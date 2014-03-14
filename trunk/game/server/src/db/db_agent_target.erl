%% Author: liaoxiaobo
%% Created: 2013-4-23
%% Description: TODO: Add description to db_agent_target
-module(db_agent_target).

%%
%% Include files
%%
-include("common.hrl").

%%
%% Exported Functions
%%
-export([
		 get_user_targets_by_id/1,
		 get_user_history_targets_by_id/1,
		 get_users_achieve/1,
		 add_target/1,
		 update_target/1,
		 update_target1/1
%% 		 update_users_achieve/3
		]).

%%
%% API Functions
%%

get_user_targets_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_targets, "*", [{user_id, UserId}]).


get_user_history_targets_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_targets, "*", [{user_id, UserId},{type, 1},{is_finish, 1},{is_receive,1}],[{finish_date,desc}],[10]).

get_users_achieve(Id) ->
	?DB_MODULE:select_row(t_users_targets, "GROUP_CONCAT(`target_id`)",[{user_id, Id},{type,1},{is_receive,1}]).


%% 添加新的目标
add_target(Info) ->
	ValueList = lists:nthtail(1, tuple_to_list(Info#ets_users_targets{other_data=""})),
	
	FieldList = record_info(fields, ets_users_targets),
	Ret = ?DB_MODULE:insert(t_users_targets, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
		   Ret;
	   true ->
		   {mongo, Ret}
	end.



%% 更新目标
update_target(Info) ->
	?DB_MODULE:update(t_users_targets,
					  [{is_receive , Info#ets_users_targets.is_receive }
					   ],
					  [{user_id, Info#ets_users_targets.user_id},
					   {target_id, Info#ets_users_targets.target_id}]
					  ).


update_target1(Info) ->
	?DB_MODULE:update(t_users_targets,
					  [{is_finish  , Info#ets_users_targets.is_finish  },
					   {finish_date  , Info#ets_users_targets.finish_date  },
					   {data  , Info#ets_users_targets.data  }
					   ],
					  [{user_id, Info#ets_users_targets.user_id},
					   {target_id, Info#ets_users_targets.target_id}]
					  ).

%%更新玩家成就
%% update_users_achieve(UserId, Achieve,Data) ->
%% 	[Count] = ?DB_MODULE:select_count(t_users_titles,[{user_id,UserId}]),
%% 	case Count > 0 of
%% 		true ->
%% 			?DB_MODULE:update(t_users_titles,[{achieves,Achieve},{curr_achieve, Data}],[{user_id, UserId}]);
%% 		_ ->
%% 			?DB_MODULE:insert(t_users_titles, [user_id,achieves,curr_achieve],[UserId,Achieve,Data])
%% 	end.

%%
%% Local Functions
%%

