%%%-------------------------------------------------------------------
%%% Module  : lib_mon

%%% Description : 怪物
%%%-------------------------------------------------------------------
-module(lib_mon).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%-define(Macro, value).
%-define(MOVE_TIME, 10). 			%% 自动移动时间,单位秒
-define(ACT_RANGE,50). %%距离50内不跟，超过就接近
-define(SKILL_RANDOM,10000). %%技能random上限
-define(MOVE_PERCENT_MAX,100). %%移动可能性上限 
-define(MOVE_PERCENT,45).	%%移动的可能性机率
-define(MOVE_STEP_MAX,6).		%%移动步数上限
%-define(Move_1, [-18.75,-18.75]).
%-define(Move_2, [-18.75,0]).
%-define(Move_3, [-18.75,18.75]).
%-define(Move_4, [0,-18.75]).
%-define(Move_5, [0,18.75]).
%-define(Move_6, [18.75,-18.75]).
%-define(Move_7, [18.75,0]).
%-define(Move_8, [18.75,18.75]).

%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
		 init_template_mon/0,
		 %get_monster_pid/2,
		 %get_monster_info/1,
		 harted_list_remove_by_player/2,
		 harted_list_target_remove_by_player/2,
		 begin_guard/3,
		 begin_path_guard/2,
		 begin_tower_guard/3,
		 begin_our_tower_guard/3,
		 begin_common_move/2,
		 begin_perparefight/1,
		 begin_fight0/1,
		 begin_return/1,
		 common_moving/1,
		 dead/1,
		 remove/1,
		 reborn/1,
		 reduce_hp_and_mp_by_self/3,
		 reduce_hp_and_mp/5,
		 %save_online/1,
		 mon_recover/1,
		 reduce_hp_and_mp_for_tower/2,
		 tower_dead/1
		 ]).
-export([
		 auto_player_move/3	%%测试用玩家自动走路
		 ]).
%%====================================================================
%% External functions
%%====================================================================
%%初始化怪物模板
init_template_mon() -> 
	F = fun(Mon) ->
		MonInfo = list_to_tuple([ets_monster_template] ++ Mon),
		MovePath = tool:split_string_to_intlist(MonInfo#ets_monster_template.move_path),
		NewMonInfo = MonInfo#ets_monster_template{move_path = MovePath},
  		ets:insert(?ETS_MONSTER_TEMPLATE, NewMonInfo)
	end,
	L = db_agent_template:get_monster_template(),
	lists:foreach(F, L),
	ok.

%%==========================================仇恨列表========================================================
%% 仇恨列表处理 结构 {Pid,伤害量,最后伤害时间,ID} - id用于在ets战斗表中找对象
%% 修正，增加可加怪进入仇恨列表，可攻击怪物

harted_list_add(TargetPid,Hartedlist,NewHurt, ID, SelfID) ->
	case lists:keyfind(TargetPid, 1, Hartedlist) of
		false ->
			case is_pid(TargetPid) of
				true ->
					gen_server:cast(TargetPid,{been_locked,SelfID}); %通知锁定
				_ ->
					skip
			end,
			[{TargetPid, NewHurt, get(?DIC_MAP_LOOPTIME), ID} | Hartedlist];
		{_PId, PreHurtVal, _Acttime,_ID} ->
			CurHateVal = PreHurtVal + NewHurt,
			lists:keyreplace(TargetPid, 1, Hartedlist, {TargetPid, CurHateVal, get(?DIC_MAP_LOOPTIME), ID})
	end.

%% 被动删除某项，不需再通知解锁
harted_list_remove_by_player(TragetPid,Hartedlist) ->
	lists:keydelete(TragetPid,1,Hartedlist).

%% 被动删除锁定对象，不需通知解锁者，需通知锁定者，在被动删除某项后才能执行
harted_list_target_remove_by_player(Hartedlist,SelfID) ->
	if length(Hartedlist) > 0 ->
			NHL = harted_list_sort(Hartedlist),
			{NewTargetPid,TargetPosX,TargetPosY,TargetHP} = harted_target_lock(NHL,SelfID),
			{NHL,NewTargetPid,TargetPosX,TargetPosY,TargetHP};
	   true ->
			[]
	end.

%% 主动删除某项
harted_list_remove(TargetPid, MonInfo) ->
	case harted_list_remove(TargetPid,MonInfo#r_mon_info.harted_list,MonInfo#r_mon_info.id,
													MonInfo#r_mon_info.target_pid) of
								{NewHartedList} ->
									MonInfo#r_mon_info{harted_list = NewHartedList};
								{NewHartedList,TargetPid,_TargetPosX,_TargetPosY,_TargetHP} ->
									MonInfo#r_mon_info{harted_list = NewHartedList,target_pid = TargetPid};
								[] ->
									MonInfo#r_mon_info{harted_list = [],target_pid=undefined};								
								_Msg ->
									%?WARNING_MSG("monster_begin_fight2_harted_list_remove:~w,~w,~w~n",[_Msg, TargetPid, MonInfo#r_mon_info.harted_list]),
									MonInfo#r_mon_info{harted_list = [],target_pid=undefined}
	end.
harted_list_remove(TargetPid,Hartedlist,SelfID,LockTargetPid) ->
	notice_unlock(TargetPid,SelfID),
	NHL0 = lists:keydelete(TargetPid,1,Hartedlist),
	if length(NHL0) > 0 ->
			NHL = harted_list_sort(NHL0),
			if TargetPid =:= LockTargetPid ->
				   {NewTargetPid,TargetPosX,TargetPosY,TargetHP} = harted_target_lock(NHL,SelfID),
				   {NHL,NewTargetPid,TargetPosX,TargetPosY,TargetHP};
	 		  true ->
				   {NHL}
			end;
	   true ->
		   []
	end.

%%删除怪物仇恨列表
harted_list_clear(SelfID,Hartedlist) ->
	lists:foreach(fun({Pid,_,_,_}) -> notice_unlock(Pid,SelfID) end, Hartedlist),
	[].

%%获取当前目标值，NHL已排序
harted_target_lock(NHL,MonID) ->
	{TargetPid,_,_,_EtsID} = lists:nth(1,NHL),
	notice_target_lock(TargetPid,MonID),
	if is_pid(TargetPid) ->
		   {TargetPid,0,0,0};
	   true ->
		   {undefined,0,0,0}
	end.

notice_target_lock(TargetPid,SelfID) ->
	case is_pid(TargetPid) of
		true ->
			gen_server:cast(TargetPid,{been_locked_target,SelfID});
		_ ->
			skip
	end.

notice_target_unlock(TargetPid,SelfID) ->
	case is_pid(TargetPid) of
		true ->
			gen_server:cast(TargetPid,{unlock_target,SelfID});
		_ ->
			skip
	end.

%%怪物主动通知解除锁定
notice_unlock(LockedPid,SelfID) ->
	case is_pid(LockedPid) of
		true ->
			gen_server:cast(LockedPid,{unlock,SelfID});
		_ ->
			skip
	end.

%%仇恨列表排序
harted_list_sort(HartedList) ->
	F = fun({_,V1,_,_},{_,V2,_,_}) -> V1 > V2 end,
	lists:sort(F,HartedList).

%%===========================================================================================================
%技能使用时消耗血蓝
reduce_hp_and_mp_by_self(MonInfo,HP,MP) ->
	CurrentHP = max(0, MonInfo#r_mon_info.hp - HP),
	CurrentMP = max(0, MonInfo#r_mon_info.mp - MP),
	MonInfo#r_mon_info{hp = CurrentHP,
					   mp = CurrentMP}.

%% 塔被扣血
reduce_hp_and_mp_for_tower(MonInfo, HP) ->
	CurrentHP = max(0, MonInfo#r_mon_info.hp - HP),
	%%?DEBUG("MonInfo hp:~p, id:~p",[HP, MonInfo#r_mon_info.hp]),
	if CurrentHP =:= 0 ->
		   Time = get(?DIC_MAP_LOOPTIME),	%等于下次马上执行
		   NewMonInfo = MonInfo#r_mon_info{hp = 0, next_work_time = Time, last_path = []},
			if 	MonInfo#r_mon_info.monster_type =:= ?ACT_TYPE_ACT_OUR_BOSS ->
					tower_dead(NewMonInfo);
				true ->
					dead(NewMonInfo)
			end;
	   true ->
		   MonInfo#r_mon_info{hp = CurrentHP}
	end.

tower_dead(MonInfo) ->
	case get(?DUPLICATE_PID_DIC) of
		undefined ->
			skip;
		Duplicate_Pid ->
			gen_server:cast(Duplicate_Pid, {'tower_dead'})
	end,
	MonInfo.

%扣血蓝（可由敌人或自身技能或怪引发，由于涉及到仇恨列表处理，故需拆开处理）
reduce_hp_and_mp(TargetPid,TargetID,MonInfo,HP,_MP) ->
	if (MonInfo#r_mon_info.hp > 0) ->
			%% 活动boss被攻击时，计算玩家的伤害输出
%% 			if MonInfo#r_mon_info.template_id =:= ?ACTIVE_BOSS_ID ->
%% 					HurtHp = min(MonInfo#r_mon_info.hp, HP),
%% 					gen_server:cast(mod_active_monster:get_mod_monster_pid(), {monster_hurt, MonInfo#r_mon_info.template#ets_monster_template.max_hp, TargetID, HurtHp});
%% 				true ->
%% 					ok
%% 			end,
			CurrentHP = max(0, MonInfo#r_mon_info.hp - HP),
			hurt_send_duplicate(MonInfo#r_mon_info.template#ets_monster_template.max_hp, TargetID, HP, CurrentHP, MonInfo#r_mon_info.template_id),
			case TargetPid =/= MonInfo#r_mon_info.pid of 
				true ->
					reduce_hp_and_mp1(TargetPid,TargetID,MonInfo,CurrentHP,HP);
				_ ->
					reduce_hp_and_mp2(MonInfo,CurrentHP)
			end;
	   true ->
		   MonInfo
	end.

%敌人导致
reduce_hp_and_mp1(TargetPid,TargetID,MonInfo,CurrentHP,HP) ->
	NHL0 = harted_list_add(TargetPid, 
						  MonInfo#r_mon_info.harted_list,
						  HP,
						  TargetID,
						  MonInfo#r_mon_info.id),
	%排序
	NHL = harted_list_sort(NHL0),
	case CurrentHP > 0 of
		true ->
			{TargetPid1,_,_,_EtsID} = lists:nth(1,NHL),
    		if TargetPid1 =/= MonInfo#r_mon_info.target_pid ->
				%目标变了，通知两个目标解除相关信息，并获取新的坐标
				notice_target_unlock(MonInfo#r_mon_info.target_pid,MonInfo#r_mon_info.id),
				notice_target_lock(TargetPid1,MonInfo#r_mon_info.id),
				NewTargetPid = TargetPid1;
			 true ->
				%没变
				NewTargetPid = TargetPid1
			end,
			reduce_hp_and_mp3(MonInfo,CurrentHP,HP,NHL,NewTargetPid);
			%reduce_hp_and_mp3(MonInfo,CurrentHP,HP,NHL,NewTargetPid,TargetPosX,TargetPosY,TargetHP);
		_ ->
			reduce_hp_and_mp4(MonInfo,HP,NHL)
	end.

%自身导致
reduce_hp_and_mp2(MonInfo,CurrentHP) ->
	case CurrentHP > 0 of
		true ->
			reduce_hp_and_mp3(MonInfo,CurrentHP);
		_ ->
			reduce_hp_and_mp4(MonInfo)
	end.

%敌人导致扣血
%reduce_hp_and_mp3(MonInfo,CurrentHP,HP,NHL,NewTargetPid,TargetPosX,TargetPosY,TargetHP) ->
reduce_hp_and_mp3(MonInfo,CurrentHP,HP,NHL,NewTargetPid) ->
	case MonInfo#r_mon_info.state =:= fight of
				true ->
					MonInfo#r_mon_info{hp = CurrentHP, 
							   		   total_been_hurted = MonInfo#r_mon_info.total_been_hurted + HP,
							  		   harted_list = NHL,
							   		   target_pid = NewTargetPid};
									   %target_pos_x = TargetPosX,
									   %target_pos_y = TargetPosY,
									   %target_hp = TargetHP};
				_ ->
					Time = get(?DIC_MAP_LOOPTIME),	%等于下次马上执行
					MonInfo#r_mon_info{hp = CurrentHP, 
							   		   total_been_hurted = MonInfo#r_mon_info.total_been_hurted + HP,
							   		   harted_list = NHL,
							   		   state = perparefight,
							   		   last_path = [],
									   next_work_time = Time,
									   target_pid = NewTargetPid}
									   %target_pos_x = TargetPosX,
									   %target_pos_y = TargetPosY,
									   %target_hp = TargetHP
									  % }
	end.

%自身导致扣血
reduce_hp_and_mp3(MonInfo,CurrentHP) ->
	MonInfo#r_mon_info{hp = CurrentHP}.

%敌人导致死亡
reduce_hp_and_mp4(MonInfo,HP,NHL) ->
	Time = get(?DIC_MAP_LOOPTIME),	%等于下次马上执行
	NewMonInfo = MonInfo#r_mon_info{hp = 0, 
							   total_been_hurted = MonInfo#r_mon_info.total_been_hurted + HP,
							   harted_list = NHL,
							   next_work_time = Time,
							   last_path = []},
	%跳过dead的state处理，直接进入remove，处理掉落速度的问题，不这样处理的话需要等待state切换，导致物品掉落比前段动画速度慢。
	dead(NewMonInfo).

%自身扣hp导致死亡
reduce_hp_and_mp4(MonInfo) ->
	NewMonInfo = MonInfo#r_mon_info{hp = 0,
									last_path = []},
	dead(NewMonInfo).

begin_tower_guard(MonInfo,Time,IsDup) ->
	TmpU = lib_map:get_square_random_user_target(MonInfo#r_mon_info.template#ets_monster_template.camp,
												 MonInfo#r_mon_info.pos_x,
												 MonInfo#r_mon_info.pos_y,
												 MonInfo#r_mon_info.template#ets_monster_template.act_distince,
												 1),
	if TmpU =:= [] ->
			MonInfo;
		true ->
		%%加入仇恨列表
			[U] = TmpU,		
			NHL = harted_list_add(U#ets_users.other_data#user_other.pid, 
								  MonInfo#r_mon_info.harted_list,
								  0,
								  U#ets_users.id,
								  MonInfo#r_mon_info.id),
			{TargetPid,_TargetPosX,_TargetPosY,_TargetHP} = harted_target_lock(NHL,MonInfo#r_mon_info.id),
			MonInfo#r_mon_info{state = fight,
							   harted_list = NHL,
							   target_pid = TargetPid}
	end.
begin_our_tower_guard(MonInfo,_Time,_IsDup) ->
	TmpU = lib_map:get_square_random_monster_target(-2,MonInfo#r_mon_info.pos_x,
												 MonInfo#r_mon_info.pos_y,
												 MonInfo#r_mon_info.template#ets_monster_template.act_distince,
												 1),
	if TmpU =:= [] ->
			MonInfo;
		true ->
		%%加入仇恨列表
			[U] = TmpU,	
			%% 有目标怪，加入仇恨列表
				   NHL = harted_list_add(?Target_for_tower,
										 MonInfo#r_mon_info.harted_list,
										 0,
										 U#r_mon_info.id,
										 MonInfo#r_mon_info.id),
				   %% 不需要通知
				   MonInfo#r_mon_info{state = fight,
									  harted_list = NHL,
									  target_pid = undefined}
	end.

get_path_target_point(MonInfo) ->
	Num = MonInfo#r_mon_info.last_path_num,
	MovePathLen = length(MonInfo#r_mon_info.template#ets_monster_template.move_path),
	if
		MovePathLen < Num ->
			?DEBUG("GET PATH ERROR:~p",[2]),
			{};
		true ->
			{TargetX1,TargetY1} = lists:nth(Num, MonInfo#r_mon_info.template#ets_monster_template.move_path),
			if
				abs(MonInfo#r_mon_info.pos_x - TargetX1) < 19 andalso abs(MonInfo#r_mon_info.pos_y - TargetY1) < 19 ->
					if
						MovePathLen =:= Num ->
							%?DEBUG("GET PATH ERROR:~p",[1]),
							{};
						true ->
							{TargetX,TargetY} = lists:nth(Num + 1, MonInfo#r_mon_info.template#ets_monster_template.move_path),
							{TargetX,TargetY, Num + 1}
					end;
				true ->
					{TargetX1,TargetY1,Num}
			end
	end.

path_guard(MonInfo, Time) ->
	case get_path_target_point(MonInfo) of
		{} ->
			MonInfo;
		{TargetX,TargetY,Num} ->
			PN_Num =  MonInfo#r_mon_info.move_speed div 7,
			{PN, PosX, PosY} = tower_move_path(MonInfo#r_mon_info.pos_x ,MonInfo#r_mon_info.pos_y, TargetX,TargetY,PN_Num,[]),
			NewMonInfo = MonInfo#r_mon_info{
									last_path = PN,
									last_path_num = Num,
								    last_walk_time= Time %%misc_timer:now_seconds()
								   },
			{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [NewMonInfo]),
			mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, NewMonInfo#r_mon_info.pos_x, NewMonInfo#r_mon_info.pos_y, BinData1),
			NewMonInfo#r_mon_info{pos_x = PosX, pos_y = PosY, born_x = PosX, born_y = PosY}
	end.

begin_path_guard(MonInfo, Time) ->
	TmpMonster1 = lib_map:get_square_random_our_monster_target(MonInfo#r_mon_info.pos_x,
												 MonInfo#r_mon_info.pos_y,
												 MonInfo#r_mon_info.template#ets_monster_template.act_distince,
												 1),
	if 
		TmpMonster1 =:= [] ->
				   %% 没有目标怪，主动怪找人
			NewMonInfo = begin_guard(MonInfo,Time);
		true ->
			[TmpMonster] = TmpMonster1,
			NHL = harted_list_add(?Tower_Target_Mon,
										 MonInfo#r_mon_info.harted_list,
										 0,
										 TmpMonster#r_mon_info.id,%%目标怪物id
										 MonInfo#r_mon_info.id),
		NewMonInfo = MonInfo#r_mon_info{state = perparefight,
									  harted_list = NHL,
									  target_pid = undefined}
	end,
	case NewMonInfo#r_mon_info.state of
		perparefight ->
			NewMonInfo#r_mon_info{state = fight};
		_ ->
			path_guard(NewMonInfo, Time)
	end.

begin_guard(MonInfo,Time,IsDup) ->
	case IsDup of
		1 ->	%%在副本，主动怪验证守塔,不需要验证距离
			MovePath = MonInfo#r_mon_info.template#ets_monster_template.move_path,
			case length(MovePath) of
				0 ->
					NeedAddHarted = true,
					NewMonInfo = MonInfo;
				L ->
					{X, Y} = lists:nth(L, MovePath),
					if MonInfo#r_mon_info.pos_x =:= X ->
						NeedAddHarted = true,
						NewMonInfo = MonInfo;
					true ->						
						NeedAddHarted = false,
						PN = make_common_move_path(MovePath, MonInfo#r_mon_info.pos_x,MonInfo#r_mon_info.pos_y),
						NewMonInfo = MonInfo#r_mon_info{
												last_path = PN,%%[[x,y],[x1,y1]]
											    last_walk_time = Time,
												state = move
											   },%%转为move状态
						%%通知路径
						{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [NewMonInfo]),
						mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, 
														NewMonInfo#r_mon_info.pos_x, 
														NewMonInfo#r_mon_info.pos_y, 
														BinData1)
					end
			end,
			if NeedAddHarted =:= true ->
				TmpMonster1 = lib_map:get_square_random_our_monster_target(NewMonInfo#r_mon_info.pos_x,
												 NewMonInfo#r_mon_info.pos_y,
												 NewMonInfo#r_mon_info.template#ets_monster_template.act_distince,
												 1),
				if TmpMonster1 =:= [] ->
				   %% 没有目标怪，主动怪找人
				   begin_guard(NewMonInfo,Time);
			    true ->
				   %% 有目标怪，加入仇恨列表
					[TmpMonster] = TmpMonster1,
				   NHL = harted_list_add(?Tower_Target_Mon,
										 NewMonInfo#r_mon_info.harted_list,
										 0,
										 TmpMonster#r_mon_info.id,
										 NewMonInfo#r_mon_info.id),
				   %% 不需要通知
				   NewMonInfo#r_mon_info{state = perparefight,
									  harted_list = NHL,
									  target_pid = undefined}
				end;
			true ->
				NewMonInfo
			end; 

		_ ->
			begin_guard(MonInfo,Time)
	end.

%%主动怪检查周围，行走或将目标加入仇恨表，并转变状态
begin_guard(MonInfo,Time) ->
	TmpU = lib_map:get_square_random_user_target(MonInfo#r_mon_info.template#ets_monster_template.camp,
												 MonInfo#r_mon_info.pos_x,
												 MonInfo#r_mon_info.pos_y,
												 MonInfo#r_mon_info.template#ets_monster_template.act_distince,
												 1),
	if TmpU =:= [] ->
		%%运动
		   if MonInfo#r_mon_info.template#ets_monster_template.guard_distince > 0 ->
					begin_common_move(MonInfo,Time);
			  true ->
				  	MonInfo
		   end;
		true ->
		%%加入仇恨列表
			[U] = TmpU,
			%%TargetPid = lib_player:get_player_pid(U#ets_users.id),
			add_user_into_harted_list(U, MonInfo)
	end.
add_user_into_harted_list(U, MonInfo) ->
	NHL = harted_list_add(U#ets_users.other_data#user_other.pid, 
								  MonInfo#r_mon_info.harted_list,
								  0,
								  U#ets_users.id,
								  MonInfo#r_mon_info.id),
	{TargetPid,_TargetPosX,_TargetPosY,_TargetHP} = harted_target_lock(NHL,MonInfo#r_mon_info.id),
	MonInfo#r_mon_info{state = perparefight,
							   harted_list = NHL,
							   target_pid = TargetPid}.

%% 攻击塔的过程中，优先攻击人
fight_guard(MonInfo) ->
	{false,MonInfo}.
%% 	TmpU = lib_map:get_square_random_user_target(MonInfo#r_mon_info.template#ets_monster_template.camp,
%% 												 MonInfo#r_mon_info.pos_x,
%% 												 MonInfo#r_mon_info.pos_y,
%% 												 MonInfo#r_mon_info.template#ets_monster_template.act_distince,
%% 												 1),
%% 	if TmpU =:= [] ->
%% 		   {false,MonInfo}; %%没有找到人
%% 	   true -> %% 加入仇恨列表
%% 		   [U] = TmpU,
%% 		   NHL = harted_list_add(U#ets_users.other_data#user_other.pid, 
%% 								  MonInfo#r_mon_info.harted_list,
%% 								  1,
%% 								  U#ets_users.id,
%% 								  MonInfo#r_mon_info.id),
%% 			{TargetPid,_TargetPosX,_TargetPosY,_TargetHP} = harted_target_lock(NHL,MonInfo#r_mon_info.id),
%% 		   %% 维持当前状态，只改变仇恨列表和锁定信息
%% 			{ok,
%% 		   MonInfo#r_mon_info{harted_list = NHL,
%% 							  last_path = [],	%%重新寻路
%% 							   target_pid = TargetPid}} %% 有人物对象
%% 	end.

%%从准备战斗切换为战斗，即为了在巡逻和防御间加入延迟时间
begin_perparefight(MonInfo) ->
	MonInfo#r_mon_info{state = fight}.

%%普通移动
begin_common_move(MonInfo,Time) ->
	case Time - MonInfo#r_mon_info.last_walk_time > MonInfo#r_mon_info.move_time of
		true ->
			begin_common_move1(MonInfo,Time);
		_ ->
			MonInfo
	end.

begin_common_move1(MonInfo,Time) ->
	Move = util:rand(1,?MOVE_PERCENT_MAX),
	case ?MOVE_PERCENT > Move of
			true ->
				%%开始走
				%?DEBUG("make_common_move_path:~p",[MonInfo#r_mon_info.pos_x]),
				PN = make_common_move_path(MonInfo#r_mon_info.pos_x,
										   MonInfo#r_mon_info.pos_y,
										   MonInfo#r_mon_info.born_x,
										   MonInfo#r_mon_info.born_y,
										   MonInfo#r_mon_info.template#ets_monster_template.guard_distince),
				if length(PN) > 0 ->
						NewMonInfo = MonInfo#r_mon_info{
												last_path = PN,
											    last_walk_time = Time,
												state = move
											   },%%转为move状态
						%%通知路径
						{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [NewMonInfo]),
%%     					mod_map_agent:send_to_area_scene(NewMonInfo#r_mon_info.map_id, NewMonInfo#r_mon_info.pos_x,NewMonInfo#r_mon_info.pos_y, BinData1),
						mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, 
														NewMonInfo#r_mon_info.pos_x, 
														NewMonInfo#r_mon_info.pos_y, 
														BinData1),
						NewMonInfo;
				   true ->
					   	MonInfo#r_mon_info{last_walk_time = Time}
				end;
			_ ->
				MonInfo#r_mon_info{last_walk_time = Time}
	end.

begin_fight0(MonInfo) ->
	case MonInfo#r_mon_info.template#ets_monster_template.monster_type of
		?MONSTER_TYPE_STONE -> %%石头类怪物不会攻击，移动
			MonInfo#r_mon_info{state = guard, target_pid=undefined};
		?MONSTER_TYPE_SEAL -> %%石头类怪物不会攻击，移动
			MonInfo#r_mon_info{state = guard, target_pid=undefined};
		_ ->
			case length(MonInfo#r_mon_info.harted_list) > 0 of
				true ->
					{TargetPid,_,_,EtsID} = lists:nth(1,MonInfo#r_mon_info.harted_list),
					begin_fight1(MonInfo,TargetPid,EtsID);
				_ ->
					%%如果列表中没有对象了，返回return状态，返回原点再返回guard状态
					MonInfo#r_mon_info{state = return, target_pid=undefined}%,target_pos_x = 0,target_pos_y = 0,target_hp = 0}
			end
	end.

begin_fight1(MonInfo,TargetPid,EtsID) ->
	begin_fight2(MonInfo,TargetPid,EtsID).

begin_fight2(MonInfo,TargetPid,EtsID) ->
	case is_pid(TargetPid) of
		true -> %% 是人
			case lists:keyfind(EtsID,#ets_users.id,lib_map:get_online_dic()) of
				Player when is_record(Player, ets_users) ->
					case Player#ets_users.current_hp > 0 of
						true ->
							begin_fight3(MonInfo,Player);
						_ ->
							harted_list_remove(TargetPid,MonInfo)
					end;
				_ ->
					{false}
			end;
		_Other when	TargetPid =:= ?Target_for_tower ->%%普通怪物
			case lists:keyfind(EtsID, #r_mon_info.id, lib_map:get_mon_dic()) of
						TowerMon when is_record(TowerMon, r_mon_info) ->
							case TowerMon#r_mon_info.hp > 0 of
								true ->
									begin_fight3(MonInfo,TowerMon);
								_ ->
									harted_list_remove(TargetPid,MonInfo)
							end;
						_ -> %% 找不到，应该挂掉了，清掉
							harted_list_remove(TargetPid,MonInfo)
			end;
		_ -> %% 是守塔怪
			%%case fight_guard(MonInfo) of
			%%	{ok, NewMonInfo1} ->
			%%		begin_fight0(NewMonInfo1);
			%%	_ ->	%%没有找到人，继续向下	
					case lists:keyfind(EtsID, #r_mon_info.id, lib_map:get_tower_mon_dic()) of
						TowerMon when is_record(TowerMon, r_mon_info) ->
							case TowerMon#r_mon_info.hp > 0 of
								true ->
									begin_fight3(MonInfo,TowerMon);
								_ ->
									harted_list_remove(TargetPid,MonInfo)
							end;
						_ -> %% 找不到，应该挂掉了，清掉
							harted_list_remove(TargetPid,MonInfo)
					end
			%%end
	end.


begin_fight3(MonInfo,Target) ->
	if MonInfo#r_mon_info.last_path =/= [] ->
		fight_moving(MonInfo);
	true ->
		case is_record(Target, ets_users) of
			true ->
				   TargetID = Target#ets_users.id,
				   TargetType = ?ELEMENT_PLAYER,
				   TargetX = Target#ets_users.pos_x,
				   TargetY = Target#ets_users.pos_y;
			_ ->
				   TargetID = Target#r_mon_info.id,
				   TargetType = ?ELEMENT_MONSTER,
				   TargetX = Target#r_mon_info.pos_x,
				   TargetY = Target#r_mon_info.pos_y
		end,
		   	DistanceX = abs(MonInfo#r_mon_info.pos_x - TargetX),
		   	DistanceY = abs(MonInfo#r_mon_info.pos_y - TargetY),
		   	case MonInfo#r_mon_info.total_skill_percent =:= 0 of
				true ->
					{false};
				_ ->
					%%case get_random_skill(MonInfo#r_mon_info.skill_list, MonInfo#r_mon_info.skill_list,util:rand(1,MonInfo#r_mon_info.total_skill_percent)) of
					case get_random_skill(MonInfo#r_mon_info.skill_list, MonInfo#r_mon_info.next_skill_nth) of
						{S1,NewSkillList} ->
							SkillData = lib_skill:get_skill_from_template(S1#r_use_skill.skill_id), 
		   					case begin_fight4(MonInfo, SkillData,MonInfo#r_mon_info.skill_list,
								 DistanceX,DistanceY,TargetID,TargetType,TargetX,TargetY) of
								{ok,TimeOut,_SkillID} ->
									{ok,TimeOut,NewSkillList};
								Other ->
									Other
							end;
						_ ->
		   					?DEBUG("monster skill info:~p",[false]),
							{false}
		   			end
			end
	end.

begin_fight4(MonInfo,SkillData,SkillList,DistanceX,DistanceY,TargetID,TargetType,TargetX,TargetY) ->
	if (DistanceX > SkillData#ets_skill_template.range) orelse (DistanceY > SkillData#ets_skill_template.range) ->
		   if 
				MonInfo#r_mon_info.template#ets_monster_template.act_type =:= ?ACT_TYPE_ACT_OUR_TOWER 
				orelse MonInfo#r_mon_info.template#ets_monster_template.act_type =:= ?ACT_TYPE_ACT_OUR_BOSS 
				orelse MonInfo#r_mon_info.template#ets_monster_template.act_type =:= ?ACT_TYPE_ACT_TOWER ->
					MonInfo#r_mon_info{state = return, target_pid=undefined, harted_list = []};
				true ->
		  			NewMonInfo =  begin_fight_move(MonInfo,TargetX,TargetY),
					NewMonInfo
			end;
	   true ->
			if MonInfo#r_mon_info.template#ets_monster_template.act_type =:= ?ACT_TYPE_ACT_OUR_TOWER  ->
					ActorType = ?ELEMENT_OUR_TOWER;
				true ->
					ActorType = ?ELEMENT_MONSTER
			end,
		 %?DEBUG("Monste info :~p",[{MonInfo#r_mon_info.template_id, ActorType}]),
		 lib_battle:battle_start(MonInfo#r_mon_info.id,
								   TargetID,
								   SkillData,
								   SkillList,
								   TargetX,
								   TargetY,
								   TargetType,
								   ActorType)
	end.

%%守塔怪物巡逻路径
tower_move_path(PosX,PosY,_TargetX,_TargetY,0,PN) -> 
	{PN,PosX,PosY};
tower_move_path(PosX,PosY,TargetX,TargetY,Step,PN) ->
	OffsetX = fight_move_path1(PosX,TargetX),
	OffsetY = fight_move_path1(PosY,TargetY),
	TmpL = length(PN),
	{NPX1,NPY1} = make_path_point(TmpL, OffsetX, OffsetY),
	NPN = PN ++ [[PosX + NPX1,PosY + NPY1]],
	NStep = Step - 1,
	tower_move_path(PosX+NPX1,PosY+NPY1,TargetX,TargetY,NStep,NPN).

fight_move_path(_PosX,_PosY,_TargetX,_TargetY,0,PN) -> PN;
fight_move_path(PosX,PosY,TargetX,TargetY,Step,PN) ->
	OffsetX = fight_move_path1(PosX,TargetX),
	OffsetY = fight_move_path1(PosY,TargetY),
	TmpL = length(PN),
	{NPX1,NPY1} = make_path_point(TmpL, OffsetX, OffsetY),
	NPN = PN ++ [[PosX + NPX1,PosY + NPY1]],
	NStep = Step - 1,
	fight_move_path(PosX+NPX1,PosY+NPY1,TargetX,TargetY,NStep,NPN).

fight_move_path1(Pos,Target) ->
	if 
		Pos - Target > 18.75 -> 
			-18.75;
		Pos - Target < -18.75 ->
			18.75;
		true -> 
			0
	end.

%%战斗的接近移动
begin_fight_move(MonInfo,TargetX,TargetY) ->
	PN_Num =  MonInfo#r_mon_info.move_speed div 7,
	PN = fight_move_path(MonInfo#r_mon_info.pos_x ,MonInfo#r_mon_info.pos_y, TargetX,TargetY,PN_Num,[]),
	NewMonInfo = MonInfo#r_mon_info{
									last_path = PN,
								    last_walk_time=misc_timer:now_seconds()
								   },
	{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [NewMonInfo]),
%%     mod_map_agent:send_to_area_scene(NewMonInfo#r_mon_info.map_id, NewMonInfo#r_mon_info.pos_x,NewMonInfo#r_mon_info.pos_y, BinData1),
	mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, NewMonInfo#r_mon_info.pos_x, NewMonInfo#r_mon_info.pos_y, BinData1),
	NewMonInfo.

begin_return(MonInfo) ->
	if (MonInfo#r_mon_info.last_path =:= []) 
		 ->
		   if (abs(MonInfo#r_mon_info.pos_x - MonInfo#r_mon_info.born_x) > 18.75) orelse (abs(MonInfo#r_mon_info.pos_y - MonInfo#r_mon_info.born_y) > 18.75)
				->
				  %%寻找返回的路径
				  if length(MonInfo#r_mon_info.harted_list) > 0 ->
				  		L = harted_list_clear(MonInfo#r_mon_info.id,MonInfo#r_mon_info.harted_list),
						%notice_target_unlock(MonInfo#r_mon_info.target_pid,MonInfo#r_mon_info.id),
				  		NewMonInfo = MonInfo#r_mon_info{harted_list=L,
													target_pid = undefined};
													%target_pos_x = 0,
													%target_pos_y = 0,
													%target_hp = 0};
					 true ->
						 NewMonInfo = MonInfo
				  end,
				  begin_return1(NewMonInfo);
			  true ->
					{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [MonInfo]),
					mod_map_agent:send_to_map_scene(MonInfo#r_mon_info.map_id, 
									MonInfo#r_mon_info.pos_x, 
									MonInfo#r_mon_info.pos_y, 
									BinData1),
					MonInfo#r_mon_info{state = guard} %%已到达出生点附近
		   end;
	   true ->
			common_moving(MonInfo)
	end.

begin_return1(MonInfo) ->
	PN_Num =  MonInfo#r_mon_info.move_speed div 7,
	PN = fight_move_path(MonInfo#r_mon_info.pos_x,MonInfo#r_mon_info.pos_y,MonInfo#r_mon_info.born_x,MonInfo#r_mon_info.born_y,PN_Num,[]),
	%PN = loop_return_move(MonInfo#r_mon_info.pos_x,MonInfo#r_mon_info.pos_y,MonInfo#r_mon_info.born_x,MonInfo#r_mon_info.born_y,[]),
	NewMonInfo = MonInfo#r_mon_info{last_path = PN,
								   last_walk_time=misc_timer:now_seconds()								
								   },
	{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [NewMonInfo]),
%%     mod_map_agent:send_to_area_scene(NewMonInfo#r_mon_info.map_id, NewMonInfo#r_mon_info.pos_x,NewMonInfo#r_mon_info.pos_y, BinData1),
	mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, 
									NewMonInfo#r_mon_info.pos_x, 
									NewMonInfo#r_mon_info.pos_y, 
									BinData1),
	NewMonInfo.

% 死亡
dead(MonInfo) ->
	List = lib_map:get_online_dic(),	
	dead_exp_award(MonInfo,List), %经验
	DropNumber = dead_dropitem_award(MonInfo,List), %掉落
	L = harted_list_clear(MonInfo#r_mon_info.id,MonInfo#r_mon_info.harted_list),
	Nth = 
		if MonInfo#r_mon_info.drop_random_list_index + MonInfo#r_mon_info.drop_roll_times > ?DROP_ITEM_LIST_ROUND ->
			  MonInfo#r_mon_info.drop_random_list_index + MonInfo#r_mon_info.drop_roll_times - ?DROP_ITEM_LIST_ROUND;
		   true ->
			   MonInfo#r_mon_info.drop_random_list_index + MonInfo#r_mon_info.drop_roll_times
		end,
	DropNth = 
		if MonInfo#r_mon_info.drop_local_random_list_index + DropNumber > ?DROP_LOCAL_LIST_ROUND ->
			   MonInfo#r_mon_info.drop_local_random_list_index + DropNumber - ?DROP_LOCAL_LIST_ROUND;
		   true ->
			   MonInfo#r_mon_info.drop_local_random_list_index + DropNumber
		end,
	MonInfo#r_mon_info{
					   buff_list = [],
					   state = remove,
					   harted_list = L,
					   total_been_hurted = 0,
					   target_pid = undefined,
					   drop_random_list_index = Nth,
					   drop_local_random_list_index = DropNth
					   }.



remove(MonInfo) ->
	MonInfo#r_mon_info{
					   state = reborn
					   }.

reborn(MonInfo) ->
	NewSkillList = lib_map_monster:init_mon_skill_List(MonInfo#r_mon_info.template#ets_monster_template.skill),
	NewMonInfo = MonInfo#r_mon_info{
					   tmp_move_speed = 0,
					   buff_list = [],
					   pos_x = MonInfo#r_mon_info.born_x,
					   pos_y = MonInfo#r_mon_info.born_y,
					   hp = MonInfo#r_mon_info.template#ets_monster_template.max_hp,
						skill_list = NewSkillList,
						next_skill_nth = 1,
					   state = guard
					   },
	
	{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE_REBORN,  [NewMonInfo]),
	
%%     mod_map_agent:send_to_area_scene(NewMonInfo#r_mon_info.map_id, NewMonInfo#r_mon_info.pos_x,NewMonInfo#r_mon_info.pos_y, BinData1),
	mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, 
									NewMonInfo#r_mon_info.pos_x, 
									NewMonInfo#r_mon_info.pos_y, 
									BinData1),
	NewMonInfo.


fight_moving(MonInfo) ->
	case length(MonInfo#r_mon_info.last_path) > 0 of
		%% 如果有步就走
		 true when MonInfo#r_mon_info.template#ets_monster_template.act_type =/= ?ACT_TYPE_ACT_TOWER
			andalso MonInfo#r_mon_info.template#ets_monster_template.act_type =/= ?ACT_TYPE_ACT_OUR_TOWER
			andalso MonInfo#r_mon_info.template#ets_monster_template.act_type =/= ?ACT_TYPE_ACT_OUR_BOSS ->
			[H|T] = MonInfo#r_mon_info.last_path,
			[MoveX,MoveY] = H,
			NewMonInfo = MonInfo#r_mon_info{pos_x = MoveX, 
											pos_y = MoveY,
											last_path= T},
			
			case NewMonInfo#r_mon_info.target_pid of
				undefined -> %% 锁定的是塔怪，走的过程中继续查找看看有没有人在附近，有就把人加入仇恨列表，打人
					case fight_guard(NewMonInfo) of
						{ok, NewMonInfo1} -> %% 找到人，重新转入战斗流程
							begin_fight0(NewMonInfo1);
						_ -> %% 没找到，继续
							NewMonInfo
					end;
				_ -> %% 是人
					%%检查是不是已经到返回位置
					check_distince(NewMonInfo,NewMonInfo#r_mon_info.template#ets_monster_template.return_distince) 
			end;			
		_->
			MonInfo
		end.


%%有路径后根据路径开始走
common_moving(MonInfo) ->
	case length(MonInfo#r_mon_info.last_path) > 0 of
		%% 如果有步就走
		 true ->
			case MonInfo#r_mon_info.template#ets_monster_template.act_type of %%塔不能移动
				?ACT_TYPE_ACT_OUR_TOWER ->
					MonInfo#r_mon_info{state=guard, last_path = []};
				?ACT_TYPE_ACT_OUR_BOSS ->
					MonInfo#r_mon_info{state=guard, last_path = []};
				?ACT_TYPE_ACT_TOWER ->
					MonInfo#r_mon_info{state=guard, last_path = []};
				_ ->
				[H|T] = MonInfo#r_mon_info.last_path,
				[MoveX,MoveY] = H,
				MonInfo#r_mon_info{pos_x = MoveX,pos_y = MoveY,last_path= T}
				
				%%检查是不是已经到巡逻边界  - 因调整为在范围内取点，因此不会再超过巡逻范围，取消检查。
			end;
		_->
			case MonInfo#r_mon_info.template#ets_monster_template.act_type of
				?ACT_TYPE_PASV ->%%被动怪物结束，下次循环时间为步行间隔
					{MonInfo#r_mon_info{state=guard},MonInfo#r_mon_info.move_time}; %%转为guard状态
				_ ->
					MonInfo#r_mon_info{state=guard}
			end
	end.

mon_recover(MonInfo) ->
	if MonInfo#r_mon_info.hp < MonInfo#r_mon_info.template#ets_monster_template.max_hp andalso MonInfo#r_mon_info.hp > 0 ->
			%自动回血
			NewHP = min(MonInfo#r_mon_info.hp + MonInfo#r_mon_info.template#ets_monster_template.hp_recover,MonInfo#r_mon_info.template#ets_monster_template.max_hp),
			NewMonInfo = MonInfo#r_mon_info{hp = NewHP},
			%%通知(恢复太快，目前不考虑更新)
%% 			{ok, BinData1} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [NewMonInfo]),
%% 			mod_map_agent:send_to_map_scene(NewMonInfo#r_mon_info.map_id, 
%% 											NewMonInfo#r_mon_info.pos_x,
%% 											NewMonInfo#r_mon_info.pos_y, 
%% 											BinData1),
			NewMonInfo;
		true ->
			MonInfo
	end.

%%%====================================================================
%%% Private functions
%%%====================================================================
%%通常掉落物添加
dead_dropitem_award(MonInfo, List) ->
	NHL = harted_list_sort(MonInfo#r_mon_info.harted_list),
	case length(NHL) of
		0 ->
			0;
		_ ->
			HurtMost = lists:nth(1,NHL),
			{_OwnerPid,_,_,EtsId} = HurtMost,
			%% 地图内不要使用Call 人物
			%% 	Owner = lib_player:get_player_info(OwnerPid),
			case lists:keyfind(EtsId, #ets_users.id, List) of
				Owner when is_record(Owner, ets_users) andalso Owner#ets_users.other_data#user_other.infant_state =/= 4 ->
					DropList = lib_drop:get_drop_item_from_list(MonInfo#r_mon_info.drop_list_common),
					NumberFixDrop = dead_dropitem_award1(DropList, MonInfo, Owner, MonInfo#r_mon_info.drop_local_random_list_index),
					%%新增加的掉落机制的广播
					DropList2 = lib_drop:get_drop_item_from_list_by_random_list(MonInfo#r_mon_info.drop_list_once,
														  				MonInfo#r_mon_info.drop_roll_times,
														  				MonInfo#r_mon_info.drop_random_list_index,
														  				MonInfo#r_mon_info.drop_random_list,
																		[]),
					%MonInfo#r_mon_info.drop_local_random_list_index + NumberFixDrop
					NewDropIndex =  
						if MonInfo#r_mon_info.drop_local_random_list_index + NumberFixDrop > ?DROP_LOCAL_LIST_ROUND ->
					  		 MonInfo#r_mon_info.drop_local_random_list_index + NumberFixDrop - ?DROP_LOCAL_LIST_ROUND;
				   		true ->
					  		 MonInfo#r_mon_info.drop_local_random_list_index + NumberFixDrop
						end,		
					NumberFloatDrop = dead_dropitem_award1(DropList2, MonInfo, Owner, NewDropIndex),
					NumberFixDrop + NumberFloatDrop;
		 		_ ->
					 0
			end
	end.
	

dead_dropitem_award1(DropList, MonInfo, Owner, DropLocalIndex) ->
	case length(DropList) > 0 of
		true ->
			L = dead_dropitem_award_a(DropList,
									  MonInfo#r_mon_info.map_id,
									  MonInfo#r_mon_info.pos_x,
									  MonInfo#r_mon_info.pos_y,
									  MonInfo#r_mon_info.pid,
									  Owner#ets_users.id,
									  Owner#ets_users.other_data#user_other.pid_team,	
									  %MonInfo#r_mon_info.drop_local_random_list,
									  lib_map:get_map_random_local(),
									  DropLocalIndex,		
									  []
									 ),
			%广播
			{ok, BinData} = pt_23:write(?PP_TARGET_DROPITEM_ADD, L),
			mod_map_agent:send_to_map_scene(MonInfo#r_mon_info.map_id,
											 MonInfo#r_mon_info.pos_x,
											 MonInfo#r_mon_info.pos_y,
											 BinData),
			length(L);
		_ ->
			0
	end.

dead_dropitem_award_a([], _MapID, _X, _Y, _Pid_Map, _OwnerID, _OwnTeamPid, _LocalList, _LocalNth, L) -> L;
dead_dropitem_award_a(Templates, MapID, X, Y, Pid_Map, OwnerID, OwnTeamPid, LocalList, LocalNth, L) ->
	[H|T] = Templates,
	case is_record(H,r_drop_item_template) of
		true ->
			ItemTemplateID = H#r_drop_item_template.item_template_id,
			Amount = H#r_drop_item_template.drop_number,
			IsBind = H#r_drop_item_template.is_bind;
		_ ->
%% 			[ItemTemplateID,_,_,Amount,IsBind] = H
			ItemTemplateID = H#ets_monster_item_template.item_template_id,
			Amount = H#ets_monster_item_template.amount,
			IsBind = H#ets_monster_item_template.isbind
	end,
	{TmpL,TmpLocalNth} = dead_dropitem_award_b(ItemTemplateID,MapID,X,Y,Pid_Map,OwnerID,OwnTeamPid,IsBind,[],Amount, LocalList,LocalNth),
	NL = [TmpL|L],
	dead_dropitem_award_a(T, MapID, X, Y, Pid_Map, OwnerID, OwnTeamPid, LocalList, TmpLocalNth, NL).

dead_dropitem_award_b(_ItemTemplateID,_MapID,_X,_Y,_Pid_Map,_OwnerID,_OwnTeamPid,_IsBind,L,0,_LocalList,LocalNth) -> {L,LocalNth};
dead_dropitem_award_b(ItemTemplateID,MapID,X,Y,Pid_Map,OwnerID,OwnTeamPid,IsBind,L,Amount,LocalList,LocalNth) ->
%% 	ID =  gen_server:call(Pid_Map,'DROPITEMID',2000),
	ID = lib_map:get_drop_auto_id(),
	%% todo不要取随机数
	%TmpLocX = util:rand(1,75),
	%TmpLocY = util:rand(1,75),
	{TmpLocX,TmpLocY} = lists:nth(LocalNth,LocalList),
	LocX = X + TmpLocX - 50,
	LocY = Y + TmpLocY - 50,
	DropItem = #r_drop_item{
								id = ID,
								map_id = MapID,
								x = LocX,
								y = LocY,
								owner_id = OwnerID,
								item_template_id = ItemTemplateID,
								drop_time = misc_timer:now_seconds(),
								state = lock,
								isbind = IsBind,
								ownteampid = OwnTeamPid
							},
	
	%%添加道具消耗/产出记录
	%lib_statistics:add_item_log(ItemTemplateID, ?ITEM_DROP, 1),	
%% 	mod_map:put_dropitem_in_map(Pid_Map, DropItem),
	lib_map:update_drop_dic(DropItem),
	NL = [DropItem|L],
	NA = Amount - 1,
	NLocalNth = if LocalNth + 1 > ?DROP_LOCAL_LIST_ROUND ->
					   1;
				   true ->
					   LocalNth + 1
				end,
	dead_dropitem_award_b(ItemTemplateID,MapID,X,Y,Pid_Map,OwnerID,OwnTeamPid,IsBind,NL,NA,LocalList,NLocalNth).


%%根据攻击情况计算经验
dead_exp_award(MonInfo,List) ->
	HartedList = MonInfo#r_mon_info.harted_list,
	TotalHurt = MonInfo#r_mon_info.total_been_hurted,
	ExpFix = MonInfo#r_mon_info.template#ets_monster_template.exp_fixed,
	Exp = MonInfo#r_mon_info.template#ets_monster_template.exp,
	%% 增加一个怪物死亡通知副本
	KillUserId = get_max_hurt_ets_id(HartedList, 0,0),
	raid_active_award(List, MonInfo#r_mon_info.template_id, KillUserId),
	boss_dead_send(List, MonInfo, KillUserId),
	dead_send_duplicate(List, MonInfo#r_mon_info.template_id, KillUserId, MonInfo#r_mon_info.monster_type),%% 暂时不管是谁杀死的。
	dead_exp_award1(HartedList,TotalHurt,ExpFix,Exp, MonInfo#r_mon_info.template_id, 
					MonInfo#r_mon_info.template#ets_monster_template.level, [], MonInfo#r_mon_info.drop_list_task,
					MonInfo#r_mon_info.map_id, MonInfo#r_mon_info.pos_x, MonInfo#r_mon_info.pos_y,
					List).

%% 帮会突袭活动击怪物奖励
raid_active_award(List, MonsterId, KillUserId) ->
	if
		MonsterId =:= 9201 orelse MonsterId =:= 9202 orelse MonsterId =:= 9203 ->
			case lists:keyfind(KillUserId, #ets_users.id, List) of
				false ->
					ok;
				Player ->
					mod_guild:add_guild_feats(Player,1,1,3),
					gen_server:cast(Player#ets_users.other_data#user_other.pid_guild_map,{monster_dead})
			end;
		true ->
			ok
	end.

%% boss 死亡更新
boss_dead_send(List, MonInfo, KillUserId) ->
	case is_boss(MonInfo#r_mon_info.template_id) of
		true ->
			BossPid = mod_boss_manage:get_boss_manage_pid(),
			gen_server:cast(BossPid,{boss_dead, MonInfo#r_mon_info.template_id}),
			%lib_map:delete_mon_dic(MonInfo#r_mon_info.id),
			%erlang:send_after(1, self(), {delete_mon_dic,MonInfo#r_mon_info.id}), %怪物能自动移除不需要再调用移除方法
			case lists:keyfind(KillUserId, #ets_users.id, List) of
				false ->
					ok;
				Player ->
					ChatStr = ?GET_TRAN(?_LANG_NOTICE_KILL_BOSS, [Player#ets_users.nick_name, MonInfo#r_mon_info.template#ets_monster_template.name]),
					lib_chat:chat_sysmsg_roll([ChatStr])
			end;
		false ->
			ok
	end.

%% 怪物死亡通知副本
dead_send_duplicate(List, MonsterId, KillUserId, MonsterType) ->
	case List of
		[] ->
			ok;
		[Player|_] ->
			
			if 
				is_record(Player, ets_users) =:= false 
				orelse is_pid(Player#ets_users.other_data#user_other.pid_dungeon) =:= false ->
					skip;
				true ->
					gen_server:cast(Player#ets_users.other_data#user_other.pid_dungeon, 
							{monster_dead, MonsterId, KillUserId, MonsterType,Player#ets_users.other_data#user_other.pid_map})
			end
	end.

%% 怪物受伤通知副本
hurt_send_duplicate(Max_hp, TargetID, HurtHp, LeftHp, MonId) ->
	case lib_player:get_online_info(TargetID) of
		[] ->
			ok;
		Player ->			
			if is_pid(Player#ets_users.other_data#user_other.pid_dungeon) =:= false ->
					skip;
				Player#ets_users.other_data#user_other.map_template_id =:= ?ACTIVE_KING_FIGHT_MAP_ID orelse
				Player#ets_users.other_data#user_other.map_template_id =:= ?ACTIVE_MONSTER_MAP_ID ->
					gen_server:cast(Player#ets_users.other_data#user_other.pid_dungeon, 
							{monster_hurt, Max_hp, TargetID, HurtHp, LeftHp, MonId});
			true ->
				ok
			end
	end.

get_max_hurt_ets_id([], Id,Ht) ->
	Id;
get_max_hurt_ets_id([H|T], Id,Ht) ->
	{_Pid,Hurt,_,EtsId} = H,
	if
		Hurt > Ht ->
			get_max_hurt_ets_id(T, EtsId,Hurt);
		true ->
			get_max_hurt_ets_id(T, Id,Ht)
	end.

dead_exp_award1([],_TotalHurt,ExpFix,_Exp, MonsterId, MonsterLevel, TeamExpList, TaskItem, MapId, X, Y,_List) -> 
	dead_exp_award2(TeamExpList,MonsterLevel,ExpFix, MonsterId, TaskItem, MapId, X, Y);
dead_exp_award1(HL,TotalHurt,ExpFix,Exp, MonsterId, MonsterLevel, TeamExpList, TaskItem, MapId, X, Y,List) ->
	[H|T] = HL,
	{Pid,Hurt,_,EtsId} = H,
	%AddExp = util:floor(ExpFix + (Exp * Hurt / TotalHurt)), %向下取整
%% 	Player = lib_player:get_player_info(Pid),
	%List = lib_map:get_online_dic(),
	if is_pid(Pid) =:= true ->
			Player = lists:keyfind(EtsId, #ets_users.id, List);
		true ->
			Player = false
	end,	

	case Player of
		false ->
		   NewTeamExpList = TeamExpList,
		   skip;
	   _ ->
		    TeamPid = Player#ets_users.other_data#user_other.pid_team,
			if
				TotalHurt > 0 ->
					FExp =  util:floor(Exp * Hurt / TotalHurt); %浮动值，有队伍的话先扔入队伍数据暂存，不提交
				true ->
					FExp = util:floor(Exp / length(List))
			end,
			if TeamPid =/= undefined ->
				   NewTeamExpList =
				   case lists:keyfind(TeamPid,1,TeamExpList) of
					    {_,ExpCheck}->
						   if FExp > ExpCheck ->
						  		lists:keyreplace(TeamPid,1,TeamExpList,{TeamPid,FExp});
							  true ->
								  TeamExpList
						   end;
					  	_ ->
						  [{TeamPid,FExp}|TeamExpList]
				   end;
			   true -> %无队伍，直接加  
				    NewTeamExpList = TeamExpList,
%% 					gen_server:cast(Pid,{addexp,ExpFix,FExp,MonsterLevel,1, MapId, X, Y}),%传递
					gen_server:cast(Pid,{addexp,ExpFix,FExp,MonsterLevel,1}),
					gen_server:cast(Pid,{kill_monster, MonsterId, TaskItem})
			end
	end,
	dead_exp_award1(T,TotalHurt,ExpFix,Exp, MonsterId, MonsterLevel, NewTeamExpList, TaskItem, MapId, X, Y, List).

dead_exp_award2([],_MonsterLevel,_ExpFix, _MonsterId, _TaskItem, _MapId, _X, _Y) -> 
	ok;
dead_exp_award2(TeamExpList,MonsterLevel,ExpFix, MonsterId, TaskItem, MapId, X, Y) ->		%组队经验
	[{TeamPid,Exp}|T] = TeamExpList,
	Teammate = lib_map:get_teammate_info(TeamPid,X,Y),
	%Teammate = lib_team:get_member_pid(TeamPid),
	Number = length(Teammate),
	dead_exp_award3(Teammate, MonsterLevel, ExpFix,Exp,Number,MonsterId, TaskItem, MapId, X, Y),
	dead_exp_award2(T,MonsterLevel,ExpFix, MonsterId, TaskItem, MapId, X, Y).

dead_exp_award3([],_MonsterLevel,_ExpFix, _Exp, _Number, _MonsterId, _TaskItem, _MapId, _X, _Y) -> 
	ok;
dead_exp_award3(Teammate,MonsterLevel,ExpFix, Exp, Number, MonsterId, TaskItem, MapId, X, Y) ->
	[H|T] = Teammate,
	Pid = H#ets_users.other_data#user_other.pid,
	if
		H#ets_users.current_hp > 0 ->
%% 			gen_server:cast(Pid,{addexp,ExpFix,Exp,MonsterLevel,Number, MapId, X, Y}),%传递
			gen_server:cast(Pid,{addexp,ExpFix,Exp,MonsterLevel,Number}),
			gen_server:cast(Pid,{kill_monster, MonsterId, TaskItem});
		true ->
			skip
	end,
	dead_exp_award3(T,MonsterLevel,ExpFix,Exp, Number, MonsterId, TaskItem, MapId, X, Y).

%%循环出返回路径
loop_return_move(TmpX,TmpY,BornX,BornY,L) ->
	if 
		(abs(TmpX - BornX) < 18.75) and (abs(TmpY - BornY) < 18.75)
		  ->
			L;
		true
		  ->
			if 
				TmpX - BornX > 0 ->
				  	OffsetX = -18.75;
				TmpX - BornX < 0 ->
					OffsetX = 18.75;
				true ->
					OffsetX = 0
			end,
			if 
				TmpY - BornY > 0 ->
					OffsetY = -18.75;
				TmpY - BornY < 0 ->
					OffsetY = 18.75;
				true ->
					OffsetY = 0
			end	,
			TmpL = length(L),
			{NPX1,NPY1} = make_path_point(TmpL, OffsetX, OffsetY),
			MoveX = TmpX + NPX1,
			MoveY = TmpY + NPY1,
			loop_return_move(MoveX, MoveY,BornX,BornY,L++[[MoveX,MoveY]])
	end.

%%检查是否已经超出某种距离
check_distince(MonInfo,Distince) ->
	OffsetX = abs(MonInfo#r_mon_info.pos_x - MonInfo#r_mon_info.born_x),
	OffsetY = abs(MonInfo#r_mon_info.pos_y - MonInfo#r_mon_info.born_y),
	case (OffsetX > Distince) 
			 orelse 
	   	(OffsetY > Distince)
			of
		true ->
	   		MonInfo#r_mon_info{state = return};
		_ ->
			MonInfo
	end.

		

%%随机抽技能  -=--=--修改成安顺序使用技能3.15号修改
get_random_skill(SkillList,Index) ->
	[Basic|SkillList1] = SkillList,
	if
		SkillList1 =:= [] ->
			{Basic,[]};
		true ->
			Skill = lists:nth(Index,SkillList1),
			if 
				Skill#r_use_skill.skill_percent > 0 ->
					NewSkill = Skill#r_use_skill{skill_percent = 0, skill_lastusetime = misc_timer:now_seconds()},
					NewSkillList = lists:keyreplace(Skill#r_use_skill.skill_id, #r_use_skill.skill_id, SkillList, NewSkill),
					{Basic,NewSkillList};
				true ->
					WorkTime = Skill#r_use_skill.skill_lastusetime + (Skill#r_use_skill.skill_colddown/1000),
					Now = misc_timer:now_seconds(),
					if
						Now > WorkTime ->
							NewSkillList = lists:keyreplace(Skill#r_use_skill.skill_id,
															#r_use_skill.skill_id,
															SkillList,
															Skill#r_use_skill{skill_lastusetime = Now}),
							{Skill,NewSkillList};
						true ->
							{Basic,[]}
					end
			end
	end.
	

%% get_random_skill([],_OldSkillList,_RandomValue) -> 
%% 	[];
%% get_random_skill(SkillList,OldSkillList,RandomValue) ->
%% 	[H|T] = SkillList,
%% 	case T of 
%% 		[] ->
%% 			 WorkTime = H#r_use_skill.skill_lastusetime + (H#r_use_skill.skill_colddown/1000),
%% 			 Now = misc_timer:now_seconds(),
%% 			 case Now > WorkTime of
%% 				 true ->
%% 					 H;
%% 				 _ ->
%% 					 lists:nth(1,OldSkillList)
%% 			 end;
%% 		_ ->
%% 			if (RandomValue > H#r_use_skill.skill_percent) ->
%% 				   get_random_skill(T,OldSkillList,RandomValue);
%% 			   true ->
%% 				   WorkTime = H#r_use_skill.skill_lastusetime + (H#r_use_skill.skill_colddown/1000),
%% 				   Now = misc_timer:now_seconds(),
%% 				   case Now > WorkTime of
%% 					   true ->
%% 						  H;
%% 					  _ ->
%% 						  lists:nth(1,OldSkillList)
%% 				   end
%% 			end
%% 	end.

%% 算路径点，0向上取整，其余向下取整
make_path_point(Length, PX, PY) ->
	case Length rem 4 of
		0 ->
			NPX = util:ceil(PX),
			NPY = util:ceil(PY);
		_ ->
			NPX = util:floor(PX),
			NPY = util:floor(PY)
	end,
	{NPX,NPY}.
			

%在范围内寻找一个点然后走
make_common_move_path(PosX,PosY,BornX,BornY,GuardDistince) ->
	TmpMoveRndX = util:rand(1,GuardDistince*2),
	TmpMoveRndY = util:rand(1,GuardDistince*2),
	MoveRndX = TmpMoveRndX - GuardDistince + BornX,
	MoveRndY = TmpMoveRndY - GuardDistince + BornY,
	make_common_move_path1(PosX,PosY,MoveRndX,MoveRndY,[]).

%生成守护副本移动路径
make_common_move_path(MovePath,CurrentX,CurrentY) ->
	make_common_move_path(MovePath,CurrentX,CurrentY,[]).

make_common_move_path([],CurrentX,CurrentY,PN) ->
	PN;
make_common_move_path([{TargetX,TargetY}|L],CurrentX,CurrentY,PN) ->
	TargetY1 = TargetY + util:rand(0,100),
	NewPN = make_common_move_path1(CurrentX,CurrentY,TargetX,TargetY1,PN),
	make_common_move_path(L,TargetX,TargetY,NewPN).

make_common_move_path1(CurrentX,CurrentY,TargetX,TargetY,PN) ->
	if CurrentX =:= TargetX andalso CurrentY =:= TargetY ->
		   PN;
	   CurrentX =:= TargetX ->
		   NPX = CurrentX,
		   NPY = make_common_move_path_detail(CurrentY,TargetY),
		   TmpL = length(PN),
		   {NPX1,NPY1} = make_path_point(TmpL, NPX, NPY),
		   NPN = PN ++ [[NPX1,NPY1]],
		   make_common_move_path1(NPX1,NPY1,TargetX,TargetY,NPN);
	   CurrentY =:= TargetY ->
		   NPX = make_common_move_path_detail(CurrentX,TargetX),
		   NPY = CurrentY,
		   TmpL = length(PN),
		   {NPX1,NPY1} = make_path_point(TmpL, NPX, NPY),
		   NPN = PN ++ [[NPX1,NPY1]],
		   make_common_move_path1(NPX1,NPY1,TargetX,TargetY,NPN);
	   true ->
		   NPX = make_common_move_path_detail(CurrentX,TargetX),
		   NPY = make_common_move_path_detail(CurrentY,TargetY),
		   TmpL = length(PN),
		   {NPX1,NPY1} = make_path_point(TmpL, NPX, NPY),
		   NPN = PN ++ [[NPX1,NPY1]],
		   make_common_move_path1(NPX1,NPY1,TargetX,TargetY,NPN)
	end.

make_common_move_path_detail(Current,Target) ->
	if Current > Target ->
		   if Current - Target >= 18.75 ->
				  Current - 18.75;
			  true ->
				  Target
		   end;
	   true ->
		   if Target - Current >= 18.75 ->
				  Current + 18.75;
			  true ->
				  Target
		   end
	end.
		
		  
is_boss(MonsterId) ->
	if
		MonsterId > 999801000 andalso MonsterId < 999802000 ->
			true;
		true ->
			false
	end.

auto_player_move(MapId, PosX, PosY) ->
  MoveStepRnd = util:rand(1,?MOVE_STEP_MAX),
  PN = make_common_move_path(MapId, PosX, PosY, MoveStepRnd, []),
  LengthPN = length(PN),
			PathBin = writepath(PN,<<>>),
  <<LengthPN:16, PathBin/binary>>.
writepath([], PathBin) -> PathBin;
writepath([H | T], PathBin) ->
	[MoveX,MoveY] = H,
    NewPathBin = << PathBin/binary,
					MoveX:16,
					MoveY:16 >>,
	writepath(T, NewPathBin).