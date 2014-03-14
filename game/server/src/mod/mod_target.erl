%%% -------------------------------------------------------------------
%%% Author  : liaoxiaobo
%%% Description :
%%%
%%% Created : 2013-4-23
%%% -------------------------------------------------------------------
-module(mod_target).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").


%% --------------------------------------------------------------------
%% External exports
-export([start_link/4]).

-define(TOTAL_ACHIEVE_NUM,200).		%% 总成就值

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(target_status, {user_id, pid_item,pid_send, pid_player,not_receive_num}).

%% ====================================================================
%% External functions
%% ====================================================================

start_link(UserId,Pid_item, Pid_send, Pid_player) ->
	gen_server:start_link(?MODULE, [UserId, Pid_item,Pid_send, Pid_player], []).

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
init([UserId,Pid_item, Pid_send, Pid_player]) ->
    try 
		do_init([UserId, Pid_item,Pid_send, Pid_player])	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create target is error."}
	end.

do_init([UserId,Pid_item, Pid_send, Pid_player]) ->
	Num = lib_target:init_target_online(UserId),
%% 	Now = misc_timer:now_seconds(),
	State = #target_status{
						 user_id = UserId,
						 pid_item = Pid_item,
						 pid_send = Pid_send,
						 pid_player = Pid_player,
						 not_receive_num = Num
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
handle_call(Info, From, State) ->
    try
		do_call(Info,From, State)
	catch
		_:Reason ->
			?WARNING_MSG("UserId:~w,mod_target handle_call is exception:~w~n,Info:~w",[State#target_status.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_target handle_cast is exception:~w~n,Info:~w",[State#target_status.user_id, Reason, Info]),
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
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
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

%% 获取目标列表
do_cast({'get_target_list',AchieveData}, State) ->
	List = lib_target:get_dic(),
	{ok, Bin} = pt_29:write(?PP_TARGET_LIST_UPDATE, [List,State#target_status.not_receive_num]),
	{ok, Bin1} = pt_29:write(?PP_TARGET_ACHIEVEMENT_UPDATE, [AchieveData,?TOTAL_ACHIEVE_NUM]),
	lib_send:send_to_sid(State#target_status.pid_send, <<Bin/binary,Bin1/binary>>),
	{noreply, State};


%% 获取成就历史数据
do_cast({'get_target_history_list'}, State) ->
	List = lib_target:get_history_dic(),
	{ok, Bin} = pt_29:write(?PP_TARGET_HISTORY_UPDATE, [List]),
	lib_send:send_to_sid(State#target_status.pid_send, Bin),
	{noreply, State};


%% 目标检测
do_cast({'check_target',ConditionList},State) ->
	{UpdateList , FinishList} = lib_target:check_target(State#target_status.pid_player,State#target_status.user_id,ConditionList),
	case length(UpdateList) of
		0 ->
			{noreply, State};
		_ ->
			F = fun(Target,{UpdateList , FinishList}) ->
						if
							Target#ets_users_targets.type =:= 1 ->
								{UpdateList1 , FinishList1} = lib_target:check_target(State#target_status.pid_player,State#target_status.user_id,[{?TARGET_ALL_FINISH,{Target#ets_users_targets.target_id,1}}]),
								{UpdateList ++ UpdateList1,FinishList++FinishList1};
							true ->
								{UpdateList , FinishList}
						end
				end,
			{NewUpdateList , NewFinishList} = lists:foldl(F, {UpdateList , FinishList}, FinishList),
			FinishLen = length(NewFinishList),		
		
			NewNum = State#target_status.not_receive_num + FinishLen,
			NewState = State#target_status{not_receive_num = NewNum},
			{ok, Bin} = pt_29:write(?PP_TARGET_LIST_UPDATE, [NewUpdateList,NewNum]),
			case FinishLen =/= 0 of
				true ->
					{ok, Bin1} = pt_29:write(?PP_TARGET_FINISH, [NewFinishList]);
				_ ->
					Bin1 = <<>>
			end,
			
			lib_send:send_to_sid(State#target_status.pid_send, <<Bin/binary,Bin1/binary>>),
			{noreply, NewState}
	end;
	
	
%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast({apply_cast, Module, Method, Args}, State) ->
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_target__apply_cast error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_target cast is not match:~w",[Info]),
    {noreply, State}.



%% 领取目标奖励
do_call({'get_target_award',PlayerStatus,Id}, _,State) ->
	case lib_target:get_award(PlayerStatus,Id) of
		false ->
			{ok, Bin} = pt_29:write(?PP_TARGET_GET_AWARD, [Id,State#target_status.not_receive_num,0]),
			lib_send:send_to_sid(State#target_status.pid_send, Bin),
			{reply,{ok}, State};
		{Value,PlayerStatus1} ->
			NewNum = State#target_status.not_receive_num - 1,
			NewState = State#target_status{not_receive_num = NewNum},
			{ok, Bin} = pt_29:write(?PP_TARGET_GET_AWARD, [Id,NewNum,1]),
			lib_send:send_to_sid(NewState#target_status.pid_send, Bin),
			case Value of
				update ->
					{ok, Bin1} = pt_29:write(?PP_TARGET_ACHIEVEMENT_UPDATE, [PlayerStatus1#ets_users.achieve_data,?TOTAL_ACHIEVE_NUM]),
					lib_send:send_to_sid(NewState#target_status.pid_send, Bin1);
					
				_ ->
					skip
			end,
					
			{reply,{Value,PlayerStatus1}, NewState}
	end;


do_call(Info, _, State) ->
	?WARNING_MSG("mod_target call is not match:~w",[Info]),
    {reply, ok, State}.





