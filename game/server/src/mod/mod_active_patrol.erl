%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-6-17
%%% -------------------------------------------------------------------
-module(mod_active_patrol).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([get_active_patrol_pid/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {user_num = 0,				%%目前队列中玩家人数
				user_join_time = 0,			%%最后一个玩家加入队伍的时间
				user_list = [],				%%
				award_list = [],			%%
				terminal_time = 0,
				group_index = 1}).

%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:cast(self(), {stop}).

get_active_patrol_pid() ->
	ProcessName = mod_active_patrol_process_name,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_active_patrol(ProcessName)
			end;
		_ ->
			start_mod_active_patrol(ProcessName)
	end.

%%启动活动1001监控模块 (加锁保证全局唯一)
start_mod_active_patrol(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_active_patrol()
				end;
			_ ->
				start_active_patrol()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启活动1001监控模块
start_active_patrol() ->
%%     case supervisor:start_child(
%%                server_sup,
%%                {mod_active_question,
%%                 {mod_active_question, start_link,[]},
%%                 permanent, 10000, worker, [mod_active_question]}) of
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start mod_active_patrol error:~p~n",[R]),
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
			?WARNING_MSG("mod_active_patrol init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	process_flag(trap_exit, true),
	misc:register(global, mod_active_patrol_process_name , self()),
	
	erlang:send_after(1000, self(), {auto_start}),%%计算时间到自动开始

	State = #state{},	
	misc:write_monitor_pid(self(),?MODULE, {State}),
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
			?WARNING_MSG("mod_active_patrol  call is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_active_patrol cast is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_active_patrol info is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	gen_server:cast(mod_active:get_active_pid(), {terminal, ?QUESTION_ACTIVE_ID}),
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
	?WARNING_MSG("mod_active_patrol call is not match:~w",[Info]),
    {reply, ok, State}.

do_cast({stop}, State) ->
	{stop, normal, State};

do_cast({set_continue_time, Time}, State) ->
	NewState = State#state{terminal_time = Time},
	{noreply, NewState};

do_cast({set_question_award, List}, State) ->
	NewList = tool:split_string_to_intlist(List),
	NewState = State#state{award_list = NewList},
	{noreply, NewState};

do_cast({join_active, SendPid, UserInfo}, State) ->
	NewList = [{UserInfo}|State#state.user_list],	
	if
		State#state.user_num =:= 5 ->
			lib_active_patrol:send_start_patrol(State#state.group_index,State#state.award_list,NewList),
			NewState = State#state{group_index = State#state.group_index + 1, user_list = [],user_num = 0};
		true ->
			NewState = State#state{user_num = State#state.user_num + 1, user_join_time = 30,user_list = NewList}
	end,
	{ok, Bin} = pt_23:write(?PP_ACTIVE_PATROL_JOIN, [1,NewState#state.user_num]),
	lib_send:send_to_sid(SendPid, Bin),
	{noreply, NewState};

do_cast(Info, State) ->
	?WARNING_MSG("mod_active_patrol cast is not match:~w",[Info]),
    {noreply, State}.

do_info({auto_start}, State) ->
	if
		State#state.terminal_time =:= 0 ->
			lib_active_patrol:send_start_patrol(State#state.group_index,State#state.award_list,State#state.user_list),
			NewState = State#state{group_index = State#state.group_index + 1,user_list = [],user_num = 0},
			stop();
		State#state.user_num =:= 0 ->
			NewState = State#state{terminal_time = State#state.terminal_time - 1};
		State#state.user_join_time =:= 0 ->
			lib_active_patrol:send_start_patrol(State#state.group_index,State#state.award_list,State#state.user_list),
			NewState = State#state{group_index = State#state.group_index + 1, user_list = [], user_num = 0,
									terminal_time = State#state.terminal_time - 1 };
		true ->
			NewState = State#state{user_join_time = State#state.user_join_time - 1, terminal_time = State#state.terminal_time - 1}	
	end,
	{noreply, NewState};

do_info(Info, State) ->
	?WARNING_MSG("mod_active_patrol info is not match:~w",[Info]),
    {noreply, State}.
