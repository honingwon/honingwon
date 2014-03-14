-module(lib_guild_fight).

-export([create_guild_fight_war/0, enter_guild_fight/7, get_relive_pos/0, login_in_duplicate/2, loop_off_line_list/1,
			kill_player/3, send_guild_fight_award/1, dead_by_buff_offline/2, dead_by_kill/3, kill_monster/3, get_item_by_id/3]).

-include("common.hrl").

-define(TIME_LIMIT_OFF_LINE_IN_WAR, 180).    %% 离线玩家在地图中的保留时间
-define(RELIVE_POS,[{277,546},{285,1463},{2187,1468},{1930,269}]).%%公会乱斗出生坐标222,1411|390,275|2144,1433|2248,389
-define(FLAG_POS,[{499,760},{866,1317},{1439,510},{1867,1354}]). %% 公会乱斗旗帜刷新坐标
-define(MAX_TOP_NUM, 3).			%% 发送击杀前三的公会礼包
-define(TOP1_ITEM_ID, 292705).				%% 霸主公会礼包
%% -define(TOP2_ITEM_ID, 292602).				%% 前二公会礼包
%% -define(TOP3_ITEM_ID, 292603).			%% 第三公会礼包
-define(APPEND_ITEM_ID, 292706).			%% 参与礼包
-define(MAX_BANGGONG, 100).				%% 帮会乱斗获得最大帮贡
-define(GUILD_FIGHT_FLAG, 900000501).		%% 帮会乱斗旗帜ID
-define(GUILD_FIGHT_BUFF, 9000005).		%% 帮会乱斗流血BUFF
-define(GUILD_ITEM_LIST, [{60, 292700}, {3*60, 292701}, {6*60, 292702}, {10*60, 292703}, {14*60, 292704}]). %% 帮会阶段性礼包

create_guild_fight_war() ->
	MapId= ?ACTIVE_GUILD_FIGHT_MAP_ID,
	{Map_pid, _} = mod_map:get_scene_pid(MapId, undefined, undefined),
	gen_server:cast(Map_pid, {load_map}),						%动态加载不会直接加载怪物与采集物				
	lib_chat:chat_sysmsg([?ROLL, ?None, ?GREEN, [?_LANG_CHAT_ACTIVE_GUILD_FIGHT_OPEN]]),
	WarMap = #r_guild_fight{
							 map_only_id = MapId,				%% 地图唯一Id
							 map_id = MapId,					%% 地图Id
						     map_pid = Map_pid,					%% 地图pid
							 war_state = 0
							 },
	WarMap.

%% PlayerPid为用户Pid PidSend为服务端的Pid
enter_guild_fight(UserId, Guild_id, NickName, PlayerPid, PidSend, State, PlayerInfo) ->
	Guild_Name =
	case mod_guild:get_guild_info(Guild_id) of
		{ok,Guild} ->
			Guild#ets_guilds.guild_name;
		_ ->
			""
	end,
	Guild_Info =
	case lists:keyfind(Guild_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
		false ->
			#r_guild_fight_guild{
								guild_id = Guild_id,
								nick_name = Guild_Name
								};
		_  ->
			[]
	end,
	if PlayerInfo =:= false ->
		Player_Info = #r_guild_fight_user{
								user_id = UserId,
								guild_id = Guild_id,
								nick_name = NickName,
								user_pid = PlayerPid, 
								send_pid = PidSend,
								state = 1
								};
	true ->
		Player_Info = PlayerInfo#r_guild_fight_user{user_pid = PlayerPid, send_pid = PidSend, state = 1}
	end,
	{PosX, PosY} = get_relive_pos(),
	{Guild_Info, Player_Info, PosX, PosY}.

get_relive_pos() ->
	Relive = util:rand(1, 4),
	lists:nth(Relive, ?RELIVE_POS).

get_flag_pos() ->
	Flag = util:rand(1, 4),
	lists:nth(Flag, ?RELIVE_POS).

%% 断线重连
login_in_duplicate({UserId, UserPid, SendPid, _VipLevel,_Sex},State) ->
	case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
		false ->
			{reply, {false}, State};
		UserInfo when (UserInfo#r_guild_fight_user.state =:= 0 andalso State#r_guild_fight.war_state =:= 1) ->
			NewInfo = UserInfo#r_guild_fight_user{state = 1, send_pid = SendPid, user_pid = UserPid},
			NewList = lists:keyreplace(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list,NewInfo),
			NewState = State#r_guild_fight{player_list = NewList},
			{reply, {NewState#r_guild_fight.map_pid, NewState#r_guild_fight.map_only_id, 0, NewState#r_guild_fight.map_id}, NewState};
		_er ->		
			{reply, {false}, State}
	end.

%% 更新离线玩家名单
loop_off_line_list(State) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info,List) ->
			if
				Info#r_guild_fight_user.state =:= 0 andalso Info#r_guild_fight_user.offline_time + ?TIME_LIMIT_OFF_LINE_IN_WAR < Now ->
					NewInfo = Info#r_guild_fight_user{state = 2},
					[NewInfo|List];
				true ->
					[Info|List]
			end
		end,
	L = lists:foldl(F, [], State#r_guild_fight.player_list),
	State#r_guild_fight{player_list = L}.

%% 杀死玩家更新公会击杀数目
kill_player(UserId, DeadID, State) ->
	NewState =
	case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
		false ->
			State;
		Player_Info ->
			case lists:keyfind(Player_Info#r_guild_fight_user.guild_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
				false ->
					State;
				Guild_Info ->
					Kill_num = Guild_Info#r_guild_fight_guild.kill_num + 1,
					if Kill_num >= 20 andalso Kill_num rem 10 =:= 0 ->
						Msg = ?GET_TRAN(?_LANG_CHAT_ACTIVE_GUILD_FIGHT_KILL, [Guild_Info#r_guild_fight_guild.nick_name, Kill_num]),
						lib_chat:chat_sysmsg_roll([Msg]);
					true ->
						skip
					end, 
					NewGuild = Guild_Info#r_guild_fight_guild{kill_num = Kill_num},
					NewGuildList = lists:keyreplace(NewGuild#r_guild_fight_guild.guild_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list, NewGuild),					
					State#r_guild_fight{guild_list = NewGuildList}
			end
	end,
	dead_by_kill(UserId, DeadID, NewState).

%% 离线导致的旗帜丢失
dead_by_buff_offline(UserId, State) ->
	if State#r_guild_fight.buff_user_id =:= UserId ->
		{PosX, PosY} = get_flag_pos(),		
		gen_server:cast(State#r_guild_fight.map_pid, {create_boss, ?GUILD_FIGHT_FLAG, PosX, PosY, 0, misc_timer:now_seconds()}),
		NewState1 = stop_guild_time(UserId, State),		
		NewState1#r_guild_fight{buff_user_id = 0, buff_guild_id = 0, buff_guild_name = ""};
	true ->
		State
	end.

%% 被玩家杀死导致的旗帜丢失
dead_by_kill(KillId, DeadId, State) ->
	if State#r_guild_fight.buff_user_id =:= DeadId ->
		case lists:keyfind(KillId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
			false ->
				skip;
			User ->
				gen_server:cast(User#r_guild_fight_user.user_pid, {update_pvp_first, ?GUILD_FIGHT_BUFF, 0})				
		end,
		State1 = stop_guild_time(DeadId, State),
		NewState = start_guild_time(KillId, State1),
		send_new_buff_player(NewState),
		NewState;
	true ->
		State
	end.

%% 杀死旗帜导致的旗帜获取
kill_monster(MonsterId, UserId, State) ->
	if MonsterId =/= ?GUILD_FIGHT_FLAG ->
		State;
		true ->
			case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
				false ->
					State;
				UserInfo ->
					gen_server:cast(UserInfo#r_guild_fight_user.user_pid, {update_pvp_first, ?GUILD_FIGHT_BUFF, 0}),
					State1 = start_guild_time(UserId, State),
					send_new_buff_player(State1),
					State1
			end		
	end.

%% 停止公会计时
stop_guild_time(UserId, State) ->
	case lib_player:get_online_info(UserId) of
			[] ->
				State;
			PlayerState ->
				case lists:keyfind(PlayerState#ets_users.club_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
					false ->
						State;
					GuildInfo ->
						gen_server:cast(PlayerState#ets_users.other_data#user_other.pid, {update_pvp_first, 0, 0}),	
						Now = misc_timer:now_seconds(),
						TotalTime = GuildInfo#r_guild_fight_guild.total_time + Now - GuildInfo#r_guild_fight_guild.old_time,
						NewGuildInfo = GuildInfo#r_guild_fight_guild{total_time = TotalTime, state = 0},
						NewGuildList = lists:keyreplace(PlayerState#ets_users.club_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list, NewGuildInfo),
						State#r_guild_fight{guild_list = NewGuildList}
				end
	end.

%% 启动公会计时
start_guild_time(UserId, State) ->
	case lib_player:get_online_info(UserId) of
			[] ->
				State;
			PlayerState ->
				case lists:keyfind(PlayerState#ets_users.club_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
					false ->
						State;
					GuildInfo ->
						Now = misc_timer:now_seconds(),
						NewGuildInfo = GuildInfo#r_guild_fight_guild{old_time = Now, state = 1},
						NewGuildList = lists:keyreplace(PlayerState#ets_users.club_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list, NewGuildInfo),
						State1 = State#r_guild_fight{guild_list = NewGuildList},
						State1#r_guild_fight{buff_user_id = UserId, buff_guild_id = PlayerState#ets_users.club_id, 
										buff_guild_name = GuildInfo#r_guild_fight_guild.nick_name}
				end
	end.

send_new_buff_player(State) ->
	if State#r_guild_fight.buff_guild_id =/= 0 ->
		Msg = ?GET_TRAN(?_LANG_CHAT_FLAG_GET, [State#r_guild_fight.buff_guild_name]),
		lib_chat:chat_sysmsg_roll([Msg]),
		{ok,Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_THEFIRAST, [State#r_guild_fight.buff_guild_name]),
		mod_map_agent:send_to_scene(State#r_guild_fight.map_only_id, Bin);
	true ->
		{ok,Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_THEFIRAST, [""]),
		mod_map_agent:send_to_scene(State#r_guild_fight.map_only_id, Bin)
	end.

%% 玩家获取阶段性礼包
get_item_by_id(UserId, ItemId, State) ->
	case lists:keyfind(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list) of
		false ->
			State;
		UserInfo ->
			case lists:keyfind(ItemId, 1, UserInfo#r_guild_fight_user.item_recv_list) of
				false ->
					case lists:keyfind(ItemId, 2, ?GUILD_ITEM_LIST) of
						false ->
							State;
						Info ->
							{Time, ItemId} = Info,
							case lists:keyfind(UserInfo#r_guild_fight_user.guild_id, #r_guild_fight_guild.guild_id, State#r_guild_fight.guild_list) of
								false ->
									State;
								GuildInfo ->
									if GuildInfo#r_guild_fight_guild.total_time > Time ->
										case lib_player:get_online_info(UserInfo#r_guild_fight_user.user_id) of
											[] ->
												State;
											Status ->
												gen_server:cast(Status#ets_users.other_data#user_other.pid_item, {'add_item_or_mail', ItemId, 1, ?BIND,Status#ets_users.nick_name,?ITEM_PICK_SYS}),
												NewList = [{ItemId}|UserInfo#r_guild_fight_user.item_recv_list],
												NewUserInfo = UserInfo#r_guild_fight_user{item_recv_list = NewList},
												NewUserList = lists:keyreplace(UserId, #r_guild_fight_user.user_id, State#r_guild_fight.player_list, NewUserInfo),
												State#r_guild_fight{player_list = NewUserList}
										end;
									true ->
										State
									end
							end
					end;							
				_ ->
					State
			end
	end.

%% 发送剩余未领取的阶段性物品
send_all_not_get_item(State) ->
	F = fun(GuildInfo) ->
		F2 = fun(Info, List) ->
			{Time, ItemId} = Info,
			if Time =< GuildInfo#r_guild_fight_guild.total_time ->
				[ItemId|List];
			true ->
				List
			end
		end,
		%% 当前公会可以领取的阶段性物品
		List1 = lists:foldl(F2, [], ?GUILD_ITEM_LIST),
		F3 = fun(UserInfo) ->
			if GuildInfo#r_guild_fight_guild.guild_id =:= UserInfo#r_guild_fight_user.guild_id ->
				case lib_player:get_online_info(UserInfo#r_guild_fight_user.user_id) of
					[] ->
						skip;
					Status ->
						F1 = fun(ItemId) ->
							case lists:keyfind(ItemId, 1, UserInfo#r_guild_fight_user.item_recv_list) of
								false ->
									gen_server:cast(Status#ets_users.other_data#user_other.pid_item, {'add_item_or_mail', ItemId, 1, ?BIND,Status#ets_users.nick_name,?ITEM_PICK_SYS});
								_ ->
									skip
							end
						end,
						%% 发送还没被领取的物品
						lists:foreach(F1, List1)
				end;
			true ->
				skip
			end
		end,
		%% 遍历玩家列表发送物品
		lists:foreach(F3, State#r_guild_fight.player_list)
	end,
	lists:foreach(F, State#r_guild_fight.guild_list).
		
					

%% 发送公会乱斗礼包
send_guild_fight_award(State) ->
	send_all_not_get_item(State),
	F = fun(X, Y) ->
			X#r_guild_fight_guild.total_time > Y#r_guild_fight_guild.total_time
		end,
	List = lists:sort(F, State#r_guild_fight.guild_list),
	NewList = lists:sublist(List, ?MAX_TOP_NUM),
 	if length(List) > 0 ->
			%%发送第一公会
		   	Info1 = lists:nth(1, NewList),
			if Info1#r_guild_fight_guild.total_time >= 14*60 ->
				send_top_item(?TOP1_ITEM_ID, State#r_guild_fight.player_list, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT1, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE1, 
						Info1#r_guild_fight_guild.guild_id, Info1#r_guild_fight_guild.total_time, 1, NewList);
			true ->
				send_top_item(?APPEND_ITEM_ID, State#r_guild_fight.player_list, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT1, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE1, 
						Info1#r_guild_fight_guild.guild_id, Info1#r_guild_fight_guild.total_time, 1, NewList)
			end;
		true ->
			skip
	end,
%% 	if	length(List) > 1 ->
%% 			%% 发送第二公会
%% 			Info2 = lists:nth(2, NewList),
%% 			send_top_item(?TOP2_ITEM_ID, State#r_guild_fight.player_list, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT1, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE2, 
%% 						Info2#r_guild_fight_guild.guild_id, Info2#r_guild_fight_guild.kill_num, 2, NewList);
%% 		true ->
%% 			skip
%% 	end,		
%% 	if length(List) > 2 ->
%% 			%% 发送第三公会
%% 			Info3 = lists:nth(3, NewList),
%% 			send_top_item(?TOP3_ITEM_ID, State#r_guild_fight.player_list, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT1, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE3, 
%% 						Info3#r_guild_fight_guild.guild_id, Info3#r_guild_fight_guild.kill_num, 3, NewList);
%% 		true ->
%% 			skip
%% 	end,
	if	length(List) > 1 ->
			%% 发送剩余公会
			OtherList = lists:nthtail(1, NewList),
			F1 = fun(Info4) ->
					{Total_Time, Index, _} = get_guild_info_index(List, Info4#r_guild_fight_guild.guild_id),
					send_top_item(?APPEND_ITEM_ID, State#r_guild_fight.player_list, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT2, ?_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE4, 
							Info4#r_guild_fight_guild.guild_id, Total_Time, Index, NewList)
				 end,
			lists:foreach(F1, OtherList);
		true ->
			skip 
	end,
	%% 发送公会乱斗结束公告
	if length(List) =:= 0 ->
			Msg = ?_LANG_CHAT_ACTIVE_GUILD_FIGHT_RESULT1;	
		true ->
			Info_1 = lists:nth(1, NewList),
			Msg = ?GET_TRAN(?_LANG_CHAT_ACTIVE_GUILD_FIGHT_RESULT, [Info_1#r_guild_fight_guild.nick_name])
	end,	
	lib_chat:chat_sysmsg_roll([Msg]).

%% 获取当前所在公会击杀数，排名
get_guild_info_index(List, GuildId) ->
	F = fun(Info, Nums) ->
			{Total, Index, State} = Nums,
			if Info#r_guild_fight_guild.guild_id =:= GuildId ->
					{Info#r_guild_fight_guild.total_time, Index, find};
				State =:= start ->
					{Total, Index + 1, start};
				true ->
					Nums
			end
		end,
	lists:foldl(F, {0, 1, start}, List).

%%发送礼包函数 活动结果, 物品Id, 发送玩家列表， 邮件正文， 邮件标题 乱斗排名前三，帮贡
send_top_item(Item_Id, List, Content, Title, Guild_Id, Total_Time, Index, NewList) ->
	F = fun(Info) ->
			if Info#r_guild_fight_user.guild_id =:= Guild_Id -> 
					case data_agent:item_template_get(Item_Id) of
						Template when is_record(Template, ets_item_template) ->
							MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
							MailItem = item_util:add_item_and_get_id(MailItem1),
							lib_mail:send_GM_items_to_mail([[MailItem], "", Info#r_guild_fight_user.user_id,
														Title, Content]),
							{ok, Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_RESULT, [NewList, Total_Time, Index, Item_Id]),
							lib_send:send_to_sid(Info#r_guild_fight_user.send_pid, Bin),
							BangGong = tool:ceil(Total_Time/60),
							case lib_player:get_online_info(Info#r_guild_fight_user.user_id) of
								[] ->
									skip;
								PlayState ->
									if BangGong =/= 0 ->
										mod_guild:add_guild_feats(PlayState, BangGong, BangGong, 0);
									true ->
										skip
									end
							end;
						[] ->
							ok
					end	;
				true ->
					skip	
			end		
	end,
	lists:foreach(F, List).


