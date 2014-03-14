%%%-------------------------------------------------------------------
%%% Module  : pp_team
%%% Author  : 
%%% Description : 组队
%%%-------------------------------------------------------------------
-module(pp_team).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================
%%组队邀请，处理邀请请求
%%PlayerStatus邀请人信息
handle(?PP_TEAM_INVITE, PlayerStatus, [TarNick]) -> 
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) andalso lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) =/= ?DUPLICATE_TYPE_GUILD1 of
		true ->
%%			lib_chat:chat_sysmsg([PlayerStatus#ets_users.id, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_NOT_JOIN]),
			ok;
		_ ->
			MyNick = tool:to_list(PlayerStatus#ets_users.nick_name),
			MyId = PlayerStatus#ets_users.id,
			MyPid = PlayerStatus#ets_users.other_data#user_other.pid_send,
	        Result = 
				case MyNick =:= TarNick of
					true -> 
						{false, invite_self};
					%%不能组自己
					_ ->
						case lib_player:get_role_id_by_name(TarNick) of
							null ->
								{false, player_not_exist};										%%不存在
							TarId ->
								case lib_player:get_online_info(TarId) of
									[] ->
										{false, player_offline};								%%不在线
									TarInfo ->
										handle_invite(PlayerStatus, TarInfo)
								end
						end
				end,
			case Result of 
				{false, invite_self} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_SELF]);
				{false, player_not_exist} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_NOT_EXIST]);
				{false, player_offline} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_OFFLINE]);
				{false, not_leader} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_NOT_LEADER]);
				{false, in_team} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_IN_TEAM]);
				{false, in_other_team} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_IN_OTHERTEAM]);
				{false, max_member} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_MAX_MEMBER]);
				{false, duplicate} ->
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_NOT_JOIN]);
				{ok, invite, TarID} -> 
					lib_chat:chat_sysmsg_pid([MyPid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_SUCCESS]),
					{ok, DataBin} = pt_17:write(?PP_TEAM_INVITE_MSG, [MyNick, MyId]),
					lib_send:send_to_uid(TarID, DataBin);
				{ok, join, TarLeaderId} ->
					{ok, DataBin} = pt_17:write(?PP_TEAM_INVITE_MSG, [MyNick, MyId]),
					lib_send:send_to_uid(TarLeaderId, DataBin);
				_ -> 
					skip
			end,
			ok
	end;
		

%%邀请信息,处理受邀人返回的组队应答
%%PlayerStatus受邀人信息
handle(?PP_TEAM_INVITE_MSG, PlayerStatus, [IsAgree, InviterId]) ->
%% 	InviterInfo = lib_player:get_online_info(InviterId),
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
		true when PlayerStatus#ets_users.other_data#user_other.map_template_id =/= ?GUILD_MAP_ID ->
			lib_chat:chat_sysmsg([PlayerStatus#ets_users.id, ?FLOAT, ?None, ?ORANGE, ?_LANG_NOT_ALLOW_OPERATE]),
			skip;
		_ ->
			case lib_player:get_online_info(InviterId) of
				InviterInfo when is_record(InviterInfo, ets_users)  ->
					case IsAgree of
						1 ->
							case misc:is_process_alive(InviterInfo#ets_users.other_data#user_other.pid_team) of
								true -> 
									case misc:is_process_alive(PlayerStatus#ets_users.other_data#user_other.pid_team) of
										true ->								%%都有队伍
											skip;
										_ ->								%%邀请人有队，受邀人无队,受邀人入队
											gen_server:cast(InviterInfo#ets_users.other_data#user_other.pid_team, 
											{join_team, PlayerStatus#ets_users.id, 
											 PlayerStatus#ets_users.other_data#user_other.pid, 
											 PlayerStatus#ets_users.nick_name,
											 PlayerStatus#ets_users.current_map_id,
											 PlayerStatus})
									end;
								_ ->
									case misc:is_process_alive(PlayerStatus#ets_users.other_data#user_other.pid_team) of
										true ->								%%邀请人无队，受邀人有队，邀请人入队
											gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, 
											{join_team, InviterInfo#ets_users.id, 
											 InviterInfo#ets_users.other_data#user_other.pid, 
											 InviterInfo#ets_users.nick_name,
											 InviterInfo#ets_users.current_map_id,
											 InviterInfo});
										_ ->								%%均无队，创建队伍
											mod_team:create_team([InviterInfo, PlayerStatus])
									end
							end;
						_ ->
							lib_chat:chat_sysmsg_pid([InviterInfo#ets_users.other_data#user_other.pid_send,
										   ?CHAT, ?None, ?ORANGE, ?GET_TRAN(?_LANG_TEAM_VITITE_DISAGREE, [PlayerStatus#ets_users.nick_name])])	%%拒绝邀请
					end;
				_ ->
					skip
			end
	end,
	ok;


%%查找空队伍和未加入队伍玩家
handle(?PP_TEAM_NOFULL_MSG, PlayerStatus, []) ->
	{_, WorkerPid} = mod_team_agent:get_mod_team_agent_pid(),
	gen_server:cast(WorkerPid,{get_notfull_and_no_team,
							   PlayerStatus#ets_users.other_data#user_other.pid_map,
							   PlayerStatus#ets_users.id,
							   PlayerStatus#ets_users.team_id,
							   PlayerStatus#ets_users.current_map_id,
							   PlayerStatus#ets_users.other_data#user_other.pid_send}),
%% 	mod_team_agent:get_notfull(PlayerStatus#ets_users.id,
%% 							   PlayerStatus#ets_users.other_data#user_other.pid_map,
%% 							   PlayerStatus#ets_users.team_id,
%% 							   PlayerStatus#ets_users.current_map_id,
%% 							   PlayerStatus#ets_users.other_data#user_other.pid_send),
	ok;

%%逐出队伍
handle(?PP_TEAM_KICK, PlayerStatus, [TarId]) ->
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
		true when PlayerStatus#ets_users.other_data#user_other.map_template_id =/= ?GUILD_MAP_ID ->
			lib_chat:chat_sysmsg([PlayerStatus#ets_users.id, ?FLOAT, ?None, ?ORANGE, ?_LANG_NOT_ALLOW_OPERATE]),
			ok;
		_ ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, {kick_out, TarId, PlayerStatus#ets_users.id}),
			ok
	end;
		

%%离开队伍
handle(?PP_TEAM_LEAVE, PlayerStatus, []) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, {team_quit, PlayerStatus#ets_users.id}),
	ok;

%%解散队伍
handle(?PP_TEAM_DISBAND, PlayerStatus, []) ->
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
		true when PlayerStatus#ets_users.other_data#user_other.map_template_id =/= ?GUILD_MAP_ID  ->
			lib_chat:chat_sysmsg([PlayerStatus#ets_users.id, ?FLOAT, ?None, ?ORANGE, ?_LANG_NOT_ALLOW_OPERATE]),
			ok;
		_ ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, {disband}),
			ok
	end;

%%更换队长
handle(?PP_TEAM_LEADER_CHANGE, PlayerStatus, [NewLeaderID]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, {change_leader, NewLeaderID, PlayerStatus#ets_users.id}),
	ok;

%%队伍设置
handle(?PP_TEAM_CHANGE_SETTING, PlayerStatus, [IsAutoIn, AllotMode]) ->
	Setting = [{is_autoin, IsAutoIn}, {allot_mode, AllotMode}],
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, {change_setting, Setting, PlayerStatus#ets_users.id}),
	ok;

%% %%获取队伍信息get_infant_user
%% handle(?PP_TEAM_GETALLINFO, PlayerStatus, []) ->
%% %% 	NewStatus = lib_team:member_check(PlayerStatus),
%% %% 	%%临时放这里（获取防沉迷信息）
%% %% 	lib_infant:send_infant_user(NewStatus),
%% %% 	%%临时放这里
%% %% 	pp_pet:handle(?PP_PET_LIST_UPDATE, PlayerStatus, []),
%% 	{ok, PlayerStatus};

%% 创建队伍 
handle(?PP_TEAM_CREATE, PlayerStauts, []) ->
	case misc:is_process_alive(PlayerStauts#ets_users.other_data#user_other.pid_team)of
		true ->
			ok;
		_ ->
			case lib_map:is_copy_scene(PlayerStauts#ets_users.current_map_id) of
			true when PlayerStauts#ets_users.other_data#user_other.map_template_id =/= ?GUILD_MAP_ID ->
				lib_chat:chat_sysmsg([PlayerStauts#ets_users.id, ?FLOAT, ?None, ?ORANGE, ?_LANG_NOT_ALLOW_OPERATE]),
				ok;
			_ ->
				mod_team:create_team([PlayerStauts, undefined]),
				lib_chat:chat_sysmsg_pid([PlayerStauts#ets_users.other_data#user_other.pid_send, 
							  ?CHAT, ?None, ?ORANGE, ?_LANG_TEAM_CREATE]),
				ok
			end
	end;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_team no match"}.

%%====================================================================
%% Private functions
%%====================================================================
%%邀请玩家或请求入队
handle_invite(SelfInfo, TarInfo) ->
	TarTeam = TarInfo#ets_users.other_data#user_other.pid_team,
	SelfTeam = SelfInfo#ets_users.other_data#user_other.pid_team,
	case misc:is_process_alive(TarTeam) of
		true ->
			case misc:is_process_alive(SelfTeam) of
				true -> 
					if TarTeam =/= SelfTeam -> 
						   {false, in_other_team};		%%在其他队伍
					   true -> 
						   {false, in_team}									%%已在队里
					end;
				_ ->														%%给对方队长发请求加入队伍
					gen_server:call(TarTeam, {join_request, SelfInfo})
			end;
		_ -> 
			case misc:is_process_alive(SelfTeam) of
				true ->
					gen_server:call(SelfTeam, {invite_request, SelfInfo#ets_users.id, TarInfo#ets_users.id});
				_ -> 
					{ok, invite, TarInfo#ets_users.id}
			end
	end.
	

