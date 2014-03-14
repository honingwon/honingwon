%% Author: 冯伟平
%% Created: 2011-3-28
%% Description: TODO: buff 处理
-module(db_agent_buff).


%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([
			get_user_all_buff/1,
			save_user_buff/1
		]).

%%
%% API Functions
%%


%获取玩家所有buff 
get_user_all_buff(UserID) ->
	Ret = ?DB_MODULE:select_all(t_users_buffs, "*", 
								[{user_id, UserID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%%保存玩家Buff
save_user_buff(BuffList) ->	
	AddBuffList = lists:filter(fun(Info)-> Info#ets_users_buffs.other_data#r_other_buff.is_new =:= 1
							   andalso Info#ets_users_buffs.is_exist =:= 1 
							   end, BuffList),
	AlterBuffList =  lists:filter(fun(Info)-> Info#ets_users_buffs.other_data#r_other_buff.is_new =/= 1 
								  andalso Info#ets_users_buffs.other_data#r_other_buff.is_alter =:= 1
							   end, BuffList),
	lists:foreach(fun update_user_buff/1, AlterBuffList),
	lists:foreach(fun insert_user_buff/1, AddBuffList).


update_user_buff(BuffInfo) ->
	?DB_MODULE:update(t_users_buffs,
					  [{begin_date, BuffInfo#ets_users_buffs.begin_date},
					   {valid_date, BuffInfo#ets_users_buffs.valid_date},
					   {end_date, BuffInfo#ets_users_buffs.end_date},
					   {is_exist, BuffInfo#ets_users_buffs.is_exist},
					   {total_value, BuffInfo#ets_users_buffs.total_value},
					   {is_exist, BuffInfo#ets_users_buffs.is_exist}],
					  [{user_id, BuffInfo#ets_users_buffs.user_id}, {template_id, BuffInfo#ets_users_buffs.template_id}]).

insert_user_buff(BuffInfo) ->
	ValueList = lists:nthtail(1, tuple_to_list(BuffInfo#ets_users_buffs{other_data = ""})),
    FieldList = record_info(fields, ets_users_buffs),
	Ret = ?DB_MODULE:insert(t_users_buffs, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
    		Ret;
		true ->
			{mongo, Ret}
	end.
%%
%% Local Functions
%%

