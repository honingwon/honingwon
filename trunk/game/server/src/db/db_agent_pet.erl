%% Author: liaoxiaobo
%% Created: 2012-10-31
%% Description: TODO: Add description to db_agent_pet
-module(db_agent_pet).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%
%% Exported Functions
%%
-export([
		 get_user_all_pet/1,
		 create_pet/1,
		 update_pet/2,
		 delete_pet/1,
		 get_pet_info_by_condition/3,
		 get_pet_all_skills/1,
		 update_pet_skill/5,
		 delete_pet_skills/1,
		 update_pet_battle/1,
		 get_pet_battle_all_pets/0,
		 get_battle_top_last/0,
		 get_pet_battle_by_pet_id/1,
		 get_pet_battle_by_user_id/1,
		 crate_pet_battle/1,
		 get_pet_battle_by_top/2,
		 get_pet_battle_skills/1,
		 update_pet_battle_top/2,
		 get_pet_battle_top_by_pet_id/1,
		 reset_pet_battle_yesterday_top/0,
		 get_pet_battle_yesterday_top/1,
		 get_pet_battle_yesterday_top_max/0
		]).

%%
%% API Functions
%%

%% 更新宠物斗坛记录
update_pet_battle(PetInfo) ->
	?DB_MODULE:update(t_pet_battle, [{user_id,PetInfo#ets_pet_battle.user_id},{replace_template_id,PetInfo#ets_pet_battle.replace_template_id},
														{name, PetInfo#ets_pet_battle.name},{fight,PetInfo#ets_pet_battle.fight},{quality,PetInfo#ets_pet_battle.quality},
														{level,PetInfo#ets_pet_battle.level},{stairs,PetInfo#ets_pet_battle.stairs},
														{win,PetInfo#ets_pet_battle.win},{total,PetInfo#ets_pet_battle.total},{winning,PetInfo#ets_pet_battle.winning},
														{skill_list,PetInfo#ets_pet_battle.skill_list}],
							  									[{pet_id,PetInfo#ets_pet_battle.pet_id}]).

update_pet_battle_top(Pet1,Pet2) ->	
	Sql = ?GET_TRAN("call update_pet_battle_top(~p,~p,~p,~p)",
										[Pet1#ets_pet_battle.pet_id,Pet1#ets_pet_battle.top,Pet2#ets_pet_battle.pet_id,Pet2#ets_pet_battle.top]),
	%?DEBUG("Sql~s",[Sql]),
	try 
		%?DB_MODULE:execute(t_pet_battle, update,Sql)
		?DB_MODULE:execute(t_pet_battle, update,Sql)	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

crate_pet_battle(PetInfo) ->
	ValueList = lists:nthtail(1, tuple_to_list(PetInfo)),
    FieldList = record_info(fields, ets_pet_battle),
	Ret = ?DB_MODULE:insert(t_pet_battle, FieldList, ValueList),	
	case Ret of 
		[] ->[];
		_ -> Ret
	end.
%% 	?DB_MODULE:insert(t_pet_battle, [pet_id, template_id,quality,name,level,fight,stairs,user_id,top],
%% 							  [PetInfo#ets_pet_battle.pet_id,PetInfo#ets_pet_battle.template_id,PetInfo#ets_pet_battle.quality,PetInfo#ets_pet_battle.name,PetInfo#ets_pet_battle.level,
%% 							  PetInfo#ets_pet_battle.fight,PetInfo#ets_pet_battle.stairs,PetInfo#ets_pet_battle.user_id,get_battle_top_last()]).

get_pet_battle_by_top(Top,Count) ->
	Ret = ?DB_MODULE:select_all(t_pet_battle,"pet_id",[{top, ">=",Top},{top, "<",Top + Count}],[{top,desc}],[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

reset_pet_battle_yesterday_top() ->
	Sql = "UPDATE t_pet_battle SET yesterday_top = top;",
	try 
		?DB_MODULE:execute(t_pet_battle, update,Sql)	
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

get_pet_battle_top_by_pet_id(PetID) ->
	Ret = ?DB_MODULE:select_row(t_pet_battle,"top",[{pet_id, PetID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

get_pet_battle_by_pet_id(PetID) ->
	Ret = ?DB_MODULE:select_row(t_pet_battle,"*",[{pet_id, PetID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

get_pet_battle_by_user_id(UserID) ->
	Ret = ?DB_MODULE:select_all(t_pet_battle,"pet_id",[{user_id, UserID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

get_pet_battle_yesterday_top(UserID) ->
	Ret = ?DB_MODULE:select_all(t_pet_battle,"yesterday_top",[{user_id, UserID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

get_pet_battle_yesterday_top_max() ->
	Sql = "SELECT MAX(yesterday_top) FROM t_pet_battle;",
	try 
		%?DB_MODULE:execute(t_pet_battle, update,Sql)
		?DB_MODULE:execute(t_pet_battle, select,Sql)
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

get_battle_top_last() ->
	[Count] = ?DB_MODULE:select_count(t_pet_battle,[]),
	Count.

%获取所有宠物斗坛信息
get_pet_battle_all_pets() ->
	Ret = ?DB_MODULE:select_all(t_pet_battle, "*",
								[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%% 创建宠物
create_pet(MountsInfo) ->
	ValueList = lists:nthtail(1, tuple_to_list(MountsInfo#ets_users_pets{other_data = ""})),
    FieldList = record_info(fields, ets_users_pets),
	Ret = ?DB_MODULE:insert(t_users_pets, FieldList, ValueList),	
	case Ret of 
		[] ->[];
		_ -> Ret
	end.
	
%获取玩家所有宠物
get_user_all_pet(UserID) ->
	Ret = ?DB_MODULE:select_all(t_users_pets, "*", 
								[{user_id, UserID}, {is_exit, 1}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.


update_pet(UpdateList, WhereList) ->
	?DB_MODULE:update(t_users_pets, UpdateList, WhereList).


delete_pet(WhereList) ->
	?DB_MODULE:delete(t_users_pets, WhereList).

get_pet_info_by_condition(WhereList,Order_List, Limit_num) ->
	Ret = ?DB_MODULE:select_row(t_users_pets, "*", 
								WhereList,Order_List, Limit_num),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%% 获取宠物技能template_id
get_pet_battle_skills(ID) ->
	Ret = ?DB_MODULE:select_all(t_users_pets_skills, "template_id", 
								[{id, ID}],[{study_time,asc}],[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%% 获取宠物所有技能
get_pet_all_skills(ID) ->
	Ret = ?DB_MODULE:select_all(t_users_pets_skills, "*", 
								[{id, ID}],[{study_time,asc}],[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

update_pet_skill(ID,OldTemplateId,TemplateId,Lv,Validdate) ->
	case OldTemplateId =:= 0 of
		true ->
			?DB_MODULE:insert(t_users_pets_skills, [id,template_id,is_exist,lv,study_time],
							  				  [ID,TemplateId,1,Lv,Validdate]);
		_ ->
			?DB_MODULE:update(t_users_pets_skills, [{template_id,TemplateId},{lv,Lv}],
							  					[{id,ID},{template_id,OldTemplateId}])
	end.


delete_pet_skills(WhereList) ->
	?DB_MODULE:delete(t_users_pets_skills, WhereList).


