%%%------------------------------------
%%% @Module  : mod_map
%%% @Author  : 
%%% @Created : 2010.08.24
%%% @Description: 场景管理
%%%------------------------------------
-module(mod_map).
-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl"). 
-include_lib("stdlib/include/ms_transform.hrl").

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([init/1, 
		 handle_call/3, 
		 handle_cast/2, 
		 handle_info/2, 
		 terminate/2, 
		 code_change/3,
		 do_call/3,
		 do_cast/2,
		 do_info/2
		 ]).

-export([start/1, 
		 start_link/1, 
		 get_scene_pid/1,
		 get_scene_pid/3, 
		 start_mod_scene/2, 
		 start_scene/3, 
		 update_player/1,
		 update_player_skill/1,
		 update_online_dic_pet_skill/1,
%% 		 enter_map/2, 
		 leave_scene/8, 
%% 		 check_enter/2, 
%% 		 put_dropitem_in_map/2, 
		 get_dropitem_in_map/9,
		 %get_battle_object/2,
%		 update_monster_battle_object/1,
%% 		 update_player_battle_object/1,
		 update_player_pos/1,
 		 update_player_team/1,
		 update_player_hp_mp/6,
		 get_map_round_info/4,
		 update_user_onmap/2,
		 update_online_dic_invincible/2
		]).

-record(state, {
				only_id = 0, 	%% 唯一id
				map_id = 0, 	%% 模板id
				worker_id = 0,
				is_dup = 0,		%% 0为副本，1为副本
				dup_pid = undefined	,	%% 副本pid
			    kill_monster_num = 0	%% 帮会突袭活动时候使用
%% 				drop_item_id = 1, %% 掉落物id计数器
				%mon_auto_id = 1,	%%怪物自动id
				%collect_auto_id = 1 %% 采集自动id
				}).

-define(CLEAR_ONLINE_PLAYER, 10*60*1000).	  %% 每10分钟 对 ets_online 做一次清理
-define(DROP_ITEM_LOOP_TIME, 2000).			  %% 两秒对ets_drop_item处理
-define(Bonfire_Time_Tick, (20 * 1000)).	  %% 帮派篝火时间检测



%% ====================================================================
%% External functions
%% ====================================================================
start({MapId, SceneProcessName, Worker_id}) ->
    gen_server:start(?MODULE, {MapId, SceneProcessName, Worker_id}, []).

start_link({MapId, SceneProcessName, Worker_id}) ->
    gen_server:start_link(?MODULE, {MapId, SceneProcessName, Worker_id}, []).
	

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init({MapId, SceneProcessName, Worker_id}) ->
	try
		do_init({MapId, SceneProcessName, Worker_id})
	catch
		_:Reason ->
			?WARNING_MSG("mod_map handle_call is exception:~w~",[Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create map is error"}
	end.

do_init({MapId, SceneProcessName, Worker_id}) ->
	process_flag(trap_exit, true),
	misc:register(global, SceneProcessName, self()), 
	
	lib_map:put_map_dic_id(MapId), %地图的id
	
	lib_map:put_map_random_local(lib_drop:get_drop_item_local_list()),	%地图的随机掉落位置

	{TemplateId, IsDup} = 
		case lib_map:is_copy_scene(MapId) of
			true ->
				put(?DIC_MAP_MON_AUTO_ID, 1),
				{lib_map:get_copy_map_id(MapId), 1};
			_ ->
				{MapId, 0}
		end,
	
	if Worker_id =:= 0 ->
			net_kernel:monitor_nodes(true),
		   	lib_map:load_map(MapId,self()),
			misc:write_monitor_pid(self(),mod_scene, {MapId, ?SCENE_WORKER_NUMBER}),

			erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player}),
			erlang:send_after(?DROP_ITEM_LOOP_TIME, self(), {event, drop_item_loop});
	   true -> 
		   	misc:write_monitor_pid(self(),mod_scene_worker, {MapId, Worker_id})
	end,
	
	Time = misc_timer:now_milseconds(),
	erlang:send_after(?LOOPTIME, self(), {loop,Time}), 

	State= #state{
				  only_id= MapId, 
				  map_id=TemplateId, 
				  worker_id = Worker_id, 
				  is_dup = IsDup},
	
	if
		%%帮派地图
		State#state.map_id =:= 1000 ->
			erlang:send_after(?Bonfire_Time_Tick, self(),{bonfire_time});
		true ->
			skip
	end,
	
	{ok, State}.
						

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Info,_From, State) ->
	try

		do_call(Info,_From, State)
		
%% 		timer_check(do_call, [Info, _From, State])

	catch
		_:Reason ->
			?WARNING_MSG("MapId:~w, mod_map handle_call is exception:~w~n,Info:~w",[State#state.map_id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	
%% 	timer_check(do_cast, [Info, State])
	catch
		_:Reason ->
			?WARNING_MSG("MapId:~w, mod_map handle_cast is exception:~w~n,Info:~w",[State#state.map_id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.
%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
	try
		do_info(Info, State)
		
%% 		timer_check(do_info, [Info, State])
	catch
		_:Reason ->
			?WARNING_MSG("MapId:~w, mod_map handle_info is exception:~w~n,Info:~w",[State#state.map_id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.
%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

timer_check(Method, Args) ->
	Start = misc_timer:now_milseconds(),
		
%% 	Reply = F(Info,_From, State),
	Reply = apply(mod_map, Method, Args),
		
	End = misc_timer:now_milseconds(),
		
	if Start + 1000 < End ->
			   ?WARNING_MSG("time:~w,handle_call:~p,",[End - Start, Args]);
		 true ->
			   skip
	end,
	Reply.

%% =========================================================================
%%% 业务逻辑处理函数
%% =========================================================================
		   

%% 动态加载某个场景
get_scene_pid(MapID) ->
	SceneProcessName = misc:create_process_name(scene_p,[MapID, 0]),
	case misc:whereis_name({global, SceneProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					{Pid,_WorkerPid} = start_mod_scene(MapID, SceneProcessName),
					Pid
			end;
		_ ->
			{Pid,_WorkerPid} = start_mod_scene(MapID, SceneProcessName),
			Pid
	end.

get_scene_pid(MapId, _OldScenePid, _PlayerPid) ->
	SceneProcessName = misc:create_process_name(scene_p,[MapId, 0]),
	{MapPid, Worker_Pid} =
		case misc:whereis_name({global, SceneProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						case lib_arena:is_arena_scene(MapId) of
							true ->
								{Pid, Pid};
							false ->
								{Pid, Pid}
						end;
					false -> 
						start_mod_scene(MapId, SceneProcessName)
				end;					
			_ ->
				start_mod_scene(MapId, SceneProcessName)
		end,
	{Worker_Pid, MapPid}.

%%启动场景模块 (加锁保证全局唯一)
start_mod_scene(MapId, SceneProcessName) ->
	global:set_lock({SceneProcessName, undefined}),	
	{MapPid, Worker_Pid} = 
		case misc:whereis_name({global, SceneProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						{Pid, Pid};
					false -> 
						NewScenePid = start_scene(MapId, SceneProcessName, 1),
						{NewScenePid, NewScenePid}
				end;
			_ ->
				NewMapPid = start_scene(MapId, SceneProcessName, 2),
				timer:sleep(500),
				{NewMapPid, NewMapPid}
		end,	
	global:del_lock({SceneProcessName, undefined}),
	{MapPid, Worker_Pid}.

%% 启动场景模块
start_scene(MapId, SceneProcessName, _Source) ->
	Pid =
		case mod_map:start({MapId, SceneProcessName, 0}) of
			{ok, NewMapPid} ->
				NewMapPid;
			_ ->
				undefined
		end,
	timer:sleep(500),
	Pid.

update_user_onmap(PidMap,UserOnMap) ->
	?PRINT("Update onmap ~p ~n",[UserOnMap]),
	try
		gen_server:cast(PidMap, {apply_cast, lib_map, update_map_user_dic, [UserOnMap]})
	catch
		_:Reason ->
			?ERROR_MSG("update_user_onmap is error:~p", [Reason]),
			fail
	end.

%%同步场景用户状态
update_player(Status) ->
	try  
		gen_server:cast(Status#ets_users.other_data#user_other.pid_map, 
						{apply_cast, lib_map, update_online_dic_not_skill, [Status]})
%% 		gen_server:cast(Status#ets_users.other_data#user_other.pid_map, 
%% 						{apply_cast, lib_map, update_online_dic, [Status]})
	catch
		_:Reason-> 
			?ERROR_MSG("update_player is error:~p", [Reason]),
			fail
	end.

%% 更新技能
update_player_skill(Status) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_map, 
						{apply_cast, lib_map, update_online_dic_skill, [Status]}).
%% 更新宠物技能
update_online_dic_pet_skill(Status) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_map, 
						{apply_cast, lib_map, update_online_dic_pet_skill, [Status]}).
	

%%更新玩家血魔
update_player_hp_mp(_Map_Id, Pid_Map, _Pid, UserId, Hp, Mp) ->
	%{Worker_Pid, _MapPid} = mod_map:get_scene_pid(Map_Id, Pid_Map, Pid),
	gen_server:cast(Pid_Map, {apply_cast, lib_map, update_player_hp_mp, [UserId, Hp, Mp]})	.
	


%% 更新玩家位置
update_player_pos(Status) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_map, 
					{apply_cast, lib_map, update_player_pos, [Status#ets_users.id,
															  Status#ets_users.pos_x, 
															  Status#ets_users.pos_y, 
															  Status#ets_users.other_data#user_other.index]}).

%% 更新玩家位置
update_player_team(Status) ->
	{Worker_Pid, _MapPid} = mod_map:get_scene_pid(Status#ets_users.current_map_id, 
															   Status#ets_users.other_data#user_other.pid_map, 
															   Status#ets_users.other_data#user_other.pid),
	gen_server:cast(Worker_Pid, {apply_cast, lib_map, update_player_team, [Status#ets_users.id, 
																			Status#ets_users.team_id,
																			Status#ets_users.other_data#user_other.pid_team]}).
 
%% 更新无敌时间
update_online_dic_invincible(Status, Date) ->
	gen_server:cast(Status#ets_users.other_data#user_other.pid_map, 
					{apply_cast, lib_map, update_online_dic_invincible, 
					 [Status, Date]})	.

%% %%同步场景中用户战斗信息
%% update_player_battle_object(Status) ->
%% 	gen_server:cast(Status#ets_users.other_data#user_other.pid_map,{update_player_battle_object,Status}).

%% 进入新地图
get_map_round_info(MapID, PlayerStatus, X, Y) ->
	case is_pid(PlayerStatus#ets_users.other_data#user_other.pid_map) of
		true ->
			Pid_Map = PlayerStatus#ets_users.other_data#user_other.pid_map;
		_er ->
			Pid_Map = get_scene_pid(MapID)
			
	end,
	gen_server:cast(Pid_Map,{get_map_round_info, X, Y, PlayerStatus, Pid_Map}).


%% %%用户进入场景
%% enter_map(Pid_map, Status) ->
%% 	gen_server:cast(Pid_map, {apply_cast, lib_map, enter_map, [Status]}).	

%%用户退出场景
leave_scene(PlayerId, PetId, MapId, Pid_map, X, Y, Pid, IDList) ->
	try  	
		gen_server:cast(Pid_map, 
				 {apply_cast, lib_map, leave_map, [PlayerId, PetId, MapId, X, Y, Pid, IDList]})
	catch
		_:Reason-> 
			?ERROR_MSG("leave_scene is error:~p", [Reason]),
			fail
	end.	


%% 在场景中， 获取一个掉落物
get_dropitem_in_map(Pid_Map,DropID,PlayerID,PosX,PosY,Pid_Team,Pid_Item,AllotMode,PidFlag) ->
	gen_server:cast(Pid_Map,{get_dropitem_in_map,DropID, PlayerID, PosX, PosY, Pid_Team, Pid_Item, AllotMode, PidFlag, Pid_Map}).

%% =========================================================================
%% Local functions
%% =========================================================================


%%---------------------do_call--------------------------------
%% 统一模块+过程调用(call)
do_call({apply_call, Module, Method, Args}, _From, State) ->
	Reply  = 
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_scene_apply_call error: Module=~p, Method=~p, Reason=~p",[Module, Method,Info]),
			 error;
		 DataRet -> 
			 DataRet
	end,
    {reply, Reply, State};
			
do_call({'total_player'}, _From, State) ->
	Num = length(lib_map:get_scene_user([])),
	{reply, Num, State};

%%返回地图中的总怪物数
do_call({total_monster}, _From, State) ->
	Num = lib_map:get_alive_monster_num(),
	{reply, Num, State};

do_call({get_monster_by_id, Monster_Id}, _, State) ->
	MonInfo = lib_map_monster:get_online_monster(Monster_Id),
	{reply, MonInfo, State};	

do_call(Info, _, State) ->
	?WARNING_MSG("mod_map call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------

%% 统一模块+过程调用(cast)
do_cast({apply_cast, Module, Method, Args}, State) ->
	case apply(Module, Method, Args) of
		 {'EXIT', Info} ->	
			 ?WARNING_MSG("mod_scene_apply_cast error: Module=~p, Method=~p, Args =~p, Reason=~p",[Module, Method, Args, Info]),
			 error;
		 _ -> ok
	end,
    {noreply, State};

do_cast({load_map}, State) ->
	lib_map:load_map(State#state.map_id,self()),
	erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player}),
	erlang:send_after(?DROP_ITEM_LOOP_TIME, self(), {event, drop_item_loop}),
	{noreply, State};

%% 创建副本怪物
do_cast({'create_duplicate_mon', MonList, Is_Dynamic, AverLevel, Min_Level, Is_First_Create}, State) ->
	case MonList of
		[] ->
			lib_map:load_duplicate_collect(State#state.map_id),
			{noreply, State};
		_ ->
			lib_map:load_duplicate_collect(State#state.map_id),
			lib_map:load_duplicate_map(State#state.only_id, MonList, Is_Dynamic, AverLevel, Min_Level, Is_First_Create, misc_timer:now_seconds()),
			{noreply, State}
	end;
%%刷新指定编号采集物
do_cast({create_collect, CollectId}, State) ->
	lib_map:load_collect(State#state.only_id, CollectId),
	{noreply, State};
%%刷新指定编号采集物在指点坐标上
do_cast({create_collect_pos, CollectId, PosList}, State) ->
	lib_map:load_collect(State#state.only_id, CollectId, PosList),
	{noreply, State};

%% 刷新指定编号怪物
do_cast({create_monster, MonsterId}, State) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info) ->
			{X,Y} = Info,
			lib_map:load_boss({MonsterId, State#state.only_id, X, Y, Now})
		end,
	case data_agent:monster_template_get(MonsterId) of
		[] ->
			ok;
		TempMon ->
			List = tool:split_string_to_intlist(TempMon#ets_monster_template.lbornl_points),
			lists:foreach(F, List)			
	end,
	{noreply, State};

%% 刷新王城守卫
do_cast({create_guard, GuardList}, State) ->
	Now = misc_timer:now_seconds(),
	F = fun({MonsterId,X,Y}) ->
		lib_map:load_boss({MonsterId, State#state.only_id, X, Y, Now})
	end,
	lists:foreach(F, GuardList),
	{noreply, State};

%%移除地图玩家
do_cast({remove_player},State) ->
	L = lib_map:get_online_dic(),
	F = fun(Info) ->
				gen_server:cast(Info#ets_users.other_data#user_other.pid,{player_break_away}),
%% 				lib_player:use_transfer_shoe(Info,1021,2540,3540),
				lib_map:delete_online_dic(Info#ets_users.id)
		end,
	lists:foreach(F, L),
	{noreply, State};

%% 刷新boss
do_cast({create_boss, MonsterId, X, Y, Type,Now}, State) ->
	case Type of
		0 ->%%野外boss
			lib_map:load_boss({MonsterId, State#state.only_id, X, Y,Now});
		1 ->%%世界boss
			case data_agent:map_template_get(State#state.map_id) of
				[] ->
					ok;
				TempMap ->
					case lib_map:get_mon_dic() of
						[] ->
							lib_map:load_boss({MonsterId, State#state.only_id, X, Y,Now}),
							gen_server:cast(mod_boss_manage:get_boss_manage_pid(), {boss_relive, MonsterId}),
							case data_agent:monster_template_get(MonsterId) of
								[] ->
									ok;
								TempMonster ->									
									ChatStr = ?GET_TRAN(?_LANG_NOTICE_RELIVE_BOSS, [TempMonster#ets_monster_template.name, TempMap#ets_map_template.name]),									
									lib_chat:chat_sysmsg_roll([ChatStr])
							end;
						_L ->
							%%?DEBUG("create_boss:~p",[_L]),
							ok
					end				
			end;
		_ ->
			ok
	end,
	{noreply, State};

%% 创建打钱副本怪物
do_cast({'create_money_duplicate_mon', MonList, Is_Dynamic, AverLevel, Min_Level, Is_First_Create}, State) ->
	case MonList of
		[] ->
			{noreply, State};
		_ ->
			put(?DIC_MAP_DROP, []), %%清除掉落的物品并且通知用户
			List = lib_map:get_online_dic(),
			{ok, BinData} = pt_12:write(?PP_CLEAR_DROPITEM_ALL, 0),
			F = fun(Info) ->
					   lib_send:send_to_sid(Info#ets_users.other_data#user_other.pid_send, BinData)
			   end,
		    lists:foreach(F, List),
			lib_map:load_duplicate_map(State#state.only_id, MonList, Is_Dynamic, AverLevel, Min_Level, Is_First_Create, misc_timer:now_seconds()),
			{noreply, State}
	end;
do_cast({'clear_monster_all'}, State) ->
	put(?DIC_MAP_MON, []),
	{noreply, State};
%%给怪物或塔防对象增加buff
do_cast({'add_monster_buff', Type, BuffID, MonsterID}, State) ->
	if
		Type < ?Tower_Target_Mon ->
			MonsterList = lib_map:get_mon_dic();
		true ->
			MonsterList = lib_map:get_tower_mon_dic()
	end,
	F = fun(MonInfo, MList) ->
			if
				(MonsterID =:= 0 orelse MonInfo#r_mon_info.template_id =:= MonsterID )andalso MonInfo#r_mon_info.hp > 0 ->
					BuffInfo = data_agent:get_buff_from_template(BuffID),					
					{BL,NBL,RBL} = lib_buff:add_buff_new(MonInfo#r_mon_info.battle_info#battle_info.id, [BuffInfo], MonInfo#r_mon_info.buff_list),
					NDMBattleInfo = MonInfo#r_mon_info.battle_info#battle_info{new_buff_list=NBL},
					NewMonInfo = MonInfo#r_mon_info{buff_list = BL, battle_info = NDMBattleInfo},
					[NewMonInfo|MList];
				true ->
					[MonInfo|MList]
			end
		end,
	NewMonsterList = lists:foldl(F, [], MonsterList),
	if
		Type < ?Tower_Target_Mon ->
			lib_map:update_all_mon_dic(NewMonsterList);
		true ->
			lib_map:update_all_tower_mon_dic(NewMonsterList)
	end,
	{noreply, State};


do_cast({'drop_money', DropNum, Money}, State) ->
	case DropNum of
		0 ->
			{noreply, State};
		_ ->
			case lib_map:get_online_dic() of
				[] ->
					ok;
				[U|_] ->
					lib_map:award_with_drop(DropNum, Money, U#ets_users.current_map_id, U#ets_users.id, U#ets_users.pos_x, U#ets_users.pos_y,
							 U#ets_users.other_data#user_other.pid_send)
			end,				
			{noreply, State}
	end;

%% 检查创建分批怪物
do_cast({'create_mon_in_turn', Duplicate_Pid}, State) ->
	case lib_map:get_scene_mon(State#state.only_id) of
		[] ->		
			gen_server:cast(Duplicate_Pid, {'create_mon_in_turn'}),
			{noreply, State};
		_List ->
			{noreply, State}
	end; 


%%战斗第一步
do_cast({battle_start,[ActorID,TargetID,SkillData,SkillList,X,Y,TargetType,ActorType]}, State) ->
	lib_battle:battle_start(ActorID,
							TargetID,
							SkillData,
							SkillList,
							X,
							Y,
							TargetType,
							ActorType),
	{noreply, State};

%%战斗打断
do_cast({battle_cancel_perpare,ActorID, ActorType}, State) ->
	lib_battle:battle_cancel_perpare(ActorID, ActorType),
	{noreply, State};

do_cast({'collect', CollectId,TemplateId,PlayerPid}, State) ->
	lib_map_collect:collect(CollectId,TemplateId, PlayerPid),
	{noreply, State};

%%切换地图时添加战斗字典信息
do_cast({change_map_add,BattleState}, State) ->
	lib_map:update_battle_object_dic_player(BattleState),
	{noreply,State};

%%更新玩家的战斗对象信息
%% do_cast({update_player_battle_object,Status}, State) ->
%% 	lib_map:update_player_battle_object(Status),
%% 	{noreply,State};

%------------------------拾取-----------------------------------
do_cast({get_dropitem_in_map,DropID, PlayerID, PosX, PosY, Pid_Team, Pid_Item, AllotMode, PidFlag, Pid_Map}, State) ->
	case lists:keyfind(DropID, #r_drop_item.id, lib_map:get_drop_dic()) of
		false ->
			{noreply, State};
	DropItem ->
		{ok, BinData} = pt_23:write(?PP_TARGET_DROPITEM_REMOVE, DropItem),
		mod_map_agent:send_to_area_scene(DropItem#r_drop_item.map_id,
 										 DropItem#r_drop_item.x,
 										 DropItem#r_drop_item.y,
 										 BinData),
		if 
			DropItem#r_drop_item.item_template_id < 1000 ->%%在打钱副本中拾取钱币不需要加入包裹中
				gen_server:cast(State#state.dup_pid, {'get_drop_money', DropItem#r_drop_item.item_template_id, DropItem#r_drop_item.amount}),				
				lib_map:delete_drop_dic(DropItem#r_drop_item.id);
			true ->
				lib_map:get_drop(DropID, PlayerID, PosX, PosY, Pid_Team, Pid_Item, AllotMode, PidFlag, Pid_Map)
		end,
		{noreply,State}
	end;

do_cast({get_item_result,Result,DropID}, State) ->
	case Result of
		true ->
			lib_map:delete_drop_dic(DropID);
		_ ->
			case lists:keyfind(DropID, #r_drop_item.id, lib_map:get_drop_dic()) of
				false ->
					skip;
				DropItem ->
					%% 捡物品失败，重新出现在地上
					lib_map:update_drop_dic(DropItem#r_drop_item{work_lock = false}),
					{ok, BinData} = pt_23:write(?PP_TARGET_DROPITEM_ADD,[new, [DropItem]]),
					mod_map_agent:send_to_area_scene(DropItem#r_drop_item.map_id,
 										 DropItem#r_drop_item.x,
 										 DropItem#r_drop_item.y,
 										 BinData)
			end
	end,
	{noreply,State};

do_cast({hartedremove,IDList,TargetPid},State) -> %%目标通知怪物删除仇恨列表内容
	lib_map_monster:harted_list_remove_by_target(IDList,TargetPid),
	{noreply, State};

%-------------------------组队------------------------------------------
% 获取没队伍的玩家信息
do_cast({get_scene_user_with_no_team, TeamList, UserID, _TeamID, _MapID, PidSend}, State) ->
	lib_map:get_scene_user_with_no_team(TeamList, UserID, PidSend),
	%FreeUserL = lib_map:get_scene_user_with_no_team(UserID),
	%gen_server:cast(TeamAgentPid,{get_notfull_and_no_team, FreeUserL, TeamID, MapID, PidSend}),
	{noreply, State};
	
%-------------------------地图场景----------------------------------------
do_cast({get_map_round_info, X, Y, PlayerStatus, Pid_Map}, State) ->
	Other = PlayerStatus#ets_users.other_data#user_other{pid_map=Pid_Map,
														 pid_locked_monster=[],
														 pid_locked_target_monster=[]},
	NewStatus = PlayerStatus#ets_users{other_data=Other},
	
	Slice9 = lib_map:get_9_slice(X,Y),
	
%% 	lib_map:update_player_battle_object(PlayerStatus), %战斗对象添加到地图
	[SceneMon,SceneCollect,_SceneNpc, SceneDrop] =
		case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
			?DUPLICATE_TYPE_PASS ->
				lib_map:get_scene_info(X,Y);
			_ ->
				lib_map:get_scene_info_in_slice(X,Y)
		end,
	%怪物
	{ok, MonBin} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, SceneMon),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, MonBin),
	%采集
	{ok, CollectBin} = pt_12:write(?PP_MAP_COLLECT_UPDATE, SceneCollect),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, CollectBin),
	%掉落
	{ok, DropBin} = pt_23:write(?PP_TARGET_DROPITEM_ADD,[new,SceneDrop]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, DropBin),
	
	SceneUser = lib_map:get_online_dic(),
	F = fun(User, Acc) ->
				InSlice = lib_map:is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, Slice9),
				if InSlice =:= true andalso User#ets_users.id =/= PlayerStatus#ets_users.id ->
						[User|Acc];
					true ->
						Acc
				end
		end,
	
	OtherUser = lists:foldl(F, [], SceneUser),
	if length(SceneUser) > 0 ->
		{ok, UserData} = pt_12:write(?PP_MAP_USER_ADD, OtherUser),
		lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, UserData);
	   true ->
		   skip
	end,
	
	F1 = fun(User) ->
				 if 
					 User#ets_users.other_data#user_other.sit_state > 1 ->
						 {ok, BinData} = pt_12:write(?PP_SIT_INVITE_REPLY, [1, User#ets_users.id, 
																			User#ets_users.other_data#user_other.double_sit_id]),
						 lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData);
					 true ->
						 skip
				 end
		 end,
	%进入的时候把他人发送给自己。	
	lists:foreach(F1, SceneUser),
	%%进入场景广播给其他玩家 
	lib_map:enter_map(NewStatus),
	%%cast到人物进程让人物修改pid_map等
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid,{get_map_round_info,Pid_Map}),
	{noreply, State};
	
%% 副本pid
do_cast({'set_dup_pid', DupPid}, State) ->
    put(?DUPLICATE_PID_DIC, DupPid),
	NewState = State#state{
						   dup_pid = DupPid
						   },
	{noreply, NewState};

%%目前关卡使用，全部怪物都杀光才算进入下一层
do_cast({can_pass_mission}, State) ->
	if 
		State#state.is_dup =:= 1 andalso is_pid(State#state.dup_pid) ->
			case lib_map:is_monster_all_dead() of 
				true ->
					gen_server:cast(State#state.dup_pid,{add_pass_mission_award});
				_er ->
					ok
			end;
		true ->
			ok
	end,
	{noreply, State};
%%删除怪物%%不使用
do_cast({remove_active_refresh_monster, MList, CList}, State) ->
	lists:foreach(fun lib_map:delete_mon_dic_by_template_id/1, MList),
	{ok, StandBin} = pt_12:write(?PP_MAP_MONSTER_REMOVE, MList),
	mod_map_agent:send_to_scene(State#state.map_id,StandBin),
	if CList =/= [] ->
		DList = lists:foldl(fun lib_map:delete_collect_dic_by_template_id/2, [], CList),
		F = fun(Info, BinData) ->
				<<BinData/binary,(Info#r_collect_info.id):32,0:8>>
			end,
		Bin = lists:foldl(F, <<>>, DList),
		N = length(DList),
		Bin1 = pt:pack(?PP_MAP_COLLECT_UPDATE, <<N:16, Bin/binary>>),
		mod_map_agent:send_to_scene(State#state.map_id,Bin1);
	true ->
		spik
	end,
	{noreply, State};

do_cast({monster_dead}, State) ->
	NewState = State#state{kill_monster_num = State#state.kill_monster_num + 1},
	{noreply, NewState};
do_cast({check_tower_boss_dead}, State) ->
	lib_map:check_tower_boss_dead(),
	{noreply, State};
do_cast({close_duplicate_map}, State) ->
	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast({get_mon_num}, State) ->
	L = lib_map:get_mon_dic(),
	?DEBUG("mon_info:~p",[L]),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_map cast is not match:~w",[Info]),
    {noreply, State}.



%%---------------------do_info--------------------------------
%% 处理节点关闭事件
do_info({nodedown, Node}, State) ->
	try
		if State#state.worker_id =:= 0 ->
				MapId = State#state.map_id,
				lists:foreach(fun(T) ->
									  if T#ets_users.other_data#user_other.node =:= Node, T#ets_users.current_map_id =:= MapId ->
%% 										   ets:delete(?ETS_ONLINE_SCENE, T#ets_users.id),
										   lib_map:delete_online_dic(T#ets_users.id),
										   {ok, BinData} = pt_12:write(?PP_MAP_USER_REMOVE, [{T#ets_users.id, T#ets_users.other_data#user_other.pet_id}]),
										   lib_send:send_to_local_scene(MapId, BinData);
										 true ->
											 no_action
									  end 
							  end,
%% 							  ets:tab2list(?ETS_ONLINE_SCENE));
							  lib_map:get_online_dic());
	   		true -> no_action
		end
	catch 
		_:Reason -> 
			?ERROR_MSG("nodedown is : ~p", [Reason]),
			error
	end,
    {noreply, State};

do_info({loop, Time}, State) ->
	
	NT = Time + ?LOOPTIME,
	put(?DIC_MAP_LOOPTIME, NT),
	erlang:send_after(?LOOPTIME, self(), {loop,NT}),
	Now = misc_timer:now_milseconds(),
	lib_map_monster:monster_loop(Now, State#state.is_dup, State#state.only_id),
	

%%  	if State#state.is_dup =:= 1 ->
%%  		   lib_map_monster:tower_monster_loop(Time);	%%只有副本有守塔怪
%%  	   true ->
%%  		   ok
%%  	end,
	
	lib_map_collect:loop(),

	{noreply, State};

%%帮派地图篝火处理
do_info({bonfire_time}, State) ->
	erlang:send_after(?Bonfire_Time_Tick, self(),{bonfire_time}),
	NowSecond = util:get_today_current_second(),
	MinSecond = 18 * 60 * 60 ,
	MaxSecond = 19 * 60 * 60 ,
	if
		NowSecond >= MinSecond andalso NowSecond =< MaxSecond ->
			X1 = 1019,
			Y1 = 704,
			X2 = 2071,
			Y2 = 1227,
			
			case lib_map:get_scene_user_in_slice({X1, Y1, X2, Y2}) of
				[] ->
					skip;
				GuildUser ->
					lib_map:guild_bonfire(GuildUser)
			end;
		
		true ->
			skip
	end,
	
	{noreply, State};
	

do_info({event, clear_online_player}, State) ->
	erlang:send_after(?CLEAR_ONLINE_PLAYER, self(), {event, clear_online_player}),
	L = lib_map:get_online_dic(),	
	Now = misc_timer:now_seconds(),
	DisTime = 11 * 60,
	F = fun(Info) ->
				if Now > Info#ets_users.other_data#user_other.map_last_time + DisTime ->
%%  					   lib_map:delete_battle_content_dic_player(Info#ets_users.id),
%% 					   lib_map:delete_battle_object_dic_player(Info#ets_users.id),
 					   lib_map:delete_online_dic(Info#ets_users.id);
				   true ->
					   skip
				end
		end,
	lists:foreach(F, L),
	case State#state.is_dup of
		0 ->
			lib_statistics:add_map_player(State#state.map_id, length(lib_map:get_scene_user([])));
		1 ->
			skip
	end,
	{noreply, State};

do_info({event, drop_item_loop}, State) ->
	erlang:send_after(?DROP_ITEM_LOOP_TIME, self(), {event, drop_item_loop}),
	lib_map:drop_loop_event(State#state.map_id),	
	{noreply, State};

%% 战斗第二步
do_info({battle_second,[ActorID,ActorType,TargetID,TargetType,X,Y,SkillData,StartTime]}, State) ->
	lib_battle:battle_second(ActorID,ActorType,TargetID,TargetType,X,Y,SkillData,StartTime),
	{noreply, State};

%% 起身
do_info({standup, ID, Pid}, State) ->
	case lib_battle:standup(ID, Pid) of
		{ok, NewPlayer} ->
			lib_map:update_online_dic(NewPlayer),
			{ok, StandBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayer]),
			mod_map_agent:send_to_area_scene(NewPlayer#ets_users.current_map_id,
												NewPlayer#ets_users.pos_x,
												NewPlayer#ets_users.pos_y,
												StandBin),
			gen_server:cast(Pid,{standup}),
			erlang:send_after(?INVICIBLE_TIME, self(), {common_fight, ID, Pid});	%% 1.5秒无敌
		_ ->
			ok
	end,
	{noreply, State};

%% 无敌状态转回正常状态
do_info({common_fight, ID, Pid}, State) ->
	case lib_battle:common_fight(ID) of
		{ok, NewPlayer} ->
			lib_map:update_online_dic(NewPlayer),
			{ok, CommonBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayer]),
			mod_map_agent:send_to_area_scene(NewPlayer#ets_users.current_map_id,
												NewPlayer#ets_users.pos_x,
												NewPlayer#ets_users.pos_y,
												CommonBin),
			gen_server:cast(Pid,{common_fight});
		_ ->
			ok
	end,
	{noreply, State};

%%怪物死亡后调用，不然客户端会出现假怪
do_info({delete_mon_dic,Id}, State) ->
	lib_map:delete_mon_dic(Id),
    {noreply, State};

%%帮会突袭活动结束发送宝箱
do_info({raid_active_award}, State) ->
	lib_map:raid_active_award(State#state.only_id,State#state.kill_monster_num div 10),
	NewState = State#state{kill_monster_num = 0},
	{noreply, NewState};


%% 处理节点开启事件
do_info({nodeup, _Node}, State) ->
	{noreply, State};

do_info(Info, State) ->
	?WARNING_MSG("mod_map info is not match:~w",[Info]),
    {noreply, State}.

