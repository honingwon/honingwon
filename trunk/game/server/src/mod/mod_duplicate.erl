%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%

%%% Created : 2011-5-3
%%% -------------------------------------------------------------------
-module(mod_duplicate).


-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").

-define(Scan_Time_Tick, (1 * 1000)).
-define(DELAY_SHUT_DOWN_TIME_TICK, 180000).%%延迟关闭副本
-define(DORP_MONEY_DELAY_TICK, 5000).
-define(MONEY_DUPLICATE_PICKUP_TIME, 50).%%经济副本掉落铜币后拾取时间
-define(BATTER_TIME_TICK, 12). %%连击持续时间

-define(PASS_MISSION_TYPE, 1). %%杀死指定怪物

-define(DUPLICATE_STATUS_BATTLE, 1). %%副本战斗中
-define(DUPLICATE_STATUS_PICKUP, 2). %%副本拾取中
-define(DUPLICATE_STATUS_RAND_MONEY, 22). %%副本摇奖
-define(MONEY_DUPLICATE_RAND_TIME, 5).%%经济副本摇奖时间

-define(BUFF_CAST_TARGET_MONSTER, 1). %%给怪物施放buff
-define(BUFF_CAST_TARGET_PLAYER, 0).	%%给玩家释放buff
-define(TIME_LIMIT_OUT , 3600).	%%玩家在乱斗副本中停留时间为1小时
-define(LOOP_BOSS_TIME , 60*1000).	%%乱斗副本30秒一次来定时刷出boss
%% --------------------------------------------------------------------
%% External exports
-export([
		 start/7,
		 enter_mult_duplicate/1,
		 summon_monster_by_num/3
		]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(dup_user_info, {
				user_id = 0,
				name = " ",
				vipLevel = 0,	%%vip等级
				sex = 0,		%%性别
				pid_user,
				pid_send,
				batter_num = 0, %%连击数
				max_batter_num = 0, %%最大连接数
				batter_time = 0,%%连击时间	
				status = 0,		%% 0 在线，1离线
				shop_item_list = {0,[]},%%副本商店可购物品列表	
				mission_index = 1,%%玩家当前所在关卡层数
				enter_time = 0,		%% 玩家进入副本时间	
				award_list = []
				}).		
-record(state, {
				duplicate_id = 0,		%% 副本ID
				map_id = 0,				%% 地图id
				map_list = [],			%% 地图相关信息列表
				%map_only_id = 0,		%% 地图唯一id
				create_mon_times = 0,   %% 分批怪物次数				
				duplicate_type = 0,     %% 副本类型
				start_time = 0,         %% 副本开始时间
				aver_level = 0,         %% 队伍平均等级
 				%map_pid = undefined,	%% 地图进程
				team_pid = undefined,	%% 队伍进程
				status = 1,				%% 副本当前状态（1战斗中，22打钱摇奖倒计时,2暂停战斗，拾取物品，3守塔副本使用，表示可以被提前开启）
				pass_status = 0,		%% 过关状态（0未过关，1过关如果是最后一个关卡则通知副本结束）
				current_mission_start_time = 0,%%当前关卡开启时间
				nextmontime = 0,        %% 守塔副本下一批怪的时间
				totalmisson = 0,        %% 守塔副本的怪物总批数
				current_mission_award = [],%% 当前关卡奖励
				current_mission_pass_info = [],%%关卡通关条件[{}]
				current_mission_kill_award = [], %%杀怪奖励
				current_mission_dead_buff = [],%%怪物死亡触发buff{ets_monster_dead_buff:monsterID,buffID,targetType,root/10000}
				current_mission_dead_summon = [],%%怪物死亡召唤怪物{ets_monster_dead_summon:monsterID,deadNum,targetID,targetNum}
				current_mission_dead_boss = [],%%Boss死亡触发buff{ets_monster_dead_boss:monsterID,buffID,targetID}
				current_mission_collect_buff = [],%%采集物品触发buff{ets_collect_buff:collectID,havingBuff,addBuff}
				current_mission_dead_loop_summon = [],%%怪物死亡触发循环召唤{ets_monster_dead_loop_summon:monsterID,deadNum,targetID,targetNum}
				current_mission_pass_event = [],%%试炼副本通关{ets_mission_pass_event:Type,MonsterId}(Type目前只有1召唤怪物)
				current_mission_dead_num = 0,%%计算怪物死亡数量，主要用于召唤
				current_mission_stone_dead_num = 0,%%计算石头类怪物死亡数量用于召唤
				current_mission_boss = [], %% 召唤，击杀boss发送世界公告{ets_monster_boss:monsterID}
				current_mission_time_boss = [], %% 定时刷新boss {ets_monster_time_boss: monsterId, time}
				pass_mission_use_time = 0,	%%通关使用时间（在试炼副本中使用）
				top_name,				%% 排行榜玩家名称
				top_id_list = [],		%% 排行榜玩家编号list验证玩家重复进榜
				user_list = [],			%% 玩家列表
				dead_monster_list = [], %% 杀死怪物列表
				relive_boss_list = []	%% 存活的boss列表
				}).

%% ====================================================================
%% External functions
%% ====================================================================
start(Pid_team, _UserId, MapId, UserList, DuplicateId, MissionId, AverLevel) ->
	{ok, Dup_pid} = gen_server:start(?MODULE, [Pid_team, MapId, UserList, DuplicateId, MissionId, AverLevel], []),
	{ok, Dup_pid}.

%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([Pid_team, MapId, User, DuplicateId, MissionId, AverLevel]) ->
	try 
		do_init([Pid_team, MapId, User, DuplicateId, MissionId, AverLevel])	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create duplicate is error."}
	end.

do_init([Pid_team, MapId, User, DuplicateId,MissionId, AverLevel]) ->
	ProcessName = misc:create_process_name(duplicate_p, [MapId, 0]),
	misc:register(global, ProcessName, self()),

	DuplicateTemplate = data_agent:duplicate_template_get(DuplicateId),
	DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
	Duplicate_Type = DuplicateTemplate#ets_duplicate_template.type,
    Now = misc_timer:now_seconds(),
	{UserId, Name, Pid, PidSend, VipLevel,Sex} = User,
	UserInfo1 = #dup_user_info{user_id = UserId, name = Name, pid_user = Pid , pid_send = PidSend, vipLevel = VipLevel, sex = Sex, mission_index = MissionId},
	if Duplicate_Type =:= ?DUPLICATE_TYPE_FIGHT ->
		UserInfo = UserInfo1#dup_user_info{enter_time = Now},
		erlang:send_after(?LOOP_BOSS_TIME, self(), {'relive_boss'});
	true ->
		UserInfo = UserInfo1
	end,
	{TopName,TopIdList} = get_top_name("",[],UserInfo),
	State = #state{
				   duplicate_id = DuplicateId,
				   map_id = MapId,
				   create_mon_times = MissionId,
				   duplicate_type = Duplicate_Type,
				   start_time = Now,
				   aver_level = AverLevel,
				   team_pid = Pid_team,
				   totalmisson = erlang:length(DuplicateMission),
				   current_mission_award = [],
				   top_name = TopName,
				   top_id_list = TopIdList,
				   user_list = [UserInfo]
				   },
	
	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),	
	
	if DuplicateTemplate#ets_duplicate_template.total_time =:= 0 orelse Duplicate_Type =:= ?DUPLICATE_TYPE_FIGHT ->
			skip;
		true ->
			erlang:send_after(DuplicateTemplate#ets_duplicate_template.total_time * 1000, self(), {'count_down', MapId})
	end,
	misc:write_monitor_pid(self(),?MODULE, {State}),
    {ok, State}.

get_mod_mult_duplicate_pid(DuplicateId) ->
	ProcessName = misc:create_process_name(duplicate_p, [DuplicateId, 0]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					Pid;
				false ->
					false
			end;
		_ ->
			false
	end.	

%%动态加载处理进程 
get_mod_mult_duplicate_pid(_UserId, MapId, UserList, DuplicateId, MissionId, AverLevel) ->
	ProcessName = misc:create_process_name(duplicate_p, [MapId, 0]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true ->
					{true, Pid};
				false ->
					start_mod_mult_duplicate(ProcessName, [_UserId, MapId, UserList, DuplicateId, MissionId, AverLevel])
			end;
		_ ->
			start_mod_mult_duplicate(ProcessName, [_UserId, MapId, UserList, DuplicateId, MissionId, AverLevel])
	end.

%%启动监控模块
start_mod_mult_duplicate(ProcessName, [_UserId, MapId, UserList, DuplicateId, MissionId, AverLevel]) ->
	global:set_lock({ProcessName, undefined}),
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true ->
						{true, Pid};
					false ->
						start(undefined, _UserId, MapId, UserList, DuplicateId, MissionId, AverLevel)
				end;
			_ ->
				start(undefined, _UserId, MapId, UserList, DuplicateId, MissionId, AverLevel)
		end,
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

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
handle_call(Info, _From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_duplicate handle_call is exception:~w~n,Info:~w,~nDuplicateId:~p",[Reason, Info, State#state.duplicate_id]),
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
	catch
		_:Reason ->
			?WARNING_MSG("mod_duplicate handle_cast is exception:~w~n,Info:~w,~nDuplicateId:~w",[Reason, Info, State#state.duplicate_id]),
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
	catch
		_:Reason ->
			?WARNING_MSG("mod_duplicate handle_info is exception:~w~n,Info:~w,~n DuplicateId:~p",[Reason, Info, State#state.duplicate_id]),
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

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

enter_mult_duplicate([UserId, MapId, UserList, DuplicateId, MissionId, AverLevel]) ->
	case get_mod_mult_duplicate_pid(UserId, MapId, UserList, DuplicateId, MissionId, AverLevel) of
		{true, Pid} ->
			{UserId, PlayerName, PlayerPid, PidSend, VipLevel,Sex} = UserList,
			gen_server:cast(Pid, {'join', {UserId,PlayerName,PlayerPid,PidSend,VipLevel,Sex}}),
			{true, Pid};
		{ok, Pid}->
			{ok, Pid};
		_ ->
			skip
	end.
 

%%---------------------do_call--------------------------------
%% 进入副本
do_call({'enter'}, _, State) ->
	case State#state.map_list =:= [] of
		true ->
			{Map_pid, UniqueId, NewState} = create_duplicate_map(State),
			if
				NewState#state.duplicate_type =:= ?DUPLICATE_TYPE_GUARD ->
					
					%%Now = misc_timer:now_seconds(),
					UserInfo = lists:nth(1, NewState#state.user_list),
					PidSend = UserInfo#dup_user_info.pid_send,
					{ok, Bin} = pt_12:write(?PP_NEXT_MON_TIME, [NewState#state.create_mon_times,
																NewState#state.totalmisson,
																NewState#state.nextmontime]),
					lib_send:send_to_sid(PidSend, Bin);
				true ->
					skip 
			end,
					
			{reply, {ok, Map_pid, UniqueId, State#state.map_id}, NewState};
		_ ->
			case lists:keyfind(State#state.map_id, 1, State#state.map_list) of
				false ->
					?DEBUG("error enter:~p",[{State#state.map_id,State#state.map_list}]),
					{reply, {false}, State};
				{_,OnlyId,Pid} ->
					{reply, {ok, Pid, OnlyId, State#state.map_id}, State}
			end			
	end;
%% 爬塔副本进入下层
do_call({'enter_next', Map_id, User_id}, _, State) ->
	case lists:keyfind(User_id, #dup_user_info.user_id, State#state.user_list) of
		false ->
			?WARNING_MSG("user is not in duplicate:~p",[User_id]),
			{reply,{error, "user is not in duplicate!"}, State};
		UserInfo ->
			if
				UserInfo#dup_user_info.mission_index =:= State#state.create_mon_times andalso State#state.pass_status =/= 1 ->
					?WARNING_MSG("mission is not pass:~p",[{UserInfo#dup_user_info.mission_index,
																State#state.pass_status,Map_id}]),
					{reply,{error, "mission is not pass!"}, State};
				UserInfo#dup_user_info.mission_index =:= State#state.create_mon_times
				andalso (State#state.current_mission_award =:= [] orelse State#state.current_mission_award =:= [{0}]) andalso State#state.pass_status =:= 1 ->
					DuplicateTemplate = data_agent:duplicate_template_get(State#state.duplicate_id),	
					DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
					MissionTempate = lists:nth(State#state.create_mon_times, DuplicateMission),	
					Next_Index = Map_id - MissionTempate#ets_duplicate_mission_template.map_id,
					if Next_Index >= 1 ->
							NewUserInfo = UserInfo#dup_user_info{mission_index = UserInfo#dup_user_info.mission_index + Next_Index},
							NewUserList = lists:keyreplace(User_id, #dup_user_info.user_id, State#state.user_list, NewUserInfo),
							NewMapList = clear_duplicate_map(UserInfo#dup_user_info.mission_index,Map_id,NewUserList,State#state.map_list),
					
							NewState1 = State#state{map_id = Map_id, create_mon_times = State#state.create_mon_times + Next_Index, pass_status = 0,
											map_list = NewMapList, user_list = NewUserList},
							{Map_pid, UniqueId, NewState} = create_duplicate_next_map(NewState1),
							update_duplicate_target(NewState),%%更新爬塔目标
							{reply, {ok, Map_pid, UniqueId}, NewState};
						true ->
							{reply,{error, "error map id!"}, State}
					end;
				UserInfo#dup_user_info.mission_index < State#state.create_mon_times ->%如果玩家不是在最高层，需要处理移动到下一层并清除map
					case lists:keyfind(Map_id, 1, State#state.map_list) of
						false ->
							?WARNING_MSG("enter next map error:~p",[{Map_id,UserInfo}]),
							{reply,{error, "enter next map error!"}, State};
						{_,OnlyId,Pid} ->
							NewUserInfo = UserInfo#dup_user_info{mission_index = UserInfo#dup_user_info.mission_index + 1},
							NewUserList = lists:keyreplace(User_id, #dup_user_info.user_id, State#state.user_list, NewUserInfo),
							NewMapList = clear_duplicate_map(UserInfo#dup_user_info.mission_index,Map_id,NewUserList,State#state.map_list),
							NewState = State#state{map_list = NewMapList, user_list = NewUserList},
							{reply, {ok, Pid, OnlyId}, NewState}
					end;
				true ->
					?WARNING_MSG("mission award is not send:~p",[{State#state.pass_status,State#state.current_mission_award,UserInfo#dup_user_info.mission_index,
																State#state.create_mon_times,Map_id}]),
					{reply,{error, "mission award is not send!"}, State}
			end
	end;

%% 用户登录直接进入副本
do_call({'login_in_duplicate', {UserId, UserPid, SendPid, VipLevel, Sex}},  _, State) ->
	case lists:keyfind(UserId, #dup_user_info.user_id, State#state.user_list) of
		false ->
			{reply, {false}, State};
		UserInfo ->
			NewUserInfo = UserInfo#dup_user_info{status = 0, enter_time = UserInfo#dup_user_info.enter_time, mission_index = State#state.create_mon_times, pid_send = SendPid, pid_user = UserPid, vipLevel = VipLevel, sex = Sex},	
			List = lists:keydelete(UserId, #dup_user_info.user_id, State#state.user_list),
			NewUserList = [NewUserInfo|List],
			NewState = State#state{user_list = NewUserList},
			%?DEBUG("login_in_duplicate_1:~p",[NewState]),
			case lists:keyfind(NewState#state.map_id, 1, NewState#state.map_list) of
				fasle ->
					?DEBUG("login_in_duplicate_2:~p",[{NewState#state.duplicate_id,UserId,NewState#state.map_id}]),
					{reply, {false}, NewState};	
				{MapId,OnlyId,Pid} ->
					{reply, {Pid, OnlyId,NewState#state.duplicate_id, MapId}, NewState}	
			end
	end;
%% 检查商店物品是否足够
do_call({'check_item_num', Id, ShopItemID, Count}, _, State) ->
	{_,ShopItemList} = cheack_item_num1(State#state.user_list, Id), 
	Res = cheack_item_num(ShopItemList,ShopItemID,Count),
	{reply, Res, State};
%% 获取玩家奖励信息
do_call({'get_award_list', UserId}, _, State) ->
	case get_user_info(State#state.user_list,UserId) of
		[] ->
			{reply, {State#state.create_mon_times,[]}, State};
		UserInfo ->
			if
				State#state.duplicate_id =/= ?DUPLICATE_MONEY_MAP_ID orelse State#state.status =:= ?DUPLICATE_STATUS_PICKUP ->
					KillBossNum = State#state.create_mon_times;
				true ->
					KillBossNum = State#state.create_mon_times - 1
			end,
			{reply, {KillBossNum,UserInfo#dup_user_info.award_list}, State}
	end;
	
%% 获取副本类型
do_call({get_duplicate_type}, _, State) ->
	{reply, State#state.duplicate_type, State};

do_call(Info, _, State) ->
	?WARNING_MSG("mod_duplicate call is not match:~w",[Info]),
    {reply, ok, State}.


cheack_item_num([],_ShopItemID,_Count) ->
	false;
cheack_item_num([Item|L],ShopItemID,Count) ->
	{ID,Num} = Item,
	if
		ID =:= ShopItemID andalso Num >= Count ->
			true;
		true ->
			cheack_item_num(L,ShopItemID,Count)
	end.
cheack_item_num1([], _ID) ->
	[];
cheack_item_num1([Info|L], ID) ->
	if
		Info#dup_user_info.user_id =:= ID ->
			Info#dup_user_info.shop_item_list;
		true ->
			cheack_item_num1(L, ID)
	end.

%%---------------------do_cast--------------------------------
%% 离开副本
do_cast({'dup_quit', UserId}, State) ->
	NewState = 
		case lists:keyfind(UserId, #dup_user_info.user_id, State#state.user_list) of
			false ->
				State;
			Info ->
				gen_server:cast(Info#dup_user_info.pid_user, {'add_duplicate_award',Info#dup_user_info.award_list}),
				if
					State#state.duplicate_type =/= ?DUPLICATE_TYPE_TREASURE andalso State#state.duplicate_type =/= ?DUPLICATE_TYPE_CHALLENGE
					andalso	State#state.duplicate_type =/= ?DUPLICATE_TYPE_FIGHT ->
						gen_server:cast(Info#dup_user_info.pid_user, {'quit_duplicate_lottery', State#state.duplicate_id});
					true ->
						ok
				end,
				NewList = lists:keydelete(UserId, #dup_user_info.user_id, State#state.user_list),
				State#state{user_list=NewList}
		end,
	
	if
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_GUARD andalso State#state.pass_status =:= 0
				andalso length(State#state.user_list) =:= 1 ->
			update_duplicate_top(State);
		true ->
			ok
	end,
	case misc:is_process_alive(State#state.team_pid) of
		true ->
			case NewState#state.user_list =/= [] of
				true ->
					{noreply, NewState};
				_ ->
					lib_duplicate:clear_duplicate_and_map(NewState#state.team_pid, NewState#state.map_list),
					{stop, normal, NewState}
			end;
		_ ->
			if State#state.duplicate_type =:= ?DUPLICATE_TYPE_FIGHT ->
				{noreply, NewState};
			true ->
				lib_duplicate:clear_duplicate_and_map(NewState#state.team_pid, NewState#state.map_list),
				{stop, normal, NewState}
			end
	end;
				
do_cast({'join', PlayerInfo}, State) ->
	{UserId, Name, Pid,PidSend,VipLevel,Sex} = PlayerInfo,
	UserInfo1 = #dup_user_info{user_id = UserId, name = Name, pid_user = Pid, pid_send = PidSend,
				vipLevel = VipLevel,sex = Sex, mission_index = State#state.create_mon_times},
	if State#state.duplicate_type =:= ?DUPLICATE_TYPE_FIGHT ->
		Now = misc_timer:now_seconds(),
		UserInfo = UserInfo1#dup_user_info{enter_time = Now};
	true ->
		UserInfo = UserInfo1
	end,
	if
		State#state.duplicate_type =:= 3 ->
			%%Now = misc_timer:now_seconds(),
			{ok, Bin} = pt_12:write(?PP_NEXT_MON_TIME, [State#state.create_mon_times,
														State#state.totalmisson,
														State#state.nextmontime]),
			lib_send:send_to_sid(PidSend, Bin);
		true ->
			skip
	end,
	case lists:keyfind(UserId, #dup_user_info.user_id, State#state.user_list) of
		false ->
			NewList = [UserInfo|State#state.user_list];
		_ ->
			NewList = lists:keyreplace(UserId, #dup_user_info.user_id, State#state.user_list, UserInfo)
	end,
	{TopName,TopIdList} = get_top_name(State#state.top_name,State#state.top_id_list,UserInfo),
	{noreply, State#state{user_list=NewList, top_name = TopName, top_id_list = TopIdList}};

%% 分批创建怪物
do_cast({'create_mon_in_turn'}, State) ->
	NewState = create_mon_in_turn(State),
	{noreply, NewState};

%%守塔怪物死亡  送出副本
do_cast({'tower_dead'}, State) ->
	F = fun(Info) ->
				gen_server:cast(Info#dup_user_info.pid_user, {'quit_duplicate_timeout'})
		end,
	case is_all_off_line(State) of
		true ->
			lib_duplicate:clear_duplicate_and_map(State#state.team_pid, State#state.map_list),
			{stop, normal, State};
		false ->
			lists:foreach(F, State#state.user_list),
			{noreply, State}
	end;

%%关卡通关发送奖励
do_cast({add_pass_mission_award}, State) ->
	%%目前不考虑奖励发放，守卫无关卡奖励
	update_duplicate_top(State),
	{ok, BinData} = pt_12:write(?PP_COPY_PASS, [State#state.map_id, State#state.duplicate_type, 1]),
	send_to_all(State, BinData),
	NewState = State#state{current_mission_pass_info = [], pass_status = 1},
	{noreply, NewState};

%%收到怪物死亡后向地图进程发送是否过关询问
do_cast({monster_dead, MonsterId, UserId, MonsterType, Pid}, State) ->
	case State#state.duplicate_type of
		?DUPLICATE_TYPE_PASS ->	
			%%怪物死亡触发事件
			
			if
				MonsterType	=:= ?MONSTER_TYPE_SEAL ->
					NewState1 = State;
				MonsterType =:= ?MONSTER_TYPE_STONE ->
					{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),%%爬塔怪物死亡
					send_to_all(State, BinData),
					NewState1 = State#state{current_mission_dead_num = State#state.current_mission_dead_num + 1,
											current_mission_stone_dead_num = State#state.current_mission_stone_dead_num + 1};
				true ->
					{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),%%爬塔怪物死亡
					send_to_all(State, BinData),
					NewState1 = State#state{current_mission_dead_num = State#state.current_mission_dead_num + 1}					
			end,
			
			NewState2 = exe_duplicate_dead_event(NewState1, MonsterId, Pid),
			NewState = duplicate_pass_mission(MonsterId, NewState2);			
			%gen_server:cast(NewState#state.map_pid, {can_pass_mission});
		?DUPLICATE_TYPE_MONEY ->
			NewState1 =	add_batter_num(UserId, State),
			NewState = money_duplicate_pass_mission(MonsterId, NewState1);
		?DUPLICATE_TYPE_CHALLENGE ->
			if
				MonsterType	=:= ?MONSTER_TYPE_SEAL ->
					NewState1 = State;
				MonsterType =:= ?MONSTER_TYPE_STONE ->
					{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),%%爬塔怪物死亡
					send_to_all(State, BinData),
					NewState1 = State#state{current_mission_dead_num = State#state.current_mission_dead_num + 1,
											current_mission_stone_dead_num = State#state.current_mission_stone_dead_num + 1};
				true ->
					{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),%%爬塔怪物死亡
					send_to_all(State, BinData),
					NewState1 = State#state{current_mission_dead_num = State#state.current_mission_dead_num + 1}					
			end,
			NewState2 = exe_duplicate_dead_event(NewState1, MonsterId, Pid),
			NewState = challenge_pass_mission(MonsterId, NewState2);
		?DUPLICATE_TYPE_GUARD ->%%防守地图需要以全部怪物被清除为通本
			if
				State#state.create_mon_times =:= State#state.totalmisson ->
					[{_,_,Pid}] = State#state.map_list,
					gen_server:cast(Pid, {can_pass_mission});
				true ->
					ok
			end,			
			NewState = guard_duplicate_kill_monster_award(MonsterId, State);
		?DUPLICATE_TYPE_FIGHT -> %% 乱斗副本Boss怪物死亡会发送公告
			if
				MonsterType	=:= ?MONSTER_TYPE_SEAL ->
					NewState = State;
				MonsterType =:= ?MONSTER_TYPE_STONE ->
					{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),%%爬塔怪物死亡
					send_to_all(State, BinData),
					NewState = State#state{current_mission_dead_num = State#state.current_mission_dead_num + 1,
											current_mission_stone_dead_num = State#state.current_mission_stone_dead_num + 1};				
				true ->
					{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),%%爬塔怪物死亡
					send_to_all(State, BinData),
					case lists:keyfind(MonsterId, 1, State#state.current_mission_dead_loop_summon) of
						false ->
							NewState = State;
						_ ->
							NewState = summon_monster_dead_num(MonsterId, State, Pid)
					end
			end,
			
%% 			NewState2 = exe_duplicate_dead_event(NewState1, MonsterId, Pid),
%% 			NewState = duplicate_pass_mission(MonsterId, NewState1),
			case lib_player:get_online_info(UserId) of 
				[] ->
					ok;
				PlayerInfo ->
					monster_dead_boss_send_msg(NewState, MonsterId, PlayerInfo#ets_users.nick_name)
			end;
		_ ->
			NewState = duplicate_pass_mission(MonsterId, State),
			ok			
	end,
	New_State = if
		NewState#state.pass_status =:= 1 andalso State#state.duplicate_type  =/= ?DUPLICATE_TYPE_MONEY  ->	
			add_pass_mission_award(NewState);
		true ->
			NewState
	end,
	{noreply, New_State};
%%收到采集物品后触发事件
do_cast({collect_buff, CollectID, Pid, _UserId}, State) ->
	collect_buff(State, CollectID, Pid),
	{noreply, State};



%%爬塔关卡中怪物死亡群发剩余怪物数量
%% do_cast({map_dead_monster_send, MonsterId}, State) ->
%% 	{ok,BinData} = pt_12:write(?PP_UPDATE_DEAD_MONSTER, [State#state.map_id, MonsterId]),
%% 	send_to_all(State, BinData),
%% 	{noreply, State};
%%杀死经济副本boss摇奖
do_cast({rand_money_num}, State) ->
	case State#state.status of
		?DUPLICATE_STATUS_RAND_MONEY ->
			Amount = util:rand(8,99),
			Value = case State#state.current_mission_award of				
				[{_Id, Value1}|_L] ->
					Value1;
				[] ->
					?WARNING_MSG("error mission award:~p",[State]),
					10
			end,
			{ok, Bin} = pt_12:write(?PP_RAND_MONEY, Amount),
			send_to_all(State, Bin),
			erlang:send_after(?DORP_MONEY_DELAY_TICK, self(), {'drop_money',Amount, Value}),
			NewState = State#state{status = ?DUPLICATE_STATUS_PICKUP},
			{noreply, NewState};
		_er->
			?DEBUG("error status for rand_money_num:~p",[_er]),
			{noreply, State}
	
	end;
%%拾取打钱副本中掉落的钱币
do_cast({'get_drop_money', MoneyType, Value}, State) ->
	NewState = add_award_for_all(State, [{MoneyType,Value}]),
	{ok, BinData} = pt_12:write(?PP_PICKUP_MONEY_AMOUNT, [MoneyType, Value]),
	[UserInfo|_] = NewState#state.user_list,
	lib_send:send_to_sid(UserInfo#dup_user_info.pid_send, BinData),
	{noreply, NewState};
%% 释放下波怪物
do_cast({'open_guard_next_monster'}, State) ->
	case State#state.status of
		3 ->
			NewState = create_mon_in_defence_tower1(State);
		_er ->
			?DEBUG("error proto :~p",[_er]),
			NewState = State
	end,
	{noreply, NewState};
%% 用户离线后副本还保留3分钟 所以只是调整副本中人物状态
do_cast({'off_line', ID}, State) ->
	case lists:keyfind(ID, #dup_user_info.user_id, State#state.user_list) of
		false ->
			NewState = State;
		UserInfo ->
			NewUserInfo = UserInfo#dup_user_info{status = 1},
			List = lists:keydelete(ID, #dup_user_info.user_id, State#state.user_list),
			NewUserList = [NewUserInfo|List],
			NewState = State#state{user_list = NewUserList},
			if State#state.duplicate_type =:= ?DUPLICATE_TYPE_FIGHT ->
				false;
			true ->
				erlang:send_after(?DELAY_SHUT_DOWN_TIME_TICK, self(), {'shut_down'})
			end
	end,
	{noreply, NewState};
%% 掉线用户重连更新send_pid
%% do_cast({'reconnection_update_pid', Id, UserPid, SendPid}, State) ->
%% 	case get_user_info(State#state.user_list,Id) of
%% 		[] ->
%% 			NewState = State;
%% 		UserInfo ->
%% 			NewUserInfo = UserInfo#dup_user_info{pid_send = SendPid, pid_user = UserPid},
%% 			NewUserList = lists:keyreplace(NewUserInfo#dup_user_info.user_id, #dup_user_info.user_id, State#state.user_list, NewUserInfo),
%% 			NewState = State#state{user_list = NewUserList};
%% 	end,
%% 	{noreply, NewState};

%% 返回商品可购买数量
do_cast({'get_shop_sale_num',Id, _NpcID,ShopID}, State) ->
	case get_user_info(State#state.user_list,Id) of
		[] ->			
			NewState = State;
		UserInfo ->
					case UserInfo#dup_user_info.shop_item_list of
						{MadId, ShopSaleList} when MadId =:= State#state.map_id ->
							NewState = State;
						_ ->
							MadId = case data_agent:shop_npc_get(ShopID) of
										   [] ->
											   0;
										   ShopNPCTemplate when is_record(ShopNPCTemplate, ets_shop_npc_template) ->
											   case data_agent:npc_get(ShopNPCTemplate#ets_shop_npc_template.npc_id) of
												   [] ->
													   0;
												   NPC ->
													   NPC#ets_npc_template.map_id
											   end
										end,
							
							if
								MadId =:= State#state.map_id ->
									ShopSaleList = item_util:get_shop_sale_list(ShopID),
									NewUserInfo = UserInfo#dup_user_info{shop_item_list = {MadId,ShopSaleList}},
									NewUserList = lists:keyreplace(NewUserInfo#dup_user_info.user_id, #dup_user_info.user_id, State#state.user_list, NewUserInfo),
									NewState = State#state{user_list = NewUserList};
								true ->
									ShopSaleList = [],
									NewState = State
							end
					end,

			{ok,Bin} = pt_12:write(?PP_DUPLICATE_SHOP_SALE_NUM, ShopSaleList),
			lib_send:send_to_sid(UserInfo#dup_user_info.pid_send, Bin)
	end,
	{noreply, NewState};

%% 购买副本商品
do_cast({'buy_item',Id, ShopItemID,Count}, State) ->
	case get_user_info(State#state.user_list,Id) of
		[] ->
			NewState = State;
		UserInfo ->
			{MapId, SaleList} = UserInfo#dup_user_info.shop_item_list,
			{ShopSaleList, Num} = buy_item(SaleList,ShopItemID,Count),
			NewUserInfo = UserInfo#dup_user_info{shop_item_list = {MapId,ShopSaleList}},
			NewUserList = lists:keyreplace(NewUserInfo#dup_user_info.user_id, #dup_user_info.user_id, State#state.user_list, NewUserInfo),
			NewState = State#state{user_list = NewUserList},
			{ok, Bin} = pt_12:write(?PP_DUPLICATE_SHOP_BUY, [1, ShopItemID, Num]),
			lib_send:send_to_sid(UserInfo#dup_user_info.pid_send, Bin)
	end,
	{noreply, NewState};

%% 用户掉线后重新连接返回副本信息
do_cast({'get_duplicate_info',Id},State) ->
	send_duplicate_info(State, Id),
	{noreply, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_duplicate cast is not match:~w",[Info]),
    {noreply, State}.

buy_item(ShopSaleList,ShopItemID,Count) ->	
	buy_item1(ShopSaleList,ShopItemID,Count,[]).

buy_item1([],_ShopItemID,_Count,List) ->
	?DEBUG("no have shop item:~p",[{_ShopItemID,_Count}]),
	{List, 0};
buy_item1([Item|L],ShopItemID,Count,List) ->
	{Id,Num} = Item,
	if
		Id =:= ShopItemID ->
			if
				Num >= Count ->
					{lists:append(L,[{ShopItemID, Num - Count}|List]), Num - Count};
				true ->
					?DEBUG("no have shop item:~p",[{ShopItemID,Count}]),
					{lists:append(L, List), 0}
			end;			
 		true ->
			buy_item1(L,ShopItemID,Count,[Item|List])
	end.

%%---------------------do_info--------------------------------
%% 副本扫描
do_info({'scan_time'}, State) ->
	erlang:send_after(?Scan_Time_Tick, self(), {'scan_time'}),
	if
		%%普通副本
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_NORMAL ->
			NewState = State;
		
		%%分批出怪副本
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_BATCH ->
			[{_,_,Pid}] = State#state.map_list,
			gen_server:cast(Pid, {'create_mon_in_turn', self()}),
			NewState = State;
			
		%%守塔副本
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_GUARD ->
			NewState1 = create_mon_in_defence_tower(State),
			NewState = NewState1;
		
		%%打钱副本
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_MONEY ->
			NewState1 = create_mission_money_duplicate(State),%%时间到清除地上物品刷出怪物
			NewState = NewState1;
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_FIGHT ->
			NewState = get_out_time_over_player(State);
		true ->
			NewState = State
	end,

	{noreply, NewState};

%% 定时刷出boss
do_info({'relive_boss'}, State) ->
	%% 获取当天的时间
	erlang:send_after(?LOOP_BOSS_TIME, self(), {'relive_boss'}),
	Now1 = misc_timer:now_seconds(),
	{{_, _, _}, {H, M, S}} = util:seconds_to_localtime(Now1),
	Now = H*3600 + M*60 + S,
	LoopTime_2 = 2*?LOOP_BOSS_TIME/1000, 
	F = fun(Info, List) ->
		{MonsterId, Time} = Info,
		if Now >= Time andalso Now =< Time + LoopTime_2 ->
			relive_boss(MonsterId, Now1, State, List);
		true ->
			List
		end
	end,
	NewList =  lists:foldl(F, State#state.relive_boss_list, State#state.current_mission_time_boss),
	NewState = State#state{relive_boss_list = NewList}, 
	{noreply, NewState};
		

do_info({drop_money, Amount, Value}, State) ->
	[{_,_,Pid}] = State#state.map_list,
	gen_server:cast(Pid, {'drop_money', Amount, Value}),
	{noreply, State};

do_info({'send_can_open_nex_monster'}, State) ->
	case State#state.status of
		1 ->
			{ok, BinData} = pt_12:write(?PP_CAN_OPEN_NEXT_MONSTER, 0),
			send_to_all(State, BinData),
			NewState = State#state{status = 3};
		_er ->
			?DEBUG("error state:~p",[_er]),
			NewState = State
	end,
	{noreply, NewState};

%% 当用户离开副本后3分钟调用
do_info({'shut_down'}, State) ->
	case is_all_off_line(State) of
		true ->
			lib_duplicate:clear_duplicate_and_map(State#state.team_pid, State#state.map_list),
			{stop, normal, State};
		false ->
			{noreply, State}
	end;

%% 副本倒计时
do_info({'count_down', MapId}, State) ->
	?DEBUG("count_down:~p",[{MapId =:= State#state.map_id}]),
	if MapId =:= State#state.map_id ->
		F = fun(Info) ->
				gen_server:cast(Info#dup_user_info.pid_user, {'quit_duplicate_timeout'})
			end,
		lists:foreach(F, State#state.user_list),
		%%?DEBUG("count_down1111111:~p",[{misc_timer:now_seconds()}]),
		case is_all_off_line(State) of
			true ->
				lib_duplicate:clear_duplicate_and_map(State#state.team_pid, State#state.map_list),
				{stop, normal, State};
			false ->
				{noreply, State}
		end;
	true ->
		{noreply, State}
	end;

do_info(Info, State) ->
	?WARNING_MSG("mod_duplicate info is not match:~w",[Info]),
    {noreply, State}.
%%----------------------------------------------------------------------------
create_duplicate_map(State) ->
	UniqueId = mod_increase:get_duplicate_auto_id(),
%% 	Id = State#state.map_id * 10000 + UniqueId, 
	Id = lib_map:create_copy_id(State#state.map_id, UniqueId),
	ProcessName = misc:create_process_name(duplicate_p, [Id, 0]),
	misc:register(global, ProcessName, self()),
	{Map_pid, _} = mod_map:get_scene_pid(Id, undefined, undefined),
	gen_server:cast(Map_pid, {'set_dup_pid', self()}),
	
 	%%加载怪物
  	DuplicateTemplate = data_agent:duplicate_template_get(State#state.duplicate_id),
  	DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
 	%%取第一关卡的怪物数据
	
  	MissionTempate = lists:nth(State#state.create_mon_times, DuplicateMission),
 	MonList = tool:split_string_to_intlist(MissionTempate#ets_duplicate_mission_template.monster_list),

	Is_Dynamic = DuplicateTemplate#ets_duplicate_template.is_dynamic,
	AverLevel = State#state.aver_level,
	Min_Level = DuplicateTemplate#ets_duplicate_template.min_level,
 	gen_server:cast(Map_pid, {'create_duplicate_mon', MonList, Is_Dynamic, AverLevel, Min_Level, 1}),
	Mission_pass_info = lib_duplicate:get_script_info(ets_1, MissionTempate#ets_duplicate_mission_template.script),
	Pass_Status = if Mission_pass_info =:= [] ->
						1;
					true ->
						0
				end,
	NewState = 
		case State#state.duplicate_type of
			?DUPLICATE_TYPE_GUARD ->
				NeedTimes = MissionTempate#ets_duplicate_mission_template.need_times,
				SendTime = NeedTimes * 500,
				erlang:send_after(SendTime, self(), {'send_can_open_nex_monster'}),
				State#state{
							current_mission_pass_info = Mission_pass_info,
							pass_status = 0,
							current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_start_time = misc_timer:now_seconds(),
							nextmontime = NeedTimes %%当时间到一半的时候可以直接释放怪物
						   };
			?DUPLICATE_TYPE_PASS ->
				State#state{
							current_mission_pass_info = Mission_pass_info,
							pass_status = Pass_Status,
							current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_buff = lib_duplicate:get_script_info(ets_monster_dead_buff, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_summon = lib_duplicate:get_script_info(ets_monster_dead_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_boss = lib_duplicate:get_script_info(ets_monster_dead_boss, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_loop_summon = lib_duplicate:get_script_info(ets_monster_dead_loop_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_collect_buff = lib_duplicate:get_script_info(ets_collect_buff, 
												MissionTempate#ets_duplicate_mission_template.script)
							%%current_mission_start_time = misc_timer:now_seconds(),
							%%nextmontime = NeedTimes %%当时间到一半的时候可以直接释放怪物
						   };
			?DUPLICATE_TYPE_CHALLENGE ->
				State#state{
							current_mission_pass_info = Mission_pass_info,
							pass_status = Pass_Status,
							current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_buff = lib_duplicate:get_script_info(ets_monster_dead_buff, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_summon = lib_duplicate:get_script_info(ets_monster_dead_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_boss = lib_duplicate:get_script_info(ets_monster_dead_boss, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_loop_summon = lib_duplicate:get_script_info(ets_monster_dead_loop_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_pass_event = lib_duplicate:get_script_info(ets_mission_pass_event,
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_collect_buff = lib_duplicate:get_script_info(ets_collect_buff, 
												MissionTempate#ets_duplicate_mission_template.script)
						   };
			?DUPLICATE_TYPE_MONEY ->
				NewState1 = State#state{
										current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
										current_mission_dead_loop_summon = lib_duplicate:get_script_info(ets_monster_dead_loop_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
										current_mission_pass_info = Mission_pass_info,
										pass_status = Pass_Status,
										status = ?DUPLICATE_STATUS_BATTLE
										},
				NewState1;
			?DUPLICATE_TYPE_FIGHT ->
				State1 = State#state{
							current_mission_pass_info = Mission_pass_info,
							current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_buff = lib_duplicate:get_script_info(ets_monster_dead_buff, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_summon = lib_duplicate:get_script_info(ets_monster_dead_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_boss = lib_duplicate:get_script_info(ets_monster_dead_boss, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_dead_loop_summon = lib_duplicate:get_script_info(ets_monster_dead_loop_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_pass_event = lib_duplicate:get_script_info(ets_mission_pass_event,
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_collect_buff = lib_duplicate:get_script_info(ets_collect_buff, 
												MissionTempate#ets_duplicate_mission_template.script),	
							current_mission_boss = lib_duplicate:get_script_info(ets_monster_boss, 
												MissionTempate#ets_duplicate_mission_template.script),
							current_mission_time_boss = lib_duplicate:get_script_info(ets_monster_time_boss, 
												MissionTempate#ets_duplicate_mission_template.script),									
							pass_status = Pass_Status
										},
				F = fun(Info, List) ->
						{MonsterID,DeadNum,TargetID,_TargetNum} = Info,
						[{MonsterID, 0}|List]
					end,
				List1 = lists:foldl(F, [], State1#state.current_mission_dead_loop_summon),
				State1#state{dead_monster_list = List1};
			_ ->
				State#state{current_mission_pass_info = Mission_pass_info, pass_status = Pass_Status}
		end,
	
	{Map_pid ,Id, NewState#state{ map_list = [{State#state.map_id, Id, Map_pid}],
		 current_mission_award = MissionTempate#ets_duplicate_mission_template.award_id, current_mission_start_time = misc_timer:now_seconds()}}.

%% 爬塔副本进入下层
create_duplicate_next_map(State) ->
	UniqueId = mod_increase:get_duplicate_auto_id(),
%% 	Id = State#state.map_id * 10000 + UniqueId, 
	Id = lib_map:create_copy_id(State#state.map_id, UniqueId),
	ProcessName = misc:create_process_name(duplicate_p, [Id, 0]),
	misc:register(global, ProcessName, self()),
	{Map_pid, _} = mod_map:get_scene_pid(Id, undefined, undefined),
	gen_server:cast(Map_pid, {'set_dup_pid', self()}),
	
 	%%加载怪物
	DuplicateTemplate = data_agent:duplicate_template_get(State#state.duplicate_id),
	
	DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
 	%%取当前关卡的怪物数据
	%%?DEBUG("Create_Mon_Times:~p,~p",[Create_Mon_Times, DuplicateMission]),
	if
		length(DuplicateMission) < State#state.create_mon_times ->
			?WARNING_MSG("error mission:~p",[{State#state.create_mon_times,State#state.duplicate_id,State#state.map_id}]),
			MissionTempate = [];
		true ->
			MissionTempate = lists:nth(State#state.create_mon_times, DuplicateMission)
	end,
  	if
		MissionTempate#ets_duplicate_mission_template.map_id =/= State#state.map_id ->
			?WARNING_MSG("error mission:~p",[{MissionTempate#ets_duplicate_mission_template.mission_id,State#state.map_id}]);
		true ->
			ok
	end,
	case MissionTempate#ets_duplicate_mission_template.need_times of %%应为每一层的时间一样所以还是使用副本设置的时间
		0 ->
			skip;
		TotalTime ->
			erlang:send_after(TotalTime * 1000, self(), {'count_down', State#state.map_id})
	end,
	%%?DEBUG("MissionTempate:~p",[MissionTempate]),
 	MonList = tool:split_string_to_intlist(MissionTempate#ets_duplicate_mission_template.monster_list),
	
	Is_Dynamic = DuplicateTemplate#ets_duplicate_template.is_dynamic,
	AverLevel = State#state.aver_level,
	Min_Level = DuplicateTemplate#ets_duplicate_template.min_level,
 	gen_server:cast(Map_pid, {'create_duplicate_mon', MonList, Is_Dynamic, AverLevel, Min_Level, 1}),

	NewState = State,%% 守护副本不会被掉用这个方法
	Mission_pass_info = lib_duplicate:get_script_info(ets_1, MissionTempate#ets_duplicate_mission_template.script),
	Pass_Status = if Mission_pass_info =:= [] ->
						1;
					true ->
						0
				end,	
	NewMapList = [{State#state.map_id,Id,Map_pid}|NewState#state.map_list],
	
	{Map_pid ,Id, NewState#state{map_list = NewMapList,
 	current_mission_award = MissionTempate#ets_duplicate_mission_template.award_id,
	current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
	current_mission_dead_buff = lib_duplicate:get_script_info(ets_monster_dead_buff, 
												MissionTempate#ets_duplicate_mission_template.script),
	current_mission_dead_summon = lib_duplicate:get_script_info(ets_monster_dead_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
	current_mission_dead_boss = lib_duplicate:get_script_info(ets_monster_dead_boss, 
												MissionTempate#ets_duplicate_mission_template.script),
	current_mission_dead_loop_summon = lib_duplicate:get_script_info(ets_monster_dead_loop_summon, 
												MissionTempate#ets_duplicate_mission_template.script),
	current_mission_collect_buff = lib_duplicate:get_script_info(ets_collect_buff, 
												MissionTempate#ets_duplicate_mission_template.script),
	current_mission_pass_info = Mission_pass_info,
	pass_status = Pass_Status,
	current_mission_dead_num = 0,current_mission_stone_dead_num = 0,current_mission_start_time = misc_timer:now_seconds()}}.

%% 创建经济副本关卡
create_mission_money_duplicate(State1) ->
	Now = misc_timer:now_seconds(),
	State =	update_batter_num(Now, State1), %%检查连击是否会断	
	if 
		State#state.nextmontime + ?MONEY_DUPLICATE_PICKUP_TIME < Now andalso State#state.status =:= ?DUPLICATE_STATUS_PICKUP ->			
			Create_Mon_Times = State#state.create_mon_times + 1,
			DuplicateTemplate = data_agent:duplicate_template_get(State#state.duplicate_id),
			DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
			if	
				erlang:length(DuplicateMission) < Create_Mon_Times ->
					State;
				true ->
					MissionTempate = lists:nth(Create_Mon_Times,  DuplicateMission),
					NeedTimes = MissionTempate#ets_duplicate_mission_template.need_times,
					F = fun(Info) ->
								{ok, Bin} = pt_12:write(?PP_LEFT_TIME, [Create_Mon_Times,State#state.totalmisson, NeedTimes]),%%
								lib_send:send_to_sid(Info#dup_user_info.pid_send, Bin)
						end,
					lists:foreach(F, State#state.user_list),
					MonList = tool:split_string_to_intlist(MissionTempate#ets_duplicate_mission_template.monster_list),
					Is_Dynamic = DuplicateTemplate#ets_duplicate_template.is_dynamic,
				    AverLevel = State#state.aver_level,
					Min_Level = DuplicateTemplate#ets_duplicate_template.min_level,
					[{_,_,Pid}] = State#state.map_list,
					gen_server:cast(Pid, {'create_money_duplicate_mon', MonList, Is_Dynamic, AverLevel, Min_Level, Create_Mon_Times}),
					%update_duplicate_target(State),														
					NewState = State#state{
										   current_mission_award = MissionTempate#ets_duplicate_mission_template.award_id,
											current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
											current_mission_pass_info = lib_duplicate:get_script_info(ets_1, 
												MissionTempate#ets_duplicate_mission_template.script),
										   create_mon_times = Create_Mon_Times,
										   status = ?DUPLICATE_STATUS_BATTLE
										   },					
					NewState1 = update_batter_time(Now, NewState),
					NewState1
			end;
		true ->
			State
	end.

%% 乱斗副本踢出时间已到的玩家
get_out_time_over_player(State) ->
	Now = misc_timer:now_seconds(),
	F = fun(Info) ->
			if Now - Info#dup_user_info.enter_time > ?TIME_LIMIT_OUT ->				
				gen_server:cast(Info#dup_user_info.pid_user, {'quit_duplicate_timeout'});
			true ->
				skip				
			end
		end,
	lists:foreach(F, State#state.user_list),
	State.

%%增加连击次数  目前不考虑组队
add_batter_num(UserId, State) ->
	Now = misc_timer:now_seconds(),
	[Award|_] = State#state.current_mission_kill_award,	
	UserList = add_batter_num1(State#state.user_list, [], Now, UserId, [Award]),
	State#state{user_list = UserList, current_mission_dead_num = State#state.current_mission_dead_num + 1}.

add_batter_num1([], List, _Now, _UserId, _Award) ->
	List;
add_batter_num1([User|L], List, Now, _UserId, Award) ->
%% 	if User#dup_user_info.user_id =/= UserId ->
%% 		add_batter_num1(L, [User|List], UserId);
%% 	true ->
	NewAwardList = add_award1(Award, User#dup_user_info.award_list),%%在算连击的同时将奖励也处理了
	NaxBatterNum = if User#dup_user_info.batter_num + 1 > User#dup_user_info.max_batter_num ->
							User#dup_user_info.batter_num + 1;
						true ->
							User#dup_user_info.max_batter_num
					end,
	NewUser = User#dup_user_info{award_list = NewAwardList,batter_time = Now, max_batter_num = NaxBatterNum, batter_num = User#dup_user_info.batter_num + 1},
	[{_,Value}] = Award,
	{ok, BinData} = pt_12:write(?PP_UPDATE_BATTER_NUM, [NewUser#dup_user_info.batter_num, ?BATTER_TIME_TICK, Value]),
%% 	?DEBUG("batter num:~p",[{NewUser#dup_user_info.batter_num}]),
	lib_send:send_to_sid(NewUser#dup_user_info.pid_send, BinData),
	case NewUser#dup_user_info.batter_num of
		100 ->
			 gen_server:cast(NewUser#dup_user_info.pid_user,{'add_player_buff', 740001});
		200 ->
			 gen_server:cast(NewUser#dup_user_info.pid_user,{'add_player_buff', 740002});
		300 ->
			 gen_server:cast(NewUser#dup_user_info.pid_user,{'add_player_buff', 740003});
		400 ->
			 gen_server:cast(NewUser#dup_user_info.pid_user,{'add_player_buff', 740004});
		500 ->
			 gen_server:cast(NewUser#dup_user_info.pid_user,{'add_player_buff', 740005});
		_ ->
			ok
	end,
	[NewUser|L] ++ List.
%% 	end.

%%更新连击次数
update_batter_num(Time, State) ->
	F = fun(User,L) ->
			if
				User#dup_user_info.batter_time + ?BATTER_TIME_TICK > Time ->
					[User|L];
				User#dup_user_info.batter_num > 0 ->
					NewUser = User#dup_user_info{batter_time = 0, batter_num = 0},
					{ok, BinData} = pt_12:write(?PP_UPDATE_BATTER_NUM,[ 0, 0 ,0]),					
					lib_send:send_to_sid(User#dup_user_info.pid_send, BinData),
					[NewUser|L];
				true ->
					[User|L]
			end	
		end,
	if State#state.status =:= ?DUPLICATE_STATUS_BATTLE ->
			UserList = lists:foldr(F, [], State#state.user_list),
			State#state{user_list = UserList};
		State#state.status =:= ?DUPLICATE_STATUS_RAND_MONEY  andalso State#state.nextmontime + ?MONEY_DUPLICATE_RAND_TIME < Time ->
			gen_server:cast(self(), {rand_money_num}),
			State;
		true ->
			State
	end.
	
%%统一更新连击时间
update_batter_time(_Time, State) ->
	F = fun(User,L)  ->
			NewUser = User#dup_user_info{batter_time = User#dup_user_info.batter_time + ?MONEY_DUPLICATE_PICKUP_TIME},
			[NewUser|L]
		end,
	UserList = lists:foldr(F, [], State#state.user_list),
	State#state{user_list = UserList}.

%% 创建守塔副本怪物
create_mon_in_defence_tower(State) ->
	case State#state.status of
		1 ->
			State;
		2 ->
			State;
		3 ->
			Now = misc_timer:now_seconds(),
			if
 				Now <  State#state.current_mission_start_time + State#state.nextmontime ->
					State;
				true ->
					check_tower_boss_dead(State),
					create_mon_in_defence_tower1(State)
			end;
		_er ->
			?DEBUG("error state:~p",[_er]),
			State
	end.

check_tower_boss_dead(State) ->
	if	State#state.create_mon_times > 20 ->
			[{_,_,Pid}] = State#state.map_list,
			gen_server:cast(Pid,{check_tower_boss_dead});
		true ->
			skip
	end.

chat_sysmsg(State, Create_Mon_Times,Str) ->
	F = fun(Info,Names) ->
			if 
				Names =:= [] ->
					Info#dup_user_info.name;
				true ->
					?GET_TRAN("~s,~s",[Names,Info#dup_user_info.name])
			end
		end,
	Name = lists:foldl(F, [], State#state.user_list),

	DuplicateTemplate = data_agent:duplicate_template_get(State#state.duplicate_id),
	ChatStr = ?GET_TRAN(Str, [Name, DuplicateTemplate#ets_duplicate_template.name,Create_Mon_Times]),
	lib_chat:chat_sysmsg_roll([ChatStr]).

create_mon_in_defence_tower1(State) ->
	Create_Mon_Times = State#state.create_mon_times + 1,
	%?DEBUG("~w",[Create_Mon_Times]),
	case Create_Mon_Times rem 10 of
		0 ->
			chat_sysmsg(State, Create_Mon_Times,?_LANG_NOTICE_DUPLICATE_GUARD);
		_ ->
			ok%chat_sysmsg(State, Create_Mon_Times)
	end,
	DuplicateTemplate = data_agent:duplicate_template_get(State#state.duplicate_id),
	DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
	if
		erlang:length(DuplicateMission) < Create_Mon_Times ->
			State;
		true ->		
			Now = misc_timer:now_seconds(),
			MissionTempate = lists:nth(Create_Mon_Times,  DuplicateMission),								
			NeedTimes = MissionTempate#ets_duplicate_mission_template.need_times,
			
%% 			LastMissionTempate = lists:nth(Create_Mon_Times-1,  DuplicateMission),
%% 			LastNeedTimes = LastMissionTemate#ets_duplicate_mission_template.need_times,
%% 			if
%% 				Now <  State#state.current_mission_start_time + State#state.nextmontime ->%%通过时间判断，此处可以优化
%% 					State;
%% 				true ->						
					MonList = tool:split_string_to_intlist(MissionTempate#ets_duplicate_mission_template.monster_list),
					
					Is_Dynamic = DuplicateTemplate#ets_duplicate_template.is_dynamic,
				    AverLevel = State#state.aver_level,
					Min_Level = DuplicateTemplate#ets_duplicate_template.min_level,
					
					%%计算下一波怪的时间       发给客户端显示
					F = fun(Info) ->
								{ok, Bin} = pt_12:write(?PP_NEXT_MON_TIME, [Create_Mon_Times,State#state.totalmisson,NeedTimes]),
								lib_send:send_to_sid(Info#dup_user_info.pid_send, Bin)
						end,
					lists:foreach(F, State#state.user_list),
					update_duplicate_target(State),
					[{_,_,Pid}] = State#state.map_list,
					gen_server:cast(Pid, {'create_duplicate_mon', MonList, Is_Dynamic, AverLevel, Min_Level, Create_Mon_Times}),
					SendTime = NeedTimes * 500,
					erlang:send_after(SendTime, self(),{'send_can_open_nex_monster'}),																	
					NewState = State#state{
										   create_mon_times = Create_Mon_Times,
										   current_mission_kill_award = lib_duplicate:get_script_info(ets_kill_monster_award, 
												MissionTempate#ets_duplicate_mission_template.script),
										   status = 1,
										   current_mission_start_time = Now,
										   nextmontime = NeedTimes
										  },
					NewState
%% 			end
	end.
			
%% 创建分批副本
create_mon_in_turn(State) ->
	Create_Mon_Times = State#state.create_mon_times + 1,
	DuplicateTemplate =  data_agent:duplicate_template_get(State#state.duplicate_id),
	DuplicateMission = DuplicateTemplate#ets_duplicate_template.other_data#other_duplicate_template.missions,
	
	if
		erlang:length(DuplicateMission) < Create_Mon_Times ->
			State;
		true ->
			MissionTempate = lists:nth(Create_Mon_Times,  DuplicateMission),		
			MonList = tool:split_string_to_intlist(MissionTempate#ets_duplicate_mission_template.monster_list),
			
			Is_Dynamic = DuplicateTemplate#ets_duplicate_template.is_dynamic,
			AverLevel = State#state.aver_level,
			Min_Level = DuplicateTemplate#ets_duplicate_template.min_level,
			[{_,_,Pid}] = State#state.map_list,
			gen_server:cast(Pid, {'create_duplicate_mon', MonList, Is_Dynamic, AverLevel,Min_Level,Create_Mon_Times}),
			NewState = State#state{create_mon_times = Create_Mon_Times},
			NewState
	end.

guard_duplicate_kill_monster_award(_MonsterId, State) ->	
	NewState = case State#state.current_mission_kill_award of
		[] ->
			?DEBUG("error award:~p",[State#state.map_id]),
			State;
		[Award1|L] ->
			{Type1,Value1} = Award1,
			case L of
				[] -> 
					Award = guard_duplicate_kill_monster_award1(Type1,Value1,0,0),
					guard_duplicate_kill_monster_award2(State, Award);
				[{Type2,Value2}|_] ->
					Award = guard_duplicate_kill_monster_award1(Type1,Value1,Type2,Value2),
					guard_duplicate_kill_monster_award2(State, Award);
				_->
					?DEBUG("error award:~p",[State#state.map_id]),
					State
			end;
		_->
			?DEBUG("error award:~p",[State#state.map_id]),
			State
	end,
	NewState.
guard_duplicate_kill_monster_award1(Type1,Value1,Type2,Value2) ->
	{Exp1, BindCopper1} = if 
		Type1 =:= ?CURRENCY_TYPE_EXP ->
			{Value1,0};
		Type1 =:= ?CURRENCY_TYPE_BIND_COPPER ->
			{0,Value1};
		true ->
			{0,0}
	end,
	{Exp, BindCopper} = if
		Type2 =:= ?CURRENCY_TYPE_EXP ->
			{Exp1 + Value2,BindCopper1};
		Type2 =:= ?CURRENCY_TYPE_BIND_COPPER ->
			{Exp1,BindCopper1 + Value2};
		true ->
			{Exp1, BindCopper1}
	end,
	{{Exp, BindCopper},[{?CURRENCY_TYPE_EXP,Exp},{?CURRENCY_TYPE_BIND_COPPER,BindCopper}]}.
guard_duplicate_kill_monster_award2(State, Award) ->
	{{Exp, BindCopper},AwardList} = Award,
	if
		Exp > 0 orelse BindCopper > 0 ->
			{ok, BinData} = pt_12:write(?PP_GUARD_KILL_AWARD, [Exp, BindCopper]),
			send_to_all(State, BinData),
			add_award_for_all(State, AwardList);
		true ->
			?DEBUG("error guard award:~p",[Award]),
			State
	end.

%%副本过关提示
duplicate_pass_mission(MonsterId, State) ->
	PassList = money_duplicate_pass_mission1(State#state.current_mission_pass_info, [], MonsterId),
	if
		State#state.pass_status =:= 1 ->
			State;
		PassList =/= [] ->
			State#state{current_mission_pass_info = PassList};
		true ->
			PassType = if
				State#state.create_mon_times =:= State#state.totalmisson ->
					1;%副本通关
				true ->
					0%当前关卡通关
			end,
			check_psas_notice(State),
			update_duplicate_top(State),
			{ok, BinData} = pt_12:write(?PP_COPY_PASS, [State#state.map_id, State#state.duplicate_type, PassType]),
			send_to_all(State, BinData),
			State#state{current_mission_pass_info = PassList, pass_status = 1}		
	end.

check_psas_notice(State) ->
	if	State#state.duplicate_id =:= ?DUPLICATE_ZTG_ID ->
			case State#state.create_mon_times of
				9 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				16 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				23 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				30 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				_ ->
					skip
			end;
		State#state.duplicate_id =:= ?DUPLICATE_YMH_ID ->
			case State#state.create_mon_times of
				11 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				17 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				23 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				30 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				31 ->
					chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS);
				_ ->
					skip
			end;
		State#state.create_mon_times > 5 andalso State#state.create_mon_times rem  5 =:= 0 ->
			chat_sysmsg(State, State#state.create_mon_times,?_LANG_NOTICE_DUPLICATE_PASS_TEAM);
		true ->
			skip
	end.
	

%%试炼副本过关提示
challenge_pass_mission(MonsterId, State) ->
	PassList = money_duplicate_pass_mission1(State#state.current_mission_pass_info, [], MonsterId),
	if
		PassList =/= [] ->
			State#state{current_mission_pass_info = PassList};		
		true ->
			challenge_pass_mission1(State)
	end.
challenge_pass_mission1(State) ->
	[U|_] = State#state.user_list,
	Result = gen_server:call(U#dup_user_info.pid_user, {max_challenge_num}),

	if
		State#state.pass_status =:= 1 ->
			challenge_pass_mission2(State, U),		
			State;
		true ->
			update_duplicate_top(State),
			Time = misc_timer:now_seconds() - State#state.start_time,
			NewState = State#state{current_mission_pass_info = [], pass_status = 1, pass_mission_use_time = Time},
			if Result =:= true ->
					challenge_pass_mission2(NewState, U);
				true ->
					case lists:keyfind(NewState#state.map_id, 1, NewState#state.map_list) of
						false ->
							ok;
						{_,_,Pid} ->
							pass_mission_summon(NewState, Pid)
					end					
			end,
			NewState
	end.

challenge_pass_mission2(State, U) ->%%计算星级
	case data_agent:get_challenge_duplicate_template(State#state.create_mon_times)of
		[] ->
			Star = 1;
		Temp ->
			%Time = misc_timer:now_seconds() - State#state.current_mission_start_time,
			Star = challenge_pass_mission3(Temp#ets_challenge_duplicate_template.star_time, State#state.pass_mission_use_time)
	end,	
	gen_server:cast(U#dup_user_info.pid_user, {update_challenge_star, State#state.create_mon_times, Star}),
	{ok, BinData} = pt_12:write(?PP_CHALLENGE_BOSS_PASS, [State#state.create_mon_times, Star, State#state.pass_mission_use_time]),
	lib_send:send_to_sid(U#dup_user_info.pid_send, BinData).

challenge_pass_mission3([],_Time) ->	1;
challenge_pass_mission3([H|L], Time) ->
	{Star,T} = H,
	if
		Time =< T ->
			Star;
		true ->
			challenge_pass_mission3(L, Time)
	end.

get_top_name(Name,List,Info) ->
	Names=if
		Name =:= [] ->
			?GET_TRAN("~s,~p,~p,~p",[Info#dup_user_info.name,Info#dup_user_info.user_id,Info#dup_user_info.vipLevel,Info#dup_user_info.sex]);
		true ->
			?GET_TRAN("~s|~s,~p,~p,~p",[Name,Info#dup_user_info.name,Info#dup_user_info.user_id,Info#dup_user_info.vipLevel,Info#dup_user_info.sex])
	end,
	{Names, [Info#dup_user_info.user_id|List]}. 

update_duplicate_top(State) ->
%% 	F = fun(Info,{Name,List}) ->
%% 			Name1 = if
%% 				Name =:= [] ->
%% 					?GET_TRAN("~s,~p,~p,~p",[Info#dup_user_info.name,Info#dup_user_info.user_id,Info#dup_user_info.vipLevel,Info#dup_user_info.sex]);
%% 				true ->
%% 					?GET_TRAN("~s|~s,~p,~p,~p",[Name,Info#dup_user_info.name,Info#dup_user_info.user_id,Info#dup_user_info.vipLevel,Info#dup_user_info.sex])
%% 			end,
%% 			{Name1,[Info#dup_user_info.user_id|List]}
%% 		end,		
	if
		State#state.duplicate_type =:= ?DUPLICATE_TYPE_GUARD orelse State#state.duplicate_type =:= ?DUPLICATE_TYPE_PASS
		orelse State#state.duplicate_type =:= ?DUPLICATE_TYPE_CHALLENGE ->
					TopPid = mod_top:get_mod_top_pid(),
					%%{Names,Lists} = lists:foldl(F, {[],[]}, State#state.user_list),
					Lists = State#state.top_id_list,
					case State#state.duplicate_type of
						?DUPLICATE_TYPE_GUARD ->
							UseTime = misc_timer:now_seconds() - State#state.start_time;
						?DUPLICATE_TYPE_CHALLENGE ->
							UseTime = misc_timer:now_seconds() - State#state.start_time;
						?DUPLICATE_TYPE_PASS ->
							UseTime = misc_timer:now_seconds() - State#state.current_mission_start_time 
					end,
					UserInfo = #top_duplicate_info{use_time = UseTime, user_name = State#state.top_name,
									pass_id = State#state.create_mon_times, duplicate_id = State#state.duplicate_id, user_id_list = Lists},
					gen_server:cast(TopPid, {update_duplicate_top, UserInfo}); 
		true ->
					ok
	end.

%%打钱副本是否过关卡奖励
money_duplicate_pass_mission(MonsterId, State) ->	
	PassList = money_duplicate_pass_mission1(State#state.current_mission_pass_info,[], MonsterId),
	if
		PassList =/= [] ->
			State#state{current_mission_pass_info = PassList};
		true ->
			%%gen_server:cast(self(), {rand_money_num}),
			[{_,_,Pid}] = State#state.map_list,
			gen_server:cast(Pid,{'clear_monster_all'}),
			{ok, BinData} = pt_12:write(?PP_CLEAR_MOUNSTER_ALL, ?MONEY_DUPLICATE_PICKUP_TIME),
			send_to_all(State, BinData),
			case data_agent:monster_template_get(MonsterId) of
				MonInfo when MonInfo#ets_monster_template.type =:= 1 ->					
					[H|_] = State#state.user_list,
					ChatStr = ?GET_TRAN(?_LANG_NOTICE_DUPLICATE_MONEY,[H#dup_user_info.name, MonInfo#ets_monster_template.name]),
					lib_chat:chat_sysmsg_roll([ChatStr]);
				_ ->
					skip
			end,			
%% 			{ok, Bin} = pt_12:write(?PP_KILL_BOSS, State#state.create_mon_times),
%% 			lib_send:send_one(UserInfo#dup_user_info.pid_send, Bin),
%% 			PassType = if
%% 				State#state.create_mon_times =:= State#state.totalmisson ->
%% 					1;%副本通关
%% 				true ->
%% 					0%当前关卡通关
%% 			end,
%% 			{ok, BinData} = pt_12:write(?PP_COPY_PASS, [State#state.map_id, PassType]),
%% 			send_to_all(State, BinData),
			State#state{current_mission_pass_info = PassList, status = ?DUPLICATE_STATUS_RAND_MONEY, nextmontime = misc_timer:now_seconds(), pass_status = 1}		
	end.



money_duplicate_pass_mission1([], List, _MonsterId) ->
	List;
money_duplicate_pass_mission1([{T,V}|L], List ,MonsterId) ->
	if
		V =:= MonsterId ->
			if
				T =:= 1 ->
					List ++ L;
				true ->
					[{T - 1, V}|List] ++ L
			end;
		true ->
			money_duplicate_pass_mission1(L, [{T,V}|List] ,MonsterId)
	end.
%% 清除无人会走的map
clear_duplicate_map(Index,MapId,UserList,MapList) ->
	F = fun(Info) ->
			Res = Info#dup_user_info.mission_index =< Index,
			Res
		end,
	case lists:any(F, UserList) of
		true ->
			MapList;
		false ->
			clear_duplicate_map1(MapId,MapList)
	end.
clear_duplicate_map1(Map_Id,MapList) ->
	F = fun(Info) ->
			{MapId,_OnlyId,MapPid} = Info,
			if
				MapId < Map_Id ->
					gen_server:cast(MapPid, {stop, duplicate_finish}),
					false;
				true ->
					true
			end
		end,
	lists:filter(F, MapList).

%%关卡通关发送奖励
add_pass_mission_award(State) ->
	F = fun(UserInfo, List) ->
		NewAwardList = add_award1(State#state.current_mission_award, UserInfo#dup_user_info.award_list),
%% 		if%% 如果是爬塔需要通知客户端
%% 			State#state.duplicate_type =:= ?DUPLICATE_TYPE_PASS ->
%% 				{ok, Bin} = pt_12:write(?PP_PASS_MISSION, [State#state.map_id,0,0]),
%% 				lib_send:send_to_sid(UserInfo#dup_user_info.pid_send, Bin);
%% 			true ->
%% 				ok
%% 		end,
		[UserInfo#dup_user_info{award_list = NewAwardList}|List]
		end,
	if State#state.current_mission_award =/= [] ->
		NewUserList = lists:foldl(F, [], State#state.user_list),
		NewState = State#state{current_mission_award = [], user_list = NewUserList};
		%?DEBUG("add_pass_mission_award(~p",[State#state.current_mission_award]);
	true ->
		NewState = State
	end,
	NewState.
%%通用奖励发放方法
add_award_for_all(State, AwardList) ->
	F = fun(UserInfo, List) ->
			NewAwardList = add_award1(AwardList, UserInfo#dup_user_info.award_list),
			[UserInfo#dup_user_info{award_list = NewAwardList}|List]
		end,
	if length(AwardList) > 0 ->
		NewUserList = lists:foldl(F, [], State#state.user_list),
		State#state{current_mission_award = [], user_list = NewUserList};
	true ->
		State
	end.
add_award1([],AwardList) ->
	AwardList;
add_award1([Award|L],AwardList) ->
	NewAwardList = add_award(Award,AwardList,[]),
	add_award1(L, NewAwardList).
%%添加奖励
add_award({Id, Value},[],List) ->
	[{Id, Value}|List];
add_award({Id, Value},[{TId, TValue}|L],List) ->
	if TId =:= Id ->
		lists:append([{TId,TValue + Value}|List], L);
	true ->
		add_award({Id, Value},L,[{TId, TValue}|List])
	end.
%% 想副本中的用户发送信息
send_to_all(State, BinData) ->
	F = fun(UserInfo) ->
			lib_send:send_to_sid(UserInfo#dup_user_info.pid_send, BinData)
		end,
	lists:foreach(F, State#state.user_list).
%% 判断是否全部离线
is_all_off_line(State) ->
	is_all_off_line1(State#state.user_list).

is_all_off_line1([]) ->
	true;
is_all_off_line1([U|L]) ->
	if
		U#dup_user_info.status =:= 0 ->	
			false;
		true ->
			is_all_off_line1(L)
	end.

%%副本事件代码
exe_duplicate_dead_event(State, MonsterId, Pid) ->
	State1 = monster_dead_buff(State, MonsterId, Pid),
	State2 = monster_dead_summon(State1, MonsterId, Pid),
	State3 = monster_dead_boss(State2, MonsterId, Pid),
	monster_dead_loop_summon(State3, MonsterId, Pid).

monster_dead_buff(State, DMonsterID, Pid) ->
	F = fun(Info) ->
			{MonsterID,BuffID,TargetType,TargetID,Rate} = Info,
			if
				DMonsterID =:= MonsterID ->
					RandNum = util:rand(1, 10000),
					if
 						RandNum =< Rate ->
							case TargetType of
								?BUFF_CAST_TARGET_PLAYER ->
									add_buff_for_player(State, BuffID);
								?BUFF_CAST_TARGET_MONSTER ->%%目前不支持怪物死亡给怪物增加buff
									add_buff_for_monster(Pid, BuffID, TargetID, 1);%%type 小于10为地方怪物，大于10为我方怪物
								_er ->
									?DEBUG("error target:~p",[_er]),
									ok
							end;							
						true ->
							ok
					end;
				true ->
					ok				
			end
		end,
	
	lists:foreach(F, State#state.current_mission_dead_buff),
	State.
%%通关后召唤怪物
pass_mission_summon(State,Pid) ->
	F = fun(Info) ->
			{Type,MonsterId} = Info,
			case Type of
				1 ->
					summon_monster(Pid, MonsterId);
				_ ->
					ok
			end
		end,
	lists:foreach(F, State#state.current_mission_pass_event).

%%召唤怪物
monster_dead_summon(State, DMonsterID, Pid) ->
	F = fun(Info, List) ->
			{MonsterID,DeadNum,TargetID,TargetNum} = Info,
			if
				MonsterID =:= DMonsterID andalso				
				(DeadNum =:= 0 orelse DeadNum =:= State#state.current_mission_stone_dead_num) ->
					case summon_monster1(State, Pid, TargetID, summ_boss) of
						{0,0} ->
							List;
						{Num,MonsterId} when TargetNum =:= 0 ->
							[{Num,MonsterId}|List];
						_ ->							 
							List
					end;
				true ->
					List
			end
		end,
	NewList = lists:foldl(F, [], State#state.current_mission_dead_summon),
	if
		NewList =/= [] ->
			State#state{current_mission_pass_info = State#state.current_mission_pass_info ++ NewList};
		true ->
			State
	end.

%% 怪物出现时发送消息
monster_summon_sendmsg(State, MonsterId, Type) ->
	case data_agent:map_template_get(State#state.map_id) of
		[] ->
			MapName = "未知地图";
		MapTemplate ->
			MapName = MapTemplate#ets_map_template.name
	end,
	F = fun(Info) ->
			{MonsterID} = Info,
			if
				MonsterID =:= MonsterId ->
					case data_agent:monster_template_get(MonsterID) of
						[] ->
							skip;
						MonInfo ->
							if Type =:= summ_boss ->					
								ChatStr = ?GET_TRAN(?_LANG_NOTICE_DUPLICATE_BOSS_BORN,[MonInfo#ets_monster_template.name, MapName]),
								lib_chat:chat_sysmsg_roll([ChatStr]);
							true ->
								ChatStr = ?GET_TRAN(?_LANG_NOTICE_TIME_BOSS_BORN,[MonInfo#ets_monster_template.name, MapName]),
								lib_chat:chat_sysmsg_roll([ChatStr])
							end
					end;
				true ->
					ok
			end
		end,
	lists:foreach(F, State#state.current_mission_boss).

summon_monster1(State, MapPid, MonsterID, Type) ->
	case data_agent:monster_template_get(MonsterID) of
		[] ->
			{0,0};
		MonTemplate ->
			MonList = tool:split_string_to_intlist(MonTemplate#ets_monster_template.lbornl_points),
			F = fun(Mon,MList) ->
					if State#state.duplicate_type =:= ?DUPLICATE_TYPE_FIGHT ->
						monster_summon_sendmsg(State, MonsterID, Type);
					true ->
						skip
					end,
					{X,Y} = Mon,
					[{MonsterID,X,Y}|MList]
				end,
			NewMonList = lists:foldl(F, [], MonList),			
 			gen_server:cast(MapPid, {'create_duplicate_mon', NewMonList, 0, 1, 1, 0}),
			{length(NewMonList),MonsterID}
	end.
	
summon_monster(MapPid, MonsterID) ->
	case data_agent:monster_template_get(MonsterID) of
		[] ->
			{0,0};
		MonTemplate ->
			MonList = tool:split_string_to_intlist(MonTemplate#ets_monster_template.lbornl_points),
			F = fun(Mon,MList) ->
					{X,Y} = Mon,
					[{MonsterID,X,Y}|MList]
				end,
			NewMonList = lists:foldl(F, [], MonList),			
 			gen_server:cast(MapPid, {'create_duplicate_mon', NewMonList, 0, 1, 1, 0}),
			{length(NewMonList),MonsterID}
	end.

summon_monster_by_num(MapPid, MonsterID, Num) ->
	case data_agent:monster_template_get(MonsterID) of
		[] ->
			{0,0};
		MonTemplate ->
			MonList = tool:split_string_to_intlist(MonTemplate#ets_monster_template.lbornl_points),
			F = fun(Mon,MList) ->
					{List, Count} = MList,
					if Count > Num ->
						MList;
					true ->
						{X,Y} = Mon,					
						NewList = [{MonsterID,X,Y}|List],
						NewCount = Count + 1,
						{NewList, NewCount}
					end
				end,
			{NewMonList, _} = lists:foldl(F, {[], 0}, MonList),
 			gen_server:cast(MapPid, {'create_duplicate_mon', NewMonList, 0, 1, 1, 0}),
			{length(NewMonList),MonsterID}
	end.

%%怪物死亡，给boss增加buff
monster_dead_boss(State, DMonsterID, Pid) ->
	F = fun(Info) ->
			{MonsterID,BuffID,TargetID} = Info,
			if
				MonsterID =:= DMonsterID ->
					add_buff_for_monster(Pid, BuffID, TargetID, 1);
				true ->
					ok
			end
		end,
	lists:foreach(F, State#state.current_mission_dead_boss),
	State.

%% boss死亡发送世界公告
monster_dead_boss_send_msg(State, DMonsterId, UserName) -> 
	F = fun(Info) ->
			{MonsterID} = Info,
			if
				MonsterID =:= DMonsterId ->
					case data_agent:monster_template_get(MonsterID) of
				[] ->
					skip;
				MonInfo ->					
					ChatStr = ?GET_TRAN(?_LANG_NOTICE_DUPLICATE_BOSS_KILL,[UserName, MonInfo#ets_monster_template.name]),
					lib_chat:chat_sysmsg_roll([ChatStr])
			end;
				true ->
					ok
			end
		end,
	lists:foreach(F, State#state.current_mission_boss).

%%怪物死亡，给无限循环召唤
monster_dead_loop_summon(State, DMonsterID, Pid) ->
	F = fun(Info, Num) ->
			{MonsterID,DeadNum,TargetID,_TargetNum} = Info,
			if
				MonsterID =:= DMonsterID andalso DeadNum =< State#state.current_mission_dead_num ->
					summon_monster1(State, Pid, TargetID, summ_boss),
					Num + 1;
				true ->
					Num
			end
		end,
	SummonNum = lists:foldl(F, 0, State#state.current_mission_dead_loop_summon),
	if
		SummonNum > 0 ->
			State#state{current_mission_dead_num = 0};
		true ->
			State
	end.

%%采集物品获得buff(是否只有采集到的玩家才能增加buf还是全部都增加？)
collect_buff(State, TCollectID, Pid) ->
	F = fun(Info) ->
			{CollectID,HavingBuff,AddBuff} = Info,
			if
				CollectID =:= TCollectID ->
					gen_server:cast(Pid, {'add_player_buff_with_check', HavingBuff, AddBuff});
				true ->
					ok
			end
		end,
	lists:foreach(F, State#state.current_mission_collect_buff),
	State.

%%给怪物增加BUFF
add_buff_for_monster(MapPid, BuffID, MonsterID, Type) ->
	gen_server:cast(MapPid, {'add_monster_buff', Type, BuffID, MonsterID}).

%%给玩家增加buff
add_buff_for_player(State, BuffID) ->
	F = fun(UserInfo) ->
			gen_server:cast(UserInfo#dup_user_info.pid_user, {'add_player_buff', BuffID})
		end,
	lists:foreach(F, State#state.user_list).
%%获取自定玩家对象
get_user_info([],_Id) ->
	[];
get_user_info([Info|L],Id) ->
	if
		Info#dup_user_info.user_id =:= Id ->
			Info;
		true ->
			get_user_info(L,Id)
	end.
%% 用户掉线后重新连接返回副本信息
send_duplicate_info(State, Id) ->
	case get_user_info(State#state.user_list, Id) of
		[] ->
			ok;
		UserInfo ->
			Bin = get_duplicate_info(State, UserInfo),
			{StartTime,MissionIndex} = if State#state.duplicate_type =:= ?DUPLICATE_TYPE_PASS ->
												{State#state.current_mission_start_time, UserInfo#dup_user_info.mission_index};
										  State#state.duplicate_type =:= ?DUPLICATE_TYPE_FIGHT ->
												{UserInfo#dup_user_info.enter_time, UserInfo#dup_user_info.mission_index};
											true ->
												{State#state.start_time, State#state.create_mon_times}
										end,		

			{ok, DataBin} = pt_12:write(?PP_COPY_INFO, [State#state.duplicate_id, State#state.duplicate_type, MissionIndex,StartTime, Bin]),
			lib_send:send_to_sid(UserInfo#dup_user_info.pid_send, DataBin)
	end.
get_duplicate_info(State, UserInfo) ->	
	case State#state.duplicate_type of
%% 		?DUPLICATE_TYPE_NORMAL ->	%%普通副本
%% 			<<>>;
%% 		?DUPLICATE_TYPE_BATCH ->	%%分批副本
%% 			<<>>;
		?DUPLICATE_TYPE_GUARD ->	%%守护副本
			AwardBin = award_to_binary(UserInfo#dup_user_info.award_list),
			NextMonsterTime = State#state.nextmontime,
			<<AwardBin/binary,NextMonsterTime:64>>;
		?DUPLICATE_TYPE_PASS ->		%%通关副本
			AwardBin = award_to_binary(UserInfo#dup_user_info.award_list),
			KillNum = State#state.current_mission_dead_num,
			<<AwardBin/binary,KillNum:32>>;
		?DUPLICATE_TYPE_CHALLENGE ->%%试炼副本
			AwardBin = award_to_binary(UserInfo#dup_user_info.award_list),
			KillNum = State#state.current_mission_dead_num,
			<<AwardBin/binary,KillNum:32>>;
%% 		?DUPLICATE_TYPE_GUILD ->	%%公会副本
%% 			<<>>;
%% 		?DUPLICATE_TYPE_TREASURE ->	%%藏宝副本
%% 			<<>>;
		?DUPLICATE_TYPE_MONEY ->	%%打钱副本
			AwardBin = award_to_binary(UserInfo#dup_user_info.award_list),
			KillNum = State#state.current_mission_dead_num,
			S = State#state.status,
			MaxBatterNum = UserInfo#dup_user_info.max_batter_num,			
			BatterNum = UserInfo#dup_user_info.batter_num,
			BatterTime = UserInfo#dup_user_info.batter_time,
			<<AwardBin/binary,KillNum:32,S:16,MaxBatterNum:32,BatterNum:32,BatterTime:64>>;
		?DUPLICATE_TYPE_FIGHT ->		%%乱斗副本
			AwardBin = award_to_binary(UserInfo#dup_user_info.award_list),
			KillNum = State#state.current_mission_dead_num,
			<<AwardBin/binary,KillNum:32>>;
		_er ->
			<<>>
	end.
award_to_binary(List) ->
	F = fun(Info, Data) ->
			{Id, Value} = Info,
			<<Data/binary,Id:32,Value:32>>
		end,
	N = length(List),
	Award = lists:foldl(F, <<>>, List),
	<<N:16,Award/binary>>.

%%通知玩家完成的目标
update_duplicate_target(State) ->
	F = fun(Info) ->
			lib_target:cast_check_target(Info#dup_user_info.pid_user,[{?TARGET_DUPLICATE,{State#state.duplicate_id, State#state.create_mon_times}}])
		end,
	lists:foreach(F, State#state.user_list).

%% 指定时间刷出boss
relive_boss(MonsterId, Now, State, List) ->
	LoopTime_10 = 10*?LOOP_BOSS_TIME/1000,
	[{_,_,Pid}] = State#state.map_list,
	case lists:keyfind(MonsterId, 1, List) of 
		false ->
			summon_monster1(State, Pid, MonsterId, time_boss),
			NewInfo = {MonsterId, 1, Now},
			[NewInfo|List];
		Info ->
			{MonId, State1, Time} = Info,
			%% 如果当前时间大于前一次刷出时间加LoopTime_10，才能刷出怪物
			if MonId =:= MonsterId andalso State1 =:= 1 ->
				List;
			Now > Time + LoopTime_10 ->				
				summon_monster1(State, Pid, MonId, time_boss),
				NewInfo = {MonId, 1, Now},
				lists:keyreplace(MonId, 1, List, NewInfo);
			true ->
				List
			end
	end.

summon_monster_dead_num(MonsterId, State, Pid) ->
	F = fun(Info, List) ->
			{Id, Num} = Info,
			if Id =:= MonsterId ->
				{Id1, Num1} = summon_monster_mult(MonsterId, Num+1, State, Pid),
				[{Id1, Num1}|List];
			true ->
				[Info|List]
			end
		end,
	List = lists:foldl(F, [], State#state.dead_monster_list),
	State#state{dead_monster_list = List}.

summon_monster_mult(MonsterId, Num, State, Pid) ->
	case lists:keyfind(MonsterId, 1, State#state.current_mission_dead_loop_summon) of
		{MonsterID,DeadNum,TargetID,_TargetNum} ->
			if MonsterID =:= MonsterId andalso Num >= DeadNum ->
				summon_monster1(State, Pid, TargetID, summ_boss),
				{MonsterId, 0};
			true ->
				{MonsterId, Num}
			end;
		_ ->
			{MonsterId, Num}
	end.
			
	
			



