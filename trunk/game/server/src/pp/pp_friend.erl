%% Author: 黄文龙
%% Created: 2011-3-11
%% Description: TODO: Add description to pp_friend
-module(pp_friend).

-include("common.hrl").

-export([handle/3]).




%% API Functions
%%
%%返回关系列表
handle(?PP_FRIEND_LIST,PlayerStatus,[])->
	RelationL = lib_friend:get_relation_dic(),
	GroupL = lib_friend:get_relation_group_dic(),
	{ok, Bin} = pt_18:write(?PP_FRIEND_LIST,[RelationL,GroupL]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
	ok;
	
%%添加到关系         RelationQuery 32位数
handle(?PP_FRIEND_UPDATE, PlayerStatus,[FriendNick, RelationQuery]) ->
	RelationL = lib_friend:get_relation_dic(),
	UserId=PlayerStatus#ets_users.id,
	case db_agent_user:get_user_info_by_Nick(FriendNick) of
			 [FriendId, FriendSex, FriendLevel, FriendOnline, FriendCareer] ->
				 if UserId =:= FriendId ->
						lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,?_LANG_FRIEND_REQUEST_SELF]);
						%{ok,Bin} = pt_18:wirte(?PP_FRIEND_SYS_MSG,[?RELATION_ERROR_NOT_SELF]),
						%lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);
					true ->
						case lib_friend:add_relation(
						  PlayerStatus#ets_users.id,PlayerStatus#ets_users.nick_name,
						  PlayerStatus#ets_users.other_data#user_other.pid_send,
						  PlayerStatus#ets_users.other_data#user_other.pid_target,
			 			  FriendId,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
			 			  RelationQuery,RelationL) of
%% 							{ok,RPidSend,RBin,RNewRelationL} ->
%% 								lib_send:send_to_sid(RPidSend,RBin),
%% 								put(?DIC_USERS_RELATION,RNewRelationL),
%% %% 								{ok,PlayerStatus};
%% 								ok;
							{ok,RPidSend,RBin} ->
								lib_send:send_to_sid(RPidSend,RBin),
								ok;
							{false,Msg} ->
								lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg]),
								ok;
							_Error ->
								?WARNING_MSG("pp_friend PP_FRIEND_UPDATE is error: ~p ~n",[_Error])
						end
				 end;
		_ ->
		     %% 昵称不存在，发回client		
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,?_LANG_FRIEND_ROLE_NOT_EXIST])
	end;

%% 好友请求回复     参数：对方Id , 是否添加好友
handle(?PP_FRIEND_ACCEPT, PlayerStatus, [FriendID, IsFriend]) ->
	RelationL = lib_friend:get_relation_dic(),
	case IsFriend of
		1-> 
			case lib_friend:add_relation_friend_response(PlayerStatus#ets_users.id,PlayerStatus#ets_users.nick_name,
														 PlayerStatus#ets_users.sex,PlayerStatus#ets_users.level,
														 PlayerStatus#ets_users.state,PlayerStatus#ets_users.career,
														 PlayerStatus#ets_users.other_data#user_other.pid_send,
													RelationL,PlayerStatus#ets_users.other_data#user_other.pid_target,FriendID) of
%% 				{ok,RPidSend,RBin,RNewRelationL} ->
%% 					lib_send:send_to_sid(RPidSend,RBin),
%% 					put(?DIC_USERS_RELATION,RNewRelationL),
%% %% 					{ok,PlayerStatus};
%% 					ok;
				{ok,RPidSend,RBin} ->
					lib_send:send_to_sid(RPidSend,RBin),
					ok;
				{false,Msg} ->
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg]),
					ok;
				_Error ->
					?WARNING_MSG("pp_friend PP_FRIEND_ACCEPT is error: ~p ~n",[_Error])
					%{ok,MsgBin} = pt_18:write(?PP_FRIEND_SYS_MSG,[Msg]),
					%lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,MsgBin)
			end;
		_ ->
			case lib_player:get_online_info(FriendID) of
				[] ->
					skip;
				UserInfo ->
					lib_chat:chat_sysmsg_pid([UserInfo#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,?_LANG_FRIEND_ADD_REFUSE])
  			end,
			ok
	end;


%%从关系中删除   
handle(?PP_FRIEND_DELETE,PlayerStatus,[FriendID,RelationQuery]) ->
	RelationL = lib_friend:get_relation_dic(),
    case lib_friend:remove_relation(RelationL,FriendID,PlayerStatus#ets_users.other_data#user_other.pid_send,
									RelationQuery) of
%% 		{ok,RPidSend,RBin,RNewRelationL} ->
%% 			lib_send:send_to_sid(RPidSend,RBin),
%% 			put(?DIC_USERS_RELATION,RNewRelationL),
%% %% 			{ok,PlayerStatus};
%% 			ok;
		{ok,RPidSend,RBin} ->
			lib_send:send_to_sid(RPidSend,RBin),
			ok;
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg]),
			ok;
		_Error ->
			?WARNING_MSG("pp_friend PP_FRIEND_DELETE is error: ~p ~n",[_Error])
	end;


%%好友分组更新   
handle(?PP_FRIEND_GROUP_UPDATE,PlayerStatus,[GroupID,GroupName]) ->
	GroupL = lib_friend:get_relation_group_dic(),
	case lib_friend:group_update(PlayerStatus#ets_users.id,GroupID,GroupName,GroupL) of
%% 		{ok,RGroupBin,RNewGroupL} ->
		{ok, RGroupBin} ->
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,RGroupBin),
%% 			put(?DIC_USERS_RELATION_GROUP,RNewGroupL),
%% 			{ok,PlayerStatus};
			ok;
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg]),
			ok;
		_Error ->
			?WARNING_MSG("pp_friend PP_FRIEND_GROUP_UPDATE is error: ~p ~n",[_Error])
			%{ok,MsgBin} = pt_18:write(?PP_FRIEND_SYS_MSG,[Msg]),
			%lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,MsgBin)
	end;
			
			
 %%删除好友分组    
handle(?PP_FRIEND_GROUP_DELETE,PlayerStatus,[GroupID]) ->
	GroupL = lib_friend:get_relation_group_dic(),
	case lib_friend:group_delete(GroupID, GroupL) of
%% 		{ok,RGroupBin,RNewGroupL} ->
		{ok, RGroupBin} ->
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,RGroupBin),
%% 			put(?DIC_USERS_RELATION_GROUP,RNewGroupL),
%% 			{ok,PlayerStatus};
			ok;
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg]),
			ok;
		_Error ->
			?WARNING_MSG("pp_friend PP_FRIEND_GROUP_DELETE is error: ~p ~n",[_Error])
			%{ok,MsgBin} = pt_18:write(?PP_FRIEND_SYS_MSG,[Msg]),
			%lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,MsgBin)
	end;
	
%%好友分组移动     
handle(?PP_FRIEND_GROUP_MOVE,PlayerStatus,[FromGId,ToGId,FriendId]) ->
	RelationL = lib_friend:get_relation_dic(),
	GroupL = lib_friend:get_relation_group_dic(),
	case lib_friend:group_friend_move(PlayerStatus#ets_users.id,FromGId,ToGId,FriendId,RelationL,GroupL) of
%% 		{ok,RGroupBin,RNewRelationL} ->
		{ok, RGroupBin} ->
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,RGroupBin),
%% 			put(?DIC_USERS_RELATION,RNewRelationL),
%% 			{ok,PlayerStatus};
			ok;
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?EVENT,?None,?RED,Msg]),
			ok;
		_Error ->
			?WARNING_MSG("pp_friend PP_FRIEND_GROUP_MOVE is error: ~p ~n",[_Error])
	end;
				   	

%%好友搜索      
handle(?PP_QUERY_FRIEND_INFO,PlayerStatus,[Nick]) ->
	case lib_player:get_role_id_by_name(Nick) of
				null ->                                   %%角色不存在
					{ok,FriendMessage} = pt_18:write(?PP_QUERY_FRIEND_INFO,[0,"",""]);
				Id -> 
					case lib_player:get_online_info(Id) of
						[] ->                             %%玩家不在线
							{ok,FriendMessage} = pt_18:write(?PP_QUERY_FRIEND_INFO,[0,Nick,Nick]);
						FriendInfo -> 
							{ok,FriendMessage} = pt_18:write(?PP_QUERY_FRIEND_INFO,[1,Id,FriendInfo])
					end
	end,
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, FriendMessage),
	ok;

%% 查询用户信息, todo 改为cast
handle(?PP_QUERY_USER_INFO,PlayerStatus,[TargetUserId]) ->
	%%todo 需要优化，判断有问题。可以改为cast
 	case lib_player:get_player_info_by_id(TargetUserId) of
 		{false} ->
			skip;
 		TUser ->
			TEquipList =
				case erlang:is_pid(TUser#ets_users.other_data#user_other.pid_item) of
					true ->
						gen_server:call(TUser#ets_users.other_data#user_other.pid_item,{'get_equip_list'});
					_ ->
						item_util:get_offline_equip_list(TargetUserId)
				end,
			{ok, BinData} = pt_18:write(?PP_QUERY_USER_INFO, [TargetUserId, TUser, TEquipList]),
		 	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData)
 	end,
	ok;

%% 查询用户经脉信息
handle(?PP_QUERY_USER_VEINS,PlayerStatus,[TargetUserId]) ->
		case lib_player:get_player_info_by_id(TargetUserId) of
			{false} ->
				ok;
			TUser ->
				{ok, BinData} = pt_18:write(?PP_QUERY_USER_VEINS, [TargetUserId, TUser#ets_users.other_data#user_other.veins_list]),
				lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData)
		end,
	ok;

handle(Cmd, _, _) ->
	?WARNING_MSG("pp_item cmd is not : ~w",[Cmd]),
	ok.

%%
%% Local Functions
%%

