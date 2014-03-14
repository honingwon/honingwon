%%%-------------------------------------------------------------------
%%% Module  : mod_guild
%%% Author  : lxb
%%% Created : 2012-9-25
%%% Description : 帮派模块
%%%-------------------------------------------------------------------
-module(mod_guild).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
-record(state, {worker_id = 0}).
%%--------------------------------------------------------------------
%% External exports
-export([get_mod_guild_pid/0,
		 start/1,
		 start_link/1,
		 stop/0,
		 get_guild_list/4,
	   	 get_guild_info/1,
	   	 get_guild_info/2,
		 edit_guild_declaretion/4,
		 get_guild_declaretion/3,
		 create_log/2,
		 get_guild_logs/2,
		 get_guild_warehouse_logs/2,
		 add_guild_feats/4,
%% 		 contribution/7,
		 disband_guild/3,
		 leave_guild/1,
		 update_guild_level_setting/4,
		 update_guild_device_level/5,
		 update_guild_summon/5,
		 kick_guild_user/5,
		 demise_chief/5,
		 agree_demise_chief/5,
		 update_guild_member_setting/4,
		 request_join_guild/4,
		 get_guild_users_request/5,
		 agree_guild_users_request/6,
		 disagree_guild_users_request/6,
		 clear_guild_users_request/3,
		 get_guild_info_and_member/3,
 		 edit_guild_user_member_type/5,
		 invite_join_corp/6,
		 agree_guild_users_invite/5,
		 invite_join_guild/5,
		 %agree_guild_users_invite/2,
		 create_corp/1,
		 edit_corps_declaration/4,
		 set_corp_leader/5,
		 kick_corp_user/4,
		 edit_corp_name/5,
		
%% 		 get_item_in_guild_warehouse/6,
		 get_item_list_in_guild_warehouse/4,
		 get_guild_user_info/3,
		 get_guild_user_info/2,
		 get_guild_users_list/1,		 
		 check_mail_send/5,
		 get_mails_total_count/1,
		 send_guild_member_online/6,
%% 		 corp_member_level_change/3,
		 guild_transport/1,
		 get_guild_extend_info/2,
		 get_guild_levelup_info/2,
		 get_guild_users_list_info/2,
		 get_guild_summon_num/2,
		 get_guild_corp_info/2,
%% 		 check_guild_transport/1,
%% 		 check_guild_transport/3,
		 get_guild_info_for_user/1,
		 get_guild_map_info/1,
		 get_guild_level/1,
		 guild_task_award/6,
		 reduce_guild_user_feats/6,
		 get_guild_user_feats_use_timers/3,
		 open_active_summon_monster/1,
		 change_guild_money/3,

 		 get_guild_item_request_all/4,
		 get_guild_item_request/4,
		 request_guild_item/4,
		 invite_guild_item/6,
		 cancel_guild_item_request/4
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
start_link([ProcessName, Worker_id]) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [ProcessName, Worker_id], []).

start([ProcessName, Worker_id]) ->
    gen_server:start(?MODULE, [ProcessName, Worker_id], []).

stop() ->
    gen_server:call(?MODULE, stop).

%%动态加载帮会处理进程 
get_mod_guild_pid() ->
	ProcessName = misc:create_process_name(guild_p, [0]),
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				Pid;
			_ ->
				start_mod_guild(ProcessName)
	end.

%%启动帮会监控模块 (加锁保证全局唯一)
start_mod_guild(ProcessName) ->
	global:set_lock({ProcessName, undefined}),	
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						WorkerId = random:uniform(?GUILD_WORKER_NUMBER),
						ProcessName_1 = misc:create_process_name(guild_p, [WorkerId]),
 						misc:whereis_name({global, ProcessName_1});						
					false -> 
						start_guild(ProcessName)
				end;
			_ ->
				start_guild(ProcessName)
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%启动帮会监控树模块
start_guild(ProcessName) ->
	case supervisor:start_child(
       		server_sup, {mod_guild,
            		{mod_guild, start_link,[[ProcessName, 0]]},
               		permanent, 10000, supervisor, [mod_guild]}) of
		{ok, Pid} ->
				Pid;
		_er ->
			?DEBUG("start_guild:~p",[_er]),
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
init([ProcessName, Worker_id]) ->
	process_flag(trap_exit, true),
	misc:register(global, ProcessName, self()),	%% 多节点的情况下， 仅在一个节点启用帮会处理进程
	if Worker_id =:= 0 ->
			%加载信息
			lib_guild:init_guild(),
			lib_guild:init_guilds_day_update(1),%%每天需要重置的公会数据			
			lib_guild:init_leave_guilds_users(),
			lib_guild:init_guild_users_request(),
			lib_guild:init_guild_warehouse(),
			lib_guild:init_guild_items_request(),
			misc:write_monitor_pid(self(),?MODULE, {?GUILD_WORKER_NUMBER}),
			misc:write_system_info(self(), mod_guild, {}),
			
			NowSeconds = util:get_today_current_second(),
			if NowSeconds > ?GUILD_BATTLE_END_SECONDS ->
				   Interval = (?GUILD_BATTLE_END_DAY - (NowSeconds - ?GUILD_BATTLE_END_SECONDS)) * 1000,
				   erlang:send_after(Interval, self(), {end_guild_battle});
			   true ->
				   Interval = (?GUILD_BATTLE_END_SECONDS - NowSeconds) * 1000,
				   erlang:send_after(Interval, self(), {end_guild_battle})
			end;
			
			%% 启动多个场景服务进程
%% 			lists:foreach(
%% 				fun(WorkerId) ->
%% 					ProcessName_1 = misc:create_process_name(guild_p, [WorkerId]),
%% 					mod_guild:start([ProcessName_1, WorkerId])
%% 				end,
%% 				lists:seq(1, ?GUILD_WORKER_NUMBER));	
	   true -> 
			misc:write_monitor_pid(self(), mod_guild_worker, {Worker_id})
	end,
	State= #state{worker_id = Worker_id},	
    {ok, State}.

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
%% 统一模块+过程调用(call)
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_guild handle_call is exception:~w,Info:~w",[Reason, Info]),
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
%% 统一模块+过程调用(cast)
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_guild handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_guild handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%%--------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%---------------------do_call--------------------------------
%% apply_call 调用
do_call({apply_call, Module, Method, Args}, _From, State) ->
	Reply  = 
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_guild__apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
			 {false,error};
		 DataRet -> 
			 DataRet
	end,
    {reply, Reply, State};

do_call({contribution_money,Type,Num,PlayerStatus},_From,State) ->
	Reply = lib_guild:contribution_money(PlayerStatus,Num,Type),
	{reply, Reply, State};

%% do_call({contribution,UserID,GuildID,UserName,Type,Number,PidSend}, _Form, State) ->
%% 	Reply = lib_guild:contribution(UserID,GuildID,UserName,Number,PidSend,Type),
%% 	{reply, Reply, State};

do_call({club_war_declear,TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend}, _Form, State) ->
	Reply = lib_guild:club_war_declear(TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend),
	{reply, Reply, State};

do_call({club_war_stop,TargetGuildID,PageIndex,PageSize,GuildID,UserID,PidSend}, _Form, State) ->
	Reply = lib_guild:club_war_stop(TargetGuildID,PageIndex,PageSize,GuildID,UserID,PidSend),
	{reply, Reply, State};

%% do_call({get_item_in_guild_warehouse,  ID, ClubID, ItemID, ItemNum, PidSend}, _Form, State) ->
%% 	Reply = lib_guild:get_item_in_guild_warehouse(ID,ClubID,ItemID,ItemNum,PidSend),
%% 	{reply, Reply, State};
%% 
%% do_call({get_item_in_guild_warehouse_refresh,ItemID,ItemTemplateID,ItemNum,GuildID,UserID,NickName,PidSend}, _Form, State) ->
%% 	Reply = lib_guild:get_item_in_guild_warehouse_refresh(ItemID,ItemTemplateID,ItemNum,GuildID,UserID,NickName,PidSend),
%% 	{reply, Reply, State};

do_call({put_item_in_guild_warehouse,GuildID,UserID}, _Form, State) ->
	Reply = lib_guild:put_item_in_guild_warehouse(GuildID, UserID),
	{reply, Reply, State};

do_call({put_item_in_guild_warehouse_refresh,NickName,GuildID, UserID, ItemID,ItemTemplateID,Item, PidSend}, _Form, State) ->
	Reply = lib_guild:put_item_in_guild_warehouse_refresh(NickName,GuildID, UserID, ItemID,ItemTemplateID,Item, PidSend),
	{reply, Reply, State};

%% 创建帮会
do_call({create_guild,GuildName,Declear,CreateType,PidSend,Pid,OldGuildID,NickName,Career,Sex,UserLevel,VipId,UserID}, _Form, State) ->
	Reply = lib_guild:create_guild(GuildName,Declear, CreateType, PidSend, Pid, OldGuildID, NickName, Career,Sex, UserLevel,VipId, UserID),
	{reply, Reply, State};

%% 停止
do_call(stop,_Form, State) ->
	{stop, normal, State};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_guild call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------
do_cast({apply_cast, Module, Method, Args}, State) ->
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_guild__apply_cast error: Module=~p, Method=~p, Reason=~p",[Module, Method, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State};

do_cast({member_level_up, UserID, UserLevel}, State) ->
	lib_guild:member_level_up(UserID, UserLevel),
	{noreply, State};

do_cast({get_guild_info_for_user, UserID, UserPid}, State) ->
	case lib_guild:get_guild_info_for_user(UserID) of
		{GuildID,GuildName,GuildJob,GuildMapPid,GuildMapID,EnemyList,GuildLevel,FurnaceLevel,CurrentFeats,TotalFeats} -> 
			gen_server:cast(UserPid,{get_guild_info_for_user_return, GuildID, GuildName, GuildJob, GuildMapPid, GuildMapID, EnemyList, GuildLevel,FurnaceLevel, CurrentFeats,TotalFeats});
		_ ->
			ok
	end,
	{noreply, State};

%% 帮会战

do_cast({club_war_declear_init,PageIndex,PageSize,GuildID,UserID,PidSend}, State) ->
	lib_guild:club_war_declear_init(PageIndex,PageSize,GuildID,UserID,PidSend),
	{noreply, State};

do_cast({club_war_deal_init,PageIndex,PageSize,GuildID,UserID,PidSend}, State) ->
	lib_guild:club_war_deal_init(PageIndex,PageSize,GuildID,UserID,PidSend),
	{noreply, State};

do_cast({club_war_enemy_init,PageIndex,PageSize,GuildID,UserID,PidSend}, State) ->
	lib_guild:club_war_enemy_init(PageIndex,PageSize,GuildID,UserID,PidSend),
	{noreply, State};

do_cast({club_war_declear,TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend}, State) ->
	lib_guild:club_war_declear(TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend),
	{noreply, State};

do_cast({club_war_deal,TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend}, State) ->
	lib_guild:club_war_deal(TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend),
	{noreply, State};

do_cast({club_war_stop,TargetGuildID,PageIndex,PageSize,GuildID,UserID,PidSend,PidItem}, State) ->
	lib_guild:club_war_stop(TargetGuildID,PageIndex,PageSize,GuildID,UserID,PidSend,PidItem),
	{noreply, State};

do_cast({club_weal_update, UserID,GuildID,Level,PidSend}, State) ->
	lib_guild:club_weal_update(UserID,GuildID, Level, PidSend),
	{noreply, State};

do_cast({club_getweal,UserID,GuildID,Level,PidSend,Pid}, State) ->
	lib_guild:get_club_weal(UserID,GuildID,Level,PidSend,Pid),
	{noreply, State};


do_cast(Info, State) ->
	?WARNING_MSG("mod_guild cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------

do_info({end_guild_battle}, State) ->
	Interval = ?GUILD_BATTLE_END_DAY * 1000,
	erlang:send_after(Interval, self(), {start_guild_battle}),
	lib_guild:send_stop_war_to_all(),
	{noreply, State};

do_info({guilds_day_update}, State) ->
	lib_guild:init_guilds_day_update(0),
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_guild info is not match:~w",[Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.



%% create_guild(PlayerStatus, Name, Declear) ->
%% 	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, create_guild, [PlayerStatus, Name, Declear]}).

get_guild_list(Name,PageIndex,PageSize,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_list, [Name,PageIndex,PageSize,PidSend]}).


get_guild_user_info(GuildID, UserID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_user_info, [GuildID, UserID,PidSend]}).


get_guild_info(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_info, [GuildID,PidSend]}).

edit_guild_declaretion(GuildID, UserID,Declaration,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, edit_guild_declaretion, [GuildID, UserID,Declaration,PidSend]}).

get_guild_declaretion(GuildID, UserID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_declaretion, [GuildID, UserID,PidSend]}).

create_log(PlayerStatus,Msg) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, create_log, [PlayerStatus,Msg]}).

get_guild_logs(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_logs, [GuildID,PidSend]}).

%% contribution(Type, UserID,GuildID,NickName,Num,PidSend, PidItem) ->
%% 	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, contribution, [UserID,GuildID,NickName,
%% 																					   Num,PidSend, PidItem, Type]}).

disband_guild(GuildID,UserID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, disband_guild, [GuildID,UserID,PidSend]}).

leave_guild(PlayerStatus) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, leave_guild, [PlayerStatus]}).

update_guild_level_setting(UserID,Pid,PidSend,GuildID) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, update_guild_level_setting, [UserID,Pid,PidSend,GuildID]}).

update_guild_device_level(UserID,Pid,PidSend,GuildID,Type) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, update_guild_device_level, [UserID,Pid,PidSend,GuildID,Type]}).

update_guild_summon(UserId,Pid,PidSend,GuildID,SummonTemp) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, update_guild_summon, [UserId,Pid,PidSend,GuildID,SummonTemp]}).

kick_guild_user(UserID,ControlUserNick,TargetUserID,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, kick_guild_user, [UserID,ControlUserNick,TargetUserID,GuildID,PidSend]}).

demise_chief(GuildID,UserID,NickName,TargetUserID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, demise_chief, [GuildID,UserID,NickName,TargetUserID,PidSend]}).

agree_demise_chief(LeaderID,TargetID,TargetNick,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, agree_demise_chief, [LeaderID,TargetID,TargetNick,GuildID,PidSend]}).

update_guild_member_setting(UserID,EType,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, update_guild_member_setting, [UserID,EType,GuildID,PidSend]}).

request_join_guild(UserID,UserLevel,JoinGuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, request_join_guild, [UserID,UserLevel,JoinGuildID,PidSend]}).

get_guild_users_request(GuildID,UserID,PageIndex,PageSize,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_users_request, [GuildID,UserID,PageIndex,PageSize,PidSend]}).

agree_guild_users_request(LeaderID,UserID,PidSend,GuildID,PageIndex,PageSize) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, agree_guild_users_request, [LeaderID,UserID,PidSend,GuildID,PageIndex,PageSize]}).

disagree_guild_users_request(GuildID,LeaderID,UserID,PidSend,PageIndex,PageSize) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, disagree_guild_users_request, [GuildID,LeaderID,UserID,PidSend,PageIndex,PageSize]}).

clear_guild_users_request(GuildID, UserID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, clear_guild_users_request, [GuildID, UserID, PidSend]}).

get_guild_info_and_member(GuildID,UserID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_info_and_member, [GuildID,UserID,PidSend]}).

edit_guild_user_member_type(LeaderID,UserID,Duty,GuildID,PidSend) ->
 	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, edit_guild_user_member_type, [LeaderID,UserID,Duty,GuildID,PidSend]}).


get_guild_extend_info(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_extend_info,[GuildID,PidSend]}).

get_guild_levelup_info(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_levelup_info,[GuildID,PidSend]}).

get_guild_users_list_info(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_users_list_info,[GuildID,PidSend]}).

get_guild_summon_num(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_summon_num,[GuildID,PidSend]}).

get_guild_corp_info(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_guild_corp_info,[GuildID,PidSend]}).

invite_join_corp(GuildID,UserID,NickName,InviteNickName,CorpID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, invite_join_corp, [GuildID,UserID,NickName,InviteNickName,CorpID,PidSend]}).

agree_guild_users_invite(UserID,GuildID,UserGuildID,PidSend,NickName) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, agree_guild_users_invite, [UserID,GuildID,UserGuildID,PidSend,NickName]}).

invite_join_guild(GuildID,UserID,UserNick,InviteNickName,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, invite_join_guild, [GuildID,UserID,UserNick,InviteNickName,PidSend]}).

create_corp(PlayerStatus) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, create_corp, [PlayerStatus]}).

edit_corps_declaration(UserID,Enounce,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, edit_corps_declaration, [UserID,Enounce,GuildID,PidSend]}).

set_corp_leader(UserID,LeaderID,CorpID,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, set_corp_leader, [UserID,LeaderID,CorpID,GuildID,PidSend]}).

kick_corp_user(LeaderID,UserID,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, kick_corp_user, [LeaderID,UserID,GuildID,PidSend]}).

edit_corp_name(LeaderID,CorpName,NewName,GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, edit_corp_name, [LeaderID,CorpName,NewName,GuildID,PidSend]}).



%% get_item_in_guild_warehouse(NickName,UserID,GuildID,ItemID,UserPidItem,UserPidSend) ->
%% 	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_item_in_guild_warehouse, 
%% 										 [NickName,UserID,GuildID,ItemID,UserPidItem,UserPidSend]}).

get_item_list_in_guild_warehouse(GuildID,UserID,PageIndex,PidSend) ->
	gen_server:cast(get_mod_guild_pid(),{apply_cast, lib_guild, get_item_list_in_guild_warehouse,
										 [GuildID,UserID,PageIndex,PidSend]}).

get_guild_warehouse_logs(GuildID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild,  get_guild_warehouse_logs,
										  [GuildID,PidSend]}).

add_guild_feats(PlayerStatus,UserFeats,GuildMoney,ContributionType) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, add_guild_feats,
											[PlayerStatus,UserFeats,GuildMoney,ContributionType]}).

send_guild_member_online(UserID,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, send_guild_member_online,
										  [UserID,Fight,LastOnlineTime,Online,Pid,PidSend]}).

get_guild_users_list(GuildID) ->
	gen_server:call(get_mod_guild_pid(),{apply_call, lib_guild, get_guild_users_list,
										 [GuildID]}).

get_mails_total_count(UserID) ->
	gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild,  get_mails_total_count,
										  [UserID]}).

check_mail_send(UserID,PidSend,NickName,Title,Context) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild,  check_mail_send,
										  [UserID,PidSend,NickName,Title,Context]}).

get_guild_info(GuildID) ->
	gen_server:call(get_mod_guild_pid(),{apply_call, lib_guild, get_guild_info, [GuildID]}).

guild_transport(UserID) ->
	gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, guild_transport,
										  [UserID]}).

%% check_guild_transport(GuildID) ->
%% 	%% todo改为cast
%% 	gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, check_guild_transport,
%% 										  [GuildID]}).

%% check_guild_transport(GuildID, PlayerPid, {Mod, Fun}) ->
%% 	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, check_guild_transport_cast,
%% 										  [GuildID, PlayerPid, {Mod, Fun}]}).

%登录时第一次加载数据的call
get_guild_info_for_user(UserID) ->
	gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, get_guild_info_for_user,
										  [UserID]}).

%% 获取帮派信息
get_guild_map_info(GuildId) ->
	case gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, get_guild_map_info,
										  [GuildId]}) of
		{ok, MapPid, MapOnlyId} ->
			{ok, MapPid, MapOnlyId};
		_ ->
			{error}
	end.

get_guild_user_info(GuildID, UserID) ->
	gen_server:call(get_mod_guild_pid(),{apply_call, lib_guild, get_guild_user_info, [GuildID, UserID]}).

%% 更改公会财富
change_guild_money(GuildID, Money, Type) ->
	gen_server:call(get_mod_guild_pid(),{apply_call, lib_guild, change_guild_money, [GuildID, Money, Type]}).

%% 扣除个人功勋
reduce_guild_user_feats(GuildId, UserId, NeedLevel, Feats,Type,Times) ->
	case gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, reduce_guild_user_feats,
											   [GuildId, NeedLevel, UserId, Feats,Type,Times]}) of
		{true, LeftFeats,Timers} ->
			{true, LeftFeats,Timers};
		{false,Msg} ->
			{false,Msg};
		_ ->
			{false}		
	end.

get_guild_user_feats_use_timers(GuildId, UserId, Type) ->
	case gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, get_guild_user_feats_use_timers,
											   [GuildId, UserId, Type]}) of
		{true, Timers} ->
			{true, Timers};
		{false,Msg} ->
			{false,Msg}
	end.

%% 获取帮派级别信息
get_guild_level(GuildId) ->
	gen_server:call(get_mod_guild_pid(), {apply_call, lib_guild, get_guild_level,
										  [GuildId]}).

%%帮会突袭活动召唤
open_active_summon_monster(List) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, open_active_summon_monster,
										  [List]}).

%% 完成帮会任务获得奖励
guild_task_award(GuildId, UserId, Contribution, Money, Activity, Feats) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, guild_task_award, [GuildId, UserId, Contribution, Money, Activity, Feats]}).


%% 获取申请列表
get_guild_item_request_all(GuildID,UserID,PageIndex,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, get_guild_item_request_all,
										  [GuildID,UserID,PageIndex,PidSend]}).
%% 获取个人申请列表
get_guild_item_request(GuildID,UserID,PageIndex,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, get_guild_item_request,
										  [GuildID,UserID,PageIndex,PidSend]}).
%% 申請物品
request_guild_item(GuildID,UserID,ItemID,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, request_guild_item,
										  [GuildID,UserID,ItemID,PidSend]}).
%% 审核物品
invite_guild_item(GuildID,UserID, Nick, RequestId,Type,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, invite_guild_item,
										  [ GuildID,UserID,Nick, RequestId,Type,PidSend]}).

%% 取消申请物品
cancel_guild_item_request(GuildID,UserID, RequestId,PidSend) ->
	gen_server:cast(get_mod_guild_pid(), {apply_cast, lib_guild, cancel_guild_item_request,
										  [GuildID,UserID, RequestId,PidSend]}).

	
%%====================================================================
%% Private functions
%%====================================================================


