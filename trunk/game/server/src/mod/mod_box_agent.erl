%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-6-10
%%% -------------------------------------------------------------------
-module(mod_box_agent).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-define(OPEN_BOX_DATA, open_box_data).  

%% --------------------------------------------------------------------
%% External exports
-export([
		 start_link/0,
		 get_open_box_pid/0
		]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->      
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_open_box_pid() ->
	ProcessName = mod_box_process,
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_mod_box(ProcessName)
				end;
			_ ->
				start_mod_box(ProcessName)
	end.

start_mod_box(ProcessName) ->
	global:set_lock({ProcessName, undefined}),	
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_open_box()
				end;
			_ ->
				start_open_box()
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

start_open_box() ->
	case supervisor:start_child(server_sup, 
								{mod_box_agent, {mod_box_agent, start_link, []},
								 permanent, 10000, supervisor, [mod_box_agent]}) of
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
	ProcessName = mod_box_process,		
 	misc:register(global, ProcessName, self()),		

	%%放进进程字典
	put(?OPEN_BOX_DATA, []),
	
	misc:write_monitor_pid(self(),?MODULE, {}),
	misc:write_system_info(self(), mod_box_agent, {}),	
	
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

%%---------------------do_call--------------------------------
do_call({'get_box_data'}, _From, State) ->
	List = get(?OPEN_BOX_DATA),
	 {reply, List, State};


do_call(Info, _, State) ->
	?WARNING_MSG("mod_duplicate_agent call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast({'update_box_data', Data}, State) ->
	%%广播世界
	{ok, BinData} = pt_14:write(?PP_BOX_DATA_TO_WORLD, [Data]),
	lib_send:send_to_all(BinData),
	
	List = get(?OPEN_BOX_DATA),
	if
		erlang:length(List) < 20 ->
			NewList = [Data|List],
			put(?OPEN_BOX_DATA, NewList);
		true ->
			List1 = [Data|List],
			{List2, _List3} = lists:split(20, List1),
			put(?OPEN_BOX_DATA, List2)
	end,
	{noreply, State};


do_cast(Info, State) ->
	?WARNING_MSG("mod_duplicate_agent cast is not match:~w",[Info]),
    {noreply, State}.


%%---------------------do_info--------------------------------
do_info(Info, State) ->
	?WARNING_MSG("mod_duplicate_agent info is not match:~w",[Info]),
    {noreply, State}.

