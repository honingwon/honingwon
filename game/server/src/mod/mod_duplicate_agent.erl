%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-5-19
%%% -------------------------------------------------------------------
-module(mod_duplicate_agent).

-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-define(Make_A_Match, 60*3).

%% --------------------------------------------------------------------
%% External exports
-export([
		 get_duplicate_pid/0,
		 start_link/0
		]
	   ).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->      
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_duplicate_pid() ->
	ProcessName = mod_duplicate_process,
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_mod_duplicate(ProcessName)
				end;
			_ ->
				start_mod_duplicate(ProcessName)
	end.

start_mod_duplicate(ProcessName) ->
	global:set_lock({ProcessName, undefined}),	
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_duplicate()
				end;
			_ ->
				start_duplicate()
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

start_duplicate() ->
	case supervisor:start_child(server_sup, 
								{mod_duplicate_agent, {mod_duplicate_agent, start_link, []},
								 permanent, 10000, supervisor, [mod_duplicate_agent]}) of
		{ok, Pid} ->
				timer:sleep(1000),
				Pid;
		_ ->
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
    process_flag(trap_exit, true),
	ProcessName = mod_duplicate_process,		
 	misc:register(global, ProcessName, self()),		

    lib_duplicate_agent:init_dic_enroll(),
	
	misc:write_monitor_pid(self(),?MODULE, {}),
	misc:write_system_info(self(), mod_duplicate_agent, {}),	
	
	%% 一定间隔时间进行撮合
	erlang:send_after(?Make_A_Match, self(), {make_a_match}),
	{ok, #state{}}.

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
			?WARNING_MSG("mod_duplicate_agent handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_duplicate_agent handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_duplicate_agent handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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
	misc:delete_system_info(self()),
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


%%====================================================================
%% Local functions
%%====================================================================

%%---------------------do_call--------------------------------
do_call(Info, _, State) ->
	?WARNING_MSG("mod_duplicate_agent call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%%队伍报名
do_cast({'team_enroll', TeamEnroll}, State) ->	
	{noreply, State};

%%个人报名
do_cast({'single_enroll', SingleEnroll}, State) ->
	{noreply, State};



do_cast(Info, State) ->
	?WARNING_MSG("mod_duplicate_agent cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
do_info({make_a_match}, State) ->
	%%撮合
	{noreply, State};


do_info(Info, State) ->
	?WARNING_MSG("mod_duplicate_agent info is not match:~w",[Info]),
    {noreply, State}.






