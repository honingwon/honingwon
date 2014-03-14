%%%-------------------------------------------------------------------
%%% Module  : pp_battle
%%% Author  : 
%%% Description : 战斗
%%%-------------------------------------------------------------------
-module(pp_battle).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================
%% 打断蓄气
handle(?PP_TARGET_ATTACKED_WAITING,PlayerState,[]) ->
	gen_server:cast(PlayerState#ets_users.other_data#user_other.pid_map,
					{battle_cancel_perpare,PlayerState#ets_users.id,?ELEMENT_PLAYER}),
	ok;
%%提交巡逻
handle(?PP_ACTIVE_PATROL_FINISH,PlayerState,[]) ->
	case PlayerState#ets_users.other_data#user_other.active_id of
		?PATROL_ACTIVE_ID ->
			Now = misc_timer:now_seconds(),
			if
				PlayerState#ets_users.other_data#user_other.active_start_time + 40 > Now ->
					ok;
				true ->
					%%发送奖励
					NewStatus = lib_player:add_duplicate_award(PlayerState#ets_users.other_data#user_other.active_award, PlayerState),
					NewOther = NewStatus#ets_users.other_data#user_other{active_id = 0,active_start_time = 0,active_award = []},
					NewPlayerStatus = NewStatus#ets_users{other_data = NewOther},
					{update, NewPlayerStatus}
			end;
		_ ->
			ok
	end;
%%参加巡逻活动
handle(?PP_ACTIVE_PATROL_JOIN,PlayerState,[]) ->
	case PlayerState#ets_users.other_data#user_other.active_id of
		0 when( PlayerState#ets_users.level >= 40) ->
			Active_Pid = mod_active:get_active_pid(),
			case gen_server:call(Active_Pid, {is_active_open, ?PATROL_ACTIVE_ID}) of
				true ->
					UserInfo = {PlayerState#ets_users.id,PlayerState#ets_users.other_data#user_other.pid},
					lib_active_manage:join_active(?PATROL_ACTIVE_ID, PlayerState#ets_users.other_data#user_other.pid_send, UserInfo),
					NewOther = PlayerState#ets_users.other_data#user_other{active_id = ?PATROL_ACTIVE_ID},
					NewPlayerStatus = PlayerState#ets_users{other_data = NewOther},
					{update, NewPlayerStatus};
				false ->
					ok
			end;
		_ ->
			ok
	end;

%%参加pvp活动
handle(?PP_PVP_ACTIVE_JOIN,PlayerState,[ActiveId]) ->
	case PlayerState#ets_users.other_data#user_other.active_id of
		0 when( PlayerState#ets_users.level >= 35 andalso PlayerState#ets_users.other_data#user_other.pid_team =:= undefined) ->%%pvp活动限制等级大于等于40级
			Active_Pid = mod_active:get_active_pid(),
			case gen_server:call(Active_Pid, {is_active_open, ActiveId}) of
				true ->
					UserInfo = #pvp1_user_info{
										user_id = PlayerState#ets_users.id,		%报名用户唯一编号
										user_pid= PlayerState#ets_users.other_data#user_other.pid,			%用户pid		
										career = PlayerState#ets_users.career,			%职业
										level = PlayerState#ets_users.level,			%等级
										fight = PlayerState#ets_users.fight,			%战斗力
										join_time = misc_timer:now_seconds()},
					%gen_server:cast(Active_Pid, {join_active, ActiveId,PlayerState#ets_users.other_data#user_other.pid_send,UserInfo}),
					lib_active_manage:join_active(ActiveId, PlayerState#ets_users.other_data#user_other.pid_send, UserInfo),
					%?DEBUG("PP_PVP_ACTIVE_JOIN:~p",[2]),
					NewOther = PlayerState#ets_users.other_data#user_other{active_id = ActiveId},
					NewPlayerStatus = PlayerState#ets_users{other_data = NewOther},
					{update, NewPlayerStatus};
				false ->
					%?DEBUG("PP_PVP_ACTIVE_JOIN:~p",[3]),
					ok
			end;			
		_ ->
			?DEBUG("PP_PVP_ACTIVE_JOIN:~p",[4]),
			ok
	end;

%%退出pvp活动 
handle(?PP_PVP_ACTIVE_QUIT,PlayerState,[_ActiveId]) ->
	case PlayerState#ets_users.other_data#user_other.active_id of
		0 ->
			NewPlayerStatus = PlayerState;
		ActiveId ->
			Active_Pid = mod_active:get_active_pid(),
			case gen_server:call(Active_Pid, {is_active_open, ActiveId}) of
				true ->
					gen_server:cast(Active_Pid, {quit_active, ActiveId,PlayerState#ets_users.other_data#user_other.pid_send,PlayerState#ets_users.id}),
					NewOther = PlayerState#ets_users.other_data#user_other{active_id = 0},
					NewPlayerStatus = PlayerState#ets_users{other_data = NewOther};
				false ->
					NewPlayerStatus = PlayerState
			end
	end,
	{update, NewPlayerStatus};
%%返回功勋信息
handle(?PP_PVP_EXPLOIT_INFO, PlayerState,[]) ->
	{ok,Bin} = pt_23:write(?PP_PVP_EXPLOIT_INFO, [PlayerState#ets_users.other_data#user_other.exploit_info]),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, Bin),
	ok;
%%返回boss刷新时间
handle(?PP_BOSS_INFO, PlayerState,[]) ->
	Pid = mod_boss_manage:get_boss_manage_pid(),
	gen_server:cast(Pid, {request_boss_info, PlayerState#ets_users.other_data#user_other.pid_send}),
	ok;
%% 通知boss存活数量
handle(?PP_BOSS_ALIVE_NUM, PlayerState,[]) ->
	Pid = mod_boss_manage:get_boss_manage_pid(),
	gen_server:cast(Pid, {request_boss_num, PlayerState#ets_users.other_data#user_other.pid_send}),
	ok;


handle(?PP_ACTIVE_START_TIME_LIST, PlayerState,[]) ->
	gen_server:cast(mod_active:get_active_pid(), {current_active, PlayerState#ets_users.other_data#user_other.pid_send}),
	ok;

handle(?PP_ACTIVE_RESOURCE_TOP_LIST, PlayerStatus,[]) ->
	if
		PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?RESOURCE_WAR_MAP_ID ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {get_top_list, PlayerStatus#ets_users.other_data#user_other.pid_send});
		true ->
			skip
	end;

handle(?PP_ACTIVE_RESOURCE_POINT_ADD, PlayerStatus,[]) ->	
	if
		PlayerStatus#ets_users.camp =/= 0 andalso PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?RESOURCE_WAR_MAP_ID ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {get_user_point, PlayerStatus#ets_users.id});
		true ->
			skip
	end,
	{update, PlayerStatus};

handle(?PP_ACTIVE_RESOURCE_CAMP_CHANGE, PlayerStatus,[Camp]) ->	
	{Res,ErrCode,NewStatus} =
	if
		PlayerStatus#ets_users.camp =:= 0 orelse PlayerStatus#ets_users.other_data#user_other.map_template_id =/= ?RESOURCE_WAR_MAP_ID ->
			{0,?ER_NOT_IN_CAMP_WAR,PlayerStatus};
		Camp > 3 orelse Camp < 1 ->
			{0,?ER_WRONG_VALUE,PlayerStatus};
		PlayerStatus#ets_users.camp =:= Camp ->
			{0,?ER_IS_SAME_CAMP,PlayerStatus};
		PlayerStatus#ets_users.other_data#user_other.war_state =:= 0 ->
			{0,?ER_STATE_BATTLE,PlayerStatus};
		PlayerStatus#ets_users.yuan_bao < ?CHANGE_RESOURCE_WAR_CAMP_PRICE ->
			{0,?ER_NOT_ENOUGH_YUANBAO,PlayerStatus};
		true ->
			%%修改
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {chang_war_camp, PlayerStatus#ets_users.id, Camp}),
			BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{camp = Camp},
			NewOther = PlayerStatus#ets_users.other_data#user_other{war_state = Camp, battle_info = BattleInfo},
			PlayerStatus1 = PlayerStatus#ets_users{camp = Camp, other_data = NewOther},
			{X,Y} = lib_resource_war:get_relive_pos(Camp),
			{ok, PlayerStatus2} = lib_player:use_transfer_shoe(PlayerStatus1, ?RESOURCE_WAR_MAP_ID, X, Y),
			%%传送到指点坐标
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus2, ?CHANGE_RESOURCE_WAR_CAMP_PRICE, 0, 0, 0, {?CONSUME_YUANBAO_CHANGE_WAR_CAMP,Camp,1}),
			{1,0,NewPlayerStatus}			
	end,
	{ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_CAMP_CHANGE, [Res,ErrCode]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
	{update_map, NewStatus};

handle(?PP_ACTIVE_RESOURCE_WAR_QUIT, PlayerStatus,[]) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?RESOURCE_WAR_MAP_ID of
		true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {war_quit, PlayerStatus#ets_users.id}),
			NewStatus = quit_map(PlayerStatus),			
	        {ok, Bin} = pt_23:write(?PP_ACTIVE_RESOURCE_WAR_QUIT, [1, misc_timer:now_seconds()]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update_map, NewStatus};
		
		_ ->
			skip
	end;

handle(?PP_ACTIVE_RESOURCE_WAR_ENTER, PlayerState,[]) ->
	{Map_id, Pos_x, Pos_y} = ?ENTER_RESOURCE_WAR_NPC_POS,
	case PlayerState#ets_users.darts_left_time < 1 of%%运镖期间不能进入副本
		true when(PlayerState#ets_users.current_map_id =:= Map_id 
					andalso abs(PlayerState#ets_users.pos_x - Pos_x) < ?ACCEPT_DISTANT andalso abs(PlayerState#ets_users.pos_y - Pos_y) < ?ACCEPT_DISTANT ) ->
			case mod_resource_war:enter_resource_war(PlayerState) of
				{ok, WarCampType, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY} ->
					NewStatus1 = enter_map(PlayerState, WarCampType, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY, ?PKMode_CAMP, ?RESOURCE_WAR_MAP_ID),			
					{update_map, NewStatus1};
				_er ->
					skip
			end;
		_ ->
			skip
	end;

handle(?PP_ACTIVE_PVP_FIRST_QUIT, PlayerStatus,[]) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?PVP_FIRST_MAP_ID of
		true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {war_quit, PlayerStatus#ets_users.id}),
			NewStatus = quit_map(PlayerStatus),			
	        {ok, Bin} = pt_23:write(?PP_ACTIVE_PVP_FIRST_QUIT, [1, misc_timer:now_seconds()]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update_map, NewStatus};
		
		_ ->
			skip
	end;

handle(?PP_ACTIVE_PVP_FIRST_ENTER, PlayerState,[]) ->
	{Map_id, Pos_x, Pos_y} = ?ENTER_PVP_FIRST_NPC_POS,
	case PlayerState#ets_users.darts_left_time < 1 of%%运镖期间不能进入副本
		true when(PlayerState#ets_users.current_map_id =:= Map_id 
					andalso abs(PlayerState#ets_users.pos_x - Pos_x) < ?ACCEPT_DISTANT andalso abs(PlayerState#ets_users.pos_y - Pos_y) < ?ACCEPT_DISTANT ) ->
			case mod_pvp_first:enter_pvp_first(PlayerState) of
				{ok, WarCampType, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY} ->
					NewStatus1 = enter_map(PlayerState, WarCampType, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY, ?PKMode_CAMP, 0),
					{update_map, NewStatus1};
				_er ->
					skip
			end;
		_ ->
			skip
	end;

handle(?PP_ACTIVE_PVP_FIRST_THEFIRAST, PlayerStatus,[]) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?PVP_FIRST_MAP_ID of
		true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon,
								 {get_the_first, PlayerStatus#ets_users.other_data#user_other.pid_send});
%% 			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {get_the_first}) of 
%% 				{ok, Data} ->
%% 					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Data),
%% 					{update_map, PlayerStatus}	;
%% 				{false, Data} ->
%% 					{update_map, PlayerStatus}	
%% 			end;
		_ ->
			skip
	end;

handle(?PP_ACTIVE_MONSTER_QUIT, PlayerStatus,[]) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?ACTIVE_MONSTER_MAP_ID of
		true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {war_quit, PlayerStatus#ets_users.id}),
			NewStatus = quit_map(PlayerStatus),
			
	        {ok, Bin} = pt_23:write(?PP_ACTIVE_MONSTER_QUIT, [1, misc_timer:now_seconds()]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update_map, NewStatus};
		
		_ ->
			skip
	end;

handle(?PP_ACTIVE_MONSTER_ENTER, PlayerState,[]) ->
	Map_Type = lib_map:get_map_type(PlayerState#ets_users.current_map_id),
	if PlayerState#ets_users.darts_left_time < 1 andalso Map_Type =:= ?DUPLICATE_TYPE_WORLD andalso PlayerState#ets_users.current_map_id =/= ?ACTIVE_MONSTER_MAP_ID->    %%运镖期间不能进入副本
		   lib_duplicate:quit_duplicate(PlayerState#ets_users.other_data#user_other.pid_dungeon,
													PlayerState#ets_users.id,
													PlayerState#ets_users.current_map_id),
			case mod_active_monster:enter_active_monster(PlayerState) of
				{ok, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY} ->
					NewStatus1 = enter_map(PlayerState, 0, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY, ?PKMode_GOODNESS, 0),			
					{update_map, NewStatus1};
				_er ->
					skip
			end;
		true ->
			skip
	end;

handle(?PP_ACTIVE_GUILD_FIGHT_QUIT, PlayerStatus,[]) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?ACTIVE_GUILD_FIGHT_MAP_ID of
		true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {war_quit, PlayerStatus#ets_users.id}),
			NewStatus = quit_map(PlayerStatus),			
	        {ok, Bin} = pt_23:write(?PP_ACTIVE_GUILD_FIGHT_QUIT, [1, misc_timer:now_seconds()]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update_map, NewStatus};
		
		_ ->
			skip
	end;

handle(?PP_ACTIVE_GUILD_FIGHT_ENTER, PlayerState,[]) ->
	Map_Type = lib_map:get_map_type(PlayerState#ets_users.current_map_id),
	if PlayerState#ets_users.darts_left_time < 1 andalso Map_Type =:= ?DUPLICATE_TYPE_WORLD andalso PlayerState#ets_users.club_id =/= 0 ->    %%运镖期间不能进入副本
			case mod_guild_fight:enter_guild_fight(PlayerState) of
				{ok, WarCamp, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY} ->
					NewStatus1 = enter_map(PlayerState, WarCamp, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY, ?PKMode_CLUB, 0),
					{update_map, NewStatus1};
				_er ->
					skip
			end;
		PlayerState#ets_users.club_id =:= 0 ->
			lib_chat:chat_sysmsg_pid([PlayerState#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 ?_LANG_GUILD_FIGHT_NO_GUILD]);
		true ->
			skip
	end;

%% 帮会乱斗玩家获取物品
handle(?PP_ACTIVE_GUILD_FIGHT_ITEM, PlayerState,[ItemId]) ->
	mod_guild_fight:get_item_by_id(PlayerState#ets_users.id, ItemId);

%% 帮会乱斗当前玩家信息
handle(?PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, PlayerState,[]) ->
	mod_guild_fight:get_continue_time(PlayerState#ets_users.id);

handle(?PP_ACTIVE_KING_FIGHT_SIGNUP, PlayerState,[]) ->
	if PlayerState#ets_users.club_id =/= 0 ->
		mod_king_fight_signup:king_fight_sign_up(PlayerState#ets_users.club_id, PlayerState#ets_users.id,PlayerState#ets_users.other_data#user_other.pid_send);
	true ->
		skip
	end;

handle(?PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, PlayerState,[]) ->
	mod_king_fight_signup:get_signup_info(PlayerState#ets_users.club_id, PlayerState#ets_users.other_data#user_other.pid_send);

handle(?PP_ACTIVE_GET_SIGNUP_STATE, PlayerState,[]) ->
	mod_king_fight_signup:get_signup_state(PlayerState#ets_users.other_data#user_other.pid_send);

handle(?PP_ACTIVE_GET_CITYCRAFT_INFO, PlayerState,[]) ->
	Info = lib_king_fight:get_king_war_info(),
	{ok, Bin} = pt_23:write(?PP_ACTIVE_GET_CITYCRAFT_INFO, [Info#ets_king_war_info.attack_guild_name,Info#ets_king_war_info.defence_guild_name, Info#ets_king_war_info.city_master, Info#ets_king_war_info.days]),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, Bin);

handle(?PP_ACTIVE_GUARD_INFO, PlayerState,[]) ->
	Info = lib_king_fight:get_king_war_info(),
	GuardList = Info#ets_king_war_info.guard_list,
	{ok, Bin} = pt_23:write(?PP_ACTIVE_GUARD_INFO, [GuardList]),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, Bin);

handle(?PP_ACTIVE_BUY_GUARD, PlayerState,[Type]) ->
	lib_king_fight:buy_guard(Type, PlayerState);

handle(?PP_ACTIVE_DELETE_GUARD, PlayerState,[Position]) ->
	lib_king_fight:delete_guard(Position, PlayerState);

handle(?PP_ACTIVE_CHANGE_GUARD_POSITION, PlayerState,[P1,P2]) ->
	if P1 =:= P2 ->
			PlayerState;
		true ->
			lib_king_fight:change_guard_position(P1, P2, PlayerState)
	end;

handle(?PP_ACTIVE_KING_FIGHT_QUIT, PlayerStatus,[]) ->
	case PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?ACTIVE_KING_FIGHT_MAP_ID of
		true ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {war_quit, PlayerStatus#ets_users.id}),
			NewStatus = quit_map(PlayerStatus),			
	        {ok, Bin} = pt_23:write(?PP_ACTIVE_KING_FIGHT_QUIT, [1, misc_timer:now_seconds()]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update_map, NewStatus};		
		_ ->
			skip
	end;

handle(?PP_ACTIVE_KING_FIGHT_ENTER, PlayerState,[Camp]) ->
	Map_Type = lib_map:get_map_type(PlayerState#ets_users.current_map_id),
	if Map_Type =/= ?DUPLICATE_TYPE_WORLD ->
			lib_chat:chat_sysmsg_pid([PlayerState#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_KING_WAR_IN_DUPLICATE]);
		PlayerState#ets_users.darts_left_time < 1 andalso Map_Type =:= ?DUPLICATE_TYPE_WORLD ->    %%运镖期间不能进入副本
			case mod_king_fight:enter_king_war(PlayerState, Camp) of
				{ok, WarCamp, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY} ->
					NewStatus1 = enter_map(PlayerState, WarCamp, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY, ?PKMode_CAMP, 0),
					{update_map, NewStatus1};
				_er ->
					case lib_king_fight:is_king_war_time() of
						false ->
							{ok,NewPlayerState} = lib_player:use_transfer_shoe(PlayerState, 1033, 3969, 2444),
							{update_map,NewPlayerState};
						true ->
							skip
					end
			end;
		true ->
			skip
	end;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_battle no match"}.

%% 进入地图
enter_map(PlayerStatus, WarCamp, WarPid, MapPid, OnlyMapId, MapId, PosX, PosY, PkMode, AddBuffID) ->
	lib_team:team_quit(PlayerStatus),
	mod_map:leave_scene(PlayerStatus#ets_users.id, 
						PlayerStatus#ets_users.other_data#user_other.pet_id,
						PlayerStatus#ets_users.current_map_id, 
						PlayerStatus#ets_users.other_data#user_other.pid_map, 
						PlayerStatus#ets_users.pos_x, 
						PlayerStatus#ets_users.pos_y,
						PlayerStatus#ets_users.other_data#user_other.pid,
						PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),	
	BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{camp = 0},				
	Other = PlayerStatus#ets_users.other_data#user_other{
														war_state = WarCamp,
														pid_dungeon = WarPid,
														pid_map = MapPid,
														walk_path_bin=undefined,
														map_template_id = MapId,
														battle_info = BattleInfo,
														duplicate_id = 0},					
	Now =  misc_timer:now_seconds(),
	{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [PkMode, Now]), %% 进入战场强制切换阵营模式，离开的时候强制切回
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinData),
	NewStatus = PlayerStatus#ets_users{current_map_id=OnlyMapId,
										pos_x=PosX,
										pos_y=PosY,
										old_map_id = PlayerStatus#ets_users.current_map_id,
										old_pos_x = PlayerStatus#ets_users.pos_x,
										old_pos_y = PlayerStatus#ets_users.pos_y,
										pk_mode = PkMode,
										pk_mode_change_date = Now,
										camp = WarCamp,
										other_data=Other},
	NewStatus11 = lib_player:calc_speed(NewStatus, 0),
	if AddBuffID =:= 0 ->
		NewStatus1 = NewStatus11;
	true ->
		NewStatus1 = lib_buff:add_buff(AddBuffID, NewStatus11)
	end,
	{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [MapId, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
	lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
	{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus1]),
	mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
									 NewStatus1#ets_users.pos_x,
									 NewStatus1#ets_users.pos_y,
									 PlayerData,
									 undefined),
	NewStatus1.

%% 退出地图
quit_map(PlayerStatus) ->
	mod_map:leave_scene(PlayerStatus#ets_users.id,
						PlayerStatus#ets_users.other_data#user_other.pet_id,
						PlayerStatus#ets_users.current_map_id,
						PlayerStatus#ets_users.other_data#user_other.pid_map,
						PlayerStatus#ets_users.pos_x,
						PlayerStatus#ets_users.pos_y,
						PlayerStatus#ets_users.other_data#user_other.pid,
						PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
	BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{camp = 0},
	Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined,
														war_state = 0,
														buff_titleId = 0,
														pid_map = undefined,
														pid_dungeon = undefined,
														battle_info = BattleInfo,
														map_template_id=PlayerStatus#ets_users.old_map_id
																},
	NewStatus1 = PlayerStatus#ets_users{current_map_id= PlayerStatus#ets_users.old_map_id,
										pos_x=PlayerStatus#ets_users.old_pos_x,
									    pos_y=PlayerStatus#ets_users.old_pos_y,
										camp = 0,											   
										pk_mode = ?PKMode_GOODNESS,
									    other_data=Other},
	NewStatus = lib_buff:remove_buff(NewStatus1,1), 
	{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_GOODNESS, NewStatus#ets_users.pk_mode_change_date]), %% 退出战场强制切换善恶模式
	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send,BinData),
	{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewStatus#ets_users.current_map_id, NewStatus#ets_users.pos_x, NewStatus#ets_users.pos_y]),
	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, EnterData),
	NewStatus.
%%====================================================================
%% Private functions
%%====================================================================


