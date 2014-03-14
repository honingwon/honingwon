%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description : 神秘商店
%%%
%%% Created : 2011-6-10
%%% -------------------------------------------------------------------
-module(mod_smshop_agent).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-define(SMSHOP_BUY_DATA, smshop_buy_data).  

%% --------------------------------------------------------------------
%% External exports
-export([
		 start_link/0,
		 get_open_smshop_pid/0,
		 get_smshop_data/0,
		 update_smshop_data/2
		]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->      
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

get_open_smshop_pid() ->
	ProcessName = mod_smshop_process,
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_mod_smshop(ProcessName)
				end;
			_ ->
				start_mod_smshop(ProcessName)
	end.

start_mod_smshop(ProcessName) ->
	global:set_lock({ProcessName, undefined}),	
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_open_smshop()
				end;
			_ ->
				start_open_smshop()
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

start_open_smshop() ->
	case supervisor:start_child(server_sup, 
								{mod_smshop_agent, {mod_smshop_agent, start_link, []},
								 permanent, 10000, supervisor, [mod_smshop_agent]}) of
		{ok, Pid} ->
			timer:sleep(1000),
			Pid;
		_ ->
			undefined
	end.

get_smshop_data() ->
	gen_server:call(get_open_smshop_pid(), {'get_smshop_data'}).

update_smshop_data(NickName,TemplateId) ->
	gen_server:cast(get_open_smshop_pid(), {'update_smshop_data', {NickName, TemplateId}}).



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
	ProcessName = mod_smshop_process,		
 	misc:register(global, ProcessName, self()),		

	%%放进进程字典
	put(?SMSHOP_BUY_DATA, []),
	
	misc:write_monitor_pid(self(),?MODULE, {}),
	misc:write_system_info(self(), mod_smshop_agent, {}),	
	
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
do_call({'get_smshop_data'}, _From, State) ->
	List = get(?SMSHOP_BUY_DATA),
	 {reply, List, State};


do_call(Info, _, State) ->
	?WARNING_MSG("mod_duplicate_agent call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast({'update_smshop_data', Data}, State) ->
	%%广播世界
	{ok, BinData} = pt_14:write(?PP_MYSTERY_SHOP_DATA_TO_WORLD, [Data]),
	lib_send:send_to_all(BinData),
	
	List = get(?SMSHOP_BUY_DATA),
	if
		erlang:length(List) < 20 ->
			NewList = [Data|List],
			put(?SMSHOP_BUY_DATA, NewList);
		true ->
			List1 = [Data|List],
			{List2, _List3} = lists:split(20, List1),
			put(?SMSHOP_BUY_DATA, List2)
	end,
	{noreply, State};


do_cast(Info, State) ->
	?WARNING_MSG("mod_duplicate_agent cast is not match:~w",[Info]),
    {noreply, State}.


%%---------------------do_info--------------------------------
do_info(Info, State) ->
	?WARNING_MSG("mod_duplicate_agent info is not match:~w",[Info]),
    {noreply, State}.

