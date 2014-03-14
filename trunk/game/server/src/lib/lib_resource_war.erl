%% Author: wangdahai
%% Created: 2013-8-2
%% Description: TODO: Add description to lib_pvp_war
-module(lib_resource_war).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create_resource_war/0,enter_resource_war/6,remove_user_from_camp/2,loop_off_line_list/1,kill_monster_add/3,
			get_user_point/2,send_war_award/1,send_war_result/1,
		collect_point_add/3,loop_top_List/1,loop_quit_limit_list/1,kill_point_add/4,change_war_camp/3,get_relive_pos/1]).

-define(MIN_CAMP_NUM, 5).	%%阵营最少匹配人数
-define(CAMP_RELIVE_POS,[{4061,740},{6147,4340},{657,4377}]). %%阵营对应出生坐标点
-define(TIME_LIMIT_ENTER_WAR, 120).							%% 玩家重新进入战场时间限制
-define(TIME_LIMIT_OFF_LINE_IN_WAR, 180).					%% 离线玩家在阵营中的保留时间
-define(MAX_TOP_NUM, 10).									%% 排行榜最高数量
-define(MAX_AWARD_EXPLOIT_POINT, 30).						%% 最高可获得功勋点数
-define(POINT_TO_EXPLOIT_SCALE, 20).						%% 积分兑换功勋比例20:1
%%
%% API Functions
%%
change_war_camp(UserId, CampType, WarState) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, WarState#r_resource_war.player_list) of
		[] ->
			WarState;
		Info when Info#r_resource_war_user.camp =/= CampType ->
			NewInfo = Info#r_resource_war_user{camp = CampType},
			WarState1 = remove_user_from_camp(Info, WarState),
			WarState2 = add_user_from_camp(NewInfo, WarState1),
			NewList = lists:keyreplace(UserId, #r_resource_war_user.user_id, WarState#r_resource_war.player_list, NewInfo),
			WarState2#r_resource_war{player_list = NewList};
		_ ->
			WarState			
	end.

enter_resource_war(UserId, Fight, NickName, PidSend, PlayerPid, WarState) ->
	CampType = get_camp_id(WarState#r_resource_war.camp1,WarState#r_resource_war.camp2,WarState#r_resource_war.camp3),
	Info = #r_resource_war_user{user_id = UserId,
						camp = CampType,
						nickname = NickName,
						fight = Fight,
						user_pid = PidSend,
						send_pid = PlayerPid
				},
	{PosX,PosY} = lists:nth(CampType, ?CAMP_RELIVE_POS),
	{Info,PosX,PosY}.
	
get_relive_pos(CampType) ->
	if(CampType > 0 andalso CampType < 4) ->
			lists:nth(CampType, ?CAMP_RELIVE_POS);
		true ->
			{}
	end.

get_user_point(UserId, State) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list) of
		false ->
			skip;
		Info ->
			{ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_POINT_ADD, [0, Info#r_resource_war_user.collect_point, Info#r_resource_war_user.kill_point,Info#r_resource_war_user.killing_num]),
			lib_send:send_to_sid(Info#r_resource_war_user.send_pid, Bin)
	end.

remove_user_from_camp(Info, State) ->
	case Info#r_resource_war_user.camp of
		1 ->
			{Camp_Num,Camp_Fight} = State#r_resource_war.camp1,		
			State#r_resource_war{camp1 = {Camp_Num - 1, Camp_Fight - Info#r_resource_war_user.fight},
								 player_count =  State#r_resource_war.player_count - 1};
		2 ->
			{Camp_Num,Camp_Fight} = State#r_resource_war.camp2,		
			State#r_resource_war{camp2 = {Camp_Num - 1, Camp_Fight - Info#r_resource_war_user.fight},
								 player_count =  State#r_resource_war.player_count - 1};
		3 ->
			{Camp_Num,Camp_Fight} = State#r_resource_war.camp3,		
			State#r_resource_war{camp3 = {Camp_Num - 1, Camp_Fight - Info#r_resource_war_user.fight},
								 player_count =  State#r_resource_war.player_count - 1};
		_ ->
			State
	end.

add_user_from_camp(Info, State) ->
	case Info#r_resource_war_user.camp of
		1 ->
			{Camp_Num,Camp_Fight} = State#r_resource_war.camp1,		
			State#r_resource_war{camp1 = {Camp_Num + 1, Camp_Fight + Info#r_resource_war_user.fight},
								 player_count =  State#r_resource_war.player_count + 1};
		2 ->
			{Camp_Num,Camp_Fight} = State#r_resource_war.camp2,		
			State#r_resource_war{camp2 = {Camp_Num + 1, Camp_Fight + Info#r_resource_war_user.fight},
								 player_count =  State#r_resource_war.player_count + 1};
		3 ->
			{Camp_Num,Camp_Fight} = State#r_resource_war.camp3,		
			State#r_resource_war{camp3 = {Camp_Num + 1, Camp_Fight + Info#r_resource_war_user.fight},
								 player_count =  State#r_resource_war.player_count + 1};
		_ ->
			State
	end.

create_resource_war() ->
	MapId= ?RESOURCE_WAR_MAP_ID,
 	%UniqueId = mod_increase:get_free_war_auto_id(),
	%Id = lib_map:create_copy_id(MapId, UniqueId),
	ProcessName = misc:create_process_name(duplicate_p, [MapId, 0]),
	%?DEBUG("ProcessName:~p",[{ProcessName, self()}]),
	misc:register(global, ProcessName, self()),
	misc:write_monitor_pid(self(),?MODULE, {}),
	{Map_pid, _} = mod_map:get_scene_pid(MapId, undefined, undefined),
	gen_server:cast(Map_pid, {load_map}),%动态加载不会直接加载怪物与采集物
	WarMap = #r_resource_war{
							 map_only_id = MapId,				%% 地图唯一Id
							 map_id = MapId,					%% 地图Id
						     map_pid = Map_pid,					%% 地图pid
							 war_state = 0
							 },
	WarMap.

loop_off_line_list(State) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info,{L,S}) ->
			if
				Info#r_resource_war_user.state =:= 0 andalso Info#r_resource_war_user.off_line_time + ?TIME_LIMIT_OFF_LINE_IN_WAR < Now ->
					NewState = remove_user_from_camp(Info, State),
					{L, NewState};
				true ->
					{[Info|L],S}
			end
		end,
	{L,S} = lists:foldl(F, {[],State}, State#r_resource_war.player_list),
	S#r_resource_war{player_list = L}.

loop_quit_limit_list(List) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info,L) ->
			if
				Info#r_resource_war_user.state =:= 11 andalso Info#r_resource_war_user.off_line_time + ?TIME_LIMIT_ENTER_WAR < Now ->
					L;
				true ->
					[Info|L]
			end
		end,
	lists:foldl(F, [], List).

send_war_result(State)->
	Data = pt_23:pack_resource_war_result(State),
	F = fun(Info) ->
			if Info#r_resource_war_user.state =:= 0 ->
					ok;
				true ->
					Point1 = (Info#r_resource_war_user.collect_point + Info#r_resource_war_user.kill_point) div ?POINT_TO_EXPLOIT_SCALE,
					Point = if  Point1 > ?MAX_AWARD_EXPLOIT_POINT -> ?MAX_AWARD_EXPLOIT_POINT;
								true -> Point1 end,
					gen_server:cast(Info#r_resource_war_user.user_pid, {resource_result, Data, Point})
			end
		end,
	lists:foreach(F, State#r_resource_war.player_list).	

collect_point_add(CollectId, UserId, State) ->
	case CollectId of
		1000101 ->
			add_collect_point(UserId, 2, State);
		1000102 ->
			add_collect_point(UserId, 10, State);
		1000103 ->
			add_collect_point(UserId, 1, State);
		1000104 ->
			add_collect_point(UserId, 20, State);
		1000105 ->
			add_collect_point(UserId, 8, State);
		_ ->
			State
	end.

kill_point_add(UserId,DeadID,AddPoint,State) ->
	update_kill_point(UserId, DeadID, AddPoint, State).

kill_monster_add(MonsterId, UserId, State) ->
	TMonsterId = MonsterId div 10,
	Point = 
	case TMonsterId of
		10000010 ->
			200;
		10000011 ->
			200;
		10000012 ->
			200;
		10000013 ->
			100;
		10000014 ->
			200;
		10000020 ->
			1000;
		10000021 ->
			1000;
		10000022 ->
			1000;
		_ ->
			0
	end,
	case data_agent:monster_template_get(MonsterId) of
		[] ->
			State;
		TempMonster ->			
			add_kill_point(UserId, Point, TempMonster, State)
	end.
	

loop_top_List(List) ->
	F = fun(X,Y) ->
			(X#r_resource_war_user.collect_point + X#r_resource_war_user.kill_point) > (Y#r_resource_war_user.collect_point + Y#r_resource_war_user.kill_point)
		end,
	NewList = lists:sort(F, List),
	lists:sublist(NewList, ?MAX_TOP_NUM).

send_war_award(State) ->
	send_war_Top_award(State#r_resource_war.top_list, 1),
	send_war_camp_award(State).
		

%%
%% Local Functions
%%

send_war_camp_award(State) ->
	{C1p,K1p} = State#r_resource_war.camp1Point,
	{C2p,K2p} = State#r_resource_war.camp2Point,
	{C3p,K3p} = State#r_resource_war.camp3Point,
	Camp1Point = C1p + K1p,
	Camp2Point = C2p + K2p,
	Camp3Point = C3p + K3p,
	NumL = if Camp1Point > Camp2Point ->
			if Camp2Point > Camp3Point ->
					[1,2,3];
				Camp1Point> Camp3Point ->
					[1,3,2];
				true ->
					[2,3,1]
			end;
		true ->
			if Camp1Point > Camp3Point ->
					[2,1,3];
				Camp2Point> Camp3Point ->
					[3,1,2];
				true ->
					[3,2,1]
			end
	end,
	send_msg(State,Camp1Point,Camp2Point,Camp3Point),
	F = fun(Info) ->
			Num = lists:nth(Info#r_resource_war_user.camp, NumL),
			case get_camp_award(Num) of
				[] ->skip;
				{ItemList,Content} ->
					lib_mail:send_GM_items_to_mail([ItemList, "", Info#r_resource_war_user.user_id, ?_LANG_MAIL_RESOURCE_WAR_AWARD_TITLE, Content])
			end
		end,
	lists:foreach(F, State#r_resource_war.player_list).

send_msg(State,Camp1Point,Camp2Point,Camp3Point) ->
	Camp= if Camp1Point > Camp2Point ->
			if Camp1Point > Camp3Point ->
					1;
				true ->
					3
			end;
		true ->
			if Camp2Point > Camp3Point ->
					2;
				true ->
					3
			end
	end,
	case State#r_resource_war.top_list of
		[] ->
			skip;
		[Info|_] ->
			CampName = lists:nth(Camp, ?_LANG_CAMP_NAME_LIST),
			Msg = ?GET_TRAN(?_LANG_CHAT_RESOURCE_WAR,[CampName,Info#r_resource_war_user.nickname]),
			lib_chat:chat_sysmsg_roll([Msg])
	end.
	
send_war_Top_award([_], 11) ->
	ok;
send_war_Top_award([],_) ->
	ok;
send_war_Top_award([H|L],Top) ->
	case get_top_award_item(Top) of
		[] ->
			send_war_Top_award(L,Top + 1);
		ItemList ->
			Content = ?GET_TRAN(?_LANG_MAIL_RESOURCE_WAR_AWARD_TOP_CONTENT,[Top]),
			lib_mail:send_GM_items_to_mail([ItemList, "", H#r_resource_war_user.user_id, ?_LANG_MAIL_RESOURCE_WAR_AWARD_TITLE, Content]),
			send_war_Top_award(L,Top + 1)
	end.

get_camp_award(Num) ->
	{Template_id, Content} = case Num of
		1 ->
			{290600,?_LANG_MAIL_RESOURCE_WAR_AWARD_CAMP_CONTENT1};
		2 ->
			{290601,?_LANG_MAIL_RESOURCE_WAR_AWARD_CAMP_CONTENT2};
		3 ->
			{290602,?_LANG_MAIL_RESOURCE_WAR_AWARD_CAMP_CONTENT3}		
	end,
	case data_agent:item_template_get(Template_id) of
		Template when is_record(Template, ets_item_template) ->
			MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
			MailItem = item_util:add_item_and_get_id(MailItem1),
			{[MailItem],Content};
		_ ->
			[]
	end.

get_top_award_item(Top) ->
	Template_id = if
		Top =:= 1 ->
			290603;
		Top =:= 2 ->
			290604;
		Top =:= 3 ->
			290605;
		Top =:= 4 ->
			290606;
		Top =:= 5 ->
			290607;
		true ->
			-1
	end,
	case data_agent:item_template_get(Template_id) of
		Template when is_record(Template, ets_item_template) ->
			MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
			MailItem = item_util:add_item_and_get_id(MailItem1),
			[MailItem];
		_ ->
			[]
	end.

update_kill_point(UserId, DeadId, Point, State) ->		
	{U1, U2, List} = get_users(State#r_resource_war.player_list, UserId, DeadId, {[],[],[]}),
	
	if U1 =:= [] ->
			State;
		true ->
			{ExtraPoint, NewU2} = if U2 =:= [] -> {0,U2};					
				true ->
					EPoint = kill_send_msg(U1,U2),
					{EPoint, U2#r_resource_war_user{killing_num = 0, dead_num = U2#r_resource_war_user.dead_num + 1 }}
			end,
			NewU1 = U1#r_resource_war_user{kill_num = U1#r_resource_war_user.kill_num + 1,
										   killing_num = U1#r_resource_war_user.killing_num + 1,
										   kill_point = U1#r_resource_war_user.kill_point + ExtraPoint + Point},
			{ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_POINT_ADD, [ExtraPoint + Point,NewU1#r_resource_war_user.collect_point, NewU1#r_resource_war_user.kill_point,NewU1#r_resource_war_user.killing_num]),
			lib_send:send_to_sid(NewU1#r_resource_war_user.send_pid, Bin),
			NewList = 
			if	NewU2 =:= [] ->					
					[NewU1|List];
				true ->
					{ok, U2Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_POINT_ADD, [0, NewU2#r_resource_war_user.collect_point, NewU2#r_resource_war_user.kill_point,NewU2#r_resource_war_user.killing_num]),
					lib_send:send_to_sid(NewU2#r_resource_war_user.send_pid, U2Bin),%%更新被击杀玩家的连杀次数
					killing_send_msg(NewU1,NewU2), 
					[NewU1|[NewU2|List]]
			end,
			add_camp_kill_point(NewU1#r_resource_war_user.camp, ExtraPoint + Point, State#r_resource_war{player_list = NewList})
	end.
killing_send_msg(U1,U2) ->
	Lv = 
	if	U1#r_resource_war_user.killing_num =:= 3 ->
			1;
		U1#r_resource_war_user.killing_num =:= 5 ->
			2;
		U1#r_resource_war_user.killing_num =:= 10 ->
			3;
		U1#r_resource_war_user.killing_num =:= 20 ->
			4;
		U1#r_resource_war_user.killing_num =:= 40 ->
			5;
		U1#r_resource_war_user.killing_num >= 50 andalso U1#r_resource_war_user.killing_num rem 5 =:= 0 ->
			6;
		true ->
			0
	end,
	if Lv =:= 0 -> skip;
	   true ->
			CampName1 = lists:nth(U1#r_resource_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			CampName2 = lists:nth(U2#r_resource_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			KILLName = lists:nth(Lv, ?_LANG_KILL_NAME_LIST),
			Msg = ?GET_TRAN(?_LANG_CHAT_RESOURCE_KILLING, [CampName1,U1#r_resource_war_user.nickname,CampName2,U2#r_resource_war_user.nickname,KILLName]),
			lib_chat:chat_sysmsg_roll([Msg])
	end.

kill_send_msg(U1,U2) ->
	{ExtraPoint,Lv} =
	if	U2#r_resource_war_user.killing_num < 3 ->
			{0,0};
		U2#r_resource_war_user.killing_num < 5 ->
			{5,1};
		U2#r_resource_war_user.killing_num < 10 ->
			{15,2};
		U2#r_resource_war_user.killing_num < 20 ->
			{40,3};
		U2#r_resource_war_user.killing_num < 40 ->
			{120,4};
		U2#r_resource_war_user.killing_num < 50 ->
			{350,5};
		true ->
			{500,6}
	end,
	if Lv =:= 0 ->	ExtraPoint;
	   true ->
			CampName1 = lists:nth(U1#r_resource_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			CampName2 = lists:nth(U2#r_resource_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			KinghtName = lists:nth(Lv, ?_LANG_KNIGHT_NAME_LIST),
			Msg = ?GET_TRAN(?_LANG_CHAT_RESOURCE_KILL, [CampName1,U1#r_resource_war_user.nickname,CampName2,KinghtName,U2#r_resource_war_user.nickname,ExtraPoint]),
			lib_chat:chat_sysmsg_roll([Msg]),
			ExtraPoint
	end.


get_users([], _UserId, _DeadId, Data) ->
	Data;
get_users([H|L], UserId, DeadId, {U1,U2,List}) ->
	case H#r_resource_war_user.user_id of
		UserId ->
			if	U2 =:= [] ->
					get_users(L, UserId, DeadId, {H,U2,List});
				true ->
					{H,U2,L++List}
			end;
		DeadId ->
			if	U1 =:= [] ->
					get_users(L, UserId, DeadId, {U1,H,List});
				true ->
					{U1,H,L++List}
			end;
		_ ->
			get_users(L, UserId, DeadId, {U1,U2,[H|List]})
	end.
	

add_kill_point(UserId, Point, MonsterInfo, State) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list) of
		false ->
			State;
		Info ->
			NewInfo = Info#r_resource_war_user{kill_point = Info#r_resource_war_user.kill_point + Point},
			NewList = lists:keyreplace(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list, NewInfo),
			{ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_POINT_ADD, [Point,NewInfo#r_resource_war_user.collect_point, NewInfo#r_resource_war_user.kill_point,NewInfo#r_resource_war_user.killing_num]),
			lib_send:send_to_sid(NewInfo#r_resource_war_user.send_pid, Bin),
			CampName = lists:nth(NewInfo#r_resource_war_user.camp, ?_LANG_CAMP_NAME_LIST),
			Msg = ?GET_TRAN(?_LANG_CHAT_RESOURCE_KILL_BOSS, [CampName,NewInfo#r_resource_war_user.nickname, MonsterInfo#ets_monster_template.name,Point]),
			lib_chat:chat_sysmsg_roll([Msg]),
			add_camp_kill_point(NewInfo#r_resource_war_user.camp, Point, State#r_resource_war{player_list = NewList})
	end.

add_collect_point(UserId, Point, State) ->
	case lists:keyfind(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list) of
		false ->
			State;
		Info ->
			NewInfo = Info#r_resource_war_user{collect_point = Info#r_resource_war_user.collect_point + Point},
			NewList = lists:keyreplace(UserId, #r_resource_war_user.user_id, State#r_resource_war.player_list, NewInfo),
			{ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_POINT_ADD, [Point,NewInfo#r_resource_war_user.collect_point,NewInfo#r_resource_war_user.kill_point,NewInfo#r_resource_war_user.killing_num]),
			lib_send:send_to_sid(NewInfo#r_resource_war_user.send_pid, Bin),
			add_camp_collect_point(NewInfo#r_resource_war_user.camp, Point, State#r_resource_war{player_list = NewList})
	end.

add_camp_kill_point(Camp, Point, State) ->
	case Camp of
		1 ->
			{CPoint,KPoint} = State#r_resource_war.camp1Point,
			State#r_resource_war{camp1Point = {CPoint,KPoint + Point}};
		2 ->
			{CPoint,KPoint} = State#r_resource_war.camp2Point,
			State#r_resource_war{camp2Point = {CPoint,KPoint + Point}};
		3 ->
			{CPoint,KPoint} = State#r_resource_war.camp3Point,
			State#r_resource_war{camp3Point = {CPoint,KPoint + Point}};
		_ ->
			State
	end.

add_camp_collect_point(Camp, Point, State) ->
	case Camp of
		1 ->
			{CPoint,KPoint} = State#r_resource_war.camp1Point,
			State#r_resource_war{camp1Point = {CPoint+ Point,KPoint}};
		2 ->
			{CPoint,KPoint} = State#r_resource_war.camp2Point,
			State#r_resource_war{camp2Point = {CPoint + Point,KPoint}};
		3 ->
			{CPoint,KPoint} = State#r_resource_war.camp3Point,
			State#r_resource_war{camp3Point = {CPoint + Point,KPoint}};
		_ ->
			State
	end.

get_camp_id({Camp1_num,Camp1_fight},{Camp2_num,Camp2_fight},{Camp3_num,Camp3_fight}) ->
	{TempNum, CampType} = 
	if Camp1_num > Camp2_num ->
			if Camp2_num > Camp3_num ->
					{Camp3_num,3};
				true ->
					{Camp2_num,2}
			end;
		true ->
			if Camp1_num > Camp3_num ->
					{Camp3_num, 3};
				true ->
					{Camp1_num, 1}
			end
	end, 
	if TempNum > ?MIN_CAMP_NUM ->
			if Camp1_fight > Camp2_fight ->
				if Camp2_fight > Camp3_fight ->
					3;
				true ->
					2
				end;
			true ->
				if Camp1_fight > Camp3_fight ->
					3;
				true ->
					1
				end
			end;
		true ->
			CampType
	end.
	
