%%%-------------------------------------------------------------------
%%% Module  : lib_mail
%%% Author  : 
%%% Description : 邮件
%%%-------------------------------------------------------------------
-module(lib_mail).


%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
%% 附件标记位
-define(Mail_Attach1, 1).
-define(Mail_Attach2, 2).
-define(Mail_Attach3, 3).
-define(Mail_Attach4, 4).
-define(Mail_Attach5, 5).
-define(Mail_Copper, 11).
-define(Mail_YuanBao, 12).
-define(Mail_BindCopper,13).
-define(Mail_BindYuanBao, 14).

-define(Page_Size, 7).

%%附件的类型
-define(Type_Money, 1024).
-define(Type_Attach1, 1).
-define(Type_Attach2, 2).
-define(Type_Attach3, 4).
-define(Type_Attach4, 8).
-define(Type_Attach5, 16).

-define(Mail_NeedCopper, 10).			%%邮件手续费
-define(Mail_Valid_Date, 24*30).		%%有效时间

-define(MAX_NUM, 300). %% 最大邮件数
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([send_mail_to_one/2, 
		 get_attach_fetch/2, 
		 set_attach_fetch/2,
		 delete_mail/2, 
		 receive_mail/2, 
		 read_mail/2,
		 send_items_to_mail/1,
		 delete_mail_empty/2,
		 query_all_mail/1,
		 check_mail_full/1,
		 send_sys_mail/12,
		 send_guild_mail/5,
		 send_GM_items_to_mail/1,
		 %guild_mail_permission/3,
		 send_box_items_to_mail/1,
		 send_items_to_mail/6,
		 send_mail_multiple/6,
		 send_mail_multiple_item/5
		 ]).

%% ----------------------------------
%% 发送系统邮件
%% ----------------------------------



send_sys_mail(SenderNick, SenderId, RecevierNick, RecevierUserId, Items, MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao) ->
	case check_mail(RecevierNick, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao) of
		{error, Reason} ->
 			?WARNING_MSG("send_sys_mail:~p~n",[Reason]),
			skip;
		{ok, RecevierNick1} ->
			try
				case check_mail_full(RecevierUserId) of
					true ->
						skip;
				   	false ->
					   	send_items_to_mail(SenderNick, SenderId, RecevierNick1, RecevierUserId, Items, MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao)
				end
				
			catch 
				_:R ->
					?WARNING_MSG("send_items_to_mail:~p~n",[R])
			end
	end,
	ok.

	
check_mail(Name, Title, Content, _Copper, _BindCopper, _YuanBao, _BindYuanBao) ->
	case check_title(Title) of
		true ->
			case check_content(Content) of
				true ->
					NewName = 
					case is_binary(Name) of
						true ->
							binary_to_list(Name);
						false ->
							Name
					end,
					case check_name(NewName) of
						true ->
							{ok, NewName};
						false ->
							{error, "WRONG_NAME"}
					end;
				false ->
				 	{error, "WRONG_CONTENT"};
				error ->
					{error, "?WRON_CONTENT"}
			end;
		false ->
			{error, "WRONG_TITLE"};
		error ->
			{error, "WRONG_TITLE"}
	end.

%% 检查收件人昵称
check_name(Name) ->
	case lib_player:is_exists_name(Name) of 
		true ->
			true;
		_ ->
			case check_length(Name, 19) of
				true ->
					true;
				_ ->
					false
			end
	end.

%% 检查标题（限制50汉字）
check_title(Title) ->
	check_length(Title, 100).

%% 检查内容（限制500汉字）
check_content(Content) ->
	check_length(Content, 1000).

%% 长度合法性检查
check_length(Item, LenLimit) ->
	case asn1rt:utf8_binary_to_list(list_to_binary(Item)) of
		{ok, UnicodeList} ->
			Len = misc:string_width(UnicodeList),
			Len =< LenLimit andalso Len >= 1;
		{error, _R} ->
			error
	end.


%% ----------------------------------
%% 检查邮件是否已满, TRUE已满 FALSE未满
%% ----------------------------------
check_mail_full(UserId) ->
	Mail_Count = db_agent_mail:get_mail_count(UserId),
	if
		Mail_Count < ?MAX_NUM ->
			false;
		true ->
			true
	end.

%%====================================================================
%% External functions
%%====================================================================
send_items_to_mail(SenderName, SenderId, ItemList, ReceiverId, ReceiverName, Type) ->
	send_items_to_mail(SenderName, SenderId, ReceiverName, ReceiverId, ItemList, Type, [], [], 0, 0, 0, 0).

send_items_to_mail([SenderName, SenderId, ItemList, ReceiverId, ReceiverName]) ->
	send_items_to_mail(SenderName, SenderId, ReceiverName, ReceiverId, ItemList, ?Mail_Type_BuyItem, [], [], 0, 0, 0, 0).

%发送箱子物品
send_box_items_to_mail([SenderName, SenderId, ItemList, ReceiverId, ReceiverName]) ->	
	send_items_to_mail(SenderName, SenderId, ReceiverName, ReceiverId, ItemList, ?Mail_Type_OpenBox, [], [], 0, 0, 0, 0).
%%系统发送邮件
send_GM_items_to_mail([ItemList, ReceiverName,ReceiverId, Title, Content]) ->
	send_items_to_mail("GM", 0, ReceiverName, ReceiverId, ItemList, ?Mail_Type_GM, Title, Content, 0, 0, 0, 0).

send_items_to_mail(SenderName, SenderId, ReceiverName, ReceiverId, ItemList, MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao) ->
	Length = length(ItemList),
	if
		Length =:= 0 ->
			send_items_to_mail1(SenderName, SenderId, ReceiverName, ReceiverId, [], MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao);		
		Length =:= 1 ->
			send_items_to_mail1(SenderName, SenderId, ReceiverName, ReceiverId, ItemList, MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao);
		Length > 1 ->
			[ItemInfo|Left_ItemList] = ItemList,
			send_items_to_mail1(SenderName, SenderId, ReceiverName, ReceiverId, [ItemInfo], MailType, Title, Content, 0, 0, 0, 0),
			send_items_to_mail(SenderName, SenderId, ReceiverName, ReceiverId, Left_ItemList, MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao)		
	end.
		
		  
send_items_to_mail1(SenderName, SenderId, ReceiverName, ReceiverId, ItemList, MailType, Title, Content, Copper, BindCopper, YuanBao, BindYuanBao) ->
%%背包满时，用邮件存储
	Len = length(ItemList),
	F = fun(Item, [Acc, Mark, Context]) ->
				ItemId = Item#ets_users_items.id,
                Amount = Item#ets_users_items.amount,
				Template = data_agent:item_template_get(Item#ets_users_items.template_id),
				Mark0 = Mark ++ [binary_to_list(Template#ets_item_template.name)],
				Context0 = Context ++ ":" ++ [lists:concat([binary_to_list(Template#ets_item_template.name), '*', Amount])],
				Acc0 = Acc ++ [ItemId],
				[Acc0, Mark0, Context0]
		end,
	[ItemIds, NameList, Context] = lists:foldl(F, [[], [], []], ItemList),
		
	Remark = string:join(NameList, ","),

	[Attach1, Attach2, Attach3, Attach4, Attach5] = ItemIds ++ lists:duplicate((5 - Len), 0),
	
	MailInfo = init_mail(0, SenderId, SenderName, ReceiverId, ReceiverName, Title, Content ++ Context, 
						 misc_timer:now_seconds(), Copper, BindCopper, YuanBao, BindYuanBao,
						 Attach1, Attach2, Attach3, Attach4, Attach5, Remark, MailType, 
						 ?Mail_Valid_Date, ItemList),
	
	{ok, DataBin} = pt_19:write(?PP_MAIL_UPDATE, [MailInfo]),
	lib_send:send_to_uid(ReceiverId, DataBin).

%%发邮件
send_mail_to_one(PlayerStatus, [ReceiverId, ReceiverName, Title, Context, Copper, Attach]) ->
	SenderId = PlayerStatus#ets_users.id,
	User = PlayerStatus,

	case User#ets_users.copper >= Copper andalso 
						  ((User#ets_users.copper + User#ets_users.bind_copper) >= (Copper + ?Mail_NeedCopper)) of 
		true ->			
			NewPlayerInfo = lib_player:reduce_cash_and_send(User, 0, 0, Copper, ?Mail_NeedCopper,{?CONSUME_MONEY_MAIL_SEND,ReceiverId,1}),
			
			%% 修改成物品进程处理			
			[ItemList, Items, NameList] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,	
														 {'mail_send_item', Attach}),
			
			Remark = string:join(NameList, ","),
			AttachLen = length(Items),
			[Attach1, Attach2, Attach3, Attach4, Attach5] = Items ++ lists:duplicate((5 - AttachLen), 0),
			

			MailInfo = init_mail(0, SenderId, PlayerStatus#ets_users.nick_name, ReceiverId, ReceiverName,
								 Title, Context, util:unixtime(), Copper, 0, 0, 0, Attach1, Attach2, Attach3,
								  Attach4, Attach5, Remark, ?Mail_Type_Common, ?Mail_Valid_Date, ItemList),
	
			{ok, DataBin} = pt_19:write(?PP_MAIL_UPDATE, [MailInfo]),
			lib_send:send_to_uid(ReceiverId, DataBin),

			{ok,DataBin2} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,[], Attach]),		%%更新背包
			lib_send:send_to_uid(SenderId, DataBin2),
			{ok, NewPlayerInfo};
		_ ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,?_LANG_MAIL_LESS_COPPER]),
			{error, {"not enough copper"}}
	end.

%%邮件收取 
receive_mail(PlayerStatus, [MailId, Type]) ->
    PlayerId = PlayerStatus#ets_users.id,
	Mail = case db_agent_mail:get_mail_by_id(MailId,PlayerId) of
			   [] -> 
				   [];
			   M -> 
				   list_to_tuple([ets_users_mails | M])
		   end,
    if Mail =/= [] ->
%%收取货币 （Type==0是收取所有的附件包括货币）
		   {NewPlayerStatus, NewMail} = 
			   if Type =:= 0 orelse Type =:= ?Type_Money ->
					  receive_money(PlayerStatus, Mail);
				  true -> 
					  {PlayerStatus, Mail}
			   end,
%%收取附件
		   NewMail1 = receive_attach(NewPlayerStatus, NewMail, Type, 
									 ?Type_Attach1, ?Mail_Attach1, NewMail#ets_users_mails.attach1),
		   NewMail2 = receive_attach(NewPlayerStatus, NewMail1, Type, 
									 ?Type_Attach2, ?Mail_Attach2, NewMail1#ets_users_mails.attach2),
		   NewMail3 = receive_attach(NewPlayerStatus, NewMail2, Type, 
									 ?Type_Attach3, ?Mail_Attach3, NewMail2#ets_users_mails.attach3),
		   NewMail4 = receive_attach(NewPlayerStatus, NewMail3, Type, 
									 ?Type_Attach4, ?Mail_Attach4, NewMail3#ets_users_mails.attach4),
		   NewMail5 = receive_attach(NewPlayerStatus, NewMail4, Type, 
									 ?Type_Attach5, ?Mail_Attach5, NewMail4#ets_users_mails.attach5),
%%通知客户端
		   AttachFetch = NewMail5#ets_users_mails.attach_fetch,
		   db_agent_mail:update_mail([{attach_fetch, AttachFetch}], MailId),
		   {ok, DataBin} = pt_19:write(?PP_MAIL_RECEIVE, [MailId, AttachFetch]),
		   lib_send:send_to_uid(PlayerId, DataBin),
		   {ok, NewPlayerStatus};
	   true ->
		   {erorr, {"mail is not exist"}}
	end.

%%阅读邮件
read_mail(PlayerStatus, [MailId]) ->
	PlayerId = PlayerStatus#ets_users.id,
	Result = db_agent_mail:update_mail([{is_read, 1}], MailId),
	{ok, DataBin} = pt_19:write(?PP_MAIL_READ, [MailId, Result]),
	lib_send:send_to_uid(PlayerId, DataBin).

query_all_mail(UserId) ->
	List = db_agent_mail:get_mail_by_player(UserId),
	MailList = init_mail(List),
	MailList.

init_mail(List) ->
	F = fun(Mail) ->
				Mail1 = list_to_tuple([ets_users_mails | Mail]),					%%转化为record格式
				ItemIds = [Mail1#ets_users_mails.attach1, 
						   Mail1#ets_users_mails.attach2, 
						   Mail1#ets_users_mails.attach3, 
						   Mail1#ets_users_mails.attach4, 
						   Mail1#ets_users_mails.attach5],
				Items = get_itemlist_by_id(ItemIds),
				Mail1#ets_users_mails{other_data = Items}     
		end,
	MailList1 = [F(I) || I <- List],
	MailList1.

%%邮件删除
delete_mail(UserId,[MailId]) ->
%%      PlayerId = PlayerStatus#ets_users.id,
     Result = db_agent_mail:delete_mail(MailId),
     {ok, DataBin} = pt_19:write(?PP_MAIL_DELETE, [MailId,Result]),
     lib_send:send_to_uid(UserId, DataBin).

%% 删除空邮件
delete_mail_empty(UserId, List) ->
	F = fun(Id) ->
			delete_mail(UserId, [Id])
		end,
	lists:foreach(F, List).
															

%%或取AttachFetch中对应附件的标记,1为已取,0为未取
get_attach_fetch(Fetch, Index) ->
	Fetch1 = <<Fetch:32>>,
	Left = 32 - Index,
	Right = Index - 1,
	<<_:Left, Val:1, _:Right>> = Fetch1,
	Val.

%%设置邮件AttachFetch中对应附件的标记为已取
set_attach_fetch(Fetch, Index) ->
	Fetch1 = <<Fetch:32>>,
	Left = 32 - Index,
	Right = Index - 1,
	<<Bin1:Left, _:1, Bin2:Right>> = Fetch1,
	<<Bin:32>> = <<Bin1:Left, 1:1, Bin2:Right>>,
	Bin.
%%====================================================================
%% Local functions
%%====================================================================
%%附件收取
receive_attach(PlayerStatus, Mail, Type, AttachType, Mail_Attach, ItemId) ->
   AttachFetch = Mail#ets_users_mails.attach_fetch,
   Item = case db_agent_item:get_item_by_itemid(ItemId) of
			  [] -> 
				  [];
			  I -> 
				  Info = list_to_tuple([ets_users_items | I]),
				  Info#ets_users_items{other_data=#item_other{}}
		  end,
   MailAttach = get_attach_fetch(AttachFetch, Mail_Attach),
   if (Type =:= 0 orelse Type =:= AttachType) andalso MailAttach =:= 0 andalso Item =/= [] ->
		  ItemPid = PlayerStatus#ets_users.other_data#user_other.pid_item,
		  {ok, Res} = gen_server:call(ItemPid, {'mail_item_add', Item}),	%%发送给物品进程，收取物品
		  if Res =:= 1 ->
				 Mail#ets_users_mails{attach_fetch = set_attach_fetch(AttachFetch, Mail_Attach)};
			 true ->
				 Mail
		  end;
	  true ->
		  Mail
   end.

%%货币收取
receive_money(PlayerStatus, Mail) ->
    %%邮件的货币
    Copper = Mail#ets_users_mails.copper,
    YuanBao = Mail#ets_users_mails.yuan_bao,
    BindCopper = Mail#ets_users_mails.bind_copper,
	BindYuanBao = Mail#ets_users_mails.bind_yuan_bao,
	
%% 	CopperAttach = get_attach_fetch(Mail#ets_users_mails.attach_fetch, ?Mail_Copper),
%% 	{NewCopper, NewMail1} = 
%% 		if Copper /= 0 andalso CopperAttach =:= 0 ->
%% 			   Mail1 = Mail#ets_users_mails{attach_fetch = set_attach_fetch(Mail#ets_users_mails.attach_fetch,?Mail_Copper)},
%% 			   {Copper, Mail1};
%% 		   true ->
%% 			   {0, Mail}
%% 		end,
%% 
%% 	YuanBaoAttach = get_attach_fetch(Mail#ets_users_mails.attach_fetch, ?Mail_YuanBao),
%% 	{NewYuanBao, NewMail2} = 
%% 		if YuanBao /= 0 andalso YuanBaoAttach =:= 0 ->
%% 			   Mail2 = NewMail1#ets_users_mails{attach_fetch = set_attach_fetch(NewMail1#ets_users_mails.attach_fetch,?Mail_YuanBao)},
%% 			   {YuanBao, Mail2};
%% 		   true ->
%% 			   {0, NewMail1}
%% 		end,
%% 	
%% 	BindCopperAttach = get_attach_fetch(Mail#ets_users_mails.attach_fetch, ?Mail_BindCopper),
%% 	{NewBindCopper, NewMail3} = 
%% 		if BindCopper /= 0 andalso BindCopperAttach =:= 0 ->
%% 			   Mail3 = NewMail2#ets_users_mails{attach_fetch = set_attach_fetch(NewMail2#ets_users_mails.attach_fetch,?Mail_BindCopper)},
%% 			   {BindCopper, Mail3};
%% 		   true ->
%% 			   {0, NewMail2}
%% 		end,
%% 	
%% 	BindYuanBaoAttach = get_attach_fetch(Mail#ets_users_mails.attach_fetch, ?Mail_BindYuanBao),
%% 	{NewBindYuanBao, NewMail4} = 
%% 		if BindYuanBao /= 0 andalso BindYuanBaoAttach =:= 0 ->
%% 			   Mail4 = NewMail3#ets_users_mails{attach_fetch = set_attach_fetch(NewMail3#ets_users_mails.attach_fetch,?Mail_BindYuanBao)},
%% 			   {BindYuanBao, Mail4};
%% 		   true ->
%% 			   {0, NewMail3}
%% 		end,
	
	%% 一次性取出所有货币
	CopperAttach = get_attach_fetch(Mail#ets_users_mails.attach_fetch, ?Mail_Copper),
 	{NewCopper, NewYuanBao, NewBindCopper, NewBindYuanBao, NewMail1} = 
		if CopperAttach =:= 0 ->
			   Mail1 = Mail#ets_users_mails{attach_fetch = set_attach_fetch(Mail#ets_users_mails.attach_fetch,?Mail_Copper)},
%% 			   Mail1 = Mail#ets_users_mails{attach_fetch = ?Type_Money},
			   {Copper, YuanBao, BindCopper, BindYuanBao, Mail1};
		   true ->
			   {0, 0, 0, 0, Mail}
		end,
	
	%%添加元宝日志
%% 	lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, NewYuanBao, NewBindYuanBao, 
%% 										   0, ?CONSUME_YUANBAO_RECEIVE_MAIL, misc_timer:now_seconds(), 0, 0,
%% 										   PlayerStatus#ets_users.level),
	
	NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, NewYuanBao, NewBindYuanBao, NewCopper, NewBindCopper,
													{?GAIN_MONEY_RECEIVE_MAIL,Mail#ets_users_mails.id,1}),
	{NewPlayerStatus, NewMail1}.

%%获取附件物品信息列表
get_itemlist_by_id(ItemIds) ->
	F = fun(Id, List) ->
				if Id > 0 ->
					   case db_agent_item:get_item_by_itemid(Id) of
						   [] -> 
							   List;
						   Item -> 
							   Record = list_to_tuple([ets_users_items] ++ Item),
							   Other = #item_other{sell_price = 0},
		  				 	   NewRecord = Record#ets_users_items{other_data = Other},
							   [NewRecord|List]

%% 							   List ++ [list_to_tuple([ets_users_items | NewRecord])]
					   end;
				   true -> List
				end
		end,
	lists:foldl(F, [], ItemIds).


%% send_guild_mail(PlayerStatus, Title, Context) ->
%% 	case mod_guild:get_guild_users_list(PlayerStatus#ets_users.club_id) of
%% 		[] ->
%% 			skip;
%% 		MemberList ->
%% 			F = fun(Info) ->
%% 						if Info#ets_users_guilds.user_id =:= PlayerStatus#ets_users.id ->
%% 							   skip;
%% 						   true ->
%% 							   
%% 							MailInfo = init_mail(0, PlayerStatus#ets_users.id, PlayerStatus#ets_users.nick_name,
%% 												  Info#ets_users_guilds.user_id,Info#ets_users_guilds.user_id,  %% 需要改为昵称
%% 												  Title, Context, util:unixtime(), 0, 0, 0, 0, 0, 0, 0, 0, 0, "", 
%% 												 ?Mail_Type_Guild_Broad, ?Mail_Valid_Date, []),
%% 							
%% 		  					   {ok, DataBin} = pt_19:write(?PP_MAIL_UPDATE, [MailInfo]),
%% 				        	   lib_send:send_to_uid(Info#ets_users_guilds.user_id, DataBin)
%% 						end
%% 				end,
%% 			lists:foreach(F, MemberList)
%% 	end.

send_guild_mail(MemberList,Title,Context,PlayerID,PlayerNickName) ->
	case MemberList of
		[] ->
			skip;
		_ ->
			F = fun(Member) ->
						if Member#ets_users_guilds.user_id =:= PlayerID ->
							   skip;
						   true ->
							   MailInfo = init_mail(0, 
													PlayerID, 
													PlayerNickName,
													Member#ets_users_guilds.user_id,
													Member#ets_users_guilds.other_data#other_users_guilds.nick_name,
													Title,
													Context,
													misc_timer:now_seconds(),
													0, 0, 0, 0, 0, 0, 0, 0, 0, "", 
													?MAIL_TYPE_GUILD_BROAD, ?Mail_Valid_Date, []
													),
							   {ok, DataBin} = pt_19:write(?PP_MAIL_UPDATE, [MailInfo]),
							   lib_send:send_to_uid(Member#ets_users_guilds.user_id, DataBin)
						end
				end,
			lists:foreach(F, MemberList)
	end.

send_mail_multiple(AccountString,Action,Min_lev,Max_lev,Title, Content) ->
	case Action of
		1 ->
			 NameList = string:tokens(AccountString, ","),
			 F = fun(Nick_Name) ->
						 case lib_player:get_role_id_by_name(Nick_Name) of
							 null ->
								 skip;
							 Id ->
								 send_sys_mail(Id,Nick_Name,Title, Content)
						 end
				 end,
			 lists:foreach(F, NameList);
		2 ->
			db_agent_mail:insert_mail_level_use(Title, Content,?Mail_Type_GM, ?Mail_Valid_Date,Min_lev,Max_lev);
		3 -> %% 不通知 
			db_agent_mail:insert_mail_all(Title, Content,?Mail_Type_GM, ?Mail_Valid_Date);
		_ ->
			skip

	end.


send_mail_multiple_item(ItemInfo,MoneyInfo,UserInfo,Title, Content) ->
	[YuanBao,Bind_YuanBao,Copper,Bind_Copper] = string:tokens(MoneyInfo, ","),
	NameList = string:tokens(UserInfo, ","),
	ItemList = case string:tokens(ItemInfo, ",") of
				   ["null"] ->
					   [];
				   I ->
					   I
			   end,
	F = fun(Nick_Name) ->
				 case lib_player:get_role_id_by_name(Nick_Name) of
					 null ->
						 skip;
					 User_id ->
						 F1 = fun(Info, ItemList) ->
									  [Template_id,Amount,Is_Bind] = string:tokens(Info, "|"),
									  
									 Template = data_agent:item_template_get(list_to_integer(Template_id)),
									 Item = item_util:create_new_item(Template,list_to_integer(Amount), -100, tool:to_integer(User_id), list_to_integer(Is_Bind), 0),
									 NewItem = item_util:add_item_and_get_id(Item),
									 [NewItem|ItemList]
							 end,
						 ItemList1 = lists:foldl(F1, [], ItemList),
						 
						 lib_mail:send_sys_mail(?GM_NICK, ?GM_ID,  Nick_Name, User_id, ItemList1, ?Mail_Type_GM,
												Title, Content,  list_to_integer(Copper), list_to_integer(Bind_Copper), list_to_integer(YuanBao), list_to_integer(Bind_YuanBao))
				 end
		 end,
	lists:foreach(F, NameList).




send_sys_mail(Id,NickName,Title, Content) ->
	MailInfo = init_mail(0, ?GM_ID ,?GM_NICK,
						 Id,
						 NickName,
						 Title,
						 Content,
						 misc_timer:now_seconds(),
						 0, 0, 0, 0, 0, 0, 0, 0, 0, "", 
						 ?Mail_Type_GM, ?Mail_Valid_Date, []
						),
	{ok, DataBin} = pt_19:write(?PP_MAIL_UPDATE, [MailInfo]),
	lib_send:send_to_uid(Id, DataBin).
	
%%cast帮会模块进行帮会邮件发送
%% guild_mail_permission(PlayerStatus, Title, Context) ->
%% 	mod_guild:check_mail_send(PlayerStatus#ets_users.id,
%% 							  PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 							  PlayerStatus#ets_users.nick_name,
%% 							  Title,
%% 							  Context).
%%获取帮会发送邮件的权限
%% guild_mail_permission(PlayerStatus) ->
%% 	if PlayerStatus#ets_users.club_id =/= 0 ->
%% 		{ok,Member} = mod_guild:get_guild_user_info(PlayerStatus#ets_users.id),
%% 		%%帮主有权限发送群邮件
%% 		if Member#ets_users_guilds.member_type == ?GUILD_JOB_PRESIDENT ->
%% 				%%如果发邮件数超过每天发送上限，则不进行发送
%% 			   	case mod_guild:check_mail_send(PlayerStatus#ets_users.id) of
%% 					{ok} -> {ok};
%% 					{false,Msg} ->						
%% 						{no_permission}
%% 				end;
%% 		   	true ->
%% 				{no_permission}
%% 		end;
%% 	   	true ->
%% 		   {no_permission}
%% 	end.
 

%%实例化邮件信息
init_mail(ID, Send_id, SendNick, Receive_id, Receive_nick, Title, Context, Send_date, Copper, Bind_copper,
		  Yuanbao, Bind_yuanbao, Attach1, Attach2, Attach3, Attach4, Attach5, Remark, Type, Valid_date, Other_data) ->
	NewContent = binary_to_list(re:replace(Context, "<\/?[^>]*>", "", [global, caseless,{return, binary}])),
	MailInfo = #ets_users_mails{id = ID,
					 sender_id = Send_id,
					 send_nick = SendNick,
					 receiver_id = Receive_id,
					 receiver_nick = Receive_nick,  %% 需要改为昵称
					 title = Title,
					 context = NewContent,
					 send_date = Send_date,
					 copper = Copper,
					 bind_copper = Bind_copper,
					 yuan_bao = Yuanbao,
					 bind_yuan_bao = Bind_yuanbao,
					 attach1 = Attach1,
					 attach2 = Attach2,
					 attach3 = Attach3,
					 attach4 = Attach4,
					 attach5 = Attach5,
					 remark = Remark,
					 type = Type, 
					 valid_date = Valid_date,
					 other_data = Other_data
					},
	_Res = db_agent_mail:add_mail(MailInfo),	
	Mail_ID = db_agent_mail:get_id_by_player_last(Send_id, Receive_id),
%% 	timer:sleep(200),
	MailInfo#ets_users_mails{ id = Mail_ID}.


