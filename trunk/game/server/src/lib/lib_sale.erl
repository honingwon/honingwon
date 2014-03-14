%%%-------------------------------------------------------------------
%%% Module  : lib_sale
%%% Author  : Administrator
%%% Created : 2011-4-6
%%% Description : 寄售系统
%%%-------------------------------------------------------------------
-module(lib_sale).



%%--------------------------------------------------------------------
%% Include files 
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).
-define(BASE_SALE_TIME_OUT, 3600).
-define(KEEP_TIME, 259200).	%暂存期 72小时, 72*60*60

-define(DIC_USERS_SALES_ITEMS, dic_users_sales_items). %% 寄售记录的物品
-define(DIC_USERS_SALES, dic_users_sales). %%寄售记录
-define(GEN_PAGE_SIZE, 5).  %% 一般查询 单页记录数

%%--------------------------------------------------------------------
%% External exports 
%%--------------------------------------------------------------------
-compile(export_all).
-export([
		 sale_again/2, %% 再售
		 buy_sale_item/2,			%% 购买寄售
		 delete_sale_item/3,		%% 取回、撤消寄售
		 sale_money/5,				%% 添加寄售货币
		 add_sale_item/5,			%% 添加寄售物品
		 load_all_sale/0,			%% 从数据库加载所有寄售记录到 ets_users_sales, 加载寄售物品到ets_users_items

		 list_sale_items_self/2,		
		 list_sale_items_self1/2,	%% 我的上架物品
		 list_sale_items/10,		%% 查找物品
		 filter_sale_items/8, 		%% 寄售表过滤
		 handle_sale_item_timeout/0 %% 处理暂存过期物品 
		 ]).

%%====================================================================
%% External functions 
%%====================================================================

%% ----------------------------------------------------
%% 从数据库加载所有寄售记录
%% ----------------------------------------------------
load_all_sale() ->	
	%% old version加载寄售记录到ets_users_sales表
	case db_agent_item:load_all_sale() of
		[] -> skip;
		SalesList when is_list(SalesList) -> 
			lists:foreach(fun load_sales_into_ets/1, SalesList);
%% 			SalesList1 = lists:foldl(fun load_sales_into_dic/2, [], SalesList),
%% 			put(?DIC_USERS_SALES, SalesList1);
		_ -> skip
	end,
%%	%% old version加载寄售的物品到ets_users_items表
	%% 加载寄售的物品到dic_users_sales_items字典
	case db_agent_item:load_all_sale_items() of
		[] -> skip;
		ItemsInfoList when is_list(ItemsInfoList) ->
			SalesItemsList = lists:foldl(fun load_sales_items_into_dic/2, [], ItemsInfoList),
			put(?DIC_USERS_SALES_ITEMS, SalesItemsList);
		_ -> skip
	end,	
	ok.

%% load_sales_into_dic(SaleValue, NewList) ->
%% 	SaleRecord = list_to_tuple([ets_users_sales] ++ (SaleValue)),
%% 	[SaleRecord|NewList].
load_sales_items_into_dic(ItemValue, NewList) ->
	Record = list_to_tuple([ets_users_items] ++ (ItemValue)),
	Other = #item_other{sell_price = 0},
	NewRecord = Record#ets_users_items{other_data = Other},
	[NewRecord|NewList].
load_sales_into_ets(SaleValue) ->
	SaleRecord = list_to_tuple([ets_users_sales] ++ (SaleValue)),
	ets_update_sale_item(SaleRecord).
%% load_sales_items_into_ets(ItemValue) ->
%% 	ItemRecord = list_to_tuple([ets_users_items] ++ (ItemValue)),
%% 	ets:insert(?ETS_USERS_ITEMS, ItemRecord).

%% 根据寄售价格类型，寄售时间得到保管费系数
get_deduct_by_money(Type) ->
	ItemsDeducts = [
				   {{2, 8}, 0.05},%%铜币价 100铜币扣5铜币
				   {{2, 24}, 0.10},
				   {{2, 48}, 0.15},
				   {{3, 8}, 15}, %% 元宝价  1元宝扣15铜币
				   {{3, 24}, 30},
				   {{3, 48}, 45}
				   ],
	case lists:keysearch(Type, 1, ItemsDeducts) of
		{value, {_Type, Radix}} ->
			[Radix];
		false ->
			error
	end.

%% -----------------------------------------------------
%% 22011 再售
%% -----------------------------------------------------
sale_again(PlayerStatus, SaleId) ->
	case is_on_sale(SaleId) of
		[] ->
			{fail, ?_LANGUAGE_SALE_MSG_SALE_NOT_EXIST};
		[Sale] ->			
			if
				is_record(Sale, ets_users_sales) =:= false ->
					{fail, ?_LANGUAGE_SALE_MSG_SALE_NOT_EXIST};
				Sale#ets_users_sales.user_id =/= PlayerStatus#ets_users.id ->
					{fail, ?_LANGUAGE_SALE_MSG_NOT_MATCH_SALER};
				true ->
					sale_again2(PlayerStatus, Sale)
			end
	end.
sale_again2(PlayerStatus, Sale) ->	
	PriceType = Sale#ets_users_sales.price_type,
	ValidTime = Sale#ets_users_sales.valid_time,
	case get_deduct_by_money({PriceType, ValidTime}) of
		[DeductRadix] ->
			ReduceCopper1 = DeductRadix * Sale#ets_users_sales.unit_price,
			ReduceCopper = tool:ceil(ReduceCopper1),
			if
				PlayerStatus#ets_users.copper < ReduceCopper ->
					{fail, ?_LANGUAGE_SALE_MSG_NOT_ENOUGH_COPPER};
				true ->					
					NewSale = Sale#ets_users_sales{ start_time = misc_timer:now_seconds()},
					db_agent_item:update_sale_item([{start_time,NewSale#ets_users_sales.start_time}],[{id,Sale#ets_users_sales.id}]),
%%					ReduceCopper = DeductRadix * Sale#ets_users_sales.unit_price,
					
					ets_update_sale_item(NewSale),		
					NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, ReduceCopper, 0),
					list_sale_items_self(PlayerStatus, 1),
					{ok, NewPlayerStatus}
			end;
		error ->
			{fail, ?_LANGUAGE_SALE_MSG_ERROR_PARAM}
	end.
	
is_on_sale(SaleId) ->
	ets:lookup(?ETS_USERS_SALES, SaleId).

%% ----------------------------------------------------
%% 22007寄售元宝、铜币
%% ----------------------------------------------------
sale_money(PlayerStatus, PriceType, Money, Price, ValidTime) ->
	case get_deduct_by_money({PriceType, ValidTime}) of
		[DeductRadix] ->
			sale_money1(PlayerStatus, PriceType, Money, Price, ValidTime, DeductRadix);
		error ->
			{fail, ?_LANGUAGE_SALE_MSG_ERROR_PARAM}
	end.
sale_money1(PlayerStatus, PriceType, Money, Price, ValidTime, DeductRadix) ->
	if Money < 0 orelse Price < 0 ->
		{0, PlayerStatus};
	true ->%% 寄售数量及价格不为0
		Copper = PlayerStatus#ets_users.copper,
		case PriceType of
			?SALES_PRICE_TYPE_YB -> %% ==>2寄售价格类型:元宝
				%% 寄售的货币是铜币
				ReduceCopper = tool:ceil(Price * DeductRadix),
				case Copper >=0 andalso ReduceCopper > 0 andalso Copper >= (Money + ReduceCopper) of
					true ->
						sale_money_copper(PlayerStatus, Money, Price, PriceType, ValidTime, ReduceCopper);
					false ->
						{fail, ?_LANGUAGE_SALE_MSG_NOT_ENOUGH_COPPER}
				end;
			?SALES_PRICE_TYPE_COPPER -> %% ==>1 寄售价格类型:铜币
				%% 寄售的货币是元宝
				ReduceCopper = tool:ceil(Price * DeductRadix),
				sale_money_yuanbao(PlayerStatus, Money, Price, PriceType, ValidTime, ReduceCopper);
			_Other ->
				{fail, "PlayerStatus"}
		end
	end.
sale_money_yuanbao(PlayerStatus, Money, Price, PriceType, ValidTime, DeductPrice) ->
	YuanBao = PlayerStatus#ets_users.yuan_bao,
%% 	case YuanBao >=0 andalso DeductPrice > 0 andalso YuanBao >= (Money + DeductPrice) of
	case YuanBao >=0 andalso DeductPrice > 0 andalso YuanBao >= Money andalso PlayerStatus#ets_users.copper >= DeductPrice of
		true -> %% 向ets_users_sales表插入记录
			SaleItemValueList = 
				#ets_users_sales{id = 0,
								type = ?SALES_TYPE_YUAN_BAO_SALE,
								user_id = PlayerStatus#ets_users.id,
								item_id = 0,
								name = ?_LANGUAGE_SALE_YUAN_BAO,
								quality = ?SALES_QUALITY_ALL,
								career = ?SALES_CAREER_ALL,
								level = ?SALES_LEVEL_ALL,
								category = 0,
								unit_price = Price,
								price_type = PriceType,
								amount = Money,
								start_time = misc_timer:now_seconds(),
								valid_time = ValidTime,
								is_exist = 1
								},
			SaleGoodsEts = sale_item(SaleItemValueList),
			if SaleGoodsEts =:= [] ->
				{fail, "PlayerStatus"};
			true ->
				%% 更新ets_users_sales表
				ets_update_sale_item(SaleGoodsEts),
				%% 扣保管费，扣寄售的元宝
				CopperNeedCut = DeductPrice,
				YuanBaoNeedCut = Money,
				
				NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, YuanBaoNeedCut, 0, CopperNeedCut, 0,
																	{?CONSUME_YUANBAO_SALE_SELL,SaleGoodsEts#ets_users_sales.id,1}),
%% 				lib_statistics:add_consume_yuanbao_log(NewPlayerStatus#ets_users.id, YuanBaoNeedCut, 0, 
%% 										   1, ?CONSUME_YUANBAO_SALE_SELL, misc_timer:now_seconds(), 0, 0,
%% 										   NewPlayerStatus#ets_users.level),
				{ok,NewPlayerStatus}
			end;
		false ->
			{fail, "PlayerStatus"}
	end.
sale_money_copper(PlayerStatus, Money, Price, PriceType, ValidTime, DeductPrice) ->
	%% 向ets_users_sales表插入记录
	SaleItemValueList = #ets_users_sales{id = 0,
										type = ?SALES_TYPE_COPPER_SALE,
										user_id = PlayerStatus#ets_users.id,
										item_id = 0,
										name = ?_LANGUAGE_SALE_COPPER,
										quality = ?SALES_QUALITY_ALL,
										career = ?SALES_CAREER_ALL,
										level = ?SALES_LEVEL_ALL,
										category = 0,
										unit_price = Price,
										price_type = PriceType,
										amount = Money,
										start_time = misc_timer:now_seconds(),
										valid_time = ValidTime,
										is_exist = 1
										},
	SaleGoodsEts = sale_item(SaleItemValueList),
	if SaleGoodsEts =:= [] ->
		{fail, "PlayerStatus"};
	true ->
		%% 更新ets_users_sales表
		ets_update_sale_item(SaleGoodsEts),
		%% 扣保管费，扣寄售的铜币
		CopperNeedCut = Money + DeductPrice,
		NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, CopperNeedCut, 0),
		{ok, NewPlayerStatus}
	end.
%% ----------------------------------------------------
%% 购买寄售物品
%% ----------------------------------------------------
buy_sale_item(PlayerStatus, SaleId) ->
	%% 查找ets表的寄售记录 
	SaleItemResult = get_sale_item_record(SaleId),	
	case SaleItemResult =:= [] of
		true -> %% 没有寄售记录
%% 			{fail, ?_LANGUAGE_SALE_MSG_SALE_NOT_EXIST};%% 5
			{fail, 5};
		false ->
%% 			NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),			
%% 			if
%% 				NullCells =:= [] ->%% 背包满					
%% 					{fail, ?_LANGUAGE_SALE_MSG_BAG_FULL};
%% 				true ->
					[SaleItem] = SaleItemResult,
					buy_sale_item1(SaleItem, PlayerStatus)
%% 			end
	end.
buy_sale_item1(SaleItem, PlayerStatus) ->
	if
		SaleItem#ets_users_sales.user_id =:= PlayerStatus#ets_users.id ->
			{fail, 7};
		true ->
			buy_sale_item2(SaleItem, PlayerStatus) 
	end.
buy_sale_item2(SaleItem, PlayerStatus) ->
	case SaleItem#ets_users_sales.type of
		?SALES_TYPE_ITEM_SALE ->     %% 物品寄售
			buy_sale_item3(SaleItem, PlayerStatus);
		?SALES_TYPE_YUAN_BAO_SALE -> %% 元宝寄售
			buy_sale_yb(SaleItem, PlayerStatus);
		?SALES_TYPE_COPPER_SALE ->   %% 铜币寄售
			buy_sale_copper(SaleItem, PlayerStatus);
		_ ->                         %% 未知寄售类型
			{fail, 0}
	end.
buy_sale_yb(SaleItem, PlayerStatus) ->
	Unit_price = SaleItem#ets_users_sales.unit_price,
	Amount = SaleItem#ets_users_sales.amount,
	NeedPrice = Unit_price, %%* Amount,		
	Copper = PlayerStatus#ets_users.copper,
	if
		SaleItem#ets_users_sales.price_type =/= ?SALES_PRICE_TYPE_COPPER ->
			{fail, 0};
		NeedPrice > 0 andalso Copper > 0 andalso Copper >= NeedPrice ->
			handle_buy_sale_for_money(
			  						SaleItem, 
									yb_onsale_success, 
									yb_buy_success, 
									PlayerStatus, 
									Amount, 
									NeedPrice);
		true -> %% 铜币不足
			{fail, 4}
	end.
buy_sale_copper(SaleItem, PlayerStatus) ->
	Unit_price = SaleItem#ets_users_sales.unit_price,
	Amount = SaleItem#ets_users_sales.amount,
	NeedPrice = Unit_price,%% * Amount,
	YuanBao = PlayerStatus#ets_users.yuan_bao,
	if
		SaleItem#ets_users_sales.price_type =/= ?SALES_PRICE_TYPE_YB ->
			{fail, 0};
		NeedPrice > 0 andalso YuanBao > 0 andalso YuanBao >= NeedPrice ->
			handle_buy_sale_for_money(SaleItem, copper_onsale_success, copper_buy_success, PlayerStatus, Amount, NeedPrice);
		true -> %% 元宝不足
			{fail, 3}
	end.
handle_buy_sale_for_money(SaleItem, ToSaler, _ToBuyer, PlayerStatus, Amount, NeedPrice) ->
	SaleId = SaleItem#ets_users_sales.id,
	SalerId = SaleItem#ets_users_sales.user_id,
	SalerNick = lib_player:get_nick_by_id(SalerId),	
	Param = [Amount, NeedPrice],
	%% 给买家发邮件
%% 	send_mail_for_sale(PlayerStatus#ets_users.id, PlayerStatus#ets_users.nick_name, SaleType, Param),

	%% 给卖家发邮件
	send_mail_for_sale(SalerId, SalerNick, ToSaler, Param, ?Mail_Type_AuctionSuccess),

	%% 删除ets表寄售记录
	ets_delete_sale_item(SaleId),

	%% 更新数据库寄售记录
	db_agent_item:delete_sale_item([{id, SaleId}]),
	
	NewPlayerStatus = 
		case ToSaler of
			yb_onsale_success ->
				PlayerStatus1 = lib_player:reduce_cash(PlayerStatus, 0, 0,NeedPrice, 0,{?CONSUME_YUANBAO_SALE_BUY,SaleId,1}),
				
				%%元宝操作日志
%% 				lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, Amount, 0, 
%% 												   0, ?CONSUME_YUANBAO_SALE_BUY_IN, misc_timer:now_seconds(), 0, 0,
%% 												   PlayerStatus#ets_users.level),
				lib_player:add_cash_and_send(PlayerStatus1, Amount, 0, 0, 0,{?GAIN_MONEY_SALE_SELL,SaleId,1});
			copper_onsale_success ->
				PlayerStatus1 = lib_player:reduce_cash(PlayerStatus, NeedPrice, 0, 0, 0,{?CONSUME_YUANBAO_SALE_BUY,SaleId,1}),
				lib_player:add_cash_and_send(PlayerStatus1, 0, 0, Amount, 0,{?GAIN_MONEY_SALE_SELL,SaleId,1})
		end,

	{ok, NewPlayerStatus}.
	
buy_sale_item3(SaleItem, PlayerStatus) ->
	ItemId = SaleItem#ets_users_sales.item_id,
	Item = dic_get_sale_item(ItemId),
	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),			
	if
		is_record(Item, ets_users_items) =:= false ->
			{fail, 6};
%% 		NullCells =:= [] -> %% 背包满					
%% 			{fail, 2};
		true ->
			buy_sale_item4(SaleItem, PlayerStatus, Item,length(NullCells))
	end.
buy_sale_item4(SaleItem, PlayerStatus, Item,NullCellNum) ->
	#ets_users{
			   copper = Copper,
			   yuan_bao = YuanBao} = PlayerStatus,
	Unit_price = SaleItem#ets_users_sales.unit_price,
	SaleId = SaleItem#ets_users_sales.id,
	NeedPrice = Unit_price,   %% * Amount,
	case SaleItem#ets_users_sales.price_type of
		?SALES_PRICE_TYPE_COPPER ->
			case NeedPrice > 0 andalso Copper > 0 andalso Copper >= NeedPrice of
				true ->
					NewPlayerStatus = 
						handle_buy_sale_for_item(
						 					SaleItem#ets_users_sales.user_id,
											SaleId, 
											Item, 
											PlayerStatus, 
											0,
											NeedPrice,
											SaleItem#ets_users_sales.name,
											SaleItem#ets_users_sales.amount,
											NullCellNum),
					{ok, NewPlayerStatus};
				false ->
					{fail, 4}%% 铜币不足
			end;
		?SALES_PRICE_TYPE_YB ->
			case NeedPrice > 0 andalso YuanBao > 0 andalso YuanBao >= NeedPrice of
				true ->
					NewPlayerStatus = 
						handle_buy_sale_for_item(
						  					SaleItem#ets_users_sales.user_id,
											SaleId,
											Item,
											PlayerStatus,															
											NeedPrice,
											0,
											SaleItem#ets_users_sales.name,
											SaleItem#ets_users_sales.amount,
											NullCellNum),

					{ok, NewPlayerStatus};
				false ->
					{fail, 3} %% 元宝不足
			end
	end.

handle_buy_sale_for_item(SalerId, SaleId, Item, PlayerStatus, ReduceYuanBao, ReduceFreeCopper, ItemName, Amount,NullCellNum) ->

	NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYuanBao, 0, ReduceFreeCopper, 0,{?CONSUME_YUANBAO_SALE_BUY,SaleId,1}),
%% 	lib_statistics:add_consume_yuanbao_log(NewPlayerStatus#ets_users.id, ReduceYuanBao, 0, 
%% 										   1, ?CONSUME_YUANBAO_SALE_BUY, misc_timer:now_seconds(), 0, 0,
%% 										   NewPlayerStatus#ets_users.level),
	%% 给买家发邮件
	if
		NullCellNum =:= 0 andalso ReduceYuanBao > 0 ->
			send_mail_for_sale(NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.nick_name, item_yb_buy_success, [[Item], ItemName, Amount,ReduceYuanBao],?Mail_Type_BuyItem);
		NullCellNum =:= 0 andalso ReduceFreeCopper > 0 ->
			send_mail_for_sale(NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.nick_name, item_copper_buy_success, [[Item], ItemName, Amount, ReduceFreeCopper],?Mail_Type_BuyItem);
		true ->
			%% 直接进入买家背包
				gen_server:call(
				  PlayerStatus#ets_users.other_data#user_other.pid_item, 
				  {'change_item_owner', 
				   Item#ets_users_items{user_id = PlayerStatus#ets_users.id}})
	end,


	%% 给卖家发邮件
	SalerNick = lib_player:get_nick_by_id(SalerId),
	send_mail_for_sale(SalerId, SalerNick, item_onsale_success, [ItemName, Amount, ReduceFreeCopper, ReduceYuanBao], ?Mail_Type_AuctionSuccess),
														
	%% 更新数据库寄售记录
	db_agent_item:delete_sale_item([{id, SaleId}]),

	%% 删除ets表寄售记录
	ets_delete_sale_item(SaleId),
	dic_update_user_sale_item(Item, del),
	NewPlayerStatus.

%% ----------------------------------------------------
%% 查找寄售物品
%% ----------------------------------------------------
list_sale_items(UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page, Pid) ->
	%% 寄售表过滤
	PartitionItems = filter_sale_items(UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList),
				
	LenCheck = length(PartitionItems),
	case LenCheck > 1 of
		true ->
			SortSaleTimeItems = lists:sort(fun sort_sale_items_by_time/2, PartitionItems);
		false ->
			SortSaleTimeItems = PartitionItems
	end,
	Start = ?GEN_PAGE_SIZE * (Page - 1),	
	[NewSum, NewPage, NewSaleList] =
		if
			LenCheck =:= 0 ->
				[0, 0, []];
			LenCheck < Start ->
				[0, 0, []];
			true ->
				Len = 
					if
						LenCheck - Start > ?GEN_PAGE_SIZE ->
							?GEN_PAGE_SIZE;
						true ->
							LenCheck - Start
					end,
				
				SaleList = lists:sublist(SortSaleTimeItems, Start + 1, Len),
				SaleList1 = lists:map(fun handle_list_sale_items_self/1, SaleList),
				[LenCheck, Page, SaleList1]
		end,
		
	{ok, BinData} = pt_22:write(?PP_SALES_ITEM_QUERY, [NewSum, NewPage, NewSaleList]),
	lib_send:send_to_sid(Pid, BinData).


	
%% 寄售表过滤
filter_sale_items(UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList) ->
	case Type of
		1 ->
			filter_sale_items1(UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList);
		_ ->
			ets_list_sale_items([UserId, Type])
	end.

filter_sale_items1(UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList) ->
	%% 过滤等级 
	if
		(LowLevel =:= ?SALES_LEVEL_ALL) andalso (UpLevel =:= ?SALES_LEVEL_ALL) ->
			ItemsRecords = ets_list_sale_items([UserId, Type]);
		(LowLevel =< UpLevel) andalso (LowLevel >= ?SALES_QUERY_MIN_LEVEL) andalso (UpLevel =< ?SALES_QUERY_MAX_LEVEL) ->
			ItemsRecords = ets_list_sale_items([UserId, LowLevel, UpLevel]);
		true ->
			ItemsRecords = []
	end,
	%% 品质过滤 和职业过滤
	{QualityRecords, _} =
	if 
		Quality =/= ?SALES_QUALITY_ALL andalso Career =/= ?SALES_CAREER_ALL ->
			lists:partition(fun(Item) -> Item#ets_users_sales.quality =:= Quality
							andalso Item#ets_users_sales.career =:= Career end, ItemsRecords);
		Quality =:= ?SALES_QUALITY_ALL andalso Career =/= ?SALES_CAREER_ALL ->
			lists:partition(fun(Item) -> Item#ets_users_sales.career =:= Career end, ItemsRecords);
		Quality =/= ?SALES_QUALITY_ALL andalso Career =:= ?SALES_CAREER_ALL ->
			lists:partition(fun(Item) -> Item#ets_users_sales.quality =:= Quality end, ItemsRecords);
		true ->
			{ItemsRecords, []}
	end,

	%% 种类过滤
	{CategoryRecords, _} = 
	if 
		CategoryList =/= [] ->
			lists:partition(fun(Item) -> lists:member(Item#ets_users_sales.category, CategoryList) =:= true end , QualityRecords);
		true ->
			{QualityRecords, []}
	end,

	%% 关键字过滤	
	{KeyRecords, _} = 
	case length(KeyName) of
		0 ->
			 {CategoryRecords, []};
		_ ->			
			lists:partition(fun(Item) -> string:str(tool:to_list(Item#ets_users_sales.name), KeyName) =/= 0 end, CategoryRecords)
		end,
	KeyRecords.

%% ----------------------------------------------------
%% 处理暂存过期的寄售记录
%% (因为寄售时间到，还暂存在我的上架物品列表，暂存期过了才邮件发回或邮箱满而删除)
%% ----------------------------------------------------
handle_sale_item_timeout() ->
	Records = load_sale_items(),
	NowTime = misc_timer:now_seconds(),
	{TimeOutRecords, _} = lists:partition(
						   fun (Record) ->
									DiffTime = NowTime - Record#ets_users_sales.start_time,
									SaleTime = Record#ets_users_sales.valid_time * ?BASE_SALE_TIME_OUT,
									DiffTime > SaleTime + ?KEEP_TIME
						   end, Records),
	lists:map(
	  fun (Elem) ->
			   handle_sale_item_record_timeout(NowTime, Elem)
	  end, TimeOutRecords),
	ok.
%% 处理每条过期记录,邮件发回
handle_sale_item_record_timeout(_EndSaleTime, TimeOutRecord) ->
	#ets_users_sales{id = SaleId,
					 type =  Type,
					 user_id = UserId,
					 name = ItemName,
					 amount = Amount
					} = TimeOutRecord,
	case Type of
		%%----------寄售的是物品
		?SALES_TYPE_ITEM_SALE -> 
			ItemId = TimeOutRecord#ets_users_sales.item_id,
			Item = dic_get_sale_item(ItemId),
			if
				is_record(Item, ets_users_items) =:= false ->
					db_agent_item:delete_sale_item([{id, SaleId}]),
					ets_delete_sale_item(SaleId);
				true ->				
					Nick = lib_player:get_nick_by_id(UserId),
					Param = [Item, ItemName, Amount],
					%% 发送邮件
					send_mail_for_sale(UserId, Nick, item_onsale_timeout, Param, ?Mail_Type_AuctionFail),
					%% 数据库删除记录
					db_agent_item:delete_sale_item([{id, SaleId}]),
					%% ets_users_sales表删除记录
%% 					ets_delete_sale_item(SaleId)
					dic_delete_sale_item(ItemId)
			end;
		%%-----------------寄售的是元宝
		?SALES_TYPE_YUAN_BAO_SALE -> 
			Nick = lib_player:get_nick_by_id(UserId),
			Param = Amount,
			%% 发送邮件
			send_mail_for_sale(UserId, Nick, yb_onsale_timeout, Param, ?Mail_Type_AuctionFail),
			%% 数据库删除记录
			db_agent_item:delete_sale_item([{id, SaleId}]),
			%% ets_users_sales表删除记录
			ets_delete_sale_item(SaleId),
			ok;
		%% -----------------寄售的是铜币
		?SALES_TYPE_COPPER_SALE -> 
			Nick = lib_player:get_nick_by_id(UserId),
			Param = Amount,
			%% 发送邮件
			send_mail_for_sale(UserId, Nick, copper_onsale_timeout, Param, ?Mail_Type_AuctionFail),
			%% 数据库删除记录
			db_agent_item:delete_sale_item([{id, SaleId}]),
			%% ets_users_sales表删除记录
			ets_delete_sale_item(SaleId),
			ok;
		Other ->
			?WARNING_MSG("~p:~p:~p:~p~n",[?MODULE, ?LINE, "undefine sale_type", Other])
	end.
%% ----------------------------------------------------
%% 22001 添加寄售物品
%% ----------------------------------------------------
add_sale_item(PlayerStatus, Place, PriceType, Price, ValidTime) ->
	#ets_users{copper = Copper,
			   id = UserId
			   } = PlayerStatus,
	Pid_item = PlayerStatus#ets_users.other_data#user_other.pid_item,		
	case gen_server:call(Pid_item, {'get_item_info_by_place', Place}) of
		[] ->
			{fail, ?_LANGUAGE_SALE_MSG_ITEM_NOT_EXIST};
		[Item] ->
			[DeductRadix] = get_deduct_by_money({PriceType, ValidTime}),
			DeductPrice = tool:ceil(Price * DeductRadix),				
			if 
				Price =< 0 orelse Copper < DeductPrice -> 
					%% 寄售价格少于等于0或者身上铜币不足以扣除保管费		
				   {fail, ?_LANGUAGE_SALE_MSG_NOT_ENOUGH_COPPER};
				true ->
					#ets_users_items{id = ItemId, 
									template_id = TemplateId,
									amount = Amount} =  Item,
					
				   ItemTemplate = data_agent:item_template_get(TemplateId),
				   #ets_item_template{
									  need_career = Career,
									  name = Name,
									  category_id = Category,
									  quality = Quality,
									  need_level = Level} = ItemTemplate,
				   %% 查找是否已经存在该物品的寄售记录
				   case ets_get_item_info(ItemId) of
					   [] -> %% 不存在
						     %% 通知物品进程删除该物品
						   case gen_server:call(Pid_item, {'delete_sale_item', ItemId, ?BAG_TYPE_SALE}) of
								{ok} ->
									SaleItem = #ets_users_sales{id = 0, 
																type = ?SALES_TYPE_ITEM_SALE,
																user_id = UserId,
																item_id = ItemId,
																name = Name,
																quality = Quality,
																career = Career,
																level = Level,
																category = Category,
																unit_price = Price,
																price_type = PriceType,
                                                                amount = Amount,
                                                                start_time = misc_timer:now_seconds(),
                                                                valid_time = ValidTime,
																is_exist = 1},
						   			SaleItemInsertEts = 
										case db_agent_item:add_sale_item(SaleItem) of
										{mongo, Ret} ->
											SaleItem#ets_users_items{id = Ret};
										1 ->
											get_sale_item_for_id(UserId, ItemId)
										end,										
									if
										SaleItemInsertEts =:= [] ->
											{fail, ?_LANGUAGE_SALE_MSG_DB_ADD_FAIL};
										true ->
											ets_update_sale_item(SaleItemInsertEts),
											dic_update_user_sale_item(Item, add),
											NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, DeductPrice,0),
											{ok, NewPlayerStatus}
									end;							   
								{fail, Msg} ->
									{fail, Msg}						   
							end;
						_ ->%% 有记录了， 出错
							{fail, ?_LANGUAGE_SALE_MSG_ITEM_ON_SALE}
					end
			  end	
	end.
%% ----------------------------------------------------
%% 取回/撤消寄售物品
%% ----------------------------------------------------
delete_sale_item(PlayerStatus, SaleId, Page) ->
	UserId = PlayerStatus#ets_users.id,
	SaleItemResult = get_sale_item_record(SaleId),
	case SaleItemResult of
		[] ->
			{fail, ?_LANGUAGE_SALE_MSG_SALE_NOT_EXIST};
		_ ->
			[SaleItem] = SaleItemResult,
			if
				SaleItem#ets_users_sales.user_id =/= UserId ->
					{fail, ?_LANGUAGE_SALE_MSG_NOT_MATCH_SALER};
				true ->
					delete_sale_item2(PlayerStatus, SaleId, Page, SaleItem)					
			end
	end.
delete_sale_item2(PlayerStatus, SaleId, Page, SaleItem) ->
	case SaleItem#ets_users_sales.type of
		?SALES_TYPE_ITEM_SALE ->
			ItemId = SaleItem#ets_users_sales.item_id,	
			Item = dic_get_sale_item(ItemId),
			if
				is_record(Item, ets_users_items) =:= false ->
					{fail, ?_LANGUAGE_SALE_MSG_ERROR_ITEM_DATA};
				true ->
					NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),	
					case NullCells =/= [] of
						true ->
							%% 撤消的物品直接进入背包
							{ok, Res} = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'mail_item_add', Item});
						_ ->
							send_mail_for_sale(PlayerStatus#ets_users.id, 
											   PlayerStatus#ets_users.nick_name, 
											   item_onsale_delete, 
											   [[Item], 
												SaleItem#ets_users_sales.name
											   ],
											   ?Mail_Type_Onsale_delete),
							Res = 1
					end,
					
					if 
						Res =:= 1 ->
							%% 更新寄售记录
						    db_agent_item:delete_sale_item([{id, SaleId}]),									
						    %% 在ets_users_sales删除记录
						    ets_delete_sale_item(SaleId),
						    dic_update_user_sale_item(Item, del),
						    list_sale_items_self(PlayerStatus, Page),
						    {ok, PlayerStatus, item};
						true ->
							{fail, ?_LANGUAGE_SALE_MSG_FAIL_CANCEL_SALE_BEACAUSE_BAG_FULL}
					end	
			
			end;
		?SALES_TYPE_COPPER_SALE ->			
			delete_sale_item3(PlayerStatus, copper, SaleItem, Page);
		?SALES_TYPE_YUAN_BAO_SALE ->
			
			delete_sale_item3(PlayerStatus, yuanbao, SaleItem, Page)
	end.
delete_sale_item3(PlayerStatus, MoneyType, SaleItem, Page) ->
	db_agent_item:delete_sale_item([{id, SaleItem#ets_users_sales.id}]),
	ets_delete_sale_item(SaleItem#ets_users_sales.id),
	NewPlayerStatus = 
		case MoneyType of
			copper ->
				lib_player:add_cash_and_send(PlayerStatus, 0, 0, SaleItem#ets_users_sales.amount, 0,{?GAIN_MONEY_SALE_CANCEL, SaleItem#ets_users_sales.id,1});
			yuanbao ->
				
%% 				lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, SaleItem#ets_users_sales.amount, 0, 
%% 													   0, ?CONSUME_YUANBAO_DELETE_SALE, misc_timer:now_seconds(), 0, 0,
%% 													   PlayerStatus#ets_users.level),
				lib_player:add_cash_and_send(PlayerStatus, SaleItem#ets_users_sales.amount, 0, 0, 0,{?GAIN_MONEY_SALE_CANCEL, SaleItem#ets_users_sales.id,1})
		end,
	list_sale_items_self(PlayerStatus, Page),
	{ok, NewPlayerStatus, money}.

%% 发送寄售系统邮件
send_mail_for_sale(UserId, Nick, Type, Param, MailType) ->
	Title = ?_LANGUAGE_SALE_TITLE, %% 寄售系统邮件
	NewParam = 
		case Type of 
			%% -------------------超时-------------------------
			item_onsale_timeout ->   %% 物品寄售超时
				[Item, ItemName, Amount] = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_ITEM_ONSALE_TIMEOUT, [ItemName, Amount]),
				[[Item], Content, 0, 0, 0];
			yb_onsale_timeout ->     %% 元宝寄售超时
				Amount = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_YB_ONSALE_TIMEOUT, [Amount]),
				[[], Content, 0, 0, Amount];
			copper_onsale_timeout -> %% 铜币寄售超时
				Amount = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_COPPER_ONSALE_TIMEOUT, [Amount]),
				[[], Content, Amount, 0, 0];
			%%-------------------撤消--------------------------
			item_onsale_delete ->    %% 物品寄售撤消成功
				[Item, ItemName] = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_ITEM_ONSALE_DELETE, [ItemName]),
				[Item, Content, 0, 0, 0];
			yb_onsale_delete ->      %% 元宝寄售撤消成功
				Amount = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_YB_ONSALE_DELETE, [Amount]),
				[[], Content, 0, 0, Amount];
			copper_onsale_delete ->  %% 铜币撤消成功
				Amount = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_COPPER_ONSALE_DELETE, [Amount]),
				[[], Content, Amount, 0, 0];
			%%-------------------购买成功-----------------------
			item_yb_buy_success ->      %% 物品铜币购买成功(给买家发)
				[Items, ItemName, Amount, NeedPrice] = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_ITEM_BUY_SUCCESS1, [ItemName, Amount, NeedPrice]),
				[Items, Content, 0, 0, 0];
			item_copper_buy_success ->      %% 物品铜币购买成功(给买家发)
				[Items, ItemName, Amount, NeedPrice] = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_ITEM_BUY_SUCCESS, [ItemName, Amount, NeedPrice]),
				[Items, Content, 0, 0, 0];
			yb_buy_success -> %% 元宝购买成功(给买家发)
				[Amount, NeedPrice] = Param, 
				Content = ?GET_TRAN(?_LANGUAGE_SALE_YB_BUY_SUCCESS, [Amount, NeedPrice]),
				[[], Content, 0, 0, Amount];
			copper_buy_success ->    %%铜币购买成功（给买家发）
				[Amount, NeedPrice] = Param, 
				Content = ?GET_TRAN(?_LANGUAGE_SALE_COPPER_BUY_SUCCESS, [Amount, NeedPrice]),
				[[], Content, Amount, 0, 0];
			%% ----------------------寄售成功-------------------------
			item_onsale_success ->   %% 物品寄售成功（给卖家发)
				[ItemName, Amount , ReduceCopper, ReduceYuanBao] = Param,
				if 
					ReduceYuanBao > 0 ->						
					   Content = ?GET_TRAN(?_LANGUAGE_SALE_ITEM_ONSALE_SUCCESS_YUANBAO, [ItemName, Amount, ReduceYuanBao]);
					true ->	
					   Content = ?GET_TRAN(?_LANGUAGE_SALE_ITEM_ONSALE_SUCCESS_COPPER, [ItemName, Amount, ReduceCopper])
				end,
				[[], Content, ReduceCopper, 0, ReduceYuanBao]; 
			yb_onsale_success ->     %% 元宝寄售成功（给卖家发）
				[Amount, NeedPrice] = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_YB_ONSALE_SUCCESS, [Amount, NeedPrice]),
				[[], Content, NeedPrice, 0, 0];
			copper_onsale_success -> %% 铜币寄售成功（给卖家发）
				[Amount, NeedPrice] = Param,
				Content = ?GET_TRAN(?_LANGUAGE_SALE_COPPER_ONSALE_SUCCESS, [Amount, NeedPrice]),
				[[], Content, 0, 0, NeedPrice]
		end,
	[NewItems, NewContent, NewCopper, NewBindCopper, NewYuanBao] = NewParam,
	lib_mail:send_sys_mail(Nick, UserId, Nick, UserId, NewItems, MailType, Title, NewContent, NewCopper, NewBindCopper, NewYuanBao, 0).

%% ----------------------------------------------------
%% 查看已上架寄售物品(我的寄售物品)
%% ----------------------------------------------------
list_sale_items_self(PlayerStatus, Page) ->	
	[Sum, Page1, SaleList] = list_sale_items_self1(PlayerStatus#ets_users.id, Page),
	{ok, BinData} = pt_22:write(?PP_SALES_ITEM_QUERY_SELF, [Sum, Page1, SaleList]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData).


list_sale_items_self1(UserId, Page) ->
	SaleItems = ets_get_sale_items_self(UserId),
	SortSaleItems = lists:sort(fun sort_sale_items_by_time/2, SaleItems),
	[Sum, Page1, SaleList] = list_sale_items_self2(SortSaleItems, Page),
	[Sum, Page1, SaleList].

list_sale_items_self2(SortSaleItems, Page) ->
	Sum = length(SortSaleItems),
	Start = ?SALES_PAGE_SIZE * (Page - 1),
	if
		Page < 1 orelse Sum =:= 0 ->
		   [0, 0, []];
		Start >= Sum ->
		   list_sale_items_self2(SortSaleItems, Page - 1);
		?SALES_PAGE_SIZE >= Sum ->
		   SaleList = lists:map(fun handle_list_sale_items_self/1, SortSaleItems),
	   	   [Sum, 1, SaleList];
		true ->
		   Len = case Sum - Start >= ?SALES_PAGE_SIZE of
					  true -> ?SALES_PAGE_SIZE;
					  false -> Sum - Start
				  end,
		   SaleList = lists:sublist(SortSaleItems, Start + 1, Len),
		   SaleList1 = lists:map(fun handle_list_sale_items_self/1, SaleList),
		   [Sum, Page, SaleList1]
	end.
	
ets_get_sale_items_self(UserId) ->
	Pattern = #ets_users_sales{user_id = UserId, _ = '_'},
	ets:match_object(?ETS_USERS_SALES, Pattern).
sort_sale_items_by_time(SaleItemA, SaleItemB) ->
	Result = SaleItemA#ets_users_sales.start_time =< SaleItemB#ets_users_sales.start_time,
	case Result of
		true ->
			false;
		false ->
			true
	end.
handle_list_sale_items(SaleItem) ->
	handle_list_sale_items_self(SaleItem).

handle_list_sale_items_self(SaleItem) ->
	ItemId = SaleItem#ets_users_sales.item_id,
	case db_agent_item:get_item_by_itemid(ItemId) of
		[] -> SaleItem;
		Item -> ItemInfo = list_to_tuple([ets_users_items] ++ (Item)),
				Other = #item_other{sell_price = 0},
				Record = ItemInfo#ets_users_items{other_data = Other},
				SaleItem#ets_users_sales{other_data = Record}
	end.

%%====================================================================
%% Local functions 
%%====================================================================

%% 获取所有寄售记录
get_dic() ->
	case get(?DIC_USERS_SALES) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

%% 获取所有寄售的物品列表
get_dic_item() ->
	case get(?DIC_USERS_SALES_ITEMS) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.   

%%根据物品id获取寄售物品信息
dic_get_sale_item(ItemId) ->
	List = get_dic_item(),
	case lists:keyfind(ItemId, #ets_users_items.id, List) of
		false ->
			[];
		Info ->
			Info
	end.

%% 更新寄售物品列表
update_dic_item(Info, Opt) ->
	List = get_dic_item(),
	NewList = 
		case Opt of
			add ->
				[Info|List];
			del ->
				lists:keydelete(Info#ets_users_items.id, #ets_users_items.id, List)
		end,
	put(?DIC_USERS_SALES_ITEMS, NewList).

dic_update_user_sale_item(Info, Opt) ->
	update_dic_item(Info, Opt).	

sale_item(SaleItemValueList) ->
	case db_agent_item:add_sale_item(SaleItemValueList) of
		{mongo, Ret} ->
			SaleItemValueList#ets_users_sales{id = Ret};
		1 ->
			WhereList = [{user_id, SaleItemValueList#ets_users_sales.user_id}, {type, SaleItemValueList#ets_users_sales.type}],
			SaleItem = (catch db_agent_item:get_sale_item_for_id(WhereList)),
			list_to_tuple([ets_users_sales] ++ (SaleItem));
%% 			db_agent_item:get_sale_item_for_id(SaleItemValueList#ets_users_sales.user_id, SaleItemValueList#ets_users_sales.item_id);
		_Other ->
			[]
	end.

%% 以list()形式返回所有ets_users_sales
load_sale_items() ->
%% 	get_dic().
	ets:tab2list(?ETS_USERS_SALES).

%% 从ets_users_sales表中， 查找市场存在的物品（按等级范围）
ets_list_sale_items([_UserId, LowLevel, UpLevel]) ->
	Now = misc_timer:now_seconds(),
	MS = ets:fun2ms(fun(T) when T#ets_users_sales.level >= LowLevel
						  andalso T#ets_users_sales.level =< UpLevel 
						 andalso (T#ets_users_sales.start_time + T#ets_users_sales.valid_time * 3600) > Now ->
						T
					end),
	ets:select(?ETS_USERS_SALES, MS);

%% 从ets_users_sales表中， 查找市场存在的物品（按寄售类型, 0所有/1物品/2铜币/3元宝）
ets_list_sale_items([_UserId, Type]) ->
	Now = misc_timer:now_seconds(),
	case Type =:= 0 of
		true ->
%% 			load_sale_items();
 			MS = ets:fun2ms(fun(T) when (T#ets_users_sales.start_time + T#ets_users_sales.valid_time * 3600) > Now -> T end);
		false ->				
			MS = ets:fun2ms(fun(T) when T#ets_users_sales.type =:= Type 
								 andalso (T#ets_users_sales.start_time + T#ets_users_sales.valid_time * 3600) > Now -> T end)
%% 			
	end,
	ets:select(?ETS_USERS_SALES, MS).

%% 根据用户id和物品id获取寄售记录
get_sale_item_for_id(UserId, ItemId) ->
	SaleItem = (catch db_agent_item:get_sale_item_for_id(UserId, ItemId)),
	SaleItemInfo = list_to_tuple([ets_users_sales] ++ SaleItem),
	SaleItemInfo.

%% 查找ets_users_sales寄售记录
get_sale_item_record(SaleId) ->
	ets:lookup(?ETS_USERS_SALES, SaleId).

%% 增加ets_users_sales寄售记录
ets_update_sale_item(SaleRecord) ->
	ets:insert(?ETS_USERS_SALES, SaleRecord).
%%------------------------------------------
%% 删除ets_users_sales寄售记录
ets_delete_sale_item(SaleId) ->
	ets:delete(?ETS_USERS_SALES, SaleId).
%%------------------------------------------
%% 删除寄售
dic_delete_sale(Info) ->
	List = get_dic(),
	List1 = lists:keydelete(Info#ets_users_sales.id, #ets_users_sales.id, List),
	put(?DIC_USERS_SALES_ITEMS, List1),
	
	%% 如果寄售的是物品
	if Info#ets_users_sales.type =:= 1 ->
		   dic_delete_sale_item(Info#ets_users_sales.item_id);
	   true ->
		   skip
	end.
%% 删除寄售的物品
dic_delete_sale_item(ItemId) ->
	List = get_dic_item(),
	List1 = lists:keydelete(ItemId, #ets_users_items.id, List),
	put(?DIC_USERS_SALES_ITEMS, List1).

%% 根据物品id获取寄售物品信息
ets_get_item_info(ItemId) ->
	Pattern = #ets_users_sales{item_id = ItemId, _='_'},
	ets:match_object(?ETS_USERS_SALES, Pattern).


