%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-6-3
%%% -------------------------------------------------------------------
-module(mod_active_refesh_monster).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start_link/1,stop/0,get_active_refesh_monster_pid/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {active_id = 0,
				refesh_monster = []}).

-define(MOD_LOOP_TIEM, 60000). %%pvp1匹配循环时间

%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================
start_link(ActiveId) ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [ActiveId], []).

stop() ->
	gen_server:cast(?MODULE, {stop, ""}).

get_active_refesh_monster_pid(ActiveId) ->
	ProcessName = mod_active_refesh_monster_p,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_active_refesh_monster(ProcessName, ActiveId)
			end;
		_ ->
			start_mod_active_refesh_monster(ProcessName, ActiveId)
	end.

%%启动活动1001监控模块 (加锁保证全局唯一)
start_mod_active_refesh_monster(ProcessName, ActiveId) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_active_refesh_monster(ActiveId)
				end;
			_ ->
				start_active_refesh_monster(ActiveId)
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启活动1001监控模块
start_active_refesh_monster(ActiveId) ->
%%     case supervisor:start_child(
%%                server_sup,
%%                {mod_active_refesh_monster,
%%                 {mod_active_refesh_monster, start_link,[ActiveId]},
%%                 permanent, 10000, worker, [mod_active_refesh_monster]}) of
	case start_link(ActiveId) of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_active_refesh_monster error:~p~n",[R]),
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
init([ActiveId]) ->
	try
		do_init([ActiveId])
	catch
		_:Reason ->
			?WARNING_MSG("mod_active_refesh_monster init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init([ActiveId]) ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	misc:register(global, mod_active_refesh_monster_p , self()),
	%%初始化活动配置数据
 	%List = lib_active_manage:init_active_open_time(),
	List =  lib_active_refesh_monster:refresh_monster(ActiveId),		
	State = #state{active_id = ActiveId, refesh_monster = List},	
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
			?WARNING_MSG("mod_active_refesh_monster handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_active_refesh_monster handle_cast is exception:~w~n,Info:~w",[Reason, Msg]),
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
			?WARNING_MSG("mod_active_refesh_monster handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
	gen_server:cast(mod_active:get_active_pid(), {terminal, State#state.active_id}),
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
	?WARNING_MSG("mod_active_refesh_monster call is not match:~w",[Info]),
    {reply, ok, State}.

do_cast({set_continue_time, OverTime}, State) ->
	%?DEBUG("set_continue_time:~p",[OverTime]),
	erlang:send_after(OverTime * 1000, self(),{active_over}),
	{noreply, State};
%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_active_refesh_monster cast is not match:~w",[Info]),
    {noreply, State}.

do_info({active_over}, State) ->
%% 	if
%% 		State#state.refesh_monster =/= [] ->
%% 			[{MapId, MList, CList}] = State#state.refesh_monster,
%% 			MapPid = mod_map:get_scene_pid(MapId),
%% 			gen_server:cast(MapPid, {remove_active_refresh_monster, MList, CList});
%% 		true ->
%% 			skip
%% 	end,	
	stop(),
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_active_refesh_monster info is not match:~w",[Info]),
    {noreply, State}.
