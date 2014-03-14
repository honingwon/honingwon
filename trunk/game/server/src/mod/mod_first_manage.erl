%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-9-27
%%% -------------------------------------------------------------------
-module(mod_first_manage).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([get_mod_first_manage_pid/0,stop/0,start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_first_manage_pid() ->
	ProcessName = mod_first_manage_process,
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
		   {mod_first_manage,
			{mod_first_manage, start_link, []},
			 permanent, 10000, worker, [mod_first_manage]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_first_manage error:~p~n", [R]),
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
    process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_first_manage_process,		
 	misc:register(global, ProcessName, self()),	
	
	ok = lib_sys_first:init_sys_first(),
	
	misc:write_monitor_pid(self(),?MODULE, {}),	
	erlang:send_after(1, self(), {update_first}),
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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_first_manage handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_first_manage handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_first_manage handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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

%%---------------------do_call--------------------------------
do_call(stop,_Form, State) ->
	{stop, normal, State};

do_call(Info, _From, State) ->
	?WARNING_MSG("mod_first_manage call is not match:~w",[Info]),
    {reply, ok, State}.
%%---------------------do_cast--------------------------------
do_cast({update_first}, State) ->
	erlang:send_after(1, self(), {update_first}),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_first_manage cast is not match:~w",[Info]),
    {noreply, State}.
%%---------------------do_info--------------------------------	
do_info({update_first}, State) ->%%目前只更新天下第一buff
	Now = misc_timer:now_seconds(),
	case ets:lookup(?ETS_SYS_FIRST, ?PVP_FIRST_TYPE) of
		[] ->skip;
			%erlang:send_after(3600000, self(), {update_first});
		[Info] ->
			if	Info#ets_sys_first.user_id =:= 0 ->
					skip;
					%erlang:send_after(3600000, self(), {update_first});
				Info#ets_sys_first.expires_time =< Now ->
					lib_sys_first:remove_pvp_first();
					%erlang:send_after(3600000, self(), {update_first});
				true ->
					Time = Info#ets_sys_first.expires_time - Now,
					erlang:send_after(Time * 1000, self(), {update_first})
			end
	end,
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_first_manage info is not match:~w",[Info]),
    {noreply, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------


