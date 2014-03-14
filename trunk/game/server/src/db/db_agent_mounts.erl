%% Author: liaoxiaobo
%% Created: 2012-10-31
%% Description: TODO: Add description to db_agent_mounts
-module(db_agent_mounts).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%
%% Exported Functions
%%
-export([
		 get_user_all_mounts/1,
		 create_mounts/1,
		 update_mounts/2,
		 delete_mounts/1,
		 get_mounts_info_by_condition/3,
		 get_mounts_all_skills/1,
		 update_mounts_skill/5,
		 delete_mounts_skills/1
		]).

%%
%% API Functions
%%


%% 创建坐骑
create_mounts(MountsInfo) ->
	ValueList = lists:nthtail(1, tuple_to_list(MountsInfo#ets_users_mounts{other_data = ""})),
    FieldList = record_info(fields, ets_users_mounts),
	Ret = ?DB_MODULE:insert(t_users_mounts, FieldList, ValueList),	
	if ?DB_MODULE =:= db_mysql ->
    		Ret;
		true ->
			{mongo, Ret}
	end.
	
%获取玩家所有坐骑
get_user_all_mounts(UserID) ->
	Ret = ?DB_MODULE:select_all(t_users_mounts, "*", 
								[{user_id, UserID}, {is_exit, 1}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.


update_mounts(UpdateList, WhereList) ->
	?DB_MODULE:update(t_users_mounts, UpdateList, WhereList).


delete_mounts(WhereList) ->
	?DB_MODULE:delete(t_users_mounts, WhereList).

get_mounts_info_by_condition(WhereList,Order_List, Limit_num) ->
	Ret = ?DB_MODULE:select_row(t_users_mounts, "*", 
								WhereList,Order_List, Limit_num),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%% 获取坐骑所有技能
get_mounts_all_skills(ID) ->
	Ret = ?DB_MODULE:select_all(t_users_mounts_skill, "*", 
								[{id, ID}],[{study_time,asc}],[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

update_mounts_skill(ID,OldTemplateId,TemplateId,Lv,Validdate) ->
	case OldTemplateId =:= 0 of
		true ->
			?DB_MODULE:insert(t_users_mounts_skill, [id,template_id,is_exist,lv,study_time],
							  				  [ID,TemplateId,1,Lv,Validdate]);
		_ ->
			?DB_MODULE:update(t_users_mounts_skill, [{template_id,TemplateId},{lv,Lv}],
							  					[{id,ID},{template_id,OldTemplateId}])
	end.


delete_mounts_skills(WhereList) ->
	?DB_MODULE:delete(t_users_mounts_skill, WhereList).



%% 
%% get_user_all_mounts_book(UserID) ->
%% 	Ret = ?DB_MODULE:select_all(t_users_mounts_book, "*", 
%% 								[{user_id, UserID}]),
%% 	case Ret of 
%% 		[] ->[];
%% 		_ -> Ret
%% 	end.
%% 
%% 
%% insert_mounts_book(Info) ->
%% 	ValueList = lists:nthtail(1, tuple_to_list(Info#ets_users_mounts_book{other_data = ""})),
%%     FieldList = record_info(fields, ets_users_mounts_book),
%% 	Ret = ?DB_MODULE:insert(t_users_mounts_book, FieldList, ValueList),	
%% 	if ?DB_MODULE =:= db_mysql ->
%%     		Ret;
%% 		true ->
%% 			{mongo, Ret}
%% 	end.
%% 
%% 
%% delete_mounts_book(WhereList) ->
%% 	?DB_MODULE:delete(t_users_mounts_book, WhereList).

%%
%% Local Functions
%%

