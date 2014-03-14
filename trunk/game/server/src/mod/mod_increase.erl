%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-5-4
%%% -------------------------------------------------------------------
-module(mod_increase).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([
		 get_mod_increase_pid/0,
		 start_link/0,
		 stop/0,
		 get_duplicate_auto_id/0,
		 get_guest_auto_id/0,
		 get_guild_auto_id/0,
		 get_free_war_auto_id/0
		 ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
				duplicate_auto_id = 1,				%% 副本自增id
				guild_auto_id = 1,					%% 帮派Id
				free_war_auto_id = 1,				%% 神魔乱斗Id
				guest_auto_id = 10000,				%% 游客自增id
				item_auto_id = 1000000000			%%  物品自增id,需要先从数据库读取
				}).

-define(DEFAULT_GUEST_ID, 10000).			%默认的游客自增id
%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_increase_pid() ->
	ProcessName = mod_increase_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_increase(ProcessName)
			end;
		_ ->
			start_mod_increase(ProcessName)
	end.


%%启动监控模块 (加锁保证全局唯一)
start_mod_increase(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_increase()
				end;
			_ ->
				start_increase()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_increase() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_increase,
			{mod_increase, start_link, []},
			 permanent, 10000, worker, [mod_increase]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_increase error:~p~n", [R]),
			undefined
	end.

%% 获取副本自增Id
get_duplicate_auto_id() ->
	Pid = get_mod_increase_pid(),
	AutoId = gen_server:call(Pid, 'duplicate'),
	AutoId.

%% 获取副本自增Id
get_guild_auto_id() ->
	Pid = get_mod_increase_pid(),
	AutoId = gen_server:call(Pid, 'guild'),
	AutoId.

%% 获取自由战自增Id
get_free_war_auto_id() ->
	Pid = get_mod_increase_pid(),
	AutoId = gen_server:call(Pid, 'free_war'),
	AutoId.

%% 获取游客自增Id
get_guest_auto_id() ->
	Pid = get_mod_increase_pid(),
	AutoId = gen_server:call(Pid, 'guest'),
	AutoId.

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
	ProcessName = mod_increase_process,		
 	misc:register(global, ProcessName, self()),	
	GuestID =
		case db_agent:get_auto_guest_id() of 
			null ->
				?DEFAULT_GUEST_ID;
			Value ->
				tool:to_integer(Value)
		end,
	State = #state{
				   guest_auto_id = GuestID
				   },
	
	misc:write_monitor_pid(self(),?MODULE, {}),	
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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("DuplicateAutoId:~w, mod_increase handle_call is exception:~w~n,Info:~w",[State#state.duplicate_auto_id, Reason, Info]),
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
			?WARNING_MSG("DuplicateAutoId:~w, mod_increase handle_cast is exception:~w~n,Info:~w",[State#state.duplicate_auto_id, Reason, Info]),
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
			?WARNING_MSG("DuplicateAutoId:~w, mod_increase handle_info is exception:~w~n,Info:~w",[State#state.duplicate_auto_id, Reason, Info]),
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
%% 获取副本id
do_call('duplicate', _, State) ->
%% 	AutoId = State#state.duplicate_auto_id + 1,
%% 	NewState = State#state{duplicate_auto_id = AutoId},
	
	NewState = 
		case State#state.duplicate_auto_id < 99999 of
			true ->	
				AutoId = State#state.duplicate_auto_id + 1,
				State#state{duplicate_auto_id = AutoId};
			_ ->
				AutoId = 1,
				State#state{duplicate_auto_id = AutoId}
		end,
	{reply, AutoId, NewState};

%% 获取帮派副本id
do_call('guild', _, State) ->
	NewState = 
		case State#state.guild_auto_id < 99999 of
			true ->	
				AutoId = State#state.guild_auto_id + 1,
				State#state{guild_auto_id = AutoId};
			_ ->
				AutoId = 1,
				State#state{guild_auto_id = AutoId}
		end,
	{reply, AutoId, NewState};

%% 获取战场副本id
do_call('free_war', _, State) ->
	NewState = 
		case State#state.free_war_auto_id < 99999 of
			true ->	
				AutoId = State#state.free_war_auto_id + 1,
				State#state{free_war_auto_id = AutoId};
			_ ->
				AutoId = 1,
				State#state{free_war_auto_id = AutoId}
		end,
	{reply, AutoId, NewState};

do_call('guest', _, State) ->
	AutoId = State#state.guest_auto_id + 1,
	NewState = State#state{guest_auto_id = AutoId},
	{reply, AutoId, NewState};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_increase call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast(Info, State) ->
	?WARNING_MSG("mod_increase cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------	
do_info(Info, State) ->
	?WARNING_MSG("mod_increase info is not match:~w",[Info]),
    {noreply, State}.



