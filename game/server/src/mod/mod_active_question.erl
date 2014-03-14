%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-6-7
%%% -------------------------------------------------------------------
-module(mod_active_question).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").

-define(QUESTION_ANSWER_NEXT_TIME, 20 * 1000). %%答题到公布答案并发放奖励间隔时间	
-define(QUESTION_ANSWER_AWARD_TIME, 3 * 1000). %%奖励到开始下一题时间间隔
%% --------------------------------------------------------------------
%% External exports
-export([start_link/0,stop/0,get_active_question_pid/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {
		question_index = 1,		%%当前答题编号
		question_list = [],		%%题目列表
		question_award = []		%%奖励列表
		}).

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

get_active_question_pid() ->
	ProcessName = mod_active_question_process_name,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> Pid;
				false ->
					start_mod_active_question(ProcessName)
			end;
		_ ->
			start_mod_active_question(ProcessName)
	end.

%%启动活动1001监控模块 (加锁保证全局唯一)
start_mod_active_question(ProcessName) ->
	global:set_lock({ProcessName, undefined}), 
	ProcessPid = 
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> Pid;
					false ->
						start_active_question()
				end;
			_ ->
				start_active_question()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%开启活动1001监控模块
start_active_question() ->
%%     case supervisor:start_child(
%%                server_sup,
%%                {mod_active_question,
%%                 {mod_active_question, start_link,[]},
%%                 permanent, 10000, worker, [mod_active_question]}) of
	case start_link() of
		{ok, Pid} ->
				Pid;
		{error, R} ->
				?WARNING_MSG("start active_question error:~p~n",[R]),
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
			?WARNING_MSG("mod_active_question init is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "start active service is error"}
	end.

do_init() ->
	process_flag(trap_exit, true),
	misc:register(global, mod_active_question_process_name , self()),
	
	erlang:send_after(60000, self(), {answer_next_question}),%%优先开始答题计时。
 	List = lib_active_question:init_active_question_list(),
	State = #state{question_list = List},	
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
			?WARNING_MSG("mod_active_question  call is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_active_question cast is exception:~w~",[Reason]),
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
			?WARNING_MSG("mod_active_question info is exception:~w~",[Reason]),
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
	?WARNING_MSG("mod_active_question call is not match:~w",[Info]),
    {reply, ok, State}.
%% 停止
do_cast({stop}, State) ->
	{stop, normal, State};

do_cast({set_continue_time, _Time}, State) ->
	{noreply, State};

do_cast({set_question_award, List}, State) ->
	NewList = tool:split_string_to_intlist(List),
	NewState = State#state{question_award = NewList},
	{noreply, NewState};

do_cast(Info, State) ->
	?WARNING_MSG("mod_active_question cast is not match:~w",[Info]),
    {noreply, State}.

do_info({send_answer_award},State) ->
	%?DEBUG("send_answer_award:~p",[State#state.question_award]),
	Question = lists:nth(State#state.question_index, State#state.question_list),
	lib_active_question:send_answer_award(State#state.question_index, Question, State#state.question_award),
	if
		State#state.question_index >= ?MAX_ACTIVE_QUESTION_NUMBER ->
			NewState = State,
			stop();
		true ->			
			NewState = State#state{question_index = State#state.question_index + 1},
			erlang:send_after(?QUESTION_ANSWER_AWARD_TIME, self(), {answer_next_question})
	end,
	{noreply, NewState};

do_info({answer_next_question},State) ->
	%?DEBUG("answer_next_question:~p",[State#state.question_index]),
	Question = lists:nth(State#state.question_index, State#state.question_list),
	lib_active_question:next_question(State#state.question_index, Question),
	erlang:send_after(?QUESTION_ANSWER_NEXT_TIME, self(), {send_answer_award}),	
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_active_question info is not match:~w",[Info]),
    {noreply, State}.
