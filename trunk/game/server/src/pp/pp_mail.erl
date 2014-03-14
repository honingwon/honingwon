%%%-------------------------------------------------------------------
%%% Module  : pp_mail
%%% Author  : 
%%% Description : 邮件
%%%-------------------------------------------------------------------
-module(pp_mail).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================

%% 查询所有邮件
handle(?PP_MAIL_QUERY_ALL, PlayerStatus, []) ->
	case lib_mail:query_all_mail(PlayerStatus#ets_users.id) of
		List when erlang:is_list(List) ->
			{ok, DataBin} = pt_19:write(?PP_MAIL_UPDATE, List),		%%发送邮件列表
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, DataBin);
		_ ->
			skip
	end,
	ok;

%% 邮件发送
handle(?PP_MAIL_SEND, PlayerStatus, [ReceiverName, Title, Content, Copper, Attach]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Result = 
				case ReceiverName =/= binary_to_list(PlayerStatus#ets_users.nick_name) of
					true -> 
						case lib_player:get_role_id_by_name(ReceiverName) of
							null ->
								{error, "Receiver isn't exist"};
							ReceiverId -> 
								lib_mail:send_mail_to_one(PlayerStatus, [ReceiverId, ReceiverName, Title, Content, Copper, Attach])
				        end;
					_ -> 
						{error, "can not send to self"}
				end,
			{Result1, NewPlayerStatus1} = 
				case Result of
					{ok, NewPlayerStatus} -> 
						{1, NewPlayerStatus};
					_ ->
						{0, PlayerStatus}
				end,
			{ok, DataBin} = pt_19:write(?PP_MAIL_SEND, [Result1]),		%%返回发送结果
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, DataBin),
			{update_db, NewPlayerStatus1};
		
		_ ->
			ok
	end;
		


%% 邮件收取
handle(?PP_MAIL_RECEIVE, PlayerStatus, [MailId, Type]) ->
	case lib_mail:receive_mail(PlayerStatus, [MailId, Type]) of
		{ok, NewPlayerStatus} ->
			{update_db, NewPlayerStatus};
		_ ->
			ok
	end;

%% 邮件读取
handle(?PP_MAIL_READ, PlayerStatus, [MailId]) ->
	lib_mail:read_mail(PlayerStatus, [MailId]),
	ok;

%% 邮件删除
handle(?PP_MAIL_DELETE, PlayerStatus, [MailId]) ->
	lib_mail:delete_mail(PlayerStatus#ets_users.id, [MailId]),
    ok;

%% %% 邮件列表
%% handle(?PP_MAIL_RECEIVE_LIST, PlayerStatus, [Page, QueryType]) ->
%% 	lib_mail:receive_maillist(PlayerStatus, [Page, QueryType]),
%%     ok;

%% 删除空邮件
handle(?PP_MAIL_DELETE_EMPTY, PlayerStatus, [List]) ->
	lib_mail:delete_mail_empty(PlayerStatus#ets_users.id, List),
	ok;

%% 帮派邮件,需要先判断是否有权限发送
handle(?PP_MAIL_GUILD, PlayerStatus, [Title, Content]) ->
	mod_guild:check_mail_send(PlayerStatus#ets_users.id,
							  PlayerStatus#ets_users.other_data#user_other.pid_send,
							  PlayerStatus#ets_users.nick_name,
							  Title,
							  Content);


%% 获取帮会邮件数
handle(?PP_GET_MAIL_GUILD_NUM,PlayerStatus,_) ->
	case mod_guild:get_mails_total_count(PlayerStatus#ets_users.id) of
		{ok,Today_send_mails,TotalMails,_} ->
			{ok, Bin} = pt_19:write(?PP_GET_MAIL_GUILD_NUM, [TotalMails,Today_send_mails]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin);
		_ ->
			skip
	end;

%% 	case lib_mail:guild_mail_permission(PlayerStatus) of
%% 		{ok} -> 
%% 			lib_mail:send_guild_mail(PlayerStatus, Title, Content),
%% 		   	{ok, DataBin} = pt_19:write(?PP_MAIL_GUILD, 1),
%% 		   	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, DataBin);
%% 		{no_permission} ->
%% 			{ok, DataBin} = pt_19:write(?PP_MAIL_GUILD, 0),
%% 		   	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, DataBin)
%% 	end,
%% 	ok;

handle(Cmd, _Status, _Data) ->
	?WARNING_MSG("pp_mail cmd is not : ~w",[Cmd]),							 
    {error, "pp_mail no match"}.
%%====================================================================
%% Local functions
%%====================================================================


