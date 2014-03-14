%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2012-9-26
%%% -------------------------------------------------------------------
-module(fsm_veins).

-behaviour(gen_fsm).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-export([init/1, handle_event/3, handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).
-export([start_link/2]).
-export([reduce_practice_time/2,start_practice/2]).
-export([unixtime/0]).
-export([beg/2,beg/3,over/2,over/3]).
 
-record(state,{
				timeout = 0,					%% 穴位升级修炼所需时间
				user_pid = undefined			%% 用户pid	
				}).

-define(FSM_CLOSE_TIME_OUT, 30000).				%% 停止修炼10秒后关闭状态机

%%-----------------------------------------------------------
%% 系统函数
%%-----------------------------------------------------------
start_link(Timeout,Pid) ->
    gen_fsm:start_link(?MODULE, [Timeout,Pid], []).

%% 初始化
init([Timeout,Pid]) ->
%% 	io:format("fsm START Reason : ~p",[{Timeout,Pid}]),
	StateData = #state{timeout = Timeout, user_pid = Pid},
    {ok, beg, StateData, timeout(Timeout)}.
 
reduce_practice_time(Pid,ReduceTime) ->
	gen_fsm:send_event(Pid, {reduce_time, ReduceTime}).

start_practice(Pid, PracticeTime) ->
	%%io:format("send event pid:~p,time:~p~n",[Pid, PracticeTime]),
	gen_fsm:send_event(Pid, {practice_start, PracticeTime}).

beg({reduce_time, ReduceTime}, StateData) ->
	NewStateData = StateData#state{timeout = StateData#state.timeout - ReduceTime },
	{next_state, beg, NewStateData, timeout(NewStateData#state.timeout)};
beg(timeout, StateData) ->
	gen_server:cast(StateData#state.user_pid,{practice_time, practice_end}),
	%%io:format("currter state::beg~n"),
	{next_state, over, StateData, ?FSM_CLOSE_TIME_OUT};
beg({stop, _Reason}, StateData) ->
	{stop, normal, StateData};
beg(_Event, StateData) ->
	%%可输出错误信息
	%%io:format("currter state::bag,event:~p , state:~p~n",[_Event, StateData]),
	{next_state, beg, StateData, timeout(StateData#state.timeout)}.

over({practice_start, ReduceTime}, StateData) ->
	NewStateData = StateData#state{timeout = ReduceTime},
	%%io:format("currter state::over~n"),
	{next_state, beg, NewStateData, timeout(NewStateData#state.timeout)};
over(timeout, StateData) ->
	{stop, normal, StateData};
over({stop, _Reason}, StateData) ->
	{stop, normal, StateData};
over(_Event, StateData) ->
	%%可输出错误信息
	%%io:format("currter state::over,event:~p , state:~p~n",[_Event, StateData]),
	{next_state, over, StateData, ?FSM_CLOSE_TIME_OUT}.

%%--------------------------------------------------------------------
%% 状态回调函数
%%-------------------------------------------------------------------

beg(_Event, _From, StateData)	->
	%%io:format("currter state call backe bag~n"),
    {reply, ok, beg, StateData, timeout(StateData#state.timeout)}.

over(_Event, _From, StateData)	->
	%%io:format("currter state call backe over~n"),
    {reply, ok, over, StateData, ?FSM_CLOSE_TIME_OUT}.

handle_event(_Event, State, StateData) ->
	%%io:format("fsm Event : ~p, StateName :~p, StatData :~p~n",[_Event, State, StateData]),
    {next_state,State,StateData, timeout(StateData#state.timeout)}.
 
handle_sync_event(get_state, _From, StateName, StateData) ->
    {reply, {StateName, StateData, timeout(StateData#state.timeout)}, StateName, StateData, timeout(StateData#state.timeout)};
handle_sync_event(_Event, _From, StateName, StateData) ->
    {reply, ok, StateName, StateData, timeout(StateData#state.timeout)}.
 
handle_info(_Info, StateName, StateData) ->
    {next_state, StateName, StateData, timeout(StateData#state.timeout)}.
 
%%-----------------------------------------------------------
%% 系统关闭
%%-----------------------------------------------------------
terminate(_Reason, _StateName, _StatData) ->
	%%io:format("fsm over Reason : ~p, StateName :~p, StatData :~p~n",[_Reason, _StateName, _StatData]),
%% 	io:format("fsm over Reason : ~p",[_Reason]),
	gen_server:cast(_StatData#state.user_pid,{practice_time, fsm_stop}),
    ok.
 
%%-----------------------------------------------------------
%% 热代码切换
%%-----------------------------------------------------------
code_change(_OldVsn, StateName, StateData, _Extra) ->
    {ok, StateName, StateData}.
 
%%----------------------------------------------------------
%% 私有函数
%%----------------------------------------------------------
%% @spec timeout
%% 重新计算timeout值
unixtime() ->
    {M, S, _} = erlang:now(),
    M * 1000000 + S.
%%util:unixtime()
timeout(SwitchTime) ->
    %%case SwitchTime - unixtime() of
	case SwitchTime - util:unixtime() of
        Timeout when Timeout >= 0 ->
            Timeout * 1000;
        _ ->
            0
    end.