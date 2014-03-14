%%%-------------------------------------------------------------------
%%% Module  : mod_team
%%% Author  : 
%%% Description : 组队模块
%%%-------------------------------------------------------------------
-module(mod_team).
-behaviour(gen_server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([create_team/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(Check_Left_Tick, 60*1000).

%%====================================================================
%% External functions
%%====================================================================
%%创建队伍
create_team([InviterInfo, TarInfo]) ->
	{ok, TeamPid} = gen_server:start_link(?MODULE, [InviterInfo, TarInfo], []),
	TeamPid.

%% %%取得副本进程id
%% get_dungeon(TeamPid) ->
%%     case misc:is_process_alive(TeamPid) of
%% 		false -> false;
%%         true -> gen_server:call(TeamPid, get_dungeon)
%%     end.

%%====================================================================
%% Callback functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%%--------------------------------------------------------------------
init([InviterInfo, TarInfo]) ->
%% 	if is_pid(PidDungeon) -> nil;
%% 		   mod_dungeon:set_team_pid(PidDungeon, self());
%% 	   true -> no_dungeon
%% 	end,
	try 
		
	TeamId = mod_team_agent:get_index(),
	ProcessName = misc:create_process_name(mod_team, [TeamId]),
	misc:register(global, ProcessName, self()),
	misc:write_monitor_pid(self(),?MODULE, {}),
	
	Id = InviterInfo#ets_users.id,
	Pid = InviterInfo#ets_users.other_data#user_other.pid,
	Nick = InviterInfo#ets_users.nick_name,
		Member = [#team_member{id = Id, 
						   pid = Pid,
						   nickname = Nick,
						   index = 0,
						   mapid = InviterInfo#ets_users.current_map_id,
						   user = InviterInfo
						   }],
	%% 邀请入队，同时创建队伍的
	NewMember = case erlang:is_record(TarInfo, ets_users) of
					true -> 
						gen_server:cast(TarInfo#ets_users.other_data#user_other.pid, {join_team, self(), TeamId, ?DROP_ITEM_RANDOM,0,0}),
						
						lib_chat:chat_sysmsg_pid([TarInfo#ets_users.other_data#user_other.pid_send,
												   ?CHAT, ?None, ?ORANGE, ?_LANG_TEAM_JOIN_SELFTEXT]),
						JoinMsg = ?GET_TRAN(?_LANG_TEAM_JOIN_TEXT, [TarInfo#ets_users.nick_name]),
						lib_chat:chat_sysmsg_pid([InviterInfo#ets_users.other_data#user_other.pid_send,
											   ?CHAT, ?None, ?ORANGE, JoinMsg]),
						
						[#team_member{id = TarInfo#ets_users.id,
						   pid = TarInfo#ets_users.other_data#user_other.pid,
						   nickname = TarInfo#ets_users.nick_name,
						   index = 1,
						   mapid = TarInfo#ets_users.current_map_id,
						   user = TarInfo
						  }|Member];
					_ ->
						Member
				end,
	
	
	gen_server:cast(Pid, {join_team, self(), TeamId,?DROP_ITEM_RANDOM,0,0}),				%%更改新队员的pid_team

	State = #ets_team{id = TeamId,
					  pid = self(),
					  allot_mode = 1,
					  leaderid = Id,
					  leaderpid = Pid,
					  leadername = Nick,
					  leadermap = InviterInfo#ets_users.current_map_id,
					  teamname = tool:to_list(Nick) ++ ?_LANG_TEAM_NAME,
					  member = NewMember
					 },
	
%% 	mod_team_agent:insert_team(State),							%%加入或更新管理进程的队伍信息
%% 	send_team_info(State, []),
 	gen_server:cast(self(), {update_team_info, State, []}),
	
	%%定时更新玩家位置	
	erlang:send_after(1000, self(), {send_team_position}),
	
	%% 清理不在线玩家
	erlang:send_after(?Check_Left_Tick, self(), {check_left_member}),
	{ok, State}
	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{stop, "create team is error."}
	end.


%%--------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("TeamId:~w, mod_team handle_call is exception:~w~n,Info:~w",[State#ets_team.id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{reply, ok, State}
	end.

%%--------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("TeamId:~w, mod_team handle_cast is exception:~w~n,Info:~w",[State#ets_team.id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.
		
%%--------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_info(Info, State) ->
	try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("TeamId:~w, mod_team handle_info is exception:~w~n,Info:~w",[State#ets_team.id, Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%%--------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%%--------------------------------------------------------------------
terminate(_Reason, State) ->
	mod_team_agent:remove_team(State),	%%删除管理进程的队伍信息
	misc:delete_monitor_pid(self()),
    ok.

%%--------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Local functions
%%====================================================================
%%设置队员index,用于客户端跟随
set_index(State) ->
	F = fun(I, [L, N]) ->
				case I#team_member.id =:= State#ets_team.leaderid of
					true -> 
						L1 = L ++ [I#team_member{index = 0}],
						[L1, N];
					_ -> 
						L1 = L ++ [I#team_member{index = N}],
						[L1, N + 1]
				end
		end,
	[Member, _] = lists:foldl(F, [[], 1], State#ets_team.member),
	State#ets_team{member = Member}.

%%向所有队员发送信息
send_team(TeamInfo, Bin) ->
    F = fun(MemberId) ->
        		lib_send:send_to_uid(MemberId, Bin)
    	end,
    [F(Member#team_member.id)|| Member <- TeamInfo#ets_team.member].

%%向其他队员发送信息
send_to_other_member(SelfId, TeamInfo, Bin) ->
	case length(TeamInfo#ets_team.member) > ?TEAM_MEMBER_MIN of
		true ->
			F = fun(MemberId) ->
        		lib_send:send_to_uid(MemberId, Bin)
    		end,
    		[F(Member#team_member.id) || Member <- TeamInfo#ets_team.member, Member#team_member.id =/= SelfId];
		false ->
			skip
	end.

%% 发送队友地图位置
send_team_map_info(TeamInfo) ->
	case length(TeamInfo#ets_team.member) > ?TEAM_MEMBER_MIN of
		true ->
			F = fun(Member,List) ->
				MemberId = Member#team_member.id,
				case lib_player:get_online_info(MemberId) of 
					[] -> List;
					User ->%?DEBUG("current_map_id ~p",[User#ets_users.other_data#user_other.map_template_id]),
						[{MemberId,User#ets_users.other_data#user_other.map_template_id,User#ets_users.pos_x,User#ets_users.pos_y}|List]
				end
    		end,
			PositionList = lists:foldl(F, [], TeamInfo#ets_team.member),
			{ok,BinData} = pt_17:write(?PP_TEAM_POSITION_UPDATE, [PositionList]),
			send_team(TeamInfo,BinData);
		false ->
			skip
	end.
	

%% 发送队伍信息,NoticeList离队队员ID列表
send_team_info(TeamInfo, NoticeList) ->
    Data = [
        TeamInfo#ets_team.id,
        TeamInfo#ets_team.leaderid,
%%         pack_member(TeamInfo#ets_team.member),
		TeamInfo#ets_team.member,
		NoticeList
    ],
    {ok, BinData} = pt_17:write(?PP_TEAM_UPDATE_MSG, Data),
    send_team(TeamInfo, BinData),
	lib_send:do_broadcast_id(NoticeList, BinData).

%%取得在线队员列表
get_online_member(Members, Esc) ->
	F = fun(M) -> 
				if M#team_member.id =/= Esc ->
					   case M#team_member.state =:= 1 of
%% 					   case misc:is_process_alive(M#team_member.pid) of
						   true -> 
							   true;
						   _ -> 
							   false
					   end;
				   true -> false
				end
		end,
	lists:filter(F, Members).

%%换队长
change_leader(TeamInfo, ToMb) ->
	NewInfo1 = TeamInfo#ets_team{
								leaderid = ToMb#team_member.id, 
								leaderpid = ToMb#team_member.pid, 
								leadername = ToMb#team_member.nickname,
								leadermap = ToMb#team_member.mapid,
								teamname = tool:to_list(ToMb#team_member.nickname) ++ ?_LANG_TEAM_NAME
										   },
	NewInfo = set_index(NewInfo1),
	lib_team:sysmsg_team_other(NewInfo#ets_team.leaderid, NewInfo,
							   [?CHAT,?None,?ORANGE, tool:to_list(NewInfo#ets_team.leadername)
							   ++ ?_LANG_TEAM_LEADER_CHANGE]),
	lib_chat:chat_sysmsg([NewInfo#ets_team.leaderid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_LEADER_CHANGE_SELF]),
	NewInfo.

%%通知成员拾取模式改变
notice_team_allot_change(Members,Mode) ->
	F = fun(Member) ->
				gen_server:cast(Member#team_member.pid,{team_allot_change, Mode})
		end,
	lists:foreach(F, Members).

%%---------------------do_call--------------------------------
%%获取队伍信息
do_call({get_team_info}, _From, State) ->
    {reply, State, State};

%%获取掉落物品的所属者
do_call({get_drop_owner_id}, _From, State) ->
	N = State#ets_team.drop_owner_id rem length(State#ets_team.member) + 1,	
	Info = lists:nth(N, State#ets_team.member),
	{reply, Info#team_member.id,State#ets_team{drop_owner_id = State#ets_team.drop_owner_id + 1}};
	

%%申请加入队伍
do_call({join_request, PlayerInfo}, _From, State) ->
	case State#ets_team.duplicate_pid =/= undefined of
		true ->
			{reply, {false, duplicate}, State};
		_ ->
			if length(State#ets_team.member) < ?TEAM_MEMBER_MAX ->
				   case State#ets_team.is_autoin of 
					   0 ->			%%不自动入队
						   LeaderId = State#ets_team.leaderid,
						   {reply, {ok, join, LeaderId}, State};				%%向队长发送进队申请
					   _ ->			%%自动入队
						   gen_server:cast(self(), {join_team, PlayerInfo#ets_users.id, 
									PlayerInfo#ets_users.other_data#user_other.pid, 
									PlayerInfo#ets_users.nick_name,
									PlayerInfo#ets_users.current_map_id,
									PlayerInfo}),
						   {reply, {ok, auto_in}, State}
				   end;
		   true -> 
			   {reply, {false, max_member}, State}							%%队伍满
		end
	end;

%%邀请入队，验证邀请返回结果
do_call({invite_request, InviteId, TarId}, _From, State) ->
	case State#ets_team.duplicate_pid =/= undefined of
		true ->
			{reply, {false, duplicate}, State};
		_ ->
			if InviteId =/= State#ets_team.leaderid andalso State#ets_team.allow_invit =/= 1 -> 
		   		{reply, {false, not_leader}, State};							%%不是队长
	   		true -> 
		   		if length(State#ets_team.member) >= ?TEAM_MEMBER_MAX ->
						   {reply, {false, max_member}, State};					%%队伍满
					   true ->
						   case lists:keyfind(TarId, 2, State#ets_team.member) of
							   false ->
								   {reply, {ok, invite, TarId}, State};			%%可以邀请入队，或看需要继续添加判断条件
							   _ -> 
								   {reply, {false, in_team}, State}				%%已在队伍中
						   end
				end
		end
	end;
%% %%修改队伍分配方式
%% handle_call({change_allot_mode, Mode, PlayerId}, _From, State) ->
%% 	if PlayerId =:= State#ets_team.leaderid ->
%% 		   NewState = State#ets_team{allot_mode = Mode},
%% 		   {reply, ok, NewState};
%% 	   true ->
%% 		   {reply, false, State}
%% 	end;
%% %%修改队伍分配品质
%% handle_call({change_allot_class, Class, PlayerId}, _From, State) ->	
%% 	if PlayerId =:= State#ets_team.leaderid ->
%% 		   NewState = State#ets_team{allot_class = Class},
%% 		   {reply, ok, NewState};
%% 	   true ->
%% 		   {reply, false, State}
%% 	end;
%%检查玩家是否在队伍中
do_call({member_check, PlayerInfo}, _From, State) -> 
	Result = case lists:keyfind(PlayerInfo#ets_users.id, 2, State#ets_team.member) of
				 false -> 
					 PlayerInfo;
				 Mb1 -> 
					 Mb2 = Mb1#team_member{pid = PlayerInfo#ets_users.other_data#user_other.pid, state = 1},
					 List = lists:keyreplace(PlayerInfo#ets_users.id, 2, State#ets_team.member, Mb2),
					 NewState = State#ets_team{member = List},
					 gen_server:cast(self(), {update_team_info, NewState, []}),
					 Other = PlayerInfo#ets_users.other_data#user_other{pid_team = State#ets_team.pid, allot_mode = 1},
					 PlayerInfo#ets_users{other_data = Other}
			 end,
	{reply, Result, State};

%%创建副本进程
do_call({create_duplicate, MapId, DuplicateId, MissionIndex, DuplicateName, PlayerInfo, PlayerPid,PidSend}, _From, State) ->
	{UserId, PlayerName, Sex, VipLevel} = PlayerInfo,
	case misc:is_process_alive(State#ets_team.duplicate_pid) andalso State#ets_team.duplicate_map_id =:= MapId  andalso 
							UserId =/= State#ets_team.leaderid of
		true ->		
			%% todo 不要再去找队长
			case lib_player:get_online_info(State#ets_team.leaderid) of
				[] ->							
					lib_chat:chat_sysmsg([UserId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_NOT_CREATE_DUPLICATE]),
					{reply, error, State};
				LeadInfo ->												
					if
						State#ets_team.duplicate_pid =/= LeadInfo#ets_users.other_data#user_other.pid_dungeon ->													
							lib_chat:chat_sysmsg([UserId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_NOT_CREATE_DUPLICATE]),
							{reply, error, State};
						true ->																					
							gen_server:cast(State#ets_team.duplicate_pid, {'join', {UserId,PlayerName,PlayerPid,PidSend,VipLevel,Sex}}),
							{reply, {ok, State#ets_team.duplicate_pid}, State}
					end
			end;
		
		_ ->			
			case UserId =/= State#ets_team.leaderid orelse misc:is_process_alive(State#ets_team.duplicate_pid) of
				true -> 
					if 
						UserId =/= State#ets_team.leaderid ->
						   lib_chat:chat_sysmsg([UserId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_NOT_LEADER_DUPLICATE]);
						true ->
						   lib_chat:chat_sysmsg([UserId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_READY_DUPLICATE])
					end,
				   {reply, error, State};
				
				_ ->									
				   case lib_team:check_duplicate_in_team(DuplicateId, State) of
					   {ok} ->
						   AverLevel = average_level_in_team(State),
						   
						   {ok, Pid} = mod_duplicate:start(self(), UserId, MapId, {UserId,PlayerName,PlayerPid, PidSend, VipLevel,Sex}, DuplicateId, MissionIndex, AverLevel),
						   NewState = State#ets_team{duplicate_pid=Pid, duplicate_map_id=MapId},
						   {reply, {ok, Pid, [State#ets_team.pid, UserId, DuplicateId, DuplicateName]}, NewState};
					   _ ->
						  {reply, error, State}
				   end
			
			end
	end;
	


do_call(Info, _, State) ->
	?WARNING_MSG("mod_team  call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
%% 清除副本信息
do_cast({'clear_dup'}, State) ->
	NewState = State#ets_team{duplicate_pid=undefined, duplicate_map_id = undefined},
	{noreply, NewState};

do_cast({'send_to_teammate_enter', UserId, DuplicateId, DuplicateName}, State) ->
	{ok, Bin} = pt_17:write(?PP_TEAM_DUPLICATE_ENTER, [DuplicateId, DuplicateName]),
	send_to_other_member(UserId, State, Bin),
	{noreply, State};
	

%%添加新队员
do_cast({join_team, PlayerId, Pid, Nick, MapId, User}, State) ->
	case lists:keyfind(PlayerId, 2, State#ets_team.member) of
		false ->
			case length(State#ets_team.member) < ?TEAM_MEMBER_MAX of
				true -> 
					Mb = State#ets_team.member ++ [#team_member{id = PlayerId, pid = Pid, nickname = Nick, mapid = MapId, user=User}],
					NewState = set_index(State#ets_team{member = Mb}),
					?DEBUG("State#ets_team.allot_mode:~p",[State#ets_team.allot_mode]),
					gen_server:cast(Pid, {join_team, self(), State#ets_team.id,
											 State#ets_team.allot_mode, State#ets_team.is_autoin, State#ets_team.allow_invit}),	%%更改新队员的pid_team
					gen_server:cast(self(), {update_team_info, NewState, []}),
			JoinMsg = ?GET_TRAN(?_LANG_TEAM_JOIN_TEXT, [Nick]),
			lib_team:sysmsg_team_other(PlayerId, NewState,
									   [?CHAT, ?None, ?ORANGE, JoinMsg]),
			lib_chat:chat_sysmsg([PlayerId, ?CHAT, ?None, ?ORANGE, ?_LANG_TEAM_JOIN_SELFTEXT]);
				_ -> 
					skip
			end;
		_ -> skip
	end,
	{noreply, State};

%%踢出队伍
do_cast({kick_out, TarId, PlayerId}, State) ->
	case PlayerId =:= State#ets_team.leaderid of
        false -> 
			skip;								%%不是队长
        true -> 
			case lists:keyfind(TarId, 2, State#ets_team.member) of
				false -> 
					skip;
				Mb -> 
					case length(State#ets_team.member) > ?TEAM_MEMBER_MIN of
						true -> 
							NewMb = lists:keydelete(TarId, 2, State#ets_team.member),
							NewState = set_index(State#ets_team{member = NewMb}),
						    gen_server:cast(Mb#team_member.pid, {leave_team}),
							gen_server:cast(self(), {update_team_info, NewState, [Mb#team_member.id]}),
			lib_team:sysmsg_team_all(NewState,
									 [?CHAT,?None,?ORANGE, ?GET_TRAN(?_LANG_TEAM_LEAVE_TEXT, [Mb#team_member.nickname])]),
			lib_chat:chat_sysmsg([TarId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_KICK_SELFTEXT]);
%%	?PRINT("~p kick team ~p~n", [Mb#team_member.nickname, NewState]),
%% 							{reply, ok, NewState};
						false -> 
							gen_server:cast(self(), {disband})
%%	?PRINT("team disband ~n"),
%% 							{reply, ok, State}
                    end
			end
    end,
	{noreply, State};
%%离开队伍
do_cast({team_quit, PlayerId}, State) ->
	case lists:keyfind(PlayerId, 2, State#ets_team.member) of
        false -> {noreply, State};
        Mb ->															%%检查是否能退出队伍
			{Result, RetState} =
				case length(State#ets_team.member) > 1 of
                    false ->
						gen_server:cast(self(), {disband}),				%%剩余两人以下，解散队伍
						{0, State};
                    _ ->
						Online = get_online_member(State#ets_team.member, PlayerId),
						case length(Online) > 0 of
							false ->
								gen_server:cast(self(), {disband}),		%%在线剩余两人以下，解散队伍
								{0, State};
							_ ->
								case PlayerId =:= State#ets_team.leaderid of	%%检查是否是队长退队
									true ->
										NewMb = lists:keydelete(PlayerId, 2, State#ets_team.member),
										[H|_T] = Online,
										NewState = change_leader(State#ets_team{member = NewMb}, H),
										{1, NewState};
									_ ->									%非队长退出
										NewMb = lists:keydelete(PlayerId, 2, State#ets_team.member),
										NewState = set_index(State#ets_team{member = NewMb}),
										{1, NewState}
								end
						end
				end,
			case Result of
				1 ->			%%离队成功,更新队伍成员位置信息
					lib_team:sysmsg_team_all(RetState,
									 [?CHAT,?None,?ORANGE,?GET_TRAN(?_LANG_TEAM_LEAVE_TEXT, [Mb#team_member.nickname])]),
					lib_chat:chat_sysmsg([PlayerId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_LEAVE_SELFTEXT]),
					gen_server:cast(Mb#team_member.pid, {leave_team}),
					gen_server:cast(self(), {update_team_info, RetState, [PlayerId]});
				_ ->
					skip
			end,
			{noreply, RetState}
	end;

%%修改队伍设置
do_cast({change_setting, Setting, PlayerId}, State) when is_list(Setting) ->
	if PlayerId =:= State#ets_team.leaderid ->
		   F = fun(I, Acc) ->
					   case I of 
						   {is_autoin, Auto} -> 
							   Acc#ets_team{is_autoin = Auto};
						   {allot_mode, Mode} -> 
							   %通知成员新的拾取模式(拾取模式固定，该为设置允许队员邀请其它玩家)
							   %%notice_team_allot_change(State#ets_team.member,Mode),
							   Acc#ets_team{allow_invit = Mode};
%% 						   {allot_class, Class} -> 
%% 							   Acc#ets_team{allot_class = Class};
						   _ -> 
							   Acc
					   end
			   end,
		   NewState = lists:foldl(F, State, Setting),
		   mod_team_agent:insert_team(NewState),			%%加入或更新管理进程的队伍信息
		   TeamID = NewState#ets_team.id,
		   IsAutoIn = NewState#ets_team.is_autoin, 
		   AllowInvit = NewState#ets_team.allow_invit, 
		   
%% 		   AllotClass = NewState#ets_team.allot_class,
		   {ok, Data} = pt_17:write(?PP_TEAM_CHANGE_SETTING, [TeamID, IsAutoIn, AllowInvit]),
		   send_team(NewState, Data),
		   lib_team:sysmsg_team_all(NewState, [?CHAT,?None,?ORANGE, ?_LANG_TEAM_SETTING_CHANGE]),
		   {noreply, NewState};
%% 		   {reply, ok, NewState};
	   true ->
%%	?PRINT("~p not leader~n", [PlayerId]),
 		   lib_chat:chat_sysmsg([PlayerId, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_NOT_LEADER]),
		   {noreply, State}
%% 		   {reply, false, State}
	end;
%%更换队长
do_cast({change_leader, ToUid, FromUid}, State) ->
	case FromUid =:= State#ets_team.leaderid of
		false -> 								%% 非队长无法委任队长
			lib_chat:chat_sysmsg([FromUid, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_VITITE_NOT_LEADER]),
			{noreply, State};
        true ->
            case lists:keyfind(ToUid, 2, State#ets_team.member) of
                false -> 
					{noreply, State};
                Mb -> 
					case lib_player:is_online(ToUid) of
						false ->
							{noreply, State};
						true ->
							NewState = change_leader(State, Mb),
							gen_server:cast(self(), {update_team_info, NewState, []}),
%% 							{reply, ok, NewState}
							{noreply, NewState}
					end
            end
    end;
%%解散队伍
do_cast({disband}, State) -> 
    F = fun(Member) ->
            gen_server:cast(Member#team_member.pid, {leave_team}),
			Member#team_member.id
        end,
    NoticeList = [F(M)|| M <- State#ets_team.member],
	send_team_info(State#ets_team{member = []}, NoticeList),
	[lib_chat:chat_sysmsg([I, ?CHAT,?None,?ORANGE, ?_LANG_TEAM_DISBAND_TEXT]) || I <- NoticeList],
%%	?PRINT("team disband ~p~n", [NoticeList]),
    {stop, normal, State};

%%队员升级通知队友  
do_cast({'update_teammate_levelup', UserId, UserLevel}, State) ->
	TeaMemList = State#ets_team.member,
	F = fun(Info, List) ->
				if
					Info#team_member.id =:= UserId ->
						UserInfo = Info#team_member.user,
						NewUserInfo = UserInfo#ets_users{level=UserLevel},
						NewInfo = Info#team_member{user=NewUserInfo},		
						[NewInfo | List];
					true ->
						[Info | List]
				end
		end,
	NewTeamMemList = lists:foldl(F, [], TeaMemList),
	NewState = State#ets_team{member=NewTeamMemList},

	{ok, LevelBin} = pt_17:write(?PP_TEAM_LEVEL_UPDATE, [UserId, UserLevel]),
	F1 = fun(Info, [Bin]) ->
				 lib_send:send_to_sid(Info#team_member.user#ets_users.other_data#user_other.pid_send, Bin),
				 [Bin]
		 end,
	lists:foldl(F1, [LevelBin], NewState#ets_team.member),
	
	{noreply, NewState};

	
%%广播给队员
do_cast({send_to_member, Data}, State) -> 
	send_team(State, Data),
	{noreply, State};
%%广播给其他队员
do_cast({send_to_other_member, SelfId, Data}, State) -> 
	send_to_other_member(SelfId, State, Data),
	{noreply, State};
%%队伍聊天
%% handle_cast({team_chat, Data}, State) -> 
%%     send_team(State, Data),
%% 	{noreply, State};
%%查看队伍信息
do_cast({send_team_info}, State) ->
	send_team_info(State, []),
	{noreply, State};
%%更新队伍信息
do_cast({update_team_info, TeamInfo, NoticeList}, _State) when is_record(TeamInfo, ets_team) ->
	mod_team_agent:insert_team(TeamInfo),							%%加入或更新管理进程的队伍信息
	send_team_info(TeamInfo, NoticeList),
	{noreply, TeamInfo};
%% 更新队员在线状态和地图[{state, Online},{mapid, MapId}]
do_cast({update_member_info, PlayerId, InfoList}, State) ->
	case lists:keyfind(PlayerId, 2, State#ets_team.member) of 
		false -> 
			{noreply, State};
		Mb -> 
			F = fun(I, Acc) ->
						case I of 
							{state, Online} -> 
								Acc#team_member{state = Online};
							{mapid, MapId} -> 
								Acc#team_member{mapid = MapId};
							_ -> Acc
						end
				end,
			NewMb = lists:foldl(F, Mb, InfoList),
			List = lists:keyreplace(PlayerId, 2, State#ets_team.member, NewMb),
			NewState = 
				case PlayerId =:= State#ets_team.leaderid of		%%是否是队长
					true -> 
						State#ets_team{leadermap = NewMb#team_member.mapid, member = List};
					_ -> 
						State#ets_team{member = List}
				end,
			mod_team_agent:insert_team(NewState),					%%加入或更新管理进程的队伍信息
			send_team_info(NewState, []),
			{noreply, NewState}
	end;
%%检查队伍状态
do_cast({team_check, PlayerId}, State) ->

	NewMember = lists:map(fun(Info) -> 
								  if Info#team_member.id =:= PlayerId ->
										 Info#team_member{state = 0};
									 true -> 
										 Info
								  end
						  end, State#ets_team.member),
	
	case get_online_member(NewMember, PlayerId) of
		[] -> 
			gen_server:cast(self(), {disband}),				%%全下线解散队伍
			{noreply, State};
		[Mb | _] -> 
			NewState = 
				if State#ets_team.leaderid =:= PlayerId ->
					   change_leader(State, Mb);
				   true -> 
					   State
				end,
			gen_server:cast(self(), {update_member_info, PlayerId, [{state, 0}]}),
			{noreply, NewState}
	end;
%% %%投骰子
%% handle_cast({random_drop, PlayerInfo, DropList, DropId, MonId}, State) ->
%% 	{noreply, State};
%% %%共享队伍经验
%% handle_cast({share_team_exp, PlayerId, MonExp, MonSpirit, MonId, MonLv, MapId, X, Y}, State) ->
%% 	{noreply, State};
%% %% 清除队伍副本
%% handle_cast(clear_dungeon, State) ->
%% 	{noreply, State};

%% 停止
do_cast({stop, _Reason}, State) ->
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_team  cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%%踢出30分钟不在线玩家
do_info({check_left_member}, State) ->
	F = fun(M) ->
				case misc:is_process_alive(M#team_member.pid) of 
					true -> skip;
					_ ->
						PlayerInfo = lib_player:get_player_info_by_id(M#team_member.id),
						Now = misc_timer:now_seconds(),
						if
							(Now - PlayerInfo#ets_users.last_online_date) > 60 * 30 ->
								gen_server:cast(self(), {team_quit,M#team_member.id});
							true -> skip
						end
				end
		end,	
	[F(M) || M <- State#ets_team.member],
	erlang:send_after(?Check_Left_Tick, self(), {check_left_member}),
	{noreply, State};

do_info({send_team_position}, State) ->
	%?DEBUG("send_team_postion",[]),
	send_team_map_info(State),
	erlang:send_after(1000, self(), {send_team_position}),
	{noreply,State};

do_info(Info, State) ->
	?WARNING_MSG("mod_team info is not match:~w",[Info]),
    {noreply, State}.


%%====================================================================
%% Private functions
%%====================================================================
average_level_in_team(State) ->
	MemberList = State#ets_team.member,
	F = fun(Member, [TotalLevel, Num]) ->
				Info = Member#team_member.user,
				Level = Info#ets_users.level,
				[Level+TotalLevel, Num+1]
		end,
	[Total, Number] = lists:foldl(F, [0,0], MemberList),
	AverLevel = Total/Number,
	NewAverLevel = tool:ceil(AverLevel),
	NewAverLevel.




