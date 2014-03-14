%% Author: Administrator
%% Created: 2011-5-4
%% Description: TODO: Add description to lib_map_monster
-module(lib_map_monster).



%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl"). 
%%
%% Exported Functions
%%
-export([
		 mod_create_mon/7,
		 monster_loop/3,
		 tower_monster_loop/1,
		 get_scene_mon/0,
		 reduce_hp_and_mp/7,
		 reduce_hp_and_mp_by_self/3,
		 add_buff/2,
		 update_state/1,
		 init_mon_skill_List/1,
		 %target_move/3,
		 %target_hp/2,
		 harted_list_remove_by_target/2,
		 get_moninfo_by_id/1
		]).

-define(Move_Time_Max, 20000).			%%移动时间最大值
-define(Move_Time_Min, 3000).			%%移动时间最小值
-define(PERPAREFIGHT,1000).			%%延迟两秒战斗
%%
%% API Functions
%%

mod_create_mon(MonTemplate1, MapID, X, Y, HP1, AutoID, Now) ->
	NewAutoID = 
		if 
			AutoID > ?MON_LIMIT_NUM ->		%是否超过怪物数量限制
		   	    1;
	   		true -> 
				AutoID
                %StateID+ 1
        end,
	{MonTemplate,HP} = 
		if
			MonTemplate1#ets_monster_template.world_level =:= 1 ->
				MonWorldId = MonTemplate1#ets_monster_template.monster_id + lib_world_data:get_world_level(),				
				case data_agent:monster_template_get(MonWorldId) of
					[] ->
						{MonTemplate1,HP1};
					MonTemp ->
						{MonTemp,MonTemp#ets_monster_template.max_hp}
				end;
			true ->
				{MonTemplate1,HP1}
		end,
	mod_create_mon1(NewAutoID,MonTemplate, MonTemplate#ets_monster_template.monster_id, MapID, X, Y, HP,MonTemplate#ets_monster_template.move_speed, Now).


init_mon_skill_List(SL) ->
	Skill_List = tool:split_string_to_intlist(SL),
	F = fun(S,L) ->
			{Sid, CD} = S,
			case lib_skill:get_skill_from_template(Sid) of
				[]->
					L;
				D ->
					Record = #r_use_skill{
									  skill_id = Sid,				%% 技能id
									  skill_percent = CD,			%% 0反击时候不处于cd中1反击的时候cd中
									  skill_lv = D#ets_skill_template.current_level,		%% 技能等级
									  skill_group = D#ets_skill_template.group_id,			%% 技能组
									  skill_lastusetime = 0,						%% 技能上次使用时间
									  skill_colddown = D#ets_skill_template.cold_down_time	%% 技能冷却时间
									  },
					[Record|L]
			end
		end,
	TmpSkillList = lists:foldl(F, [], Skill_List),
	lists:reverse(TmpSkillList).
mod_create_mon1(Id, MTinfo, MonId, MapId, X, Y, Hp,MoveSeed, Now) ->
	%%技能处理=============================================
	SL = MTinfo#ets_monster_template.skill,

	%%修改技能处理，安顺序循环使用优先使用技能（第一个技能当普通攻击使用）	
	Skill_List_Final = init_mon_skill_List(SL),
	TotalSkillPercent = length(Skill_List_Final),
	%%技能处理结束==========================================
	%%掉落处理==============================================
	%%2011-05-25修改，增加t_monster_drop_item_template.
	%%对应随机落点方式取掉落物，即怪目前有三种掉落
	DL = lib_drop:get_monster_drop(MTinfo#ets_monster_template.monster_id),
	{CDL,TDL} = lib_drop:split_monster_drop_by_state(DL),
	{FDL,DropRollTimes,RandomL} = lib_drop:get_monster_drop2(MTinfo#ets_monster_template.monster_id),
	%DropLocList = lib_drop:get_drop_item_local_list(),
	%%掉落处理结束==========================================
	%%移动时间处理==========================================
	MoveTime = util:rand(?Move_Time_Min,?Move_Time_Max),
	%%移动时间处理结束======================================
	%%?PRINT("~n SL ~p ~n",[Skill_List]),
	DestructTime = if MTinfo#ets_monster_template.destruct_time =:= 0 -> 0 ;
						true ->	Now + MTinfo#ets_monster_template.destruct_time
					end,
	MonInfo = #r_mon_info{id = Id,
						  template_id = MonId,
						  template = MTinfo,
						  can_reborn = MTinfo#ets_monster_template.can_reborn,
						  destruct_time = DestructTime,
						  monster_type = MTinfo#ets_monster_template.monster_type,
						  skill_list = Skill_List_Final,
						  buff_list = [],
						  map_id = MapId,
						  born_x = X,
						  born_y = Y,
						  pos_x = X,
						  pos_y = Y,
						  hp = Hp,
						  last_path_num = 1,
						  last_path = [],
						  pid = self(),
						 % pid_map = MapPid,
%% 						  unique_key = {MapId, Id},
						  state = guard, %%guard,fight,dead,return,move,remove,reborn,readyforpower,perparefight
						  last_walk_time = misc_timer:now_seconds(),
						  harted_list = [],
						  total_been_hurted = 0,
						  drop_list_common = CDL,
						  drop_list_task = TDL,
						  
						  drop_list_once = FDL,
						  drop_roll_times = DropRollTimes,
						  drop_random_list = RandomL,
						  drop_random_list_index = 1,
						  
						  drop_local_random_list_index = 1,
		%				  drop_local_random_list = DropLocList,
						  move_speed = MoveSeed,
						  move_time = MoveTime,
						  attack_speed = MTinfo#ets_monster_template.attack_speed,
						  total_skill_percent = TotalSkillPercent %%第一个为默认技能所以不计算在内
						 },
	BattleInfo = lib_battle:init_battle_data_mon(MonInfo),
	NewMonInfo = MonInfo#r_mon_info{battle_info = BattleInfo},
%% 	AllL = case get(?DIC_MAP_MONSTER) of
%% 			   undefined ->
%% 				   [];
%% 			   V ->
%% 				   V
%% 		   end,
%% 	put(?DIC_MAP_MONSTER,[MonInfo|AllL]).
	%lib_map:add_battle_content_monster(Id,Skill_List_Final),
%% 	lib_map:update_monster_battle_object(MonInfo),
	if NewMonInfo#r_mon_info.monster_type >= ?Tower_Target_Mon -> %% 归入守塔dic中
		   lib_map:update_tower_mon_dic(NewMonInfo);
			
	   true ->
		   lib_map:update_mon_dic(NewMonInfo)
	end,
	NewMonInfo.

%% 守塔怪，目前只会在副本中循环
tower_monster_loop(Time) ->
	AllL = lib_map:get_tower_mon_dic(),
	tower_monster_loop1(AllL, Time, []).

tower_monster_loop1([], _Time, NewList) ->
	lib_map:update_all_tower_mon_dic(NewList);
tower_monster_loop1([H|T], Time, NewList) ->
	NewMon = 
		try 
			Tmp = tower_mon_loop_detail(H,Time),
			case is_record(Tmp, r_mon_info) of
				true ->
					Tmp;
				_ ->
					?WARNING_MSG("monster_loop error: ~w ~n",[H#r_mon_info.state]),
					H#r_mon_info{state = guard }
			end
		catch 
			Error:Reason ->
				?WARNING_MSG("monster_loop_detail:~w~n,~w~n,Info:~w",[Error, Reason, H]),
				?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
				H#r_mon_info{state = guard }
		end,
	tower_monster_loop1(T, Time, [NewMon|NewList]).

tower_mon_loop_detail(MonInfo, Time) ->
	if MonInfo#r_mon_info.next_work_time =< Time ->
		   NewMonInfo =
			   case MonInfo#r_mon_info.state of
				   dead -> 
					   LoopTime = ?LOOPTIME,
					   lib_mon:dead(MonInfo);		%%死亡
				   _Other ->
					   LoopTime = ?LOOPTIME,
					   MonInfo
			   end,
		   ?DEBUG("dhawang --test1 :~p",[NewMonInfo#r_mon_info.next_work_time]),
		   NewMonInfo1 = NewMonInfo#r_mon_info{next_work_time = Time + LoopTime},
		   timer_buff(NewMonInfo1, Time),
		   NewMonInfo1;
	   true ->
		   MonInfo
	end.

		
%% 普通怪物循环
monster_loop(Time, IsDup, MapId) ->
	AllL = lib_map:get_mon_dic(),	
	monster_loop1(AllL, Time, IsDup, MapId, [], [], false),
	AllL1 = lib_map:get_tower_mon_dic(),
	monster_loop1(AllL1, Time, IsDup, MapId, [], [], true).
monster_loop1([], _Time, _IsDup, MapId, NewList, DList, IsTower) ->
	if
		DList =:= [] ->
			ok;
		true ->
			{ok, StandBin} = pt_12:write(?PP_MAP_MONSTER_REMOVE, DList),
			mod_map_agent:send_to_scene(MapId, StandBin)
	end,	
	if
		IsTower =:= false ->
			lib_map:update_all_mon_dic(NewList);
		true ->
			lib_map:update_all_tower_mon_dic(NewList)
	end;
monster_loop1([H|T] , Time, IsDup, MapId, NewList, DList, IsTower) ->
	
	if H#r_mon_info.state =:= reborn andalso H#r_mon_info.can_reborn =:= 0 ->
			monster_loop1(T, Time, IsDup, MapId, NewList,DList,IsTower);
	   H#r_mon_info.destruct_time > 0 andalso H#r_mon_info.destruct_time < Time div 1000 ->
			if
				H#r_mon_info.state =:= reborn ->
					monster_loop1(T, Time, IsDup, MapId, NewList,DList,IsTower);
				true ->
					monster_loop1(T, Time, IsDup, MapId, NewList,[H#r_mon_info.id|DList],IsTower)
			end;			
	   true ->	
			NewMon =
				try
					if	H#r_mon_info.template#ets_monster_template.hp_recover > 1 
							andalso H#r_mon_info.harted_list =:= []
							andalso (H#r_mon_info.state =:= guard orelse H#r_mon_info.state =:= return) ->
						H1 = lib_mon:mon_recover(H);
					true ->
						H1 = H
					end,
					Tmp = monster_loop_detail(H1,Time,IsDup),
					case is_record(Tmp,r_mon_info) of
						true ->
								Tmp;
						_ ->
								?WARNING_MSG("monster_loop error: ~w ~n",[H#r_mon_info.state]),
								H#r_mon_info{state = return }
					end
				catch 
					Error:Reason ->
								?WARNING_MSG("monster_loop_detail:~w~n,~w~n,Info:~w",[Error, Reason, H]),
								?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
								H#r_mon_info{state = return }
				end,
			monster_loop1(T, Time, IsDup, MapId, [NewMon|NewList],DList,IsTower)
	end.

monster_loop_detail(MonInfo,Time,IsDup) ->
	if MonInfo#r_mon_info.next_work_time =< Time ->
		   NewMonInfo =
			   case MonInfo#r_mon_info.state of
				   guard ->
					 case MonInfo#r_mon_info.template#ets_monster_template.act_type of 
						 ?ACT_TYPE_PASV ->%%被动怪到时运动
							 if MonInfo#r_mon_info.template#ets_monster_template.guard_distince > 0 ->
									LoopTime = ?BATTLE_LOOPTIME,	%?LOOPTIME,%时间放长
									lib_mon:begin_common_move(MonInfo,Time);
								true ->
									LoopTime = ?NOT_NEED_GUARD_LOOPTIME,
									MonInfo
							 end;
						 ?ACT_TYPE_ACT ->%%主动怪检测周围
							 LoopTime = ?BATTLE_LOOPTIME, %?LOOPTIME,%时间放长
							 if MonInfo#r_mon_info.monster_type =:= ?MONSTER_TYPE_PATH_GUARD ->
									lib_mon:begin_path_guard(MonInfo,Time);
								true ->
									lib_mon:begin_guard(MonInfo,Time,IsDup)	%%在副本时可攻击怪 - 用于守塔
							 end;
							 
						 ?ACT_TYPE_ACT_TOWER ->
							LoopTime = ?BATTLE_LOOPTIME,
							lib_mon:begin_tower_guard(MonInfo,Time,IsDup);
						 ?ACT_TYPE_ACT_OUR_TOWER ->
							 LoopTime = ?BATTLE_LOOPTIME,
							 %%?DEBUG("dhawang --testOUR_TOWER :~p",[MonInfo#r_mon_info.next_work_time]),
							 lib_mon:begin_our_tower_guard(MonInfo,Time,IsDup);
						 ?ACT_TYPE_ACT_OUR_BOSS ->
							 LoopTime = 1000000000,	%%永远不动
							 MonInfo;
						 ?MONSTER_TYPE_STONE ->
							LoopTime = 1000000000,	%%永远不动
							 MonInfo;
						 ?MONSTER_TYPE_SEAL ->
							LoopTime = 1000000000,	%%永远不动
							 MonInfo;
						 _ ->
							LoopTime = 1000000000,	%%永远不动
							 MonInfo
					   end;
				   fight ->
					   case lib_mon:begin_fight0(MonInfo) of
						   {false} -> 
							   LoopTime = ?BATTLE_LOOPTIME, %%异常处理时间
							   MonInfo;
						   {ok,TimeOut,NewSkillList} ->
							   case TimeOut of
								   0 ->
									   %%LoopTime = ?BATTLE_LOOPTIME;
									   LoopTime = MonInfo#r_mon_info.attack_speed;
								   _ ->
									   LoopTime = TimeOut
							   end,
								if
											MonInfo#r_mon_info.total_skill_percent =< MonInfo#r_mon_info.next_skill_nth + 1 ->
												Next_Skill_Nth = 1;
											true ->
												Next_Skill_Nth = MonInfo#r_mon_info.next_skill_nth + 1
								end,
								if
									NewSkillList =:= [] ->
										MonInfo#r_mon_info{next_skill_nth = Next_Skill_Nth};
									true ->
										MonInfo#r_mon_info{skill_list = NewSkillList, next_skill_nth = Next_Skill_Nth}
								end;
%% 							   SkillList = MonInfo#r_mon_info.skill_list,
%% 							   case lists:keyfind(SkillID,#r_use_skill.skill_id,SkillList) of
%% 								   false ->
%% 							   			MonInfo;
%% 								   SkillInfo ->
%% 										if
%% 											MonInfo#r_mon_info.total_skill_percent =< MonInfo#r_mon_info.next_skill_nth + 1 ->
%% 												Next_Skill_Nth = 1;
%% 											true ->
%% 												Next_Skill_Nth = MonInfo#r_mon_info.next_skill_nth + 1
%% 										end,
%% 									   NewSkillList = lists:keyreplace(SkillID,
%% 																	   #r_use_skill.skill_id,
%% 																	   SkillList,
%% 																	   SkillInfo#r_use_skill{skill_lastusetime = misc_timer:now_seconds()}),
%% 									   MonInfo#r_mon_info{skill_list = NewSkillList, next_skill_nth = Next_Skill_Nth}
%% 							   end;
						   V -> 
							   LoopTime = ?LOOPTIME,
							   V
					   end;
				   dead -> 
					   LoopTime = ?LOOPTIME,
					   lib_mon:dead(MonInfo);		%%死亡 清空仇恨列表
				   return -> 
					   LoopTime = ?LOOPTIME,
					   lib_mon:begin_return(MonInfo); %%返回 清空仇恨列表
				   move -> 
						case lib_mon:common_moving(MonInfo) of
									{TmpMonInfo,NextWorkTime} ->
									LoopTime = NextWorkTime,
									TmpMonInfo;
								TmpMonInfo ->
									LoopTime = ?LOOPTIME,
									TmpMonInfo
						end;
				   remove -> 
					   LoopTime = MonInfo#r_mon_info.template#ets_monster_template.reborn_time,
					   lib_mon:remove(MonInfo);
				   reborn -> 
					   LoopTime = ?LOOPTIME,
					   lib_mon:reborn(MonInfo);
				   readyforpower ->
					   LoopTime = ?LOOPTIME,
					   MonInfo;
				   perparefight -> 
					   LoopTime = ?PERPAREFIGHT,
					   lib_mon:begin_perparefight(MonInfo)
			   end,	
		   NewMonInfo1 = NewMonInfo#r_mon_info{next_work_time = Time + LoopTime},
		   timer_buff(NewMonInfo1, Time),
		   %%lib_map:update_monster_battle_object(NewMonInfo1),
		   NewMonInfo1;
	   true ->
		   MonInfo,
		   timer_buff(MonInfo,Time)
	end.

%% buff处理
timer_buff(MonInfo,Time) ->
	case length(MonInfo#r_mon_info.buff_list) > 0 of
		true ->
			{RemoveL,NewMonInfo,NeedSave} = lib_buff:timer_buff_list(MonInfo#r_mon_info.buff_list,
																		?ELEMENT_MONSTER,
																		Time,
																		[],
																		[],
																		MonInfo,
																		0),
			case length(RemoveL) > 0 of
				true ->
					lib_buff:send_buff_update(?ELEMENT_MONSTER,
											  NewMonInfo#r_mon_info.id,
											  RemoveL,
											  0,
											  NewMonInfo#r_mon_info.map_id,
											  NewMonInfo#r_mon_info.pos_x,
											  NewMonInfo#r_mon_info.pos_y, 
											  []);
				_ ->
					skip
			end,
			case NeedSave of
				1 ->
					BattleInfo = lib_battle:init_battle_data_mon(NewMonInfo),
					NewMonInfo1 = NewMonInfo#r_mon_info{battle_info = BattleInfo},
					lib_map:update_mon_dic(NewMonInfo1);
				_ ->
					NewMonInfo1 = NewMonInfo
			end,
			NewMonInfo1;
		_ ->
			MonInfo
	end.

get_scene_mon() ->
	AllL = lib_map:get_mon_dic(),
	F = fun(X) -> 
				get_scene_mon_detail(X) 
		end,
	[F(I) || I <- AllL].

get_scene_mon_detail(MonInfo) ->
	[MonInfo#r_mon_info.id,
	 MonInfo#r_mon_info.template_id,
	 MonInfo#r_mon_info.pos_x,
	 MonInfo#r_mon_info.pos_y,
	 MonInfo#r_mon_info.hp,
	 MonInfo#r_mon_info.last_path].

%扣hp mp 加bufflist
reduce_hp_and_mp(HurtType, ID, TargetPid, TargetID, HP,MP,BuffList) ->
%% 	?DEBUG("HurtType:~p",[{HurtType,TargetID,ID,HP}]),
	if		
		HurtType =:= ?ELEMENT_PLAYER orelse HurtType =:= ?ELEMENT_PET->
			case get_moninfo_by_id(ID) of
				MonInfo when is_record(MonInfo,r_mon_info) ->
					if MonInfo#r_mon_info.state =:= return ->
						   {false};	%返回状态不扣
					   true ->
						   NewMonInfo = lib_mon:reduce_hp_and_mp(TargetPid,TargetID,MonInfo,HP,MP),
						   NewMonInfo1 = NewMonInfo#r_mon_info{buff_list = BuffList},
						   put_moninfo_by_id(ID,NewMonInfo1),
						   {ok}
					end;
				_ ->
					{ok}	%%先返回，让前台可以继续删除对象
			end;
		HurtType =:= ?ELEMENT_MONSTER -> %% 怪物攻击塔/塔攻击怪物
			case lib_map:get_online_monster(ID, ?ELEMENT_OUR_TOWER) of
				[] ->					
					{ok};
				MonInfo when is_record(MonInfo, r_mon_info) ->
					NewMonInfo = lib_mon:reduce_hp_and_mp_for_tower(MonInfo, HP),
					NewMonInfo1 = NewMonInfo#r_mon_info{buff_list = BuffList},
					lib_map:update_tower_mon_dic(NewMonInfo1),
					{ok};
				_er ->
					?DEBUG("get onlien monster error:~p, hurt type:~p",[_er, HurtType]),
					{ok}
			end;
		HurtType =:= ?ELEMENT_OUR_TOWER ->
			case lib_map:get_online_monster(ID, ?ELEMENT_MONSTER) of
				[] ->					
					{ok};
				MonInfo when is_record(MonInfo, r_mon_info) ->
					NewMonInfo = lib_mon:reduce_hp_and_mp_for_tower(MonInfo, HP),
					NewMonInfo1 = NewMonInfo#r_mon_info{buff_list = BuffList},
					lib_map:update_mon_dic(NewMonInfo1),
					{ok};
				_er ->
					?DEBUG("get onlien monster error:~p, hurt type:~p",[_er, HurtType]),
					{ok}
			end
	end.

reduce_hp_and_mp_by_self(ID, HP, MP) ->
	MonInfo = get_moninfo_by_id(ID),
 	NewMonInfo = lib_mon:reduce_hp_and_mp_by_self(MonInfo,HP,MP),
	%lib_map:update_monster_battle_object(NewMonInfo),
	put_moninfo_by_id(ID,NewMonInfo).

update_state(NewMonInfo) ->
	put_moninfo_by_id(NewMonInfo#r_mon_info.id, NewMonInfo).


add_buff(ID,ChangeBuffList) ->
	MonInfo = get_moninfo_by_id(ID),
	{BuffList,NewBuffList,NewRemoveBuffList} = lib_buff:add_buff_to_buff_list(MonInfo#r_mon_info.id, ChangeBuffList,MonInfo#r_mon_info.buff_list),
	NewMonInfo = MonInfo#r_mon_info{buff_list = BuffList},
	%lib_map:update_monster_battle_object(NewMonInfo),
	put_moninfo_by_id(ID,NewMonInfo),
	NewBuffList.

%target_move([],_X,_Y) -> ok;
%target_move(IDList,X,Y) ->
%	[H|T] = IDList,
%	{ID} = H,
%	MonInfo = get_moninfo_by_id(ID),
%	NewMonInfo = MonInfo#r_mon_info{target_pos_x = X,target_pos_y = Y},
%	put_moninfo_by_id(ID,NewMonInfo),
%	target_move(T,X,Y).

%target_hp([],_HP) -> ok;
%target_hp(IDList,HP) ->
%	[H|T] = IDList,
%	{ID} = H,
%	MonInfo = get_moninfo_by_id(ID),
%	NewMonInfo = MonInfo#r_mon_info{target_hp = HP},
%	put_moninfo_by_id(ID,NewMonInfo),
%	target_hp(T,HP).

%清除仇恨
harted_list_remove_by_target([],_TargetPid) -> ok;
harted_list_remove_by_target(IDList,TargetPid) ->
	[H|T] = IDList,
	{ID} = H,
	harted_list_remove_by_target_detail(ID,TargetPid),
	harted_list_remove_by_target(T,TargetPid).
	

harted_list_remove_by_target_detail(ID,TargetPid) ->
	case get_moninfo_by_id(ID) of
		MonInfo when is_record(MonInfo,r_mon_info) ->
			%MonInfo = get_moninfo_by_id(ID),
			NewHartedList0 = lib_mon:harted_list_remove_by_player(TargetPid,MonInfo#r_mon_info.harted_list),
			NewMonInfo =
				case lib_mon:harted_list_target_remove_by_player(NewHartedList0,MonInfo#r_mon_info.id) of
					[] ->
						MonInfo#r_mon_info{harted_list = [],target_pid=undefined};%,target_pos_x=0,target_pos_y =0,target_hp=0};
					{NHL,NewTargetPid,_TargetPosX,_TargetPosY,_TargetHPL} ->
						MonInfo#r_mon_info{harted_list = NHL,target_pid=NewTargetPid}%,target_pos_x=TargetPosX,target_pos_y =TargetPosY,target_hp=TargetHPL}
				end,
			put_moninfo_by_id(ID,NewMonInfo);
		_ ->
			{skip}
	end.

%%
%% Local Functions
%%
get_moninfo_by_id(ID) ->
%% 	lists:keyfind(ID,#r_mon_info.id,get(?DIC_MAP_MONSTER)).
	List = lib_map:get_mon_dic(),
	lists:keyfind(ID, #r_mon_info.id, List).


put_moninfo_by_id(_ID, MonInfo) ->
%% 	put(?DIC_MAP_MONSTER,lists:keyreplace(ID,#r_mon_info.id,get(?DIC_MAP_MONSTER),MonInfo)).
	lib_map:update_mon_dic(MonInfo).

	


	
	
	
	

