%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-4-24
%%% -------------------------------------------------------------------
-module(mod_pvp_duplicate).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {duplicate_id = 0,
				active_id = 0,			%%对应活动编号
				map_id = 0,
				map_only_id = 0,		%% 地图唯一id
				map_pid = undefined,
				status = 0,
				create_mon_times = 1,
				duplicate_type = 0,
				start_time = 0,
				count_down = 0,			%%倒计时，时间到后战斗强制结束
				totalmisson = 0,
				current_mission,
				points = [],			%% 出生地
				user_list1 = [],	%%蓝方
				user_list2 = []}).	%%红方

-define(Scan_Time_Tick, (1 * 1000)).
%% ====================================================================
%% External functions
%% ====================================================================
start(DuplicateId,ActiveId) ->
	{ok, Dup_pid} = gen_server:start(?MODULE, [DuplicateId,ActiveId], []),
	{ok, Dup_pid}.

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
init([DuplicateId,ActiveId]) ->
	try 
		do_init([DuplicateId,ActiveId])	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create duplicate is error."}
	end.

do_init([DuplicateId,ActiveId]) ->
	ProcessName = misc:create_process_name(mod_pvp_dup, [DuplicateId]),
	misc:register(global, ProcessName, self()),
	DuplicateTemplate = data_agent:duplicate_template_get(DuplicateId),
	DuplicateMission = lists:nth(1, DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions),
	Duplicate_Type = DuplicateTemplate#ets_duplicate_template.type,
    Now = misc_timer:now_seconds(),
	%{UserId, Name, Pid, PidSend} = User,
	%UserInfo = #dup_user_info{user_id = UserId, name = Name, pid_user = Pid , pid_send = PidSend},
	Points = lib_pvp_duplicate:get_pvp_duplicate_Points(DuplicateMission),
	State = #state{
				   duplicate_id = DuplicateId,
				   active_id = ActiveId,
				   map_id = DuplicateMission#ets_duplicate_mission_template.map_id,
				   create_mon_times = 1,
				   duplicate_type = Duplicate_Type,
				   start_time = Now,
				   count_down = DuplicateTemplate#ets_duplicate_template.total_time,
				   %totalmisson = erlang:length(DuplicateMission),
				   current_mission = DuplicateMission,
					points = Points
				   },
	misc:write_monitor_pid(self(),?MODULE, {State}),
	%%NewState = create_duplicate_map(State),
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
			?WARNING_MSG("mod_pvp_duplicate handle_call is exception:~w~n,Info:~w,~nDuplicateId:~p",[Reason, Info, State#state.duplicate_id]),
			%?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
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
			?WARNING_MSG("mod_pvp_duplicate handle_cast is exception:~w~n,Info:~w,~nDuplicateId:~w",[Reason, Info, State#state.duplicate_id]),
			%?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
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
			?WARNING_MSG("mod_pvp_duplicate handle_info is exception:~w~n,Info:~w,~n DuplicateId:~p",[Reason, Info, State#state.duplicate_id]),
			%?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
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

do_call(Info, _, State) ->
	?WARNING_MSG("mod_pvp_duplicate call is not match:~w",[Info]),
    {reply, ok, State}.

%%用户加入到pvp副本中
do_cast({enter_pvp_duplicate, UserInfo}, State) ->%%如果异步调用异常，转用call
	if
		State#state.map_only_id =:= 0 ->
			{Map_Pid, Map_Only_Id} = lib_pvp_duplicate:create_duplicate_map(State#state.current_mission),
			erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),%%应为时间比较短所以在副本创建完成后再进入计时
			NewState = State#state{map_pid = Map_Pid, map_only_id = Map_Only_Id, start_time = misc_timer:now_seconds()};
		true ->
			NewState = State
	end,
	case UserInfo#pvp_dup_user_info.camp_type of
		0 ->
			NewState1 = NewState#state{user_list1 = [UserInfo|NewState#state.user_list1]};
		1 ->
			NewState1 = NewState#state{user_list2 = [UserInfo|NewState#state.user_list2]};
		_ ->
			NewState1 = NewState
	end,
	{X,Y} = lists:nth(UserInfo#pvp_dup_user_info.camp_type + 1,NewState1#state.points),
	gen_server:cast(UserInfo#pvp_dup_user_info.pid_user, {enter_pvp_duplicate_map,
			NewState1#state.map_pid,
			self(),
			NewState1#state.map_only_id,
			NewState1#state.duplicate_id,
			NewState1#state.map_id,
			X,Y}),%%通知用户进入副本成功，更新位置
	{noreply, NewState1};
%% 玩家死亡
do_cast({player_dead, UserId}, State) ->
	%?DEBUG("pvp_player_dead:~p",[UserId]),
	case lists:keyfind(UserId, #pvp_dup_user_info.user_id, State#state.user_list1) of
		false ->
			case lists:keyfind(UserId, #pvp_dup_user_info.user_id, State#state.user_list2) of
				false ->
					NewState = State;
				Info ->
					NewInfo = Info#pvp_dup_user_info{status = 1},
					NewList2 = lists:keyreplace(UserId, #pvp_dup_user_info.user_id, State#state.user_list2, NewInfo),
					%gen_server:cast(Info#pvp_dup_user_info.pid_user, {'SOCKET_EVENT', ?PP_PLAYER_RELIVE, [6]}),
					NewState = State#state{user_list2 = NewList2}
			end;
		Info ->
			NewInfo = Info#pvp_dup_user_info{status = 1},
			NewList1 = lists:keyreplace(UserId, #pvp_dup_user_info.user_id, State#state.user_list1, NewInfo),
			%gen_server:cast(Info#pvp_dup_user_info.pid_user, {'SOCKET_EVENT', ?PP_PLAYER_RELIVE, [6]}),
			NewState = State#state{user_list1 = NewList1}
	end,
	{noreply, NewState};
%% 离开副本
do_cast({'dup_quit', UserId}, State) ->
	
	{List1,List2} = lib_pvp_duplicate:pvp_dup_quit(UserId, State#state.user_list1, State#state.user_list2),
	NewState = State#state{user_list1 = List1, user_list2 = List2},
	{noreply, NewState};

%% 下线离开副本
do_cast({off_line, UserId}, State) ->
	{List1,List2} = lib_pvp_duplicate:pvp_dup_quit(UserId, State#state.user_list1, State#state.user_list2),
	NewState = State#state{user_list1 = List1, user_list2 = List2},
	{noreply, NewState};
%% 怪物死亡触发事件
do_cast({monster_dead, _MonsterId, UserId, _MonsterType,_Pid}, State) ->
	case State#state.duplicate_type of
		?DUPLICATE_TYPE_PVP1 ->	
			%%怪物死亡触发事件			
			case lists:keyfind(UserId, #pvp_dup_user_info.user_id, State#state.user_list1 ++ State#state.user_list2) of
				false ->
				 ok;
				UserInfo ->
					Rand = util:rand(1, 8),
					gen_server:cast(UserInfo#pvp_dup_user_info.pid_user, {'add_player_buff', 100000010 + Rand})
					%gen_server:cast(UserInfo#pvp_dup_user_info.pid_user, {'add_player_buff', 100000016})
			end;			
		_ ->
			ok			
	end,	
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_pvp_duplicate cast is not match:~w",[Info]),
    {noreply, State}.

%%副本检查
do_info({'scan_time'}, State) ->	
	if
		State#state.count_down =:= 0 ->
			%%通知战斗结束平局
			lib_pvp_duplicate:pvp_send_result(State#state.active_id, 0, State#state.user_list1, State#state.user_list2),
			erlang:send_after(5000, self(), {'shut_down'}),
			NewState = State;
		true ->
			case lib_pvp_duplicate:check_camp_state(State#state.user_list1, State#state.user_list2) of
				-1 ->
					erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
					%%?DEBUG("scan_time:~p",[State#state.count_down]),
					NewState = State#state{count_down = State#state.count_down - 1};
				Result ->
					lib_pvp_duplicate:pvp_send_result(State#state.active_id, Result, State#state.user_list1, State#state.user_list2),
					NewState = State,
					erlang:send_after(5000, self(), {'shut_down'})
			end
	end,
	{noreply, NewState};
%%关闭副本地图
do_info({'shut_down'}, State) ->
	F = fun(Info) ->
				gen_server:cast(Info#pvp_dup_user_info.pid_user, {'quit_duplicate_timeout'})
		end,
	case State#state.user_list1 ++ State#state.user_list2 of
		[] ->
			lib_pvp_duplicate:clear_duplicate_and_map(State#state.map_pid),
			{stop, normal, State};	
		List1 ->
			lists:foreach(F, List1),
			erlang:send_after(1000, self(), {'shut_down'}),
			{noreply, State}
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_pvp_duplicate info is not match:~w",[Info]),
    {noreply, State}.
%%-----------------------------------------------------------------------


	

