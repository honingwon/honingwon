%% Author: Administrator
%% Created: 2011-5-4
%% Description: TODO: Add description to lib_duplicate
-module(lib_duplicate).

%%
%% Include files
%%
-include("common.hrl").

-define(DIC_USERS_DUPLICATE, dic_users_duplicate). %% 副本字典
-define(BEGIN_ID, 10000). %% 多人活动副本起始ID
-define(END_ID, 11000). %% 多人活动副本终止ID
-define(MULT_ENTER_ITEMID, 206115). %% 多人活动副本入场券ID
%%
%% Exported Functions
%% 
-export([
		 init_template_duplicate/0,
		 init_duplicate_online/1,
		 enter_duplicate/2,
		 enter_challenge_duplicate/2,
		 enter_duplicate_by_fly/3,
		 is_dead_duplicate/1,
		 off_line_duplicate/1,
		 quit_duplicate/3,
		 quit_duplicate/2,
		 quit_duplicate/1,
		 clear_duplicate_and_map/2,
		 duplicate_lottery/2,
		 send_duplicate_lottery/1,
		 save_dic/0,
		 get_dic/0,
		 update_dic/1,
		 get_duplicate_by_id/2,
		 duplicate_offline/0,
		 refresh_free_duplicate_num/3,
%% 		 refresh_repeat_duplicate/3,
		 check_user_duplicate_times/3,
 		 reset_duplicate_times/2,
		 add_duplicate_times/3,
		 quit_club_map/1
		 ]).

-export([
			get_script_info/2
			
			]).
			
%% 返回脚本中所需内容
get_script_info(Type, []) ->
	[];
get_script_info(Type, [H|L]) ->
	{T,V} = H,
	if 
		T =:= Type ->
			V;
		true ->
			get_script_info(Type, L)
	end.

%%-----------------------------------------------------------------------------
%%
%% API Functions
%%


%% 初始化副本模板
init_template_duplicate() ->
%% 	ok = init_template_duplicate_award(),
	ok = init_template_duplicate_mission(),
	ok = init_template_dupldate1(),
	ok = init_template_dynamic_mon(),
	ok.

%% 副本奖励
%% init_template_duplicate_award() ->
%% 	ok.

%%	
init_template_dynamic_mon() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_dynamic_mon_template] ++ Info),						
				ets:insert(?ETS_DYNAMIC_MON_TEMPLATE, Record)
		end,
	case db_agent_template:get_dynamic_mon_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.



%%	副本关卡
init_template_duplicate_mission() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_duplicate_mission_template] ++ Info),
				AwardList = tool:split_string_to_intlist(Record#ets_duplicate_mission_template.award_id),
				Script = tool:split_string_to_record(Record#ets_duplicate_mission_template.script),
				NewRecord = Record#ets_duplicate_mission_template{award_id = AwardList, script = Script},
				ets:insert(?ETS_DUPLICATE_MISSION_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_duplicate_mission_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.
%% 副本模板
init_template_dupldate1() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_duplicate_template] ++ Info),
				Missions = init_duplicate_mission(Record#ets_duplicate_template.mission),
				LotteryList = init_duplicate_lottery(Record#ets_duplicate_template.duplicate_id),
				
				Other = #other_duplicate_template{missions=Missions, lotterys = LotteryList},
				
				NewRecord = Record#ets_duplicate_template{other_data=Other},		
				ets:insert(?ETS_DUPLICATE_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_duplicate_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

%% 返回副本状态列表 
init_duplicate_mission(MissionIds) ->
	MissionList = string:tokens(tool:to_list(MissionIds), ","),	
	F = fun(Id, Infos) ->
				case data_agent:duplicate_template_mission_get(tool:to_integer(Id)) of
					[] ->
						Infos;
					Info ->
						[Info|Infos]
				end
		end,
	Mission = lists:foldl(F, [], MissionList),
	NewMission = lists:reverse(Mission),
	NewMission.
%% 返回副本抽奖随机信息
init_duplicate_lottery(DuplicateId) ->
	F = fun(Info, Data) ->
			[{Rate1,List1},{Rate2,List2},{Rate3,List3}] = Data,
			Record1 = list_to_tuple([ets_duplicate_lottery_template] ++ Info),			
			case Record1#ets_duplicate_lottery_template.career of
				1 ->
					NewRate = Rate1 + Record1#ets_duplicate_lottery_template.rate,
					Record = Record1#ets_duplicate_lottery_template{rate = NewRate},
					[{NewRate,[Record|List1]},{Rate2,List2},{Rate3,List3}];
				2 ->
					NewRate = Rate2 + Record1#ets_duplicate_lottery_template.rate,
					Record = Record1#ets_duplicate_lottery_template{rate = NewRate},
					[{Rate1,List1},{NewRate,[Record|List2]},{Rate3,List3}];
				3 ->
					NewRate = Rate3 + Record1#ets_duplicate_lottery_template.rate,
					Record = Record1#ets_duplicate_lottery_template{rate = NewRate},
					[{Rate1,List1},{Rate2,List2},{NewRate,[Record|List3]}];
				_ ->
					Data
			end	 
		end,
	case db_agent_template:get_duplicate_lottery_template(DuplicateId) of
		[] ->
			skip;
		List when is_list(List) ->
			[{TRate1,TList1},{TRate2,TList2},{TRate3,TList3}] = lists:foldl(F, [{0,[]},{0,[]},{0,[]}], List),
			NTList1 = lists:reverse(TList1),
			NTList2 = lists:reverse(TList2),
			NTList3 = lists:reverse(TList3),
			[{TRate1,NTList1},{TRate2,NTList2},{TRate3,NTList3}];
		_ ->
			skip
	end.

%% 初始化玩家在线副本
init_duplicate_online(UserId) ->
	%%Now = misc_timer:now_seconds(),
	F = fun(Info, Acc) ->
				Record = list_to_tuple([ets_users_duplicate] ++ Info),					
				case data_agent:duplicate_template_get(Record#ets_users_duplicate.duplicate_id) of
					[] ->
						Acc;
				_Template ->
						%% 隔天副本信息刷新(与福利经验一起处理)
								Other = #other_duplicate{},
								NewRecord = Record#ets_users_duplicate{other_data=Other},
								[NewRecord|Acc]
				end
		end,
	case db_agent_duplicate:get_user_duplicate_by_id(UserId) of
		[] ->
			put(?DIC_USERS_DUPLICATE, []);
		List when is_list(List) ->
			NewList = lists:foldl(F, [], List),
			put(?DIC_USERS_DUPLICATE, NewList);
	
		_ ->
			put(?DIC_USERS_DUPLICATE, [])
	end,
	ok.
		
%% 进入副本
enter_duplicate(PlayerStatus, DuplicateId) ->
%% 	?DEBUG("dhwang_test--DuplicateId:~p",[DuplicateId]),
	case data_agent:duplicate_template_get(DuplicateId) of
		[] ->
			skip;
		Template ->
			enter_duplicate2(PlayerStatus, Template, DuplicateId, 1)
	end.
%% 进入试炼副本
enter_challenge_duplicate(PlayerStatus, MissionIndex) ->
	case data_agent:duplicate_template_get(?CHALLENGE_DUPLICATE_ID) of
		[] ->
			skip;
		Template ->
			if
				PlayerStatus#ets_users.level < Template#ets_duplicate_template.min_level orelse
					PlayerStatus#ets_users.level > Template#ets_duplicate_template.max_level ->
						{ok,Data} = pt_12:write(?PP_ENTER_CHALLENGE_BOSS, [0,?ER_NOT_ENOUGH_LEVEL]),
						lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Data),
						skip;
				true ->
					enter_duplicate1(PlayerStatus, Template, ?CHALLENGE_DUPLICATE_ID, MissionIndex)
			end
	end.

%% 直接传送进入副本
enter_duplicate_by_fly(PlayerStatus, DuplicateId, MissionId) ->
	case PlayerStatus#ets_users.darts_left_time < 1 of%%运镖期间不能进入副本
		true ->
			case enter_duplicate_for_GM(PlayerStatus, DuplicateId, MissionId)of
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
					NewStatus = PlayerStatus#ets_users{current_map_id=OnlyMapId,
											   pos_x=X,
											   pos_y=Y,
							   				   old_map_id = OldMapId,
											   old_pos_x = OldX,
											   old_pos_y = OldY,
											   other_data=Other},
					NewStatus1 = lib_player:calc_speed(NewStatus, 0),
					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [MapId, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
			
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, DuplicateId),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, ReturnData),	
					
%% 					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus1]),
%% 					mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
%% 									  				NewStatus1#ets_users.pos_x,
%% 									  				NewStatus1#ets_users.pos_y,
%% 									  				PlayerData,
%% 									  				undefined),
			
					{update_map, NewStatus1};
				_ ->
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, -1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData),	
					{ok, PlayerStatus}
			end;
		_ ->
			{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, -1),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ReturnData),
			{ok, PlayerStatus}
	end.
enter_duplicate_for_GM(PlayerStatus, DuplicateId, MissionId) ->
%% 	?DEBUG("dhwang_test--GM_DuplicateId:~p",[DuplicateId]),
	case data_agent:duplicate_template_get(DuplicateId) of
		[] ->
			skip;
		Template ->
			enter_duplicate1(PlayerStatus, Template, DuplicateId, MissionId)
	end.

enter_duplicate2(PlayerStatus, Template, DuplicateId, MissionId) ->
	if
		PlayerStatus#ets_users.level < Template#ets_duplicate_template.min_level orelse
					PlayerStatus#ets_users.level > Template#ets_duplicate_template.max_level
					orelse Template#ets_duplicate_template.type =:= ?DUPLICATE_TYPE_TREASURE  ->
			error;
		true ->
			%%检查玩家进入次数
			%case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_duplicate, 
			%					{'check_user_duplicate', {DuplicateId,Template#ets_duplicate_template.day_times}}) of
			case lib_duplicate:check_user_duplicate_times(PlayerStatus#ets_users.id,DuplicateId,Template#ets_duplicate_template.day_times) of
				ok ->
					enter_duplicate1(PlayerStatus, Template, DuplicateId, MissionId);
				_ ->
					?DEBUG("not enough tiems:~p",[1]),
					error
			end
	end.

enter_duplicate1(PlayerStatus, Template, DuplicateId, MIndex) ->
	MissionIndex = if
					length(Template#ets_duplicate_template.other_data#other_duplicate_template.missions) < MIndex ->
						1;
					true ->
						MIndex
				end,
	Mission = lists:nth(MissionIndex, Template#ets_duplicate_template.other_data#other_duplicate_template.missions),
	MapId = Mission#ets_duplicate_mission_template.map_id,		 
	Result = 
		case misc:is_process_alive(PlayerStatus#ets_users.other_data#user_other.pid_team) of
			true ->
				if
					Template#ets_duplicate_template.max_player > 1 ->
						case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_team, {create_duplicate,
										  Mission#ets_duplicate_mission_template.map_id,
										  Template#ets_duplicate_template.duplicate_id,
										  MissionIndex,
										  Template#ets_duplicate_template.name,
										  {PlayerStatus#ets_users.id, PlayerStatus#ets_users.nick_name,PlayerStatus#ets_users.sex,PlayerStatus#ets_users.vip_id},
										  self(),
								          PlayerStatus#ets_users.other_data#user_other.pid_send})  of
							{ok, Pid} ->																
								{ok, Pid, MapId};
							{ok, Pid, List} ->
								{ok, Pid, MapId, List};
							
							_ ->
								?DEBUG("not enough tiems:~p",[2]),
								error
						end;
					true ->
						lib_chat:chat_sysmsg([PlayerStatus#ets_users.id, ?FLOAT, ?None, ?ORANGE, ?_LANG_ONLY_SINGLE_ENTER]),
						?DEBUG("not enough tiems:~p",[3]),
						error										
				end;
			
			_ ->
				if
					Template#ets_duplicate_template.max_player > 1 andalso Template#ets_duplicate_template.type =/= ?DUPLICATE_TYPE_FIGHT->
						?DEBUG("not enough player:~p",[4]),
						error;
					Template#ets_duplicate_template.type =:= ?DUPLICATE_TYPE_FIGHT ->
						next;
					true ->
						{ok, Pid} = mod_duplicate:start(undefined,
														PlayerStatus#ets_users.id,
														MapId,
														{PlayerStatus#ets_users.id,
														 PlayerStatus#ets_users.nick_name,
														 PlayerStatus#ets_users.other_data#user_other.pid,
														 PlayerStatus#ets_users.other_data#user_other.pid_send,
														 PlayerStatus#ets_users.vip_id,
														 PlayerStatus#ets_users.sex},
														 DuplicateId,
														 MissionIndex,
														 PlayerStatus#ets_users.level),
						{ok, Pid, MapId}
				end
		end,

	Result1 = 
	if Template#ets_duplicate_template.type =:= ?DUPLICATE_TYPE_FIGHT ->
		case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'check_and_reduce_item_to_users', ?MULT_ENTER_ITEMID, ?CONSUME_ITEM_USE}) of
			false ->
				?DEBUG("not enough tiems:~p",[1111111111]),
				error;
			true ->
				case mod_duplicate:enter_mult_duplicate([PlayerStatus#ets_users.id,
												MapId,
												{PlayerStatus#ets_users.id,
												PlayerStatus#ets_users.nick_name,
												PlayerStatus#ets_users.other_data#user_other.pid,
												PlayerStatus#ets_users.other_data#user_other.pid_send,
												PlayerStatus#ets_users.vip_id,
												PlayerStatus#ets_users.sex},
												DuplicateId,
												MissionIndex,
												PlayerStatus#ets_users.level]) of
					{_, Pid1} ->																
						{ok, Pid1, MapId};
					_ ->
						%% 如果未进副本，则返还入场券
						gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'add_item', ?MULT_ENTER_ITEMID, 1, ?BIND, ?CONSUME_ITEM_USE}),
						?DEBUG("not enough tiems:~p",[2]),
						error
				end
		end;
	true ->
		Result
	end,
	
	case Result1 of
		{ok, Pid_dup, MapId} ->
			 enter_duplicate_map(PlayerStatus, Pid_dup, Mission, DuplicateId, []);
		
		{ok, Pid_dup, MapId, NewList} ->
			 enter_duplicate_map(PlayerStatus, Pid_dup, Mission, DuplicateId, NewList);
		_ ->
			?DEBUG("not enough tiems:~p",[5]),
			ok
	end.

enter_duplicate_map(PlayerStatus, Pid_dup, Mission, DuplicateId, List) -> 
	case gen_server:call(Pid_dup, {'enter'}) of
		{ok, Map_pid, Id, MapId} ->
			%%增加进入副本次数
			%gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_duplicate, {'add_duplicate_times', DuplicateId}),
			%移到pp_map handle(pp_enter_duplicate)
			
			%%假如是队长 发送给队伍中其他人
			case List of
				[] ->
					skip;
				[TeamPid, UserId, DuplicateId, DuplicateName] ->
					gen_server:cast(TeamPid, {'send_to_teammate_enter', UserId, DuplicateId, DuplicateName})
			end,
			
			%Mission#ets_duplicate_mission_template.map_id
			{ok, Map_pid, Pid_dup, Id, MapId,
			  Mission#ets_duplicate_mission_template.pos_x, Mission#ets_duplicate_mission_template.pos_y};
		_ ->
			skip
	end.

%% 登陆时判断副本是否存活
is_dead_duplicate(MapId) ->
	case lib_map:is_copy_scene(MapId) of
		true ->
			%%true;
		    ProcessName = misc:create_process_name(duplicate_p, [MapId, 0]),			
		    case misc:whereis_name({global, ProcessName}) of
			    undefined ->
		 		    false;
	      	    Pid ->
		    		Pid
		    end;
	    _ ->
		    not_duplicate
	end.

%% 下线离开副本
off_line_duplicate(DupPid, UserId, MapId) ->
	case lib_map:is_copy_scene(MapId) of
		true when is_pid(DupPid) =:= true ->
			gen_server:cast(DupPid, {'off_line', UserId});
		_ ->
			ok
	end.
off_line_duplicate(PlayerStatus) ->
	if
		is_pid(PlayerStatus#ets_users.other_data#user_other.pid_dungeon) ->
			off_line_duplicate1(PlayerStatus);
		true ->
			ActiveId = PlayerStatus#ets_users.other_data#user_other.active_id,
			if%%判断是否活动报名了，就退出报名
				ActiveId > 0 ->
					Active_Pid = mod_active:get_active_pid(),
					gen_server:cast(Active_Pid, {quit_active, ActiveId, undefine,PlayerStatus#ets_users.id});
				true ->
					ok
			end,
			PlayerStatus
	end.

off_line_duplicate1(PlayerStatus) ->
	DupPid = PlayerStatus#ets_users.other_data#user_other.pid_dungeon,
	UserId = PlayerStatus#ets_users.id,
	MapId = PlayerStatus#ets_users.current_map_id,
	
	off_line_duplicate(DupPid, UserId, MapId),
	
	Duplicate_id = PlayerStatus#ets_users.other_data#user_other.duplicate_id,
	case data_agent:duplicate_template_get(Duplicate_id) of
		[] ->
			ok; 
		_DuplicateTemp ->
			mod_map:leave_scene(PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id,
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
						        PlayerStatus#ets_users.pos_x,
						        PlayerStatus#ets_users.pos_y,
						        PlayerStatus#ets_users.other_data#user_other.pid,
						        PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
			Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined,
																 pid_map = undefined,
														 		pid_dungeon=undefined,
														 		map_template_id = 0,
														 		duplicate_id = 0,
														 		war_state = 0},
			NewStatus = PlayerStatus#ets_users{other_data=Other},
	        {ok, NewStatus}
	end.

%% 离开副本
quit_duplicate(DupPid, UserId, MapId) ->
	IsWar = lib_map:is_copy_war(MapId),
	case lib_map:is_copy_scene(MapId) of
		true when is_pid(DupPid) =:= true ->
			gen_server:cast(DupPid, {'dup_quit', UserId});
		true when IsWar =:= true ->
			mod_free_war:quit_free_war(UserId);
		_ ->
			skip
	end.

quit_duplicate(PlayerStatus) ->
	if
		PlayerStatus#ets_users.current_hp < 1 
			andalso PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?DUPLICATE_PVP1_MAP_ID ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
			NewStatus = PlayerStatus#ets_users{current_hp = PlayerStatus#ets_users.other_data#user_other.total_hp,
										 current_mp = PlayerStatus#ets_users.other_data#user_other.total_mp,
										 other_data = OtherData},
			{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [NewStatus#ets_users.id, NewStatus#ets_users.current_hp, NewStatus#ets_users.current_mp]),
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, BinData);   			
		true ->
			NewStatus = PlayerStatus
	end,
	quit_duplicate(NewStatus, 0).


quit_duplicate(PlayerStatus, _Type) ->
	DupPid = PlayerStatus#ets_users.other_data#user_other.pid_dungeon,
	UserId = PlayerStatus#ets_users.id,
	MapId = PlayerStatus#ets_users.current_map_id,

	case lib_map:get_map_type(MapId) of%%只获取打钱副本的奖励
		?DUPLICATE_TYPE_MONEY ->
			{MissionNum,AwardList} = gen_server:call(DupPid, {get_award_list, UserId});
		?DUPLICATE_TYPE_GUARD ->
			{MissionNum,AwardList} = gen_server:call(DupPid, {get_award_list, UserId});
		?DUPLICATE_TYPE_PASS ->
			{MissionNum,AwardList} = gen_server:call(DupPid, {get_award_list, UserId});
		_ ->
			{MissionNum,AwardList} = {1,[]}
	end,
	%?DEBUG("quit_duplicate:~p",[{MapId,MissionNum}]),

	lib_duplicate:quit_duplicate(DupPid, UserId, MapId),
	
	Duplicate_id = PlayerStatus#ets_users.other_data#user_other.duplicate_id,
	case data_agent:duplicate_template_get(Duplicate_id) of
		[] ->
			ok; 
		DuplicateTemp ->
			mod_map:leave_scene(PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id,
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
						        PlayerStatus#ets_users.pos_x,
						        PlayerStatus#ets_users.pos_y,
						        PlayerStatus#ets_users.other_data#user_other.pid,
						        PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
			Active_Id = if PlayerStatus#ets_users.other_data#user_other.active_id =:= ?PVP1_ACTIVE_ID 
							andalso PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?DUPLICATE_PVP1_MAP_ID ->
					0;
				true ->
					PlayerStatus#ets_users.other_data#user_other.active_id
			end,
			Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined,
																 pid_map = undefined,
														 		pid_dungeon=undefined,
														 		map_template_id = PlayerStatus#ets_users.old_map_id,
														 		duplicate_id = 0,
																active_id = Active_Id,
														 		war_state = 0},

			{OldMapId,OldX,OldY} = case PlayerStatus#ets_users.old_map_id of
						0 ->
							{DuplicateTemp#ets_duplicate_template.map_id,DuplicateTemp#ets_duplicate_template.pos_x,DuplicateTemp#ets_duplicate_template.pos_y};
						_ ->
							{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y}
			end,
			
			NewStatus = PlayerStatus#ets_users{current_map_id=OldMapId,
											   pos_x=OldX,
									           pos_y=OldY,
									           other_data=Other},			

			{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewStatus#ets_users.current_map_id, NewStatus#ets_users.pos_x, NewStatus#ets_users.pos_y]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, EnterData),
			%?DEBUG("quit_duplicate:~p",[Duplicate_id,MissionNum]),
			lib_target:cast_check_target(NewStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_DUPLICATE_TIMERS,{Duplicate_id,1}}]),
			{ok, ReturnData} = pt_12:write(?PP_QUIT_DUPLICATE, [Duplicate_id,MissionNum,AwardList]),
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, ReturnData),
			
			
			%% 移除副本BUFF
			NewStatus1 = lib_buff:remove_buff(NewStatus,1),
	        {ok, NewStatus1}
	end.
	
%%退出帮派地图
quit_club_map(PlayerStatus) ->
%% 	case  erlang:is_pid(PlayerStatus#ets_users.other_data#user_other.pid_guild_map) of
	case PlayerStatus#ets_users.current_map_id =:= PlayerStatus#ets_users.other_data#user_other.guild_map_id of
		true ->
			mod_map:leave_scene(PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.other_data#user_other.pet_id,
						        PlayerStatus#ets_users.current_map_id,
						        PlayerStatus#ets_users.other_data#user_other.pid_map,
						        PlayerStatus#ets_users.pos_x,
						        PlayerStatus#ets_users.pos_y,
						        PlayerStatus#ets_users.other_data#user_other.pid,
						        PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),

			Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined,
																 pid_map = undefined,
																 war_state = 0,
%% 																 pid_guild_map=undefined,																
%% 																 guild_map_id=0,
																 map_template_id=PlayerStatus#ets_users.old_map_id
																},
			NewStatus = PlayerStatus#ets_users{current_map_id= PlayerStatus#ets_users.old_map_id,
											   pos_x=PlayerStatus#ets_users.old_pos_x,
									           pos_y=PlayerStatus#ets_users.old_pos_y,											   
%%											   pk_mode = ?PKMode_GOODNESS,
									           other_data=Other},
			{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewStatus#ets_users.current_map_id, NewStatus#ets_users.pos_x, NewStatus#ets_users.pos_y]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, EnterData),
	
%%			{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_GOODNESS, misc_timer:now_seconds()]),
%%			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, BinData),
			
	        {ok, Bin} = pt_21:write(?PP_CLUB_LEAVE_SCENCE, [1]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{ok, NewStatus};
		
		_ ->
			{error}
	end.
%% 通知客户段有副本抽奖还没有抽取
send_duplicate_lottery(Status) ->
	DuplicateId = Status#ets_users.lottery_duplicate_id,
	if
		DuplicateId > 0 ->
			{ok, BinData} = pt_12:write(?PP_COPY_LOTTERY, [DuplicateId,0,0]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData);
		true ->
			ok
	end.

%% 副本结束抽奖
duplicate_lottery(DuplicateId,Status)->
	{ItemId,Num,IsBind} = case data_agent:duplicate_template_get(DuplicateId) of
		[] ->
			{0,0,1};
		DupTemp ->
			case DupTemp#ets_duplicate_template.other_data#other_duplicate_template.lotterys of
				[] ->
					{0,0,2};
				List when length(List) =:= 3 ->
					{RateCount,LotteryList} = lists:nth(Status#ets_users.career, List),
					Rate = util:rand(0,RateCount),
					get_duplicate_lottery_item(LotteryList,Rate);
				_ ->
					{0,0,3}
			end
	end,
	if
		ItemId =:= 0 ->
			{ok, BinData} = pt_12:write(?PP_COPY_LOTTERY, [0,0,IsBind]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),
			Status#ets_users{lottery_duplicate_id = 0};
		true ->
			{ok, BinData} = pt_12:write(?PP_COPY_LOTTERY, [DuplicateId,ItemId,Num]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),
			gen_server:cast(Status#ets_users.other_data#user_other.pid_item, {'add_item',ItemId,Num,IsBind,?ITEM_PICK_LOTTERY}),
			Status#ets_users{lottery_duplicate_id = 0}
	end.

get_duplicate_lottery_item([],_) ->
	{0,0,0};
get_duplicate_lottery_item([H|L], Rate) ->
	if
		H#ets_duplicate_lottery_template.rate >= Rate ->
			{H#ets_duplicate_lottery_template.item_id, H#ets_duplicate_lottery_template.amount, H#ets_duplicate_lottery_template.is_bind};
		true ->
			get_duplicate_lottery_item(L, Rate)
	end.
	
%% 清除副本地图
clear_duplicate_and_map(TeamPid, MapList) ->
	gen_server:cast(TeamPid, {'clear_dup'}),
	F = fun(Info) ->
			{_,_,MapPid} = Info,
			gen_server:cast(MapPid, {stop, duplicate_finish})
		end,
	lists:foreach(F, MapList).

%% 检查进入副本次数
check_user_duplicate_times(UserId, DuplicateId,Times) ->
	case get_duplicate_by_id(UserId, DuplicateId) of
		[] ->
			ok;
		Info ->
			if
				Info#ets_users_duplicate.today_num >= Times ->
					error;
				true ->
					ok
			end
	end.

%% 增加进入副本次数
add_duplicate_times(UserId, DuplicateId,Times) ->
	Now = misc_timer:now_seconds(),
	case get_duplicate_by_id(UserId, DuplicateId) of
		[] ->
			%Template = data_agent:duplicate_template_get(DuplicateId),
			%%Sum_num = Template#ets_duplicate_template.day_times,
		
			Info = #ets_users_duplicate{user_id=UserId,
										duplicate_id=DuplicateId,
										sum_num = Times,
										today_num = Times,
										last_time=Now,
										other_data=#other_duplicate{}},
			update_dic({Info,true});
		
		Info ->
			NewInfo = Info#ets_users_duplicate{today_num = Info#ets_users_duplicate.today_num + Times,
												sum_num = Info#ets_users_duplicate.sum_num + Times,
											   last_time = Now},
			
			update_dic({NewInfo,true})
	end.

reset_duplicate_times(UserId, DuplicateId) ->
	Now = misc_timer:now_seconds(),
	%case DuplicateId of
	%	?DUPLICATE_ZTG_ID ->
			case get_duplicate_by_id(UserId, DuplicateId) of
				[] ->
					{error, ?ER_WRONG_VALUE};
				Info when Info#ets_users_duplicate.reset_num > 0 ->
					{error, ?ER_LIMIT_RESET_NUM};
				Info when Info#ets_users_duplicate.today_num > 0 ->
					NewInfo = Info#ets_users_duplicate{today_num = Info#ets_users_duplicate.today_num - 1,
														reset_num = Info#ets_users_duplicate.reset_num + 1,
											   			last_time = Now},
					update_dic({NewInfo,true}),
					{ok, Info#ets_users_duplicate.today_num};
				_ ->
					{error, ?ER_NOT_ENTER_DUPLICATE}
			end.
	%	_ ->
	%		{error, ?ER_WRONG_VALUE}
	%end.

%% 玩家副本进程退出
duplicate_offline() ->
	save_dic(),
	erase(?DIC_USERS_DUPLICATE),
    ok.

%%
%% Local Functions
%%


%%	----------------------------辅助方法-----------------------
%% 获取副本列表
get_dic() ->
	case get(?DIC_USERS_DUPLICATE) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.


save_dic() ->
	List = get_dic(),
	save_dic1(List, []).

save_dic1([], NewList) ->
	put(?DIC_USERS_DUPLICATE, NewList),
	NewList;
save_dic1([Info|List], NewList) ->
	NewInfo =
		case Info#ets_users_duplicate.other_data#other_duplicate.dirty_state of
			2 ->	
				db_agent_duplicate:add_duplicate(Info),
				Other = Info#ets_users_duplicate.other_data#other_duplicate{dirty_state = 0},
				Info#ets_users_duplicate{other_data=Other};
			1 ->
				db_agent_duplicate:update_duplicate(Info),
				Other = Info#ets_users_duplicate.other_data#other_duplicate{dirty_state = 0},								
				Info#ets_users_duplicate{other_data=Other};
			_ ->
				Info
		end,
	
	save_dic1(List, [NewInfo|NewList]).
			

%% 更新
update_dic({Info, NeedCast}) ->
	case is_record(Info, ets_users_duplicate) of
		true ->
			List = get_dic(),
			NewList = 
				case lists:keyfind(Info#ets_users_duplicate.duplicate_id, #ets_users_duplicate.duplicate_id, List) of
					false ->						
						Other = Info#ets_users_duplicate.other_data#other_duplicate{dirty_state=2},
						NewInfo = Info#ets_users_duplicate{other_data=Other},
						[NewInfo|List];
					
					Old when  Old#ets_users_duplicate.other_data#other_duplicate.dirty_state < 1 ->
						List1 = lists:keydelete(Info#ets_users_duplicate.duplicate_id, #ets_users_duplicate.duplicate_id, List),
						Other = Info#ets_users_duplicate.other_data#other_duplicate{dirty_state=1},
						NewInfo = Info#ets_users_duplicate{other_data=Other},
						[NewInfo|List1];
					
					Old ->
						List1 = lists:keydelete(Info#ets_users_duplicate.duplicate_id, #ets_users_duplicate.duplicate_id, List),
						Other = #other_duplicate{dirty_state = Old#ets_users_duplicate.other_data#other_duplicate.dirty_state},
						NewInfo = Info#ets_users_duplicate{other_data=Other},			
						[NewInfo|List1]
				end,
			%?DEBUG("update_dic(:~p",[NewList]),
			put(?DIC_USERS_DUPLICATE, NewList),
			%% 如果是限制进入副本需要更新副本进入次数
			if
				NeedCast =:= true ->
					gen_server:cast(self(),{'update_copy_enter_count', [Info]});
				true ->
					ok
			end,
			ok;
		_ ->
			?WARNING_MSG("update_dic:~w", [Info]),
			skip
	end.



%% 通过玩家和副本id获取副本
get_duplicate_by_id(_UserId, DuplicateId) ->
	case get_dic() of
		[] ->
			[];
		List ->
			case lists:keyfind(DuplicateId, #ets_users_duplicate.duplicate_id, List) of
				false ->
					[];
				Info ->
					Info
			end
	end.

%%%-------------------------副本商店数据更新-------------------------------


%% %% -------------------------隔天副本刷新--------------------------------
refresh_free_duplicate_num(TDays,Now,Level) ->
	%TDays = util:get_diff_days(LastData,Now),
	case TDays > 0 of
		true ->
			{NewNum, NewNum1} = refresh_free_duplicate_num1(Level, TDays, Now),
			{NewNum, NewNum1};
		false ->
			false
	end.

refresh_free_duplicate_num1(Level, TDays, Now) ->	
	F = fun(Info) ->
			NewInfo = Info#ets_users_duplicate{today_num = 0, reset_num = 0, last_time = Now},
			update_dic({NewInfo,true})
		end,	
	case get_dic() of
		[] ->
			refresh_free_duplicate_num2([],Level,TDays);
		List ->
			lists:foreach(F, List),
			refresh_free_duplicate_num2(List,Level,TDays)
	end.

refresh_free_duplicate_num2(List,Level,TDays) ->
	List1 = ets:tab2list(?ETS_DUPLICATE_TEMPLATE),
	F = fun(Info,{LeaveNum,LeaveNum1}) ->
			if				
				Info#ets_duplicate_template.type > 4 orelse Info#ets_duplicate_template.min_level > Level ->
					{LeaveNum,LeaveNum1};
				Info#ets_duplicate_template.max_player > 1 ->
					N = refresh_free_duplicate_num3(List,Info),
					{LeaveNum, LeaveNum1 + Info#ets_duplicate_template.day_times * TDays - N};
				true ->
					N = refresh_free_duplicate_num3(List,Info),
					{LeaveNum + Info#ets_duplicate_template.day_times * TDays - N, LeaveNum1}
			end
		end,
	lists:foldl(F, {0,0}, List1).

refresh_free_duplicate_num3([],_Info) ->
	0;
refresh_free_duplicate_num3([H|L],Info) ->
	if
		H#ets_users_duplicate.duplicate_id =:= Info#ets_duplicate_template.duplicate_id ->
			H#ets_users_duplicate.today_num;
		true ->
			refresh_free_duplicate_num3(L,Info)
	end.

%% refresh_repeat_duplicate(UserId, LastDate, Now) ->
%% 	case util:is_same_date(LastDate, Now) of
%% 		true ->
%% 			skip;
%% 		false ->
%% 			refresh_repeat_duplicate1(UserId, Now)
%% 	end.
%% 	
%% refresh_repeat_duplicate1(_UserId, Now) ->
%% 	case get_dic() of
%% 		[] ->
%% 			skip;
%% 		List ->
%% 			refresh_repeat_duplicate2(List, Now)
%% 	end.
%% 
%% refresh_repeat_duplicate2(List, Now) ->
%% 	F = fun(Info, {DuplicateList,LeaveNum,LeaveNum1}) ->
%% 				?DEBUG("refresh_repeat_duplicate2:~p",[{LeaveNum,LeaveNum1}]),
%% 				case refresh_repeat_duplicate3(Info, Now) of
%% 					{ok, NewInfo} ->
%% 						{[NewInfo | DuplicateList],LeaveNum,LeaveNum1};
%% 					{Num,Num1} ->
%% 						{DuplicateList,LeaveNum + Num,LeaveNum1 + Num1};
%% 					_ ->
%% 						{DuplicateList,LeaveNum,LeaveNum1}
%% 				end
%% 		end,
%% 	{_NewList, NewNum, NewNum1} = lists:foldl(F, {[],0,0}, List),
%% 	%{ok, NewList, NewNum, NewNum1}.
%% 	?DEBUG("refresh_repeat_duplicate:~p",[{_NewList, NewNum, NewNum1}]),
%% 	{ok, NewNum, NewNum1}.
%% 				
%% refresh_repeat_duplicate3(Info, Now) ->%%当重置进入副本次数的时候将副本未使用次数返回
%% 	LastDay = misc_timer:get_day(Info#ets_users_duplicate.last_time),
%% 	Day = misc_timer:get_day(Now),
%% 	TDays = Day - LastDay,
%% 	if
%% 		TDays > 0 ->
%% 			case data_agent:duplicate_template_get(Info#ets_users_duplicate.duplicate_id) of
%% 				Template when is_record(Template, ets_duplicate_template) =:= true ->
%% 					if
%% 						%%隔天刷新
%% 						Template#ets_duplicate_template.can_reset =/= 1 ->
%% 							{ok, Info};
%% 						true ->
%% 							if
%% 								Info#ets_users_duplicate.today_num > 0 ->
%% 									NewInfo = Info#ets_users_duplicate{today_num = 0,last_time = Now},
%% 									update_dic({NewInfo,true});									
%% 								true ->
%% 									NewInfo = Info#ets_users_duplicate{last_time = Now},
%% 									update_dic({NewInfo,false})				
%% 							end,
%% 							if
%% 								Template#ets_duplicate_template.max_player > 1 ->
%% 									{0,Template#ets_duplicate_template.day_times * TDays - Info#ets_users_duplicate.today_num};
%% 								true ->
%% 									{Template#ets_duplicate_template.day_times * TDays - Info#ets_users_duplicate.today_num,0}
%% 							end
%% 					end;
%% 				_ ->
%% 					false
%% 			end;
%% 		true ->
%% 			skip
%% 	end.


			 
			
