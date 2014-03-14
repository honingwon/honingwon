%% Author: 
%% Created: 

%% Description: TODO: 战斗相关
-module(lib_battle).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-define(MAX_MAGIC_REDUCE,65). %减伤比例
-define(MAX_RANGE_REDUCE,65).
-define(MAX_VINDICTIVE_REDUCE,65).
-define(New_Player_Level,25). %新手保护级别 
-define(Buff_Percent,100). %buff命中上限
-define(PK_CHECK, 1).	%进行了PK检测，如成功更新本人主动pk时间
-define(PK_NO_NEED,2).	%不需PK检测，不需处理


-define(NO_PK_MAP,[{1021},{2070},{9000003}]).				%% 不允许pk地图id

%计算种类
-define(CalcAttack, 1).	
-define(CalcMump, 2).
-define(CalcMagic, 3).
-define(CalcFar, 4). 

-define(ACTOR_HP, 21).
-define(ACTOR_MP, 22).
-define(Target_HP, 23).
-define(Target_MP, 24).

-export([
		 init_battle_data_mon/1,					%%初始化战斗信息
		 init_battle_data_pet/2,					%%初始化战斗信息
		 init_battle_data_player/1,					%%初始化战斗信息
		 init_battle_data_player/2,					%%战斗信息修改
		 battle_start/8,
		 battle_second/8,
		 battle_cancel_perpare/2,
		 standup/2,
		 common_fight/1
		]).


%====================================
%关于pk，单体时在第一步进行mode判断，群体在第二步进行mode判断
%====================================


%%=============================================================================================================
%% API Functions
%%=============================================================================================================

%=========================================================================
%% 战斗起身后无敌转回正常
common_fight(ID) ->
	case lib_map:get_online_player(ID) of
		Player when is_record(Player, ets_users) ->
			common_fight1(Player);
		_ ->
			{false}
	end.

common_fight1(Player) ->
	case Player#ets_users.other_data#user_other.player_now_state =:= ?ELEMENT_STATE_INVINCIBLE of
		true ->
			common_fight2(Player);
		_ ->
			{false}
	end.

common_fight2(Player) ->
	OtherData = Player#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_FIGHT},
	NewPlayer = Player#ets_users{other_data = OtherData},
	{ok,NewPlayer}.

%% 战斗起身 目前只有玩家会被击倒
standup(ID,Pid) ->
	case lib_map:get_online_player(ID) of
		Player when is_record(Player, ets_users) ->
			standup1(Player, misc_timer:now_seconds());
		_ ->
			{false}
	end.

standup1(Player, StandupTime) ->
	case Player#ets_users.other_data#user_other.player_now_state =:= ?ELEMENT_STATE_HITDOWN andalso
		Player#ets_users.current_hp > 0 andalso 
		StandupTime >= Player#ets_users.other_data#user_other.player_standup_date of
		true ->
			standup2(Player);
		_ ->
			{false}
	end.

standup2(Player) ->
	OtherData = Player#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_INVINCIBLE},	%% 起身后暂时无敌
	%% 发通知
	NewPlayer = Player#ets_users{other_data = OtherData},
	{ok, NewPlayer}.

%% 自行打断
battle_cancel_perpare(ActorID, ActorType) ->
	case ActorType of
		?ELEMENT_PLAYER ->
			case lib_map:get_online_player(ActorID) of
				Actor when is_record(Actor,ets_users) ->					
					BattleInfo = Actor#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare ={},
																							   element_state = ?ELEMENT_STATE_FIGHT},
					OtherData = Actor#ets_users.other_data#user_other{battle_info = BattleInfo},
					NewActor = Actor#ets_users{other_data = OtherData},
%% 					battle_update(?ELEMENT_PLAYER,NewActor),
					battle_update_self_hpmp(BattleInfo#battle_info.type,
								   BattleInfo#battle_info.pid,
								   BattleInfo#battle_info.id,
								   0,
								   0,?ELEMENT_STATE_FIGHT),
					lib_map:update_online_dic(NewActor);
				true ->
					skip
			end;
		_ ->
			case lib_map:get_online_monster(ActorID, ?ELEMENT_MONSTER) of
				Actor when is_record(Actor, r_mon_info) ->
					BattleInfo = Actor#r_mon_info.battle_info#battle_info{skill_prepare = {},
																		  element_state = ?ELEMENT_STATE_FIGHT},
					NewActor = Actor#r_mon_info{battle_info = BattleInfo},
%% 					battle_update(?ELEMENT_MONSTER,NewActor),
					battle_update_self_hpmp(BattleInfo#battle_info.type,
								   BattleInfo#battle_info.pid,
								   BattleInfo#battle_info.id,
								   0,
								   0,?ELEMENT_STATE_FIGHT),
					lib_map:update_mon_dic(NewActor);
				true ->
					skip
			end
	end.

%% ==================================战斗第一步 start =========================================
% 战斗第一步，成功后进行蓄气
battle_start(ActorID,TargetID,SkillData,SkillList,X,Y,TargetType,ActorType) ->
	%% 纠正对象
	{NewTargetID,NewTargetType} = case (ActorType =:= ?ELEMENT_PLAYER andalso 
										   SkillData#ets_skill_template.active_side =:= ?Skill_Target_Self) orelse
										   (ActorType =:= ?ELEMENT_PLAYER andalso 
										   SkillData#ets_skill_template.active_side =:= ?Skill_Target_Self_Group andalso TargetID=:=0 )
																		 of
									 true ->
										 {ActorID,ActorType};
									 _ ->
										if
											TargetType =:= 8 ->
												{TargetID,?ELEMENT_MONSTER};
											true ->
												 {TargetID,TargetType}
										end
								 end,
	case ActorType of 
		?ELEMENT_PLAYER ->
			case lib_map:get_online_player(ActorID) of
				Actor when is_record(Actor, ets_users) ->
					%?DEBUG("actor info:~p",[{Actor#ets_users.camp, Actor#ets_users.other_data#user_other.battle_info#battle_info.camp}]),
					case check_skill_not_prepare(Actor#ets_users.other_data#user_other.battle_info#battle_info.skill_prepare) of
						{ok} ->
							battle_start1(Actor,
										  Actor#ets_users.other_data#user_other.battle_info,
										  Actor#ets_users.current_hp,
										  NewTargetID,
										  SkillData,
										  SkillList,
										  X,
										  Y,
										  ActorType,
										  NewTargetType);
						_ ->
							{false}
					end;
				_ ->
					{false}
			end;
		?ELEMENT_PET ->
			case lib_map:get_online_player(ActorID) of
				Actor when is_record(Actor, ets_users) ->
					if
						is_record(Actor#ets_users.other_data#user_other.pet_battle_info, battle_info) ->
								battle_start1(Actor,
										  Actor#ets_users.other_data#user_other.pet_battle_info,
										  1,
										  NewTargetID,
										  SkillData,
										  SkillList,
										  X,
										  Y,
										  ActorType,
										  NewTargetType);
						true ->
							?INFO_MSG("~s",["pet_battle_info is undefined"]),
							{false}
					end;				
			    _er ->
				   {false}
			end;
		_ ->
			case lib_map:get_online_monster(ActorID, ActorType) of
				Actor when is_record(Actor, r_mon_info) ->
					case check_skill_not_prepare(Actor#r_mon_info.battle_info#battle_info.skill_prepare) of
						{ok} ->
							battle_start1(Actor,
										  Actor#r_mon_info.battle_info,
										  Actor#r_mon_info.hp,
										  NewTargetID,
										  SkillData,
										  SkillList,
										  X,
										  Y,
										  ActorType,
										  NewTargetType);
						_er ->
							?DEBUG("error info:~p",[_er]),
							{false}
					end;
				_er2 ->
					%?DEBUG("error battle_start null tagert:~p",[{_er2,ActorID,TargetID,X,Y,TargetType,ActorType}]),
					{false}
			end
	end.

battle_start1(Actor,ActorBattleInfo,ActorHP,TargetID,SkillData,SkillList,X,Y,ActorType,TargetType) ->
	case SkillData#ets_skill_template.effect_number > 1 of 
		true -> %群攻
			if ActorHP > 0 -> %Target传空值
%% 				if ActorType =/= ?ACT_TYPE_ACT_OUR_TOWER ->
				   		battle_start2(Actor,ActorBattleInfo,[], [], X, Y, SkillData, SkillList, false,TargetType);
%% 					true ->
%% 						battle_start3(Actor,ActorBattleInfo,[],[],X,Y,SkillData,SkillList,false,TargetType)
%% 				end;
			   true ->
				   {false}
			end;
		_ ->
			%单攻	
			{Target,TargetBattleInfo, TargetHP} =
				case TargetType of
					?ELEMENT_PLAYER ->
						case lib_map:get_online_player(TargetID) of
							[] ->
								{[],[],0};
							OutTarget ->
								{OutTarget, 
								 OutTarget#ets_users.other_data#user_other.battle_info, 
								 OutTarget#ets_users.current_hp}
						end;
					_ ->
						if
							ActorType =:= ?ELEMENT_PLAYER orelse ActorType =:= ?ELEMENT_PET orelse ActorType =:= ?ELEMENT_OUR_TOWER -> %%玩家或宠物不允许攻击塔怪
								case lib_map:get_online_monster(TargetID, ?ELEMENT_MONSTER) of
									[] ->
										case lib_map:get_online_tower_mon(TargetID) of
											[] ->
												{ok, DataBin} = pt_12:write(?PP_REMOVE_MONSTER, [TargetID]),
												lib_send:send_to_sid(Actor#ets_users.other_data#user_other.pid_send, DataBin),
												{[],[],0};
											TowerMon ->
												if TowerMon#r_mon_info.hp =:= 0 ->
													  {ok, DataBin} = pt_12:write(?PP_REMOVE_MONSTER, [TargetID]),
													  lib_send:send_to_sid(Actor#ets_users.other_data#user_other.pid_send, DataBin),
													  {[],[],0}; 
												   true ->
													   {[],[],0}
												end
										end;
									OutTarget when (OutTarget#r_mon_info.template#ets_monster_template.camp =/= ActorBattleInfo#battle_info.camp) ->
										{OutTarget,OutTarget#r_mon_info.battle_info,OutTarget#r_mon_info.hp};
									_or ->
										%?DEBUG("camp info:~p",[{_or#r_mon_info.template#ets_monster_template.camp, ActorBattleInfo#battle_info.camp}]),
										{[],[],0}
								end;
							ActorType =:= ?ELEMENT_MONSTER -> %% 怪物不允许攻击普通怪
								case lib_map:get_online_tower_mon(TargetID) of
									[] ->
										%{ok, DataBin} = pt_12:write(?PP_REMOVE_MONSTER, [TargetID]),
										%lib_send:send_to_sid(Actor#ets_users.other_data#user_other.pid_send, DataBin),
										{[],[],0};
									OutTarget ->
										{OutTarget,OutTarget#r_mon_info.battle_info,OutTarget#r_mon_info.hp}
								end;
							true ->
								?DEBUG("error actorType:~p",[ActorType]),
								{[],[],0}
						end
				end,
			%% pk 需要检验模式 宠物打玩家时拿主人去检验
			if TargetType =:= ?ELEMENT_PLAYER andalso ActorType =:= ?ELEMENT_PLAYER ->
				   NeedCheckMode = true;
			   true ->
				   NeedCheckMode = false
			end,
			case TargetBattleInfo of
				[] ->
					{false};
				_ ->
					if (ActorHP > 0 andalso TargetHP > 0) ->
						   battle_start2(Actor,
										 ActorBattleInfo,
										 Target,
										 TargetBattleInfo,
										 X,
										 Y,
										 SkillData,
										 SkillList,
										 NeedCheckMode,
										 TargetType);
					   %%复活技能,跳过部分验证
					   ActorHP > 0 ->
						   case lists:keymember(?ATTR_TARGET_RELIVE,1,SkillData#ets_skill_template.skill_effect_list) of
							   true ->
								   battle_start4(Actor,
												 ActorBattleInfo,
												 Target,
												 TargetBattleInfo,
												 X,
												 Y,
												 SkillData,
												 SkillList,
												 TargetType);
							   _ ->
								   {false}
						   end;
					   %% 宠物战斗 跳过部分验证
					   ActorType =:= ?ELEMENT_PET andalso TargetHP > 0 -> 
						    battle_start3(Actor,
										  ActorBattleInfo,
										  Target,
										  TargetBattleInfo,
										  X,
										  Y,
										  SkillData,
										  SkillList,
										  NeedCheckMode,
										  TargetType);
					   true ->
						   {false}
					end
			end
	end.

battle_start2(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,SkillList,NeedCheckMode,TargetType) ->
	if SkillData#ets_skill_template.active_side =:= ?Skill_Target_Self orelse
		SkillData#ets_skill_template.active_type =:= ?ASSIST_SKILL orelse 
		SkillData#ets_skill_template.active_type =:= ?PET_PASV_SKILL ->
		   NewNeedCheckMode = false;
	   true ->
		   NewNeedCheckMode = NeedCheckMode
	end,
	battle_start3(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,SkillList,NewNeedCheckMode,TargetType).

battle_start3(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,SkillList,NeedCheckMode,TargetType) ->
	case check_battle_mode(NeedCheckMode,Actor,Target,SkillData#ets_skill_template.default_skill) of
		{true,PKCheck} ->
			if PKCheck =:= ?PK_CHECK ->
				   %通知本人更新主动pk时间 
				   gen_server:cast(ActorBattleInfo#battle_info.pid,{actor_pk,[{TargetBattleInfo#battle_info.id}]});
			   ActorBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER ->
				   %更新战斗时间
				   gen_server:cast(ActorBattleInfo#battle_info.pid,{actor_fight});
			   true ->
				   skip
			end,
			battle_start4(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,SkillList,TargetType);
		{false,_Msg} ->
			{false}
	end.


%% todo 公共cd
battle_start4(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,SkillList,TargetType) ->
	case check_skill_cost_condition0(Actor, ActorBattleInfo#battle_info.type,X, Y, SkillData, SkillList) of
		{mp_error} ->
			send_battle_no_calc(ActorBattleInfo),
			{false};
		{not_own_skill_error} ->
			send_battle_no_calc(ActorBattleInfo),
			{false};
		{range_error} ->
			send_battle_no_calc(ActorBattleInfo),
			{false};
		{skill_use_item_error} ->
			send_battle_no_calc(ActorBattleInfo),
			{false};
		{ok,MPOut} ->
			battle_start5(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,MPOut,TargetType);
		{error} ->
			send_battle_no_calc(ActorBattleInfo),
			{false}
	end.

battle_start5(Actor,ActorBattleInfo,Target,TargetBattleInfo,X,Y,SkillData,MPOut,TargetType) ->
	case check_skill_use_fr(Actor,
							ActorBattleInfo#battle_info.type,
							SkillData#ets_skill_template.skill_id,
							SkillData#ets_skill_template.cold_down_time) of
		{ok, StartTime, TmpNewActor, Type} ->
%% 			notice_mp(Actor,MPOut,X,Y),
			%%开始吟唱
			
			TimeOut = SkillData#ets_skill_template.prepare_time,
			case TimeOut > 0 of
				true ->
					case TargetBattleInfo of
						[] ->
							TargetBattleInfoID = 0,
							TargetBattleInfoType = ?ELEMENT_PLAYER;
						_ ->
							TargetBattleInfoID = TargetBattleInfo#battle_info.id,
							TargetBattleInfoType = TargetBattleInfo#battle_info.type
					end,
						%% todo 修改MP
					battle_update_self_hpmp(ActorBattleInfo#battle_info.type,
								   ActorBattleInfo#battle_info.pid,
								   ActorBattleInfo#battle_info.id,
								   0,
								   MPOut,?ELEMENT_STATE_READYFORPOWER),
					
					NewActorBattleInfo = case ActorBattleInfo#battle_info.element_state =:= ?ELEMENT_STATE_COMMON of
											 true ->
												 ActorBattleInfo#battle_info{element_state = ?ELEMENT_STATE_FIGHT};
											 _ ->
												 ActorBattleInfo
										 end,
					
					case Type of
						?ELEMENT_PLAYER ->
							NewBattleInfo = TmpNewActor#ets_users.other_data#user_other.battle_info#battle_info{element_state = ?ELEMENT_STATE_READYFORPOWER},
							NewOther = TmpNewActor#ets_users.other_data#user_other{battle_info=NewBattleInfo},
							NewActor = TmpNewActor#ets_users{other_data = NewOther},
							lib_map:update_online_dic(NewActor);
						?ELEMENT_PET ->
							NewBattleInfo = TmpNewActor#ets_users.other_data#user_other.pet_battle_info#battle_info{element_state = ?ELEMENT_STATE_READYFORPOWER},
							NewOther = TmpNewActor#ets_users.other_data#user_other{pet_battle_info=NewBattleInfo},
							NewActor = TmpNewActor#ets_users{other_data = NewOther},
							lib_map:update_online_dic(NewActor);
						?ELEMENT_OUR_TOWER ->							
							NewBattleInfo = TmpNewActor#r_mon_info.battle_info#battle_info{element_state = ?ELEMENT_STATE_READYFORPOWER},
							NewActor = TmpNewActor#r_mon_info{battle_info = NewBattleInfo},
							lib_map:update_tower_mon_dic(NewActor);
						_ ->
							NewBattleInfo = TmpNewActor#r_mon_info.battle_info#battle_info{element_state = ?ELEMENT_STATE_READYFORPOWER},
							NewActor = TmpNewActor#r_mon_info{battle_info = NewBattleInfo},
							lib_map:update_mon_dic(NewActor)
					end,
					%%保存状态
%% 					battle_update_self_hpmp(ActorBattleInfo#battle_info.type,
%% 								   ActorBattleInfo#battle_info.pid,
%% 								   ActorBattleInfo#battle_info.id,
%% 								   0,
%% 								   0,?ELEMENT_STATE_READYFORPOWER),
					
%% 					battle_update(Type,NewActor),
					%%发准备包
					send_battle_prepare_skill(NewActorBattleInfo,
											  SkillData#ets_skill_template.group_id,
											  SkillData#ets_skill_template.current_level,
											  ?SkillPrepare,
											  X,
											  Y),
					%%定时再执行
					erlang:send_after(TimeOut,
									  self(),	%% 使用本进程信息，防止用户的pid_map变了跑到别的节点去导致报错
									  {battle_second,[NewActorBattleInfo#battle_info.id,
													  NewActorBattleInfo#battle_info.type,
													  TargetBattleInfoID,
													  TargetBattleInfoType,
													  X,
													  Y,
													  SkillData,
													  StartTime]}),
					NextWorkTime = SkillData#ets_skill_template.straight_time,
					{ok,NextWorkTime,SkillData#ets_skill_template.skill_id};
				_ ->
					%% 瞬发技能
					case Type of
						?ELEMENT_PLAYER ->
							NewBattleInfo = TmpNewActor#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare = {},
																												element_state = ?ELEMENT_STATE_FIGHT},
							NewOther = TmpNewActor#ets_users.other_data#user_other{battle_info=NewBattleInfo},
							NewActor = TmpNewActor#ets_users{other_data = NewOther},
							lib_map:update_online_dic(NewActor);
						?ELEMENT_PET -> %% 宠物不需要修改战斗状态

							NewBattleInfo = TmpNewActor#ets_users.other_data#user_other.pet_battle_info#battle_info{skill_prepare = {},
																													element_state = ?ELEMENT_STATE_FIGHT},
							NewOther = TmpNewActor#ets_users.other_data#user_other{pet_battle_info=NewBattleInfo},
							NewActor = TmpNewActor#ets_users{other_data = NewOther},
							lib_map:update_online_dic(NewActor);
						?ELEMENT_OUR_TOWER ->
							NewBattleInfo = TmpNewActor#r_mon_info.battle_info#battle_info{element_state = ?ELEMENT_STATE_READYFORPOWER},
							NewActor = TmpNewActor#r_mon_info{battle_info = NewBattleInfo},
							lib_map:update_tower_mon_dic(NewActor);
						_ ->
							NewBattleInfo = TmpNewActor#r_mon_info.battle_info#battle_info{element_state = ?ELEMENT_STATE_FIGHT},
							NewActor = TmpNewActor#r_mon_info{battle_info = NewBattleInfo},
							lib_map:update_mon_dic(NewActor)
					end,
					%% todo 修改MP
					
					battle_update_self_hpmp(ActorBattleInfo#battle_info.type,
						   ActorBattleInfo#battle_info.pid,
						   ActorBattleInfo#battle_info.id,
						   0,
						   MPOut,?ELEMENT_STATE_FIGHT),
					
					NewActorBattleInfo = case ActorBattleInfo#battle_info.element_state =:= ?ELEMENT_STATE_COMMON of
											 true ->
												 ActorBattleInfo#battle_info{element_state = ?ELEMENT_STATE_FIGHT};
											 _ ->
												 ActorBattleInfo
										 end,
						
					battle_start6(NewActor,
								  NewActorBattleInfo,
								  Target,
								  X,
								  Y,
								  SkillData,
								  TargetType),

					NextWorkTime = SkillData#ets_skill_template.straight_time,
					{ok,NextWorkTime,SkillData#ets_skill_template.skill_id} %% 用于通知怪物控制时间
			end;
		{cd_error} ->
			?DEBUG("~w",[cd_error]),
			send_battle_no_calc(ActorBattleInfo), %%cd出错
			{false}
	end.

%% 不需要蓄气的，直接调用第二步计算
battle_start6(Actor,ActorBattleInfo,Target,X,Y,SkillData,TargetType) ->
	if SkillData#ets_skill_template.effect_number > 1 -> %群攻 - 需要check mode
		  MsgSkillType = group,
		  %?DEBUG("battle_start6t:~p",[{ActorBattleInfo#battle_info.camp,ActorBattleInfo#battle_info.type}]),	
		  if ActorBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER  orelse  ActorBattleInfo#battle_info.type =:= ?ELEMENT_PET ->
				 TmpPlayerList = lib_map:get_square_random_user_target( ActorBattleInfo#battle_info.camp,
																		X,
																 		Y,
																 		SkillData#ets_skill_template.radius,
																	   	SkillData#ets_skill_template.effect_number
																	   	),
				 %?DEBUG("get_square_random_user_target:~p",[{ActorBattleInfo#battle_info.camp,TmpPlayerList}]),			 
				 PlayerList = get_target_player_by_battle_mode(Actor,TmpPlayerList,[],SkillData#ets_skill_template.default_skill),
				 PlayerTargetCount = length(PlayerList),
				 if PlayerTargetCount > 0 ->
						%%通知本人更新主动pk时间
						NoticeIDL = change_battleinfo_to_id(PlayerList,[]),
						gen_server:cast(ActorBattleInfo#battle_info.pid,{actor_pk,NoticeIDL});
					true ->
						gen_server:cast(ActorBattleInfo#battle_info.pid,{actor_fight})
				 end,
				 TmpEffectNum = SkillData#ets_skill_template.effect_number - PlayerTargetCount,
				 case TmpEffectNum > 0 of
					 true ->
						 TmpMonsterList = lib_map:get_square_random_monster_target(
																			ActorBattleInfo#battle_info.camp,
																			X,
																			Y,
																			SkillData#ets_skill_template.radius,
																		    TmpEffectNum
																		    );
					 _ ->
						 TmpMonsterList = []
				 end,
				 TargetList = PlayerList ++ TmpMonsterList;
			 
			 true ->
				 case TargetType of
					 ?ELEMENT_MONSTER -> %% 选择守塔怪
						 if
							ActorBattleInfo#battle_info.type =:= ?ACT_TYPE_ACT_OUR_TOWER ->
								TargetList = lib_map:get_square_random_monster_target(-2,
																			 X,
																			 Y,
																			 SkillData#ets_skill_template.radius,
																			 SkillData#ets_skill_template.effect_number
																			 );
							true ->
						 		TargetList = lib_map:get_square_random_tower_target(X,
																			 Y,
																			 SkillData#ets_skill_template.radius,
																			 SkillData#ets_skill_template.effect_number
																			 )
						end;
%% 					 ?ELEMENT_OUR_TOWER ->
%% 						?DEBUG("ELEMENT_OUR_TOWER2:~p",[SkillData#ets_skill_template.effect_number]),
%% 						TargetList = lib_map:get_square_random_monster_target(X,
%% 																			 Y,
%% 																			 SkillData#ets_skill_template.radius,
%% 																			 SkillData#ets_skill_template.effect_number
%% 																			 );
					 _ ->
						 TargetList = lib_map:get_square_random_user_target(
																		Actor#r_mon_info.template#ets_monster_template.camp,
																		X,
																 		Y,
																 		SkillData#ets_skill_template.radius,
																	   	SkillData#ets_skill_template.effect_number
																	   	)
				 end
		  end;
	   true ->
		   MsgSkillType = single,
		   TargetList = [Target]
	end,
%% 	?DEBUG("TargetList info:~p",[{length(TargetList),ActorBattleInfo#battle_info.camp}]),
	%?DEBUG("TargetList info:~p",[{length(TargetList),ActorBattleInfo#battle_info.camp}]),
	battle_second3(TargetList,ActorBattleInfo,SkillData,X,Y,SkillData#ets_skill_template.current_level,
				   SkillData#ets_skill_template.group_id,MsgSkillType).

%% ==================================战斗第一步 end =========================================

%% ==================================战斗第二步 start =========================================

% 蓄气完成后第二步操作
battle_second(ActorID,ActorType,TargetID,TargetType,X,Y,SkillData,StartTime) ->
	if 
		ActorType =:= ?ELEMENT_PLAYER ->
		   case lib_map:get_online_player(ActorID) of
			   [] ->
				   Actor = [],
				   ActorBattleInfo = [];
			   T when is_record(T, ets_users) ->
				   Actor = T,
				   ActorBattleInfo = Actor#ets_users.other_data#user_other.battle_info
		   end; 
		ActorType =:= ?ELEMENT_PET ->
		   case lib_map:get_online_player(ActorID) of
			   [] ->
				   Actor = [],
				   ActorBattleInfo = [];
			   T when is_record(T, ets_users) ->
				   Actor = T,
				   ActorBattleInfo = Actor#ets_users.other_data#user_other.pet_battle_info
		   end; 
		ActorType =:= ?ELEMENT_OUR_TOWER ->
		   case lib_map:get_online_tower_monster(ActorID) of
			   [] ->
				   Actor = [],
				   ActorBattleInfo = [];
			   T when is_record(T, r_mon_info) ->
				   Actor = T,
				   ActorBattleInfo = Actor#r_mon_info.battle_info
		   end;
	   true ->
		   case lib_map:get_online_monster(ActorID, ?ELEMENT_MONSTER) of
			   [] ->
				   Actor = [],
				   ActorBattleInfo = [];
			   T when is_record(T, r_mon_info) ->
				   Actor = T,
				   ActorBattleInfo = Actor#r_mon_info.battle_info
		   end
	end,
	case ActorBattleInfo of
		[] ->
			skip;
		_ ->
			SkillID = SkillData#ets_skill_template.skill_id,
			case check_skill_prepare(Actor,
									ActorType,
									SkillID,
									StartTime) of
				{prepare_time_error} ->
					skip;
				{ok} ->
					battle_second1(Actor,ActorBattleInfo,TargetID,TargetType,SkillData,X,Y)
			end
	end.

battle_second1(Actor,ActorBattleInfo,TargetID,TargetType,SkillData,X,Y) ->
	if
		ActorBattleInfo#battle_info.element_state =/= ?ELEMENT_STATE_DEAD andalso
										   ActorBattleInfo#battle_info.element_state =/= ?ELEMENT_STATE_HITDOWN ->
			case ActorBattleInfo#battle_info.type of %% 准备已完成，调整状态
				?ELEMENT_PLAYER ->
					NewBattleInfo = Actor#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare = {},
																									 element_state = ?ELEMENT_STATE_FIGHT},
					NewOther = Actor#ets_users.other_data#user_other{battle_info=NewBattleInfo},
					NewActor =Actor#ets_users{other_data = NewOther},
					lib_map:update_online_dic(NewActor);
				?ELEMENT_PET ->
					NewBattleInfo = Actor#ets_users.other_data#user_other.pet_battle_info#battle_info{skill_prepare = {},
																									 element_state = ?ELEMENT_STATE_FIGHT},
					NewOther = Actor#ets_users.other_data#user_other{pet_battle_info=NewBattleInfo},
					NewActor =Actor#ets_users{other_data = NewOther},
					lib_map:update_online_dic(NewActor);
			   _ ->
				   NewBattleInfo = Actor#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare = {},
																									 element_state = ?ELEMENT_STATE_FIGHT},
				   NewActor =Actor#r_mon_info{battle_info = NewBattleInfo},
				   lib_map:update_mon_dic(NewActor)
		   end,
%% 		   battle_update(ActorBattleInfo#battle_info.type,NewActor),%%保存状态
		   battle_update_self_hpmp(ActorBattleInfo#battle_info.type,
								   ActorBattleInfo#battle_info.pid,
								   ActorBattleInfo#battle_info.id,
								   0,
								   0,?ELEMENT_STATE_FIGHT),
		   battle_second2(Actor,ActorBattleInfo,TargetID,TargetType,SkillData,X,Y);
	   true ->	%% 被打死，击倒，准备无效
		   skip
	end.
	

battle_second2(Actor,ActorBattleInfo,TargetID,TargetType,SkillData,X,Y) ->
	if SkillData#ets_skill_template.effect_number > 1 -> %群攻 - 需要check mode
		  MsgSkillType = group,
		  if ActorBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER orelse ActorBattleInfo#battle_info.type =:= ?ELEMENT_PET ->
				 TmpPlayerList = lib_map:get_square_random_user_target(ActorBattleInfo#battle_info.camp,
																		X,
																 		Y,
																 		SkillData#ets_skill_template.radius,
																	   	SkillData#ets_skill_template.effect_number
																	   	),
				 PlayerList = get_target_player_by_battle_mode(Actor,
															   TmpPlayerList,
															   [],
															   SkillData#ets_skill_template.default_skill),
				 PlayerTargetCount = length(PlayerList),
				 if PlayerTargetCount > 0 ->
						%%通知本人更新主动pk时间  
						NoticeIDL = change_battleinfo_to_id(PlayerList,[]),
						gen_server:cast(ActorBattleInfo#battle_info.pid,{actor_pk,NoticeIDL});
					true ->
						gen_server:cast(ActorBattleInfo#battle_info.pid,{actor_fight})
				 end,
				 TmpEffectNum = SkillData#ets_skill_template.effect_number - PlayerTargetCount,
				 case TmpEffectNum > 0 of
					 true ->
						 TmpMonsterList = lib_map:get_square_random_monster_target(
																			ActorBattleInfo#battle_info.camp,
																			X,
																			Y,
																			SkillData#ets_skill_template.radius,
																		    TmpEffectNum
																		    );
					 _ ->
						 TmpMonsterList = []
				 end,
				 TargetList = PlayerList ++ TmpMonsterList;
			 true ->
				case TargetType of
					 ?ELEMENT_MONSTER -> %% 选择守塔怪
						 TargetList = lib_map:get_square_random_monster_target(-2,
																			 X,
																			 Y,
																			 SkillData#ets_skill_template.radius,
																			 SkillData#ets_skill_template.effect_number
																			 );
					 ?ELEMENT_OUR_TOWER ->
						TargetList = lib_map:get_square_random_tower_target(-2,X,
																			 Y,
																			 SkillData#ets_skill_template.radius,
																			 SkillData#ets_skill_template.effect_number
																			 );
					 true ->
						 TargetList = lib_map:get_square_random_user_target(
																		Actor#r_mon_info.template#ets_monster_template.camp,
																		X,
																 		Y,
																 		SkillData#ets_skill_template.radius,
																	   	SkillData#ets_skill_template.effect_number
																	   	)
				 end
		  end;
	   true ->
		   MsgSkillType = single,
		   if 
			   ActorBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER orelse ActorBattleInfo#battle_info.type =:= ?ELEMENT_PET ->
				  if TargetType =:= ?ELEMENT_PLAYER ->
						 TargetSecond = lib_map:get_online_player(TargetID);
					 true ->
						 TargetSecond = lib_map:get_online_monster(TargetID, ?ELEMENT_MONSTER)
				  end;
			   true ->
				   if TargetType =:= ?ELEMENT_PLAYER ->
						  TargetSecond = lib_map:get_online_player(TargetID);
					TargetType =:= ?ELEMENT_MONSTER ->
						 TargetSecond = lib_map:get_online_monster(TargetID, ?ELEMENT_MONSTER);
					  true ->
						
						  TargetSecond = lib_map:get_online_tower_mon(TargetID)
				   end
		   end,
		   TargetList = [TargetSecond]
	end,
	battle_second3(TargetList,ActorBattleInfo,SkillData,X,Y,SkillData#ets_skill_template.current_level,
				   SkillData#ets_skill_template.group_id,MsgSkillType).

battle_second3(TargetList,ActorBattleInfo,SkillData,X,Y,SkillLv,SkillGroupID,MsgSkillType) ->
	F = fun(T,L) -> 
				TBattleInfo = if is_record(T,ets_users) ->
									 T#ets_users.other_data#user_other.battle_info;
								 true ->
									 T#r_mon_info.battle_info
							  end,
				case battle_second_detail(T,TBattleInfo,ActorBattleInfo,SkillData,MsgSkillType) of
					{Der,Msg} ->
						[LD,LM] = L,
						NLD = [Der|LD],
						NLM = [Msg|LM],
						[NLD,NLM];
					_ ->
						L
				end
		end,
	[DerMsg,Msg] = lists:foldl(F, [[],[]], TargetList),
	{ok, BinData} = write_battle_update(ActorBattleInfo,DerMsg,Msg,SkillLv,SkillGroupID,X,Y,MsgSkillType),
	send_battle_update(ActorBattleInfo,BinData,X,Y).

%% ==================================战斗第二步 end =========================================

%细节计算
battle_second_detail(TargetElement,TargetBattleInfo,ActorBattleInfo,SkillData,MsgSkillType) ->
	case TargetElement of 
		[] ->
			skip;
		_ ->
			NewActorBattleInfo = init_battle_data(ActorBattleInfo,TargetBattleInfo),
			SN = SkillData#ets_skill_template.skill_effect_list,
			case is_record(TargetElement, ets_users) of
				true ->
				   State = TargetElement#ets_users.other_data#user_other.player_now_state;
			    _ ->
				   State = ?ELEMENT_STATE_FIGHT
			end,
			NewTargetBattleInfo = case State of
							?ELEMENT_STATE_COMMON ->
								TargetBattleInfo#battle_info{element_state = ?ELEMENT_STATE_FIGHT};
							_ ->
								TargetBattleInfo#battle_info{element_state = State}
						end,
			
  			[NewAer,NewDer] = cale_active_effect_loop(SN,SkillData#ets_skill_template.skill_id,NewActorBattleInfo,NewTargetBattleInfo),
			battle_second_detail1(NewAer,
								  NewDer,
								  NewActorBattleInfo,
								  TargetElement,
								  TargetBattleInfo,
								  SkillData,
								  MsgSkillType,
								  NewTargetBattleInfo#battle_info.element_state)
	end.

battle_second_detail1(NewAer,NewDer,ActorBattleInfo,TargetElement,TargetBattleInfo,SkillData,MsgSkillType,OldNowState) ->
	DicCT = NewAer#battle_info.count_type,
 	DicTH = NewAer#battle_info.target_hp,
 	DicTM = NewAer#battle_info.target_mp,
	if 
		NewAer#battle_info.actor_hp > 0 ->
			gen_server:cast(NewAer#battle_info.pid,{reducehpmp_byself,NewAer#battle_info.actor_hp,?ELEMENT_STATE_FIGHT}),
		
			{TargetBattleInfo#battle_info{element_state = OldNowState},{addblood}};
		true ->
			case calc_hit(SkillData#ets_skill_template.active_type,NewAer#battle_info.hit_target,NewDer#battle_info.duck) of
				{hit} ->
					
					F = fun(X,L) -> 
								get_total_hurt1(X,L,NewAer,NewDer) 
						end, %%战斗效果
					HurtList = lists:foldl(F,[],DicCT),
					F2 = fun(X,L) -> 
								 get_total_hurt2(X,L) 
						 end,
					HurtTList = lists:foldl(F2,[[],0],HurtList), %调整成[[msg1,msg2],totalhurt]的效果
					[MsgList,HurtTotal] = HurtTList,	
					
					%%暴击
					case calc_critical(NewAer#battle_info.power_hit,NewDer#battle_info.deligency,SkillData#ets_skill_template.active_type) of
						{critical} ->
							Msg = {critical},
							HurtFinal = tool:ceil(HurtTotal * 1.5);
						_ ->
							Msg = get_msglist_to_msg(MsgList,{hit}),
							HurtFinal = HurtTotal
					end,
					%通过pid通知自身减
					if NewAer#battle_info.type =:= ?ELEMENT_MONSTER ->
						   HurtFinal1 = get_hurt_for_monster(HurtFinal,
															 NewAer#battle_info.acthurt_min,
															 NewAer#battle_info.acthurt_max);
					   NewDer#battle_info.type =:= ?ELEMENT_MONSTER ->
						   HurtFinal1 = get_hurt_for_monster(HurtFinal,
															 NewDer#battle_info.targethurt_min,
															 NewDer#battle_info.targethurt_max);
					   true ->
						   HurtFinal1 = HurtFinal
					end,
					%附加其他直接扣减值 
					HurtFinalHP = 
						case NewDer#battle_info.element_state of
							?ELEMENT_STATE_HITDOWN -> 
								if SkillData#ets_skill_template.default_skill =/= 1 -> %% 技能，即第一次击倒前,扣血正常
									   tool:floor(HurtFinal1 + DicTH ); %%* (100 + NewAer#battle_info.attack_suppression - NewDer#battle_info.defense_suppression) / 100);
								   true ->%% 击倒时 扣血减半
									   tool:floor((HurtFinal1 + DicTH ) * 0.5) %%* (100 + NewAer#battle_info.attack_suppression - NewDer#battle_info.defense_suppression) / 100 * 0.5) 
								end;
							_ -> %% 其他正常
								tool:floor(HurtFinal1 + DicTH ) %%* (100 + NewAer#battle_info.attack_suppression - NewDer#battle_info.defense_suppression) / 100)
						end,
					
					HurtFinalMP = DicTM, 
					
					%减target中值
					if
						is_record(TargetElement, ets_users) ->
							{HPList,MPList} = regulate_hp_mp(HurtFinalHP,HurtFinalMP,TargetElement#ets_users.current_hp,TargetElement#ets_users.current_mp),
							if
								TargetElement#ets_users.current_hp =< HurtFinalHP ->
									FinalState = ?ELEMENT_STATE_DEAD,
									FinalStandup = 0; 
								true ->
									FinalState = NewDer#battle_info.element_state,
									FinalStandup = NewDer#battle_info.element_standup_date
							end;
					   is_record(TargetElement, r_mon_info)->
							{HPList,MPList} = regulate_hp_mp(HurtFinalHP,HurtFinalMP,TargetElement#r_mon_info.hp,TargetElement#r_mon_info.mp),
							if
								 TargetElement#r_mon_info.hp =< HurtFinalHP ->
									 FinalState = ?ELEMENT_STATE_DEAD,
									 FinalStandup = 0; 
								 true ->
									 FinalState = NewDer#battle_info.element_state,
									 FinalStandup = NewDer#battle_info.element_standup_date
							end;
					   true ->
						   HPList = [],
						   MPList = [],
						   FinalState = NewDer#battle_info.element_state,
						   FinalStandup = NewDer#battle_info.element_standup_date
					end,
					Buff_List = tool:split_string_to_intlist(SkillData#ets_skill_template.buff_list),
					case length(Buff_List) > 0 of
						true ->
							%% todo 注意这里的处理修正了。传递的是修改的buff
							{HL,{BL,NBL,RemoveBuffList}} = battle_update_buff(ActorBattleInfo,TargetElement,NewDer,Buff_List),	%{BuffList,ChangeBuffList}
							NDMBattleInfo = NewDer#battle_info{
%% 														remove_buff_list = RemoveBuffList,
														new_buff_list = NBL,
													  	effect_hp = HPList,
													  	effect_mp = MPList,
													  	element_state = FinalState};
						_ ->
							BL = if is_record(TargetElement, ets_users) ->
										TargetElement#ets_users.other_data#user_other.buff_list;
									true ->
										TargetElement#r_mon_info.buff_list
								 end,
						    HL = [],
							NDMBattleInfo = NewDer#battle_info{
													  effect_hp = HPList,
													  effect_mp = MPList,
													  element_state = FinalState}
					end,
					AttackerName = if  ActorBattleInfo#battle_info.type =:= ?ELEMENT_PET ->
														ActorBattleInfo#battle_info.pet_owner_name;
													true ->
														ActorBattleInfo#battle_info.name
												end,
					case battle_update_target_info(NDMBattleInfo#battle_info.pid,
												   NDMBattleInfo#battle_info.id,
												   AttackerName,
												   ActorBattleInfo#battle_info.pid,
												   ActorBattleInfo#battle_info.id,
												   HurtFinalHP,
												   HurtFinalMP,
												   ActorBattleInfo#battle_info.type,
												   NDMBattleInfo#battle_info.type,
												   BL,
												   HL,
												   FinalState,
												   FinalStandup
												  ) of
						{ok} ->
							{NDMBattleInfo#battle_info{element_state = FinalState},Msg};
						_ ->
							{TargetBattleInfo#battle_info{element_state = OldNowState},{miss}}
					end;
				_ -> 
					{TargetBattleInfo#battle_info{element_state = OldNowState},{miss}}
			end
	end.

regulate_hp_mp(HurtFinalHP,HurtFinalMP,HP,MP) ->
	{ [HP-HurtFinalHP],[MP - HurtFinalMP]}.
			

%% regulate_hp_mp(HurtFinalHP,HurtFinalMP,HP,MP,Num) ->
%% 	L = case Num of
%% 		1 ->
%% 			{ [HP-HurtFinalHP],[MP - HurtFinalMP]};
%% 		2 ->
%% 			Random = util:rand(20, 40),
%% 			L1 = util:ceil(Random * HurtFinalHP / 100),
%% 			{[HP - L1,HP - HurtFinalHP],[0,MP - HurtFinalMP]};
%% 		3 ->
%% 			Random = util:rand(10, 20),
%% 			Random1 = util:rand(25, 30),
%% 			L1 = util:ceil(Random * HurtFinalHP / 100),
%% 			L2 = util:ceil(Random1 * HurtFinalHP / 100),
%% 			{[HP - L1,HP - L1 - L2,HP - HurtFinalHP],[0,0,MP - HurtFinalMP]};
%% 		_ ->
%% 			Random = util:rand(8, 10),
%% 			Random1 = util:rand(15, 20),
%% 			Random2 = util:rand(25, 35),
%% 			L1 = util:ceil( Random * HurtFinalHP / 100 ),
%% 			L2 = util:ceil(Random1 * HurtFinalHP / 100),
%% 			L3 = util:ceil( Random2 * HurtFinalHP / 100),
%% 			{[HP - L1,HP - L1 - L2,HP - L1 - L2 - L3,HP - HurtFinalHP],[0,0,0,MP - HurtFinalMP]}
%% 	end.


  

%================================================pk相关======================================================
%% 检查pk mode
check_battle_mode(NeedCheckMode,Actor,Target,IsDefaultSkill) ->
	MapID = lib_map:get_map_dic_id(),
	case lists:keymember(MapID,1,?NO_PK_MAP) of
		true ->
			if  
				is_record(Actor,ets_users) andalso is_record(Target,ets_users) ->
					if	Actor#ets_users.id =:= Target#ets_users.id ->
							{true, ?PK_NO_NEED};
						true ->
							{false, ?PK_CHECK}
					end;
				is_record(Actor,ets_users_pets) andalso is_record(Target,ets_users) ->
					{false, ?PK_CHECK};
				true ->
				   {true, ?PK_NO_NEED}
			end;
		_ ->
			case NeedCheckMode of
				true ->
			  		{check_battle_mode0(Actor,Target,IsDefaultSkill),?PK_CHECK};
				_ ->
			  		{true,?PK_NO_NEED}
			end
	end.

%% 双方都是人物时，检查PK模式   返回 true可攻击
check_battle_mode0(Actor,Target,IsDefaultSkill) ->
	MapID = lib_map:get_map_dic_id(),
	case lists:keymember(MapID,1,?NO_PK_MAP) of
		true ->
			false;
		_ ->
			check_battle_mode2(Actor,Target,IsDefaultSkill)
%% 			case lists:keymember(Target#ets_users.club_id, 1, Actor#ets_users.other_data#user_other.battle_info#battle_info.guild_enemy) of
%% 				false ->
%% 					check_battle_mode1(Actor,Target,IsDefaultSkill);
%% 				_ ->
%% 					check_battle_mode_lv(Target)
%% 			end
	end.

check_battle_mode1(Actor,Target,IsDefaultSkill) ->	%% 神魔乱斗判断
	case Actor#ets_users.other_data#user_other.war_state > 0 andalso Target#ets_users.other_data#user_other.war_state > 0 of 
		true ->
			if Actor#ets_users.other_data#user_other.war_state =/= Target#ets_users.other_data#user_other.war_state ->
				   if Target#ets_users.other_data#user_other.battle_info#battle_info.invincible_date =/= 0 ->
						  %% 检查是否无敌时间
						  Now = misc_timer:now_seconds(),
						  if Now > Target#ets_users.other_data#user_other.battle_info#battle_info.invincible_date ->
								 lib_map:update_online_dic_invincible(Target,0),
								 true;
							 true ->
								 false
						  end;
					  true ->
						  true
				   end;
			   true ->
				   false
			end;
		_ ->
			check_battle_mode2(Actor,Target,IsDefaultSkill)
	end.

check_battle_mode2(Actor,Target,IsDefaultSkill) ->
	if Actor#ets_users.id =/= Target#ets_users.id
		andalso Target#ets_users.pk_mode =/= ?PKMode_PEACE ->	%% 对方的pk mode不可是和平模式
			if Target#ets_users.other_data#user_other.player_now_state =/= ?ELEMENT_STATE_HITDOWN ->
					check_battle_mode3(Actor,Target);
				Target#ets_users.other_data#user_other.player_now_state =:= ?ELEMENT_STATE_HITDOWN andalso
						IsDefaultSkill =:= 1 -> %击倒的打不中只有默认技能能打中
					check_battle_mode3(Actor,Target);
				true ->
					false
			 end;
		true ->
			false
	end.

check_battle_mode3(Actor,Target) ->
	case Actor#ets_users.pk_mode of
		?PKMode_PEACE ->
			false;
		?PKMode_FREEDOM ->
			check_battle_mode_lv(Target);
		?PKMode_GOODNESS ->
			check_battle_mode_goodness(Target);
		?PKMode_TEAM ->
			check_battle_mode_lv(Target) andalso check_battle_mode_team(Actor,Target);
		?PKMode_CLUB ->
			check_battle_mode_lv(Target) andalso check_battle_mode_club(Actor,Target);
		?PKMode_CAMP ->
			check_battle_mode_lv(Target) andalso check_battle_mode_camp(Actor,Target);
		_ ->
			false
	end.

%% 获取pk对象列表
get_target_player_by_battle_mode(_Actor,[],ReturnList,_IsDefaultSkill) -> ReturnList;
get_target_player_by_battle_mode(Actor,[H|T],ReturnList,IsDefaultSkill) ->
	case check_battle_mode0(Actor,H,IsDefaultSkill) of
		true ->
			get_target_player_by_battle_mode(Actor,T,[H|ReturnList],IsDefaultSkill);
		_ ->
			get_target_player_by_battle_mode(Actor,T,ReturnList,IsDefaultSkill)
	end.


%以下均为false不能攻
%等级
check_battle_mode_lv(Player) ->
	Player#ets_users.level > ?PK_LEVEL.

%白名
check_battle_mode_goodness(Player) ->
	Player#ets_users.pk_value > ?USER_PK_VALUE.

%队伍
check_battle_mode_team(Actor,Target) ->
	 Actor#ets_users.team_id > 0 andalso 
		Actor#ets_users.team_id =/= Target#ets_users.team_id.

%帮派
check_battle_mode_club(Actor,Target) ->
	Actor#ets_users.club_id > 0 andalso
		Actor#ets_users.club_id =/= Target#ets_users.club_id.

%阵营
check_battle_mode_camp(Actor,Target) ->
	Actor#ets_users.camp > 0 andalso
		Actor#ets_users.camp =/= Target#ets_users.camp.

%=================================================================================================================

%打断
cancel_skill_prepare(Der) ->
	 case Der#battle_info.type of
				 ?ELEMENT_PLAYER ->
					 DerElement = lib_map:get_online_player(Der#battle_info.id),
					 BattleInfo = DerElement#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare = {}},
					 OtherData = DerElement#ets_users.other_data#user_other{battle_info = BattleInfo},
					 NewDer =DerElement#ets_users{other_data = OtherData},
					 lib_map:update_online_dic(NewDer);
					 %% todo，cast 人物 调整skill prepare
				 _ ->
					 DerElement = lib_map:get_online_monster(Der#battle_info.id, ?ELEMENT_MONSTER),
					 BattleInfo = DerElement#r_mon_info.battle_info#battle_info{skill_prepare = {}},
					 NewDer = DerElement#r_mon_info{battle_info=BattleInfo},
					 lib_map:update_mon_dic(NewDer)
			 end,
	
	battle_update_self_hpmp(Der#battle_info.type,Der#battle_info.pid,Der#battle_info.id,0,0,?ELEMENT_STATE_FIGHT).
%% 	battle_update(Der#battle_info.type, NewDer).

get_battle_type(Arr) ->
	if
		Arr#r_mon_info.monster_type =:= ?ELEMENT_OUR_TOWER ->
			?ELEMENT_OUR_TOWER;
		true ->
			?ELEMENT_MONSTER
	end.
		 
init_battle_data_mon(Arr) ->
	#battle_info{id = Arr#r_mon_info.id,
				 name = Arr#r_mon_info.template#ets_monster_template.name,
				 type = get_battle_type(Arr),%%战斗类型与怪物类型保持一致
				 acthurt_max = Arr#r_mon_info.template#ets_monster_template.acthurt_max,
						acthurt_min = Arr#r_mon_info.template#ets_monster_template.acthurt_min,
						targethurt_max = Arr#r_mon_info.template#ets_monster_template.targethurt_max,
						targethurt_min = Arr#r_mon_info.template#ets_monster_template.targethurt_min,
						camp = Arr#r_mon_info.template#ets_monster_template.camp,
						
						
						attack = Arr#r_mon_info.template#ets_monster_template.attack_physics + Arr#r_mon_info.tmp_attack_physics,      %% 普通攻击力	
      					far_hurt = Arr#r_mon_info.template#ets_monster_template.attack_range + Arr#r_mon_info.tmp_attack_range,          %% 远程伤害	
      					magic_hurt = Arr#r_mon_info.template#ets_monster_template.attack_magic + Arr#r_mon_info.tmp_attack_magic,          %% 魔法伤害	
      					mump_hurt = Arr#r_mon_info.template#ets_monster_template.attack_vindictive + Arr#r_mon_info.tmp_attack_vindictive,%% 斗气伤害	
      					defense = Arr#r_mon_info.template#ets_monster_template.defanse_physics + Arr#r_mon_info.tmp_defanse_physics,    %% 普通防御力	
      					far_defense = Arr#r_mon_info.template#ets_monster_template.defanse_range + Arr#r_mon_info.tmp_defanse_range,        %% 远程防御	
      					magic_defense = Arr#r_mon_info.template#ets_monster_template.defanse_magic + Arr#r_mon_info.tmp_defanse_magic,        %% 魔法防御	
      					mump_defense = Arr#r_mon_info.template#ets_monster_template.defanse_vindictive + Arr#r_mon_info.tmp_defanse_vindictive,%% 斗气防御				 	
      					hit_target = Arr#r_mon_info.template#ets_monster_template.hit + Arr#r_mon_info.tmp_hit,                            %% 命中	
      					duck = Arr#r_mon_info.template#ets_monster_template.dodge + Arr#r_mon_info.tmp_dodge,                        %% 闪避	
      					keep_off = Arr#r_mon_info.template#ets_monster_template.block + Arr#r_mon_info.tmp_block,                        %% 格挡	
				 		power_hit = Arr#r_mon_info.template#ets_monster_template.critical + Arr#r_mon_info.tmp_critical, 					%% 暴击power_hit
						deligency = Arr#r_mon_info.template#ets_monster_template.tough + Arr#r_mon_info.tmp_tough,							%% 坚韧
      					far_avoid_in_hurt = Arr#r_mon_info.template#ets_monster_template.reduce_range + Arr#r_mon_info.tmp_reduce_range,          %% 远程吸收	
      					magic_avoid_in_hurt = Arr#r_mon_info.template#ets_monster_template.redece_magic + Arr#r_mon_info.tmp_reduce_magic,          %% 魔法吸收	
      					mump_avoid_in_hurt = Arr#r_mon_info.template#ets_monster_template.reduce_vindictive + Arr#r_mon_info.tmp_reduce_vindictive,%% 斗气吸收

						abnormal_rate = Arr#r_mon_info.template#ets_monster_template.abnormal_rate,
						anti_abnormal_rate = Arr#r_mon_info.template#ets_monster_template.anti_abnormal_rate,
						
						pid = Arr#r_mon_info.pid, %%pid
						
						battle_physics_x = 0, %%战斗备用变量x
						battle_range_x = 0, %%战斗备用变量x
						battle_magic_x = 0, %%战斗备用变量x
						battle_vindictive_x = 0 %%战斗备用变量x
%% 						battle_physics_y = 0,  %%战斗备用变量y
%% 						battle_range_y = 0,  %%战斗备用变量y
%% 						battle_magic_y = 0,  %%战斗备用变量y
%% 						battle_vindictive_y = 0  %%战斗备用变量y	
						
						%% 怪暂时不处理element_now_state
	}.


init_battle_data_pet(UserInfo,Arr) ->
	#battle_info{pet_id =  Arr#ets_users_pets.id,
				 id = UserInfo#ets_users.id,
				 name = Arr#ets_users_pets.name,
				 type = ?ELEMENT_PET,
				 pet_owner_name = UserInfo#ets_users.nick_name,		%%宠物主人名字
				 pet_attack_type = Arr#ets_users_pets.type,			%%宠物属攻类型
				 attack = Arr#ets_users_pets.other_data#pet_other.attack + Arr#ets_users_pets.other_data#pet_other.attack2, 				%% 普通攻击力	
				 hit_target = Arr#ets_users_pets.other_data#pet_other.hit + Arr#ets_users_pets.other_data#pet_other.hit2, 							%% 命中
				 power_hit = Arr#ets_users_pets.other_data#pet_other.power_hit + Arr#ets_users_pets.other_data#pet_other.power_hit2, 		%% 暴击
				 magic_hurt = Arr#ets_users_pets.other_data#pet_other.magic_attack + Arr#ets_users_pets.other_data#pet_other.magic_attack2,%% 魔法攻击	
				 far_hurt = Arr#ets_users_pets.other_data#pet_other.far_attack + Arr#ets_users_pets.other_data#pet_other.far_attack2,		%% 远程攻击	
			     mump_hurt = Arr#ets_users_pets.other_data#pet_other.mump_attack + Arr#ets_users_pets.other_data#pet_other.mump_attack2,  %% 斗气攻击	
				 pid = UserInfo#ets_users.other_data#user_other.pid, %%pid
				 pid_send = UserInfo#ets_users.other_data#user_other.pid_send,
				 battle_physics_x = 0, %%战斗备用变量x
				 battle_range_x = 0, %%战斗备用变量x
				 battle_magic_x = 0, %%战斗备用变量x
				 battle_vindictive_x = 0 %%战斗备用变量x
						
	}.



init_battle_data_player(Arr) ->
	#battle_info{
                		id = Arr#ets_users.id,			%唯一标识
						name = Arr#ets_users.nick_name,
						type = ?ELEMENT_PLAYER,

						acthurt_max = -1,
						acthurt_min = -1,
						targethurt_max = -1,
						targethurt_min = -1,
						damage = Arr#ets_users.other_data#user_other.damage,
						attack = Arr#ets_users.other_data#user_other.attack + Arr#ets_users.other_data#user_other.tmp_attack,      %% 普通攻击力	
      					far_hurt = Arr#ets_users.other_data#user_other.far_hurt + Arr#ets_users.other_data#user_other.tmp_far_hurt,          %% 远程伤害	
						magic_hurt = Arr#ets_users.other_data#user_other.magic_hurt + Arr#ets_users.other_data#user_other.tmp_magic_hurt,          %% 魔法伤害	
      					mump_hurt = Arr#ets_users.other_data#user_other.mump_hurt + Arr#ets_users.other_data#user_other.tmp_mump_hurt,%% 斗气伤害	
      					defense = Arr#ets_users.other_data#user_other.defense + Arr#ets_users.other_data#user_other.tmp_defense,    %% 普通防御力	
      					far_defense = Arr#ets_users.other_data#user_other.far_defense + Arr#ets_users.other_data#user_other.tmp_far_defense,        %% 远程防御	
      					magic_defense = Arr#ets_users.other_data#user_other.magic_defense + Arr#ets_users.other_data#user_other.tmp_magic_defense,        %% 魔法防御	
      					mump_defense = Arr#ets_users.other_data#user_other.mump_defense + Arr#ets_users.other_data#user_other.tmp_mump_defense,%% 斗气防御	
      					hit_target = Arr#ets_users.other_data#user_other.hit_target + Arr#ets_users.other_data#user_other.tmp_hit_target,                            %% 命中	
      					duck = Arr#ets_users.other_data#user_other.duck + Arr#ets_users.other_data#user_other.tmp_duck,                        %% 闪避	
      					keep_off = Arr#ets_users.other_data#user_other.keep_off + Arr#ets_users.other_data#user_other.tmp_keep_off,              %% 格挡	
						power_hit = Arr#ets_users.other_data#user_other.power_hit + Arr#ets_users.other_data#user_other.tmp_power_hit,			%% 暴击
						deligency = Arr#ets_users.other_data#user_other.deligency + Arr#ets_users.other_data#user_other.tmp_deligency,			%% 坚韧
      					far_avoid_in_hurt = Arr#ets_users.other_data#user_other.far_avoid_in_hurt + Arr#ets_users.other_data#user_other.tmp_far_avoid_in_hurt,          %% 远程吸收	
      					magic_avoid_in_hurt = Arr#ets_users.other_data#user_other.magic_avoid_in_hurt + Arr#ets_users.other_data#user_other.tmp_magic_avoid_in_hurt,          %% 魔法吸收	
      					mump_avoid_in_hurt = Arr#ets_users.other_data#user_other.mump_avoid_in_hurt + Arr#ets_users.other_data#user_other.tmp_mump_avoid_in_hurt,%% 斗气吸收
						%x = Arr#ets_users.pos_x,
						%y = Arr#ets_users.pos_y,
						%map_id = Arr#ets_users.current_map_id,
						
						camp = Arr#ets_users.camp,
						guild_id = Arr#ets_users.club_id,
						team_id = Arr#ets_users.team_id,
						pk_value = Arr#ets_users.pk_value,
						level = Arr#ets_users.level,
						pk_mode = Arr#ets_users.pk_mode, 
						
					
						abnormal_rate = Arr#ets_users.other_data#user_other.abnormal_rate,
						anti_abnormal_rate = Arr#ets_users.other_data#user_other.anti_abnormal_rate,
						
						pid = Arr#ets_users.other_data#user_other.pid, %%pid
						pid_send = Arr#ets_users.other_data#user_other.pid_send,
						
						battle_physics_x = 0, %%战斗备用变量x
						battle_range_x = 0, %%战斗备用变量x
						battle_magic_x = 0, %%战斗备用变量x
						battle_vindictive_x = 0, %%战斗备用变量x
						
						element_state = Arr#ets_users.other_data#user_other.player_now_state,	%%当前状态
						element_standup_date = Arr#ets_users.other_data#user_other.player_standup_date,
						
						attack_suppression = Arr#ets_users.other_data#user_other.attack_suppression,		%% 攻击压制
					    defense_suppression = Arr#ets_users.other_data#user_other.defense_suppression		%% 防御压制
						
            }.

%%根据人物修改现有的战斗信息
init_battle_data_player(Arr, BattleObject) ->
	BattleObject#battle_info{
							 damage = Arr#ets_users.other_data#user_other.damage,
						attack = Arr#ets_users.other_data#user_other.attack + Arr#ets_users.other_data#user_other.tmp_attack,      %% 普通攻击力	
      					far_hurt = Arr#ets_users.other_data#user_other.far_hurt + Arr#ets_users.other_data#user_other.tmp_far_hurt,          %% 远程伤害	
						magic_hurt = Arr#ets_users.other_data#user_other.magic_hurt + Arr#ets_users.other_data#user_other.tmp_magic_hurt,          %% 魔法伤害	
      					mump_hurt = Arr#ets_users.other_data#user_other.mump_hurt + Arr#ets_users.other_data#user_other.tmp_mump_hurt,%% 斗气伤害	
      					defense = Arr#ets_users.other_data#user_other.defense + Arr#ets_users.other_data#user_other.tmp_defense,    %% 普通防御力	
      					far_defense = Arr#ets_users.other_data#user_other.far_defense + Arr#ets_users.other_data#user_other.tmp_far_defense,        %% 远程防御	
      					magic_defense = Arr#ets_users.other_data#user_other.magic_defense + Arr#ets_users.other_data#user_other.tmp_magic_defense,        %% 魔法防御	
      					mump_defense = Arr#ets_users.other_data#user_other.mump_defense + Arr#ets_users.other_data#user_other.tmp_mump_defense,%% 斗气防御	
      					hit_target = Arr#ets_users.other_data#user_other.hit_target + Arr#ets_users.other_data#user_other.tmp_hit_target,                            %% 命中	
      					duck = Arr#ets_users.other_data#user_other.duck + Arr#ets_users.other_data#user_other.tmp_duck,                        %% 闪避	
      					keep_off = Arr#ets_users.other_data#user_other.keep_off + Arr#ets_users.other_data#user_other.tmp_keep_off,                        %% 格挡
						power_hit = Arr#ets_users.other_data#user_other.power_hit + Arr#ets_users.other_data#user_other.tmp_power_hit,			%% 暴击
						deligency = Arr#ets_users.other_data#user_other.deligency + Arr#ets_users.other_data#user_other.tmp_deligency,			%% 坚韧	
      					far_avoid_in_hurt = Arr#ets_users.other_data#user_other.far_avoid_in_hurt + Arr#ets_users.other_data#user_other.tmp_far_avoid_in_hurt,          %% 远程吸收	
      					magic_avoid_in_hurt = Arr#ets_users.other_data#user_other.magic_avoid_in_hurt + Arr#ets_users.other_data#user_other.tmp_magic_avoid_in_hurt,          %% 魔法吸收	
      					mump_avoid_in_hurt = Arr#ets_users.other_data#user_other.mump_avoid_in_hurt + Arr#ets_users.other_data#user_other.tmp_mump_avoid_in_hurt,%% 斗气吸收
						camp = Arr#ets_users.camp,
						guild_id = Arr#ets_users.club_id,
						team_id = Arr#ets_users.team_id,
						pk_value = Arr#ets_users.pk_value,
						level = Arr#ets_users.level,
						pk_mode = Arr#ets_users.pk_mode, 
						abnormal_rate = Arr#ets_users.other_data#user_other.abnormal_rate,
						anti_abnormal_rate = Arr#ets_users.other_data#user_other.anti_abnormal_rate,
						
						element_state = Arr#ets_users.other_data#user_other.player_now_state,	%%当前状态
						element_standup_date= Arr#ets_users.other_data#user_other.player_standup_date,
						attack_suppression = Arr#ets_users.other_data#user_other.attack_suppression,		%% 攻击压制
					    defense_suppression = Arr#ets_users.other_data#user_other.defense_suppression		%% 防御压制
            }.




%%===========================================================================================================
%% Local Functions
%%===========================================================================================================



%Aer攻击者，der被击者，bufflist技能附带的buff,返回影响后的buff
%在battle包里update了不需要再通知
battle_update_buff(AerBattleInfo,Der,DerBattleInfo,BuffList) ->
	HitBuff = battle_update_buff1(BuffList,AerBattleInfo,DerBattleInfo,[]), %命中的buff
	NewBuffList = if is_record(Der, ets_users) ->
					  Der#ets_users.other_data#user_other.buff_list;
				  true ->
					  Der#r_mon_info.buff_list
			   end,   
	{HitBuff,lib_buff:add_buff_new(DerBattleInfo#battle_info.id, HitBuff, NewBuffList)}. %结果{BuffList,ChangeBuffList}

battle_update_buff1([],_AerBattleInfo,_DerBattleInfo,L) -> L;
battle_update_buff1([TmpBuffID|T],AerBattleInfo,DerBattleInfo,L) ->
	{BuffID} = TmpBuffID,
	BuffInfo = lib_buff:get_buff_from_template(BuffID),
	case BuffInfo of
		[] ->
			battle_update_buff1(T,AerBattleInfo,DerBattleInfo,L);
		_ ->
			Abnormal = AerBattleInfo#battle_info.abnormal_rate
							+ BuffInfo#ets_buff_template.hit_percent,
			Antiabnormal = DerBattleInfo#battle_info.anti_abnormal_rate,
			case Abnormal > Antiabnormal of 
				true ->
					Nab = tool:floor((Abnormal - Antiabnormal) ),%%* (100 + AerBattleInfo#battle_info.attack_suppression - DerBattleInfo#battle_info.defense_suppression) /100) ,
					case Nab > 100 of
						true ->
							NL = [BuffInfo|L];
						_ ->
							NabP = util:rand(1,?Buff_Percent),
							case Nab > NabP of
								true ->
									NL = [BuffInfo|L];
								_ ->
									NL = L
							end
					end;
				_ ->
					NL = L
			end,
		battle_update_buff1(T,AerBattleInfo,DerBattleInfo,NL)
	end.


 %传变化值,HurtPid = 攻击者Pid，Pid = 被击者Pid, Type 攻击者类型, 当前的bufflist
battle_update_target_info(TargetPid, TargetID, HurtName, HurtPid, HurtID, HP, MP, HurtType, TargetType, BuffList,HitBuffList, NowState, StandupDate) ->
	case TargetType of
		?ELEMENT_PLAYER ->
			lib_map:update_online_dic(TargetID, HP, MP, NowState, StandupDate),
			%% 需要修改为同步调用。
    		gen_server:cast(TargetPid,{reducehpmp, TargetID, HurtPid, HurtID, HP, MP, HurtType, HitBuffList, HurtName, NowState, StandupDate}),
			{ok};
		_ ->
			lib_map_monster:reduce_hp_and_mp(HurtType,TargetID,HurtPid,HurtID,HP,MP,BuffList)
	end.

%% 因为自身原因扣红蓝，如使用技能
battle_update_self_hpmp(Type,Pid,ID,HP,MP,NowState) ->
	case Type of
		?ELEMENT_PLAYER ->
%% 			lib_map:update_online_dic(ID, HP, MP),
			gen_server:cast(Pid,{reducehpmp_byself,ID,HP,MP,NowState});
		?ELEMENT_PET ->
			skip;
		?ELEMENT_OUR_TOWER ->
			skip;
		_ ->
			lib_map_monster:reduce_hp_and_mp_by_self(ID,HP,MP)
	end.

%% 通知更新State
%% battle_update(Type,Element) ->
%% 	case Type of
%% 		?ELEMENT_PLAYER when  is_record(Element,ets_users) ->
%% 			lib_map:update_online_dic(Element),
%% %% 			gen_server:cast(Element#ets_users.other_data#user_other.pid,{update_state,Element});
%% 			BattleInfo = Element#ets_users.other_data#user_other.battle_info,
%% 			gen_server:cast(Element#ets_users.other_data#user_other.pid, {update_battle_info,BattleInfo, Element#ets_users.current_hp, Element#ets_users.current_mp});
%% 		_  when is_record(Element,r_mon_info) ->
%% 			lib_map_monster:update_state(Element);
%% 		_ ->
%% 			?WARNING_MSG("battle_update is error:~w,~w", [Type,Element])
%% 
%% 	end.

%% 通知更新State
battle_update(Type,Element) ->
	case Type of
		?ELEMENT_PLAYER when  is_record(Element,ets_users) ->
			lib_map:update_online_dic(Element),
%% 			gen_server:cast(Element#ets_users.other_data#user_other.pid,{update_state,Element});
			BattleInfo = Element#ets_users.other_data#user_other.battle_info,
			gen_server:cast(Element#ets_users.other_data#user_other.pid, {update_battle_info,
																			BattleInfo,
																			Element#ets_users.current_hp,
																			Element#ets_users.current_mp});
		_  when is_record(Element,r_mon_info) ->
			lib_map_monster:update_state(Element);
		_ ->
			?WARNING_MSG("battle_update is error:~w,~w", [Type,Element])
	end.

%发包 - 战斗结果
send_battle_update(_Actor,Bin,X,Y) ->
	MapId = lib_map:get_map_dic_id(),
	case lib_map:get_map_type(MapId) of %%如果是爬塔副本通知全地图
		?DUPLICATE_TYPE_PASS ->
			mod_map_agent:send_to_map(MapId, Bin, true);
		_ ->
			mod_map_agent:send_to_map_scene(MapId,
									X,
									Y,
									Bin)
	end.
	

%% 技能重生
send_skill_relive(AerName,DerBattleInfo,_V1,_V2) ->
	if DerBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER ->
		   {ok, BinData} = pt_12:write(?PP_SKILL_RELIVE,AerName),
		   lib_send:send_to_sid(DerBattleInfo#battle_info.pid_send,BinData);
	   true ->
		   skip
	end.

%发包 - 本次战斗无效
send_battle_no_calc(Actor) ->
	if Actor#battle_info.type =:= ?ELEMENT_PLAYER ->
			{ok, BinData} = write_battle_no_calc(),
			lib_send:send_to_sid(Actor#battle_info.pid_send,BinData);
	   true ->
		   skip
	end.

%发包 - 技能准备
send_battle_prepare_skill(Actor,SkillGroupId,Lv,WaitState,X,Y) ->
 	{ok,BinData} = write_battle_waiting(Actor,SkillGroupId,Lv,WaitState,X,Y),
%% 	mod_map_agent:send_to_area_scene(lib_map:get_map_dic_id(),
%% 									 X, 
%% 									 Y, 
%% 									 BinData).
	MapId = lib_map:get_map_dic_id(),
	mod_map_agent:send_to_map_scene(MapId,
									X,
									Y,
									BinData).


%调用四类计算获取一个列表[{msg1,v1},{msg2,v2}...]
get_total_hurt1(X,L,Aer,Der) ->
	[calc_attack(Aer,Der,X)|L].

%用1的列表组合所有战斗伤害和提示信息,注意初始L值要为[[],0],结果[[msg1,msg2],v1+v2]
get_total_hurt2(X,L) ->
	{V1a,V1b} = X,
	[VTa,VTb] = L,
	[[V1a|VTa],V1b+VTb].

%% 命中计算
calc_hit(?ASSIST_SKILL,_Hit, _Miss) ->
	{hit};

calc_hit(_,Hit, Miss) -> %算闪避几率，不是命中
	TMPH = 
		if Hit > Miss ->
			1;
			true ->
				util:floor(math:sqrt((Miss - Hit)*3)) %+ (AttackSuppression-DefenseSuppression),
		end,
	HV = if TMPH > 30 ->
				30;			
			true ->
			 	TMPH
		 end,
	Rnd = util:rand(1,100),
	if HV >= Rnd ->
		{miss};
	true ->
		{hit}
	end.

%% 暴击计算
calc_critical(Critical,Tough, ActiveType) ->
	if
		ActiveType =:= ?ASSIST_SKILL ->
			{hit};
		true ->
			if Critical >= Tough ->
				CPtmp = util:floor(math:sqrt((Critical - Tough)*12)) ,%+ (AttackSuppression-DefenseSuppression),
				CP =  if CPtmp > 60 ->
					60;
				true ->
					CPtmp
				end,
				Rnd = util:rand(1,100),
				if CP >= Rnd ->
					{critical};
				true ->
					{hit}
				end;
			true ->
				{hit}
			end
	end.	

%%根据属性计算结果 - 战斗公式
calc_attack(Aer,Der,Type) ->
	V = case Type of
		{?CalcAttack} ->
			Rnd = util:rand(1,100),
			if Aer#battle_info.keep_off > Rnd -> %block了
			       M = block,
				   0;
			   true ->
					M = hit,
					if Aer#battle_info.attack =:= 0 ->
						   %不计算本项
						   0;
					   (Aer#battle_info.attack + Aer#battle_info.damage) < Der#battle_info.defense ->
						   if Aer#battle_info.type =:= ?ELEMENT_PLAYER andalso Der#battle_info.type =:= ?ELEMENT_PLAYER ->
								  tool:floor(Aer#battle_info.attack * 0.1 );
							  true ->
								  1 + Aer#battle_info.damage
						   end;
					   true ->
						   util:ceil((Aer#battle_info.attack + Aer#battle_info.damage - Der#battle_info.defense)
							 * (Aer#battle_info.battle_physics_x / 100) )
					end
			end;
		{?CalcMagic} ->
			M = hit,
			if Aer#battle_info.magic_hurt =:= 0 ->
				   0;
			   (Aer#battle_info.magic_hurt + Aer#battle_info.magic_damage)  < Der#battle_info.magic_defense ->
				   if Aer#battle_info.type =:= ?ELEMENT_PLAYER andalso Der#battle_info.type =:= ?ELEMENT_PLAYER ->
						  tool:floor(Aer#battle_info.magic_hurt * 0.1 );
					  true ->
						  1 + Aer#battle_info.magic_damage
				   end;
			   true ->
				   util:ceil(((Aer#battle_info.magic_hurt + Aer#battle_info.magic_damage - Der#battle_info.magic_defense)* 
								  ( Aer#battle_info.battle_magic_x / 100)  * 1.5 ))
			end;
		{?CalcFar} ->
			M = hit,
			if Aer#battle_info.far_hurt =:= 0 ->
				   0;
			   (Aer#battle_info.far_hurt + Aer#battle_info.far_damage) < Der#battle_info.far_defense ->
				   if Aer#battle_info.type =:= ?ELEMENT_PLAYER andalso Der#battle_info.type =:= ?ELEMENT_PLAYER ->
						  tool:floor(Aer#battle_info.far_damage * 0.1 );
					  true ->
						   1 + Aer#battle_info.far_damage
				   end;
			   true ->
				   util:ceil(((Aer#battle_info.far_hurt + Aer#battle_info.far_damage - Der#battle_info.far_defense) *
								  ( Aer#battle_info.battle_range_x / 100)  * 1.5 ))
			end;
		{?CalcMump} ->
			M = hit,
			if Aer#battle_info.mump_hurt  =:= 0 ->
				   0;
			   (Aer#battle_info.mump_hurt + Aer#battle_info.mump_damage)< Der#battle_info.mump_defense ->
				   if Aer#battle_info.type =:= ?ELEMENT_PLAYER andalso Der#battle_info.type =:= ?ELEMENT_PLAYER ->
						  tool:floor(Aer#battle_info.mump_damage * 0.1);
					  true ->
						   1 + Aer#battle_info.mump_damage
				   end;
			   true ->
				   util:ceil(((Aer#battle_info.mump_hurt + Aer#battle_info.mump_damage - Der#battle_info.mump_defense) * 
								  ( Aer#battle_info.battle_vindictive_x / 100)  * 1.5 ))
			end
		end,
	{M,V}.

%===========================================================================================
%%检查技能可用性(不包括cd)
check_skill_cost_condition0(Aer,ActorType, DerX, DerY, SkillData, SkillList) ->
	if 
		ActorType =:= ?ELEMENT_PET ->
			check_skill_cost_condition_pet1(Aer,DerX,DerY,SkillData,SkillList,0);
		is_record(Aer,ets_users) ->
		   if  Aer#ets_users.current_mp - SkillData#ets_skill_template.active_use_mp >= 0 ->
				  check_skill_cost_condition_player1(Aer,
											  DerX,
											  DerY,
											  SkillData,
											  SkillList,
											  SkillData#ets_skill_template.active_use_mp);
			  true ->
				  {mp_error}
		   end;
	   	is_record(Aer,r_mon_info) ->
		    check_skill_cost_condition_monster1(Aer,DerX,DerY,SkillData,SkillList,0)
			
	end.
	
check_skill_cost_condition_player1(Aer,DerX,DerY,SkillData,SkillList,MP) ->
	case lists:keymember(SkillData#ets_skill_template.skill_id,#r_use_skill.skill_id,SkillList) of
		true ->
			check_skill_cost_condition_player3(Aer,DerX,DerY,SkillData,MP);
		_ ->
			{not_own_skill_error}
	end.

check_skill_cost_condition_player2(Aer,DerX,DerY,SkillData,MP) ->
	check_skill_cost_condition_player3(Aer,DerX,DerY,SkillData,MP).

check_skill_cost_condition_player3(Aer,DerX,DerY,SkillData,MP) ->
	case SkillData#ets_skill_template.active_side =/= ?Skill_Target_Self of
		true ->
			if (abs(Aer#ets_users.pos_x - DerX) > SkillData#ets_skill_template.range)
				 orelse (abs(Aer#ets_users.pos_y - DerY) > SkillData#ets_skill_template.range) ->
				   {range_error};
			   true ->
				   {ok, MP}
			end;
		false ->  %%自身起效不判断距离
			{ok, MP}
	end.

check_skill_cost_condition_monster1(Aer,DerX,DerY,SkillData,SkillList,MP) ->
	case lists:keymember(SkillData#ets_skill_template.skill_id,#r_use_skill.skill_id,SkillList) of
		true ->
			check_skill_cost_condition_monster2(Aer,DerX,DerY,SkillData,MP);
		_ ->
			{not_own_skill_error}
	end.
	
check_skill_cost_condition_monster2(Aer,DerX,DerY,SkillData,MP) ->
	check_skill_cost_condition_monster3(Aer,DerX,DerY,SkillData,MP).



check_skill_cost_condition_monster3(Aer,DerX,DerY,SkillData,MP) ->
	case SkillData#ets_skill_template.active_side =/= ?Skill_Target_Self of
		true ->
			if (abs(Aer#r_mon_info.pos_x - DerX) > SkillData#ets_skill_template.range)
				 orelse (abs(Aer#r_mon_info.pos_y - DerY) > SkillData#ets_skill_template.range) ->
				   {range_error};
			   true ->
				   {ok, MP}
			end;
		false ->  %%自身起效不判断距离
			{ok, MP}
	end.

check_skill_cost_condition_pet1(Aer,DerX,DerY,SkillData,SkillList,MP) ->
	case lists:keymember(SkillData#ets_skill_template.skill_id,#r_use_skill.skill_id,SkillList) of
		true ->
			check_skill_cost_condition_pet2(Aer,DerX,DerY,SkillData,MP);
		_ ->
			{not_own_skill_error}
	end.
	
check_skill_cost_condition_pet2(Aer,DerX,DerY,SkillData,MP) ->
	check_skill_cost_condition_pet3(Aer,DerX,DerY,SkillData,MP).


check_skill_cost_condition_pet3(Aer,DerX,DerY,SkillData,MP) ->
	case SkillData#ets_skill_template.active_side =/= ?Skill_Target_Self of
		true ->
			if (abs(Aer#r_mon_info.pos_x - DerX) > SkillData#ets_skill_template.range)
				 orelse (abs(Aer#r_mon_info.pos_y - DerY) > SkillData#ets_skill_template.range) ->
				   {range_error};
			   true ->
				   {ok, MP}
			end;
		false ->  %%自身起效不判断距离
			{ok, MP}
	end.

%===========================================================================================	

%检查技能频率，不直接传递
check_skill_use_fr(Actor,Type,SkillID,CD) ->
	if
		Type =:= ?ELEMENT_PET ->
			case lists:keyfind(SkillID,#r_use_skill.skill_id,Actor#ets_users.other_data#user_other.pet_skill_list) of
				false ->
					{cd_error};
				UseSkillInfo ->
					check_skill_use_fr_pet1(Actor,SkillID,CD,UseSkillInfo)
			end;
		Type =:= ?ELEMENT_PLAYER ->
			case lists:keyfind(SkillID,#r_use_skill.skill_id,Actor#ets_users.other_data#user_other.skill_list) of
				false ->
					{cd_error};
				UseSkillInfo ->
					check_skill_use_fr_player1(Actor,SkillID,CD,UseSkillInfo)
			end;
	    Type =:= ?ELEMENT_OUR_TOWER ->
			case lists:keyfind(SkillID,#r_use_skill.skill_id,Actor#r_mon_info.skill_list) of
				false ->
					{cd_error};
				UseSkillInfo ->
					check_skill_use_fr_our_tower1(Actor,SkillID,CD,UseSkillInfo)
			end;
	   true ->
		   case lists:keyfind(SkillID,#r_use_skill.skill_id,Actor#r_mon_info.skill_list) of
			   false ->
				   {cd_error};
			   UseSkillInfo ->
				   check_skill_use_fr_monster1(Actor,SkillID,CD,UseSkillInfo)
		   end
	end.

check_skill_use_fr_player1(Actor,SkillID,CD,UseSkillInfo) ->
	Time = misc_timer:now_milseconds(),
	case UseSkillInfo#r_use_skill.skill_lastusetime + CD < Time of
		true ->
			NewDicSL1 = lists:keydelete(SkillID,#r_use_skill.skill_id,Actor#ets_users.other_data#user_other.skill_list),
			NewDicSL2 = [UseSkillInfo#r_use_skill{skill_lastusetime = Time}|NewDicSL1],
			NewDicPS = {SkillID,Time},
			NewBattleInfo = Actor#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare = NewDicPS},
			NewOther = Actor#ets_users.other_data#user_other{battle_info = NewBattleInfo,
															 skill_list = NewDicSL2},
			NewActor = Actor#ets_users{other_data = NewOther},
			{ok, Time, NewActor, ?ELEMENT_PLAYER};
		_ ->
			{cd_error}
	end.

check_skill_use_fr_pet1(Actor,SkillID,CD,UseSkillInfo) ->
	Time = misc_timer:now_milseconds(),
	case UseSkillInfo#r_use_skill.skill_lastusetime + CD < Time of
		true ->
			NewDicSL1 = lists:keydelete(SkillID,#r_use_skill.skill_id,Actor#ets_users.other_data#user_other.pet_skill_list),
			NewDicSL2 = [UseSkillInfo#r_use_skill{skill_lastusetime = Time}|NewDicSL1],
			NewDicPS = {SkillID,Time},
			NewBattleInfo = Actor#ets_users.other_data#user_other.pet_battle_info#battle_info{skill_prepare = NewDicPS},
			NewOther = Actor#ets_users.other_data#user_other{pet_battle_info = NewBattleInfo,
															 pet_skill_list = NewDicSL2},
			NewActor = Actor#ets_users{other_data = NewOther},
			{ok, Time, NewActor, ?ELEMENT_PET};
		_ ->
			{cd_error}
	end.

check_skill_use_fr_our_tower1(Actor,SkillID,CD,UseSkillInfo) ->
	Time = misc_timer:now_milseconds(),
	case UseSkillInfo#r_use_skill.skill_lastusetime + CD < Time of
		true ->
			NewDicSL1 = lists:keydelete(SkillID,#r_use_skill.skill_id,Actor#r_mon_info.skill_list),
			NewDicSL2 = [UseSkillInfo#r_use_skill{skill_lastusetime = Time}|NewDicSL1],
			NewDicPS = {SkillID,Time},
			NewBattleInfo = Actor#r_mon_info.battle_info#battle_info{skill_prepare = NewDicPS},
			NewActor = Actor#r_mon_info{battle_info = NewBattleInfo,
										skill_list = NewDicSL2},
			{ok, Time, NewActor, ?ELEMENT_OUR_TOWER};
		_ ->
			{cd_error}
	end.

check_skill_use_fr_monster1(Actor,SkillID,CD,UseSkillInfo) ->
	Time = misc_timer:now_milseconds(),
	case UseSkillInfo#r_use_skill.skill_lastusetime + CD < Time of
		true ->
			NewDicSL1 = lists:keydelete(SkillID,#r_use_skill.skill_id,Actor#r_mon_info.skill_list),
			NewDicSL2 = [UseSkillInfo#r_use_skill{skill_lastusetime = Time}|NewDicSL1],
			NewDicPS = {SkillID,Time},
			NewBattleInfo = Actor#r_mon_info.battle_info#battle_info{skill_prepare = NewDicPS},
			NewActor = Actor#r_mon_info{battle_info = NewBattleInfo,
										skill_list = NewDicSL2},
			{ok, Time, NewActor, ?ELEMENT_MONSTER};
		_ ->
			{cd_error}
	end.

check_skill_not_prepare(SkillPrepare) ->
	case SkillPrepare of
		{} ->
			{ok};
		_ ->
			{not_prepare_error}
	end.


%吟唱状态检查
check_skill_prepare(Actor,ActorType,SkillID,PrepareTime) ->
	if
		ActorType =:= ?ELEMENT_PLAYER ->
			 check_skill_prepare_user(Actor,SkillID,PrepareTime);
		ActorType =:= ?ELEMENT_PET ->
			 check_skill_prepare_pet(Actor,SkillID,PrepareTime);
	   true ->
		   check_skill_prepare_monster(Actor,SkillID,PrepareTime)
	end.

check_skill_prepare_user(Actor, SkillID, PrepareTime) ->
	case Actor#ets_users.other_data#user_other.battle_info#battle_info.skill_prepare of
		{} ->
			{prepare_time_error};
		{SkillID, CheckPrepareTime} ->
			if PrepareTime =:= CheckPrepareTime ->
				   NewBattleInfo = Actor#ets_users.other_data#user_other.battle_info#battle_info{skill_prepare = {}},
				   NewOther = Actor#ets_users.other_data#user_other{battle_info = NewBattleInfo},
				   NewActor = Actor#ets_users{other_data = NewOther},
				   lib_map:update_online_dic(NewActor),
				   {ok};
			   true ->
				   {prepare_time_error}
			end;
		{_OtherSkillID,_CheckPrepareTime} ->
			{prepare_time_error}
	end.

check_skill_prepare_pet(Actor, SkillID, PrepareTime) ->
	case Actor#ets_users.other_data#user_other.pet_battle_info#battle_info.skill_prepare of
		{} ->
			{prepare_time_error};
		{SkillID, CheckPrepareTime} ->
			if PrepareTime =:= CheckPrepareTime ->
				   NewBattleInfo = Actor#ets_users.other_data#user_other.pet_battle_info#battle_info{skill_prepare = {}},
				   NewOther = Actor#ets_users.other_data#user_other{pet_battle_info = NewBattleInfo},
				   NewActor = Actor#ets_users{other_data = NewOther},
				   lib_map:update_online_dic(NewActor),
				   {ok};
			   true ->
				   {prepare_time_error}
			end;
		{_OtherSkillID,_CheckPrepareTime} ->
			{prepare_time_error}
	end.

check_skill_prepare_monster(Actor, SkillID, PrepareTime) ->
	case Actor#r_mon_info.battle_info#battle_info.skill_prepare of
		{} ->
			{prepare_time_error};
		{SkillID, CheckPrepareTime} ->
			if PrepareTime =:= CheckPrepareTime ->
				   NewBattleInfo = Actor#r_mon_info.battle_info#battle_info{skill_prepare = {}},
				   NewActor = Actor#r_mon_info{battle_info = NewBattleInfo},
				   lib_map:update_mon_dic(NewActor),
				   {ok};
			   true ->
				   {prepare_time_error}
			end;
		{_OtherSkillID,_CheckPrepareTime} ->
			{prepare_time_error}
	end.
		
%% 补充战斗属性，用于计算参数的变化
init_battle_data(ActorBattleInfo,TargetBattleInfo) ->
	ActorBattleInfo#battle_info{battle_physics_x = 100,battle_range_x = 100,battle_magic_x = 100,battle_vindictive_x = 100}.
%% 	if ActorBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER andalso
%% 									   TargetBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER ->
%% 		   ActorBattleInfo#battle_info{battle_physics_x=0,battle_range_x=1,battle_magic_x=1,battle_vindictive_x=1};
%% 	   ActorBattleInfo#battle_info.type =:= ?ELEMENT_PLAYER andalso
%% 									   TargetBattleInfo#battle_info.type =:= ?ELEMENT_MONSTER ->
%% 		   ActorBattleInfo#battle_info{battle_physics_y=1,battle_range_y=0,battle_magic_y=0,battle_vindictive_y=0};
%% 	   true ->
%% 		   ActorBattleInfo
%% 	end.
	

%=====================================================================
% 计算类型
cale_active_type(ActorBattleInfo,Type) ->
	case lists:keymember(Type,1, ActorBattleInfo#battle_info.count_type) of
		false ->
			NL = [{Type}|ActorBattleInfo#battle_info.count_type],
			ActorBattleInfo#battle_info{count_type=NL};
		_ ->
			ActorBattleInfo
	end.

cale_active_type(ActorBattleInfo,Type,Value) ->
	case Type of
		?ACTOR_HP ->
			ActorBattleInfo#battle_info{actor_hp = ActorBattleInfo#battle_info.actor_hp + Value};
		?ACTOR_MP ->
			ActorBattleInfo#battle_info{actor_mp = ActorBattleInfo#battle_info.actor_mp + Value};
		?Target_HP ->
			ActorBattleInfo#battle_info{target_hp = ActorBattleInfo#battle_info.target_hp + Value};
		?Target_MP ->
			ActorBattleInfo#battle_info{target_mp = ActorBattleInfo#battle_info.target_mp + Value};
		_ ->
			ActorBattleInfo
	end.


%%尾递归技能效果
%%技能只对攻击者攻击和被击者防御起效，其他属于持续效果用buff
cale_active_effect_loop([],_ID, Aer, Der) ->
    [Aer, Der];
cale_active_effect_loop([H | T],ID, Aer, Der) ->
	case H of
		{K,V} ->
%% 	case erlang:is_list(V) of 
%% 		false -> %%加减法
			case K of
				?ATTR_ATTACK ->
					NewAer0 = cale_active_type(Aer,?CalcAttack),
					Att = Aer#battle_info.attack + V,
					NewAer = NewAer0#battle_info{
                        attack = Att
                    },
                    cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_DEFENSE ->
					Att = Aer#battle_info.defense + V,
					NewAer = Aer#battle_info{
						power_hit = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_DAMAGE ->
					NewAer0 = cale_active_type(Aer,?CalcAttack),
					Att = Aer#battle_info.damage + V,
					NewAer = NewAer0#battle_info{
                        damage = Att
                    },
                    cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MUMPHURTATT ->
					NewAer0 = cale_active_type(Aer,?CalcMump),
                    Att = Aer#battle_info.mump_hurt + V,
					NewAer = NewAer0#battle_info{
						mump_hurt = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MAGICHURTATT ->
					NewAer0 = cale_active_type(Aer,?CalcMagic),
					Magic = Aer#battle_info.magic_hurt + V,
					NewAer = NewAer0#battle_info{
						magic_hurt = Magic					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_FARHURTATT ->
					NewAer0 = cale_active_type(Aer,?CalcFar),
                    Far = Aer#battle_info.far_hurt + V,
					NewAer = NewAer0#battle_info{
						far_hurt = Far					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MUMPDEFENSE ->
					Att = Aer#battle_info.mump_defense + V,
					NewAer = Aer#battle_info {
						mump_defense = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_MAGICDEFENCE ->
					Att = Aer#battle_info.magic_defense + V,
					NewAer = Aer#battle_info {
						magic_defense = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_FARDEFENSE ->
					Att = Aer#battle_info.far_defense  + V,
					NewAer = Aer#battle_info {
						far_defense  = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_MUMPHURT ->
					NewAer0 = cale_active_type(Aer,?CalcMump),
                    Att = Aer#battle_info.mump_damage + V,
					NewAer = NewAer0#battle_info{
						mump_damage = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MAGICHURT ->
					NewAer0 = cale_active_type(Aer,?CalcMagic),
					Magic = Aer#battle_info.magic_damage + V,
					NewAer = NewAer0#battle_info{
						magic_damage = Magic					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_FARHURT ->
					NewAer0 = cale_active_type(Aer,?CalcFar),
                    Far = Aer#battle_info.far_damage + V,
					NewAer = NewAer0#battle_info{
						far_damage = Far					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_EXTENT_HP ->
					NewAer0 = cale_active_type(Aer,?ACTOR_HP,V),
					cale_active_effect_loop(T,ID, NewAer0, Der);
				?ATTR_HP ->
					NewAer0 = cale_active_type(Aer,?ACTOR_HP,V),
					cale_active_effect_loop(T,ID, NewAer0, Der);
				?ATTR_MP ->
					NewAer0 = cale_active_type(Aer,?ACTOR_MP,V),
					cale_active_effect_loop(T,ID, NewAer0, Der);
				?ATTR_POWERHIT ->
					Pow = Aer#battle_info.power_hit + V,
					NewAer = Aer#battle_info{
						power_hit = Pow					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_DELIGENCY ->
					Att = Aer#battle_info.deligency + V,
					NewAer = Aer#battle_info {
						deligency = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_HITTARGET ->
					Hit = Aer#battle_info.hit_target + V,
					NewAer = Aer#battle_info{
						hit_target = Hit		  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_ATT_ATTACK ->
					case Aer#battle_info.pet_attack_type of
						?CalcMump ->
							cale_active_effect_loop([{?ATTR_MUMPHURTATT,V} | T],ID, Aer, Der);
						?CalcMagic ->
							cale_active_effect_loop([{?ATTR_MAGICHURTATT,V} | T],ID, Aer, Der);
						?CalcFar ->
							cale_active_effect_loop([{?ATTR_FARHURTATT,V} | T],ID, Aer, Der);
						_ ->
							cale_active_effect_loop(T,ID, Aer, Der )
					end;					
				?ATTR_PHYSICS_HURT_ADD ->
					Att = Aer#battle_info.battle_physics_x + V,
					NewAer = Aer#battle_info{
						battle_physics_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_RANGE_HURT_ADD ->
					Att = Aer#battle_info.battle_range_x + V,
					NewAer = Aer#battle_info{
						battle_range_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MAGIC_HURT_ADD ->
					Att = Aer#battle_info.battle_magic_x + V,
					NewAer = Aer#battle_info{
						battle_magic_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_VINDICTIVE_HURT_ADD ->
					Att = Aer#battle_info.battle_vindictive_x + V,
					NewAer = Aer#battle_info{
						battle_vindictive_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
%========================================================================================				
				?ATTR_TARGET_DUCK -> 
					Duck = Der#battle_info.duck + V,
					NewDer = Der#battle_info{
						duck = Duck			  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				?ATTR_TARGET_DELIGENCY ->
					Deligency = Der#battle_info.deligency + V,
					NewDer = Der#battle_info{
						deligency = Deligency					  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				?ATTR_TARGET_POWERHIT ->
					Keepoff = Der#battle_info.power_hit + V,
					NewDer = Der#battle_info{
						power_hit = Keepoff					  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				?ATTR_TARGET_KEEPOFF ->
					Keepoff = Der#battle_info.keep_off + V,
					NewDer = Der#battle_info{
						keep_off = Keepoff					  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				
				Attr ->
					?WARNING_MSG("SkillID ~w Attr1 is not at:~w~n", [ID,Attr]),
					cale_active_effect_loop(T,ID, Aer, Der)
			end;
		{K,V1,V2} -> %%乘除法
			case K of
				?ATTR_ATTACK ->
					NewAer0 = cale_active_type(Aer,?CalcAttack),
					Att = Aer#battle_info.attack + (Aer#battle_info.attack * V1 / V2),
					NewAer = NewAer0#battle_info{
                        attack = Att
                    },
                    cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_DEFENSE ->
					Att = Aer#battle_info.defense + (Aer#battle_info.defense * V1 / V2),
					NewAer = Aer#battle_info{
						power_hit = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_DAMAGE ->
					NewAer0 = cale_active_type(Aer,?CalcAttack),
					Att = Aer#battle_info.damage + (Aer#battle_info.damage * V1 / V2),
					NewAer = NewAer0#battle_info{
                        damage = Att
                    },
                    cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MUMPHURTATT ->
					NewAer0 = cale_active_type(Aer,?CalcMump),
                    Att = Aer#battle_info.mump_hurt + (Aer#battle_info.mump_hurt * V1 / V2),
					NewAer = NewAer0#battle_info{
						mump_hurt = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MAGICHURTATT ->
					NewAer0 = cale_active_type(Aer,?CalcMagic),
					Magic = Aer#battle_info.magic_hurt + (Aer#battle_info.magic_hurt * V1 / V2),
					NewAer = NewAer0#battle_info{
						magic_hurt = Magic					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_FARHURTATT ->
					NewAer0 = cale_active_type(Aer,?CalcFar),
                    Far = Aer#battle_info.far_hurt + (Aer#battle_info.magic_hurt * V1 / V2),
					NewAer = NewAer0#battle_info{
						far_hurt = Far					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MUMPDEFENSE ->
					Att = Aer#battle_info.mump_defense + (Aer#battle_info.mump_defense * V1 / V2),
					NewAer = Aer#battle_info {
						mump_defense = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_MAGICDEFENCE ->
					Att = Aer#battle_info.magic_defense + (Aer#battle_info.magic_defense * V1 / V2),
					NewAer = Aer#battle_info {
						magic_defense = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_FARDEFENSE ->
					Att = Aer#battle_info.far_defense  + (Aer#battle_info.far_defense * V1 / V2),
					NewAer = Aer#battle_info {
						far_defense  = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_MUMPHURT ->
					NewAer0 = cale_active_type(Aer,?CalcMump),
                    Att = Aer#battle_info.mump_damage + (Aer#battle_info.mump_damage * V1 / V2),
					NewAer = NewAer0#battle_info{
						mump_damage = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MAGICHURT ->
					NewAer0 = cale_active_type(Aer,?CalcMagic),
					Magic = Aer#battle_info.magic_damage + (Aer#battle_info.magic_damage * V1 / V2),
					NewAer = NewAer0#battle_info{
						magic_damage = Magic					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_FARHURT ->
					NewAer0 = cale_active_type(Aer,?CalcFar),
                    Far = Aer#battle_info.far_damage + (Aer#battle_info.magic_damage * V1 / V2),
					NewAer = NewAer0#battle_info{
						far_damage = Far					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_HP ->
					cale_active_effect_loop(T,ID, Aer, Der);
				?ATTR_MP ->
					cale_active_effect_loop(T,ID, Aer, Der);
				?ATTR_POWERHIT ->
					Pow = Aer#battle_info.power_hit + (Aer#battle_info.power_hit * V1 / V2),
					NewAer = Aer#battle_info{
						power_hit = Pow					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_DELIGENCY ->
					Att = Aer#battle_info.deligency + (Aer#battle_info.deligency * V1 / V2),
					NewAer = Aer#battle_info {
						deligency = Att					  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_HITTARGET ->
					Hit = Aer#battle_info.hit_target + (Aer#battle_info.hit_target * V1 / V2),
					NewAer = Aer#battle_info{
						hit_target = Hit		  
					},
					cale_active_effect_loop(T,ID, NewAer, Der );
				?ATTR_ATT_ATTACK ->
					case Aer#battle_info.pet_attack_type of
						?CalcMump ->
							cale_active_effect_loop([{?ATTR_MUMPHURTATT,V1,V2} | T],ID, Aer, Der);
						?CalcMagic ->
							cale_active_effect_loop([{?ATTR_MAGICHURTATT,V1,V2} | T],ID, Aer, Der);
						?CalcFar ->
							cale_active_effect_loop([{?ATTR_FARHURTATT,V1,V2} | T],ID, Aer, Der);
						_ ->
							cale_active_effect_loop(T,ID, Aer, Der )
					end;					
				?ATTR_PHYSICS_HURT_ADD ->
					Att = Aer#battle_info.battle_physics_x + (Aer#battle_info.battle_physics_x * V1 / V2),
					NewAer = Aer#battle_info{
						battle_physics_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_RANGE_HURT_ADD ->
					Att = Aer#battle_info.battle_range_x + (Aer#battle_info.battle_range_x * V1 / V2),
					NewAer = Aer#battle_info{
						battle_range_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_MAGIC_HURT_ADD ->
					Att = Aer#battle_info.battle_magic_x + (Aer#battle_info.battle_magic_x * V1 / V2),
					NewAer = Aer#battle_info{
						battle_magic_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
				?ATTR_VINDICTIVE_HURT_ADD ->
					Att = Aer#battle_info.battle_vindictive_x + (Aer#battle_info.battle_vindictive_x * V1 / V2),
					NewAer = Aer#battle_info{
						battle_vindictive_x = Att				  
					},
					cale_active_effect_loop(T,ID, NewAer, Der);
%========================================================================================				
				?ATTR_TARGET_DUCK -> 
					Att = Der#battle_info.duck + (Der#battle_info.duck * V1 / V2),
					NewDer = Der#battle_info{
						duck = Att			  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				?ATTR_TARGET_DELIGENCY ->
					Att = Der#battle_info.deligency + (Der#battle_info.deligency * V1 / V2),
					NewDer = Der#battle_info{
						deligency = Att					  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				?ATTR_TARGET_POWERHIT ->
					Att = Der#battle_info.power_hit + (Der#battle_info.power_hit * V1 / V2),
					NewDer = Der#battle_info{
						keep_off = Att					  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				?ATTR_TARGET_KEEPOFF ->
					Att = Der#battle_info.keep_off + (Der#battle_info.keep_off * V1 / V2),
					NewDer = Der#battle_info{
						keep_off = Att					  
					},
					cale_active_effect_loop(T,ID, Aer, NewDer );
				
				Attr ->
					?WARNING_MSG("SkillID ~w Attr2 is not at:~w~n", [ID,Attr]),
					cale_active_effect_loop(T,ID, Aer, Der)
			end;
		{K,V1,V2,V3} ->	%% 第一位是时间，第二位是机率，第三位是总随机数
			case K of	%% 目前只有人能被击倒
				?Attr_TARGET_HITDOWN ->
					if Der#battle_info.element_state =:= ?ELEMENT_STATE_INVINCIBLE -> %% 无敌时 不能击倒
							cale_active_effect_loop(T,ID,Aer,Der);
						true ->
							Now = misc_timer:now_seconds(),
							Standup = Now + tool:floor(V1/1000),
							if Der#battle_info.type =:= ?ELEMENT_PLAYER andalso V2 =:= V3  ->
						 		  	cancel_skill_prepare(Der),	%%打断技能
						 		  	NewDer = Der#battle_info{element_state = ?ELEMENT_STATE_HITDOWN,
															element_standup_date = Standup},
						   
						 		  	erlang:send_after(V1, self() , {standup, Der#battle_info.id, Der#battle_info.pid}),
						  		  	cale_active_effect_loop(T,ID,Aer,NewDer);
					   			Der#battle_info.type =:= ?ELEMENT_PLAYER ->
						   			Tmp = util:rand(1,V3),
						   			if  V2 + Aer#battle_info.attack_suppression - Der#battle_info.defense_suppression > Tmp  ->
										   	cancel_skill_prepare(Der),	%%打断技能
										   	NewDer = Der#battle_info{element_state = ?ELEMENT_STATE_HITDOWN,
															element_standup_date = Standup},
								   
										   	erlang:send_after(V1, self() , {standup, Der#battle_info.id, Der#battle_info.pid}),
								  		   	cale_active_effect_loop(T,ID,Aer,NewDer);
							   			true ->
								   			cale_active_effect_loop(T,ID,Aer,Der)
						  		 	end;
					   			true ->
						   			cale_active_effect_loop(T,ID,Aer,Der)
							end
					end;
				Attr ->
					?WARNING_MSG("SkillID ~w Attr3 is not at:~w~n", [ID,Attr]),
					cale_active_effect_loop(T,ID, Aer, Der)
			end;
		_Attr ->
			?WARNING_MSG("SkillID ~w Attr is not at:~w~n", [ID,_Attr]),
			cale_active_effect_loop(T,ID, Aer, Der)
	end.

		
get_msg_to_int(Msg) -> 
case Msg of
	{hit} -> 1;
	{miss} -> 2;
	{block} -> 3;
	{critical} -> 4;
	{reduce} -> 5;
	{addblood} -> 6
end.

get_msglist_to_msg([],M) -> M;
get_msglist_to_msg(MsgList,M) -> %{hit}进入，有{reduce}或者{block}覆盖输出
	[H|T] = MsgList,
	case H of
		hit -> 
			get_msglist_to_msg(T,M);
		reduce ->
			get_msglist_to_msg(T,{reduce});
		block ->
			get_msglist_to_msg(T,{block})
	end.
	
get_target_list([], [], L) -> L;
get_target_list(TargetList, MsgList, L) ->
	[H|T] = TargetList,
	[MH|MT] = MsgList,
	TID = H#battle_info.id,
	TT = H#battle_info.type,
	THP = H#battle_info.effect_hp,
	TMP = H#battle_info.effect_mp,
	TMsg = get_msg_to_int(MH),
	TStand = H#battle_info.element_state,
	TBuff = H#battle_info.new_buff_list,
	NL = [[TID,TT,THP,TMP,TMsg,TStand,TBuff]|L],
	get_target_list(T,MT,NL).

%战斗无效时原包返回，前台自动攻击根据此包和下面的包控制
write_battle_no_calc() ->
	pt_20:write(?PP_PLAYER_ATTACK,0).
	
%战斗蓄气
write_battle_waiting(ActorBattleInfo,SkillGroupId,LV,WaitState,X,Y) -> 
	ID = if
			 ActorBattleInfo#battle_info.type =:= ?ELEMENT_PET ->
				 ActorBattleInfo#battle_info.pet_id;
			 true ->
				 ActorBattleInfo#battle_info.id
		 end,
	pt_23:write(?PP_TARGET_ATTACKED_WAITING,
				[
				 ActorBattleInfo#battle_info.type,
				 ID,
				 SkillGroupId,
				 LV,
				 WaitState,
				 X,
				 Y
				 ]
			   ).

%战斗成功
write_battle_update(ActorBattleInfo,TargetList,MsgList,SkillLv,SkillGroupId,X,Y,_MsgSkillType) ->
	TL = get_target_list(TargetList,MsgList,[]),
	ID = if
			 ActorBattleInfo#battle_info.type =:= ?ELEMENT_PET ->
				 ActorBattleInfo#battle_info.pet_id;
			 true ->
				 ActorBattleInfo#battle_info.id
		 end,

	if
		ActorBattleInfo#battle_info.type =:= ?ELEMENT_OUR_TOWER ->
			ActorBattleType = ?ELEMENT_MONSTER;
		true ->
			ActorBattleType = ActorBattleInfo#battle_info.type
	end,
	pt_23:write(?PP_TARGET_ATTACKED_UPDATE,  
			[
				ActorBattleType,
				ID,
				SkillGroupId,
				SkillLv,
				X, 			%蓄气到成功前不能移动，所以不用担心位置
				Y, 
				ActorBattleInfo#battle_info.element_state,
				TL
			]).

%% 根据模板计算出怪物实际的攻击
get_hurt_for_monster(Hurt,MinHurt,MaxHurt) ->
	if Hurt > MaxHurt ->
			MaxHurt;
	   Hurt < MinHurt ->
			MinHurt;
		true ->
			Hurt
	end.




change_battleinfo_to_id([],OutL) -> OutL;
change_battleinfo_to_id(PlayerList,OutL) ->
	[H|T] = PlayerList,
	change_battleinfo_to_id(T,[{H#ets_users.id}|OutL]).
