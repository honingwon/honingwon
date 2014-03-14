%% Author: wangdahai
%% Created: 2013-8-2
%% Description: TODO: Add description to lib_pvp_war
-module(lib_pvp_first).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create_pvp_first/0,enter_pvp_first/5,get_pvp_first_result/2,send_new_first/1,
			send_pvp_first_award/1,reset_the_first/2,kill_monster/3,send_pvp_first_buff/1,
		get_relive_pos/0,login_in_duplicate/2,off_line/2,check_pvp_first_kill/5,kill_send_msg/1,
		pvp_first_kill/2,send_pvp_first_award1/3,get_new_first/2,loop/1]).

-define(AWARD_BUFF_FIRST_TIME, 23*3600).
-define(MONSTER_FIRST,900000201). %BUFF怪物
-define(BUFF_FIRST_INACTIVE,9000002).  %天下第一buff活动中
-define(BUFF_FIRST_OUTACTIVE,9000003).  %天下第一buff活动后
-define(PVP_FIRST_AWARD_FIRST,292300).  %天下第一奖励
-define(PVP_FIRST_AWARD_NORMAL,292301).  %参与奖奖励
-define(PVP_FIRST_AWARD_EXP,2000).		%地图中的成员每分钟获得2000exp
-define(RELIVE_POS,[{311,358},{2397,474},{241,1544},{2465,1527}]).%%阵营对应出生坐标点
-define(TIME_LIMIT_ENTER_WAR, 30).							%% 玩家重新进入战场时间限制
-define(TIME_LIMIT_OFF_LINE_IN_WAR, 180).					%% 离线玩家在活动中的保留时间
%% -define(MAX_TOP_NUM, 10).									%% 排行榜最高数量
%% -define(MAX_AWARD_EXPLOIT_POINT, 30).						%% 最高可获得功勋点数
%% -define(POINT_TO_EXPLOIT_SCALE, 20).						%% 积分兑换功勋比例20:1
%%
%% API Functions
%%

enter_pvp_first(UserId, Fight, NickName, PidSend, PlayerPid) ->
	Info = #r_pvp_first_user{user_id = UserId,
						nickname = NickName,
						fight = Fight,
						user_pid = PidSend,
						send_pid = PlayerPid
				},
	{PosX,PosY} = get_relive_pos(),
	{Info,PosX,PosY,?PVP_FIRST_OTHER_CAMP}.
	
get_relive_pos() ->
	Relive = util:rand(1, 4),
	lists:nth(Relive, ?RELIVE_POS).

create_pvp_first() ->
	MapId= ?PVP_FIRST_MAP_ID,
	ProcessName = misc:create_process_name(duplicate_p, [MapId, 0]),
	%?DEBUG("ProcessName:~p",[{ProcessName, self()}]),
	misc:register(global, ProcessName, self()),
	misc:write_monitor_pid(self(),?MODULE, {}),
	{Map_pid, _} = mod_map:get_scene_pid(MapId, undefined, undefined),
	gen_server:cast(Map_pid, {load_map}),%动态加载不会直接加载怪物与采集物
	WarMap = #r_pvp_first{
							 map_only_id = MapId,				%% 地图唯一Id
							 map_id = MapId,					%% 地图Id
						     map_pid = Map_pid,					%% 地图pid
							 war_state = 0						%%							
							 },
	WarMap.

reset_the_first(User,State) ->
	if State#r_pvp_first.war_state =:= 1 andalso State#r_pvp_first.the_first =:= User#r_pvp_first_user.user_id ->
			Msg = ?GET_TRAN(?_LANG_CHAT_PVP_FIRST_QUIT, [User#r_pvp_first_user.nickname]),
					lib_chat:chat_sysmsg_roll([Msg]),
			gen_server:cast(State#r_pvp_first.map_pid, {create_monster, ?MONSTER_FIRST}),			
			NewState = State#r_pvp_first{the_first = 0,the_first_nickname = ""},
			send_new_first(NewState),
			NewState;
		true ->
			NewState = State
	end,
	NewState.

login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State) ->
	case lists:keyfind(UserId, #r_pvp_first_user.user_id, State#r_pvp_first.player_list) of
		false ->
			{reply, {false}, State};
		UserInfo when (UserInfo#r_pvp_first_user.state =:= 0 andalso State#r_pvp_first.war_state =:= 1) ->
			NewInfo = UserInfo#r_pvp_first_user{state = 1, send_pid = SendPid, user_pid = UserPid},
			NewList = lists:keyreplace(UserId, #r_pvp_first_user.user_id, State#r_pvp_first.player_list,NewInfo),
			NewState = State#r_pvp_first{player_list = NewList},
			{reply, {NewState#r_pvp_first.map_pid, NewState#r_pvp_first.map_only_id, 0, NewState#r_pvp_first.map_id}, NewState};
		_er ->			
			%?DEBUG("login in3:~p",[_er]),
			{reply, {false}, State}
	end.

off_line(UserId, State) ->
	case lists:keyfind(UserId, #r_pvp_first_user.user_id, State#r_pvp_first.player_list) of
		false ->
			{noreply, State};
		Info ->				
			State1 = lib_pvp_first:reset_the_first(Info, State),
			NewInfo = Info#r_pvp_first_user{state = 0},
			NewPList = lists:keyreplace(UserId, #r_pvp_first_user.user_id, State1#r_pvp_first.player_list, NewInfo),
			NewState = State1#r_pvp_first{player_list = NewPList},
			{noreply, NewState}
	end.

get_pvp_first_result(User,State) ->
	case User#r_pvp_first_user.user_id =:= State#r_pvp_first.the_first of
		true ->
			pt_23:write(?PP_ACTIVE_PVP_FIRST_RESULT,[?PVP_FIRST_AWARD_FIRST,?PVP_FIRST_AWARD_NORMAL]);
		_ ->
			pt_23:write(?PP_ACTIVE_PVP_FIRST_RESULT,[0,?PVP_FIRST_AWARD_NORMAL])
	end.

%% kill_player(UserId,DeadID,State) ->
%% 	update_kill_player(UserId, DeadID, State).

send_pvp_first_award(State) ->	
	%TheFirstID = State#r_pvp_first.the_first,
	F = fun(Info) ->
			send_pvp_first_award1(?_LANG_MAIL_PVP_FIRST_AWARD_NORMAL,?PVP_FIRST_AWARD_NORMAL,Info#r_pvp_first_user.user_id)
		end,
	lists:foreach(F, State#r_pvp_first.player_list).
		
kill_monster(MonsterId, UserId, State) ->
	if MonsterId =/= ?MONSTER_FIRST ->
		State;
		true ->
			case lists:keyfind(UserId, #r_pvp_first_user.user_id, State#r_pvp_first.player_list) of
				false ->
					State;
				UserInfo ->
					gen_server:cast(UserInfo#r_pvp_first_user.user_pid, {update_pvp_first, ?BUFF_FIRST_INACTIVE, ?PVP_FIRST_FIRST_CAMP}),
%% 					gen_server:cast(UserInfo#r_pvp_first_user.user_pid, {'add_player_buff', ?BUFF_FIRST_INACTIVE}),
					State1 = State#r_pvp_first{the_first = UserId,the_first_pid = UserInfo#r_pvp_first_user.user_pid,
												 the_first_nickname = UserInfo#r_pvp_first_user.nickname},
					kill_send_msg(State1#r_pvp_first.the_first_nickname),
					send_new_first(State1),
					State1
			end		
	end.

send_pvp_first_buff(State) ->	
	case State#r_pvp_first.the_first of
		0 ->			
			lib_chat:chat_sysmsg_roll([?_LANG_CHAT_PVP_FIRST1]);
		ID ->
			lib_sys_first:update_pvp_first(ID, ?AWARD_BUFF_FIRST_TIME),
			?DEBUG("send_pvp_first_buff:~p",[ID]),
			gen_server:cast(State#r_pvp_first.the_first_pid, {'update_pvp_first', ?BUFF_FIRST_OUTACTIVE, 0}),
			send_pvp_first_award1(?_LANG_MAIL_PVP_FIRST_AWARD_FIRST,?PVP_FIRST_AWARD_FIRST,ID),
			Msg = ?GET_TRAN(?_LANG_CHAT_PVP_FIRST,[State#r_pvp_first.the_first_nickname]),
			lib_chat:chat_sysmsg_roll([Msg])			
	end.
get_new_first(State, Pid) ->
	RemainTime = State#r_pvp_first.start_time + State#r_pvp_first.continue_time - misc_timer:now_seconds(),
	{ok,Bin} = pt_23:write(?PP_ACTIVE_PVP_FIRST_THEFIRAST, [RemainTime,State#r_pvp_first.the_first, State#r_pvp_first.the_first_nickname]),
	lib_send:send_to_sid(Pid, Bin).

send_new_first(State) ->
	RemainTime = State#r_pvp_first.start_time + State#r_pvp_first.continue_time - misc_timer:now_seconds(),
	{ok,Bin} = pt_23:write(?PP_ACTIVE_PVP_FIRST_THEFIRAST, [RemainTime,State#r_pvp_first.the_first, State#r_pvp_first.the_first_nickname]),
	mod_map_agent:send_to_scene(State#r_pvp_first.map_only_id, Bin).

check_pvp_first_kill(KillId,Userid,Pid,NickName,State) ->
	if	State#r_pvp_first.war_state =:= 1 andalso State#r_pvp_first.the_first =:= KillId ->
			gen_server:cast(State#r_pvp_first.the_first_pid, {update_pvp_first, 0, ?PVP_FIRST_OTHER_CAMP}),
			NewState = 	State#r_pvp_first{the_first = Userid, the_first_pid = Pid, the_first_nickname = NickName},
			gen_server:cast(self(), {send_new_first}),
			{reply,{ok},NewState};
		true ->
			{reply,{false},State}
	end.

pvp_first_kill(Status, DeadID) ->
	case Status#ets_users.other_data#user_other.map_template_id =:= ?PVP_FIRST_MAP_ID  of
		true ->
			case gen_server:call(Status#ets_users.other_data#user_other.pid_dungeon,
									{'check_pvp_first_kill', DeadID,Status#ets_users.id,self(),Status#ets_users.nick_name}) of
				{false} ->
					ok;
				{ok} ->
					lib_player:update_pvp_first(?BUFF_FIRST_INACTIVE, ?PVP_FIRST_FIRST_CAMP, Status)
			end;
		_ ->
			ok
	end.

loop(State) ->
	F = fun(Info) ->
			if	Info#r_pvp_first_user.state =:= 1 ->
					gen_server:cast(Info#r_pvp_first_user.user_pid, {'guild_weal',?PVP_FIRST_AWARD_EXP});
				true ->
					skip
			end
		end,
	lists:foreach(F, State#r_pvp_first.player_list).
%%
%% Local Functions
%%
send_pvp_first_award1(Content,Template_id,Userid) ->
	case data_agent:item_template_get(Template_id) of
		Template when is_record(Template, ets_item_template) ->
			MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
			MailItem = item_util:add_item_and_get_id(MailItem1),
			lib_mail:send_GM_items_to_mail([[MailItem],"", Userid, ?_LANG_MAIL_PVP_FIRST_AWARD_TITLE, Content]);
		_ ->
			[]
	end.

%% change_war_camp(User, CampType, WarState) ->
%% 	gen_server:cast(User#r_pvp_first_user.user_pid, {pvp_first_camp_change,CampType}),
%% 	WarState.

%% update_kill_player(UserId, DeadId, State) ->		
%% 	{U1, U2, List} = get_users(State#r_pvp_first.player_list, UserId, DeadId, {[],[],[]}),
%% 	TheFirst = State#r_pvp_first.the_first,
%% 	if U1 =:= [] ->
%% 			NewState = State;
%% 		true ->
%% 			if U2#r_pvp_first_user.user_id =:= TheFirst ->
%% 				%%U1加buff,U2自动去buff
%% 				NewState1 = change_war_camp(U1,?FIRST_CAMP,State),
%% 				NewState2 = change_war_camp(U2,?OTHER_CAMP,NewState1),
%% 				NewState = NewState2#r_pvp_first{the_first = UserId,the_first_nickname = U1#r_pvp_first_user.nickname},
%% 				gen_server:cast(U1#r_pvp_first_user.user_pid, {'add_player_buff', ?BUFF_FIRST_INACTIVE}),
%% 				send_new_first(NewState),
%% 				kill_send_msg(U1);
%% 				true ->
%% 					NewState = State
%% 			end				
%% 	end,
%% 	NewState.

kill_send_msg(NickName) ->
	Msg = ?GET_TRAN(?_LANG_CHAT_PVP_FIRST_KILL, [NickName,NickName]),
	lib_chat:chat_sysmsg_roll([Msg]).


get_users([], _UserId, _DeadId, Data) ->
	Data;
get_users([H|L], UserId, DeadId, {U1,U2,List}) ->
	case H#r_pvp_first_user.user_id of
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
	