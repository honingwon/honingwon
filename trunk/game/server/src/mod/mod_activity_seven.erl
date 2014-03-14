%% Author: liaoxiaobo
%% Created: 2013-8-1
%% Description: TODO: Add description to mod_activity_seven 七天嘉年华
-module(mod_activity_seven).

-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
-record(state, { }).

%%--------------------------------------------------------------------
%% External exports
-export([start_link/0,
		 get_mod_activity_seven_pid/0,
		 stop/0	,
		 get_info/0,
		 get_reward/2,
		 update_top_list/1
	
		]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

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
get_mod_activity_seven_pid() ->
	ProcessName = mod_activity_seven_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_activity_seven(ProcessName)
			end;
		_ ->
			start_mod_activity_seven(ProcessName)
	end.

%%启动监控模块
start_mod_activity_seven(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_activity_seven()
				end;
			_ ->
				start_activity_seven()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_activity_seven() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_activity_seven,
			{mod_activity_seven, start_link, []},
			 permanent, 10000, worker, [mod_activity_seven]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_activity_seven error:~p~n", [R]),
			undefined
	end.

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
init([]) ->
	process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_activity_seven_process,		
 	misc:register(global, ProcessName, self()),	
	
	ok = lib_activity_seven:init_template(),
	ok = lib_activity_seven:init_data(),
	misc:write_monitor_pid(self(),?MODULE, {}),	
    {ok, #state{}}.


get_info() ->
	Pid = get_mod_activity_seven_pid(),
	gen_server:call(Pid, {'get_info'}).

get_reward(PlayerStatus,ID) ->
	Pid = get_mod_activity_seven_pid(),
	gen_server:call(Pid, {'get_reward',PlayerStatus,ID}).

%% get_day_reward(PlayerStatus,ID,PetFight,MaxVeinsLeve) ->
%% 	Pid = get_mod_activity_seven_pid(),
%% 	gen_server:call(Pid, {'get_day_reward',PlayerStatus,ID,PetFight,MaxVeinsLeve}).

update_top_list(List) ->
	Pid = get_mod_activity_seven_pid(),
	gen_server:cast(Pid, {'update_data',List}).


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
			?WARNING_MSG("mod_activity_seven handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_activity_seven handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_activity_seven handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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


do_call({'get_info'}, _From, State) ->
	List = lib_activity_seven:get_all(),
	{reply, List, State};


do_call({'get_reward', PlayerStatus,Id}, _From, State) ->
%% 	Re = lib_activity_seven:get_reward(PlayerStatus,Id),
%% 	{reply, Re, State};
	{reply, ok, State};


%% do_call({'get_day_reward', PlayerStatus,Id,PetFight,MaxVeinsLeve}, _From, State) ->
%% 	Re = lib_activity_seven:get_day_reward(PlayerStatus,Id,PetFight,MaxVeinsLeve),
%% 	{reply, Re, State};


%% 停止
do_call(stop,_Form, State) ->
	{stop, normal, State};

do_call(Info, _From, State) ->
	?WARNING_MSG("mod_activity_seven call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------

do_cast({'update_data', TopList},  State) ->
	lib_activity_seven:update(TopList),
	{noreply,  State};




do_cast(Info, State) ->
	?WARNING_MSG("mod_activity_seven cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------	
do_info(Info, State) ->
	?WARNING_MSG("mod_activity_seven info is not match:~w",[Info]),
    {noreply, State}.

%%====================================================================
%% Private functions
%%====================================================================

