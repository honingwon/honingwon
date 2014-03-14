%%%-------------------------------------------------------------------
%%% Module  : pt_15
%%% Author  : Administrator
%%% Created : 2011-3-18
%%% Description : 
%%%-------------------------------------------------------------------
-module(pt_15).

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
-export([read/2, write/2]).

%%====================================================================
%% External functions 
%%====================================================================

%% 创建摊位 completely
read(?PP_STALL_CREATE, Bin) ->
	{StallName,Bin1} = pt:read_string(Bin),
	<<LenSell:32,Bin2/binary>> = Bin1,
	[SellList,Bin3] = read_slist(LenSell,Bin2,[]),
	<<LenBuy:32,Bin4/binary>> = Bin3,
	BuyList = read_blist(LenBuy,Bin4,[]),
	{ok,[StallName,SellList,BuyList]};
%% 取消摊位 completely
read(?PP_STALL_CANCEL, _) ->
	{ok,[]};
%% 向摊位购买
read(?PP_STALL_BUY, <<RoleID:64, Len:32, Bin/binary>>) ->
    Buys = read_to_buy(Len, Bin, []),
	{ok,[RoleID, Buys]};
%% 向摊位出售
%read(?PP_STALL_SALE, <<RoleID:64, Len:32, Bin/binary>>) ->
read(?PP_STALL_SALE, Bin1) ->
	 <<RoleID:64, Len:32, Bin/binary>> = Bin1,
	Sales = read_to_sale(Len, Bin, []),
	{ok,[RoleID, Sales]};
%% 查询摊位 RoleID是摊主id completely
read(?PP_STALL_QUERY, <<RoleID:64>>) ->
	{ok,[RoleID]};
%% 摆摊留言
read(?PP_STALL_CHAT, <<UserId:64, Bin/binary>>) ->
	{Data,_} = pt:read_string(Bin),
	{ok, [UserId, Data]};
read(Cmd, ERROR) ->
 ?PRINT("error cmd ~ts:~p===>~p~n", [?MODULE, Cmd, ERROR]).


write(?PP_STALL_STATE_UPDATE, [RoleID, StallName]) ->
	StallNameBin = pt:write_string(StallName),
	Data = <<RoleID:64, StallNameBin/binary>>,
	{ok, pt:pack(?PP_STALL_STATE_UPDATE, Data)};
write(?PP_STALL_QUERY,[SellList, BuyList]) ->
	SellLen = length(SellList),
	SItem = fun(Info1) ->
					Info = Info1#r_stall_sells.sells_detail,
					SellPrice = Info1#r_stall_sells.price,
%% 					?PRINT("~ts:~p == ~p~n",["SellInfo", Info, SellPrice]),
							<<
							  (Info#ets_users_items.id):64,
							  (Info#ets_users_items.template_id):32,
							  (Info#ets_users_items.is_bind):8,
							  (Info#ets_users_items.strengthen_level):32,
						      (Info#ets_users_items.amount):32,
						      (Info#ets_users_items.place):32,
						      (Info#ets_users_items.create_date):32,
						      (Info#ets_users_items.state):32,
						      (Info#ets_users_items.enchase1):32,
						      (Info#ets_users_items.enchase2):32,
						      (Info#ets_users_items.enchase3):32,
						      (Info#ets_users_items.enchase4):32,
						      (Info#ets_users_items.enchase5):32,
							  (Info#ets_users_items.durable):32,
							  (Info#ets_users_items.other_data#item_other.sell_price):32,
							  SellPrice:32>>
		end,
	SellListBin = tool:to_binary([SItem(X)||X <- SellList]),	
	BuyLen = length(BuyList),
	BItem = fun(Info2) ->
					<<(Info2#r_stall_buys.id):32,
					  (Info2#r_stall_buys.price):32,
					  (Info2#r_stall_buys.num):32>>
			end,
	BuyListBin = tool:to_binary([BItem(Y)||Y <- BuyList]),	
	{ok,pt:pack(?PP_STALL_QUERY, <<SellLen:32, SellListBin/binary, BuyLen:32, BuyListBin/binary>>)};
write(?PP_STALL_CREATE, Result) ->
	{ok, pt:pack(?PP_STALL_CREATE, <<Result:8>>)};
write(?PP_STALL_CANCEL, Result) ->
	{ok, pt:pack(?PP_STALL_CANCEL, <<Result:8>>)};
write(?PP_STALL_BUY, Result) ->
	{ok, pt:pack(?PP_STALL_BUY, <<Result:8>>)};
write(?PP_STALL_SALE, Result) ->
	{ok, pt:pack(?PP_STALL_SALE, <<Result:8>>)};
write(?PP_STALL_UPDATE, List) ->
	Len = erlang:length(List),
	F = fun(H) ->
				  {TemplateId, Amount} = H,
				  <<TemplateId:32,
					Amount:32>>
		  end,
	Bin = tool:to_binary([ F(H) || H <- List ]),
	{ok,pt:pack(?PP_STALL_UPDATE, <<Len:32, Bin/binary>>)};
write(?PP_STALL_CHAT, [UserId, Nick, ChatMsg]) ->
	NickBin = pt:write_string(Nick),
	Now = misc_timer:now_seconds(),
	ChatMsgBin = pt:write_string(ChatMsg),
	{ok, pt:pack(?PP_STALL_CHAT,<<UserId:64, NickBin/binary, Now:32, ChatMsgBin/binary>>)};
write(?PP_STALL_LOG, [UserId, Nick, Type, List]) ->
	Len = erlang:length(List),
	NickBin = pt:write_string(Nick),
	Now = misc_timer:now_seconds(),
	
	F = fun(X) ->
				#ets_users_items{template_id=TemplateId, amount=Amount}= X,
				ItemTemplate = data_agent:item_template_get(TemplateId),
				Name = ItemTemplate#ets_item_template.name,
				NameBin = pt:write_string(Name),
				<<NameBin/binary,
				  Amount:32
				  >>
		end,
	ListBin = tool:to_binary([F(X)||X<-List]),
	{ok, pt:pack(?PP_STALL_LOG, <<UserId:64, NickBin/binary, Now:32, Type:32, Len:32, ListBin/binary>>)};

write(Cmd, ERROR) ->
	?PRINT("error cmd ~ts:~p===>~p~n", [?MODULE, Cmd, ERROR]).
	
%%====================================================================
%% Local functions 
%%====================================================================

read_slist(0,Bin,List) ->
	[lists:reverse(List), Bin];
read_slist(N,Bin,List) ->
	M = N-1,
	<<Place:32,Price:32,Bin1/binary>> = Bin,
	read_slist(M,Bin1,[{Place,Price}|List]).

read_blist(0,_Bin,List) ->
	lists:reverse(List);
read_blist(N,Bin,List) ->
 	M = N-1,
	<<TemplateId:32,Price:32,Amount:32,Bin1/binary>> = Bin,
	read_blist(M,Bin1,[{TemplateId,Price,Amount}|List]).

read_to_buy(0, _Bin, List) ->
	lists:reverse(List);
read_to_buy(N, Bin, List) ->
	M = N - 1,
	<<Place:32, Amount:32, Bin1/binary>> = Bin,
	read_to_buy(M, Bin1,[{Place, Amount}|List]).

read_to_sale(0, _Bin, List) ->
	lists:reverse(List);
read_to_sale(N, Bin, List) ->
	M = N - 1,
	<<Place:32, Amount:32, Bin1/binary>> = Bin,
	read_to_sale(M, Bin1, [{Place, Amount}|List]).
