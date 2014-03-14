%% Author: Administrator
%% Created: 2011-6-2
%% Description: TODO: Add description to lib_vip
-module(lib_vip).


%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([init_vip_award/0,
		 vip_card_use/2,
		 get_vip_template/1,
		 get_vip_award/2,
		 update_vip_by_timer/2,
		 load_vip/2,
		 change_dbvip_to_vipid/1,
		 check_vip_refresh/1]).

%%
%% API Functions
%%
%% 将数据库中以位计算的vipid转换为真实的模板vip_id
change_dbvip_to_vipid(VipID) ->
	if VipID band ?VIP_BSL_WEEK =/= 0 ->
		   ?VIP_WEEK_ID;
	   VipID band ?VIP_BSL_MONTH =/= 0 ->
		   ?VIP_MONTH_ID;
	   VipID band ?VIP_BSL_HALFYEAR =/= 0 ->
		   ?VIP_HALF_YEAR_ID;
	   VipID band ?VIP_BSL_DAY =/= 0 ->
		   ?VIP_ONE_DAY_ID;
	   VipID band ?VIP_BSL_ONEHOUR =/= 0 ->
		   ?VIP_ONE_HOUR_ID;
	   true ->
		   ?VIP_NONE
	end.
	
%% 将模板vipid转换到数据库位处理的vipid
change_vipid_to_dbvip(PlayerVipID, VipID) ->
	case VipID of 
		?VIP_WEEK_ID ->
			PlayerVipID bor ?VIP_BSL_WEEK;
		?VIP_MONTH_ID ->
			PlayerVipID bor ?VIP_BSL_MONTH;
		?VIP_HALF_YEAR_ID ->
			PlayerVipID bor ?VIP_BSL_HALFYEAR;
		?VIP_ONE_DAY_ID ->
			PlayerVipID bor ?VIP_BSL_DAY;
		?VIP_ONE_HOUR_ID ->
			PlayerVipID bor ?VIP_BSL_ONEHOUR;
		_ ->
			PlayerVipID
	end.

%% 将模板vipid在从数据库位处理数据中删除
delete_vipid_to_dbvip(PlayerVipID, VipID) ->
	case VipID of
		?VIP_WEEK_ID ->
			PlayerVipID bxor ?VIP_BSL_WEEK;
		?VIP_MONTH_ID ->
			PlayerVipID bxor ?VIP_BSL_MONTH;
		?VIP_HALF_YEAR_ID ->
			PlayerVipID bxor ?VIP_BSL_HALFYEAR;
		?VIP_ONE_DAY_ID ->
			PlayerVipID bxor ?VIP_BSL_DAY;
		?VIP_ONE_HOUR_ID ->
			PlayerVipID bxor ?VIP_BSL_ONEHOUR;
		_ ->
			PlayerVipID
	end.

%% check_vipid(OldVipID,NewVipID) ->
%% 	case NewVipID of
%% 		?VIP_ONE_DAY_ID ->
%% 			OldVipID =:= ?VIP_WEEK_ID;
%% 		?VIP_ONE_HOUR_ID ->
%% 			OldVipID =:= ?VIP_HALF_YEAR_ID;
%% 		_ ->
%% 			OldVipID =:= NewVipID
%% 	end.


%%加载模板
init_vip_award() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_vip_template] ++ Info),	
				ItemsList = tool:split_string_to_intlist(Record#ets_vip_template.items),
				Buffs = tool:split_string_to_intlist(Record#ets_vip_template.buffs),
				NewRecord = Record#ets_vip_template {items =ItemsList, buffs = Buffs},
				ets:insert(?ETS_VIP_TEMPLATE, NewRecord)
		end,
	L = db_agent_template:get_vip_template(),
	lists:foreach(F, L),
	ok.

%% 使用vip卡
vip_card_use(PlayerStatus,Place) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'vip_card_use', Place}) of
		{true,VipClass} ->
			NewPlayerStatus = update_vip(PlayerStatus,VipClass),
%% 			case  VipClass#ets_vip_template.vip_id =:= ?VIP_ONE_HOUR_ID of
%% 				true ->
%% 					{ok,Bin} = pt_20:write(?PP_PLAYER_VIP_ONE_HOUR,[1]),
%% 					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin);
%% 				_ ->
%% 					skip
%% 			end,
			lib_active_open_server:use_vip(VipClass#ets_vip_template.vip_id,NewPlayerStatus),
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_VIP_CAR,{VipClass#ets_vip_template.vip_id,1}}]),
			{ok,NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	
	end.




update_vip(PlayerStatus,VipInfo) ->
	Time = misc_timer:now_seconds(),
	
	case change_dbvip_to_vipid(PlayerStatus#ets_users.vip_id) of
		0 ->	%%非vip 直接处理
			VipOther = PlayerStatus#ets_users.other_data#user_other{vip_exp_rate = VipInfo#ets_vip_template.exp_rate / 100,
																	vip_strength_rate = VipInfo#ets_vip_template.strength_rate / 100,
																	vip_drop_rate = VipInfo#ets_vip_template.drop_rate / 100,
																	vip_hole_rate = VipInfo#ets_vip_template.hole_rate / 100,
																	vip_lifeexp_rate = VipInfo#ets_vip_template.lifeexp_rate / 100,
																	vip_mounts_stair_rate = VipInfo#ets_vip_template.mounts_stair_rate * 100,
																	vip_pet_stair_rate = VipInfo#ets_vip_template.pet_stair_rate * 100,
																	vip_vein_rate = VipInfo#ets_vip_template.vein_rate
																	},
			
			PlayerStatus#ets_users{
								   vip_refresh_date = Time,
								   vip_id = change_vipid_to_dbvip(PlayerStatus#ets_users.vip_id,VipInfo#ets_vip_template.vip_id),
								   vip_date = Time + (VipInfo#ets_vip_template.effect_date),
								   vip_tranfer_shoes = VipInfo#ets_vip_template.tranfer_shoe,
								   vip_bugle = VipInfo#ets_vip_template.bugle,
								   other_data = VipOther
								   };
		OldVipID ->
			update_vip2(PlayerStatus, OldVipID, VipInfo, Time)
	end.

update_vip2(PlayerStatus,OldVipID, VipInfo, Time) ->
	case OldVipID =:= VipInfo#ets_vip_template.vip_id of
		true ->
		   %% 类型相同，时间叠加,更新时间
		   VipOther = PlayerStatus#ets_users.other_data#user_other{vip_exp_rate = VipInfo#ets_vip_template.exp_rate / 100,
																   vip_strength_rate = VipInfo#ets_vip_template.strength_rate / 100,
																   vip_drop_rate = VipInfo#ets_vip_template.drop_rate / 100,
																   vip_hole_rate = VipInfo#ets_vip_template.hole_rate / 100,
																   vip_lifeexp_rate = VipInfo#ets_vip_template.lifeexp_rate / 100,
																   vip_mounts_stair_rate = VipInfo#ets_vip_template.mounts_stair_rate * 100,
																   vip_pet_stair_rate = VipInfo#ets_vip_template.pet_stair_rate * 100,
																   vip_vein_rate = VipInfo#ets_vip_template.vein_rate
																  },
		   PlayerStatus#ets_users{
								   vip_refresh_date = Time,
								  vip_date = PlayerStatus#ets_users.vip_date + (VipInfo#ets_vip_template.effect_date),
								  other_data = VipOther
								 };
	   _ ->
		   %% 类型不同，时间覆盖,更新时间
			VipOther = PlayerStatus#ets_users.other_data#user_other{vip_exp_rate = VipInfo#ets_vip_template.exp_rate / 100,
																	vip_strength_rate = VipInfo#ets_vip_template.strength_rate / 100,
																	vip_drop_rate = VipInfo#ets_vip_template.drop_rate / 100,
																	vip_hole_rate = VipInfo#ets_vip_template.hole_rate / 100,
																	vip_lifeexp_rate = VipInfo#ets_vip_template.lifeexp_rate / 100,
																	vip_mounts_stair_rate = VipInfo#ets_vip_template.mounts_stair_rate * 100,
																	vip_pet_stair_rate = VipInfo#ets_vip_template.pet_stair_rate * 100,
																	vip_vein_rate = VipInfo#ets_vip_template.vein_rate
																	
																	},
			NewVipID0 =  delete_vipid_to_dbvip(PlayerStatus#ets_users.vip_id,OldVipID),
			NewVipID =  change_vipid_to_dbvip(NewVipID0,VipInfo#ets_vip_template.vip_id),
			PlayerStatus#ets_users{
								   vip_refresh_date = Time,
								   vip_id = NewVipID,
								   vip_date = Time + (VipInfo#ets_vip_template.effect_date),
								   vip_tranfer_shoes = VipInfo#ets_vip_template.tranfer_shoe,
								   vip_bugle = VipInfo#ets_vip_template.bugle,
								   vip_yuanbao_date = 0,
								   vip_money_date = 0,
								   vip_buff_date = 0,
								   other_data = VipOther
								   }
	end.

%% 获取vip模板
get_vip_template(VipClass) ->
	data_agent:get_vip_template(VipClass).

%% 获取vip奖励
get_vip_award(PlayerState,Place) ->
	case  change_dbvip_to_vipid(PlayerState#ets_users.vip_id) of
		0 ->
			{false};
		VipID ->
			get_vip_award1(PlayerState, VipID,Place)
	end.

get_vip_award1(PlayerState, VipID,Place) ->
	Now = misc_timer:now_seconds(),
	case Place of
		0 -> %% 元宝
			get_vip_award1_1(PlayerState,
							 VipID,
							 Now,
							 Now,
							 PlayerState#ets_users.vip_money_date,
							 PlayerState#ets_users.vip_buff_date,
							 PlayerState#ets_users.vip_yuanbao_date,
							 Place);
		1 -> %% 铜币
			get_vip_award1_1(PlayerState,
							 VipID,
							 Now,
							 PlayerState#ets_users.vip_yuanbao_date,
							 Now,
							 PlayerState#ets_users.vip_buff_date,
							 PlayerState#ets_users.vip_money_date,
							 Place);
		_ -> %% buff
			get_vip_award1_1(PlayerState,
							 VipID,
							 Now,
							 PlayerState#ets_users.vip_yuanbao_date,
							 PlayerState#ets_users.vip_money_date,
							 Now,
							 PlayerState#ets_users.vip_buff_date,
							 Place)
	end.

			
get_vip_award1_1(PlayerState, VipID,Now,Data1,Data2,Data3,PerDate,Place) ->
	case util:is_same_date(Now,PerDate) of	%%true 同天
		true ->
		   {false};
		_ ->
		   get_vip_award2(PlayerState,Data1,Data2,Data3, VipID,Place)
	end.

get_vip_award2(PlayerState,Data1,Data2,Data3, VipID,Place) ->
	case get_vip_template(VipID) of
		[] ->
			{false};
		VipInfo ->
			case Place of
				0 ->
					NewState = lib_player:add_cash_and_send(PlayerState,
													0,
													VipInfo#ets_vip_template.yuanbao,
													0,
													0,{?GAIN_MONEY_VIP_AWARD, VipID,1});
				1 ->
					NewState = lib_player:add_cash_and_send(PlayerState,
													0,
													0,
													0,
													VipInfo#ets_vip_template.money,{?GAIN_MONEY_VIP_AWARD, VipID,1});
				_ ->
					F = fun({BuffId},PlayerStatus) ->
								lib_buff:add_buff(BuffId, PlayerStatus)
						end,
					NewState = lists:foldl(F, PlayerState, VipInfo#ets_vip_template.buffs)
			end,
			{ok,NewState#ets_users{vip_yuanbao_date = Data1,vip_money_date =Data2, vip_buff_date=Data3}}
	end.
	

%%定时处理vip
update_vip_by_timer(PlayerState, Now) ->
	NowTime = tool:floor(Now / 1000),
	%% 检查是否过期
	if NowTime > PlayerState#ets_users.vip_date ->
		   {ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL,[1,0,0,0,0,1,1,1]),
		   
		   lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, VipBin),
	   
		   VipOther = PlayerState#ets_users.other_data#user_other{vip_exp_rate = 0,
																  vip_strength_rate = 0,
																  vip_drop_rate = 0,
																  vip_hole_rate = 0,
																  vip_lifeexp_rate = 0},
		   OldVipID = change_dbvip_to_vipid(PlayerState#ets_users.vip_id),
		   NewPlayerStatus = PlayerState#ets_users{
								 vip_id = delete_vipid_to_dbvip(PlayerState#ets_users.vip_id,OldVipID),
								 vip_tranfer_shoes = 0,
								 vip_bugle = 0,
								 other_data = VipOther
								 },
		   {ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD, [NewPlayerStatus]),
			mod_map_agent: send_to_area_scene(NewPlayerStatus#ets_users.current_map_id,
											  NewPlayerStatus#ets_users.pos_x,
											  NewPlayerStatus#ets_users.pos_y,
											  PlayerData,
											  undefined),
		   NewPlayerStatus;
	   true ->
		   update_vip_by_timer1(PlayerState,NowTime)
	end.

update_vip_by_timer1(PlayerState,NowTime) ->
	case util:is_same_date(PlayerState#ets_users.vip_refresh_date, NowTime) of
		true -> %% 同天不处理
			PlayerState;
		_ ->	%%跨天，重置鞋子，更新时间
			update_vip_by_timer2(PlayerState,NowTime)
	end.

update_vip_by_timer2(PlayerState, NowTime) ->
	Vip_ID = change_dbvip_to_vipid(PlayerState#ets_users.vip_id),
	case data_agent:get_vip_template(Vip_ID) of
		[] ->
			PlayerState;
		VipInfo ->
			{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [PlayerState#ets_users.vip_id,
															  PlayerState#ets_users.vip_date,
															  VipInfo#ets_vip_template.tranfer_shoe,
															  VipInfo#ets_vip_template.bugle,
															  0,0,0]),
			lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, VipBin),
			PlayerState#ets_users{vip_tranfer_shoes = VipInfo#ets_vip_template.tranfer_shoe,
								  vip_bugle = VipInfo#ets_vip_template.bugle,
								  vip_refresh_date = NowTime}
	end.
				   
%% 登录时处理vip信息
load_vip(PlayerStatus,NowSecond) ->
	RepeatDay = util:get_diff_days(PlayerStatus#ets_users.vip_refresh_date, NowSecond),
	case change_dbvip_to_vipid(PlayerStatus#ets_users.vip_id) of
		?VIP_NONE ->
			PlayerStatus;
		Vip_ID ->
			load_vip1(PlayerStatus,Vip_ID,NowSecond,RepeatDay)
	end.

load_vip1(PlayerStatus,Vip_ID,NowSecond,RepeatDay) ->
	if PlayerStatus#ets_users.vip_date < NowSecond -> %%vip到期
		   PlayerStatus#ets_users{vip_id = delete_vipid_to_dbvip(PlayerStatus#ets_users.vip_id,Vip_ID),
								  vip_tranfer_shoes = 0,
								  vip_bugle = 0
								 };
	   RepeatDay >= 1 ->
		   %%还是vip，跨天，重置飞鞋数，加载经验倍数
		   case get_vip_template(Vip_ID) of
			   [] ->
				   PlayerStatus;
			   VipInfo ->
				   VipOther = PlayerStatus#ets_users.other_data#user_other{vip_exp_rate = VipInfo#ets_vip_template.exp_rate / 100,
																		  vip_strength_rate = VipInfo#ets_vip_template.strength_rate / 100,
																		  vip_drop_rate = VipInfo#ets_vip_template.drop_rate / 100,
																		  vip_hole_rate = VipInfo#ets_vip_template.hole_rate / 100,
																		  vip_lifeexp_rate = VipInfo#ets_vip_template.lifeexp_rate / 100
																		  },
				   PlayerStatus#ets_users{
										  vip_refresh_date = NowSecond,
										  vip_tranfer_shoes = VipInfo#ets_vip_template.tranfer_shoe,
										  vip_bugle = VipInfo#ets_vip_template.bugle,
										  other_data = VipOther}
		   end;
	   
	   true ->
		   %% vip，未跨天
		   case lib_vip:get_vip_template(Vip_ID) of
			   [] ->
				   PlayerStatus;
			   VipInfo ->
				   VipOther = PlayerStatus#ets_users.other_data#user_other{vip_exp_rate = VipInfo#ets_vip_template.exp_rate / 100,
																		  vip_strength_rate = VipInfo#ets_vip_template.strength_rate / 100,
																		  vip_drop_rate = VipInfo#ets_vip_template.drop_rate / 100,
																		  vip_hole_rate = VipInfo#ets_vip_template.hole_rate / 100,
																		  vip_lifeexp_rate = VipInfo#ets_vip_template.lifeexp_rate / 100
																		  },
				   PlayerStatus#ets_users{other_data = VipOther}
		   end
	end.

check_vip_refresh(PlayerStatus) ->
	NowSecond = misc_timer:now_seconds(),
	RepeatDay = util:get_diff_days(PlayerStatus#ets_users.vip_refresh_date, NowSecond),
	PlayerStatus1 = PlayerStatus#ets_users{vip_refresh_date = NowSecond},
	
	case change_dbvip_to_vipid(PlayerStatus1#ets_users.vip_id) of
		?VIP_NONE ->
			NewPlayerStatus = PlayerStatus1#ets_users{
													vip_tranfer_shoes = 0,
													vip_bugle = 0
												   },
			{NewPlayerStatus,0,0,0};
		Vip_ID ->
			check_vip_refresh_1(PlayerStatus1,Vip_ID,NowSecond,RepeatDay)
	end.
			
check_vip_refresh_1(PlayerStatus,Vip_ID,NowSecond,RepeatDay) ->
	if 
		PlayerStatus#ets_users.vip_date < NowSecond -> %%vip到期
			NewPlayerStatus = PlayerStatus#ets_users{
													vip_id = delete_vipid_to_dbvip(PlayerStatus#ets_users.vip_id,Vip_ID),
													vip_tranfer_shoes = 0,
													vip_bugle = 0
												   },
			{NewPlayerStatus,0,0,0};
		RepeatDay >= 1 ->
			case get_vip_template(Vip_ID) of
			   [] ->
				   NewPlayerStatus = PlayerStatus#ets_users{
													vip_tranfer_shoes = 0,
													vip_bugle = 0
												   },
				   {NewPlayerStatus,0,0,0};
				VipInfo ->
				   NewPlayerStatus = PlayerStatus#ets_users{
										  vip_refresh_date = NowSecond,
										  vip_tranfer_shoes = VipInfo#ets_vip_template.tranfer_shoe,
										  vip_bugle = VipInfo#ets_vip_template.bugle},
				   IsGetAward1 = case util:is_same_date(NowSecond,PlayerStatus#ets_users.vip_yuanbao_date) of
									 true ->
										 1;
									 _ ->
										 0
								 end,
				   IsGetAward2 = case util:is_same_date(NowSecond,PlayerStatus#ets_users.vip_money_date) of
									  true ->
										  1;
									  _ ->
										  0
								  end,
				   IsGetAward3 = case util:is_same_date(NowSecond,PlayerStatus#ets_users.vip_buff_date) of
									  true ->
										  1;
									  _ ->
										  0
								  end,
				   {NewPlayerStatus,IsGetAward1,IsGetAward2,IsGetAward3}
			end;
		true ->
			 IsGetAward1 = case util:is_same_date(NowSecond,PlayerStatus#ets_users.vip_yuanbao_date) of
									 true ->
										 1;
									 _ ->
										 0
								 end,
			 IsGetAward2 = case util:is_same_date(NowSecond,PlayerStatus#ets_users.vip_money_date) of
									  true ->
										  1;
									  _ ->
										  0
								  end,
			 IsGetAward3 = case util:is_same_date(NowSecond,PlayerStatus#ets_users.vip_buff_date) of
									  true ->
										  1;
									  _ ->
										  0
								  end,
			 {PlayerStatus,IsGetAward1,IsGetAward2,IsGetAward3}
	end.
	
	
			
			  
%%
%% Local Functions
%%

  				
					
					
					
					
