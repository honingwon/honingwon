%%%------------------------------------
%%% @Module  : mod_player
%%% @Author  : ygzj
%%% @Created : 2010.09.27
%%% @Description: 角色处理
%%%------------------------------------ 
-module(mod_player).
-behaviour(gen_server).
-include("common.hrl").


-define(SAVE_PLAYER_TICK, (1 * 60 * 1000)). 	%% 保存tick
-define(Online_Time_Tick, (10 * 1000)).
-define(Revert_Time_Tick, (5 * 1000)).
-define(Sit_Time_Tick, (2 * 1000)).				%%打坐时间检测

-define(PET_TIME_TICK, (10 * 60 * 1000)).		%% 宠物饱食度

-define(Infant_Kick_Time, (5*60)). 			 	%%沉迷状态踢下线
-define(Infant_Kick_Key, infant_kick_key).		%%沉迷时间记录
-define(Rob_Dart_Times, 10).					%%每天抢劫镖车次数

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
		 start/9,
		 stop/2,
		 update_db/1,
		 test_cmd/3,
		test_info/1
		]).
 
%%启动角色主进程
start(Site, UserName, UserID,IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip, Infant, Socket) ->
    gen_server:start(?MODULE, [Site, UserName, UserID, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant, Socket], []).

test_cmd(UId, Cmd, Bin) ->
	Pid = lib_player:get_player_pid(UId),
	gen_server:cast(Pid, {'SOCKET_EVENT', Cmd, Bin}).

test_info(Id) ->
	Pid = lib_player:get_player_pid(Id),
	gen_server:cast(Pid, {test_info}).
%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([Site, UserName, UserID,IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip, Infant, Socket]) ->
	try
		do_init([Site, UserName, UserID, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant, Socket])
	catch
		_:Reason ->
			?WARNING_MSG("mod_player do_init is exception:~w~n,Info:~w",[Reason, UserID]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{ok, #ets_users{}}
	end.

do_init([Site, UserName, UserID,IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip, Infant, Socket]) ->
	case  lib_player:get_player_pid(UserID) of
		[] ->
%% 			process_flag(trap_exit, true),
			%%     process_flag(priority, max),
			net_kernel:monitor_nodes(true),
			PlayerProcessSiteUserName = misc:player_process_site_and_username(Site, UserName),
			misc:register(global, PlayerProcessSiteUserName, self()),
			PlayerProcessName = misc:player_process_name(UserID),
			misc:register(global, PlayerProcessName, self()),
	
			Status = load_player_info(UserID, Socket, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant),
	
			%% 在线时间统计
			erlang:send_after(?Online_Time_Tick, self(), {online_time}),

			%%自动回复属性
			erlang:send_after(?Revert_Time_Tick, self(),{revert_time}),

			%% buff处理
		 	erlang:send_after(?Buff_Time_Tick, self(), {buff_timer, misc_timer:now_milseconds()}),
	
			%%打坐检测处理
			erlang:send_after(?Sit_Time_Tick, self(),{sit_time}),
			
			%% 宠物饱食度的更新
			erlang:send_after(?PET_TIME_TICK, self(),{pet_update_energy_time}),
	
			%% 保存扫描
			erlang:send_after(?SAVE_PLAYER_TICK, self(), {'scan_time'}),
	
			%% 临时防止多登陆
			erlang:send_after(3 * 1000, self(), {'kick_dup_login'}),
			
			
	
			misc:write_monitor_pid(self(),?MODULE, {UserID}),
			
 			gen_server:cast(mod_statistics:get_mod_statistics_pid(), {'get_sys_multexp', self()}),
			
 		   {ok, Status};
		Pid ->
			?WARNING_MSG("start login second:~w", [UserID]),
			stop(Pid, "login second"),
			{stop, "start login second."}
	end.

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
			?WARNING_MSG("UserId:~w, mod_player handle_call is exception:~w~n,Info:~w",[State#ets_users.id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_player handle_cast is exception:~w~n,Info:~w",[State#ets_users.id, Reason, Info]),
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
			?WARNING_MSG("UserId:~w, mod_player handle_info is exception:~w~n,Info:~w",[State#ets_users.id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.
%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(Reason, Status) ->
	try
		do_terminate(Reason, Status)
	catch 
		_:Reason ->
			?WARNING_MSG("UserId:~w, mod_player terminate is exception:~w ~n",[Status, Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			ok
	end.
%% 	?DEBUG(" Oh myGod the mod_player process exit,Reason:[~p] ", [Reason]),
%% %% 	?ERROR_MSG("player is out", []),
%% 	%% 卸载角色数据
%%     unload_player_info(Status),	
%% 	misc:delete_monitor_pid(self()),
%% 	lists:foreach(fun(Pid) -> 
%% 						misc:delete_monitor_pid(Pid)
%% 				end, 
%% 				Status#ets_users.other_data#user_other.pid_send),
%%     ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_oldvsn, Status, _extra) ->
    {ok, Status}.

%%
%% ------------------------私有函数------------------------
%%
%% 接受client事件
socket_event(Cmd, Bin, Status) ->
	NewStatus = 
    case routing(Cmd, Status, Bin) of
        {ok, Status1} ->						%% 修改ets和status
            save_online(Status1),
       		Status1;
		{update, Status1} ->
			update(Status1),
			Status1;
		{update_map, Status1} ->
			update_map(Status1),
			Status1;
		{update_db, Status1} ->
			update_db(Status1),
			Status1;
		{update_all, Status1} ->
			update_all(Status1),
			Status1;
        _R ->
            Status
	 end,
	case Cmd == ?PP_PLAYER_MOVE_STEP orelse Cmd == ?PP_PLAYER_ATTACK  of
		true when NewStatus#ets_users.other_data#user_other.duplicate_id =/= 0 ->
			SumPacket = NewStatus#ets_users.other_data#user_other.sum_packet + 1,
			Other = NewStatus#ets_users.other_data#user_other{sum_packet=SumPacket}, 
			NewStatus#ets_users{other_data=Other};
		_ ->
			if NewStatus#ets_users.id =:= 300000091 
		 		orelse NewStatus#ets_users.id =:= 300039875 
				 orelse NewStatus#ets_users.id =:= 300041355 
				 orelse NewStatus#ets_users.id =:= 300042790 
				 orelse NewStatus#ets_users.id =:= 300052717 
				 orelse NewStatus#ets_users.id =:= 300047486  ->
		  		 ?WARNING_MSG("socket_event socket_event:~p,~p,~p",[NewStatus#ets_users.id,Cmd,Bin]);
	  		 true ->
		  		 skip
			end,
			NewStatus
	end.


%% 路由
%%cmd:命令号
%%Socket:socket id
%%data:消息体
routing(Cmd, Status, Bin) ->
    %%取前面二位区分功能类型
    [H1, H2, _, _, _] = integer_to_list(Cmd),
    case [H1, H2] of
        %%游戏基础功能处理
 		"10" -> pp_base:handle(Cmd, Status, Bin);
        "12" -> pp_map:handle(Cmd, Status, Bin);   
		"14" -> pp_item:handle(Cmd, Status, Bin);
		"15" -> pp_stall:handle(Cmd, Status, Bin);
        "16" -> pp_chat:handle(Cmd, Status, Bin);
		"17" -> pp_team:handle(Cmd, Status, Bin);
		"18" -> pp_friend:handle(Cmd, Status, Bin);
        "19" -> pp_mail:handle(Cmd, Status, Bin);
		"20" -> pp_player:handle(Cmd, Status, Bin);
		"21" -> pp_guild:handle(Cmd, Status, Bin);
		"22" -> pp_sale:handle(Cmd, Status, Bin);
		"23" -> pp_battle:handle(Cmd, Status, Bin);
		"24" -> pp_task:handle(Cmd, Status, Bin);
		"25" -> pp_pet:handle(Cmd, Status, Bin);
		"26" -> pp_infant:handle(Cmd, Status, Bin);
		"27" -> pp_trade:handle(Cmd, Status, Bin);
		"28" -> pp_mounts:handle(Cmd, Status, Bin);
		"29" -> pp_target:handle(Cmd, Status, Bin);
		"30" -> pp_sysinfo:handle(Cmd, Status, Bin);
        _ -> %%错误处理
            ?ERROR_MSG("Routing Error [~w].", [Cmd]),
            {error, "Routing failure"}
    end.

%% 加载角色数据
load_player_info(UserId, Socket, IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant) ->

	User = lib_player:get_info_by_id(UserId), 
	TUser = list_to_tuple([ets_users|User]),	
	
	<<_:192, WeaponState:8,ClothState:8, _/binary>> = lib_player:change_stylebin(TUser#ets_users.style_bin),
	MountsSkillBooks = util:bitstring_to_term(TUser#ets_users.mounts_skill_books),
	MountsSkillBooks2 =  case MountsSkillBooks of
							 undefined  ->
								 [];
							 _ ->
								 MountsSkillBooks
						 end,
	PetSkillBooks = util:bitstring_to_term(TUser#ets_users.pet_skill_books),
	PetSkillBooks2 =  case PetSkillBooks of
							 undefined  ->
								 [];
							 _ ->
								 PetSkillBooks
						 end,
	TMUser = TUser#ets_users{mounts_skill_books = MountsSkillBooks2,pet_skill_books = PetSkillBooks2},
	
	OwnSkillList = lib_skill:get_user_skill(UserId),

	DefaultSkill = lib_skill:get_default_skill_from_template(TMUser#ets_users.career),
	SkillRecord = #r_use_skill{
						  skill_id = DefaultSkill#ets_skill_template.skill_id,	%% 技能id
						  skill_percent = 0,									%% 技能机率
						  skill_lv = DefaultSkill#ets_skill_template.current_level,			%% 技能等级
						  skill_group = DefaultSkill#ets_skill_template.group_id,			%% 技能组
						  skill_lastusetime = 0,					%% 技能上次使用时间
						  skill_colddown = DefaultSkill#ets_skill_template.cold_down_time	%% 技能冷却时间
						 },
	Skill_List = [SkillRecord|OwnSkillList],
	SkillBar = lib_skill:get_user_skill_bar(UserId),
	
	Pid = self(),
	Node = node(),
	
	Pid_send = spawn_link(fun() -> send_msg(Socket) end),
	misc:write_monitor_pid(Pid_send, socket_send, {UserId, 1}),	
	
		%%普通buff，经验buff，血包buff
	{Buffs, Blood_Buff, Magic_Buff, Exp_Buff} = lib_buff:get_user_buff(UserId),
	Now = misc_timer:now_milseconds(),
	NowSecond = misc_timer:now_seconds(),
	New_Buffs = lib_buff:init_users_buff(Buffs, Now),
 	{New_Exp_Buff, ExpRate, _} = lib_buff:timer_exp_buff_list(Pid_send, UserId, Exp_Buff, 1, Now,[]),
	
	 %% 修改数据库上线状态 	
	db_agent_friend:update_friend_online(UserId),

	%% 初始化用户的活动数据
	lib_active:init_user_active(UserId),
	
	%% 初始化充值/消耗活动(首充等)数据
	lib_active_open_server:init_user_activity_open_server(UserId),
	
	%% 初始化用户黄钻数据
	[Is_rece_new_pack,Rece_day_pack_date,Level_up_pack] = lib_yellow:init_user_yellow_box(UserId),
	
	%%  加载好友信息和分组信息 	
	%lib_friend:init_friend(UserId),
	
	% 打开物品进程
 	{ok, Pid_item} = mod_item:start_link(UserId,TMUser#ets_users.career,TMUser#ets_users.level, TMUser#ets_users.bag_max_count, TMUser#ets_users.depot_max_number,Pid, Pid_send),

	%% 任务进程
	{ok, Pid_task} = mod_task:start_link(UserId, Pid_send, Pid),
	
	%% 目标成就进程 
	{ok, Pid_target} = mod_target:start_link(UserId,Pid_item, Pid_send, Pid),
	
	%% 穴位初始化
	{TUser1,Veins_List,Pid_Veins} = lib_veins:get_user_veins(UserId, TMUser, Pid_target),
	%% 初始化宠物(增加了宠物装备所以必须在物品初始化后在加载宠物信息)
	lib_pet:init_online_pet(UserId,Pid_item),	

	%% 玩家副本进程(已经删除该进程转移到mod_player中)
	%%{ok, Pid_Duplicate} = mod_users_dup:start_link(UserId, Pid_send, Pid,TUser1#ets_users.last_online_date),
	%Pid_Duplicate = undefine,
	ok = lib_duplicate:init_duplicate_online(UserId),
	%% 获得出战宠物
	[Pet_id,Pet_template_id,Replace_template_id,PetSkillList,Pet_nick] = lib_pet:get_fight_pet_info(),

	
	
 	Total_Title = lib_player:get_user_total_titles(UserId),
	
	Total_Achieve = lib_target:get_user_total_achieve(UserId),
%% 	CurrAchieveData = lib_target:get_user_curr_achieves(Total_Achieve),
	MapTemplateId = lib_map:get_map_id(TUser1#ets_users.current_map_id),
	
	UserIP = misc:get_ip(Socket),
	
%% 	PlayerNowState = if TUser1#ets_users.current_hp > 0 ->
%% 							?ELEMENT_STATE_COMMON;
%% 						true ->
%% 							?ELEMENT_STATE_DEAD
%% 					end,
	PlayerNowState = ?ELEMENT_STATE_COMMON,
	BankList = lib_bank:get_user_bank_info(UserId),
	WelfareInfo = lib_welfare:get_user_welfare_info({UserId,TUser1#ets_users.last_online_date,TUser1#ets_users.level,TUser1#ets_users.vip_id}),%福利初始化一定要在副本信息初始后
	TokenInfo = lib_token_task:get_user_token_task(UserId),
	ExploitInfo = lib_exploit:get_user_exploit({UserId,NowSecond}),
	ChallengeInfo = lib_challenge_duplicate:init_user_challenge_info({UserId,NowSecond}),
	MarryInfo = lib_marry:get_user_marry(TUser1#ets_users.marry_id),
	BuffTitleId = lib_sys_first:check_pvp_first(UserId),
	Other = #user_other{
						 map_template_id = MapTemplateId,	
						 socket=Socket, 
						 pid=Pid,
						 pid_send=Pid_send,
 						 pid_item=Pid_item,
%% 						 pid_collect=Pid_collect,
						 pid_task = Pid_task,
						 pid_target = Pid_target,
						 %pid_duplicate = Pid_Duplicate,
						 pid_veins = Pid_Veins,
						 welfare_info = WelfareInfo,
						 token_info = TokenInfo,
						 exploit_info = ExploitInfo,
						 challenge_info = ChallengeInfo,
						 node=Node,
						 pid_locked_monster=[],
						 skill_list = Skill_List, 
						 skill_bar = SkillBar,						 
						 buff_list = New_Buffs,
						 veins_list = Veins_List,
						 pet_id = Pet_id,						
				   	     pet_template_id = Pet_template_id,			 
				   	     style_id = Replace_template_id,			 
					     pet_nick = Pet_nick,
 						 total_title = Total_Title,
 						 total_achieve = Total_Achieve,
%% 						 achieve_data = CurrAchieveData,
 						 blood_buff = Blood_Buff,
						 magic_buff = Magic_Buff,
						 exp_buff = New_Exp_Buff,
 						 exp_rate = ExpRate,
						 last_pk_auto_update_time = NowSecond,
 						 login_time = NowSecond,
						 marry_list = MarryInfo,
						 player_now_state = PlayerNowState,
						 map_last_time=NowSecond,
						 
						 weapon_state = WeaponState,
						 cloth_state = ClothState,
						 bank_list = BankList,
						 pet_skill_list = PetSkillList,
						 
					     is_yellow_vip = IsYellowVip,
				         is_yellow_year_vip = IsYellowYearVip,
                         yellow_vip_level = YellowVipLevel,
						 is_yellow_high_vip = IsYellowHighvip,
						
						 is_rece_new_pack = Is_rece_new_pack,
						 rece_day_pack_date = Rece_day_pack_date,
						 level_up_pack = Level_up_pack,
						 buff_titleId = BuffTitleId
						% daily_award_list = AwardList
						 },
	
	TUser2 = TUser1#ets_users{ip = UserIP, other_data=Other},

	Level = lib_exp:get_level_by_exp(TUser2#ets_users.exp),
	TUser3 = TUser2#ets_users{level = Level},
	
	%%重新登录更新运镖时间
	TUser4 = 
		if
			TUser3#ets_users.darts_left_time =:= 0 ->
				TUser3#ets_users{darts_left_time = 0 };
			TUser3#ets_users.darts_left_time =< NowSecond ->
				TUser3#ets_users{darts_left_time = 0 ,escort_id = 0 };
			true ->
				TUser3
		end,
	lib_task:init_escort_time(TUser4#ets_users.other_data#user_other.pid_task, TUser4#ets_users.darts_left_time),
		
	TUser5 = lib_player:calc_properties(TUser4),
	TUser6 = case  TUser5#ets_users.current_hp < 1 of
				 true ->
					case lib_duplicate:is_dead_duplicate(TUser5#ets_users.current_map_id) of
						not_duplicate ->							
							lib_player:relive_to_city(TUser5);
						false ->
							TUser55 = lib_buff:remove_buff(TUser5,1),
							lib_player:relive_to_city(TUser55);
						Dup_Pid ->
						 	case lib_player:login_in_duplicate(TUser5, Dup_Pid) of
								false ->
									TUser55 = lib_buff:remove_buff(TUser5,1),
					 				lib_player:relive_to_city(TUser55);
								TUser555 ->
									lib_player:relive_with_dup_fresh(TUser555)
							end						
					end;				 	
				 _ ->
					%?DEBUG("TUser5#ets_users.current_map_id:~p",[TUser5#ets_users.current_map_id]),
					case lib_duplicate:is_dead_duplicate(TUser5#ets_users.current_map_id) of
						not_duplicate ->
							%?DEBUG("TUser5 not_duplicate:~p",[TUser5#ets_users.current_map_id]),
							lib_king_fight:check_king_map_login(TUser5);
						false ->
							%?DEBUG("TUser5 false:~p",[TUser5#ets_users.current_map_id]),
							TUser55 = lib_buff:remove_buff(TUser5,1),
							lib_player:return_to_old_map(TUser55);
						Dup_Pid ->
						 	case lib_player:login_in_duplicate(TUser5, Dup_Pid) of
								false ->
									%?DEBUG("login_in_duplicate false:~p",[TUser5#ets_users.current_map_id]),
									TUser55 = lib_buff:remove_buff(TUser5,1),
					 				lib_player:return_to_old_map(TUser55);
								TUser55 ->
									TUser55
							end						
					end
			 end,
	%?DEBUG("TUser6 :~p",[{TUser6#ets_users.camp,TUser6#ets_users.other_data#user_other.battle_info#battle_info.camp,TUser6#ets_users.other_data#user_other.war_state}]),
	TUser7 = lib_infant:get_infant_user(TUser6, Infant),

	%% 检测PK状态是否为队伍，帮派，阵营的其中一种，当是这状态但不满足条件时自动调整
	TUser8 = 
		if TUser7#ets_users.pk_mode =:= ?PKMode_TEAM ->
			   if TUser7#ets_users.team_id =:= 0 orelse TUser7#ets_users.other_data#user_other.pid_team =:= undefined ->
					  lib_player:change_pk_mode_auto(TUser7);
				  true ->
					  TUser7
			   end;
		   TUser7#ets_users.pk_mode =:= ?PKMode_CLUB andalso TUser7#ets_users.club_id =:= 0 ->
			   lib_player:change_pk_mode_auto(TUser7);
		   TUser7#ets_users.pk_mode =:= ?PKMode_CAMP ->
				if
					TUser7#ets_users.camp =:= 0 ->
						case TUser7#ets_users.other_data#user_other.map_template_id of
							?RESOURCE_WAR_MAP_ID ->
								TUser7;
							?PVP_FIRST_MAP_ID ->
								TUser7;
							?ACTIVE_KING_FIGHT_MAP_ID ->
								TUser7;
							_ ->
								lib_player:change_pk_mode_auto(TUser7)
						end;
					true ->
						TUser7
				end;			   
		   true ->
			   TUser7
		end,
		
%% 	TUser8 = case TUser7#ets_users.pk_mode == ?PKMode_TEAM of
%% 				true ->
%% 					case (TUser7#ets_users.team_id == 0 orelse TUser7#ets_users.other_data#user_other.pid_team == undefined) of
%% 						true -> TUser7#ets_users{pk_mode = ?PKMode_PEACE};
%% 						_ -> TUser7
%% 					end;
%% 			 	_ -> TUser7
%% 			end,
	
	%% 被动技能
%% 	TUser9 = lib_skill:cale_pasv_skill(Skill_List,[],TUser8),
	%% 帮会
%% 	TUser10 =
%% 		case mod_guild:get_guild_info_for_user(TUser8#ets_users.id) of
%% 			{ClubID,ClubName,ClubJob} ->
%% 				OtherData = TUser8#ets_users.other_data#user_other{club_name = ClubName,club_job = ClubJob},
%% 				TUser8#ets_users{club_id = ClubID, other_data = OtherData};
%% 			_ ->
%% 				TUser8#ets_users{club_id = 0}
%% 		end,
		
%% 	TUser10 = mod_guild:get_guild_info_for_user(TUser8),
	TUser10 = TUser8#ets_users{club_id = 0},
	gen_server:cast(mod_guild:get_mod_guild_pid(),{get_guild_info_for_user, 
												   TUser10#ets_users.id, 
												   TUser10#ets_users.other_data#user_other.pid}),
	

%% 	%%相隔一天将神魔令次数、劫镖次数清0
%% 	RepeatDay = util:get_diff_days(TUser10#ets_users.last_online_date, NowSecond),
%% 	TUser12 = 
%% 		case RepeatDay >= 1 of
%% 			true ->
%% 				TUser10#ets_users{shenmo_times = 0, today_escort_times=0};
%% 			_ ->
%% 				TUser10
%% 		end,
	
	%%判断是否还是vip
	TUser13 = lib_vip:load_vip(TUser10,NowSecond),

	%%判段如果是在副本中，这发送进入副本包
%% 	if
%% 		TUser13#ets_users.other_data#user_other.duplicate_id > 0 ->
%% 			{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, TUser13#ets_users.other_data#user_other.duplicate_id),
%% 			lib_send:send_to_sid(TUser13#ets_users.other_data#user_other.pid_send, ReturnData);
%% 		true ->
%% 			ok
%% 	end,
	TUser14 = lib_daily_award:check_daily_award_string(TUser13),

	ets:insert(?ETS_ONLINE, TUser14),
	TUser14.

%% 卸载角色数据
unload_player_info(TempStatus) ->
	
	UserId = TempStatus#ets_users.id,
	Fight = TempStatus#ets_users.fight,
	UserNick = TempStatus#ets_users.nick_name,
	
%% 	TempStatus1 = 
%% 		case lib_duplicate:quit_club_map(TempStatus) of
%% 			{ok, TempStatus2} ->
%% 				TempStatus2;
%% 			_ ->
%% 				TempStatus
%% 		end,
%% 	
	NowSecond = misc_timer:now_seconds(),
	Status1 = lib_buff:remove_buff(TempStatus,4),%下线移除副本
	NewCamp = if  Status1#ets_users.current_map_id =:= ?PVP_FIRST_MAP_ID -> ?PVP_FIRST_OTHER_CAMP;
			true -> Status1#ets_users.camp end,
	Status = 
		case lib_duplicate:off_line_duplicate(Status1) of
			{ok,NewStatus} ->
				NewStatus#ets_users{last_online_date = NowSecond,camp = NewCamp};
			_ ->
				Status1#ets_users{last_online_date = NowSecond,camp = NewCamp}
		end,

	%% 下线离开场景 
	pp_map:handle(?PP_MAP_USER_REMOVE, Status, 0),
    
    %% 修改数据库下线状态 	
	db_agent_friend:update_friend_offline(UserId),

	%%下线提示 	
	lib_friend:send_friend_state(UserId, UserNick, 0),
	
	mod_guild:send_guild_member_online(UserId,
									   Fight,
									   NowSecond,
									   0,
									   undefined,
									   undefined),
	
	%% 更新队伍
	lib_team:team_check(Status),

	%%打坐双修取消
	lib_sit:cancle_sit(Status),
		
	%% 交易取消
	lib_trade:trade_offline(Status),
	
	%% 保存状态数据
    save_player_table(Status),
	
	%%添加登入登出记录
	lib_statistics:insert_login_log(UserId, Status#ets_users.other_data#user_other.login_time, 
									   0, Status#ets_users.ip, Status#ets_users.career, Status#ets_users.level),
	
	%%保存Buff状态		
	BuffList = Status#ets_users.other_data#user_other.buff_list,
%% 	RemoveList = Status#ets_users.other_data#user_other.remove_buff_list,
	ExpList = Status#ets_users.other_data#user_other.exp_buff,
	BloodBuff = Status#ets_users.other_data#user_other.blood_buff,
	MagicBuff = Status#ets_users.other_data#user_other.magic_buff,
	db_agent_buff:save_user_buff(ExpList ++ BloodBuff ++ MagicBuff ++ BuffList),
	%%保存副本数据
	lib_duplicate:duplicate_offline(),
	Status#ets_users.other_data#user_other.pid_send ! {stop},

	gen_server:cast(Status#ets_users.other_data#user_other.pid_item, {stop, 0}),
	gen_server:cast(Status#ets_users.other_data#user_other.pid_task, {stop, 0}),
	%gen_server:cast(Status#ets_users.other_data#user_other.pid_duplicate, {stop, 0}),
	if is_pid(Status#ets_users.other_data#user_other.pid_veins) ->
		gen_fsm:send_event(Status#ets_users.other_data#user_other.pid_veins, {stop, 0});
	true ->
		true
	end,

	%% 清除相关ets数据
	delete_player_ets(Status#ets_users.id),
    %% 删除ETS记录
    ets:delete(?ETS_ONLINE, Status#ets_users.id),
    %% 关闭socket连接
%%     gen_tcp:close(Status#ets_users.other_data#user_other.socket),
	catch erlang:port_close(Status#ets_users.other_data#user_other.socket),

    ok.

delete_player_ets(UserId) ->
%% 	todo 清除玩家数据：物品，任务....
	%lib_friend:delete_offline_friend_ets(UserId),
%% 	item_util:item_offline(UserId), %% 放进程字典，不用清除ets
%% 	lib_pet:delete_offline_pet_ets(UserId),
%% 	lib_task:task_offline(UserId), %% 放进程字典，不用清除ets
	ok.

%%发消息
send_msg(Socket) ->
	try
		
 	   receive
     	   {send, Bin} ->
%% 				<<_:24,_CMD:16,_Data/binary>> = Bin,
 	            case gen_tcp:send(Socket, Bin) of
					ok ->
						skip;
					_Res ->
%% 						?WARNING_MSG("CMD:~w,Socket:~w,Res:~w~n", [CMD, Socket, Res])
						ok
				end,
	            send_msg(Socket);
			{stop} ->
				stop;
			Error ->
				?WARNING_MSG("Error:~w", [Error]),
				send_msg(Socket)
	    end
	catch
		_:_ ->
			skip,
			send_msg(Socket)
	end.

%%停止本游戏进程
stop(Pid, Reason) when is_pid(Pid) ->
    gen_server:cast(Pid, {stop, Reason}).

%% ------------------------------------保存人物信息-----------------------------
%% 更新本节点信息
update(PlayerStatus) ->
	ets:insert(?ETS_ONLINE, PlayerStatus).
%%更新地图信息
update_map(PlayerStatus) ->
	update(PlayerStatus),
	mod_map:update_player(PlayerStatus).
	%mod_map:update_player_battle_object(PlayerStatus).
%% 更新到数据库
update_db(PlayerStatus) ->
	update(PlayerStatus),
	save_player_table(PlayerStatus).
%% 保存数据库和地图，本节点
update_all(PlayerStatus) ->
	update_map(PlayerStatus),
	save_player_table(PlayerStatus).

%% 同步更新ETS中的角色数据
save_online(PlayerStatus) ->
	%% 更新本地ets里的用户信息
    ets:insert(?ETS_ONLINE, PlayerStatus),
	%% 更新对应场景中的用户信息
    mod_map:update_player(PlayerStatus),
%% 	mod_map:update_player_battle_object(PlayerStatus),
	ok.

%%保存基本信息
%%当玩家退出的时候也会执行一次这边的信息 
save_player_table(Status1) ->
 	<<Cloth:32, Weapon:32, Mount:32, Wing:32,StrengthLevel:32,MountsStrengthLevel:32,WeaponState:8,ClothState:8>> = Status1#ets_users.style_bin,
	StyleBin1 = lists:concat([Cloth, ',', Weapon, ',', Mount, ',', Wing,',',StrengthLevel,',',MountsStrengthLevel,',',WeaponState,',',ClothState]),
	Status = Status1#ets_users{style_bin = StyleBin1},
	MountsSkillBooks = util:term_to_string(Status#ets_users.mounts_skill_books),
	PetSkillBooks = util:term_to_string(Status#ets_users.pet_skill_books),
	Status2 = Status#ets_users{mounts_skill_books = MountsSkillBooks,pet_skill_books = PetSkillBooks},
	ValueList = lists:nthtail(2, tuple_to_list(Status2#ets_users{other_data=''})),
	[id | FieldList] = record_info(fields, ets_users),
	
	db_agent:mp_save_user_table(Status2#ets_users.id, FieldList, ValueList).

%%保存战斗时怪物锁定玩家的pid信息
save_locked(Status, Pid) ->
	case lists:keymember(Pid,1,Status#ets_users.other_data#user_other.pid_locked_monster) of
		true ->  %%已有
			Status;
		false -> %%没有
%% 			Status#ets_users.other_data#user_other{pid_locked_monster = [{Pid}|Status#ets_users.other_data#user_other.pid_locked_monster]}		
			Other = Status#ets_users.other_data#user_other{pid_locked_monster = [{Pid}|Status#ets_users.other_data#user_other.pid_locked_monster]},
			Status#ets_users{other_data=Other}			
	end.

save_locked_target(Status, Pid) ->
	case lists:keymember(Pid, 1, Status#ets_users.other_data#user_other.pid_locked_target_monster) of
		true ->
			Status;
		false ->
			Other = Status#ets_users.other_data#user_other{pid_locked_target_monster = [{Pid}|Status#ets_users.other_data#user_other.pid_locked_target_monster]},
			Status#ets_users{other_data=Other}
	end.

save_unlock(Status, Pid) ->
	Other = Status#ets_users.other_data#user_other{pid_locked_monster = lists:keydelete(Pid,1,Status#ets_users.other_data#user_other.pid_locked_monster)},
	Other1 = Other#user_other{pid_locked_target_monster = lists:keydelete(Pid,1,Status#ets_users.other_data#user_other.pid_locked_target_monster)},
	Status#ets_users{other_data=Other1}.

save_unlock_target(Status, Pid) ->
	Other = Status#ets_users.other_data#user_other{pid_locked_target_monster = lists:keydelete(Pid,1,Status#ets_users.other_data#user_other.pid_locked_target_monster)},
    Status#ets_users{other_data=Other}.


%%---------------------do_call--------------------------------

%%处理socket协议 (cmd：命令号; data：协议数据)
do_call({'SOCKET_EVENT', Cmd, Bin}, _From, Status) ->
	NewStatus = socket_event(Cmd, Bin, Status),
	{reply, ok, NewStatus};

 
%%获取用户信息
do_call('PLAYER', _from, Status) ->
    {reply, Status, Status};


%%获取用户信息(按字段需求)
do_call({'PLAYER', List}, _from, Status) ->
	Reply = lib_player_rw:get_player_info_fields(Status, List),
    {reply, Reply, Status};

do_call({get_friend_info,FriendID}, _from, Status) ->	%取得好友信息
	FI = case lib_friend:get_relation_info(lib_friend:get_relation_dic(),FriendID) of
		[] -> [];
		FriendInfo -> [FriendInfo]
	end,
	{reply,FI,Status};
%%判断玩家试炼挑战次数是否已经超过10次
do_call({max_challenge_num}, _from, Status) ->
	Result = if
		Status#ets_users.other_data#user_other.challenge_info#r_user_challenge_info.challenge_num > ?MAX_CHALLENGE_NUM_WTHE_AWARD ->
			true;
		true ->
			false 
	end,
	{reply,Result,Status};


%%请求玩家等级
do_call({get_player_level}, _from, Status) ->
	{reply,Status#ets_users.level,Status};


do_call({get_fight_pet}, _from, Status) ->
	Re = lib_pet:get_fight_pet(),
	{reply,Re,Status};


do_call(Info, _, State) ->
	?WARNING_MSG("mod_player call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%%处理socket协议 (cmd：命令号; data：协议数据)
do_cast({'SOCKET_EVENT', Cmd, Bin}, Status) ->	
	NewStatus = socket_event(Cmd, Bin, Status),
	{noreply, NewStatus};

%% 更新试炼副本评星
do_cast({update_challenge_star, MIndex, Star}, Status) ->
	lib_target:cast_check_target(Status#ets_users.other_data#user_other.pid_target,[{?SHILIAN_BOSS,{MIndex,Star}}]),
	Info = lib_challenge_duplicate:update_chanllenge_star(MIndex, Status#ets_users.other_data#user_other.challenge_info, Star),
	NewOther = Status#ets_users.other_data#user_other{challenge_info = Info},
	NewStatus = Status#ets_users{other_data = NewOther},
	{noreply, NewStatus};

%%发出的好友请求，被接受
%do_cast({request_friend_ok, FriendInfo}, Status) ->
%	lib_friend:add_friend(FriendInfo),
 %   {noreply, Status};

do_cast({practice_time, FsmState}, Status) ->
	case FsmState of
		practice_end ->
			NewStatus = lib_veins:upgrade_acupoint_lv(Status);
		fsm_stop ->
			NewOtherData = Status#ets_users.other_data#user_other{pid_veins = undefiend},
			NewStatus = Status#ets_users{other_data = NewOtherData}
	end,
	{noreply, NewStatus};


%%加入队伍
do_cast({join_team, PidTeam, TeamId, AllotMode, IsAutoIn, AllowInvit}, Status) when is_pid(PidTeam) ->
%% 	NewStatus = Status#ets_users.other_data#user_other{pid_team = PidTeam},
	Other = Status#ets_users.other_data#user_other{pid_team = PidTeam,
												   allot_mode = AllotMode},
	NewStatus = Status#ets_users{team_id = TeamId,
								 other_data = Other
								 },
	{ok, Data} = pt_17:write(?PP_TEAM_CHANGE_SETTING, [TeamId, IsAutoIn, AllowInvit]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Data),
%% 	save_online(NewStatus),
	update_map(NewStatus),
    {noreply, NewStatus};

%%离开队伍
do_cast({leave_team}, Status) ->
%% 	NewStatus = Status#ets_users.other_data#user_other{pid_team = undefined},
	
	Other = Status#ets_users.other_data#user_other{pid_team = undefined,
												   allot_mode = undefined},
	NewStatus = Status#ets_users{team_id = 0,
								 other_data = Other
								 },
	
	%%离开队伍时检查PK状态，如果为“队伍”状态则改为“和平”状态
	LastStatus = case NewStatus#ets_users.pk_mode == ?PKMode_TEAM of
					true ->
						AutoStatus = lib_player:change_pk_mode_auto(NewStatus),
						{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [AutoStatus#ets_users.pk_mode,
																			    misc_timer:now_seconds()]),
						lib_send:send_to_sid(AutoStatus#ets_users.other_data#user_other.pid_send,BinData),
						{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[AutoStatus]),
						mod_map_agent: send_to_area_scene(AutoStatus#ets_users.current_map_id,
									  					 AutoStatus#ets_users.pos_x,
									  					 AutoStatus#ets_users.pos_y,
									 					 PlayerData,
									  					 undefined),
						AutoStatus;
					_ -> 
						NewStatus
				 end,
	
%% 	IsWar = lib_map:is_copy_war(LastStatus#ets_users.current_map_id),
	case lib_map:is_copy_scene(LastStatus#ets_users.current_map_id) of
		true when LastStatus#ets_users.other_data#user_other.war_state =:= 0  ->
			case lib_duplicate:quit_duplicate(LastStatus) of
				{ok, LastStatus1} ->
					update_map(LastStatus1),
					{noreply, LastStatus1};
				
				 _ ->
%% 					 save_online(LastStatus),
					 update_map(LastStatus),
					 {noreply, LastStatus}
			end;
		_ ->
%% 			save_online(LastStatus), 
			update_map(LastStatus),
			{noreply, LastStatus}
	end;


%% 队伍分配模式改变
do_cast({team_allot_change, AllotMode}, Status) ->
	Other = Status#ets_users.other_data#user_other{allot_mode = AllotMode},
	NewStatus = Status#ets_users{other_data = Other},
%% 	save_online(NewStatus),
	update_map(NewStatus),
	{noreply, NewStatus};

%% %%更新用户信息
do_cast({update_player, NewStatus}, _Status) when is_record(NewStatus, ets_users) ->
%% 	save_online(NewStatus),
%% 	update_map(NewStatus),
	?WARNING_MSG("update_player is error.",[]),
    {noreply, _Status};
%% 	

%%停止角色进程(Reason 为停止原因)
do_cast({stop, _Reason}, Status) ->
	if is_record(Status, ets_users) andalso is_record(Status#ets_users.other_data, user_other) ->
		   lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send, ?_LANG_SYSTEM_SHUTDOWN]);
	   true ->
		   skip
	end,
    {stop, normal, Status};

%% 加血
do_cast({reducehpmp_byself, HP,  NowState}, Status) ->
	NewStatus = lib_player:add_hp_and_mp(HP, 0, Status) ,

	Other_data = NewStatus#ets_users.other_data#user_other{player_now_state = NowState},
	NewStatus1 = NewStatus#ets_users{other_data = Other_data},
	
	{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[NewStatus1#ets_users.id, 1, ?ELEMENT_PLAYER,HP,0,
														 NewStatus1#ets_users.current_hp, 
														 NewStatus1#ets_users.current_mp]),
	mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
												 NewStatus1#ets_users.pos_x,
												 NewStatus1#ets_users.pos_y,
												 HPMPBin,
												 undefined),

	
	case NewStatus1#ets_users.current_hp > 0 of %andalso
		true ->
			update(NewStatus1);
		_ ->%死亡/状态改变时时再同步到地图
		   update_map(NewStatus1)
	end,
	{noreply, NewStatus1};


%% 由于自己的原因扣血蓝
do_cast({reducehpmp_byself,_SelfID, HP, MP, NowState}, Status) ->
	NewStatus = lib_player:reduce_hp_and_mp_by_self(Status,HP,MP),
%% 	save_online(NewStatus),
	Other_data = NewStatus#ets_users.other_data#user_other{player_now_state = NowState},
	NewStatus1 = NewStatus#ets_users{other_data = Other_data},
	
	{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[NewStatus1#ets_users.id, 1, ?ELEMENT_PLAYER,HP,MP,
														 NewStatus1#ets_users.current_hp, 
														 NewStatus1#ets_users.current_mp]),
	mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
												 NewStatus1#ets_users.pos_x,
												 NewStatus1#ets_users.pos_y,
												 HPMPBin,
												 undefined),

	
	case NewStatus1#ets_users.current_hp > 0 of %andalso
%% 		Status#ets_users.other_data#user_other.player_now_state =:= NowState of%平时地图上处理血蓝等
		true ->
			NewStatus2 = NewStatus1,
			update(NewStatus2);
		false when( NowState=:= ?ELEMENT_STATE_DEAD) ->	%死亡
			?DEBUG("ELEMENT_STATE_DEAD:~p",[{NowState,?ELEMENT_STATE_DEAD}]),
		   	NewStatus2 = lib_buff:remove_buff(NewStatus1,2),
		   	update_map(NewStatus2);
		_ -> % 状态改变时再同步到地图	
			?DEBUG("ELEMENT_STATE_DEAD:~p",[{NowState,?ELEMENT_STATE_DEAD}]),
			NewStatus2 = lib_buff:remove_buff(NewStatus1,2),
		  	update_map(NewStatus2)	
	end,
	{noreply, NewStatus2};

% 战斗操作hp.mp.bufflist
do_cast({reducehpmp, SelfID, TargetPid, TargetID, HP, MP, Type,HitBuffList, TargetName, NowState, StandupDate},Status) ->
	NewStatus = lib_player:reduce_hp_and_mp(Status, HP, MP, Type, TargetPid, TargetID, TargetName, NowState, StandupDate),
	if  
		HitBuffList =/= [] ->
			{BL,_NBL,RemoveBuffList} = lib_buff:add_buff_new(SelfID, HitBuffList, Status#ets_users.other_data#user_other.buff_list),
			
			OldRemoveList = Status#ets_users.other_data#user_other.remove_buff_list,
			OtherData = NewStatus#ets_users.other_data#user_other{buff_list = BL,remove_buff_list = RemoveBuffList ++ OldRemoveList},
			NewStatus1 = NewStatus#ets_users{other_data = OtherData};
		true ->
			NewStatus1 = NewStatus
	end,
	
%% 	save_online(NewStatus1),
	case NewStatus1#ets_users.current_hp > 0 andalso 
		 Status#ets_users.other_data#user_other.player_now_state =:= NowState of	%平时地图上处理血蓝等
		true ->
			NewStatus2 = NewStatus1,
			update(NewStatus2);
		false when( NowState=:= ?ELEMENT_STATE_DEAD) ->	%死亡
			?DEBUG("ELEMENT_STATE_DEAD:~p",[{NowState,?ELEMENT_STATE_DEAD}]),
		   	NewStatus2 = lib_buff:remove_buff(NewStatus1,2),
		   	update_map(NewStatus2);
		_ -> % 状态改变时再同步到地图
			NewStatus2 = NewStatus1,
		  	update_map(NewStatus2)			
	end,
	{noreply,NewStatus2};

do_cast({update_state, _NewState}, Status) -> %% 同步自身，不需要再处理地图等信息
%% 	update(NewState),
	?WARNING_MSG("update_state is error",[]),
	{noreply, Status};
	 
%% 同步战斗信息
do_cast({update_battle_info, BattleInfo, CurrentHP, CurrentMP}, Status) -> %% 同步自身，不需要再处理地图等信息
	OtherData = Status#ets_users.other_data#user_other{battle_info = BattleInfo},
	NewStatus = Status#ets_users{current_hp=CurrentHP, current_mp=CurrentMP, other_data = OtherData},
	update(NewStatus),
	{noreply, NewStatus};

% 主动pk pk时间更新，目前用于交易，打坐等的判断，故不用保存地图
do_cast({actor_pk,L},Status) ->
	Other_data = lib_player:change_pk_time(Status,?PK_Actor),
	NewStatus = Status#ets_users{other_data = Other_data},
 	update(NewStatus),
	lib_player:set_pk_dic(Status#ets_users.id, L, 0),
	{noreply,NewStatus};


%% 主动攻击时间更新
do_cast({actor_fight}, Status) ->
	Other_data = Status#ets_users.other_data#user_other{last_fight_actor_time = misc_timer:now_seconds()},
	NewStatus = Status#ets_users{other_data = Other_data},
	update(NewStatus),
	{noreply,NewStatus};

%% 添加杀怪经验
do_cast({addexp,FixExp,MonExp,MonLevel,Number},Status) ->
	NewStatus = lib_player:add_exp(Status,FixExp,MonExp,MonLevel,Number),
	case NewStatus#ets_users.level =/= Status#ets_users.level of
		true ->
			update_map(NewStatus);
		_ ->
			update(NewStatus)
	end,
	{noreply, NewStatus};

%% 添加经验和荣誉
%% do_cast({'add_exp_honor', Exp, Honor}, Status) ->
%% 	NewStatus1 = lib_player:add_exp(Status, Exp),
%% 	NewStatus2 = lib_player:add_honor(NewStatus1, Honor),
%% 	{noreply, NewStatus2};

%% 自由战结束
do_cast({'free_war_finish'}, Status) ->
%% 	NewStatus1 = lib_player:add_exp(Status, Exp),
%% 	NewStatus2 = lib_player:add_honor(NewStatus1, Honor),
	
	NewStatus4 =
		case lib_duplicate:quit_duplicate(Status) of
			{ok, NewStatus3} ->
				update_map(NewStatus3),
				NewStatus3;
			_ ->
				Status
		end,
	{noreply, NewStatus4};


% 学习或者升级技能时消耗值
do_cast({upgradeskill,NItems}, Status) ->
	%物品
	F = fun(NItem) -> {ItemID,ItemNum} = NItem,
							gen_server:cast(Status#ets_users.other_data#user_other.pid_item,{'reduce_item_in_commonbag', ItemID, ItemNum,?CONSUME_ITEM_USE})
		end,
	lists:foreach(F,NItems),
	{noreply, Status};

do_cast({kill_monster, MonsterId, DropList}, Status) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_task,
					 {'kill_monster', MonsterId, DropList}),
	{noreply, Status};

%杀死了玩家 调整红名值等
do_cast({kill_player,DeadPid,DeadID, DeadLv, ClubID, PK_Value,DeadName}, Status) ->
	%%mod_free_war:free_war_kill(Status, DeadID),
	%%mod_resource_war:resource_war_kill(Status,DeadLv),
	WarState = Status#ets_users.other_data#user_other.war_state,
	if 
		WarState > 0  andalso WarState < 4 ->
			mod_resource_war:resource_war_kill(Status, DeadID, DeadLv),
			{noreply, Status};
		WarState > 3  andalso WarState < 6 ->
			case lib_pvp_first:pvp_first_kill(Status, DeadID) of
				ok ->
					{noreply, Status};
				NewStatus ->
					update_map(NewStatus),
					{noreply, NewStatus}
			end;
		Status#ets_users.current_map_id =:= ?ACTIVE_GUILD_FIGHT_MAP_ID ->	
			mod_guild_fight:guild_war_kill(Status, DeadID),
			{noreply, Status};
		Status#ets_users.current_map_id =:= ?ACTIVE_KING_FIGHT_MAP_ID ->	
			mod_king_fight:king_war_kill(Status, DeadID),
			{noreply, Status};	
		Status#ets_users.other_data#user_other.map_template_id =:= ?FIGHT_DUP_MAP_ID ->	
			{noreply, Status};
		true ->
			lib_statistics:add_pk_log(Status#ets_users.id, Status#ets_users.level, Status#ets_users.pk_value,
							   DeadID, DeadLv, []),
			EnemyList = Status#ets_users.other_data#user_other.battle_info#battle_info.guild_enemy ,
			NeedCheck = if EnemyList =:= [] ->
							   true;
						   true ->
							   case lists:keymember(ClubID,1,EnemyList) of
								   false ->
									   true;
								   _ ->
									   false
							   end
						end,
			if NeedCheck =:= true andalso PK_Value =< 10 ->
				   case lib_player:kill_pk(Status#ets_users.id,DeadID) of
					   {true} ->
						   OldPKValue = Status#ets_users.pk_value,
						   NewPKValue = lib_player:kill_player(OldPKValue);
					   {false} ->
						   OldPKValue = Status#ets_users.pk_value,
						   NewPKValue = Status#ets_users.pk_value
				   end,
				   if OldPKValue =/= NewPKValue ->
						  {ok, PKBin} = pt_20:write(?PP_PLAYER_PK_VALUE_CHANGE,[Status#ets_users.id,NewPKValue]),
						  mod_map_agent:send_to_area_scene(Status#ets_users.current_map_id, 
											 Status#ets_users.pos_x, 
											 Status#ets_users.pos_y, 
											 PKBin),
						  NewStatus = Status#ets_users{pk_value = NewPKValue},
						  AddPkValue = NewPKValue - OldPKValue,
						  update_map(NewStatus);
					  true ->
						  AddPkValue = 0,
						  NewStatus = Status
				   end;
			   true ->
				   AddPkValue = 0,
				   NewStatus = Status
			end,
			DeadMsg = ?GET_TRAN(?_LANG_PK_KILL, [DeadName,AddPkValue]),
			lib_chat:chat_sysmsg_pid([NewStatus#ets_users.other_data#user_other.pid_send, ?EVENT, ?None, ?ORANGE, DeadMsg]),
			gen_server:cast(DeadPid,{add_enemy,
											 NewStatus#ets_users.id,
											 NewStatus#ets_users.nick_name,
											 NewStatus#ets_users.sex,
											 NewStatus#ets_users.level,
											 NewStatus#ets_users.state,
											 NewStatus#ets_users.career}),
			{noreply,NewStatus}
	end;

%% %杀死了玩家,只加仇人
%% do_cast({kill_player_red, DeadPid, DeadId, DeadLv}, Status) ->
%% 	lib_statistics:add_pk_log(Status#ets_users.id, Status#ets_users.level, Status#ets_users.pk_value,
%% 							   DeadId, DeadLv,[]),
%% 	gen_server:cast(DeadPid,{add_enemy,
%% 									 Status#ets_users.id,
%% 									 Status#ets_users.nick_name,
%% 									 Status#ets_users.sex,
%% 									 Status#ets_users.level,
%% 									 Status#ets_users.state,
%% 									 Status#ets_users.career}),
%% 	{noreply, Status};

%被杀后添加到仇人
do_cast({add_enemy,KillerID,KillerNick,KillerSex,KillerLevel,KillerState,KillerCareer},Status) ->
	case lib_friend:add_relation(Status#ets_users.id,Status#ets_users.nick_name,
								 Status#ets_users.other_data#user_other.pid_send,
								 Status#ets_users.other_data#user_other.pid_target,
								 KillerID,KillerNick,KillerSex,KillerLevel,KillerState,KillerCareer,
								 ?RELATION_ENEMY,lib_friend:get_relation_dic()) of
%% 		{ok,UserPidSend,Bin,NewRelationL} ->
%% 			lib_send:send_to_sid(UserPidSend,Bin),
%% 			put(?DIC_USERS_RELATION,NewRelationL);
		{ok,UserPidSend,Bin} ->
			lib_send:send_to_sid(UserPidSend,Bin);
		_ -> 
			skip
	end,
	{noreply,Status};

%请求通过后的处理
do_cast({add_relation_friend,RequestUserID,RequestUserNick,RequestUserSex,RequestUserLevel,RequestUserState,RequestUserCareer},Status) ->
	case lib_friend:add_relation(Status#ets_users.id,Status#ets_users.nick_name,
								 Status#ets_users.other_data#user_other.pid_send,
								 Status#ets_users.other_data#user_other.pid_target,
			 			  RequestUserID,RequestUserNick,RequestUserSex,RequestUserLevel,RequestUserState,RequestUserCareer,
			 			  ?RELATION_FRIEND,lib_friend:get_relation_dic()) of
%% 		{ok,RPidSend,RBin,RNewRelationL} ->
%% 			lib_send:send_to_sid(RPidSend,RBin),
%% 			put(?DIC_USERS_RELATION,RNewRelationL);
		{ok,RPidSend,RBin} ->
			lib_send:send_to_sid(RPidSend,RBin);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg])
	end,
	{noreply,Status};


%% 添加好友度
do_cast({add_friend_amity,RequestUserID,RequestUserNick,Amity},Status) ->
	lib_friend:add_friend_amity(Status#ets_users.other_data#user_other.pid_send,
									 Status#ets_users.id,
									 Status#ets_users.nick_name,
									 RequestUserID,
									 RequestUserNick,
									 Amity,
									 lib_friend:get_relation_dic()),
	
	{noreply,Status};


%设置上下线
do_cast({relation_online,FriendID,_FriendNick,Online,Bin},Status) ->
	case lib_friend:set_relation_online(FriendID,Online) of
		{false} ->
			skip;
		{ok,FMSG,EMSG} ->
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,Bin),
			case FMSG of
				[] ->
					skip;
				_ ->
					lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?EVENT,?None,?RED,FMSG])
			end,
			case EMSG of
				[] ->
					skip;
				_ ->
					lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?EVENT,?None,?RED,EMSG])
			end
	end,
	{noreply,Status};

%% 加载帮会数据
do_cast({get_guild_info_for_user_return, GuildID, GuildName, GuildJob, GuildMapPid, GuildMapID, EnemyList, GuildLevel,FurnaceLevel,CurrentFeats, TotalFeats}, Status) ->
	BattleInfo = Status#ets_users.other_data#user_other.battle_info#battle_info{guild_enemy = EnemyList},
 
	Other_data = Status#ets_users.other_data#user_other{club_name=GuildName,
														club_job=GuildJob,
														pid_guild_map = GuildMapPid,
														guild_map_id = GuildMapID,
														guild_level = GuildLevel,
														guild_furnace_level = FurnaceLevel,
														current_feats = CurrentFeats,
														total_feats = TotalFeats,
														battle_info = BattleInfo},

	NewStatus = Status#ets_users{club_id = GuildID,other_data=Other_data},
	update_map(NewStatus),
	{ok,Bin} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus]),
%% 	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send,Bin),
	mod_map_agent: send_to_area_scene(
									NewStatus#ets_users.current_map_id,
									NewStatus#ets_users.pos_x,
									NewStatus#ets_users.pos_y,
									Bin,
									undefined),
	

	{ok,ELBin} = pt_21:write(?PP_CLUB_WAR_ENEMY_LIST_UPDATE, [EnemyList]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, ELBin),
	{noreply,NewStatus};


% 加入帮会
do_cast({join_guild,GuildID,GuildName,GuildJob,GuildLevel,FurnaceLevel}, Status) ->
	Other_data = Status#ets_users.other_data#user_other{club_name = GuildName,club_job = GuildJob,guild_level = GuildLevel,guild_furnace_level = FurnaceLevel},
	NewStatus = Status#ets_users{club_id = GuildID,other_data=Other_data},
	update_map(NewStatus),
	{ok,Bin} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus]),
%% 	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send,Bin),
	mod_map_agent: send_to_area_scene(
									NewStatus#ets_users.current_map_id,
									NewStatus#ets_users.pos_x,
									NewStatus#ets_users.pos_y,
									Bin,
									undefined),
	lib_target:cast_check_target(Status#ets_users.other_data#user_other.pid_target,[{?TARGET_ADD_GUILD,{0,1}}]),
	{noreply,NewStatus};

% 退出，踢出帮会等
do_cast({guild_kick},Status) ->
	Other_data = Status#ets_users.other_data#user_other{club_name = "",club_job = 0,guild_level = 0, guild_furnace_level = 0},
	NewStatus = Status#ets_users{club_id = 0, other_data = Other_data},
	NewStatus1 =
		if NewStatus#ets_users.pk_mode =:= ?PKMode_CLUB ->
			   AutoStatus = lib_player:change_pk_mode_auto(NewStatus),
			   {ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [AutoStatus#ets_users.pk_mode, misc_timer:now_seconds()]),
			   lib_send:send_to_sid(AutoStatus#ets_users.other_data#user_other.pid_send,BinData),
			   AutoStatus;
		   true ->
			   NewStatus
		end,
	update_map(NewStatus1),
	{ok,Bin} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus1]),
	mod_map_agent: send_to_area_scene(
									NewStatus1#ets_users.current_map_id,
									NewStatus1#ets_users.pos_x,
									NewStatus1#ets_users.pos_y,
									Bin,
									undefined),
%% 	lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send,Bin),
	%%帮会运镖活动中，清掉界面的帮会运镖剩余时间
%% 	case mod_guild:check_guild_transport(NewStatus1#ets_users.club_id) of
%% 		{false} ->
%% 			skip;
%% 		{ok, _GuildTime} ->
%% 			{ok,EscortChatMsg} = pt_24:write(?PP_TASK_START_CLUB_TRANSPORT, 0),
%% 			lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send,EscortChatMsg)
%% 	end,
	%%清除帮派任务
	gen_server:cast(NewStatus1#ets_users.other_data#user_other.pid_task, {'cancel_guild_tasks'}),
	{noreply,NewStatus1};

% 职务变化
do_cast({guild_job_change,Type},Status) ->
	Other_data = Status#ets_users.other_data#user_other{club_job=Type},
	{ok,Bin} = pt_12:write(?PP_MAP_USER_ADD, [Status#ets_users{other_data=Other_data}]),
	
	mod_map_agent: send_to_area_scene(
									Status#ets_users.current_map_id,
									Status#ets_users.pos_x,
									Status#ets_users.pos_y,
									Bin,
									undefined),
%% 	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,Bin),
	{noreply,Status#ets_users{other_data=Other_data}};

%% 帮会等级
do_cast({guild_level_update,Level},Status) ->
	Other_data = Status#ets_users.other_data#user_other{guild_level = Level},
	{noreply,Status#ets_users{other_data=Other_data}};

%% 演武堂等级
do_cast({furnace_level_update,Level},Status) ->
	Other_data = Status#ets_users.other_data#user_other{guild_furnace_level = Level},
	{noreply,Status#ets_users{other_data=Other_data}};

%%其它用户查看该用户的宠物信息
do_cast({'get_pet_info', PetID, PidSend},Status) ->
	case lib_pet:get_pet_by_id(PetID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 ?_LANG_PET_ERROR_NONE]);
		Info ->
			ItemList = gen_server:call(Status#ets_users.other_data#user_other.pid_item, {'get_pet_equip_list', PetID}),
			{ok,Bin} = pt_25:write(?PP_PET_GET_OTHER_PETS,[Info, ItemList]),
			lib_send:send_to_sid(PidSend,Bin)
	end,
	{noreply,Status};

%% 匹配成功后向pvp进程增加用户
do_cast({enter_pvp_duplicate, ActiveId, PVP_Dup_Pid, CampType},PlayerStatus) ->
	UserInfo = #pvp_dup_user_info{
				user_id = PlayerStatus#ets_users.id,
				name = PlayerStatus#ets_users.nick_name,				
				career = PlayerStatus#ets_users.career,
				level = PlayerStatus#ets_users.level,
				camp_type = CampType,
				pid_user = self(),
				pid_send = PlayerStatus#ets_users.other_data#user_other.pid_send},
	gen_server:cast(self(), {'finish_active',PlayerStatus, ?ACTIVE_PVP,0}),
	gen_server:cast(PVP_Dup_Pid, {enter_pvp_duplicate, UserInfo}),
	{ok, Bin} = pt_23:write(?PP_PVP_START, [ActiveId,1]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
	{noreply,PlayerStatus};
%%进入pvp场景
do_cast({enter_pvp_duplicate_map,Map_Pid,PVP_Pid,Map_Only_Id,DuplicateId,Map_Id,X,Y},PlayerStatus) ->
	%?DEBUG("enter_pvp_duplicate_map:~p",[1]),
	mod_map:leave_scene(PlayerStatus#ets_users.id, 
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id, 
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
								PlayerStatus#ets_users.pos_x, 
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid,
								PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),

					Other = PlayerStatus#ets_users.other_data#user_other{
																 pid_map = Map_Pid,
																 walk_path_bin=undefined,
																 pid_dungeon=PVP_Pid,
																 map_template_id = Map_Id,
																 duplicate_id=DuplicateId},
					{OldMapId,OldX,OldY} = case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
						true ->
							{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y};
						_ ->
							{PlayerStatus#ets_users.current_map_id,PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y}
					end,
					NewStatus = PlayerStatus#ets_users{current_map_id=Map_Only_Id,
											   pos_x=X,
											   pos_y=Y,
											   old_map_id = OldMapId,
											   old_pos_x = OldX,
											   old_pos_y = OldY,
											   pk_mode = ?PKMode_FREEDOM,
%% 											   is_horse = 0,
											   other_data=Other},

					NewStatus1 = lib_player:calc_speed(NewStatus, PlayerStatus#ets_users.is_horse),

					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [Map_Id, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
			
					{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_FREEDOM, misc_timer:now_seconds()]),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, BinData),
			
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, DuplicateId),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, ReturnData),	
					
					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus1]),
					mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
									  				NewStatus1#ets_users.pos_x,
									  				NewStatus1#ets_users.pos_y,
									  				PlayerData,
									  				undefined),
					%gen_server:cast(NewStatus1#ets_users.other_data#user_other.pid, {'finish_active',NewStatus1, ?DUPLICATEACTIVE, DuplicateId}),
					update_map(NewStatus1),
					{noreply, NewStatus1};

do_cast({pvp_end, ActiveId, Result, Award}, Status) ->

	if 
		Result =:= 1 ->
			case ActiveId of	
				?PVP1_ACTIVE_ID ->
					lib_target:cast_check_target(Status#ets_users.other_data#user_other.pid_target ,[{?TARGET_PVP,{0,1}}]);
				_ ->
					ok
			end;
		true ->
			ok
	end,

	NewStatus = lib_player:pvp_end(ActiveId, Result, Award, Status),
	{noreply, NewStatus};

do_cast({add_guild_enemy,ID} ,Status) ->	
	SelfGuildEnemy = [{ID}|Status#ets_users.other_data#user_other.battle_info#battle_info.guild_enemy],
	NewBattleInfo = Status#ets_users.other_data#user_other.battle_info#battle_info{guild_enemy = SelfGuildEnemy},
	NewOther = Status#ets_users.other_data#user_other{battle_info = NewBattleInfo},
	NewStatus = Status#ets_users{other_data = NewOther},
	{ok,Bin} = pt_21:write(?PP_CLUB_WAR_ENEMY_LIST_UPDATE, [SelfGuildEnemy]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
	{noreply, NewStatus};

do_cast({remove_guild_enemy,ID} ,Status) ->
	SelfGuildEnemy = lists:keydelete(ID,1,Status#ets_users.other_data#user_other.battle_info#battle_info.guild_enemy),
	NewBattleInfo = Status#ets_users.other_data#user_other.battle_info#battle_info{guild_enemy = SelfGuildEnemy},
	NewOther = Status#ets_users.other_data#user_other{battle_info = NewBattleInfo},
	NewStatus = Status#ets_users{other_data = NewOther},
	{ok,Bin} = pt_21:write(?PP_CLUB_WAR_ENEMY_LIST_UPDATE, [SelfGuildEnemy]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
	{noreply, NewStatus};

do_cast({remove_all_guild_enemy}, Status) ->
	SelfGuildEnemy = [],
	NewBattleInfo = Status#ets_users.other_data#user_other.battle_info#battle_info{guild_enemy = SelfGuildEnemy},
	NewOther = Status#ets_users.other_data#user_other{battle_info = NewBattleInfo},
	NewStatus = Status#ets_users{other_data = NewOther},
	{ok,Bin} = pt_21:write(?PP_CLUB_WAR_ENEMY_LIST_UPDATE, [SelfGuildEnemy]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
	{noreply, NewStatus};

do_cast({publish_token_receive, Type, Award}, Status) ->
	{Copper , BindCopper , Exp } = Award,
	NewStatus1 = lib_player:add_task_award(Status, 0, 0, Copper, BindCopper, Exp, 0, [], 1100002),%%发布获得奖励
	NewTokenInfo = lib_token_task:publish_token_receive(Type, NewStatus1#ets_users.other_data#user_other.token_info),
	NewOther = NewStatus1#ets_users.other_data#user_other{token_info = NewTokenInfo},
	NewStatus = NewStatus1#ets_users{other_data = NewOther},
	case NewStatus#ets_users.level  =/= Status#ets_users.level of
		true ->
			update_map(NewStatus),
			{noreply, NewStatus};
		_ ->
			{noreply, NewStatus}
	end;

%% do_cast({pvp_first_camp_change,Camp},Status) ->
%% 	BattleInfo = Status#ets_users.other_data#user_other.battle_info#battle_info{camp = Camp},
%% 	NewOther = Status#ets_users.other_data#user_other{war_state = Camp, battle_info = BattleInfo},
%% 	NewStatus = Status#ets_users{camp = Camp, other_data = NewOther},
%% 	update_map(NewStatus),
%% 	{ok, Bin} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus]),
%% 	mod_map_agent:send_to_map_scene(NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,NewStatus#ets_users.pos_y,Bin,NewStatus#ets_users.id),
%% 	{noreply, NewStatus};

do_cast({clear_receive_token_task}, Status) ->
	NewStatus = lib_token_task:clear_receive_token_task(Status),
	{noreply, NewStatus};

% 指定角色执行一个操作(函数形式)
do_cast({cast, {M, F, A}}, Status) ->
    case erlang:apply(M, F, [Status|A]) of
        {ok, Status1} ->
%%             save_online(Status1),
			update_map(Status1),
            {noreply, Status1};
        _ ->
            {noreply, Status}
    end;


% 指定角色执行一个事件(函数形式)
do_cast({event, {M, F, A}}, Status) ->
    erlang:apply(M, F, A),
	{noreply, Status};


%% 发送信息到socket端口
do_cast({send_to_sid, Bin}, Status) ->
  	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
    {noreply, Status};

%% 被锁定
do_cast({been_locked, Pid}, Status) ->
	{noreply,save_locked(Status,Pid)};

do_cast({been_locked_target, Pid}, Status) ->
	{noreply, save_locked_target(Status,Pid)};

%% 怪物主动解除锁定 - 同时解除lock 和 targetlock
do_cast({unlock, Pid}, Status) ->
	{noreply,save_unlock(Status,Pid)};

do_cast({unlock_target, Pid}, Status) ->
	{noreply, save_unlock_target(Status,Pid)};

%%双修打坐开始
do_cast({'sit_start', Sit_State, BeInviteID}, Status) ->
 	{_Msg, NewPlayerStatus} = lib_sit:start_sit(Status, Sit_State, BeInviteID),
 	{noreply, NewPlayerStatus};

%%取消双修打坐
%Change_Model 0回复正常 1变为单休
do_cast({'sit_change_state', Double_Sit_ID}, PlayerStatus) ->
	if 
		PlayerStatus#ets_users.other_data#user_other.double_sit_id =:= Double_Sit_ID ->
			NewPlayerStatus = lib_sit:change_sit_state(PlayerStatus, 1, 0);
		true ->
			NewPlayerStatus = PlayerStatus
	end,
 	{noreply, NewPlayerStatus};

%%帮派篝火
do_cast({'guild_bonfire', GuildNum}, PlayerStatus) ->
	if
		PlayerStatus#ets_users.other_data#user_other.sit_state =:= 0 ->
			NewPlayerStatus = PlayerStatus;
		true ->
			case lib_player:add_exp_in_guild_bonfire(GuildNum, PlayerStatus) of
				{ok, Exp} when Exp > 0 ->
					NewPlayerStatus = lib_player:add_exp(PlayerStatus, Exp);
				_ ->
					NewPlayerStatus = PlayerStatus
			end		
	end,
	{noreply, NewPlayerStatus};

%% 帮会福利
do_cast({'guild_weal', Exp},PlayerStatus) ->
	NewPlayerStatus = lib_player:add_exp(PlayerStatus, Exp),
	{noreply, NewPlayerStatus};

do_cast({update_pvp_first, BuffId, Camp},PlayerStatus) ->
	NewStatus = lib_player:update_pvp_first(BuffId, Camp, PlayerStatus),
	update_map(NewStatus),
	{noreply, NewStatus};

%% 增加buf
do_cast({'add_player_buff', BuffId}, PlayerStatus) ->
	NewPlayerStatus = lib_buff:add_buff(BuffId, PlayerStatus),
%% 	case BuffId of
%% 		9000002 ->
%% 			Other = NewPlayerStatus#ets_users.other_data#user_other{ buffTitleId = BuffId};
%% 		9000003 ->
%% 			Other = NewPlayerStatus#ets_users.other_data#user_other{ buffTitleId = BuffId};
%% 		_ ->
%% 			Other = NewPlayerStatus#ets_users.other_data
%% 	end,
%% 	NewPlayerStatus1 = NewPlayerStatus#ets_users{other_data = Other},
	{noreply, NewPlayerStatus};

%% 增加前置buff条件判断如果有前置buff，再增加该buff
do_cast({'add_player_buff_with_check', HavingBuff, AddBuff}, PlayerStatus) ->
	case lib_buff:is_having_buff(HavingBuff, AddBuff, PlayerStatus) of
		true ->
			NewPlayerStatus = lib_buff:add_buff(AddBuff, PlayerStatus);
		false ->
			NewPlayerStatus = PlayerStatus
	end,
	{noreply, NewPlayerStatus};

%% 采集到物品
do_cast({'collect', TemplateId, HP, MP, Exp, LifeExperiences, YuanBao, BindYuanBao, BindCopper, Copper, ItemId}, PlayerStatus) ->
	if
		is_pid(PlayerStatus#ets_users.other_data#user_other.pid_dungeon) =:= true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {collect_buff, TemplateId,
							 PlayerStatus#ets_users.other_data#user_other.pid, PlayerStatus#ets_users.id});
		true ->
			ok
	end,

	NewPlayerStatus = lib_player:collect_item(PlayerStatus, 
											  TemplateId,
											  HP, 
											  MP, 
											  Exp, 
											  LifeExperiences, 
											  YuanBao, 
											  BindYuanBao,
											  BindCopper, 
											  Copper,
											  ItemId),
	{noreply, NewPlayerStatus};

%% 更新技能列表冷却时间
do_cast({'Update_Skill_List',SkillID,StartTime}, PlayerStatus) ->
	case lists:keyfind(SkillID,#r_use_skill.skill_id,PlayerStatus#ets_users.other_data#user_other.skill_list) of
		false -> 
			NewPlayerStatus = PlayerStatus;
		V ->
			L = lists:keyreplace(SkillID,
								 #r_use_skill.skill_id,
								 PlayerStatus#ets_users.other_data#user_other.skill_list,
								 V#r_use_skill{skill_lastusetime = StartTime}),
			OtherData = PlayerStatus#ets_users.other_data#user_other{skill_list = L},
			NewPlayerStatus = PlayerStatus#ets_users{other_data = OtherData}
	end,
	{noreply, NewPlayerStatus};

%% 任务奖励
do_cast({'task_award', YuanBao, BindYuanBao, Copper, BindCopper, Exp, LifeExp, Awards, TaskId}, PlayerStatus) ->
	NewPlayerStatus = lib_player:add_task_award(PlayerStatus, YuanBao, BindYuanBao, Copper, BindCopper, Exp, LifeExp, Awards, TaskId),
	{noreply, NewPlayerStatus};

%% 更新并通知交易状态
do_cast({'trade_change_state', BinData, TradeStatus, TradeList}, PlayerStatus) ->
	NewPlayerStatus = lib_trade:trade_change_state(
						PlayerStatus,
						TradeStatus,
						TradeList),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
%% 	save_online(NewPlayerStatus),
	update_map(NewPlayerStatus),
	{noreply, NewPlayerStatus};

%% 查询物品
do_cast({'item_refer', Pid_send, ItemId}, PlayerStatus) ->
	if is_record(PlayerStatus, ets_users) == true 
		 andalso is_record(PlayerStatus#ets_users.other_data, user_other) == true ->		   
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'item_refer', Pid_send, ItemId});
	   true ->
		   skip
	   end,
	{noreply, PlayerStatus};

do_cast({'trade_money', YuanBao, Copper}, PlayerStatus) ->
	NewPlayerStatus = PlayerStatus#ets_users{yuan_bao = YuanBao, copper = Copper},
%% 	save_online(NewPlayerStatus), 
	update_map(NewPlayerStatus),
	{noreply, NewPlayerStatus};
%更新金钱
%% do_cast({'change_money', OptType, YuanBao, Copper, BindCopper}, PlayerStatus) ->
%% 	NewPlayerStatus = 
%% 		case OptType of
%% 			1 -> %% 是添加
%% 				lib_player:add_cash_and_send(PlayerStatus, YuanBao, Copper, BindCopper);
%% 			2 -> %% 是减少
%% 				lib_player:reduce_cash_and_send(PlayerStatus, YuanBao, Copper, BindCopper);
%% 			_ ->
%% 				PlayerStatus
%% 		end,
%% 	save_online(NewPlayerStatus),
%% 	update(NewPlayerStatus),
%% 	{noreply, NewPlayerStatus};

%% 进入地图后处理
do_cast({get_map_round_info,Pid_Map}, PlayerStatus) ->
	Other = PlayerStatus#ets_users.other_data#user_other{pid_map = Pid_Map,
														 pid_locked_monster = [],
														 pid_locked_target_monster = []},
	NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},
	{noreply, NewPlayerStatus};
	
%%禁言/接禁 （IsBan 1：可以说话  0：禁止说话）
do_cast({'ban_chat', IsBan, BanDate,Reason}, PlayerStatus) ->
	NewPlayerStatus = PlayerStatus#ets_users{ban_chat = IsBan, ban_chat_date = misc_timer:now_seconds() + BanDate * 60},
	if 
		Reason =/= [] ->
			lib_chat:chat_sysmsg_pid([NewPlayerStatus#ets_users.other_data#user_other.pid_send, ?CHAT,?None,?ORANGE,Reason]);
		true ->
			skip
	end,
	{noreply, NewPlayerStatus};


%% 每日奖励,物品模块添加物品成功后回调
do_cast({daily_award}, PlayerStatus) ->
	%NewPlayerStatus = lib_daily_award:get_daily_award_by_item(PlayerStatus),
	{noreply, PlayerStatus };

%% 更新福利中的副本剩余次数
%% do_cast({'update_welfare_duplicate_num', NewNum, NewNum1}, PlayerStatus) ->
%% 	if
%% 		NewNum + NewNum1 > 0 ->
%% 			NewPlayerStatus = lib_welfare:update_welfare_duplicate_num(PlayerStatus,NewNum, NewNum1);
%% 		true ->
%% 			NewPlayerStatus = PlayerStatus
%% 	end,
%% 	{noreply, NewPlayerStatus };

%%禁止登录（IsForbit 1:可以登录 0：禁止登录）
do_cast({'forbid_login', IsForbid, ForBidDate, Reason}, PlayerStatus) ->
  NewPlayerStatus = PlayerStatus#ets_users{forbid = IsForbid, forbid_date = misc_timer:now_seconds() + ForBidDate * 60,
										   forbid_reason = Reason},
  if IsForbid =:= 0 andalso is_record(NewPlayerStatus, ets_users) andalso is_record(NewPlayerStatus#ets_users.other_data, user_other) ->
%% 		 lib_chat:chat_sysmsg_pid([NewPlayerStatus#ets_users.other_data#user_other.pid_send,?ALTER, ?None,?ORANGE,?_LANG_FORBID_LOGIN]),
		 {stop, normal, NewPlayerStatus};
	   true ->
		 {noreply, NewPlayerStatus}
	end;

%% 更新运镖剩余时间
do_cast({'update_escort_time', EscortTime}, Status) ->
	NewStatus = Status#ets_users{darts_left_time=EscortTime},
	update_map(NewStatus),
	{noreply, NewStatus};

%%运镖过程中更新信息
do_cast({'update_escort_info', FinishTime, Speed, AwareExp, AwareCorper, EscortState}, Status) ->
	NewStatus = lib_player:update_escort_info(Status, FinishTime, Speed, AwareExp, AwareCorper, EscortState),
	update_map(NewStatus),
	{noreply, NewStatus};

%%运镖退出时更新界面样式
do_cast({'cancel_escort'}, Status) ->
	NewStatus = lib_player:cancel_escort(Status),
 	update_map(NewStatus),
	{noreply, NewStatus};
%% 拉镖完成
do_cast({'finish_escort', Experience, Copper}, Status) ->
	NewStatus = lib_player:finish_escort(Status, Experience, Copper),
 	update_map(NewStatus),
	{noreply, NewStatus};
%% 拉镖被杀
do_cast({'kill_escort', AttackerPid, AttName, Exp, Copper, AttType}, Status) ->
	NewStatus = lib_player:kill_escort(Status, AttackerPid, AttName, Exp, Copper, AttType),
 	update_map(NewStatus),
	{noreply, NewStatus};
	

%%劫镖者获得奖励
do_cast({'add_rob_aware', AwardCopper}, Status) ->
	case lib_player:check_rob_times(Status, ?Rob_Dart_Times) of
		{ok, PlayerStatus} ->
			lib_player:add_task_award(PlayerStatus, 0, 0, 0, AwardCopper, 0, 0, [], 555202),
			Msg = ?GET_TRAN(?_LANG_TASK_CARGO_ROB_SUCCESS,[]), 
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, ?EVENT, ?None, ?ORANGE, Msg]),
			NewStatus = PlayerStatus;
		false ->
			Msg = ?GET_TRAN(?_LANG_TASK_CARGO_ROB_LIMIT, [?Rob_Dart_Times]),
			lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send, ?FLOAT, ?None, ?ORANGE, Msg]),
			NewStatus = Status
	end,
	{noreply, NewStatus};

%%更新神魔令使用次数
do_cast({'update_shenmo_times', ShenmoTimes}, Status) ->
	NewStatus = Status#ets_users{shenmo_times=ShenmoTimes},
	{noreply, NewStatus};

%%更新副本中关卡通过奖励
do_cast({'add_duplicate_award', AwardList}, Status) ->
	NewStatus = lib_player:add_duplicate_award(AwardList, Status),
	{noreply, NewStatus};


%% 时间到离开副本 
do_cast({'quit_duplicate_timeout'}, Status) ->
	case lib_duplicate:quit_duplicate(Status) of
		{ok, NewStatus} ->
			update(NewStatus),
			{noreply, NewStatus};
		_ ->
			{noreply, Status}
	end;

%% 时间到离开战场
do_cast({'quit_war_timeout'}, Status) ->
	%?DEBUG("quit_war_timeout :~p", [Status#ets_users.current_map_id]),
	if Status#ets_users.current_map_id =:= ?RESOURCE_WAR_MAP_ID ->
		case pp_battle:handle(?PP_ACTIVE_RESOURCE_WAR_QUIT, Status, []) of
			{update_map, NewStatus} ->				
				update(NewStatus),
				{noreply, NewStatus};
			_er ->
				?DEBUG("quit_war_timeout :~p", [_er]),
				{noreply, Status}
		end;
	Status#ets_users.current_map_id =:= ?PVP_FIRST_MAP_ID ->
		case pp_battle:handle(?PP_ACTIVE_PVP_FIRST_QUIT, Status, []) of
			{update_map, NewStatus} ->	
							
				update(NewStatus),
				{noreply, NewStatus};
			_er ->
				?DEBUG("quit_war_timeout :~p", [_er]),
				{noreply, Status}
		end;
	Status#ets_users.current_map_id =:= ?ACTIVE_MONSTER_MAP_ID ->
		case pp_battle:handle(?PP_ACTIVE_MONSTER_QUIT, Status, []) of
			{update_map, NewStatus} ->	
							
				update(NewStatus),
				{noreply, NewStatus};
			_er ->
				?DEBUG("quit_war_timeout :~p", [_er]),
				{noreply, Status}
		end;
	Status#ets_users.current_map_id =:= ?ACTIVE_GUILD_FIGHT_MAP_ID ->
		case pp_battle:handle(?PP_ACTIVE_GUILD_FIGHT_QUIT, Status, []) of
			{update_map, NewStatus} ->	
							
				update(NewStatus),
				{noreply, NewStatus};
			_er ->
				?DEBUG("quit_war_timeout :~p", [_er]),
				{noreply, Status}
		end;
	Status#ets_users.current_map_id =:= ?ACTIVE_KING_FIGHT_MAP_ID ->
		case pp_battle:handle(?PP_ACTIVE_KING_FIGHT_QUIT, Status, []) of
			{update_map, NewStatus} ->	
							
				update(NewStatus),
				{noreply, NewStatus};
			_er ->
				?DEBUG("quit_war_timeout :~p", [_er]),
				{noreply, Status}
		end;
	true ->
			{noreply, Status}
	end;

do_cast({'quit_pvp_first_timeout',Data}, Status) ->
	case pp_battle:handle(?PP_ACTIVE_PVP_FIRST_QUIT, Status, []) of
			{update_map, NewStatus} ->	
				lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Data),
				update(NewStatus),
				{noreply, NewStatus};
			_er ->
				?DEBUG("quit_pvp_first_timeout :~p", [_er]),
				{noreply, Status}
	end;


%% 	{noreply, Status};
%% 	case lib_duplicate:quit_duplicate(Status) of
%% 		{ok, NewStatus} ->
%% 			{noreply, NewStatus};
%% 		_ ->
%% 			{noreply, Status}
%% 	end;
%%玩家充值
do_cast({'user_pay', PayInfo}, Status) ->
	NewStatus = lib_player:user_buy_item_qq(PayInfo,Status),
	{noreply, NewStatus};
%%联运充值接口
do_cast({'unite_pay', UserName,Site,ServerId}, Status) ->
	if	Status#ets_users.server_id =:= ServerId ->
			NewStatus = lib_player:unite_pay(Status);
		true ->
			NewStatus = Status
	end,
	{noreply, NewStatus};

%%重新登录更新镖车品质
do_cast({'update_escort_state', EscortState}, Status) ->
	Other_data = Status#ets_users.other_data#user_other{escort_state=EscortState},
	NewStatus = Status#ets_users{other_data = Other_data},
	{noreply, NewStatus};

%% 起身
%% do_cast({standup, Time, Standup}, Status) ->
%% 	erlang:send_after(Time, self(), {standup, Standup}),
%% 	{noreply, Status};	

do_cast({standup}, Status) ->
	OtherData = Status#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_FIGHT},
	NewPlayer = Status#ets_users{other_data = OtherData},
	{noreply, NewPlayer};

do_cast({common_fight}, Status) ->
	OtherData = Status#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_INVINCIBLE},
	NewPlayer = Status#ets_users{other_data = OtherData},
	{noreply, NewPlayer};

%%帮会运镖，重新登录时显示运镖剩余时间
do_cast({'update_guild_tran_time', GuildTime}, Status) ->
	{ok,BinChatMsg} = pt_24:write(?PP_TASK_START_CLUB_TRANSPORT, GuildTime),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,BinChatMsg),
	{noreply, Status};

%%巡逻活动开始
do_cast({start_patrol,UserId,Group,Award}, Status) ->
	if
		Status#ets_users.id =:= UserId andalso Status#ets_users.other_data#user_other.active_id =:= ?PATROL_ACTIVE_ID->
			{ok, Bin} = pt_23:write(?PP_ACTIVE_PATROL_START, [Group,1]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
			NewState = Status#ets_users.other_data#user_other{active_start_time = misc_timer:now_seconds(),active_award = Award};
		true ->
			NewState = Status
	end,
	{noreply, NewState};

do_cast({test_info}, Status) ->
	?DEBUG("test_info:~p",[Status#ets_users.other_data#user_other.buff_titleId]),
	{noreply, Status};

do_cast({'set_mulexp', ExpRate}, Status) ->
	Other = Status#ets_users.other_data#user_other{sys_exp_rate = ExpRate},
	NewStatus = Status#ets_users{other_data = Other},
	{noreply, NewStatus};

do_cast({'free_war_award',Awards, Exp, Honor}, Status) ->
 	NewStatus1 = lib_player:add_exp(Status, Exp),
	NewStatus2 = lib_player:add_honor(NewStatus1, Honor),
	if length(Awards) > 0 ->
		gen_server:cast(Status#ets_users.other_data#user_other.pid_item,{'add_free_awards', 
																	 Awards, 
																	 Status#ets_users.user_name,
																	 Status#ets_users.id});
	   true ->
		   skip
	end,
	{noreply, NewStatus2};
%%更新排行榜用户个人信息
do_cast({'update_top_user'}, Status) ->
%% 	TopUserInfo = #top_user_info{user_id = Status#ets_users.id,
%% 								name = Status#ets_users.nick_name,
%% 								vip = Status#ets_users.vip_id,
%% 								vip_time = Status#ets_users.vip_date,
%% 								sex = Status#ets_users.sex,
%% 								career = Status#ets_users.career,
%% 								guild_name = Status#ets_users.other_data#user_other.club_name},
%% 	lib_top:update_top_user_info(TopUserInfo),
	{noreply, Status};

do_cast({'finish_active',PlayerStatus,Type,Id}, Status) ->
 	lib_active:finish_active(PlayerStatus,Type,Id),
	{noreply, Status};

%% 副本结束抽奖
do_cast({'duplicaet_lottery', DuplicateId}, Status) ->
	NewStatus =	lib_duplicate:duplicate_lottery(DuplicateId, Status),
	{noreply, NewStatus};
%% 离开副本，发送抽奖机会
do_cast({'quit_duplicate_lottery', DuplicateId}, Status) ->
	{ok,BinData} = pt_12:write(?PP_COPY_LOTTERY, [DuplicateId,0,0]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),
	NewStatus = Status#ets_users{lottery_duplicate_id = DuplicateId},
	{noreply, NewStatus};

%% 发送目标通知
do_cast({'check_target',ConditionList},Status) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_target,{'check_target',ConditionList}),
	{noreply, Status};

	
%% 强化通知
do_cast({'chat_sysmsg_1',Str, ItemId,TemplateId,Level}, Status) ->
	ChatStr = ?GET_TRAN(Str, [Status#ets_users.nick_name,Status#ets_users.id,ItemId,  TemplateId, Level]),
	lib_chat:chat_sysmsg_roll([ChatStr]),
	{noreply, Status};
%% 合成通知
do_cast({'chat_sysmsg_compose',ItemId,TemplateId}, Status) ->
	ChatStr = ?GET_TRAN(?_LANG_NOTICE_COMPOSE, [Status#ets_users.nick_name,Status#ets_users.id,ItemId,  TemplateId]),
	lib_chat:chat_sysmsg_roll([ChatStr]),
	{noreply, Status};

%% 淬炼通知
do_cast({'chat_sysmsg_quench',ItemId,TemplateId}, Status) ->
	ChatStr = ?GET_TRAN(?_LANG_STONE_QUENCH, [Status#ets_users.nick_name,Status#ets_users.id,ItemId,  TemplateId]),
	lib_chat:chat_sysmsg_roll([ChatStr]),
	{noreply, Status};
%% 精炼通知
%% do_cast({'chat_sysmsg_upgrade',ItemId,TemplateId}, Status) ->
%% 	ChatStr = ?GET_TRAN(?_LANG_NOTICE_UPGRADE, [Status#ets_users.nick_name,Status#ets_users.id,ItemId,  TemplateId]),
%% 	lib_chat:chat_sysmsg_roll([ChatStr]),
%% 	{noreply, Status};

%%结婚邀请
do_cast({marry_request,UserId,NickName,Type,Relation,Now}, Status) ->
	lib_marry:marry_request(Status,UserId,NickName,Type,Relation,Now);

do_cast({marry_request_error}, Status) ->
	NewOther = Status#ets_users.other_data#user_other{marry_status = {0,0,0,0}},
	NewStatus = Status#ets_users{other_data = NewOther},
	{noreply, NewStatus};

do_cast({marry_echo,UserId,NickName,Res}, Status) ->
	if Res =/= 1 ->
			NewStatus = lib_marry:marry_echo_no(Status, UserId, NickName, Res);
	   true ->
			NewStatus = lib_marry:marry_echo_yes(Status, UserId, NickName)
	end,
	{noreply, NewStatus};

%进入结婚地图
do_cast({enter_marry_map,Map_Pid,Marry_Pid,Map_Only_Id,DuplicateId,Map_Id,X,Y},PlayerStatus) ->
		NewStatus = lib_marry_duplicate:enter_marry_map(Map_Pid,Marry_Pid,Map_Only_Id,DuplicateId,Map_Id,X,Y,PlayerStatus),
%% 		lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
		update_map(NewStatus),
		{noreply, NewStatus};

%% 增加好友度
do_cast({'add_amity',UserPidSend,UserId,UserNick,FriendId,Amity}, Status) ->
	lib_friend:add_amity(UserPidSend,UserId,UserNick,FriendId,Amity),
	{noreply, Status};

do_cast({'user_equip',Num}, Status) ->
	lib_active_open_server:user_equip(Num,Status),
	{noreply, Status};

do_cast({'add_title',TitleId},Status) ->
	{ok,NewStatus} = lib_player:check_add_title(TitleId,Status),
	{noreply, NewStatus};

do_cast({resource_result, Data, Point},Status) ->	
	NewExploitInfo = lib_exploit:add_exploit(Status#ets_users.other_data#user_other.exploit_info, Point),
	%?DEBUG("resource_result:~p",[{Point,NewExploitInfo#user_exploit_info.exploit}]),
	{ok,Bin1} = pt_23:write(?PP_PVP_EXPLOIT_INFO, [NewExploitInfo]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin1),
	NewOther = Status#ets_users.other_data#user_other{exploit_info = NewExploitInfo},
	NewStatus = Status#ets_users{other_data = NewOther},
	{ok, BinData} = pt_23:write(?PP_ACTIVE_RESOURCE_RESULT, [Point,Data]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),
	{noreply, NewStatus};

do_cast({pvp_first_result, Item1,Item2},Status) ->	
	{ok, BinData} = pt_23:write(?PP_ACTIVE_PVP_FIRST_RESULT, [Item1,Item2]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),
	{noreply, Status};

do_cast({'update_copy_enter_count', List}, Status) ->	
	{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, List),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinDate),
	{noreply, Status};

do_cast({quit_hall, Flag}, Status) ->	%退出结婚礼堂
	NewStatus = lib_marry_duplicate:quit_hall(Status, Flag),
	update_map(NewStatus),
	{noreply, NewStatus};

do_cast({player_break_away},Status) ->
	{ok, NewStatus} = lib_player:player_break_away(Status),
	update(NewStatus),
	{noreply, NewStatus};

do_cast({current_map_fly, X , Y}, Status) -> %飞行到指定位置
	 {ok, NewStatus} = lib_player:use_transfer_shoe(Status, Status#ets_users.current_map_id, X,Y),
	 {noreply, NewStatus};

do_cast({marry_success, UserId, Ring_Id, MarryList}, Status) -> 
	gen_server:cast(Status#ets_users.other_data#user_other.pid_item, {'add_item_or_mail', Ring_Id, 1, ?BIND, Status#ets_users.nick_name,?ITEM_PICK_SYS}),
	NewOther = Status#ets_users.other_data#user_other{marry_list = MarryList},
	NewStatus = Status#ets_users{marry_id = UserId, other_data = NewOther},
	{noreply, NewStatus};

do_cast({update_marry, Type, Send, List}, Status) ->
	if	Type =:= 1 -> %%更新数据
			NewList = List;
		true ->%%删除数据
			if	Status#ets_users.id =:= Status#ets_users.marry_id ->
					NewList = List;
				true ->
					NewList = []
			end
	end,
	NewOther = Status#ets_users.other_data#user_other{marry_list = NewList},
	if	NewList =/= [] ->
			NewStatus = Status#ets_users{other_data = NewOther};
		true ->
			NewStatus = Status#ets_users{marry_id = 0, other_data = NewOther}
	end,
	if	Send =:= true ->
			{ok, Bin1} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus]),
			mod_map_agent:send_to_area_scene(NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,NewStatus#ets_users.pos_y,Bin1);
		true ->
			skip
	end,
	{noreply, NewStatus};

do_cast(Info, State) ->
	?WARNING_MSG("mod_player cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%% 发送信息到socket端口
do_info({send_to_sid, Bin}, Status) ->
  	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
    {noreply, Status};

do_info({'SET_TIME_PLAYER', Interval, Message}, Player) ->
	erlang:send_after(Interval, self(), Message),
	{noreply, Player};

%%发送选择用户信息给客服端
do_info({'select'}, Status) ->
	case  lib_player:get_player_pid(Status#ets_users.id) of
		Pid when Pid =:= self() ->
			{ok, BinData} = pt_20:write(?PP_LOGIN, [Status]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),

			{ok,SysDate} = pt_30:write(?PP_SYS_DATE,misc_timer:now_seconds()),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,SysDate),
			%%用户登录时候就推送副本进入信息
			%gen_server:cast(Status#ets_users.other_data#user_other.pid_duplicate, {'copy_enter_count'}),
			case lib_duplicate:get_dic() of
				[] ->
					{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, []),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinDate);
				List ->
					{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, List),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinDate)
			end,
	
			lib_friend:init_friend(Status#ets_users.id),
	
			%%上线提醒	
			lib_friend:send_friend_state(Status#ets_users.id,
								 Status#ets_users.nick_name,
								 1),
			
			mod_guild:send_guild_member_online(Status#ets_users.id, 
											   Status#ets_users.fight,
											   0,
											   1,
											   Status#ets_users.other_data#user_other.pid, 
											   Status#ets_users.other_data#user_other.pid_send);	
		_ ->
			?WARNING_MSG("double login:~w,~w,~w,~w,~w", [Status#ets_users.id, Status#ets_users.nick_name, Status#ets_users.user_name, Status#ets_users.copper, Status#ets_users.yuan_bao]),
			 stop(self(), 1)
	end,

    {noreply, Status};

%%防沉迷检测，玩家在线时间检测，
do_info({online_time}, Status) ->
	erlang:send_after(?Online_Time_Tick, self(), {online_time}),
	TempOnlineTime =  ?Online_Time_Tick/1000,
	PacketErrorCount = 
		case Status#ets_users.other_data#user_other.sum_packet / TempOnlineTime  > 5 of
			true ->
				Status#ets_users.other_data#user_other.sum_packet_error + 1;
			_ ->
				Status#ets_users.other_data#user_other.sum_packet_error
		end,
			
	case PacketErrorCount  > 50 of
		true ->
			?WARNING_MSG("sum_packet:~w,~w", [Status#ets_users.id, Status#ets_users.other_data#user_other.sum_packet]),
			lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send, ?_LANG_PACKET_FAST]),
			%gen_server:cast(Status#ets_users.other_data#user_other.pid,
			%				 {'forbid_login', 0, 1440, "packet is fast."}),
			stop(self(), "packet is fast."),
			{noreply, Status};
		_ ->		
			TmpTime = misc_timer:now_seconds(),
			if 
				Status#ets_users.other_data#user_other.infant_state =/= 4 ->
					{ok, TempInfantState, LastOnlineDate, OnlineTime1} = lib_infant:check(Status#ets_users.other_data#user_other.pid_send, Status#ets_users.online_time, 
																	  Status#ets_users.other_data#user_other.infant_state, 
																	  Status#ets_users.last_online_date);
				true -> 
					TempInfantState = 4,
					LastOnlineDate = Status#ets_users.last_online_date,
					OnlineTime1 = Status#ets_users.online_time
			end,
			InfantState = TempInfantState,
			OnlineTime = OnlineTime1 + tool:ceil(?Online_Time_Tick/1000),
			Other = Status#ets_users.other_data#user_other{ infant_state = InfantState, sum_packet=0, sum_packet_error=PacketErrorCount},
			%处理pk值
			if Status#ets_users.pk_value > 0 ->
				if Status#ets_users.other_data#user_other.last_pk_auto_update_time =:= 0 ->
						TempStatus = Status#ets_users{other_data=Other#user_other{last_pk_auto_update_time = TmpTime}};	
					
					TmpTime - Status#ets_users.other_data#user_other.last_pk_auto_update_time > ?PK_AUTO_UPDATE_TIME ->
						TmpPkValue = Status#ets_users.pk_value - ?PK_AUTO_UPDATE_VALUE,
						{ok, PKBin} = pt_20:write(?PP_PLAYER_PK_VALUE_CHANGE,[Status#ets_users.id, TmpPkValue]),
						mod_map_agent:send_to_area_scene(Status#ets_users.current_map_id, 
									 Status#ets_users.pos_x, 
									 Status#ets_users.pos_y, 
									 PKBin),
				   		TempStatus = Status#ets_users{pk_value = TmpPkValue,
												 other_data = Other#user_other{last_pk_auto_update_time = TmpTime}};
					true ->
						TempStatus = Status#ets_users{other_data=Other}
				end;
			   true ->
				   TempStatus = Status#ets_users{other_data=Other}
			end,			
			NewStatus = TempStatus#ets_users{
									 online_time = OnlineTime,
 									 last_online_date = LastOnlineDate,
									 total_online_time = TempStatus#ets_users.total_online_time + tool:ceil(?Online_Time_Tick/1000)
									},
			if
				OnlineTime >= 3*3600 ->
					lib_active:finish_active(NewStatus,?ONLINE_TIME,0);
				true ->
					ewStatus
			end,
		{noreply, NewStatus}
	end;
	
%%玩家buff检测
do_info({buff_timer, Time}, Status) ->
	Now = misc_timer:now_milseconds(),
	erlang:send_after(?Buff_Time_Tick, self(),{buff_timer, Now}),	
	
	case length(Status#ets_users.other_data#user_other.buff_list) > 0 of
		true ->
			{RemoveL,NewStatus,NeedSaveEts} = lib_buff:timer_buff_list(Status#ets_users.other_data#user_other.buff_list,
																		   ?ELEMENT_PLAYER,Now,[],[],Status,0),
			case length(RemoveL) > 0 of
				true ->
					lib_buff:send_buff_update(?ELEMENT_PLAYER,NewStatus#ets_users.id,RemoveL,0,
											 NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,
											  NewStatus#ets_users.pos_y, NewStatus#ets_users.other_data#user_other.buff_temp_info);
				_ ->
					skip
			end;
		_ ->
			NeedSaveEts = 0,
			NewStatus = Status
	end,
	
	%%多倍经验buff
	{NewBuffInfo, ExpRate, NeedSaveEts1} = lib_buff:timer_exp_buff_list(
											 NewStatus#ets_users.other_data#user_other.pid_send,
											 NewStatus#ets_users.id,
											 NewStatus#ets_users.other_data#user_other.exp_buff, 1, Now,
											 NewStatus#ets_users.other_data#user_other.buff_temp_info),
	Other1 = NewStatus#ets_users.other_data#user_other{exp_rate = ExpRate, exp_buff = NewBuffInfo},
	NewStatus1 = NewStatus#ets_users{other_data = Other1},
	 
	%%血包buff,魔法buff
	if NewStatus1#ets_users.current_hp > 0 andalso NewStatus1#ets_users.other_data#user_other.player_now_state =/= ?ELEMENT_STATE_DEAD  ->
		   {AddBlood, AddMagic, NewStatus2} = lib_buff:auto_add_hp_mp_buff(NewStatus1),
		   if 
			   AddBlood > 0 orelse AddMagic > 0 ->
				
				NewStatus3 = lib_player:add_hp_and_mp(AddBlood, AddMagic, NewStatus2),
				%%消息广播
				{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[NewStatus3#ets_users.id, 1, ?ELEMENT_PLAYER,AddBlood, AddMagic,
																	 NewStatus3#ets_users.current_hp, 
																	 NewStatus3#ets_users.current_mp]),
				mod_map_agent:send_to_area_scene(NewStatus3#ets_users.current_map_id,
												 NewStatus3#ets_users.pos_x,
												 NewStatus3#ets_users.pos_y,
												 HPMPBin,
												 undefined),
				NeedSaveEts2 = 1;
			  true ->
				   NewStatus3 = NewStatus1,
				   NeedSaveEts2 = 0
		   end;
	   true ->
		   NewStatus3 = NewStatus1,
		   NeedSaveEts2 = 0
	end,
	
	%% 每日奖励
	NewStatus4_1 = NewStatus3,%lib_daily_award:update_daily_award_by_timer(NewStatus3,Time),
	%% 连续登录
	%NewStatus4_1 = lib_welfare:update_daily_login_by_timer(NewStatus4,Time,Now),
	
	%% vip定时
	NewStatus5_1 = case lib_vip:change_dbvip_to_vipid(NewStatus4_1#ets_users.vip_id) =/= ?VIP_NONE of 
					 true ->
						 lib_vip:update_vip_by_timer(NewStatus4_1,Time);
					 _ ->
						 NewStatus4_1
				 end,
	
	{ok, NewStatus5} = lib_player:check_remove_title(NewStatus5_1,Now),
	
	%% 战斗状态定时
	case lib_player:update_now_state(NewStatus5) of
		{ok, NewStatus6} ->
			
			NeedSaveEts3 = 1;
		{_, NewStatus6} ->
			NeedSaveEts3 = 0;
		_ ->
			NewStatus6 = NewStatus5,
			NeedSaveEts3 = 0
	end,	
	
	if NeedSaveEts =:= 1 orelse NeedSaveEts1 =:= 1 orelse NeedSaveEts3 =:= 1 ->
		   BattleInfo = lib_battle:init_battle_data_player(NewStatus6, NewStatus6#ets_users.other_data#user_other.battle_info),
		   BattleOther = NewStatus6#ets_users.other_data#user_other{battle_info = BattleInfo},
		   NewStatus7 = NewStatus6#ets_users{other_data = BattleOther},
		   lib_buff:send_player_info(NewStatus7, 1,0,0),
		   update_map(NewStatus7);
		NeedSaveEts2 =:= 1 ->
		   BattleInfo = lib_battle:init_battle_data_player(NewStatus6, NewStatus6#ets_users.other_data#user_other.battle_info),
		   BattleOther = NewStatus6#ets_users.other_data#user_other{battle_info = BattleInfo},
		   NewStatus7 = NewStatus6#ets_users{other_data = BattleOther},
		   update_map(NewStatus7);
	   true ->
		   NewStatus7 = NewStatus6
	end,
	
	{noreply, NewStatus7};

%%玩家自动恢复检测
do_info({revert_time}, State) ->

	erlang:send_after(?Revert_Time_Tick, self(),{revert_time}),	
	
 	Hp = State#ets_users.other_data#user_other.hp_revert,
 	Mp = State#ets_users.other_data#user_other.mp_revert,	

	if
		State#ets_users.other_data#user_other.sit_state > 0 ->
			NewStatus = State;
		true ->
			NewStatus = lib_player:auto_add_hp_mp(State, Hp, Mp)
	end,

	{noreply, NewStatus};
	
%%打坐修炼添加奖励
do_info({sit_time}, PlayerStatus) ->
	erlang:send_after(?Sit_Time_Tick, self(),{sit_time}),
		
	Sit_State = PlayerStatus#ets_users.other_data#user_other.sit_state,
	AwardTime = lib_sit:get_award_time(Sit_State),
	FactTime = misc_timer:now_seconds() - PlayerStatus#ets_users.other_data#user_other.sit_date,
 	if
 		Sit_State > 0 andalso FactTime >= AwardTime andalso PlayerStatus#ets_users.current_hp >0 ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{sit_date = misc_timer:now_seconds()},
			State = PlayerStatus#ets_users{other_data = OtherData},
			Sit_Award = lib_sit:get_award_by_level(PlayerStatus#ets_users.level, Sit_State),
			case Sit_Award of
				[] ->
					NewPlayerState3 = PlayerStatus;
				{Award_Exp, Temp_Life_Exp, Hp , Mp} ->					
					if 
						State#ets_users.pk_value > ?USER_PK_VALUE ->
							Award_Life_Exp = 0;
						true ->
							Award_Life_Exp = Temp_Life_Exp
					end,						
					NewPlayerState1 = lib_player:add_life_experiences(State, Award_Life_Exp),
					NewPlayerState2 = lib_player:add_exp(NewPlayerState1,Award_Exp),
					NewPlayerState3 = lib_player:auto_add_hp_mp(NewPlayerState2, Hp, Mp)
			end;
 		true ->
 			NewPlayerState3 = PlayerStatus
 	end,
 	{noreply, NewPlayerState3};

%% 更新宠物饥饿度
do_info({pet_update_energy_time}, PlayerStatus) ->
	erlang:send_after(?PET_TIME_TICK, self(),{pet_update_energy_time}),
	case  lib_pet:update_energy(PlayerStatus) of
		{up,PetInfo} ->
			{ok, BinData} = pt_12:write(?PP_MAP_PET_REMOVE, [PetInfo#ets_users_pets.id]),
			mod_map_agent:send_to_area_scene(
									PlayerStatus#ets_users.current_map_id,
									PlayerStatus#ets_users.pos_x,
									PlayerStatus#ets_users.pos_y,
									BinData,
									undefined),
			Other = PlayerStatus#ets_users.other_data#user_other{pet_id=0,pet_template_id=0,style_id=0,pet_nick=undefined},
			NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},

			{noreply, NewPlayerStatus};
		_ ->
			{noreply, PlayerStatus}
	end;

%% 更新活动
do_info({reset_user_active}, Status) ->
 	lib_active:reset_user_data(),
	{noreply, Status};

%%副本神游完成
do_info({shenyou_time_over}, Status) ->
 	NewStatus = lib_shenyou:shenyou_timeover(Status),
	update_map(NewStatus),
	{noreply, NewStatus};

%% 扫描保存
do_info({'scan_time'}, PlayerStatus) ->	
	%% 放在前面发送，防止出错死掉
	erlang:send_after(?SAVE_PLAYER_TICK, self(), {'scan_time'}),
	
	Now = misc_timer:now_seconds(),
	lib_duplicate:save_dic(),
	Other = PlayerStatus#ets_users.other_data#user_other{map_last_time=Now},
	NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},	
	mod_map:update_player(NewPlayerStatus),
	save_player_table(NewPlayerStatus),
	update(NewPlayerStatus),
	
 	{noreply, NewPlayerStatus};

%% 防止多登陆踢掉
do_info({'kick_dup_login'}, Status) ->
	case  lib_player:get_player_pid(Status#ets_users.id) of
		Pid when Pid =:= self() ->
			{noreply, Status};
		_ ->
			?WARNING_MSG("kick_dup_login:~w,~w,~w,~w,~w", [Status#ets_users.id, Status#ets_users.nick_name, Status#ets_users.user_name, Status#ets_users.copper, Status#ets_users.yuan_bao]),
			{stop, "kick_dup_login", Status} 
	end;

%% %% 战斗起身
%% do_info({standup, StandupTime}, State) ->
%% 	NewState =
%% 		case lib_battle:standup(State, StandupTime) of
%% 			{false} ->
%% 				State;
%% 			{ok, NewPlayer} ->
%% 				{ok, StandBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayer]),
%% 				mod_map_agent:send_to_area_scene(NewPlayer#ets_users.current_map_id,
%% 												NewPlayer#ets_users.pos_x,
%% 												NewPlayer#ets_users.pos_y,
%% 												StandBin),
%% 				update_map(NewPlayer),
%% 				NewPlayer
%% 		end,
%% 	{noreply, NewState};

%% 处理节点开启事件
do_info({nodeup, _Node}, Player) ->
	{noreply, Player};

%% 处理节点关闭事件
do_info({nodedown, _Node}, Player) ->
	%% todo 节点被关闭，需要处理组队等问题
	{noreply, Player};


do_info(Info, State) ->
	?WARNING_MSG("mod_player info is not match:~w",[Info]),
    {noreply, State}.


%%---------------------do_terminate--------------------------------
do_terminate(_Reason, Status) ->
	%% 卸载角色数据 
    unload_player_info(Status),	
	misc:delete_monitor_pid(self()),
%% 	lists:foreach(fun(Pid) -> 
%% 						misc:delete_monitor_pid(Pid)
%% 				end, 
%% 				Status#ets_users.other_data#user_other.pid_send),
	
	misc:delete_monitor_pid(Status#ets_users.other_data#user_other.pid_send),
    ok.






