%%% -------------------------------------------------------------------
%%% Author  : wangyuechun
%%% Description :
%%%
%%% Created : 2013-10-9
%%% -------------------------------------------------------------------
-module(mod_pet_battle).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%% --------------------------------------------------------------------
%% External exports
-export([]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3,get_mod_pet_battle_pid/0,
		start_link/0,stop/0]).

-record(state, {process_pid = 0}).

-define(SAVE_PET_BATTLE_TOP_TIKE, 300000). %定时更新宠物数据到数据库
-define(PET_BATTLE_TOP_AWARD_TIKE, 82800).	%宠物斗坛排行榜奖励发送时间
-define(PET_BATTLE_TOP_AWARD_TIKE1, 86400000).	%宠物斗坛排行榜奖励间隔时间24小时

%% ====================================================================
%% External functions
%% ====================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_pet_battle_pid() ->
	ProcessName = mod_pet_battle_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_pet_battle(ProcessName)
			end;
		_ ->
			start_mod_pet_battle(ProcessName)
	end.

%%启动监控模块
start_mod_pet_battle(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_pet_battle()
				end;
			_ ->
				start_pet_battle()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_pet_battle() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_pet_battle,
			{mod_pet_battle, start_link, []},
			 permanent, 10000, worker, [mod_pet_battle]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_pet_battle error:~p~n", [R]),
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
	try 
		do_init([])	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "pet_battle process is error."}
	end.

do_init([]) ->
	process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_pet_battle_process,
 	misc:register(global, ProcessName, self()),	
	
	State = #state{},
	misc:write_monitor_pid(self(),?MODULE, {}),	
	erlang:send_after(?SAVE_PET_BATTLE_TOP_TIKE, get_mod_pet_battle_pid(), {update_pet_battle_info}),
	lib_pet_battle:init_wild_pet_battle(),
	lib_pet_battle:reset_pet_battle_yesterday_top(),
	ResetTime = misc_timer:get_diff_seconds(?PET_BATTLE_TOP_AWARD_TIKE), 
	erlang:send_after(ResetTime * 1000, get_mod_pet_battle_pid(), {reset_pet_battle_award}),
    {ok,State}.

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
    try
		do_call(Request, From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_pet_battle handle_call is exception:~w~n,Info:~w",[Reason, Request]),
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
handle_cast(Msg, State) ->
    try
		do_cast(Msg, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_pet_battle handle_cast is exception:~w~n,Info:~w",[Reason, Msg]),
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
			?WARNING_MSG("mod_pet_battle handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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

%%============do_call==============

%% 停止
do_call(stop,_Form, State) ->
	{stop, normal, State};

do_call(Call,_From, State) ->
	?WARNING_MSG("mod_pet_battle call is not match:~w",[Call]),
    {noreply, State}.

%%============do_cast==============
do_cast(Cast, State) ->
	?WARNING_MSG("mod_pet_battle cast is not match:~w",[Cast]),
    {noreply, State}.

%%============do_info==============
do_info({update_pet_battle_info}, State) ->
	%?DEBUG("update_pet_battle_info",[]),
	lib_pet_battle:save_pet_battle_data(),
	erlang:send_after(?SAVE_PET_BATTLE_TOP_TIKE, self(), {update_pet_battle_info}),
	{noreply, State};

do_info({reset_pet_battle_award}, State) ->
	%?DEBUG("reset_pet_battle_award",[]),
	%lib_pet_battle:send_pet_battle_champion_award(),
	lib_pet_battle:reset_pet_battle_yesterday_top(),
	erlang:send_after(?PET_BATTLE_TOP_AWARD_TIKE1, self(), {reset_pet_battle_award}),
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_pet_battle info is not match:~w",[Info]),
    {noreply, State}.