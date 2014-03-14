%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-4-8
%%% -------------------------------------------------------------------
-module(mod_token_task).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl"). 
%% --------------------------------------------------------------------
%% External exports
-export([]).

%% gen_server callbacks
-export([start_link/0,stop/0,get_token_pid/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


-define(CLEAR_OLD_TOKEN_TIME, 3600 * 1000). %%清除定时间

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).


get_token_pid() ->
	ProcessName = ?GLOBAL_TOKEN_PROCESS_NAME,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_token_task(ProcessName)
			end;
		_ ->
			start_mod_token_task(ProcessName)
	end.

%%启动江湖令监控模块 (加锁保证全局唯一)
start_mod_token_task(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_token_task()
				end;
			_ ->
				start_token_task()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启江湖令监控模块
start_token_task() ->
    case supervisor:start_child(
               server_sup,
               {mod_token_task,
                {mod_token_task, start_link,[]},
                permanent, 10000, worker, [mod_token_task]}) of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_token_task error:~p~n",[R]),
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
		_:Reason ->
			?WARNING_MSG("mod_token_task handle_call is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start token service is error"}
	end.

do_init() ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	misc:register(global, ?GLOBAL_TOKEN_PROCESS_NAME, self()), 
%% 	ets:new(?ETS_TOKEN_PUBLISH_1, [{keypos, #ets_token_publish_info.token_id}, named_table, public, set]),			%%江湖令发布历史信息
%% 	ets:new(?ETS_TOKEN_PUBLISH_2, [{keypos, #ets_token_publish_info.token_id}, named_table, public, set]),			%%江湖令发布历史信息
%% 	ets:new(?ETS_TOKEN_PUBLISH_3, [{keypos, #ets_token_publish_info.token_id}, named_table, public, set]),			%%江湖令发布历史信息
%% 	ets:new(?ETS_TOKEN_PUBLISH_4, [{keypos, #ets_token_publish_info.token_id}, named_table, public, set]),			%%江湖令发布历史信息
%% 	Token_Publish_Count = lib_token_task:init_token_publish(),
%% 	State = #mod_token_task_state{token_count = Token_Publish_Count},
	State = lib_token_task:init_token_publish(),
	erlang:send_after(?CLEAR_OLD_TOKEN_TIME, self(),{clear_old_token}),
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
			?WARNING_MSG("mod_token_task handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
handle_cast(Msg, State) ->
    try
		do_cast(Msg, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_token_task handle_call is exception:~w~n,Info:~w",[Reason, Msg]),
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
			?WARNING_MSG("mod_token_task handle_call is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
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
%% get_token_pid() ->
%% 	case global:whereis_name(?GLOBAL_TOKEN_PROCESS_NAME) of
%% 			    undefined ->
%% 		 		    false;
%% 	      	    Pid ->
%% 		    		Pid
%% 	end.
%% 玩家接收江湖令任务后更新总数
do_call({receive_task, Type, Pid}, _From, State) ->
	{AutoId, N1, N2, N3, N4} = State#mod_token_task_state.token_count,
	case Type of
		1 when (N1 > 0)->
			[Info|L] = State#mod_token_task_state.token_publish_list_1,
			NewState = State#mod_token_task_state{token_publish_list_1 = L, token_count = {AutoId, N1 -1, N2, N3, N4}};
		2 when (N2 > 0)->
			[Info|L] = State#mod_token_task_state.token_publish_list_2,
			NewState = State#mod_token_task_state{token_publish_list_2 = L, token_count = {AutoId, N1, N2 -1, N3, N4}};
		3 when (N3 > 0)->
			[Info|L] = State#mod_token_task_state.token_publish_list_3,
			NewState = State#mod_token_task_state{token_publish_list_3 = L, token_count = {AutoId, N1, N2, N3 -1, N4}};
		4 when (N4 > 0)->
			[Info|L] = State#mod_token_task_state.token_publish_lsit_4,
			NewState = State#mod_token_task_state{token_publish_lsit_4 = L, token_count = {AutoId, N1, N2, N3, N4 -1}};
		_ ->
			Info = [],
			NewState = State
	end,
	case Info of
		[] ->
			{reply,[], State};
		PublishInfo ->			
			{ok,Bin} = pt_24:write(?PP_TOKEN_PUBLISH_LIST, NewState#mod_token_task_state.token_count),
			lib_send:send_to_sid(Pid, Bin),
			db_agent_token_task:delete_token(PublishInfo#ets_token_publish_info.token_id),
			{reply,PublishInfo, NewState}
	end;

do_call(Info, _, State) ->
	?WARNING_MSG("mod_token_task call is not match:~w",[Info]),
    {reply, ok, State}.


%%发布江湖令
do_cast({publish_token_task, Userid, Level, Type}, State) ->
	{AutoId, Num1, Num2, Num3, Num4} = State#mod_token_task_state.token_count,
	NewTokenId = AutoId + 1,
	PublishInfo = #ets_token_publish_info{publish_user_id = Userid, publish_level = Level, token_id = NewTokenId , type = Type},
	case Type of
		1 ->					
					%ets:insert(?ETS_TOKEN_PUBLISH_1, PublishInfo),
					NewList = State#mod_token_task_state.token_publish_list_1 ++ [PublishInfo],
					NewState = State#mod_token_task_state{token_publish_list_1 = NewList,  token_count = {NewTokenId,Num1 + 1,Num2,Num3,Num4}};
		2 ->
					%ets:insert(?ETS_TOKEN_PUBLISH_2, PublishInfo),
					NewList = State#mod_token_task_state.token_publish_list_2 ++ [PublishInfo],
					NewState = State#mod_token_task_state{token_publish_list_2 = NewList,  token_count = {NewTokenId,Num1, Num2 + 1,Num3,Num4}};
		3 ->
					%ets:insert(?ETS_TOKEN_PUBLISH_3, PublishInfo),
					NewList = State#mod_token_task_state.token_publish_list_3 ++ [PublishInfo],
					NewState = State#mod_token_task_state{token_publish_list_3 = NewList,  token_count = {NewTokenId,Num1, Num2, Num3 + 1,Num4}};
		4 ->
					%ets:insert(?ETS_TOKEN_PUBLISH_4, PublishInfo),
					NewList = State#mod_token_task_state.token_publish_lsit_4 ++ [PublishInfo],
					NewState = State#mod_token_task_state{token_publish_lsit_4 = NewList, token_count = {NewTokenId,Num1, Num2,Num3,Num4 + 1}};
		_ ->
					?WARNING_MSG("init_token_publish Error:~p",[{Type}]),
					NewState = State
	end,	
	db_agent_token_task:add_token(PublishInfo),
	{noreply, NewState};

%% 发送服务器江湖令发布信息
do_cast({send_publish_count, Pid}, State) ->
	{ok,Bin} = pt_24:write(?PP_TOKEN_PUBLISH_LIST, State#mod_token_task_state.token_count),
	lib_send:send_to_sid(Pid, Bin),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_token_task cast is not match:~w",[Info]),
    {noreply, State}.
do_info({clear_old_token}, State) ->
	%%判断12点的时候清除全部发布信息
	{noreply, State};
do_info(Info, State) ->
	?WARNING_MSG("mod_token_task info is not match:~w",[Info]),
    {noreply, State}.
