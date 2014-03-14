%%%-------------------------------------------------------------------
%%% Module  : pt_27
%%% Author  : Administrator
%%% Created : 2011-4-6
%%% Description : 寄售系统
%%%-------------------------------------------------------------------
-module(pt_22).


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

%%
%%客户端 -> 服务端 ----------------------------
%%
%%-----------------------------------------
%%添加寄售铜币、元宝
%%----------------------------------------
read(?PP_SALES_MONEY_ADD, <<SaleType:32, Amount:32, Price:32, ValidTime:32>>) ->
	{ok, [SaleType, Amount, Price, ValidTime]};

%% --------------------------------------------
%% 添加寄售物品
%% --------------------------------------------
read(?PP_SALES_ITEM_ADD, <<Place:32, PriceType:32, Price:32, ValidTime:32>>) ->
	{ok, [Place, PriceType, Price, ValidTime]};
%% --------------------------------------------
%% 撤消寄售物品
%% --------------------------------------------
read(?PP_SALES_ITEM_DELETE, <<SaleId:64, Page:32>>) ->
	{ok, [SaleId, Page]};
%% --------------------------------------------
%% 购买寄售物品
%% --------------------------------------------
read(?PP_SALES_ITEM_BUY, <<SaleId:64>>) ->
	{ok, [SaleId]};
%% --------------------------------------------
%% 查找寄售物品
%% --------------------------------------------
read(?PP_SALES_ITEM_QUERY, <<Type:32, Career:32, Quality:32/signed, LowLevel:32, UpLevel:32, Bin/binary>>) ->
	{KeyName, Bin1} = pt:read_string(Bin),
	<<Len:32, Bin2/binary>> = Bin1,
	{CategoryList, Bin3} = read_category_list(Bin2, Len, []),
	<<Page:32, _Bin4/binary>> = Bin3,		
	{ok, [Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page]};
%% --------------------------------------------
%% 查看已寄售物品（我的寄售）
%% --------------------------------------------
read(?PP_SALES_ITEM_QUERY_SELF, <<Page:32>>) ->
	{ok, [Page]};

%% --------------------------------------------
%% 再售
%% --------------------------------------------
read(?PP_SALES_SALE_AGAIN, <<SaleId:64>>) ->
	{ok, [SaleId]};
read(Cmd, Bin) ->
	?WARNING_MSG("~p read:~p ,is not match:~p",[?MODULE, Cmd, Bin]).

%%
%%服务端 -> 客户端 ----------------------------
%%
%% ---------------------------------------------
%% 再售成功与否
%%---------------------------------------------
write(?PP_SALES_SALE_AGAIN, [Result, Msg]) ->
	MsgBin = pt:write_string(Msg),
	{ok, pt:pack(?PP_SALES_SALE_AGAIN, <<Result:8, MsgBin/binary>>)};

%% --------------------------------------------
%% 返回取消寄售成功与否
%% ---------------------------------------------
write(?PP_SALES_ITEM_DELETE, [Result, Msg]) ->
	MsgBin = pt:write_string(Msg),
	{ok, pt:pack(?PP_SALES_ITEM_DELETE, <<Result:8, MsgBin/binary>>)};
%% --------------------------------------------
%% 返回添加寄售成功与否
%% ---------------------------------------------
write(?PP_SALES_MONEY_ADD, [Result]) ->
	{ok, pt:pack(?PP_SALES_MONEY_ADD, <<Result:8>>)};
%% --------------------------------------------
%% 返回添加寄售成功与否
%% ---------------------------------------------
write(?PP_SALES_ITEM_ADD, Result) ->
	{ok, pt:pack(?PP_SALES_ITEM_ADD, <<Result:8>>)};
%% -----------------------------------------------
%% 更新寄售物品
%% -----------------------------------------------
write(?PP_SALES_ITEM_UPDATE, _SalesList) ->
	{ok};
%% -----------------------------------------------
%% 返回查找寄售物品
%% -----------------------------------------------
write(?PP_SALES_ITEM_QUERY, [Sum, Page, SaleList]) ->
	case Sum =:= 0 of
		true ->
			{ok, pt:pack(?PP_SALES_ITEM_QUERY, <<Sum:32>>)};
		false ->
			BinData = write_query(SaleList, 0),
			{ok, pt:pack(?PP_SALES_ITEM_QUERY, <<Sum:32, Page:32, BinData/binary>>)}
	end;	
%% -----------------------------------------------
%% 返回查看已寄售物品（我的寄售）
%% -----------------------------------------------
write(?PP_SALES_ITEM_QUERY_SELF, [Sum, Page, SaleList]) ->
	case Sum == 0 of
		true -> {ok, pt:pack(?PP_SALES_ITEM_QUERY_SELF, <<Sum:32>>)};
		false ->
			BinData = write_query(SaleList, 1),
			{ok, pt:pack(?PP_SALES_ITEM_QUERY_SELF, <<Sum:32, Page:32, BinData/binary>>)}
	end;
%% -----------------------------------------------
%% 返回购买寄售物品是否成功
%% -----------------------------------------------
write(?PP_SALES_ITEM_BUY, [Result, SaleId]) ->
	{ok, pt:pack(?PP_SALES_ITEM_BUY, <<Result:8, SaleId:64>>)};
write(Cmd, Info) ->
	?WARNING_MSG("~p write:~p ,is not match:~p",[?MODULE, Cmd, Info]).

%%====================================================================
%% Local functions 
%%====================================================================
read_category_list(Bin, 0, List) ->
	{List, Bin};
read_category_list(Bin, Len, List) ->
	<<CategoryId:32, Bin1/binary>> = Bin,
	read_category_list(Bin1, Len - 1, [CategoryId|List]).

write_query(SaleList, IsSelf) ->
	Len = length(SaleList),

	F = fun(Sale) ->

				Id = Sale#ets_users_sales.id,
				Type = Sale#ets_users_sales.type,
				Amount = Sale#ets_users_sales.amount,
				Price = Sale#ets_users_sales.unit_price,
				PriceType = Sale#ets_users_sales.price_type,
				ItemBin = 
					case Type of
						1 -> %% 寄售类型为物品
							Item = Sale#ets_users_sales.other_data,
							pt:packet_item(Item);
						_ -> %% 寄售的是货币
							<<>>
					end,
				case IsSelf of
					1 ->
						StartTime = Sale#ets_users_sales.start_time,
						ValidTime = Sale#ets_users_sales.valid_time * 3600,
						Now = misc_timer:now_seconds(),
						KeepTime = 72 * 60 * 60,
						LeftTime = StartTime + ValidTime - Now,
						RemainTime = 
							if  LeftTime > 0 ->
								   0;
							   true ->
								   KeepTime + LeftTime
							end,
						<<Id:64,
				  		  Type:32,
				  		  Amount:32,
				  		  Price:32,
						  PriceType:32,
 				  		  RemainTime:32,
				  		  ItemBin/binary>>;
					0 ->
						<<Id:64,
						  Type:32,
						  Amount:32,
						  Price:32,
						  PriceType:32,
						  ItemBin/binary>>
				end
		end,
	SaleListBin = tool:to_binary([F(I) || I <- SaleList]),
	<<Len:32, SaleListBin/binary>>.

%% 
%% write_sale_item(Item) ->
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
%% 				SellPrice = Item#ets_users_items.other_data#item_other.sell_price,
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
%% 				  >>.

				