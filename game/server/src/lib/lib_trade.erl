%%%-------------------------------------------------------------------
%%% Module  : lib_trade
%%% Author  : 
%%% Description :  Exchange of items or money for money or other items
%%%-------------------------------------------------------------------
-module(lib_trade).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl"). 

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([
		 trade_offline/1,		%% 	离线取消交易
		 trade_change_state/3, 	%% 	改变交易状态及交易列表
		 request_trade/2, 		%% 	请求交易
		 item_remove/2, 		%% 	交易栏物品移除
		 sure_trade/2, 			%% 	确定交易
		 trade_item_add/4,		%%	交易栏物品添加
		 money_trade/5,			%%	交易栏铜币添加
		 accept_trade/3,  		%% 	接受交易请求
		 accept_trade_1/3,
		 cancel_trade_1/1,
		 check_is_trade/1,
		 check_is_sit/1,
		 check_is_die/1,
		 check_is_pk/1,
		 do_trade/1
		 
		 ]).

-define(ITEM_STATUS_ONTRADE, 5).  %% item status on trade
-define(TRADE_MAX_NUM, 12). 	%% 交易栏最大格子数
%%====================================================================
%% External functions
%%====================================================================

%% -------------------------------------------------------------------------
%% 	离线取消交易
%% -------------------------------------------------------------------------
trade_offline(PlayerStatus) ->
%%	pp_trade:handle(?PP_TRADE_CANCEL, PlayerStatus, []).
	lib_trade:cancel_trade_1(PlayerStatus).

%% -------------------------------------------------------------------------
%% 	交易栏物品移除
%% -------------------------------------------------------------------------
%% 移除物品
item_remove(PlayerStatus, Place) ->
	case item_remove_1(PlayerStatus, Place) of
		error ->
			[0, [], {}, []];
		Result ->
			Result
	end.

item_remove_1(PlayerStatus, Place) ->
	{_ATrade, BUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	BPlayerStatus = lib_player:get_online_info(BUserId),

	case BPlayerStatus of
		[] ->
			error;
		_ ->
			%%物品进程 call!
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_item_info_by_place', Place}) of
				[] ->
					error;
				[ItemInfo] ->
					ItemId = ItemInfo#ets_users_items.id,
					ATradeList = PlayerStatus#ets_users.other_data#user_other.trade_list,
					BTradeList = BPlayerStatus#ets_users.other_data#user_other.trade_list,
					{_BTrade, _AUserId} = BPlayerStatus#ets_users.other_data#user_other.trade_status,
					AResult = lists:keymember({ItemId, 1, 2}, 1, ATradeList),
					BResult = lists:keymember({ItemId, 1, 1}, 1, BTradeList),
					if
						AResult =/= BResult ->
							error;
						true ->
							ATradeListRest = lists:keydelete({ItemId, 1, 2}, 1, ATradeList),
							BTradeListRest = lists:keydelete({ItemId, 1, 1}, 1, BTradeList),
							BPlayerStatusRest = trade_change_state(BPlayerStatus,
																   BPlayerStatus#ets_users.other_data#user_other.trade_status,
																   BTradeListRest),
							[1, ATradeListRest, BPlayerStatusRest, ItemInfo]
					end
			end
	end.

%% ----------------------------------------------------------------------------------------
%%	确定交易
%% ----------------------------------------------------------------------------------------
%% 确定交易
sure_trade(PlayerStatus, BUserId) ->
	case sure_trade_1(PlayerStatus, BUserId) of
		error ->
			[6, {}, {}];
		Result ->
			Result
	end.

sure_trade_1(APlayerStatus, BUserId) ->
	case lib_player:get_online_info(BUserId) of
		[] ->
			NewPlayerStatus = trade_status_reset(APlayerStatus),
			[2, NewPlayerStatus, {}];
		
		BPlayerStatus ->
			{BTrade, _AUserId} = BPlayerStatus#ets_users.other_data#user_other.trade_status,
			if
				BTrade =:= 3 -> %% 对方已经确定
					sure_trade_3(APlayerStatus, BPlayerStatus);
				BTrade =:= 2 -> %% 对方已锁定
					NewPlayerStatus = trade_change_state(APlayerStatus,
														{3, BUserId},
														 APlayerStatus#ets_users.other_data#user_other.trade_list),
					[ 0, NewPlayerStatus, BPlayerStatus];
				true ->	%% 对方未锁定
					[ 5, APlayerStatus, {}]
			end
	end.

%% 确定交易：对方已经确定
sure_trade_3(APlayerStatus, BPlayerStatus) ->
	ATradeList = APlayerStatus#ets_users.other_data#user_other.trade_list,
	BTradeList = BPlayerStatus#ets_users.other_data#user_other.trade_list,
		
	if 
		length(ATradeList) =/= length(BTradeList) ->	  
			%% 数据错误
			APlayerStatusRest = trade_status_reset(APlayerStatus),
			BPlayerStatusRest = trade_status_reset(BPlayerStatus),
			[6, APlayerStatusRest, BPlayerStatusRest];
		
	   true ->
		   %%获取背包空格数 用了比较多call 需改进！
		   ANullCells = gen_server:call(APlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
		   BNullCells = gen_server:call(BPlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
		   		   
		   ACellNum = length(ANullCells),
		   BCellNum = length(BNullCells),
		   
		   AInsertNum = get_trade_item_amount(1, ATradeList),
		   BInsertNum = get_trade_item_amount(2, ATradeList),
		    	   
		   CanTrade = check_trade_finish(ATradeList, APlayerStatus, BPlayerStatus),
		   if
			   ACellNum < AInsertNum ->
				   %%自己背包满
				   APlayerStatusRest = trade_change_state(APlayerStatus,
														  {2, BPlayerStatus#ets_users.id},
														  APlayerStatus#ets_users.other_data#user_other.trade_list),
				   BPlayerStatusRest = trade_change_state(BPlayerStatus,
														  {2, BPlayerStatus#ets_users.id},
														  BPlayerStatus#ets_users.other_data#user_other.trade_list),
				   [3, APlayerStatusRest, BPlayerStatusRest];
			   
			   BCellNum < BInsertNum -> 
				   %% 对方背包满
				   APlayerStatusRest = trade_change_state(APlayerStatus,
														  {2, BPlayerStatus#ets_users.id},
														  APlayerStatus#ets_users.other_data#user_other.trade_list),
				    BPlayerStatusRest = trade_change_state(BPlayerStatus,
														  {2, BPlayerStatus#ets_users.id},
														  BPlayerStatus#ets_users.other_data#user_other.trade_list),
				   [4, APlayerStatusRest, BPlayerStatusRest];
			   
			   
			   CanTrade =/= true ->
				   %% 金币不足  
				    APlayerStatusRest = trade_change_state(APlayerStatus,
														  {2, BPlayerStatus#ets_users.id},
														  APlayerStatus#ets_users.other_data#user_other.trade_list),
				    BPlayerStatusRest = trade_change_state(BPlayerStatus,
														  {2, BPlayerStatus#ets_users.id},
														  BPlayerStatus#ets_users.other_data#user_other.trade_list),
				   [4, APlayerStatusRest, BPlayerStatusRest];
			   
			   true ->	
				   Res = sure_trade_finish( ATradeList, 
											{APlayerStatus#ets_users.yuan_bao, 
											 APlayerStatus#ets_users.copper, 
											 0,
											 BPlayerStatus#ets_users.yuan_bao, 
											 BPlayerStatus#ets_users.copper,
											 0,
											  [], [], 
											 APlayerStatus#ets_users.id,
											 BPlayerStatus#ets_users.id,
											 [], [], 
											 APlayerStatus#ets_users.other_data#user_other.pid_item,
											 BPlayerStatus#ets_users.other_data#user_other.pid_item}),

				   {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, BItemList, ANulls, BNulls} = Res,
				   
				   F = fun(Info, List) ->
							   lists:concat([List, Info#ets_users_items.id, ','])
					   end,
				   TempAItemIDs = lists:foldl(F, [], AItemList),
				   TempBItemIDs = lists:foldl(F, [], BItemList),			   
				   if 
					   length(TempAItemIDs) > 0 ->
						 AItemIDs = lists:sublist(TempAItemIDs, 1, length(TempAItemIDs) -1);
					   true ->
						   AItemIDs = TempAItemIDs
				   end,
				   if 
					   length(TempBItemIDs) > 0 ->
						 BItemIDs = lists:sublist(TempBItemIDs, 1, length(TempBItemIDs) -1);
					   true ->
						   BItemIDs = TempBItemIDs
				   end,		   
				   %%添加交易日
				   lib_statistics:add_trade_log(APlayerStatus#ets_users.id, AtradeCopper, BItemIDs, 
												BPlayerStatus#ets_users.id, BtradeCopper, AItemIDs,
												misc_timer:now_seconds()),
	
				   				   		
				   %%在物品进程里进行物品交易 用了比较多call 需改进！
%% 				   {ok, NewAItemList} = gen_server:call(APlayerStatus#ets_users.other_data#user_other.pid_item,
%% 							{'trade', AItemList, ANulls}),
%% 				   {ok, NewBItemList} = gen_server:call(BPlayerStatus#ets_users.other_data#user_other.pid_item,
%% 							{'trade', BItemList, BNulls}),
				   
				   gen_server:cast(APlayerStatus#ets_users.other_data#user_other.pid_item, {'trade', AItemList, ANulls}),
				   gen_server:cast(BPlayerStatus#ets_users.other_data#user_other.pid_item, {'trade', BItemList, BNulls}),
				   
				   
 				   APlayerStatusRest = APlayerStatus#ets_users{yuan_bao = AYB, copper = ACopper},
				   BPlayerStatusRest = BPlayerStatus#ets_users{yuan_bao = BYB, copper = BCopper},
				   
				   gen_server:cast(BPlayerStatus#ets_users.other_data#user_other.pid, {'trade_money', BYB, BCopper}),
				   
				   send_to_client(APlayerStatusRest),
				   send_to_client(BPlayerStatusRest),
				   				   				   				   				   
				   [1, APlayerStatusRest, BPlayerStatusRest]
		   end
	end.

send_to_client(PlayerStatus) ->
	{ok, BinData} = pt_20:write(?PP_UPDATE_SELF_INFO,[PlayerStatus#ets_users.yuan_bao,
													  PlayerStatus#ets_users.copper,
													  PlayerStatus#ets_users.bind_copper,
													  PlayerStatus#ets_users.depot_copper,
													  PlayerStatus#ets_users.bind_yuan_bao]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData).


%% 检查能否交易
check_trade_finish([], _APlayerStatus, _BPlayerStatus) ->
	true;
check_trade_finish(List, APlayerStatus, BPlayerStatus) ->
	[ATrade|ATradeList] = List,
	{{ItemId, Type, TradeType}, Amount} = ATrade,
	CanTrade = 
		case TradeType of
			1 -> %% 别人给自己	
				case Type of
					1 ->
						%% 需求加入物品判断
						true;
					2 ->
						if BPlayerStatus#ets_users.copper >= Amount ->
							   true;
						   true ->
							   false
						end;
					3 ->
						if BPlayerStatus#ets_users.yuan_bao >= Amount ->
							   true;
						   true ->
							   false
						end
				end;
			2 ->
				case Type of
					1 ->
						%% 需求加入物品判断
						true;
					2 ->
						if APlayerStatus#ets_users.copper >= Amount ->
							   true;
						   true ->
							   false
						end;
					3 ->
						if APlayerStatus#ets_users.yuan_bao >= Amount ->
							   true;
						   true ->
							   false
						end
				end
		end,
	case CanTrade of
		true ->
			check_trade_finish(ATradeList, APlayerStatus, BPlayerStatus);
		_ ->
			false
	end.
					
sure_trade_finish([], 
				  {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, BItemList, _AUserId, _BUserId, ANulls, BNulls, _AItemPid, _BItemPid})->
	{AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, BItemList, ANulls, BNulls};
sure_trade_finish(List, 
				  {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, BItemList, AUserId, BUserId, ANulls, BNulls, AItemPid, BItemPid}) ->
	
	[ATrade|ATradeList] = List,
	{{ItemId, Type, TradeType}, Amount} = ATrade,
	
	case TradeType of
		1 -> %% 别人给自己			
			case Type of
				1 -> %% 物品
					
					%%物品进程 call!
					case  gen_server:call(BItemPid, {'get_item_by_itemid', ItemId}) of
						[] ->
							sure_trade_finish(ATradeList,
											  {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, BItemList, AUserId, BUserId,ANulls, BNulls,AItemPid, BItemPid});
						ItemInfo ->
							NewItemInfo = ItemInfo#ets_users_items{user_id = AUserId},
							sure_trade_finish(ATradeList,
											   {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, [NewItemInfo|AItemList], BItemList,AUserId, BUserId, ANulls , [ItemInfo#ets_users_items.place|BNulls], AItemPid, BItemPid})
					end;

				2 -> %% 铜币
					NewACopper = ACopper + Amount,
					NewBCopper = BCopper - Amount,
					sure_trade_finish(ATradeList,
									  {AYB, NewACopper, AtradeCopper, BYB, NewBCopper, BtradeCopper + Amount, AItemList, BItemList,AUserId, BUserId, ANulls, BNulls,AItemPid, BItemPid});
				3 -> %% 元宝
					NewAYB = AYB + Amount,
					NewBYB = BYB - Amount,
					sure_trade_finish(ATradeList,
									  {NewAYB, ACopper, AtradeCopper, NewBYB, BCopper, BtradeCopper, AItemList, BItemList,AUserId, BUserId, ANulls, BNulls,AItemPid, BItemPid})
			end;
		
		2 -> %% 自己给别人
			case Type of
				1 -> %%物品
					
					%%物品进程 call!
					case gen_server:call(AItemPid, {'get_item_by_itemid', ItemId}) of
						[] ->
							sure_trade_finish(ATradeList,
											   {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, BItemList, AUserId, BUserId,ANulls, BNulls,AItemPid, BItemPid});
						ItemInfo ->
							NewItemInfo = ItemInfo#ets_users_items{user_id = BUserId},
							sure_trade_finish(ATradeList,
											   {AYB, ACopper, AtradeCopper, BYB, BCopper, BtradeCopper, AItemList, [NewItemInfo|BItemList], AUserId, BUserId, [ItemInfo#ets_users_items.place|ANulls], BNulls,AItemPid, BItemPid})
					end;
				
				2 -> %%铜币
					NewACopper = ACopper - Amount,
					NewBCopper = BCopper + Amount,
					sure_trade_finish(ATradeList, 
									  {AYB, NewACopper, AtradeCopper + Amount, BYB, NewBCopper, BtradeCopper, AItemList, BItemList, AUserId, BUserId,ANulls, BNulls,AItemPid, BItemPid});
				
				3 ->%%元宝
					NewAYB = AYB - Amount,
					NewBYB = BYB + Amount,
					sure_trade_finish(ATradeList, 
									  {NewAYB, ACopper, AtradeCopper, NewBYB, BCopper, BtradeCopper, AItemList, BItemList, AUserId, BUserId,ANulls, BNulls,AItemPid, BItemPid})
			end
			
	end.


%% ----------------------------------------------------------------------------------------
%%	取消交易
%% ----------------------------------------------------------------------------------------
cancel_trade_1(PlayerStatus) ->
	{_ATrade, BUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	case _ATrade =:= 0 of
		true ->
			ok;
		_ ->
			[APlayerStatus, BPid] = cancel_trade_2(PlayerStatus, BUserId),
			case BPid of 
				[] -> %% 对方不在线
					skip;
				_ ->
					{ok, BinData} = pt_27:write(?PP_TRADE_CANCEL_RESPONSE, [0]),
			
					gen_server:cast(BPid, {'trade_change_state', BinData, {0, 0}, []})
			end,
			{ok, APlayerStatus}
	end.

cancel_trade_2(PlayerStatus, BUserId) ->
	BPid = lib_player:get_player_pid(BUserId),
	PlayerStatusRest = lib_trade:trade_change_state(PlayerStatus,											
													{0, 0},
													[]),
	[PlayerStatusRest, BPid].


%%--------------------------------------------------------------------
%% Add Transactions articles
%% @return [number(), list(), record()]
%%--------------------------------------------------------------------

%% 添加交易物品
trade_item_add(PlayerStatus, Type, BUserId, Place) ->
	case trade_item_add_1(PlayerStatus,Type,BUserId,Place) of
		error ->
			[0, [], {}, []];
		Result ->
			Result
	end.

trade_item_add_1(PlayerStatus, Type, BUserId, Place) ->
	case Type of
		1 -> %% add item  then Param means ets_users_items.place
			item_trade(PlayerStatus, Type, BUserId, Place);
		
		2 -> %% add copper 
			%% then Param means money amount
			money_trade(PlayerStatus#ets_users.other_data#user_other.trade_list, 
						Type, 
						BUserId, 
						Place,  
						PlayerStatus#ets_users.copper);
		
		3 -> %% add yuanbao
			money_trade(PlayerStatus#ets_users.other_data#user_other.trade_list,
						Type,
						BUserId,
						Place,
						PlayerStatus#ets_users.yuan_bao)
	end.

%%--------------------------------------------------------------------
%% Request transaction
%%--------------------------------------------------------------------

%%--------------------------------------------------------------------
%% Accept transaction
%%--------------------------------------------------------------------
%% 同意交易
accept_trade(PlayerStatus, BResult, AUserId) ->
	case lib_trade:do_trade({lib_trade, accept_trade_1, [BResult, AUserId, PlayerStatus]})of
		error ->
			[0, []];
		Result ->
			Result
	end.

accept_trade_1(BResult, AUserId, PlayerStatus) ->
	APlayerStatus = lib_player:get_online_player_info_by_id(AUserId),
	case BResult of
		0 -> %% refuse!
			case APlayerStatus of
				[] -> %% initiator offline
					[?TRADE_OFFLINE, []];
				_ ->
					[1, APlayerStatus]
			end;
		1 -> %% accept!
			case APlayerStatus of
				[] -> %% initiator offline
					[0, []];
				_ ->
					{ATrade, _IdB} = APlayerStatus#ets_users.other_data#user_other.trade_status,
					[APK, ADie, ASit]= [check_is_pk(APlayerStatus),check_is_die(APlayerStatus),check_is_sit(APlayerStatus)],

					{BTrade, _IdA} = PlayerStatus#ets_users.other_data#user_other.trade_status,
					[BPK, BDie, BSit]= [check_is_pk(PlayerStatus),check_is_die(PlayerStatus),check_is_sit(PlayerStatus)],
					if	
						%% A is trading
						ATrade /= 0 -> [?TRADE_BUSY, []];
						%% A is fighting
						APK == 1 -> [?TRADE_BUSY, []];
						%% A is dead
						ADie == 1 -> [?TRADE_BUSY, []];
						%% A is Sitting
						ASit == 1 -> [?TRADE_BUSY, []];
						
						%% B is trading
						BTrade /= 0 -> [?TRADE_TRADING, []];
						%% B is fighting
						BPK == 1 -> [?TRADE_FIGHTING, []];
						%% B is dead
						BDie == 1 -> [?TRADE_DEAD, []];
						%% B is Sitting
						BSit == 1 -> [?TRADE_SITTING, []];						
						
						true ->
							[1, APlayerStatus]
					end
			end;
		_ ->
			error
	end.


%% 改变交易状态
trade_change_state(PlayerStatus, TradeStatus, TradeList) ->
	Other = PlayerStatus#ets_users.other_data#user_other{ trade_status = TradeStatus, trade_list = TradeList},
	PlayerStatus#ets_users{other_data=Other}.
	
%% 重置交易状态	
trade_status_reset(PlayerStatus) ->
	PlayerStatus#ets_users.other_data#user_other{trade_status = {0, 0}, trade_list = []}.

%%%====================================================================
%%% Private functions
%%%====================================================================
%% 更新双方物品记录
item_trade(PlayerStatus, Type, BUserId, Place) ->
	if
		Place > 0 ->
			Len = get_trade_item_amount(2, PlayerStatus#ets_users.other_data#user_other.trade_list),
			if
				Len >= ?TRADE_MAX_NUM ->
					[2, [], {}, []];
				true ->
					item_trade1(PlayerStatus, Type, BUserId, Place)
			end;
		true ->
			[3, [], {}, []]
	end.


item_trade1(PlayerStatus, Type, BUserId, Place) ->
	%%物品进程 call!
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_item_info_by_place', Place}) of
		[] ->
			[4, [], {}, []];
		[ItemInfo] ->
			if
				ItemInfo#ets_users_items.is_bind =:= 1 orelse
				ItemInfo#ets_users_items.user_id =/= PlayerStatus#ets_users.id ->
					[5, [], {}, ItemInfo];
				
				true ->		
					ItemId = ItemInfo#ets_users_items.id,
					Amount = ItemInfo#ets_users_items.amount,
					
					BPlayerStatus = lib_player:get_online_player_info_by_id(BUserId),
					BTradeList = BPlayerStatus#ets_users.other_data#user_other.trade_list,
					ATradeList = PlayerStatus#ets_users.other_data#user_other.trade_list,
					ATradeListRest = [{{ItemId, Type, 2}, Amount}|ATradeList],
					BTradeListRest = [{{ItemId, Type, 1}, Amount}|BTradeList],
					
					Other = BPlayerStatus#ets_users.other_data#user_other{trade_list = BTradeListRest},
					BPlayerStatusRest = BPlayerStatus#ets_users{other_data= Other},
					[1, ATradeListRest, BPlayerStatusRest, ItemInfo]
			end
	end.


%% 获取其中一方交易栏的现有的物品数
get_trade_item_amount(TradeType, TradeList) ->
	F = fun (Trade, Acc0) ->
			{{_ItemId, Type, TradeType1}, _Amount} = Trade,
			if 
				TradeType1 =/= TradeType ->
				   Acc0;
			   true ->
				   if
					   Type =:= 1 -> %% 物品
						   Acc0 + 1;
					   true -> %% 铜币或元宝
						   Acc0
				   end
			end
		end,
	lists:foldl(F, 0, TradeList).

%% 更新双方铜币、元宝记录
money_trade(ATradeList, Type, BUserId, Amount, AMoney) ->
	if
		Amount < 0 orelse AMoney < 0 orelse abs(Amount) > abs(AMoney) ->
			[0, [], {}, []];
		true ->
			if
				Amount =:= 0 ->
					%% 删除铜币、元宝记录
					BPlayerStatus = lib_player:get_online_player_info_by_id(BUserId),
					BTradeList = BPlayerStatus#ets_users.other_data#user_other.trade_list,
					%% {{物品id，类型， 流向 }, 数量} 
					%% TRADE_ID      交易物品id： 2为货币，其他 ets_users_items.id
					%% TRADE_TYPE    交易类型：     1 物品  2 铜币 3 元宝
					%% TRADE_FLLOW   交易流向：     1 流向别人  2流向自己
					%% TRADE_AMOUNT  交易数量：     物品的数量or货币的数量
					BTradeListRest = lists:keydelete({2, Type, 1}, 1, BTradeList), %% 1表示 别人给自己的
					ATradeListRest = lists:keydelete({2, Type, 2}, 1, ATradeList), %% 2表示自己给别人的			
													
					BPlayerStatusRest = trade_change_state(BPlayerStatus,
														   BPlayerStatus#ets_users.other_data#user_other.trade_status,
														   BTradeListRest),
					[1, ATradeListRest, BPlayerStatusRest, []];
				true ->
					%% 删除铜币、元宝记录
					BPlayerStatus = lib_player:get_online_player_info_by_id(BUserId),
					BTradeList = BPlayerStatus#ets_users.other_data#user_other.trade_list,
					
					BTradeListRest = lists:keydelete({2, Type, 1}, 1, BTradeList), %% 1表示 别人给自己的
					ATradeListRest = lists:keydelete({2, Type, 2}, 1, ATradeList), %% 2表示自己给别人的
					
					%% 添加新的铜币、元宝记录		
					BTradeListRest1 = [{{2, Type, 1}, Amount}|BTradeListRest],
					ATradeListRest1 = [{{2, Type, 2}, Amount}|ATradeListRest],

					BPlayerStatusRest = trade_change_state(BPlayerStatus,
														   BPlayerStatus#ets_users.other_data#user_other.trade_status,
														   BTradeListRest1),
					[1, ATradeListRest1, BPlayerStatusRest, []]
			end
	end.



%%------------------------------------------------------------------------------------------------------
%% 检查玩家是否在pk中
check_is_pk(PlayerStatus) ->
	PkTime1 = misc_timer:now_seconds() - PlayerStatus#ets_users.other_data#user_other.last_pk_actor_time,     %(主动)
	PkTime2 = misc_timer:now_seconds() - PlayerStatus#ets_users.other_data#user_other.last_pk_target_time,    %(被动)
	if
		PkTime1 < 10 orelse PkTime2 < 10 ->
			1;
		true ->
			0
	end.

%% 检查玩家是否死亡
check_is_die(PlayerStatus) ->
	if
		PlayerStatus#ets_users.current_hp > 0 ->
			0;
		true ->
			1
	end.

%% 检查玩家是否打坐中
check_is_sit(_PlayerStatus) ->
	0.
%%	if PlayerStatus#ets_users.other_data#user_other.sit_state == 0 ->
%%			0;
%%		true ->
%%			1
%%	end.
	
%% 检查玩家是否交易中
check_is_trade(PlayerStatus) ->
	{Trade, _TargetUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	if 
		Trade =/= 0 ->
			1;
		true ->
			0
	end.


%% 交易请求
request_trade(PlayerStatus, TargetUserId) ->
	case check_can_trade_start(PlayerStatus, TargetUserId) of
		error ->
			[error, []];
		Result ->
			Result
	end.


%% 检查能否交易
check_can_trade_start(PlayerStatus, TargetUserId) ->
	case check_can_trade(PlayerStatus) of
		{ok, _Pid} ->
			case check_can_trade(TargetUserId) of
				{ok, Pid_Send} ->
					[ok, Pid_Send];
				{fail, Msg} ->
					do_trade_error(PlayerStatus#ets_users.id, Msg),
					[error, []]
			end;
		{fail, Msg} ->
			do_trade_error(PlayerStatus#ets_users.id, Msg),
			[error, []]
	end.


check_can_trade(PlayerStatus) when is_record(PlayerStatus, ets_users) ->
	case lib_trade:check_is_pk(PlayerStatus) of 
		1 ->
			{fail, ?_LANGUAGE_TRADE_FAIL_PK};
		0 ->
			case lib_trade:check_is_die(PlayerStatus) of
				1 -> 
					{fail, ?_LANGUAGE_TRADE_FAIL_DEAH};
				0 ->
					check_can_trade2(PlayerStatus)
			end
	end;
check_can_trade(UserId) when is_number(UserId) ->
	 case lib_player:get_online_player_info_by_id(UserId) of
		 [] ->
			 {fail, ?_LANGUAGE_TRADE_FAIL_OFFLINE};
		 PlayerStatus ->
			 check_can_trade(PlayerStatus)
	 end;
check_can_trade(_Value) ->
	{fail, ?_LANGUAGE_TRADE_FAIL_UNKOWN_VALUE}.


check_can_trade2(PlayerStatus) ->
	case lib_trade:check_is_sit(PlayerStatus) of
		1 ->
			{fail, ?_LANGUAGE_TRADE_FAIL_SIT};
		0 ->
			case lib_trade:check_is_trade(PlayerStatus) of
				1 ->
					{fail, ?_LANGUAGE_TRADE_FAIL_TRADE};
				0 ->
					{ok, PlayerStatus#ets_users.other_data#user_other.pid_send}
			end
	end.

do_trade_error(UserId, Msg)->
	lib_chat:chat_sysmsg([UserId, ?EVENT,?None,?RED,Msg]).


do_trade({Module, Method, Args}) ->
	case apply(Module, Method, Args)of
		{'EXIT', Info} ->
			?WARNING_MSG("...do_trade EXIT:~p~n", [Info]),
			error;
		Data ->
			Data
	end.


%% trade_list_add(PlayerStatus, Type, ItemId, Amount) ->
%% 	case PlayerStatus#ets_users.other_data#user_other.trade_list of
%% 		[] ->
%% 			[1, [{{ItemId, Type}, Amount}]];
%% 		TradeList ->
%% 			case lists:keysearch({ItemId, Type}, 1, TradeList) of
%% 				false ->
%% 					Len = length(TradeList),
%% 					if
%% 						Len < ?TRADE_MAX_NUM ->
%% 							NewTradeList = [{{ItemId, Type}, Amount}|TradeList],
%% 							[1, NewTradeList];
%% 						true ->
%% 							[0, TradeList]
%% 					end;
%% 				{value, {Key, _Amount}} ->
%% 					if 
%% 						Type /= 1 -> %% not item
%% 							NewTradeList = lists:keyreplace(Key, 1, TradeList, {Key, Amount}),
%% 							[1, NewTradeList];
%% 						true ->
%% 							[0, TradeList]
%% 					end
%% 			end
%% 	end.
%% 