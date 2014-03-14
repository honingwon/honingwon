%%Author: Administrator
%%Created: 2011-3-7
%%Description: 组队信息
-module(pt_17).
%%
%% Include files
%%
 
%%
%% Exported Functions
%%
-export([read/2, write/2]).
-include("common.hrl").
 
%%
%%客户端 -> 服务端 ----------------------------
%%

%%组队邀请
read(?PP_TEAM_INVITE, Bin) ->
	{Name, _} = pt:read_string(Bin),
	{ok, [Name]};

%%邀请信息
read(?PP_TEAM_INVITE_MSG, <<IsAgree:8, InviterId:64>>)->
	{ok, [IsAgree, InviterId]};

%%查找空队伍和未加入队伍玩家
read(?PP_TEAM_NOFULL_MSG, _) ->
 	{ok, []};
 
%%逐出队伍
read(?PP_TEAM_KICK, <<UserID:64>>) ->
 	{ok, [UserID]};

%%离开队伍
read(?PP_TEAM_LEAVE, _) ->
 	{ok, []};
 
%%解散队伍
read(?PP_TEAM_DISBAND, _) ->
 	{ok, []};

%%更换队长
read(?PP_TEAM_LEADER_CHANGE, <<NewLeaderID:64>>) -> 
	{ok, [NewLeaderID]};

%%队伍设置
read(?PP_TEAM_CHANGE_SETTING, <<IsAutoIn:8, AllotMode:8>>) ->
	{ok, [IsAutoIn, AllotMode]};
%% %%获取玩家队伍信息
%% read(?PP_TEAM_GETALLINFO, _) ->
%% 	{ok, []};

%% 创建组队
read(?PP_TEAM_CREATE, _) ->
	{ok, []};

read(Cmd, _R) ->
	?WARNING_MSG("pt_17 read:~w", [Cmd]),
    {error, no_match}.
	
%% 
%%服务端 -> 客户端 ----------------------------
%%

%% 组队邀请
write(?PP_TEAM_INVITE_MSG, [LeaderNick, LeaderID]) ->
	NickBin = pt:write_string(LeaderNick),
	Data = <<NickBin/binary, LeaderID:64>>,
 	{ok, pt:pack(?PP_TEAM_INVITE_MSG, Data)};


%%组队信息更新，PL队员，NL离队的队员
write(?PP_TEAM_UPDATE_MSG, [TeamID, LeaderID, PL, NL]) ->
	N1 = length(PL), 
	F1 = fun(Info) ->
				 UserID = Info#team_member.user#ets_users.id,
				 TotalHP = Info#team_member.user#ets_users.other_data#user_other.total_hp + Info#team_member.user#ets_users.other_data#user_other.tmp_totalhp,
				 CurrentHP = Info#team_member.user#ets_users.current_hp,
				 TotalMP = Info#team_member.user#ets_users.other_data#user_other.total_mp + Info#team_member.user#ets_users.other_data#user_other.tmp_totalmp,
				 CurrentMP = Info#team_member.user#ets_users.current_mp,
				 Nick = pt:write_string(Info#team_member.user#ets_users.nick_name),
				 Sex = Info#team_member.user#ets_users.sex,
				 Lv = Info#team_member.user#ets_users.level,
				 Career = Info#team_member.user#ets_users.career,
%% 				 Style = Info#r_user_info.style_bin,
				 Style = Info#team_member.user#ets_users.style_bin,
				 <<UserID:64,
				   TotalHP:32,
				   CurrentHP:32,
				   TotalMP:32,
				   CurrentMP:32,
				   (Info#team_member.index):16,
				   Nick/binary,
				   Sex:8,
				   Lv:8,
				   Career:8,
				   Style/binary>>
		 end,
	LB1 = tool:to_binary([F1(X) || X <- PL]),
	N2 = length(NL),
	F2 = fun(NoticID)->
		 <<NoticID:64>>
	end,
	LB2 = tool:to_binary([F2(Y) || Y <- NL]),
	Data = <<TeamID:32,
			 LeaderID:64,
			 N1:32,
			 LB1/binary,
			 N2:32,
			 LB2/binary>>,
	{ok, pt:pack(?PP_TEAM_UPDATE_MSG, Data)};

write(?PP_TEAM_POSITION_UPDATE,[List]) ->
	Len = length(List),
	F = fun({PlayerID,MapID,MapX,MapY}) ->
			<<PlayerID:64,
				   MapID:32,
				   MapX:16,
				   MapY:16>>
		end,
	Bin = tool:to_binary([F(Info) || Info <- List]),
	Data = <<Len:8, Bin/binary>>,
	{ok,pt:pack(?PP_TEAM_POSITION_UPDATE, Data)};
	

%%未满队伍及未组队队员
write(?PP_TEAM_NOFULL_MSG, [TL, PL]) ->
	N1 = length(TL),
	F1 = fun(Team) ->
				 LeaderId = Team#ets_team.leaderid,
				 LeaderNick = Team#ets_team.leadername,
				 IsAutoIn = Team#ets_team.is_autoin,
				 Count = length(Team#ets_team.member),
				 NickBin = pt:write_string(LeaderNick),
				 
				 %% todo 不能够get_online玩家
%% 				 LeadInfo = lib_player:get_online_player_info_by_id(LeaderId),
%% 				 LeadLevel = LeadInfo#ets_users.level,
				 LeadLevel = Team#ets_team.leader_level,
				 <<LeaderId:64,
				   NickBin/binary,
				   LeadLevel:32,
				   Count:8,
				   IsAutoIn:8>>
		 end,
	LB1 = tool:to_binary([F1(X) || X <- TL]),
	N2 = length(PL),
    F2 = fun(PlayerInfo) ->
				 {PlayerID,PlayerNick} = PlayerInfo,
				 %PlayerID = PlayerInfo#ets_users.id,
				 %PlayerNick = PlayerInfo#ets_users.nick_name,
				 UserLv = case lib_player:get_online_player_info_by_id(PlayerID) of
					[] ->
						31;
					PlayerInfo1 ->
						PlayerInfo1#ets_users.level
				 end,
				 PlayerLevel = UserLv,
				 NickBin2 = pt:write_string(PlayerNick),
				 <<PlayerID:64, NickBin2/binary, PlayerLevel:32>>
		 end,
    LB2 = tool:to_binary([F2(Y) || Y <- PL]),
	Data = <<N1:32, LB1/binary, N2:32, LB2/binary>>,
	{ok,pt:pack(?PP_TEAM_NOFULL_MSG, Data)};

%%队伍设置
write(?PP_TEAM_CHANGE_SETTING, [_TeamID, IsAutoIn, AllotMode]) ->
%% 	Data = <<_TeamID:32, IsAutoIn:8, AllotMode:8>>,
	Data = <<IsAutoIn:8, AllotMode:8>>,
 	{ok, pt:pack(?PP_TEAM_CHANGE_SETTING, Data)};

%%队伍成员等级更新
write(?PP_TEAM_LEVEL_UPDATE, [Id, Level]) ->
	{ok, pt:pack(?PP_TEAM_LEVEL_UPDATE, <<Id:64, Level:32>>)};


%% 血蓝更新
write(?PP_TEAM_BATTLEINFO, [PlayerID, CurrentHP, CurrentMP]) ->
	Data = <<PlayerID:64, CurrentHP:32, CurrentMP:32>>,
 	{ok, pt:pack(?PP_TEAM_BATTLEINFO, Data)};

%% 队长进入副本通知
write(?PP_TEAM_DUPLICATE_ENTER, [DuplicateId, DuplicateName]) ->
	NameBin = pt:write_string(DuplicateName),
	Data = <<DuplicateId:32, NameBin/binary, 0:32>>,
	{ok, pt:pack(?PP_TEAM_DUPLICATE_ENTER, Data)};
	
write(Cmd, _R) ->
	?WARNING_MSG("pt_17,write:~w",[Cmd]),
	{ok, pt:pack(0, <<>>)}.
 
