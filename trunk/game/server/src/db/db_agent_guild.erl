%%%-------------------------------------------------------------------
%%% Module  : db_agent_guild
%%% Author  : lxb
%%% Created : 2012-9-25
%%% Description : 帮派模块
%%%-------------------------------------------------------------------
-module(db_agent_guild).


%%
%% Include files
%%
-include("common.hrl").

%%
%% Exported Functions
%%
-export([
		 get_guild_info_by_condition/1,
		 get_guild_corp_info_by_condition/1,
		 create_guild/1,
		 create_guild_user/1,
		 create_log/1,
		 get_guilds_by_pager/3,
		 get_guilds_count/0,
		 get_guild_users_all/0,
		 get_guild_users_request_all/0,
		 create_guild_user_request/1,
		 update_guilds_day_data/1,
		 update_guild/2,
		 update_user_guild/2,
		 create_corp/1,
		 update_corp/2,
		 delete_guild_user_request/1,
		 delete_guild_user/1,
		 delete_guild/1,
		 delete_corp/1,
		 get_guild_logs/1,
		 get_guild_warehouse_logs/1,
		 get_guild_warehouse_all/0,
		 create_guild_item/1,
		 delete_guild_item/1,
		 get_guild_items_request_all/0,
		 update_guilds_items_request/2,
		 insert_guilds_items_request/1,
		 get_guild_items_request_by_condition/1
		 ]).

%%
%% API Functions
%%



%% 根据条件查找帮会
get_guild_info_by_condition(Condition) ->	
	?DB_MODULE:select_row(t_guilds, "*", Condition, [], [1]).

%% 根据条件查询军团
get_guild_corp_info_by_condition(Condition) ->
	?DB_MODULE:select_row(t_guilds_corps, "*", Condition, [], [1]).

%% 根据条件查询记事
get_guild_logs(GuildID) ->
	?DB_MODULE:select_all(t_guilds_logs,"*",[{guild_id,GuildID},{log_type,"<",3}],[{id,desc}],[30]).

%% 根据条件查询记事
get_guild_warehouse_logs(GuildID) ->
	?DB_MODULE:select_all(t_guilds_logs,"*",[{guild_id,GuildID},{log_type ,">", 2}],[{id,desc}],[30]).


%% 创建帮会
create_guild(Guild) ->
	ValueList = lists:nthtail(1, tuple_to_list(Guild#ets_guilds{other_data=''})),
	FieldList = record_info(fields, ets_guilds),
	Ret = ?DB_MODULE:insert(t_guilds, FieldList, ValueList),
	case ?DB_MODULE of
		db_mysql ->
			Ret;
		_ ->
		   {mongo, Ret}
	end.

%% 帮会信息更新
update_guild(UpdateList,WhereList) ->
	?DB_MODULE:update(t_guilds,UpdateList,WhereList).

%% 创建军团 
create_corp(Corp) ->
	ValueList = lists:nthtail(1, tuple_to_list(Corp#ets_guilds_corps{other_data=''})),
	FieldList = record_info(fields, ets_guilds_corps),
	Ret = ?DB_MODULE:insert(t_guilds_corps, FieldList, ValueList),
	case ?DB_MODULE of
		db_mysql ->
			Ret;
		_ ->
			{mongo, Ret}
	end.

%% 创建日志
create_log(GuildLog) ->
	ValueList = lists:nthtail(1, tuple_to_list(GuildLog#ets_guilds_logs{other_data=''})),
	FieldList = record_info(fields, ets_guilds_logs),
	Ret = ?DB_MODULE:insert(t_guilds_logs,FieldList,ValueList),
	case ?DB_MODULE of
		db_mysql ->
			Ret;
		_ ->
			{mongo, Ret}
	end.

%% 军团信息更新
update_corp(UpdateList,WhereList) ->
	?DB_MODULE:update(t_guilds_corps,UpdateList,WhereList).

%% 用户帮会信息更新
update_user_guild(UpdateList,WhereList) ->
	?DB_MODULE:update(t_users_guilds,UpdateList,WhereList).
	

%% 创建帮会-个人关系
create_guild_user(UserGuild) ->
	ValueList = lists:nthtail(1,tuple_to_list(UserGuild#ets_users_guilds{other_data=''})),
	FieldList = record_info(fields, ets_users_guilds),
	Ret = ?DB_MODULE:insert(t_users_guilds, FieldList, ValueList),
	case ?DB_MODULE of
		db_mysql ->
		   Ret;
	   	_ ->
		   {mongo, Ret}
	end.

%% 创建帮会加入申请/邀请
create_guild_user_request(UserGuildRequest) ->
	ValueList = lists:nthtail(1, tuple_to_list(UserGuildRequest#ets_users_guilds_request{other_data=''})),
	FieldList =  record_info(fields, ets_users_guilds_request),
	Ret = ?DB_MODULE:insert(t_users_guilds_request, FieldList, ValueList),
	case ?DB_MODULE of
		db_mysql ->
		   Ret;
	   	_ ->
		   {mongo, Ret}
	end.

create_guild_item(GuildItem) ->
	ValueList = lists:nthtail(1, tuple_to_list(GuildItem#ets_guilds_items{other_data=''})),
	FieldList =  record_info(fields, ets_guilds_items),
	Ret = ?DB_MODULE:insert(t_guilds_items, FieldList, ValueList),
	case ?DB_MODULE of
		db_mysql ->
		   Ret;
	   	_ ->
		   {mongo, Ret}
	end.

delete_guild_item(Condition) ->
	?DB_MODULE:delete(t_guilds_items,Condition).

%% 删除帮会申请/邀请记录
delete_guild_user_request(Condition) ->
	?DB_MODULE:delete(t_users_guilds_request,Condition).

%% 删除会员信息
delete_guild_user(Condition) ->
	?DB_MODULE:delete(t_users_guilds,Condition).

%% 删除帮会信息
delete_guild(Condition) ->
	?DB_MODULE:delete(t_guilds,Condition).

%% 删除军团信息
delete_corp(Condition) ->
	?DB_MODULE:delete(t_guilds_corps,Condition).


%%分页读取帮会
get_guilds_by_pager(Name,PageIndex, PageSize) ->
	Temp = if PageIndex > 0 -> PageIndex - 1;
			  true -> 0
		   end,
	Offset = Temp * PageSize,
	Limit = lists:concat([Offset, ",", PageSize]),
	case Name of 
		[] ->
			C = ?DB_MODULE:select_count(t_guilds,[]),
			L = ?DB_MODULE:select_all(t_guilds, "*", [], [{guild_level,desc}],[Limit]);
		_ ->
			L = ?DB_MODULE:select_all(t_guilds, "*", [{guild_name,Name}], [{guild_level,desc}],[Limit]),
			C = length(L)
	end,
	{C,L}.

%%帮会数量
get_guilds_count() -> 
	[Sum] = ?DB_MODULE:select_row(t_guilds, "count(1)", []),
    Sum.

%% 获取所有帮会所有会员数据
get_guild_users_all() ->
	?DB_MODULE:select_all(t_users_guilds, "*", [],[],[]).

%% 获取所有帮会的所有申请数据
get_guild_users_request_all() ->
	?DB_MODULE:select_all(t_users_guilds_request, "*", [], [], []).


%% 获取所有帮会的所有仓库数据
get_guild_warehouse_all() ->
	?DB_MODULE:select_all(t_guilds_items, "*", [],[],[]).

%% 获取所有帮会物品申请记录
get_guild_items_request_all()->
	?DB_MODULE:select_all(t_guilds_items_request, "*", [{is_exist, 1}],[{request_date,asc}],[]).

%% 获取所有帮会物品申请记录
get_guild_items_request_by_condition(Condition)->
	?DB_MODULE:select_row(t_guilds_items_request, "*", Condition, [], [1]).

%% 帮会物品申请记录更新
update_guilds_items_request(UpdateList,WhereList) ->
	?DB_MODULE:update(t_guilds_items_request,UpdateList,WhereList).

%更新公会日数据
update_guilds_day_data(List) ->
	F = fun(Info, S) ->
			if
				S =:= [] ->
					?GET_TRAN("~p",[Info]);
				true ->
					?GET_TRAN("~s,~p",[S,Info])
			end
		end,
	Sql1 = lists:foldl(F, [], List),
	Sql = ?GET_TRAN("update t_guilds set today_send_mails = 0,last_send_date = 0,summon_collect_num = 0,summon_monster_num = 0 where id in(~s);",[Sql1]),
	try 
		?DB_MODULE:execute(t_guilds, update,Sql)
	catch
		_:_Reason ->
			?WARNING_MSG("get_stacktrace:~p",[{_Reason,erlang:get_stacktrace()}])
	end.

insert_guilds_items_request(Info) ->
	ValueList = lists:nthtail(1, tuple_to_list(Info#ets_guilds_items_request{other_data=''})),
	FieldList = record_info(fields, ets_guilds_items_request),
	?DB_MODULE:insert(t_guilds_items_request, FieldList, ValueList).

%%
%% Local Functions
%%

