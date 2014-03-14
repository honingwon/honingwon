%%%-------------------------------------------------------------------
%%% Module  : mod_item


%%% Author  : 
%%% Description : 物品模块
%%%-------------------------------------------------------------------
-module(mod_item).
-behaviour(gen_server).

-export([start_link/7]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(SAVE_ITEM_TICK, (1 * 60 * 1000)).			%% 保存物品tick

-define(SMSHOP_REF_TICK, (4 * 3600 )).			%% 神秘商店刷新tick

%%====================================================================
%% External functions
%%====================================================================

%% start(PlayerId, BagMaxCount, Socket) ->
%%     gen_server:start(?MODULE, [PlayerId,BagMaxCount,Socket], []).
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link(UserId,Career, Level,BagMaxCount, DepotMaxCount,UserPid,Socket) ->
    gen_server:start_link(?MODULE, [UserId, Career,Level,BagMaxCount, DepotMaxCount,UserPid, Socket], []).

%%====================================================================
%% Callback functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%%--------------------------------------------------------------------
init([UserId, Career, Level, BagMaxCount, DepotMaxCount,UserPid, Pid]) ->
	try
		do_init([UserId, Career, Level,BagMaxCount, DepotMaxCount,UserPid, Pid])
	catch
		_:Reason ->
			?WARNING_MSG("mod_item handle_call is exception:~w~n,Info:~w",[Reason, UserId]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{ok, #ets_users{}}
	end.

do_init([UserId, Career,Level,BagMaxCount, DepotMaxCount,UserPid, Pid]) ->
	ok = item_util:init_item_online(UserId,Career),
    NullCells = item_util:get_null_cells(UserId, BagMaxCount),
	DepotNullCells = item_util:get_nullcells_in_depot(UserId, DepotMaxCount),
	BoxNullCells  =  item_util:get_nullcells_in_box(UserId),
	SMShopInfo = item_util:init_smshop_info(UserId),
	ItemStatus = #item_status{
							user_id = UserId,
							level = Level,
							null_cells = NullCells,
							maxbagnull = BagMaxCount,
							pid = Pid,
							user_pid = UserPid,
							depot_null_cells = DepotNullCells,
							maxdepotnull = DepotMaxCount,
							maxboxnull = BoxNullCells,
							smshop_info = SMShopInfo
						},
 	misc:write_monitor_pid(self(),?MODULE, {}),	
	erlang:send_after(?SAVE_ITEM_TICK, self(), {'scan_time'}),
		
    {ok, ItemStatus}.

  
%%--------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("UserId:~w,mod_item handle_call is exception:~w~n,Info:~w",[State#item_status.user_id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

%%--------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("UserId:~w,mod_item handle_cast is exception:~w~n,Info:~w",[State#item_status.user_id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%%--------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_info(Info, State) ->
	try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("UserId:~w,mod_item handle_info is exception:~w~n,Info:~w",[State#item_status.user_id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%%--------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Private functions
%%====================================================================

%%---------------------do_call--------------------------------
do_call({'remove_item', _Item}, _Form, State) ->
	{reply, {ok}, State};

do_call({get_item_strengLv, Place}, _Form, State) ->
	if
		Place > 0 andalso Place < 30 ->
			case item_util:get_user_item_by_place(State#item_status.user_id, Place) of
			[] ->
				{reply, {0}, State};
			[Item] ->
				{reply, {Item#ets_users_items.strengthen_level}, State}				
			end;
		true ->
			{reply, {0}, State}	
	end;
	
%%判断有没有复活药水 有则使用
do_call({'use_relive_water'}, _From, State) ->
	UserList = item_util:get_item_list(State#item_status.user_id, ?BAG_TYPE_COMMON),
	F = fun(Info, List) ->
				if
					Info#ets_users_items.template_id =:= ?ITEM_RELIVE_WATER ->
						[Info | List];
					true ->
						List
				end
		end,
	ReliveWaterList = lists:foldl(F, [], UserList),
	
	{Res, NewState1} = 
		if
			erlang:length(ReliveWaterList) > 0 ->
				ReliveWaterInfo = lists:nth(1, ReliveWaterList),
				[NewState, NewItemInfo, ItemDeleteList] = lib_item:change_item_num_in_commonbag(ReliveWaterInfo, ReliveWaterInfo#ets_users_items.place, 1, State,?CONSUME_ITEM_USE),
				{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemInfo, ItemDeleteList]),
				lib_send:send_to_sid(State#item_status.pid, ItemData),
				{ok, NewState};
			
			true ->
				{error, State}
	end,
	{reply, {Res}, NewState1};



%% 背包新增空格, 不允许使用
do_call({'add_cells', BagType}, _Form, State) ->
%% 	NewNullCells = lists:sort([BagType|State#item_status.null_cells]),
%% 	NewState = State#item_status{null_cells = NewNullCells},
	case  BagType  of 
		?BAG_TYPE_COMMON ->
			if 
				State#item_status.maxbagnull >= ?MAXCOMMONCOUNT ->
					AddComExpan = 0;
				State#item_status.maxbagnull + 6 >= ?MAXCOMMONCOUNT ->
					AddComExpan = ?MAXCOMMONCOUNT - State#item_status.maxbagnull;
				true ->
					AddComExpan = 6
			end,
			AddDepotExpan = 0;
		?BAG_TYPE_STORE ->
			AddComExpan = 0,
			if 
				State#item_status.maxdepotnull >= ?MAXDEPOTCOUNT ->
					AddDepotExpan = 0;
				State#item_status.maxdepotnull + 6 >= ?MAXDEPOTCOUNT ->
					AddDepotExpan = ?MAXDEPOTCOUNT - State#item_status.maxdepotnull;
				true ->
					AddDepotExpan = 6
			end;
		_ ->
			AddComExpan = 0,
			AddDepotExpan = 0
	end,
	CommonBagNulls = item_util:get_null_cells(State#item_status.user_id, 
															  State#item_status.maxbagnull+AddComExpan),
	DepotBagNulls = item_util:get_nullcells_in_depot(State#item_status.user_id,
																	 State#item_status.maxdepotnull+AddDepotExpan),
	NewState = State#item_status{null_cells = CommonBagNulls,
													 maxbagnull = State#item_status.maxbagnull+AddComExpan,
													 depot_null_cells = DepotBagNulls,
													 maxdepotnull = State#item_status.maxdepotnull+AddDepotExpan
													 },
	{reply, {add_expansion, AddComExpan, AddDepotExpan}, NewState};


%% 添加寄售购买得来的物品
do_call({'change_item_owner', ItemInfo}, _Form, State) ->
	[Cell|NewNullCells] = State#item_status.null_cells,
	NewState = State#item_status{null_cells = NewNullCells},
	
	NewItemInfo = case ItemInfo#ets_users_items.id of
					  0 ->
						  lib_item:add_item(ItemInfo#ets_users_items{place = Cell});
					  _ ->
						  lib_item:change_item_owner(ItemInfo, Cell)
				  end,
	item_util:save_dic(),
	{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,[NewItemInfo], []]),
	lib_send:send_to_sid(State#item_status.pid, ItemData),
	{reply, {ok, NewItemInfo}, NewState};

%% %%购买物品 todo 验证格子是否足够 ,货币足够，拆分，商店是否有售。
%% do_call({'buy', YuanBao, BindYuanBao, Copper, BindCopper, ShopId, TemplateId, Amount, PayType}, _From, State) ->
%% 	case lib_item:check_buy(YuanBao, BindYuanBao, Copper, BindCopper, ShopId, TemplateId, Amount, State, PayType) of
%% 		{ok, Template, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao} ->		
%% 			%%物品叠加  判断生成物品的绑定类型	
%% 			if
%% 				Template#ets_item_template.bind_type =:= ?BIND_TYPE_1 ->
%% 					BindFlag = ?BIND;
%% 				true ->
%% 					BindFlag = ?NOBIND
%% 			end,				   					
%% 			{NewState, ItemList, _} = lib_item:add_item_amount_summation(Template, Amount, State, [], BindFlag, ?CANSUMMATION),
%% 			%%更新背包物品
%% 			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, []]),
%% 			lib_send:send_to_sid(State#item_status.pid, ItemData),					
%% 			{reply, [1, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao], NewState};
%% 		
%% 		_ ->
%% 			{reply, [0, 0, 0, 0, 0], State}
%% 	end;

%%功勋购买物品
do_call({exploit_buy, Exploit,ShopItemID,Amount}, _From, State) ->
	case lib_item:check_exploit_buy(Exploit,ShopItemID,Amount,State)of
		{ok, Template, ShopTempBind, ReduceExploit} ->
			if
				Template#ets_item_template.bind_type =:= ?BIND_TYPE_1 orelse  ShopTempBind =:= ?BIND_TYPE_1 ->
					BindFlag = ?BIND;
				true ->
					BindFlag = ?NOBIND
			 end,				   					
			{NewState, ItemList, _} = lib_item:add_item_amount_summation(Template, Amount, State, [], BindFlag, ?CANSUMMATION),
			%%更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(State#item_status.pid, ItemData),	
			{reply, [1, ReduceExploit, Template#ets_item_template.template_id], NewState};
		_er ->
			?DEBUG("exploit_buy error:~p",[_er]),
			{reply, [0, 0, 0], State}
	end;

do_call({qpoint_buy, ShopItemID, Amount}, _From, State) ->
	if
		Amount >= ?MINAMOUNT andalso Amount < ?MAXAMOUNT ->
			case data_agent:shop_template_get(ShopItemID) of				
				ShopTemplate when is_record(ShopTemplate, ets_shop_template) ->
					case data_agent:item_template_get(ShopTemplate#ets_shop_template.template_id) of
						[] ->
							{reply, {false}, State};
						ItemTemplate ->
							if
								ItemTemplate#ets_item_template.bind_type =:= ?BIND_TYPE_1 
										orelse  ShopTemplate#ets_shop_template.is_bind =:= ?BIND_TYPE_1 ->
									BindFlag = ?BIND;
								true ->
									BindFlag = ?NOBIND
			 				end,
							{NewState, ItemList, MorAmount} = lib_item:add_item_amount_summation(ItemTemplate, Amount, State, [], BindFlag, ?CANSUMMATION),
							
							if MorAmount > 0 ->%背包满了发送邮件
									gen_server:cast(self(), {add_item_send_mail,ItemTemplate,MorAmount,BindFlag});
								true ->
									ok
							end,
							%%更新背包物品
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
							lib_send:send_to_sid(State#item_status.pid, ItemData),
							{reply, {ok}, NewState}
					end;
				_ ->
					{reply, {ok}, State}
			end;
		true ->
			 {reply, {false}, State}
	end;

%%购买物品 todo 验证格子是否足够 ,货币足够，拆分，商店是否有售。
do_call({'buy', YuanBao, BindYuanBao, Copper, BindCopper, ShopItemID, Amount, GuildId, UserId,MapID,PosX,PosY,VipID}, _From, State) ->
	case lib_item:check_buy(YuanBao, BindYuanBao, Copper, BindCopper, ShopItemID, Amount,MapID,PosX,PosY,VipID, State) of
		{ok, Template, ShopTempBind, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao} ->	
			%%物品叠加  判断生成物品的绑定类型	
			if
				Template#ets_item_template.bind_type =:= ?BIND_TYPE_1 orelse  ShopTempBind =:= ?BIND_TYPE_1 ->
					BindFlag = ?BIND;
				true ->
					BindFlag = ?NOBIND
			 end,				   					
			{NewState, ItemList, _} = lib_item:add_item_amount_summation(Template, Amount, State, [], BindFlag, ?CANSUMMATION),
			%%更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(State#item_status.pid, ItemData),
			
			{reply, [1,ItemList, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, Template#ets_item_template.template_id], NewState};
		
		{bagfull} ->
			{reply, [2,[], 0, 0, 0, 0, 0], State};
		_ ->
			{reply, [0,[], 0, 0, 0, 0, 0], State}
	end;



%% 购买优惠商品
do_call({'buy_discount', YuanBao, BindYuanBao, Copper, BindCopper, ShopItemID, Amount, PlayerPidSend}, _From, State) ->
	BoughtItems = mod_shop:get_user_discounts(State#item_status.user_id),
	case lib_item:check_discount_buy(YuanBao, BindYuanBao, Copper, BindCopper, ShopItemID, Amount, BoughtItems, State) of
		{ok, Template, ShopItem, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, SurplusCount,LimitCount} ->	
			%%保存个人每天购买优惠商品数量
			Now = misc_timer:now_seconds(),
			{Today, _NextDay} = util:get_midnight_seconds(Now),
			FinishTime = Today+ShopItem#ets_shop_discount_template.finish_time,
%% 				case ShopItem#ets_shop_discount_template.type of
%% 					1 ->
%% 						Today+(ShopItem#ets_shop_discount_template.dates*24*60*60);
%% 					0 ->
%% 						Today+ShopItem#ets_shop_discount_template.finish_time
%% 				end,
			DiscountItem = #discount_items{item_id=ShopItem#ets_shop_discount_template.id,
										   item_count=Amount,
										   finish_time=FinishTime
										   },
			mod_shop:update_user_discounts(DiscountItem, State#item_status.user_id),
			
			%%物品叠加  判断生成物品的绑定类型	
			if
				Template#ets_item_template.bind_type =:= ?BIND_TYPE_1 orelse  ShopItem#ets_shop_discount_template.is_bind =:= ?BIND_TYPE_1 ->
					BindFlag = ?BIND;
				true ->
					BindFlag = ?NOBIND
			end,				   					
			{NewState, ItemList, _} = lib_item:add_item_amount_summation(Template, Amount, State, [], BindFlag, ?CANSUMMATION),
			%%更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(State#item_status.pid, ItemData),				
			{reply, [1, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, Template#ets_item_template.template_id, SurplusCount,LimitCount], NewState};
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerPidSend, ?FLOAT, ?None, ?ORANGE, Msg]),
			{reply, [0, 0, 0, 0, 0, 0, 0,0], State};
		{error, _Reason} ->
			%%?WARNING_MSG("mod_item buy_discount error:~w ~n",[Reason]),
			{reply, [0, 0, 0, 0, 0, 0, 0,0], State}
	end;


do_call({'buy_guild_shop', GuildId, ShopItemID, Amount}, _From, State) ->
	BoughtItems = mod_shop:get_user_guild_shop(State#item_status.user_id),
	case lib_item:check_guild_shop_buy(GuildId, ShopItemID, Amount, BoughtItems, State) of
		{ok,ItemTemplate, IsBind, Feats ,Today} ->	
			%%保存个人每天购买优惠商品数量
			FinishTime = Today ,
			DiscountItem = #discount_items{item_id = ShopItemID,
										   item_count=Amount,
										   finish_time=FinishTime
										   },
			UpdateDiscountItem = case mod_shop:update_user_guild_shop(DiscountItem, State#item_status.user_id) of
				false ->
					DiscountItem;
				Re ->
					Re
			end,			
			
			%%物品叠加  判断生成物品的绑定类型	
			if
				ItemTemplate#ets_item_template.bind_type =:= ?BIND_TYPE_1 orelse  IsBind =:= ?BIND_TYPE_1 ->
					BindFlag = ?BIND;
				true ->
					BindFlag = ?NOBIND
			end,				   					
			{NewState, ItemList, _} = lib_item:add_item_amount_summation(ItemTemplate, Amount, State, [], BindFlag, ?CANSUMMATION),
			%%更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(State#item_status.pid, ItemData),		
			
			{reply, [1, Feats,UpdateDiscountItem], NewState};
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([State#item_status.pid, ?FLOAT, ?None, ?ORANGE, Msg]),
			{reply, [0, 0,[]], State};
		{error, _Reason} ->
			{reply, [0,0,[]] , State}
	end;

do_call({guild_prayer,GuildId}, _From, State) ->
	case mod_guild:get_guild_user_info(GuildId,State#item_status.user_id) of
		[] ->
			{reply, [0,?ER_WRONG_VALUE] , State};
		MemberInfo ->
			PrayerNum = lib_guild:pub_get_guild_user_feats_use_timers(MemberInfo, 13),
			if
				MemberInfo#ets_users_guilds.current_feats < ?GUILD_PRAYER_PRICE ->
					{reply, [0,?ER_NOT_ENOUGH_GUILD_FEATS] , State};
				PrayerNum >= ?GUILD_PRAYER_MAX_NUM ->
					{reply, [0,?ER_MAX_GUILD_PRAYER_NUM] , State};
				erlang:length(State#item_status.null_cells) < 1 ->
					{reply, [0,?ER_NOT_ENOUGH_BAG] , State};
				true ->
					TemplateId = lib_guild:get_guild_prayer_info(),
					gen_server:cast(self(), {'add_item', TemplateId, 1, ?BIND, ?ITEM_PICK_SYS}),
					{reply, [1,TemplateId] , State}
%% 					case of
%% 						[] ->
%% 						ItemTemplate ->
%% 							{NewState, ItemList, _} = lib_item:add_item_amount_summation(ItemTemplate, 1, State, [], ?BIND, ?CANSUMMATION),
%% 							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
%% 							lib_send:send_to_sid(State#item_status.pid, ItemData),
%% 							{reply, [1,ItemId] , NewState}
%% 					end
			end	
	end;

do_call({'gm_add_item', ItemID, Amount}, _From, State) ->
	if
		Amount >= ?MINAMOUNT andalso Amount < ?MAXAMOUNT ->
			case data_agent:item_template_get(ItemID) of
						[] ->
							{reply, [0, 0, 0, 0, 0, 0], State};
						ItemTemplate ->
							NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
							if
								NeedCellNum > erlang:length(State#item_status.null_cells)->
									{reply, [0, 0, 0, 0, 0, 0], State};
								true ->
									%%物品叠加  判断生成物品的绑定类型	
									if
										ItemTemplate#ets_item_template.bind_type =:= ?BIND_TYPE_1 ->
											BindFlag = ?BIND;
										true ->
											BindFlag = ?NOBIND
									end,
									{NewState, ItemList, _} = lib_item:add_item_amount_summation(ItemTemplate, Amount, State, [], BindFlag, ?CANSUMMATION),
									%%更新背包物品
									{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SCENE,ItemList, []]),
									lib_send:send_to_sid(State#item_status.pid, ItemData),
									{reply, [1, 0, 0, 0, 0, ItemTemplate#ets_item_template.template_id], NewState}
							end
			end;
		true ->
			{reply, [0, 0, 0, 0, 0, 0], State}
	end;

%%装备物品
do_call({'equip', PlayerStatus, FromPlace, ToPlace,Pet}, _From, State) ->
	case lib_item:move_item_equip(State, FromPlace, ToPlace, PlayerStatus#ets_users.bag_max_count, PlayerStatus) of
		{ok, NewState, ItemList, DeleteList} ->
			if 
				FromPlace >= ?BAG_BEGIN_CELL andalso ToPlace < 0 ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[], DeleteList]),
					lib_send:send_to_sid(State#item_status.pid, BinData),
					{reply, {remove}, NewState};
				true ->
					item_util:calc_equip_num(State#item_status.user_id,PlayerStatus),
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
					lib_send:send_to_sid(State#item_status.pid, BinData),
					
				  	{reply, {ok}, NewState}
			end;
		_ ->
			{reply, {error}, State}
	end;

do_call({'pet_equip',MaxCount, FromPlace, ToPlace, PetLevel, PetId}, _From, State) ->
	case lib_item:move_item_pet_equip(State, FromPlace, ToPlace, PetLevel, PetId, MaxCount) of
		{ok, NewState, ItemList, DeleteList, PItem, PDele} ->
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
			lib_send:send_to_sid(State#item_status.pid, BinData),
			{ok, BinData2} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [PetId,?ITEM_PICK_NONE,PItem, PDele]),
			lib_send:send_to_sid(State#item_status.pid, BinData2),	
			{reply, {ok}, NewState};
		_ ->
			{reply, {ok}, State}	
	end;

%%获取装备属性
do_call({'get_equip_properties',PlayerStatus}, _From, State) ->
	[Record, StyleBin] = item_util:calc_equip_properties(State#item_status.user_id, PlayerStatus#ets_users.other_data#user_other.pid_target,PlayerStatus#ets_users.career),
	{NewStyleBin,Mounts} = item_util:update_stylebin(StyleBin,
													 PlayerStatus#ets_users.other_data#user_other.weapon_state,
													 PlayerStatus#ets_users.other_data#user_other.cloth_state),
	{reply, [ok, Record, NewStyleBin,  Mounts], State};

do_call({'get_pet_equip_properties',PetId,TargetPid}, _From, State) ->
	Record = item_util:calc_pet_equip_properties(PetId,TargetPid),
	{reply, [ok, Record], State};

%%获取装备列表
do_call({'get_equip_list'}, _From, State) ->
	List = item_util:get_equip_list(State#item_status.user_id),
	{reply, List, State};

%%获取宠物装备
do_call({'get_pet_equip_list', PetId},_From, State ) ->
	List = item_util:get_pet_equip_list(PetId),
	{reply, List, State};
%%道具回收
do_call({'item_retrieve', Place}, _From, State) ->
	case lib_item:item_retrieve(State, Place) of
		{ok, NewState, ItemList, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper} ->
			%%更新背包物品
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, [Place]]),
			lib_send:send_to_sid(State#item_status.pid, BinData),
			{reply, {ok, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper}, NewState};		
		_ ->
			{noreply,{ok, 0, 0, 0, 0}, State}
	end;

%%道具出售
do_call({'item_sell', Place, Count}, _From, State) ->
	case lib_item:item_sell(State, Place, Count) of
		[Res, NewState, ItemList, DeleteList, AddCopper, AddBindCopper] ->	
			%%更新背包物品
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
			lib_send:send_to_sid(State#item_status.pid, BinData),
			
			%%更新回购背包物品
%% 			{ok, BinData1} = pt_14:write(?PP_ITEM_BUY_BACK_UPDATE, [[ItemInfo], DeleteTempBag]),
%% 			lib_send:send_to_sid(State#item_status.pid, BinData1),
			
			{reply, [ok, Res, AddCopper, AddBindCopper], NewState};
		_ ->
			{reply, [ok, 0, 0, 0], State}
	end;
	

%%道具回购
do_call({'buy_back', Copper, Place}, _From, State) ->	
           case  lib_item:get_iteminfo_by_tempbag(Place, State#item_status.temp_bag) of 		  
			[ItemInfo] when is_record(ItemInfo, ets_users_items)  -> 				
	             Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
                 Amount = ItemInfo#ets_users_items.amount,
	    	     TotalCopper = Template#ets_item_template.sell_copper * Amount,			
			  if
				   length(State#item_status.null_cells) > 0 andalso Copper >= TotalCopper ->
				     {ok, NewState, ItemList, DeleteList} = lib_item:item_buy_back(ItemInfo, State),					 	 		 				 
				     %%更新背包物品
					 {ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
				     lib_send:send_to_sid(NewState#item_status.pid, ItemData),
					 %%更新回购背包物品
					 {ok, ItemData1} = pt_14:write(?PP_ITEM_BUY_BACK_UPDATE, [[], DeleteList]),
				     lib_send:send_to_sid(NewState#item_status.pid, ItemData1),
					     {reply, [1, TotalCopper], NewState};				
				  true ->
					     {reply,[0, 0], State}
			 end;
			
		   _ ->
		 	             {reply,[0, 0], State}
	     end;


%%道具喂养
do_call({'item_feed',PlayerStatus, MountsId,List}, _From, State) ->
	case lib_mounts:get_mounts_by_id(MountsId) of
		[] ->
			{reply, {ok, 0}, State};
		Info when (Info#ets_users_mounts.level < 120) ->
			case lib_item:item_feed(State, List) of
				[Res, NewState, ItemList, DeleteList, AddExp] ->	
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
					lib_send:send_to_sid(State#item_status.pid, BinData),
					case lib_mounts:add_exp_and_lvup(PlayerStatus,MountsId,AddExp) of
						{ok,1} ->
							{reply, {ok, 1}, NewState};
						_ ->
							{reply, {ok, 0}, NewState}
					end;
					
				_ ->
					{reply, {ok, 0}, State}
			end;
		_ ->
			{reply, {ok, 0}, State}
	end;


%% 坐骑修改状态
do_call({'update_mounts_state',PlayerStatus,ID,MountsState}, _From, State) ->
	case lib_mounts:update_mounts_state(ID,MountsState,State#item_status.pid) of
		{ok,Mounts1} ->
			IsHorse = 1;
		{ok} ->
			IsHorse = 0;
		_ ->
			IsHorse = 2
	end,
	case IsHorse =/= 2 of
		true ->
			{_, NewPlayerStatus}  = lib_sit:cancle_sit(PlayerStatus),
			
%% 			[Record, StyleBin] = item_util:calc_equip_properties(State#item_status.user_id,NewPlayerStatus#ets_users.other_data#user_other.pid_target),
%% 			{NewStyleBin,Mounts} = item_util:update_stylebin(StyleBin,
%% 													 NewPlayerStatus#ets_users.other_data#user_other.weapon_state,
%% 													 NewPlayerStatus#ets_users.other_data#user_other.cloth_state),
%% 			OldWeaponType = NewPlayerStatus#ets_users.other_data#user_other.equip_weapon_type,
			NewPlayerStatus1 =  NewPlayerStatus#ets_users{ is_horse = IsHorse },

%% 			NewPlayerStatus2 = lib_player:calc_properties(NewPlayerStatus1, Record, NewStyleBin,  Mounts,Pet),
			{reply, {ok,NewPlayerStatus1}, State};
		
		_ ->
			{reply, false, State}
	end;

do_call({'update_gengu', NeedNum}, _From, ItemStatus) ->
	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, 203024) of
		[] ->
			{reply, no_emult, ItemStatus};
		Info when (Info#ets_users_items.amount >= NeedNum andalso Info#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON)->
			[NewState, NewInfo, DeleteList] = lib_item:change_item_num_in_commonbag(Info, Info#ets_users_items.place, NeedNum, ItemStatus,?CONSUME_ITEM_USE),
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewInfo, DeleteList]),
			lib_send:send_to_sid(NewState#item_status.pid, ItemData),
			 {reply, ok, NewState};
		_ ->
			 {reply, not_enough_emult, ItemStatus}
	end;

%%装备开孔
do_call({'hole',ItemPlace, TapPlace, Copper,BindCopper, VipRateAdd}, _From, ItemStatus) ->
    case lib_item:check_hole(ItemStatus, ItemPlace, TapPlace, Copper,BindCopper) of
		{fail, Res} ->	
			case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace) of
				[] ->
					ReturnItemId = -1;
				[ReturnItem] ->
					ReturnItemId = ReturnItem#ets_users_items.id
			end,
            {reply, [Res, 0, ReturnItemId, 0], ItemStatus};     
		
		{ok, ItemInfo, TapInfo, Cost} ->	
			HoleList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2, ItemInfo#ets_users_items.enchase3],
			HoleNum = lists:foldl(fun(Info, Num) -> 
										  if Info =/= -1 ->
												 Num +1;
											 true ->
												 Num
										  end end, 0, HoleList),
			case lib_item:tap_hole(ItemStatus, ItemInfo, TapInfo, TapPlace, VipRateAdd) of				
				{ok, NewItemStatus, Res, ItemList, DeleteList} ->	 		
					 %%更新背包物品
					 {ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				     lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					   {reply, [Res, Cost, ItemInfo#ets_users_items.id, HoleNum], NewItemStatus}; 
				
				{fail, NewItemStatus, Res, ItemList, DeleteList} ->			
					 %%更新背包物品
					 {ok, ItemData1} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				     lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData1),
	                   {reply, [Res, Cost, ItemInfo#ets_users_items.id, HoleNum], NewItemStatus};   
				
                 Error ->
                     ?DEBUG("mod_item tap_hole:~p", [Error]),
                     {reply, [[Error], 0, 0, HoleNum], ItemStatus}          
            end
    end;

%%道具使用
do_call({'item_use', Career,Place, Level, Yaoxiao, Location}, _From, ItemStatus) ->
	case lib_item:check_item_use(Place, ItemStatus, Level, Location) of
		{ok, ItemInfo, Template} ->
			case lib_item:item_use(ItemInfo, Template, ItemStatus) of
				{add_hp_mp, [NewState, NewItemList, DeleteList, Hp, Mp]} ->
					%%更新背包物品            
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					AddHp = tool:to_integer(Yaoxiao * Hp),
					AddMp = tool:to_integer(Yaoxiao * Mp),
					{reply, [add_hp_mp, AddHp, AddMp], NewState};
				{open_box,[NewState, NewItemList, DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, MailItemList]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[open_box, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, MailItemList], NewState};
				
				{add_curexp_lifexp_phy, [NewState, NewItemList, DeleteList, CurrExp, LiftExp, PhyExp]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[add_curexp_lifexp_phy, CurrExp, LiftExp, PhyExp], NewState};
				{add_curexp_pet_exp, [NewState, NewItemList, DeleteList,AddExp]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[add_curexp_pet_exp, AddExp], NewState};
				{add_curexp_exploit, [NewState, NewItemList, DeleteList,AddExploit]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[add_curexp_exploit, AddExploit], NewState};
				{add_copper, [NewState, NewItemList, DeleteList, AddCopper, AddBindCopper]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[add_copper, AddCopper, AddBindCopper], NewState};

				{add_buff, [NewState, NewItemList, DeleteList, BuffId]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [add_buff, BuffId], NewState};
				
				
				{add_expansion, [NewState, NewItemList, DeleteList, AddComExpan, AddDepotExpan]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),	
					CommonBagNulls = item_util:get_null_cells(NewState#item_status.user_id, 
															  NewState#item_status.maxbagnull+AddComExpan),
					DepotBagNulls = item_util:get_nullcells_in_depot(NewState#item_status.user_id,
																	 NewState#item_status.maxdepotnull+AddDepotExpan),
					NewState1 = NewState#item_status{null_cells = CommonBagNulls,
													 maxbagnull = NewState#item_status.maxbagnull+AddComExpan,
													 depot_null_cells = DepotBagNulls,
													 maxdepotnull = NewState#item_status.maxdepotnull+AddDepotExpan
													 },
					{reply,[add_expansion, AddComExpan, AddDepotExpan], NewState1};
				
				
				{return_to_city, [NewState, NewItemList, DeleteList]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [return_to_city], NewState};
				{enter_treasure_map, [NewState, NewItemList, DeleteList]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					DuplicateId = Template#ets_item_template.propert4,
					{reply, [enter_treasure_map, DuplicateId], NewState};
				{random_to_transfer, [NewState, NewItemList, DeleteList]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [random_to_transfer], NewState};
					
				{reduce_pk_value, [NewState, NewItemList, DeleteList, ReducePkValue]} ->		
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [reduce_pk_value, ReducePkValue], NewState};
				
				{shenmo_accept_task, [NewState, NewItemList, DeleteList, TaskId, TaskState]}->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [shenmo_accept_task, TaskId, TaskState], NewState};
				
				{vip_card, [NewState, NewItemList, DeleteList, VipClass]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [vip_card, VipClass] , NewState};
				
				{mounts_card,[NewState, NewItemList, DeleteList]} ->
					%% 使用坐骑卡
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					lib_mounts:mounts_to_list(Career,ItemInfo,Template,NewState#item_status.pid,NewState#item_status.user_pid),
					{reply, [mounts_card],NewState};
				{mounts_skill,[NewState, NewItemList, DeleteList]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					lib_mounts:update_skill(ItemInfo,Template,NewState#item_status.pid),
					{reply, [mounts_skill] , NewState};
				{add_user_title,[NewState,NewItemInfo,DeleteList, TitleId]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemInfo, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply, [add_user_title, TitleId] , NewState};
				{other, [NewState, NewItemList, DeleteList]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
%% 					?WARNING_MSG("item_use error is other:~w", [NewItemList]),
					{reply, {error}, NewState};
				
				{error, _Reason} ->
%% 					?WARNING_MSG("item_use:~s", [_Reason]),
					{reply, {error}, ItemStatus};
				_Reason ->
%% 					?WARNING_MSG("item_use:~s", [_Reason]),
					{reply, {error}, ItemStatus}
			end;
		_ ->
			{reply, {error}, ItemStatus}
	end;


%%道具批量使用
do_call({'item_batch_use', Place, Count}, _From, ItemStatus) ->
	case lib_item:check_item_use(Place,Count, ItemStatus) of
		{ok, ItemInfo, Template} ->
			
			case lib_item:item_use(ItemInfo,Count, Template, ItemStatus) of
				{add_copper, [NewState, NewItemList, DeleteList, AddCopper, AddBindCopper]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[add_copper, AddCopper, AddBindCopper], NewState};
				
				{add_curexp_lifexp_phy, [NewState, NewItemList, DeleteList, CurrExp, LiftExp, PhyExp]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[add_curexp_lifexp_phy, CurrExp, LiftExp, PhyExp], NewState};
				
				{open_box,[NewState, NewItemList, DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, MailItemList]} ->
					%%更新背包物品
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,NewItemList, DeleteList]),
					lib_send:send_to_sid(NewState#item_status.pid, BinData),
					{reply,[open_box, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, MailItemList], NewState};
				
				{error, _Reason} ->
%% 					?WARNING_MSG("item_use:~s", [Reason]),
					{reply, {error}, ItemStatus};
				_ ->
					{reply, {error}, ItemStatus}
			end;
		_ ->
			{reply, {error}, ItemStatus}
	end;

%%使用穴位升级加速卡
do_call({'use_veins_speed_up_card', Place}, _From, ItemStatus) ->
	case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, Place) of
		[ItemInfo] ->
			if
				ItemInfo#ets_users_items.template_id =:= ?VEINS_SPEED_UP_CARD ->
					[NewState, NewInfo, Delete] = lib_item:change_item_num_in_commonbag(ItemInfo, ItemInfo#ets_users_items.place, 1, ItemStatus,?CONSUME_ITEM_USE),
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE, NewInfo, Delete]),
					lib_send:send_to_sid(NewState#item_status.pid, ItemData),
					{reply, {ok}, NewState};
				true ->
					?DEBUG("item not speed up card:~p",[Place]),
					{reply, {error}, ItemStatus}
			end;
		[] ->
			?DEBUG("item not enough:~p",[Place]),
			{reply, {error}, ItemStatus}
	end;

%%其他模块调用“使用物品”
do_call({'item_use_by_other_mod', TemplateId}, _From, ItemStatus) ->
	case lib_item:check_item_by_templateid(TemplateId, ItemStatus) of	
		{ok, ItemInfo, ItemTemplate, NewItemStatus} ->	
			case lib_item:item_use(ItemInfo, ItemTemplate, NewItemStatus) of
				{error, _Res} ->
					{reply, {ok, false}, NewItemStatus};			
				{chat_horn, [NewItemInfo, DeleteList, NewItemStatus1]} ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewItemInfo, DeleteList]),
					lib_send:send_to_sid(NewItemStatus1#item_status.pid, BinData),
					{reply, {ok, true}, NewItemStatus1};
				
				_ ->
					{reply, {ok, false}, NewItemStatus}
			end;
		{error, _Res} ->
			{reply, {ok, false}, ItemStatus}
	end;
			
%%物品强化
do_call({'item_streng', ItemPlace, StonePlace, GuardPlace, AKey, PetId, Copper, BindCopper, VipRate}, _From, ItemStatus) ->
	case lib_item:check_streng(ItemStatus, ItemPlace, StonePlace, PetId, Copper, BindCopper) of
		{ok, ItemInfo, StoneInfo, NeedCopper1} ->
			Result = if AKey =:= 1 ->
				[StrengNum, Result1] = lib_item:item_streng_akey(ItemStatus, ItemInfo, StoneInfo, StonePlace, GuardPlace, VipRate, Copper + BindCopper),
				NeedCopper = NeedCopper1 * StrengNum,
				Result1;
			true ->
				NeedCopper = NeedCopper1,
				lib_item:item_streng(ItemStatus, ItemInfo, StoneInfo, StonePlace, GuardPlace, VipRate)
			end,
			case Result of
				{Res, IsProtect, NewItemInfo,ItemInfoList, DeleteList, Level, NewItemStatus} ->
					if	PetId > 0 ->
							{ok, PetData} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [PetId, ?ITEM_PICK_NONE,[NewItemInfo], []]),
							lib_send:send_to_sid(NewItemStatus#item_status.pid, PetData),
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemInfoList, DeleteList]);
						true ->
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[NewItemInfo|ItemInfoList], DeleteList])
					end,					
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					%%增加属性更新
%% 					NewPlayerSatus = calc_update_properties1(ItemInfo,Pet, PlayerSatus),					
					{reply, {ok, NeedCopper, Res, IsProtect, Level, ItemInfo#ets_users_items.id,ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place}, NewItemStatus};
				_er ->
					?DEBUG("item streng error:~p",[_er]),			
					{reply, {error1}, ItemStatus}
			end;
		_e ->
			?DEBUG("item streng check_streng error:~p",[_e]),
			{reply, {error2}, ItemStatus}
	end;

%%修理装备
%% do_call({'mend', PlayerStatus, ItemPlace}, _From, ItemStatus) ->	
%% 	{reply, {error}, ItemStatus};


%%道具镶嵌
do_call({'enchase',[ ItemPlace, StonePlace, HolePlace,Copper,BindCopper, UserID, Level]}, _From, ItemStatus) ->
	case lib_item:check_enchase([ItemPlace, StonePlace, HolePlace,Copper,BindCopper,ItemStatus]) of
		{fail, Res} ->		
%%			[Item] = item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace),
			?DEBUG("check_enchase error:~p",[Res]),
			case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace) of
				[] ->
					ReturnItemId = 0;
				[ReturnItem] ->
					ReturnItemId = ReturnItem#ets_users_items.id
			end,	
            {reply, [Res, 0, ReturnItemId, 0,0], ItemStatus};   
			
		{ok, ReduceCopper, ItemInfo, StoneInfo} ->	
			case lib_item:enchase_item(ItemStatus, ItemInfo, StoneInfo, HolePlace, StonePlace, UserID, Level) of
				{ok, NewItemStatus, Res, ItemList, DeleteList} ->							
					%% 更新背包物品(装备+宝石)
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 					NewPlayerStatus = calc_update_properties(ItemInfo, PlayerStatus),				
                    {reply, [Res, ReduceCopper, ItemInfo#ets_users_items.id, ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place], NewItemStatus};				
                Error ->
                     ?WARNING_MSG("mod_item chenase:~p", [Error]),
					 {reply, [0, 0, 0, 0,0], ItemStatus}
			end;
		_err ->
			?WARNING_MSG("check_enchase error:~p",[_err]),
			{reply, [0, 0, 0, 0,0], ItemStatus}
	end;
	
%%道具宝石摘取
do_call({'pick_stone', [ ItemPlace, PickPlace, HolePlace, Copper, BindCopper, UserID, Level]}, _From, ItemStatus) ->
	case lib_item:check_pick_stone(ItemStatus, ItemPlace, HolePlace, Copper, BindCopper) of
		{error, _Res} ->
%%			[Item] = item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace),
			
			case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace) of
				[] ->
					ReturnItemId = 0;
				[ReturnItem] ->
					ReturnItemId = ReturnItem#ets_users_items.id
			end,	
			
			{reply, [0, 0, ReturnItemId, 0,0], ItemStatus};
		
		{ok, ItemInfo, StoneTempalte, StoneLevel, SuccRate, NeedCopper} ->
			case lib_item:pick_up_stone(ItemStatus, ItemInfo, StoneTempalte, StoneLevel, SuccRate, PickPlace, HolePlace, UserID, Level) of
				{ok, NewItemStatus, Res, ItemList, DeleteList} ->
					%% 更新背包物品信息
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 					NewPlayerStatus = calc_update_properties(ItemInfo, Pet,PlayerStatus),					
                    {reply, [Res, NeedCopper, ItemInfo#ets_users_items.id,  ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place], NewItemStatus};	
				
				{error, _Res} ->
					 ?DEBUG("mod_item pick up stone:~p", [_Res]),
					{reply, [0, 0, ItemInfo#ets_users_items.id, 0,0], ItemStatus};
				
				Error ->
					 ?DEBUG("mod_item pick up stone:~p", [Error]),
					 {reply, [0, 0, 0, 0,0], ItemStatus}
			end
	end;
					
%%道具合成
do_call({'item_compose', [FormuleId, Copper, ComposeNum]}, _From, ItemStatus) ->
	case lib_item:check_item_compose(ItemStatus, FormuleId, Copper, ComposeNum) of
		{error, _Res} ->
			{reply, [0, 0], ItemStatus};
		{ok, NeedCopper, FormulaTemp} ->					
			case lib_item:item_compose(ItemStatus, FormulaTemp, ComposeNum) of
				{ok, NewItemStatus, Res, ItemList, DeleteList} ->
					%% 更新背包物品信息
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),						
                    {reply, [Res, NeedCopper], NewItemStatus};	
				Error ->									
					 ?DEBUG("mod_item compose:~p", [Error]),
					 {reply, [[Error], 0], ItemStatus}
			end
	end;
%%装备品质提升
do_call({'item_upgrade', [PlayerStatus,PetId, ItemPlace,Material1,Material2,Material3,Copper]}, _From, ItemStatus) ->
	case lib_item:check_item_upgrade(ItemStatus,PetId,ItemPlace,Copper) of
		{error, _Res} ->
			?DEBUG("mod_item upgrade:~p", [_Res]),
			{reply, [0, 0, 0,0], ItemStatus};
		{ok, [ItemInfo,NewMaterialList,TargetId,NeedCopper]} ->					
			case lib_item:item_upgrade(ItemStatus, ItemInfo,NewMaterialList,TargetId) of
				{ok, NewItemStatus, Res, TargetItem, NewItemInfo, ItemList, DeleteList} ->
					if
						TargetItem#ets_item_template.quality > 3 ->
							gen_server:cast(ItemStatus#item_status.user_pid, {'chat_sysmsg_1',?_LANG_NOTICE_UPGRADE, 
										ItemInfo#ets_users_items.id, TargetItem#ets_item_template.template_id, TargetItem#ets_item_template.quality});
						true ->
							ok 
					end,
					if	PetId > 0 ->
							{ok, PetData} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [PetId, ?ITEM_PICK_NONE,[NewItemInfo], []]),
							lib_send:send_to_sid(NewItemStatus#item_status.pid, PetData),
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]);
						true ->
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[NewItemInfo|ItemList], DeleteList])
					end,					
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					item_util:calc_equip_num(PlayerStatus#ets_users.id , PlayerStatus),				
                    {reply, [Res, NeedCopper,  ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place], NewItemStatus};	
				Error ->									
					 ?DEBUG("mod_item upgrade:~p", [Error]),
					 {reply, [0, 0, 0,0], ItemStatus}
			end
	end;
%%装备等级提升
do_call({'item_uplevel', [PlayerStatus,PetId,ItemPlace,Material1,Material2,Material3,Copper]}, _From, ItemStatus) ->
	case lib_item:check_item_uplevel(ItemStatus,PetId,ItemPlace,Copper) of
		{error, _Res} ->
			?DEBUG("mod_item uplevel:~p", [_Res]),
			{reply, [0, 0, 0,0], ItemStatus};
		{ok, [ItemInfo,NewMaterialList,TargetId,NeedCopper]} ->	
			TargetItem = data_agent:item_template_get(TargetId),
			if TargetItem#ets_item_template.need_level > PlayerStatus#ets_users.level ->
				{reply, [0, 0, 0,0], ItemStatus};
			true ->			
				case lib_item:item_upgrade(ItemStatus, ItemInfo,NewMaterialList,TargetId) of
				{ok, NewItemStatus, Res, TargetItem, NewItemInfo, ItemList, DeleteList} ->
					if
						TargetItem#ets_item_template.need_level > 50 ->
							gen_server:cast(ItemStatus#item_status.user_pid, {'chat_sysmsg_1',?_LANG_NOTICE_UPLEVEL, 
										ItemInfo#ets_users_items.id, TargetItem#ets_item_template.template_id, TargetItem#ets_item_template.need_level});
						true ->
							skip
					end,
					if	PetId > 0 ->
							{ok, PetData} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [PetId, ?ITEM_PICK_NONE,[NewItemInfo], []]),
							lib_send:send_to_sid(NewItemStatus#item_status.pid, PetData),
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]);
						true ->
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[NewItemInfo|ItemList], DeleteList])
					end,
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,[{?TARGET_EQUIPMENT_UPGRADE,{TargetItem#ets_item_template.need_level,1}}]),						
                    {reply, [Res, NeedCopper, ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place], NewItemStatus};	
				Error ->									
					 ?DEBUG("mod_item uplevel:~p", [Error]),
					 {reply, [0, 0, 0,0], ItemStatus}
				end
			end
	end;

%%宝石合成
do_call({'stone_compose',[StoneId,ComposeNum,UseBind,Copper]}, _From, ItemStatus) ->
	case lib_item:check_stone_compose(ItemStatus, StoneId,ComposeNum,Copper) of
		{error, Res1} ->	
			?DEBUG("check_stone_compose error:~p",[Res1]),
			{reply, [0, 0], ItemStatus};
		{ok, ItemList, NeedCopper} ->
			case lib_item:item_stone_compose(ItemStatus, ItemList, ComposeNum * ?COMSTONE_STONE_NUM, UseBind) of
				{NewItemStatus, Res, IsLuck, ItemList1, DeleteList, NewInfo, Level} ->
					%% 更新背包物品信息
					if
						Level > 5 ->
							gen_server:cast(ItemStatus#item_status.user_pid, {'chat_sysmsg_compose', NewInfo#ets_users_items.id, NewInfo#ets_users_items.template_id});
						true ->
							ok 
					end,
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_STONE_COMPOSE,ItemList1, DeleteList]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
					[Temp|_] = ItemList,
					lib_statistics:add_compose_log(Temp#ets_users_items.template_id, Res, ComposeNum, IsLuck),
                    {reply, [Res, NeedCopper], NewItemStatus};	
				
				{error, _Res} ->
					?DEBUG("mod stone compose:~p", [_Res]),
					{reply, [0, 0], ItemStatus};
				
				Error ->									
					 ?DEBUG("mod stone compose:~p", [Error]),
					 {reply, [0, 0], ItemStatus}
			end
	end;	

%%宝石淬炼
do_call({'stone_quench',[StonePlace, QuenchPlace, Copper, YuanBao, IsYuanBao, IsBag, ItemPlace, HolePlace, UserID, Level]}, _From, ItemStatus) ->
	if IsBag =:= 1 ->
			%% 在背包里的宝石淬炼过程
			case lib_item:check_bag_stone_quench(ItemStatus, StonePlace, QuenchPlace, Copper, YuanBao, IsYuanBao) of
				{error, Res1} ->	
					?DEBUG("check_stone_quench error:~p",[Res1]),
					{reply, [0, 0, 0], ItemStatus};
				{ok, ItemList1, ItemList2, NeedCopper, NeedYuanBao, IsFine} ->
					case lib_item:item_bag_stone_quench(ItemStatus, ItemList1, ItemList2, IsYuanBao, IsFine) of
						{NewItemStatus, Res, ItemList, DeleteList, NewItemInfo, Level1} ->
							if	IsFine =:= 1 andalso Res =:= ?UNPERFECT_QUENCH ->
									skip;
							 	Res =:= ?PERFECT_QUENCH ->			
									if Level1 >= 3 ->
											gen_server:cast(ItemStatus#item_status.user_pid, {'chat_sysmsg_quench', NewItemInfo#ets_users_items.id, NewItemInfo#ets_users_items.template_id});
										true ->
											skip
									end;
								Res =:= ?UNPERFECT_QUENCH ->
									if Level1 >= 5 ->
											gen_server:cast(ItemStatus#item_status.user_pid, {'chat_sysmsg_quench', NewItemInfo#ets_users_items.id, NewItemInfo#ets_users_items.template_id});
										true ->
											skip
									end;
								true ->
									skip
							end,
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_QUENCH,ItemList, DeleteList]),
				    		lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
                    		{reply, [Res, NeedCopper, NeedYuanBao], NewItemStatus};					
						Error ->									
					 		?DEBUG("mod stone quench:~p", [Error]),
					 		{reply, [0, 0, 0], ItemStatus}
					end
			end;
		true ->
			%% 在装备上的宝石淬炼过程
			case lib_item:check_equip_stone_quench(ItemStatus, ItemPlace, HolePlace, QuenchPlace, Copper, YuanBao, IsYuanBao) of
				{error, Res1} ->	
					?DEBUG("check_stone_quench error:~p",[Res1]),
					{reply, [0, 0, 0], ItemStatus};
				{ok, ItemList, NeedCopper, NeedYuanBao} ->
					case lib_item:item_equip_stone_quench(ItemStatus, ItemList, ItemPlace, HolePlace, IsYuanBao, UserID, Level) of
						{NewItemStatus, Res, NewItemList, DeleteList} ->
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_QUENCH,NewItemList, DeleteList]),
				    		lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
                    		{reply, [Res, NeedCopper, NeedYuanBao], NewItemStatus};					
						Error ->									
					 		?DEBUG("mod stone quench:~p", [Error]),
					 		{reply, [0, 0, 0], ItemStatus}
					end
			end
	end;

%%精致宝石分解
do_call({'stone_decompose',[StonePlace, Copper]}, _From, ItemStatus) ->
	case lib_item:item_bag_stone_decompose(ItemStatus, StonePlace, Copper) of
		{NewItemStatus, Res, NeedCopper, ItemList, DeleteList} ->
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_DECOMPOSE, ItemList, DeleteList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
            {reply, [Res, NeedCopper], NewItemStatus};					
		Error ->									
			?DEBUG("mod stone decompose:~p", [Error]),
			{reply, [0, 0], ItemStatus}
	end;

%%装备分解
do_call({'item_decompose', ItemPlace, Copper, BindCopper}, _From, ItemStatus) ->
	case lib_item:check_decompose(ItemStatus, ItemPlace, Copper, BindCopper) of
		{error, _Res} ->
			{reply, [0, 0], ItemStatus};
		{ok, ItemInfo, SuccRate, NeedCopper, ItemTemp} ->
			case lib_item:item_decompse(ItemInfo, ItemPlace, SuccRate, ItemStatus, ItemTemp) of
				{NewItemStatus, Res, ItemList, DeleteList} ->
					%% 更新背包物品信息
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),						
                    {reply, [Res, NeedCopper], NewItemStatus};	
				Error ->									
					 ?DEBUG("mod_item decompose:~p", [Error]),
					 {reply, [[Error], 0], ItemStatus}
			end
	end;

%%装备融合 
do_call({'item_fusion', BulePlace, PurplePlace1, PurplePlace2,Copper, BindCopper}, _From, ItemStatus) ->
	case lib_item:check_item_fision(ItemStatus, BulePlace, PurplePlace1, PurplePlace2,Copper, BindCopper) of
		{error, _Res} ->
			{reply, [0], ItemStatus};
		{ok, BuleItemInfo, PurpleItemInfo1, PurpleItemInfo2} ->
			case lib_item:item_fision(ItemStatus,BuleItemInfo,PurpleItemInfo1,PurplePlace1,PurpleItemInfo2,PurplePlace2) of
				{NewItemStatus, ItemList, DeleteList} ->
					%% 更新背包物品信息
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),						
                    {reply, [1], NewItemStatus};
				Error ->									
					 ?DEBUG("mod_item fusion:~p", [Error]),
					 {reply, [0], ItemStatus}
			end
	end;

%%装备洗练Locks={LockPlace,Num}
do_call({'item_rebuild', PlayerStatus, PetId, ItemPlace, StonePlace, Locks, Copper, LockList}, _From, ItemStatus) ->	
	case lib_item:check_item_rebuild(PlayerStatus, ItemStatus, PetId, ItemPlace, StonePlace, Copper, Locks) of
		{error, _Res} ->
			case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace) of
				[] ->
					ReturnItemId = -1;
				[ReturnItem] ->
					ReturnItemId = ReturnItem#ets_users_items.id
			end,
			?DEBUG("mod_item rebuild error:~p", [_Res]),	
			{reply, [0, 0, ReturnItemId, 0,0,0], ItemStatus};
		
		{ok, ItemInfo, StoneInfo, NeedCopper, ItemTemplate} ->
			case lib_item:item_rebuild(ItemStatus, ItemInfo, StoneInfo, StonePlace, Locks, ItemTemplate, LockList) of
				{NewItemStatus, Res, NewItemInfo, ItemList, DeleteList} ->
					if	PetId > 0 ->
							{ok, PetData} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [PetId, ?ITEM_PICK_NONE,[NewItemInfo], []]),
							lib_send:send_to_sid(NewItemStatus#item_status.pid, PetData),
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]);
						true ->
							{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[NewItemInfo|ItemList], DeleteList])
					end,
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),		
                    {reply, [Res, NeedCopper, ItemInfo#ets_users_items.id,ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place, length(ItemInfo#ets_users_items.other_data#item_other.prop_list)], NewItemStatus};
				Error ->
					 ?DEBUG("mod_item rebuild error:~p", [Error]),
					 {reply, [[Error], 0, 0, 0,0,0], ItemStatus}
			end
	end;


%%替换洗炼属性
do_call({'item_replace_rebuild', PlayerStatus, PetId, Itemplace}, _From, ItemStatus) ->
	case lib_item:item_replace_rebuild(ItemStatus, PetId, Itemplace) of
		{error,ItemId,_Res} ->
			?DEBUG("mod_replace_rebuild :~p", [_Res]),
			{reply, [0, ItemId, 0,0], ItemStatus};
		{ok,ItemId,ItemInfo} ->
			if	PetId > 0 ->
					{ok, ItemData} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [PetId, ?ITEM_PICK_NONE,[ItemInfo], []]);
				true ->
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[ItemInfo], []])
			end,
			lib_send:send_to_sid(ItemStatus#item_status.pid, ItemData),		
			{reply, [1, ItemId, ItemInfo#ets_users_items.bag_type,ItemInfo#ets_users_items.place], ItemStatus}
	end;

%%装备移转
do_call({'item_transform',OpType,ItemPlace1,ItemPlace2,Copper}, _From, ItemStatus) ->
	case lib_item:check_item_transform(ItemStatus, OpType,ItemPlace1,ItemPlace2,Copper) of
		{error, _Res} ->	
			?DEBUG("mod_item transform:~p", [_Res]),
			{reply, [0, 0,0], ItemStatus};
		{ok, ItemInfo1, ItemInfo2, NeedCopper} ->			
			case lib_item:item_transform(ItemStatus, ItemInfo1, ItemInfo2, OpType) of
				{NewItemStatus, Res, ItemList,IsUpdate} ->
					
					%% 更新背包物品信息
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, []]),
				    lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),		
                    {reply, [Res, NeedCopper,IsUpdate], NewItemStatus};
				Error ->
					?DEBUG("mod_item transform:~p", [Error]),
					{reply, [[Error], 0,0], ItemStatus}
			end
	end;

%% 装备熔炼
do_call({'equip_fusion', ItemPlace1, ItemPlace2, ItemID3, Copper}, _From, ItemStatus) ->
	case lib_item:check_equip_funsion(ItemStatus, ItemPlace1, ItemPlace2, ItemID3, Copper) of
		{error, Res} ->
			?DEBUG("mod_item equip_fusion:~p", [Res]),
			{reply, [0, 0, 0], ItemStatus};
		{ok, ItemInfo1, ItemInfo2, ItemList1, Amount, NewItem_id, NeedCopper} ->
			case lib_item:equip_funsion(ItemStatus, ItemInfo1, ItemInfo2, ItemList1, Amount, NewItem_id) of
				{NewItemStatus, Res, ItemList, DeleteList, IsUpdate} ->
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					{reply, [Res, NeedCopper, IsUpdate], ItemStatus};
				Error ->
					?DEBUG("mod_item equip_fusion:~p", [Error]),
					{reply, [0, 0, 0], ItemStatus}
			end
	end;

%%查询人物样式信息
do_call({'style_info'}, _From, ItemStatus) ->
%% 		[_Attack, _Defense, StyleBin, _speed] = item_util:calc_equip_properties(ItemStatus#item_status.user_id,ItemStatus#item_status.user_pid),
%% 		{NewStyleBin,_NewSpeed1,Mounts} = item_util:update_stylebin(StyleBin),
		{reply, {ok}, ItemStatus};

%%添加邮件附件
do_call({'mail_item_add', ItemInfo}, _From, ItemStatus) ->
	[NewItemStatus, NewItemList, Res] = lib_item:mail_item_add(ItemStatus, ItemInfo),
	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,NewItemList, []]),
	lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
	{reply, {ok, Res}, NewItemStatus};

%%宠物到列表
do_call({'pet_to_list', ItemId}, _From, ItemStatus) ->
	case lib_item:pet_to_list(ItemStatus, ItemId) of 
		{ok, {NewItemStatus,  ItemInfo,Template,DeleteList}} ->
			%%更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[], DeleteList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
			{reply, {ok,ItemInfo,Template}, NewItemStatus};
		{error, _Reason} ->
			?WARNING_MSG("pet_to_list:~s",[_Reason]),
			{reply, error, ItemStatus};
		_ ->
			{reply, error, ItemStatus}
	end;

%%宠物到背包
%% do_call({'pet_to_bag', PetId}, _From, ItemStatus) ->
%% 	case lib_item:pet_to_bag(ItemStatus, PetId) of 
%% 		{ok, {NewItemStatus, ItemInfo}} ->
%% 			%%更新背包物品
%% 			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,[ItemInfo], []]),
%% 			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 			%%更新宠物
%% 			{ok, PetData} = pt_25:write(?PP_PET_LIST_UPDATE, [[],[PetId]]),
%% 			lib_send:send_to_sid(NewItemStatus#item_status.pid, PetData),
%% 			%%删去列表宠物
%% 			{reply, ok, NewItemStatus};
%% 		
%% 		{error, Reason} ->
%% 			?WARNING_MSG("pet_to_bag:~s",[Reason]),
%% 			{reply, error, ItemStatus};
%% 		
%% 		_ ->
%% 			{reply, error, ItemStatus}
%% 	end;

%%宠物出战
do_call({'pet_fight', PetId}, _From, ItemStatus) ->
	case lib_item:pet_fight(ItemStatus#item_status.user_id, PetId) of
		{ok, PetTemplateId, PetNick} ->
			{reply, {ok, PetTemplateId, PetNick}, ItemStatus};
		{error, Reason} ->
			?WARNING_MSG("pet_fight:~s",[Reason]),
			{reply, error, ItemStatus};
		_ ->
			{reply, error, ItemStatus}
	end;

%%宠物召回
do_call({'pet_call_back', PetId}, _From, ItemStatus) ->
	case lib_item:pet_call_back(ItemStatus#item_status.user_id, PetId) of
		ok ->
			{reply, ok, ItemStatus};
		{error, Reason} ->
			?WARNING_MSG("pet_call_back:~w",[Reason]),
			{reply, error, ItemStatus};
		_ ->
			{reply, error, ItemStatus}
	end;

%%拾取掉落物品，需要验证格子是不是够，返回true和false
%% do_call({'add_item', TemplateId, Amount, IsBind}, _From, State) ->
%% 	case lib_item:pick_up_item(TemplateId, Amount, IsBind, State) of
%% 		{fail, Reply} ->
%% 			{reply, Reply, State};
%% 		
%% 		{ok, Reply, ItemList, NewState} ->					
%% 			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, []]),
%% 			lib_send:send_to_sid(NewState#item_status.pid, ItemData),					
%% 			{reply, Reply, NewState}	
%% 	end;		

	
%%检查用户是否有对应物品，返回true和false
do_call({'check_item', TemplateId}, _From, State) ->
	Reply = lib_item:check_item_to_users(TemplateId, 1, State#item_status.user_id),
	{reply, Reply, State};


%%扣除物品,优先扣减绑定的物品 如果没有物品也 返回 ok
do_call({'reduce_item_to_users',TemplateId,Type}, _From, State) ->
	{true, NewItemStatus, ItemList, DelList} = lib_item:reduce_item_to_users(TemplateId, 1, State,Type),
	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
	lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
	{reply, ok, NewItemStatus};

%%检查用户是否有对应物品并扣除物品(优先扣减绑定的物品)  ,返回true和false
do_call({'check_and_reduce_item_to_users',TemplateId, Type}, _From, State) ->
	case lib_item:check_item_to_users(TemplateId, 1, State#item_status.user_id) of
		true ->
			{true, NewItemStatus, ItemList, DelList} = lib_item:reduce_item_to_users(TemplateId, 1, State, Type),
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			{reply, true, NewItemStatus};
		false ->
			{reply, false, State}
	end;

%% 扣除物品
do_call({'reduce_item_to_users_by_iteminfo',ItemInfo,Type}, _From, State) ->
	{true, NewState, DeleteList} = lib_item:reduce_item_to_info(ItemInfo,State,Type),
	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[], DeleteList]),
	lib_send:send_to_sid(NewState#item_status.pid, BinData),
	{reply, true, NewState};


%%  任务，必需先判断物品是否足够，扣除背包物品
do_call({'task_reduce_item', TargetObjects, TargetAmounts, IsBind}, _From, State) ->
	case lib_item:task_reduce_item(State, TargetObjects, TargetAmounts, IsBind) of
		{ok, NewState, ItemList, DelList} ->
			%% 更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, DelList]),
			lib_send:send_to_sid(NewState#item_status.pid, ItemData),
			{reply, true, NewState};
		{error, Reason} ->
			?WARNING_MSG("task_reduce_item is :~s", [Reason]),
			{reply, false, State}
	end;

%% 发布江湖令任务需要扣除对应的江湖令牌
do_call({publish_token_task, TemplateId},  _From, State) ->
	Amount = 1,
	case lib_item:check_item_to_users(TemplateId, Amount, State#item_status.user_id) of
		true ->
			{true, NewState, ItemList, DelList} =  lib_item:reduce_item_to_users(TemplateId, Amount, State,?CONSUME_ITEM_USE),
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
			lib_send:send_to_sid(NewState#item_status.pid, ItemData),
			{reply, true, NewState};
		_ ->
			{reply, false, State}
	end;

%% 寄售成功，删除背包物品
do_call({'delete_sale_item', ItemId, BagType}, _From, State) ->
	UserId = State#item_status.user_id,
	ItemInfo = item_util:get_user_item_by_id(UserId, ItemId),
	if
		is_record(ItemInfo, ets_users_items) =:= false ->
			NewState = State,
			Reply = {fail, ?_LANGUAGE_SALE_MSG_ERROR_ITEM_DATA};
		ItemInfo#ets_users_items.is_bind /= 0 ->
			NewState = State,
			Reply = {fail, ?_LANGUAGE_SALE_MSG_BIND_ITEM};
		true ->
			case item_util:get_item_name(ItemInfo#ets_users_items.template_id) of
				<<>> ->				
					NewState = State,
					Reply = {fail, ?_LANGUAGE_SALE_MSG_ERROR_ITEM_TEMPLATE};
				_Name ->
					NullCells = lists:sort([ItemInfo#ets_users_items.place|State#item_status.null_cells]),
					NewState = State#item_status{null_cells = NullCells},
					lib_item:change_item_bagtype(ItemInfo, BagType, -5, 0),
					Reply = {ok},
					{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[], [ItemInfo#ets_users_items.place]]),
					item_util:save_dic(),
					lib_send:send_to_sid(State#item_status.pid, BinData)
			end
	end,
	{reply, Reply, NewState};


%% PK红名死亡掉落物品
do_call({'drop_item_by_pk'}, _From, ItemState) ->
	case lib_item:item_drop_by_pk_death(ItemState, ItemState#item_status.user_id) of
		{error} ->
			{reply, [[], []], ItemState};
		
		{ok, NewItemState, ItemList, EquipList, DeleteList} ->
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,lists:append(ItemList, EquipList), DeleteList]),
			lib_send:send_to_sid(NewItemState#item_status.pid, ItemData),					
			{reply, [ItemList, EquipList], NewItemState}	
	end;

%% 邮件发送物品
do_call({'mail_send_item', Attach},  _From, ItemStatus) ->
	[ItemList,Items, NameList, NullCells] = lib_item:mail_send_items(ItemStatus#item_status.user_id, Attach, ItemStatus),
	NewNullCells = lists:append( NullCells, ItemStatus#item_status.null_cells),
	NewItemStatus = ItemStatus#item_status{
										   null_cells = NewNullCells
										   },
    {reply, [ItemList,Items, NameList], NewItemStatus};

%% 帮会放入
do_call({'guild_put_item',Place}, _From,ItemStatus) ->
	case lib_item:guild_warehouse_put_item(ItemStatus#item_status.user_id,Place) of
		{ok,CItemID,CPlace,CItem} ->
			NewNullCells = lists:append([CPlace], ItemStatus#item_status.null_cells),
			NewItemStatus = ItemStatus#item_status{
										   null_cells = NewNullCells
										   },
			{reply,{ok,CItemID,CPlace,CItem}, NewItemStatus };
		{false,Msg} ->
			{reply,{false,Msg}, ItemStatus}
	end;

%% 帮会取出
do_call({'guild_get_item', ItemInfo}, _From, ItemStatus) ->
	[NewItemStatus, NewItemList, _Res] = lib_item:guild_warehouse_get_item(ItemStatus, ItemInfo),
	%{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [NewItemList, []]),
	%lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
	{reply, {ok, NewItemList}, NewItemStatus};


%% 使用飞天鞋
do_call({'transfer_shoe_use', [MapId, Pos_X, Pos_Y, Vip_tranfer_shoes, RealVipID]}, _From, ItemStatus) ->
	if Vip_tranfer_shoes > 0 andalso RealVipID > 0 ->	%% vip鞋有剩余 且是vip
		   %%判断传送点是否能站立
			case lib_map:is_stand_pos_to_grid(MapId, Pos_X, Pos_Y) of
				true ->
					{reply, [1,Vip_tranfer_shoes - 1], ItemStatus};
				_ ->
					{reply, [0], ItemStatus}
			end;
	   true ->
		   case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?TRANSFER_SHOE_TEMPID) of
			   [] ->
				   {reply, [0], ItemStatus};
			   ItemInfo when(ItemInfo#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON)->
				   %%判断传送点是否能站立
				   case lib_map:is_stand_pos_to_grid(MapId, Pos_X, Pos_Y) of
					   true ->
						   {true, NewItemStatus, ItemList, DelList} = lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus,?CONSUME_ITEM_USE),
						   {ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
						   lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
						   {reply, [1], NewItemStatus};
					   _ ->
						   {reply, [0], ItemStatus}
				   end;
			   _ ->
				    {reply, [0], ItemStatus}
		   end
	end;

%% 使用VIP卡
do_call({'vip_card_use',Place},_From, ItemStatus) ->
	ItemInfos = item_util:get_user_item_by_place(ItemStatus#item_status.user_id, Place),
	case ItemInfos of
		[] ->
			{reply, {false,?_LANG_ERROR_ITEM_NONE},ItemStatus};
		[ItemInfo] ->
			Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			case Template#ets_item_template.category_id =:= ?CATE_VIPCARD of
				true ->
					NullCells = ItemStatus#item_status.null_cells,
					if
						erlang:length(NullCells) >= Template#ets_item_template.propert2 ->
							case data_agent:get_vip_template(Template#ets_item_template.propert1) of
								[] ->
									{reply, {false,?_LANG_OPERATE_ERROR}, ItemStatus};
								VipInfo ->
									{true, ItemStatus1, DelList} = lib_item:reduce_item_to_info(ItemInfo, ItemStatus,?CONSUME_ITEM_USE),
								
									F = fun({TemplateId,Num},{ItemStatus,ItemList}) ->
											case lib_item:pick_up_item(TemplateId, Num, 0, ItemStatus) of
												{fail, _Reply} ->
													{ItemStatus,ItemList};
												{ok, _Reply, ItemList1, NewItemStatus} ->
													{NewItemStatus,ItemList ++ ItemList1}
											end
										end,
									{NewItemStatus,ItemList} = lists:foldl(F, {ItemStatus1,[]}, VipInfo#ets_vip_template.items),
									{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, DelList]),
					 				lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
									{reply, {true,VipInfo}, NewItemStatus}
							end;
						true ->
							
							{reply, {false,?_LANG_VIP_BAG_FULL}, ItemStatus}
					end;
					
				_ ->
					{reply, {false,?_LANG_VIP_BAG_FULL}, ItemStatus}
			end
	end;
		
	

%% 强行宣战
%% do_call({'declear_guild_war'}, _From, ItemStatus) ->
%% 	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?DECLEAR_WAR_TEMPID) of
%% 		[] ->
%% 			{reply, [0], ItemStatus};
%% 		ItemInfo ->
%% 			{true, NewItemStatus, ItemList, DelList} = 
%% 				lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus),
%% 			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, DelList]),
%% 			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 			{reply, [1], NewItemStatus}
%% 	end;

%% %% 停战令
%% do_call({'stop_guild_war'}, _From, ItemStatus) ->
%% 	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?STOP_WAR_TEMPID) of
%% 		[] ->
%% 			{reply, [0], ItemStatus};
%% 		ItemInfo ->
%% 			{true, NewItemStatus, ItemList, DelList} = 
%% 				lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus),
%% 			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, DelList]),
%% 			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 			{reply, [1], NewItemStatus}
%% 	end;

%% %% 贡献令
%% do_call({'contribution',Number}, _From, ItemStatus) ->
%% 	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?CONTRIBUTION_TEMPID) of
%% 		[] ->
%% 			{reply, [0], ItemStatus};
%% 		ItemInfo ->
%% 			if ItemInfo#ets_users_items.amount >= Number ->
%% 				   {true, NewItemStatus, ItemList, DelList} = 
%% 					   lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, Number, ItemStatus),
%% 				   {ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, DelList]),
%% 				   lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 				   {reply, [1], NewItemStatus};
%% 			   true ->
%% 				   {reply, [0], ItemStatus}
%% 			end
%% 	end;
	


do_call({'get_item_info_by_place', Place}, _From, ItemStatus) ->
	ItemInfo = item_util:get_user_item_by_place(ItemStatus#item_status.user_id, Place),
	{reply, ItemInfo, ItemStatus};


do_call({'get_item_by_itemid', ItemId}, _From, ItemStatus) ->
	ItemInfo = item_util:get_user_item_by_id(ItemStatus#item_status.user_id, ItemId),
	
	item_util:delete_dic_thorough(ItemInfo),
	
	{reply, ItemInfo, ItemStatus};

do_call({'get_null_cells'}, _From, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	{reply, NullCells, ItemStatus};

%% 根据物品模板ID获取物品数量
do_call({'count_by_tempId', TemplateId}, _From, ItemStatus) ->
	Count = item_util:get_count_by_templateid(ItemStatus#item_status.user_id, TemplateId),
	{reply, Count, ItemStatus};

%% 判断物品是否绑定、是的话扣除物品
%% do_call({'is_item_not_bind', TemplateId}, _From, ItemStatus) ->
%% 	IsBind = 
%% 		case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, TemplateId) of
%% 	    	[] ->
%% 				error;
%% 			ItemInfo when ItemInfo#ets_users_items.is_bind =:= 0 ->
%% 				Amount = 1,
%% 				case lib_item:check_item_to_users(TemplateId, Amount, ItemStatus#item_status.user_id) of
%% 					true ->
%% 						{true, NewItemStatus, ItemList, DelList} = lib_item:reduce_item_to_users(TemplateId, Amount, ItemStatus),
%% 						{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, DelList]),
%% 						lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData);
%% 					_ ->
%% 						skip
%% 				end,
%% 				true;
%% 			_ ->
%% 				false
%% 		end,
%% 	{reply, IsBind, ItemStatus};


%%开宝箱
do_call({'open_box_in_yuanbao', YuanBao, Career, Box_Type, NickName}, _From, ItemStatus) ->
	case lib_item:open_box_in_yuanbao(YuanBao, Career, Box_Type, NickName, ItemStatus) of
		{ok, NewItemStatus, ItemList, NeedYuanBao, ToCDate,ItemList1, DelList} ->	
			
			{ok, BinData1} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_PET_BOOK_SEAL,ItemList1, DelList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData1),
			
			%%发送数据给客户端
			{ok, BinData} = pt_14:write(?PP_OPEN_BOX_SINGLE, [ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
					
			%%临时显示数据
			{ok, Bin} = pt_14:write(?PP_BOX_CLIENT_DATA, [ToCDate, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, Bin),

			ItemList_String = lists:foldl(fun(Info, ItemList_String) ->
						lists:concat([ItemList_String, '|', Info#ets_users_items.template_id])
				end, "", ItemList),		
			{reply, {ok, NeedYuanBao, ItemList_String}, NewItemStatus};
		_ ->
			{reply, {error}, ItemStatus}
	end;

%%宠物封印技能
do_call({'pet_book_seal', TemplateId},_From, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	case length(NullCells) > 0 of
		true ->
%% 			case lib_item:check_item_to_users(?ITEM_PET_SKILL_SEAL, 1, ItemStatus#item_status.user_id) of
%% 				true ->
					{true, NewItemStatus, ItemList, DelList} = lib_item:reduce_item_to_users(TemplateId, 1, ItemStatus,?CONSUME_ITEM_USE),
					case lib_item:pick_up_item(TemplateId, 1, ?BIND, NewItemStatus) of
						{fail, _Reply} ->
							{reply,{false,?_LANG_DAILY_AWARD_ITEM_ERROR}, NewItemStatus};
						{ok, _Reply, ItemList1, NewItemStatus1} ->
							{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_PET_BOOK_SEAL,ItemList1 ++ ItemList, DelList]),
							 lib_send:send_to_sid(NewItemStatus1#item_status.pid, BinData),
							{reply, true, NewItemStatus1}
					end;
%% 				false ->
%% 					{reply, {false,?_LANG_PET_ERROR_SEAL_NONE}, ItemStatus}
%% 			end;
		_ ->
			{reply, {false,?_LANG_DAILY_AWARD_ITEM_ERROR}, ItemStatus}
	end;
		




do_call({'mounts_stairs_lvup', PlayerStatus, ID}, _From, State) ->
	case lib_mounts:mounts_stairs_lvup(PlayerStatus, State,ID) of
		{ok,NeedCopper,Re,NewItemStatus} ->
		  	{reply, {ok,NeedCopper,Re}, NewItemStatus}; 
		{ok,NeedCopper,NewItemStatus} ->
		  	{reply, {ok,NeedCopper,0}, NewItemStatus}; 
		_ ->
			{reply, false, State}
	end;

do_call({'mounts_grow_up_lvup', PlayerStatus,IsProt,ID}, _From, State) ->
	case lib_mounts:mounts_grow_up_lvup(PlayerStatus, State,IsProt,ID) of
		{ok,NeedCopper,NewItemStatus} ->
		  	{reply, {ok,NeedCopper}, NewItemStatus}; 
		_ ->
			{reply, false, State}
	end;

do_call({'mounts_qualification_lvup', PlayerStatus,IsProt,ID}, _From, State) ->
	case lib_mounts:mounts_qualification_lvup(PlayerStatus,State,IsProt, ID) of
		{ok,NeedCopper,NewItemStatus} ->
		  	{reply, {ok,NeedCopper}, NewItemStatus}; 
		_ ->
			{reply, false, State}
	end;

do_call({mounts_refined_update, PlayerStatus, ID, IsYuanBao}, _From, State) ->
	case lib_mounts:mounts_refined_update(PlayerStatus, ID, IsYuanBao) of
		{ok, NeedCopper, NeedYuanBao} ->
			{reply, {ok, NeedCopper, NeedYuanBao}, State};
		_ ->
			{reply, false, State}
	end;

do_call({'ref_skill_book', PlayerStatus, Type}, _From, State) ->
	case lib_mounts:ref_skill_book(PlayerStatus, Type) of
		{ok,PlayerStatus1,ReduceYuanBao, ReduceBindYuanBao} ->
		  	{reply, {ok,PlayerStatus1,ReduceYuanBao, ReduceBindYuanBao}, State}; 
		_ ->
			{reply, false, State}
	end;
	
do_call({'get_skill_book',  PlayerStatus, Place}, _From, State) ->
	case lib_mounts:get_skill_book(PlayerStatus, Place,State) of
		{ok,PlayerStatus1,NewItemStatus} ->
		  	{reply, {ok,PlayerStatus1}, NewItemStatus}; 
		_ ->
			{reply, false, State}
	end;

do_call({'seal_skill',  PlayerStatus, ID,SkillGroupID}, _From, State) ->
	case lib_mounts:seal_skill(PlayerStatus,State, ID,SkillGroupID) of
		{ok,NewItemStatus} ->
		  	{reply, {ok}, NewItemStatus}; 
		_ ->
			{reply, false, State}
	end;

do_call({'delete_skill',  PlayerStatus, ID,SkillGroupID}, _From, State) ->
	case lib_mounts:delete_skill(PlayerStatus, ID,SkillGroupID) of
		{ok} ->
		  	{reply, {ok}, State}; 
		_ ->
			{reply, false, State}
	end;

do_call({'get_mounts_info', ID}, _From, State) ->
	case lib_mounts:get_mounts_by_id(ID) of
		[] ->
		  	{reply, false, State}; 
		Info ->
			{reply, {ok,Info}, State}
	end;

do_call({'get_fight_mounts'}, _From, State) ->
	case lib_mounts:get_fight_mounts_info() of
		{false}->
		  	{reply, {false}, State}; 
		{ok,Info} ->
			{reply, {ok,Info}, State}
	end;

%%神秘商店商品主动刷新
do_call({'smshop_ref',PlayerStatus}, _From, State) ->
	case lib_item:smshop_ref(PlayerStatus,State#item_status.smshop_info) of
		{ok,NewInfo,ReduceYuanbao} ->
			db_agent_item:update_smshop_info(NewInfo),
			NewState = State#item_status{smshop_info = NewInfo},
			{reply,{ok,NewInfo,ReduceYuanbao},NewState}; 
		{false,Msg} ->
			{reply,{false,Msg},State}; 
		_ ->
			{reply, false, State}
	end;

%%神秘商店商品购买
do_call({'smshop_buy',PlayerStatus,Place}, _From, State) ->
	case lib_item:smshop_buy(PlayerStatus,State#item_status.smshop_info,Place,State) of
		{ok,_UpdateInfo,NewInfo,Template,Bind,Amount,ReduceYunBao,ReduceCopper} ->
			%%物品叠加  判断生成物品的绑定类型	
			if
				Template#ets_item_template.bind_type =:= ?BIND_TYPE_1 orelse  Bind =:= ?BIND_TYPE_1 ->
					BindFlag = ?BIND;
				true ->
					BindFlag = ?NOBIND
			 end,
			
			{NewState, ItemList, _} = lib_item:add_item_amount_summation(Template, Amount, State, [], BindFlag, ?CANSUMMATION),
			%%更新背包物品
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(State#item_status.pid, ItemData),
			
			db_agent_item:update_smshop_info_item(NewInfo),
			NewState1 = NewState#item_status{smshop_info = NewInfo},
			
			{reply,{ok,[NewInfo,ReduceYunBao,ReduceCopper,Template#ets_item_template.template_id,Amount]},NewState1}; 
		{false,Msg} ->
			{reply,{false,Msg},State}; 
		_ ->
			{reply, false, State}
	end;

  
  

%% 使用玫瑰花
do_call({'rose_play',PlayerStatus,UserId, Type, Amount,IsAuto}, _From, State) ->
	case lib_item:rose_play(PlayerStatus,UserId,Type, Amount,IsAuto,State) of
		{ok,NewState,TotalAmity,TmpYuanbao} ->
			{reply, {ok,TotalAmity,TmpYuanbao}, NewState}; 
		{ok,NewState,TotalAmity} ->
			{reply, {ok,TotalAmity}, NewState}; 
		{false,Msg} ->
			{reply, {false,Msg}, State}
	end;

  

do_call(Info, _, State) ->
	?WARNING_MSG("mod_item call is not match:~w",[Info]),
    {reply, ok, State}.


%%------------------------------------------------------------
%% 装备更新
%% calc_update_properties(ItemInfo,Pet, PlayerStatus) ->
%% 	if
%% 						ItemInfo#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso ItemInfo#ets_users_items.place < ?BAG_BEGIN_CELL ->
%%  							[Record, StyleBin] = item_util:calc_equip_properties(PlayerStatus#ets_users.id, PlayerStatus#ets_users.other_data#user_other.pid_target),
%% 							{NewStyleBin,Mounts} = item_util:update_stylebin(StyleBin,
%% 													 PlayerStatus#ets_users.other_data#user_other.weapon_state,
%% 													 PlayerStatus#ets_users.other_data#user_other.cloth_state),
%% 							NewPlayerSatus = lib_player:calc_properties(PlayerStatus, Record, NewStyleBin,  Mounts,Pet),
%% 							{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerSatus),
%% 							lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
%% 							NewPlayerSatus;
%% 						true ->
%% %% 							?DEBUG("replace_rebuild Item Info bag:~p",[ItemInfo]),
%% 							PlayerStatus
%% 	end.


%% calc_update_properties1(ItemInfo,Pet, PlayerStatus) ->
%% 	if
%% 						ItemInfo#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso ItemInfo#ets_users_items.place < ?BAG_BEGIN_CELL ->
%% 							[Record, StyleBin] = item_util:calc_equip_properties(PlayerStatus#ets_users.id, PlayerStatus#ets_users.other_data#user_other.pid_target),
%% 							{NewStyleBin,Mounts} = item_util:update_stylebin(StyleBin,
%% 													 PlayerStatus#ets_users.other_data#user_other.weapon_state,
%% 													 PlayerStatus#ets_users.other_data#user_other.cloth_state),
%% 							NewPlayerSatus = lib_player:calc_properties(PlayerStatus, Record, NewStyleBin,  Mounts,Pet),
%% 							{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerSatus),
%% 							lib_send:send_to_sid(NewPlayerSatus#ets_users.other_data#user_other.pid_send, PlayerBin),
%% 							
%% 							{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerSatus]),
%% 								%%样式广播周围玩家
%% 								mod_map_agent:send_to_area_scene(
%% 								  NewPlayerSatus#ets_users.current_map_id,
%% 								  NewPlayerSatus#ets_users.pos_x,
%% 								  NewPlayerSatus#ets_users.pos_y,
%% 								  PlayerScenBin),
%% 							
%% 							NewPlayerSatus;
%% 						true ->
%% 							PlayerStatus
%% 	end.


%%---------------------do_cast--------------------------------

do_cast({apply_cast, Module, Method, Args}, State) ->
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_item__apply_cast error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State};

do_cast({put_item_in_guild_warehouse,NickName,UserID,GuildID,Place,PidSend}, ItemStatus) ->
	PID = mod_guild:get_mod_guild_pid(),
	case gen_server:call(PID, {put_item_in_guild_warehouse,GuildID,UserID}) of
		{ok} ->
			case lib_item:guild_warehouse_put_item(ItemStatus#item_status.user_id,Place) of
				{ok,CItemID,CPlace,CItem} ->
					gen_server:call(PID, {put_item_in_guild_warehouse_refresh,
											 NickName,
											 GuildID, 
											 UserID, 
											 CItemID,
											 CItem#ets_users_items.template_id,
											 CItem, 
											 PidSend}),
					NewNullCells = lists:append([CPlace], ItemStatus#item_status.null_cells),
					NewItemStatus = ItemStatus#item_status{null_cells = NewNullCells},
					{ok,DataBin2} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[], [Place]]),		%%更新背包
					lib_send:send_to_sid(PidSend, DataBin2),
					{noreply, NewItemStatus};
				{false,Msg} ->
					lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,Msg]),
					{noreply, ItemStatus}
			end;
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,Msg]),
			{noreply, ItemStatus}
	end;

%% do_cast({get_item_in_guild_warehouse,NickName,ID,ClubID,ItemID,PidSend}, ItemStatus) ->
%% 	case db_agent_item:get_item_by_itemid(ItemID) of
%% 		[] ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,?_LANG_GUILD_ERROR_WAREHOUSE_NOT_ITEM]),
%% 			{noreply, ItemStatus};
%% 		I ->
%% 			%% todo增加对物品现在状态的判断
%% 			ItemInfo = list_to_tuple([ets_users_items | I]),
%% 			NewItemInfo = ItemInfo#ets_users_items{is_bind = 1,other_data=#item_other{}},	%%取出后会绑定
%% 			PID = mod_guild:get_mod_guild_pid(),
%% 			case gen_server:call(PID,{get_item_in_guild_warehouse, ID, ClubID, NewItemInfo#ets_users_items.id, NewItemInfo#ets_users_items.amount, PidSend}) of
%% 				{ok} ->
%% 					[NewItemStatus, NewItemList, _Res] = lib_item:guild_warehouse_get_item(ItemStatus, NewItemInfo),
%% 					 case length(NewItemList) of 
%% 					   0 ->
%% 						 	lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,?_LANG_GUILD_ERROR_BAG_MAX]),
%% 							{noreply, ItemStatus};
%% 					   _ ->
%% 						   gen_server:call(PID, {get_item_in_guild_warehouse_refresh,
%% 												 ItemID,
%% 												 ItemInfo#ets_users_items.template_id,
%% 												 NewItemInfo#ets_users_items.amount,
%% 												 ClubID,
%% 												 ID,
%% 												 NickName,
%% 												 PidSend}),					%%堵塞本进程保证同步
%% 						   {ok,DataBin2} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [NewItemList, []]),		%%更新背包
%% 						   lib_send:send_to_sid(PidSend, DataBin2),  
%% 						   {noreply, NewItemStatus}
%% 				   end;
%% 				{false, Msg} ->
%% 					lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,Msg]),
%% 					{noreply, ItemStatus}
%% 			end
%% 	end;

do_cast({add_item_send_mail, Template,Amount,IsBind}, ItemStatus) ->
	case is_record(Template, ets_item_template) of
		true ->
			MailItemList = lib_item:add_item_send_mail(Template,Amount,IsBind,[]),
			lib_mail:send_GM_items_to_mail([MailItemList, "",ItemStatus#item_status.user_id, ?_LANG_MAIL_FULL_BAG_ITEM_TITLE, ?_LANG_MAIL_FULL_BAG_ITEM_CONTENT]);
		false ->
			skip
	end,
	{noreply, ItemStatus};
%% 停战
do_cast({club_war_stop,TargetGuildID,PageIndex,PageSize,GuildID,UserID,PidSend}, ItemStatus) ->
	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?STOP_WAR_TEMPID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,?_LANG_GUILD_ERROR_NO_STOP_ITEM]),
			{noreply, ItemStatus};
		ItemInfo ->
			case gen_server:call(mod_guild:get_mod_guild_pid(),{club_war_stop,
															   TargetGuildID,
															   PageIndex,
															   PageSize,
															   GuildID,
															   UserID,
															   PidSend}) of
				{ok} ->
					{true, NewItemStatus, ItemList, DelList} = 
						lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus,?CONSUME_ITEM_USE),
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					{noreply, NewItemStatus};
				_ ->
					{noreply, ItemStatus}
			end
	end;

%% 强行宣战
do_cast({club_war_declear,TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend}, ItemStatus) ->
	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?DECLEAR_WAR_TEMPID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,?_LANG_GUILD_ERROR_NO_DECLEAR_ITEM]),
			{noreply, ItemStatus};
		ItemInfo ->
			case gen_server:call(mod_guild:get_mod_guild_pid(), {club_war_declear,
																 TargetGuildID,
																 DeclearType,
																 PageIndex,
																 PageSize,
																 GuildID,
																 UserID,
																 PidSend}) of
				{ok} ->
					{true, NewItemStatus, ItemList, DelList} = 
						lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus,?CONSUME_ITEM_USE),
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					{noreply, NewItemStatus};
				_ ->
					{noreply, ItemStatus}
			end
	end;

%% %% 贡献令
%% do_cast({contribution,UserID,GuildID,UserName,Type,Number,PidSend}, ItemStatus) ->
%% 	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?CONTRIBUTION_TEMPID) of
%% 		[] ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE, ?_LANG_GUILD_ERROR_NO_CONTRIBUTION_ITEM]),
%% 			{noreply, ItemStatus};
%% 		ItemInfo ->
%% 			if ItemInfo#ets_users_items.amount >= Number ->
%% 				   case gen_server:call(mod_guild:get_mod_guild_pid(), {contribution,
%% 																		UserID,
%% 																		GuildID,
%% 																		UserName,
%% 																		Type,
%% 																		Number,
%% 																		PidSend}) of
%% 					   {ok} ->
%% 						   {true, NewItemStatus, ItemList, DelList} = 
%% 							   lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, Number, ItemStatus),
%% 						   {ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList, DelList]),
%% 						   lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
%% 						   {noreply, NewItemStatus};
%% 					   _ ->
%% 						   {noreply, ItemStatus}
%% 				   end;
%% 			   true ->
%% 				   lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE, ?_LANG_GUILD_ERROR_NO_CONTRIBUTION_ITEM]),
%% 				   {noreply, ItemStatus}
%% 			end
%% 	end;

%% 建帮令
do_cast({create_guild,Name,Declear,CreateType,PidSend,Pid,GuildID,NickName,Career,Sex,Level,VipId,UserID}, ItemStatus) ->
	case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, ?CREATE_GUILD_CARD_TEMPID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE, ?_LANG_GUILD_ERROR_NO_CREATE_CARD_ITEM]),
			{noreply, ItemStatus};
		ItemInfo when(ItemInfo#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso ItemInfo#ets_users_items.amount >= 1) ->
			   case gen_server:call(mod_guild:get_mod_guild_pid(), {create_guild,
																	Name,
																	Declear,
																	CreateType,
																	PidSend,
																	Pid,
																	GuildID,
																	NickName,
																	Career,
																	Sex,
																	Level,
																	VipId,
																	UserID}) of
				   {ok} ->
					   {true, NewItemStatus, ItemList, DelList} = 
						   lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus,?CONSUME_ITEM_USE),
					   {ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
					   lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					   {noreply, NewItemStatus};
				   _ ->
					   {noreply, ItemStatus}
			   end;
		_ ->
			{noreply, ItemStatus}
	end;


%%获得个人身上所有物品
do_cast({'query_all'}, ItemStatus) ->
	List = item_util:get_item_list(ItemStatus#item_status.user_id, ?BAG_TYPE_COMMON),
	%%更新背包物品
	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,List,[]]),
	lib_send:send_to_sid(ItemStatus#item_status.pid, BinData),
	{noreply, ItemStatus};

%%获取仓库所有物品
do_cast({'depot_all'}, ItemStatus) ->
	List = item_util:get_depot_bag_list(ItemStatus#item_status.user_id),
	%%更新背包物品
	{ok, BinData} = pt_14:write(?PP_DEPOT_ITEM_UPDATE, [List, []]),
	lib_send:send_to_sid(ItemStatus#item_status.pid, BinData),
	{noreply, ItemStatus};

%%获取箱子所有物品
do_cast({'get_box_all_data'}, ItemStatus) ->
	ItemList = item_util:get_item_list(ItemStatus#item_status.user_id, ?BAG_TYPE_BOX),
	{ok, BinData} = pt_14:write(?PP_BOX_ALL_DATA, [ItemList, []]),
	lib_send:send_to_sid(ItemStatus#item_status.pid, BinData),
	{noreply, ItemStatus};

%%移动箱子物品到背包
do_cast({'move_box_data', Type, ItemId}, ItemStatus) ->
	case lib_item:move_boxitem_to_bag(Type, ItemId, ItemStatus) of
		{error, NewType} ->
			{ok, BinData} = pt_14:write(?PP_MOVE_BOX_DATA, [0, NewType, ItemId]),
			lib_send:send_to_sid(ItemStatus#item_status.pid, BinData),
			{noreply, ItemStatus};
		
		{ok, NewType, ItemList, NewItemStatus} ->		
			%%更新背包物品
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			
			{ok, Bin} = pt_14:write(?PP_MOVE_BOX_DATA, [1, NewType, ItemId]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, Bin),
			{noreply, NewItemStatus};
		_ ->
			{noreply, ItemStatus}
	end;
			

%% 完成交易，增加物品，增加空格
do_cast({'trade', ItemList, Nulls}, State) ->
	FNull = fun(Place, [UserId]) ->
%%					item_util:delete_dic(UserId, Place),
					
					[UserId]
			end,
	[_] = lists:foldl(FNull, [State#item_status.user_id], Nulls),
	
	F = fun(Item, [NewItemList, [Cell|NewNullCells]]) ->
				 NewItem = lib_item:change_item_owner(Item, Cell),
				 [[NewItem|NewItemList], NewNullCells]
		end,
	[NewItemList, NewNullCells] = lists:foldl(F, [[], State#item_status.null_cells], ItemList),
	NewState = State#item_status{null_cells = Nulls ++ NewNullCells},
	
	{ok, BinData2} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,NewItemList, Nulls]),
	lib_send:send_to_sid(NewState#item_status.pid, BinData2),

	{noreply, NewState};

%%更新背包空格
%% do_cast({'update_state', NullCells}, ItemStatus) ->
%% 	NewNullCells = NullCells ++ ItemStatus#item_status.null_cells,
%% 	NewItemStatus = ItemStatus#item_status{null_cells = NewNullCells},
%% 	{noreply, NewItemStatus};

%%物品移动 
do_cast({'move', FromBagType, FromPlace, ToBagType, ToPlace, Amount}, State) ->
	case lib_item:move_item_test(State, FromPlace, FromBagType, ToPlace, ToBagType, Amount) of	
		{ok, NewState, ItemList, DeleteList, DepotItemList, DepotDeleteList} ->
			%%更新背包物品
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
		    lib_send:send_to_sid(NewState#item_status.pid, BinData),
			%%更新仓库物品
			{ok, DepotBinData} = pt_14:write(?PP_DEPOT_ITEM_UPDATE, [DepotItemList, DepotDeleteList]),
		    lib_send:send_to_sid(NewState#item_status.pid, DepotBinData),
			{noreply, NewState};
		{common_bag, NewState, ItemList, DeleteList} ->
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
		    lib_send:send_to_sid(NewState#item_status.pid, BinData),
			{noreply, NewState};
		{depot_bag, NewState, ItemList, DeleteList} ->
			{ok, BinData} = pt_14:write(?PP_DEPOT_ITEM_UPDATE, [ItemList, DeleteList]),
		    lib_send:send_to_sid(NewState#item_status.pid, BinData),
			{noreply, NewState};
		_ ->
			{noreply, State}
	end;

%%背包整理
do_cast({'array_item', MaxCell, BagType}, ItemStatus) ->
	case lib_item:array_item(ItemStatus, MaxCell, BagType) of
		{common_bag, NewState, ItemList, DeleteList} ->
			%?DEBUG("dhwang_test--array_item common_bag:~p",[DeleteList]),
			%%更新背包物品
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DeleteList]),
			lib_send:send_to_sid(NewState#item_status.pid, BinData),
			{noreply, NewState};
		{store_bag, NewState, ItemList, DeleteList} ->
			%%更新仓库物品
			{ok, BinData} = pt_14:write(?PP_DEPOT_ITEM_UPDATE, [ItemList, DeleteList]),
			lib_send:send_to_sid(NewState#item_status.pid, BinData),
			{noreply, NewState};
		_ ->
			{noreply, ItemStatus}
	end;

%%道具拆分
do_cast({'spilt_item', Place, Count}, ItemStatus) ->
	case lib_item:split_item(ItemStatus, Place, Count) of
		{ok, NewItemStatus, ItemList} ->
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			{noreply, NewItemStatus};
		_ ->
			{noreply, ItemStatus}
	end;
%% 任务奖励
do_cast({'task_award', TaskAwards}, ItemStatus) ->
	case lib_item:add_task_award(ItemStatus, TaskAwards) of
		{ok, NewState, ItemList} ->
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_TASK_AWARD,ItemList,[]]),
			lib_send:send_to_sid(ItemStatus#item_status.pid, BinData),
			{noreply, NewState};
		_ ->
			{noreply, ItemStatus}
	end;
			

										
%%减少当前装备的物品的耐久
do_cast({'reduce_equip_item_durable', Percent}, ItemStatus) ->
	case lib_item:reduce_equip_durable(ItemStatus, Percent) of
		{ok, NewEquipList, NewItemStatus} ->					
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,NewEquipList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			{noreply, NewItemStatus};

		_ ->
			{noreply, ItemStatus}
	end;

%%减少物品数量  根据物品模板ID,数量
do_cast({'reduce_item_in_commonbag', TemplateId, Amount,Type}, ItemStatus) ->
	case lib_item:check_item_to_users(TemplateId, Amount, ItemStatus#item_status.user_id) of
		true ->
			{true, NewItemStatus, ItemList, DelList} = lib_item:reduce_item_to_users(TemplateId, Amount, ItemStatus,Type),
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			{noreply, NewItemStatus};
		
		_ ->
			{noreply, ItemStatus}
	end;

%% 查询物品
do_cast({'item_refer', Pid_send, ItemId}, ItemStatus) ->
	case item_util:get_user_item_by_id(ItemStatus#item_status.user_id, ItemId) of
		[] ->
			skip;
		Item ->
			{ok, BinData} = pt_14:write(?PP_ITEM_REFER, Item),
			lib_send:send_to_sid(Pid_send, BinData)
	end,	
	{noreply, ItemStatus};

do_cast({'collect_add_item', ItemID, Amount, NickName}, ItemStatus) ->
	if
		Amount >= ?MINAMOUNT andalso Amount < ?MAXAMOUNT ->
			case data_agent:item_template_get(ItemID) of
						[] ->
							{noreply, ItemStatus};
						ItemTemplate ->
							NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
							if
								NeedCellNum > erlang:length(ItemStatus#item_status.null_cells)->
									Is_bind = 1, 
									ItemInfo = item_util:create_new_item(ItemTemplate, Amount, 0, 0,
												Is_bind,0,?BAG_TYPE_MAIL),
									MailItem = item_util:add_item_and_get_id(ItemInfo),
%% 									Content = [lists:concat([binary_to_list(ItemTemplate#ets_item_template.name), '*', Amount])],
									lib_mail:send_sys_mail(NickName, ItemStatus#item_status.user_id,NickName, ItemStatus#item_status.user_id ,[MailItem],
												   ?MAIL_TYPE_COLLECT_ITEM, ?_LANG_MAIL_COLLENT_TITLE, "  ", 0, 0, 0, 0),
									{ok, ItemData} = pt_20:write(?PP_PLAYER_COLLECT, 0),
									lib_send:send_to_sid(ItemStatus#item_status.pid, ItemData),
									{noreply, ItemStatus};
								true ->
									{NewState, ItemList, _} = lib_item:add_item_amount_summation(ItemTemplate, Amount, ItemStatus, [], ?BIND, ?CANSUMMATION),
									%%更新背包物品
									{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SCENE,ItemList, []]),
									lib_send:send_to_sid(ItemStatus#item_status.pid, ItemData),
									{noreply, NewState}
							end
			end;
		true ->
			{noreply, ItemStatus}
	end;
%%拾取掉落物品，需要验证格子是不是够，返回true和false
do_cast({'add_item', TemplateId, Amount, IsBind, MapPid, DropItemID}, ItemStatus) ->
	case lib_item:pick_up_item(TemplateId, Amount, IsBind, ItemStatus) of
		{fail, Reply} ->
			gen_server:cast(MapPid,{get_item_result,Reply, DropItemID}),
			{noreply,ItemStatus};
		{ok, Reply, ItemList, NewItemStatus} ->					
			gen_server:cast(MapPid,{get_item_result,Reply,DropItemID}),
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SCENE,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),					
			{noreply,  NewItemStatus}	
	end;	
%% 增加物品
do_cast({'add_item', TemplateId, Amount, IsBind, AddType}, ItemStatus) ->
	case lib_item:add_item(TemplateId, Amount, IsBind, AddType, ItemStatus) of
		{fail, _} ->
			{noreply,ItemStatus};
		{ok, _Reply, ItemList, NewItemStatus} ->	
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [AddType,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),					
			{noreply,  NewItemStatus}
	end;
%% 增加物品背包满时邮件发送
do_cast({add_item_or_mail, ItemID, Amount, IsBind, NickName, AddType}, ItemStatus) ->
	case lib_item:pick_up_item(ItemID, Amount, IsBind, ItemStatus) of
		{fail, _Reply} ->
			case data_agent:item_template_get(ItemID) of
				[] ->
					{noreply, ItemStatus};
				ItemTemplate ->
					ItemInfo = item_util:create_new_item(ItemTemplate, Amount, 0, 0,IsBind,0,?BAG_TYPE_MAIL),
					MailItem = item_util:add_item_and_get_id(ItemInfo),
					lib_mail:send_sys_mail(NickName, ItemStatus#item_status.user_id,NickName, ItemStatus#item_status.user_id ,[MailItem],
												   ?MAIL_TYPE_ADD_ITEM, ?_LANG_MAIL_ADD_TITLE, "  ", 0, 0, 0, 0),
					{noreply, ItemStatus}
			end;
		{ok, _Reply, ItemList, NewItemStatus} ->		
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
			{noreply, NewItemStatus}
	end;

%% 获取宠物技能书
do_cast({'pet_books_add', TemplateId, Amount, IsBind}, ItemStatus) ->
	case lib_item:pick_up_item(TemplateId, Amount, IsBind, ItemStatus) of
		{fail, _Reply} ->
			{noreply,ItemStatus};
		{ok, _Reply, ItemList, NewItemStatus} ->		
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
			{noreply,  NewItemStatus}	
	end;	

%% 活跃度领取奖励
do_cast({'play_active', Info}, ItemStatus) ->
	F = fun({TemplateId, Amount},ItemStatus) ->
				case lib_item:pick_up_item(TemplateId, Amount, 1, ItemStatus) of
					{fail, _Reply} ->
						ItemStatus;
					{ok, _Reply, ItemList, NewItemStatus} ->		
						{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
						lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
						NewItemStatus
				end
		end,
	NewItemStatus = lists:foldl(F,ItemStatus , Info),
	{noreply,  NewItemStatus};

%% 发放神游奖励
do_cast({'shenyou_award', Info,NickName,Times}, ItemStatus) ->
	F = fun({TemplateId, Amount,Bind},ItemStatus) ->
				TotalAmount = tool:ceil(Amount*Times),
				case lib_item:pick_up_item(TemplateId, TotalAmount, Bind, ItemStatus) of
					{fail, _Reply} ->
						case data_agent:item_template_get(TemplateId) of
							[] ->
								ItemStatus;
							ItemTemplate ->
								ItemInfo = item_util:create_new_item(ItemTemplate, TotalAmount, 0, 0,
												Bind,0,?BAG_TYPE_MAIL),
								MailItem = item_util:add_item_and_get_id(ItemInfo),
								lib_mail:send_sys_mail(NickName, ItemStatus#item_status.user_id,NickName, ItemStatus#item_status.user_id ,[MailItem],
												   ?MAIL_TYPE_ADD_ITEM, ?_LANG_MAIL_ADD_TITLE, "  ", 0, 0, 0, 0),
								ItemStatus
						end;
					{ok, _Reply, ItemList, NewItemStatus} ->		
						{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
						lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
						NewItemStatus
				end
		end,
	NewItemStatus = lists:foldl(F,ItemStatus , Info),
	{noreply,  NewItemStatus};

%%每日奖励
do_cast({'daily_add_item', TemplateIds,PlayerPid,PlayerPidSend}, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	if
		length(TemplateIds) > NullCells ->
			lib_chat:chat_sysmsg_pid([PlayerPidSend,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			{noreply, ItemStatus};
		true ->
			F = fun({TemplateId, Amount},ItemStatus) ->
						case lib_item:pick_up_item(TemplateId, Amount, 1, ItemStatus) of
							{fail, _Reply} ->
								ItemStatus;
							{ok, _Reply, ItemList, NewItemStatus} ->
								{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
								lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
								NewItemStatus
						end
				end,
			NewItemStatus = lists:foldl(F, ItemStatus, TemplateIds),
			gen_server:cast(PlayerPid,{daily_award}),
								
			{noreply,  NewItemStatus}
	end;


%% 目标奖励
do_cast({'target_add_item', TemplateIds,PlayerPidSend}, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	if
		length(TemplateIds) > NullCells ->
			lib_chat:chat_sysmsg_pid([PlayerPidSend,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			{noreply, ItemStatus};
		true ->
			F = fun({TemplateId, Amount},ItemStatus) ->
						case lib_item:pick_up_item(TemplateId, Amount, 1, ItemStatus) of
							{fail, _Reply} ->
								ItemStatus;
							{ok, _Reply, ItemList, NewItemStatus} ->
								{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
								lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
								NewItemStatus
						end
				end,
			NewItemStatus = lists:foldl(F, ItemStatus, TemplateIds),
								
			{noreply,  NewItemStatus}
	end;

%% 黄钻奖励
do_cast({'yellow_add_item', TemplateIds,PlayerPidSend}, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	if
		length(TemplateIds) > NullCells ->
			lib_chat:chat_sysmsg_pid([PlayerPidSend,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			{noreply, ItemStatus};
		true ->
			F = fun({TemplateId, Amount},ItemStatus) ->
						case lib_item:pick_up_item(TemplateId, Amount, 1, ItemStatus) of
							{fail, _Reply} ->
								ItemStatus;
							{ok, _Reply, ItemList, NewItemStatus} ->
								{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
								lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
								NewItemStatus
						end
				end,
			NewItemStatus = lists:foldl(F, ItemStatus, TemplateIds),
								
			{noreply,  NewItemStatus}
	end;

%% 充值/消耗 奖励
do_cast({'activity_open_server_add_item', TemplateId}, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	if
		NullCells =:= [] ->
			lib_chat:chat_sysmsg_pid([ItemStatus#item_status.pid,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			{noreply, ItemStatus};
		true ->
			case lib_item:pick_up_item(TemplateId, 1, 1, ItemStatus) of
				{fail, _Reply} ->
					NewItemStatus = ItemStatus;
				{ok, _Reply, ItemList, NewItemStatus} ->
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					NewItemStatus
			end,
			{noreply,  NewItemStatus}
	end;

%%七天活动奖励
do_cast({'activity_seven_add_item', TemplateIds}, ItemStatus) ->
	NullCells = ItemStatus#item_status.null_cells,
	if
		length(TemplateIds) > NullCells ->
			lib_chat:chat_sysmsg_pid([ItemStatus#item_status.pid,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			{noreply, ItemStatus};
		true ->
			F = fun({TemplateId, Amount},ItemStatus) ->
						case lib_item:pick_up_item(TemplateId, Amount, 1, ItemStatus) of
							{fail, _Reply} ->
								ItemStatus;
							{ok, _Reply, ItemList, NewItemStatus} ->
								{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
								lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
								NewItemStatus
						end
				end,
			NewItemStatus = lists:foldl(F, ItemStatus, TemplateIds),
								
			{noreply,  NewItemStatus}
	end;


%% %%活动领取奖励
%% do_cast({'activity_add_item', TemplateId,Amount,IsBind,Pid_send,Username,UID, ActiveIndex}, ItemStatus) ->
%% 	case lib_item:pick_up_item(TemplateId, Amount, IsBind, ItemStatus) of
%% 		{fail, _Reply} ->
%% 			Template = data_agent:item_template_get(TemplateId),
%% 			TempMailItem = item_util:create_new_item(Template, Amount, 0, 0, IsBind, 0, ?BAG_TYPE_MAIL),
%% 			MailItem = item_util:add_item_and_get_id(TempMailItem),
%% 			lib_mail:send_items_to_mail(Username, UID, [MailItem],
%% 										UID, Username, ?Mail_Type_Default),
%% 			
%% 			
%% 			
%% 			{ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [1, ActiveIndex]),
%% 			lib_send:send_to_sid(Pid_send, ResBin),
%% 			{noreply, ItemStatus};
%% 		{ok, _Reply, ItemList, NewItemStatus} ->
%% 			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
%% 			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
%% 			{ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [1, ActiveIndex]),
%% 			lib_send:send_to_sid(Pid_send, ResBin),
%% 			{noreply,  NewItemStatus}	
%% 	end;

do_cast({'add_free_awards', Awards, Username, UID}, Status) ->
	F = fun(Info, [ItemList,ItemStatus]) -> 
				case lib_item:pick_up_item(Info#ets_free_war_award_template.template_id,
										   Info#ets_free_war_award_template.amount, 
										   Info#ets_free_war_award_template.is_bind, ItemStatus) of
					{ok, _Reply, List, NewItemStatus} ->
						[ItemList ++ List, NewItemStatus];
					{fail, _Reply} ->
						Template = data_agent:item_template_get(Info#ets_free_war_award_template.template_id),
						TempMailItem = item_util:create_new_item(Template, Info#ets_free_war_award_template.amount, 
																 0, 0, Info#ets_free_war_award_template.is_bind, 
																 0, ?BAG_TYPE_MAIL),
						MailItem = item_util:add_item_and_get_id(TempMailItem),
						lib_mail:send_items_to_mail(Username, UID, [MailItem], UID, Username, ?Mail_Type_Default),
						[ItemList, ItemStatus]
				end
		end,
	[NewItemList, NewItemStatus] = lists:foldl(F, [[], Status], Awards),
	{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,NewItemList, []]),
	lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
	{noreply, NewItemStatus};

%%神魔令保存任务
do_cast({'shenmo_save_task', ItemId, TaskId}, ItemStatus) ->
	case item_util:get_user_item_by_id(ItemStatus#item_status.user_id, ItemId) of
		[] ->
			skip;
		Item ->
			case data_agent:item_template_get(Item#ets_users_items.template_id) of
				[] ->
					skip;
				ItemTemp when ItemTemp#ets_item_template.category_id =:= ?CATE_DMOGORGON ->
					NewItem = Item#ets_users_items{enchase1=TaskId, enchase2=0},
					item_util:update_item_to_bag(NewItem),
					{ok, ShenMoItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[NewItem], []]),
					lib_send:send_to_sid(ItemStatus#item_status.pid, ShenMoItemData),
					{ok, ReturnItemId} = pt_14:write(?PP_SHENMO_SAVE_TASK, ItemId),
					lib_send:send_to_sid(ItemStatus#item_status.pid, ReturnItemId)
			end
	end,
	{noreply, ItemStatus};

%%神魔令任务保存品质
do_cast({'shenmo_refresh_state', ShenmoItemId, LingLongItemId}, ItemStatus) ->
	case lib_item:shenmo_refresh_state(ShenmoItemId, LingLongItemId, ItemStatus) of
		{ok, NewItem} ->
			item_util:update_item_to_bag(NewItem),
			{ok, ShenMoItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[NewItem], []]),
			lib_send:send_to_sid(ItemStatus#item_status.pid, ShenMoItemData),
			{ok, ReturnState} = pt_14:write(?PP_SHENMO_REFRESH_STATE, NewItem#ets_users_items.enchase2),
			lib_send:send_to_sid(ItemStatus#item_status.pid, ReturnState);
		{error, _Reason} ->
			skip
	end,
	{noreply, ItemStatus};
%%神木蚕丝兑换道具
do_cast({item_exchang_buy, ShopItemID, Amount}, ItemStatus) ->
	case lib_item:check_item_exchang_buy(ShopItemID,Amount,ItemStatus) of
		{ok, ITemp, ItemList, NeedCount} ->
			{NewItemStatus, NewList, DList} = lib_item:item_exchang_buy(ItemStatus, ItemList, NeedCount, Amount ,ITemp),
			
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,NewList, DList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),

			{ok,Bin} = pt_14:write(?PP_ITEM_EXCHANG_BUY, [1, 0]),
			lib_send:send_to_sid(ItemStatus#item_status.pid, Bin),
			{noreply, NewItemStatus};
		{error, Pr} ->
			{ok,Bin} = pt_14:write(?PP_ITEM_EXCHANG_BUY, [0, Pr]),
			lib_send:send_to_sid(ItemStatus#item_status.pid, Bin),
			{noreply, ItemStatus}
	end;

%% 发送神秘商店更新最后时间
do_cast({'send_last_update'},ItemStatus) ->
	case ItemStatus#item_status.smshop_info =/= undefined of
		true ->
			SMShopInfo = ItemStatus#item_status.smshop_info,
			{ok, Data} = pt_14:write(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER, [SMShopInfo#ets_users_smshop.last_ref_date,SMShopInfo#ets_users_smshop.vip_ref_times]),
			lib_send:send_to_sid(ItemStatus#item_status.pid, Data),
			{noreply, ItemStatus};
		_ ->
			{noreply, ItemStatus}
	end;

%%神秘商店商品实时信息
do_cast({'smshop_info',PlayerStatus},ItemStatus) ->
	case ItemStatus#item_status.smshop_info =/= undefined of
		true ->
			SMShopInfo = ItemStatus#item_status.smshop_info,
			Now = misc_timer:now_seconds(),
			DiffDay = util:get_diff_days(Now,SMShopInfo#ets_users_smshop.last_ref_date),
			if
				DiffDay =/= 0 ->
					IsSend = 1,
					SMShopInfo1 = item_util:update_smshop_info(SMShopInfo),
					NewInfo = SMShopInfo1#ets_users_smshop{last_ref_date = Now, vip_ref_times = 0};
				true ->
					IsSend = 0,
					NewInfo = SMShopInfo
			end,
%% 			if
%% 				SMShopInfo#ets_users_smshop.last_ref_date + ?SMSHOP_REF_TICK - Now =< 0 ->
%% 					SMShopInfo1 = item_util:update_smshop_info(SMShopInfo),
%% 					LastRefDate = Now - ((Now - SMShopInfo#ets_users_smshop.last_ref_date) rem ?SMSHOP_REF_TICK ),
%% 					NewInfo = SMShopInfo1#ets_users_smshop{last_ref_date = LastRefDate},
%% 					IsSend = 1;
%% 				true ->
%% 					IsSend = 0,
%% 					NewInfo = SMShopInfo
%% 			end,
%% 			DiffDay = util:get_diff_days(Now,NewInfo#ets_users_smshop.vip_ref_date),
%% 			if
%% 				PlayerStatus#ets_users.vip_id  band ?VIP_BSL_HALFYEAR =/= 0 
%% 				  andalso DiffDay =/= 0->
%% 					IsSend1 = 1,
%% 					NewInfo1 = NewInfo#ets_users_smshop{vip_ref_date =Now,vip_ref_times = ?MAX_SMSHOP_REF_TIMES };
%% 				true ->
%% 					IsSend1 = IsSend,
%% 					NewInfo1 = NewInfo
%% 			end,
			if
				IsSend =:= 1 ->
					db_agent_item:update_smshop_info(NewInfo),
					{ok, Data1} = pt_14:write(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER, [NewInfo#ets_users_smshop.last_ref_date,NewInfo#ets_users_smshop.vip_ref_times]),
					lib_send:send_to_sid(ItemStatus#item_status.pid, Data1);
				true ->
					ok
			end,

			NewItemStatus = ItemStatus#item_status{smshop_info = NewInfo},
			{ok, Data} = pt_14:write(?PP_MYSTERY_SHOP_INFO, [NewInfo#ets_users_smshop.items_list]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, Data),
			{noreply, NewItemStatus};
		_ ->
			{noreply, ItemStatus}
	end;

do_cast({level_up, Level},ItemStatus) ->
	NewItemStatus = ItemStatus#item_status{level = Level},
	{noreply, NewItemStatus};



%% 停止
do_cast({stop, _Reason}, State) ->
	item_util:item_offline(),
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_item cast is not match:~w",[Info]),
    {noreply, State}.


%%---------------------do_cast--------------------------------
%% 物品扫描保存，可以改为mod_player统一调用
do_info({'scan_time'}, State) ->
	%% 放在前面发送，防止出错死掉
	erlang:send_after(?SAVE_ITEM_TICK, self(), {'scan_time'}),
	item_util:save_dic(),
	
	{noreply, State};

	
do_info(Info, State) ->
	?WARNING_MSG("mod_item info is not match:~w",[Info]),
    {noreply, State}.




