%%%-------------------------------------------------------------------
%%% Module  : db_agent_mail


%%% Author  : Lincoln
%%% Created : 2011-3-14
%%% Description : 
%%%-------------------------------------------------------------------
-module(db_agent_mail).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([add_mail/1, 
		 delete_mail/1, 
		 get_mail_by_id/2, 
		 get_mail_by_player/1, 
		 get_mail_by_player/3,
		 get_mail_by_player2/3,
		 get_mail_count/1,
		 update_mail/2,
		 get_id_by_player_last/2,
		 insert_mail_all/4,
		 insert_mail_level_use/6
		]).

%%====================================================================
%% External functions
%%====================================================================
%%新增邮件
add_mail(MailInfo) -> 
	ValueList = lists:nthtail(2, tuple_to_list(MailInfo#ets_users_mails{other_data=""})),
	[id | FieldList] = record_info(fields, ets_users_mails),
	Ret = ?DB_MODULE:insert(t_users_mails, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
    		Ret;
		true ->
			{mongo, Ret}
	end.

%%更新邮件[{online_flag,1}, {hp,50, add}, {mp,30,sub}]
update_mail(Field_Value_List, MailId) ->
	?DB_MODULE:update(t_users_mails, Field_Value_List, [{id, MailId}]).

%%删除邮件
delete_mail(MailId) ->
%%	?DB_MODULE:delete(t_users_mails, [{id, MailId}]).
	update_mail([{is_exist, 0}], MailId).

	
%%读取邮件
get_mail_by_id(MailId,UserId) ->
	?DB_MODULE:select_row(t_users_mails, "*", [{id, MailId},{receiver_id, UserId},{is_exist, 1}]).

%%读取玩家全部邮件
get_mail_by_player(PlayerId) ->
	?DB_MODULE:select_all(t_users_mails, "*", [{receiver_id, PlayerId},{is_exist, 1}]).

%%分页读取玩家邮件
get_mail_by_player(PlayerId, Page, PageSize) ->
	Temp = if Page > 0 -> Page - 1;
			  true -> 0
		   end,
	Offset = Temp * PageSize,
	Limit = lists:concat([Offset, ",", PageSize]),
	?DB_MODULE:select_all(t_users_mails, "*", [{receiver_id, PlayerId},{is_exist, 1}], [{id,desc}],[Limit]).
%%分页读取玩家邮件2
get_mail_by_player2(Page, PageSize, WhereList) ->
	Temp = if Page > 0 -> Page - 1;
			  true -> 0
		   end,
	Offset = Temp * PageSize,
	Limit = lists:concat([Offset, ",", PageSize]),
	?DB_MODULE:select_all(t_users_mails, "*", WhereList, [{id,desc}],[Limit]).

%%邮件数量
get_mail_count(PlayerId) -> 
	[Sum] = ?DB_MODULE:select_row(t_users_mails, "count(1)", [{receiver_id, PlayerId},{is_exist, 1}]),
    Sum.

%% 获取最后发送邮件Id
get_id_by_player_last(SenderId, RecevierId) ->
	?DB_MODULE:select_one(t_users_mails, "id", [{sender_id, SenderId}, {receiver_id, RecevierId}], [{id,desc}], [1]).

%% 发送全服邮件
insert_mail_all(Title, Content,Type,ValidDate) ->
	Value = [io_lib:format("~p,'~s',`id`,`nick_name`,'~s','~s',~p,~p,~p,~p FROM t_users",[ ?GM_ID,?GM_NICK,Title, Content,misc_timer:now_seconds(),Type,ValidDate,1])],
	Sql = lists:concat(["INSERT INTO t_users_mails ( 
	sender_id, 
	send_nick, 
	receiver_id, 
	receiver_nick, 
	title, 
	context, 
	send_date, 	
	`type`, 
	valid_date, 
	is_exist	
	)
	SELECT ", Value]),
	db_mysqlutil:execute(Sql).


%% 发送全服邮件
insert_mail_level_use(Title, Content,Type,ValidDate,Min_lev,Max_lev) ->
	Value = [io_lib:format("~p,'~s',`id`,`nick_name`,'~s','~s',~p,~p,~p,~p FROM t_users where `level` BETWEEN ~p AND ~p",[ ?GM_ID,?GM_NICK,Title, Content,misc_timer:now_seconds(),Type,ValidDate,1,Min_lev,Max_lev])],
	Sql = lists:concat(["INSERT INTO t_users_mails ( 
	sender_id, 
	send_nick, 
	receiver_id, 
	receiver_nick, 
	title, 
	context, 
	send_date, 	
	`type`, 
	valid_date, 
	is_exist	
	)
	SELECT ", Value]),
	db_mysqlutil:execute(Sql).


%%====================================================================
%% Local functions
%%====================================================================


