%% Author: Administrator
%% Created: 2011-6-13
%% Description: TODO: Add description to lib_free_war
-module(lib_free_war).


%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 get_born_pos/2,
		 init_free_war_map/0,
		 can_enter_map/3,
		 get_map_dic/0,
		 get_map_by_id/1,
		 get_map_player_by_map_id/1,
		 get_free_war_user_info/1,
		 enter_map_info/8,
		 quit_free_war/1,
		 kill_player/2,
		 finish_war/0,
		 refresh_day/2,
		 collect_free_war_award/1,
		 init_free_war_award/0,
		 update_player_pid/2
		]).

-define(DIC_FREE_WAR_MAP, dic_free_war_map).		%% 战斗地图字典
-define(DIC_FREE_WAR_PLAYER, dic_free_war_player).	%% 玩家字典
-define(WAR_MAX_PLAYER, 200).						%% 最大战斗人数
-define(DEFAULT_WAR_MAP, 5001).		%% 战斗地图

-define(WAR_LEAVE_TIME, 420).						%% 7分钟后才能再次进入

-define(WAR_GOD_STATE, 1).							%% 神阵
-define(WAR_DEVIL_STATE, 2).						%% 魔阵
%% -define(INIT_WAR_MAP, [{40, 60},{40, 60},{40, 60},{60, 100},{60, 100},{60, 100},{60, 100}]).	%% 实例化战场
-define(INIT_WAR_MAP, [{40, 59},{40, 59},{60, 80}]).

%% -define(WAR_GOD_RELIVE_POS, [{426,1648},{1180,518},{3186,340}]).	%% 神出生点
%% -define(WAR_DEVIL_RELIVE_POS, [{4709,2294},{4232,3251},{2140,3445}]).		%% 魔出生点
%% -define(WAR_DUPLICATE, 518001).		%% 战场副本
%%
%% API Functions
%%

%% 获取出生点
get_born_pos(WarState, Type) ->
	Index = Type rem 3 + 1,
	case WarState of
		?WAR_GOD_STATE ->
			lists:nth(Index, ?WAR_GOD_RELIVE_POS);
		_ ->
			lists:nth(Index, ?WAR_DEVIL_RELIVE_POS)
	end.

%% 实例化地图
init_free_war_map() ->
	F = fun({MinLevel, MaxLevel}) ->
				create_free_war_map(MinLevel, MaxLevel)
		end,
	lists:foreach(F, ?INIT_WAR_MAP).

init_free_war_award() ->
	F = fun(Info, List) ->
				 TempRecord = list_to_tuple([ets_free_war_award_template] ++ Info),
				case lists:keyfind({TempRecord#ets_free_war_award_template.level, TempRecord#ets_free_war_award_template.index}, 
								   #free_war_award.level_index, List) of
					false ->
%% 						Record = list_to_tuple([free_war_award] ++ [{TempRecord#ets_free_war_award_template.level, TempRecord#ets_free_war_award_template.index}, [TempRecord]]),
						LevelIndex = {TempRecord#ets_free_war_award_template.level, TempRecord#ets_free_war_award_template.index},
						Record = #free_war_award{level_index=LevelIndex, award=[TempRecord]},
						[Record|List];
					TempInfo ->
						List1 = lists:keydelete({TempRecord#ets_free_war_award_template.level, TempRecord#ets_free_war_award_template.index}, #free_war_award.level_index, List),
						NewInfo = 
							TempInfo#free_war_award{
													 award =  TempInfo#free_war_award.award ++ [TempRecord]
																},
						[NewInfo|List1]
				end
		end,
	case db_agent_template:get_free_war_award_template() of
		[] ->
			skip;
		List when is_list(List) ->
			TempList = lists:foldl(F, [], List),
			F1 = 
				fun(Record) -> 
						ets:insert(?ETS_FREE_WAR_AWARD_TEMPLATE, Record)
				end,
			lists:foreach(F1, TempList);
		_ ->
			skip
	end.

%% 创建战斗地图
create_free_war_map(MinLevel, MaxLevel) ->
	MapId= ?DEFAULT_WAR_MAP,
 	UniqueId = mod_increase:get_free_war_auto_id(),
	Id = lib_map:create_copy_id(MapId, UniqueId),
	ProcessName = misc:create_process_name(duplicate_p, [Id, 0]),
	misc:register(global, ProcessName, self()),
	{Map_pid, _} = mod_map:get_scene_pid(Id, undefined, undefined),
	
%% 	{MinLevel, MaxLevel} = get_min_max_level(Level),
	WarMap = #r_free_war_map{
							 map_only_id = Id,						%% 地图唯一Id
							 map_id = MapId,				%% 地图Id
						     map_pid = Map_pid, 					%% 地图pid
						     player_count = 0,						%% 当前人数
						     min_level = MinLevel,							%% 最小等级
						     max_level = MaxLevel,							%%  最大等级
							 god_point = 0,
							 devil_point = 0
							 },
	update_map_dic(WarMap),
	WarMap.


%% 清除玩家
clear_player_dic() ->
	put(?DIC_FREE_WAR_PLAYER, []).

%% 获取玩家列表
get_player_dic() ->
	case get(?DIC_FREE_WAR_PLAYER) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.
%% 更新玩家
update_player_dic(Info) ->
	case is_record(Info, r_free_war_user) of  
		true -> 
			List = get_player_dic(),
			NewList = 
				case lists:keyfind(Info#r_free_war_user.user_id, #r_free_war_user.user_id, List) of
					false ->
						[Info|List];
					_Old ->
						List1 = lists:keydelete(Info#r_free_war_user.user_id, #r_free_war_user.user_id, List),	
						[Info|List1]
				end,
			put(?DIC_FREE_WAR_PLAYER, NewList);
		_ ->
			?WARNING_MSG("update_dic:~w", [Info]),
			skip
	end.

%% 更新所有玩家
update_all_player_dic(List) ->
	put(?DIC_FREE_WAR_PLAYER, List).

%% 通过id获取玩家
get_player_by_id(UserId) ->
	case get_player_dic() of
		[] ->
			[];
		List ->
			case lists:keyfind(UserId, #r_free_war_user.user_id, List) of
				false ->
					[];
				Info ->
					Info
			end
	end.

%% 通过warid获取用户
get_map_player_by_map_id(WarId) ->
	List = get_player_dic(),
	F = fun(Info) ->
				if Info#r_free_war_user.war_map_id =:= WarId ->
					   true;
				   true ->
					   false
				end
		end,
	List1 = lists:filter(F, List),
%% 	FSort = fun(Info1, Info2) ->
%% 					if Info1#r_free_war_user.kill_count > Info2#r_free_war_user.kill_count ->
%% 						   true;
%% 					   true ->
%% 						   
%% 					end
%% 			end,
%% 	List2 = lists:sort(F, FSort),
	
	List1.
%% 	case length(List1)>50 of
%% 		true ->
%% 			lists:sublist(List1, 50);
%% 		_ ->
%% 			List1
%% 	end.
	
%% 用户信息,杀人被杀信息
get_free_war_user_info(UserId) ->
	case get_player_by_id(UserId) of
		[] ->
			error;
		Info ->
			KillList = get_free_war_user_info1(Info#r_free_war_user.kill_list),
			ByKillList = get_free_war_user_info1(Info#r_free_war_user.by_kill_list),
			{ok, KillList, ByKillList}
	end.
											
get_free_war_user_info1(List) ->		
	FKill = fun(KillId, KillList) ->
					case get_player_by_id(KillId) of
						[] ->
							KillList;
						KillInfo ->
							case lists:keyfind(KillId, #r_free_war_user.user_id, KillList) of
								false ->
									[KillInfo#r_free_war_user{kill_count = 1}|KillList];
								OldInfo ->		
									NewKillList = lists:keydelete(KillId, #r_free_war_user.user_id, KillList),
									NewInfo = OldInfo#r_free_war_user{kill_count = OldInfo#r_free_war_user.kill_count +1},
									[NewInfo|NewKillList]
							end
					end
			end,
	lists:foldl(FKill, [], List).

%% 清除地图字典
clear_map_dic() ->
	F = fun(Info, Acc) ->
				NewInfo = Info#r_free_war_map{
											  player_count = 0,
											  god_count = 0,
											  devil_count = 0,
											  god_point = 0,
											  devil_point = 0											  
											  },
				[NewInfo|Acc]
		end,
	
	List = get_map_dic(),
	NewList = lists:foldl(F, [], List),
	put(?DIC_FREE_WAR_MAP, NewList). 
	
%% 获取地图列表
get_map_dic() ->
	case get(?DIC_FREE_WAR_MAP) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.


%% 更新
update_map_dic(Info) ->
	case is_record(Info, r_free_war_map) of
		true ->	
			List = get_map_dic(),
			NewList = 
				case lists:keyfind(Info#r_free_war_map.map_only_id, #r_free_war_map.map_only_id, List) of
					false ->
						[Info|List];
					_Old ->
						List1 = lists:keydelete(Info#r_free_war_map.map_only_id, #r_free_war_map.map_only_id, List),	
					    [Info|List1]
				end,
			put(?DIC_FREE_WAR_MAP, NewList),
			ok;
		_ ->
			?WARNING_MSG("update_dic:~w", [Info]),
			skip
	end.

%% 通过id获取玩家
get_map_by_id(MapId) ->
	case get_map_dic() of
		[] ->
			[];
		List ->
			case lists:keyfind(MapId, #r_free_war_map.map_only_id, List) of
				false ->
					[];
				Info ->
					Info
			end
	end.

%% %% 战斗列表
%% get_free_war_list() ->
%% 	List = get_map_dic(),

%% 取得战斗地图信息
enter_map_info(WarMap, UserId, NickName, Level, ClubName, Career, PlayerPid, FlagCount) ->
	{WarState, PosX, PosY} = get_free_war_state(WarMap, FlagCount),
	enter_free_war(UserId, NickName, Level, ClubName, Career, PlayerPid, WarMap#r_free_war_map.map_only_id, WarState),
	{WarState, PosX, PosY, ?WAR_DUPLICATE}.


%% 战斗地图信息
get_free_war_state(WarMap, FlagCount) ->
	case WarMap#r_free_war_map.god_count > WarMap#r_free_war_map.devil_count of
		true ->
			Count = WarMap#r_free_war_map.devil_count + 1,
			PlayerCount = WarMap#r_free_war_map.player_count + 1,
			NewWarMap = WarMap#r_free_war_map{player_count = PlayerCount, devil_count=Count},
			update_map_dic(NewWarMap),
			{PosX, PosY} = lists:nth(FlagCount, ?WAR_DEVIL_RELIVE_POS),
			{?WAR_DEVIL_STATE, PosX, PosY};
		_ ->
			Count = WarMap#r_free_war_map.god_count + 1,
			PlayerCount = WarMap#r_free_war_map.player_count + 1,
			NewWarMap = WarMap#r_free_war_map{player_count = PlayerCount, god_count=Count},
			update_map_dic(NewWarMap),
			{PosX, PosY} = lists:nth(FlagCount, ?WAR_GOD_RELIVE_POS),
			{?WAR_GOD_STATE, PosX, PosY}
	end.

%% 能否进入
can_enter_map(WarId, UserId, Level) ->
	case get_player_by_id(UserId) of
		[] ->
			can_enter_map1(WarId, Level);
		Info ->
			Now = misc_timer:now_seconds(),
			if Now - Info#r_free_war_user.leave_time > ?WAR_LEAVE_TIME  ->
				   can_enter_map1(WarId, Level);
			   true ->
				   {error, ?_LANG_WAR_NOT_TIME}
			end
	end.

can_enter_map1(WarId, Level) ->
	
	case get_map_by_id(WarId) of
		[] ->
			{error, ?_LANG_WAR_ENTER_ERROR};
		Info ->
			if Info#r_free_war_map.player_count >= ?WAR_MAX_PLAYER ->
				   {error, ?_LANG_WAR_PLAYER_FULL};
			   Info#r_free_war_map.min_level > Level orelse Info#r_free_war_map.max_level < Level->
				   {error, ?_LANG_WAR_LEVEL_ERROR};
				true ->
					{true, Info}
			end
	end.
				
			
%% 进入战场
enter_free_war(UserId, NickName, Level, ClubName, Career, PlayerPid, OnlyMapId, WarState) ->
	Info = #r_free_war_user{user_id = UserId,
							nick_name = NickName,
							level = Level,
							club_name = ClubName,
							career = Career,
							war_map_id = OnlyMapId, 
							is_online = 1,
							war_state = WarState,
							kill_count = 0,
							leave_time = 0,
							player_pid = PlayerPid},
	{ok, DataBin} = pt_12:write(?PP_FREE_WAR_USER_LIST, [Info]),
	mod_map_agent:send_to_scene(OnlyMapId, DataBin),
	update_player_dic(Info).

%% 离开战场
quit_free_war(UserId) ->
	case get_player_by_id(UserId) of
		[] ->
			skip;
		Info when Info#r_free_war_user.is_online =:= 1 ->
			case get_map_by_id(Info#r_free_war_user.war_map_id) of
				[] ->
					skip;
				WarMap ->
					NewWarMap = 
						case Info#r_free_war_user.war_state of
							1 ->
								WarMap#r_free_war_map{
													  player_count = WarMap#r_free_war_map.player_count - 1,
													  god_count = WarMap#r_free_war_map.god_count - 1
													  };
							2 ->
								WarMap#r_free_war_map{
													  player_count = WarMap#r_free_war_map.player_count - 1,
													  devil_count = WarMap#r_free_war_map.devil_count - 1
													  };
							3 ->
								skip
						end,
					update_map_dic(NewWarMap)							
			end,
			Now = misc_timer:now_seconds(),
			NewInfo = Info#r_free_war_user{leave_time=Now, is_online=0},
			{ok, DataBin} = pt_12:write(?PP_FREE_WAR_USER_LIST, [NewInfo]),
			mod_map_agent:send_to_scene(Info#r_free_war_user.war_map_id, DataBin),
			update_player_dic(NewInfo);
		_ ->
			skip
	end.


%% 杀死玩家计数
kill_player(UserId, KillUserId) ->
	case get_player_by_id(UserId) of
		[] ->
			skip;
		Info ->
			KillList = [KillUserId|Info#r_free_war_user.kill_list],
			NewInfo = Info#r_free_war_user{kill_list=KillList, kill_count=Info#r_free_war_user.kill_count + 1},
			{ok, DataBin} = pt_12:write(?PP_FREE_WAR_USER_LIST, [NewInfo]),
			mod_map_agent:send_to_scene(Info#r_free_war_user.war_map_id, DataBin),
			update_player_dic(NewInfo),
			kill_player1(Info#r_free_war_user.war_map_id, Info#r_free_war_user.war_state)
	end,

	case get_player_by_id(KillUserId) of
		[] ->
			skip;
		KillInfo ->
			ByKillList = [UserId|KillInfo#r_free_war_user.by_kill_list],
			NewKillInfo = KillInfo#r_free_war_user{by_kill_list=ByKillList},
			update_player_dic(NewKillInfo)
	end,
	ok.

kill_player1(WarMapId, WarState) ->
	case get_map_by_id(WarMapId) of
		[] ->
			skip;
		WarMap ->
			NewWarMap = 
				case WarState of
					1 ->
						WarMap#r_free_war_map{god_point = WarMap#r_free_war_map.god_point + 1};
					2 ->
						WarMap#r_free_war_map{devil_point = WarMap#r_free_war_map.devil_point + 1};
					_ ->
						WarMap
				end,
			{ok, DataBin} = pt_12:write(?PP_FREE_WAR_RESULT, NewWarMap),
			mod_map_agent:send_to_scene(WarMapId, DataBin),
			update_map_dic(NewWarMap)	
	end.

%% 领取奖励
collect_free_war_award(UserId) ->
	case get_player_by_id(UserId) of
		[] ->
			skip;
		Info when Info#r_free_war_user.award_state =:= 1 ->
			finish_war_win(Info#r_free_war_user.level, Info#r_free_war_user.kill_count, Info#r_free_war_user.repute, Info#r_free_war_user.player_pid),
			NewInfo = Info#r_free_war_user{award_state=0},
			update_player_dic(NewInfo);
		Info when Info#r_free_war_user.award_state =:= 2 ->
			finish_war_lose(Info#r_free_war_user.level, Info#r_free_war_user.kill_count, Info#r_free_war_user.player_pid),
			NewInfo = Info#r_free_war_user{award_state=0},
			update_player_dic(NewInfo);
		Info when Info#r_free_war_user.award_state =:= 3 ->
			finish_war_draw(Info#r_free_war_user.level, Info#r_free_war_user.kill_count, Info#r_free_war_user.player_pid),
			NewInfo = Info#r_free_war_user{award_state=0},
			update_player_dic(NewInfo);
		_ ->
			skip
	end.

%% 自由战场结束
finish_war() ->
	List = get_player_dic(),
	FSort = fun(Info1, Info2) ->
					if Info1#r_free_war_user.kill_count > Info2#r_free_war_user.kill_count ->
						   true;
					   true ->
						   false
					end
			end,
	Newlist = lists:sort(FSort, List),
	
	F = fun(Info, {PlayerList, ReputeList}) ->
				case Info#r_free_war_user.is_online of
					1 ->
						{NewInfo, NewReputeList} = finish_war1(Info, ReputeList),
						{[NewInfo|PlayerList], NewReputeList};
					_ ->
						{[Info|PlayerList],ReputeList}
				end
		end, 
%% 	lists:foreach(F, PlayerList),
	{NewList1, _} = lists:foldl(F, {[],[]}, Newlist),
	update_all_player_dic(NewList1),
	clear_map_dic(),
	ok.

finish_war1(Info, ReputeList) ->
	{Repute, NewReputeList} = cacl_repute(Info#r_free_war_user.war_map_id, ReputeList),
	NewInfo = 
		case get_map_by_id(Info#r_free_war_user.war_map_id) of
			[] ->
				Info;
			WarMap when WarMap#r_free_war_map.god_point > WarMap#r_free_war_map.devil_point ->
				case  Info#r_free_war_user.war_state =:= ?WAR_GOD_STATE of
					true ->
						Info#r_free_war_user{is_online=2, award_state=1, repute=Repute};
					_ ->
						Info#r_free_war_user{is_online=2, award_state=2, repute=Repute}
				end;
			WarMap when WarMap#r_free_war_map.god_point < WarMap#r_free_war_map.devil_point ->
				case Info#r_free_war_user.war_state =:= ?WAR_DEVIL_STATE of
					true ->
						Info#r_free_war_user{is_online=2, award_state=1, repute=Repute};
					_ ->
						Info#r_free_war_user{is_online=2, award_state=2, repute=Repute}
				end;
			_ ->
				Info#r_free_war_user{is_online=2, award_state=3, repute=Repute}
		end,
	gen_server:cast(Info#r_free_war_user.player_pid, {'free_war_finish'}),
	{NewInfo,  NewReputeList}.

cacl_repute(WarId, ReputeList) ->
	case lists:keyfind(WarId, 1, ReputeList) of
		false ->
			{1, [{WarId, 1}|ReputeList]};
		Info ->
			NewList = lists:keydelete(WarId, 1, ReputeList),
			{_, Index} = Info,
			{Index + 1, [{WarId, Index + 1}|NewList]}
	end.

%% finish_war1(Info) ->
%% 	Res = 
%% 		case get_map_by_id(Info#r_free_war_user.war_map_id) of
%% 			[] ->
%% 				skip;
%% 			WarMap when WarMap#r_free_war_map.god_point > WarMap#r_free_war_map.devil_point ->
%% 				case  Info#r_free_war_user.war_state =:= ?WAR_GOD_STATE of
%% 					true ->
%% 						finish_war_win(Info#r_free_war_user.level);
%% 					_ ->
%% 						finish_war_lose(Info#r_free_war_user.level)
%% 				end;
%% 			WarMap when WarMap#r_free_war_map.god_point < WarMap#r_free_war_map.devil_point ->
%% 				case Info#r_free_war_user.war_state =:= ?WAR_DEVIL_STATE of
%% 					true ->
%% 						finish_war_win(Info#r_free_war_user.level);
%% 					_ ->
%% 						finish_war_lose(Info#r_free_war_user.level)
%% 				end;
%% 			_ ->
%% 				finish_war_draw(Info#r_free_war_user.level)
%% 		end,
%% 	case Res of
%% 		{ok, Exp, Honor} ->
%% %% 			gen_server:cast(Info#r_free_war_user.player_pid, {'add_exp_honor', Exp, Honor});
%% 			gen_server:cast(Info#r_free_war_user.player_pid, {'free_war_finish', Exp, Honor});		
%% 		_ ->
%% 			skip
%% 	end.

%% 	经验值			荣誉值
%% 胜方玩家	(500+玩家等级*100)*30*1.25 + 玩家等级*200*击杀数			200
%% 负方玩家	(500+玩家等级*100)*30*0.75 + 玩家等级*200*击杀数			100
%% 平方玩家	(500+玩家等级*100)*30*1 + 玩家等级*200*击杀数			150


%% 	经验值			荣誉值
%% 胜方玩家	(500+玩家等级*100)*45*1.25 + 玩家等级*300*击杀数			320
%% 负方玩家	(500+玩家等级*100)*45*0.75 + 玩家等级*300*击杀数			160
%% 平方玩家	(500+玩家等级*100)*45*1 + 玩家等级*300*击杀数			240

%% 胜利
finish_war_win(Level, KillCount, Repute, Pid) ->
	{Exp, Honor} =
		case Level >= 60 of
			true ->
				Key = {60, Repute},
				{tool:floor((500+Level*100)*45*1.25 + Level*300*KillCount), 320};
			_ ->
				Key = {40, Repute},
				{tool:floor((500+Level*100)*30*1.25 + Level*200*KillCount), 200}
		end,
	case data_agent:get_free_war_award(Key) of
		[] ->
			gen_server:cast(Pid, {'free_war_award', [], Exp, Honor});
		Awards  ->
			gen_server:cast(Pid, {'free_war_award', Awards#free_war_award.award, Exp, Honor})
	end,
%% 	if length(Awards) > 0 ->
%% 		   gen_server:cast(Pid, {'free_war_award', Awards, Exp, Honor});
%% 	   true ->
%% 		   skip
%% 	end,
	{ok, Exp, Honor}.
%% 失败
finish_war_lose(Level, KillCount, Pid) ->
	{Exp, Honor} =
		case Level >= 60 of
			true ->
				{tool:floor((500+Level*100)*45*0.75 + Level*300*KillCount), 160};
			_ ->
				{tool:floor((500+Level*100)*30*0.75 + Level*200*KillCount), 100}
		end,
	
	gen_server:cast(Pid, {'free_war_award', [], Exp, Honor}),
	{ok, Exp, Honor}.
%% 平手
finish_war_draw(Level, KillCount, Pid) ->
	{Exp, Honor} =
		case Level >= 60 of
			true ->
				{tool:floor((500+Level*100)*45*1 + Level*300*KillCount), 240};
			_ ->
				{tool:floor((500+Level*100)*30*1 + Level*200*KillCount), 150}
		end,
	gen_server:cast(Pid, {'free_war_award', [], Exp, Honor}),
	{ok, Exp, Honor}.

%% 隔天刷新
refresh_day(LastDate, Now) ->
	case util:is_same_date(LastDate, Now) of
		true ->
			skip;
		false ->
			refresh_day1()
	end.
refresh_day1() ->
	clear_player_dic(),
	clear_map_dic().


%% 更新进程
update_player_pid(UserId, PlayerPid) ->
	case get_player_by_id(UserId) of
		[] ->
			skip;
		Info ->
			NewInfo = Info#r_free_war_user{player_pid = PlayerPid},
			update_player_dic(NewInfo)
	end.

%%
%% Local Functions
%%

