%%%-------------------------------------------------------------------
%%% Module  : mod_task
%%% Author  : 
%%% Description : 任务模块
%%%-------------------------------------------------------------------
-module(mod_task).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").


%%-define(Macro, value).
-record(task_status, {user_id, pid_send, pid_player, last_date, save_date, escort_timer, escort_taskId}).

-define(Scan_Time_Tick, (5 * 1000)).
-define(SAVE_TASK_TICK, (1 * 60)).  %% 5分钟保存一次，以秒为单位

%%--------------------------------------------------------------------
%% External exports
-export([start_link/3]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2,handle_info/2, terminate/2, code_change/3]).

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link(UserId, Pid_send, Pid_player) ->
	gen_server:start_link(?MODULE, [UserId, Pid_send, Pid_player], []).
%%     gen_server:start_link({local, ?MODULE}, ?MODULE, [UserId, Socket], []).

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
init([UserId, Pid_send, Pid_player]) ->
	try 
		do_init([UserId, Pid_send, Pid_player])	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create task is error."}
	end.

do_init([UserId, Pid_send, Pid_player]) ->
	ok = lib_task:init_task_online(UserId),
	Now = misc_timer:now_seconds(),
	State = #task_status{
						 user_id = UserId,
						 pid_send = Pid_send,
						 pid_player = Pid_player,
						 last_date = 0,
						 save_date = Now,
						 escort_timer = -1,
						 escort_taskId = 0
						},  
	
	misc:write_monitor_pid(self(),?MODULE, {}),	
	
	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
	{ok, State}.

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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("UserId:~w, mod_task handle_call is exception:~w~n,Info:~w",[State#task_status.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_task handle_cast is exception:~w~n,Info:~w",[State#task_status.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_task handle_info is exception:~w~n,Info:~w",[State#task_status.user_id, Reason, Info]),
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
    ok.

%%--------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Private functions
%%====================================================================

%%---------------------do_call--------------------------------

%%提交任务
do_call({check_token_task, TaskId},_From, State) ->
	case lib_task:check_token_task(TaskId) of
		ok ->
			{reply, ok, State};
		{error, Msg} ->
			{reply, {error, Msg}, State}
	end;
	

do_call({'submit', TaskId, PlayerStatus},_From, State) ->
	case lib_task:submit_task(PlayerStatus, TaskId) of
		{ok, TaskInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			NewState = State#task_status{escort_timer = -1, escort_taskId = 0},
			TonkenInfo = PlayerStatus#ets_users.other_data#user_other.token_info,
			if
				TaskId >= ?MIN_TOKEN_TASK_ID andalso TonkenInfo#ets_user_token.receive_task_id > 0 ->
					{ok, Bin1} = pt_24:write(?PP_TOKEN_TRUST_FINISH,1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin1),					
					{Copper1 , BindCopper1 , Exp } = lib_token_task:get_token_task_award(TonkenInfo#ets_user_token.receive_task_id rem 10,
												 TonkenInfo#ets_user_token.receive_task_id div 10, false),%%发送奖励
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid, {clear_receive_token_task});
				true ->
					{Copper1 , BindCopper1 , Exp } = {0,0,0}
			end,
			{reply,[YuanBao, BindYuanBao, Copper + Copper1, BindCopper + BindCopper1, Experience + Exp, LifeExp, Awards],NewState};
		{error, _Reason} ->
%% 			?ERROR_MSG("task is not submit : ~s ",[_Reason]),
			{reply, error, State};
		ERROR ->
			?ERROR_MSG("task is not submit ERROR : ~w ",[ERROR]),
			{reply, error, State}
	end;

%%提交任务
do_call({'submit_by_yuanbao', TaskId, PlayerStatus},_From, State) ->
	case lib_task:submit_task_by_yuanbao(PlayerStatus, TaskId) of
		{ok, NeedYuanBao, TaskInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			NewState = State#task_status{escort_timer = -1, escort_taskId = 0},
			TonkenInfo = PlayerStatus#ets_users.other_data#user_other.token_info,
			if
				TaskId >= ?MIN_TOKEN_TASK_ID andalso TonkenInfo#ets_user_token.receive_task_id > 0 ->
					{ok, Bin1} = pt_24:write(?PP_TOKEN_TRUST_FINISH,1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin1),					
					{Copper1 , BindCopper1 , Exp } = lib_token_task:get_token_task_award(TonkenInfo#ets_user_token.receive_task_id rem 10,
												 TonkenInfo#ets_user_token.receive_task_id div 10, false),%%发送奖励
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid, {clear_receive_token_task});
				true ->
					{Copper1 , BindCopper1 , Exp } = {0,0,0}
			end,
			{reply,[NeedYuanBao,YuanBao, BindYuanBao, Copper + Copper1, BindCopper + BindCopper1, Experience + Exp, LifeExp, Awards],NewState};
		{error, _Reason} ->
			{reply, error, State};
		ERROR ->
			?ERROR_MSG("task is not submit ERROR : ~w ",[ERROR]),
			{reply, error, State}
	end;

%%GM提交任务
do_call({'submit_gm', TaskId, PlayerStatus},_From, State) ->
	case lib_task:submit_task_by_GM(PlayerStatus, TaskId) of
		{ok, TaskInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			NewState = State#task_status{escort_timer = -1, escort_taskId = 0},
			{reply,[YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards],NewState};
		{error, _Reason} ->
%% 			?ERROR_MSG("task is not submit : ~s ",[_Reason]),
			{reply, error, State};
		ERROR ->
			?ERROR_MSG("task is not submit ERROR : ~w ",[ERROR]),
			{reply, error, State}
	end;

do_call({'submit_token', PlayerStatus},_From, State) ->
	case lib_task:submit_token(PlayerStatus) of
		{ok, TaskInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			NewState = State#task_status{escort_timer = -1, escort_taskId = 0},
			{reply,[YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards],NewState};
		{error, _Reason} ->
			?DEBUG("submit_token error:~p",[_Reason]),
			{reply, error, State};
		ERROR ->
			?ERROR_MSG("task is not submit ERROR : ~w ",[ERROR]),
			{reply, error, State}
	end;

%% 任务委托
do_call({'trust', PlayerStatus, List}, _From, State) ->
	case lib_task:trust_task(PlayerStatus, List) of
		{ok, TaskList, YuanBao, Copper} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, TaskList),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			{reply, [YuanBao, Copper], State};
		{error, _Reason} ->
%% 			?ERROR_MSG("task is not trust : ~s ",[Reason]),
			{reply, error, State};
		ERROR ->
			?ERROR_MSG("task is not trust ERROR : ~w ",[ERROR]),
			{reply, error, State}
	end;

%% 运镖刷新
do_call({'transport_add', IsAutoRef,NeedQuality, PlayerStatus},_From, State) ->
	case lib_task:transport_add(PlayerStatus,IsAutoRef,NeedQuality) of
%% 		{ok, NewPlayerStatus,_IsSuc, 0,_ReduceCopper} ->
%% 			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 							 		 ?FLOAT,
%% 							 		 ?None,
%% 							 		 ?ORANGE,
%% 									 ?_LANG_TASK_CARGO_COPPER_NOT_ENOUGH]),
%% 			{reply,{false,NewPlayerStatus}, State};
		{ok, NewPlayerStatus,IsSuc, _Timers,ReduceCopper} ->
			{ok, ResultBin} = pt_24:write(?PP_TASK_QUALITY_REFRESH, [NewPlayerStatus#ets_users.escort_id,IsSuc,ReduceCopper]),
			lib_send:send_to_sid(State#task_status.pid_send, ResultBin),
			{reply,{ok,NewPlayerStatus,ReduceCopper}, State};
		_ ->
%% 			?ERROR_MSG("task is not transport_add ERROR : ~w ",[ERROR]),
			{reply,{false,PlayerStatus}, State}
	end;
	

do_call(Info, _, State) ->
	?WARNING_MSG("mod_task call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast({'client', TaskId, RequireCount}, State) ->
	case lib_task:client_control(TaskId, RequireCount) of
		{ok, TaskInfo} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin);
		{error, _Reason} ->
%% 			?ERROR_MSG("task is not client : ~s ",[Reason]);
			skip;
		ERROR ->
			?ERROR_MSG("task is not c;ient ERROR : ~w ",[ERROR])
	end,
	{noreply, State};
%% 查询任务
do_cast({'query_all'}, State) ->
	List = lib_task:get_dic(),
	{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, List),
	lib_send:send_to_sid(State#task_status.pid_send, Bin),
	{noreply, State};

%% 接受任务
do_cast({'accept', TaskId, PlayerStatus}, State) ->
	case lib_task:accept(PlayerStatus, TaskId) of
		{ok, TaskInfo, EscortTimer, Condition} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			case Condition of
				?TASK_ESCORT_DARTS ->
					NewState = State#task_status{escort_timer = EscortTimer, escort_taskId = TaskId};
				_ ->
					NewState = State
			end;
		{error, _Reason} ->
%% 			todo 发送失败原因
			?ERROR_MSG("task is not accept : ~s ~w",[_Reason ,TaskId]),
%% 			skip;
			NewState = State;
		ERROR ->
			?ERROR_MSG("task is not accept ERROR :~w ~w ",[ERROR ,TaskId]),
			NewState = State
	end,
	{noreply, NewState};

%%接受神魔令任务
do_cast({'accept_shenmo', TaskId, TaskState, Level, Sex, Camp, Career, ShenmoTimes}, State) ->
	case lib_task:accept_shenmo(State#task_status.user_id, State#task_status.pid_player, State#task_status.pid_send, Level, Sex, Camp, Career, TaskId, TaskState, ShenmoTimes) of
		{ok, TaskInfo} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin);
		{error, Reason} ->
			?ERROR_MSG("task is not accept : ~s ",[Reason]);
		ERROR ->
			?ERROR_MSG("task is not accept ERROR : ~w ",[ERROR])
	end,
	{noreply, State};

%% 取消任务
do_cast({'cancel', TaskId}, State) ->
	case lib_task:cancel_task(State#task_status.pid_player, TaskId) of  %%State#task_status.user_id
		{ok, NewInfo, Condition} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [NewInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			case Condition of
				?TASK_ESCORT_DARTS ->
					NewState = State#task_status{escort_timer = -1, escort_taskId = 0};
				_ ->
					NewState = State
			end;
		{error, _Reason} ->
%% 			?ERROR_MSG("task is not cancel : ~s ",[Reason]);
%% 			skip;
			NewState = State;
		ERROR ->
			?ERROR_MSG("task is not cancel ERROR : ~w ",[ERROR]),
			NewState = State
	end,
	{noreply,NewState};

%% do_cast({cancel_token_task}, State) ->
%% 	case lib_task:cancel_token_task(State#task_status.pid_player) of
%% 		{ok, NewInfo, _Condition} ->
%% 			%?DEBUG("task  cancel ok: ~p ",[NewInfo]),
%% 			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [NewInfo]),
%% 			lib_send:send_to_sid(State#task_status.pid_send, Bin),
%% 			NewState = State;
%% 		{error, _Reason} ->
%% 			?DEBUG("task is not cancel : ~s ",[_Reason]),
%% 			NewState = State;
%% 		ERROR ->
%% 			?ERROR_MSG("task is not cancel ERROR : ~w ",[ERROR]),
%% 			NewState = State
%% 	end,
%% 	{noreply,NewState};

%% 取消江湖令任务
%% 立即完成江湖任务


%% 杀怪检查
do_cast({'kill_monster', MonsterId, DropList}, State) ->
	TaskList1 = case lib_task:kill_monster(State#task_status.user_id, MonsterId) of
						{ok, []} ->
							[];
						{ok, KillTask} ->
				%% 			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, KillTask),
				%% 			lib_send:send_to_sid(State#task_status.pid_send, Bin);
							KillTask;
						_  ->
							?WARNING_MSG("kill_monster is error.", []),
							[]
					end, 

	TaskList2 = case lib_task:drop_kill_monster(State#task_status.user_id, DropList) of
						  {ok, DropTask} ->
							  DropTask;
						  _ ->
							  ?WARNING_MSG("drop_kill_monster is error.", []),
							  []
					  end,
	if length(TaskList1) > 0 orelse length(TaskList2) > 0 ->
%% 		   NewList = TaskList1 ++ TaskList2,
		   NewList = lists:concat([TaskList1, TaskList2]),
		   {ok, Bin} = pt_24:write(?PP_TASK_UPDATE, NewList),
		   lib_send:send_to_sid(State#task_status.pid_send, Bin);
	   true ->
		   skip
	end,

	{noreply, State};

%% 采集物品
do_cast({'collect_item', TemplateId}, State) ->
	case lib_task:collect_item(State#task_status.user_id, TemplateId) of
		{ok, []} ->
			skip;
		{ok, TaskList} ->
		   {ok, Bin} = pt_24:write(?PP_TASK_UPDATE, TaskList),
		   lib_send:send_to_sid(State#task_status.pid_send, Bin);
		_ ->
		   ?WARNING_MSG("collect_item is error.", []),
		   error
	end,
	{noreply, State};

%% 购买
do_cast({'buy_item', TemplateId,Count}, State) ->
	case lib_task:buy_item(State#task_status.user_id, TemplateId,Count) of
		{ok, []} ->
			skip;
		{ok, TaskList} ->
		   {ok, Bin} = pt_24:write(?PP_TASK_UPDATE, TaskList),
		   lib_send:send_to_sid(State#task_status.pid_send, Bin);
		_ ->
		   ?WARNING_MSG("collect_item is error.", []),
		   error
	end,
	{noreply, State};

%% do_cast({'accept', TaskId, Sex, Camp, Career, Level, PosX, PosY}, State) ->
%% 	case lib_task:accept(State#task_status.user_id, TaskId, Sex, Camp, Career, Level, PosX, PosY) of
%% 		{ok, TaskInfo} ->
%% 			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [TaskInfo]),
%% 			lib_send:send_to_sid(State#task_status.pid_send, Bin);
%% 		{error, _Reason} ->
%% %% 			todo 发送失败原因
%% %% 			?ERROR_MSG("task is not accept : ~s ",[Reason]);
%% 			skip;
%% 		ERROR ->
%% 			?ERROR_MSG("task is not accept ERROR : ~w ",[ERROR])
%% 	end,
%% 	{noreply, State};


%%重新上线后初始化运镖的时间和任务ID
do_cast({'init_escort_info', FinishTime}, State) ->
	case lib_task:get_escort_info(FinishTime) of
		{ok, TaskId, DartsLeftTime, EscortState} ->
			gen_server:cast(State#task_status.pid_player, {'update_escort_state', EscortState}),
			NewState = State#task_status{escort_timer = DartsLeftTime, escort_taskId=TaskId};
		{error, _Reason}->
			gen_server:cast(State#task_status.pid_player, {'update_escort_time', 0}),%%没有对应运镖任务将运镖剩余时间清为0
			NewState = State
%% 			?ERROR_MSG("task is not init_escort_time ERROR : ~w ",[_Reason])
	end,
	{noreply, NewState};

do_cast({'check_player_dead', Player, AttackerPid, AttName, AttType}, State) ->
	case lib_task:check_player_dead(Player, AttackerPid, AttName, AttType) of
		{ok, NewInfo} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, [NewInfo]),
			lib_send:send_to_sid(State#task_status.pid_send, Bin),
			NewState = State#task_status{escort_timer = -1, escort_taskId = 0};
		{error, _Reason}->
%% 			?ERROR_MSG("task is not init_escort_time ERROR : ~w ",[_Reason])
			NewState = State
	end,
	{noreply, NewState};

%%充值
do_cast({'recharge'}, State) ->
	case lib_task:recharge() of
		{ok, TaskInfos} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, TaskInfos),
			lib_send:send_to_sid(State#task_status.pid_send, Bin);
		{error, _Reason} ->
%% 			?ERROR_MSG("task is not client : ~s ",[Reason]);
			skip;
		_ ->
			skip

	end,
	{noreply, State};

%%取消所有帮会任务
do_cast({'cancel_guild_tasks'}, State) ->
	case lib_task:cancel_task_by_condition() of
		{ok, TaskInfos} ->
			{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, TaskInfos),
			lib_send:send_to_sid(State#task_status.pid_send, Bin);
		_ ->
			skip
	end,
	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	lib_task:task_offline(),
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_task cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%% 任务扫描
do_info({'scan_time'}, State) ->
	%% 放在前面发送，防止出错死掉
	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
	
	Now = misc_timer:now_seconds(),
		
	%% 委托任务
	case lib_task:check_trust_task(State#task_status.user_id) of
		{ok, NewList, TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, AwardList} ->
			if length(NewList) > 0 ->
				{ok, Bin} = pt_24:write(?PP_TASK_UPDATE, NewList),
				lib_send:send_to_sid(State#task_status.pid_send, Bin),
				gen_server:cast(State#task_status.pid_player, 
							{'task_award', TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, 0, AwardList, State#task_status.escort_taskId});
			   true ->
				   skip
			end;
		{error, Reason} ->
			?ERROR_MSG("task is not submit : ~s ",[Reason]);
		ERROR ->
			?ERROR_MSG("task is not submit ERROR : ~w ",[ERROR])
	end,
	
	%% 刷新任务,登陆自动刷新一次
	case lib_task:refresh_repeat_task(State#task_status.user_id, State#task_status.last_date, Now) of
		{ok, List} ->
			if length(List) > 0 ->
				{ok, RefreshBin} = pt_24:write(?PP_TASK_UPDATE, List),
				lib_send:send_to_sid(State#task_status.pid_send, RefreshBin);
			   true ->
				   skip
			end;
		_ ->
			skip
	end,
	
	%%更新运镖时间
	NewTimer = State#task_status.escort_timer - 5,
	case State#task_status.escort_timer >= 0 of
		true ->
			case NewTimer =< 0 andalso State#task_status.escort_taskId > 0 of
				true ->
					case lib_task:cancel_task(State#task_status.pid_player, State#task_status.escort_taskId) of
						{ok, NewInfo, _Condition} ->
							{ok, TaskInfoBin} = pt_24:write(?PP_TASK_UPDATE, [NewInfo]),
							lib_send:send_to_sid(State#task_status.pid_send, TaskInfoBin);
						_ ->
							skip
					end,
					NewState = State#task_status{escort_timer = -1, escort_taskId = 0};
				_ ->
					NewState = State#task_status{escort_timer = NewTimer}
			end;
		_ ->
			NewState = State#task_status{escort_timer = NewTimer}
	end,
	
	%% 如果时间到，自动保存数据库
	if NewState#task_status.save_date + ?SAVE_TASK_TICK < Now ->
		   lib_task:save_dic(),
		   {noreply, NewState#task_status{last_date=Now, save_date=Now}};
	   true ->
		   {noreply, NewState#task_status{last_date=Now}}
	end;

%% 	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
%% 	{noreply, State#task_status{last_date=Now}};
	
do_info(Info, State) ->
	?WARNING_MSG("mod_task info is not match:~w",[Info]),
    {noreply, State}.

