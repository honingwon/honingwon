%%%-----------------------------------
%%% @Module  : pt_16
%%% @Created : 2011.03.08
%%% @Description: 聊天信息
%%%-----------------------------------
-module(pt_16).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%


%%聊天信息
read(?PP_CHAT, <<Channel:8, Bin/binary>>) ->
    {Nick, Bin1} = pt:read_string(Bin),
	<<UserID:64, Sex:32, Bin2/binary>> = Bin1,
	{ToNick, Bin3} = pt:read_string(Bin2), 
	<<ToUserID:64, Bin4/binary>> =	Bin3,
	{Msg, _} = pt:read_string(Bin4),
    {ok, [Channel, Nick, UserID, Sex, ToNick, ToUserID, Msg]};
%% 银行投资购买
read(?PP_BANK_BUY, <<Type:32>>) ->
	{ok, [Type]};

%% 银行投资红利领取
read(?PP_BANK_GET, <<Type:32>>) ->
	{ok, [Type]};

%% 获取银行投资信息
read(?PP_BANK_LIST, _) ->
	{ok, []};

read(_Cmd, _R) ->
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%%聊天信息
write(?PP_CHAT, [Channel, VipID, Nick, UserID, Sex, ToNick, ToUserID, Msg]) ->
	NickBin = pt:write_string(Nick),
	ToNickBin = pt:write_string(ToNick),
	MsgBin = pt:write_string(Msg),
	Data = <<Channel:8,
			 VipID:16,
			 NickBin/binary,
			 UserID:64,
			 Sex:32,
			 ToNickBin/binary,
			 ToUserID:64,
			 MsgBin/binary>>,
	{ok, pt:pack(?PP_CHAT, Data)};

%%系统消息
write(?PP_SYS_MESS,[Type, Code, Color, Msg]) ->
	MsgBin = pt:write_string(Msg),
	Data = <<Type:16,
			 Code:32,
			 Color:8,
			 MsgBin/binary>>,
	{ok, pt:pack(?PP_SYS_MESS, Data)};

%% 银行投资购买
write(?PP_BANK_BUY, State) ->
	{ok, pt:pack(?PP_BANK_BUY, <<State:8>>)};

%% 银行投资红利领取
write(?PP_BANK_GET, State) ->
	{ok, pt:pack(?PP_BANK_GET, <<State:8>>)};

%% 获取银行投资信息
write(?PP_BANK_LIST, List) ->
	N = length(List),
	F = fun(Info,Bin) ->
			<<Bin/binary,
			(Info#ets_user_bank.type):16,
			(Info#ets_user_bank.money):32,
			(Info#ets_user_bank.state):32,
			(Info#ets_user_bank.add_time):32
			>> 
		end,
	BinData = lists:foldl(F, <<>>, List),
	{ok, pt:pack(?PP_BANK_LIST, <<N:16,BinData/binary>>)};

write(Cmd, _R) ->
	?WARNING_MSG("~s_errorcmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.



