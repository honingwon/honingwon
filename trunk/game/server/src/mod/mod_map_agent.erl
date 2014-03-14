%%%------------------------------------
%%% @Module  : mod_map_agent
%%% @Author  : ygzj
%%% @Created : 2010.11.06
%%% @Description: 场景管理_代理
%%%------------------------------------
-module(mod_map_agent). 
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl"). 
-include_lib("stdlib/include/ms_transform.hrl").

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile([export_all]).

-record(state, {worker_id = 0}).
-define(CLEAR_ONLINE_PLAYER, 10*60*1000).	  %% 每10分钟 对 ets_online 做一次清理
-define(COPY_BROAD_COUNT, 10).				 %% 小于30才做直接广播。

%% ====================================================================
%% External functions
%% ====================================================================
start({SceneAgentProcessName, Worker_id}) ->
    gen_server:start(?MODULE, {SceneAgentProcessName, Worker_id}, []).

start_link({SceneAgentProcessName, Worker_id}) ->
	gen_server:start_link(?MODULE, {SceneAgentProcessName, Worker_id}, []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init({SceneAgentProcessName, Worker_id}) ->
    process_flag(trap_exit, true),
	if Worker_id =:= 0 ->
			misc:write_monitor_pid(self(), mod_scene_agent, {?SCENE_WORKER_NUMBER}),
			%% 启动多个场景代理服务进程
			lists:foreach(
				fun(WorkerId) ->
					SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
					mod_map_agent:start({SceneAgentWorkerName, WorkerId}),
					ok
				end,
				lists:seq(1, ?SCENE_WORKER_NUMBER)),
			pg2:create(scene_agent),
			pg2:join(scene_agent, self()),
			erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player});
	   true -> 
		   misc:register(local, tool:to_atom(SceneAgentProcessName), self()),
		   misc:write_monitor_pid(self(),mod_scene_agent_worker, {Worker_id})
	end,
	State= #state{worker_id = Worker_id},	
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
			?WARNING_MSG("mod_map_agent handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_map_agent handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_map_agent handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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

%%---------------------do_call--------------------------------
%% 统一模块+过程调用(call)
do_call({apply_call, Module, Method, Args}, _From, State) ->	
	Reply  = 
	case apply(Module, Method, Args) of
		 {'EXIT', _Info} ->	
%% 			 ?WARNING_MSG("mod_scene_agent_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
			 error;
		 DataRet -> 
			 DataRet
	end,
    {reply, Reply, State};

do_call(_Request, _From, State) ->
    {reply, State, State}.

%%---------------------do_cast--------------------------------
%%发送答题结果数据
do_cast({send_to_scene, {SceneId,Limit,Index,Res,List,List2}},State) ->
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_question_answer, SceneId,Limit,Index,Res,List,List2}),
	{noreply, State};
%%接受请求发送信息到场景,并分发给各代理工
do_cast({send_to_scene, SceneId, BinData}, State) ->
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_scene, SceneId, BinData}),
	{noreply, State};

do_cast({send_to_scene, SceneId, BinData, ExceptId}, State) ->
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_scene, SceneId, BinData, ExceptId}),
	{noreply, State};


%%接受请求发送信息到场景区域,并分发给各代理工
do_cast({send_to_scene, SceneId, X, Y, BinData}, State) ->  
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_scene, SceneId, X, Y, BinData}),
	{noreply, State};

do_cast({send_to_scene, SceneId, X, Y, BinData, ExceptId}, State) ->
	WorkerId = random:uniform(?SCENE_WORKER_NUMBER),
	SceneAgentWorkerName = misc:create_process_name(scene_agent_p, [WorkerId]),
	gen_server:cast(tool:to_atom(SceneAgentWorkerName), {send_to_local_scene, SceneId, X, Y, BinData, ExceptId}),
	{noreply, State};


%%发送答题答案
do_cast({send_question_answer, SceneId,Limit,Index,Res,List,List2}, State) ->
	lib_send:send_question_answer( SceneId,Limit,Index,Res,List,List2),	
	{noreply, State};
%%发送信息到本地的场景用户
do_cast({send_to_local_scene, SceneId, BinData}, State) ->
	lib_send:send_to_local_scene(SceneId, BinData),	
	{noreply, State};


do_cast({send_to_local_scene, SceneId, BinData, ExceptId}, State) ->
	lib_send:send_to_local_scene(SceneId, BinData, ExceptId),	
	{noreply, State};

%%发送信息到本地的场景用户(区域)
do_cast({send_to_local_scene, SceneId, X, Y, BinData}, State) ->
	lib_send:send_to_local_scene(SceneId, X, Y, BinData),	
	{noreply, State};

do_cast({send_to_local_scene, SceneId, X, Y, BinData, ExceptId}, State) ->
	lib_send:send_to_local_scene(SceneId, X, Y, BinData, ExceptId),	
	{noreply, State};

%%当人物移动时候的广播
do_cast({move_broadcast, SceneId, Pid_player, X1, Y1, X2, Y2, BinData, LeaveData}, State) ->
	lib_map:move_broadcast_node(SceneId, Pid_player, X1, Y1, X2, Y2, BinData, LeaveData),
	{noreply, State};

%% 复活进入场景
do_cast({revive_to_scene, Pid_player, PlayerId, ReviveType, Scene1, X1, Y1, Scene2, X2, Y2, Bin12003}, State) ->
	lib_map:revive_to_scene_node(Pid_player, PlayerId, ReviveType, Scene1, X1, Y1, Scene2, X2, Y2, Bin12003),
	{noreply, State};

%% 统一模块+过程调用(cast)
do_cast({apply_cast, Module, Method, Args}, State) ->
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_scene_agent_apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State};

do_cast(_Msg, State) ->
    {noreply, State}.


%%---------------------do_info--------------------------------
do_info({event, clear_online_player}, State) ->
	erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player}),	
	L = ets:tab2list(?ETS_ONLINE),
	Now = misc_timer:now_seconds(),
	DisTime = 20 * 60, 
	F = fun(Info) ->
				case is_record(Info, ets_users) of
					true ->
						if Now > Info#ets_users.other_data#user_other.map_last_time + DisTime ->
					 		  ets:delete(?ETS_ONLINE, Info#ets_users.id),
							  case erlang:is_port(Info#ets_users.other_data#user_other.socket) of
						   			true ->
										gen_tcp:close(Info#ets_users.other_data#user_other.socket);
						  		 	_ ->
							   			skip
					   		 end;
				   		true ->
					   		skip
						end;
					_ ->
						ets:delete_object(?ETS_ONLINE, Info),
						?WARNING_MSG("clear_online_player:~w", [Info])
				end
						
%% 				if Now > Info#ets_users.other_data#user_other.map_last_time + DisTime ->
%% 					   ets:delete(?ETS_ONLINE, Info#ets_users.id),
%% 					   case erlang:is_port(Info#ets_users.other_data#user_other.socket) of
%% 						   true ->
%% 								gen_tcp:close(Info#ets_users.other_data#user_other.socket);
%% 						   _ ->
%% 							   skip
%% 					   end;
%% 				   true ->
%% 					   skip
%% 				end
		end,
	lists:foreach(F, L),
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_map_agent is error:~w", [Info]),
    {noreply, State}.

%% =========================================================================
%%% 业务逻辑处理函数
%% =========================================================================
%% 发送数据到某一场景 
send_to_scene(SceneId, BinData)->
	[gen_server:cast(Pid, {send_to_scene, SceneId, BinData}) || Pid <- misc:pg2_get_members(scene_agent)].

send_to_map(SceneId, BinData, IsAtMap)->
	IsCopy = lib_map:is_copy_scene(SceneId),
	if IsCopy =:= true andalso IsAtMap ->
		   List = lib_map:get_online_dic(),
		   F = fun(Info) ->
					   lib_send:send_to_sid(Info#ets_users.other_data#user_other.pid_send, BinData)
			   end,
		   lists:foreach(F, List);
	   true ->
		   [gen_server:cast(Pid, {send_to_scene, SceneId, BinData}) || Pid <- misc:pg2_get_members(scene_agent)]
	end.

%% 发送数据到某一场景区域
send_to_area_scene(SceneId, X, Y, BinData) ->
	[gen_server:cast(Pid, {send_to_scene, SceneId, X, Y, BinData}) || Pid <- misc:pg2_get_members(scene_agent)].

send_to_area_scene(SceneId, X, Y, BinData, ExceptId) ->
	[gen_server:cast(Pid, {send_to_scene, SceneId, X, Y, BinData, ExceptId}) || Pid <- misc:pg2_get_members(scene_agent)].

send_to_map_scene(SceneId, X, Y, BinData) ->
	send_to_map_scene(SceneId, X, Y, BinData, 0).

send_to_map_scene(SceneId, X, Y, BinData, ExceptId) ->
	IsCopy = lib_map:is_copy_scene(SceneId),
	if IsCopy =:= true ->
		   List = lib_map:get_online_dic(),
		   case length(List) < ?COPY_BROAD_COUNT of
				true ->
					Slice9 = lib_map:get_9_slice(X, Y),
					F = fun(Info) ->
								InSlice = lib_map:is_pos_in_slice(Info#ets_users.pos_x, Info#ets_users.pos_y, Slice9),
								if
									InSlice == true andalso ExceptId =/= Info#ets_users.id ->
										lib_send:send_to_sid(Info#ets_users.other_data#user_other.pid_send, BinData);
									true ->
										ok
								end
						end,
		   			lists:foreach(F, List);
				_ ->
					[gen_server:cast(Pid, {send_to_scene, SceneId, X, Y, BinData, ExceptId}) || Pid <- misc:pg2_get_members(scene_agent)]
		   end;
	   true ->
		   [gen_server:cast(Pid, {send_to_scene, SceneId, X, Y, BinData, ExceptId}) || Pid <- misc:pg2_get_members(scene_agent)]
	end.
%% 	[gen_server:cast(Pid, {send_to_scene, SceneId, X, Y, BinData, ExceptId}) || Pid <- misc:pg2_get_members(scene_agent)].
send_question_answer(SceneId,Limit,Index,Res,List,List2) ->
	[gen_server:cast(Pid, {send_question_answer, SceneId,Limit,Index,Res,List,List2}) || Pid <- misc:pg2_get_members(scene_agent)].
%% 	UList = lib_map:get_online_dic(),
%% 	?DEBUG("UList:~p",[length(UList)]),
%% 	case length(UList) < ?COPY_BROAD_COUNT of
%% 		true ->
%% 				F = fun(Info) ->
%% 						?DEBUG("UList_x:~p",[Info#ets_users.pos_x]),
%% 						V = Info#ets_users.level * Info#ets_users.level,
%% 						if
%% 							Info#ets_users.pos_x > Limit andalso Res =:= 2 ->
%% 								NewList = [{?CURRENCY_TYPE_EXP,V bsl 1},{?CURRENCY_TYPE_BIND_COPPER,V}],
%% 								NewRes = 1;
%% 							Info#ets_users.pos_x =< Limit andalso Res =:= 1 ->
%% 								NewList = [{?CURRENCY_TYPE_EXP,V bsl 1},{?CURRENCY_TYPE_BIND_COPPER,V}],
%% 								NewRes = 1;
%% 							true ->
%% 								NewList = [{?CURRENCY_TYPE_EXP,V},{?CURRENCY_TYPE_BIND_COPPER,V bsr 1}],
%% 								NewRes = 0
%% 						end,
%% 						gen_server:cast(Info#ets_users.other_data#user_other.pid,{add_duplicate_award, NewList}),
%% 						{ok, Bin} = pt_23:write(Index,NewRes),
%% 						lib_send:send_to_sid(Info#ets_users.other_data#user_other.pid_send, Bin)
%% 					end,
%% 		   		lists:foreach(F, UList);
%% 		_ ->
%% 				[gen_server:cast(Pid, {send_question_answer, SceneId,Limit,Index,Res,List,List2}) || Pid <- misc:pg2_get_members(scene_agent)]
%% 	end.

%%当人物或者怪物移动时候的广播
move_broadcast(SceneId, Pid_player, X1, Y1, X2, Y2, BinData,LeaveData) ->
	[gen_server:cast(Pid, {move_broadcast, SceneId, Pid_player, X1, Y1, X2, Y2, BinData,LeaveData}) || Pid <- misc:pg2_get_members(scene_agent)].



