%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-5-14
%%% -------------------------------------------------------------------
-module(mod_boss_manage).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start_link/0,stop/0,get_boss_manage_pid/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {list = []}).

-define(LOOP_TIEM, 1000). %%循环时间
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

get_boss_manage_pid() ->
	ProcessName = mod_boss_manage_process_name,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_boss_manage(ProcessName)
			end;
		_ ->
			start_mod_boss_manage(ProcessName)
	end.

%%启动活动1001监控模块 (加锁保证全局唯一)
start_mod_boss_manage(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_boss_manage()
				end;
			_ ->
				start_boss_manage()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启活动1001监控模块
start_boss_manage() ->
    case supervisor:start_child(
               server_sup,
               {mod_boss_manage,
                {mod_boss_manage, start_link,[]},
                permanent, 10000, worker, [mod_boss_manage]}) of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_boss_manage error:~p~n",[R]),
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
			?WARNING_MSG("mod_boss_manage init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	misc:register(global, mod_boss_manage_process_name , self()),
	%%初始化boss数据
 	List = lib_boss_manage:init_boss_template(),
	State = #state{list = List},
	erlang:send_after(?LOOP_TIEM, self(),{boss_manage_loop}),
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
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_boss_manage call is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_boss_manage cast is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_boss_manage info is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
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
	?WARNING_MSG("mod_boss_manage call is not match:~w",[Info]),
    {reply, ok, State}.

do_cast({boss_dead, MonsterId}, State) ->
	NewList = lib_boss_manage:update_boss_dead(MonsterId, State#state.list),
	NewState = State#state{list = NewList},
	{noreply, NewState};

do_cast({boss_relive, MonsterId}, State) ->
	NewList = lib_boss_manage:update_boss_relive(MonsterId, State#state.list),
	NewState = State#state{list = NewList},
	{noreply, NewState};

do_cast({request_boss_info, Pid}, State) ->
	{ok, Bin} = pt_23:write(?PP_BOSS_INFO,[State#state.list]),
	lib_send:send_to_sid(Pid, Bin),
	{noreply, State};

do_cast({request_boss_num, Pid}, State) ->
	Bin = lib_boss_manage:pack_boss_alive_num(State#state.list),
	lib_send:send_to_sid(Pid, Bin),
	{noreply, State};

do_cast({request_boss_info1}, State) ->
	?DEBUG("request_boss_info:~p",[State#state.list]),
	{noreply, State};
do_cast(Info, State) ->
	?WARNING_MSG("mod_boss_manage cast is not match:~w",[Info]),
    {noreply, State}.

do_info({boss_manage_loop},State) ->
	NewList = lib_boss_manage:loop_boss_relive(State#state.list),
	NewState =  State#state{list = NewList},
	erlang:send_after(?LOOP_TIEM, self(),{boss_manage_loop}),
	{noreply, NewState};

do_info(Info, State) ->
	?WARNING_MSG("mod_boss_manage info is not match:~w",[Info]),
    {noreply, State}.
