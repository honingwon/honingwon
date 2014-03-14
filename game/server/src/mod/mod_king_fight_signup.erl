-module(mod_king_fight_signup).

-behaviour(gen_server).

-include("common.hrl").

-export([start_link/0, stop/0, get_king_fight_pid/0, king_fight_sign_up/3, get_signup_info/2, close_signup/0, open_signup/0, get_signup_state/1]).

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3,test/0]).

-define(KING_FIGHT_START, 18*3600). %%报名开始时间 43200
-define(KING_FIGHT_END, 16*3600). %%报名结束时间
-define(KING_FIGHT_REMOVE, 17*3600). %%王城踢人时间
-define(KING_FIGHT_TIKE,24*3600*1000).%%王城竞拍间隔

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() -> 
	gen_server:call(?MODULE, stop).

get_king_fight_pid() ->
	ProcessName = mod_king_fight_process,
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					start_mod_king_fight_signup(ProcessName) 
			end;
		_ ->
			start_mod_king_fight_signup(ProcessName)
	end.

start_mod_king_fight_signup(ProcessName) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						Pid;
					false ->
						start_king_fight_signup()
				end;
			_ ->
				start_king_fight_signup()
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

start_king_fight_signup() ->
	case supervisor:start_child(server_sup, {mod_king_fight_signup,{mod_king_fight_signup, start_link, []},
									permanent, 10000, worker, [mod_king_fight_signup]}) of
		{ok, Pid} ->
			Pid;
		{error, R} ->
			?WARNING_MSG("start mod_king_fight_signup error:~p~n", [R]),
			undefined
	end.

init([]) ->
	process_flag(trap_exit, true),	
	%% 多节点的情况下， 仅启用一个进程
	ProcessName = mod_king_fight_process,		
 	misc:register(global, ProcessName, self()),	
	
	misc:write_monitor_pid(self(),?MODULE, {}),
	State = lib_king_fight_signup:init_king_fight(),
	NowTime = misc_timer:now_seconds(),
	{{_, _, _}, {H, M, S}} = util:seconds_to_localtime(NowTime), 	
	Now = H*3600+M*60+S,
	if Now < ?KING_FIGHT_END orelse Now > ?KING_FIGHT_START ->
			open_signup(),
			ResetTime = misc_timer:get_diff_seconds(?KING_FIGHT_END),
			erlang:send_after(ResetTime * 1000, get_king_fight_pid(), {close_signup});
		true ->			
			ResetTime = misc_timer:get_diff_seconds(?KING_FIGHT_START),
			erlang:send_after(ResetTime * 1000, get_king_fight_pid(), {open_signup})
	end,
	{ok, State}.

handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_fight_signup handle_call is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_fight_signup handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

handle_info(Info, State) ->
    try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_king_fight_signup handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% 公会报名
king_fight_sign_up(GuildId, UserId,SendPid) ->
	Pid = get_king_fight_pid(),
	GuildInfo =
	case mod_guild:get_guild_info(GuildId) of
		{false, _} ->
			[];
		{ok, Info} ->
			Info
	end,
	gen_server:call(Pid, {sign_up, GuildId, GuildInfo#ets_guilds.guild_name,GuildInfo#ets_guilds.money, UserId,SendPid}).

%% 获取公会报名信息
get_signup_info(GuildId, SendPid) ->
	Pid = get_king_fight_pid(),
	gen_server:cast(Pid, {get_signup_info, GuildId, SendPid}).

%% 关闭公会报名
close_signup() ->
	erlang:send_after(10, get_king_fight_pid(), {close_signup}).

%% 开启公会报名
open_signup() ->
	erlang:send_after(10, get_king_fight_pid(), {open_signup}).

%% 获取报名状态
get_signup_state(SendPid) ->
	Pid = get_king_fight_pid(),
	gen_server:cast(Pid, {get_signup_state, SendPid}).

test() ->
		MapPid = mod_map:get_scene_pid(1033),
		gen_server:cast(MapPid, {remove_player}).

%% ------------------------------------------ do call ----------------------------------
%% 公会报名 1表示成功， 0表示失败
do_call({sign_up, GuildId,GuildName, GuildMoney, UserId,SendPid}, _From, State) ->
	case lib_king_fight_signup:king_fight_sign_up(GuildId,GuildName, GuildMoney, UserId, State) of 
		{ok, NewState, My_guild_money} ->
			%% 更新本帮会报名财富信息
			{ok, Bin} = pt_23:write(?PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, [NewState#r_king_fight_signup.guild_nick_name,
													NewState#r_king_fight_signup.guild_money, My_guild_money, State#r_king_fight_signup.guild_list]),
			lib_send:send_to_guild_user(GuildId, Bin),
			%% 向全服发送报名第一信息
			{ok, Bin1} = pt_23:write(?PP_ACTIVE_KING_FIGHT_SIGNUP, [NewState#r_king_fight_signup.guild_nick_name,
										My_guild_money]),
			lib_send:send_to_all(Bin1),
			{reply, 1, NewState};
		{error, Res} ->
			lib_chat:chat_sysmsg_pid([SendPid,?FLOAT,?None,?ORANGE,Res]),
			{reply, 0, State}
	end;
 
do_call(Info, _From, State) ->
	?WARNING_MSG("mod_king_fight_signup call is not match:~w",[Info]),
    {reply, ok, State}.
	
%%---------------------do_cast--------------------------------
%% 获取公会报名信息
do_cast({get_signup_info, GuildId, SendPid}, State) ->
	My_guild_money = lib_king_fight_signup:get_my_guild_money(GuildId, State),
	{ok, Bin} = pt_23:write(?PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, [State#r_king_fight_signup.guild_nick_name,
													State#r_king_fight_signup.guild_money, My_guild_money, State#r_king_fight_signup.guild_list]),
	lib_send:send_to_sid(SendPid, Bin),
	{noreply, State};

do_cast({get_signup_state, SendPid}, State) ->
	{ok, Bin} = pt_23:write(?PP_ACTIVE_GET_SIGNUP_STATE, [State#r_king_fight_signup.state]),
	lib_send:send_to_sid(SendPid, Bin),
	{noreply, State};


do_cast(Info, State) ->
	?WARNING_MSG("mod_king_fight_signup cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------	

do_info({open_signup}, State) ->
	Info = lib_king_fight:get_king_war_info(),
	NewState = State#r_king_fight_signup{
										state = 1,
										king_guild_id = Info#ets_king_war_info.defence_guild_id,		
										king_stand_days = Info#ets_king_war_info.days,		
										king_guild_name = Info#ets_king_war_info.defence_guild_name},
	{ok, Bin} = pt_23:write(?PP_ACTIVE_GET_SIGNUP_STATE, [NewState#r_king_fight_signup.state]),
	lib_send:send_to_all(Bin),
	ResetTime = misc_timer:get_diff_seconds(?KING_FIGHT_END),
	erlang:send_after(ResetTime * 1000, get_king_fight_pid(), {close_signup}),
	{noreply, NewState};

do_info({close_signup}, State) ->
	NewState = lib_king_fight_signup:close_signup(State),
	{ok, Bin} = pt_23:write(?PP_ACTIVE_GET_SIGNUP_STATE, [0]),
	lib_send:send_to_all(Bin),
	ResetTime = misc_timer:get_diff_seconds(?KING_FIGHT_START),
	erlang:send_after(ResetTime * 1000, get_king_fight_pid(), {open_signup}),
	{noreply, NewState};

do_info(Info, State) ->
	?WARNING_MSG("mod_king_fight_signup info is not match:~w",[Info]),
    {noreply, State}.