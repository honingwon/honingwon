%%% -------------------------------------------------------------------
%%% Author  : liaoxiaobo
%%% Description :
%%%
%%% Created : 2013-4-10
%%% -------------------------------------------------------------------
-module(mod_sysmsg).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

-define(SEND_SYS_MSG_TICK, (1 * 10 * 1000)). 	%% 发公告tick

%% --------------------------------------------------------------------
%% External exports
-export([
		 start_link/1,
		 stop/0,
		 get_mod_sysmsg_pid/0,
		 update_msg/8
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


start_link(ProcessName) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [ProcessName], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_sysmsg_pid() ->
	ProcessName = mod_mysmsg_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_sysmsg(ProcessName)
			end;
		_ ->
			start_mod_sysmsg(ProcessName)
	end.

%%启动监控模块
start_mod_sysmsg(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_sysmsg(ProcessName)
				end;
			_ ->
				start_sysmsg(ProcessName)
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_sysmsg(ProcessName) ->
	case supervisor:start_child(
		   server_sup,
		   {mod_sysmsg,
			{mod_sysmsg, start_link, [ProcessName]},
			 permanent, 10000, worker, [mod_sysmsg]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_sysmsg error:~p~n", [R]),
			undefined
	end.


update_msg(ID,OP,MsgType, SendType, StartTime, EndTime, Interval, Content) ->
	Pid = get_mod_sysmsg_pid(),
	gen_server:cast(Pid, {'update_msg',ID,OP,MsgType, SendType, StartTime, EndTime, Interval, Content}).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([ProcessName]) ->
	process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
 	misc:register(global, ProcessName, self()),	
	ok = lib_sysmsg:init_sys_msg(),
	
	erlang:send_after(?SEND_SYS_MSG_TICK, self(), {send_msg}),
	
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
handle_call(Request, From, State) ->
    Reply = ok,
    {reply, Reply, State}.

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
			?WARNING_MSG("mod_sysmsg handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_sysmsg handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, State) ->
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

do_cast({'update_msg',ID,OP,MsgType, SendType, StartTime, EndTime, Interval, Content}, State) ->
	lib_sysmsg:update_sys_msg(ID,OP,MsgType, SendType, StartTime, EndTime, Interval, Content),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_increase cast is not match:~w",[Info]),
    {noreply, State}.

do_info({send_msg}, State) ->
  	erlang:send_after(?SEND_SYS_MSG_TICK, self(), {send_msg}),
	lib_sysmsg:timer_sys_msg(),
    {noreply, State};



do_info(Info, State) ->
	?WARNING_MSG("mod_sysmsg info is not match:~w",[Info]),
    {noreply, State}.



