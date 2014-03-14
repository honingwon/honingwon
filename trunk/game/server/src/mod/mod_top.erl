%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2012-12-6
%%% -------------------------------------------------------------------
-module(mod_top).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start_link/0,get_mod_top_pid/0,stop/0,get_top_list/2,update_top_info/5]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {fight = 1,
				level = 1,
				veins = 1,
				gengu = 1,
				copper = 1,
				achieve = 1,
				server_open_days = 0}).

-define(UPDATE_TOP_ETS_LIST, 50000). %定时更新修改过的排行到ets表中
-define(SAVE_DUPLICATE_TOP_TIKE, 3600000). %定时更新副本排行榜到数据库
-define(RESET_CHALLENGE_TOP_TIKE, 86400).	%重置试炼排行榜s
-define(LOOP_TIKE_TIME, 501).				%
-define(SEVEN_DAYS_TOP_TIKE, 180000).		%三分钟统计一次排行

-define(TOP_TIME, 1).		%% 试炼排行榜重置时间（0:00）
-define(TOP_TIME_1, 5400). 	%% 排行榜统计时间1 (1:30)
-define(TOP_TIME_2, 43200). %% 排行榜统计时间2（13：30）

%% ====================================================================
%% External functions
%% ====================================================================
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
	gen_server:call(?MODULE, stop).

%%动态加载处理进程 
get_mod_top_pid() ->
	ProcessName = mod_top_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_top(ProcessName)
			end;
		_ ->
			start_mod_top(ProcessName)
	end.

%%启动监控模块
start_mod_top(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_top()
				end;
			_ ->
				start_top()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.
				  
%%开启监控模块
start_top() ->
	case supervisor:start_child(
		   server_sup,
		   {mod_top,
			{mod_top, start_link, []},
			 permanent, 10000, worker, [mod_top]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_top error:~p~n", [R]),
			undefined
	end.

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
			{stop, "top process is error."}
	end.

do_init([]) ->
	process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_top_process,		
 	misc:register(global, ProcessName, self()),	
	
	ok = lib_top:init_top_config(),	
	ok = lib_top:init_ets_duplicate_top(),
	ok = lib_top:first_statistic_top(),
	ok = lib_top:init_line_off_top(),
	
	misc:write_monitor_pid(self(),?MODULE, {}),	
	%%erlang:send_after(200, self(), {update_top_list}),
	ResetTime = misc_timer:get_diff_seconds(?RESET_CHALLENGE_TOP_TIKE) * 1000, 
	erlang:send_after(ResetTime, self(), {reset_challenge_top}),
	erlang:send_after(?SAVE_DUPLICATE_TOP_TIKE, self(), {update_duplicate_top}),
	OpenDays = util:get_diff_days(config:get_service_start_time(), misc_timer:now_seconds()),
	%%erlang:send_after(0, self(), {seven_days_top}), %%七神器调整
    {ok, #state{server_open_days = OpenDays}}.

%% 用户调用方法
get_top_list(TopType, Page) ->
	Pid = get_mod_top_pid(),
	gen_server:call(Pid, {'get_top_list', TopType, Page}).

update_top_info(_PlayerPid, _TopDefine, _Career, _Sex, _TopInfo) ->
	ok.
%% 	Pid = get_mod_top_pid(),
%% 	gen_server:cast(Pid, {'update_top_info', PlayerPid, TopDefine, Career, Sex, TopInfo}).

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
			?WARNING_MSG("mod_top handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_top handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_top handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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

%%---------------------do_call--------------------------------
do_call({'get_top_list', TopType, Page}, _From, State) ->
	TopList = lib_top:get_top_list(TopType, Page),
	{reply, TopList, State};

%% 停止
do_call(stop,_Form, State) ->
	{stop, normal, State};

do_call(Info,_From, State) ->
	?WARNING_MSG("mod_top call is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_cast--------------------------------

%%更新副本排行榜排名
do_cast({update_duplicate_top, UesInfo}, State) ->
	
	lib_top:update_duplicate_top(UesInfo),
	{noreply, State};

do_cast({'update_top_info',PlayerPid, TopDefine, Career, Sex, TopInfo}, State) ->
	case lib_top:update_top_info(TopDefine, Career, Sex, TopInfo) of
		update_top ->
			gen_server:cast(PlayerPid, {'update_top_user'}),
			case TopInfo#top_info.top_type of
				?TOP_TYPE_FIGHT ->
					NewState = State#state{fight = 1};
				?TOP_TYPE_LEVEL ->
					NewState = State#state{level = 1};
				?TOP_TYPE_VEINS ->
					NewState = State#state{veins = 1};
				?TOP_TYPE_GENGU ->
					NewState = State#state{gengu = 1};
				?TOP_TYPE_COPPER ->
					NewState = State#state{copper = 1};
				?TOP_TYPE_ACHIEVE ->
					NewState = State#state{achieve = 1};
				_ ->			
					NewState = State
			end;
		_ ->
%% 			?DEBUG("update top error:~p",[1]),
			NewState = State
	end,
	{noreply, NewState};

%%更新副本排行帮

do_cast(Info, State) ->
	?WARNING_MSG("mod_top cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------	
%% do_info({loop, LoopTime}, Status)->
%% 	Now = misc_timer:now_seconds(),
%% 	if 		
%% 		Now - LoopTime > 1 ->
%% 			?WARNING_MSG("top loop time error:~p",[{Now, Now - LoopTime}]),
%% 			erlang:send_after(0, self(), {loop, Now}),
%% 		true ->
%% 			erlang:send_after(?LOOP_TIKE_TIME, self(), {loop, Now}),
%% 			Time = misc_timer:get_time(Now),
%% 			if
%% 				Time rem 180 =:= 0 ->	%% 保存副本排行到数据库
%% 					MS = ets:fun2ms(fun(T) -> T end),
%% 					TopList = ets:select(?ETS_DUPLICATE_TOP, MS),
%% 					lists:foreach(fun(Record) -> lib_top:save_duplicate_top(Record) end, TopList);
%% 				true ->	
%% 					ok
%% 			end,
%% 			case Time of
%% 				TOP_TIME ->	%% 试炼排行榜重置时间（0:00）
%% 					lib_top:send_challenge_first_award();
%% 				TOP_TIME_1 -> %% 排行榜统计时间1 (1:30)
%% 					lib_top:statistic_top();
%% 				TOP_TIME_2 -> %% 排行榜统计时间2 (13:30)
%% 					lib_top:statistic_top();
%% 				_ ->
%% 					ok
%% 			end
%% 	end,
%% 	{noreply, Status};	

do_info({update_duplicate_top}, Status) ->
	erlang:send_after(?SAVE_DUPLICATE_TOP_TIKE, self(), {update_duplicate_top}),
	MS = ets:fun2ms(fun(T) -> T end),
	TopList = ets:select(?ETS_DUPLICATE_TOP, MS),
	lists:foreach(fun(Record) -> lib_top:save_duplicate_top(Record) end, TopList),
	{noreply, Status};

%%重置挑战排行榜
do_info({reset_challenge_top}, Status) ->
	erlang:send_after(?RESET_CHALLENGE_TOP_TIKE * 1000, self(), {reset_challenge_top}),
	OpenDays = util:get_diff_days(config:get_service_start_time(), misc_timer:now_seconds()),
	NewStatus = Status#state{server_open_days = OpenDays},
	lib_top:send_challenge_first_award(),	
	{noreply, NewStatus};


%%定时计数排行并更新到服务端
do_info({statistic_top}, Status) ->	
	lib_top:statistic_top(),%%重新排名非即时排行榜
	{noreply, Status};
%%前七天排行
do_info({seven_days_top}, Status) ->	
	if  Status#state.server_open_days > 7 ->
			{noreply, Status};
		true ->
			erlang:send_after(?SEVEN_DAYS_TOP_TIKE, self(), {seven_days_top}),
			OpenDays = util:get_diff_days(config:get_service_start_time(), misc_timer:now_seconds()),
			lib_top:update_seven_days_top(OpenDays),
			NewStatus = Status#state{server_open_days = OpenDays},
			{noreply, NewStatus}
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_top info is not match:~w",[Info]),
    {noreply, State}.
