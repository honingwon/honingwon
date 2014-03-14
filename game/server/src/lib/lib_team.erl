%%%-------------------------------------------------------------------
%%% Module  : lib_team
%%% Author  : 
%%% Description : 组队
%%%-------------------------------------------------------------------
-module(lib_team).


%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([send_to_all/2, 
		 send_to_other/2, 
		 update_team_hpmp/1, 
		 sysmsg_team_all/2,
		 get_team_info/1, 
		 get_member_pid/1,
		 sysmsg_team_other/3, 
		 update_member_info/2, 
		 member_check/1, 
		 team_check/1,
		 team_quit/1,
		 check_duplicate_in_team/2
		 %get_map_player_noteam/1
		]).

%%====================================================================
%% External functions
%%====================================================================
%%广播给队员
send_to_all(TeamPid, Bin) ->
	gen_server:cast(TeamPid, {send_to_member, Bin}).

%%广播给其他队员
send_to_other(PlayerInfo, Bin) ->
	TeamPid = PlayerInfo#ets_users.other_data#user_other.pid_team,
    case misc:is_process_alive(TeamPid) =:= true andalso is_binary(Bin) of
        false -> 
			skip;
        true -> 
			gen_server:cast(TeamPid, {send_to_other_member, PlayerInfo#ets_users.id, Bin})
    end.
%%广播玩家血量和法力值
update_team_hpmp(PlayerInfo) ->
	TeamPid = PlayerInfo#ets_users.other_data#user_other.pid_team,
	case misc:is_process_alive(TeamPid) of
		false -> 
			skip;
		_ ->
			PlayerID = PlayerInfo#ets_users.id,
			CurrentHP = PlayerInfo#ets_users.current_hp,
			CurrentMP = PlayerInfo#ets_users.current_mp,
			{ok, Bin} = pt_17:write(?PP_TEAM_BATTLEINFO, [PlayerID, CurrentHP, CurrentMP]),
			gen_server:cast(TeamPid, {send_to_member, Bin})
	end.

%%队伍系统信息(全部)
sysmsg_team_all(TeamInfo, [Type, Code, Color, Msg]) ->
    F = fun(PidSend) ->
        lib_chat:chat_sysmsg_pid([PidSend, Type, Code, Color, Msg])
    end,
    [F(Member#team_member.user#ets_users.other_data#user_other.pid_send) || Member <- TeamInfo#ets_team.member].
%%队伍系统信息(其他人)
sysmsg_team_other(SelfId, TeamInfo, [Type, Code, Color, Msg]) ->
	case length(TeamInfo#ets_team.member) > 1 of
		true ->
			F = fun(PidSend) ->
        		lib_chat:chat_sysmsg_pid([PidSend, Type, Code, Color, Msg])
    		end,
    		[F(Member#team_member.user#ets_users.other_data#user_other.pid_send)
			|| Member <- TeamInfo#ets_team.member, Member#team_member.id =/= SelfId];
		_ ->
			skip
	end.

%%获取得队伍信息
get_team_info(Pid) ->
	case misc:is_process_alive(Pid) of
		true -> gen_server:call(Pid, get_team_info);
		_ -> []
	end.

%%获取队员进程pid
get_member_pid(Pid) ->
	case get_team_info(Pid) of
		[] -> 
			[];
		Info -> 
			F = fun(M) -> 
						M#team_member.pid 
				end,
			[F(I) || I <- Info#ets_team.member]
	end.

%%获取玩家所在地图未组队玩家信息
%% get_map_player_noteam(PlayerInfo) -> 
%%  	Map_Pid = PlayerInfo#ets_users.other_data#user_other.pid_map,
%% 	case misc:is_process_alive(Map_Pid) of
%% 		true -> 
%% 			AllUser = gen_server:call(Map_Pid, {apply_call, lib_map, get_scene_user, [PlayerInfo#ets_users.current_map_id]}),
%% %% 			F = fun([User, _], List) -> 
%% 			F = fun(User, List) ->
%% 						case User#ets_users.id =/= PlayerInfo#ets_users.id of
%% 							true ->
%% 								Tid = User#ets_users.other_data#user_other.pid_team,
%% 								case misc:is_process_alive(Tid) of
%% 									true -> List;
%% 									_ -> List ++ [User]
%% 								end;
%% 							_ -> List
%% 						end
%% 				end,
%% 			lists:foldl(F, [], AllUser);
%% 		_ -> 
%% 			[]
%% 	end.	
%%更换队员在线状态或所在地图（切换进入新地图时调用）[{state, Online},{mapid, MapId}]
update_member_info(PlayerInfo, InfoList) ->
	TeamPid = PlayerInfo#ets_users.other_data#user_other.pid_team,
	case misc:is_process_alive(TeamPid) of
		false -> 
			skip;
		_ ->
			gen_server:cast(TeamPid, {update_member_info, PlayerInfo#ets_users.id, InfoList})
	end.
%%检查玩家队伍，掉线后重上线
member_check(PlayerInfo) ->
	ProcessName = misc:create_process_name(mod_team, [PlayerInfo#ets_users.team_id]),
	case misc:whereis_name({global, ProcessName}) of
		Pid when is_pid(Pid) ->
			gen_server:call(Pid, {member_check, PlayerInfo});
		_ -> 
			PlayerInfo
	end.
%% 玩家下线时检查队伍状态,所有人下线则解散队伍，队长下线则换队长
team_check(PlayerInfo) ->
	Pid = PlayerInfo#ets_users.other_data#user_other.pid_team,
	case is_pid(Pid) of
		true ->
			gen_server:cast(Pid, {team_check, PlayerInfo#ets_users.id});
		_ ->
			skip
	end.

%% 离开队伍
team_quit(PlayerStatus) ->
	Pid = PlayerStatus#ets_users.other_data#user_other.pid_team,
	case is_pid(Pid) of
		true ->
			gen_server:cast(Pid, {team_quit, PlayerStatus#ets_users.id});
		_ ->
			skip
	end.


%% 	case misc:is_process_alive(Pid) of
%% 		true -> gen_server:cast(Pid, {team_check, PlayerInfo#ets_users.id});
%% 		_ -> skip
%% 	end.


%% 检查进入副本时队伍成员满足情况
check_duplicate_in_team(DuplicateId, State) ->
%% 	{ok}.
	DuplicateTemplate = data_agent:duplicate_template_get(DuplicateId),
%% 	F = fun(MemberInfo, [List, Template]) ->
%% 				Info = MemberInfo#team_member.user,
%% 				if
%% 					Info#ets_users.level < Template#ets_duplicate_template.min_level orelse
%% 					   Info#ets_users.level > Template#ets_duplicate_template.max_level orelse   
%%                 			Info#ets_users.other_data#user_other.pid_dungeon =/= undefined ->
%% 						[[Info | List], Template];
%% 					true ->
%% 						[List, Template]
%% 				end
%% 		end,
%% 	[List, _] = lists:foldl(F, [[], DuplicateTemplate], State#ets_team.member),
	
%% 	List = State#ets_team.member,
	if
%% 		erlang:length(List) =/= 0 ->
%% 			lib_chat:chat_sysmsg([State#ets_team.leaderid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_TEAMMATE_READY_DUPLICATE]);
%% 			{error};
		erlang:length(State#ets_team.member) < DuplicateTemplate#ets_duplicate_template.min_player ->
			{error};
		erlang:length(State#ets_team.member) > DuplicateTemplate#ets_duplicate_template.max_player ->
			{error};
		
		true ->
			{ok}
	end.

	
%% 捡物品
%% drop_item(PlayerId, State, DropItem) ->
%% 	case State#ets_team.allot_mode of
%% 		?DROP_ITEM_RANDOM ->
%% 			skip;
%% 		_ ->
%% 			skip
%% 	end.

	

%%
%% update_nearby(PlayerInfo) ->
%% 	TL = mod_team_agent:get_notfull(PlayerStatus#ets_users.current_map_id),			%%未满队伍
%% 	PL = lib_team:get_map_player_noteam(PlayerStatus),								%%未组玩家
%% 	{ok, DataBin} = pt_17:write(?PP_TEAM_NOFULL_MSG, [TL, PL]),
%% 	lib_send:
%%====================================================================
%% Private functions
%%====================================================================


