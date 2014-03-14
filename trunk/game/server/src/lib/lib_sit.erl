%%%-------------------------------------------------------------------
%%% Module  : lib_sit

%%% Author  : 
%%% Description : 打坐修炼
%%%-------------------------------------------------------------------
-module(lib_sit).



%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

-define(SIT_AWARD_20_SECONDS, 20).

%%--------------------------------------------------------------------
%% External exports
-export([start_sit/3, cancle_sit/1, invite_sit/3, invite_sit_reply/3, get_award_time/1, start_xw/1,cancle_xw/1,
		 change_sit_state/3, init_template_sit_award/0, get_award_by_level/2]).

%%初始化打坐奖励模板表
init_template_sit_award() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_sit_award_template] ++ Info),	
				ets:insert(?ETS_SIT_AWARD_TEMPLATE, Record)
		end,
	L = db_agent_template:get_sit_award_template(),
	lists:foreach(F, L),
	ok.

get_award_by_level(Level, Type) ->
	%%0 正常 1单修 2 修为 3 普双休 4特殊双休 
	case data_agent:get_sit_award_from_template(Level) of
		[] -> 
			[];
		Award ->
			case Type of
				1 -> 
					{Award#ets_sit_award_template.single_exp, 
					 Award#ets_sit_award_template.single_lifeexp,
					 Award#ets_sit_award_template.hp, Award#ets_sit_award_template.mp};
				2 ->
					{0,
					 Award#ets_sit_award_template.xw_lifeexp,
					 Award#ets_sit_award_template.hp, Award#ets_sit_award_template.mp};
				3 ->
					{Award#ets_sit_award_template.normal_double_exp,
					 Award#ets_sit_award_template.normal_double_lifeexp,
					 Award#ets_sit_award_template.hp, Award#ets_sit_award_template.mp};
				4 ->
					{Award#ets_sit_award_template.special_double_exp,
					 Award#ets_sit_award_template.special_double_lifeexp,
					 Award#ets_sit_award_template.hp, Award#ets_sit_award_template.mp};
				_ ->
					[]
			end
	end.
	
%%开始打坐
start_sit(PlayerStatus, Sit_State, Together_Id) ->      %Sit_State(0 正常 2 修为 3 普双休 4特殊双休 )
	case can_sit(PlayerStatus, Sit_State) of 
		{ok, Msg} ->
			NewPlayerStatus = change_sit_state(PlayerStatus, Sit_State, Together_Id);
		{error, Msg} ->
			NewPlayerStatus = PlayerStatus
	end,
	{Msg, NewPlayerStatus}.

%%取消打坐
cancle_sit(PlayerStatus) ->
	if 
		PlayerStatus#ets_users.other_data#user_other.sit_state =:= 0 ->
			NewPlayerStatus = PlayerStatus;
		true  ->
			NewPlayerStatus = change_sit_state(PlayerStatus, 0, 0)
	end,
	{?_LANGUAGE_SIT_CANCLE, NewPlayerStatus}.

%% 开始修为
start_xw(PlayerStatus) ->
	case can_sit(PlayerStatus, 2) of 
		{ok, Msg} ->
			NewPlayerStatus = change_sit_state(PlayerStatus, 2, 0);
		{error, Msg} ->
			NewPlayerStatus = PlayerStatus
	end,
	{Msg, NewPlayerStatus}.

%% 取消修为
cancle_xw(PlayerStatus) ->
	if 
		PlayerStatus#ets_users.other_data#user_other.sit_state =:= 0 ->
			NewPlayerStatus = PlayerStatus;
	   true  ->
		   case can_sit(PlayerStatus, 1) of 
			   {ok, _Msg} ->
				   NewPlayerStatus = change_sit_state(PlayerStatus, 1, 0);
			   {error, _Msg} ->
				   NewPlayerStatus = PlayerStatus
		   end
	end,
	{?_LANGUAGE_SIT_XW_CANCLE, NewPlayerStatus}.

							 
%%打坐邀请 (1成功 ；2已经在双修；3超过范围)
invite_sit(PlayerStatus, Nick, ID) ->
	UserId = PlayerStatus#ets_users.id,
	if
		ID =/= -1 ->
			BeInvitedID = ID;
		true ->
			BeInvitedID = lib_player:get_role_id_by_name(Nick)
	end,
	case lib_player:get_online_info(BeInvitedID) of
		[] ->  
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									   ?EVENT,?None,?RED,?_LANG_FRIEND_NOT_ONLINE]);    %%玩家不在线
		BeInvitedStatus ->
			SliceInfo = lib_map:get_9_slice(PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y),
			case lib_map:is_pos_in_slice(BeInvitedStatus#ets_users.pos_x, 
										 BeInvitedStatus#ets_users.pos_y, SliceInfo) of
				true ->
					case can_sit(BeInvitedStatus, 3) of
						{ok, _} ->
							Res = 1, SendToid = BeInvitedStatus#ets_users.other_data#user_other.pid_send;
						{error, _} ->
							Res = 2, SendToid = PlayerStatus#ets_users.other_data#user_other.pid_send
					end,
					{ok, BinData} = pt_12:write(?PP_SIT_INVITE,[Res, PlayerStatus#ets_users.nick_name,
															    PlayerStatus#ets_users.id,
															    PlayerStatus#ets_users.pos_x,
															    PlayerStatus#ets_users.pos_y]),
					lib_send:send_to_sid(SendToid, BinData);
 				_ ->
 					skip			
			end
	end.


%%打坐邀请回复
invite_sit_reply(PlayerStatus, SourceID, SitOrNot) ->
	case SitOrNot of
		1 ->
			invite_sit_reply1(PlayerStatus, SourceID);
		_ ->
			invite_sit_reply2(PlayerStatus, SourceID)
	end.

%%同意双修打坐
invite_sit_reply1(PlayerStatus, SourceID) ->
	UserId = PlayerStatus#ets_users.id,
	case lib_player:get_online_info(SourceID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
									  ?EVENT,?None,?RED,?_LANG_FRIEND_NOT_ONLINE]),
			PlayerStatus;    %%玩家不在线
		SourceStatus ->
			SliceInfo = lib_map:get_9_slice(PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y),
			case lib_map:is_pos_in_slice(SourceStatus#ets_users.pos_x, 
										 SourceStatus#ets_users.pos_y, SliceInfo) of
				true ->
					invite_sit_reply2(SourceStatus, PlayerStatus, SourceID, UserId);
				_ ->
					PlayerStatus
			end
	end.

invite_sit_reply2(SourceStatus, PlayerStatus, SourceID, UserId) ->
	case can_sit(SourceStatus, 3) of
		{error, _Msg} ->
			PlayerStatus;
		_ ->
			case can_sit(PlayerStatus, 3) of
				{error, _Msg1} ->
					PlayerStatus;
				_ ->
					%%特殊关系分别为师徒、结拜、婚姻,双修是State为4，暂不处理							
					Sit_State = 3, %%3普通双修，4特殊双修
					NewPlayerStatus = change_sit_state(PlayerStatus, 3, SourceID),
					gen_server:cast(SourceStatus#ets_users.other_data#user_other.pid, {'sit_start', Sit_State, UserId}),						
					%%广播双修信息
					{ok, BinData} = pt_12:write(?PP_SIT_INVITE_REPLY, [1, NewPlayerStatus#ets_users.id, SourceID]),
					mod_map_agent:send_to_area_scene(NewPlayerStatus#ets_users.current_map_id,
													 NewPlayerStatus#ets_users.pos_x,
													 NewPlayerStatus#ets_users.pos_y,
													 BinData,
													 undefined),
					NewPlayerStatus
			end
	end.

%%拒绝邀请
invite_sit_reply2(PlayerStatus, SourcNick) ->
	SourceID = lib_player:get_role_id_by_name(SourcNick),
	case lib_player:get_online_info(SourceID) of
		[] ->  
			skip;
		_SourceStatus ->
			{ok, BinData} = pt_12:write(?PP_SIT_INVITE_REPLY, [0, PlayerStatus#ets_users.id, SourceID]),
			lib_send:send_to_uid(SourceID, BinData)
	end,
	PlayerStatus.
		
%%%====================================================================
%%% Private functions
%%%====================================================================

%%检测能否打坐
can_sit(Status, Sit_State) ->
	PkTime1 = misc_timer:now_seconds() - Status#ets_users.other_data#user_other.last_pk_actor_time,     %(主动)
	PkTime2 = misc_timer:now_seconds() - Status#ets_users.other_data#user_other.last_pk_target_time,    %(被动)
	if Status#ets_users.other_data#user_other.sit_state == Sit_State  orelse 
												  (Status#ets_users.other_data#user_other.sit_state  + Sit_State )=:= 5  ->
		   {error, ?_LANGUAGE_SIT_ALREADY};
	   PkTime1 < 10 orelse PkTime2 <10 ->
		   {error, ?_LANGUAGE_SIT_ON_PK};
	   Status#ets_users.current_hp =< 0 ->
		   {error, ?_LANGUAGE_SIT_ON_PK};
	   true ->
		   {ok,?_LANGUAGE_SIT_START}
	end.

%%改变打坐状态
change_sit_state(PlayerStatus, Sit_State, Together_Id) ->
	if
		Sit_State == 0 andalso  PlayerStatus#ets_users.other_data#user_other.sit_state =:= 3 ->	
			Pid = lib_player:get_player_pid(PlayerStatus#ets_users.other_data#user_other.double_sit_id),
			case Pid of
				[] -> skip;
				_ ->
					gen_server:cast(Pid, {'sit_change_state', PlayerStatus#ets_users.id})
			end;
		true ->
			skip
	end,
	NewOtherData = PlayerStatus#ets_users.other_data#user_other{ sit_state = Sit_State, double_sit_id = Together_Id },

	if	
		Sit_State =:= 0 -> 
			NewOtherData1 = NewOtherData,
			Sit = 0;
		Sit_State =:= 2 -> 
			NewOtherData1 = NewOtherData#user_other{sit_date = misc_timer:now_seconds()},
			Sit = 2;
		true -> 
			Sit = 1,
			NewOtherData1 = NewOtherData#user_other{sit_date = misc_timer:now_seconds()}
	end,	
	NewPlayerStatus = PlayerStatus#ets_users{ other_data = NewOtherData1},
	
	if
		Sit_State < 3 ->
			
			%%广播普通修炼信息
			{ok, SitBin} = pt_12:write(?PP_SIT_START_OR_CANCLE,[PlayerStatus#ets_users.id, Sit]),
			mod_map_agent:send_to_area_scene(
			  NewPlayerStatus#ets_users.current_map_id,
			   NewPlayerStatus#ets_users.pos_x,
			  NewPlayerStatus#ets_users.pos_y,
			  SitBin,
			  undefined);
		true -> 
			skip
	end,
	NewPlayerStatus.

get_award_time(Sit_State) ->
	case Sit_State of
		_ ->
			?SIT_AWARD_20_SECONDS
			end.
		
