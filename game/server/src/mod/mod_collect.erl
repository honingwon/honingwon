%%%-------------------------------------------------------------------
%%% Module  : mod_collect


%%% Author  : Lincoln
%%% Description : 
%%%-------------------------------------------------------------------
-module(mod_collect).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
-record(state, {
				user_id,
				pid_send,
				pid_player
				}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([start_link/3]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link(UserId, PidSend, PidPlayer) ->
    gen_server:start_link(?MODULE, [UserId, PidSend, PidPlayer], []).

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
init([UserId, PidSend, PidPlayer]) ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	State = #state{
					user_id = UserId,
					pid_send = PidSend,
					pid_player = PidPlayer
					},
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
			?WARNING_MSG("UserId:~w, mod_collect handle_call is exception:~w~n,Info:~w",[State#state.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_collect handle_cast is exception:~w~n,Info:~w",[State#state.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_collect handle_info is exception:~w~n,Info:~w",[State#state.user_id, Reason, Info]),
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
do_call(Info, _, State) ->
	?WARNING_MSG("mod_collect call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%% 采集物品
do_cast({'collect', MapId, CollectId}, State) ->
	%% 需要加时间验证
	lib_collect:collect(MapId, CollectId, State#state.pid_player),
	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_collect cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
do_info(Info, State) ->
	?WARNING_MSG("mod_collect info is not match:~w",[Info]),
    {noreply, State}.
