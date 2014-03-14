%% Author: wangdahai
%% Created: 2012-12-6
%% Description: TODO: Add description to db_agent_top
-module(db_agent_top).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 get_top_discount/1,get_top_type/0,update_discount/1,delete_discount/1,
		 get_top_user_discuont/0,seven_day_top/1,
		 get_top_config/0,top_config_info_get/1,statistic_top/1,truncate_top_table/0,
		 delete_duplicate_top/1,insert_into_duplicate_top/1,get_top_individual/0,get_top_other/0,
		 get_duplicate_top_list/0,duplicate_top_list_get/1,get_duplicate_top_info/0]).

-define(TOP_NUMBER,200).
%%
%% API Functions
%%
get_top_discount(TopType) ->
	?DB_MODULE:select_all(t_user_top, "*" ,[{top_type, TopType}],[{value}],[?TOP_NUMBER]).

get_top_type() ->
	?DB_MODULE:select_all(t_user_top, "DISTINCT(top_type)", []).

%%获取副本信息，排行使用ets
get_duplicate_top_list() ->
	?DB_MODULE:select_all(mysql_template_dispatcher, t_duplicate_template, "duplicate_id,type,0,0,null", []).
%%获取副本排行明细

get_duplicate_top_info() ->
	?DB_MODULE:select_all(t_duplicate_top_info, "*,null", [],[{duplicate_id},{pass_id},{use_time}],[]).

update_discount(UpdateList) ->
  	?DB_MODULE:replace(t_user_top, UpdateList).

delete_discount(WhereList) ->
	?DB_MODULE:delete(t_user_top, WhereList).
%删除某一个副本的排行信息
delete_duplicate_top(DuplicateId) ->
	?DB_MODULE:delete(t_duplicate_top_info, [{duplicate_id,DuplicateId}]).

%保存到数据库
insert_into_duplicate_top(List) ->
	F = fun(Info, S) ->
			if
				S =:= [] ->
					?GET_TRAN("(~p,~p,'~s',~p)",[Info#top_duplicate_info.duplicate_id,Info#top_duplicate_info.pass_id,
													Info#top_duplicate_info.user_name,Info#top_duplicate_info.use_time]);
				true ->
					?GET_TRAN("~s,(~p,~p,'~s',~p)",[S,Info#top_duplicate_info.duplicate_id,Info#top_duplicate_info.pass_id,
													Info#top_duplicate_info.user_name,Info#top_duplicate_info.use_time])
			end
		end,
	Sql1 = lists:foldl(F, [], List),
	Sql = ?GET_TRAN("insert into t_duplicate_top_info(duplicate_id,pass_id,user_name,use_time) values~s;",[Sql1]),
	try 
		?DB_MODULE:execute(t_duplicate_top_info, insert,Sql)
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

truncate_top_table() ->
	?DB_MODULE:execute(t_top_individual, delete,"TRUNCATE TABLE t_top_individual;"),
	?DB_MODULE:execute(t_top_other, delete,"TRUNCATE TABLE t_top_other;").


statistic_top(Sql) ->
	try 
		?DB_MODULE:execute(t_top_individual, insert,Sql)
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

seven_day_top(Sql) ->
	try 
		?DB_MODULE:execute(t_users, select,Sql)
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

get_top_config() ->
	?DB_MODULE:select_all(mysql_template_dispatcher, t_top_config,"*",[]).

top_config_info_get(Id) ->
	case config:get_read_data_mode() of
		1 ->
			case ets:lookup(?ETS_TOP_CONFIG, Id) of
				[] -> 
					[];
				[D] ->
					D
			end;
		_ ->
			[]%%data_stone_decompose_template:get(Id)
	end.

get_top_individual() ->
	?DB_MODULE:select_all(t_top_individual, "*", [],[],[]).

get_top_other() ->
	?DB_MODULE:select_all(t_top_other, "*", [],[],[]).

get_top_user_discuont() ->
	?DB_MODULE:select_all(t_user_top_view, "*" ,[]).

%% top_user_discount_info_get(Id) ->
%% 	case config:get_read_data_mode() of
%% 		1 ->
%% 			case ets:lookup(?TOP_USER_DISCOUNT_INFO, Id) of
%% 				[] -> 
%% 					[];
%% 				[D] ->
%% 					D
%% 			end;
%% 		_ ->
%% 			[]%%data_stone_decompose_template:get(Id)
%% 	end.

%% top_list_info_get(TopType) ->
%% 	case ets:lookup(?ETS_TOP_DISCOUNT, TopType) of
%% 		[] -> 
%% 			[];
%% 		[D] ->
%% 			D
%% 	end.

duplicate_top_list_get(DuplicateId) ->
	case ets:lookup(?ETS_DUPLICATE_TOP, DuplicateId) of
		[] ->
			[];
		[D] ->
			D
	end.
%%
%% Local Functions
%%

