%%%-------------------------------------------------------------------
%%% Module  : mod_team_agent
%%% Author  : Lincoln
%%% Created : 2011-3-20
%%% Description : 
%%%-------------------------------------------------------------------
-module(mod_team_agent).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

-define(INDEX, 1).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([get_mod_team_agent_pid/0, 
		 start_link/1, 
		 start/1, 
		 stop/0, 
		 get_index/0, 
		 insert_team/1, 
		 remove_team/1, 
		 get_notfull/5, 
		 get_team_info/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%====================================================================
%% External functions
%%====================================================================
%%取得组队监控进程，随机选择一个工作进程
get_mod_team_agent_pid() ->
	ProcessName = misc:create_process_name(mod_team_agent, [0]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) -> 
			case misc:is_process_alive(Pid) of
				true ->
					WorkerId = random:uniform(?TEAM_WORKER_NUMBER),
					ProcessName_1 = misc:create_process_name(mod_team_agent, [WorkerId]),
					WorkerPid = misc:whereis_name({global, ProcessName_1}),
					{Pid, WorkerPid};
				false ->
					ProcessPid = start_team_manage(ProcessName),
					{ProcessPid, ProcessPid}
			end;
		_ ->
			ProcessPid = start_team_manage(ProcessName),
			{ProcessPid, ProcessPid}
	end.
%%启动组队监控进程
start_team_manage(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid = 
		case supervisor:start_child(server_sup, 
						{mod_team_agent,
						{mod_team_agent, start_link,[[ProcessName, 0]]},
						permanent, 10000, worker, [mod_team_agent]}) of
			{ok, Pid} ->
				Pid;
			_ ->
				undefined
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
%%启动队伍管理进程
start_link([ProcessName, WorkerId]) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [ProcessName, WorkerId], []).
%%
start([ProcessName, WorkerId]) ->
    gen_server:start(?MODULE, [ProcessName, WorkerId], []).
%%
stop() ->
    gen_server:call(?MODULE, stop).

%%获取队伍ID，使用主管理进程
get_index() ->
%% 	ProcessName = misc:create_process_name(mod_team_agent, [0]),
	{Pid, _} = get_mod_team_agent_pid(),
	try
		gen_server:call(Pid, get_index)	
	catch
		_:_ -> 0
	end.
%%添加或更新队伍信息
insert_team(TeamInfo) when is_record(TeamInfo, ets_team) ->
	{_, WorkerPid} = get_mod_team_agent_pid(),
	try
		gen_server:cast(WorkerPid, {insert, TeamInfo})
	catch
		_:_ -> skip
	end.
%%从ets移除队伍信息
remove_team(TeamInfo) when is_record(TeamInfo, ets_team) ->
	{_, WorkerPid} = get_mod_team_agent_pid(),
	try
		gen_server:cast(WorkerPid, {remove, TeamInfo})
	catch
		_:_ -> skip
	end.

%%查找未满队伍
get_notfull(UserID, MapPid, TeamID, MapID, PidSend) -> 
	{_, WorkerPid} = get_mod_team_agent_pid(),
	%% 缺少队伍列表
	gen_server:cast(MapPid, {get_scene_user_with_no_team, WorkerPid, UserID, TeamID, MapID, PidSend}).
	
	%try
	%	gen_server:call(WorkerPid, {get_not_full, [MapId, TeamId]})
	%catch
	%	_:_ -> []
	%end.

%%取得队伍信息
get_team_info(TeamId) ->
	{_, WorkerPid} = get_mod_team_agent_pid(),
	try
		gen_server:call(WorkerPid, {get_team_info, TeamId})
	catch
		_:_ -> undefined
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
init([ProcessName, WorkerId]) ->
%% 	?PRINT("init team manager name:~p pid: ~p~n", [ProcessName, self()]),
	process_flag(trap_exit, true),
 	misc:register(global, ProcessName, self()),
	if WorkerId =:= 0 ->
		   put(index, ?INDEX),
		   ets:new(?ETS_TEAM, [{keypos, #ets_team.pid}, named_table, public, set]),		%%队伍信息
		   misc:write_monitor_pid(self(), ?MODULE, {?TEAM_WORKER_NUMBER}),
		   misc:write_system_info(self(), ?MODULE, {}),
		   %% 启动多个组队服务进程
		   lists:foreach(
			 fun(Id) ->
					 Name = misc:create_process_name(mod_team_agent, [Id]),
					 mod_team_agent:start([Name, Id])
			 end,
			 lists:seq(1, ?TEAM_WORKER_NUMBER));
%% 		   ?PRINT("Team Global Manager init ok.~n");
	   true ->
		   ok
	end,
    {ok, []}.

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
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_team_agent handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_team_agent handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_team_agent handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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
	misc:delete_system_info(self()),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Local functions
%%====================================================================

%%---------------------do_call--------------------------------
%%提交任务
%%获取队伍ID,
do_call(get_index, _From, State) ->
	Index = get(index),
	put(index, Index + 1),
%% 	?PRINT("get team id:~p~n", [Index]),
    {reply, Index, State};
%%     {reply, State, State + 1};
%%查询未满的队伍列表
%do_call({get_not_full, [MapId, TeamId]}, _From, State) ->
% 	Ms = 
%		case MapId > 0 of
%			false -> ets:fun2ms(fun(T) when length(T#ets_team.member) < ?TEAM_MEMBER_MAX, T#ets_team.id =/= TeamId -> T end);
%			_ -> ets:fun2ms(fun(T) when length(T#ets_team.member) < ?TEAM_MEMBER_MAX, T#ets_team.leadermap =:= MapId, T#ets_team.id =/= TeamId -> T end)
%		end,
%	L = ets:select(?ETS_TEAM, Ms),
 %   {reply, L, State};
%%查询队伍信息
do_call({get_team_info, TeamId}, _From, State) ->
 	Ms = ets:fun2ms(fun(T) when T#ets_team.id =:= TeamId -> T end),
	L = case ets:select(?ETS_TEAM, Ms) of
			[I | _] -> I;
			[] -> []
		end,
    {reply, L, State};
do_call(Info, _, State) ->
	?WARNING_MSG("mod_team_agent call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%%添加队伍
do_cast({insert, TeamInfo}, State) ->
%% 	?PRINT("new team:~p~n", [TeamInfo]),
	ets:insert(?ETS_TEAM, TeamInfo),
    {noreply, State};
%%移除队伍
do_cast({remove, TeamInfo}, State) ->
%% 	?PRINT("remove team:~p~n", [TeamInfo]),
	ets:delete(?ETS_TEAM, TeamInfo#ets_team.pid),
    {noreply, State};

%% %%查找没有队伍的玩家及空队伍
do_cast({get_notfull_and_no_team, MapPid, UserID, TeamID, MapID, PidSend}, State) ->
	MS = ets:fun2ms(fun(T) when length(T#ets_team.member) < ?TEAM_MEMBER_MAX, T#ets_team.leadermap =:= MapID, 
									   T#ets_team.id =/= TeamID -> T end),
	TL = ets:select(?ETS_TEAM, MS),
	gen_server:cast(MapPid, {get_scene_user_with_no_team, TL, UserID, TeamID, MapID, PidSend}),
	{noreply, State};
	

%% %%查找没有队伍的玩家及空队伍
%% do_cast({get_notfull_and_no_team, PL, TeamID, MapID, PidSend}, State) ->
%% 	Ms = ets:fun2ms(fun(T) when length(T#ets_team.member) < ?TEAM_MEMBER_MAX, T#ets_team.leadermap =:= MapID, 
%% 									   T#ets_team.id =/= TeamID -> T end),
%% 	TL = ets:select(?ETS_TEAM, Ms),
%% 	{ok, DataBin} = pt_17:write(?PP_TEAM_NOFULL_MSG, [TL, PL]),
%% 	lib_send:send_to_sid(PidSend, DataBin),
%% 	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_team_agent cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
do_info(Info, State) ->
	?WARNING_MSG("mod_team_agent info is not match:~w",[Info]),
    {noreply, State}.



