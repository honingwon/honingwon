%% Author: Administrator
%% Created: 2011-3-5
%% Description: TODO: Add description to pp_map
-module(pp_map).
%%
%% Include files
%%
-include("common.hrl").

-define(Enter_VipMap_1, [1019, 6757, 4609]).  %%进入vip地图坐标(30-40)
-define(Enter_VipMap_2, [1020, 1937, 587]).   %%进入vip地图坐标(40-60) 

-define(Quit_VipMap, [1021,3552,2451]).   


%%
%% Exported Functions
%%
-export([handle/3]).

%%
%% API Functions
%%

%% 获取副本进入次数列表
handle(?PP_COPY_ENTER_COUNT, PlayerStatus, _) ->
	%gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_duplicate, {'copy_enter_count'}),
	NewStatus = lib_welfare:reset_login_day(PlayerStatus),
	case lib_duplicate:get_dic() of
				[] ->
					{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, []),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinDate);
				List ->
					{ok, BinDate} = pt_12:write(?PP_COPY_ENTER_COUNT, List),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinDate)
	end,
	{update, NewStatus};

%% 获取用户试炼数据
handle(?PP_CHALLENGE_BOSS_INFO, PlayerStatus, _) ->
	{ok, Data} = pt_12:write(?PP_CHALLENGE_BOSS_INFO, 
			[PlayerStatus#ets_users.other_data#user_other.challenge_info#r_user_challenge_info.challenge_star,
			PlayerStatus#ets_users.other_data#user_other.challenge_info#r_user_challenge_info.challenge_num]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Data),
	ok;
%%请求试炼副本当天挑战奖励次数
handle(?PP_CHALLENGE_AWARD_NUM, PlayerStatus, _) ->
	{ok, Data} = pt_12:write(?PP_CHALLENGE_BOSS_INFO, [PlayerStatus#ets_users.other_data#user_other.challenge_info#r_user_challenge_info.challenge_num]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Data),
	ok;

%% 在挑战副本中，继续挑战下一个boss
handle(?PP_CHALLENGE_NEXT_BOSS, PlayerStatus, [MissionIndex]) ->
	DType = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {get_duplicate_type}),
	Limit = lib_challenge_duplicate:check_chanllenge_duplicate(MissionIndex,
				PlayerStatus#ets_users.other_data#user_other.challenge_info#r_user_challenge_info.challenge_star),
	if
		DType =:= ?DUPLICATE_TYPE_CHALLENGE andalso Limit =:= true ->
			
			DupPid = PlayerStatus#ets_users.other_data#user_other.pid_dungeon,
			UserId = PlayerStatus#ets_users.id,
			MapId = PlayerStatus#ets_users.current_map_id,
			lib_duplicate:quit_duplicate(DupPid, UserId, MapId),
			handle(?PP_ENTER_CHALLENGE_BOSS, PlayerStatus, [MissionIndex]);
		true ->
			case lib_duplicate:quit_duplicate(PlayerStatus) of
				{ok, NewStatus} ->
					{update_map, NewStatus};
				_ ->
					ok
			end
	end;

%% 进入试炼副本
handle(?PP_ENTER_CHALLENGE_BOSS, PlayerStatus, [MissionId]) ->
	case lib_challenge_duplicate:check_chanllenge_duplicate(MissionId,
		PlayerStatus#ets_users.other_data#user_other.challenge_info#r_user_challenge_info.challenge_star)of
		true ->
			case PlayerStatus#ets_users.darts_left_time < 1 andalso PlayerStatus#ets_users.other_data#user_other.infant_state =/= 4 of %%运镖，防沉迷期间不能进入副本
				true ->
					case lib_duplicate:enter_challenge_duplicate(PlayerStatus, MissionId)of
					{ok, Map_pid, Dup_pid, OnlyMapId, MapId, X, Y} ->
						mod_map:leave_scene(PlayerStatus#ets_users.id, 
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id, 
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
								PlayerStatus#ets_users.pos_x, 
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid,
								PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
						ChallengeInfo = PlayerStatus#ets_users.other_data#user_other.challenge_info,
						Now = misc_timer:now_seconds(),
						CNum = case util:is_same_date(ChallengeInfo#r_user_challenge_info.last_challenge_time, Now) of
									true ->
										ChallengeInfo#r_user_challenge_info.challenge_num + 1;
									false ->
										1
								end,
						NewChallengeInfo = ChallengeInfo#r_user_challenge_info{challenge_num = CNum,
																				last_challenge_time = Now},
						db_agent_user:update_user_challenge(PlayerStatus#ets_users.id, NewChallengeInfo),%%修改玩家试炼副本信息到数据库
						Other = PlayerStatus#ets_users.other_data#user_other{
																 pid_map = Map_pid,
																 walk_path_bin=undefined,
																 pid_dungeon=Dup_pid,
																 map_template_id = MapId,
																 challenge_info = NewChallengeInfo,
																 duplicate_id=?CHALLENGE_DUPLICATE_ID},
						{OldMapId,OldX,OldY} = case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
							true ->
								{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y};
							_ ->
								{PlayerStatus#ets_users.current_map_id,PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y}
						end,
						NewStatus = PlayerStatus#ets_users{current_map_id=OnlyMapId,
											   pos_x=X,
											   pos_y=Y,
											   old_map_id = OldMapId,
											   old_pos_x = OldX,
											   old_pos_y = OldY,
											   other_data=Other},
						lib_duplicate:add_duplicate_times(NewStatus#ets_users.id, ?CHALLENGE_DUPLICATE_ID,1),%增加进入副本次数
						NewStatus1 = lib_player:calc_speed(NewStatus, PlayerStatus#ets_users.is_horse),

						{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [MapId, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
						lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
			
						{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, ?CHALLENGE_DUPLICATE_ID),
						lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, ReturnData),					
						
						gen_server:cast(NewStatus1#ets_users.other_data#user_other.pid, {'finish_active',NewStatus1, ?DUPLICATEACTIVE, ?CHALLENGE_DUPLICATE_ID}),
						{update_map, NewStatus1};
					_ ->
						{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, -1),
						lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData),
						?DEBUG("enter_challenge_duplicate:~p",[1111]),	
						ok
					end;
				_ ->
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, -1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData),
					?DEBUG("enter_challenge_duplicate:~p",[2222]),	
					ok
			end;
		false ->			
			{ok,Data} = pt_12:write(?PP_ENTER_CHALLENGE_BOSS, [0,?ER_LIMIT_PASS]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Data),
			?DEBUG("check_chanllenge_duplicate:~p",[?ER_LIMIT_PASS]),	
			ok
	end;

%% 场景进入请求，判断能不能进入，没必要添加进地图
handle(?PP_MAP_ENTER, PlayerStatus, [DoorId]) ->
	case PlayerStatus#ets_users.other_data#user_other.infant_state of
		%%1 ->
		%%	InfantState = 1;
		4 ->
			InfantState = 1;
		_ ->
		%%	{ok, InfantState, _, _} = lib_infant:check(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerStatus#ets_users.online_time, 
		%%															  PlayerStatus#ets_users.other_data#user_other.infant_state, 
		%%															  PlayerStatus#ets_users.last_online_date)
			InfantState = 1 %%防沉迷中不限制过场景
	end,

	if InfantState =/= 4 ->
		   if
			   DoorId =:= -1 ->
				   {ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [
 										  PlayerStatus#ets_users.other_data#user_other.map_template_id,
										  PlayerStatus#ets_users.pos_x,
										  PlayerStatus#ets_users.pos_y]),
				   lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
					if
						is_pid(PlayerStatus#ets_users.other_data#user_other.pid_dungeon)
							andalso PlayerStatus#ets_users.other_data#user_other.duplicate_id > 0 ->
								{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, PlayerStatus#ets_users.other_data#user_other.duplicate_id),
								lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData);
						true ->
							ok
					end,
				   ok;
			   true ->
				   case lib_map:door_enter(PlayerStatus, DoorId) of
					   {ok, NewPlayerStatus} ->
						   {update_map, NewPlayerStatus};
					   _ ->
						   %?WARNING_MSG("enter door error:~p",[PlayerStatus#ets_users.other_data#user_other.map_template_id]),
						   MapId = lib_map:get_map_id(PlayerStatus#ets_users.other_data#user_other.map_template_id),
						   {ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [
										  MapId,
										  PlayerStatus#ets_users.pos_x,
										  PlayerStatus#ets_users.pos_y]),
				   		 lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
						 if MapId =:= PlayerStatus#ets_users.other_data#user_other.map_template_id ->
								ok;
							true ->
								NewOther = PlayerStatus#ets_users.other_data#user_other{map_template_id = MapId},
						 		NewStatus = PlayerStatus#ets_users{other_data = NewOther},
								{update_map, NewStatus}
						 end						 
				   end
		   end;
	   true -> 
		   NewOther = PlayerStatus#ets_users.other_data#user_other{infant_state = InfantState},
		   NewStatus = PlayerStatus#ets_users{other_data = NewOther},
		   {update_map, NewStatus}
	end;

%% 释放下波怪物
handle(?PP_OPEN_NEXT_MONSTER, Status, []) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {'open_guard_next_monster'}),
	ok;

%% 随机掉落铜币数量
handle(?PP_RAND_MONEY, Status, []) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {'rand_money_num'}),
	ok;
%% 返回商品可购买数量
handle(?PP_DUPLICATE_SHOP_SALE_NUM, Status, [NpcID,ShopID]) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {'get_shop_sale_num',Status#ets_users.id, NpcID,ShopID}),
	ok;
%%用户掉线后请求重新连接返回副本信息
handle(?PP_COPY_INFO, Status, []) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {'get_duplicate_info',Status#ets_users.id}),
	ok;
%%用户离开副本后抽奖
handle(?PP_COPY_LOTTERY, Status, []) ->
	if
		Status#ets_users.lottery_duplicate_id > 0 ->
			gen_server:cast(Status#ets_users.other_data#user_other.pid, {'duplicaet_lottery',Status#ets_users.lottery_duplicate_id});
		true ->
			ok
	end,
	ok;
%% 清除副本次数限制
handle(?PP_COPY_LIMIT_NUM_RESET, Status, [DupId]) ->	
	NeedYuanbao = 	if DupId =:= ?DUPLICATE_ZTG_ID -> ?DUPLICATE_RESET_ZTG_PRICE;
					   DupId =:= ?DUPLICATE_YMH_ID -> ?DUPLICATE_RESET_YMH_PRICE;
					   true -> 0
					end,
	{Res, Err_Code, NewStatus} =
	if NeedYuanbao > 0 ->
			if
				Status#ets_users.yuan_bao >= NeedYuanbao ->
					case lib_duplicate:reset_duplicate_times(Status#ets_users.id, DupId) of
						{ok, DayNum} ->
							Status1 = lib_player:reduce_cash_and_send(Status, NeedYuanbao, 0, 0, 0, {?CONSUME_YUANBAO_RESET_DUPLICATE,DupId,1}),
							{1,DupId, Status1};
						{error, ErrNum} ->
							{0,ErrNum,Status}
					end;
%% 					case gen_server:call(Status#ets_users.other_data#user_other.pid_duplicate, {'reset_dup_num',DupId}) of
%% 						{1,Id,_Num} ->
%% 							Status1 = lib_player:reduce_cash_and_send(Status, NeedYuanbao, 0, 0, 0, {?CONSUME_YUANBAO_RESET_DUPLICATE,Id,1}),
%% 							{1,Id, Status1};
%% 						{0,ErrCode,_Num} ->
%% 							{0,ErrCode,Status};
%% 						_ ->
%% 							{0,?ER_UNKNOWN_ERROR,Status}
%% 					end;
				true ->
					{0,?ER_NOT_ENOUGH_YUANBAO,Status}
			end;
		true ->
			{0,?ER_WRONG_VALUE,Status}
	end,
	{ok, Bin} = pt_12:write(?PP_COPY_LIMIT_NUM_RESET, [Res, Err_Code]),
	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
	{update, NewStatus};

%% 副本商店物品购买
handle(?PP_DUPLICATE_SHOP_BUY, PlayerStatus, [ShopItemID, Count]) ->
	YuanBao = PlayerStatus#ets_users.yuan_bao,
	BindYuanBao = PlayerStatus#ets_users.bind_yuan_bao,
	Copper = PlayerStatus#ets_users.copper,
	BindCopper = PlayerStatus#ets_users.bind_copper,
	%%先判断副本商店中的物品是否足够
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {'check_item_num',PlayerStatus#ets_users.id, ShopItemID,Count}) of
		true ->
			[Res, _ItemList, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, TemplateID] = 
			gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, 
						{'buy',
						 YuanBao,
						 BindYuanBao,
						 Copper,
						 BindCopper,
						 ShopItemID,
						 Count,
						 PlayerStatus#ets_users.club_id,
						 PlayerStatus#ets_users.id,
						 lib_map:get_map_id(PlayerStatus#ets_users.current_map_id),
						 PlayerStatus#ets_users.pos_x,
						 PlayerStatus#ets_users.pos_y,
						 lib_vip:change_dbvip_to_vipid(PlayerStatus#ets_users.vip_id)
						}),
			if Res =:= 1 ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {'buy_item',PlayerStatus#ets_users.id, ShopItemID,Count}),
			%%todo 先扣绑定，再扣非绑定
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYunBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper,
															{?CONSUME_YUANBAO_DUPLICATE_SHOP_BUY, TemplateID, Count});
			%%添加消费记录
%% 			lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, ReduceYunBao, ReduceBindYuanBao, 
%% 										   1, ?CONSUME_YUANBAO_ITEM_BUY, misc_timer:now_seconds(), TemplateID, Count,
%% 										   PlayerStatus#ets_users.level);
			true ->
				{ok,Bin} = pt_12:write(?PP_DUPLICATE_SHOP_BUY, [0,0,0]),
				lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
				NewPlayerStatus = PlayerStatus
			end;
		false ->
			{ok,Bin} = pt_12:write(?PP_DUPLICATE_SHOP_BUY, [0,0,0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			NewPlayerStatus = PlayerStatus
	end,
	
	%%返回是否成功	
	{update, NewPlayerStatus};


%%离开场景
handle(?PP_MAP_USER_REMOVE, Status, _SceneId) ->
	mod_map:leave_scene(Status#ets_users.id, 
						Status#ets_users.other_data#user_other.pet_id,
						Status#ets_users.current_map_id, 
			     		Status#ets_users.other_data#user_other.pid_map, 
				    	Status#ets_users.pos_x, 
						Status#ets_users.pos_y,
						Status#ets_users.other_data#user_other.pid,
						Status#ets_users.other_data#user_other.pid_locked_monster),
	ok;

%% 获取场景信息
handle(?PP_MAP_ROUND_INFO, Status, []) ->  	
	mod_map:get_map_round_info(Status#ets_users.current_map_id,Status,Status#ets_users.pos_x,Status#ets_users.pos_y);
	

%% 玩家走路
handle(?PP_PLAYER_MOVE, Status, [_ID, WalkPathBin]) ->
	{_, Status1} = lib_sit:cancle_sit(Status),
	{ok, BinData} = pt_12:write(?PP_PLAYER_MOVE, [Status1#ets_users.id, 
												  Status1#ets_users.other_data#user_other.index,
												  WalkPathBin]),
	mod_map_agent: send_to_area_scene(
							Status1#ets_users.current_map_id,
							Status1#ets_users.pos_x,
							Status1#ets_users.pos_y,
							BinData,
							Status1#ets_users.id),

	Other = Status1#ets_users.other_data#user_other{walk_path_bin = WalkPathBin},
	NewStatus = Status1#ets_users{
							 	other_data=Other
								},
	{update_map, NewStatus};



%% 行路同步	
handle(?PP_PLAYER_MOVE_STEP, Status, [X, Y, Index]) ->	
	%%传递给锁定为目标的对象
	%lib_player:notice_move(Status),
	
	Old_x = Status#ets_users.pos_x,
	Old_y = Status#ets_users.pos_y,
	
	if abs(Old_x - X)< 100 andalso abs(Old_y - Y) < 100 ->
		Other = Status#ets_users.other_data#user_other{index=Index},
		NewStatus = Status#ets_users{
									 pos_x=X,
									 pos_y=Y,
									 other_data=Other
									 },
				
		
		mod_map:update_player_pos(NewStatus),
		{update, NewStatus};
		
	   true ->
%% 		   ?ERROR_MSG("PP_PLAYER_MOVE_STEP X:~w,Y:~w,oldX:~w,oldY:~w .",[X, Y, Old_x, Old_y]),
		   ok
	end;
		   
%% type 1:回城复活，2：原地计时复活，3：原地健康复活，4：安全复活，5安全健康复活，6立即安全满血复活,7战场出生点复活
handle(?PP_PLAYER_RELIVE, PlayerStatus, [Type]) ->
	case lib_player:relive(PlayerStatus, Type) of
		{ok,NewPlayerStatus} ->						
%% 			{ok, NewPlayerStatus};
			{update_map, NewPlayerStatus};
		_ ->						
			%% 发送错误原因
			skip
	end;

%%普通打坐开始 或取消
handle(?PP_SIT_START_OR_CANCLE, PlayerStatus, [Is_Sit]) ->
	case Is_Sit of
		1 ->
			{_Msg, NewPlayerStatus} = lib_sit:start_sit(PlayerStatus, 1, 0);
		_ ->
			{_Msg, NewPlayerStatus} = lib_sit:cancle_sit(PlayerStatus)		
	end,
	{update_map, NewPlayerStatus};

%%修为打坐开始 或取消 
handle(?PP_XW_START_OR_CANCLE, PlayerStatus, [Is_Sit]) ->
	case Is_Sit of
		1 ->
			{_Msg, NewPlayerStatus} = lib_sit:start_xw(PlayerStatus);
		_ ->
			{_Msg, NewPlayerStatus} = lib_sit:cancle_xw(PlayerStatus)		
	end,
	{update_map, NewPlayerStatus};


%%邀请打坐
handle(?PP_SIT_INVITE, PlayerStatus, [BeInvitedNick, BeInvitedID]) ->
	if
		BeInvitedID =:= PlayerStatus#ets_users.id ->
			skip;
		true ->
			lib_sit:invite_sit(PlayerStatus, BeInvitedNick, BeInvitedID)
	end,
	ok;

%%打坐请求回复
handle(?PP_SIT_INVITE_REPLY, PlayerStatus, [SitOrNot, SourceID]) ->
	NewPlayerStatus = lib_sit:invite_sit_reply(PlayerStatus, SourceID, SitOrNot),
%% 	{ok, NewPlayerStatus};
	{update_map, NewPlayerStatus};

%%挂机技能设置
handle(?PP_PLAYER_HANGUPDATA, PlayerStatus, [Hangup]) ->
	NewPlayerStatus = PlayerStatus#ets_users{hangup_setting = Hangup},
%% 	{ok, NewPlayerStatus};
	{update_map, NewPlayerStatus};

%% 进入副本id
handle(?PP_ENTER_DUPLICATE, PlayerStatus, [DuplicateId]) ->
	case PlayerStatus#ets_users.darts_left_time < 1 andalso PlayerStatus#ets_users.other_data#user_other.infant_state =/= 4 of%%运镖，防沉迷期间不能进入副本
		true ->
			case lib_duplicate:enter_duplicate(PlayerStatus, DuplicateId) of
				{ok, Map_pid, Dup_pid, OnlyMapId, MapId, X, Y} ->
					mod_map:leave_scene(PlayerStatus#ets_users.id, 
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id, 
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
								PlayerStatus#ets_users.pos_x, 
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid,
								PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),

					Other = PlayerStatus#ets_users.other_data#user_other{
																 pid_map = Map_pid,
																 walk_path_bin=undefined,
																 pid_dungeon=Dup_pid,
																 map_template_id = MapId,
																 duplicate_id=DuplicateId},
					{OldMapId,OldX,OldY} = case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
						true ->
							{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y};
						_ ->
							{PlayerStatus#ets_users.current_map_id,PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y}
					end,
					{PkMode1, PkTime} = case misc:is_process_alive(PlayerStatus#ets_users.other_data#user_other.pid_team) of
						true ->
							NowTime = misc_timer:now_seconds(),
							{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_TEAM, NowTime]),
							lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
							{?PKMode_TEAM,NowTime};
						_ ->
							{PlayerStatus#ets_users.pk_mode,PlayerStatus#ets_users.pk_mode_change_date}
					end,
					Is_DUPLICATE_TYPE_FIGHT =
					case data_agent:duplicate_template_get(DuplicateId) of
						[] ->
							PkMode = PkMode1,
							false;
						Template when Template#ets_duplicate_template.type =:= ?DUPLICATE_TYPE_FIGHT ->							
							NowTime1 = misc_timer:now_seconds(),
							{ok,BinData1} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_FREEDOM, NowTime1]),
							lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData1),
							PkMode = ?PKMode_FREEDOM,
							true;
						_ ->
							PkMode = PkMode1,
							false
					end,
					NewStatusTemp = PlayerStatus#ets_users{current_map_id=OnlyMapId,
											   pos_x=X,
											   pos_y=Y,
											   old_map_id = OldMapId,
											   old_pos_x = OldX,
											   old_pos_y = OldY,
											   pk_mode = PkMode,
											   pk_mode_change_date = PkTime,
%% 											   is_horse = 0,
											   other_data=Other},
%% 					if Is_DUPLICATE_TYPE_FIGHT =:= true ->
%% 						NewStatus = NewStatusTemp#ets_users{current_map_id = MapId};
%% 					true ->
%% 						NewStatus = NewStatusTemp
%% 					end,
					NewStatus1_1 = lib_welfare:reset_login_day(NewStatusTemp),
					lib_duplicate:add_duplicate_times(NewStatus1_1#ets_users.id, DuplicateId,1),%增加进入副本次数
					NewStatus1 = lib_player:calc_speed(NewStatus1_1, PlayerStatus#ets_users.is_horse),

					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [MapId, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
						
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, DuplicateId),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, ReturnData),	
					
					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus1]),
					mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
									  				NewStatus1#ets_users.pos_x,
									  				NewStatus1#ets_users.pos_y,
									  				PlayerData,
									  				undefined),
					gen_server:cast(NewStatus1#ets_users.other_data#user_other.pid, {'finish_active',NewStatus1, ?DUPLICATEACTIVE, DuplicateId}),
					{update_map, NewStatus1};
				_ ->
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, -1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData),	
					ok
			end;
		_ ->
			{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, -1),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData),
			ok
	end;

%% 退出副本
handle(?PP_QUIT_DUPLICATE, PlayerStatus, _) ->
	case lib_duplicate:quit_duplicate(PlayerStatus) of
		{ok, NewStatus} ->
			{update_map, NewStatus};
		_ ->
			ok
	end;

%% 进入vip地图
handle(?PP_ENTER_VIPMAP, PlayerStatus, [Id]) ->
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
		true ->
			ok;
		_ ->
			if
				PlayerStatus#ets_users.darts_left_time >= 1 orelse PlayerStatus#ets_users.vip_id < 1 ->
					ok;
				true ->
					if
						Id =:= 1 ->
							[Current_Map_Id, PosX, PosY] = ?Enter_VipMap_1;
						true ->
							[Current_Map_Id, PosX, PosY] = ?Enter_VipMap_2
				    end,
					mod_map:leave_scene(PlayerStatus#ets_users.id, 
										PlayerStatus#ets_users.other_data#user_other.pet_id,
						                PlayerStatus#ets_users.current_map_id, 
						                PlayerStatus#ets_users.other_data#user_other.pid_map, 
						                PlayerStatus#ets_users.pos_x, 
						                PlayerStatus#ets_users.pos_y,
						                PlayerStatus#ets_users.other_data#user_other.pid,
						                PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
					Other = PlayerStatus#ets_users.other_data#user_other{
																		 walk_path_bin=undefined,
																		 pid_map = undefined
																		},
					NewPlayerStatus = PlayerStatus#ets_users{
															 current_map_id = Current_Map_Id,
															 pos_x = PosX,
															 pos_y = PosY,
															 other_data=Other
															},
					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewPlayerStatus#ets_users.current_map_id,
																  NewPlayerStatus#ets_users.pos_x,
																  NewPlayerStatus#ets_users.pos_y]),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
					{update_map, NewPlayerStatus}
			end
	end;
					
	
%% 退出vip地图
handle(?PP_QUIT_VIPMAP, PlayerStatus, _) ->
	[Current_Map_Id, PosX, PosY] = ?Quit_VipMap,
	
	mod_map:leave_scene(PlayerStatus#ets_users.id, 
						PlayerStatus#ets_users.other_data#user_other.pet_id,
						PlayerStatus#ets_users.current_map_id, 
						PlayerStatus#ets_users.other_data#user_other.pid_map, 
						PlayerStatus#ets_users.pos_x, 
						PlayerStatus#ets_users.pos_y,
						PlayerStatus#ets_users.other_data#user_other.pid,
						PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
	
	Other = PlayerStatus#ets_users.other_data#user_other{
														 walk_path_bin=undefined,
														 pid_map = undefined
														},
	NewPlayerStatus = PlayerStatus#ets_users{
											 current_map_id = Current_Map_Id,
											 pos_x = PosX,
											 pos_y = PosY,
											 other_data=Other
											},
	{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewPlayerStatus#ets_users.current_map_id,
												  NewPlayerStatus#ets_users.pos_x,
												  NewPlayerStatus#ets_users.pos_y]),
	
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
	{update_map, NewPlayerStatus};
	

%% 技能复活
%% handle(?PP_SKILL_RELIVE, PlayerStatus, _) ->
%% 	case lib_player:relive_by_skill(PlayerStatus,10,10) of
%% 		{ok, NewStatus} ->
%% 			{update_map, NewStatus};
%% 		_ ->
%% 			ok
%% 	end;

%% 战场列表
handle(?PP_FREE_WAR_LIST, PlayerStatus, _) ->
	mod_free_war:get_free_war_list(PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 战场杀人信息
handle(?PP_FREE_WAR_USER_INFO, PlayerStatus, _) ->
	mod_free_war:get_free_war_user_info(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerStatus#ets_users.id);

%% 战场用户列表
handle(?PP_FREE_WAR_USER_LIST, PlayerStatus, WarId) ->
	mod_free_war:get_free_war_user_list(PlayerStatus#ets_users.other_data#user_other.pid_send, WarId);

%% 战场结果
handle(?PP_FREE_WAR_RESULT, PlayerStatus, WarId) ->
	mod_free_war:get_free_war_result(PlayerStatus#ets_users.other_data#user_other.pid_send, WarId);

%% 进入自由战场
handle(?PP_ENTER_FREE_WAR, TempPlayerStatus, WarId) ->
	case TempPlayerStatus#ets_users.darts_left_time < 1 of%%运镖期间不能进入副本
		true ->
			case mod_free_war:enter_free_war_map(TempPlayerStatus, WarId) of
				{ok, WarState, MapPid, OnlyMapId, MapId, PosX, PosY, DuplicateId} ->
					lib_team:team_quit(TempPlayerStatus),
					
%% 					lib_duplicate:quit_duplicate(PlayerStatus#ets_users.other_data#user_other.pid_duplicate,
%% 													PlayerStatus#ets_users.id,
%% 													PlayerStatus#ets_users.current_map_id),
					
					PlayerStatus = 
						case lib_duplicate:quit_duplicate(TempPlayerStatus) of
							{ok,  TempPlayerStatus1} ->
								TempPlayerStatus1;
							_ ->
								TempPlayerStatus
						end,
											
					mod_map:leave_scene(PlayerStatus#ets_users.id, 
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id, 
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
								PlayerStatus#ets_users.pos_x, 
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid,
								PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
 
					Other = PlayerStatus#ets_users.other_data#user_other{
																 war_state = WarState,
																 pid_map = MapPid,
																 walk_path_bin=undefined,
																 map_template_id = MapId,
																 duplicate_id = DuplicateId},
			
					NewStatus = PlayerStatus#ets_users{current_map_id=OnlyMapId,
											   pos_x=PosX,
											   pos_y=PosY,
											   is_horse = 0,
											   other_data=Other},
					NewStatus1 = lib_player:calc_speed(NewStatus, 0),
					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [MapId, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus1]),
					mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
									  				NewStatus1#ets_users.pos_x,
									  				NewStatus1#ets_users.pos_y,
									  				PlayerData,
									  				undefined),
			
					{update_map, NewStatus1};
				_ ->
					skip
			end;
		_ ->
			skip
	end;

%% 退出自由战场
handle(?PP_QUIT_FREE_WAR, PlayerStatus, _) ->
	case lib_duplicate:quit_duplicate(PlayerStatus) of
		{ok, NewStatus} ->
			{ok, DataBin} = pt_12:write(?PP_QUIT_FREE_WAR, []),
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, DataBin),	
			{update_map, NewStatus};
		_ ->
			ok
	end;

%% 领取奖励
handle(?PP_FREE_WAR_AWARD, PlayerStatus, _) ->
 	mod_free_war:collect_free_war_award(PlayerStatus#ets_users.id);

%% 战场复活
handle(?PP_FREE_WAR_RELIVE, PlayerStatus, [Type]) ->
	case lib_map:is_copy_war(PlayerStatus#ets_users.current_map_id) of
		true ->
			case lib_player:relive_war(PlayerStatus, Type) of
				{ok, NewPlayerStatus} ->
					{update_map, NewPlayerStatus};
				_ ->
					ok
			end;
		_ ->
			ok
	end;


handle(_Cmd, _, _DataBin) ->
	?WARNING_MSG("pp_map error cmd:~w ~n",[_Cmd]),
	ok.


%%
%% Local Functions
%%

