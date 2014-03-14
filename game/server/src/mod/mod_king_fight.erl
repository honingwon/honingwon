-module(mod_king_fight).

-behaviour(gen_server).

-include("common.hrl").

-export([start_link/0, stop/0, get_mod_king_fight_pid/0, enter_king_war/2, king_war_kill/2]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(LOOP_OFFLINE_TIME, 3000).
-define(KILL_PLAYER_POINT, 2).
-define(KILL_ITEM_POINT, 10).
-define(ENTER_LV, 40).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(self(), {stop}).

get_mod_king_fight_pid() ->
	ProcessName = misc:create_process_name(duplicate_p, [?ACTIVE_KING_FIGHT_MAP_ID, 0]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_king_fight(ProcessName)
			end;
		_ ->
			start_mod_king_fight(ProcessName) 
	end.

%%加锁保证全局唯一
start_mod_king_fight(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_king_fight()
				end;
			_ ->
				start_king_fight()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
	
start_king_fight() ->
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start king_fight error:~p~n",[R]),
				undefined
	end.

init([]) ->
	try
		do_init()
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_war init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	process_flag(trap_exit, true),	
	ProcessName = misc:create_process_name(duplicate_p, [?ACTIVE_KING_FIGHT_MAP_ID, 0]),
	misc:register(global, ProcessName, self()),
	misc:write_monitor_pid(self(),?MODULE, {}),

	State = lib_king_fight:create_king_fight_war(),
	{ok, State}.

handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_war  call is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_war cast is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

handle_info(Info, State) ->
	try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_war info is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

enter_king_war(PlayerStatus, Camp) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?KING_FIGHT_ACTIVE_ID}) of
		true when PlayerStatus#ets_users.level >= ?ENTER_LV ->
			gen_server:call(get_mod_king_fight_pid(), {'enter_king_war', 
													PlayerStatus#ets_users.id, 
													PlayerStatus#ets_users.nick_name, 
													PlayerStatus#ets_users.other_data#user_other.pid, 
													PlayerStatus#ets_users.other_data#user_other.pid_send,
													PlayerStatus#ets_users.club_id,
													Camp});
		_ ->
			{error,?ER_NOT_ENOUGH_LEVEL}
	end.

king_war_kill(PlayerStatus, DeadId) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?KING_FIGHT_ACTIVE_ID}) of
		true ->
			gen_server:cast(get_mod_king_fight_pid(), {kill_player, PlayerStatus#ets_users.id, DeadId});
		_ ->
			{error,?_LANG_KING_WAR_NOT_OPEN}
	end.

%% ========================================== do_call ====================================

do_call({'enter_king_war', UserId, NickName,  PlayerPid,PidSend, Guild_id, Camp}, _, State) ->
	if State#r_king_war.defence_guild_id =:=0 andalso Camp =:= ?KING_FINGHT_DEF_CAMP ->
		lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ?_LANG_KING_WAR_FIRST]),
		{reply,{error,?ER_UNKNOWN_ERROR},State};
	State#r_king_war.war_state =:= 1 ->
		case lists:keyfind(UserId, #r_king_war_user.user_id, State#r_king_war.player_list) of
			false ->
				{PlayerInfo,PosX,PosY} = lib_king_fight:enter_king_war(UserId, Guild_id, NickName, PlayerPid, PidSend, Camp, State),
				PlayerList = [PlayerInfo|State#r_king_war.player_list],
				NowTime = misc_timer:get_time(misc_timer:now_seconds()),
				Time = State#r_king_war.continue_time + misc_timer:get_time(State#r_king_war.start_time) - NowTime,
				{ok, Bin} = pt_23:write(?PP_ACTIVE_KING_WAR_CONTINUE_TIME, [Time]),
				NewState = State#r_king_war{player_list = PlayerList},
				lib_send:send_to_sid(PlayerInfo#r_king_war_user.send_pid, Bin),
				{reply, {ok, PlayerInfo#r_king_war_user.camp, self(), NewState#r_king_war.map_pid,NewState#r_king_war.map_only_id, NewState#r_king_war.map_id, PosX, PosY}, NewState};	
			_ ->
				{reply,{error,?ER_UNKNOWN_ERROR},State}
		end;
	true ->
		lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ?_LANG_KING_WAR_NOT_OPEN]),
		{reply,{error,?ER_UNKNOWN_ERROR},State}
	end;

do_call({'login_in_duplicate', {UserId, UserPid, SendPid, _VipLevel,_Sex}},  _, State) ->	
	NowTime = misc_timer:get_time(misc_timer:now_seconds()),
	Time = State#r_king_war.continue_time + misc_timer:get_time(State#r_king_war.start_time) - NowTime,
	{ok, Bin} = pt_23:write(?PP_ACTIVE_KING_WAR_CONTINUE_TIME, [Time]),
	lib_send:send_to_sid(SendPid, Bin),
	lib_king_fight:login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State);

do_call(Info, _, State) ->
	?WARNING_MSG("mod_king_war call is not match:~w",[Info]),
    {reply, ok, State}.

%%============================== do_cast ===============================

do_cast({monster_dead, MonsterId, UserId, _MType, _Pid}, State) -> 
	if MonsterId =:= ?KING_FIGHT_ITEM_ID ->
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?KING_FIGHT_ACTIVE_ID}),
			erlang:send_after(1000, self(), {active_over}),
			NewState1 = lib_king_fight:add_point(UserId, ?KILL_ITEM_POINT, State),
			NewState = NewState1#r_king_war{war_result = 0};
		true ->
			case lists:keyfind(MonsterId, 1, ?KING_FIGHT_MONSTER_ID) of
				false ->
					NewState = State;
				{_,Point} ->
					NewState = lib_king_fight:add_point(UserId, Point, State)
			end
	end,
	{noreply, NewState};


%%玩家对圣物造成伤害
do_cast({monster_hurt, TotalHp, _User_id, _ReduceHp, LeftHp, MonId}, State) ->
	if MonId =:= ?KING_FIGHT_ITEM_ID ->
		NewState = State#r_king_war{lost_hp = LeftHp};
	true ->
		NewState = State
	end,
	{noreply, NewState};

%%击杀玩家获得
do_cast({kill_player,UserId, DeadID}, State) ->
	?DEBUG("~p",[{UserId}]),
	NewState = lib_king_fight:add_point(UserId, DeadID,?KILL_PLAYER_POINT, State),
	{noreply, NewState};

do_cast({'war_quit', UserId}, State) ->
	%?DEBUG("war_quit~p~n",[State]),
	case lists:keyfind(UserId, #r_king_war_user.user_id, State#r_king_war.player_list) of
		false ->
			{noreply, State};
		_Info ->
			NewPList = lists:keydelete(UserId, #r_king_war_user.user_id, State#r_king_war.player_list),
			NewState = State#r_king_war{player_list = NewPList},
			{noreply, NewState}
	end;

do_cast({'off_line', UserId}, State) ->
	case lists:keyfind(UserId, #r_king_war_user.user_id, State#r_king_war.player_list) of
		false ->
			{noreply, State};
		Info ->				
			NewInfo = Info#r_king_war_user{state = 0, off_line_time = misc_timer:now_seconds()},
			NewPList = lists:keyreplace(UserId, #r_king_war_user.user_id, State#r_king_war.player_list, NewInfo),
			NewState = State#r_king_war{player_list = NewPList},
			{noreply, NewState} 
	end; 

do_cast({set_continue_time, OverTime}, State) ->
	erlang:send_after(OverTime * 1000, self(),{active_over}), 
	
	NewState = State#r_king_war{map_pid = State#r_king_war.map_pid,
							   map_only_id = State#r_king_war.map_only_id,
							   map_id = State#r_king_war.map_id,
							   start_time = misc_timer:now_seconds(), %%开始时间
							   war_result = 1,
							   continue_time = OverTime},
	erlang:send_after(?LOOP_OFFLINE_TIME, self(), {loop}),  
	{noreply, NewState};

do_cast({send_award}, State) ->
	if State#r_king_war.war_state =:= 0 ->			
		   	erlang:send_after(1000, self(), {shut_down,0}),
			lib_king_fight:send_king_war_award(State);
		true ->
			skip 
	end,
	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	?DEBUG("stop:~p",[_Reason]),
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_king_war cast is not match:~w",[Info]),
    {noreply, State}.

%%================================= do_info ===========================================
do_info({loop}, State) ->
	if State#r_king_war.war_state =:= 1 ->
			NewState = lib_king_fight:loop_off_line_list(State), 
			TopList =  lib_king_fight:loop_top_list(State#r_king_war.player_list),
			NewState1 = NewState#r_king_war{top_list = TopList},
			F = fun(Info) ->
				{ok, Bin} = pt_23:write(?PP_ACTIVE_KING_WAR_TOP_LIST, [TopList, State#r_king_war.lost_hp, Info#r_king_war_user.point, Info#r_king_war_user.camp]),
				lib_send:send_to_sid(Info#r_king_war_user.send_pid, Bin)
			end,
			lists:foreach(F, State#r_king_war.player_list),	
			erlang:send_after(?LOOP_OFFLINE_TIME, self(), {loop}),
			{noreply, NewState1};
		true ->
			{noreply, State}
	end;

do_info({active_over}, State) ->
	if
		State#r_king_war.war_state =:= 1 ->
			?WARNING_MSG("active_over:~p",[{self(),State#r_king_war.war_state}]),			
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?KING_FIGHT_ACTIVE_ID}),
			gen_server:cast(self(), {send_award}),
			NewState = State#r_king_war{war_state = 0},			
			{noreply, NewState};
		true ->
			?WARNING_MSG("active_over:~p",[{self(),State,State#r_king_war.war_state}]),
			gen_server:cast(self(), {send_award}),
			{noreply, State}
	end;

do_info({'shut_down',T}, State) ->
	F = fun(Info,L) ->
			if
				Info#r_king_war_user.state =:= 0 ->
					L;
				true ->
					case misc:is_process_alive(Info#r_king_war_user.user_pid) of
						true -> 
							gen_server:cast(Info#r_king_war_user.user_pid, {'quit_war_timeout'}), 
							[Info|L];
						false ->
							L
					end
			end
		end,
	case State#r_king_war.player_list of
		[] ->
			lib_pvp_duplicate:clear_duplicate_and_map(State#r_king_war.map_pid),
			?WARNING_MSG("shut_down:~p",[self()]),
			{stop, normal, State};
		List1 ->
			if 	T > 10 ->	%如果10秒后还是有异常直接停止
					lib_pvp_duplicate:clear_duplicate_and_map(State#r_king_war.map_pid),
					?WARNING_MSG("shut_down:~p",[{self(), List1}]),
					{stop, normal, State};
				true ->
					List = lists:foldl(F,[], List1),
					erlang:send_after(500, self(), {'shut_down', T + 1}),
					{noreply, State#r_king_war{player_list = List}}
			end
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_king_war info is not match:~w",[Info]),
    {noreply, State}.