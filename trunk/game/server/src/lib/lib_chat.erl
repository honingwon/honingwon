%%%-------------------------------------------------------------------
%%% Module  : lib_chat
%%% Author  : 
%%% Description : 聊天
%%%-------------------------------------------------------------------
-module(lib_chat).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%% -define(Client_Config,64).					%%客户端配置（私聊是否允许）
%%-record(state, {}).
%%说话的时间间隔
%% -define(World_Time, 20).
%% -define(Other_Time, 2).

-define(CHAT_WORD_DIC, chat_word_dic). %% 世界进程字典
-define(CHAT_WORD_INTERVAL, 10). %%  说话时间间隔

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([chat_nearby/2,
		 chat_private/2,
		 chat_world/2,
		 chat_bugle/2,
		 chat_scene/2,
		 chat_team/2,
		 chat_sysmsg/1,
		 chat_sysmsg_roll/1,
%% 		 check_chat_interval/2,
%%          getChatTimeDiff/1,
         check_donttalk/1,
		 chat_sysmsg_pid/1,
		 chat_guild/2]).




%%====================================================================
%% External functions
%%====================================================================

%% 系统消息处理 根据id
chat_sysmsg([Msg]) ->
	{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?NOTIC,?None,?ORANGE,Msg]),
    lib_send:send_to_all(BinData);


chat_sysmsg([UId,Msg]) ->
{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?EVENT,?None,?ORANGE,Msg]),
    lib_send:send_to_uid(UId, BinData);

chat_sysmsg([Type,Code,Color,Msg]) ->
    {ok,BinData} = pt_16:write(?PP_SYS_MESS,[Type,Code,Color,Msg]),
    lib_send:send_to_all(BinData);

chat_sysmsg([UId, Type,Code,Color,Msg]) ->
    {ok,BinData} = pt_16:write(?PP_SYS_MESS,[Type,Code,Color,Msg]),
    lib_send:send_to_uid(UId, BinData).

chat_sysmsg_roll([Msg]) ->
	{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,Msg]),
    lib_send:send_to_all(BinData).

%% 系统消息处理 根据pid
chat_sysmsg_pid([PId,Msg]) ->
	{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?EVENT,?None,?ORANGE,Msg]),
    lib_send:send_to_sid(PId, BinData);

chat_sysmsg_pid([PId, Type, Code,Color,Msg]) ->
    {ok,BinData} = pt_16:write(?PP_SYS_MESS,[Type,Code,Color,Msg]),
    lib_send:send_to_sid(PId, BinData).

chat_guild(Status, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Msg]) ->
	VipID = Status#ets_users.vip_id,
	case Status#ets_users.club_id > 0 of
		true ->
%% 			case check_chat_interval(previous_chat_time_team, ?Other_Time) of	%目前使用队伍聊天的间隔
%% 				true ->
					{ok,BinData} = pt_16:write(?PP_CHAT,[Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
					lib_send:send_to_guild_user(Status#ets_users.club_id,BinData);
%% 				_ ->
%% 					{_Now,TimeDiff} = getChatTimeDiff(previous_chat_time_team), 
%%                       Time = 3 - TimeDiff div 1000000,
%%                       MsgInfo = lists:concat([?_LANG_CHAT_GUILD_TIME,Time,?_LANG_CHAT_TIME_UNIT]),
%% 			          chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,MsgInfo])
%% 			end;
		_ ->
			chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_CHAT_GUILD_MSG])
	end.

%% 队伍聊天
chat_team(Status, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Msg]) ->
	TeamPid = Status#ets_users.other_data#user_other.pid_team,
	VipID = Status#ets_users.vip_id,
    case misc:is_process_alive(TeamPid) of
        true ->
%%              case check_chat_interval(previous_chat_time_team, ?Other_Time) of
%%                 true ->
	                 {ok,BinData} = pt_16:write(?PP_CHAT,[Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
	                 lib_team:send_to_all(TeamPid, BinData);
%%                 false ->
%%                       {_Now,TimeDiff} = getChatTimeDiff(previous_chat_time_team), 
%%                       Time = 3 - TimeDiff div 1000000,
%%                       MsgInfo = lists:concat([?_LANG_CHAT_TEAM_TIME,Time,?_LANG_CHAT_TIME_UNIT]),
%% 			          chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,MsgInfo])
%%                 end;
        false ->
			  chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_CHAT_TEAM_MSG])
end.

%% 处理场景内的聊天
chat_scene(Status,[Channel,Nick,UserID,Sex,ToNick,ToUserID,Msg]) ->
	VipID = Status#ets_users.vip_id,
    {ok,BinData} = pt_16:write(?PP_CHAT,[Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
	mod_map_agent:send_to_scene(Status#ets_users.current_map_id,BinData).

%% 处理附近聊天(九宫格内)
chat_nearby(Status,[Channel,Nick,UserID,Sex,ToNick,ToUserID,Msg]) ->
	VipID = Status#ets_users.vip_id,
	{ok, BinData} = pt_16:write(?PP_CHAT, [Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
	mod_map_agent:send_to_area_scene(Status#ets_users.current_map_id,
                                     Status#ets_users.pos_x,
                                     Status#ets_users.pos_y,BinData).


%%处理私聊 
chat_private(PlayerStatus,[Channel,Nick,TempUserID,Sex,ToNick,ToUserID,Msg]) ->
	if TempUserID > 0 ->
		   UserID = TempUserID;
	   true ->
		   UserID = lib_player:get_role_id_by_name(ToNick)
	end,		 
	if UserID =/= ToUserID ->
	 case lib_player:get_online_info(ToUserID) of
		[]  -> 
			chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 ?FLOAT,?None,?ORANGE,?_LANG_CHAT_USER_MSG]);
	    ToPlayerInfo ->
			VipID = PlayerStatus#ets_users.vip_id,
			{ok, BinData} = pt_16:write(?PP_CHAT, [Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
		    lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			SelfRelationInfo = lists:keyfind(ToUserID,#ets_users_friends.friend_id, lib_friend:get_relation_dic()),
			chat_private1(SelfRelationInfo,
						  ToPlayerInfo#ets_users.other_data#user_other.pid,
						  ToPlayerInfo#ets_users.other_data#user_other.pid_send,
						  UserID,
						  BinData)
 	 end;
	true ->
			 chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							  ?FLOAT,?None,?ORANGE,?_LANG_CHAT_NOT_PRIVATE])
    end.

chat_private1(SelfRelationInfo,ToPid,ToPidSend,SelfID,BinData) ->
	if SelfRelationInfo =/= false ->
		   if SelfRelationInfo#ets_users_friends.state band ?RELATION_BLACK =/= 0 ->
				  skip;
			  true ->
				  chat_private2(ToPid,ToPidSend,SelfID,BinData)
		   end;
	   true ->
		   chat_private2(ToPid,ToPidSend,SelfID,BinData)
	end.

chat_private2(ToPid,ToPidSend,SelfID,BinData) ->
	case catch gen:call(ToPid,'$gen_call',{get_friend_info,SelfID},2000) of
		{'EXIT',_Reason} ->
			skip;
		{ok, UFriend} ->
			if UFriend =/= [] ->
				   [FriendInfo] = UFriend,
				   if FriendInfo band ?RELATION_BLACK =/= 0 ->
						  skip;
					  true ->
						  lib_send:send_to_sid(ToPidSend, BinData)
				   end;
			   true ->
				   lib_send:send_to_sid(ToPidSend, BinData)
			end
	end.

%%处理喇叭
chat_bugle(Status, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Msg]) ->
	{Status1,IsGetAward1,IsGetAward2,IsGetAward3} = lib_vip:check_vip_refresh(Status),
	VipID = Status1#ets_users.vip_id,
	VipBugle = Status1#ets_users.vip_bugle,
	{Res,NewStatus} = if
						VipBugle > 0 ->
							Status2 = Status1#ets_users{vip_bugle = VipBugle- 1},
							{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [Status2#ets_users.vip_id,
																	  Status2#ets_users.vip_date,
																	  Status2#ets_users.vip_tranfer_shoes,
																	  Status2#ets_users.vip_bugle,
																	  IsGetAward1,IsGetAward2,IsGetAward3]),
							lib_send:send_to_sid(Status2#ets_users.other_data#user_other.pid_send, VipBin),
							{true,Status2};
						true ->
								ItemPid = Status#ets_users.other_data#user_other.pid_item,
								{ok, R} = gen_server:call(ItemPid, {'item_use_by_other_mod', ?TEMPLATE_SPEAKER}),
								{R,Status}
						end,
	
	if 
		Res =/= false ->
	         {ok, BinData} = pt_16:write(?PP_CHAT, [Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
	         lib_send:send_to_all(BinData);
	    true ->
		   chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_CHAT_NOT_LABA])
	end,
	NewStatus.

%% 	VipID = Status1#ets_users.vip_id,
%% 	RealVipID = lib_vip:change_dbvip_to_vipid(VipID),
%% 
%% 
%% 	{Res,NewStatus} = if
%% 						VipBugle > 0 andalso RealVipID > 0 ->
%% 								Status1 = Status#ets_users{vip_bugle = VipBugle- 1},
%% 								Now = misc_timer:now_seconds(),
%% 								IsGetAward1 = case util:is_same_date(Now,Status1#ets_users.vip_yuanbao_date) of
%% 									 true ->
%% 										 1;
%% 									 _ ->
%% 										 0
%% 								 end,
%% 								IsGetAward2 = 
%% 									case util:is_same_date(Now,Status1#ets_users.vip_money_date) of
%% 										true ->
%% 											1;
%% 										_ ->
%% 											0
%% 									end,
%% 								IsGetAward3 = 
%% 									case util:is_same_date(Now,Status1#ets_users.vip_buff_date) of
%% 										true ->
%% 											1;
%% 										_ ->
%% 											0
%% 									end,
%% 								{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [Status1#ets_users.vip_id,
%% 																	  Status1#ets_users.vip_date,
%% 																	  Status1#ets_users.vip_tranfer_shoes,
%% 																	  Status1#ets_users.vip_bugle,
%% 																	  IsGetAward1,IsGetAward2,IsGetAward3]),
%% 								lib_send:send_to_sid(Status1#ets_users.other_data#user_other.pid_send, VipBin),
%% 					
%% 
%% 								{true,Status1};
%% 							true ->
%% 								ItemPid = Status#ets_users.other_data#user_other.pid_item,
%% 								{ok, R} = gen_server:call(ItemPid, {'item_use_by_other_mod', ?TEMPLATE_SPEAKER}),
%% 								{R,Status}
%% 						end,
%% 
%% 	if 
%% 		Res =/= false ->
%% 	         {ok, BinData} = pt_16:write(?PP_CHAT, [Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
%% 	         lib_send:send_to_all(BinData);
%% 	    true ->
%% 		   chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_CHAT_NOT_LABA])
%% 	end,
%% 	NewStatus.



%%处理世界聊天
chat_world(_Status, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Msg]) ->
	Level = _Status#ets_users.level,
	VipID = _Status#ets_users.vip_id,
	if Level < 1 ->
		     {ok, BinData} = pt_16:write(?PP_CHAT, [Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,?_LANG_CHAT_WORLD_LEVEL]),
			 lib_send:send_to_sid(_Status#ets_users.other_data#user_other.pid_send,BinData);
			 %%lib_send:send_to_uid(UserID,BinData);
	true -> 
		case check_chat_world_interval() of
			true ->
				{ok, BinData} = pt_16:write(?PP_CHAT, [Channel,VipID,Nick,UserID,Sex,ToNick,ToUserID,Msg]),
				lib_send:send_to_all(BinData);
			_ ->
				skip
%% 				{_Now,TimeDiff} = getChatTimeDiff(previous_chat_time_world), 
%% 				Time = 30 - TimeDiff div 1000000,
%% 				MsgInfo = lists:concat([?_LANG_CHAT_WORLD_TIME,Time,?_LANG_CHAT_TIME_UNIT]),
%% 				chat_sysmsg_pid([_Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,MsgInfo])
		end
	end.	
		
%%禁言判断
check_donttalk(Player) ->
	case Player#ets_users.ban_chat of 
		1 ->
			{true, Player};
		_ ->
			Date = Player#ets_users.ban_chat_date,
			Now = misc_timer:now_seconds(),
			if
				Now > Date ->
					NewPlayer1 = Player#ets_users{ban_chat = 1},
					{true,NewPlayer1};
				true ->
					{false,Player}
            end
	end.

				 


%% 获取聊天间隔
%% getChatTimeDiff(Previous_chat_time)->
%% 	case get(Previous_chat_time) of
%% 		undefined -> 
%% 			PreviousChatTime = {0,0,0};
%% 		Val ->
%% 			PreviousChatTime = Val
%% 	end,
%% 	Now = misc_timer:now(),
%% 	TimeDiff = timer:now_diff(Now, PreviousChatTime),
%% 	{Now,TimeDiff}.
%% 
%% %% 检查聊天间隔
%% check_chat_interval(Previous_chat_time, Interval) ->
%% 	{Now,TimeDiff} = getChatTimeDiff(Previous_chat_time),
%% 	if TimeDiff >= Interval*1000000 ->
%% 			put(Previous_chat_time, Now),
%% 			true;
%% 	   true ->
%% 		   false
%% 	end.

check_chat_world_interval() ->
	Now = misc_timer:now_seconds(),
	case get(?CHAT_WORD_DIC) of
		undefined ->
			NewTime = Now + ?CHAT_WORD_INTERVAL,
			put(?CHAT_WORD_DIC, NewTime),
			true;
		NextTime when Now > NextTime ->
			NewTime = Now + ?CHAT_WORD_INTERVAL,
			put(?CHAT_WORD_DIC, NewTime),
			true;
		_ ->
			false
	end.
		
