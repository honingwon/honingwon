-module(lib_active_monster).

-export([create_active_monster_war/0, enter_active_monster/5, loop_top_list/1, loop_off_line_list/1, get_relive_pos/0,
			login_in_duplicate/2, send_war_award/1]).

-define(TIME_LIMIT_OFF_LINE_IN_WAR, 180).    %% 离线玩家在地图中的保留时间
-define(MAX_TOP_NUM, 10).					%% 排行榜人数
-define(TOP1_ITEM_ID, 292500).				%% 第一名礼包
-define(TOP10_ITEM_ID, 292501).				%% 前十名礼包
-define(APPEND_ITEM_ID, 292502).			%% 参与礼包
-define(RELIVE_POS, {1459, 1057}).			%% 进入地图的出生点
-define(MIN_COPPER, 10000).
-define(MAX_COPPER1, 600000).

-include("common.hrl").
-include("record.hrl").


create_active_monster_war() ->
	MapId= ?ACTIVE_MONSTER_MAP_ID,
	{Map_pid, _} = mod_map:get_scene_pid(MapId, undefined, undefined),
	gen_server:cast(Map_pid, {load_map}),						%动态加载不会直接加载怪物与采集物
	case data_agent:monster_template_get(?ACTIVE_BOSS_ID) of
		[] ->
			skip;
		MonInfo ->	
			Msg = ?GET_TRAN(?_LANG_CHAT_ACTIVE_MONSTER_OPEN, [MonInfo#ets_monster_template.name]),				
			lib_chat:chat_sysmsg_roll([Msg])
	end, 
	WarMap = #r_active_monster{
							 map_only_id = MapId,				%% 地图唯一Id
							 map_id = MapId,					%% 地图Id
						     map_pid = Map_pid,					%% 地图pid
							 war_state = 0,
							 monster_state = 1
							 },
	WarMap. 

%% 进入活动boss场景
enter_active_monster(UserId, _Fight, NickName, PidSend, PlayerPid) ->
	Info = #r_active_monster_user{user_id = UserId,
						nick_name = NickName,
						user_pid = PidSend, 
						send_pid = PlayerPid,
						state = 1
				},
	{PosX, PosY} = ?RELIVE_POS,
	{Info, PosX, PosY}.

get_relive_pos() ->
	?RELIVE_POS.

%% 断线重连
login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State) ->
	case lists:keyfind(UserId, #r_active_monster_user.user_id, State#r_active_monster.player_list) of
		false ->
%% 			gen_server:cast(UserPid, {'quit_war_timeout'}),
			{reply, {false}, State};
		UserInfo when (UserInfo#r_active_monster_user.state =:= 0 andalso State#r_active_monster.war_state =:= 1) ->
			NewInfo = UserInfo#r_active_monster_user{state = 1, send_pid = SendPid, user_pid = UserPid},
			NewList = lists:keyreplace(UserId, #r_active_monster_user.user_id, State#r_active_monster.player_list,NewInfo),
			NewState = State#r_active_monster{player_list = NewList},
			{reply, {NewState#r_active_monster.map_pid, NewState#r_active_monster.map_only_id, 0, NewState#r_active_monster.map_id}, NewState};
		_er ->			
			{reply, {false}, State}
	end.

%% 获取伤害输出前10
loop_top_list(List) ->
	F = fun(X,Y) ->
			X#r_active_monster_user.damage > Y#r_active_monster_user.damage
		end,
	NewList = lists:sort(F, List),
	lists:sublist(NewList, ?MAX_TOP_NUM).

%% 更新离线玩家名单
loop_off_line_list(State) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info,List) ->
			if
				Info#r_active_monster_user.state =:= 0 andalso Info#r_active_monster_user.offline_time + ?TIME_LIMIT_OFF_LINE_IN_WAR < Now ->
					List;
				true ->
					[Info|List]
			end
		end,
	L = lists:foldl(F, [], State#r_active_monster.player_list),
	State#r_active_monster{player_list = L}.

%% 如果boss死亡 发送第一名豪侠礼包，前十名精英礼包，其他人发送参与礼包，如果没死，就全部发送参与礼包
send_war_award(State)->
	if
		State#r_active_monster.monster_state =:= 0 ->
			[Top1|L] = State#r_active_monster.top_list,
			send_top_item(0, ?TOP1_ITEM_ID, [Top1], ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_CONTENT, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE1),
			send_top_item(0, ?TOP10_ITEM_ID, L, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_CONTENT, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE2), 
			F1 = fun(X,Y) ->
				X#r_active_monster_user.damage > Y#r_active_monster_user.damage
			end,
			if length(State#r_active_monster.player_list) > 10 ->
					NewList = lists:sort(F1, State#r_active_monster.player_list),
					L1 = lists:nthtail(?MAX_TOP_NUM, NewList),
					send_top_item(0, ?APPEND_ITEM_ID, L1, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_CONTENT, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE3);
				true ->
					skip
			end,
			%% 向世界发送活动boss结果
			case data_agent:monster_template_get(?ACTIVE_BOSS_ID) of
				[] ->
					skip;
				MonInfo ->					
					ChatStr = ?GET_TRAN(?_LANG_CHAT_ACTIVE_MONSTER_WIN,[Top1#r_active_monster_user.nick_name, MonInfo#ets_monster_template.name]),
					lib_chat:chat_sysmsg_roll([ChatStr])
			end;
		true ->
			send_top_item(1, ?APPEND_ITEM_ID, State#r_active_monster.player_list, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_CONTENT, ?_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE3),
			%% 向世界发送活动boss结果
			case data_agent:monster_template_get(?ACTIVE_BOSS_ID) of
				[] ->
					skip;
				MonInfo ->	
					Msg = ?GET_TRAN(?_LANG_CHAT_ACTIVE_MONSTER_FAIL, [MonInfo#ets_monster_template.name]),				
					lib_chat:chat_sysmsg_roll([Msg])
			end
	end.

%%发送礼包函数 活动结果, 物品Id, 发送玩家列表， 邮件正文， 邮件标题,  根据伤害量来给玩家发送铜币
send_top_item(Result, Item_Id, List, Content, Title) ->
	F = fun(Info) ->
			case data_agent:item_template_get(Item_Id) of
				Template when is_record(Template, ets_item_template) ->
					MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
					MailItem = item_util:add_item_and_get_id(MailItem1),
					{ok, Bin} = pt_23:write(?PP_ACTIVE_MONSTER_GIFT, [Result, Item_Id]),
					lib_send:send_to_sid(Info#r_active_monster_user.send_pid, Bin),
					TempCopper = Info#r_active_monster_user.damage / 10,
					TempCopper1 = tool:ceil(TempCopper),
					AddCopper =
					if TempCopper1 < ?MIN_COPPER ->
							?MIN_COPPER;
						TempCopper1 > ?MAX_COPPER1 ->
							?MAX_COPPER1;
						true ->
							TempCopper1
					end,
					lib_mail:send_sys_mail("GM", 0, Info#r_active_monster_user.nick_name, Info#r_active_monster_user.user_id, [MailItem], ?Mail_Type_GM, Title, Content, 0, AddCopper, 0, 0);		 
				_ ->
					skip				
			end
		end,
	lists:foreach(F, List).

