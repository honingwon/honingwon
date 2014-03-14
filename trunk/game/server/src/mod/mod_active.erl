%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-4-17
%%% -------------------------------------------------------------------
-module(mod_active).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl"). 
%% --------------------------------------------------------------------
%% External exports
-export([start_link/0, stop/0, get_active_pid/0, open_active/1,update_1008/0, is_active_open/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {active_open_time_list = [],
				open_active_id = 0,
				open_active_pid}).
-define(ACTIVE_LOOP_TIME, 52000). %%活动定时循环处理
%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(?MODULE, {stop}).

get_active_pid() ->
	ProcessName = ?GLOBAL_ACTIVE_PROCESS_NAME,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_active(ProcessName)
			end;
		_ ->
			start_mod_active(ProcessName)
	end.

%%启动活动监控模块 (加锁保证全局唯一)
start_mod_active(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_active()
				end;
			_ ->
				start_active()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启活动监控模块
start_active() ->
    case supervisor:start_child(
               server_sup,
               {mod_active,
                {mod_active, start_link,[]},
                permanent, 10000, worker, [mod_active]}) of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_active error:~p~n",[R]),
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
			?WARNING_MSG("mod_active init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	misc:register(global, ?GLOBAL_ACTIVE_PROCESS_NAME, self()),
	%%初始化活动配置数据
	List = lib_active_manage:init_active_open_time(),
%% 	?DEBUG("active_open_time:~p",[List]),
	State = #state{active_open_time_list = List},
	erlang:send_after(?ACTIVE_LOOP_TIME, self(),{active_loop}),
	{ok, State}.

update_1008() ->
	Pid = get_active_pid(),
	gen_server:cast(Pid, {update_1008}).

open_active(ActiveId) ->
	Pid = get_active_pid(),
	gen_server:cast(Pid, {open_active, ActiveId}).

is_active_open(ActiveId) ->
	Pid = get_active_pid(),
	gen_server:call(Pid, {is_active_open, ActiveId}).
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
			?WARNING_MSG("mod_active handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_active handle_cast is exception:~w~n,Info:~w",[Reason, Msg]),
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
			?WARNING_MSG("mod_active handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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
%%验证当前活动是否开启
do_call({is_active_open, ActiveId}, _,State) ->
	Re =if
			State#state.open_active_id =:= ActiveId ->
				true;
			true ->
				false
		end,
	{reply, Re, State};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_active call is not match:~w",[Info]),
    {reply, ok, State}.

%%刚登录玩家通知已开启的活动
do_cast({current_active, Pid}, State) ->
	{ok, Bin} = pt_23:write(?PP_ACTIVE_START_TIME_LIST, [State#state.active_open_time_list]),
	lib_send:send_to_sid(Pid, Bin),
	{noreply, State};
%%如果活动ID为当前开放的活动编号，加入到活动列表中
do_cast({join_active, ActiveId,SendPid,UserInfo}, State) ->
	if
		State#state.open_active_id =:= ActiveId ->
			lib_active_manage:join_active(ActiveId, SendPid, UserInfo);
		true ->
			ok
	end,
	{noreply, State};
%%退出报名
do_cast({quit_active, ActiveId,SendPid,UserId}, State) ->
	if
		State#state.open_active_id =:= ActiveId ->
			lib_active_manage:quit_active(ActiveId, SendPid, UserId);
		true ->
			ok
	end,
	{noreply, State};
%%临时开启指定活动
do_cast({open_active, ActiveId}, State) ->
	if
		State#state.open_active_id =:= 0 ->
			List = lib_active_manage:open_active(ActiveId, State#state.active_open_time_list),
			NewState = State#state{active_open_time_list = List};
		true ->
			NewState = State
	end,
	{noreply, NewState};
%%保存当前活动信息
do_cast({start, ActiveId, Pid}, State) ->
	if
		State#state.open_active_id =:= 0 ->
			NewState = State#state{open_active_id = ActiveId, open_active_pid = Pid};
		true ->
			NewState = State
	end,
	{noreply, NewState};

%%活动结束后，处理活动状态信息
do_cast({terminal, ActiveId}, State) ->
	%?DEBUG("terminal:~p",[ActiveId]),
	if
		State#state.open_active_id =:= ActiveId ->
			{ok, Bin} = pt_23:write(?PP_PVP_ACTIVE_FINISH, [ActiveId]),
			lib_send:send_to_all(Bin),
			NewState = State#state{open_active_id = 0,open_active_pid = undifend};			
		true ->
			NewState = State
	end,
	case lists:keyfind(ActiveId , #ets_active_open_time_template.active_id, NewState#state.active_open_time_list) of
		false ->
			NewState1 = NewState;
		Tuple ->
			NewTuple = Tuple#ets_active_open_time_template{other = 0, time = 0},
			List = lists:keyreplace(ActiveId, #ets_active_open_time_template.active_id, NewState#state.active_open_time_list, NewTuple),
			NewState1 = NewState#state{active_open_time_list = List}
	end,
	{noreply, NewState1};
do_cast({update_1008}, State) ->
	case lists:keyfind(1008, #ets_active_open_time_template.active_id, State#state.active_open_time_list) of
		false ->
			NewState = State;
		Info ->
			?DEBUG("update_1008:~p",[Info]),
			NewInfo = Info#ets_active_open_time_template{open_time=[75600], continue_time = 1800},
			NewList = lists:keyreplace(1008, #ets_active_open_time_template.active_id, State#state.active_open_time_list, NewInfo),
			?DEBUG("update_1008:~p",[NewInfo]),
			NewState = State#state{active_open_time_list = NewList}
	end,
	{noreply, NewState};

do_cast({show_state}, State) ->
	?WARNING_MSG("show_state:~p",[State]),
	{noreply, State};

%% 停止
do_cast({stop}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_active cast is not match:~w",[Info]),
    {noreply, State}.

do_info({'EXIT',_Pid,_Reason}, State) ->
	{noreply, State};

do_info({active_loop}, State) ->
	erlang:send_after(?ACTIVE_LOOP_TIME, self(),{active_loop}),
	if
		State#state.open_active_id =< 0 ->%%如果一个活动在进行中，不再去判断是否有新的活动开启
			List = lib_active_manage:active_loop(State#state.active_open_time_list),
			NewState = State#state{active_open_time_list = List};
		true ->
			NewState = State
	end,
	{noreply, NewState};

do_info(Info, State) ->
	?WARNING_MSG("mod_active info is not match:~w",[Info]),
    {noreply, State}.