%%%-----------------------------------
%%% @Module  : tcp_listener
%%% @Author  : txj
%%% @Created : 2011.02.22 
%%% @Description: tcp listerner监听
%%%-----------------------------------
-module(tcp_listener).
-behaviour(gen_server).
-export([start_link/2]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2, code_change/3]).
-include("common.hrl").

start_link(AcceptorCount, Port) ->
    gen_server:start_link(?MODULE, {AcceptorCount, Port}, []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init({AcceptorCount, Port}) ->
    process_flag(trap_exit, true),
	misc:write_monitor_pid(self(),?MODULE, {}),
    case gen_tcp:listen(Port, ?TCP_OPTIONS) of
        {ok, LSock} ->
            lists:foreach(fun (_) ->
                          	{ok, _APid} = supervisor:start_child(
                                            tcp_acceptor_sup, [LSock])
                          end,
                          lists:duplicate(AcceptorCount, dummy)),
            {ok, LSock};
        {error, Reason} ->
            {stop, {cannot_listen, Reason}}
    end.

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
handle_call(_Request, _From, State) ->
    {reply, State, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, State) ->
    gen_tcp:close(State),
	misc:delete_monitor_pid(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
