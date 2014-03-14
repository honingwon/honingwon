%%%-------------------------------------------------------------------
%%% Module  : lib_friend
%%% Author	: 黄文龙 
%%% Edit 	: 冯伟平
%%% Created	: 2011-3-11
%%% Description: TODO: Add description to lib_friend
%%%-------------------------------------------------------------------
-module(lib_friend).


%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(MAX_LEVEL,6).   %% 好友度最高等级

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([init_friend/1,

		 insert_ets_friend/1,
		 delete_friend_ets/2,
		 delete_group_ets/1,
		 get_friend_num/1,
		 update_ets_friend/1,

		 is_friend_exists/3,
		 get_ets_list/2,
		 get_user_all_groups/1,
		 get_user_all_friends/1,
		 delete_offline_friend_ets/1,
		 is_same_group_name/2,
		 insert_ets_group/1,
		 load_friend_group_info/1,
		 
		 add_relation/12,
		 add_relation_friend_response/10,
		 remove_relation/4,
		 group_update/4,
		 group_delete/2,
		 group_friend_move/6,
		 
		 send_friend_state/3,
		 get_relation_info/2,
		 
		 set_relation_online/2,
		 get_friend_info/1,
		 get_friend_list/2,
		 
		 get_relation_dic/0,
		 update_relation_dic/1,
		 delete_relation_dic/1,
		 get_relation_group_dic/0,
		 update_relation_group_dic/1,
		 delete_relation_group_dic/1,
		 
		 
		 init_template_amity/0, 
		 get_level_by_amity/1,
		 get_amity_by_level/1,
		 add_amity/5,
		 add_friend_amity/7
		]).

%%====================================================================
%% External functions
%%====================================================================

%% 初始化玩家好友
init_friend(UserId) ->
	load_relation_info(UserId),
	load_friend_group_info(UserId).


load_relation_info(UserId) ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_users_friends] ++ Info),
				NewRecord = get_friend_other(Record),
				update_relation_dic(NewRecord)
		end,
	L = db_agent_friend:get_friends_by_id(UserId),
	lists:foreach(F,L).

% 取得其他信息
get_friend_other(FriendInfo) ->
	[NickName, Sex, Level, _State, Career] = db_agent_user:get_user_info_by_UserId(FriendInfo#ets_users_friends.friend_id),
	State = case lib_player:is_online(FriendInfo#ets_users_friends.friend_id) of
				true -> 1;
				_ -> 0
			end,
	Other = #other_friend{
						  nick_name=NickName, 
						  sex=Sex, 
						  career = Career,
						  level=Level,
						  state=State},	
	FriendInfo#ets_users_friends{other_data=Other}.

load_friend_group_info(UserID) ->
	F = fun(Info) ->
				update_relation_group_dic(list_to_tuple([ets_users_groups] ++ Info))
		end,
	lists:foreach(F, db_agent_friend:get_groupall_by_id(UserID)).
%% 	F = fun(Info,L) ->
%% 				Record = list_to_tuple([ets_users_groups] ++ Info),
%% 				[Record|L]
%% 		end,
%% 	case db_agent_friend:get_groupall_by_id(UserID) of
%% 		[] ->
%% 			[];
%% 		List ->
%% 			lists:foldl(F,[],List)
%% 	end.

% 判断关系是否存在
is_relation_exists(FriendID,FriendQuery,RelationL) ->
	if FriendQuery =:= ?RELATION_FRIEND_QUERY ->
		   CheckFriendQuery = ?RELATION_FRIEND;
	   true ->
		   CheckFriendQuery = FriendQuery
	end,
	is_relation_exists1(RelationL,FriendID,CheckFriendQuery).

is_relation_exists1(RelationL,FriendID,FriendQuery) ->
	case lists:keyfind(FriendID,#ets_users_friends.friend_id,RelationL) of
		false ->
			{false,[]};
		RelationInfo ->
			if RelationInfo#ets_users_friends.state band FriendQuery =/= 0 ->
				  {true, RelationInfo};	%已存在对应关系,不需要再处理
			  true ->
				  {false, RelationInfo}	%关系记录存在，没对应关系 
		   end
	end.

get_relation_info(DicL,FriendID) ->
	case lists:keyfind(FriendID, #ets_users_friends.friend_id, DicL) of
		false ->
			[];
		FriendInfo ->
			FriendInfo
	end.

get_group_info(DicL,GroupID) ->
	case lists:keyfind(GroupID, #ets_users_groups.id, DicL) of
		false ->
			[];
		GroupInfo ->
			GroupInfo
	end.

	
%获取好友列表
get_friend_list([],L) -> L;
get_friend_list([RelationInfo|T],L) ->
	if RelationInfo#ets_users_friends.state band ?RELATION_FRIEND =/= 0 ->
		   NL = [RelationInfo|L];
	   true ->
		   NL = L
	end,
	get_friend_list(T,NL).

set_relation_online(FriendID,Online) ->
	case lists:keyfind(FriendID, #ets_users_friends.friend_id, get_relation_dic()) of
		false ->
			{false};
		FriendInfo ->
			Other_Data = FriendInfo#ets_users_friends.other_data#other_friend{state=Online},
			update_relation_dic(FriendInfo#ets_users_friends{other_data=Other_Data}),
			FMSG =
			if FriendInfo#ets_users_friends.state band ?RELATION_FRIEND =/= 0 ->
				   case Online of
						1 ->
							?GET_TRAN(?_LANG_FRIEND_ONLINE,[?_LANG_FRIEND_FRIEND,
															FriendInfo#ets_users_friends.other_data#other_friend.nick_name]);
						_ ->
							?GET_TRAN(?_LANG_FRIEND_OFFLINE,[?_LANG_FRIEND_FRIEND,
															 FriendInfo#ets_users_friends.other_data#other_friend.nick_name])
					end;
			   true ->
				   []
			end,
			EMSG =
			if FriendInfo#ets_users_friends.state band ?RELATION_ENEMY =/= 0 ->
				   case Online of
						1 ->
							?GET_TRAN(?_LANG_FRIEND_ONLINE,[?_LANG_FRIEND_ENEMY,
															FriendInfo#ets_users_friends.other_data#other_friend.nick_name]);
						_ ->
							?GET_TRAN(?_LANG_FRIEND_OFFLINE,[?_LANG_FRIEND_ENEMY,
															 FriendInfo#ets_users_friends.other_data#other_friend.nick_name])
					end;
			   true ->
				   []
			end,
			{ok,FMSG,EMSG}
	end.


%用户关系已存在，返回对应的错误提示
add_relation_exists_error(FriendQuery) ->
	if FriendQuery band ?RELATION_FRIEND_QUERY =/= 0 ->
		   ?_LANG_FRIEND_ERROR_FRIEND_EXISTS;   
	   FriendQuery band ?RELATION_FRIEND =/= 0 ->
		   ?_LANG_FRIEND_ERROR_FRIEND_EXISTS;
	   FriendQuery band ?RELATION_BLACK =/= 0 ->
		   ?_LANG_FRIEND_ERROR_BLACK_EXISTS;
	   FriendQuery band ?RELATION_ENEMY =/= 0 ->
		   ?_LANG_FRIEND_ERROR_ENEMY_EXISTS;
	   true ->
		   []
	end.

%更新用户关系,
%FriendQuery是相应的关系请求，RelationL是用户关系进程字典的值
%返回值{ok,UserPidSend,Bin,NewRelationL}/{ok,UserPidSend,Bin}. 或 {false,msg}
add_relation(UserID,UserNick,UserPidSend,UserPidTarget,
			 FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
			 FriendQuery,
			 RelationL) ->
	case is_relation_exists(FriendID,FriendQuery,RelationL) of
		{true,_RelationInfo} ->
			{false,add_relation_exists_error(FriendQuery)};
		{false,[]} ->
			add_relation1(UserID,UserNick,UserPidSend,UserPidTarget,
						  FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
						  0,FriendQuery,
						  RelationL);
		{false,RelationInfo} ->
			add_relation1(UserID,UserNick,UserPidSend,UserPidTarget,
						  FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
						  RelationInfo#ets_users_friends.state,FriendQuery,
						  RelationL)
	end.

%根据不同的请求，进入不同的关系处理流程
add_relation1(UserID,UserNick,UserPidSend,UserPidTarget,
			  FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
			  OldFriendState,FriendQuery,
			  RelationL) ->
	if FriendQuery band ?RELATION_FRIEND_QUERY =/= 0 ->
		   add_relation_friend_request(UserID,UserNick,FriendID);	%好友请求
	   FriendQuery band ?RELATION_FRIEND =/= 0 ->
		   add_relation_friend(UserID,UserPidSend,UserPidTarget,
							   FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
							   OldFriendState,FriendQuery,
							   RelationL);		%添加好友（请求通过后）
	   FriendQuery band ?RELATION_BLACK =/= 0 ->
		   add_relation_black(UserID,UserPidSend,
							  FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
							  OldFriendState,FriendQuery,
							  RelationL);		%添加黑名单
	   FriendQuery band ?RELATION_ENEMY =/= 0 ->
		   add_relation_enemy(UserID,UserPidSend,
							  FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
							  OldFriendState,FriendQuery,
							  RelationL);		%添加仇人
	   true ->
		   skip
	end. 

%添加好友的请求，发给对方
add_relation_friend_request(UserID,UserNick,FriendID) ->
	case lib_player:get_online_info(FriendID) of
		[] ->
			{false,?_LANG_FRIEND_NOT_ONLINE};
		FriendInfo ->
			 {ok, BinData} = pt_18:write(?PP_FRIEND_RESPONSE,[FriendID,UserID,UserNick]), 
			 {ok, FriendInfo#ets_users.other_data#user_other.pid_send,BinData}
	end.


%% 好友请求处理 - 同意好友请求 RequestUser 是被请求者，User是请求者
add_relation_friend_response(RequestUserID,RequestUserNick,RequestUserSex,
							 RequestUserLevel,RequestUserState,RequestUserCareer,
							 RequestPidSend,
							 RequestRelationL,
							 RequestPidTarget,
							 UserID) ->
	case lib_player:get_online_info(UserID) of
		[] ->
			{false,?_LANG_FRIEND_NOT_ONLINE};
		UserInfo ->
			RCU = get_relation_num(RequestUserID,?RELATION_FRIEND),
			CU = get_relation_num(UserID,?RELATION_FRIEND),
			if RCU =< ?RELATION_FRIENDS_MAX andalso
		   		CU =< ?RELATION_FRIENDS_MAX ->
				   %请求者的关系添加直接扔回请求者进程处理
				   gen_server:cast(UserInfo#ets_users.other_data#user_other.pid,{add_relation_friend,
																				 RequestUserID,RequestUserNick,
																				 RequestUserSex,RequestUserLevel,
																				 RequestUserState,RequestUserCareer}),
				   add_relation(RequestUserID,RequestUserNick,RequestPidSend,RequestPidTarget,
								UserInfo#ets_users.id,UserInfo#ets_users.nick_name,
								UserInfo#ets_users.sex,UserInfo#ets_users.level,
								UserInfo#ets_users.state,UserInfo#ets_users.career,
								?RELATION_FRIEND,RequestRelationL);
	   			true ->
					%直接通知请求者人数已满
					lib_chat:chat_sysmsg_pid([RequestPidSend, 
												  ?EVENT,?None,?RED,?_LANG_FRIEND_ADD_FULL]),
   					{false, ?_LANG_FRIEND_ADD_FULL}
			end
	end.

%添加好友
add_relation_friend(UserID,UserPidSend,UserPidTarget,
					FriendID,FriendNick,FriendSex,FriendLevel,_FriendOnline,FriendCareer,
					OldFriendState,FriendQuery,
					RelationL) ->
	case OldFriendState band ?RELATION_BLACK =/= 0 of
		true -> %是黑名单关系，需要取消黑名单
			TmpFriendState = OldFriendState band ?RELATION_BLACK_CANCEL;
		false ->
			TmpFriendState = OldFriendState
	end,
	lib_chat:chat_sysmsg([FriendID, ?EVENT,?None,?RED,?_LANG_FRIEND_ADD_SUCCESS]),
	RCU = get_relation_num(UserID,?RELATION_FRIEND),
	
	lib_target:cast_check_target(UserPidTarget ,[{?TARGET_ADD_FRIENDS,{0,RCU+1}}]),
	
	add_relation_final(UserID,UserPidSend,
					   FriendID,FriendNick,FriendSex,FriendLevel,1,FriendCareer,
					   TmpFriendState,FriendQuery,RelationL).
	
%添加黑名单
add_relation_black(UserID,UserPidSend,
				   FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
				   OldFriendState,FriendQuery,
				   RelationL) ->
	CN = get_relation_num(UserID,?RELATION_BLACK),
	if CN =< ?RELATION_BLACKS_MAX ->
		   case OldFriendState band ?RELATION_FRIEND =/= 0 of
			   true -> %是好友关系，需要取消好友
				   TmpFriendState = OldFriendState band ?RELATION_FRIEND_CANCEL;
			   false ->
				   TmpFriendState = OldFriendState
		   end,
		   add_relation_final(UserID,UserPidSend,
							  FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
							  TmpFriendState,FriendQuery,RelationL);
	   true ->
		   {false, ?_LANG_FRIEND_BLACK_ADD_FULL}
	end.

%添加仇人
add_relation_enemy(UserID,UserPidSend,
				   FriendID,FriendNick,FriendSex,FriendLevel,_FriendOnline,FriendCareer,
				   OldFriendState,FriendQuery,
				   RelationL) ->
	CN = get_relation_num(UserID, ?RELATION_ENEMY),
	if CN =< ?RELATION_ENEMYS_MAX ->	%未满，可直接处理
		   add_relation_final(UserID,UserPidSend,
							  FriendID,FriendNick,FriendSex,FriendLevel,1,FriendCareer,
							  OldFriendState,FriendQuery,RelationL);
	   true ->	%替换
		   NewRelationL = remove_relation_enemy_last_one(RelationL,RelationL,1,UserPidSend),
		   add_relation_final(UserID,UserPidSend,
							  FriendID,FriendNick,FriendSex,FriendLevel,1,FriendCareer,
							  OldFriendState,FriendQuery,NewRelationL)
	end.
		   

%% 最终操作
add_relation_final(UserID,UserPidSend,
				   FriendID,FriendNick,FriendSex,FriendLevel,FriendOnline,FriendCareer,
				   TmpFriendState,FriendQuery,RelationL) ->
	NewFriendState = TmpFriendState bor FriendQuery,	%修改state
	Other_data = #other_friend{
							   nick_name = FriendNick,
							   sex = FriendSex,
							   career = FriendCareer,
							   level = FriendLevel,
							   state = FriendOnline
							   },
	FriendInfo = #ets_users_friends{
									user_id = UserID,
									friend_id = FriendID,
									group_id = 0,
									amity = 0,
									date = misc_timer:now_seconds(),
									state = NewFriendState,
									other_data = Other_data
									},
	Amity = case lists:keyfind(FriendID,#ets_users_friends.friend_id,RelationL) of
		false ->
			db_agent_friend:add_friend(FriendInfo),
			update_relation_dic(FriendInfo),
			0;
			%%NewRelationL = [FriendInfo|RelationL];
		_ ->
			db_agent_friend:update_friend(FriendInfo),
			update_relation_dic(FriendInfo),
			db_agent_friend:get_amity_by_id(UserID,FriendID)
			%%NewRelationL = lists:keyreplace(FriendID,#ets_users_friends.friend_id,RelationL,FriendInfo)
	end,
	{ok,Bin} = pt_18:write(?PP_FRIEND_UPDATE, [FriendID,
											   FriendNick,
											   FriendSex,
											   FriendLevel,
											   FriendOnline,
											   NewFriendState, 
											   FriendCareer,
											   Amity
											   ]),
	%%{ok,UserPidSend,Bin,NewRelationL}.
	{ok, UserPidSend, Bin}.

notice_relation_update(PidSend,RelationInfo) -> %部分内部处理需要提前在此发信息通知前端更新
	{ok,Bin} = pt_18:write(?PP_FRIEND_UPDATE, [RelationInfo#ets_users_friends.friend_id,
											   RelationInfo#ets_users_friends.other_data#other_friend.nick_name,
											   RelationInfo#ets_users_friends.other_data#other_friend.sex,
											   RelationInfo#ets_users_friends.other_data#other_friend.level,
											   RelationInfo#ets_users_friends.state,
											   RelationInfo#ets_users_friends.state,
											   RelationInfo#ets_users_friends.other_data#other_friend.career,
											   RelationInfo#ets_users_friends.amity
											   ]),
	lib_send:send_to_sid(PidSend,Bin).

%删除第一个仇人信息,返回新list
remove_relation_enemy_last_one([],RelationL,_Place,_PidSend) -> RelationL;
remove_relation_enemy_last_one(CheckRelationL,RelationL,Place,PidSend) ->
	[RelationInfo|T] = CheckRelationL,
	if RelationInfo#ets_users_friends.state band ?RELATION_ENEMY =/= 0 ->
		   NewState = RelationInfo#ets_users_friends.state band ?RELATION_ENEMY_CANCEL,
		   NewRelationInfo = RelationInfo#ets_users_friends{state=NewState},
		   notice_relation_update(PidSend,NewRelationInfo),
		   if NewState =:= 0 -> %空了
				  ListT = lists:nthtail(Place,RelationL),
				  case Place of
					  1 ->
						  ListT;
					  _ ->
				  		ListH = lists:sublist(RelationL, Place -1),
				  		ListH ++ ListT
				  end;
			  true ->
				  ListH = lists:sublist(RelationL, Place -1),
				  ListT = lists:nthtail(Place,RelationL),
				  NListH = [NewRelationInfo|ListH],
				  NListH ++ ListT
		   end;
	   true ->
		   remove_relation_enemy_last_one(T,RelationL,Place+1,PidSend)
	end.

%根据请求条件，删除指定人物的对应信息
remove_relation(RelationL,FriendID,PidSend,RelationQuery) ->
	case RelationQuery of
		?RELATION_FRIEND ->
			RelationCancel = ?RELATION_FRIEND_CANCEL;
		?RELATION_BLACK ->
			RelationCancel = ?RELATION_BLACK_CANCEL;
%% 		?RELATION_ENEMY ->
		_ -> %% 默认设置一个
			RelationCancel = ?RELATION_ENEMY_CANCEL
	end,
	remove_relation1(RelationL,FriendID,PidSend,RelationQuery,RelationCancel).

remove_relation_error(RelationQuery) -> 
	case RelationQuery of
		?RELATION_FRIEND ->
			{false,?_LANG_FRIEND_ERROR_FRIEND_NOT_EXISTS};
		?RELATION_BLACK ->
			{false,?_LANG_FRIEND_ERROR_BLACK_NOT_EXISTS};
%% 		?RELATION_ENEMY ->
		_ ->
			{false,?_LANG_FRIEND_ERROR_ENEMY_NOT_EXISTS}
	end.

remove_relation1(RelationL,FriendID,PidSend,RelationQuery,RelationCancel) ->
	case lists:keyfind(FriendID,#ets_users_friends.friend_id,RelationL) of
		false ->
			remove_relation_error(RelationQuery);
		FriendInfo ->
			remove_relation2(RelationL,FriendInfo,PidSend,RelationQuery,RelationCancel)
	end.

remove_relation2(_RelationL,FriendInfo,PidSend,RelationQuery,RelationCancel) ->
	if FriendInfo#ets_users_friends.state band RelationQuery =/= 0 ->
		   NewState = FriendInfo#ets_users_friends.state band RelationCancel,
		   NewFriendInfo = FriendInfo#ets_users_friends{state = NewState},
		   if NewState =:= 0 ->
				  db_agent_friend:delete_friend(FriendInfo#ets_users_friends.user_id,
												FriendInfo#ets_users_friends.friend_id),
				  delete_relation_dic(FriendInfo#ets_users_friends.friend_id);
%% 				  NewL = lists:keydelete(FriendInfo#ets_users_friends.friend_id, 
%% 										 #ets_users_friends.friend_id, 
%% 										 RelationL);
			  true ->
				  db_agent_friend:update_friend(NewFriendInfo),
				  update_relation_dic(NewFriendInfo)
%% 				  NewL = lists:keyreplace(FriendInfo#ets_users_friends.friend_id, 
%% 										  #ets_users_friends.friend_id, 
%% 										  RelationL,
%% 										  NewFriendInfo)
		   end,
		   {ok,Bin} = pt_18:write(?PP_FRIEND_UPDATE, [NewFriendInfo#ets_users_friends.friend_id,
													  NewFriendInfo#ets_users_friends.other_data#other_friend.nick_name,
													  NewFriendInfo#ets_users_friends.other_data#other_friend.sex,
													  NewFriendInfo#ets_users_friends.other_data#other_friend.level,
													  NewFriendInfo#ets_users_friends.state,
													  NewFriendInfo#ets_users_friends.state,
													  NewFriendInfo#ets_users_friends.other_data#other_friend.career,
													  NewFriendInfo#ets_users_friends.amity
													  ]),
%% 		   {ok,PidSend,Bin,NewL};
	   	   {ok,PidSend,Bin};
	   true ->
		   remove_relation_error(RelationQuery)
	end.

			
%%获取对应关系的记录数量
get_relation_num(UserID,RelationQuery) ->
	MS = ets:fun2ms(fun(T) when T#ets_users_friends.user_id =:= UserID -> T#ets_users_friends.state end),
	case ets:select(?ETS_USERS_FRIENDS,MS) of
		[] -> 0;
		L ->
			get_relation_num1(L,RelationQuery,0)
	end.

get_relation_num1([],_RelationQuery,Num) -> Num;
get_relation_num1([H|T],RelationQuery,Num) ->
	if H band RelationQuery =/= 0 ->
		 NewNum = Num + 1;
	   true ->
		   NewNum =Num
	end,
	get_relation_num1(T,RelationQuery,NewNum).


group_update(UserID,GroupID,GroupName,GroupL) ->
	if GroupID =:= 0 -> %新增
		   if length(GroupL) < ?GROUPS_LIMIT_NUM ->
				  db_agent_friend:add_group(UserID,GroupName),
				  Group=db_agent_friend:get_group_info(UserID,GroupName),
				  GroupInfo=list_to_tuple([ets_users_groups] ++ Group),
%% 				  NewGroupL = [GroupInfo|GroupL],
				  update_relation_group_dic(GroupInfo),
				  pt_18:write(?PP_FRIEND_GROUP_UPDATE, [GroupInfo#ets_users_groups.id,GroupName,1]);
%% 				  {ok, GroupBin} = pt_18:write(?PP_FRIEND_GROUP_UPDATE, [GroupInfo#ets_users_groups.id,
%% 																		 GroupName,1]),
%% 				  {ok,GroupBin,NewGroupL};
			  true ->
				  {false, ?_LANG_FRIEND_GROUP_NUM_LIMIT}
		   end;
	   true ->
		   case get_group_info(GroupL,GroupID) of
			   [] ->
				   {false, ?_LANG_FRIEND_GROUP_NOT_EXIST};
			   GroupInfo ->
				   db_agent_friend:update_group(GroupInfo#ets_users_groups.id,GroupName),
				   NewGroupInfo = GroupInfo#ets_users_groups{name = GroupName},
%% 				   NewGroupL = lists:keyreplace(GroupID, #ets_users_groups.id, GroupL, NewGroupInfo),
				   update_relation_group_dic(NewGroupInfo),
				   pt_18:write(?PP_FRIEND_GROUP_UPDATE, [NewGroupInfo#ets_users_groups.id,GroupName,1])
%% 				   {ok, GroupBin} = pt_18:write(?PP_FRIEND_GROUP_UPDATE, [NewGroupInfo#ets_users_groups.id,
%% 																		   GroupName,1]),
%% 				   {ok,GroupBin,NewGroupL}
		   end
	end.

%%删除分组 - 有用户不允许删除
group_delete(GroupID,GroupL)->
	case get_group_info(GroupL,GroupID) of
		[] ->
			{false, ?_LANG_FRIEND_GROUP_NOT_EXIST};
		_GroupInfo ->
			db_agent_friend:delete_group_friend(GroupID),
%% 			NewGroupL = lists:keydelete(GroupID, #ets_users_groups.id, GroupL),
			delete_relation_group_dic(GroupID),
			pt_18:write(?PP_FRIEND_GROUP_DELETE, [GroupID])
%% 			{ok, GroupBin} = pt_18:write(?PP_FRIEND_GROUP_DELETE, [GroupID]),
%% 			{ok,GroupBin,NewGroupL}
	end.
	
%% 移动用户分组
group_friend_move(UserID,FromGroupID,ToGroupID,FriendID,RelationL,GroupL) ->
		case ToGroupID of
		0 ->
			group_friend_move_a(UserID,FromGroupID,ToGroupID,FriendID,RelationL);
		_ ->
			group_friend_move_b(UserID,FromGroupID,ToGroupID,FriendID,RelationL,GroupL)
	end.

group_friend_move_a(UserID,FromGroupID,ToGroupID,FriendID,RelationL) ->
	case get_relation_info(RelationL,FriendID) of
		[] ->
			{false, ?_LANG_FRIEND_ERROR_FRIEND_NOT_EXISTS};
		FriendInfo ->
			db_agent_friend:group_move(UserID,FromGroupID,ToGroupID,FriendID),
 			NewFriendInfo = FriendInfo#ets_users_friends{group_id = ToGroupID},
%% 			NL = lists:keyreplace(FriendID, #ets_users_friends.friend_id, RelationL, NewFriendInfo),
			update_relation_dic(NewFriendInfo),
			pt_18:write(?PP_FRIEND_GROUP_MOVE,[FromGroupID,ToGroupID,FriendID])
%% 			{ok,GroupBin}= pt_18:write(?PP_FRIEND_GROUP_MOVE,[FromGroupID,ToGroupID,FriendID]),
%% 			{ok,GroupBin,NL}
	end.

group_friend_move_b(UserID,FromGroupID,ToGroupID,FriendID,RelationL,GroupL) ->
	case get_group_info(GroupL,ToGroupID) of 
		[] ->
			{false,?_LANG_FRIEND_GROUP_NOT_EXIST};
		_ ->
			case get_relation_info(RelationL,FriendID) of
				[] ->
					{false, ?_LANG_FRIEND_ERROR_FRIEND_NOT_EXISTS};
				FriendInfo ->
					db_agent_friend:group_move(UserID,FromGroupID,ToGroupID,FriendID),
					NewFriendInfo = FriendInfo#ets_users_friends{group_id = ToGroupID},
%% 					NL = lists:keyreplace(FriendID, #ets_users_friends.friend_id, RelationL, NewFriendInfo),
					update_relation_dic(NewFriendInfo),
					pt_18:write(?PP_FRIEND_GROUP_MOVE,[FromGroupID,ToGroupID,FriendID])
%% 					{ok,GroupBin}= pt_18:write(?PP_FRIEND_GROUP_MOVE,[FromGroupID,ToGroupID,FriendID]),
%% 					{ok,GroupBin,NL}
			end
	end.

%%发送好友状态
send_friend_state(UserId,NickName,State) ->
	{ok,FriendBin} = pt_18:write(?PP_FRIEND_ONLINE_STATE,[UserId,State]),
	lib_send:send_to_relation_online_all(UserId,NickName,State,FriendBin).

%%获取关系记录
get_friend_info(FriendID) ->
	case get_relation_info(get_relation_dic(),FriendID) of
		[] ->
			[];
		FriendInfo ->
			[FriendInfo]
	end.


%%	----------------------------dic 辅助方法-----------------------
get_relation_dic() ->
	case get(?DIC_USERS_RELATION) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

update_dic(List) ->
	put(?DIC_USERS_RELATION, List).

update_relation_dic(Info) ->
	case  is_record(Info, ets_users_friends) of
		true ->
			List = get_relation_dic(),
			List1 = lists:keydelete(Info#ets_users_friends.friend_id, #ets_users_friends.friend_id, List),
			update_dic([Info|List1]);
		_ ->
			skip
	end,
	ok.

delete_relation_dic(Id) ->
	List = get_relation_dic(),
	List1 = lists:keydelete(Id, #ets_users_friends.friend_id, List),
	update_dic(List1),
	ok.

get_relation_group_dic() ->
		case get(?DIC_USERS_RELATION_GROUP) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

update_relation_group_dic(Info) ->
	case  is_record(Info, ets_users_groups) of
		true ->
			List = get_relation_group_dic(),
			List1 = lists:keydelete(Info#ets_users_groups.id, #ets_users_groups.id, List),
			put(?DIC_USERS_RELATION_GROUP, [Info|List1]);
		_ ->
			skip
	end,
	ok.

delete_relation_group_dic(Id) ->
	List = get_relation_group_dic(),
	List1 = lists:keydelete(Id, #ets_users_groups.id, List),
	put(?DIC_USERS_RELATION_GROUP, List1),
	ok.

%===================================================================================================================


%%获取玩家的好友数目
get_friend_num(UserId) ->
	length(ets:match(?ETS_USERS_FRIENDS,#ets_users_friends{user_id=UserId,friend_id='$1',_='_'})).

%% %%获取玩家的好友分组数目
%% get_group_num(UserId) ->
%% 	length(ets:match(?ETS_USERS_GROUPS,#ets_users_groups{id='$1',user_id=UserId,_='_'})).

%%获取相应列表
get_ets_list(Tab, Pattern) ->
    L = ets:match_object(Tab, Pattern),
    case is_list(L) of
		true -> L;
        false -> []
    end.

%%获取玩家所有好友
get_user_all_friends(UserId) ->
	Pattern = #ets_users_friends{user_id=UserId, _='_' },
	get_ets_list(?ETS_USERS_FRIENDS, Pattern).

%%获取玩家所有好友分组 
get_user_all_groups(UserId) ->
	Pattern=#ets_users_groups{_='_',user_id=UserId,_='_'},
	get_ets_list(?ETS_USERS_GROUPS,Pattern).


 

%% 插入好友ETS
insert_ets_friend(FriendInfo) ->	
	ets:insert(?ETS_USERS_FRIENDS, FriendInfo),
	FriendInfo.

%% 插入好友分组ETS
insert_ets_group(GId) ->	
	Group=db_agent_friend:get_grouprow_by_id(GId),
	GroupInfo=list_to_tuple([ets_users_groups] ++ Group),
	ets:insert(?ETS_USERS_GROUPS,GroupInfo).


%%判断好友是否存在
is_friend_exists(UserId, FriendId,State) ->
	case ets:match(?ETS_USERS_FRIENDS, #ets_users_friends{user_id=UserId, friend_id=FriendId,state=State,_='_'}) of
		[] ->
			false;
		_ ->
			true
	end.

%%分组是否存在 
is_same_group_name(UserId,Gname)->
%% 	?PRINT("Gname=~w~n",[Gname]),
	Gname1=list_to_binary(Gname),
%% 		?PRINT("Gname2=~w~n",[Gname1]),
%% 		?PRINT("Gname3=~w~n",[?_LANG_FRIEND_STRANGER]),
	case ets:match(?ETS_USERS_GROUPS, #ets_users_groups{_='_',user_id=UserId,_='_',name=Gname1}) of
		[] ->
			false;
		_ ->
			true
	end.

%%好友ETS删除
delete_friend_ets(Id,FriendId) ->
	db_agent_friend:delete_friend(Id,FriendId),
    ets:match_delete(?ETS_USERS_FRIENDS,#ets_users_friends{user_id=Id,friend_id=FriendId,_='_'}).


%%好友分组ETS删除
delete_group_ets(GId)->
	db_agent_friend:delete_group_friend(GId),
    ets:delete(?ETS_USERS_GROUPS, GId).

%%下线清除好友和分组信息 
delete_offline_friend_ets(UserId) ->
	ets:match_delete(?ETS_USERS_FRIENDS, #ets_users_friends{user_id=UserId, _='_' }),
	ets:match_delete(?ETS_USERS_GROUPS,#ets_users_groups{_='_',user_id=UserId,_='_'}).


%% 更新好友ETS
update_ets_friend(FriendInfo) ->
	ets:match_delete(?ETS_USERS_FRIENDS, 	#ets_users_friends{user_id=FriendInfo#ets_users_friends.user_id,friend_id=FriendInfo#ets_users_friends.friend_id,_='_' }),
	insert_ets_friend(FriendInfo).

%% ======================好友度========================

%%初始化友好度模板
init_template_amity() -> 
	F = fun(Info) ->
		Record = list_to_tuple([ets_amity_template] ++ Info),
		SN = tool:split_string_to_intlist(Record#ets_amity_template.data),
		Other_Amity = #other_amity{},
		Record1  = Record#ets_amity_template{other_data = Other_Amity },
		NewRecord = cale_attach_effect_loop(SN,Other_Amity,Record1),
		
  		ets:insert(?ETS_AMITY_TEMPLATE, NewRecord)
	end,
	L = db_agent_template:get_amity_template(),
	lists:foreach(F, L),
	ok.
%% 友好度计算等级
get_level_by_amity(Amity)->
	List = ets:tab2list(?ETS_AMITY_TEMPLATE),
	F = fun(V1,V2) -> V1#ets_amity_template.level < V2#ets_amity_template.level end,
	LSort = lists:sort(F,List),
	get_level_by_amity1(LSort, Amity).
get_level_by_amity1([], _) ->
	?MAX_LEVEL;
get_level_by_amity1([H|T], Amity) ->
	if 
		H#ets_amity_template.total_amity > Amity ->
			H#ets_amity_template.level -1;
		true ->
			get_level_by_amity1(T, Amity)
	end.

%% 根据好友度等级获取好友度信息
get_amity_by_level(Level) ->
	data_agent:get_amity_by_level(Level).

%% 增加好友度
add_amity(UserPidSend,UserId,UserNick,FriendId,Amity) ->
	case lib_player:get_online_info(FriendId) of
		[] ->
			{false};
		FriendInfo ->
			List = get_relation_dic(),
			case is_relation_exists(FriendId,?RELATION_FRIEND,List) of
				{true,_RelationInfo} -> %% 是好友添加好友度
					gen_server:cast(FriendInfo#ets_users.other_data#user_other.pid,{add_friend_amity,
																				 	UserId,
																					UserNick,
																					Amity
																					}),
					add_friend_amity(UserPidSend,UserId,UserNick,FriendId,FriendInfo#ets_users.nick_name,Amity,List);
				_ ->
					{false}
			end
	end.

add_friend_amity(UserPidSend,_UserId,_UserNick,FriendId,_FriendNick,Amity,RelationL) ->
	case lists:keyfind(FriendId,#ets_users_friends.friend_id,RelationL) of
		false ->
			{false};
		FriendInfo ->
			CheckAmity = FriendInfo#ets_users_friends.amity + Amity,
			CheckLevel = get_level_by_amity(CheckAmity),
			NewFriendInfo = FriendInfo#ets_users_friends{ amity = CheckAmity,amity_level = CheckLevel},
			db_agent_friend:update_friend_amity(NewFriendInfo),
			
			{ok,Bin} = pt_18:write(?PP_FRIEND_AMITY_UPDATE, [FriendId,CheckAmity]),
			lib_send:send_to_sid(UserPidSend,Bin),
			update_relation_dic(NewFriendInfo),
			{ok}
	end.


%%====================================================================
%% Local functions
%%====================================================================


cale_attach_effect_loop([], _Other_Amity,Record) ->
    Record;

cale_attach_effect_loop([{K, V} | T],Other_Amity,Record) ->
			case K of
				?ATTACK_PHYSICS ->
					Other = Other_Amity#other_amity{
													attack_physics = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?DEFENCE_PHYSICS -> 
					Other = Other_Amity#other_amity{
													defence_physics = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?HURT_PHYSICS ->
					Other = Other_Amity#other_amity{
													hurt_physics = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTACK_VINDICTIVE ->
					Other = Other_Amity#other_amity{
													attack_vindictive = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);				
				?ATTACK_MAGIC -> 
					Other = Other_Amity#other_amity{
													attack_magic = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_HITTARGET -> 
					Other = Other_Amity#other_amity{
													hit_target = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_DUCK -> 
					Other = Other_Amity#other_amity{
													duck = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_DELIGENCY -> 
					Other = Other_Amity#other_amity{
													deligency = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_POWERHIT -> 
					Other = Other_Amity#other_amity{
													power_hit = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_HP -> 
					Other = Other_Amity#other_amity{
													max_physical = V
												   },
					NewRecord = Record#ets_amity_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				
				_Other ->
					?WARNING_MSG("cale_attach_effect_loop:~w", [_Other]),
					cale_attach_effect_loop(T,Other_Amity,Record)
			end.


