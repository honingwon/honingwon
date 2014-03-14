%%% -------------------------------------------------------------------
%%% Author  : wangyuechun
%%% Description :
%%%
%%% Created : 2013-9-22
%%% -------------------------------------------------------------------
-module(mod_pvp_first).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([enter_pvp_first/1,get_mod_pvp_first_pid/0,close_pvp_first/0]).

%% gen_server callbacks
-export([start_link/0, init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(LOOP_TIME_AWARD_EXP, 60000).	%%循环时间

%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(?MODULE, stop).

%%动态加载处理进程 
get_mod_pvp_first_pid() ->
	%ProcessName = mod_pvp_first_process,
	ProcessName = misc:create_process_name(duplicate_p, [?PVP_FIRST_MAP_ID, 0]),
	%?DEBUG("ProcessName:~p",[ProcessName]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> 
					Pid;
				false ->
					start_mod_pvp_first(ProcessName)
			end;
		_ ->
			start_mod_pvp_first(ProcessName)
	end.

%%启动监控模块 (加锁保证全局唯一)
start_mod_pvp_first(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false ->
						start_pvp_first()
				end;
			_ ->
				start_pvp_first()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启监控模块
start_pvp_first() ->
%%     case supervisor:start_child(
%%                server_sup,
%%                {mod_pvp_first,
%%                 {mod_pvp_first, start_link,[]},
%%                 permanent, 10000, worker, [mod_pvp_first]}) of
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_pvp_first error:~p~n",[R]),
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
	State = lib_pvp_first:create_pvp_first(),	
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
			?WARNING_MSG("mod_pvp_first handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_pvp_first handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_pvp_first handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
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
close_pvp_first() ->
	erlang:send_after(0, get_mod_pvp_first_pid(), {active_over}).

enter_pvp_first(PlayerStatus) ->
	case gen_server:call(mod_active:get_active_pid(), {is_active_open,?PVP_FIRST_ACTIVE_ID}) of
		true when PlayerStatus#ets_users.level >= 40 ->
			gen_server:call(get_mod_pvp_first_pid(), {'enter_pvp_first', 
													PlayerStatus#ets_users.id, 
													PlayerStatus#ets_users.nick_name, 
													PlayerStatus#ets_users.other_data#user_other.pid, 
													PlayerStatus#ets_users.other_data#user_other.pid_send,
													PlayerStatus#ets_users.fight});
		_ ->
			{error,?ER_NOT_ENOUGH_LEVEL}
	end.

%%---------------------do_call--------------------------------
do_call({'enter_pvp_first', UserId, NickName,  PlayerPid,PidSend, Fight}, _, State) ->
	if State#r_pvp_first.war_state =:= 1 ->
		{Info,PosX,PosY,Camp} = lib_pvp_first:enter_pvp_first(UserId, Fight, NickName, PlayerPid,PidSend),
		UserList = [Info|State#r_pvp_first.player_list],
		NewState = State#r_pvp_first{player_count = State#r_pvp_first.player_count + 1, player_list = UserList},
		{reply, {ok, Camp, self(), NewState#r_pvp_first.map_pid,NewState#r_pvp_first.map_only_id,NewState#r_pvp_first.map_id,PosX,PosY}, NewState};
	true ->
		lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ?_LANG_FIRST_NOT_OPEN]),
		{reply,{error,?ER_UNKNOWN_ERROR},State}
	end;

do_call({'login_in_duplicate', {UserId, UserPid, SendPid, _VipLevel,_Sex}},  _, State) ->	
	lib_pvp_first:login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State);

do_call({'check_pvp_first_kill', KillId,Userid,Pid,NickName},  _, State) ->	
	lib_pvp_first:check_pvp_first_kill(KillId,Userid,Pid,NickName,State);

do_call(Info, _, State) ->
	?WARNING_MSG("mod_pvp_first call is not match:~w",[Info]),
    {reply, ok, State}.
%%---------------------do_cast--------------------------------

do_cast({send_new_first}, State) ->
	lib_pvp_first:kill_send_msg(State#r_pvp_first.the_first_nickname),
	lib_pvp_first:send_new_first(State),
	{noreply, State};

%%击杀玩家获得
do_cast({kill_player,UserId, DeadID}, Status) ->
	NewState = lib_pvp_first:kill_player(UserId, DeadID, Status),
	{noreply, NewState};
%%击杀怪物获得
do_cast({monster_dead, MonsterId, UserId, _MType, _Pid}, Status) ->
	NewState = lib_pvp_first:kill_monster(MonsterId, UserId, Status),	
	{noreply, NewState};

do_cast({'war_quit', UserId}, State) ->
	%?DEBUG("war_quit~p~n",[State]),
	case lists:keyfind(UserId, #r_pvp_first_user.user_id, State#r_pvp_first.player_list) of
		false ->
			{noreply, State};
		Info ->
			State1 = lib_pvp_first:reset_the_first(Info, State),
			NewPList = lists:keydelete(UserId, #r_pvp_first_user.user_id, State1#r_pvp_first.player_list),
			NewState = State1#r_pvp_first{player_list = NewPList },
			{noreply, NewState}
	end;

do_cast({'get_the_first', Pid}, State) ->
	if State#r_pvp_first.war_state =:= 1 ->
		lib_pvp_first:get_new_first(State, Pid);
	true ->		
		skip
	end,
	{noreply, State};

do_cast({'off_line', UserId}, State) ->
	lib_pvp_first:off_line(UserId, State);

do_cast({set_continue_time, OverTime}, State) ->
	erlang:send_after(OverTime * 1000, self(),{active_over}),
	
	NewState = #r_pvp_first{map_pid = State#r_pvp_first.map_pid,
							   map_only_id = State#r_pvp_first.map_only_id,
							   map_id = State#r_pvp_first.map_id,
							   start_time = misc_timer:now_seconds(), %%开始时间
							   continue_time = OverTime},
	%?WARNING_MSG("set_continue_time:~p",[{OverTime,self(), NewState}]),
	erlang:send_after(?LOOP_TIME_AWARD_EXP, self(), {loop}),
	{noreply, NewState};

do_cast({test}, State) ->
	?DEBUG("showState:~p",[State]),
	{noreply, State};

do_cast({send_award}, State) ->
	%%群发战斗结束内容
	if State#r_pvp_first.war_state =:= 0 ->			
			%lib_pvp_first:send_war_result(State),
		   	erlang:send_after(0, self(), {shut_down,0}),
			lib_pvp_first:send_pvp_first_award(State);
			%?DEBUG("send_award :~p",[State#r_pvp_first.map_only_id]),
			State;
		true ->
			skip
	end,
	{noreply, State};

do_cast({show_state}, State) ->
	?DEBUG("state:~p",[State]),
	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	?DEBUG("stop:~p",[_Reason]),
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_pvp_first cast is not match:~w",[Info]),
    {noreply, State}.
%%---------------------do_info--------------------------------
do_info({loop}, State) ->
	erlang:send_after(?LOOP_TIME_AWARD_EXP, self(), {loop}),
	lib_pvp_first:loop(State),
	{noreply, State};

do_info({active_over}, State) ->
	if
		State#r_pvp_first.war_state =:= 1 ->
			?WARNING_MSG("active_over:~p",[{self(),State#r_pvp_first.war_state}]),			
			gen_server:cast(mod_active:get_active_pid(), {terminal, ?PVP_FIRST_ACTIVE_ID}),
			gen_server:cast(self(), {send_award}),
			NewState = State#r_pvp_first{war_state = 0},			
			{noreply, NewState};
		true ->
			?WARNING_MSG("active_over:~p",[{self(),State,State#r_pvp_first.war_state}]),
			gen_server:cast(self(), {send_award}),
			{noreply, State}
	end;
	
do_info({'shut_down',T}, State) ->
	%?DEBUG("shut_down :~p",[State#r_pvp_first.player_list]),
	F = fun(Info,L) ->
			if
				Info#r_pvp_first_user.state =:= 0 ->
					L;
				true ->
					case misc:is_process_alive(Info#r_pvp_first_user.user_pid) of
						true -> 
							{ok,Data} = lib_pvp_first:get_pvp_first_result(Info,State),
							gen_server:cast(Info#r_pvp_first_user.user_pid, {'quit_pvp_first_timeout',Data}),
							[Info|L];
						false ->
							L
					end
			end
		end,
	case State#r_pvp_first.player_list of
		[] ->
			lib_pvp_first:send_pvp_first_buff(State),
			lib_pvp_duplicate:clear_duplicate_and_map(State#r_pvp_first.map_pid),
			?WARNING_MSG("shut_down:~p",[self()]),
			{stop, normal, State};
		List1 ->
			if 	T > 10 ->	%如果10秒后还是有异常直接停止
					lib_pvp_first:send_pvp_first_buff(State),
					lib_pvp_duplicate:clear_duplicate_and_map(State#r_pvp_first.map_pid),
					?WARNING_MSG("shut_down:~p",[{self(), List1}]),
					{stop, normal, State};
				true ->
					List = lists:foldl(F,[], List1),
					erlang:send_after(500, self(), {'shut_down', T + 1}),
					{noreply, State#r_pvp_first{player_list = List}}
			end
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_pvp_first info is not match:~w",[Info]),
    {noreply, State}.
