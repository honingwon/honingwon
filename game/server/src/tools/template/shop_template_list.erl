%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to shop_template_list
-module(shop_template_list).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create/1]).


%%
%% API Functions
%%


create([Infos,Cates]) ->
	F = fun(Info, Acc) ->
		  Record = list_to_tuple([ets_shop_template] ++ Info),
	    	 case lists:keyfind(Record#ets_shop_template.shop_id, #ets_shop_template.shop_id, Acc) of
		  	 	false ->
			 	 	[Record|Acc];
		  	 	_ ->
	           		Acc
	    	 end
      	end,
    ShopList = lists:foldl(F, [], Infos),
	
	Len  = length(ShopList),
	FInfo = fun(Info) ->
					FShop="",      %%商店名称，因为用不到置空
					InitShopCateBin =initShopCate((Info#ets_shop_template.shop_id),Infos,Cates),
					
					<<(Info#ets_shop_template.shop_id):8,
					  (create_template_all:write_string(FShop))/binary,
                      InitShopCateBin/binary >>
			   end,
	    Bin = tool:to_binary([FInfo(X)||X <- ShopList]),
	{ok, <<Len:8, Bin/binary>>}.

%%
%% Local Functions
%% 

initShopCate(ShopId,Infos1,Cates1) ->
	F1 = fun(Info1,Acc1) ->
			Info	= list_to_tuple([ets_shop_template] ++ Info1),
	     	if ((Info#ets_shop_template.shop_id)==ShopId)  ->
		        case lists:keyfind(Info#ets_shop_template.category_id, #ets_shop_template.category_id, Acc1) of
		           false ->
			       		[Info|Acc1];
		           _ ->
	               		Acc1
				end;
		      true ->
                	Acc1
	     	end
      	end,
    ListCate = lists:foldr(F1, [], Infos1),
	
	FCate = fun(Info2)->
			list_to_tuple([ets_shop_category_template] ++ Info2)
			end,
	Cate2=[FCate(Q)||Q <- Cates1],
	
	CateLen = length(ListCate),
	FCateInfo = fun(CateInfo) ->
			Cate1=lists:keyfind(CateInfo#ets_shop_template.category_id, #ets_shop_category_template.category_id, Cate2),
%% 			case lists:keyfind(CateInfo#ets_shop_template.category_id, #ets_shop_category_template.category_id, Cate2) of
%% 				false ->
%% 					skip;
%% 				Cate1 ->
					<<(create_template_all:write_string(Cate1#ets_shop_category_template.name))/binary,
               	   (initShopItem(ShopId,(Cate1#ets_shop_category_template.category_id),Infos1))/binary >>
%% 			end
			   end,
	    CateBin = tool:to_binary([FCateInfo(Y)||Y <- ListCate]),
	<<CateLen:8, CateBin/binary>>.

initShopItem(ShopID2,CateID2,Infos2)->
	F2 = fun(Info,Acc2) ->
				Recordshop= list_to_tuple([ets_shop_template] ++ Info),
	     if ((Recordshop#ets_shop_template.shop_id)=:=ShopID2)  ->
		        if ((Recordshop#ets_shop_template.category_id)=:=CateID2)  ->
			       		[Recordshop|Acc2];
		           true ->
	              		 Acc2
				end;
		      true ->
                	Acc2
	     end
      end,
	  ShopItemList1 = lists:foldr(F2, [], Infos2),
	  ShopItemList = sorts_infos(ShopItemList1),
	
      ListItemLen=length(ShopItemList),
      ListItemInfo = fun(Info2)->
				 <<(Info2#ets_shop_template.id):32/signed,
				   (Info2#ets_shop_template.state):8,
                   (Info2#ets_shop_template.template_id):32/signed,
                   (Info2#ets_shop_template.pay_type):8,
				   (Info2#ets_shop_template.price):32,
				   (Info2#ets_shop_template.old_price):32>>
					end,

        ListItemBin = tool:to_binary([ListItemInfo(Q)||Q <- ShopItemList]),
       <<ListItemLen:16/signed,ListItemBin/binary>>.


sorts_infos(Infos) ->
	F = fun(Info1, Info2) ->
				if Info1#ets_shop_template.id >Info2#ets_shop_template.id ->
					   true;
				   true ->
					   false
				end
		end,
	lists:sort(F, Infos).


