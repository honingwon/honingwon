-module(lib_king_fight).

-include("common.hrl").

-define(TIME_LIMIT_OFF_LINE_IN_WAR, 180).    %% 离线玩家在地图中的保留时间
-define(CAMP_RELIVE_POS,[{3969,2444}, {400,313}]). %%阵营对应出生坐标点
-define(MAX_TOP_NUM, 3).			%% 需要显示积分前三名
-define(VIC_ITEM_ID, 292601).				%% 胜利礼包
-define(JION_ITEM_ID, 292602).				%% 参与礼包
-define(VIC_ADD_MONEY, 30000).				%% 胜利公会财富
-define(FAIL_ADD_MONEY, 10000).				%% 失败公会财富
-define(KING_WAR_HOLD, "坚守住").			%% 坚守住
-define(KING_WAR_TAKE, "强攻下").			%% 强攻下
-define(MAX_GUARD_NUM,10).				%%最大守卫数量
-define(GUARD_ID,[900000404,900000414,900000424]).				%%守卫ID
-define(GUARD_PRICE,[1000,2000,3000]).				%%守卫价格
-define(GUARD_POSITION,[{2286,1542},{2340,1541},{2795,1303},{2851,1305},{2720,1718},{2613,1718},{2665,1685},{2822,1737},{2675,1845},{2651,1774}]).

-export([create_king_fight_war/0, enter_king_war/7, get_relive_pos/1, login_in_duplicate/2, loop_off_line_list/1, init_king_war_info_ets/0,buy_guard/2,change_guard_position/3,add_point/4,
			get_king_war_info/0,update_king_war_info/1,loop_top_list/1, add_point/3, send_king_war_award/1,delete_guard/2,summon_king_war_guard/1,is_king_war_time/0,check_king_map_login/1]).




create_king_fight_war() ->
	MapId= ?ACTIVE_KING_FIGHT_MAP_ID,
	{Map_pid, _} = mod_map:get_scene_pid(MapId, undefined, undefined),			
	Info = lib_king_fight:get_king_war_info(),
	summon_king_war_guard(Map_pid),
	case data_agent:monster_template_get(?KING_FIGHT_ITEM_ID) of
		[] ->
			MonHp = 0;
		MonInfo ->
			MonHp = MonInfo#ets_monster_template.max_hp
	end,
	WarMap = #r_king_war{
							 map_only_id = MapId,				%% 地图唯一Id
							 map_id = MapId,					%% 地图Id
						     map_pid = Map_pid,					%% 地图pid
							 defence_guild_id = Info#ets_king_war_info.defence_guild_id,		%% 防守公会id
							 attack_guild_id = Info#ets_king_war_info.attack_guild_id,		%% 进攻公会id
							 lost_hp = MonHp,						%%圣物生命值
							 war_state = 1
							 },
	if Info#ets_king_war_info.attack_guild_id =:= 0 ->		
			lib_chat:chat_sysmsg([?ROLL, ?None, ?GREEN, [?_LANG_CHAT_ACTIVE_KING_FIGHT_OPEN_FAILD]]),
			WarMap#r_king_war{war_state = 0};
		true ->
			lib_chat:chat_sysmsg([?ROLL, ?None, ?GREEN, [?GET_TRAN(?_LANG_CHAT_ACTIVE_KING_FIGHT_OPEN,[Info#ets_king_war_info.attack_guild_name,Info#ets_king_war_info.defence_guild_name])]]),
			{ok,Bin}= pt_23:write(?PP_ACTIVE_KING_FIGHT_ENTER, []),
			lib_send:send_to_guild_user(Info#ets_king_war_info.defence_guild_id, Bin),
			lib_send:send_to_guild_user(Info#ets_king_war_info.attack_guild_id, Bin),
			WarMap
	end.

%% PlayerPid为用户Pid PidSend为服务端的Pid
enter_king_war(UserId, Guild_id, NickName, PlayerPid, PidSend, Camp, State) ->
	Camp1 = 
	if Guild_id =:= State#r_king_war.attack_guild_id orelse State#r_king_war.defence_guild_id =:= 0 ->
		?KING_FINGHT_ATT_CAMP;
	Guild_id =/= State#r_king_war.defence_guild_id andalso Camp =:= ?KING_FINGHT_ATT_CAMP ->
		?KING_FINGHT_ATT_CAMP;
	true ->
		?KING_FINGHT_DEF_CAMP
	end,
	Player_Info = #r_king_war_user{
								user_id = UserId,
								camp = Camp1,
								nickname = NickName,
								user_pid = PlayerPid, 
								send_pid = PidSend,
								state = 1
								},
	{PosX, PosY} = get_relive_pos(Camp1),
	{Player_Info, PosX, PosY}.

get_relive_pos(Camp) ->
	Relive = Camp - 5,
	lists:nth(Relive, ?CAMP_RELIVE_POS).

%% 断线重连
login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State) ->
	case lists:keyfind(UserId, #r_king_war_user.user_id, State#r_king_war.player_list) of
		false ->
			?DEBUG("!!",[]),
			{reply, {false}, State};
		UserInfo when (State#r_king_war.war_state =:= 1) ->%UserInfo#r_king_war_user.state =:= 0 andalso 
			?DEBUG("!!",[]),
			NewInfo = UserInfo#r_king_war_user{state = 1, send_pid = SendPid, user_pid = UserPid},
			NewList = lists:keyreplace(UserId, #r_king_war_user.user_id, State#r_king_war.player_list,NewInfo),
			NewState = State#r_king_war{player_list = NewList},
			{reply, {NewState#r_king_war.map_pid, NewState#r_king_war.map_only_id, 0, NewState#r_king_war.map_id}, NewState};
		_er ->			
			?DEBUG("!!",[]),
			{reply, {false}, State}
	end.

%% 更新离线玩家名单
loop_off_line_list(State) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info,List) ->
			if
				Info#r_king_war_user.state =:= 0 andalso Info#r_king_war_user.off_line_time + ?TIME_LIMIT_OFF_LINE_IN_WAR < Now ->
					List;
				true ->
					[Info|List]
			end
		end,
	L = lists:foldl(F, [], State#r_king_war.player_list),
	State#r_king_war{player_list = L}.

%% 获取积分排名前三
loop_top_list(List) ->
	F = fun(X,Y) ->
			X#r_king_war_user.point > Y#r_king_war_user.point
		end,
	NewList = lists:sort(F, List),
	lists:sublist(NewList, ?MAX_TOP_NUM).

add_point(UserId,Point, State) ->
	case lists:keyfind(UserId, #r_king_war_user.user_id, State#r_king_war.player_list) of
		false ->
			State;
		UserInfo ->			
			UserInfo1 = UserInfo#r_king_war_user{point = UserInfo#r_king_war_user.point + Point },
			List1 = lists:keyreplace(UserId, #r_king_war_user.user_id, State#r_king_war.player_list, UserInfo1),
			State#r_king_war{player_list = List1}
	end.

add_point(UserId, DeadId,Point, State) ->
	case lists:keyfind(UserId, #r_king_war_user.user_id, State#r_king_war.player_list) of
		false ->
			State;
		UserInfo ->			
			case lists:keyfind(DeadId, #r_king_war_user.user_id, State#r_king_war.player_list) of
				false ->
					State;
				DeadInfo ->
					EP = if DeadInfo#r_king_war_user.killing_num >= 3 ->
							kill_send_msg(UserInfo,DeadInfo);
						true ->
							0
					end,
					UserInfo1 = UserInfo#r_king_war_user{point = UserInfo#r_king_war_user.point + Point + EP,killing_num= UserInfo#r_king_war_user.killing_num+1},
					killing_send_msg(UserInfo1,DeadInfo),
					DeadInfo1 = DeadInfo#r_king_war_user{killing_num = 0},
					List1 = lists:keyreplace(UserId, #r_king_war_user.user_id, State#r_king_war.player_list, UserInfo1),
					List2 = lists:keyreplace(DeadId, #r_king_war_user.user_id, List1, DeadInfo1),
					State#r_king_war{player_list = List2}
			end
	end.

killing_send_msg(U1,U2) ->
	Lv = 
	if	U1#r_king_war_user.killing_num =:= 3 ->
			1;
		U1#r_king_war_user.killing_num =:= 5 ->
			2;
		U1#r_king_war_user.killing_num =:= 10 ->
			3;
		U1#r_king_war_user.killing_num =:= 20 ->
			4;
		U1#r_king_war_user.killing_num =:= 40 ->
			5;
		U1#r_king_war_user.killing_num >= 50 andalso U1#r_king_war_user.killing_num rem 5 =:= 0 ->
			6;
		true ->
			0
	end,
	if Lv =:= 0 -> skip;
	   true ->
			CampName1 = lists:nth(U1#r_king_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			CampName2 = lists:nth(U2#r_king_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			KILLName = lists:nth(Lv, ?_LANG_KILL_NAME_LIST),
			Msg = ?GET_TRAN(?_LANG_CHAT_RESOURCE_KILLING, [CampName1,U1#r_king_war_user.nickname,CampName2,U2#r_king_war_user.nickname,KILLName]),
			lib_chat:chat_sysmsg_roll([Msg])
	end.

kill_send_msg(U1,U2) ->
	{ExtraPoint,Lv} =
	if	U2#r_king_war_user.killing_num < 3 ->
			{0,0};
		U2#r_king_war_user.killing_num < 5 ->
			{5,1};
		U2#r_king_war_user.killing_num < 10 ->
			{15,2};
		U2#r_king_war_user.killing_num < 20 ->
			{40,3};
		U2#r_king_war_user.killing_num < 40 ->
			{120,4};
		U2#r_king_war_user.killing_num < 50 ->
			{350,5};
		true ->
			{500,6}
	end,
	if Lv =:= 0 ->	ExtraPoint;
	   true ->
			CampName1 = lists:nth(U1#r_king_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			CampName2 = lists:nth(U2#r_king_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			KinghtName = lists:nth(Lv, ?_LANG_KNIGHT_NAME_LIST),
			Msg = ?GET_TRAN(?_LANG_CHAT_RESOURCE_KILL, [CampName1,U1#r_king_war_user.nickname,CampName2,KinghtName,U2#r_king_war_user.nickname,ExtraPoint]),
			lib_chat:chat_sysmsg_roll([Msg]),
			ExtraPoint
	end.

send_king_war_award(State) ->
	%% 为参战双方发放公会财富
	if State#r_king_war.war_result =:= 0 ->
		mod_guild:change_guild_money(State#r_king_war.attack_guild_id, ?VIC_ADD_MONEY, add),
		mod_guild:change_guild_money(State#r_king_war.defence_guild_id, ?FAIL_ADD_MONEY, add),
		%% 更新王城战胜利公会		
		add_king_winner(?KING_WAR_TAKE);
	true ->
		mod_guild:change_guild_money(State#r_king_war.defence_guild_id, ?VIC_ADD_MONEY, add),
		mod_guild:change_guild_money(State#r_king_war.attack_guild_id, ?FAIL_ADD_MONEY, add),
		%% 更新王城战胜利公会
		add_king_winner(?KING_WAR_HOLD)
	end,
	F1 = fun(X,Y) ->
			X#r_king_war_user.point > Y#r_king_war_user.point
		end,
	NewList = lists:sort(F1, State#r_king_war.player_list),
	%% 为玩家发送帮贡和物品奖励
	F = fun(Info, Index) ->
			case  lib_player:get_online_info(Info#r_king_war_user.user_id) of
				[] ->
					skip;
				PlayState ->
					if PlayState#ets_users.club_id =:= 0 ->
						skip;
					true ->
						mod_guild:add_guild_feats(PlayState, Info#r_king_war_user.point * 10, 0, 0)
					end
			end,			
			{ItemId, Title, Content} = get_king_war_item_id(Info#r_king_war_user.camp, State#r_king_war.war_result),
			case data_agent:item_template_get(ItemId) of
				[] ->
					skip;
				Template ->
					MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
					MailItem = item_util:add_item_and_get_id(MailItem1),
					lib_mail:send_sys_mail("GM", 0, Info#r_king_war_user.nickname, Info#r_king_war_user.user_id, [MailItem], ?Mail_Type_GM, Title, Content, 0, Info#r_king_war_user.point * 1000, 0, 0)
			end,
			{ok, Bin} = pt_23:write(?PP_ACTIVE_KING_FIGHT_RESULT, [State#r_king_war.top_list, Info#r_king_war_user.point, Index, ItemId]),
			lib_send:send_to_sid(Info#r_king_war_user.send_pid, Bin),
			Index + 1
		end,
	lists:foldl(F, 1, NewList).

get_king_war_item_id(Camp, War_result) ->
	if (War_result =:= 0 andalso Camp =:= ?KING_FINGHT_ATT_CAMP) orelse (War_result =:= 1 andalso Camp =:= ?KING_FINGHT_DEF_CAMP) ->
		{?VIC_ITEM_ID, ?_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_TITLE1, ?_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_CONTENT1};
	true ->
		{?JION_ITEM_ID, ?_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_TITLE2, ?_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_CONTENT2}
	end.

add_king_winner(SendMsg) ->
	Info = get_king_war_info(),
	Info1 =
	if SendMsg =:= ?KING_WAR_TAKE ->
		Info#ets_king_war_info{defence_guild_id = Info#ets_king_war_info.attack_guild_id,
										  defence_guild_name = Info#ets_king_war_info.attack_guild_name,
										  days = 1,
										  guard_list = []};
	true ->
		Info#ets_king_war_info{days = Info#ets_king_war_info.days+1}
	end,
	MasterName = 
	case mod_guild:get_guild_info(Info1#ets_king_war_info.defence_guild_id) of
		{ok, Guild} ->
			Guild#ets_guilds.master_name;
		_ ->
			""
	end,
	Info2 = 	Info1#ets_king_war_info{attack_guild_id = 0,
													attack_guild_name = "",
													city_master = MasterName},
	update_king_war_info(Info2),
	db_agent_duplicate:delete_king_fight(),
	if Info2#ets_king_war_info.defence_guild_id >0 ->
			%% 向所有人发送王城胜利公会信息
			{ok, Bin} = pt_23:write(?PP_ACTIVE_GET_CITYCRAFT_INFO, ["",Info2#ets_king_war_info.defence_guild_name, Info2#ets_king_war_info.city_master, Info2#ets_king_war_info.days]),
			lib_send:send_to_all(Bin),
			Msg = ?GET_TRAN(?_LANG_CHAT_ACTIVE_KING_FIGHT_RESULT1, [Info2#ets_king_war_info.defence_guild_name, SendMsg]),
			lib_chat:chat_sysmsg([?NOTIC,?None,?ORANGE,Msg]);
		true ->
			lib_chat:chat_sysmsg([?NOTIC,?None,?ORANGE,?_LANG_CHAT_ACTIVE_KING_FIGHT_RESULT2])
	end.

summon_king_war_guard(MapPid) ->
	Info = get_king_war_info(),
	GuardList = Info#ets_king_war_info.guard_list,
	F = fun({P,T},List) ->
		MonsterID = lists:nth(T, ?GUARD_ID),
		{X,Y} = lists:nth(P, ?GUARD_POSITION),
		[{MonsterID,X,Y}|List]
	end,
	NewMonList = lists:foldl(F, [], GuardList),
	gen_server:cast(MapPid, {'create_guard', NewMonList}).

init_king_war_info_ets() ->
	Attack = db_agent_duplicate:get_king_fight_attack(),
	Info = case  Attack of
		[] ->
			#ets_king_war_info{};
		[GuildID,GuildName,_,_] ->
			#ets_king_war_info{attack_guild_id = GuildID,
										attack_guild_name = GuildName};
		E ->
			?DEBUG("ets_king_war_info error ~p",[E]),
			#ets_king_war_info{}
	end,
	Def = db_agent_duplicate:get_king_winner(),
	Info1 = case Def of
		[] ->
			Info;
		[GuildID1,GuildName1,CityMaster,GuildList,Days,_] ->
			Info#ets_king_war_info{defence_guild_id = GuildID1,
											  defence_guild_name = GuildName1,
											  city_master = CityMaster,
											  guard_list = tool:split_string_to_intlist(GuildList),
											  days = Days};
		E1 ->
			?DEBUG("ets_king_war_info error ~p",[E1]),
			Info
	end,	
	ets:insert(?ETS_KING_WAR_INFO, Info1).

check_user_permission(User) ->
	Info = get_king_war_info(),
	case mod_guild:get_guild_user_info(User#ets_users.club_id, User#ets_users.id) of
		[] ->
			{error, ?_LANG_CHAT_GUILD_MSG};
		MemberInfo ->	
			if MemberInfo#ets_users_guilds.member_type =/= ?GUILD_JOB_PRESIDENT
					andalso MemberInfo#ets_users_guilds.member_type =/= ?GUILD_JOB_VICE_PERSIDENT->
				{error, ?_LANG_KING_WAR_NO_PRESIDENT};
			User#ets_users.club_id =/= Info#ets_king_war_info.defence_guild_id ->
				{error,?_LANG_KING_WAR_NOT_KING_GUILD};
			true ->
				{true}
			end
	end.

delete_guard(Position,User) ->
	Info = get_king_war_info(),
	GuildList = Info#ets_king_war_info.guard_list,
	case check_user_permission(User) of 
		{error,Msg} ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]);
		{true} ->
			case lists:keyfind(Position, 1, GuildList) of
				false ->
					skip;
				{P,_} ->	
					GuildList1 = lists:keydelete(P, 1, GuildList),
					NewInfo = Info#ets_king_war_info{guard_list = GuildList1},
					ets:insert(?ETS_KING_WAR_INFO, NewInfo),
					db_agent_duplicate:update_king_winner_guard_list(NewInfo),
					{ok, Bin} = pt_23:write(?PP_ACTIVE_GUARD_INFO, [GuildList1]),
					lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Bin);
				E ->
					?DEBUG("~p",[E])
			end
	end.	

buy_guard(Type,User) ->
	Info = get_king_war_info(),
	GuildList = Info#ets_king_war_info.guard_list,
	case check_user_permission(User) of 
		{error,Msg} ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]);
		{true} ->
			case length(GuildList) of
				?MAX_GUARD_NUM ->
					lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_KING_WAR_MAX_GUARD_NUM]);
				_ ->
					GuildMoney =
					case mod_guild:get_guild_info(User#ets_users.club_id) of
						{false, _1} ->
							0;
						{ok, GuildInfo} ->
							GuildInfo#ets_guilds.money;
						E ->
							?DEBUG("~p",[E])
					end,
					NeedMoney = lists:nth(Type, ?GUARD_PRICE),
					if GuildMoney < NeedMoney ->
						lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY]);
					true ->
						mod_guild:change_guild_money(User#ets_users.club_id, NeedMoney, reduce),
						P = get_empty_position(GuildList,1),
						GuildList1 = lists:append(GuildList,[{P,Type}]),
						NewInfo = Info#ets_king_war_info{guard_list = GuildList1},
						ets:insert(?ETS_KING_WAR_INFO, NewInfo),
						db_agent_duplicate:update_king_winner_guard_list(NewInfo),
						{ok, Bin} = pt_23:write(?PP_ACTIVE_GUARD_INFO, [GuildList1]),
						lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Bin)
					end
			end;
		E ->
			?DEBUG("Error:~p",[E])
	end.

get_empty_position(_,?MAX_GUARD_NUM) ->
	?MAX_GUARD_NUM;
get_empty_position(GuildList,P) ->
	case lists:keyfind(P,1,GuildList) of
		false ->
			P;
		_ ->
			get_empty_position(GuildList,P+1)
	end.


change_guard_position(P1,P2,User) ->
	case check_user_permission(User) of 
		{error,Msg} ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]);
		{true} ->
			Info = get_king_war_info(),
			GuildList = Info#ets_king_war_info.guard_list,
			Guard1 = lists:keyfind(P1, 1, GuildList),
			Guard2 = lists:keyfind(P2, 1, GuildList),
			GuildList2 = 
				if Guard1 =:= false andalso Guard2 =:= false ->
					GuildList;
				Guard1 =:= false andalso Guard2 =/= false ->
					{_,T2} = Guard2,
					lists:keyreplace(P2, 1, GuildList, {P1,T2});
				Guard1 =/= false andalso Guard2 =:= false ->
					{_,T1} = Guard1,
					lists:keyreplace(P1, 1, GuildList, {P2,T1});
				true ->
					{_,T1} = Guard1,
					{_,T2} = Guard2,
					GuildList1 = lists:keyreplace(P1, 1, GuildList, {P1,T2}),
					lists:keyreplace(P2, 1, GuildList1, {P2,T1})
				end,
			NewInfo = Info#ets_king_war_info{guard_list = GuildList2},
			ets:insert(?ETS_KING_WAR_INFO, NewInfo),
			db_agent_duplicate:update_king_winner_guard_list(NewInfo),
			{ok, Bin} = pt_23:write(?PP_ACTIVE_GUARD_INFO, [GuildList2]),
			lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Bin);
		E ->
			?DEBUG("Error:~p",[E])
	end.

get_king_war_info() ->
	case ets:lookup(?ETS_KING_WAR_INFO, 0) of
		[] ->
			init_king_war_info_ets(),
			?DEBUG("ets_king_war_info error ",[]),
			get_king_war_info();
		[Info] ->
			Info;
		E ->
			?DEBUG("ets_king_war_info error ~p",[E])
	end.

update_king_war_info(Info) ->
	ets:insert(?ETS_KING_WAR_INFO, Info),
	case db_agent_duplicate:get_king_winner_by_id(Info#ets_king_war_info.defence_guild_id) of
		[] ->
			db_agent_duplicate:add_king_winner(Info);
		_->
			db_agent_duplicate:update_king_winner_days(Info)
	end.

is_king_war_time() ->
	Now = misc_timer:now_seconds(),
	{{_, _, _}, {H, M, _}} = util:seconds_to_localtime(Now), 	
	if H>18 andalso H<19 ->
			ture;
		true ->
			false
	end.

check_king_map_login(User) ->
	WarState = is_king_war_time(),
	if User#ets_users.current_map_id =:= 1033 andalso WarState =:= true ->
			BattleInfo = User#ets_users.other_data#user_other.battle_info#battle_info{camp = 0},
			Other = User#ets_users.other_data#user_other{
														 war_state = 0,
														 battle_info = BattleInfo,
														 pid_map = undefined,
														 walk_path_bin=undefined,
														 map_template_id = 1021,
														 player_now_state = ?ELEMENT_STATE_COMMON
														},
			User#ets_users{
								current_map_id = 1021,
								camp = 0,
								pos_x = 2540,
								pos_y = 3540,
								other_data=Other
								};
		true ->
			User#ets_users{camp=0}
	end.