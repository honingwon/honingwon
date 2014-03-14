%% Author: Administrator
%% Created: 2011-3-10
%% Description: TODO: Add description to lib_shop
-module(lib_shop).

-include("common.hrl").
-export([
		 init_template_shop/0,
		 update_shop_dic/1,
		 get_discount_item_by_id/1,
%% 		 get_shop_discount_by_day/1,
%% 		 get_discount_start_server/1,
%% 		 update_discount_dic/1,
		 update_shop_info/1,
		 fetch_shop_discount/0,
		 get_user_discounts/1,
		 update_user_discounts/2,
		 get_user_guild_shop/1,
		 get_user_guild_shop_dic/0,
		 update_user_guild_shop/2
		]).

-define(DIC_SHOP_DISCOUNT_TEMP, dic_shop_discount_template).%%优惠商品模板字典
-define(DIC_SHOP_DISCOUNT, dic_shop_discount).				%%优惠商品信息字典
-define(DIC_SHOP_USER_DISCOUNT, dic_shop_user_discount).	%%用户购买商品信息字典

-define(DIC_SHOP_USER_GUILD, dic_shop_user_guild).	%%用户购买公会商品信息字典

-define(FLAG_START_SERVER, 1).%%开服标志
-define(FLAG_START_ACTIVITY, 2).%%活动标志

-record(user_shop_items,{
							user_id = 0,		%%用户ID
							date = 0,			%% 最后更新时间
							shop_items = []		%%购买优惠商品信息
						}).
%%
%% API Functions
%%
init_template_shop() ->
	ok = init_shop_discount_template(),
	ok = init_shop_npc_template(),
	ok = init_shop_discount(),
	ok.

init_shop_discount_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_shop_discount_template] ++ Info),
                  ets:insert(?ETS_SHOP_DISCOUNT_TEMPLATE, Record)
           end,
    case db_agent_template:get_shop_discount_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.

init_shop_npc_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_shop_npc_template] ++ Info),
                  ets:insert(?ETS_SHOP_NPC_TEMPLATE, Record)
           end,
    case db_agent_template:get_shop_npc_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
    ok.

init_shop_discount() ->
	F = fun(Info) ->
				list_to_tuple([ets_shop_discount] ++ Info)
           end,
    case db_agent_shop:get_shop_discount() of
        [] -> skip;
        List when is_list(List) ->
			put(?DIC_SHOP_DISCOUNT, [F(X)|| X <- List]);
        _ -> skip
    end,
	ok.
%%===================进程字典辅助函数=======================
update_discount_dic(DiscountInfo) ->
	case is_record(DiscountInfo, ets_shop_discount) of
		true ->
			List = get_discount_dic(),
			List1 = lists:keydelete(DiscountInfo#ets_shop_discount.shop_id, #ets_shop_discount.shop_id, List),
			put(?DIC_SHOP_DISCOUNT, [DiscountInfo|List1]);
		_ ->
			?WARNING_MSG("update_discount_dic",[DiscountInfo])
	end,
	ok.

get_discount_dic()->
	case get(?DIC_SHOP_DISCOUNT) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

get_discount_by_id(ItemId) ->
	List = get_discount_dic(),
	case lists:keyfind(ItemId, #ets_shop_discount.shop_id, List) of
		false ->
			[];
		Item ->
			Item
	end.
%%-----------------------------------------------
get_ets_list(Tab, Pattern) ->
    L = ets:match_object(Tab, Pattern),
    case is_list(L) of
        true -> L;
        false -> []
    end.

update_shop_dic(Info) ->
	case is_record(Info, ets_shop_discount_template) of
		true ->	
			List = get_shop_dic(),
			NewList = 
				case lists:keyfind(Info#ets_shop_discount_template.id, #ets_shop_discount_template.id, List) of
					false ->
						Other = Info#ets_shop_discount_template.other_data#other_discount{dirty_state=2},
						NewInfo = Info#ets_shop_discount_template{other_data=Other},
						[NewInfo|List];
					Old when  Old#ets_shop_discount_template.other_data#other_discount.dirty_state < 1 ->
						List1 = lists:keydelete(Info#ets_shop_discount_template.id, #ets_shop_discount_template.id, List),
						Other = Info#ets_shop_discount_template.other_data#other_discount{dirty_state=1},
						NewInfo = Info#ets_shop_discount_template{other_data=Other},			
			    		[NewInfo|List1];
					Old ->
						List1 = lists:keydelete(Info#ets_shop_discount_template.id, #ets_shop_discount_template.id, List),	
						Other = Info#ets_shop_discount_template.other_data#other_discount{dirty_state=Old#ets_shop_discount_template.other_data#other_discount.dirty_state},
						NewInfo = Info#ets_shop_discount_template{other_data=Other},
					    [NewInfo|List1]
				end,
			put(?DIC_SHOP_DISCOUNT_TEMP, NewList),
			ok;
		_ ->
			?WARNING_MSG("update_dic:~w", [Info]),
			skip
	end.

get_shop_dic() ->
	case get(?DIC_SHOP_DISCOUNT_TEMP) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

get_discount_item_by_id(ItemId) ->
	List = get_shop_dic(),
	case lists:keyfind(ItemId, #ets_shop_discount_template.id, List) of
		false ->
			[];
		Info ->
			Info
	end.

update_shop_info(ShopInfo) ->
	update_shop_dic(ShopInfo),
	Discounts = get_discount_dic(),
	Now = misc_timer:now_seconds(),
	{Today, _NextDay} = util:get_midnight_seconds(Now),
	FinishTime = Today+ShopInfo#ets_shop_discount_template.finish_time,
	case lists:keyfind(ShopInfo#ets_shop_discount_template.id, #ets_shop_discount.shop_id, Discounts) of
		false ->
			DiscountInfo = #ets_shop_discount{shop_id=ShopInfo#ets_shop_discount_template.id,
										   surplus_count=ShopInfo#ets_shop_discount_template.other_data#other_discount.left_count,
										   finish_time=FinishTime},
			update_discount_dic(DiscountInfo),
			db_agent_shop:create_discount(DiscountInfo);
		Discount ->
			NewDiscount = #ets_shop_discount{surplus_count=ShopInfo#ets_shop_discount_template.other_data#other_discount.left_count,
										   finish_time=FinishTime},
			update_discount_dic(NewDiscount),
			db_agent_shop:update_discount([{surplus_count,NewDiscount#ets_shop_discount.surplus_count},
										   {finish_time, FinishTime}],
										  [{shop_id,ShopInfo#ets_shop_discount_template.id}])
	end.

%% 获取当天优惠商品信息
get_shop_discount_by_day(Day) ->
	Pattern = #ets_shop_discount_template{which_day=Day, _='_'},
	case Day < 1 orelse Day > 7 of
		true ->
			[];
		_ ->
			get_ets_list(?ETS_SHOP_DISCOUNT_TEMPLATE, Pattern)
	end.

%%获取开服前几天优惠商品
get_discount_start_server(DiffDates) ->
	Pattern = #ets_shop_discount_template{type=?FLAG_START_SERVER, dates=DiffDates+1, _='_'},
	get_ets_list(?ETS_SHOP_DISCOUNT_TEMPLATE, Pattern).

%% 获取活动优惠商品
get_discount_by_activity() ->
	Now = misc_timer:now_seconds(),
	Pattern = #ets_shop_discount_template{type=?FLAG_START_ACTIVITY, _='_'},
	List = get_ets_list(?ETS_SHOP_DISCOUNT_TEMPLATE, Pattern),
	F = fun(Elem,AccIn) ->
				BeginDate = tool:date_to_unix(tool:to_list(Elem#ets_shop_discount_template.start_date)),
				EndDate = tool:date_to_unix(tool:to_list(Elem#ets_shop_discount_template.finish_date)),
				case Now >= BeginDate andalso Now =< EndDate of
					true ->
						[Elem|AccIn];
					_ ->
						AccIn
				end
		end,
	lists:foldl(F, [], List).
	


%% 商城优惠物品
fetch_shop_discount() ->
	Now = misc_timer:now_seconds(),
	case util:get_diff_days(config:get_service_start_time(), Now) of
		DiffDates when DiffDates =< 7 ->
			case get_discount_start_server(DiffDates) of
				[] ->
					fetch_shop_discount_1(Now);
				ShopItems ->
					fetch_shop_discount4(DiffDates, ShopItems)
			end;
		_ ->
			fetch_shop_discount_1(Now)
	end.

fetch_shop_discount_1(Now) ->
	case get_discount_by_activity() of
		[] ->
			fetch_shop_discount1(Now);
		ShopItems ->
			fetch_shop_discount4_1(ShopItems)
	end.


%% 获取非活动时间段的优惠物品
fetch_shop_discount1(Now) ->
	{Date, _Time} = util:seconds_to_localtime(Now),
	Day = calendar:day_of_the_week(Date),
	case get_shop_discount_by_day(Day) of
		[] ->
			{error, "error: no discount goods"};
		ShopItems ->
			fetch_shop_discount2(Now, ShopItems)
	end.

fetch_shop_discount2(Now, ShopItems) ->
	Fun = fun(Elem, AccIn) ->
		BeginDate = tool:date_to_unix(tool:to_list(Elem#ets_shop_discount_template.start_date)),
		EndDate = tool:date_to_unix(tool:to_list(Elem#ets_shop_discount_template.finish_date)),
		case Now >= BeginDate andalso Now =< EndDate of
			true ->
				fetch_shop_discount3(Elem, AccIn);
			_ ->
				AccIn
		end
	end,
	{ok, lists:foldl(Fun, [], ShopItems)}.

fetch_shop_discount3(Elem, AccIn) ->
	CurrSeconds = util:get_today_current_second(),
	if Elem#ets_shop_discount_template.start_time > CurrSeconds ->
			ElemOther = #other_discount{cheap_type=1, left_time=0,left_count=Elem#ets_shop_discount_template.max_count},
			NewElem = Elem#ets_shop_discount_template{other_data = ElemOther},
			[NewElem|AccIn];
		Elem#ets_shop_discount_template.finish_time < CurrSeconds ->
			ElemOther = #other_discount{cheap_type=0, left_time=0,left_count=Elem#ets_shop_discount_template.max_count},
			NewElem = Elem#ets_shop_discount_template{other_data = ElemOther},
			[NewElem|AccIn];
		true ->
			LeftTime = Elem#ets_shop_discount_template.finish_time-CurrSeconds,
			NewElem = fetch_shop_discount5(Elem, LeftTime),
			update_shop_info(NewElem),
			[NewElem|AccIn]
	end.


fetch_shop_discount4(DiffDates, ShopItems) ->
	CurrSeconds = util:get_today_current_second(),
	Fun = fun(Elem, AccIn) ->
		case Elem#ets_shop_discount_template.dates =:= (DiffDates+1) of
			true ->
				LastElem = 
					if Elem#ets_shop_discount_template.start_time > CurrSeconds ->
						   	ElemOther = #other_discount{cheap_type=0, left_time=0,left_count=Elem#ets_shop_discount_template.max_count},
							Elem#ets_shop_discount_template{other_data = ElemOther};
						Elem#ets_shop_discount_template.finish_time < CurrSeconds ->
		  					ElemOther = #other_discount{cheap_type=1, left_time=0,left_count=Elem#ets_shop_discount_template.max_count},
							Elem#ets_shop_discount_template{other_data = ElemOther};
						true ->
							LeftTime = Elem#ets_shop_discount_template.finish_time-CurrSeconds,
							NewElem = fetch_shop_discount5(Elem, LeftTime),
							update_shop_info(NewElem),
							NewElem
		  			end,
				[LastElem|AccIn];
			_ ->
				AccIn
		end
	end,
	{ok, lists:foldl(Fun, [], ShopItems)}.


fetch_shop_discount4_1(ShopItems) ->
	CurrSeconds = util:get_today_current_second(),
	Fun = fun(Elem, AccIn) ->
			LastElem = 
				if Elem#ets_shop_discount_template.start_time > CurrSeconds ->
					   	ElemOther = #other_discount{cheap_type=0, left_time=0,left_count=Elem#ets_shop_discount_template.max_count},
						Elem#ets_shop_discount_template{other_data = ElemOther};
					Elem#ets_shop_discount_template.finish_time < CurrSeconds ->
	  					ElemOther = #other_discount{cheap_type=1, left_time=0,left_count=Elem#ets_shop_discount_template.max_count},
						Elem#ets_shop_discount_template{other_data = ElemOther};
					true ->
						LeftTime = Elem#ets_shop_discount_template.finish_time-CurrSeconds,
						NewElem = fetch_shop_discount5(Elem, LeftTime),
						update_shop_info(NewElem),
						NewElem
	  			end,
			[LastElem|AccIn]
	end,
	{ok, lists:foldl(Fun, [], ShopItems)}.


fetch_shop_discount5(ShopItem, LeftTime) ->
	NowSeconds = misc_timer:now_seconds(),
	LeftCount = 
		case get_discount_by_id(ShopItem#ets_shop_discount_template.id) of
			[] -> 
				ShopItem#ets_shop_discount_template.max_count;
			Item ->
				case Item#ets_shop_discount.finish_time =< NowSeconds of
					true ->
						ShopItem#ets_shop_discount_template.max_count;
					_ ->
						Item#ets_shop_discount.surplus_count
				end
		end,
	NewLeftTime = 
		case LeftTime < 0 of
			true -> 0;
			_ -> LeftTime
		end,
	case get_discount_item_by_id(ShopItem#ets_shop_discount_template.id) of
		[] ->
			ElemOther = #other_discount{cheap_type=1, left_time=NewLeftTime, left_count=LeftCount},
			ShopItem#ets_shop_discount_template{other_data = ElemOther};
		Info ->
			ElemOther = Info#ets_shop_discount_template.other_data#other_discount{cheap_type=1, left_time=NewLeftTime},
			if ShopItem#ets_shop_discount_template.other_data#other_discount.left_time < 1
			 	orelse ShopItem#ets_shop_discount_template.other_data#other_discount.left_count < 1 ->
					NewOther = ElemOther#other_discount{left_count=LeftCount};
				true ->
				    NewOther = ElemOther
			end,
			Info#ets_shop_discount_template{other_data = NewOther}
	end.

get_user_discounts(UserId)->
	Now = misc_timer:now_seconds(),
	List = get_user_discount_dic(),
	
	case lists:keyfind(UserId, #user_shop_items.user_id, List) of
		false ->
			[];
		Old ->
			DiffDay = util:get_diff_days(Now,Old#user_shop_items.date),
			if
				DiffDay =/= 0 ->
					 New = Old#user_shop_items{date = Now,shop_items = [] },
					 List1 = lists:keydelete(UserId, #user_shop_items.user_id, List),
					 put(?DIC_SHOP_USER_DISCOUNT, [New|List1]),
					 [];
				 true ->
					 Old#user_shop_items.shop_items
			end
	end.

get_user_discount_dic() ->
	case get(?DIC_SHOP_USER_DISCOUNT) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

update_user_discounts(DiscountItem, UserId) ->
	Now = misc_timer:now_seconds(),
	case is_record(DiscountItem, discount_items) of
		true ->	
			List = get_user_discount_dic(),
			NewList = 
				case lists:keyfind(UserId, #user_shop_items.user_id, List) of
					false ->
						NewUserShopItem = #user_shop_items{user_id=UserId, shop_items=[DiscountItem],date = Now},
						[NewUserShopItem|List];
					Old ->
						ShopItems = Old#user_shop_items.shop_items,
						NewShopItems = 
							case lists:keyfind(DiscountItem#discount_items.item_id, #discount_items.item_id, ShopItems) of
								false ->
									[DiscountItem|ShopItems];
								OldShopItem ->
									NewShopItem = 
										case OldShopItem#discount_items.finish_time =/= DiscountItem#discount_items.finish_time 
											andalso OldShopItem#discount_items.finish_time =< Now of
											true -> 
												OldShopItem#discount_items{item_count=DiscountItem#discount_items.item_count,
																		  finish_time=DiscountItem#discount_items.finish_time};
											_ ->
												ItemCount = OldShopItem#discount_items.item_count+DiscountItem#discount_items.item_count,
												OldShopItem#discount_items{item_count=ItemCount}
										end,
									ShopItems1 = lists:keydelete(DiscountItem#discount_items.item_id, #discount_items.item_id, ShopItems),
					    			[NewShopItem|ShopItems1]
							end,
						NewUserShopItem = Old#user_shop_items{shop_items = NewShopItems},
						List1 = lists:keydelete(UserId, #user_shop_items.user_id, List),
						[NewUserShopItem|List1]
				end,
			put(?DIC_SHOP_USER_DISCOUNT, NewList),
			ok;
		_ ->
			?WARNING_MSG("update_user_discounts:~w", [DiscountItem])
	end.




get_user_guild_shop(UserId)->
	List = get_user_guild_shop_dic(),
	case lists:keyfind(UserId, #user_shop_items.user_id, List) of
		false ->
			[];
		Old ->
			Old#user_shop_items.shop_items
	end.

get_user_guild_shop_dic() ->
	case get(?DIC_SHOP_USER_GUILD) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

update_user_guild_shop(DiscountItem, UserId) ->
	case is_record(DiscountItem, discount_items) of
		true ->	
			List = get_user_guild_shop_dic(),
			{NewList,Update} = 
				case lists:keyfind(UserId, #user_shop_items.user_id, List) of
					false ->
						NewUserShopItem = #user_shop_items{user_id=UserId, shop_items=[DiscountItem]},
						{[NewUserShopItem|List],DiscountItem};
					Old ->
						ShopItems = Old#user_shop_items.shop_items,
						{NewShopItems,UpdateItem} = 
							case lists:keyfind(DiscountItem#discount_items.item_id, #discount_items.item_id, ShopItems) of
								false ->
									{[DiscountItem|ShopItems],DiscountItem};
								OldShopItem ->
									NewShopItem = 
										case OldShopItem#discount_items.finish_time =/= DiscountItem#discount_items.finish_time of
											true -> 
												OldShopItem#discount_items{item_count = DiscountItem#discount_items.item_count,
																		  finish_time = DiscountItem#discount_items.finish_time};
											_ ->
												ItemCount = OldShopItem#discount_items.item_count+DiscountItem#discount_items.item_count,
												OldShopItem#discount_items{item_count=ItemCount}
										end,
									ShopItems1 = lists:keydelete(DiscountItem#discount_items.item_id, #discount_items.item_id, ShopItems),
					    			{[NewShopItem|ShopItems1],NewShopItem}
							end,
						NewUserShopItem = Old#user_shop_items{shop_items = NewShopItems},
						List1 = lists:keydelete(UserId, #user_shop_items.user_id, List),
						{[NewUserShopItem|List1],UpdateItem}
				end,
			put(?DIC_SHOP_USER_GUILD, NewList),			
			Update;
		_ ->
			?WARNING_MSG("update_user_discounts:~w", [DiscountItem]),
			false
	end.

	


%%
%% Local Functions
%%

