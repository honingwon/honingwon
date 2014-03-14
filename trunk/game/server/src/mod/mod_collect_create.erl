%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-4-11
%%% -------------------------------------------------------------------
-module(mod_collect_create).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([
		 start_link/0,
		 create_collect/1
		 ]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {auto_id}).

%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 创建怪物
create_collect([TemplateId, MapId, X, Y, MapPid]) ->
    gen_server:cast(?MODULE, {'create', TemplateId, MapId, X, Y, MapPid}).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	misc:write_monitor_pid(self(), ?MODULE, {}),	
    {ok, #state{auto_id=1}}.

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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("AutoId:~w, mod_collect_create handle_call is exception:~w~n,Info:~w",[State#state.auto_id, Reason, Info]),
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
			?WARNING_MSG("AutoId:~w, mod_collect_create handle_cast is exception:~w~n,Info:~w",[State#state.auto_id, Reason, Info]),
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
			?WARNING_MSG("AutoId:~w, mod_collect_create handle_info is exception:~w~n,Info:~w",[State#state.auto_id, Reason, Info]),
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

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------


%%---------------------do_call--------------------------------


do_call(Info, _, State) ->
	?WARNING_MSG("mod_collect_create call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%% 创建采集
do_cast({'create', TemplateId, MapId, X, Y, MapPid}, State) ->
	case data_agent:collect_get(TemplateId) of
        [] ->
            {noreply, State};
        Template ->
			NewAutoId = State#state.auto_id + 1,
            mod_collect_item:start([NewAutoId, Template, MapId, X, Y, MapPid]),
			{noreply, State#state{auto_id = NewAutoId}}
	end;

%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_collect_create cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
do_info(Info, State) ->
	?WARNING_MSG("mod_collect_create info is not match:~w",[Info]),
    {noreply, State}.
