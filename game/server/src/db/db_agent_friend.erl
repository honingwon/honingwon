%%%-------------------------------------------------------------------
%%% Module  : db_agent_friend
%%% Author	: Administrator
%%% Created	: 2011-3-12
%%% Description: TODO: Add description to db_agent_friend
%%%-------------------------------------------------------------------
-module(db_agent_friend).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").


%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([add_friend/1,
		 update_friend/1,
		 update_friend_amity/1,
     	 update_group/2,
		 delete_friend/2,
		 delete_group_friend/1,
		 add_group/2,
		 get_friends_by_id/1,
		 get_group_id/2,
		 group_move/4,
		 update_friend_online/1,
         update_friend_offline/1,
		 is_friend_black/2,
		 get_grouprow_by_id/1,
		 get_groupall_by_id/1,
		 get_group_info/2,
		 get_amity_by_id/2
		 ]).

%%
%% API Functions
%%

%%增加好友记录 
add_friend(FriendInfo) ->
	ValueList = lists:nthtail(1, tuple_to_list(FriendInfo#ets_users_friends{other_data=""})),
    FieldList = record_info(fields, ets_users_friends),
	Ret = ?DB_MODULE:insert(t_users_friends, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
    		Ret;
		true ->
			{mongo, Ret}
	end.


%%添加好友分组 
add_group(UserId,Gname) ->
	Ret = ?DB_MODULE:insert(t_users_groups, [user_id,name,is_exist], [UserId,Gname,1]),

	if ?DB_MODULE =:= db_mysql ->
    		Ret;
		true ->
			{mongo, Ret}
	end.

%%更新好友记录 
update_friend(FriendInfo) ->
	?DB_MODULE:update(t_users_friends,
					          	 [{state,FriendInfo#ets_users_friends.state},{date,FriendInfo#ets_users_friends.date}],
								 [{user_id,FriendInfo#ets_users_friends.user_id},{friend_id,FriendInfo#ets_users_friends.friend_id}]
								 ).

%%更新好友记录 
update_friend_amity(FriendInfo) ->
	?DB_MODULE:update(t_users_friends,
					          	 [{amity,FriendInfo#ets_users_friends.amity},{amity_level,FriendInfo#ets_users_friends.amity_level}],
								 [{user_id,FriendInfo#ets_users_friends.user_id},{friend_id,FriendInfo#ets_users_friends.friend_id}]
								 ).

%% 好友分组改名 
update_group(GId,Gname) ->
	?DB_MODULE:update(t_users_groups,
				          	 [{name,Gname}],
							 [{id,GId}] 
							 ).
%% 更新好友上线状态
update_friend_online(UserId) ->	
	?DB_MODULE:update(t_users, [{state,1}],[{id, UserId}]).

%% 更新好友下线状态 
update_friend_offline(UserId) ->
	?DB_MODULE:update(t_users,[{state,0}],[{id,UserId}]).

%% 删除好友
delete_friend(Id,UserId) ->
	?DB_MODULE:delete(t_users_friends,
								 [{user_id,Id},{friend_id, UserId}]).

delete_group_friend(GId) ->
	?DB_MODULE:delete(t_users_groups,[{id,GId}]).


get_friends_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_friends, "*", [{user_id, UserId}]).

get_amity_by_id(UserId,FriendId) ->
	?DB_MODULE:select_one(t_users_friends, "amity", [{user_id, UserId},{friend_id,FriendId}]).

%% 
get_group_id(UserId,Gname) ->
	?DB_MODULE:select_one(t_users_groups, "id", [{user_id, UserId},{name,Gname}]).

get_group_info(UserId,Gname) ->
	?DB_MODULE:select_row(t_users_groups, "*", [{user_id, UserId},{name,Gname}]).

get_grouprow_by_id(GId) ->
	?DB_MODULE:select_row(t_users_groups,"*",[{id,GId}]).

get_groupall_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_groups,"*",[{user_id,UserId}]).


is_friend_black(UserId,FriendId) ->
	?DB_MODULE:select_one(t_users_friends,"state",[{user_id,UserId},{friend_id,FriendId}]).
%% 	
group_move(UserId,FromGId,ToId,FriendId) ->
	?DB_MODULE:update(t_users_friends,
					          	 [{group_id,ToId}],
								 [{user_id,UserId},{friend_id,FriendId}]
								 ).


%% Local Functions
%% 

