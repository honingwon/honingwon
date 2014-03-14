%% Author: Administrator
%% Created: 2011-3-3
%% Description: 地图信息
-module(pt_12).

%%
%% Exported Functions
%%
-export([read/2, write/2,writepath/2]).
-include("common.hrl").


%%
%%客户端 -> 服务端 ----------------------------
%%
read(?PP_PLAYER_MOVE_AUTO, <<>>) ->
	{ok, []};

%%取地图人物信息
read(?PP_MAP_ROUND_INFO,<<>>) ->
	{ok, []};


%% 进入地图
read(?PP_MAP_ENTER, <<DoorId:32/signed>>)->
	{ok, [DoorId]};

%%玩家移动
read(?PP_PLAYER_MOVE, Bin) ->
	<<ID:64, WalkPathBin/binary>> = Bin,
	{ok,[ID, WalkPathBin]};
	


%%玩家移动同步
read(?PP_PLAYER_MOVE_STEP,<<X:32, Y:32, Index:16>>) ->
	{ok, [X, Y, Index]};

%% type 1:回城复活，2：原地计时复活，3：原地健康复活
read(?PP_PLAYER_RELIVE, <<Type:8>>) ->
	{ok,[Type]};

%%打坐开始和取消
read(?PP_SIT_START_OR_CANCLE, <<Sit:8>>) ->
	{ok, [Sit]};

%%修为开始和取消
read(?PP_XW_START_OR_CANCLE, <<Sit:8>>) ->
	{ok, [Sit]};

%%双修打坐邀请
read(?PP_SIT_INVITE, Bin) ->
	{NickName, BinData} = pt:read_string(Bin),
    <<ID:64, _BinData1/binary>> = BinData,
	{ok, [NickName, ID]};

%%双修打坐邀请回复
read(?PP_SIT_INVITE_REPLY, <<Sit_Or_Not:8,SourceID:64>>) ->
	{ok, [Sit_Or_Not, SourceID]};

%%挂机技能设置
read(?PP_PLAYER_HANGUPDATA, Bin) ->
	{Hangup, _Bin1} = pt:read_string(Bin),
	{ok,[Hangup]};

%% 玩家进入副本
read(?PP_ENTER_DUPLICATE, <<DuplicateId:32>>) ->
	{ok, [DuplicateId]};

%% 玩家退出副本
read(?PP_QUIT_DUPLICATE, _) ->
	{ok, []};

%% 进入vip地图
read(?PP_ENTER_VIPMAP, <<Id:32>>) ->
	{ok, [Id]};

%% 退出vip地图
read(?PP_QUIT_VIPMAP, _) ->
	{ok, []};

read(?PP_PLAYER_FOLLOW, _R) ->
	{ok};

%%统计玩家进入副本次数
read(?PP_COPY_ENTER_COUNT, _R) ->
	{ok, []};

%% 技能重生
read(?PP_SKILL_RELIVE, _) ->
	{ok, []};

%% 战场列表
read(?PP_FREE_WAR_LIST, _) ->
	{ok, []};

%% 战场用户列表
read(?PP_FREE_WAR_USER_LIST, <<Id:64>>) ->
	{ok, Id};


%% 进入战场
read(?PP_ENTER_FREE_WAR, <<Id:64>>) ->
	{ok, Id};

%% 退出战场
read(?PP_QUIT_FREE_WAR, _) ->
	{ok, []};

%% 自由战场结果
read(?PP_FREE_WAR_RESULT, <<Id:64>>) ->
	{ok, Id};

%% 领取战场奖励
read(?PP_FREE_WAR_AWARD, _) ->
	{ok, []}; 

%% 战场复活
read(?PP_FREE_WAR_RELIVE, <<Type:8>>) ->
	{ok, [Type]}; 

%% 战斗信息
read(?PP_FREE_WAR_USER_INFO, _) ->
	{ok, []};
%% 释放下波怪物
read(?PP_OPEN_NEXT_MONSTER, _) ->
	{ok, []};
%% 随机掉落铜币数量
read(?PP_RAND_MONEY, _) ->
	{ok, []};
%% 返回商品可购买数量
read(?PP_DUPLICATE_SHOP_SALE_NUM, <<NpcID:32,ShopID:32>>) ->
	%%?DEBUG("PP_DUPLICATE_SHOP_SALE_NUM:~p",[{NpcID,ShopID}]),
	{ok, [NpcID,ShopID]};
%% 请求购买
read(?PP_DUPLICATE_SHOP_BUY, <<ShopItemID:32,Count:32>>) ->
	{ok, [ShopItemID,Count]};
%%用户掉线后请求重新连接返回副本信息
read(?PP_COPY_INFO, _) ->
	{ok, []};
%%用户出副本后抽奖
read(?PP_COPY_LOTTERY, _) ->
	{ok, []};
%% 清除副本次数限制
read(?PP_COPY_LIMIT_NUM_RESET, <<DupID:32>>) ->
	{ok, [DupID]};
%%用户进入试炼副本
read(?PP_ENTER_CHALLENGE_BOSS, <<MissionIndex:32>>) ->
	{ok, [MissionIndex]};
%%用户挑战下一个试炼副本boss
read(?PP_CHALLENGE_NEXT_BOSS, <<MissionIndex:32>>) ->
	{ok, [MissionIndex]};
%%请求用户试炼副本信息
read(?PP_CHALLENGE_BOSS_INFO, _) ->
	{ok, []};

%%请求试炼副本当天挑战奖励次数
read(?PP_CHALLENGE_AWARD_NUM, _) ->
	{ok, []};

read(Cmd, _R) ->
	?WARNING_MSG("pt_12 read:~w", [Cmd]),
    {error, no_match}.

	
%%
%%服务端 -> 客户端 ----------------------------
%%

%% 进入地图
write(?PP_MAP_ENTER,[MapID,X,Y]) ->
	Data = <<MapID:32,
			 X:32,
			 Y:32>>,
	{ok, pt:pack(?PP_MAP_ENTER,Data)};

%%地图用户添加
%% write(?PP_MAP_USER_ADD, [User, Bin]) ->
write(?PP_MAP_USER_ADD, List) ->
	
	N = length(List),
	
	F = fun(User) ->
				
				UserID = User#ets_users.id,
				TotalHP = User#ets_users.other_data#user_other.total_hp + User#ets_users.other_data#user_other.tmp_totalhp ,
				CurrentHP = User#ets_users.current_hp,
				TotalMP = User#ets_users.other_data#user_other.total_mp + User#ets_users.other_data#user_other.tmp_totalmp,
				CurrentMP = User#ets_users.current_mp,
				FigureBin = pt:packet_figure_player(User),

				Speed =  User#ets_users.other_data#user_other.speed,
				Is_Darts = User#ets_users.darts_left_time,
				EscortState =  User#ets_users.other_data#user_other.escort_state,
				
				PosX = User#ets_users.pos_x,
				PosY = User#ets_users.pos_y,	
				 
				PlayerNowState = User#ets_users.other_data#user_other.player_now_state,
				
				PetId = User#ets_users.other_data#user_other.pet_id,
				PetTemplateId = User#ets_users.other_data#user_other.pet_template_id,
				PetStyleId = User#ets_users.other_data#user_other.style_id,
				PetNick = pt:write_string(User#ets_users.other_data#user_other.pet_nick),

				case is_binary(User#ets_users.other_data#user_other.walk_path_bin) of
					true ->
				%% 			WalkPathBin = Bin;
						WalkPathBin = User#ets_users.other_data#user_other.walk_path_bin;
					_ ->
						WalkPathBin = <<0:16>>
				end,
				TempBuff = User#ets_users.other_data#user_other.exp_buff ++ User#ets_users.other_data#user_other.buff_list ++ 
						User#ets_users.other_data#user_other.blood_buff ++ User#ets_users.other_data#user_other.magic_buff,
				TotalBuff = lib_buff:filter_exist_buff(TempBuff),
				BuffLength = length(TotalBuff),
				TempBuffBin = pt:writebuff(TotalBuff,<<>>),
				BuffBin = <<
							BuffLength:16,
							TempBuffBin/binary
							>>,
				MarryBin = lib_marry:pack_marry_title(User),
				 <<
						 UserID:64,
						 (User#ets_users.other_data#user_other.war_state):8,
						 TotalHP:32,
						 CurrentHP:32,
						 TotalMP:32,						 
						 CurrentMP:32,
						 MarryBin/binary,
						 FigureBin/binary,
						 Speed:8,
 						 Is_Darts:32,
						 EscortState:8,
						 PosX:16,
						 PosY:16,
						 PlayerNowState:8,
						 (User#ets_users.other_data#user_other.index):16,
						 WalkPathBin/binary,
						 BuffBin/binary,
						 PetId:64, %%宠物Id
						 PetTemplateId:32,
						 PetStyleId:32,
						 PetNick/binary
						 
						 >>
				end,
	LB = tool:to_binary([F(X) || X <- List]),
	{ok, pt:pack(?PP_MAP_USER_ADD, <<N:16,LB/binary>>)};

write(?PP_REMOVE_MONSTER, [ID]) ->
	Data = <<ID:32>>,
	{ok, pt:pack(?PP_REMOVE_MONSTER,Data)};

%%地图用户删除
write(?PP_MAP_USER_REMOVE, List) ->
	N = length(List),
	F = fun({UserID,PetId}) ->
				<<
			 		UserID:64,
			 		PetId:64
			 	>>
		end,
	LB = tool:to_binary([F(X) || X <- List]),
	{ok,pt:pack(?PP_MAP_USER_REMOVE,<<N:16,LB/binary>>)};

%% write(?PP_MAP_USER_REMOVE, [UserID, PetId]) ->
%% 	N = 1,
%% 	Data = <<N:16,
%% 			 UserID:64,
%% 			 PetId:64
%% 			 >>,
%% 	{ok,pt:pack(?PP_MAP_USER_REMOVE,Data)};


%% 采集信息更新,state :采集类型：0消亡，1普通采集，2任务物品
write(?PP_MAP_COLLECT_UPDATE, L) ->
	N = length(L),
	F = fun(Info) ->
				if Info#r_collect_info.state =/= 0 ->
						<<(Info#r_collect_info.id):32,
						  (Info#r_collect_info.state):8,
						  (Info#r_collect_info.template_id):32,
						  (Info#r_collect_info.x):16,
						  (Info#r_collect_info.y):16
						  >>;
				   true ->
					   <<(Info#r_collect_info.id):32,
						 (Info#r_collect_info.state):8>>
				end
		end,
	LB = tool:to_binary([F(X) || X <- L]),
	{ok, pt:pack(?PP_MAP_COLLECT_UPDATE, <<N:16, LB/binary>>)};

	
	
%%怪物信息更新
write(?PP_MAP_MONSTER_INFO_UPDATE, L) ->
    N = length(L),
	
    F = fun(MonInfo) ->
			LengthPN = length(MonInfo#r_mon_info.last_path),
			PathBin = writepath(MonInfo#r_mon_info.last_path,<<>>),
			SPEED = erlang:max( util:ceil( MonInfo#r_mon_info.move_speed * (1+ MonInfo#r_mon_info.tmp_move_speed /100)),?SPEED_BUFF_REDUCE_MAX_EFFECT),
            <<(MonInfo#r_mon_info.id):32,  
			  0:8,
			  (MonInfo#r_mon_info.template_id):32, 
			  (MonInfo#r_mon_info.pos_x):32, 
			  (MonInfo#r_mon_info.pos_y):32, 
			  (MonInfo#r_mon_info.template#ets_monster_template.max_hp):32,
			  (MonInfo#r_mon_info.hp):32,
			  SPEED:8, %传递值为原值*10
			  LengthPN:16,
			  PathBin/binary
			  >>
    end,		
    LB = tool:to_binary([F(X) || X <- L]),
    {ok, pt:pack(?PP_MAP_MONSTER_INFO_UPDATE, <<N:32, LB/binary>>)};

%% 清除当前地图场景中全部掉落物品
write(?PP_CLEAR_DROPITEM_ALL, _) ->
	{ok, pt:pack(?PP_CLEAR_DROPITEM_ALL, <<0:32>>)};

%% 清除当前地图场景中全部怪物
write(?PP_CLEAR_MOUNSTER_ALL, TickTime) ->
	{ok, pt:pack(?PP_CLEAR_MOUNSTER_ALL, <<TickTime:32>>)};

%% 更新连击次数
write(?PP_UPDATE_BATTER_NUM, [BatterNum, Time, Award]) ->
	{ok, pt:pack(?PP_UPDATE_BATTER_NUM, <<BatterNum:32, Time:32, Award:32>>)};

%% 更新拾取货币数量
write(?PP_PICKUP_MONEY_AMOUNT, [MoneyType, Amount]) ->
	{ok, pt:pack(?PP_PICKUP_MONEY_AMOUNT, <<MoneyType:32, Amount:32>>)};
%% 杀死BOSS通知
write(?PP_KILL_BOSS, MissionId) ->
	{ok, pt:pack(?PP_KILL_BOSS, <<MissionId:32>>)};
%% 随机掉落铜币数量
write(?PP_RAND_MONEY, Num) ->
	{ok, pt:pack(?PP_RAND_MONEY, <<Num:32>>)};
%% 可以开放下一波怪物
write(?PP_CAN_OPEN_NEXT_MONSTER, _) ->
	{ok, pt:pack(?PP_CAN_OPEN_NEXT_MONSTER, <<0:32>>)};
%% 防守怪物击杀奖励
write(?PP_GUARD_KILL_AWARD, [Exp, BindCopper]) ->
	{ok, pt:pack(?PP_GUARD_KILL_AWARD, <<Exp:32, BindCopper:32>>)};
%% 剩余怪物数
write(?PP_UPDATE_DEAD_MONSTER, [MapId, MonsterId]) ->
	{ok, pt:pack(?PP_UPDATE_DEAD_MONSTER, <<MapId:32, MonsterId:32>>)};
%% 本层数据信息
write(?PP_UPDATE_MISSION_INFO, [MapId, MissionInfo, AwardList]) ->
	Bin = pack_mission_info(MissionInfo, AwardList),
	{ok, pt:pack(?PP_UPDATE_MISSION_INFO, <<MapId:32, Bin/binary>>)};

%% 副本关卡或副本通关(0通关，1通本)
write(?PP_COPY_PASS, [MapId, DupType, PassState]) ->
	{ok, pt:pack(?PP_COPY_PASS, <<MapId:32, DupType:32, PassState:32>>)};

%%怪物重生
write(?PP_MAP_MONSTER_INFO_UPDATE_REBORN, L) ->
	N = length(L),
	SPEED = ?MONSTER_COMMON_MOVE,
	F = fun(MonInfo) ->
			LengthPN = length(MonInfo#r_mon_info.last_path),
			PathBin = writepath(MonInfo#r_mon_info.last_path,<<>>),
			
            <<(MonInfo#r_mon_info.id):32,  
			  1:8,
			  (MonInfo#r_mon_info.template_id):32, 
			  (MonInfo#r_mon_info.pos_x):32, 
			  (MonInfo#r_mon_info.pos_y):32, 
			  (MonInfo#r_mon_info.template#ets_monster_template.max_hp):32,
			  (MonInfo#r_mon_info.hp):32,
			  SPEED:8, %传递值为原值*10
			  LengthPN:16,
			  PathBin/binary
			  >>
    end,		
    LB = tool:to_binary([F(X) || X <- L]),
    {ok, pt:pack(?PP_MAP_MONSTER_INFO_UPDATE, <<N:32, LB/binary>>)};


%%删除怪物 
write(?PP_MAP_MONSTER_REMOVE,L) ->
	N = length(L),
	F = fun(MonsterID) ->
				<<MonsterID:32>>
		end,
	LB = tool:to_binary([F(X) || X <- L]),
	{ok, pt:pack(?PP_MAP_MONSTER_REMOVE,<<N:32, LB/binary>>)};


%% type 1:回城复活，2：原地计时复活，3：原地健康复活
write(?PP_PLAYER_RELIVE, [UserId, HP, MP]) ->
	Data = <<UserId:64,
			 HP:32,
			 MP:32>>,
	{ok, pt:pack(?PP_PLAYER_RELIVE, Data)};

%%	玩家移动
write(?PP_PLAYER_MOVE, [UserId, Index, WalkPathBin]) ->
	Data = <<UserId:64,
			 Index:16,
			 WalkPathBin/binary>>,
	{ok, pt:pack(?PP_PLAYER_MOVE, Data)};

%% 随机传送符位置更新
write(?PP_PLAYER_PLACE_UPDATE, [PlayerId, Pos_X, Pos_Y]) ->
   { ok, pt:pack(?PP_PLAYER_PLACE_UPDATE, <<PlayerId:64, Pos_X:32, Pos_Y:32>>) };


%% 宠物信息更新
write(?PP_MAP_PET_INFO_UPDATE, [PetId, PetTemplateId,StyleId, UserId, PetNick]) ->
	PetNickBin = pt:write_string(PetNick),
	Data = <<PetId:64, PetTemplateId:32,StyleId:32, UserId:64, PetNickBin/binary>>,
	{ok, pt:pack(?PP_MAP_PET_INFO_UPDATE, Data)};

%% 宠物删除
write(?PP_MAP_PET_REMOVE, [PetId]) ->
	{ok, pt:pack(?PP_MAP_PET_REMOVE, <<PetId:64>>)};

%%打坐开始和取消广播
write(?PP_SIT_START_OR_CANCLE, [UserID, Sit_State]) ->
	{ok, pt:pack(?PP_SIT_START_OR_CANCLE, <<UserID:64, Sit_State:8>>)};



%%打坐邀请
write(?PP_SIT_INVITE, [State, Nick, ID, X, Y]) ->
	NickBin=pt:write_string(Nick),
	Data = <<State:8, NickBin/binary, ID:64, X:32, Y:32>>,
	{ok, pt:pack(?PP_SIT_INVITE, Data)};

%%双修打坐邀请回复
write(?PP_SIT_INVITE_REPLY, [Sit_Or_Not, ID1, ID2]) ->
	{ok, pt:pack(?PP_SIT_INVITE_REPLY, <<Sit_Or_Not:8, ID1:64, ID2:64>>)};

%% 玩家形象更新
write(?PP_PLAYER_STYLE_UPDATE, [User]) ->
	if User#ets_users.other_data#user_other.sit_state > 0 ->
		   IsSit = 1;
	   true ->
		   IsSit = 0
	end,

	Data = <<
			 (User#ets_users.id):64,
			 (User#ets_users.style_bin)/binary,
			 (User#ets_users.is_horse):8,
			 IsSit:8,
			 (User#ets_users.other_data#user_other.speed):8,
			 (User#ets_users.darts_left_time):32,
			 (User#ets_users.other_data#user_other.escort_state):8,
			 (User#ets_users.other_data#user_other.total_hp + User#ets_users.other_data#user_other.tmp_totalhp):32,
			 (User#ets_users.other_data#user_other.total_mp + User#ets_users.other_data#user_other.tmp_totalmp):32,
			 (User#ets_users.other_data#user_other.player_now_state):8,
             (User#ets_users.title):32,
             (User#ets_users.is_hide):8,
			 (User#ets_users.other_data#user_other.buff_titleId):16
		   >>,
	{ok, pt:pack(?PP_PLAYER_STYLE_UPDATE, Data)};

%% 玩家称号信息
write(?PP_PLAYER_TITLE_INFO, [User]) ->
   N = erlang:length(User#ets_users.other_data#user_other.total_title),
   F = fun({Num,_}) ->
         <<Num:32>>
       end,
   NumListBin = tool:to_binary([F(X)|| X <-(User#ets_users.other_data#user_other.total_title)]),
   NumListData =  << N:32, NumListBin/binary >>,

   Data = <<
            (User#ets_users.title):32,
            (User#ets_users.is_hide):8,

            NumListData/binary 	
          >>,
   {ok, pt:pack(?PP_PLAYER_TITLE_INFO, Data)};

%% 统计玩家进入副本
write(?PP_COPY_ENTER_COUNT, List) ->	
   N = length(List),
   F = fun(Info) ->
              <<(Info#ets_users_duplicate.duplicate_id):32,
				(Info#ets_users_duplicate.today_num):32,
				(Info#ets_users_duplicate.reset_num):32>>
       end,	
  ListBin = tool:to_binary([F(X)||X <- List]),
  {ok, pt:pack(?PP_COPY_ENTER_COUNT, <<N:32, ListBin/binary>>)};

write(?PP_NEXT_MON_TIME, [M,N,T]) ->
	{ok, pt:pack(?PP_NEXT_MON_TIME, <<M:32,N:32,T:32>>)};

write(?PP_LEFT_TIME, [M,N,T]) ->
	{ok, pt:pack(?PP_LEFT_TIME, <<M:32,N:32,T:32>>)};

write(?PP_ENTER_DUPLICATE, Duplicate_id) ->
  {ok, pt:pack(?PP_ENTER_DUPLICATE, <<Duplicate_id:32>>)};

write(?PP_QUIT_DUPLICATE, [Duplicate_id,MissionNum,AwardList]) ->
	N = length(AwardList),
	F = fun(Item, Data) ->
			{Id,Value} = Item,
			<<Data/binary, Id:32, Value:32>>
		end,
	AwardData = lists:foldl(F, <<>>, AwardList),
  {ok, pt:pack(?PP_QUIT_DUPLICATE, <<Duplicate_id:32,MissionNum:16,N:16,AwardData/binary>>)};

%% 挂机技能包
write(?PP_PLAYER_HANGUPDATA, Hangupdata) ->
	HangupBin = pt:write_string(Hangupdata),
	{ok, pt:pack(?PP_PLAYER_HANGUPDATA,<<HangupBin/binary>>)};

%% 技能重生
write(?PP_SKILL_RELIVE, Name) ->
	NameBin = pt:write_string(Name),
	{ok, pt:pack(?PP_SKILL_RELIVE, <<NameBin/binary>>)};
%% 新学技能增加到挂机栏中
write(?PP_NEW_SKILL_ADD, SkillId) ->
	{ok, pt:pack(?PP_NEW_SKILL_ADD, <<SkillId:32>>)};

%% 战场列表
write(?PP_FREE_WAR_LIST, List) ->
    N = length(List),
    F = fun(Info) ->
              <<(Info#r_free_war_map.map_only_id):64,
				(Info#r_free_war_map.player_count):8,
				(Info#r_free_war_map.min_level):8,
				(Info#r_free_war_map.max_level):8
			  >>
       end,	
   ListBin = tool:to_binary([F(X)||X <- List]),
	
   {ok, pt:pack(?PP_FREE_WAR_LIST, <<N:16, ListBin/binary>>)};

%% 战场用户列表
write(?PP_FREE_WAR_USER_LIST, List) ->
	N = length(List),
    F = fun(Info) ->
				packet_war_player(Info)
%% 				NickNameBin = pt:write_string(Info#r_free_war_user.nick_name),
%% 				ClubNameBin = pt:write_string(Info#r_free_war_user.club_name),
%%               <<(Info#r_free_war_user.user_id):64,
%% 				NickNameBin/binary,
%% 				(Info#r_free_war_user.war_state):8,
%% 				(Info#r_free_war_user.level):8,
%% 				ClubNameBin/binary,
%% 				(Info#r_free_war_user.kill_count):16
%% 			  >>
       end,	
   ListBin = tool:to_binary([F(X)||X <- List]),
   {ok, pt:pack(?PP_FREE_WAR_USER_LIST, <<N:16, ListBin/binary>>)};


%% 战场用户信息
write(?PP_FREE_WAR_USER_INFO, [KillList, ByKillList]) ->
	KillLen = length(KillList),
    F = fun(Info) ->
				packet_war_player(Info)
       end,	
    KillBin = tool:to_binary([F(X)||X <- KillList]),
	
	ByKillLen = length(ByKillList),
    FBy = fun(Info) ->
				packet_war_player(Info)
       end,	
   ByKillBin = tool:to_binary([FBy(X)||X <- ByKillList]),
   {ok, pt:pack(?PP_FREE_WAR_USER_INFO, <<KillLen:16, KillBin/binary, ByKillLen:16, ByKillBin/binary>>)};

%% 战场状态，剩余时间
write(?PP_FREE_WAR_STATE, LeaveTime) ->
	{ok, pt:pack(?PP_FREE_WAR_STATE, <<LeaveTime:32>>)};

%% 战场结果
write(?PP_FREE_WAR_RESULT, WarMap) ->
   Data = <<
            (WarMap#r_free_war_map.god_point):16,
            (WarMap#r_free_war_map.devil_point):16
          >>,
	{ok, pt:pack(?PP_FREE_WAR_RESULT, Data)};

%% 战场离开
write(?PP_QUIT_FREE_WAR, _) ->
	{ok, pt:pack(?PP_QUIT_FREE_WAR, <<>>)};

%% 返回商品可购买数量
write(?PP_DUPLICATE_SHOP_SALE_NUM, ItemList) ->
	F = fun(Info,Data) ->
			{Id,Num} = Info,
			<<Data/binary,Id:32,Num:32>>
		end,
	Bin = lists:foldl(F, <<>>, ItemList),
	Len = length(ItemList),
	{ok, pt:pack(?PP_DUPLICATE_SHOP_SALE_NUM, <<Len:32,Bin/binary>>)};
%% 请求购买副本商店物品
write(?PP_DUPLICATE_SHOP_BUY, [IsSucc, Id, Num]) ->
	{ok, pt:pack(?PP_DUPLICATE_SHOP_BUY, <<IsSucc:8, Id:32, Num:32>>)};
%% 用户掉线后重新连接返回副本信息
write(?PP_COPY_INFO, [DuplicateId,DuplicateType,MissionId,StartTime,Data]) ->
	{ok, pt:pack(?PP_COPY_INFO, <<DuplicateType:16, MissionId:16, StartTime:64,Data/binary,DuplicateId:32>>)};	
%% 副本抽奖信息更新
write(?PP_COPY_LOTTERY, [DuplicateId,ItemId,Num]) ->
	{ok, pt:pack(?PP_COPY_LOTTERY, <<DuplicateId:32, ItemId:32, Num:32>>)};
%% 清除副本次数限制
write(?PP_COPY_LIMIT_NUM_RESET, [Res,Id]) ->
	{ok, pt:pack(?PP_COPY_LIMIT_NUM_RESET, <<Res:8,Id:32>>)};
%%试炼副本星级信息
write(?PP_CHALLENGE_BOSS_INFO, [Star,Num]) ->
	NewStar = pt:write_string(Star),
	{ok, pt:pack(?PP_CHALLENGE_BOSS_INFO, <<Num:16,NewStar/binary>>)};

%%请求试炼副本当天挑战奖励次数
write(?PP_CHALLENGE_AWARD_NUM, [Num]) ->
	{ok, pt:pack(?PP_CHALLENGE_AWARD_NUM, <<Num:16>>)};

%%试炼进入副本返回信息
write(?PP_ENTER_CHALLENGE_BOSS, [State, Parameter]) ->
	{ok, pt:pack(?PP_ENTER_CHALLENGE_BOSS, <<State:8, Parameter:32>>)};

%%试炼副本通关返回评星
write(?PP_CHALLENGE_BOSS_PASS, [MissionIndex,Star,Time]) ->
	{ok, pt:pack(?PP_CHALLENGE_BOSS_PASS, <<MissionIndex:32,Star:32,Time:32>>)};

%% 首个称号
write(?PP_PLAYER_FIRST_TITLE,[Re]) ->
	{ok, pt:pack(?PP_PLAYER_FIRST_TITLE, <<Re:32>>)};

%% 乱斗副本玩家剩余时间
write(?PP_FIGHT_DUP_TIME,[CostTime]) ->
	{ok, pt:pack(?PP_FIGHT_DUP_TIME, <<CostTime:32>>)};


%% 玩家称号信息
write(?PP_PLAYER_ROLE_NAME_REMOVE, [User,RemoveList]) ->
   N = erlang:length(RemoveList),
   F = fun(Num) ->
         <<Num:32>>
       end,
   NumListBin = tool:to_binary([F(X)|| X <- RemoveList]),
   NumListData =  << N:32, NumListBin/binary >>,

   Data = <<
            (User#ets_users.title):32,
            (User#ets_users.is_hide):8,

            NumListData/binary 	
          >>,
   {ok, pt:pack(?PP_PLAYER_ROLE_NAME_REMOVE, Data)};


%%守护副本

write(Cmd, _R) ->
	?WARNING_MSG("pt_12,write:~w",[Cmd]),
	{ok, pt:pack(0, <<>>)}.
	
pack_mission_info(MissionInfo, AwardList) ->
%% 	MissionInfo#ets_duplicate_mission_template.monster_list

	<<>>.



writepath([], PathBin) -> PathBin;
writepath([H | T], PathBin) ->
	[MoveX,MoveY] = H,
    NewPathBin = << PathBin/binary,
					MoveX:16,
					MoveY:16 >>,
	writepath(T, NewPathBin).


%% 实例化战斗人物信息
packet_war_player(Info) ->
	NickNameBin = pt:write_string(Info#r_free_war_user.nick_name),
	ClubNameBin = pt:write_string(Info#r_free_war_user.club_name),
    <<(Info#r_free_war_user.user_id):64,
	  (Info#r_free_war_user.is_online):8,
	  NickNameBin/binary,
	  (Info#r_free_war_user.war_state):8,
	  (Info#r_free_war_user.level):8,
	  ClubNameBin/binary,
	  (Info#r_free_war_user.kill_count):16,
	  (Info#r_free_war_user.career):8,
	  (Info#r_free_war_user.award_state):8
	>>.



