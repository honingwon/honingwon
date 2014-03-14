%% Author: Administrator
%% Created: 2011-3-5
%% Description: TODO: Add description to lib_map
-module(lib_map).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
 
-define(SLICEWIDTH, 500).
-define(SLICEHEIGHT, 300).
-define(DROP_ITEM_GET_RANGE,160).				%拾取距离
-define(DROP_ITEM_CHANGE_UNLOCK, 30).			%掉落物从掉落开始计算，更新为自由拾取时间，单位秒
-define(DROP_ITEM_CHANGE_DELETE, 60).			%掉落物从掉落开始计算，更新为删除时间，单位秒
-define(GRID_LENGTH, 40).						%格子宽度


-define(DIC_DROP_AUTO_ID, dic_drop_auto_id).	%% 掉落物品自增id

-define(DUPLICATE_DROP_GOLD_POS_LIST, [{1514,1248},{1585,1219},{1548,1321},{1633,1322},{1652,1247},{1934,1247},{1902,1313},{1802,1249},{1869,1245},{1587,1281},
{1839,1314},{1497,1408},{1666,1406},{1538,1471},{1625,1472},{1584,1408},{1303,1269},{1236,1269},{1334,1328},{1824,1420},
{1367,1270},{1262,1325},{1538,1141},{1584,1086},{1684,1146},{1652,1086},{1617,1142},{1853,1042},{1927,977},{1305,1412},
{1946,1101},{1977,1035},{2059,1051},{2040,1129},{2143,1107},{2108,1180},{2179,1211},{2226,1154},{2263,1219},{1358,1138},
{2270,1295},{2245,1365},{2177,1346},{2181,1441},{2092,1412},{2099,1493},{2053,1545},{2001,1469},{1958,1546},{1846,1139},
{1960,1608},{1905,1492},{1825,1557},{1866,1635},{1763,1658},{1714,1587},{1645,1625},{1668,1702},{1578,1717},{2200,1282},
{1478,1703},{1491,1623},{1393,1578},{1385,1668},{1290,1639},{1306,1556},{1241,1499},{1188,1603},{1163,1525},{1573,1639},
{1154,1443},{1072,1448},{1077,1539},{1001,1482},{1025,1372},{942,1398},{930,1298},{953,1199},{1004,1240},{990,1314},
{1082,1204},{1034,1124},{1123,1113},{1222,1131},{1237,1064},{1156,1037},{1272,973},{1337,1043},{1424,1019},{1635,959},
{1357,943},{1455,915},{1526,969},{1551,886},{1650,880},{1704,948},{1757,895},{1765,1020},{1853,936}]).

-define(GUILD_RAID_ACTIVE_AWARD_ITEM_ID, 9201).	%%公会突袭活动奖励宝箱采集
-define(GUILD_RAID_ACTIVE_AWARD_POS_LIST,[{2430,1445},{2536,1938},{3330,1645},{3030,1645},{3138,1948},{2830,1545},{3330,1545},{2930,1845},{3326,1843},{2630,1845},{2530,1545},{3230,1745},
{2730,1245},{2930,1445},{3036,1946},{2430,1645},{2130,1845},{2730,1345},{3030,1345},{2936,1946},{2830,1745},{2830,1845},{2030,1645},{2726,1934},
{2730,1445},{2726,2034},{2930,1545},{2230,1545},{3026,1843},{2730,1645},{2626,1934},{3130,1445},{2530,1345},{3130,1745},{2826,2034},{2130,1545},
{2230,1445},{2938,2028},{2230,1745},{2138,1940},{2530,1245},{3230,1445},{2330,1845},{3030,1445},{2630,1745},{2330,1545},{2830,1445},{2630,1545},
{2130,1445},{2630,1445},{3030,1745},{3430,1645},{2630,1645},{3230,1645},{2730,1545},{2730,1845},{3426,1843},{3130,1645},{2730,1745},{3330,1745},
{2930,1645},{2430,1345},{3030,1545},{2530,1445},{3130,1545},{3226,1843},{3038,2028},{2030,1745},{2436,1938},{2030,1545},{2330,1345},{2330,1445},
{2826,1934},{2930,1345},{2630,1345},{2530,1645},{2230,1645},{3430,1545},{2430,1845},{2230,1845},{2030,1845},{2530,1745},{2330,1745},{2630,1245},
{3138,2028},{2530,1845},{2430,1545},{2626,2034},{2430,1745},{2130,1645},{2130,1745},{2330,1645},{2830,1645},{2930,1745},{2238,1940},{2335,1935},
{3430,1745},{3126,1843},{3230,1545},{2830,1345}]).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([init_template_map/0,
		 loadMapData/0,
		 is_copy_scene/1,
		 is_copy_war/1,
		 get_copy_map_id/1,
		 create_copy_id/2,
		 get_map_template_id/1,
		 get_base_scene_info/1,
		 get_scene_user/1,
		 get_scene_user_node/1,
%% 		 get_scene_user_from_ets/2,
		 get_scene_mon/1,
		 get_map_id/1,
		 get_map_type/1,
		 raid_active_award/2,
%%		 is_scen_mon_dead_all/1,
%% 		 get_scene_npc/1,
		 get_scene_info/2,
		 leave_map/7,
		 enter_map/1,
		 get_9_slice/2,
		 is_pos_in_slice/3,
		 is_pos_in_range/3,
		 is_same_slice/4,
%% 		 change_player_position/3,
		 move_broadcast_node/8,
		 %get_square_user_target/3,
		 %get_square_monster_target/4,
		 get_square_random_user_target/5,
		 get_square_random_monster_target/5,
		 get_square_random_our_monster_target/4,
		 get_broadcast_user/3,
		 get_broadcast_user_node/3,
		 get_broadcast_user_loop/3,
		 get_broadcast_mon/3,
		 get_broadcast_mon_loop/3,
		award_with_drop/7,
%% 		 get_broadcast_npc/3,
%% 		 get_broadcast_npc_loop/3,
		 load_boss/1,
		 load_map/2,
		 load_mon/3,
		 is_stand_pos_to_grid/3,
		 is_safe/3,
		 is_sell_area/3,
		 is_monster_all_dead/0,
		 get_alive_monster_num/0,
		 get_drop/9,
		 drop_loop_event/1,
		 return_career_born/1,
		 %get_battle_object/1,
		 %get_scene_battle_user/1,
		 %get_scene_battle_monster/1,
		 door_enter/2,
		 can_enter_map/2,
		 update_player_pos/4,
		 update_player_team/3,
		 update_player_hp_mp/3,
		 get_online_dic/0,
		 update_online_dic_not_skill/1,
		 update_online_dic_skill/1,
		 update_online_dic_pet_skill/1,
		 update_online_dic/1,
		 update_online_dic/3,
		 update_online_dic/5,
		 delete_online_dic/1,
		 get_drop_dic/0,
		 update_drop_dic/1,
		 delete_drop_dic/1,
		 get_mon_dic/0,
		 delete_mon_dic/1,
		 delete_mon_dic_by_template_id/1,
		 update_mon_dic/1,
		 update_all_mon_dic/1,
		 get_collect_dic/0,
		 update_collect_dic/1,
		 update_collect_dic/2,
		 update_all_collect_dic/1,
		 delete_collect_dic/1,
		 delete_collect_dic_by_template_id/2,
		 get_map_default_point/1,
%% 		 get_battle_object_dic_player/0,
%% 		 update_battle_object_dic_player/1,
%% 		 delete_battle_object_dic_player/1,
		 
%% 		 get_battle_object_dic_monster/0,
%% 		 update_battle_object_dic_monster/1,
%% 		 delete_battle_object_dic_monster/1,
		 
%% 		 update_monster_battle_object/1,
%% 		 update_player_battle_object/1,

%% 		 get_player_battle_object_and_clear/1,
		 get_drop_auto_id/0,
		 
%% 		 get_battle_object_player/1,
%% 		 get_battle_object_monster/1,		 
		 get_teammate_info/3,
	  	
		 load_collect/3,
		 load_collect/2,
		 load_duplicate_collect/1,
		 load_duplicate_map/7,
		 get_scene_user_with_no_team/3,
		 get_scene_info_in_slice/2,
		 check_tower_boss_dead/0,
		 put_map_dic_id/1,
		 get_map_dic_id/0,
		 put_map_random_local/1,
		 get_map_random_local/0,
		 
		 get_scene_user_in_slice/1,

		 guild_bonfire/1,
		 
		 get_online_player/1,
		 get_online_monster/2,

		 
		 map_send_all/1,
		 map_send_area/3,
		 map_send_area/4,
		 
		 get_square_random_tower_mon/0,
		 get_square_random_tower_target/4,
		 
		 get_tower_mon_dic/0,
		 get_online_tower_mon/1,
		 update_tower_mon_dic/1,
		 update_all_tower_mon_dic/1,
		 delete_tower_mon_dic/1,
		 
		 update_online_dic_invincible/2

%% 		get_map_user_dic/0,
%% 		get_map_user/1,
%% 		update_map_user_dic/1,
%% 		delete_map_user_dic/1

		 ]).

%%====================================================================
%% External functions
%%====================================================================

init_template_map() ->
	ok = loadMapData(),
	ok = loadMapTemplate(),
	ok.

loadMapData() ->
	MapConfigDir = "map/",
%%     ExtName = ".mc3m",
	ExtName = ".txt",

    %%列出文件夹中所有的地图文件
    try file:list_dir(MapConfigDir) of
        {ok, FileList} ->
            lists:foreach(
              fun(FileName) ->
                      case filename:extension(FileName) of
                          ExtName ->
                              loadMapDataFrom2(MapConfigDir , FileName, ExtName);
                          _ ->
                              ok
                      end
              end, FileList),
%%             ?INFO_MSG("~ts", ["读取地图数据完成"]),
			ok;
        {error, Reason} ->
            ?ERROR_MSG("MAP Router loadMapData error: ~w, from dir: ~w", [Reason, MapConfigDir])
    catch
        _:Reason -> ?ERROR_MSG("MAP Router loadMapData error, from dir: ~w,reason:~w~n", [MapConfigDir, Reason]) 
    end.

loadMapDataFrom2(MapConfigDir, FileName, ExtName) ->
	FullFileName = MapConfigDir ++ FileName,
	{ok, AllBin} = file:read_file(FullFileName),
%% 	io:format("read file name:~s~n", [FullFileName]),	
	AllBin2 = zlib:uncompress(AllBin),
%% 	io:format("file info bin:~s~n", [AllBin2]), 
	<<_TempMapID:32,MapNameLen:16,_MapName:MapNameLen/binary,_Width:32,_Height:32,IndexXLength:16,IndexYLength:16,Data2/binary>> = AllBin2,
	MapID = tool:to_integer(filename:basename(FileName, ExtName)),
	TileLen = IndexXLength * IndexYLength,
	<<TileBin:TileLen/binary,_Data3/binary>> = Data2,
	loadMapDataTile1(MapID, TileBin, IndexXLength, IndexYLength),

	ok.	
	  
loadMapDataTile1(MapID,DataBin,MaxX,MaxY) ->
    loadMapDataTileByY(MapID,DataBin,0,0,MaxX,MaxY).

loadMapDataTileByY(_MapID,_DataBin,_X,_Y,_MaxX,_MaxY=_Y) ->
	ok;
loadMapDataTileByY(MapID,DataBin,X,Y,MaxX,MaxY) ->
	 DataBin1 = loadMapDataTileByX(MapID,DataBin,X,Y,MaxX,MaxY),
	 loadMapDataTileByY(MapID,DataBin1,0,Y+1,MaxX,MaxY).

loadMapDataTileByX(_MapID,DataBin,_X,_Y,_MaxX=_X,_MaxY)->
	  DataBin;
loadMapDataTileByX(MapID,DataBin,X,Y,MaxX,MaxY)->
	<<Type:8,DataBin2/binary>>=DataBin,
		case Type of
	  		0 ->
	  			ok;
	  		_->
	            ets:insert(?ETS_BASE_SCENE_POSES, {{MapID, X, Y}})
    	end,

	loadMapDataTileByX(MapID,DataBin2,X+1,Y,MaxX,MaxY).

%% 数据库加载地图数据
loadMapTemplate() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_map_template] ++ Info),
				
				Areas = tool:split_string_to_intlist(Record#ets_map_template.area),
				%% type 1摆摊，2安全
				FArea = fun({Type, X, Y, Width, Height}, {Sell, Safe}) ->
							case Type of
								1 ->
									{[{Type, X, Y, X + Width, Y + Height}|Sell], Safe};
								2 ->
									{Sell, [{Type, X, Y, X + Width, Y + Height}|Safe]};
								_ ->
									?ERROR_MSG("loadMapTemplate FArea Type:~w~n", [Type]),
									{Sell, Safe}
							end
						end,
				{SellList, SafeList} = lists:foldl(FArea, {[],[]}, Areas),
				Other = #map_other{sell_area=SellList, safe_area=SafeList},

				
				Conditions = tool:split_string_to_intlist(Record#ets_map_template.requirement),
				FCondition = fun({Condition, Require}, Acc) ->
								case Condition of
									1 ->
										Acc#map_other{min_level=Require};
									2 ->
										Acc#map_other{max_level=Require};
									_ ->
										Acc
								end
							end,
				NewOther = lists:foldl(FCondition, Other, Conditions),
				RandomList = tool:split_string_to_intlist(Record#ets_map_template.rand_point),

				NewRecord = Record#ets_map_template{rand_point = RandomList, other_data=NewOther},

				ets:insert(?ETS_MAP_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_map_template() of
		[] -> 
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

check_tower_boss_dead() ->
	AllL = lib_map:get_tower_mon_dic(),
	case check_tower_boss_dead(AllL) of
		true ->
			case get(?DUPLICATE_PID_DIC)of
				undefined ->
					skip;
				Duplicate_Pid ->
					?DEBUG("check_tower_boss_dead:~p",[1]),
					gen_server:cast(Duplicate_Pid, {'tower_dead'})
			end;
		false ->
			?DEBUG("check_tower_boss_dead:~p",[1]),
			skip
	end.
check_tower_boss_dead([]) -> false;
check_tower_boss_dead([H|T]) ->
	if 	H#r_mon_info.monster_type =:= ?ACT_TYPE_ACT_OUR_BOSS ->
			if	H#r_mon_info.hp < 1 ->
					true;
				true ->
					false
			end;
		true ->
			check_tower_boss_dead(T)
	end.
	

%%	----------------------------dic 辅助方法-----------------------
%% 地图id
get_map_dic_id() ->
	get(?DIC_MAP_ID).

put_map_dic_id(ID) ->
	put(?DIC_MAP_ID, ID).

%% 随机掉落位置
get_map_random_local() ->
	get(?DIC_MAP_RANDOM_LOCAL).

put_map_random_local(L) ->
	put(?DIC_MAP_RANDOM_LOCAL, L).


%% 取得新的掉落id,移到掉落模块
get_drop_auto_id() ->
	case get(?DIC_DROP_AUTO_ID) of
		undefined ->
			put(?DIC_DROP_AUTO_ID, 1),
			1;
		AutoId ->
			NewAutoId = AutoId + 1,
			put(?DIC_DROP_AUTO_ID, NewAutoId)
	end.

%%=====================================================================================
%% %% 更新在线信息
%% get_map_user_dic() ->
%% 	case get(?DIC_MAP_USER_INFO) of
%% 		undefined ->
%% 			[];
%% 		List when is_list(List)->
%% 			List;
%% 		_ ->
%% 			[]
%% 	end.
%% 
%% get_map_user(ID) ->
%% 	L = get_map_user_dic(),
%% 	?PRINT("MapUserL ~p ~n",[L]),
%% 	case lists:keyfind(ID, #user_onmap.user_id, L) of
%% 		false ->
%% 			[];
%% 		Player ->
%% 			Player
%% 	end.
%% 
%% update_map_user_dic(Info) ->
%% 	case is_record(Info, user_onmap) of
%% 		true ->
%% 			List = get_map_user_dic(),
%% 			List1 = lists:keydelete(Info#user_onmap.user_id, #user_onmap.user_id, List),
%% 			put(?DIC_MAP_USER_INFO, [Info|List1]);
%% 		_ ->
%% 			?WARNING_MSG("update_online_dic:~w",[Info])
%% 	end,
%% 	ok.
%% 
%% delete_map_user_dic(UserId) ->
%% 	List = get_map_user_dic(),
%% 	List1 = lists:keydelete(UserId, #user_onmap.user_id, List),
%% 	put(?DIC_MAP_USER_INFO, List1),
%% 	ok.


%%=====================================================================================


%% 更新在线信息
get_online_dic() ->
	case get(?DIC_MAP_ONLINE) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

get_online_player(ID) ->
	L = get_online_dic(),
	case lists:keyfind(ID, #ets_users.id, L) of
		false ->
			[];
		Player ->
			Player
	end.

%%　todo 查一组人物对象 原get_battle_object_dic_player_list功能

update_online_dic(Info) ->
	case is_record(Info, ets_users) of
		true ->
			List = get_online_dic(),
			List1 = lists:keydelete(Info#ets_users.id, #ets_users.id, List),
			put(?DIC_MAP_ONLINE, [Info|List1]);
		_ ->
			?WARNING_MSG("update_online_dic:~w",[Info])
	end,
	ok.

update_online_dic_not_skill(Info) ->
	case is_record(Info, ets_users) of
		true ->	
			List = get_online_dic(),
			NewInfo =
				case lists:keyfind(Info#ets_users.id, #ets_users.id, List) of
					false ->
						Info;
					Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)
						andalso Old#ets_users.other_data#user_other.battle_info#battle_info.skill_prepare=/={} ->
						Player_State = check_player_now_state_change(Old#ets_users.other_data#user_other.player_now_state,
																	Info#ets_users.other_data#user_other.player_now_state,
																	Old#ets_users.other_data#user_other.player_standup_date),
						Invincible = Old#ets_users.other_data#user_other.battle_info#battle_info.invincible_date,
						SkillPrepare = Old#ets_users.other_data#user_other.battle_info#battle_info.skill_prepare,
						SkillList = Old#ets_users.other_data#user_other.skill_list,
						PetSkillList = Old#ets_users.other_data#user_other.pet_skill_list,
						BattleInfo = Old#ets_users.other_data#user_other.battle_info#battle_info{invincible_date=Invincible,
																								skill_prepare=SkillPrepare},
						UserOther = Info#ets_users.other_data#user_other{battle_info=BattleInfo,
																		 player_now_state=Player_State,
																		 skill_list = SkillList,
																		 pet_skill_list = PetSkillList
																		},
						
						Info#ets_users{other_data=UserOther};
					Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)->
						Invincible = Old#ets_users.other_data#user_other.battle_info#battle_info.invincible_date,
						SkillList = Old#ets_users.other_data#user_other.skill_list,
						PetSkillList = Old#ets_users.other_data#user_other.pet_skill_list,
						BattleInfo = Info#ets_users.other_data#user_other.battle_info#battle_info{invincible_date=Invincible},
						Player_State = check_player_now_state_change(Old#ets_users.other_data#user_other.player_now_state,
																	Info#ets_users.other_data#user_other.player_now_state,
																	Old#ets_users.other_data#user_other.player_standup_date),
						UserOther = Info#ets_users.other_data#user_other{player_now_state=Player_State,
																		battle_info=BattleInfo,
																		skill_list = SkillList,
																		pet_skill_list = PetSkillList},
						Info#ets_users{other_data = UserOther};
					_ ->
						Info
				end,
			List1 = lists:keydelete(Info#ets_users.id, #ets_users.id, List),
			put(?DIC_MAP_ONLINE, [NewInfo|List1]);
		_ ->
			?WARNING_MSG("update_online_dic:~w",[Info])
	end,
	ok.


update_online_dic_skill(Info) ->
	case is_record(Info, ets_users) of
		true ->	
			List = get_online_dic(),
			NewInfo =
				case lists:keyfind(Info#ets_users.id, #ets_users.id, List) of
					false ->
						Info;
					Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)
						andalso Old#ets_users.other_data#user_other.battle_info#battle_info.skill_prepare=/={} ->
						SkillList = Info#ets_users.other_data#user_other.skill_list,
						UserOther = Old#ets_users.other_data#user_other{skill_list = SkillList},
						
						Old#ets_users{other_data=UserOther};
					Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)->
						SkillList = Info#ets_users.other_data#user_other.skill_list,
						UserOther = Old#ets_users.other_data#user_other{skill_list = SkillList},
						
						Old#ets_users{other_data=UserOther};
					_ ->
						Info
				end,
			List1 = lists:keydelete(Info#ets_users.id, #ets_users.id, List),
			put(?DIC_MAP_ONLINE, [NewInfo|List1]);
		_ ->
			?WARNING_MSG("update_online_dic:~w",[Info])
	end,
	ok.

update_online_dic_pet_skill(Info) ->
	case is_record(Info, ets_users) of
		true ->	
			List = get_online_dic(),
			NewInfo =
				case lists:keyfind(Info#ets_users.id, #ets_users.id, List) of
					false ->
						Info;
					Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)
						andalso Old#ets_users.other_data#user_other.battle_info#battle_info.skill_prepare=/={} ->
						SkillList = Info#ets_users.other_data#user_other.pet_skill_list,
						UserOther = Old#ets_users.other_data#user_other{skill_list = SkillList},
						
						Old#ets_users{other_data=UserOther};
					Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)->
						SkillList = Info#ets_users.other_data#user_other.pet_skill_list,
						UserOther = Old#ets_users.other_data#user_other{pet_skill_list = SkillList},
						
						Old#ets_users{other_data=UserOther};
					_ ->
						Info
				end,
			List1 = lists:keydelete(Info#ets_users.id, #ets_users.id, List),
			put(?DIC_MAP_ONLINE, [NewInfo|List1]);
		_ ->
			?WARNING_MSG("update_online_dic:~w",[Info])
	end,
	ok.

update_online_dic_invincible(Info, Date) ->
	case is_record(Info, ets_users) of
		true ->
			List = get_online_dic(),
			NewInfo = case lists:keyfind(Info#ets_users.id, #ets_users.id, List) of
				false ->
					BattleInfo = Info#ets_users.other_data#user_other.battle_info#battle_info{invincible_date=Date},
					UserOther = Info#ets_users.other_data#user_other{battle_info=BattleInfo},
					Info#ets_users{other_data = UserOther};
				Old when is_record(Old, ets_users) 
						andalso is_record(Old#ets_users.other_data#user_other.battle_info, battle_info)->
					BattleInfo = Old#ets_users.other_data#user_other.battle_info#battle_info{invincible_date=Date},
					UserOther = Old#ets_users.other_data#user_other{battle_info=BattleInfo},
					Info#ets_users{other_data = UserOther};
				_ ->
					BattleInfo = Info#ets_users.other_data#user_other.battle_info#battle_info{invincible_date=Date},
					UserOther = Info#ets_users.other_data#user_other{battle_info=BattleInfo},
					Info#ets_users{other_data = UserOther}
				end,
			List1 = lists:keydelete(Info#ets_users.id, #ets_users.id, List),
			put(?DIC_MAP_ONLINE, [NewInfo|List1]);
		_ ->
			?WARNING_MSG("update_online_dic:~w",[Info])
	end,
	ok.
		

check_player_now_state_change(StateOld,StateNew,OldStandDate) ->
	case StateNew of
		?ELEMENT_STATE_INVINCIBLE ->
			case StateOld of
				?ELEMENT_STATE_HITDOWN ->
					?ELEMENT_STATE_INVINCIBLE;
				_ ->
					StateOld
			end;
		_ ->
			case StateOld of
				?ELEMENT_STATE_HITDOWN ->
					Now = misc_timer:now_seconds(),
					if OldStandDate > Now ->
							StateOld;
						true ->
							StateNew
					end;
				_ ->
					StateNew
			end
	end.


update_online_dic(ID,HP,MP) ->
	case lists:keyfind(ID, #ets_users.id, get_online_dic()) of
		false ->
			?WARNING_MSG("update_online_dic/3:~w",[ID]);
		Info ->
			update_online_dic(Info#ets_users{current_hp = Info#ets_users.current_hp - HP,
											 current_mp = Info#ets_users.current_mp - MP})
	end.

update_online_dic(ID,HP,MP,NowState,StandupDate) ->
	case lists:keyfind(ID, #ets_users.id, get_online_dic()) of
		false ->
			?WARNING_MSG("update_online_dic/6:~w",[ID]);
		Info ->
			BattleInfo = Info#ets_users.other_data#user_other.battle_info#battle_info{element_state = NowState},
			Other = Info#ets_users.other_data#user_other{ 
															player_standup_date = StandupDate,
															battle_info = BattleInfo, 
															player_now_state = NowState},
			update_online_dic(Info#ets_users{current_hp = Info#ets_users.current_hp - HP,
											 current_mp = Info#ets_users.current_mp - MP,
											 other_data = Other})
	end.

delete_online_dic(UserId) ->
	List = get_online_dic(),
	List1 = lists:keydelete(UserId, #ets_users.id, List),
	put(?DIC_MAP_ONLINE, List1),
	ok.

%% 地图掉落物品
get_drop_dic() ->
	case get(?DIC_MAP_DROP) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.
add_drop_dic(Info) ->%% 如果必须的新增的时候使用
	case  is_record(Info, r_drop_item) of
		true ->
			List = get_drop_dic(),
			%%List1 = lists:keydelete(Info#r_drop_item.id, #r_drop_item.id, List),
			put(?DIC_MAP_DROP, [Info|List]);
		_ ->
			skip
	end.

update_drop_dic(Info) ->
	case  is_record(Info, r_drop_item) of
		true ->
			List = get_drop_dic(),
			List1 = lists:keydelete(Info#r_drop_item.id, #r_drop_item.id, List),
			put(?DIC_MAP_DROP, [Info|List1]);
		_ ->
			skip
	end,
	ok.
delete_drop_dic(Id) ->
	List = get_drop_dic(),
	List1 = lists:keydelete(Id, #r_drop_item.id, List),
	put(?DIC_MAP_DROP, List1),
	ok.
%% 地图怪物
get_mon_dic() ->
	case get(?DIC_MAP_MON) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

is_monster_all_dead() ->
	case get(?DIC_MAP_MON) of
		undefined ->
			true;
		List when is_list(List) ->			
			is_monster_all_dead1(List);
		_ ->
			true
	end.

is_monster_all_dead1([]) ->
	true;
is_monster_all_dead1([H|L]) ->
	if
		H#r_mon_info.hp > 0 andalso H#r_mon_info.template#ets_monster_template.act_type =/= ?ACT_TYPE_ACT_TOWER ->
			%%?DEBUG("is_monster_all_dead1:~p",[{H#r_mon_info.template_id,H#r_mon_info.template#ets_monster_template.act_type}]),
			false;
		true ->
			is_monster_all_dead1(L)
	end.

get_alive_monster_num() ->
	case get(?DIC_MAP_MON) of
		undefined ->
			0;
		List when is_list(List) ->			
			get_alive_monster_num1(List, 0);
		_ ->
			0
	end.

get_alive_monster_num1([], Num) ->
	Num;
get_alive_monster_num1([M|List], Num) ->
	if
		M#r_mon_info.hp > 0 andalso M#r_mon_info.template#ets_monster_template.monster_type < ?ACT_TYPE_ACT_OUR_BOSS ->
			get_alive_monster_num1(List, Num + 1);
		true ->
			get_alive_monster_num1(List, Num)
	end.

get_online_monster(ID, ActorType) ->
	case ActorType of
		?ELEMENT_MONSTER ->
			L = get_mon_dic();
		?ELEMENT_OUR_TOWER ->
			L = get_tower_mon_dic();
		_er ->
			?DEBUG("error actor type:p",[_er]),
			L = []
	end,
	case lists:keyfind(ID, #r_mon_info.id, L) of
		false ->
			[];
		Mon ->
			Mon
	end.


update_mon_dic(Info) ->
	case is_record(Info, r_mon_info) of
		true ->
%% 			BattleInfo = lib_battle:init_battle_data_mon(Info),
%% 			NewInfo = Info#r_mon_info{battle_info = BattleInfo},
			List = get_mon_dic(),
			List1 = lists:keydelete(Info#r_mon_info.id, #r_mon_info.id, List),
			put(?DIC_MAP_MON, [Info|List1]);
		_ ->
			skip
	end,
	ok.


update_all_mon_dic(List) ->
	put(?DIC_MAP_MON, List),
	ok.

update_all_tower_mon_dic(List) ->
	put(?DIC_MAP_TOWER_MON, List),
	ok.

delete_mon_dic(Id) ->
	List = get_mon_dic(),
	List1 = lists:keydelete(Id, #r_mon_info.id, List),
	put(?DIC_MAP_MON, List1),
	ok.

delete_mon_dic_by_template_id(Id) ->
	List = get_mon_dic(),
	F = fun(I)-> I#r_mon_info.template_id =/= Id end,
	List1 = lists:filter(F, List),
	put(?DIC_MAP_MON, List1),
	ok.

%% 守塔怪物
get_tower_mon_dic() ->
	case get(?DIC_MAP_TOWER_MON) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

get_online_tower_mon(ID) ->
	L = get_tower_mon_dic(),
	case lists:keyfind(ID, #r_mon_info.id, L) of
		false ->
			[];
		TowerMon ->
			TowerMon
	end.

update_tower_mon_dic(Info) ->
	case is_record(Info, r_mon_info) of
		true ->
			List = get_tower_mon_dic(),
			List1 = lists:keydelete(Info#r_mon_info.id, #r_mon_info.id, List),
			if Info#r_mon_info.hp > 0 ->
				put(?DIC_MAP_TOWER_MON,[Info|List1]);
			true ->
				put(?DIC_MAP_TOWER_MON,List1)
			end;
		_ ->
			skip
	end,
	ok.


delete_tower_mon_dic(Id) ->
	List = get_tower_mon_dic(),
	List1 = lists:keydelete(Id, #r_mon_info.id, List),
	put(?DIC_MAP_TOWER_MON, List1),
	ok.


%% 地图采集
get_collect_dic() ->
	case get(?DIC_MAP_COLLECT) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.
update_collect_dic(Info, TemplateInfo) ->
	case  is_record(Info, r_collect_info) of
		true ->
			List = get_collect_dic(),
			List1 = lists:keydelete(Info#r_collect_info.id, #r_collect_info.id, List),
			if
				Info#r_collect_info.state =:= 0 andalso TemplateInfo#ets_collect_template.reborn_time =:= 0 ->
					put(?DIC_MAP_COLLECT, List1);
				true ->
					put(?DIC_MAP_COLLECT, [Info|List1])
			end;
			
		_ ->
			?WARNING_MSG("update_collect_dic:~w",[Info]),
			skip
	end,
	ok.
update_collect_dic(Info) ->
	case  is_record(Info, r_collect_info) of
		true ->
			List = get_collect_dic(),
			List1 = lists:keydelete(Info#r_collect_info.id, #r_collect_info.id, List),
			put(?DIC_MAP_COLLECT, [Info|List1]);
		_ ->
			?WARNING_MSG("update_collect_dic:~w",[Info]),
			skip
	end,
	ok.
update_all_collect_dic(List) ->
	put(?DIC_MAP_COLLECT, List),
	ok.
delete_collect_dic(Id) ->
	List = get_collect_dic(),
	List1 = lists:keydelete(Id, #r_collect_info.id, List),
	put(?DIC_MAP_COLLECT, List1),
	ok.
delete_collect_dic_by_template_id(Id, DList) ->
	List = get_collect_dic(),
	DList1 = lists:filter(fun(I)-> I#r_collect_info.template_id =:= Id end, List),
	List1 = lists:filter(fun(I)-> I#r_collect_info.template_id =/= Id end, List),
	put(?DIC_MAP_COLLECT, List1),
	NewDList = lists:append(DList1, DList),
	NewDList.


%% 战斗对象信息
%% get_battle_object_dic_player() ->
%% 	case get(?DIC_MAP_BATTLE_OBJECT_PLAYER) of
%% 		undefined ->
%% 			[];
%% 		List when is_list(List) ->
%% 			List;
%% 		_ ->
%% 			[]
%% 	end.

%% 根据ID获取玩家战斗对象
%% get_battle_object_player(ID) ->
%% 	case lists:keyfind(ID,#battle_object_state.id,get_battle_object_dic_player()) of
%% 		false ->
%% 			[];
%% 		V ->
%% 			V
%% 	end.

%% 根据ID列表查询出一组玩家战斗对象
%% get_battle_object_dic_player_list(IDL) ->
%% 	AllL = get_battle_object_dic_player(),
%% 	get_battle_object_dic_player_list_detail(IDL,AllL,[]).

%% get_battle_object_dic_player_list_detail([],_AllL,L) -> L;
%% get_battle_object_dic_player_list_detail([H|T],AllL,L) ->
%% 	case get_battle_object_player(H) of
%% 		[] ->
%% 			get_battle_object_dic_player_list_detail(T,AllL,L);
%% 		Info ->
%% 			get_battle_object_dic_player_list_detail(T,AllL,[Info|L])
%% 	end.

%% update_battle_object_dic_player(Info) ->
%% 	List = get_battle_object_dic_player(),
%% 	List1 = lists:keydelete(Info#battle_object_state.id,#battle_object_state.id,List),
%% 	put(?DIC_MAP_BATTLE_OBJECT_PLAYER,[Info|List1]),
%% 	ok.

%% delete_battle_object_dic_player(Id) ->
%% 	List = get_battle_object_dic_player(),
%% 	List1 = lists:keydelete(Id, #battle_object_state.id, List),
%% 	put(?DIC_MAP_BATTLE_OBJECT_PLAYER,List1),
%% 	ok.


%怪物战斗对象信息
%% get_battle_object_dic_monster() ->
%% 	case get(?DIC_MAP_BATTLE_OBJECT_MON) of
%% 		undefined ->
%% 			[];
%% 		List when is_list(List) ->
%% 			List;
%% 		_ ->
%% 			[]
%% 	end.

%% 根据ID获取怪物战斗对象
%% get_battle_object_monster(ID) ->
%% 	case lists:keyfind(ID,#battle_object_state.id,get_battle_object_dic_monster()) of
%% 		false ->
%% 			[];
%% 		V ->
%% 			V
%% 	end.

%% 根据ID列表查询出一组玩家战斗对象
%% get_battle_object_dic_monster_list(IDL) ->
%% 	AllL = get_battle_object_dic_monster(),
%% 	get_battle_object_dic_monster_list_detail(IDL,AllL,[]).

%% get_battle_object_dic_monster_list_detail([],_AllL,L) -> L;
%% get_battle_object_dic_monster_list_detail([H|T],AllL,L) ->
%% 	case get_battle_object_monster(H) of
%% 		[] ->
%% 			get_battle_object_dic_monster_list_detail(T,AllL,L);
%% 		Info ->
%% 			get_battle_object_dic_monster_list_detail(T,AllL,[Info|L])
%% 	end.
%% 
%% update_battle_object_dic_monster(Info) ->
%% 	List = get_battle_object_dic_monster(),
%% 	List1 = lists:keydelete(Info#battle_object_state.id,#battle_object_state.id,List),
%% 	put(?DIC_MAP_BATTLE_OBJECT_MON,[Info|List1]),
%% 	ok.
%% 
%% delete_battle_object_dic_monster(Id) ->
%% 	List = get_battle_object_dic_monster(),
%% 	List1 = lists:keydelete(Id, #battle_object_state.id, List),
%% 	put(?DIC_MAP_BATTLE_OBJECT_MON,List1),
%% 	ok.

%--------------------------------战斗信息---------------------------

%%同步场景中怪物战斗信息
%% update_monster_battle_object(MonInfo) ->
%%  	BattleState = lib_battle:init_battle_data_mon(MonInfo),
%% 	F = fun(X) ->
%% 				%{SkillID,_,_,_} = X,
%% 				%{SkillID,0}
%% 				{X#r_use_skill.skill_id, X#r_use_skill.skill_lastusetime}
%% 		end,
%% 	SkillL = [F(X) || X <- MonInfo#r_mon_info.skill_list],
%% 	update_battle_object_dic_monster(BattleState#battle_object_state{skill_time=SkillL}).

%% update_player_battle_object(PlayerInfo) ->
%% 	BattleState = lib_battle:init_battle_data_player(PlayerInfo),
%% 	F = fun(X) ->
%% %% 				{SkillID,SkillTime,_Skilllv,_GroupID} = X,
%% 				{X#r_use_skill.skill_id,X#r_use_skill.skill_lastusetime}
%% 		end,
%% 	SkillL = [F(X) || X <- PlayerInfo#ets_users.other_data#user_other.skill_list],
%% 	update_battle_object_dic_player(BattleState#battle_object_state{skill_time=SkillL}).

%% get_player_battle_object_and_clear(PlayerInfo) ->
%% 	AllL = get_battle_object_dic_player(),
%% 	case lists:keyfind(PlayerInfo#ets_users.id,#battle_object_state.id,AllL) of
%% 		false ->
%% 			lib_battle:init_battle_data_player(PlayerInfo);
%% 		V ->
%% 			delete_battle_object_dic_player(PlayerInfo#ets_users.id),
%% 			V
%% 	end.


%%	----------------------------地图区域判断-----------------------
%% 是否安全区域
is_safe(MapId, PosX, PosY) ->
	case data_agent:map_template_get(MapId) of
		[] ->
			false;
		[Map] ->
			is_in_area(Map#ets_map_template.other_data#map_other.safe_area, PosX, PosY)
	end.

%% 是否摆摊区
is_sell_area(MapId, PosX, PosY) ->
	case data_agent:map_template_get(MapId) of
		[] ->
			false;
		[Map] ->
			is_in_area(Map#ets_map_template.other_data#map_other.sell_area, PosX, PosY)
	end. 

is_in_area([], _, _) ->
	false;
is_in_area([H|T], PosX, PosY) ->
	{_Type, X1, Y1, X2, Y2} = H,
	if 
		X1 =< PosX andalso PosX =< X2 andalso Y1 =< PosY andalso PosY =< Y2 ->
			true;
		true ->
			is_in_area(T, PosX, PosY)
	end.

%% 能否站立,false 不能，true 坐标换算成格子
is_stand_pos_to_grid(MapId, PosX, PosY) ->
	X = util:floor(PosX / ?GRID_LENGTH),
	Y = util:floor(PosY / ?GRID_LENGTH),
	is_stand(MapId,X,Y).

%% 能否站立,false 不能，true 能 按格子算
is_stand(MapId, X, Y) ->
	case ets:lookup(?ETS_BASE_SCENE_POSES, {MapId, X, Y}) of
		[] ->
			false; 
		_ ->
			true
	end.

%% 获取地图默认传送点
get_map_default_point(MapId) ->
	case data_agent:map_template_get(MapId) of
		[] ->
			[];
		MapTemp ->
			[{PosX, PosY}] = tool:split_string_to_intlist(MapTemp#ets_map_template.default_point)
	end.

%% 取的地图模板ID,副本Id为地图ID*100000
get_map_template_id(MapId) ->
	case is_copy_scene(MapId) of
			true ->
				tool:floor(MapId/100000);
			_ ->
				MapId
	end.

is_copy_war(UniqueId) ->
	MapId = get_copy_map_id(UniqueId),
	if MapId >= 5000 andalso MapId < 6000 ->
			false;
		true ->
			false
	end.
		

%% 是为副本场景，唯一id
is_copy_scene(UniqueId) ->
    UniqueId > 9999.

%% 获得地图Id
get_copy_map_id(UniqueId) ->
	tool:floor(UniqueId/100000).

%% 获得地图id
get_map_id(UniqueId) ->
	if
		UniqueId > 10000000 ->
			tool:floor(UniqueId/100000);
		true ->
			UniqueId
	end.
%% 根据地图Id类型
get_map_type(UniqueId) ->
	MapId = get_map_id(UniqueId),
	if
		MapId < 9999 ->
			?DUPLICATE_TYPE_WORLD;
		MapId =:= 10000 ->
			?DUPLICATE_TYPE_GUILD1;
		MapId > 1000001 andalso MapId < 2000000 ->
			?DUPLICATE_TYPE_NORMAL;
		MapId > 2000000 andalso MapId < 3000000 ->
			?DUPLICATE_TYPE_BATCH;
		MapId > 3000000 andalso MapId < 4000000 ->
			?DUPLICATE_TYPE_GUARD;
		MapId > 4000000 andalso MapId < 5000000 ->
			?DUPLICATE_TYPE_PASS;
		MapId > 5000000 andalso MapId < 6000000 ->
			?DUPLICATE_TYPE_GUILD;
		MapId > 6000000 andalso MapId < 7000000 ->
			?DUPLICATE_TYPE_TREASURE;
		MapId > 7000000 andalso MapId < 8000000 ->
			?DUPLICATE_TYPE_MONEY;
		MapId =:= 1000000 ->
			?DUPLICATE_TYPE_PVP1;
%% 		MapId =:= 9000001 orelse MapId =:= 9000002 orelse MapId =:= 9000003 orelse MapId =:= 9000005
%% 			orelse MapId =:= ?ACTIVE_KING_FIGHT_MAP_ID->
		MapId > 9000000 andalso MapId < 9900000 ->
			?DUPLICATE_TYPE_PVP2;
		MapId > 8000000 andalso MapId < 9000000 ->
			?DUPLICATE_TYPE_CHALLENGE;
		true ->
			?DUPLICATE_TYPE_OTHER
	end.


%% 生成副本id
create_copy_id(MapId, UniqueId) ->
	MapId * 100000 + UniqueId.

%%获得基础场景信息
get_base_scene_info(MapId) ->
 	case ets:lookup(?ETS_MAP_TEMPLATE, MapId) of
		[] -> [];
		[Map] -> Map
	end.

%%获得当前场景用户信息 
get_scene_user(_MapId) ->
%% 	get_scene_user_from_ets(MapId, ?ETS_ONLINE_SCENE).
	get_online_dic().

%%获得当前场景用户信息 (本节点)
get_scene_user_node(MapId) ->
%%  	get_scene_user_from_ets(MapId, ?ETS_ONLINE).
    MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == MapId  ->		
		% todo 改成取需要字段，或ets只保存需要的字段
		T
	end),
   	ets:select(?ETS_ONLINE, MS).

%% 获取范围内用户
get_scene_user_in_slice(Slices) ->
	AllUser = get_online_dic(),
	get_scene_user_in_slice1(AllUser,Slices, []).

get_scene_user_in_slice1([], _Slices, D) -> 
    D;
get_scene_user_in_slice1([User|T], Slices, D) ->
	InSlice = is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, Slices),
	if InSlice =:= true ->
			get_scene_user_in_slice1(T, Slices, [User|D]);
		true ->
			get_scene_user_in_slice1(T, Slices, D)
	end.

%%从ets获得用户信息 
%% get_scene_user_from_ets(_MapId, _Ets_tab) ->	
%% 	get_online_dic().
%%    	MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == MapId  ->		
%% 		% todo 改成取需要字段，或ets只保存需要的字段
%% 		T
%% %% 		[
%% %% 			T,
%% %% 			T#ets_users.other_data#user_other.walk_path_bin
%% %% 		]
%% 	end),
%%    	ets:select(Ets_tab, MS).

%%获得当前场景怪物信息
get_scene_mon(_MapID) ->
	List = get_mon_dic(),
	F = fun(MonInfo, Acc) ->
 			case is_record(MonInfo, r_mon_info) of
				true ->
					NewInfo = [MonInfo#r_mon_info.id,
					MonInfo#r_mon_info.template_id,
	 				MonInfo#r_mon_info.pos_x,
	 				MonInfo#r_mon_info.pos_y,
	 				MonInfo#r_mon_info.hp,
	 				MonInfo#r_mon_info.last_path],
					[NewInfo|Acc];
				_ ->
					?WARNING_MSG("get_scene_mon:~w", [MonInfo]),
					Acc
			end
	end,
	lists:foldl(F, [], List).

%% 获取范围内怪物
get_scene_mon_in_slice(Slices) ->
	AllMon = get_mon_dic(),
	TowerMon = get_tower_mon_dic(),
	AllMon1 = AllMon ++ TowerMon,
	get_scene_mon_in_slice1(AllMon1,Slices, []).

get_scene_mon_in_slice1([], _Slices, D) -> D;
get_scene_mon_in_slice1([Mon|T], Slices, D) ->
	InSlice = is_pos_in_slice(Mon#r_mon_info.pos_x, Mon#r_mon_info.pos_y, Slices),
	if InSlice =:= true andalso (Mon#r_mon_info.hp > 0) ->
			get_scene_mon_in_slice1(T, Slices, [Mon|D]);
		true ->
			get_scene_mon_in_slice1(T, Slices, D)
	end.


%%获得当前场景采集信息
%% get_scene_collect(_MapId) ->
%% 	List = get_collect_dic(),
%% 	F = fun(Info) ->
%% 			case is_record(Info, r_collect_info) of
%% 				true -> 
%% 					[
%% 					Info#r_collect_info.id,
%% 					Info#r_collect_info.template_id,
%% 					Info#r_collect_info.x,
%% 					Info#r_collect_info.y,
%% 					Info#r_collect_info.state
%% 					];
%% 				_ ->
%% 					?WARNING_MSG("get_scene_collect:~w", [Info])
%% 			end
%% 
%% 		end,
%% 	lists:map(F, List).

%%获得范围内采集
get_scene_collect_in_slice(Slices) ->
	AllCollect = get_collect_dic(),
	get_scene_collect_in_slice1(AllCollect,Slices, []).

get_scene_collect_in_slice1([], _Slices, D) -> D;
get_scene_collect_in_slice1([Collect|T], Slices, D) ->
	InSlice = is_pos_in_slice(Collect#r_collect_info.x, Collect#r_collect_info.y, Slices),
	if InSlice =:= true ->
			get_scene_collect_in_slice1(T, Slices, [Collect|D]);
		true ->
			get_scene_collect_in_slice1(T, Slices, D)
	end.

%%获取当前场景掉落信息
get_scene_drop_item(_MapId) ->
%% 	MS = ets:fun2ms(fun(T) when T#r_drop_item.map_id == MapId  ->	T end),
%% 	ets:select(?ETS_SCENE_DROP_ITEM, MS).
	get_drop_dic().

%%获得范围内掉落信息
get_scene_drop_in_slice(Slices) ->
	AllDrop = get_drop_dic(),
	get_scene_drop_in_slice1(AllDrop,Slices, []).

get_scene_drop_in_slice1([], _Slices, D) -> D;
get_scene_drop_in_slice1([Drop|T], Slices, D) ->
	InSlice = is_pos_in_slice(Drop#r_drop_item.x, Drop#r_drop_item.y, Slices),
	if InSlice =:= true andalso Drop#r_drop_item.work_lock =:= false ->
			get_scene_drop_in_slice1(T, Slices, [Drop|D]);
		true ->
			get_scene_drop_in_slice1(T, Slices, D)
	end.


%% 获取场景基本信息
get_scene_info( X, Y) ->
	AllMon = get_mon_dic(),
	TowerMon = get_tower_mon_dic(),
	SceneMon = AllMon ++ TowerMon,
	SceneCollect = get_collect_dic(),
	SceneDrop = get_drop_dic(),
	[SceneMon,SceneCollect,[], SceneDrop].


%% 获取场景范围内基本信息
get_scene_info_in_slice(X, Y) ->
	Slice9 = get_9_slice(X,Y),
	SceneMon = get_scene_mon_in_slice(Slice9),		%% 增加读取守塔怪
	SceneCollect = get_scene_collect_in_slice(Slice9),
	SceneNpc = [],
	SceneDrop = get_scene_drop_in_slice(Slice9),
	[SceneMon,SceneCollect,SceneNpc, SceneDrop].

	
%%离开当前场景
leave_map(PlayerId, PetId, MapId, X, Y, Pid, IDList) ->
    {ok, BinData} = pt_12:write(?PP_MAP_USER_REMOVE, [{PlayerId, PetId}]),
%% 	mod_map_agent:send_to_area_scene(MapId, X, Y, BinData),

	mod_map_agent:send_to_map_scene(MapId, X, Y, BinData),

%% 	catch ets:delete(?ETS_ONLINE_SCENE, PlayerId).
	%清空仇恨列表
	lib_map_monster:harted_list_remove_by_target(IDList,Pid),
%% 	delete_battle_object_dic_player(PlayerId),
	delete_online_dic(PlayerId).
	

%%进入当前场景
enter_map(Status) ->	
    {ok, BinData} = pt_12:write(?PP_MAP_USER_ADD, [Status]),
%% 	ets:insert(?ETS_ONLINE_SCENE, Status),
	update_online_dic(Status),
%% 	mod_map_agent:send_to_area_scene(Status#ets_users.current_map_id, 
%% 							Status#ets_users.pos_x, Status#ets_users.pos_y, BinData).
	mod_map_agent:send_to_map_scene(Status#ets_users.current_map_id, 
									Status#ets_users.pos_x, 
									Status#ets_users.pos_y, 
									BinData).

%% 捡起地面的铜币与元宝 打钱副本使用
%% get_money_drop() ->


%% 捡起地面的东西
get_drop(DropID, PlayerID, X, Y, Pid_Team, Pid_Item, AllotMode, PidFlag, Pid_Map) ->
   if
        PidFlag =:= ?PID_ITEM ->
          get_drop_1(DropID, PlayerID, X, Y, Pid_Item, Pid_Map);
        PidFlag =:= ?PID_TEAM ->
          get_drop_2(DropID, PlayerID, X, Y, Pid_Team, Pid_Item, Pid_Map, AllotMode);
        true ->
         skip
   end.

%%不在组队状态下拾取物品
get_drop_1(DropID, PlayerID, X, Y, Pid_Item, Pid_Map) ->
%% 	case ets:lookup(?ETS_SCENE_DROP_ITEM,DropID) of
%% 		[DropItem] ->
	List = get_drop_dic(),
	case lists:keyfind(DropID, #r_drop_item.id, List) of
		false ->
			skip;
		DropItem ->
			case ?DROP_ITEM_GET_RANGE > abs(DropItem#r_drop_item.x - X) andalso
				?DROP_ITEM_GET_RANGE > abs(DropItem#r_drop_item.y - Y) of
				true ->
					if DropItem#r_drop_item.state =:= lock andalso DropItem#r_drop_item.owner_id =:= PlayerID ->                           
						  get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);

					   DropItem#r_drop_item.state =:= unlock ->
						  get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);

					   true ->
						   skip
					end;
				_ ->
					skip
			end
	end.


get_drop_2(DropID, PlayerID, X, Y, Pid_Team, Pid_Item, Pid_Map, AllotMode) ->
 %  TeamInfo = lib_team:get_team_info(Pid_Team),
      %TeamInfo#ets_team.allot_mode =:= ?DROP_ITEM_FREE ->
%TeamInfo#ets_team.allot_mode =:= ?DROP_ITEM_RANDOM ->
	if	AllotMode =:=  ?DROP_ITEM_FREE ->
         %%自由拾取
         	get_drop_by_free(DropID, PlayerID, X, Y, Pid_Item, Pid_Team, Pid_Map);
		AllotMode =:=  ?DROP_ITEM_RANDOM ->
		%% 随便机拾取call不能使用
			%%get_drop_by_free(DropID, PlayerID, X, Y, Pid_Item, Pid_Team, Pid_Map);
         %%随机拾取
          	get_drop_by_random(DropID, PlayerID, X, Y, Pid_Item, Pid_Team, Pid_Map);
		true ->
        	skip
   end.


%%自由拾取   
get_drop_by_free(DropID, _PlayerID, X, Y, Pid_Item, Pid_Team, Pid_Map) ->
%%     case ets:lookup(?ETS_SCENE_DROP_ITEM, DropID) of
%%        [DropItem] ->
	List = get_drop_dic(),
	case lists:keyfind(DropID, #r_drop_item.id, List) of
		false ->
			skip;
		DropItem ->
           case ?DROP_ITEM_GET_RANGE > abs(DropItem#r_drop_item.x - X) andalso
				?DROP_ITEM_GET_RANGE > abs(DropItem#r_drop_item.y - Y) of
               true ->
                 if 
                    DropItem#r_drop_item.state =:= lock andalso DropItem#r_drop_item.ownteampid =:= Pid_Team ->
                       get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);

                    DropItem#r_drop_item.state =:= unlock ->
					   get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);

                     true ->
						   skip
				end;

               _ ->
				   skip
		  end
	end.


get_drop_by_random(DropID, PlayerID, X, Y, Pid_Item, Pid_Team, Pid_Map) ->
	List = get_drop_dic(),
	case lists:keyfind(DropID, #r_drop_item.id, List) of
		false ->
			skip;
		DropItem1 ->
			case ?DROP_ITEM_GET_RANGE > abs(DropItem1#r_drop_item.x - X) andalso
				?DROP_ITEM_GET_RANGE > abs(DropItem1#r_drop_item.y - Y) of
               true ->
				 OwnerId = gen_server:call(Pid_Team, {get_drop_owner_id}),
				  DropItem = DropItem1#r_drop_item{owner_id=OwnerId},
                 get_drop_by_random_1(DropID, PlayerID, Pid_Item, Pid_Team, DropItem,OwnerId,Pid_Map);
				_ ->
					skip
			end
	end.
%% %%随机拾取
%% get_drop_by_random(DropID, PlayerID, X, Y, Pid_Item, Pid_Team, TeamInfo, Pid_Map) ->   
%% 	List = get_drop_dic(),
%% 	case lists:keyfind(DropID, #r_drop_item.id, List) of
%% 		false ->
%% 			skip;
%% 		DropItem1 ->
%%             %%随机分配
%%             Ramdom = util:rand(1, erlang:length(TeamInfo#ets_team.member)),
%% 			
%%             OwnerInfo = lists:nth(Ramdom, TeamInfo#ets_team.member),
%% 			?DEBUG("OwnerInfo:~p",[{Ramdom,OwnerInfo#team_member.id}]),
%%             OwnerId = OwnerInfo#team_member.id,
%%             DropItem = DropItem1#r_drop_item{owner_id=OwnerId},
%%              
%%             case ?DROP_ITEM_GET_RANGE > abs(DropItem#r_drop_item.x - X) andalso
%% 				?DROP_ITEM_GET_RANGE > abs(DropItem#r_drop_item.y - Y) of
%%                true ->
%%                  get_drop_by_random_1(DropID, PlayerID, Pid_Item, Pid_Team, DropItem,OwnerId,Pid_Map);
%% 
%% 				_ ->
%% 					skip
%% 			end
%% 	end.


get_drop_by_random_1(DropID, PlayerID, Pid_Item, Pid_Team, DropItem ,OwnerId, Pid_Map) ->  
	if 
		%%分配到自己
		DropItem#r_drop_item.state =:= lock andalso DropItem#r_drop_item.ownteampid =:= Pid_Team 
		  andalso  DropItem#r_drop_item.owner_id =:= PlayerID ->
			get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);
		
		%%分配到队友
		DropItem#r_drop_item.state =:= lock andalso DropItem#r_drop_item.ownteampid =:= Pid_Team 
		  andalso  DropItem#r_drop_item.owner_id =/= PlayerID ->  
			get_drop_item_2(OwnerId, DropItem,Pid_Item, DropID, Pid_Map);
		
		DropItem#r_drop_item.state =:= unlock ->     
			get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);
		
		true ->
			skip
	end.

get_drop_item_2(OwnerId, DropItem, Pid_Item, DropID,Pid_Map) ->   
	case lib_player:get_online_player_info_by_id(OwnerId) of
		[] ->
			get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map);
		OwnInfo ->
			case OwnInfo#ets_users.other_data#user_other.pid_map =:= Pid_Map of
				true ->             
					get_drop_item_1(DropItem, OwnInfo#ets_users.other_data#user_other.pid_item, DropID, Pid_Map);
				_ ->
					get_drop_item_1(DropItem, Pid_Item, DropID, Pid_Map)
			end
	end.

get_drop_item_1(DropItem, Pid_Item, DropID,Pid_Map) ->
	%% 添加标志位
	%?DEBUG("get_drop_item_1:~p",[{DropID,}]),
	case lists:keyfind(DropID, #r_drop_item.id, get_drop_dic()) of
		false ->
			ok;
		_DropItem ->
			case DropItem#r_drop_item.work_lock of
				false ->	%自由，可拾取
					update_drop_dic(DropItem#r_drop_item{work_lock = true}),
					gen_server:cast(Pid_Item,{'add_item',
												DropItem#r_drop_item.item_template_id,
												1,
												DropItem#r_drop_item.isbind,
												Pid_Map,
												DropID}),
					ok;
				_ ->
					ok
			end
	end.

%% 	GetDrop = gen_server:call(Pid_Item,{'add_item', 
%% 										DropItem#r_drop_item.item_template_id,
%% 										1,
%% 										DropItem#r_drop_item.isbind}),
%% 	case GetDrop of
%% 		true ->
%% 			{ok, BinData} = pt_23:write(?PP_TARGET_DROPITEM_REMOVE, DropItem),
%% 			mod_map_agent:send_to_map_scene(DropItem#r_drop_item.map_id, 
%% 											DropItem#r_drop_item.x, 
%% 											DropItem#r_drop_item.y, 
%% 											BinData),
%% %% 			ets:delete(?ETS_SCENE_DROP_ITEM, DropID);
%% 			delete_drop_dic(DropID);
%% 		_ ->
%% 			skip
%% 	end.


%% get_drop_team(DropItem, Pid_team) ->
%% 	TarTeam = TarInfo#ets_users.other_data#user_other.pid_team,
%% 	case misc:is_process_alive(TarTeam) of
%% 		true ->
%% 			gen_server:cast(ServerRef, Request)
	

%掉落物的循环状态处理
drop_loop_event(_MapID) ->
	TmpTime = misc_timer:now_seconds(),
	LockTime = TmpTime - ?DROP_ITEM_CHANGE_UNLOCK,
	DelTime = TmpTime - ?DROP_ITEM_CHANGE_DELETE,
	List = get_drop_dic(),
	F = fun(DropItem) ->
			if DelTime > DropItem#r_drop_item.drop_time ->
					{ok, BinData} = pt_23:write(?PP_TARGET_DROPITEM_REMOVE, DropItem),
					mod_map_agent:send_to_map_scene(DropItem#r_drop_item.map_id,
													DropItem#r_drop_item.x, 
													DropItem#r_drop_item.y, 
													BinData),
					delete_drop_dic(DropItem#r_drop_item.id);
				LockTime > DropItem#r_drop_item.drop_time andalso DropItem#r_drop_item.state =:= lock ->
					NewDropItem = DropItem#r_drop_item{state=unlock},
					{ok, BinData} = pt_23:write(?PP_TARGET_DROPITEM_UPDATE, NewDropItem),
					mod_map_agent:send_to_map_scene(DropItem#r_drop_item.map_id,
													DropItem#r_drop_item.x, 
													DropItem#r_drop_item.y, 
													BinData),
					update_drop_dic(NewDropItem);
				true ->
					skip
			end
		end,
	lists:foreach(F, List).


%%--------------------------九宫格加载场景---------------------------
%%九宫格处理函数
get_9_slice(X, Y) ->
	X1 = X div ?SLICEWIDTH * ?SLICEWIDTH ,
	Y1 = Y div ?SLICEHEIGHT * ?SLICEHEIGHT,
	{X1 - ?SLICEWIDTH, Y1 - ?SLICEHEIGHT, X1 + ?SLICEWIDTH * 2, Y1 + ?SLICEHEIGHT * 2}.

%% 判断X,Y是否在所在的框里面。
is_pos_in_slice(X, Y, {X1, Y1, X2, Y2}) ->
	if 
		X1=<X andalso X2>=X andalso Y1=<Y andalso Y2>=Y ->
			true;
		true ->
			false
	end.

is_pos_in_range(X,Y,{X1, Y1, X2, Y2}) ->
	if 
		X1=<X andalso X2>=X andalso Y1=<Y andalso Y2>=Y ->
			true;
		true ->
			false
	end. 

%是否在同一九宫格子里，小格子
is_same_slice(X1, Y1, X2, Y2) ->
	SX1 = X1 div ?SLICEWIDTH,
	SY1 = Y1 div ?SLICEHEIGHT,
	SX2 = X2 div ?SLICEWIDTH,
	SY2 = Y2 div ?SLICEHEIGHT,

	if 
		SX1 == SX2 andalso SY1 == SY2 ->
			true;
		true ->
			false
	end.

%%--------------------------------------------------


%% 更改玩家位置
%% Status玩家信息
%% X 目的点X坐标
%% Y 目的点Y坐标
change_player_position(Status, OldX, OldY) ->	
    {ok, EnterData} = pt_12:write(?PP_MAP_USER_ADD, [Status]),	
 	{ok, LeaveData} = pt_12:write(?PP_MAP_USER_REMOVE, [{Status#ets_users.id, Status#ets_users.other_data#user_other.pet_id}]),
	mod_map_agent:move_broadcast(Status#ets_users.current_map_id, 
								 Status#ets_users.other_data#user_other.pid, 
							     Status#ets_users.pos_x, 
								 Status#ets_users.pos_y, 
								 OldX, 
								 OldY,
								 EnterData,
								 LeaveData).


%% 当人物移动时候的广播(节点代理处理)
%%终点要X1，Y2，原点是X2,Y2
move_broadcast_node(MapId, Pid_player, X1, Y1, X2, Y2, EnterData, LeaveData) ->
	EnterSlice = get_9_slice(X1, Y1),
	OldSlice = get_9_slice(X2, Y2),
%%     添加人物
	MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == MapId->
		T
	end),
   	AllUser = ets:select(?ETS_ONLINE, MS),
	lists:foreach(
		fun(User)->
%% 			[Pid_send, WalkPathBin, User] = Status,
			InEnterSlice = is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, EnterSlice),
			InOldSlice = is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, OldSlice),
			if 
				InEnterSlice == true andalso InOldSlice == false ->
					lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, EnterData);
%% 					{ok, OtherData} = pt_12:write(?PP_MAP_USER_ADD, [User]),
%% 					gen_server:cast(Pid_player, {send_to_sid, OtherData}),
%% 					if 
%% 						User#ets_users.other_data#user_other.sit_state > 1 ->
%% 							{ok, BinData} = pt_12:write(?PP_SIT_INVITE_REPLY, [1, User#ets_users.id, 
%% 																			   User#ets_users.other_data#user_other.double_sit_id]),
%% 							gen_server:cast(Pid_player, {send_to_sid, BinData});
%% 						true ->
%% 							skip
%% 					end;

 				InEnterSlice == false andalso InOldSlice == true ->
					lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, LeaveData);
%% 					{ok, OtherLeaveBin} = pt_12:write(?PP_MAP_USER_REMOVE,[{User#ets_users.id, User#ets_users.other_data#user_other.pet_id}]),
%%  					gen_server:cast(Pid_player, {send_to_sid, OtherLeaveBin});
				true ->
					skip
			end
	end, AllUser), 

	ok.



%% 以下战斗用
%% 取在正方形范围内的人物对象
%% get_square_user_target(X,Y,Range) ->
%% 	%AllUsers = get_battle_object_dic_player(),
%% 	AllUsers = get_online_dic(),
%% 	R = {X-Range,Y-Range,X+Range,Y+Range},
%% 	get_square_object_target_loop(AllUsers,R,[],?Element_Player).

%% 任意获取正方形范围内指定数量人物对象
get_square_random_user_target(Camp,X,Y,Range,Number) ->
	%SquareUsers = get_square_user_target(X,Y,Range),
	%get_square_random_object_target(SquareUsers,Number,[])
	AllUsers = get_online_dic(),
	R = {X-Range,Y-Range,X+Range,Y+Range},
	get_square_random_user_target1(AllUsers, Number, R, Camp, []).

get_square_random_user_target1([],_Number,_R,_Camp,L) -> L;
get_square_random_user_target1(_Users,0,_R,_Camp,L) -> L;
get_square_random_user_target1(Users,Number,R,Camp,L) ->
	[H|T] = Users,
	InSquare = is_pos_in_range(H#ets_users.pos_x,H#ets_users.pos_y,R),
	if InSquare =:= true andalso H#ets_users.current_hp > 0 andalso (Camp =:= 0 orelse H#ets_users.camp =/= Camp)->
%% 			get_square_random_user_target1(T,Number-1,R,[get_battle_object_player(H#ets_users.id)|L]);
			get_square_random_user_target1(T,Number-1,R,Camp,[H|L]);
		true ->
			get_square_random_user_target1(T,Number,R,Camp,L)
	end.

%% 获取正方形范围内的怪物对象
%% get_square_monster_target(X,Y,Range) ->
%% 	%AllMonsters = get_battle_object_dic_monster(),
%% 	AllMonsters = get_mon_dic(),
%% 	R = {X-Range,Y-Range,X+Range,Y+Range},
%% 	get_square_object_target_loop(AllMonsters,R,[],?Element_Monster).

get_square_random_our_monster_target(X,Y,Range,Number) ->
	AllMons = get_tower_mon_dic(),	
	R = {X-Range,Y-Range,X+Range,Y+Range},
	get_square_random_monster_target1(-2,AllMons, Number, R, []).
%% 任意获取正方形范围内指定数量怪物对象
get_square_random_monster_target(Camp,X,Y,Range,Number) ->
	%SquareMons = get_square_monster_target(X,Y,Range),
	%get_square_random_object_target(SquareMons,Number,[]).
	AllMons = get_mon_dic(),
	R = {X-Range,Y-Range,X+Range,Y+Range},
	get_square_random_monster_target1(Camp,AllMons, Number, R, []).

get_square_random_monster_target1(_Camp,[],_Number,_R,L) -> L;
get_square_random_monster_target1(_Camp,_Mons,0,_R,L) -> L;
get_square_random_monster_target1(Camp,Mons,Number,R,L) ->
	[H|T] = Mons,
	InSquare = is_pos_in_range(H#r_mon_info.pos_x,H#r_mon_info.pos_y,R),	%%  不能打到守塔怪
	if InSquare =:= true andalso H#r_mon_info.hp > 0 andalso H#r_mon_info.template#ets_monster_template.camp =/= Camp ->
			get_square_random_monster_target1(Camp,T,Number-1,R,[H|L]);
		true ->
			get_square_random_monster_target1(Camp,T,Number,R,L)
	end.
	
%% 获取正方形内指定数量的守塔怪物对象
get_square_random_tower_target(X,Y,Range,Number) ->
	AllMons = get_tower_mon_dic(),
	R = {X-Range,Y-Range,X+Range,Y+Range},
	get_square_random_tower_target1(AllMons, Number, R, []).

get_square_random_tower_target1([],_Number,_R,L) -> L;
get_square_random_tower_target1(_Mons,0,_R,L) -> L;
get_square_random_tower_target1(Mons,Number,R,L) ->
	[H|T] = Mons,
	InSquare = is_pos_in_range(H#r_mon_info.pos_x,H#r_mon_info.pos_y,R),	%%  只能打到守塔怪
	if InSquare =:= true andalso H#r_mon_info.hp > 0 andalso H#r_mon_info.monster_type >= ?Tower_Target_Mon ->
			get_square_random_tower_target1(T,Number-1,R,[H|L]);
		true ->
			get_square_random_tower_target1(T,Number,R,L)
	end.


%% 以上战斗用

%%  获取场景内要广播的范围用户信息
get_broadcast_user(Q, X0, Y0) ->
    AllUser = get_scene_user(Q),
    Slice9 = get_9_slice(X0, Y0),
    get_broadcast_user_loop(AllUser, Slice9, []).

%%  获取场景内要广播的范围用户信息(本节点)
get_broadcast_user_node(Q, X0, Y0) ->
    AllUser = get_scene_user_node(Q),
    Slice9 = get_9_slice(X0, Y0),
    get_broadcast_user_loop(AllUser, Slice9, []).

get_broadcast_user_loop([], _Slice9, D) -> 
	D;
get_broadcast_user_loop([User|T], Slice9, D) ->
%%     [User, _] = S,
    InSlice = is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, Slice9),
	if
		InSlice =:= true ->
%% 			get_broadcast_user_loop(T, Slice9, D++[User]);
			get_broadcast_user_loop(T, Slice9, [User|D]);
		true ->
			get_broadcast_user_loop(T, Slice9, D)
	end.
%% 获取场景内要广播的范围怪物信息
get_broadcast_mon(MapId, X0, Y0) ->
	AllMon = get_scene_mon(MapId),
	Slice9 = get_9_slice(X0, Y0),
	get_broadcast_mon_loop(AllMon, Slice9, []).

get_broadcast_mon_loop([], _Slice9, D) -> D;
get_broadcast_mon_loop([S|T], Slice9, D) ->
	[_, _, X, Y, HP, _] = S,
    InSlice = is_pos_in_slice(X, Y, Slice9),
	if InSlice =:= true andalso HP > 0 ->
%% 			get_broadcast_mon_loop(T, Slice9, D++[S]);
			get_broadcast_mon_loop(T, Slice9, [S|D]);
		true ->
			get_broadcast_mon_loop(T, Slice9, D)
	end.

%% 获取场景内要广播的范围掉落物信息
%% get_broadcast_drop(MapId, X0, Y0) ->
%% 	AllDrop = get_scene_drop_item(MapId),
%% 	Slice9 = get_9_slice(X0,Y0),
%% 	get_broadcast_drop_loop(AllDrop,Slice9,[]).
%% get_broadcast_drop_loop([],_Slice9,L) -> 
%% 	L;
%% get_broadcast_drop_loop([H|T], Slice9, L) ->
%% 	InSlice = is_pos_in_slice(H#r_drop_item.x,H#r_drop_item.y,Slice9),
%% 	if InSlice =:= true andalso H#r_drop_item.work_lock =:= false ->
%% 			NL = [H|L],
%% 			get_broadcast_drop_loop(T,Slice9,NL);
%% 		true ->
%% 			get_broadcast_drop_loop(T,Slice9,L)
%% 	end.

%% 本节点场景初始化
load_map(MapId, _MapPid) ->
	put(?DIC_MAP_OBJECT_AUTO_ID,1),
	MonList = data_agent:monster_template_get_by_mapid(MapId),
	Now = misc_timer:now_seconds(),
	load_mon(MonList, MapId, Now),

	CollectList = data_agent:collect_template_get_by_mapid(MapId),
	load_collect3(CollectList, MapId, Now),
	ok.

%% 副本怪物初始化、采集初始化
load_duplicate_map(MapId, MonList, Is_Dynamic, AverLevel,Min_Level,Is_First_Create,Now) ->
%%   put(?DIC_MAP_OBJECT_AUTO_ID,1),
   
   load_duplicate_mon(MonList, MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now),
   ok.

load_duplicate_collect(MapId) ->
	TemplateMapId = get_map_id(MapId),
	CollectList = data_agent:collect_template_get_by_mapid(TemplateMapId),
	load_collect3(CollectList, MapId, misc_timer:now_seconds()).

%%帮派篝火
guild_bonfire(GuildUser) ->
  case get_online_dic() of
    [] ->
       skip;
    AllUsers ->
       GuildNum = erlang:length(AllUsers),
       F = fun(Info) ->
             gen_server:cast(Info#ets_users.other_data#user_other.pid, {'guild_bonfire', GuildNum})
           end,
       lists:foreach(F, GuildUser)
  end.

%% 获取副本里的守塔的目标怪物
get_square_random_tower_mon() ->
	case get_tower_mon_dic() of
		[] ->
			[];
		MonList ->
			case lists:keyfind(?Tower_Target_Mon, #r_mon_info.monster_type, MonList) of
				false ->
					[];
				TowerMon ->
					TowerMon
			end
	end.

       

%%====================================================================
%% Local Functions
%%====================================================================
%%--------------------------副本地图加载mon------------------------------
load_duplicate_mon([], _, _Is_Dynamic, _AverLevel, _Min_Level, _Is_First_Create,_Now) ->
    ok;
load_duplicate_mon([H | T], MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now) ->
    {MonId, BornX, BornY} = H,
    case data_agent:monster_template_get(MonId) of
        [] ->
			
          load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now);
        MonTemp ->
          if
              Is_Dynamic =:= 0 ->
                 HP = MonTemp#ets_monster_template.max_hp,
                 AutoID = get(?DIC_MAP_MON_AUTO_ID),
                 MonInfo = lib_map_monster:mod_create_mon(MonTemp, MapId, BornX, BornY, HP, AutoID,Now),
                 put(?DIC_MAP_MON_AUTO_ID, AutoID + 1),

                 if
                      Is_First_Create =/= 1 ->
				         {ok, MonBin} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [MonInfo]),
						 mod_map_agent:send_to_map_scene(MonInfo#r_mon_info.map_id, MonInfo#r_mon_info.pos_x, MonInfo#r_mon_info.pos_y, MonBin),
                         load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now);                     
                      true ->
                          load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now)
                 end;                                 
                 
              true ->
                 case data_agent:dynamic_mon_templatee_get(AverLevel) of
                    [] ->                    
                       %%录表数据出错 或者队伍等级低于副本等级   按41级最低级处理
                       DynamicTemp = data_agent:dynamic_mon_templatee_get(41),
                       fun_load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, DynamicTemp,MonTemp,BornX, BornY, Min_Level,Is_First_Create,Now);
                    DynamicTemp ->               
                       fun_load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, DynamicTemp,MonTemp,BornX, BornY, Min_Level, Is_First_Create,Now)
                 end
          end
    end.


fun_load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, DynamicTemp,MonTemp,BornX, BornY, Min_Level, Is_First_Create,Now) ->
	?DEBUG("fun_load_duplicate_mon:~p",[MapId]),
   AutoID = get(?DIC_MAP_MON_AUTO_ID),

   Level =  MonTemp#ets_monster_template.level + (AverLevel - Min_Level),

   Hp = MonTemp#ets_monster_template.max_hp,
   NewHp = Hp * (DynamicTemp#ets_dynamic_mon_template.hp_modulus/100000000 ),
   NewHp1 = tool:ceil(NewHp),

   Attack = MonTemp#ets_monster_template.attack_physics,
   NewAttack = Attack * (DynamicTemp#ets_dynamic_mon_template.attack_modulus/100000000),
   NewAttack1 = tool:ceil(NewAttack),

   Defense = MonTemp#ets_monster_template.defanse_physics,
   NewDefense = Defense * (DynamicTemp#ets_dynamic_mon_template.defense_modulus/100000000),
   NewDefense1 = tool:ceil(NewDefense),
    
   Exp = MonTemp#ets_monster_template.exp,
   NewExp = Exp * (DynamicTemp#ets_dynamic_mon_template.exp_modulus/100000000),
   NewExp1 = tool:ceil(NewExp),

   NewMonTemp = MonTemp#ets_monster_template{
                               level = Level,
                               max_hp = NewHp1,
                               attack_physics = NewAttack1,
                               defanse_physics = NewDefense1,
                               exp = NewExp1},

   MonInfo = lib_map_monster:mod_create_mon(NewMonTemp, MapId, BornX, BornY, NewHp1, AutoID,Now),
   put(?DIC_MAP_MON_AUTO_ID, AutoID + 1),

	%% todo 需要改成一次性发送，不要独只发送
   if
        Is_First_Create =/= 1 ->
            {ok, MonBin} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [MonInfo]),
%% 			mod_map_agent:send_to_area_scene(MonInfo#r_mon_info.map_id, MonInfo#r_mon_info.pos_x, MonInfo#r_mon_info.pos_y, MonBin),
			mod_map_agent:send_to_map_scene(MonInfo#r_mon_info.map_id, MonInfo#r_mon_info.pos_x, MonInfo#r_mon_info.pos_y, MonBin),
			?DEBUG("send_to_map_scene:~p",[MonInfo#r_mon_info.map_id]),
            load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now);   
			
        true ->
            load_duplicate_mon(T, MapId, Is_Dynamic, AverLevel, Min_Level, Is_First_Create,Now)
   end.
  
   



%% --------------------------本节点加载mon--------------------------------
load_boss({MonId, MapId, BornX, BornY,Now}) ->%%可以应当单个怪物
    case data_agent:monster_template_get(MonId) of
        [] ->
			ok;
        MonTemp ->
			HP = MonTemp#ets_monster_template.max_hp,
			AutoID = get(?DIC_MAP_OBJECT_AUTO_ID),
			MonInfo = lib_map_monster:mod_create_mon(MonTemp,MapId,BornX,BornY,HP,AutoID,Now),
			{ok, MonBin} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, [MonInfo]),
			mod_map_agent:send_to_map_scene(MonInfo#r_mon_info.map_id, MonInfo#r_mon_info.pos_x, MonInfo#r_mon_info.pos_y, MonBin),
			put(?DIC_MAP_OBJECT_AUTO_ID,AutoID + 1)
	end.

load_mon([], _, _) -> ok;
load_mon([H | T], MapId, Now) ->
	%MonId = H#ets_monster_template.monster_id,
	HP = H#ets_monster_template.max_hp,
	L = H#ets_monster_template.lbornl_points,
	Lists = string:tokens(tool:to_list(L), "|"),
	lists:foreach(fun (S) -> load_mon1(S, MapId, H, HP, Now) end,Lists),
    load_mon(T, MapId, Now).

load_mon1(Borns, MapId, MonTemplate, HP, Now) ->
	try
		Pos = string:tokens(Borns, ","),
		case length(Pos) of
			2 ->	
				[BornX, BornY] = Pos,
				AutoID = get(?DIC_MAP_OBJECT_AUTO_ID),
				lib_map_monster:mod_create_mon(MonTemplate,MapId,tool:to_integer(BornX),tool:to_integer(BornY),HP,AutoID,Now),
				put(?DIC_MAP_OBJECT_AUTO_ID,AutoID + 1);
			_ ->
				?ERROR_MSG("load_mon1 Borns Reason:~s,~w,MapId:~w ~n",[Borns,MonTemplate#ets_monster_template.monster_id,MapId])
		end
	catch
		_:Reason ->
			?ERROR_MSG("load_mon1 Reason:~w,~w,~w ~n",[MonTemplate#ets_monster_template.monster_id,Borns,Reason])
	end.

%% --------------------------本节点加载collect--------------------------------
load_collect3([], _, _) -> ok;
load_collect3([H | T], MapId, Now) ->
	%CollectId = H#ets_collect_template.template_id,
	L = H#ets_collect_template.lbornl_points,
	Lists = string:tokens(tool:to_list(L), "|"),
	lists:foreach(fun (S) -> 
						load_collect1(S, MapId, H, Now) 
					end,Lists),
    load_collect3(T, MapId, Now).

load_collect1(Borns, MapId, CollectTemplate, Now) ->
	try
		Pos = string:tokens(Borns, ","),
		case length(Pos) of
			2 ->
				[BornX, BornY] = Pos,
				AutoID = get(?DIC_MAP_OBJECT_AUTO_ID),
				lib_map_collect:create_collect(CollectTemplate, MapId, tool:to_integer(BornX), tool:to_integer(BornY), AutoID,Now),
				put(?DIC_MAP_OBJECT_AUTO_ID,AutoID + 1);
			_ ->
				?ERROR_MSG("load_collect1 Borns Reason:~p ~n",[{Borns,MapId}])
		end
	catch
		_:Reason ->
			?ERROR_MSG("load_collect1 Reason:~w ~n",[Reason])
	end.
%%根据采集物模版信息配置的坐标加载采集物
load_collect(MapId,CollectId) ->
	case data_agent:collect_get(CollectId) of
		[] ->
			skip;
		Temp ->			
			List = tool:split_string_to_intlist(Temp#ets_collect_template.lbornl_points),
			load_collect2(List, Temp, MapId, misc_timer:now_seconds())
	end.
%%根据采集物id 与 坐标加载采集物
load_collect(MapId,CollectId,PosList) ->
	case data_agent:collect_get(CollectId) of
		[] ->
			skip;
		Temp ->			
			load_collect2(PosList, Temp, MapId, misc_timer:now_seconds())
	end.
load_collect2([], _Temp, _MapId, _Now) ->
	ok;
load_collect2([H|L], Temp, MapId, Now) ->
	{X,Y} = H,
	AutoID = get(?DIC_MAP_OBJECT_AUTO_ID),
	CollectInfo = lib_map_collect:create_collect(Temp, MapId, X, Y, AutoID, Now),
	{ok, BinData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, [CollectInfo]),
	mod_map_agent:send_to_map_scene(CollectInfo#r_collect_info.map_id, 
											CollectInfo#r_collect_info.x, 
											CollectInfo#r_collect_info.y, 
											BinData),
	put(?DIC_MAP_OBJECT_AUTO_ID,AutoID + 1),
	load_collect2(L, Temp, MapId, Now).

%% 返回职业出生点
return_career_born(Career) ->
	case Career of
		?CAREER_YUEWANG ->
			?MAP_YUEWANG_DEFAULT;
		?CAREER_HUAJIAN ->
			?MAP_HUAJIAN_DEFAULT;
		?CAREER_TANGMEN ->
			?MAP_TANGMEN_DEFAULT;
		_ ->
			?MAP_YUEWANG_DEFAULT
	end.

%%帮会突袭活动结束奖励采集宝箱
raid_active_award(MapId,Num) ->	
	case data_agent:collect_get(?GUILD_RAID_ACTIVE_AWARD_ITEM_ID) of
		[] ->
			skip;
		Temp ->
			NewNum = if Num > 100 -> 100; true -> Num end,
			List = lists:sublist(?GUILD_RAID_ACTIVE_AWARD_POS_LIST, NewNum),
			load_collect2(List, Temp, MapId, misc_timer:now_seconds())
	end.

%% return_to_map(MapId) ->
%% 	case is_copy_scene(MapId) of
%% 		true ->
%% 			return_career_born(MapId);
%% 		_ ->
%% 			return_career_born(MapId)
%% 	end.		



%% 进入门
door_enter(Status, DoorId) ->
	case data_agent:door_template_get(DoorId) of
		[] ->
			%% 没有找到门
			skip;
		Door ->
			Map_id = Door#ets_door_template.next_map_id,%%.other_data#ets_door_template.current_map_id,
			case can_enter_map(Status, Door) of
				true ->
					case can_enter_duplicate_map(Status, Map_id, Door#ets_door_template.door_id) of 
					{OnlyMapId, NewMapPid} ->
						mod_map:leave_scene(Status#ets_users.id, 
											Status#ets_users.other_data#user_other.pet_id,
											Status#ets_users.current_map_id, 
											Status#ets_users.other_data#user_other.pid_map, 
											Status#ets_users.pos_x, 
											Status#ets_users.pos_y,
											Status#ets_users.other_data#user_other.pid,
											Status#ets_users.other_data#user_other.pid_locked_monster),

%% 						Pid_Map = mod_map:get_scene_pid(Door#ets_door_template.other_data#ets_door_template.current_map_id),
						Other = Status#ets_users.other_data#user_other{
																		pid_map = NewMapPid,
																		walk_path_bin=undefined,
																		map_template_id=Map_id %%Door#ets_door_template.other_data#ets_door_template.current_map_id
																		},
						NewStatus = Status#ets_users{
													current_map_id= OnlyMapId, %%Door#ets_door_template.other_data#ets_door_template.current_map_id,
													pos_x=Door#ets_door_template.next_pos_x,%%.other_data#ets_door_template.pos_x,
													pos_y=Door#ets_door_template.next_pos_y,%%.other_data#ets_door_template.pos_y,
													other_data=Other
													},
						{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [
												  Map_id,
												  NewStatus#ets_users.pos_x,
												  NewStatus#ets_users.pos_y]),
						lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, EnterData),
						%%如果进入一下几张地图，修改玩家战斗模式
						NewStatus1 = enter_map_and_change_pk_mode(Map_id, NewStatus),
						{ok, NewStatus1};
					_er ->
						?WARNING_MSG("enter map is not condition:~p",[_er]),
						error
					end;
				_e ->
						%?WARNING_MSG("enter map is not condition:~p",[_e]),
						error
			end					   
	end.

enter_map_and_change_pk_mode(MapId, Status) ->
	if
		Status#ets_users.level < 30 ->
			Status;
		MapId =:= 251 orelse MapId =:= 252 orelse MapId =:= 261 orelse MapId =:= 262 orelse MapId =:= 271
			orelse MapId =:= 272 orelse MapId =:= 281 orelse MapId =:= 291 ->
			Now = misc_timer:now_seconds(),
			NewStatus = Status#ets_users{pk_mode = ?PKMode_GOODNESS, pk_mode_change_date = Now},
			{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_GOODNESS, Now]),
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, BinData),
			NewStatus;
		true ->
			Status		
	end.

can_enter_duplicate_map(Status, Map_id, Door_id) ->
	if Door_id < ?MIN_DUPLICATE_DOOR ->
		lib_duplicate:quit_duplicate(Status#ets_users.other_data#user_other.pid_dungeon,
													Status#ets_users.id,
													Status#ets_users.current_map_id),	
		{Map_id, undefined};
	is_pid(Status#ets_users.other_data#user_other.pid_dungeon) =:= true ->
			%?DEBUG("can_enter_duplicate_mapDDDDDDDDDDDDDDDDDDDDDD:~p",[1]),
			case gen_server:call(Status#ets_users.other_data#user_other.pid_dungeon, {'enter_next', Map_id, Status#ets_users.id}) of
				{ok, Map_Pid, OnlyMapId} ->
					gen_server:cast(Status#ets_users.other_data#user_other.pid_map, {close_duplicate_map}),%%关闭上层副本
					{OnlyMapId, Map_Pid};
				_error ->					
					?WARNING_MSG("copy enter next door error:~p",[_error]),
					false
			end;
	true ->
		false
	end.


%% 玩家能否进入地图 
can_enter_map(Status, Door) ->
	if
		Status#ets_users.other_data#user_other.map_template_id =:= Door#ets_door_template.current_map_id
			 andalso abs(Status#ets_users.pos_x - Door#ets_door_template.pos_x) < 100
			 andalso abs(Status#ets_users.pos_y - Door#ets_door_template.pos_y) < 100 ->
				case data_agent:map_template_get(Door#ets_door_template.next_map_id) of
					[] ->
						false;
					MapInfo when MapInfo#ets_map_template.other_data#map_other.min_level < Status#ets_users.level 
							andalso MapInfo#ets_map_template.other_data#map_other.max_level > Status#ets_users.level ->
						true;
					_ ->
						false
				end;
		true ->
			?WARNING_MSG("can_enter_map:~p",[{Status#ets_users.current_map_id, Door#ets_door_template.door_id,
												Status#ets_users.pos_x,Status#ets_users.pos_y,Door#ets_door_template.current_map_id,Door#ets_door_template.pos_x,Door#ets_door_template.pos_y}]),
			false
	end.

%% 更新玩家地图位置
update_player_team(UserId, TeamId, PidTeam) ->
	List = get_online_dic(),
	case lists:keyfind(UserId, #ets_users.id, List) of
		false ->
			skip;
		User ->
			Other = User#ets_users.other_data#user_other{pid_team = PidTeam},
			NewUser = User#ets_users{team_id = TeamId,
								 other_data = Other
								 },
			update_online_dic(NewUser)
	end.

%% 更新玩家地图位置
update_player_pos(UserId, PosX, PosY, Index) ->
	List = get_online_dic(),
	case lists:keyfind(UserId, #ets_users.id, List) of
		false ->
			skip;
		User ->
			OldX = User#ets_users.pos_x,
			OldY = User#ets_users.pos_y,
			Other = User#ets_users.other_data#user_other{index=Index},
			NewUser = User#ets_users{pos_x=PosX, pos_y=PosY, other_data=Other},
			update_online_dic(NewUser),
			update_player_pos_out_slice(NewUser, OldX, OldY, PosX, PosY)
	end.

%% 	如果跨过九宫格就发送
update_player_pos_out_slice(Status, X1, Y1, X2, Y2) ->
	case is_same_slice(X1,
							   Y1,
							   X2,
							   Y2) of
		false ->
			change_player_position(Status, X1, Y1),
			MapId = Status#ets_users.current_map_id,
%% 			Pid_player = Status#ets_users.other_data#user_other.pid,
			EnterSlice = get_9_slice(X2, Y2),
			OldSlice = get_9_slice(X1, Y1),

			AllUser = get_online_dic(),
			FUser = fun(User, {EnterUser, LeaveUser})->
					InEnterSlice = is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, EnterSlice),
					InOldSlice = is_pos_in_slice(User#ets_users.pos_x, User#ets_users.pos_y, OldSlice),
					if 
						InEnterSlice == true andalso InOldSlice == false  ->
							{[User|EnterUser], LeaveUser};
						InEnterSlice == false andalso InOldSlice == true  ->
							{EnterUser, [{User#ets_users.id, User#ets_users.other_data#user_other.pet_id}|LeaveUser]};
						true ->
							{EnterUser, LeaveUser}
					end
				end,
			{EnterUser1, LeaveUser1} = lists:foldl(FUser, {[],[]}, AllUser),
			if length(EnterUser1) > 0 ->
					{ok, EnterUserData} = pt_12:write(?PP_MAP_USER_ADD, EnterUser1),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, EnterUserData);
				true ->
					skip
			end,

			if length(LeaveUser1) > 0 ->
					{ok, LeaveUserData} = pt_12:write(?PP_MAP_USER_REMOVE, LeaveUser1),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, LeaveUserData);
				true ->
					skip
			end,
			

			AllMon = get_mon_dic(),
			FMon = fun(Mon, NewMon)->
					InEnterSlice = is_pos_in_slice(Mon#r_mon_info.pos_x, Mon#r_mon_info.pos_y, EnterSlice),
					InOldSlice = is_pos_in_slice(Mon#r_mon_info.pos_x, Mon#r_mon_info.pos_y, OldSlice),
					if 
						InEnterSlice == true andalso InOldSlice == false andalso Mon#r_mon_info.hp > 0 ->
							[Mon|NewMon];
						true ->
							NewMon
					end
				end,
			Mons = lists:foldl(FMon, [], AllMon),
			if length(Mons) > 0 ->
					{ok, MonData} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, Mons),
%% 					gen_server:cast(Pid_player, {send_to_sid, MonData});
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,MonData);
				true ->
					skip
			end,

			AllTowerMon = get_tower_mon_dic(),
			TowerMons = lists:foldl(FMon,[],AllTowerMon),
			if length(TowerMons) > 0 ->
					{ok, TowerMonData} = pt_12:write(?PP_MAP_MONSTER_INFO_UPDATE, TowerMons),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,TowerMonData);
				true ->
					skip
			end,

			AllCollect = get_collect_dic(),
 			FCollect = fun(Collect, CollectList) ->
					InEnterSlice = is_pos_in_slice(Collect#r_collect_info.x, Collect#r_collect_info.y, EnterSlice),
					InOldSlice = is_pos_in_slice(Collect#r_collect_info.x, Collect#r_collect_info.y, OldSlice),
					if 
						InEnterSlice == true andalso 
							InOldSlice == false andalso 
							Collect#r_collect_info.state =/= 0 ->
							[Collect|CollectList];
						true ->
							CollectList
					end
				end,
			Collects = lists:foldl(FCollect, [], AllCollect),
			if length(Collects) > 0 ->
				{ok, CollectData} = pt_12:write(?PP_MAP_COLLECT_UPDATE, Collects),
%% 				gen_server:cast(Pid_player, {send_to_sid, CollectData});
				lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, CollectData);
			true ->
				skip
			end,

			%%		添加掉落
			AllDrop = get_scene_drop_item(MapId),
			FDrop = fun(Drop, L) -> 
						NX = [Drop],
						InEnterSlice = is_pos_in_slice(Drop#r_drop_item.x,Drop#r_drop_item.y,EnterSlice),
						InOldSlice = is_pos_in_slice(Drop#r_drop_item.x,Drop#r_drop_item.y,OldSlice),
						if
							InEnterSlice == true andalso InOldSlice == false andalso Drop#r_drop_item.work_lock =:= false  ->
								[NX|L];
							true ->
								L
						end
					end,

			Drops = lists:foldl(FDrop,[],AllDrop),
			if length(Drops) > 0 ->
					{ok, DropBin} = pt_23:write(?PP_TARGET_DROPITEM_ADD,Drops),
%% 					gen_server:cast(Pid_player, {send_to_sid, DropBin});
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, DropBin);
				true ->
					skip
			end;
		_ ->
			skip

	end.

%%更新玩家血量
update_player_hp_mp(UserId, Hp, Mp) ->
	List = get_online_dic(),
	case lists:keyfind(UserId, #ets_users.id, List) of
		false ->
			skip;
		User ->
			NewUser = User#ets_users{current_hp = Hp, current_mp = Mp},
			update_online_dic(NewUser)
	end.
%% 	case ets:lookup(?ETS_SCENE_BATTLE_OBJECT, UserId) of
%% 		[] ->
%% 			skip;
%% 		[Battle] ->
%% 			NewBattle = Battle#battle_object_state{hp = Hp, mp = Mp},
%% 			ets:insert(?ETS_SCENE_BATTLE_OBJECT, NewBattle)
%% 	end.

%获取队友信息
get_teammate_info(TeamPid,LocalX,LocalY) ->
	InSlice = get_9_slice(LocalX, LocalY),
	get_teammate_info_detail(TeamPid,get_online_dic(),[],InSlice).

get_teammate_info_detail(_TeamPid,[],OutList,_EnterSlice) -> OutList;
get_teammate_info_detail(TeamPid,List,OutList,EnterSlice) ->
	[H|T] = List,
	InSlice = is_pos_in_slice(H#ets_users.pos_x, H#ets_users.pos_y, EnterSlice),
	NewList =
		if H#ets_users.other_data#user_other.pid_team =:= TeamPid andalso InSlice  ->
				[H|OutList];
			true ->
				OutList
		end,
	get_teammate_info_detail(TeamPid,T,NewList,EnterSlice).

%获取地图上没有组队的人物信息
get_scene_user_with_no_team(TeamList, UserID, PidSend) ->
	AllL = get_online_dic(),
	NewTeamList = get_scene_user_with_no_team1(TeamList,AllL,[]),
	PlayerList = get_scene_user_with_no_team2(AllL,UserID,[]),
%%    ?DEBUG("NewTeamList INFO~p", [NewTeamList]),
%% 	?DEBUG("PlayerList INFO~p", [PlayerList]),
	{ok, DataBin} = pt_17:write(?PP_TEAM_NOFULL_MSG, [NewTeamList, PlayerList]),
 	lib_send:send_to_sid(PidSend, DataBin).

%分开来查找次数会少些
get_scene_user_with_no_team1([], _AllL, NewTeamList) -> NewTeamList;
get_scene_user_with_no_team1(TeamList,AllL,NewTeamList) ->
%% 	?DEBUG("Team List ~p", [TeamList]),
%% 	?DEBUG("All List ~p", [AllL]),
	[H|T] = TeamList,
	case lists:keyfind(H#ets_team.leaderid,#ets_users.id,AllL) of
		false ->
			get_scene_user_with_no_team1(T,AllL,NewTeamList);
		V ->
			get_scene_user_with_no_team1(T,AllL,[H#ets_team{leader_level=V#ets_users.level}|NewTeamList])
	end.

get_scene_user_with_no_team2([],_UserID,OutList) -> OutList;
get_scene_user_with_no_team2(UserList,UserID,OutList) ->
	[H|T] = UserList,
	if H#ets_users.id =/= UserID andalso H#ets_users.other_data#user_other.pid_team =:= undefined ->
			get_scene_user_with_no_team2(T,UserID,[{H#ets_users.id,H#ets_users.nick_name}|OutList]);
		true ->
			get_scene_user_with_no_team2(T,UserID,OutList)
	end.
		
%% ----------------------------map send -------------------------------
%% 发送地图所有玩家
map_send_all(BinData) ->
	List = get_online_dic(),
 	F = fun(Info) ->
		lib_send:send_to_sid(Info#ets_users.other_data#user_other.pid_send, BinData)
	end,
	lists:foreach(F, List).

%% 发送地图区域玩家
map_send_area(BinData, X, Y) ->
	map_send_area(BinData, X, Y, 0).
map_send_area(BinData, X, Y, ExceptId) ->
	List = get_online_dic(),
	Slice9 = get_9_slice(X, Y),
 	F = fun(Info) ->
		InSlice = is_pos_in_slice(Info#ets_users.pos_x, Info#ets_users.pos_y, Slice9),
		if InSlice == true andalso ExceptId =/= Info#ets_users.id ->
				lib_send:send_to_sid(Info#ets_users.other_data#user_other.pid_send, BinData);
			true ->
				skip
		end
	end,
	lists:foreach(F, List).


%%打钱地图掉落
award_with_drop(DropNum, AwardCopper, MapId, UserId, PosX, PosY, SendPid) ->
	award_with_drop1(DropNum, AwardCopper, MapId, ?DUPLICATE_DROP_GOLD_POS_LIST,UserId),
	[_SceneMon,_SceneCollect,_SceneNpc, SceneDrop] = get_scene_info_in_slice(PosX, PosY),
	{ok, DropBin} = pt_23:write(?PP_TARGET_DROPITEM_ADD,[new,SceneDrop]),
	lib_send:send_to_sid(SendPid, DropBin).

%%只适合在经济物品中掉落(掉落次数,)
award_with_drop1(0, _Amount, _MapId, _DropPos, _OwnId) ->
	ok;
award_with_drop1(DropNum, Amount1, MapId, [{X, Y}|PosList], OwnId) ->
	ID = get_drop_auto_id(),
	{DropItemId, Amount} =	if DropNum rem 10 =:= 0 -> %%掉落的是绑定铜币或绑定元宝
								{?CURRENCY_TYPE_BIND_YUANBAO, 1};
							true ->
								{?CURRENCY_TYPE_BIND_COPPER, Amount1}
							end,

	DropItem = #r_drop_item{
								id = ID,
								map_id = MapId,
								x = X,
								y = Y,
								owner_id = OwnId,
								amount = Amount,
								item_template_id = DropItemId,
								drop_time = misc_timer:now_seconds(),
								state = lock
								%%ownteampid = OwnTeamPid
							},
	add_drop_dic(DropItem),
award_with_drop1(DropNum - 1, Amount1 , MapId, PosList, OwnId).
%%----------------------------------------------------------------------------


%% update_user_onmap(ID, UpdateList) ->
%% 	UserOnMap = get_map_user(ID),
%% 	update_map_user_dic(UserOnMap).
%% 
%% update_user_onmap1([],UserOnMap) -> UserOnMap;
%% update_user_onmap1([H|T], UserOnMap) ->
%% 	if is_record(H, user_onmap_update) ->
%% 			NewUserOnMap = update_user_onmap2(H, UserOnMap),
%% 			update_user_onmap1(T, NewUserOnMap);
%% 		true ->
%% 			update_user_onmap1(H, UserOnMap)
%% 	end.

%% update_user_onmap2(Update,UserOnMap) ->
%% 	case Update#user_onmap_update.key of
%% 		{pid} ->
%% 			ok;
%% 		{pid_send} -> ok;
%% 		{current_hp} -> ok;
%% 		{current_mp} -> ok;
%% 		{level} -> ok;
%% 
%% 		{club_id} -> ok;
%% 		{team_id} -> ok;
%% 		{camp} -> ok;
%% 					
%% 		{pos_x} -> ok;
%% 		{pos_y} -> ok;
%% 					
%% 		{pk_mode} -> ok;
%% 		{pk_value} -> ok;
%% 		{war_state} -> ok;
%% 							
%% 		{user_id} -> ok;
%% 		{guild_level} -> ok;
%% 		{total_feats} -> ok;
%% 		{walk_path_bin} -> ok;
%% 		{skill_list} -> ok;
%% 		{buff_list} -> ok;
%% 		{remove_buff_list} -> ok;
%% 		{buff_temp_info} -> ok;
%% 		{equip_weapon_type} -> ok;
%% 		{sit_state} -> ok;
%% 		{double_sit_id} -> ok;
%% 		{horse_speed} -> ok;
%% 		{speed} -> ok;
%% 		{blood_buff} -> ok;
%% 		{magic_buff} -> ok;
%% 		{exp_buff} -> ok;
%% 		{club_name} -> ok;
%% 		{club_job} -> ok;
%% 		{escort_state} -> ok;
%% 		{player_now_state} -> ok;
%% 		{player_standup_date} -> ok;
%% 	
%% 		{total_life_experiences} -> ok;
%% 		{max_physical} -> ok;
%% 		{hp_revert} -> ok;
%% 		{mp_revert} -> ok;
%% 		{total_hp} -> ok;
%% 		{total_mp} -> ok;
%% 		{attack } -> ok;
%% 		{defense} -> ok;
%% 		{magic_hurt } -> ok;
%% 		{mump_hurt } -> ok;
%% 		{far_hurt } -> ok;
%% 		{hit_target } -> ok;
%% 		{duck } -> ok;
%% 		{keep_off } -> ok;
%% 		{power_hit } -> ok;
%% 		{deligency } -> ok;
%% 		{magic_defense } -> ok;
%% 		{mump_defense } -> ok;
%% 		{far_defense } -> ok;
%% 		{mump_avoid_in_hurt } -> ok;
%% 		{far_avoid_in_hurt } -> ok;
%% 		{magic_avoid_in_hurt } -> ok;
%% 		{abnormal_rate } -> ok;
%% 		{anti_abnormal_rate } -> ok;
%% 		{attack_suppression } -> ok;
%% 		{defense_suppression } -> ok;
%% 		{move_speed } -> ok;
%% 		{attack_speed } -> ok;
%% 				   %%临时属性，由于buff等影响
%% 		{tmp_totalhp } -> ok;
%% 		{tmp_totalmp } -> ok;
%% 		{tmp_attack } -> ok;
%% 		{tmp_defense } -> ok;
%% 		{tmp_magic_hurt } -> ok;
%% 		{tmp_far_hurt } -> ok;
%% 		{tmp_mump_hurt } -> ok;
%% 		{tmp_hit_target } -> ok;
%% 		{tmp_duck } -> ok;
%% 		{tmp_keep_off } -> ok;
%% 		{tmp_power_hit } -> ok;
%% 		{tmp_deligency } -> ok;
%% 		{tmp_magic_defense } -> ok;
%% 		{tmp_mump_defense } -> ok;
%% 		{tmp_far_defense } -> ok;
%% 		{tmp_magic_avoid_in_hurt } -> ok;
%% 		{tmp_mump_avoid_in_hurt } -> ok;
%% 		{tmp_far_avoid_in_hurt } -> ok;
%% 		{tmp_move_speed } -> ok;
%% 		{tmp_attack_speed } -> ok;
%% 					%其他战斗属性
%% 		{damage } -> ok;
%% 		{mump_damage } -> ok;
%% 		{magic_damage } -> ok;
%% 		{far_damage } -> ok;
%% 		{damage_to_shangwu } -> ok;
%% 		{damage_to_xiaoyao } -> ok;
%% 		{damage_to_liuxing } -> ok;
%% 		{damage_from_shangwu } -> ok;
%% 		{damage_from_xiaoyao } -> ok;
%% 		{damage_from_liuxing } -> ok;
%% 					%战斗
%% 		{battle_info } -> ok
%% 	end.