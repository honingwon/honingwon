-module(mod_guild_fight).

-behaviour(gen_server).
-include("common.hrl").

-export([start_link/0, stop/0, get_mod_guild_fight_pid/0, enter_guild_fight/1, guild_war_kill/2,
	 get_item_by_id/2, get_continue_time/1, monsterdead/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(LOOP_OFFLINE_TIME, 1000).

%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(self(), {stop}).

get_mod_guild_fight_pid() ->
	ProcessName = misc:create_process_name(duplicate_p, [?ACTIVE_GUILD_FIGHT_MAP_ID, 0]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_guild_fight(ProcessName)
			end;
		_ ->
			start_mod_guild_fight(ProcessName)
	end.

%%加锁保证全局唯一
start_mod_guild_fight(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_guild_fight()
				end;
			_ ->
				start_guild_fight()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
	
start_guild_fight() ->
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start guild_fight error:~p~n",[R]),
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
			?WARNING_MSG("mod_guild_fight init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	process_flag(trap_exit, true),	
	ProcessName = misc:create_process_name(duplicate_p, [?ACTIVE_GUILD_FIGHT_MAP_ID, 0]),
	misc:register(global, ProcessName, self()),
	misc:write_monitor_pid(self(),?MODULE, {}),

	State = lib_guild_fight:create_guild_fight_war(),
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
			?WARNING_MSG("mod_guild_fight  call is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_guild_fight cast is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_guild_fight info is exception:~w~",[Reason]),
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

enter_guild_fight(PlayerStatus) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_FIGHT_ACTIVE_ID}) of
		true ->
			gen_server:call(get_mod_guild_fight_pid(), {'enter_guild_fight', 
													PlayerStatus#ets_users.id, 
													PlayerStatus#ets_users.nick_name, 
													PlayerStatus#ets_users.other_data#user_other.pid, 
													PlayerStatus#ets_users.other_data#user_other.pid_send,
													PlayerStatus#ets_users.club_id});
		_ ->
			{error,?_LANG_GUILD_FIGHT_NOT_OPEN}
	end.

guild_war_kill(PlayerStatus, DeadId) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_FIGHT_ACTIVE_ID}) of
		true ->
			gen_server:cast(get_mod_guild_fight_pid(), {kill_player, PlayerStatus#ets_users.id, DeadId});
		_ ->
			{error,?_LANG_GUILD_FIGHT_NOT_OPEN}
	end.

%% guild_war_player_dead(DeadID) ->
%% 	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_FIGHT_ACTIVE_ID}) of
%% 		true ->
%% 			gen_server:cast(get_mod_guild_fight_pid(), {player_dead,DeadID});
%% 		_ ->
%% 			{error,?_LANG_GUILD_FIGHT_NOT_OPEN}
%% 	end.

get_continue_time(UserId) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_FIGHT_ACTIVE_ID}) of
		true ->
			gen_server:cast(get_mod_guild_fight_pid(), {get_continue_time, UserId});
		_ ->
			{error,?_LANG_GUILD_FIGHT_NOT_OPEN}
	end.

get_item_by_id(UserId, ItemID) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_FIGHT_ACTIVE_ID}) of
		true ->
			gen_server:cast(get_mod_guild_fight_pid(), {get_item, UserId, ItemID});
		_ ->
			{error,?_LANG_GUILD_FIGHT_NOT_OPEN}
	end.

monsterdead(UserId) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_FIGHT_ACTIVE_ID}) of
		true ->
			gen_server:cast(get_mod_guild_fight_pid(), {monster_dead, 900000501, UserId, 0, 0});
		_ ->
			{error,?_LANG_GUILD_FIGHT_NOT_OPEN}
	end.

%%---------------------do_call--------------------------------
do_call({'enter_guild_fight', UserId, NickName,  PlayerPid,PidSend, Guild_id}, _, State) ->
	if State#r_guild_fight.war_state =:= 1 ->
		UserInfo = lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list),
		if UserInfo =:= false orelse (is_record(UserInfo, r_guild_fight_user) andalso UserInfo#r_guild_fight_user.state =:= 2) ->
				{GuildInfo, PlayerInfo,PosX,PosY} = lib_guild_fight:enter_guild_fight(UserId, Guild_id, NickName, PlayerPid, PidSend, State, UserInfo),
				if UserInfo =:= false ->
					PlayerList = [PlayerInfo|State#r_guild_fight.player_list];
				true ->
					PlayerList = lists:keyreplace(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list, PlayerInfo)
				end,
				if GuildInfo =:= [] ->
					GuildList = State#r_guild_fight.guild_list;
				true ->
					GuildList = [GuildInfo|State#r_guild_fight.guild_list]
				end,
				NowTime = misc_timer:get_time(misc_timer:now_seconds()),
				Time = State#r_guild_fight.continue_time + misc_timer:get_time(State#r_guild_fight.start_time) - NowTime,
				{ok, Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, [Time, State#r_guild_fight.buff_guild_name, 0, []]),
				NewState = State#r_guild_fight{guild_list = GuildList, player_list = PlayerList},
				lib_send:send_to_sid(PlayerInfo#r_guild_fight_user.send_pid, Bin),
				{reply, {ok, 0, self(), NewState#r_guild_fight.map_pid,NewState#r_guild_fight.map_only_id,NewState#r_guild_fight.map_id,PosX,PosY}, NewState};				
			true ->
				{reply,{error,?ER_UNKNOWN_ERROR},State}
		end;
	true ->
		lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ?_LANG_GUILD_FIGHT_NOT_OPEN]),
		{reply,{error,?ER_UNKNOWN_ERROR},State}
	end;

do_call({'login_in_duplicate', {UserId, UserPid, SendPid, _VipLevel,_Sex}},  _, State) ->		
	lib_guild_fight:login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State);

do_call(Info, _, State) ->
	?WARNING_MSG("mod_guild_fight call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------
%%击杀玩家获得
do_cast({kill_player,UserId, DeadID}, Status) ->
	NewState = lib_guild_fight:kill_player(UserId, DeadID, Status),
	{noreply, NewState};

%% do_cast({player_dead, DeadID}, Status) ->
%% 	NewState = lib_guild_fight:kill_player(UserId, DeadID, Status),
%% 	{noreply, NewState};

%%击杀怪物获得
do_cast({monster_dead, MonsterId, UserId, _MType, _Pid}, Status) ->
	NewState = lib_guild_fight:kill_monster(MonsterId, UserId, Status),	
	{noreply, NewState};

do_cast({'war_quit', UserId}, State) ->
	%?DEBUG("war_quit~p~n",[State]),
	case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
		false ->
			{noreply, State};
		UserInfo ->
			NewUserInfo = UserInfo#r_guild_fight_user{state = 2},
			NewPList = lists:keyreplace(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list, NewUserInfo),
			NewState1 = State#r_guild_fight{player_list = NewPList },
			NewState = lib_guild_fight:dead_by_buff_offline(UserId, NewState1),
			{noreply, NewState}
	end;

do_cast({'off_line', UserId}, State) ->
	case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
		false ->
			{noreply, State};
		Info ->							
			NewInfo = Info#r_guild_fight_user{state = 0, offline_time = misc_timer:now_seconds()},
			NewPList = lists:keyreplace(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list, NewInfo),
			NewState = State#r_guild_fight{player_list = NewPList},
			NewState1 = lib_guild_fight:dead_by_buff_offline(UserId, NewState),
			{noreply, NewState1}
	end;

do_cast({set_continue_time, OverTime}, State) ->
	erlang:send_after(OverTime * 1000, self(),{active_over}),
	
	NewState = #r_guild_fight{map_pid = State#r_guild_fight.map_pid,
							   map_only_id = State#r_guild_fight.map_only_id,
							   map_id = State#r_guild_fight.map_id,
							   start_time = misc_timer:now_seconds(), %%开始时间
							   continue_time = OverTime},
	%?WARNING_MSG("set_continue_time:~p",[{OverTime,self(), NewState}]),
	erlang:send_after(?LOOP_OFFLINE_TIME, self(), {loop}),
	{noreply, NewState};

do_cast({send_award}, State) ->
	%%群发战斗结束内容
	if State#r_guild_fight.war_state =:= 0 ->			
			%lib_guild_fight:send_war_result(State),
		   	erlang:send_after(0, self(), {shut_down,0}),
			lib_guild_fight:send_guild_fight_award(State);
		true ->
			skip 
	end,
	{noreply, State};

do_cast({get_item, UserId, ItemId}, State) ->
	if State#r_guild_fight.war_state =:= 1 ->
		NewState = lib_guild_fight:get_item_by_id(UserId, ItemId, State),
		{noreply, NewState};
	true ->
		{noreply, State}
	end;

do_cast({get_continue_time, UserId}, State) ->
	if State#r_guild_fight.war_state =:= 1 ->
		NowTime = misc_timer:get_time(misc_timer:now_seconds()),
		Time = State#r_guild_fight.continue_time + misc_timer:get_time(State#r_guild_fight.start_time) - NowTime,
		case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
			false ->
				skip;
			UserInfo ->
				case lists:keyfind(UserInfo#r_guild_fight_user.guild_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
						false ->
							skip;
						GuildInfo ->
							{ok, Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, [Time, State#r_guild_fight.buff_guild_name, GuildInfo#r_guild_fight_guild.total_time, UserInfo#r_guild_fight_user.item_recv_list]),
							lib_send:send_to_sid(UserInfo#r_guild_fight_user.send_pid, Bin)
				end
		end;
	true ->
		skip
	end,
	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	?DEBUG("stop:~p",[_Reason]),
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_guild_fight cast is not match:~w",[Info]),
    {noreply, State}.

do_info({loop}, State) ->
	if State#r_guild_fight.war_state =:= 1 ->
			NewState1 = lib_guild_fight:loop_off_line_list(State),
			F = fun(Info, List) ->
				case lists:keyfind(Info#r_guild_fight_user.guild_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
					false ->
						List;
					GuildInfo ->						
						if GuildInfo#r_guild_fight_guild.state =:= 1 ->												
							Now = misc_timer:now_seconds(),						
							TotalTime = GuildInfo#r_guild_fight_guild.total_time + Now - GuildInfo#r_guild_fight_guild.old_time,
							NewGuildInfo = GuildInfo#r_guild_fight_guild{total_time = TotalTime, old_time = Now},
							NewGuildList = lists:keyreplace(Info#r_guild_fight_user.guild_id, #r_guild_fight_guild.guild_id, List, NewGuildInfo);
						true ->
							NewGuildInfo = GuildInfo,
							NewGuildList = List
						end,						
						{ok, Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_KILL, [NewGuildInfo#r_guild_fight_guild.total_time, NewGuildInfo#r_guild_fight_guild.kill_num, NewGuildInfo#r_guild_fight_guild.nick_name]),
						lib_send:send_to_sid(Info#r_guild_fight_user.send_pid, Bin),
						NewGuildList
				end
			end,
			NewGuildList = lists:foldl(F, NewState1#r_guild_fight.guild_list, NewState1#r_guild_fight.player_list),	
			NewState = NewState1#r_guild_fight{guild_list = NewGuildList},
			erlang:send_after(?LOOP_OFFLINE_TIME, self(), {loop}), 
			{noreply, NewState};
		true ->
			{noreply, State}
	end;

do_info({active_over}, State) ->
	if
		State#r_guild_fight.war_state =:= 1 ->
			?WARNING_MSG("active_over:~p",[{self(),State#r_guild_fight.war_state}]),			
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?GUILD_FIGHT_ACTIVE_ID}),
			gen_server:cast(self(), {send_award}),
			NewState = State#r_guild_fight{war_state = 0},			
			{noreply, NewState};
		true ->
			?WARNING_MSG("active_over:~p",[{self(),State,State#r_guild_fight.war_state}]),
			gen_server:cast(self(), {send_award}),
			{noreply, State}
	end;

do_info({'shut_down',T}, State) ->
	%?DEBUG("shut_down :~p",[State#r_guild_fight.player_list]),
	F = fun(Info,L) ->
			if
				Info#r_guild_fight_user.state =:= 0 ->
					L;
				true ->
					case misc:is_process_alive(Info#r_guild_fight_user.user_pid) of
						true -> 
							gen_server:cast(Info#r_guild_fight_user.user_pid, {'quit_war_timeout'}), 
							[Info|L];
						false ->
							L
					end
			end
		end,
	case State#r_guild_fight.player_list of
		[] ->
			lib_pvp_duplicate:clear_duplicate_and_map(State#r_guild_fight.map_pid),
			?WARNING_MSG("shut_down:~p",[self()]),
			{stop, normal, State};
		List1 ->
			if 	T > 10 ->	%如果10秒后还是有异常直接停止
					lib_pvp_duplicate:clear_duplicate_and_map(State#r_guild_fight.map_pid),
%% 					?WARNING_MSG("shut_down:~p",[{self(), List1}]),
					{stop, normal, State};
				true ->
					List = lists:foldl(F,[], List1),
					erlang:send_after(500, self(), {'shut_down', T + 1}),
					{noreply, State#r_guild_fight{player_list = List}}
			end
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_guild_fight info is not match:~w",[Info]),
    {noreply, State}.
