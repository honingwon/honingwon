%% Author: Administrator
%% Created: 2011-3-16
%% Description: TODO: Add description to db_agent_task
-module(db_agent_task).


%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 get_user_tasks_by_id/1,
		 add_task/1,
		 update_task/1,
		 add_test/0
		 ]).

%%
%% API Functions
%%


%% 获取用户任务
get_user_tasks_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_tasks, "*", [{user_id, UserId}]).

add_test() ->
	Info = #ets_users_tasks{
      user_id = 100000166,                            %% 用户id	
      task_id = 511001,                            %% 任务id	
      state = 0,                              %% 任务状态	
      require_count = [],               %% 任务条件	
      repeat_count = 0,                       %% 	
      is_finish = 0,                          %% 是否完成	
      finish_date = 85,                        %% 完成时间	
      is_exist = 1 ,                          %% 是否放弃	
					other_data=#other_task{}
						   },
	pt_24:write(?PP_TASK_UPDATE, [Info]).
%% 	add_task(Info).

%% 添加新任务
add_task(Info) ->
	ValueList = lists:nthtail(1, tuple_to_list(Info#ets_users_tasks{other_data=""})),
	FieldList = record_info(fields, ets_users_tasks),
	Ret = ?DB_MODULE:insert(t_users_tasks, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
		   Ret;
	   true ->
		   {mongo, Ret}
	end.

%% 更新任务
update_task(Info) ->
	?DB_MODULE:update(t_users_tasks,
					  [{state, Info#ets_users_tasks.state},
					   {require_count, Info#ets_users_tasks.require_count},
					   {repeat_count, Info#ets_users_tasks.repeat_count},
					   {is_finish, Info#ets_users_tasks.is_finish},
					   {finish_date, Info#ets_users_tasks.finish_date},
					   {is_exist, Info#ets_users_tasks.is_exist},
					   {is_trust, Info#ets_users_tasks.is_trust},
					   {trust_end_time, Info#ets_users_tasks.trust_end_time},
					   {trust_count, Info#ets_users_tasks.trust_count}],
					  [{user_id, Info#ets_users_tasks.user_id},
					   {task_id, Info#ets_users_tasks.task_id}]
					  ).
	
	
	
%%
%% Local Functions
%%

