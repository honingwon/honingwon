%%%-------------------------------------------------------------------
%%% Module  : mod_shop
%%% Author  : 
%%% Description : 商城
%%%-------------------------------------------------------------------
-module(mod_shop).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([start_link/0,
		 get_mod_shop_pid/0,
		 stop/0,
		 update_shop_item/1,
		 get_shop_item_by_id/1,
		 get_discount_goods/1,
		 update_user_discounts/2,
		 get_user_discounts/1,
		 get_user_guild_shop/1,
		 update_user_guild_shop/2,
		 update_goods_real_time/3
		]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_shop_pid() ->
	ProcessName = mod_shop_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_shop(ProcessName)
			end;
		_ ->
			start_mod_shop(ProcessName)
	end.

%%启动监控模块
start_mod_shop(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_shop()
				end;
			_ ->
				start_shop()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_shop() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_shop,
			{mod_shop, start_link, []},
			 permanent, 10000, worker, [mod_shop]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_shop error:~p~n", [R]),
			undefined
	end.

%%更新优惠商品信息
update_shop_item(ShopItem) ->
	Pid = get_mod_shop_pid(),
	gen_server:cast(Pid, {'update_shop_info', ShopItem}).

%%获取优惠商品通过ID
get_shop_item_by_id(ShopItemId) ->
	Pid = get_mod_shop_pid(),
	ShopItem = gen_server:call(Pid, {'get_shop_item_by_id', ShopItemId}),
	ShopItem.

%%获取每天出售的优惠商品
get_discount_goods(PlayerPidSend) ->
	Pid = get_mod_shop_pid(),
	gen_server:cast(Pid, {'get_discount_goods', PlayerPidSend}).

%%保存用户购买数量
update_user_discounts(DiscountItem, UserId) ->
	Pid = get_mod_shop_pid(),
	gen_server:cast(Pid, {'update_user_discounts', DiscountItem, UserId}).

%%获取用户购买数量
get_user_discounts(UserId) ->
	Pid = get_mod_shop_pid(),
	gen_server:call(Pid, {'get_user_discounts', UserId}).

%%更新界面优惠商品数量
update_goods_real_time(ShopItemId,UserId, PlayerPidSend) ->
	Pid = get_mod_shop_pid(),
	gen_server:cast(Pid, {'update_goods_real_time', ShopItemId,UserId, PlayerPidSend}).

%%获取用户购买数量
get_user_guild_shop(UserId) ->
	Pid = get_mod_shop_pid(),
	gen_server:call(Pid, {'get_user_guild_shop', UserId}).

update_user_guild_shop(DiscountItem, UserId) ->
	Pid = get_mod_shop_pid(),
	gen_server:call(Pid, {'update_user_guild_shop', DiscountItem, UserId}).
	
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
init([]) ->
	process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_shop_process,		
 	misc:register(global, ProcessName, self()),	
	
	ok = lib_shop:init_template_shop(),
	
	misc:write_monitor_pid(self(),?MODULE, {}),	
    {ok, #state{}}.

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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_shop handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_shop handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_shop handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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

%%---------------------do_call--------------------------------
%%由优惠商品模板ID获取优惠商品模板
do_call({'get_shop_item_by_id', ShopItemId}, _From, State) ->
	ShopItem = lib_shop:get_discount_item_by_id(ShopItemId),
	{reply, ShopItem, State};

%%获取当天优惠商品
do_call({'get_user_discounts', UserId}, _From, State) ->
	ShopItems = lib_shop:get_user_discounts(UserId),
	{reply, ShopItems, State};

%% 玩家当天公会商品
do_call({'get_user_guild_shop', UserId}, _From, State) ->
	ShopItems = lib_shop:get_user_guild_shop(UserId),
	{reply, ShopItems, State};


do_call({'update_user_guild_shop', DiscountItem, UserId}, _From, State) ->
	Re = lib_shop:update_user_guild_shop(DiscountItem, UserId),
	{reply, Re, State};

 %% 停止
do_call(stop,_Form, State) ->
	{stop, normal, State};

do_call(Info, _From, State) ->
	?WARNING_MSG("mod_increase call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------
do_cast({'update_shop_info', ShopItem}, State) ->
	lib_shop:update_shop_info(ShopItem),
	{noreply, State};

do_cast({'get_discount_goods', PlayerPidSend}, State) ->
	case lib_shop:fetch_shop_discount() of
		{ok, ShopItems} ->
			{ok, ShopItemsData} = pt_14:write(?PP_ITEM_DISCOUNT, ShopItems),
			lib_send:send_to_sid(PlayerPidSend, ShopItemsData);
		{error, _Reason} ->
			skip
	end,
	{noreply, State};

do_cast({'update_goods_real_time', ShopItemId,UserId, PlayerPidSend}, State) ->
	case lib_shop:get_discount_item_by_id(ShopItemId) of
		[] ->
			skip;
			%%{error, "error: no discount goods"};
		Info ->
			CurrCount = Info#ets_shop_discount_template.other_data#other_discount.left_count,
			Lcount = Info#ets_shop_discount_template.limit_count,
			BoughtItems = lib_shop:get_user_discounts(UserId),
			LimitCount = case lists:keyfind(Info#ets_shop_discount_template.id, #discount_items.item_id, BoughtItems) of
							 false ->
								 Lcount;
							 OldItem ->
								 Lcount - OldItem#discount_items.item_count
						 end,
					
			{ok, CountData} = pt_14:write(?PP_ITEM_REAL_TIME, [ShopItemId, CurrCount,LimitCount]),
			lib_send:send_to_sid(PlayerPidSend, CountData)
	end,
	{noreply, State};

do_cast({'update_user_discounts', DiscountItem, UserId}, State) ->
	lib_shop:update_user_discounts(DiscountItem, UserId),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_increase cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------	
do_info(Info, State) ->
	?WARNING_MSG("mod_increase info is not match:~w",[Info]),
    {noreply, State}.

%%====================================================================
%% Private functions
%%====================================================================


