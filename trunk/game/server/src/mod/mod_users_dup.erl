%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-5-7
%%% -------------------------------------------------------------------
-module(mod_users_dup).
-behaviour(gen_server).

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").

-record(duplicate_status, {
						   user_id, 
						   pid_send,
						   pid_player,
						   last_date,
						   save_date
						  }).

-define(Scan_Time_Tick, (1000)).
-define(SAVE_DUPLICATE_TICK, (5 * 60 * 1000)).

%% --------------------------------------------------------------------
%% External exports
-export([start_link/4]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================
start_link(UserId, Pid_send, Pid_player,Last_online_date) ->
	gen_server:start_link(?MODULE, [UserId, Pid_send, Pid_player,Last_online_date], []).

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
init([UserId, Pid_send, Pid_player,Last_online_date]) ->
	ok = lib_duplicate:init_duplicate_online(UserId),
	State = #duplicate_status {
							   user_id = UserId,
							   pid_send = Pid_send,
							   pid_player = Pid_player,
							   last_date = Last_online_date,
							   save_date = 0
							  },	
	misc:write_monitor_pid(self(),?MODULE, {}),	
	
	erlang:send_after(0, self(), {'scan_time'}),%%应为需要更新用户离线未使用副本次数所以要即时调用
    {ok, State}.

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
			?WARNING_MSG("UserId:~w, mod_users_dup handle_call is exception:~w~n,Info:~w",[State#duplicate_status.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_users_dup is exception:~w~n,Info:~w",[State#duplicate_status.user_id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_users_dup handle_info is exception:~w~n,Info:~w",[State#duplicate_status.user_id, Reason, Info]),
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
do_call({'check_user_duplicate', {Duplicate_id,Day_times}}, _From, State) ->
	case lib_duplicate:check_user_duplicate_times(State#duplicate_status.user_id, Duplicate_id, Day_times) of
		ok ->
			{reply, {ok}, State};
		_ ->
			{reply, {error}, State}
	end;

do_call({'reset_dup_num', DupId}, _From, State) ->
	{Res,DuplicateId,Num} = 
	case lib_duplicate:reset_duplicate_times(State#duplicate_status.user_id, DupId) of
		{ok, DayNum} ->
			{1,DupId,DayNum};		
		{error, ErrNum} ->
			{0,ErrNum,0}
	end,
	{reply,{Res,DuplicateId,Num}, State};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_users_dup call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%% 停止
do_cast({stop, _Reason}, State) ->
	lib_duplicate:duplicate_offline(),
	{stop, normal, State};

do_cast({'copy_enter_count'}, State) ->	
	case lib_duplicate:get_dic() of
		[] ->
			{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, []),
			lib_send:send_to_sid(State#duplicate_status.pid_send, BinDate);
		List ->
			{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, List),
			lib_send:send_to_sid(State#duplicate_status.pid_send, BinDate)
	end,
	{noreply, State};

do_cast({'update_copy_enter_count', List}, State) ->	
	{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, List),
	lib_send:send_to_sid(State#duplicate_status.pid_send, BinDate),
	{noreply, State};

do_cast({'add_duplicate_times', Duplicate_id}, State) ->
	lib_duplicate:add_duplicate_times(State#duplicate_status.user_id, Duplicate_id,1),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_users_dup cast is not match:~w",[Info]),
    {noreply, State}.



%%---------------------do_info--------------------------------
%% 副本扫描
do_info({'scan_time'}, State) ->
	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
	
	Now = misc_timer:now_seconds(),	
	%% 刷新副本, 登陆自动刷新一次
	
	lib_duplicate:refresh_free_duplicate_num(State#duplicate_status.last_date, Now, State#duplicate_status.user_id, State#duplicate_status.pid_player),

	SaveTick = 5 * 60,
	%% 如果时间到，自动保存数据库
	if 
		State#duplicate_status.save_date + SaveTick < Now ->
		   lib_duplicate:save_dic(),
%%		   erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
		   {noreply, State#duplicate_status{last_date=Now, save_date=Now}};
	   true ->
%%		   erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
		   {noreply, State#duplicate_status{last_date=Now}}
	end;	

do_info(Info, State) ->
	?WARNING_MSG("mod_users_dup info is not match:~w",[Info]),
    {noreply, State}.