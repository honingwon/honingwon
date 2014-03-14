%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :寄售系统
%%%
%%% Created : 2011-4-6
%%% -------------------------------------------------------------------
-module(mod_sale).



-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([start_link/0,
		 stop/0,
		 get_mod_sale_pid/0
		 ]).
-export([
		 sale_money/5,			%% 添加铜币、元宝寄售
		 buy_sale_item/2, 		%% 购买寄售
		 list_sale_items/1,		%% 查找寄售
		 delete_sale_item/2, 	%% 取回、撤消寄售
		 add_sale_item/5,		%%   添加物品寄售
		 list_sale_items_self/2,
		 sale_again/2
		]).
%% 定时器间隔时间(30*60*1000 = 30 分钟)
-define(TIMER, 10000).

-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载市场交易处理进程 
get_mod_sale_pid() ->
	ProcessName = mod_sale_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_sale(ProcessName)
			end;
		_ ->
			start_mod_sale(ProcessName)
	end.

%%启动市场交易监控模块 (加锁保证全局唯一)
start_mod_sale(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_sale()
				end;
			_ ->
				start_sale()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启市场交易监控模块
start_sale() ->
    case supervisor:start_child(
               server_sup,
               {mod_sale,
                {mod_sale, start_link,[]},
                permanent, 10000, worker, [mod_sale]}) of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_sale error:~p~n",[R]),
				undefined
	end.

%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	try 
		do_init()	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create sale is error."}
	end.

do_init() ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	ProcessName = mod_sale_process,
	misc:register(global, ProcessName, self()),
	
	ets:new(?ETS_USERS_SALES, [{keypos, #ets_users_sales.id}, public , set, named_table]),
	
	%% 加载数据库t_users_sales表
	lib_sale:load_all_sale(),
	
	erlang:send_after(?TIMER, self(), {event, timer_action}),

    {ok, #state{}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_sale handle_call is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_sale handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
	try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_sale handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------


%%---------------------do_call--------------------------------
%% 统一模块+过程调用(call)
do_call({apply_call, Module, Method, Args}, _From, State) ->
	Reply = apply(Module, Method, Args),
	{reply, Reply, State};

%% 停止
do_call(stop,_From, State) ->
	{stop, normal, State};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_sale call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------
%% 统一模块+过程调用(cast)
do_cast({apply_cast, Module, Method, Args},  State) ->
	apply(Module, Method, Args),
	{noreply, State};


do_cast(Info, State) ->
	?WARNING_MSG("mod_sale cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%% 统一模块+过程调用(info)
do_info({apply_info, Module, Method, Args}, State) ->
	apply(Module, Method, Args),
	{noreply, State};

do_info({event, timer_action}, State) ->
	lib_sale:handle_sale_item_timeout(),
	erlang:send_after(?TIMER, self(), {event, timer_action}),
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_sale info is not match:~w",[Info]),
    {noreply, State}.


%% ----------------------------------------------------
%% 22003 查找寄售物品
%% ----------------------------------------------------
list_sale_items([UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page, Pid_Send]) ->
%% 	case gen_server:call(mod_sale:get_mod_sale_pid(),
%% 						 {apply_call, lib_sale, list_sale_items,
%% 						  [UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page]}) of
%% 		error ->
%% 			[0,0,[]];
%% 		Data ->
%% 			Data
%% 	end.
	gen_server:cast(mod_sale:get_mod_sale_pid(), {apply_cast, lib_sale, list_sale_items,
 						  [UserId, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page, Pid_Send]}).
	

%% ----------------------------------------------------
%% 22001 添加寄售物品
%% ----------------------------------------------------
add_sale_item(PlayerStatus, Place, PriceType, Price, ValidTime) ->
	gen_server:call(mod_sale:get_mod_sale_pid(), {apply_call, lib_sale, add_sale_item,
												  [PlayerStatus, Place, PriceType, Price, ValidTime]}).

%% ----------------------------------------------------
%% 22002 撤消寄售物品
%% ----------------------------------------------------
delete_sale_item(PlayerStatus, [SaleId, Page]) ->
	gen_server:call(mod_sale:get_mod_sale_pid(), {apply_call, lib_sale, delete_sale_item,
												  [PlayerStatus, SaleId, Page]}).

%% ----------------------------------------------------
%% 22004 买家购买寄售物品
%% ----------------------------------------------------
buy_sale_item(PlayerStatus, [SaleId]) ->
	gen_server:call(mod_sale:get_mod_sale_pid(), {apply_call, lib_sale, buy_sale_item,
												 [PlayerStatus, SaleId]}).

%% ----------------------------------------------------
%% 22004 寄售元宝、铜币
%% ----------------------------------------------------
sale_money(PlayerStatus, PriceType, Amount, Price, ValidTime) ->
	gen_server:call(mod_sale:get_mod_sale_pid(), {apply_call, lib_sale, sale_money,
												  [PlayerStatus, PriceType, Amount, Price, ValidTime]}).

sale_again(PlayerStatus, SaleId) ->
	gen_server:call(mod_sale:get_mod_sale_pid(), {apply_call, lib_sale, sale_again,
												  [PlayerStatus, SaleId]}).

%查询本人
list_sale_items_self(PlayerStatus, Page) ->
	gen_server:cast(get_mod_sale_pid(),{apply_cast, lib_sale, list_sale_items_self,
										[PlayerStatus, Page]}).
