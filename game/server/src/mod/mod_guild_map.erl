%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :公会副本
%%%
%%% Created : 2013-5-30
%%% -------------------------------------------------------------------
-module(mod_guild_map).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl"). 

-define(Scan_Time_Tick, (1 * 1000)).
%% --------------------------------------------------------------------
%% External exports
-export([get_guild_map_pid/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


-record(state, {guild_id = 0}).

%% ====================================================================
%% External functions
%% ====================================================================
start({GuildId, SceneProcessName, Worker_id}) ->
    gen_server:start(?MODULE, {GuildId, SceneProcessName, Worker_id}, []).

start_link({GuildId, SceneProcessName, Worker_id}) ->
    gen_server:start_link(?MODULE, {GuildId, SceneProcessName, Worker_id}, []).

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
init({GuildId, SceneProcessName, Worker_id}) ->
	try
		do_init({GuildId, SceneProcessName, Worker_id})
	catch
		_:Reason ->
			?WARNING_MSG("mod_guild_map handle_call is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create map is error"}
	end.

do_init({GuildId, SceneProcessName, _Worker_id}) ->
	misc:register(global, SceneProcessName, self()),
	State = #state{guild_id = GuildId},
	
	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
	misc:write_monitor_pid(self(),?MODULE, {State}),
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
			?WARNING_MSG("mod_guild_map handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_guild_map handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_guild_map handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
get_guild_map_pid(GuildID) ->
	SceneProcessName = misc:create_process_name(scene_guild_p,[GuildID, 0]),
	case misc:whereis_name({global, SceneProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_scene(GuildID, SceneProcessName)
			end;
		_ ->
			start_mod_scene(GuildID, SceneProcessName)
	end.

%%启动场景模块 (加锁保证全局唯一)
start_mod_scene(GuildID, SceneProcessName) ->
	global:set_lock({SceneProcessName, undefined}),	
	MapPid = 
		case misc:whereis_name({global, SceneProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_scene(GuildID, SceneProcessName)
				end;
			_ ->
				start_scene(GuildID, SceneProcessName)
		end,	
	global:del_lock({SceneProcessName, undefined}),
	MapPid.

%% 启动场景模块
start_scene(GuildID, SceneProcessName) ->
	Pid =
		case mod_guild_map:start({GuildID, SceneProcessName, 0}) of
			{ok, NewMapPid} ->
				NewMapPid;
			_ ->
				undefined
		end,
	Pid.

%%----------------------------do_call-------------------------------------------------

do_call(Info, _, State) ->
	?WARNING_MSG("mod_guild_map call is not match:~w",[Info]),
    {reply, ok, State}.
%%----------------------------do_cast-------------------------------------------------
do_cast(Info, State) ->
	?WARNING_MSG("mod_guild_map cast is not match:~w",[Info]),
    {noreply, State}.
%%----------------------------do_info-------------------------------------------------
do_info({scan_time}, State) ->
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_guild_map info is not match:~w",[Info]),
    {noreply, State}.

