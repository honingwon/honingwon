%%%-------------------------------------------------------------------
%%% Module  : pp_chat
%%% Author  : 
%%% Description : 聊天
%%%-------------------------------------------------------------------
-module(pp_chat).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================
-define(CHAT_WORLD, 1).	%% 世界
-define(CHAT_CAMP, 2).		%% 阵营
-define(CHAT_GUILD, 3).	%% 帮派
-define(CHAT_TEAM, 4).		%% 组队
-define(CHAT_NEARBY, 5).	%% 附近
-define(CHAT_BUGLE, 6).	%% 喇叭
-define(CHAT_FRIEND, 8).	%% 好友
-define(CHAT_PRIVATE, 100).	%% 私聊，预留


%%处理聊天信息
handle(?PP_CHAT, Status, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered1])  -> 	
	case lib_gm_cmd:get_gm_cmd(Data_filtered1) of
		false ->
			Data_filtered = lib_words_ver:words_filter([Data_filtered1]),
			{Can_chat, NewStatus}= lib_chat:check_donttalk(Status),
			if
				Can_chat ->    
				   case Channel of
					   ?CHAT_WORLD ->
						    lib_chat:chat_world(NewStatus, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{ok, NewStatus};
					   ?CHAT_CAMP ->
						   	{ok, NewStatus};
					   ?CHAT_GUILD ->
						   	lib_chat:chat_guild(NewStatus, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{ok, NewStatus}; 
					   ?CHAT_TEAM ->
						   	lib_chat:chat_team(NewStatus, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{ok, NewStatus}; 
					   ?CHAT_NEARBY ->
						   	lib_chat:chat_nearby(NewStatus, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{ok, NewStatus}; 
					   ?CHAT_BUGLE ->
						   	NewStatus1 = lib_chat:chat_bugle(NewStatus, [Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{update,NewStatus1};
					   ?CHAT_FRIEND ->
						   	lib_chat:chat_private(NewStatus,[Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{ok,NewStatus};
					   ?CHAT_PRIVATE ->
						   	lib_chat:chat_private(NewStatus,[Channel,Nick,UserID,Sex,ToNick,ToUserID,Data_filtered]),
							{ok,NewStatus};
					   _ ->
						   {ok,NewStatus}
				   end;
			   true ->
				   lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,
											 ?ALTER,?None,?ORANGE,?_LANG_CHAT_BAN]),
					{ok,NewStatus}
			end;
		{Cmd, Par} ->
				lib_gm_cmd:exe_gm_cmd(Status, Cmd, Par)
	end;
%% 银行投资购买
handle(?PP_BANK_BUY, Status, [Type]) ->
	case lib_bank:buy_bank(Type, Status) of
		{error,ErrStr} ->
			lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,ErrStr]),
			{ok,Bin} = pt_16:write(?PP_BANK_BUY, 0),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin);
		{ok,Record,NeedYuanbao,BackMoney} ->
			Status2 = lib_player:add_cash_and_send(Status, 0, util:ceil(BackMoney), 0, 0, {?GAIN_MONEY_BANK_GET,Type,0}),
			Status1 = lib_player:reduce_cash_and_send(Status2, NeedYuanbao, 0, 0, 0,{?CONSUME_YUANBAO_BANK_BUY,Type,1}),
			NewBankList = [Record|Status1#ets_users.other_data#user_other.bank_list],
			NewOther = Status1#ets_users.other_data#user_other{bank_list = NewBankList},
			NewStatus = Status1#ets_users{other_data = NewOther},
			{ok,BinList} = pt_16:write(?PP_BANK_LIST, NewBankList),
			{ok,Bin} = pt_16:write(?PP_BANK_BUY, 1),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, <<BinList/binary,Bin/binary>>),
			{ok,NewStatus}
	end;
%% 银行投资红利领取
handle(?PP_BANK_GET, Status, [Type]) ->
	case lib_bank:get_bank_award(Type, Status) of
		{error,ErrStr} ->
			lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,ErrStr]),
			{ok,Bin} = pt_16:write(?PP_BANK_GET, 0),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin);
		{ok,Record,AwardMoney} ->
			Status1 = lib_player:add_cash_and_send(Status, 0, util:ceil(AwardMoney), 0, 0,{?GAIN_MONEY_BANK_GET,Type,1}),
			NewBankList = lists:keyreplace(Type, #ets_user_bank.type, 
									Status#ets_users.other_data#user_other.bank_list, Record),
			NewOther = Status1#ets_users.other_data#user_other{bank_list = NewBankList},
			NewStatus = Status1#ets_users{other_data = NewOther},
			{ok,BinList} = pt_16:write(?PP_BANK_LIST, NewBankList),
			{ok,Bin} = pt_16:write(?PP_BANK_GET, 1),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, <<BinList/binary,Bin/binary>>),
			{ok,NewStatus}	
	end;
%% 获取银行投资信息
handle(?PP_BANK_LIST, Status, []) ->
	{ok,Bin} = pt_16:write(?PP_BANK_LIST, Status#ets_users.other_data#user_other.bank_list),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin);
	
handle(_Cmd, _Status, _Data) ->
    {error, "pp_chat no match"}.



%%====================================================================
%% Private functions
%%====================================================================

