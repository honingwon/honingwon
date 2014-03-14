%% Author: 
%% Created: 2013-3-17


%% Description: TODO: 战斗协议
-module(pt_23).
-export([read/2,
		 write/2,
		 pack_resource_war_result/1
		 ]).
-include("common.hrl").

%%参加pvp活动
read(?PP_PVP_ACTIVE_JOIN, <<ActiveId:32>>) ->
	{ok,[ActiveId]};

%%退出pvp活动
read(?PP_PVP_ACTIVE_QUIT ,<<ActiveId:32>>) ->
	{ok,[ActiveId]};

%% 打断蓄气
read(?PP_TARGET_ATTACKED_WAITING,<<>>) ->
	{ok,[]};

%% pvp功勋数据
read(?PP_PVP_EXPLOIT_INFO,<<>>) ->
	{ok,[]};

%% boss刷新信息请求
read(?PP_BOSS_INFO,<<>>) ->
	{ok,[]};
%%通知boss存活数量
read(?PP_BOSS_ALIVE_NUM, <<>>) ->
	{ok,[]};

%% 参加巡逻活动
read(?PP_ACTIVE_PATROL_JOIN,<<>>) ->
	{ok,[]};
%% 进入资源战场
read(?PP_ACTIVE_RESOURCE_WAR_ENTER, _) ->
	{ok,[]};
%% 退出资源战场
read(?PP_ACTIVE_RESOURCE_WAR_QUIT, _) ->
	{ok,[]};
%% 资源战场排行榜
read(?PP_ACTIVE_RESOURCE_TOP_LIST, _) ->
	{ok,[]};
%% 获得积分提示
read(?PP_ACTIVE_RESOURCE_POINT_ADD, _) ->
	{ok,[]};
%% 转换阵营
read(?PP_ACTIVE_RESOURCE_CAMP_CHANGE, <<Camp:32>>) ->
	{ok,[Camp]};

%% 进入天下第一战场
read(?PP_ACTIVE_PVP_FIRST_ENTER, _) ->
	{ok,[]};
%% 退出天下第一战场
read(?PP_ACTIVE_PVP_FIRST_QUIT, _) ->
	{ok,[]};
%% 天下第一玩家
read(?PP_ACTIVE_PVP_FIRST_THEFIRAST, _) ->
	{ok,[]};

%% 活动boss
read(?PP_ACTIVE_MONSTER_ENTER, _) ->
	{ok, []};

read(?PP_ACTIVE_MONSTER_QUIT, _) ->
	{ok, []};

%% 公会乱斗
read(?PP_ACTIVE_GUILD_FIGHT_ENTER, _) ->
	{ok, []};

read(?PP_ACTIVE_GUILD_FIGHT_QUIT, _) ->
	{ok, []};

%% 公会乱斗获取阶段性物品
read(?PP_ACTIVE_GUILD_FIGHT_ITEM, <<ItemId:32>>) ->
	{ok, [ItemId]};

%% 获取公会乱斗时间
read(?PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, _) ->
	{ok, []};

%% 王城战报名信息
read(?PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, _) ->
	{ok, []};

%% 王城战报名
read(?PP_ACTIVE_KING_FIGHT_SIGNUP, _) ->
	{ok, []};

%% 获取报名状态
read(?PP_ACTIVE_GET_SIGNUP_STATE, _) ->
	{ok, []};

%% 进入王城战
read(?PP_ACTIVE_KING_FIGHT_ENTER, <<Camp:8>>) ->
	{ok, [Camp]};

%% 退出王城战
read(?PP_ACTIVE_KING_FIGHT_QUIT, _) ->
	{ok, []};

%% 获取王城占领天数
read(?PP_ACTIVE_GET_CITYCRAFT_INFO, _) ->
	{ok, []};

%%获取守卫信息
read(?PP_ACTIVE_GUARD_INFO, _) ->
	{ok, []};
%%购买守卫
read(?PP_ACTIVE_BUY_GUARD, <<Type:8>>) ->
	{ok, [Type]};
%%交换守卫位置
read(?PP_ACTIVE_CHANGE_GUARD_POSITION, <<P1:16,P2:16>>) ->
	{ok, [P1,P2]};
%%删除守卫
read(?PP_ACTIVE_DELETE_GUARD, <<P:16>>) ->
	{ok, [P]};


read(Cmd, _R) ->
	?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
    {ok,[]}.
%%
%% API Functions
%%

%% 通知用户目标战斗信息更新
write(?PP_TARGET_ATTACKED_UPDATE,[ActorType,ActorID,ActorSkillGroupID,LV,X,Y,ActorState,TList]) ->
	LengthT = length(TList),
	TListBin = writeTList(TList,<<>>),
	Data = <<
			 ActorType:8,
			 ActorID:64,
			 ActorSkillGroupID:32,
			 LV:8,
			 X:32,
			 Y:32,
			 ActorState:32,
			 LengthT:32,
			 TListBin/binary
			 >>,
	{ok, pt:pack(?PP_TARGET_ATTACKED_UPDATE, Data)};

%% 大招，等待蓄气完成
write(?PP_TARGET_ATTACKED_WAITING,[ActorType,ActorID,ActorSkillGroupID,LV,WaitState,X,Y]) ->
	Data = <<
			 ActorType:8,
			 ActorID:64,
			 WaitState:8,
			 ActorSkillGroupID:32,
			 LV:8,
			 X:32,
			 Y:32
			 >>,
	{ok, pt:pack(?PP_TARGET_ATTACKED_WAITING, Data)};

write(?PP_TARGET_DROPITEM_ADD,[new,DropItemList]) ->
	N = length(DropItemList),
	F = fun(Info) ->
				SV = get_drop_state_to_byte(Info#r_drop_item.state),
				<<
				  (Info#r_drop_item.id):32,
				  (Info#r_drop_item.item_template_id):32,
				  (Info#r_drop_item.owner_id):64,
				  (Info#r_drop_item.x):32,
				  (Info#r_drop_item.y):32,
				  SV:8
				  >>
		end,
	LB = tool:to_binary([F(X) || X <- DropItemList]),
	{ok, pt:pack(?PP_TARGET_DROPITEM_ADD, <<N:32,LB/binary>>)};


%% 物品掉落信息
write(?PP_TARGET_DROPITEM_ADD,DropItemList) ->
	%?PRINT("DIL ~p ~n",[DropItemList]),
	{DListBin,Length} = writeDList(DropItemList,<<>>,0),
	Data = <<
			 Length:32,
			 DListBin/binary
			 >>,
	{ok, pt:pack(?PP_TARGET_DROPITEM_ADD, Data)};

%% 删除物品掉落信息
write(?PP_TARGET_DROPITEM_REMOVE,DropItem) ->
	ID = DropItem#r_drop_item.id,
	Data = <<
			 ID:32
			 >>,
	{ok, pt:pack(?PP_TARGET_DROPITEM_REMOVE, Data)};

%% 物品掉落信息更新
write(?PP_TARGET_DROPITEM_UPDATE,DropItem) ->
	ID = DropItem#r_drop_item.id,
	SV = get_drop_state_to_byte(DropItem#r_drop_item.state),
	Data = <<
			 	ID:32,
				SV:8
			 >>,
	{ok, pt:pack(?PP_TARGET_DROPITEM_UPDATE, Data)};


%% 加血，加魔等等
write(?PP_TARGET_UPDATE_BLOOD,[UserId, MovieType, ElementType, HP,MP,CurrentHp, CurrentMp]) ->
	Data = <<ElementType:8, 
			 UserId:64, 
			 MovieType:8, 
			 HP:32,
			 MP:32,
			 CurrentHp:32/signed, 
			 CurrentMp:32/signed>>,
	{ok, pt:pack(?PP_TARGET_UPDATE_BLOOD, Data)};

%% PVP活动开始(State：1表示开始，2表示还有5分钟开始)time活动持续时间
write(?PP_PVP_ACTIVE_START, [ActiveId,State,Time]) ->
	%?DEBUG("PP_PVP_ACTIVE_START:~p",[ActiveId]),
	{ok, pt:pack(?PP_PVP_ACTIVE_START, <<ActiveId:32,State:32,Time:32>>)};
write(?PP_ACTIVE_START_TIME_LIST, [List]) ->
	N = length(List),
	BinData = pack_active_start_time_list(List),
	{ok, pt:pack(?PP_ACTIVE_START_TIME_LIST, <<N:16,BinData/binary>>)};

%% 开始答题（服务端推送题目）
write(?PP_ACTIVE_QUESTION_ANSWER, [Index,Question]) ->
	ContentBin = pt:write_string(Question#ets_question_bank_template.content),
	OptionBin = pt:write_string(Question#ets_question_bank_template.option),
	{ok, pt:pack(?PP_ACTIVE_QUESTION_ANSWER, <<Index:16,ContentBin/binary,OptionBin/binary>>)};
%% 答题结果
write(?PP_ACTIVE_QUESTION_AWARD, [Index,Res,V1,V2]) ->
	{ok, pt:pack(?PP_ACTIVE_QUESTION_AWARD, <<Index:16,Res:8,V1:32,V2:32>>)};

%% 参加pvp活动
write(?PP_PVP_ACTIVE_JOIN, [ActiveId,State]) ->
	{ok, pt:pack(?PP_PVP_ACTIVE_JOIN, <<ActiveId:32,State:32>>)};
%% 退出pvp活动
write(?PP_PVP_ACTIVE_QUIT, [ActiveId,State]) ->
	{ok, pt:pack(?PP_PVP_ACTIVE_QUIT, <<ActiveId:32,State:32>>)};
%% pvp匹配成功
write(?PP_PVP_START, [ActiveId,State]) ->
	{ok, pt:pack(?PP_PVP_START, <<ActiveId:32,State:32>>)};
%% PVP战斗结束
write(?PP_PVP_END, [ActiveId, State, Awards]) ->
	N = length(Awards),
	Bin = writeAward(Awards,<<>>),
	{ok, pt:pack(?PP_PVP_END, <<ActiveId:32,State:32,N:16,Bin/binary>>)};
%% PVP活动结束
write(?PP_PVP_ACTIVE_FINISH, [ActiveId]) ->
	%?DEBUG("PP_PVP_ACTIVE_FINISH:~p",[ActiveId]),
	{ok, pt:pack(?PP_PVP_ACTIVE_FINISH, <<ActiveId:32>>)};
%% pvp功勋数据
write(?PP_PVP_EXPLOIT_INFO, [Exploit]) ->
	{ok, pt:pack(?PP_PVP_EXPLOIT_INFO, <<(Exploit#user_exploit_info.exploit):32,
										(Exploit#user_exploit_info.pvp1_day_award):32>>)};
%% boss刷新信息请求
write(?PP_BOSS_INFO, [List]) ->
	N = length(List),
	Bin = pack_boss_info(List),
	{ok, pt:pack(?PP_BOSS_INFO, <<N:16,Bin/binary>>)};
%% 通知boss存活数量
write(?PP_BOSS_ALIVE_NUM, [Num]) ->
	{ok, pt:pack(?PP_BOSS_ALIVE_NUM, <<Num:32>>)};
%%参加巡逻活动
write(?PP_ACTIVE_PATROL_JOIN, [Res,Num]) ->
	{ok, pt:pack(?PP_ACTIVE_PATROL_JOIN, <<Res:32,Num:32>>)};
%%开始巡逻
write(?PP_ACTIVE_PATROL_START, [Group,Num]) ->
	{ok, pt:pack(?PP_ACTIVE_PATROL_START, <<Group:32,Num:32>>)};
%%巡逻结束
%% write(?PP_ACTIVE_PATROL_FINISH, []) ->
%% 	{ok, pt:pack(?PP_ACTIVE_PATROL_FINISH, <<Group:32,Num:32>>)};

%%退出天下第一战场
write(?PP_ACTIVE_PVP_FIRST_QUIT, [Res,Time]) ->
	{ok, pt:pack(?PP_ACTIVE_PVP_FIRST_QUIT, <<Res:8,Time:32>>)};

%% 天下第一结果
write(?PP_ACTIVE_PVP_FIRST_RESULT, [Item1,Item2]) ->
	{ok, pt:pack(?PP_ACTIVE_PVP_FIRST_RESULT, <<Item1:32,Item2:32>>)};

%% 天下第一玩家
write(?PP_ACTIVE_PVP_FIRST_THEFIRAST,[Time,ID, NickName]) ->
	NameBin = pt:write_string(NickName),
	{ok, pt:pack(?PP_ACTIVE_PVP_FIRST_THEFIRAST, <<Time:32,ID:64,NameBin/binary>>)};

%%退出资源战场
write(?PP_ACTIVE_RESOURCE_WAR_QUIT, [Res,Time]) ->
	{ok, pt:pack(?PP_ACTIVE_RESOURCE_WAR_QUIT, <<Res:8,Time:32>>)};

%% 获得积分提示
write(?PP_ACTIVE_RESOURCE_POINT_ADD, [AddPoint,CPoint,KPoint,KillingNum]) ->
	{ok, pt:pack(?PP_ACTIVE_RESOURCE_POINT_ADD, <<AddPoint:32,CPoint:32,KPoint:32,KillingNum:32>>)};

%% 资源战结果
write(?PP_ACTIVE_RESOURCE_RESULT, [Point, Data]) ->
	{ok, pt:pack(?PP_ACTIVE_RESOURCE_RESULT, <<Point:32,Data/binary>>)};

%% 资源战场排行榜
write(?PP_ACTIVE_RESOURCE_TOP_LIST, State) ->
	{CPoint1,KPoint1} = State#r_resource_war.camp1Point,
	{CPoint2,KPoint2} = State#r_resource_war.camp2Point,
	{CPoint3,KPoint3} = State#r_resource_war.camp3Point,
	N = length(State#r_resource_war.top_list),
	Data = pack_resource_top_list(State#r_resource_war.top_list),
	{ok, pt:pack(?PP_ACTIVE_RESOURCE_TOP_LIST, <<CPoint1:32,KPoint1:32,CPoint2:32,KPoint2:32,CPoint3:32,KPoint3:32, N:16,Data/binary>>)};

%% 转换阵营
write(?PP_ACTIVE_RESOURCE_CAMP_CHANGE, [Res,ErrCorde]) ->
	{ok, pt:pack(?PP_ACTIVE_RESOURCE_CAMP_CHANGE, <<Res:8,ErrCorde:32>>)};

%%退出活动boss战
write(?PP_ACTIVE_MONSTER_QUIT, [Res,Time]) ->
	{ok, pt:pack(?PP_ACTIVE_MONSTER_QUIT, <<Res:8,Time:32>>)};

%%活动boss战奖励
write(?PP_ACTIVE_MONSTER_GIFT, [Result,ItemID]) ->
	{ok, pt:pack(?PP_ACTIVE_MONSTER_GIFT, <<Result:8, ItemID:32>>)};

%% 活动boss战排行榜
write(?PP_ACTIVE_MONSTER_TOP_LIST, [State, Damage, PlayerName]) ->
	Bosshp = State#r_active_monster.monster_lost_hp,
	N = length(State#r_active_monster.top_list),
	F =	fun(Info, Bin) ->
			NickName = pt:write_string(Info#r_active_monster_user.nick_name),
			<<Bin/binary,
				NickName/binary,
				(Info#r_active_monster_user.damage):32>>
		end,
	Data = lists:foldl(F, <<>>, State#r_active_monster.top_list),
	NickNameBin = pt:write_string(PlayerName),
	{ok, pt:pack(?PP_ACTIVE_MONSTER_TOP_LIST, <<Damage:32, Bosshp:32, NickNameBin/binary, N:16, Data/binary>>)};

%% 帮会乱斗剩余时间
write(?PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, [Time, BuffGuildName, TotalTime, RcvList]) ->
	N = length(RcvList),
	F = fun(Info, Bin) ->
			{ItemId} = Info,
			<<Bin/binary, ItemId:32>>
		end,
	Data = lists:foldl(F, <<>>, RcvList),
	NickName = pt:write_string(BuffGuildName),
	{ok, pt:pack(?PP_ACTIVE_GUILD_FIGHT_CONTINUE_TIME, <<Time:32, TotalTime:16, N:16, Data/binary, NickName/binary>>)};

%%退出帮会乱斗
write(?PP_ACTIVE_GUILD_FIGHT_QUIT, [Res,Time]) ->
	{ok, pt:pack(?PP_ACTIVE_GUILD_FIGHT_QUIT, <<Res:8,Time:32>>)};

%%帮会乱斗结果
write(?PP_ACTIVE_GUILD_FIGHT_RESULT, [Top3_List, Total_Time, Index, Item_Id]) -> 
	N = length(Top3_List),
	F = fun(Info, Bin) ->
			NickName = pt:write_string(Info#r_guild_fight_guild.nick_name),
			<<Bin/binary, NickName/binary, (Info#r_guild_fight_guild.total_time):16>>
		end,
	Data = lists:foldl(F, <<>>, Top3_List),
	{ok, pt:pack(?PP_ACTIVE_GUILD_FIGHT_RESULT, <<Total_Time:16, Index:16, Item_Id:32, N:16, Data/binary>>)};

%%帮会乱斗击杀数
write(?PP_ACTIVE_GUILD_FIGHT_KILL, [TotalTime, KillNum, GuildName]) ->
	NickName = pt:write_string(GuildName),
	{ok, pt:pack(?PP_ACTIVE_GUILD_FIGHT_KILL, <<TotalTime:16, KillNum:16, NickName/binary>>)};

%%帮会乱斗当前旗帜信息
write(?PP_ACTIVE_GUILD_FIGHT_THEFIRAST, [GuildName]) ->
	NickName = pt:write_string(GuildName),
	{ok, pt:pack(?PP_ACTIVE_GUILD_FIGHT_THEFIRAST, <<NickName/binary>>)};

%% 王城战报名信息
write(?PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, [GuildName, Guild_money, My_guild_money, GuildList]) ->
	List = lists:sublist(GuildList, 3),
	N = length(List),
	F = fun(Info, Bin) ->
		Name = 
			case mod_guild:get_guild_info(Info#r_king_fight.guild_id) of
				{ok, Guild} ->
					Guild#ets_guilds.guild_name;
				_ ->
					""
			end,
		Name1 = pt:write_string(Name),
		<<Bin/binary, Name1/binary, (Info#r_king_fight.guild_money):32>>
		end,
	Data = lists:foldl(F, <<>>, List),
	NickName = pt:write_string(GuildName),
	{ok, pt:pack(?PP_ACTIVE_KING_FIGHT_SIGNUP_INFO, <<Guild_money:32, My_guild_money:32, NickName/binary, N:16, Data/binary>>)};

%% 王城战报名变动
write(?PP_ACTIVE_KING_FIGHT_SIGNUP, [GuildName, Guild_money]) ->
	NickName = pt:write_string(GuildName),
	{ok, pt:pack(?PP_ACTIVE_KING_FIGHT_SIGNUP, <<Guild_money:32, NickName/binary>>)};

write(?PP_ACTIVE_KING_FIGHT_ENTER, []) ->
	{ok, pt:pack(?PP_ACTIVE_KING_FIGHT_ENTER, <<>>)};

%%获取报名状态
write(?PP_ACTIVE_GET_SIGNUP_STATE, [State]) ->
	{ok, pt:pack(?PP_ACTIVE_GET_SIGNUP_STATE, <<State:8>>)};

%%获取王城占领天数
write(?PP_ACTIVE_GET_CITYCRAFT_INFO, [AttackGuildName,DefenseGuildName, MasterName, DefenseDay]) ->
	DefName1 = pt:write_string(DefenseGuildName),
	MasterName1 = pt:write_string(MasterName),
	AttName1 = pt:write_string(AttackGuildName),
	{ok, pt:pack(?PP_ACTIVE_GET_CITYCRAFT_INFO, <<DefenseDay:16, DefName1/binary, MasterName1/binary, AttName1/binary>>)};

%%守卫信息
write(?PP_ACTIVE_GUARD_INFO, [GuarList]) ->
	N = length(GuarList),
%% 	?DEBUG("GuarList:~p",[GuarList]),
	F =	fun({P,T}, Bin) ->	
				<<Bin/binary,P:8,T:8>>
		end,
	Data = lists:foldl(F, <<>>, GuarList),
	{ok, pt:pack(?PP_ACTIVE_GUARD_INFO, <<N:8,Data/binary>>)};

%%退出王城战
write(?PP_ACTIVE_KING_FIGHT_QUIT, [Res,Time]) ->
	{ok, pt:pack(?PP_ACTIVE_KING_FIGHT_QUIT, <<Res:8,Time:32>>)};

%% 王城战剩余时间
write(?PP_ACTIVE_KING_WAR_CONTINUE_TIME, [Time]) ->
	{ok, pt:pack(?PP_ACTIVE_KING_WAR_CONTINUE_TIME, <<Time:32>>)}; 

%% 王城战排行榜
write(?PP_ACTIVE_KING_WAR_TOP_LIST, [TopList, LostHp, Point, Camp]) ->
	N = length(TopList),
	F =	fun(Info, Bin) ->
			NickName = pt:write_string(Info#r_king_war_user.nickname),
			<<Bin/binary,
				NickName/binary,
				(Info#r_king_war_user.point):16,
				(Info#r_king_war_user.camp):8>>
		end,
	Data = lists:foldl(F, <<>>, TopList),
	{ok, pt:pack(?PP_ACTIVE_KING_WAR_TOP_LIST, <<LostHp:32, Point:16, Camp:8, N:16, Data/binary>>)};

%%王城战结果
write(?PP_ACTIVE_KING_FIGHT_RESULT, [Top3_List, Point, Index, Item_Id]) ->
	N = length(Top3_List),
	F = fun(Info, Bin) ->
			NickName = pt:write_string(Info#r_king_war_user.nickname),
			<<Bin/binary, NickName/binary, (Info#r_king_war_user.point):16>>
		end,
	Data = lists:foldl(F, <<>>, Top3_List),
	{ok, pt:pack(?PP_ACTIVE_KING_FIGHT_RESULT, <<Point:16, Index:16, Item_Id:32, N:16, Data/binary>>)};

write(Cmd, _R) ->
?INFO_MSG("~s_errorcmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

pack_resource_war_result(State) ->
	{CPoint1,KPoint1} = State#r_resource_war.camp1Point,
	{CPoint2,KPoint2} = State#r_resource_war.camp2Point,
	{CPoint3,KPoint3} = State#r_resource_war.camp3Point,
	N = length(State#r_resource_war.top_list),
	Data = pack_resource_top_list(State#r_resource_war.top_list),
	<<CPoint1:32,KPoint1:32,CPoint2:32,KPoint2:32,CPoint3:32,KPoint3:32, N:16,Data/binary>>.

%%
%% Local Functions
%%
pack_resource_top_list(List) ->
	F =	fun(Info, Bin) ->
			NickName = pt:write_string(Info#r_resource_war_user.nickname),
			<<Bin/binary,
				NickName/binary,
				(Info#r_resource_war_user.camp):16,
				(Info#r_resource_war_user.collect_point + Info#r_resource_war_user.kill_point):32>>
		end,
	lists:foldl(F, <<>>, List).

%组战斗对象循环
writeTList([],TListBin) -> TListBin;
writeTList([H|T],TListBin) ->
	[TmpID,Type,HPL,MPL,Msg,Stand,BList] = H,
	LengthB = length(BList),
	BuffBin = pt:writebuff(BList, <<>>),
	LengthHPL = length(HPL),
	HMPBin = writeHPMP(HPL,MPL, <<>>),
	case TmpID of
		{_MapID,ID} -> ID;
		ID -> ID
	end,
	NewTListBin = << 
					TListBin/binary,
					ID:64,
					Type:8,
					LengthHPL:8,
					HMPBin/binary,
					Msg:16,
					%%击倒状态等
					Stand:32,
					LengthB:16,
					BuffBin/binary
					>>,
	writeTList(T,NewTListBin).


writeHPMP([],_, BListBin) -> BListBin;
writeHPMP([HHP|THP],[HMP|TMP],BListBin) ->
	 writeHPMP(THP,TMP,<<BListBin/binary,HHP:32,HMP:32>>).

%组战斗对象中的buff的循环
writeBList([],BListBin) -> BListBin;
writeBList([H|T],BListBin) ->
	{ID,BeginDate,_ValidDate,_EndDate,_Effect} = H,
	IsExist = 1,
	NewBeginDate = util:ceil(BeginDate/1000),
	NewBListBin = <<
					BListBin/binary,
					ID:32,
					IsExist:8,
					NewBeginDate:32
					%BeginDate:64,
					%EndDate:64
					>>,
	writeBList(T,NewBListBin).

%组掉落物循环
writeDList([],DListBin,DNumber) -> {DListBin,DNumber};
writeDList(L,DListBin,DNumber) ->
	[TmpH|T] = L,
	{NewDListBin,NewDNum} = writeDList1(TmpH,DListBin,DNumber),
	writeDList(T,NewDListBin,NewDNum).

writeDList1([],DListBin,DNumber) -> {DListBin,DNumber};
writeDList1(L,DListBin,DNumber) ->
	[H|T] = L,
	SV = get_drop_state_to_byte(H#r_drop_item.state),
	ID = H#r_drop_item.id,
	TemplateID = H#r_drop_item.item_template_id,
	OwnerID = H#r_drop_item.owner_id,
	X = H#r_drop_item.x,
	Y = H#r_drop_item.y,
	NewDNum = DNumber + 1,
	NewDListBin = <<
					DListBin/binary,
					ID:32,
					TemplateID:32,
					OwnerID:64,
					X:32,
					Y:32,
					SV:8
					>>,
	writeDList1(T,NewDListBin,NewDNum).
%%pvp奖品循环
writeAward([], Bin) ->
	Bin;
writeAward([H|L], Bin) ->
	{Type,Value} = H,
	NewBin = <<Bin/binary,Type:16,Value:32>>,
	writeAward(L, NewBin).

get_drop_state_to_byte(State) ->
	case State =:= lock of
		true ->
			1;
		_ ->
			2
	end.

pack_boss_info(List) ->
	F = fun(Info, Bin) ->
		<<Bin/binary,
			(Info#ets_boss_template.boss_id):32,
			(Info#ets_boss_template.state):8,
			(Info#ets_boss_template.dead_time):32>>
		end,
	lists:foldl(F, <<>>, List).

pack_active_start_time_list(List) ->
	Time = misc_timer:get_time(misc_timer:now_seconds()),	
	F = fun(Info, Bin) ->
	STime = Info#ets_active_open_time_template.continue_time - Time + Info#ets_active_open_time_template.time,
		<<Bin/binary,
			(Info#ets_active_open_time_template.active_id):32,
			STime:32,
			(Info#ets_active_open_time_template.continue_time):32,
			(Info#ets_active_open_time_template.other):16>>
		end,
	lists:foldl(F, <<>>, List).
