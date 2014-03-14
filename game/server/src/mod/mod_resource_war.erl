%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-8-2
%%% -------------------------------------------------------------------
-module(mod_resource_war).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([enter_resource_war/1,resource_war_kill/3,get_mod_resource_war_pid/0,close_resource_war/0]).

%% gen_server callbacks
-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(LOOP_TIME_OFF_LINE_LIST, 1800).	%%循环时间

%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(?MODULE, stop).

%%动态加载处理进程 
get_mod_resource_war_pid() ->
	%ProcessName = mod_resource_war_process,
	ProcessName = misc:create_process_name(duplicate_p, [?RESOURCE_WAR_MAP_ID, 0]),
	%?DEBUG("ProcessName:~p",[ProcessName]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> 
					Pid;
				false ->
					start_mod_resource_war(ProcessName)
			end;
		_ ->
			start_mod_resource_war(ProcessName)
	end.

%%启动监控模块 (加锁保证全局唯一)
start_mod_resource_war(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false ->
						start_resource_war()
				end;
			_ ->
				start_resource_war()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启监控模块
start_resource_war() ->
%%     case supervisor:start_child(
%%                server_sup,
%%                {mod_resource_war,
%%                 {mod_resource_war, start_link,[]},
%%                 permanent, 10000, worker, [mod_resource_war]}) of
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_resource_war error:~p~n",[R]),
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
	try 
		do_init()	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create resource war is error."}
	end.
do_init() ->	
	process_flag(trap_exit, true),	
	%ProcessName = mod_resource_war_process,	
	%misc:register(global, ProcessName, self()),	
	State = lib_resource_war:create_resource_war(),	
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
			?WARNING_MSG("mod_resource_war handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_resource_war handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_resource_war handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
	%gen_server:cast(mod_active:get_active_pid(), {terminal, ?RESOURCE_WAR_ACTIVE_ID}),
	misc:delete_monitor_pid(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(OldVsn, State, Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
close_resource_war() ->
	erlang:send_after(0, get_mod_resource_war_pid(), {active_over}).

enter_resource_war(PlayerStatus) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?RESOURCE_WAR_ACTIVE_ID}) of
		true when PlayerStatus#ets_users.level >= 35 ->
			gen_server:call(get_mod_resource_war_pid(), {'enter_resource_war', 
													PlayerStatus#ets_users.id, 
													PlayerStatus#ets_users.nick_name, 
													PlayerStatus#ets_users.other_data#user_other.pid, 
													PlayerStatus#ets_users.other_data#user_other.pid_send,
													PlayerStatus#ets_users.fight});
		_ ->
			{error,?ER_NOT_ENOUGH_LEVEL}
	end.

resource_war_kill(PlayerStatus, DeadID, DeadLv) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?RESOURCE_WAR_MAP_ID  of
		true ->
			UserLv = PlayerStatus#ets_users.level div 10,
			TDeadLv = DeadLv div 10,
			if
				UserLv > TDeadLv ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {kill_player,PlayerStatus#ets_users.id, DeadID, 10});
				UserLv =:= TDeadLv ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {kill_player,PlayerStatus#ets_users.id, DeadID, 15});
				true ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {kill_player,PlayerStatus#ets_users.id, DeadID, 20})
			end;
		_ ->
			skip
	end.	

%%---------------------do_call--------------------------------
do_call({'enter_resource_war', UserId, NickName,  PlayerPid,PidSend, Fight}, _, State) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.off_line_list) of
		false when State#r_resource_war.war_state =:= 1 ->
			{Info,PosX,PosY} = lib_resource_war:enter_resource_war(UserId, Fight, NickName, PlayerPid,PidSend, State),
			NewState1 = 
			case Info#r_resource_war_user.camp of
			1 ->
				{Camp_Num,Camp_Fight} = State#r_resource_war.camp1,
				State#r_resource_war{camp1 = {Camp_Num + 1,Camp_Fight + Fight}};
			2 ->
				{Camp_Num,Camp_Fight} = State#r_resource_war.camp2,
				State#r_resource_war{camp2 = {Camp_Num + 1,Camp_Fight + Fight}};
			3 ->
				{Camp_Num,Camp_Fight} = State#r_resource_war.camp3,
				State#r_resource_war{camp3 = {Camp_Num + 1,Camp_Fight + Fight}}
			end,
			UserList = [Info|NewState1#r_resource_war.player_list],
			NewState = NewState1#r_resource_war{player_count = NewState1#r_resource_war.player_count + 1, player_list = UserList},
			{reply, {ok, Info#r_resource_war_user.camp, self(), NewState#r_resource_war.map_pid,NewState#r_resource_war.map_only_id,NewState#r_resource_war.map_id,PosX,PosY}, NewState};
		_Info ->
			%DeadMsg = ?GET_TRAN(?_LANG_PK_DEAD, [misc_timer:now_seconds() - Info#r_resource_war_user.off_line_time]),
			lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ?_LANG_WAR_ENTER_AGAIN]),
			{reply,{error,?ER_UNKNOWN_ERROR},State}
	end;

do_call({'login_in_duplicate', {UserId, UserPid, SendPid, _VipLevel,_Sex}},  _, State) ->	
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list) of
		false ->
			%?DEBUG("login in:~p",[{UserId, UserPid, SendPid, _VipLevel,_Sex}]),
			{reply, {false}, State};
		UserInfo when (UserInfo#r_resource_war_user.state =:= 0 andalso State#r_resource_war.war_state =:= 1) ->
			NewInfo = UserInfo#r_resource_war_user{state = 1, off_line_time = 0, send_pid = SendPid, user_pid = UserPid},
			Newist = lists:keyreplace(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list,NewInfo),
			NewState = State#r_resource_war{player_list = Newist},
			{reply, {State#r_resource_war.map_pid,State#r_resource_war.map_only_id, 0, State#r_resource_war.map_id}, NewState};
		_er ->			
			%?DEBUG("login in:~p",[_er]),
			{reply, {false}, State}
	end;

do_call(Info, _, State) ->
	?WARNING_MSG("mod_resource_war call is not match:~w",[Info]),
    {reply, ok, State}.
%%---------------------do_cast--------------------------------
%%发送排行榜信息
do_cast({get_top_list, Pid}, State) ->
	{ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_TOP_LIST, State),
	lib_send:send_to_sid(Pid, Bin),
	{noreply, State};
%%采集物品增加积分
do_cast({collect_buff, CollectID, _Pid, UserId}, State) ->
	NewState = lib_resource_war:collect_point_add(CollectID, UserId, State),
	{noreply, NewState};
%%击杀玩家获得
do_cast({kill_player,UserId, DeadID, AddPoint}, Status) ->
	NewState = lib_resource_war:kill_point_add(UserId, DeadID, AddPoint, Status),
	{noreply, NewState};
%%击杀怪物获得
do_cast({monster_dead, MonsterId, UserId, _MType, _Pid}, Status) ->
	NewState = lib_resource_war:kill_monster_add(MonsterId, UserId, Status),
	{noreply, NewState};

do_cast({chang_war_camp, UserId, Camp}, Status) ->
	NewState = lib_resource_war:change_war_camp(UserId, Camp, Status),
	{noreply, NewState};

do_cast({get_user_point, UserId}, Status) ->
	lib_resource_war:get_user_point(UserId,Status),
	{noreply, Status};

do_cast({'war_quit', UserId}, State) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list) of
		false ->
			{noreply, State};
		Info ->
			NewPList = lists:keydelete(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list),
			NewInfo = Info#r_resource_war_user{state = 11, off_line_time = misc_timer:now_seconds()},
			NewState1 = lib_resource_war:remove_user_from_camp(NewInfo, State),
			NewState = NewState1#r_resource_war{player_list = NewPList,											
												off_line_list = [NewInfo|NewState1#r_resource_war.off_line_list]},
			{noreply, NewState}
	end;

do_cast({'off_line', UserId}, State) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list) of
		false ->
			{noreply, State};
		Info ->			
			NewInfo = Info#r_resource_war_user{state = 0, off_line_time = misc_timer:now_seconds()},
			NewPList = lists:keyreplace(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list, NewInfo),
			NewState = State#r_resource_war{player_list = NewPList},
			{noreply, NewState}
	end;

do_cast({set_continue_time, OverTime}, State) ->
	erlang:send_after(OverTime * 1000, self(),{active_over}),
	
	NewState = #r_resource_war{map_pid = State#r_resource_war.map_pid,
							   map_only_id = State#r_resource_war.map_only_id,
							   map_id = State#r_resource_war.map_id},
	?WARNING_MSG("set_continue_time:~p",[{OverTime,self(), NewState}]),
	erlang:send_after(?LOOP_TIME_OFF_LINE_LIST, self(), {loop}),
	{noreply, NewState};

do_cast({test}, State) ->
	?DEBUG("showState:~p",[State]),
	{noreply, State};

do_cast({send_award}, State) ->
	%%群发战斗结束内容
	if State#r_resource_war.war_state =:= 0 ->			
			TopList = lib_resource_war:loop_top_List(State#r_resource_war.player_list),
			NewState = State#r_resource_war{top_list = TopList},
			lib_resource_war:send_war_result(NewState),
			%{ok, BinData} = pt_23:write(?PP_ACTIVE_RESOURCE_RESULT, ),
			%mod_map_agent:send_to_scene(State#r_resource_war.map_only_id, BinData),%%地图群发前十排行
			lib_resource_war:send_war_award(NewState),
			%?DEBUG("send_award :~p",[State#r_resource_war.map_only_id]),
			erlang:send_after(22000, self(), {shut_down,0});
			%gen_server:cast(self(), {stop, active_over});
		true ->
			NewState = State
	end,
	{noreply, NewState};

do_cast({show_state}, State) ->
	?DEBUG("state:~p",[State]),
	{noreply, State};


%% 停止
do_cast({stop, _Reason}, State) ->
	?DEBUG("stop:~p",[_Reason]),
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_resource_war cast is not match:~w",[Info]),
    {noreply, State}.
%%---------------------do_info--------------------------------
do_info({loop}, State) ->
	if 
		State#r_resource_war.war_state =:= 1 ->
			QuitList = lib_resource_war:loop_quit_limit_list(State#r_resource_war.off_line_list),
			TopList = lib_resource_war:loop_top_List(State#r_resource_war.player_list),
			NewState1 = State#r_resource_war{top_list = TopList, off_line_list = QuitList},
			{ok, BinData} = pt_23:write(?PP_ACTIVE_RESOURCE_TOP_LIST, NewState1),
			mod_map_agent:send_to_scene(State#r_resource_war.map_only_id, BinData),%%地图群发前十排行			
			NewState = lib_resource_war:loop_off_line_list(NewState1),
			erlang:send_after(?LOOP_TIME_OFF_LINE_LIST, self(), {loop}),
			{noreply, NewState};
		true ->
			{noreply, State}
	end;

do_info({active_over}, State) ->
	if
		State#r_resource_war.war_state =:= 1 ->
			?WARNING_MSG("active_over:~p",[{self(),State#r_resource_war.war_state}]),
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?RESOURCE_WAR_ACTIVE_ID}),
			gen_server:cast(self(), {send_award}),
			NewState = State#r_resource_war{war_state = 0},			
			{noreply, NewState};
		true ->
			?WARNING_MSG("active_over:~p",[{self(),State#r_resource_war.war_state}]),
			%gen_server:cast(self(), {send_award}),
			{noreply, State}
	end;
	
do_info({'shut_down',T}, State) ->
	%?DEBUG("shut_down :~p",[State#r_resource_war.player_list]),
	F = fun(Info,L) ->
			if
				Info#r_resource_war_user.state =:= 0 ->
					L;
				true ->
					case misc:is_process_alive(Info#r_resource_war_user.user_pid) of
						true -> 
							gen_server:cast(Info#r_resource_war_user.user_pid, {'quit_war_timeout'}),
							[Info|L];
						false ->
							L
					end
			end
		end,
	case State#r_resource_war.player_list of
		[] ->
			lib_pvp_duplicate:clear_duplicate_and_map(State#r_resource_war.map_pid),
			?WARNING_MSG("shut_down:~p",[self()]),
			{stop, normal, State};
		List1 ->
			if 	T > 10 ->	%如果10秒后还是有异常直接停止
					lib_pvp_duplicate:clear_duplicate_and_map(State#r_resource_war.map_pid),
					?WARNING_MSG("shut_down:~p",[{self(), List1}]),
					{stop, normal, State};
				true ->
					List = lists:foldl(F,[], List1),
					erlang:send_after(1000, self(), {'shut_down', T + 1}),
					{noreply, State#r_resource_war{player_list = List}}
			end
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_resource_war info is not match:~w",[Info]),
    {noreply, State}.
