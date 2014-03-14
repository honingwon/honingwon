%%% -------------------------------------------------------------------
%%% Author  : wangdahai
%%% Description :
%%%
%%% Created : 2013-9-2
%%% -------------------------------------------------------------------
-module(mod_marry_duplicate).

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").
%% --------------------------------------------------------------------
%% External exports
-export([start/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================
start(UserId,Type) ->
	{ok, Dup_pid} = gen_server:start(?MODULE, [UserId,Type], []),
	{ok, Dup_pid}.

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
init([UserId,Type]) ->
	try 
		do_init([UserId,Type])	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create marry_duplicate is error."}
	end.

do_init([UserId,Type]) ->
	?WARNING_MSG("create_marry map:~p",[{self(),UserId}]),
	lib_marry_duplicate:create_marry_duplicate([UserId,Type]).

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
			?WARNING_MSG("mod_marry_duplicate handle_call is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_marry_duplicate handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_marry_duplicate handle_info is exception:~w~n,Info:~w",[Reason, Info]),
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
do_call({enter_marry_duplicate,UserId1,Pid1,NickName1,UserId2,Pid2,NickName2},  _, State) ->
	 NewState = lib_marry_duplicate:enter_marry_duplicate(UserId1,Pid1,NickName1,UserId2,Pid2,NickName2,State),
	 {reply, ok, NewState};

do_call({'login_in_duplicate', {UserId, UserPid, SendPid, _VipLevel, _Sex}},  _, State) ->
	[NewState,Data] = lib_marry_duplicate:login_in_duplicate(UserId, UserPid, SendPid,State),
	{reply, Data, NewState};

do_call({give_gift_enter, UserId, UserPid,NickName, Yuanbao, Money },  _, State) ->
	NewState = lib_marry_duplicate:give_gift_enter(UserId, UserPid, NickName, Yuanbao, Money, State),
	{reply, ok, NewState};

do_call({check_free_candy, UserId},  _, State) ->
	case lib_marry_duplicate:check_free_candy(UserId, State) of
		{ok,Id1,Id2, NewState} ->
			{reply, {ok,Id1,Id2}, NewState};
		Res ->
			{reply, Res, State}
	end;

do_call({check_quit_hall, NickName},  _, State) ->
	Res = lib_marry_duplicate:check_quit_hall(NickName, State),
	{reply, Res, State};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_marry_duplicate call is not match:~w",[Info]),
    {reply, ok, State}.
%%---------------------do_cast--------------------------------
do_cast({get_hall_info, SendPid}, State) ->
	lib_marry_duplicate:get_marry_hall_info(State,SendPid),
	{noreply, State};
%% 发送请帖
do_cast({send_invitation_card, Lists}, State) ->
	lib_marry_duplicate:send_invitation_card(Lists, State),
	{noreply, State};
%% 查看礼单
do_cast({see_gift_list, Pid}, State) ->
	lib_marry_duplicate:see_gift_list(Pid, State),
	{noreply, State};	
%% 开始拜堂
do_cast({start_marry, UserId, Pid}, State) ->
	case lib_marry_duplicate:start_marry(UserId,Pid,State) of
		skip ->
			{noreply, State};
		NewState ->
			erlang:send_after(1000, self(), {marry_words,1}),
			{noreply, NewState}
	end;
%% 发送箱子
do_cast({send_marry_box}, State) -> %%时间到发送箱子
	lib_marry_duplicate:send_marry_box(State),	
	erlang:send_after(120000, self(), {shut_down}),
	{noreply, State};

%%收到采集物品后触发事件 目前不使用
do_cast({collect_buff, _CollectID, _Pid, _UserId}, State) ->	
	{noreply, State};

do_cast({quit_hall, Id}, State) ->
	NewState = lib_marry_duplicate:quit_hall_mod(Id, State),
	{noreply, NewState};

do_cast({'off_line', _ID}, State) ->
	%NewState = lib_marry_duplicate:off_line(ID, State),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_marry_duplicate cast is not match:~w",[Info]),
    {noreply, State}.
%%---------------------do_info--------------------------------

do_info({start_marry},State) ->
	case lib_marry_duplicate:start_marry_timing(State) of
		skip ->
			%?DEBUG("marry_words:~p",[2]),
			{noreply, State};
		NewState ->
			%?DEBUG("marry_words:~p",[1]),
			erlang:send_after(1000, self(), {marry_words,1}),
			{noreply, NewState}
	end;

do_info({marry_words, T},State) -> %结婚说词
	lib_marry_duplicate:marry_words(State, T),
	{noreply, State};

do_info({shut_down}, State) -> %% 发送箱子2分钟后关闭
	case lib_marry_duplicate:shut_down(State) of
		stop ->			
			?WARNING_MSG("shut_down marry map:~p",[{self()}]),
			{stop, normal, State};
		NewState ->
			{noreply, NewState}
	end;

do_info({award_exp}, State) ->%% 在副本中奖励经验
	lib_marry_duplicate:award_exp(State),
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_marry_duplicate info is not match:~w",[Info]),
    {noreply, State}.
