%%%-------------------------------------------------------------------
%%% Module  : pt_19
%%% Author  : Lincoln
%%% Created : 2011-3-13
%%% Description : 邮件
%%%-------------------------------------------------------------------
-module(pt_19).



%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([read/2, write/2]).

%%====================================================================
%% External functions
%%====================================================================
%%客户端 -> 服务端 -----------------------------------------------------
%%邮件发送
read(?PP_MAIL_SEND, Bin) -> 
	{ReceiverName, Bin1} = pt:read_string(Bin),
	{Title, Bin2} = pt:read_string(Bin1),
	{Content, Bin3} = pt:read_string(Bin2),
	<<Copper:32, Count:32, Bin4/binary>> = Bin3,
	Attach = read_attach(Count, [], Bin4),
	{ok, [ReceiverName, Title, Content, Copper, Attach]};

%%邮件收取
read(?PP_MAIL_RECEIVE, <<MailId:64, Type:32>>) -> 
	{ok, [MailId, Type]};

%%邮件读取
read(?PP_MAIL_READ, <<MailId:64>>) -> 
	{ok, [MailId]};

%%邮件删除
read(?PP_MAIL_DELETE, <<MailId:64>>) -> 
	{ok, [MailId]};

%% %%邮件列表
%% read(?PP_MAIL_RECEIVE_LIST, <<Page:32, QueryType:32>>) -> 
%% 	{ok, [Page, QueryType]}.

%% 清除空邮件
read(?PP_MAIL_DELETE_EMPTY, <<Len:16, Bin/binary>>) ->
	List = read_mail_id(Len, [], Bin),
	{ok, [List]};

%%	帮派邮件
read(?PP_MAIL_GUILD, Bin) ->
	{Title, Bin1} = pt:read_string(Bin),
	{Content, _} = pt:read_string(Bin1),
	{ok, [Title, Content]};
	
read(?PP_GET_MAIL_GUILD_NUM,_) ->
	{ok, []};
	
read(Cmd, _R) ->
	?WARNING_MSG("pt_19 read:~w", [Cmd]),
    {error, no_match}.

%%服务端 -> 客户端-----------------------------------------------------
%%邮件发送

%% 邮件更新
write(?PP_MAIL_UPDATE, List) ->
	Len = length(List),
	MailBin =  write_mail(List),
	Data = <<Len:16, MailBin/binary>>,
	{ok, pt:pack(?PP_MAIL_UPDATE, Data)};

write(?PP_MAIL_SEND, [Result]) -> 
	Data = <<Result:8>>,
	{ok, pt:pack(?PP_MAIL_SEND, Data)};

%%邮件收取
write(?PP_MAIL_RECEIVE, [MailId, Attach]) -> 
	Data = <<MailId:64, Attach:32>>,
	{ok, pt:pack(?PP_MAIL_RECEIVE, Data)};

%%邮件读取
write(?PP_MAIL_READ, [MailId, Result]) -> 
	Data = <<MailId:64, Result:8>>,
	{ok, pt:pack(?PP_MAIL_READ, Data)};

%%邮件响应
write(?PP_MAIL_RESPONSE, [PlayerId]) -> 
	Data = <<PlayerId:64>>,
	{ok, pt:pack(?PP_MAIL_RESPONSE, Data)};

%%邮件删除
write(?PP_MAIL_DELETE, [MailId, Result]) -> 
	Data = <<MailId:64, Result:8>>,
	{ok, pt:pack(?PP_MAIL_DELETE, Data)};

%% 公会邮件广播
write(?PP_MAIL_GUILD, IsSuccess) ->
	Data = <<IsSuccess:8>>,
	{ok, pt:pack(?PP_MAIL_GUILD, Data)};

%% 公会当日邮件数量
write(?PP_GET_MAIL_GUILD_NUM, [Total,Num]) ->
	{ok, pt:pack(?PP_GET_MAIL_GUILD_NUM,  <<Total:8,Num:8>>)};


%% %%邮件列表
%% write(?PP_MAIL_RECEIVE_LIST, [Page, Sum, List]) -> 	
%% 	Len = length(List),
%% 	Data1 = <<Page:32, Sum:32, Len:32>>,
%% 	Data2 =  write_mail(List),
%% 	Data = <<Data1/binary, Data2/binary>>,
%% 	{ok, pt:pack(?PP_MAIL_RECEIVE_LIST, Data)}.

write(Cmd, _R) ->
	?WARNING_MSG("pt_19,write:~w",[Cmd]),
	{ok, pt:pack(0, <<>>)}.

%%====================================================================
%% Local functions
%%====================================================================

%%邮件附件
read_mail_id(0, L, _) -> 
	L;
read_mail_id(Count, L, <<MailId:64, Bin/binary>>) -> 
	L1 = [MailId|L],
	read_mail_id(Count - 1, L1, Bin).

%%邮件附件
read_attach(0, L, _) -> 
	L;
read_attach(Count, L, <<Place:32, Bin/binary>>) -> 
	L1 = L ++ [Place],
	read_attach(Count - 1, L1, Bin).

%%邮件列表
write_mail(MailList) ->
	F = fun(Mail) ->
				MailId = Mail#ets_users_mails.id,
				SenderId = Mail#ets_users_mails.sender_id,
				SenderNick = pt:write_string(Mail#ets_users_mails.send_nick),
				ReceiverId = Mail#ets_users_mails.receiver_id,
				ReceiverNick = pt:write_string(Mail#ets_users_mails.receiver_nick),
				Title = pt:write_string(Mail#ets_users_mails.title),
				Context = pt:write_string(Mail#ets_users_mails.context),
				SendDate = Mail#ets_users_mails.send_date,
				IsRead = Mail#ets_users_mails.is_read,
				ReadDate = Mail#ets_users_mails.read_date,
				Copper = Mail#ets_users_mails.copper,
				BindCopper = Mail#ets_users_mails.bind_copper,
				YuanBao = Mail#ets_users_mails.yuan_bao,
				BindYuanBao = Mail#ets_users_mails.bind_yuan_bao,
				Attach1 = Mail#ets_users_mails.attach1,
				Attach2 = Mail#ets_users_mails.attach2,
				Attach3 = Mail#ets_users_mails.attach3,
				Attach4 = Mail#ets_users_mails.attach4,
				Attach5 = Mail#ets_users_mails.attach5,
				AttachFetch = Mail#ets_users_mails.attach_fetch,
				Remark = pt:write_string(Mail#ets_users_mails.remark),
				Type = Mail#ets_users_mails.type,
				ValidDate = Mail#ets_users_mails.valid_date,
		    	Items = Mail#ets_users_mails.other_data,	%%附件物品信息
				Len = length(Items),
				ItemsBin = write_mail_attach_item(Items),	
				<<MailId:64,
				  SenderId:64,
				  SenderNick/binary,
				  ReceiverId:64,
				  ReceiverNick/binary,
				  Title/binary,
				  Context/binary,
				  SendDate:32,
				  IsRead:8,
				  ReadDate:32,
				  Copper:32,
				  BindCopper:32,
				  YuanBao:32,
				  BindYuanBao:32,
				  Attach1:64,
				  Attach2:64,
				  Attach3:64,
				  Attach4:64,
				  Attach5:64,
				  AttachFetch:32,
				  Remark/binary,
				  Type:32,
				  ValidDate:32,
				  Len:32,
				  ItemsBin/binary>>
		end,
	A = [F(I) || I <- MailList],
	tool:to_binary(A).


%%附件物品
write_mail_attach_item(Items) ->
   
	F = fun(Info) ->	
				pt:packet_item(Info)

%% 				ItemId = Item#ets_users_items.id,
%% 				TemplateId = Item#ets_users_items.template_id,
%% 				IsBind = Item#ets_users_items.is_bind,
%% 				StrengthenLevel = Item#ets_users_items.strengthen_level,
%% 				Count = Item#ets_users_items.amount,
%% 				Place = Item#ets_users_items.place,
%% 				CreateDate = Item#ets_users_items.create_date,
%% 				State = Item#ets_users_items.state,
%% 				Enchase1 = Item#ets_users_items.enchase1,
%% 				Enchase2 = Item#ets_users_items.enchase2,
%% 				Enchase3 = Item#ets_users_items.enchase3,
%% 				Enchase4 = Item#ets_users_items.enchase4,
%% 				Enchase5 = Item#ets_users_items.enchase5,
%% 				Durable  = Item#ets_users_items.durable,
%% 				SellPrice = 2500,	%%售价
%% 				<<ItemId:64,
%% 				  TemplateId:32,
%% 				  IsBind:8,
%% 				  StrengthenLevel:32,
%% 				  Count:32,
%% 				  Place:32,
%% 				  CreateDate:32,
%% 				  State:32,
%% 				  Enchase1:32,
%% 				  Enchase2:32,
%% 				  Enchase3:32,
%% 				  Enchase4:32,
%% 				  Enchase5:32,
%% 				  Durable:32,
%% 				  SellPrice:32
%% 				  >>
		
		end,	
        tool:to_binary([F(I) || I <- Items]).



