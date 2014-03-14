%% Author: Administrator
%% Created: 2011-3-11
%% Description: TODO: Add description to pp_player
-module(pp_player).
-export([handle/3]).
-include("common.hrl").

-define(QUERY_SHENYOU,2#10000000000000000000000000).% (1 bsl 25)).  %% 副本神游
-define(QUERY_EX_YUANBAO,2#1000000000000000000000000).% (1 bsl 24)).  %% 兑换绑定银两状态
-define(QUERY_SMSHOP_LAST_UPDATE,2#100000000000000000000000).% (1 bsl 23)).  %% 神秘商店最后时间
-define(QUERY_ACTIVE_TIME_LIST,2#10000000000000000000000).% (1 bsl 22)).  %% 活动时间列表
-define(QUERY_FIRST_PAY_ACTIVE,2#1000000000000000000000).% (1 bsl 21)).  %% 开服活动
-define(QUERY_TARGET_LIST,	2#100000000000000000000).% (1 bsl 20)).  %% 目标
-define(QUERY_ACTIVE,	2#10000000000000000000).% (1 bsl 19)).  %% 活跃度值
-define(QUERY_WELFARE,	2#1000000000000000000). % (1 bsl 18)).  %% 福利信息
-define(QUERY_LOTTERY,	2#100000000000000000).	% (1 bsl 17)).  %% 副本抽奖
-define(QUERY_MOUNTS, 	2#10000000000000000).  	% (1 bsl 16)).  %% 坐骑
-define(QUERY_BAG, 		2#1000000000000000).  	% (1 bsl 15)).  %% 背包
-define(QUERY_MAIL, 	2#100000000000000).  	% (1 bsl 14)).  %% 是否有邮件
-define(QUERY_FRIEND,	2#10000000000000). 		% 1 bsl 13).	 %% 好友
-define(QUERY_TASK, 	2#1000000000000).    	% 1 bsl 12).	 %% 任务
-define(QUERY_TEAM, 	2#100000000000).     	% 1 bsl 11).	 %% 队伍
-define(QUERY_ENTHRAL, 	2#10000000000).   		% 1 bsl 10).	 %% 防沉迷
-define(QUERY_SKILL, 	2#1000000000).      	% 1 bsl 9).	 %% 技能
-define(QUERY_SKILL_BAR,2#100000000).   		% 1 bsl 8).	 %% 技能包
-define(QUERY_PET,   	2#10000000).        	% 1 bsl 7).	 %% 宠物
-define(QUERY_HANGUP,	2#1000000).	    		% 1 bsl 6		 %% 挂机设置
-define(QUERY_BUFF,  	2#100000).	         	% 1 bsl 5.		 %%	Buff信息
-define(QUERY_TITLE, 	2#10000).           	% 1 bsl 4.      %% 称号信息
-define(QUERY_DAILY_AWARD, 2#1000).				% 1 bsl 3.		 %% 奖励信息
-define(QUERY_VIP, 		2#100).				 	% 1 bsl 2.		 %% vip信息
-define(QUERY_VEINS, 	2#10).				 	% 1 bsl 1.		 %% 筋脉信息
%%
%% API Functions
%%
%% 获取自身其他信息
handle(?PP_QUERY_SELF_OTHER, PlayerStatus, [Query]) ->
	if Query band ?QUERY_MOUNTS =/=0 ->
		   pp_mounts:handle(?PP_MOUNT_LIST_UPDATE, PlayerStatus, [0]);
	   true ->
		   skip
	end,
	if Query band ?QUERY_TASK =/= 0 ->
		   pp_task:handle(?PP_TASK_QUERY, PlayerStatus, []);
	   true ->
		   skip
	end,
		
	if Query band ?QUERY_BAG =/= 0 ->
			pp_item:handle(?PP_ITEM_PLACE_UPDATE, PlayerStatus, []);
	   true ->
		   skip
	end,
	
	if Query band ?QUERY_MAIL =/= 0->
		   %% 是否有邮件
		  pp_mail:handle(?PP_MAIL_QUERY_ALL, PlayerStatus, []);
	   true ->
		   skip
	end,
	
	if Query band ?QUERY_FRIEND =/= 0->
		   pp_friend:handle(?PP_FRIEND_LIST, PlayerStatus, []);
	   true ->
		   skip
	end,
	
%% 	if Query band ?QUERY_TASK =/= 0 ->
%% 		   pp_task:handle(?PP_TASK_QUERY, PlayerStatus, []);
%% 	   true ->
%% 		   skip
%% 	end,
	
	if Query band ?QUERY_TEAM =/= 0 ->
		   NewStatus = lib_team:member_check(PlayerStatus);
	   true ->
		   NewStatus = PlayerStatus
	end,
	
	if Query band ?QUERY_ENTHRAL =/= 0 ->
		   lib_infant:send_infant_user(PlayerStatus);
	   true ->
		   skip
	end,
	
	if 
		Query band ?QUERY_SKILL =/= 0 ->
			GuildSkillUpTimes = case mod_guild:get_guild_user_feats_use_timers(PlayerStatus#ets_users.club_id, PlayerStatus#ets_users.id,11) of
						{true,Timers} ->
							Timers;
						{false,Msg} ->
							0
					end,
		   	{ok, BinSkillInit} = pt_20:write(?PP_SKILL_INIT, [PlayerStatus#ets_users.other_data#user_other.skill_list,GuildSkillUpTimes]),
		   	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinSkillInit);
	   	true ->
		  	skip
	end,
	

	if Query band ?QUERY_SKILL_BAR =/= 0 ->
		   {ok, BinSkillBarInit} = pt_20:write(?PP_SKILL_BAR_INIT, PlayerStatus#ets_users.other_data#user_other.skill_bar),
		   lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinSkillBarInit);
	   true ->
		   skip
	end,
	
	if Query band ?QUERY_VEINS =/= 0 ->
			{ok, BinVeinsInfo} = pt_20:write(?PP_VEINS_INIT,[PlayerStatus#ets_users.veins_cd,
								PlayerStatus#ets_users.veins_acupoint_uping,
								PlayerStatus#ets_users.other_data#user_other.veins_list]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinVeinsInfo);
	   true ->
		   skip
	end,	

	if Query band ?QUERY_PET =/= 0 ->
		   pp_pet:handle(?PP_PET_LIST_UPDATE, PlayerStatus, []);
	   true ->
		   skip
	end,
	
	if Query band ?QUERY_HANGUP =/= 0 ->
		   {ok, BinHangup} = pt_12:write(?PP_PLAYER_HANGUPDATA, PlayerStatus#ets_users.hangup_setting),
		    lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinHangup);
	   true ->
		   skip
	end,
	
	if Query band ?QUERY_TITLE =/= 0 ->
		   {ok, BinTitleData} = pt_12:write(?PP_PLAYER_TITLE_INFO, [PlayerStatus]),
		   lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinTitleData);
		true ->
		   skip
	end,
	
%% 	if Query band ?QUERY_BUFF =/= 0 ->
%% 		   if
%% 			   PlayerStatus#ets_users.other_data#user_other.exp_buff =:= [] ->
%% 				   skip;
%% 			   true ->
%% 				   {ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[[PlayerStatus#ets_users.other_data#user_other.exp_buff],?ELEMENT_PLAYER,
%% 															   PlayerStatus#ets_users.id,1,
%% 															   PlayerStatus#ets_users.other_data#user_other.buff_temp_info]),
%% 				   lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BuffBin)
%% 		   end;
%% 	   true ->
%% 		   skip
%% 	end,
	
	if Query band ?QUERY_DAILY_AWARD =/= 0 ->
			{AwardSign,AwardTime} = lib_daily_award:get_daily_award_template_list_and_send(
										PlayerStatus#ets_users.daily_award,
										PlayerStatus#ets_users.daily_award_date,
										PlayerStatus#ets_users.other_data#user_other.pid_send),
			NewStatus1 = NewStatus#ets_users{daily_award_date = AwardTime, daily_award = AwardSign};
	   true ->
		   NewStatus1 = NewStatus
	end,
	
	%%vip信息
	if Query band ?QUERY_VIP =/= 0 ->
		   handle(?PP_PLAYER_VIP_DETAIL, NewStatus1, []);
	   true ->
		   skip
	end, 
	if Query band ?QUERY_LOTTERY =/= 0 andalso NewStatus1#ets_users.lottery_duplicate_id > 0 ->
		  	{ok,LotteryData} = pt_12:write(?PP_COPY_LOTTERY, [NewStatus1#ets_users.lottery_duplicate_id,0,0]),
			lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send,LotteryData);
	   true ->
		   skip
	end, 
	

	if Query band ?QUERY_WELFARE =/= 0 ->
			handle(?PP_PLAYER_WELFARE_UPDATE, NewStatus1, []); 
		true ->
		   skip
	end, 

	if Query band ?QUERY_ACTIVE =/= 0 ->
		   lib_active:get_active_1(NewStatus1);
	   true ->
		   skip
	end,
	
	
	if Query band ?QUERY_TARGET_LIST =/= 0 ->
		   pp_target:handle(?PP_TARGET_LIST_UPDATE, NewStatus1, []),
		   pp_target:handle(?PP_TARGET_HISTORY_UPDATE, NewStatus1, []);
	   true ->
		   skip
	end,
	
	if Query band ?QUERY_FIRST_PAY_ACTIVE =/= 0 ->
		   handle(?PP_PLAYER_ACTIVE_OPEN_SERVER, NewStatus1, []);
	   true ->
		   skip
	end,
	if 
		Query band ?QUERY_ACTIVE_TIME_LIST =/= 0 ->
			pp_battle:handle(?PP_ACTIVE_START_TIME_LIST, NewStatus1, []);
		true ->
			skip
	end,
	if 
		Query band ?QUERY_SMSHOP_LAST_UPDATE =/= 0 ->
			pp_item:handle(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER, NewStatus1, []);
		true ->
			skip
	end,
	if 
		Query band ?QUERY_EX_YUANBAO =/= 0 ->
			{ok, Data} = pt_20:write(?PP_GET_BIND_YUANBAO, [NewStatus1#ets_users.exchange_bind_yuanbao] ),
			lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, Data);
		true ->
			skip
	end,
	NewStatus2 = if 
		Query band ?QUERY_SHENYOU =/= 0 ->
			lib_shenyou:shenyou_login(NewStatus1);
		true ->
			NewStatus1
	end,	
		
	
%% 	%检查是否在帮会运镖，是则发送剩余时间
%% 	case PlayerStatus#ets_users.club_id > 0 of
%% 		true ->
%% 			PlayerPid = PlayerStatus#ets_users.other_data#user_other.pid,
%% 			mod_guild:check_guild_transport(PlayerStatus#ets_users.club_id, PlayerPid, {lib_player, set_guild_trans_time});
%% 		_ ->
%% 			skip
%% 	end,
	%%发送游戏中目前是否有活动真正进行中
%% 	gen_server:cast(mod_active:get_active_pid(), {current_active, NewStatus1#ets_users.other_data#user_other.pid_send}),

	mod_free_war:get_free_war_state(
	  								NewStatus2#ets_users.id,
									NewStatus2#ets_users.other_data#user_other.pid,
	 								NewStatus2#ets_users.other_data#user_other.pid_send
								   ),

	%%加载玩家充值信息
	case config:get_operate_type() of
		?OPERATE_TYPE_UNITE ->
			NewStatus3 = lib_player:unite_pay(NewStatus2);
		_ ->
			NewStatus3 = lib_player:load_pay(NewStatus2)
	end,
	{update_map, NewStatus3};
%% 	{ok, NewStatus};

%% 游戏设置
handle(?PP_CONFIG, PlayerStatus, [Config]) ->
	 NewPlayerStatus =  PlayerStatus#ets_users{client_config = Config},
	 {update, NewPlayerStatus};
%%      {ok, NewPlayerStatus};

%% 服务端开服时间
handle(?PP_SERVER_OPEN_DATE, PlayerStatus, []) ->
	
	{ok, PlayerBin} = pt_20:write(?PP_SERVER_OPEN_DATE, [config:get_service_start_time(),config:get_service_hf_time()]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
	
	ok;

%% 战斗
handle(?PP_PLAYER_ATTACK, PlayerStatus, [ActorID,TargetID,TargetType,SkillGroupID,X,Y]) ->
	%注意，传入的是技能的组id
	SkillInfo = lib_skill:get_current_skill(PlayerStatus#ets_users.other_data#user_other.skill_list,SkillGroupID),
	%?PRINT("SkillID ~p ~n",[SkillInfo]),
	case SkillInfo of
		{error} ->
			failed;
		V ->
			SkillData = lib_skill:get_skill_from_template(V#r_use_skill.skill_id), %%技能判断
			case SkillData of
				[] ->
					failed;
				_ ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_map,
									{battle_start,[ActorID,
												   TargetID,
												   SkillData,
												   PlayerStatus#ets_users.other_data#user_other.skill_list,
												   X,
												   Y,
												   TargetType,
												   ?ELEMENT_PLAYER]})
			end
	end;

%% 技能学习或者升级
handle(?PP_SKILL_LEARNORUPDATE, PlayerStatus, [SkillGroupID]) ->
	NewPlayerStatus = lib_skill:update_skill(PlayerStatus,SkillGroupID),
	
	%%临时添加人物属性更新
	{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
%% 	{ok,NewPlayerStatus};

	mod_map:update_player_skill(NewPlayerStatus),

	{update, NewPlayerStatus};

%% 技能快捷栏拖动操作
handle(?PP_PLAYER_DRAG_SKILL, PlayerStatus, [Type,TemplateID,FromIndex,ToIndex]) ->
	NewPlayerStatus = lib_skill:update_skill_bar(PlayerStatus,Type,TemplateID,FromIndex,ToIndex),
%% 	{ok,NewPlayerStatus};
	{update, NewPlayerStatus};
%% 升级筋脉
handle(?PP_VEINS_ACUPOINT_UPDATE, PlayerStatus, [AcupointType]) ->
	NewPlayerStatus = lib_veins:update_acupoint(PlayerStatus, AcupointType),
	{update, NewPlayerStatus};
%% 升级根骨
handle(?PP_VEINS_GENGU_UPDATE, PlayerStatus, [AcupointType]) ->
	NewPlayerStatus = lib_veins:update_gengu(PlayerStatus, AcupointType),
	{update, NewPlayerStatus};
%% 使用元宝清除CD
handle(?PP_VEINS_CLEAR_CD, PlayerStatus, [Clear_Type, Place]) ->
	NewPlayerStatus = lib_veins:clear_cd(PlayerStatus, Clear_Type, Place),
	{update, NewPlayerStatus};

%% PK模式变更
handle(?PP_PLAYER_PK_MODE_CHANGE, PlayerStatus, [Mode]) ->
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of 
		true when PlayerStatus#ets_users.other_data#user_other.map_template_id =/= ?GUILD_MAP_ID andalso 
		PlayerStatus#ets_users.other_data#user_other.map_template_id =/= ?FIGHT_DUP_MAP_ID->
			ok;
		_ ->
			NewPlayerStatus = lib_player:change_pk_mode(PlayerStatus,Mode),
			{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [NewPlayerStatus#ets_users.pk_mode,
																   NewPlayerStatus#ets_users.pk_mode_change_date]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send,BinData),
			{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewPlayerStatus]),
			mod_map_agent: send_to_area_scene(NewPlayerStatus#ets_users.current_map_id,
									  NewPlayerStatus#ets_users.pos_x,
									  NewPlayerStatus#ets_users.pos_y,
									  PlayerData,
									  undefined),
			{update_map, NewPlayerStatus}
	end;

%拾取
handle(?PP_PLAYER_GET_DROPITEM, PlayerStatus, [DropId]) ->
	
%% 	mod_map:get_dropitem_in_map(PlayerStatus#ets_users.other_data#user_other.pid_map,
%% 								DropID,
%% 								PlayerStatus#ets_users.id,
%% 								PlayerStatus#ets_users.pos_x,
%% 								PlayerStatus#ets_users.pos_y,
%% 								PlayerStatus#ets_users.other_data#user_other.pid_item),
	
	lib_player:pick_drop_item(PlayerStatus, DropId),
	ok;
%% 	{ok, PlayerStatus};

%% 上下马
handle(?PP_PLAYER_SET_HORSE, PlayerStatus, [IsHorse]) ->
	{_, PlayerStatus1}  = lib_sit:cancle_sit(PlayerStatus),
	%%如果玩家正在运镖之中，不能骑宠
	Is_Duplicate = lib_map:is_copy_scene(PlayerStatus1#ets_users.current_map_id),
	
	NewPlayerStatus = case PlayerStatus1#ets_users.darts_left_time > 0  of
							true ->
								PlayerStatus1#ets_users{is_horse=0};
						  	_ ->
								lib_player:calc_speed(PlayerStatus1, IsHorse)
					  end,
	
	{ok, BinData} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus]),
	%%广播周围玩家
	mod_map_agent:send_to_area_scene(
							NewPlayerStatus#ets_users.current_map_id,
							NewPlayerStatus#ets_users.pos_x,
							NewPlayerStatus#ets_users.pos_y,
							BinData),
	{update_map, NewPlayerStatus};

%%选择称号
handle(?PP_PLAYER_CHOOSE_TITLE, PlayerStatus, [Title, IsHide]) ->
	{Res, NewPlayerStatus1} = lib_player:change_title(Title, PlayerStatus),
	NewPlayerStatus2 = lib_player:change_hide_title(NewPlayerStatus1, IsHide),
	
	%%重新计算玩家属性
	NewPlayerStatus = lib_player:calc_properties_send_self(NewPlayerStatus2),
	if		
		Res =:= 1 ->
			{ok, BinData} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus]),
			%%广播周围玩家
			mod_map_agent:send_to_area_scene(
			  NewPlayerStatus#ets_users.current_map_id,
			  NewPlayerStatus#ets_users.pos_x,
			  NewPlayerStatus#ets_users.pos_y,
			  BinData),
			{ok, ResData} = pt_20:write(?PP_PLAYER_CHOOSE_TITLE, [Res,NewPlayerStatus#ets_users.title,NewPlayerStatus#ets_users.is_hide]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, ResData),
			{update_map, NewPlayerStatus};
		
		true ->
			{ok, ResData} = pt_20:write(?PP_PLAYER_CHOOSE_TITLE, [Res,0,0]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, ResData),
			{update_map, NewPlayerStatus}
	end;



%% %%多倍经验开关
%% handle(?PP_BUFF_CONTROL, PlayerStatus, [IsStop]) ->
%% 	case IsStop of
%% 		1 ->
%% 			{BuffInfo, UpdateBuff} = lib_buff:frozen_exp_buff(PlayerStatus#ets_users.other_data#user_other.exp_buff, misc_timer:now_milseconds()),
%% 			Other = PlayerStatus#ets_users.other_data#user_other{exp_buff = BuffInfo, exp_rate = 1},
%% 			NewPlayerStatus = PlayerStatus#ets_users{other_data = Other};
%% 		_ ->
%% 			{Exp_Rate, BuffInfo, UpdateBuff} =lib_buff:free_exp_buff(PlayerStatus#ets_users.other_data#user_other.exp_buff, 1, misc_timer:now_milseconds()),
%% 			Other = PlayerStatus#ets_users.other_data#user_other{exp_buff = BuffInfo, exp_rate = Exp_Rate},
%% 			NewPlayerStatus = PlayerStatus#ets_users{other_data = Other}
%% 	end,
%% 	
%% 	{ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[UpdateBuff,?ELEMENT_PLAYER,NewPlayerStatus#ets_users.id,1,
%% 												NewPlayerStatus#ets_users.other_data#user_other.buff_temp_info]),
%% 	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BuffBin),
%% %% 	{ok, NewPlayerStatus};
%% 	{update, NewPlayerStatus};

handle(?PP_PLAYER_COLLECT_STOP, PlayerStatus, []) ->
	NewStatus = lib_collect:stop_collect(PlayerStatus),
	{update, NewStatus};

%% 开始采集
handle(?PP_PLAYER_COLLECT_START, PlayerStatus, [CollectId,TemplateId] ) ->
	NewStatus = lib_collect:start_collect(PlayerStatus, CollectId, TemplateId),
	{update, NewStatus};

%% 玩家采集
handle(?PP_PLAYER_COLLECT, PlayerStatus, [CollectId,TemplateId]) ->
	NewStatus = lib_collect:player_collect(PlayerStatus, CollectId, TemplateId),
	{update, NewStatus};

%% 每日奖励领取列表
handle(?PP_PLAYER_DAILY_AWARD_LIST,PlayerStatus,[]) ->
	{ok,Bin} = pt_20:write(?PP_PLAYER_DAILY_AWARD_LIST, [PlayerStatus#ets_users.daily_award,PlayerStatus#ets_users.online_time]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
	ok;

%% 每日奖励领取
handle(?PP_PLAYER_DAILY_AWARD,PlayerStatus,[Number]) ->
	NewPlayerStatus = lib_daily_award:get_daily_award(PlayerStatus,Number),
	{update, NewPlayerStatus};


%isgetaward,true已取得，false未
handle(?PP_PLAYER_VIP_DETAIL, PlayerStatus, []) ->
	case PlayerStatus#ets_users.vip_id of
		0 ->
			{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL,[0,0,0,0,1,1,1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, VipBin),
			ok;
		_ ->
			{PlayerStatus1,IsGetAward1,IsGetAward2,IsGetAward3} = lib_vip:check_vip_refresh(PlayerStatus),
			{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [PlayerStatus1#ets_users.vip_id,
															  PlayerStatus1#ets_users.vip_date,
															  PlayerStatus1#ets_users.vip_tranfer_shoes,
															  PlayerStatus1#ets_users.vip_bugle,
															  IsGetAward1,IsGetAward2,IsGetAward3]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send, VipBin),
			{update, PlayerStatus1}
	end;

handle(?PP_PLAYER_VIP_AWARD, PlayerStatus, [Place]) ->
	case lib_vip:get_vip_award(PlayerStatus,Place) of
		{ok,NewPlayerStatus} ->
			{ok, VipBin} = pt_20:write(?PP_PLAYER_VIP_AWARD,[1,Place]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, VipBin),
			{update, NewPlayerStatus};
		_ ->
			{ok, VipBin} = pt_20:write(?PP_PLAYER_VIP_AWARD,[0,Place]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, VipBin),
			ok
	end;
%%获取福利信息
handle(?PP_PLAYER_WELFARE_UPDATE, PlayerStatus, []) ->
	Welfare1 = PlayerStatus#ets_users.other_data#user_other.welfare_info,
	Now = misc_timer:now_seconds(),
	Welfare = lib_welfare:reset_login_day(Welfare1, Now, PlayerStatus#ets_users.level,PlayerStatus#ets_users.vip_id),
	case util:is_same_date(Welfare#ets_user_welfare.receive_time, Now)of%% 时间需要去当天零点时间
		true ->
			Is_Receive = 1;
		false ->
			Is_Receive = 0
	end,
	case util:is_same_date(Welfare#ets_user_welfare.vip_receive_time, Now)of%% 时间需要去当天零点时间
		true ->%% 时间需要去当天零点时间
			Is_VipReceive = 1;
		false ->
			Is_VipReceive = 0
	end,
	%?DEBUG("receive time:~p",[{Is_Receive,Is_VipReceive}]),
	{ok,BinData} = pt_20:write(?PP_PLAYER_WELFARE_UPDATE, [Is_Receive,Is_VipReceive, Welfare]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	NewOther = PlayerStatus#ets_users.other_data#user_other{welfare_info = Welfare},
	NewStatus = PlayerStatus#ets_users{other_data = NewOther},
	{update, NewStatus};

%%领取福利
handle(?PP_PLAYER_WELFARE_RECEIVE, PlayerStatus, [Type]) ->
	NewPlayerStatus = lib_welfare:receive_welfare(PlayerStatus,Type),
	{update, NewPlayerStatus};

%%兑换经验
handle(?PP_PLAYER_WELFARE_EXP_EXCHANGE, PlayerStatus, [Type,ExchangeType,Num]) ->
	NewPlayerStatus = lib_welfare:exchange_exp(PlayerStatus,{Type,ExchangeType,Num}),
	{update, NewPlayerStatus};

%% 重置连续登录天数
%% handle(?PP_PLAYER_WELFARE_RESET_LOGIN_DAY, PlayerStatus, []) ->
%% 	NewPlayerStatus = lib_welfare:reset_logiin_Day(PlayerStatus),
%% 	{update, NewPlayerStatus};

%%激活码领取
handle(?PP_PLAYER_ACTIVY_COLLECT, PlayerStatus, [ActiveIndex, Gift_id, Code]) ->
	 lib_player:collect_activity_by_code(PlayerStatus#ets_users.id, PlayerStatus#ets_users.user_name, Code, ActiveIndex, Gift_id,
										 PlayerStatus#ets_users.other_data#user_other.pid_item,
										  PlayerStatus#ets_users.other_data#user_other.pid_send),
	ok;

handle(?PP_PLAYER_ACTIVY_SEARCH, PlayerStatus, [ActiveIndex]) ->
	lib_player:collect_activity_search(PlayerStatus#ets_users.other_data#user_other.pid_send,
									   PlayerStatus#ets_users.id, ActiveIndex),
	ok;

%%  获取个人荣誉值
handle(?PP_UPDATE_SELF_HONOR, PlayerStatus, []) ->
	{ok, DataBin} = pt_20:write(?PP_UPDATE_SELF_HONOR, PlayerStatus),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, DataBin),
	ok;

%% 使用vip卡
handle(?PP_PLAYER_VIP_USE,PlayerStatus,[Place]) ->
	case lib_vip:vip_card_use(PlayerStatus,Place) of
		{ok,NewPlayerStatus} ->
			{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD, [NewPlayerStatus]),
			mod_map_agent: send_to_area_scene(
									NewPlayerStatus#ets_users.current_map_id,
									NewPlayerStatus#ets_users.pos_x,
									NewPlayerStatus#ets_users.pos_y,
									PlayerData,
									undefined),
			Now = misc_timer:now_seconds(),
			IsGetAward1 = case util:is_same_date(Now,NewPlayerStatus#ets_users.vip_yuanbao_date) of
							true ->
								1;
							_ ->
								0
						end,
			IsGetAward2 = case util:is_same_date(Now,NewPlayerStatus#ets_users.vip_yuanbao_date) of
							true ->
								1;
							_ ->
								0
						end,
			IsGetAward3 = case util:is_same_date(Now,NewPlayerStatus#ets_users.vip_yuanbao_date) of
							true ->
								1;
							_ ->
								0
						end,
			{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [NewPlayerStatus#ets_users.vip_id,
															  NewPlayerStatus#ets_users.vip_date,
															  NewPlayerStatus#ets_users.vip_tranfer_shoes,
															  NewPlayerStatus#ets_users.vip_bugle,
															  IsGetAward1,IsGetAward2,IsGetAward3]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, VipBin),
			{update, NewPlayerStatus};
		false ->
			ok
	end;

handle(?PP_PLAYER_ACTIVE_AWARD,PlayerStatus,[]) ->
	case lib_active:get_reward(PlayerStatus) of
		{ok,NewPlayerStatus} ->
			case NewPlayerStatus#ets_users.level  =/= PlayerStatus#ets_users.level of
				true ->
					{update_map, NewPlayerStatus};
				_ ->
					{update, NewPlayerStatus}
			end;
			
		_ ->
			ok
	end;

%% 回到京城防卡死
handle(?PP_PLAYER_BREAK_AWAY,PlayerStatus,[]) ->
	NewPlayerStatus =
		if PlayerStatus#ets_users.current_map_id < 10000 ->
			{ok, PlayerStatus1}=lib_player:player_break_away(PlayerStatus),
			PlayerStatus1;
		true ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_ER_NOT_WORLD_MAP]),
			PlayerStatus
		end,
	{update, NewPlayerStatus};

handle(?PP_PLAYER_ACTIVE_INFO,PlayerStatus,[]) ->
	lib_active:get_active(PlayerStatus);
														 
handle(?PP_PLAYER_ACTIVE_STATE,PlayerStatus,[]) ->
	lib_active:get_active_state(PlayerStatus);

handle(?PP_HIDE_FASHION,PlayerStatus,[State]) ->
	if
		 PlayerStatus#ets_users.other_data#user_other.cloth_state =:= State ->
			 ok;
		 true ->
			Other = PlayerStatus#ets_users.other_data#user_other{cloth_state = State},
			<<Bin1:200, _:8, Bin2/binary>> = PlayerStatus#ets_users.style_bin,
			
			NewPlayerStatus = PlayerStatus#ets_users{other_data = Other,style_bin = <<Bin1:200, State:8, Bin2/binary>>},
			
			
			{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus]),
			%%样式广播周围玩家
			mod_map_agent:send_to_area_scene(
			  NewPlayerStatus#ets_users.current_map_id,
			  NewPlayerStatus#ets_users.pos_x,
			  NewPlayerStatus#ets_users.pos_y,
			  PlayerScenBin),
			{update_map, NewPlayerStatus}
	end;
	



handle(?PP_PLAYER_ACTIVE_OPEN_SERVER,PlayerStatus,[]) ->
	List = lib_active_open_server:get_all(),
	
	{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_OPEN_SERVER,List),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);


handle(?PP_PLAYER_ACTIVE_FIRST_PAY,PlayerStatus,[]) ->
	List = lib_active_open_server:get_all(),
	case lists:keyfind(1, #ets_users_open_server.group_id, List) of
		false ->
			skip;
		Info when(Info#ets_users_open_server.num =:=0 ) ->
			{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_FIRST_PAY,[1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);
		_ ->
			skip
	end;

handle(?PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD,PlayerStatus,[Id,Gorup_ID]) ->
	case lib_active_open_server:get_award(PlayerStatus,Gorup_ID,Id) of
		{true,Count} ->
			case Count of
 				0 ->
					{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD,[1,Id,Gorup_ID]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);
				_ ->
					skip
			end;
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end,
	ok;

handle(?PP_PLAYER_YELLOW_INFO,PlayerStatus,[]) ->
	{ok,Bin} = pt_20:write(?PP_PLAYER_YELLOW_INFO,[PlayerStatus]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
	ok;

handle(?PP_PLAYER_YELLOW_GET_REWARD,PlayerStatus,[Type]) ->
	case lib_yellow:get_reward(PlayerStatus,Type) of
		{true,NewPlayerStatus} ->
			{ok,Bin} = pt_20:write(?PP_PLAYER_YELLOW_INFO,[NewPlayerStatus]),
			{ok,Bin1} = pt_20:write(?PP_PLAYER_YELLOW_GET_REWARD,[1,Type]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{update, NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			ok
	end;

%%7天活动列表
handle(?PP_ACTIVE_SEVEN,PlayerStatus,[]) ->
%% 	List = mod_activity_seven:get_info(),
	{ok,Bin} = pt_20:write(?PP_ACTIVE_SEVEN,[PlayerStatus#ets_users.seven_award_id,PlayerStatus#ets_users.seven_award2_id]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
	ok;

%%7天活动获取奖励
handle(?PP_ACTIVE_SEVEN_GETREWARD,PlayerStatus,[ID]) ->
	case  list_activity_seven:get_reward(PlayerStatus,ID) of
		{ok,NewPlayerStatus} ->
			{ok,Bin} = pt_20:write(?PP_ACTIVE_SEVEN,[NewPlayerStatus#ets_users.seven_award_id,NewPlayerStatus#ets_users.seven_award2_id]),
			{ok,Bin1} = pt_20:write(?PP_ACTIVE_SEVEN_GETREWARD,[1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{update, NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			ok
	end;

%%7天活动获取全民奖励
handle(?PP_ACTIVE_SEVEN_GET_ALL_REWARD,PlayerStatus,[_ID]) ->	
	case lib_activity_seven:get_day_reward(PlayerStatus) of
		{ok,NewPlayerStatus,BindYuanbao} ->
			if
				BindYuanbao >0 ->
					NewPlayerStatus1 = lib_player:add_cash_and_send(NewPlayerStatus,0,BindYuanbao,0,0);
				true ->
					NewPlayerStatus1 = NewPlayerStatus
			end,
			{ok,Bin} = pt_20:write(?PP_ACTIVE_SEVEN,[NewPlayerStatus#ets_users.seven_award_id,NewPlayerStatus#ets_users.seven_award2_id]),
			{ok,Bin1} = pt_20:write(?PP_ACTIVE_SEVEN_GET_ALL_REWARD,[1]),
			lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{update,NewPlayerStatus1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			ok
	end;

%%获取交易token 
handle(?PP_QQ_BUY_GOODS,PlayerStatus,[ZoneID,Domain,ShopItemID,ShopItemNum,OpenKey,Pf,PfKey]) ->
	mod_tokey:get_tokey(PlayerStatus#ets_users.other_data#user_other.pid_send,
						PlayerStatus#ets_users.user_name,ShopItemID,Domain,ShopItemNum,ZoneID,OpenKey,Pf,PfKey),
	ok;

%% 兑换绑定银两
handle(?PP_GET_BIND_YUANBAO,PlayerStatus,[Type]) ->
	NewPlayerStatus = lib_player:exchange_bind_yuanbao(PlayerStatus,Type),
	{update, NewPlayerStatus};

handle(?PP_DUPLICATE_SHENYOU,PlayerStatus,[ID,Times,ExpPill]) ->
	NewPlayerStatus = lib_shenyou:start_shenyou(PlayerStatus,ID,Times,ExpPill),
	{update, NewPlayerStatus};
	
handle(?PP_DUPLICATE_SHENYOU_COMPLATE,PlayerStatus,[]) ->
	NewPlayerStatus = lib_shenyou:shenyou_complated(PlayerStatus),
	{update, NewPlayerStatus};

handle(?PP_DUPLICATE_SHENYOU_INTERRUPT,PlayerStatus,[]) ->
	NewPlayerStatus = lib_shenyou:shenyou_interrupt(PlayerStatus),
	{update, NewPlayerStatus};

%% handle(?PP_HIDE_WEAPONACCES,PlayerStatus,[]) ->
%% 	ok;


handle(Cmd, _, _) ->
	?DEBUG("pp_player cmd is not : ~w",[Cmd]),
	ok.
%%
%% Local Functions
%%

