%% Author: Administrator
%% Created: 2011-5-10
%% Description: TODO: Add description to mod_statistics
-module(mod_global_statistics).


-define(Tick_Count, 1 * 60 * 1000).						%%每一分钟扫描一次
-define(Tick_Online_Count, 3).							%%在线人数，3分钟

%%
%% Include files
%%
-include("common.hrl").

%%
%% Exported Functions
%%
-export([start_link/0, start_mod_global_statistics/0, get_mod_global_statistics_pid/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%启动统计监控模块 (加锁保证全局唯一)
start_mod_global_statistics() ->
	ProcessName = mod_statistics_global,
	global:set_lock({ProcessName, undefined}),	
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_golbal_statistics()
				end;
			_ ->
				start_golbal_statistics()
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%启动统计监控树模块
start_golbal_statistics() ->
	case supervisor:start_child(
       		server_sup, {mod_global_statistics,
            		{mod_global_statistics, start_link,[]},
               		permanent, 10000, supervisor, [mod_global_statistics]}) of
		{ok, Pid} ->
			Pid;
		_ ->
			undefined
	end.

get_mod_global_statistics_pid() ->
	ProcessName = mod_statistics_global,
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				Pid;
			_ ->
				start_mod_global_statistics()
	end.

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
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	ProcessName = mod_statistics_global,
	misc:register(global, ProcessName, self()),
	
	erlang:send_after(?Tick_Count, self(), {mod_scan,0}),
	
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
			?WARNING_MSG("mod_global_statistics  handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_glbbal_statistics  handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_global_statistics  handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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
do_call(Info, _, State) ->
	?WARNING_MSG("mod_global_statistics call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------
%% 统一模块+过程调用(cast)
%%停止服务器
do_cast({'stop_server'}, State) ->
	lib_statistics:insert_online(),
	{stop, normal, State};

do_cast({'update_system_msg', Type, Msg, All_Begin_Date, All_End_Date, Interval_Time, Every_Begin_Date, Every_End_Date}, State) ->
	lib_statistics:update_system_msg(Type, Msg, All_Begin_Date, All_End_Date, Interval_Time, Every_Begin_Date, Every_End_Date),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_global_statistics cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%% 统一模块+过程调用(info)

%%在线人数统计
do_info({mod_scan, Count}, State) ->
	erlang:send_after(?Tick_Count, self(), {mod_scan, Count+1}),
	case Count rem ?Tick_Online_Count of
		0 ->
			lib_statistics:insert_online();
		_ ->
			skip
	end,
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_global_statistics info is not match:~w",[Info]),
    {noreply, State}.


