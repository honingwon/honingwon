%%% -------------------------------------------------------------------
%%% Author  : liaoxiaobo
%%% Description :
%%%
%%% Created : 2013-8-20
%%% -------------------------------------------------------------------
-module(mod_tokey).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

-include("common.hrl").
-include("record.hrl").

%% --------------------------------------------------------------------
%% External exports
-export([start_link/0,
		 get_mod_tokey_pid/0,
		 stop/0,
		 get_tokey/9
		]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).



%% ====================================================================
%% External functions
%% ====================================================================


%% ====================================================================
%% Server functions
%% ====================================================================


%%====================================================================
%% External functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_tokey_pid() ->
	ProcessName = mod_tokey_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_tokey(ProcessName)
			end;
		_ ->
			start_mod_tokey(ProcessName)
	end.

%%启动监控模块
start_mod_tokey(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_tokey()
				end;
			_ ->
				start_tokey()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_shop() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_tokey,
			{mod_tokey, start_link, []},
			 permanent, 10000, worker, [mod_tokey]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_tokey error:~p~n", [R]),
			undefined
	end.

%%开启监控模块
start_tokey() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_tokey,
			{mod_tokey, start_link, []},
			 permanent, 10000, worker, [mod_tokey]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_tokey error:~p~n", [R]),
			undefined
	end.



get_tokey(PidSend,User_name, ShopItemID, Domain, ShopItemNum, ZoneID, OpenKey, Pf, PfKey) ->
	Pid = get_mod_tokey_pid(),
	gen_server:cast(Pid, {'getokey',PidSend, User_name, ShopItemID, Domain, ShopItemNum, ZoneID, OpenKey, Pf, PfKey}).


%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([]) ->
	
	ssl:start(),
    process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_tokey_process,		
 	misc:register(global, ProcessName, self()),	
	
	
	misc:write_monitor_pid(self(),?MODULE, {}),	
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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_tokey handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_tokey handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_shop handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(OldVsn, State, Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------



 %% 停止
do_call(stop,_Form, State) ->
	ssl:stop(),
	{stop, normal, State};

do_call(Info, _From, State) ->
	?WARNING_MSG("mod_increase call is not match:~w",[Info]),
    {reply, ok, State}.


do_cast({'getokey',PidSend, User_name, ShopItemID, Domain, ShopItemNum, ZoneID, OpenKey, Pf, PfKey}, State) ->
	lib_tokey:get_tokey(PidSend,User_name, ShopItemID, Domain, ShopItemNum, ZoneID, OpenKey, Pf, PfKey),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_increase cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------	
do_info(Info, State) ->
	?WARNING_MSG("mod_increase info is not match:~w",[Info]),
    {noreply, State}.
