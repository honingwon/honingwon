%%%-------------------------------------------------------------------
%%% Module  : pt_27
%%% Author  : Administrator
%%% Created : 2011-4-15
%%% Description : 直接交易
%%%-------------------------------------------------------------------
-module(pt_27).



%%--------------------------------------------------------------------
%% Include files 
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports 
%%--------------------------------------------------------------------
-export([
		 read/2,
		 write/2
		 ]).

%%====================================================================
%% External functions 
%%====================================================================
%% --------------------------------------------------------------
%% 27001 发起直接交易请求
%% --------------------------------------------------------------
read(?PP_TRADE_REQUEST, <<UserId:64>>) ->
	{ok, [UserId]};
%% --------------------------------------------------------------
%% 27003 同意直接交易请求
%% --------------------------------------------------------------
read(?PP_TRADE_ACCEPT, <<Result:8, UserId:64>>) ->
	{ok, [Result, UserId]};
%% --------------------------------------------------------------
%% 27005 添加交易物品、货币
%% --------------------------------------------------------------
read(?PP_TRADE_ITEM_ADD, <<Type:32, UserId:64, Param:32>>) ->
	{ok, [Type, UserId, Param]};
read(?PP_TRADE_LOCK, _) ->
	{ok, []};
read(?PP_TRADE_SURE, _) ->
	{ok, []};
read(?PP_TRADE_CANCEL, _) ->
	{ok, []};
read(?PP_TRADE_ITEM_REMOVE, <<Place:32>>) ->
	{ok, [Place]};
read(?PP_TRADE_COPPER, <<Amount:32>>) ->
	{ok, [Amount]};
%% --------------------------------------------------------------
%% 未定义交易协议
%% --------------------------------------------------------------

read(Cmd, Bin) ->
	?WARNING_MSG("~p read:~p ,is not match:~p",[?MODULE, Cmd, Bin]).

write(?PP_TRADE_COPPER, [Amount]) ->
	{ok, pt:pack(?PP_TRADE_COPPER, <<Amount:32>>)};

write(?PP_TRADE_ITEM_REMOVE, [Result, Place]) ->
	{ok, pt:pack(?PP_TRADE_ITEM_REMOVE, <<Result:8, Place:32>>)};
write(?PP_TRADE_ITEM_ADD, [Result, Place]) ->
	{ok, pt:pack(?PP_TRADE_ITEM_ADD, <<Result:8, Place:32>>)};
write(?PP_TRADE_CANCEL, [Type]) ->
	{ok, pt:pack(?PP_TRADE_CANCEL, <<Type:8>>)};
write(?PP_TRADE_CANCEL_RESPONSE, [Type]) ->
	{ok, pt:pack(?PP_TRADE_CANCEL_RESPONSE, <<Type:8>>)};
write(?PP_TRADE_SURE_RESPONSE, []) ->
	{ok, pt:pack(?PP_TRADE_SURE_RESPONSE, <<>>)};

write(?PP_TRADE_SURE, [Result]) ->
	{ok, pt:pack(?PP_TRADE_SURE, <<Result:8>>)};
write(?PP_TRADE_START, [UserId, Nick]) ->
	NickBin = pt:write_string(Nick),
	{ok, pt:pack(?PP_TRADE_START, <<UserId:64, NickBin/binary>>)};
write(?PP_TRADE_ACCEPT, [Result]) ->
	{ok, pt:pack(?PP_TRADE_ACCEPT, <<Result:8>>)};
%% --------------------------------------------------------------
%% 27002 返回发出交易请求是否成功
%% --------------------------------------------------------------
write(?PP_TRADE_REQUEST, [Result]) ->
	{ok, pt:pack(?PP_TRADE_REQUEST, <<Result:32>>)};	
%% --------------------------------------------------------------
%% 27002 通知对方收到交易请求
%% --------------------------------------------------------------
write(?PP_TRADE_REQUEST_RESPONSE, [UserId, NickName]) ->
	NickNameBin = pt:write_string(NickName),
	{ok, pt:pack(?PP_TRADE_REQUEST_RESPONSE, <<UserId:64, NickNameBin/binary>>)};%%0代表serverID

%% --------------------------------------------------------------
%% 27004 通知同意直接交易请求
%% --------------------------------------------------------------
write(?PP_TRADE_ACCEPT_RESPONSE, [Result,UserId, NickName]) ->
	NickNameBin = pt:write_string(NickName),
	{ok, pt:pack(?PP_TRADE_ACCEPT_RESPONSE, <<Result:16, UserId:64, NickNameBin/binary>>)};
%% --------------------------------------------------------------
%% 27005 通知添加交易物品、货币
%% --------------------------------------------------------------
write(?PP_TRADE_ITEM_ADD_RESPONSE, [ItemInfo]) ->
	ItemInfoBin = pt:packet_item(ItemInfo),
	{ok, pt:pack(?PP_TRADE_ITEM_ADD_RESPONSE, <<ItemInfoBin/binary>>)};

write(?PP_TRADE_ITEM_REMOVE_RESPONSE, [ItemId]) ->
	{ok, pt:pack(?PP_TRADE_ITEM_REMOVE_RESPONSE, <<ItemId:64>>)};

write(?PP_TRADE_LOCK_RESPONSE, []) ->
	{ok, pt:pack(?PP_TRADE_LOCK_RESPONSE, <<>>)};
write(?PP_TRADE_RESULT, [Result]) ->
	{ok, pt:pack(?PP_TRADE_RESULT, <<Result:8>>)};
%% --------------------------------------------------------------
%% 未定义交易协议
%% --------------------------------------------------------------

write(Cmd, Info) ->
	?WARNING_MSG("~p write:~p ,is not match:~p",[?MODULE, Cmd, Info]).
%%====================================================================
%% Local functions 
%%====================================================================