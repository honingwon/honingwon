-module(mod_active_monster).

-behaviour(gen_server).
-include("common.hrl").
-include("record.hrl").

-export([start_link/0, stop/0, get_mod_monster_pid/0, enter_active_monster/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%% ====================================================================
%% External functions
%% ====================================================================

%% -record(state, {monster = []}).
-define(LOOP_TIME_TOP_LIST, 1800).		%% 发送排行榜时间间隔
-define(ENTER_LV, 40).					%% 进入副本最低等级

%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(self(), {stop}).

get_mod_monster_pid() ->
	ProcessName = misc:create_process_name(duplicate_p, [?ACTIVE_MONSTER_MAP_ID, 0]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_monster(ProcessName)
			end;
		_ ->
			start_mod_monster(ProcessName)
	end.

%%加锁保证全局唯一
start_mod_monster(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_monster()
				end;
			_ ->
				start_monster()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
	
start_monster() ->
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start monster error:~p~n",[R]),
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
			?WARNING_MSG("mod_monster init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	process_flag(trap_exit, true),	
	ProcessName = misc:create_process_name(duplicate_p, [?ACTIVE_MONSTER_MAP_ID, 0]),
	misc:register(global, ProcessName, self()),
	misc:write_monitor_pid(self(),?MODULE, {}),

	State = lib_active_monster:create_active_monster_war(),
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
			?WARNING_MSG("mod_monster  call is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_monster cast is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_monster info is exception:~w~",[Reason]),
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

enter_active_monster(PlayerStatus) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?MONSTER_ACTIVE_ID}) of
		true when PlayerStatus#ets_users.level >= ?ENTER_LV ->
			gen_server:call(get_mod_monster_pid(), {'enter_active_monster', 
													PlayerStatus#ets_users.id, 
													PlayerStatus#ets_users.nick_name, 
													PlayerStatus#ets_users.other_data#user_other.pid, 
													PlayerStatus#ets_users.other_data#user_other.pid_send,
													PlayerStatus#ets_users.fight});
		_ ->
			{error,?ER_NOT_ENOUGH_LEVEL}
	end.

%%---------------------do_call--------------------------------
%%玩家进入活动地图
do_call({'enter_active_monster', UserId, NickName,  PlayerPid,PidSend, Fight}, _, State) ->
	if State#r_active_monster.war_state =:= 1 ->
		case lists:keyfind(UserId, #r_active_monster_user.user_id, State#r_active_monster.player_list) of
			false ->
				{Info,PosX,PosY} = lib_active_monster:enter_active_monster(UserId, Fight, NickName, PlayerPid, PidSend),
				UserList = [Info|State#r_active_monster.player_list],
				NewState = State#r_active_monster{player_list = UserList},
				{reply, {ok, self(), NewState#r_active_monster.map_pid,NewState#r_active_monster.map_only_id,NewState#r_active_monster.map_id,PosX,PosY}, NewState};
			_ ->
				{reply,{error,?ER_UNKNOWN_ERROR},State}
		end;
	true ->
		{reply,{error,?ER_UNKNOWN_ERROR},State}
	end;

%%离线玩家上线
do_call({'login_in_duplicate', {UserId, UserPid, SendPid, _VipLevel,_Sex}},  _, State) ->	
	lib_active_monster:login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State);

do_call(Info, _, State) ->
	?WARNING_MSG("mod_active_monster call is not match:~w",[Info]),
    {reply, ok, State}.

%---------------------------------------- do_cast ---------------------------------------------------
%% 停止
do_cast({stop}, State) ->
	{stop, normal, State};

%%获取前十名
do_cast({get_top_list, Pid}, State) ->
%% 	{ok, BinData} = pt_23:write(?PP_ACTIVE_MONSTER_TOP_LIST, State),
%% 	lib_send:send_to_id(Pid, BinData),
	{noreply, State};

%%boss死亡更改boss状态，结束活动
do_cast({monster_dead, MonsterId, UserId, _MType, _Pid}, State) ->
	NewState = 
	if (MonsterId div 10) =:= (?ACTIVE_BOSS_ID div 10) ->
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?MONSTER_ACTIVE_ID}),
			gen_server:cast(self(), {send_award}),
			State#r_active_monster{monster_state = 0, war_state = 0};
		true ->
			State
	end,
	{noreply, NewState};

%%玩家对boss造成伤害
do_cast({monster_hurt, TotalHurtHp, User_id, ReduceHp, _LeftHp, _}, State) ->
	case lists:keyfind(User_id, #r_active_monster_user.user_id, State#r_active_monster.player_list) of
		false ->
			NewState = State#r_active_monster{monster_lost_hp = TotalHurtHp},
			{noreply, NewState};
		Info ->
			NewInfo = Info#r_active_monster_user{damage = Info#r_active_monster_user.damage + ReduceHp},
			NewPList = lists:keyreplace(User_id, #r_active_monster_user.user_id, State#r_active_monster.player_list, NewInfo),
			NewState = State#r_active_monster{player_list = NewPList, monster_lost_hp = TotalHurtHp},
			{noreply, NewState}
	end;

%%退出活动地图
do_cast({war_quit, User_id}, State) ->
	case lists:keyfind(User_id, #r_active_monster_user.user_id, State#r_active_monster.player_list) of
		false ->
			{noreply, State};
		Info ->
			NewPList = lists:keydelete(User_id, #r_active_monster_user.user_id, State#r_active_monster.player_list),
			NewState = State#r_active_monster{player_list = NewPList },
			{noreply, NewState}
	end;

%%离线
do_cast({off_line, User_id}, State) ->
	case lists:keyfind(User_id, #r_active_monster_user.user_id, State#r_active_monster.player_list) of
		false ->
			{noreply, State};
		Info ->				
			NewInfo = Info#r_active_monster_user{state = 0, offline_time = misc_timer:now_seconds()},
			NewPList = lists:keyreplace(User_id, #r_active_monster_user.user_id, State#r_active_monster.player_list, NewInfo),
			NewState = State#r_active_monster{player_list = NewPList},
			{noreply, NewState}
	end;

%%活动结束发送奖励
do_cast({send_award}, State) ->
	State1 = 
		if State#r_active_monster.war_state =:= 0 ->			
				TopList = lib_active_monster:loop_top_list(State#r_active_monster.player_list),
				NewState = State#r_active_monster{top_list = TopList},
				lib_active_monster:send_war_award(NewState),
				erlang:send_after(1000, self(), {shut_down,0}),
				NewState;
			true ->
				State
		end,
	{noreply, State1};

do_cast({set_continue_time, OverTime}, State) ->
	erlang:send_after(OverTime * 1000, self(),{active_over}),
	NewState = #r_active_monster{map_pid = State#r_active_monster.map_pid,
							   map_only_id = State#r_active_monster.map_only_id,
							   map_id = State#r_active_monster.map_id,
							   start_time = misc_timer:now_seconds(), %%开始时间
							   war_state = 1,
							   monster_state = 1,
							   continue_time = OverTime},
	erlang:send_after(?LOOP_TIME_TOP_LIST, self(), {loop, 1}),
	{noreply, NewState};

do_cast(Info, State) ->
	?WARNING_MSG("mod_active_monster cast is not match:~w",[Info]),
    {noreply, State}.

% ----------------------------------------- do_info ----------------------------------------

%%活动结束
do_info({active_over}, State) ->
	if
		State#r_active_monster.war_state =:= 1 ->
			?WARNING_MSG("active_over:~p",[{self(),State#r_active_monster.war_state}]),			
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?MONSTER_ACTIVE_ID}),
			NewState = State#r_active_monster{war_state = 0},
			gen_server:cast(self(), {send_award}),			
			{noreply, NewState};
		true ->
			{noreply, State}
	end;

%%循环发送排行榜 Continue在战斗结束后还进行一次排行榜的计算确保数据正确
do_info({loop, Continue}, State) ->
	if 
		Continue =:= 1 ->
			if 
				State#r_active_monster.war_state =:= 1 ->
					erlang:send_after(?LOOP_TIME_TOP_LIST, self(), {loop, 1});
				true ->
					erlang:send_after(?LOOP_TIME_TOP_LIST, self(), {loop, 0})
			end,
			NewState1 = lib_active_monster:loop_off_line_list(State),
			TopList = lib_active_monster:loop_top_list(NewState1#r_active_monster.player_list),
			NewState = NewState1#r_active_monster{top_list = TopList},
			F = fun(Info) ->
				{ok, BinData} = pt_23:write(?PP_ACTIVE_MONSTER_TOP_LIST, [NewState, Info#r_active_monster_user.damage, Info#r_active_monster_user.nick_name]),
				lib_send:send_to_sid(Info#r_active_monster_user.send_pid, BinData)
				end,
			lists:foreach(F, NewState#r_active_monster.player_list),
			{noreply, NewState};
		true ->
			{noreply, State}
	end;

%%停止boss活动模块
do_info({'shut_down',T}, State) ->
	F = fun(Info,L) ->
			if
				Info#r_active_monster_user.state =:= 0 ->
					L;
				true ->
					case misc:is_process_alive(Info#r_active_monster_user.user_pid) of
						true -> 
							gen_server:cast(Info#r_active_monster_user.user_pid, {'quit_war_timeout'}),
							[Info|L];
						false ->
							L
					end
			end
		end,
	case State#r_active_monster.player_list of
		[] ->
			lib_pvp_duplicate:clear_duplicate_and_map(State#r_active_monster.map_pid),
			?WARNING_MSG("shut_down:~p",[self()]),
			{stop, normal, State};
		List1 ->
			if 	T > 10 ->	%如果10秒后还是有异常直接停止
					lib_pvp_duplicate:clear_duplicate_and_map(State#r_active_monster.map_pid),
					?WARNING_MSG("shut_down:~p",[{self(), List1}]),
					{stop, normal, State};
				true ->
					List = lists:foldl(F,[], List1),
					erlang:send_after(500, self(), {'shut_down', T + 1}),
					{noreply, State#r_active_monster{player_list = List}}
			end
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_active_monster info is not match:~w",[Info]),
    {noreply, State}.