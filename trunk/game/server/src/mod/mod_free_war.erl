%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-6-13
%%% -------------------------------------------------------------------
-module(mod_free_war).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([
		 start_link/0,
		 stop/0,
		 get_free_war_state/3,
		 get_mod_free_war_pid/0,
		 get_free_war_list/1,
		 get_free_war_result/2,
		 get_free_war_user_list/2,
		 get_free_war_user_info/2,
		 enter_free_war_map/2,
		 quit_free_war/1,
		 free_war_kill/2,
		 collect_free_war_award/1
		]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
				flag_count = 1,			%% 状态符
				is_open = false,		%% 战场是否开始
				last_date = 0			%% 最后时间
				}).

-define(FREE_WAR_LOOP_TIME, 5000).	%%	自由战场循环
-define(BEGIN_SECOND, 19 * 60 * 60).		%% 开始时间
-define(END_SECOND, 19 * 60 * 60 + 30 * 60).	%% 结束时间
 
%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_free_war_pid() ->
	ProcessName = mod_free_war_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> 
					Pid;
				false ->
					start_mod_free_war(ProcessName)
			end;
		_ ->
			start_mod_free_war(ProcessName)
	end.

%%启动监控模块 (加锁保证全局唯一)
start_mod_free_war(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false ->
						start_free_war()
				end;
			_ ->
				start_free_war()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启监控模块
start_free_war() ->
    case supervisor:start_child(
               server_sup,
               {mod_free_war,
                {mod_free_war, start_link,[]},
                permanent, 10000, worker, [mod_free_war]}) of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_free_war error:~p~n",[R]),
				undefined
	end.


%% ====================================================================
%% Server functions
%% ====================================================================

%% 自由战场状态
get_free_war_state(UserId, PlayerPid, PidSend) ->
	gen_server:cast(get_mod_free_war_pid(), {'get_free_war_state', UserId, PlayerPid, PidSend}).

%% 战场列表
get_free_war_list(PidSend) ->
	gen_server:cast(get_mod_free_war_pid(), {'get_free_war_list', PidSend}).
%% 										 PlayerStatus#ets_users.other_data#user_other.pid_send}).

%% 战场用户列表
get_free_war_user_list(PidSend, WarId) ->
	ok.
	%%gen_server:cast(get_mod_free_war_pid(), {'get_free_war_user_list', PidSend, WarId}).

%% 战场结果
get_free_war_result(PidSend, WarId) ->
	gen_server:cast(get_mod_free_war_pid(), {'get_free_war_result', PidSend, WarId}).

%% 战场用户信息
get_free_war_user_info(PidSend, UserId) ->
	gen_server:cast(get_mod_free_war_pid(), {'get_free_war_user_info', PidSend, UserId}).

%% 战场信息
enter_free_war_map(PlayerStatus, WarId) -> 
	case PlayerStatus#ets_users.level >=40 of
		true ->
			gen_server:call(get_mod_free_war_pid(), {'enter_free_war_map', 
												 WarId,
												 PlayerStatus#ets_users.id, 
												 PlayerStatus#ets_users.nick_name,
												 PlayerStatus#ets_users.level,
												 PlayerStatus#ets_users.other_data#user_other.pid_send,
												 PlayerStatus#ets_users.other_data#user_other.club_name,
												 PlayerStatus#ets_users.career,
												 PlayerStatus#ets_users.other_data#user_other.pid});
		_ ->
			{error}
	end.

%% 战场退出
quit_free_war(UserId) ->
	gen_server:cast(get_mod_free_war_pid(), {'quit_free_war', UserId}).

%% 杀死
free_war_kill(PlayerStatus, KillUserId) ->
	case PlayerStatus#ets_users.other_data#user_other.war_state =/= 0 of
		true ->
			gen_server:cast(get_mod_free_war_pid(), {'kill_player', PlayerStatus#ets_users.id, KillUserId});
		_ ->
			skip
	end.

%% 领取奖励
collect_free_war_award(UserId) ->
	gen_server:cast(get_mod_free_war_pid(), {'collect_free_war_award', UserId}).

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
			{stop, "create free war is error."}
	end.

do_init() ->
	
	process_flag(trap_exit, true),
	
	ProcessName = mod_free_war_process,
	
	misc:register(global, ProcessName, self()),		
	
	lib_free_war:init_free_war_map(),
	
	erlang:send_after(?FREE_WAR_LOOP_TIME, self(), {loop}), 
	
	misc:write_monitor_pid(self(),?MODULE, {}),
	
	Now = misc_timer:now_seconds(),
    {ok, #state{last_date=Now}}.

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
			?WARNING_MSG("mod_free_war handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_free_war handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_free_war handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
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

%% 获取战场信息
do_call({'enter_free_war_map', WarId, UserId, NickName, Level, PidSend, ClubName, Career, PlayerPid}, _, State) ->
	case State#state.is_open of
		true ->
			case lib_free_war:can_enter_map(WarId, UserId, Level) of
				{true, WarMap} ->
					{WarState, PosX, PosY, DuplicateId} = lib_free_war:enter_map_info(WarMap, UserId, NickName, Level, ClubName, Career, PlayerPid, State#state.flag_count),
					Reply = {ok, 
							 WarState,
							 WarMap#r_free_war_map.map_pid, 
							 WarMap#r_free_war_map.map_only_id,
							 WarMap#r_free_war_map.map_id,
							 PosX,
							 PosY,
							 DuplicateId},
					{ok, DataBin} = pt_12:write(?PP_FREE_WAR_RESULT, WarMap),
					mod_map_agent:send_to_scene(WarMap#r_free_war_map.map_only_id, DataBin),
			
					FlagCount = State#state.flag_count rem 3 + 1,	
					{reply, Reply, State#state{flag_count=FlagCount}};
				{error, Reason} ->
					lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, Reason]),
					{reply, error, State};
				ERROR ->
					?WARNING_MSG("get_free_war_map:~w", [ERROR]),
					{reply, error, State}
			end;
		_ ->
			lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ?_LANG_WAR_NOT_OPEN]),
			{reply, error, State}
	end;

do_call(Info, _, State) ->
	?WARNING_MSG("mod_free_war call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------

%% 战场状态
do_cast({'get_free_war_state', UserId, PlayerPid, SendPid}, State) ->
	lib_free_war:update_player_pid(UserId, PlayerPid),
	case State#state.is_open of
		true ->
			NowSecond = util:get_today_current_second(),
			LeaveTime = ?END_SECOND - NowSecond,
			case LeaveTime > 0 of
				true ->
					{ok, DataBin} = pt_12:write(?PP_FREE_WAR_STATE, LeaveTime),
					lib_send:send_to_sid(SendPid, DataBin);
				_ ->
					skip
			end;
		_ ->
			skip
	end,
    {noreply, State};


%% 获取战场列表
do_cast({'get_free_war_list', SendPid}, State) ->
	List = lib_free_war:get_map_dic(),
	{ok, DataBin} = pt_12:write(?PP_FREE_WAR_LIST, List),
	lib_send:send_to_sid(SendPid, DataBin),
	{noreply, State};	

%% 获取战场用户列表
do_cast({'get_free_war_user_list', SendPid, WarId}, State) ->
	List = lib_free_war:get_map_player_by_map_id(WarId),
	{ok, DataBin} = pt_12:write(?PP_FREE_WAR_USER_LIST, List),
	lib_send:send_to_sid(SendPid, DataBin),
	{noreply, State};	

%% 战场结果
do_cast({'get_free_war_result', SendPid, WarId}, State) ->
	case lib_free_war:get_map_by_id(WarId) of
		[] ->
			skip;
		WarMap ->
			{ok, DataBin} = pt_12:write(?PP_FREE_WAR_RESULT, WarMap),
			lib_send:send_to_sid(SendPid, DataBin)
	end,
	{noreply, State};	


%% 战场用户信息
do_cast({'get_free_war_user_info', SendPid, UserId}, State) ->
	case lib_free_war:get_free_war_user_info(UserId) of
		{ok, KillList, ByKillList} ->
			{ok, DataBin} = pt_12:write(?PP_FREE_WAR_USER_INFO, [KillList, ByKillList]),
			lib_send:send_to_sid(SendPid, DataBin);
		_ ->
			[]
	end,
	{noreply, State};	

%% 退出战场
do_cast({'quit_free_war', UserId}, State) ->
	lib_free_war:quit_free_war(UserId),
	{noreply, State};	

%% 杀死玩家
do_cast({'kill_player', UserId, KillUserId}, State) ->
	lib_free_war:kill_player(UserId, KillUserId),
	{noreply, State};

%% 领取奖励
do_cast({'collect_free_war_award', UserId}, State) ->
	lib_free_war:collect_free_war_award(UserId),
	{noreply, State};
 
%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_free_war cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%% 循环
do_info({loop}, State) ->
	erlang:send_after(?FREE_WAR_LOOP_TIME, self(), {loop}), 
	
	Now = misc_timer:now_seconds(),
	%% 隔天清除
	lib_free_war:refresh_day(State#state.last_date, Now),

	NowSecond = util:get_today_current_second(),
	NewState =
		case State#state.is_open of
			false when NowSecond >= ?BEGIN_SECOND andalso NowSecond =< ?END_SECOND ->
				%% todo 发送战场开始
				LeaveTime = ?END_SECOND - NowSecond,
				{ok, DataBin} = pt_12:write(?PP_FREE_WAR_STATE, LeaveTime),
				lib_send:send_to_all(DataBin),
				State#state{is_open=true};
			true when NowSecond < ?BEGIN_SECOND orelse NowSecond > ?END_SECOND ->
				%%  todo 发送战场结束
				lib_free_war:finish_war(),
				State#state{is_open=false};
			_ ->
				State
		end,

	{noreply, NewState#state{last_date=Now}};


do_info(Info, State) ->
	?WARNING_MSG("mod_free_war info is not match:~w",[Info]),
    {noreply, State}.

%%---------------------private-----------------------

