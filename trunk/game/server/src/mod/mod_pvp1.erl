%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-4-18
%%% -------------------------------------------------------------------
-module(mod_pvp1).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start_link/0,stop/0,get_pvp1_pid/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
				terminal_time = -1,
				list1 = [],
				list2 = []}).

-define(PVP1_LOOP_TIEM, 1000). %%pvp1匹配循环时间
-define(PVP1_ACTIVE_PROCESS_NAME, mod_active_process_1001).%%pvp1单挑王活动进程名称
%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(?MODULE, {stop, ""}).

get_pvp1_pid() ->
	ProcessName = ?PVP1_ACTIVE_PROCESS_NAME,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_pvp1(ProcessName)
			end;
		_ ->
			start_mod_pvp1(ProcessName)
	end.

%%启动活动1001监控模块 (加锁保证全局唯一)
start_mod_pvp1(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_pvp1()
				end;
			_ ->
				start_pvp1()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启活动1001监控模块
start_pvp1() ->
%%     case supervisor:start_child(
%%                server_sup,
%%                {mod_pvp1,
%%                 {mod_pvp1, start_link,[]},
%%                 permanent, 10000, worker, [mod_pvp1]}) of
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_pvp1 error:~p~n",[R]),
				undefined
	end.

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
		_:Reason ->
			?WARNING_MSG("mod_pvp1 init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	misc:register(global, ?PVP1_ACTIVE_PROCESS_NAME , self()),
	%%初始化活动配置数据
 	%List = lib_active_manage:init_active_open_time(),
	State = #state{},
	erlang:send_after(?PVP1_LOOP_TIEM, self(),{pvp1_loop}),
	{ok, State}.

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
handle_call(Info, From, State) ->
	try
		do_call(Info,From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_pvp1 handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
handle_cast(Msg, State) ->
    try
		do_cast(Msg, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_pvp1 handle_cast is exception:~w~n,Info:~w",[Reason, Msg]),
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
			?WARNING_MSG("mod_pvp1 handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	gen_server:cast(mod_active:get_active_pid(), {terminal, ?PVP1_ACTIVE_ID}),
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

do_call(Info, _, State) ->
	?WARNING_MSG("mod_pvp1 call is not match:~w",[Info]),
    {reply, ok, State}.

do_cast({show_state_info}, State) ->
	?DEBUG("show_state_info:~p",[State]),
	{noreply, State};
do_cast({clear_join_users}, State) ->
	NewState = State#state{list1 = [], list2 = []},
	{noreply, NewState};
do_cast({set_continue_time, Time}, State) ->
	NewState = State#state{terminal_time = Time},
	{noreply, NewState};
%% 报名参加pvp1活动
do_cast({join_active, SendPid, UserInfo}, State) ->
	case lib_pvp1:join_active(UserInfo, State#state.list1) of
		{ok, List1} ->
			{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_JOIN, [?PVP1_ACTIVE_ID,1]),
			NewState = State#state{list1 = List1};
		_ ->
			{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_JOIN, [?PVP1_ACTIVE_ID,0]),
			NewState = State
	end,
	lib_send:send_to_sid(SendPid, Bin),
	{noreply, NewState};
%% 退出pvp1活动
do_cast({quit_active,SendPid, UserId}, State) ->
	case lib_pvp1:quit_active(UserId, State#state.list1, State#state.list2) of
		{ok, List1, List2} ->
			{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_QUIT, [?PVP1_ACTIVE_ID,1]),
			NewState = State#state{list1 = List1, list2 = List2};
		_ ->
			{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_QUIT, [?PVP1_ACTIVE_ID,0]),
			NewState = State
	end,
	lib_send:send_to_sid(SendPid, Bin),
	{noreply, NewState};

%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_pvp1 cast is not match:~w",[Info]),
    {noreply, State}.

%%pvp1循环处理报名玩家匹配
do_info({pvp1_loop}, State) ->
	{List1,List2} = lib_pvp1:pvp1_start_mach(State#state.list1),
	NewList2 = lib_pvp1:pvp1_mach(State#state.list2 ++ List2, 0),
	if
		State#state.terminal_time =:= 0 ->
			NewState = State#state{list1 = List1,list2 = NewList2},
			stop();
		true ->
			erlang:send_after(?PVP1_LOOP_TIEM, self(),{pvp1_loop}),
			NewState = State#state{list1 = List1,list2 = NewList2, terminal_time = State#state.terminal_time - 1}
	end,	
	{noreply, NewState};

do_info(Info, State) ->
	?WARNING_MSG("mod_pvp1 info is not match:~w",[Info]),
    {noreply, State}.