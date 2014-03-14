
%%%-------------------------------------------------------------------
%%% Module  : mod_stall_server
%%% Author  : 谢中良
%%% Created : 2011-3-21
%%% Description : 
%%%-------------------------------------------------------------------
-module(mod_stall_server).
%% -behaviour(gen_server).
%% 
%% %%--------------------------------------------------------------------
%% %% Include files
%% %%--------------------------------------------------------------------
%% -include("common.hrl").
%% -include("record.hrl").
%% 
%% -define(STATE_KEY, stall_server_state).
%% %% 摊位出售表
%% -define(ETS_STALL_SELLS, ets_stall_sells).
%% %% 摊位求购表
%% -define(ETS_STALL_WANTED_LIST, ets_stall_wanted).
%% %% 摊位详细表
%% -define(ETS_STALL_DETAIL, ets_stall_detail).
%% 
%% -define(STALL_LOG_WANTED,1).     %% 日志类型：求购
%% -define(STALL_LOG_SALE,2).       %% 日志类型：出售
%% -define(STALL_LOG_MAX_NUM, 20).  %% 日志最大数量 
%% -define(ETS_SALES_TMP, ets_sales_temp).
%% -define(ITEM_STATE_ON_SELL, 3).
%% -define(ITEM_STATE_NORMAL, 0).
%% -record(stall_server_state,{mapid=0, ets_log}).
%% %% 摊位交易日志
%% -record(r_stall_log,
%% 		{type, %% 日志类型
%% 		 src_role_id,  %% 摊主ID
%% 		 src_role_name, %% 摊主昵称
%% 		 goods_info,   %% 物品信息
%% 		 amount, %% 交易数量
%% 		 copper, %% 交易铜币
%% 		 time    %% 日期
%% 		}).
%% 
%% -record(r_stall, {start_time, stall_name, role_name, tx, ty, role_id}).
%% -record(r_buy, {copper=0, goods=[], goods2=[], goods3=[]}).
%% -record(r_sales_tmp,{role_id, template_id, amount=0}).
%% 
%% %% 已经定义在record.hrl 在这里注释是为了方便查看
%% %%-record(r_stall_sells, {id=0, role_id=0, price=0, place=0,sells_detail=undefined}).
%% %%-record(r_stall_buys, {id=0, role_id=0, num=0, price=0, buy_detail=undefned}).
%% 
%% %%--------------------------------------------------------------------
%% %% External exports
%% %%--------------------------------------------------------------------
%% -export([
%% 		 start_link/1,
%% 		 get_stall_process_name_by_mapid/1,
%% 		 start_stall_server/1
%% 		]).
%% %% gen_server callbacks
%% -export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
%% 
%% %%====================================================================
%% %% External functions 
%% %%====================================================================
%% 
%% %% 角色下线通知摆摊进程
%% user_offline(UserId, MAPId) ->
%% 	ProcessName = lists:concat(["stall_server_", MAPId]),
%% 	case global:whereis_name(ProcessName) of
%% 		undefined ->
%% 			ignore;
%% 		_ ->
%% 			global:send(ProcessName, {user_offline, UserId})
%% 	end.
%% 
%% %%根据地图id得到该地图的摆摊进程名称
%% get_stall_process_name_by_mapid(MAPID) ->
%% 	lists:concat(["stall_server_", MAPID]).
%% 
%% %% 启动地图摆摊进程
%% start_stall_server(MAPID) ->
%% 	case supervisor:start_child(mod_stall_server_sup,
%% 								{lists:concat(["mod_stall_server_", MAPID]),
%% 								 {mod_stall_server, start_link, [MAPID]},
%% 								 transient, 30000, worker, [mod_stall_server]}) of
%% 		{ok, _PID} ->
%% 			%%?PRINT("~ts:~w",["stall_server started success!!", MAPID]),
%% 			{ok, _PID};
%% 		{error, {already_started, _}} ->
%% 			?PRINT("mod_stall_server_~ts:~w~n",[MAPID,"already_started!"]),
%% 			{error, "already_started"};
%% 		{error, Reason} ->
%% 			?PRINT("~ts:~w", ["mod_stall_server started fail!Reason is", Reason]),
%% 			{error, Reason}
%% 	end.
%% 			
%% %%--------------------------------------------------------------------
%% %% Function: start_link/1
%% %% Description: Starts the server
%% %%--------------------------------------------------------------------
%% start_link(MAPID) ->
%% 	gen_server:start_link(?MODULE, [MAPID], []).
%%     %%gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
%% 
%% %%====================================================================
%% %% Callback functions 
%% %%====================================================================
%% %%--------------------------------------------------------------------
%% %% Function: init/1
%% %% Description: Initiates the server
%% %% Returns: {ok, State}          |
%% %%          {ok, State, Timeout} |
%% %%          ignore               |
%% %%          {stop, Reason}
%% %%--------------------------------------------------------------------
%% init([MAPID]) ->
%% 	misc:write_monitor_pid(self(),?MODULE, {}),
%% 	erlang:process_flag(trap_exit, true),
%% 	Name = lists:concat(["stall_server_", MAPID]),
%% 	global:register_name(Name, self()),
%% 	EtsLogName = tool:list_to_atom2(lists:concat(["ets_stall_log_", MAPID])),
%% 	EtsLog = ets:new(EtsLogName, [protected, named_table, set]),
%% 
%% 	EtsStallSellName = tool:list_to_atom2(lists:concat(["ets_stall_sell_", MAPID])),
%% 	ets:new(EtsStallSellName, [protected, named_table, set]),
%% 	%% 出售信息
%% 	ets:new(?ETS_STALL_SELLS, [protected, named_table, bag, {keypos, #r_stall_sells.role_id}]),
%% 	%% 求购信息
%% 	ets:new(?ETS_STALL_WANTED_LIST, [protected, named_table, bag, {keypos, #r_stall_buys.role_id}]),
%% 	%% 摊位信息
%% 	ets:new(?ETS_STALL_DETAIL, [protected, named_table, set, {keypos,#r_stall.role_id}]),
%% 	%%
%% 	ets:new(?ETS_SALES_TMP,[protected, named_table, bag, {keypos, #r_sales_tmp.role_id}]),
%% 
%% 	State = #stall_server_state{mapid=MAPID, ets_log=EtsLog},
%% 	init_state(State),
%% 	{ok, State}.
%% 
%% %%--------------------------------------------------------------------
%% %% Function: handle_call/3
%% %% Description: Handling call messages
%% %% Returns: {reply, Reply, State}          |
%% %%          {reply, Reply, State, Timeout} |
%% %%          {noreply, State}               |
%% %%          {noreply, State, Timeout}      |
%% %%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %%--------------------------------------------------------------------
%% handle_call(_Request, _From, State) ->
%%     {reply, ok, State}.
%% 
%% %%--------------------------------------------------------------------
%% %% Function: handle_cast/2
%% %% Description: Handling cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %%--------------------------------------------------------------------
%% handle_cast(_Msg, State) ->
%%     {noreply, State}.
%% 
%% %%--------------------------------------------------------------------
%% %% Function: handle_info/2
%% %% Description: Handling all non call/cast messages
%% %% Returns: {noreply, State}          |
%% %%          {noreply, State, Timeout} |
%% %%          {stop, Reason, State}            (terminate/2 is called)
%% %%--------------------------------------------------------------------
%% handle_info(Info, State) ->
%% 	do_handle_info(Info),
%%     {noreply, State}.
%% 
%% %%--------------------------------------------------------------------
%% %% Function: terminate/2
%% %% Description: Shutdown the server
%% %% Returns: any (ignored by gen_server)
%% %%--------------------------------------------------------------------
%% terminate(_Reason, _State) ->
%% 	misc:delete_monitor_pid(self()),
%%     ok.
%% 
%% %%--------------------------------------------------------------------
%% %% Func: code_change/3
%% %% Purpose: Convert process state when code is changed
%% %% Returns: {ok, NewState}
%% %%--------------------------------------------------------------------
%% code_change(_OldVsn, State, _Extra) ->
%%     {ok, State}.
%% 
%% %%====================================================================
%% %% Local functions 
%% %%====================================================================
%% do_handle_info({?PP_STALL_CREATE, PlayerStatus, StallName, SellList, BuyList}) ->
%% 	do_putin(PlayerStatus, StallName, SellList, BuyList);
%% do_handle_info({?PP_STALL_CANCEL, PlayerStatus}) ->
%% 	do_cancel(PlayerStatus);
%% do_handle_info({?PP_STALL_QUERY, PlayerStatus, RoleID}) ->
%% 	do_query(PlayerStatus, RoleID);
%% do_handle_info({?PP_STALL_BUY, PlayerStatus, TargetRoleID, Buys}) ->
%% 	do_buy(PlayerStatus, TargetRoleID, Buys);
%% do_handle_info({?PP_STALL_SALE, PlayerStatus, TargetRoleID, Sales}) ->
%% 	do_do_sale(PlayerStatus, TargetRoleID, Sales);
%% do_handle_info({?PP_STALL_CHAT, PlayerStatus, TargetUserId, ChatMsg}) ->
%% 	do_chat(PlayerStatus, TargetUserId, ChatMsg);
%% do_handle_info({user_offline, UserId}) ->
%% 	do_user_offline(UserId).
%% 
%% %%将物品放入摊位
%% do_putin(PlayerStatus, StallName, SellList, BuyList) ->	
%% 	RoleID = PlayerStatus#ets_users.id,
%% 	NewSellItemList = lists:foldr(
%% 						fun ({C, P}, L) -> 
%% 							do_putin2(C, P, RoleID, L) 
%% 						end, [], SellList),
%% 
%% 	State = get_state(),
%% 	EtsLog = State#stall_server_state.ets_log,
%% 	ets:insert(EtsLog,{RoleID, [], [], []}),
%% 	StallDetail = #r_stall{
%% 						   role_id=PlayerStatus#ets_users.id,
%% 						   start_time=misc_timer:now(),
%% 						   tx=PlayerStatus#ets_users.pos_x, 
%% 						   ty=PlayerStatus#ets_users.pos_y, 
%% 						   stall_name=StallName, 
%% 						   role_name=PlayerStatus#ets_users.nick_name
%% 						  },
%% 	ets:insert(?ETS_STALL_DETAIL, StallDetail),
%% 	
%% 	lists:foldr(
%% 	  fun({T, P, A}, L) -> 
%% 			  do_putin3(T, P, A, RoleID, L) 
%% 	  end, [], BuyList),
%% 	
%% 
%% 	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [NewSellItemList,[]]),
%% 	{ok, BinData1} = pt_15:write(?PP_STALL_STATE_UPDATE, [RoleID, StallName]),
%%     {ok, BinData2} = pt_15:write(?PP_STALL_CREATE, 1),
%% 
%% 	Pid = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	Q = PlayerStatus#ets_users.current_map_id,
%% 	X = PlayerStatus#ets_users.pos_x,
%% 	Y = PlayerStatus#ets_users.pos_y,
%% 
%% 	lib_send:send_to_sid(Pid, BinData),	
%% 	lib_send:send_to_local_scene(Q, X, Y, BinData1),
%% 	lib_send:send_to_sid(Pid, BinData2),
%% 	ok.
%% 
%% 
%% insert_sell_item(PlayerStatus, StallName, SellList, UserId) ->
%% 	UserId = PlayerStatus#ets_users.id,
%% 	case insert_sell_item2(SellList, UserId) of
%% 		{error, []} ->
%% 			[];
%% 		{ok, ItemList} ->		
%% 			State = get_state(),
%% 			EtsLog = State#stall_server_state.ets_log,
%% 			ets:insert(EtsLog,{UserId, [], [], []}),
%% 			stall_create_sure(PlayerStatus, StallName, ItemList, [])
%% 	end.
%% 
%% %% 摆摊成功
%% stall_create_sure(PlayerStatus, StallName, ItemList, []) ->
%% 	Pid_Send = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	UserId = PlayerStatus#ets_users.id,
%% 	Q = PlayerStatus#ets_users.current_map_id,
%% 	X = PlayerStatus#ets_users.pos_x,
%% 	Y = PlayerStatus#ets_users.pos_y,	
%% 	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList,[]]),
%% 	{ok, BinData1} = pt_15:write(?PP_STALL_STATE_UPDATE, [UserId, StallName]),
%%     {ok, BinData2} = pt_15:write(?PP_STALL_CREATE, 1),
%% 	lib_send:send_to_sid(Pid_Send, BinData),	
%% 	lib_send:send_to_local_scene(Q, X, Y, BinData1),
%% 	lib_send:send_to_sid(Pid_Send, BinData2),
%% 	ok.
%% 
%% %% 插入ets_stall_sells
%% %%-record(r_stall_sells, {id=0, role_id=0, price=0, place=0,sells_detail=undefined}).
%% insert_sell_item2(SellList, UserId) ->
%% 	case get_item_list(SellList, UserId, []) of
%% 		{error, []} ->
%% 			{error, []};
%% 		{ok, ItemList} ->
%% 			[_, NewItemList] = 
%% 			lists:foldl(
%% 			  fun (OldItem, [S, NewItemList]) ->
%% 					   [ H | T ] = S,
%% 					   {Place, Price} = H,
%% 					   R = #item_other{sell_price = Price},
%% 					   NewItem = OldItem#ets_users_items{state = ?ITEM_STATE_ON_SELL, other_data = R},
%% 					   S = #r_stall_sells{
%% 									   id           = OldItem#ets_users_items.id,
%% 									   role_id      = UserId,
%% 									   price        = Price,
%% 									   place        = Place,
%% 									   sells_detail = NewItem},
%% 					   ets:insert(?ETS_STALL_SELLS, S),
%% 					   ets:insert(?ETS_USERS_ITEMS, NewItem),
%% 					   [T, [NewItem|NewItemList]]
%% 			  end, [SellList, []], ItemList),
%% 			{ok, NewItemList}
%% 	end.	
%% 	
%% %% 获取出售物品列表
%% get_item_list([], _, ItemList) ->
%% 	{ok, ItemList};
%% get_item_list([H|T], UserId, ItemList) ->
%% 	{Place, Price} = H,
%% 	case item_util:get_user_item_by_place(UserId, Place) of
%% 		[] ->
%% 			?PRINT("~ts:~w~n",["_LANG_STALL_NO_ITEM_ON_PLACE", Place]),
%% 			{error, []};
%% 		[Item] ->
%% 			case Item#ets_users_items.state of
%% 				?ITEM_STATE_NORMAL ->
%% 					get_item_list(T, UserId, [Item|ItemList]);
%% 				_ ->
%% 					?PRINT("~ts:~w~n",["_LANG_STALL_ITEM_STATE_CANNOT_SALE, State is", Item#ets_users_items.state]),
%% 					{error, []}
%% 			end
%% 	end.			
%% 
%% 
%% %% 检查物品是否存在
%% do_putin2(Place, Price, RoleID, NewSellItemList) ->
%% 	case item_util:get_user_item_by_place(RoleID, Place) of
%% 		[ItemInfo] ->											
%% 			case t_do_putin(ItemInfo, Price, Place, RoleID) of
%% 				{ok, NewItemInfo} ->
%% 					[NewItemInfo|NewSellItemList];
%% 				{error, Reason} ->
%% 					?PRINT("do_putin2:~p~n", [Reason]),
%% 					[NewSellItemList]
%% 			end;
%% 		[] ->
%% 			[NewSellItemList]
%%  	end.
%% 
%% do_putin3(TemplateId, Price2, Amount, RoleID, NewBuyItemList) ->
%% 	case data_agent:item_template_get(TemplateId) of
%% 		ItemTemplateInfo when is_record(ItemTemplateInfo, ets_item_template) ->
%% 			StallBuys = #r_stall_buys{id=TemplateId, role_id=RoleID, num=Amount, price=Price2, buy_detail=ItemTemplateInfo},
%% 			ets:insert(?ETS_STALL_WANTED_LIST, StallBuys);
%% 		{} ->
%% 			NewBuyItemList
%% 	end.
%% 
%% %%检查物品状态，只有正常状态的物品才能放入摊位	
%% t_do_putin(ItemInfo, Price, Place, RoleID) ->
%% 	case is_record(ItemInfo, ets_users_items) of
%% 		true ->
%% 			case ItemInfo#ets_users_items.state of 
%% 				3 ->
%% 					{error, "item is already on sell!"};
%% 				0 ->
%% 					t_do_putin2(ItemInfo, Price, Place, RoleID);
%% 				_ ->
%% 					{error, "unknown item state!"}
%% 			end;
%% 		false ->
%% 			?PRINT("~ts:~w~n",["badrecord",ItemInfo])
%% 	end.
%% 
%% t_do_putin2(ItemInfo, Price, Place, RoleID) ->
%% 	Other = #item_other{sell_price = Price},
%% 	NewItemInfo = ItemInfo#ets_users_items{state=3,other_data=Other},											
%% 	StallSells = #r_stall_sells{id=NewItemInfo#ets_users_items.id, role_id=RoleID, place=Place, sells_detail=NewItemInfo},
%% 	ets:insert(?ETS_STALL_SELLS, StallSells),
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	{ok, NewItemInfo}.
%% 
%% %% 玩家收摊
%% do_cancel(PlayerStatus) ->
%% 	RoleID = PlayerStatus#ets_users.id,
%% 	%% 读取摊位信息
%% %% 	[StallDetail] = ets:lookup(?ETS_STALL_DETAIL, RoleID),
%% 	%% 删除摆摊记录
%% 	State = get_state(),
%% 	EtsLog = State#stall_server_state.ets_log,
%% 	ets:delete(EtsLog, RoleID),
%% 
%% 	StallSellsList = ets:lookup(?ETS_STALL_SELLS, RoleID),
%% 	ItemList = do_getout(StallSellsList),
%% 
%% 	Pid = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	Q = PlayerStatus#ets_users.current_map_id,
%% 	X = PlayerStatus#ets_users.pos_x,
%% 	Y = PlayerStatus#ets_users.pos_y,
%% 	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList,[]]),
%% 	{ok, BinData1} = pt_15:write(?PP_STALL_STATE_UPDATE, [RoleID,""]),
%% 	{ok, BinData2} = pt_15:write(?PP_STALL_CANCEL, 1),
%% 	lib_send:send_to_sid(Pid, BinData),	
%% 	lib_send:send_to_local_scene(Q, X, Y, BinData1),
%% 	lib_send:send_to_sid(Pid, BinData2),
%% 	ets:delete(?ETS_STALL_DETAIL, RoleID),
%% 	ets:delete(?ETS_STALL_SELLS, RoleID),
%% 	ets:delete(?ETS_STALL_WANTED_LIST, RoleID),
%% 	ok.
%% 
%% do_getout(StallSellsList) ->
%% 	lists:foldl(
%% 	  fun (StallSell, ItemList) -> 
%% 			   #r_stall_sells{sells_detail=ItemInfo} = StallSell, 
%% 			   do_getout2(ItemInfo, ItemList) 
%% 	  end, [], StallSellsList).
%% 
%% do_getout2(ItemInfo, ItemList) ->
%% 	NewItemInfo = ItemInfo#ets_users_items{state=0},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	[NewItemInfo|ItemList].
%% 
%% do_query(PlayerStatus, RoleID) ->
%% 	StallSellsList = ets:lookup(?ETS_STALL_SELLS, RoleID),
%% 	StallBuysList = ets:lookup(?ETS_STALL_WANTED_LIST, RoleID),
%% 	Pid = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	{ok, BinData} = pt_15:write(?PP_STALL_QUERY, [StallSellsList, StallBuysList]),
%% 	lib_send:send_to_sid(Pid, BinData),
%% 	ok.
%% %% 2011-3-30 new version
%% do_buy(PlayerStatus, TargetUserId, Buys) ->
%% 	UserId = PlayerStatus#ets_users.id,
%% 
%% 	case do_buy2(UserId, TargetUserId, Buys) of
%% 		[] ->
%% 			?PRINT("~ts:~p~n",["fail!","_LANG_STALL_NO_STALL"]),
%% 			{error, "_LANG_STALL_NO_STALL"};
%% 		%% 交易铜币 ，摊位出售后的剩余物品列表(db_update, ets_insert)，改变拥有者的物品列表(db_udpate, ets_insert)， 买家获得的新物品列表(db_insert, ets_insert)
%% 		[Copper, Goods, Goods2, Goods3, Reason] ->
%% 			BagMaxCount = PlayerStatus#ets_users.bag_max_count,
%% 			NullCells = item_util:get_null_cells(UserId, BagMaxCount),
%% 			NullCellsCount = erlang:length(NullCells),
%% 			GoodsCount = erlang:length(lists:concat([Goods2, Goods3])),
%% 			%% 计算背包空格
%% 			case NullCellsCount >= GoodsCount of
%% 				false ->
%% 					?PRINT("~ts:~p~n",["fail!!!!!!!!!",Reason]);
%% 				true ->
%% 					case GoodsCount == erlang:length(Buys) of
%% 						false ->
%% 							{error, Reason};
%% 						true ->
%% 							%% 购买成功
%% 							t_do_buy2(PlayerStatus, TargetUserId, Copper, Goods, Goods2, Goods3)
%% 					end
%% 					%%TODO
%% 			end
%% 	end.
%% 
%% t_do_buy2(PlayerStatus, TargetRoleID, Copper, GoodsInfo, GoodsInfo2, GoodsInfo3) ->
%% 	RoleId = PlayerStatus#ets_users.id,		
%% 	RoleName = PlayerStatus#ets_users.nick_name,
%% 	Pid_Send = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	TPlayerStatus = lib_player:get_online_info(TargetRoleID),
%% 
%% 	%% 买主添加的物品
%% 	Now = misc_timer:now(),
%% 	F = fun(X, [T1, T2]) ->
%% 				{ok, X1} = gen_server:call(
%% 							 PlayerStatus#ets_users.other_data#user_other.pid_item,
%% 							 {'change_item_owner', X}),
%% 				Log = #r_stall_log{
%% 								   type          = ?STALL_LOG_WANTED,
%% 								   src_role_id   = RoleId,
%% 								   src_role_name = RoleName,
%% 				                   goods_info    = X1, 
%% 				                   %%amount=Amount, 
%% 				                   time          = Now
%% 								  },				
%% 				[[Log|T1], [X1|T2]]
%% 		end,
%% 	[NewLog,GoodsInfo23]  = lists:foldl(F, [[],[]], lists:concat([GoodsInfo2, GoodsInfo3])),	   
%% 
%% 	State = get_state(),
%% 	EtsLog = State#stall_server_state.ets_log,	
%% 	[{TargetRoleID, OldBuyLogs, SaleLogs, ChatLogs}] = ets:lookup(EtsLog, TargetRoleID),
%% 	case erlang:length(OldBuyLogs) >= ?STALL_LOG_MAX_NUM of
%% 		true ->
%% 			NewBuyLogs = lists:reverse([NewLog|lists:reverse(OldBuyLogs)]);
%% 		false ->
%% 			NewBuyLogs = lists:reverse([NewLog|lists:reverse(OldBuyLogs)])
%% 	end,
%% 		   	   
%% 	ets:insert(EtsLog, {TargetRoleID, NewBuyLogs, SaleLogs, ChatLogs}),
%% 	%% 摊位更新的物品
%% 	FF = fun(Info, [T1, T2]) ->
%% 			#ets_users_items{id=ID} = Info,
%% 			Pattern = #r_stall_sells{role_id=TargetRoleID, id=ID, _='_'},
%% 			[Object] = ets:match_object(?ETS_STALL_SELLS, Pattern),
%% 			ets:delete_object(?ETS_STALL_SELLS, Object), 
%% 			if Info#ets_users_items.is_exist == 1 ->
%% 
%% 					NewObject = Object#r_stall_sells{sells_detail=Info},
%% 					ets:insert(?ETS_STALL_SELLS, NewObject),
%% 				 	[[Info|T1], T2];
%% 			   true ->
%% 					[T1, [Info#ets_users_items.place|T2]]	
%% 			end
%% 		end,
%% 	
%% 	[Info1,Delplaces]=lists:foldl(FF, [[], []], GoodsInfo),
%% 	NewTPlayerStatus = lib_player:add_cash(TPlayerStatus,0,0,Copper),
%% 	NewPlayerStatus = lib_player:reduce_cash(PlayerStatus,0,0,Copper),
%% 	%% 通知摊主交易信息
%% 	TPid_Send = TPlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	{ok, LogBin} = pt_15:write(?PP_STALL_LOG, [RoleId, RoleName, ?STALL_LOG_WANTED,GoodsInfo23]),
%% 	lib_send:send_to_sid(TPid_Send,LogBin),
%% 	
%% 	%% 通知摊主背包线程更新空格
%% 	gen_server:call(TPlayerStatus#ets_users.other_data#user_other.pid_item,
%% 					{'add_cells', Delplaces}),
%% 
%% 	update_player_and_goods_notify(NewTPlayerStatus, Info1, Delplaces),
%% 
%% 	update_player_and_goods_notify(NewPlayerStatus, GoodsInfo23, []),
%% 
%% 	{ok, BinData} = pt_15:write(?PP_STALL_BUY, 1),
%%     lib_send:send_to_sid(Pid_Send, BinData).
%% 
%% %% 25th new version
%% do_buy2(RoleID, TargetRoleID, Buys) ->
%% 	%%判断玩家是否正在摆
%% 	case ets:lookup(?ETS_STALL_DETAIL, TargetRoleID) of
%% 		[] ->
%% 			[];
%% 		[_StallDetail] ->
%% 			R = #r_buy{},
%% 			{#r_buy{copper = Copper, goods = Goods, goods2 = Goods2, goods3 = Goods3}, Reason} = t_do_buy(RoleID, TargetRoleID, Buys, R,[]),
%% 			[Copper, Goods, Goods2, Goods3, Reason]
%% 	end.
%% 
%% t_do_buy(_RoleID, _TargetRoleID, [], T, Reason) ->
%% 	{T, Reason};
%% t_do_buy(RoleID, TargetRoleID, [H|S], T, Reason) ->
%% 	{Place, Amount} = H,
%% 	Pattern = #r_stall_sells{role_id=TargetRoleID, place=Place, _='_'},
%% 	%% 检查物品是否在出售
%% 	case ets:match_object(?ETS_STALL_SELLS, Pattern) of
%% 		[] ->
%% 			t_do_buy(RoleID, TargetRoleID, S, T, ["_LANG_STALL_NO_STALL"|Reason]);
%% 		[StallSell] ->
%% 			#r_stall_sells{sells_detail=GoodsInfo, price=Price} = StallSell,
%% 			CurAmount = GoodsInfo#ets_users_items.amount,
%% 			%% 检查剩余数量
%% 			case CurAmount < Amount of
%% 				true ->
%% 					t_do_buy(RoleID, TargetRoleID, S, T, ["_LANG_STALL_AMOUNT_NOTENOUGH"|Reason]);
%% 				false ->
%% 					PlayerStatus = lib_player:get_online_info(RoleID),
%% 					Copper = PlayerStatus#ets_users.copper,
%% 					#r_buy{copper = OldTotalCopper, goods = OldGoods, goods2 = OldGoods2, goods3 = OldGoods3} = T,
%% 					NewTotalCopper = OldTotalCopper + Price * Amount,
%% 					%% 检查铜币
%% 					case NewTotalCopper > Copper of
%% 						true ->
%% 							t_do_buy(RoleID, TargetRoleID, S, T, ["_LANG_STALL_COPPER_NOTENOUGH"|Reason]);
%% 						false ->
%% 							NewAmount = CurAmount - Amount,
%% 							%% 交易物品
%% 							case NewAmount == 0 of
%% 								true ->
%% 									%% 改变拥有者
%% 									NewGoodsInfo = GoodsInfo#ets_users_items{is_exist=0},
%% 									NewGoods = [NewGoodsInfo|OldGoods],
%% 
%% 									NewGoodsInfo2 = GoodsInfo#ets_users_items{user_id = RoleID, state = 0,other_data = #item_other{}},
%% 									NewGoods2 = [NewGoodsInfo2|OldGoods2],
%% 
%% 									R = #r_buy{copper = NewTotalCopper, goods = NewGoods, goods2 = NewGoods2, goods3 = OldGoods3},
%% 									t_do_buy(RoleID, TargetRoleID, S, R, Reason);
%% 								false ->
%% 									%% 生成新物品
%% 									NewGoodsInfo = GoodsInfo#ets_users_items{amount=NewAmount},
%% 									NewGoods = [NewGoodsInfo|OldGoods],
%% 									
%% 									NewGoodsInfo3 = GoodsInfo#ets_users_items{amount=Amount, user_id=RoleID, id=0, state=0, other_data = #item_other{}},
%% 									NewGoods3 = [NewGoodsInfo3|OldGoods3],
%% 
%% 									R = #r_buy{copper = NewTotalCopper, goods = NewGoods, goods2 = OldGoods2, goods3 = NewGoods3},
%% 									t_do_buy(RoleID, TargetRoleID, S, R, Reason)
%% 							end
%% 					end							
%% 			end
%% 	end.
%% 			
%% update_item(Pid_Send, ItemList, DelPlacList) ->
%% 	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [ItemList,DelPlacList]),
%% 	lib_send:send_to_sid(Pid_Send, BinData).
%% 
%% update_player_and_goods_notify(PlayerStatus, GoodsInfo, DelPlaces) ->
%% 	Pid_Send = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	{ok, CashData} = pt_20:write(?PP_UPDATE_SELF_INFO,
%% 					[PlayerStatus#ets_users.yuan_bao,
%% 					 PlayerStatus#ets_users.copper,
%% 					 PlayerStatus#ets_users.bind_copper,
%% 					 PlayerStatus#ets_users.depot_copper,
%% 					 PlayerStatus#ets_users.bind_yuan_bao]),
%% 	lib_send:send_to_sid(Pid_Send, CashData),
%% 	{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [GoodsInfo,DelPlaces]),
%% 	lib_send:send_to_sid(Pid_Send, BinData).
%% 
%% do_chat(PlayerStatus, TargetUserId, ChatMsg) ->
%% 	TPlayerStatus = lib_player:get_online_info(TargetUserId),
%% 	Pid_Send = TPlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	Nick = PlayerStatus#ets_users.nick_name,
%% 	UserId = PlayerStatus#ets_users.id,
%% 	{ok, BinData} = pt_15:write(?PP_STALL_CHAT, [UserId, Nick, ChatMsg]),
%% 	lib_send:send_to_sid(Pid_Send, BinData),
%% 	ok.
%% 
%% do_do_sale(PlayerStatus, TargetUserId, Sales) ->
%% 	UserId = PlayerStatus#ets_users.id,	
%% 	NickName = PlayerStatus#ets_users.nick_name,
%% 	TPlayerStatus = lib_player:get_online_info(TargetUserId),
%% 	Pid_Send = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	TPid_Send = TPlayerStatus#ets_users.other_data#user_other.pid_send,
%% 	case get_item_sale_to_stall(TargetUserId, UserId, Sales) of
%% 		[[], [], []] ->
%% 			[];
%% 		[ItemList1, ItemList2, ItemList3] ->
%% %% 			?PRINT("~ts:~p~n",["ItemList1", ItemList1]),
%% %% 			?PRINT("~ts:~p~n",["ItemList2", ItemList2]),
%% %% 			?PRINT("~ts:~p~n",["ItemList3", ItemList3]),
%% 			TCurCopper = TPlayerStatus#ets_users.copper,
%% 			TotalCopper = get({copper, TargetUserId, UserId}),
%% 			case TotalCopper > TCurCopper of
%% 				true ->
%% 					[];
%% 				false ->
%% 					CurCopper = PlayerStatus#ets_users.copper,
%% 					NewPlayerStatus = PlayerStatus#ets_users{copper = CurCopper + TotalCopper},
%% 					NewTPlayerStatus = TPlayerStatus#ets_users{copper = TCurCopper - TotalCopper},
%% 					[DelPlaces, NewItemInfoList] = lists:foldl(
%% 					  				fun(T, [Acc0, Acc1]) ->
%% 										Place = T#ets_users_items.place,
%% 										ID = T#ets_users_items.id,
%% 										ItemInfo = T#ets_users_items{user_id=TargetUserId},
%% 										{ok, NewItemInfo} = gen_server:call(TPlayerStatus#ets_users.other_data#user_other.pid_item,
%% 															{'change_item_owner', ItemInfo}),
%% 										if ID =/= 0 ->											   
%% 											   [[Place|Acc0],[NewItemInfo|Acc1]];
%% 										   true ->
%% 											   [Acc0, [NewItemInfo|Acc1]]
%% 										end
%% 					  				end, [[],[]], lists:concat([ItemList2, ItemList3])),					
%% 					
%% 					{ok, LogBin} = pt_15:write(?PP_STALL_LOG, [UserId, NickName, ?STALL_LOG_SALE,NewItemInfoList]),
%% 					lib_send:send_to_sid(TPid_Send,LogBin),					
%% %% 					?PRINT("~ts:~p~n",["DelPlaces", DelPlaces]),
%% 					gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'add_cells', DelPlaces}),
%% 					change_item_num(ItemList1),
%% 					update_player_and_goods_notify(NewPlayerStatus, ItemList1, DelPlaces), %% 删除
%% 					update_player_and_goods_notify(NewTPlayerStatus, NewItemInfoList, []), %% 增加					
%% 					{ok, BinData} = pt_15:write(?PP_STALL_SALE, 1),
%%     				lib_send:send_to_sid(Pid_Send, BinData),					
%% 					List1 = finish_sale(TargetUserId, UserId, NewItemInfoList),
%% %% 					?PRINT("~ts:~p~n",["List1", List1]),
%% 					{ok, TBinData} = pt_15:write(?PP_STALL_UPDATE, List1),
%%     				lib_send:send_to_sid(TPid_Send, TBinData)									
%% 									
%% 			end
%% end.
%% 
%% change_item_num(ItemList) ->
%% 	lists:foreach(
%% 	  fun (Item) ->
%% 			   lib_item:change_item_num(Item, Item#ets_users_items.amount)
%% 	  end, ItemList).
%% 
%% finish_sale(TargetUserId, UserId, NewItemInfoList) ->
%% 	
%% 	erase({copper, TargetUserId, UserId}),
%% 	lists:foldl(
%% 		fun (H, Acc0) ->
%% 				 TemplateId =  H#ets_users_items.template_id,
%% 			case get({amount, TemplateId, UserId}) of
%% 				undefined ->
%% %% 					?PRINT("~ts:~p~n",["cant believe it!", "cant believe it!"]),
%% 					Acc0;
%% 				Amount ->
%% 					erase({amount, TemplateId, UserId}),
%% 					Pattern = #r_stall_buys{role_id = TargetUserId, id = TemplateId, _='_'},
%% 					case ets:match_object(?ETS_STALL_WANTED_LIST, Pattern) of
%% 						[] ->
%% 							Acc0;
%% 						[WantOne] ->
%% 							OldAmount = WantOne#r_stall_buys.num,
%% 							ets:delete_object(?ETS_STALL_WANTED_LIST, WantOne),
%% 							NewAmount = OldAmount - Amount,
%% 							case NewAmount > 0 of
%% 								true ->
%% 									NewWantOne = WantOne#r_stall_buys{num = NewAmount},
%% 									ets:insert(?ETS_STALL_WANTED_LIST, NewWantOne);									
%% 								false ->
%% 									Acc0
%% 							end,
%% %% 							?PRINT("NewAmount!~p~n", [NewAmount]),
%% 							[{TemplateId, NewAmount}|Acc0]
%%         			end
%% 			end
%% 		end, [], NewItemInfoList).
%% 
%% 
%% get_item_sale_to_stall(TargetUserId, UserId, Sales) ->
%% 	F = fun ({Place, Amount}, [Acc0, Acc1, Acc2]) ->
%% 				 case item_util:get_user_item_by_place(UserId, Place) of
%% 					 [] ->
%% 						 [[], [], []];
%% 					 [ItemInfo] ->
%% 						 case get_item_sale_to_stall2(ItemInfo, Amount, TargetUserId, UserId) of
%% 							 [[], [], []] ->
%% 								 [Acc0, Acc1, Acc2];
%% 							 [[], ItemInfo2, []] ->
%% 
%% 								 [Acc0, [ItemInfo2|Acc1], Acc2];
%% 							 [ItemInfo1, [], ItemInfo3] ->
%% 
%% 								 [[ItemInfo1|Acc0], Acc1, [ItemInfo3|Acc2]]
%% 						 end
%% 				end
%% 		end,
%% 	lists:foldl(F, [[], [], []], Sales).
%% 
%% put_copper(TargetUserId, UserId, Amount, Copper) ->
%% 	case get({copper, TargetUserId, UserId}) of
%% 		undefined ->
%% 			put({copper,TargetUserId, UserId}, Amount * Copper);
%% 		OldCopper ->
%% 			put({copper, TargetUserId, UserId}, OldCopper + Amount * Copper)
%% 	end.
%% 
%% get_item_sale_to_stall2(ItemInfo, Amount, TargetUserId, UserId) ->
%% 	#ets_users_items{template_id = TemplateId, amount = CurAmount} = ItemInfo,
%% 	LastAmount = case get({amount, TemplateId, UserId}) of
%% 		undefined ->
%% 			put({amount, TemplateId, UserId}, Amount),
%% 			Amount;
%% 		OldAmount ->
%% 			put({amount, TemplateId, UserId}, OldAmount + Amount),
%% 			OldAmount + Amount
%% 	end,	
%% 	Pattern = #r_stall_buys{role_id = TargetUserId, id = TemplateId, _='_'},
%% 	case ets:match_object(?ETS_STALL_WANTED_LIST, Pattern) of
%% 		[] ->
%% 			erase({amount, TemplateId, UserId}),
%% 			?PRINT("~ts:~p~n",["no such itemtemplateid he want anymore", TemplateId]),
%% 			[[], [], []];
%% 	[WantedOne] ->
%% 		WantAmount = WantedOne#r_stall_buys.num,
%% 		WantCopper = WantedOne#r_stall_buys.price,
%% 		if Amount =< CurAmount andalso LastAmount =< WantAmount ->
%% 
%% 			   put_copper(TargetUserId, UserId, LastAmount, WantCopper),
%% 			   case CurAmount - Amount of
%% 				   0 ->
%% 					   [[], ItemInfo#ets_users_items{user_id = TargetUserId}, []];
%% 				   NewAmount ->
%% 					   ItemInfo1 = ItemInfo#ets_users_items{amount = NewAmount},
%% 					   ItemInfo3 = ItemInfo#ets_users_items{id = 0, user_id = TargetUserId, amount = Amount},
%% 					   [ItemInfo1, [], ItemInfo3]
%% 			   end;				
%% 		   true ->
%% 			   erase({amount, TemplateId, UserId}),
%% 			   ?PRINT("~ts:~p~n",["want~amount ~", WantAmount]),
%% 			   ?PRINT("~ts:~p~n",["your~amount ~", Amount]),
%% 			   ?PRINT("~ts:~p~n",["CurAmount", CurAmount]),
%% 			   [[], [], []]
%% 		end
%% 	end.
%% %% 处理玩家出售道具到摊位
%% %% do_sale(PlayerStatus, TargetUserId, Sales) ->
%% %% 	?PRINT("SALES:~p~n", [Sales]),
%% %% 	TPlayerStatus = lib_player:get_online_info(TargetUserId),
%% %% 	UserId = PlayerStatus#ets_users.id,
%% %% 	NickName = PlayerStatus#ets_users.nick_name,
%% %% 	TPid_Send = TPlayerStatus#ets_users.other_data#user_other.pid_send,
%% %% 	Pid_Send = PlayerStatus#ets_users.other_data#user_other.pid_send,
%% %% 	
%% %% 	case t_do_sale2(TPlayerStatus, UserId, Sales) of		
%% %% 		{error, _} ->
%% %% 			?WARNING_MSG("sorry !he's bag is full~n", []);
%% %% 		{ok, ItemInfoList} ->
%% %% 			?PRINT("ItemInfoList:~p~n", [ItemInfoList]),
%% %% 			[TotalCopper, List] = 
%% %% 				case t_do_sale3(ItemInfoList, TargetUserId) of
%% %% 					[] ->
%% %% 						[0, []];
%% %% 					L ->
%% %% 						?PRINT("L:~p~n", [L]),
%% %% 						lists:foldl(
%% %% 						  fun(H, [Acc0, Acc1]) ->
%% %% 								  {TemplateId, Copper, Amount} = H,
%% %% 								  LL = [{TemplateId, Amount}|Acc1],
%% %% 								  [Copper+Acc0, LL]
%% %% 						  end, [0,[]], L)
%% %% 				end,
%% %% 			?PRINT("List:~p~n", [List]),
%% %% 			TCurCopper = TPlayerStatus#ets_users.copper,
%% %% 			case TotalCopper > TCurCopper andalso TotalCopper > 0 of
%% %% 				true ->
%% %% 					 lib_chat:chat_sysmsg_pid(Pid_Send, ?CHAT, ?None, ?RED, ["摊主铜币不足"]),
%% %% 					?PRINT("```stall owner no money~n"),
%% %% 					[];%% 摊主铜币不足
%% %% 				false ->
%% %% 					%% 更新人物金钱
%% %% 					CurCopper = PlayerStatus#ets_users.copper,
%% %% 					NewPlayer = PlayerStatus#ets_users{copper=CurCopper+TotalCopper},
%% %% 					TNewPlayer = TPlayerStatus#ets_users{copper=TCurCopper - TotalCopper},
%% %% 					%% 更新人物物品
%% %% 					[DelPlaces, NewItemInfoList] = lists:foldl(
%% %% 					  				fun(T, [Acc0, Acc1]) ->
%% %% 										Place = T#ets_users_items.place,
%% %% 										ItemInfo = T#ets_users_items{user_id=TargetUserId},
%% %% 										%% 通知摊主背包线程增加新物品（改新位置），更新ets表，更新数据库
%% %% 										{ok, NewItemInfo} = gen_server:call(TPlayerStatus#ets_users.other_data#user_other.pid_item,
%% %% 															{'change_item_owner', ItemInfo}),
%% %% 									
%% %% 							  			[[Place|Acc0],[NewItemInfo|Acc1]]
%% %% 					  				end, [[],[]], ItemInfoList),
%% %% 					%% 通知摊主交易信息					
%% %% 					{ok, LogBin} = pt_15:write(?PP_STALL_LOG, [UserId, NickName, ?STALL_LOG_SALE,NewItemInfoList]),
%% %% 					lib_send:send_to_sid(TPid_Send,LogBin),
%% %% 					
%% %% 					%% 通知顾客背包线程增加空格
%% %% 					gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
%% %% 									{'add_cells', DelPlaces}),
%% %% 					update_player_and_goods_notify(NewPlayer, [], DelPlaces), %% 删除
%% %% 					update_player_and_goods_notify(TNewPlayer, NewItemInfoList, []), %% 增加
%% %% 
%% %% 					
%% %% 					{ok, BinData} = pt_15:write(?PP_STALL_SALE, 1),
%% %%     				lib_send:send_to_sid(Pid_Send, BinData),
%% %% 					
%% %% 					%% 通知摊主更新求购信息
%% %% 					{ok, TBinData} = pt_15:write(?PP_STALL_UPDATE, List),
%% %%     				lib_send:send_to_sid(TPid_Send, TBinData),
%% %% 					
%% %% 					%% 更新ETS_STALL_SALS
%% %% 					update_ets_sales(List, TargetUserId)
%% %% 					
%% %% 			end
%% %% 	end.
%% 			
%% update_ets_sales(L, TargetUserId) ->
%% 	lists:foreach(
%% 	  fun(H) ->	
%% 			  {TemplateId, Amount} = H,
%% 			  P = #r_sales_tmp{role_id = TargetUserId, template_id = TemplateId, _='_'},
%% 			  ets:match_delete(?ETS_SALES_TMP, P),
%% 			  Pattern = #r_stall_buys{role_id = TargetUserId, id = TemplateId, _='_'},
%% 			  ?PRINT("insert num:~w~n",[Amount]),
%% 			  case ets:match_object(?ETS_STALL_WANTED_LIST, Pattern) of
%% 				  [] ->
%% 					  ?PRINT("insert num111111:~w~n",[Amount]),
%% 					  skip;
%% 				  [SellOne] ->
%% 					  ets:match_delete(?ETS_STALL_WANTED_LIST, Pattern),
%% 					  if Amount =/= 0 ->
%% 							 ?PRINT("insert num:~w~n",[Amount]),
%% 					  		NewSellOne = SellOne#r_stall_buys{ num = Amount},
%% 					  		ets:insert(?ETS_STALL_WANTED_LIST, NewSellOne);
%% 					  true ->?PRINT("skip~n"),
%% 	  						skip
%% 						end
%% 			  end
%% 	  end, L),	  	
%% 	ok.
%% 
%% %% 出售给摊位的物品列表
%% t_do_sale2(TPlayerStatus, RoleId, Sales) ->	
%% 	BagMaxCount = TPlayerStatus#ets_users.bag_max_count,
%% 	TargetRoleId = TPlayerStatus#ets_users.id,
%% 	NullCells = item_util:get_null_cells(TargetRoleId, BagMaxCount),
%% 	SalesCount = erlang:length(Sales),
%% 	case erlang:length(NullCells) >= SalesCount of
%% 		false ->
%% 			?PRINT("~ts:~w~n",["摊主背包空间不足",SalesCount]),
%% 			{error, []};
%% 		true ->
%% 			ItemList = lists:foldl(
%% 						 fun(SaleOne, Acc0) ->
%% 								 {Place, _Amount} = SaleOne,
%% 								 case item_util:get_user_item_by_place(RoleId, Place) of
%% 									 [] ->
%% 										 Acc0;
%% 									 [ItemInfo] ->
%% 										 [ItemInfo|Acc0]
%% 								 end
%% 						 end, [], Sales),
%% 			case  erlang:length(ItemList) of
%% 				SalesCount ->
%% 					{ok, ItemList};
%% 				_ ->
%% 					{error, []}
%% 			end
%% 	end.
%%                               
%% %% r_sales_tmp 出售临时表 
%% t_do_sale3(ItemInfoList, TargetUserId) ->
%% 	lists:foreach(
%% 	  fun(ItemInfo) ->			  
%%  			  #ets_users_items{template_id = TemplateId, amount = Amount} = ItemInfo,
%% %% 			  case get({RoleId, TemplateId}) of
%% %% 				  undefined ->
%% %% 					  put({RoleId, TemplateId}, Amount);
%% %% 				  Value ->
%% %% 					  NewValue = Value + Amount,
%% %% 					  put({RoleId, TemplateId}, NewValue)
%% %% 			  end
%% 			  Pattern = #r_sales_tmp{role_id = TargetUserId, template_id = TemplateId, _='_'},
%% 			  case ets:match_object(?ETS_SALES_TMP, Pattern) of
%% 				  [] ->
%% 					  
%% 					  R = #r_sales_tmp{role_id = TargetUserId, template_id = TemplateId, amount = Amount},
%% 					  ets:insert(?ETS_SALES_TMP, R);
%% 				  [SaleOne] ->
%% 					  OldAmount = SaleOne#r_sales_tmp.amount,
%% 					  NewAmount = OldAmount + Amount,
%% 				  	  NewSaleOne = SaleOne#r_sales_tmp{amount=NewAmount},
%% 					  ets:delete_object(?ETS_SALES_TMP, SaleOne),
%% 				      ets:insert(?ETS_SALES_TMP, NewSaleOne)
%% 			end
%% 	  end, ItemInfoList),
%% 	Pattern = #r_sales_tmp{role_id = TargetUserId, _='_'},
%% 	case ets:match_object(?ETS_SALES_TMP, Pattern) of
%% 		[] ->
%% 			[];
%% 		Sales ->
%% 			lists:foldl(
%% 			  fun(SaleOne, Acc0) ->
%% 					  #r_sales_tmp{template_id = TemplateId, amount = Amount} = SaleOne,
%% 					  case check_stall_buys(TargetUserId, TemplateId, Amount) of
%% 						  [] ->
%% 							  Acc0;
%% 						  {TemplateId, NewCopper, NewAmount} ->
%% 							  [{TemplateId, NewCopper, NewAmount}|Acc0]
%% 					  end
%% 			  end, [], Sales)
%% 	end.
%% 
%% %% 检查求购
%% check_stall_buys(TargetRoleID, TemplateId, Amount) ->
%% 	Pattern = #r_stall_buys{role_id = TargetRoleID, id = TemplateId, _='_'},
%% 	case ets:match_object(?ETS_STALL_WANTED_LIST, Pattern) of
%% 		[] ->
%% 			?PRINT("~ts:~w~n",["check_stall_tobuys","_LANG_STALL_NO_SUCH_ITEM_WANT_TO_BUY"]),
%% 			[];
%% 		[StallBuyOne] ->
%% 			#r_stall_buys{num = OldAmount, price = Copper} = StallBuyOne,
%% 			?PRINT("ooldAmount~p~n",[OldAmount]),
%% 			case Amount > OldAmount of
%% 				true ->
%% 					[];
%% 				false ->
%% 					NewCopper = Copper * Amount,
%% 					NewAmount = OldAmount - Amount,
%% 					{TemplateId, NewCopper, NewAmount}
%% 			end
%% 	end.
%%   
%% get_state() ->
%% 	get(?STATE_KEY).
%% init_state(State) ->
%% 	put(?STATE_KEY, State).
%% 
%% %% 处理玩家下线
%% do_user_offline(UserId) ->
%% 	_Stall =
%% 		case ets:lookup(?ETS_STALL_DETAIL, UserId) of
%% 			[] ->
%% 				?PRINT("~ts:~w~n",["?_LANG_STALL_NO_STALL", ok]);
%% 			[_StallTmp] ->
%% 				ets:delete(?ETS_STALL_DETAIL, UserId),
%% 				ets:delete(?ETS_STALL_SELLS, UserId),
%% 				ets:delete(?ETS_STALL_WANTED_LIST, UserId),
%% 				ets:delete(?ETS_SALES_TMP)
%% 		end,
%% 	ok.
%% 	
%% %% 错误提示信息
%% do_stall_error(Pid_Send, Msg) ->
%% 	ok.