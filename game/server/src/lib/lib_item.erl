%%%-------------------------------------------------------------------
%%% Module  : lib_item

%%% Author  : 
%%% Description : 物品
%%%-------------------------------------------------------------------
-module(lib_item).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-define(ITEM_CD, item_cd).
-define(DMOGORGON_MAX_STATE, 4).%%神魔令任务最高品质
-define(TRANSFORM_PRICE, 10000). %%每次转移操作需要消耗的价格
-define(REBUILD_LOCK_STONE, 201029). %%洗炼锁物品唯一编号
%%转移操作类型
-define(TRANSFORM_STRENGTHEN, 1).
-define(TRANSFORM_REBUILD, 2).
-define(TRANSFORM_ALL, 3).
-define(BUG_ITEM_DISTANT, 300).
-define(TONGBAO,206089).		%% 铜宝
-define(YINBAO,206090).			%% 银宝

-define(SMSHOPREFYUANBAO,20).    %% 神秘商店刷新一次20银两
-define(STONE_QUENCH_PRICE, 2000). %% 铜币宝石淬炼花费为2000
-define(QUENCH_COST_YUANBAO,[180, 720, 2800]). %%元宝淬炼宝石不同等级对应元宝等级
-define(QUENCHID_ADDNUM, 200).	%% 淬炼后的精炼宝石在原来宝石id基础上加200
-define(PERFECTID_ADDNUM, 400).	%% 淬炼完美的宝石在原来宝石id基础上加400
-define(ORD_STONE_BEGID, 202011). %% 原始宝石起始ID
-define(ORD_STONE_ENDID, 202140). %% 原始宝石终止ID
-define(FINE_STONE_BEGID, 202211). %% 精致宝石起始ID
-define(FINE_STONE_ENDID, 202340). %% 精致宝石终止ID

-define(QUENCH_ID_1, 201031).
-define(QUENCH_ID_2, 201032).
-define(QUENCH_ID_3, 201033).

-define(FUSION_TALLY, 203026).		%% 熔炼符
-define(FUSION_COPPER, 200000).		%% 熔炼花费铜币


%%--------------------------------------------------------------------


%% External exports
-export([
		 change_item_owner/2,
		 delete_item/2,
		 get_item_for_id/3,
		 add_item/1,
		 reduce_item_num/2,
		 change_item_num/2,
		 change_item_cell/2,
		 change_item_durable/2,
		 change_item_streng/2,
		 change_user_item_data/2,
		 change_item_isbind/2,
		 update_item/1,
%%		 add_item_amount/4,
%%		 move_item/4,
		 array_item/3,
		 split_item/3,
		 move_item_equip/5,
		 item_sell/3,
		 item_feed/2,
		 item_buy_back/2,
         item_retrieve/2,
		 item_use/3,
		 item_use/4,
		 check_item_use/3,
		 check_item_use/4,
		 check_buy/11,
		 check_hole/5,
		 check_streng/6,
		 func_check_place/4,
		 item_streng_akey/7,
		 item_streng/6,
		 tap_hole/5,
		 check_mend/2,
		 mend_item/2,
		 check_enchase/1,
		 enchase_item/7,
		 pick_up_item/4,
		 add_item/5,
		 check_pick_stone/5,
		 pick_up_stone/9,
		 check_item_compose/4,
		 change_item_templateid/2,
		 check_decompose/4,
		 item_decompse/5,
		 item_compose/3,
		 check_stone_compose/4,
		 check_stone_compose/5,
		 item_stone_compose/4,
%% 		 item_stone_compose/5,
		 check_item_fision/6,
		 item_fision/6,
%%		 check_item_to_users/2,
		 mail_item_add/2,
		 pet_to_list/2,
		 change_item_bagtype/4,
		 pet_to_bag/2,
		 pet_fight/2,
		 pet_call_back/2,
		 get_iteminfo_by_tempbag/2,
		 item_exchang_buy/5,
%%		 check_users_own_item/2,
		 change_item_num_in_commonbag/5,
		 add_task_award/2,
		 check_item_to_users/3,
		 reduce_item_to_users/4,
		 reduce_item_to_users/6,
		 reduce_item_to_info/3,
		 task_reduce_item/4,
		 check_item_by_templateid/2,
		 reduce_equip_durable/2,
		 item_drop_by_pk_death/2,
		 check_item_rebuild/7,
		 check_item_transform/5,
		 check_item_exchang_buy/3,
		 item_transform/4,
		 item_replace_rebuild/3,
		 func_add_tuple_in_list/1,
		 item_rebuild/7,
%%       item_use_1/3,
		 get_weapon_categoryid/2,
		 open_box_in_yuanbao/5,
		 check_bag_stone_quench/6,
		 check_equip_stone_quench/7,
		 item_bag_stone_quench/5,
		 item_equip_stone_quench/7,
		 item_bag_stone_decompose/3,
		 check_equip_funsion/5,
		 equip_funsion/6,
		 		 
		 fun_deal_with_list/1,
		 add_item_send_mail/4,
		 add_item_in_box/6,
		 move_boxitem_to_bag/3,
		 check_item_upgrade/4,
		 check_item_uplevel/4,
		 item_upgrade/4,
		 add_item_amount_summation/6,
		 move_item_test/6,
		 check_depot_copper/3,
		 mail_send_items/3,
		 guild_warehouse_put_item/2,
		 guild_warehouse_get_item/2,
		 shenmo_refresh_state/3,
		 check_exploit_buy/4,
		 check_discount_buy/8,
		 check_guild_shop_buy/5,
		 rose_play/6,
		 send_player_rose/7,
		 smshop_ref/2,
		 smshop_buy/4,
		 move_item_from_pet_equip/5,
		 move_item_to_pet_equip/4,
		 move_item_pet_equip/6
		 ]).

-export([item_rebuild_7/2]).

%%====================================================================
%% External functions
%%====================================================================

%% 更新物品拥有者及其位置
change_item_owner(ItemInfo, Place) ->
%% 	spawn(fun()->db_agent_item:change_item_owner(ItemInfo#ets_users_items.id, ItemInfo#ets_users_items.user_id, Place) end),
%%    	NewItemInfo = ItemInfo#ets_users_items{place=Place},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{place=Place, bag_type = ?BAG_TYPE_COMMON},
	item_util:update_item_to_bag(NewItemInfo).
	
  
get_item_for_id(UserId, TemplateId, Place) ->
    Item = (catch db_agent_item:get_item_for_id(UserId, TemplateId, Place)),
	ItemInfo = list_to_tuple([ets_users_items] ++ Item),
	ItemInfo.

%%添加物品
add_item(ItemInfo) ->
	item_util:update_item_to_bag(ItemInfo).
%% 	case db_agent_item:add_item(ItemInfo) of
%% 		{mongo, Ret} ->
%% 			NewItemInfo = ItemInfo#ets_users_items{id = Ret};
%% 		_ ->
%% 			NewItemInfo = get_item_for_id(ItemInfo#ets_users_items.user_id,
%% 										  ItemInfo#ets_users_items.template_id,
%% 										  ItemInfo#ets_users_items.place)
%% 	end,
%% 					 NewItemInfo1 = NewItemInfo#ets_users_items{other_data=#item_other{}},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo1),
%% 	NewItemInfo1.

%%箱子仓库添加物品  （可以叠加）
add_item_in_box(Template, Amount, IsBind, Streng_Level, L, State) ->
	BoxItemList = item_util:get_item_list(State#item_status.user_id, ?BAG_TYPE_BOX),
	F = fun(X) ->
				if
					X#ets_users_items.template_id =:= Template#ets_item_template.template_id 
					  andalso X#ets_users_items.is_bind =:= IsBind
					  andalso X#ets_users_items.amount =/= Template#ets_item_template.max_count ->
						true;
					true ->
						false
				end
		end,
	case lists:filter(F, BoxItemList) of
		[] ->
			add_item_in_box_1(Template, Amount, IsBind, Streng_Level, L, State);
		ItemList ->
			NewItemList = lists:sort(fun(X1,X2)->X1#ets_users_items.place < X2#ets_users_items.place end, ItemList),
			add_item_in_box_2(Template, Amount, IsBind, Streng_Level, NewItemList, L, State)
	end.
				
add_item_in_box_1(Template, Amount, IsBind, Streng_Level, L, State) ->
	if
		Amount > (Template#ets_item_template.max_count) ->
			[Cell|NewNullCells] = State#item_status.maxboxnull,
			NewState = State#item_status{maxboxnull=NewNullCells},
			ItemInfo = item_util:create_new_item(Template, Template#ets_item_template.max_count, Cell, State#item_status.user_id, IsBind, Streng_Level, ?BAG_TYPE_BOX),
            NewItemInfo = item_util:update_item_to_bag(ItemInfo),
			add_item_in_box_1(Template, Amount-(Template#ets_item_template.max_count), IsBind, Streng_Level, [NewItemInfo | L], NewState);
		true ->
			[Cell|NewNullCells] = State#item_status.maxboxnull,
			NewState = State#item_status{maxboxnull=NewNullCells},
			ItemInfo = item_util:create_new_item(Template, Amount, Cell, State#item_status.user_id, IsBind, Streng_Level, ?BAG_TYPE_BOX),
			NewItemInfo = item_util:update_item_to_bag(ItemInfo),
			{NewState, [NewItemInfo|L], 0}
	end.

add_item_in_box_2(Template, Amount, IsBind, Streng_Level, [ItemInfo | NewItemList], L, State) ->
	ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	TemplateMaxCount = ItemTemplate#ets_item_template.max_count,
	ItemInfoAmount  = ItemInfo#ets_users_items.amount,
	if
		Amount > TemplateMaxCount - ItemInfoAmount ->
			NewItemInfo = change_item_num(ItemInfo, TemplateMaxCount),
			case erlang:length(NewItemList) of
				0 ->
					add_item_in_box_1(Template, Amount-(TemplateMaxCount - ItemInfoAmount), IsBind, Streng_Level, [NewItemInfo|L], State);
				
	            _ ->
				    add_item_in_box_2(Template, Amount-(TemplateMaxCount - ItemInfoAmount), IsBind, Streng_Level, NewItemList, [NewItemInfo|L], State)	
			end;
		true ->
			NewAmount = ItemInfo#ets_users_items.amount + Amount,
			NewItemInfo = change_item_num(ItemInfo, NewAmount),
			{State, [NewItemInfo|L], 0}
	end.			

%%添加物品   选择是否叠加
add_item_amount_summation(Template, Amount, State, L, IsBind, IsSummation) ->	
	BagItemList = item_util:get_bag_list(State#item_status.user_id),
	F = fun(X)-> 
				if X#ets_users_items.template_id =:= Template#ets_item_template.template_id 
					  andalso  X#ets_users_items.is_bind =:= IsBind 
					  andalso  X#ets_users_items.amount =/= Template#ets_item_template.max_count 
					  andalso  IsSummation =:= ?CANSUMMATION ->
					   true;
				   true ->
					   false
				end
		end,				
	case lists:filter(F, BagItemList) of
		[] ->		
			add_item_amount_summation_1(Template, Amount, State, L, IsBind);	
		ItemList ->		
			case lists:sort(fun(X1,X2)->X1#ets_users_items.place < X2#ets_users_items.place end, ItemList) of
				[] ->
					{State, [], 0};
				NewItemList ->
					add_item_amount_summation_2(Template, Amount, State, IsBind, NewItemList, L)
			end		
	end.

add_item_send_mail(Template, Amount,IsBind, MailItemList) ->
	if
		Amount > (Template#ets_item_template.max_count) ->
			MailItem1 = item_util:create_new_item(Template, Template#ets_item_template.max_count, 0, 0, IsBind, 0, ?BAG_TYPE_MAIL),
			MailItem = item_util:add_item_and_get_id(MailItem1),
			add_item_send_mail(Template, Amount - Template#ets_item_template.max_count,IsBind, [MailItem|MailItemList]);
		true ->
			MailItem1 = item_util:create_new_item(Template, Amount, 0, 0, IsBind, 0, ?BAG_TYPE_MAIL),
			MailItem = item_util:add_item_and_get_id(MailItem1),
			[MailItem|MailItemList]
	end.

add_item_amount_summation_1(Template, Amount, State, L, IsBind) ->
	case State#item_status.null_cells of
		[] ->
			%gen_server:cast(self(), {add_item_send_mail,Template,Amount,IsBind}),
			{State, L, Amount};
		_ ->
			if
				Amount > (Template#ets_item_template.max_count) ->
					[Cell|NewNullCells] = State#item_status.null_cells,
					NewState = State#item_status{null_cells=NewNullCells},
					ItemInfo = item_util:create_new_item(Template, Template#ets_item_template.max_count, Cell, State#item_status.user_id),
                    NewItemInfo1 = ItemInfo#ets_users_items{is_bind=IsBind},
					NewItemInfo = item_util:update_item_to_bag(NewItemInfo1),
					add_item_amount_summation_1(Template, Amount - Template#ets_item_template.max_count, NewState, [NewItemInfo|L], IsBind);
										
				true ->
					[Cell|NewNullCells] = State#item_status.null_cells,
					NewState = State#item_status{null_cells=NewNullCells},
					ItemInfo = item_util:create_new_item(Template, Amount, Cell, State#item_status.user_id),
					NewItemInfo1 = ItemInfo#ets_users_items{is_bind=IsBind},
					
					NewItemInfo = item_util:update_item_to_bag(NewItemInfo1),
					{NewState, [NewItemInfo|L], 0}
			end
	end.

add_item_amount_summation_2(Template, Amount, State, IsBind, [ItemInfo|NewItemList], L) ->	
	ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	TemplateMaxCount = ItemTemplate#ets_item_template.max_count,
	ItemInfoAmount  = ItemInfo#ets_users_items.amount,
	if
		Amount > TemplateMaxCount - ItemInfoAmount ->
			NewItemInfo = change_item_num(ItemInfo, TemplateMaxCount),
			case erlang:length(NewItemList) of
				0 ->
					add_item_amount_summation_1(Template, Amount-(TemplateMaxCount - ItemInfoAmount), State, [NewItemInfo|L], IsBind);
				_ ->
					add_item_amount_summation_2(Template, Amount-(TemplateMaxCount - ItemInfoAmount), State, IsBind, NewItemList, [NewItemInfo|L])
			end;
		true ->
			NewAmount = ItemInfo#ets_users_items.amount + Amount,
			NewItemInfo = change_item_num(ItemInfo, NewAmount),
			{State, [NewItemInfo|L], 0}
	end.								


update_item(ItemInfo) ->
	case ItemInfo#ets_users_items.is_exist of
		1 ->
			change_item_num(ItemInfo, ItemInfo#ets_users_items.amount);
		0 ->
			item_util:delete_dic(ItemInfo)
	end,
	ok.

%%减少物品，与chang_item_num互换
reduce_item_num(ItemInfo, {Amount,Type,Level,UserId}) ->
	Now = misc_timer:now_seconds(),
	item_util:add_item_consume_log(UserId,ItemInfo#ets_users_items.id,ItemInfo#ets_users_items.template_id,Type,Amount,
								 ItemInfo#ets_users_items.amount - Amount,Level,Now),
	NewItemInfo = ItemInfo#ets_users_items{amount=Amount},
	item_util:update_item_to_bag(NewItemInfo).

change_item_num(ItemInfo, Amount) ->
%%     spawn(fun()->db_agent_item:change_item_num(ItemInfo#ets_users_items.id, Amount)end),
%%     NewItemInfo = ItemInfo#ets_users_items{amount=Amount},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	    NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{amount=Amount},
	item_util:update_item_to_bag(NewItemInfo).


change_item_cell(ItemInfo, Cell) ->
%% 	spawn(fun()->db_agent_item:change_item_cell(ItemInfo#ets_users_items.id, Cell) end),
%% 	NewItemInfo = ItemInfo#ets_users_items{place=Cell},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{place=Cell},
	item_util:update_item_to_bag(NewItemInfo).


%%改变背包类型及位置
change_item_bagtype(ItemInfo, BagType, Cell, PetId) ->%%如果涉及到宠物还需要修改宠物id
%% 	spawn(fun()->db_agent_item:change_item_bagtype(ItemInfo#ets_users_items.id, BagType, Cell) end),
%% 	NewItemInfo = ItemInfo#ets_users_items{place=Cell, bag_type=BagType},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{place=Cell, pet_id = PetId, bag_type=BagType},
	item_util:update_item_to_bag(NewItemInfo).
	
change_item_hole(ItemInfo, _Lists) ->
%%     spawn(fun()->db_agent_item:change_item_hole(ItemInfo#ets_users_items.id, Lists) end),
%% 	ets:insert(?ETS_USERS_ITEMS, ItemInfo),
%% 	ItemInfo.
	item_util:update_item_to_bag(ItemInfo).

change_item_isbind(ItemInfo, IsBind) ->
%%     spawn(fun()->db_agent_item:change_item_isbind(ItemInfo#ets_users_items.id, IsBind) end),
%% 	ets:insert(?ETS_USERS_ITEMS, ItemInfo),
%% 	ItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{is_bind=IsBind},
	item_util:update_item_to_bag(NewItemInfo).

change_item_durable(ItemInfo, DurableUpper) ->
%%     spawn(fun()->db_agent_item:change_item_durable(ItemInfo#ets_users_items.id, DurableUpper) end),
%%     NewItemInfo = ItemInfo#ets_users_items{durable = DurableUpper},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),	
%%     NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{durable = DurableUpper},
	item_util:update_item_to_bag(NewItemInfo).

change_item_templateid(ItemInfo, TempleId) ->
%% 	spawn(fun()->db_agent_item:change_item_templateid(ItemInfo#ets_users_items.id, TempleId) end),
%%     NewItemInfo = ItemInfo#ets_users_items{template_id = TempleId},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),	
%%     NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{template_id = TempleId},
	item_util:update_item_to_bag(NewItemInfo).
	
change_user_item_data(ItemInfo, Data) ->
%% 	spawn(fun()->db_agent_item:change_user_item_data(ItemInfo#ets_users_items.id, Data) end),
%%     NewItemInfo = ItemInfo#ets_users_items{data = Data},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),	
%%     NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{data = Data},
	item_util:update_item_to_bag(NewItemInfo).

change_item_enchase(ItemInfo, _Lists) ->
%% 	spawn(fun()->db_agent_item:change_item_hole(ItemInfo#ets_users_items.id, Lists) end),
%% 	ets:insert(?ETS_USERS_ITEMS, ItemInfo),
%% 	ItemInfo.
	item_util:update_item_to_bag(ItemInfo).

change_item_streng(ItemInfo, StrengLevel) ->
%% 	spawn(fun()->db_agent_item:change_item_streng(ItemInfo#ets_users_items.id, StrengLevel) end),
%% 	NewItemInfo = ItemInfo#ets_users_items{strengthen_level=StrengLevel},
%% 	ets:insert(?ETS_USERS_ITEMS, NewItemInfo),
%% 	NewItemInfo.
	NewItemInfo = ItemInfo#ets_users_items{strengthen_level=StrengLevel},
	item_util:update_item_to_bag(NewItemInfo).

%% delete_item(ItemId) ->
%% 	spawn(fun() -> db_agent_item:delete_item(ItemId) end ),
%%     ets:delete(?ETS_USERS_ITEMS, ItemId),
%% 	ok.


%% IsExist 是否存在，1表示存在，0不存在（如物品寄售，或邮寄需要才身上移掉1） 
delete_item(ItemInfo, {IsExist,Type,UserId,Level}) ->
	Now = misc_timer:now_seconds(),
	item_util:add_item_consume_log(UserId,ItemInfo#ets_users_items.id,ItemInfo#ets_users_items.template_id,Type,0,ItemInfo#ets_users_items.amount,Level,Now),
	if IsExist =:= 0 ->		  
		   item_util:delete_dic(ItemInfo#ets_users_items{is_exist = 0, create_date=Now});
	   true ->
		   item_util:delete_dic(ItemInfo)
	end.
	   

%%减少背包物品数量,根据物品的位置 (改变物品背包状态)
change_item_num_in_commonbag(ItemInfo, ItemPlace, Count, ItemState, Type) ->
	if
		ItemInfo#ets_users_items.amount =:= Count ->						
			NewNullCells = lists:sort([ItemPlace|ItemState#item_status.null_cells]),
			delete_item(ItemInfo, {0,Type,ItemState#item_status.user_id,ItemState#item_status.level}),
			NewItemState = ItemState#item_status{null_cells = NewNullCells},	   
			[NewItemState, [], [ItemPlace]];
		ItemInfo#ets_users_items.amount > Count ->
			NewItemInfo = reduce_item_num(ItemInfo,{ItemInfo#ets_users_items.amount - Count,Type,ItemState#item_status.level, ItemState#item_status.user_id}),
			[ItemState, [NewItemInfo], []];
		true ->
			[ItemState, [ItemInfo], []]
	end.




%% 批量使用物品
use_item([_], 0, ItemState, ItemInfo, DeleList) ->
	[ItemState, ItemInfo, DeleList, 0];
use_item([], Count, ItemState, ItemInfo, DeleList) ->
	[ItemState, ItemInfo, DeleList, Count];
use_item([H|ItemList], Count, ItemState, ItemInfo, DeleList) ->
	if 	H#ets_users_items.amount >= Count ->
		[NewItemState, NewItemInfo, NewDeleList] = change_item_num_in_commonbag(H,H#ets_users_items.place,Count,ItemState,?CONSUME_ITEM_USE),
		use_item(ItemList, 0, NewItemState, lists:append(ItemInfo, NewItemInfo), lists:append(DeleList, NewDeleList));
	true ->
		[NewItemState, NewItemInfo, NewDeleList] = change_item_num_in_commonbag(H,H#ets_users_items.place,H#ets_users_items.amount,ItemState,?CONSUME_ITEM_USE),
		use_item(ItemList, Count - H#ets_users_items.amount, NewItemState, lists:append(ItemInfo, NewItemInfo), lists:append(DeleList, NewDeleList))
	end.

%% 返回物品列表
get_bag_item_list_by_templateId(TemplateId, UserId)->
	ItemList = item_util:get_item_list(UserId, ?BAG_TYPE_COMMON),
	get_bag_item_list_by_templateId1(ItemList,TemplateId,[],0).

get_bag_item_list_by_templateId1([], TemplateId, ItemList, Amount) ->
	{ItemList, Amount};
get_bag_item_list_by_templateId1([H|List], TemplateId, ItemList, Amount) ->
	case H#ets_users_items.template_id =:= TemplateId of
		true ->
			get_bag_item_list_by_templateId1(List, TemplateId, [H|ItemList], Amount + H#ets_users_items.amount);
		_ ->
			get_bag_item_list_by_templateId1(List, TemplateId, ItemList, Amount)
	end.
%% 判断物品是否足够
check_item_to_users(TemplateId, Amount, UserId) ->
	ItemList = item_util:get_item_list(UserId, ?BAG_TYPE_COMMON),	
	check_item_to_user(ItemList, TemplateId, Amount).
check_item_to_user([], _TemplateId, _Amount) ->
	false;
check_item_to_user([H|List], TemplateId, Amount) ->
	case H#ets_users_items.template_id =:= TemplateId of
		true when H#ets_users_items.amount >= Amount ->
			true;
		true ->
			check_item_to_user(List, TemplateId, Amount - H#ets_users_items.amount);
		_ ->
			check_item_to_user(List, TemplateId, Amount)
	end.


%% 参数个数为5
reduce_item_to_users(TemplateId, Amount, State, ItemList, DeleteList,Type) ->
	{true, NewState, ItemList1, DeleteList1, BindFlag} = reduce_item_to_users_1(TemplateId, Amount, State,Type),
	{NewState, lists:append(ItemList, ItemList1), lists:append(DeleteList, DeleteList1), BindFlag}.


%% 参数个数为3
reduce_item_to_users(TemplateId, Amount, State,Type) ->
	{true, NewItemStatus, ItemList, DelList, _BindFlag} = reduce_item_to_users_1(TemplateId, Amount, State,Type),
	{true, NewItemStatus, ItemList, DelList}.

reduce_item_to_users_1(TemplateId, Amount, State, Type) ->
	ItemList1 = item_util:get_item_list(State#item_status.user_id, ?BAG_TYPE_COMMON),	
	%%优先扣减绑定的物品
	ItemList = lists:sort(fun(X1,X2)->X1#ets_users_items.is_bind > X2#ets_users_items.is_bind end, ItemList1),
	case lists:filter(fun(Info) ->Info#ets_users_items.is_bind =:= ?BIND end, ItemList)  of
		[] ->
			reduce_item_to_user(ItemList, TemplateId, Amount, State, [], [], 0,Type);
		_ ->
			reduce_item_to_user(ItemList, TemplateId, Amount, State, [], [], 0,Type)
	end.

reduce_item_to_user([], _TemplateId, _Amount, State, ItemList, DelList, BindFlag,_Type) ->
	{true, State, ItemList, DelList, BindFlag};
reduce_item_to_user([H|List], TemplateId, Amount, State, ItemList, DelList, BindFlag,Type) ->
	case H#ets_users_items.template_id =:= TemplateId of
		true when H#ets_users_items.amount =:= Amount ->
			Cell = H#ets_users_items.place,
			NewCells = [Cell|State#item_status.null_cells],
			delete_item(H, {0,Type,State#item_status.user_id,State#item_status.level}),
			NewState = State#item_status{null_cells=NewCells},
			{true, NewState, ItemList, [Cell|DelList], (BindFlag+H#ets_users_items.is_bind)};
		true when H#ets_users_items.amount > Amount ->
			NewItem = reduce_item_num(H, {H#ets_users_items.amount - Amount,Type,State#item_status.level,State#item_status.user_id}),
			{true, State, [NewItem|ItemList], DelList, (BindFlag+H#ets_users_items.is_bind)};
		true ->
			Cell = H#ets_users_items.place,
			NewCells = [Cell|State#item_status.null_cells],
			delete_item(H, {0,Type,State#item_status.user_id,State#item_status.level}),
			NewState = State#item_status{null_cells=NewCells},
			reduce_item_to_user(List, TemplateId, Amount - H#ets_users_items.amount, NewState, ItemList, [Cell|DelList], (BindFlag+H#ets_users_items.is_bind),Type);
		_ ->
			reduce_item_to_user(List, TemplateId, Amount, State, ItemList, DelList, BindFlag,Type)
	end.

%% 扣除物品
reduce_item_to_info(ItemInfo, State,Type) ->
	NewNullCells = lists:sort([ItemInfo#ets_users_items.place|State#item_status.null_cells]),
	DeleteList = [ItemInfo#ets_users_items.place],
	NewState = State#item_status{null_cells = NewNullCells},
	delete_item(ItemInfo, {0,Type,State#item_status.user_id,State#item_status.level}),
	{true, NewState, DeleteList}.



%% 对[{1,30}, {2,30}, {1, 40}] 类似的元组列表进行累加
func_add_tuple_in_list(List) ->
	F = fun({Type, Value}, Acc) ->
				case lists:keyfind(Type, 1, Acc) of
					false ->
						[{Type, Value} | Acc];
					Tuple ->
						{Type, Amount} = Tuple,
						NewList = lists:keyreplace(Type, 1, Acc, {Type, Value+Amount}),
						NewList
				end
		end,
	NewList = lists:foldl(F, [], List),
	NewList.


%% [{1,10},{1,20},{1,30},{2,10},{1,50}]
fun_deal_with_list(List) ->
	F = fun({Type, Value}, [Acc, FlagList]) ->
				case lists:keyfind(Type, 1, Acc) of
					false ->
						[[{Type, Value} | Acc], [{Type, 1} | FlagList]];
					_Tuple ->
						case lists:keyfind(Type, 1, FlagList) of
							false ->
								[Acc, FlagList];
							Tuple1 ->
								{_Type, Num} = Tuple1,
								if
									Num >= 3 ->
										[Acc, FlagList];
									true ->
										NewFlagList = lists:keyreplace(Type, 1, FlagList, {Type, Num+1}),
										[[{Type, Value} | Acc], NewFlagList]
								end
						end
				end
		end,
	[NewList, _] = lists:foldl(F, [[], []], List),
	NewList.



%%物品移动整合 (包括背包与仓库)
move_item_test(State, FromPlace, FromBagType, ToPlace, ToBagType, Amount) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, FromPlace, FromBagType) of
		[] ->
			{error, State};
		[FromItemInfo] ->
			move_item_1_test(State, FromItemInfo, FromBagType, ToPlace, ToBagType, Amount)			
	end.
move_item_1_test(State, FromItemInfo, FromBagType, ToPlace, ToBagType, Amount) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, ToPlace, ToBagType) of
		[] ->						
			OldCell = FromItemInfo#ets_users_items.place,
			NewFromItem = change_item_bagtype(FromItemInfo, ToBagType, ToPlace, FromItemInfo#ets_users_items.pet_id),         
			case ToBagType of
				?BAG_TYPE_COMMON ->
					case FromBagType of
						?BAG_TYPE_COMMON ->
							BagNullCells  = lists:delete(ToPlace, State#item_status.null_cells),
							BagNullCells1 = lists:sort([OldCell|BagNullCells]),	
							NewState = State#item_status{null_cells=BagNullCells1},
							{common_bag, NewState, [NewFromItem], [OldCell]};
						
						?BAG_TYPE_STORE ->						
							DepotNullCells  = State#item_status.depot_null_cells,
							DepotNullCells1 = lists:sort([OldCell|DepotNullCells]),		
					        BagNullCells  = lists:delete(ToPlace, State#item_status.null_cells),										    				
					        NewState = State#item_status{null_cells=BagNullCells,
														 depot_null_cells=DepotNullCells1},						
		                    {ok, NewState, [NewFromItem], [], [], [OldCell]}
					end;
				
				?BAG_TYPE_STORE ->
					case FromBagType of
						?BAG_TYPE_COMMON ->
							BagNullCells  = State#item_status.null_cells,
							BagNullCells1 = lists:sort([OldCell|BagNullCells]),
							DepotNullCells = lists:delete(ToPlace, State#item_status.depot_null_cells),
							NewState = State#item_status{null_cells=BagNullCells1,
														 depot_null_cells=DepotNullCells},
							{ok, NewState, [], [OldCell], [NewFromItem], []};
						
						?BAG_TYPE_STORE ->
							DepotNullCells =  lists:delete(ToPlace, State#item_status.depot_null_cells),
							DepotNullCells1 = lists:sort([OldCell|DepotNullCells]),
							NewState = State#item_status{depot_null_cells=DepotNullCells1},
							{depot_bag, NewState, [NewFromItem], [OldCell]}		
					end
			end;
		[ToItemInfo] ->
			move_item_2_test(State, FromItemInfo, FromBagType, ToItemInfo, ToPlace, ToBagType, Amount)
	end.

%%物品不相同,交换位置
move_item_2_test(State, FromItemInfo, FromBagType, ToItemInfo, ToPlace, ToBagType, Amount) ->
	if
		FromItemInfo#ets_users_items.template_id =:= ToItemInfo#ets_users_items.template_id 
		  andalso FromItemInfo#ets_users_items.is_bind =:= ToItemInfo#ets_users_items.is_bind ->
			move_item_3_test(State, FromItemInfo, FromBagType, ToItemInfo, ToBagType, Amount);
		true ->
			FromPlace   = FromItemInfo#ets_users_items.place,				
			NewFromInfo = change_item_bagtype(FromItemInfo, ToBagType, ToPlace, FromItemInfo#ets_users_items.pet_id),
			NewToInfo   = change_item_bagtype(ToItemInfo, FromBagType, FromPlace, ToItemInfo#ets_users_items.pet_id),		
			case FromBagType of
				?BAG_TYPE_COMMON ->
					case ToBagType of
						?BAG_TYPE_COMMON ->
							{common_bag, State, [NewFromInfo|[NewToInfo]], []};
						?BAG_TYPE_STORE -> 
							{ok, State, [NewToInfo], [], [NewFromInfo], []}
					end;
				?BAG_TYPE_STORE ->
					case ToBagType of
						?BAG_TYPE_COMMON ->
							{ok, State, [NewFromInfo], [], [NewToInfo], []};
						?BAG_TYPE_STORE ->
							{depot_bag, State, [NewFromInfo|[NewToInfo]], []}
					end
			end
	end.

%%物品相同,可进行叠加
move_item_3_test(State, FromItemInfo, FromBagType, ToItemInfo, ToBagType, TempAmount) ->	
%% 	Template = item_util:get_item_template(FromItemInfo#ets_users_items.template_id),
	
	Amount = 
		case TempAmount > FromItemInfo#ets_users_items.amount of
			true ->
				?WARNING_MSG("move_item_3_test :~w,~w,~w",[TempAmount,FromItemInfo#ets_users_items.amount,FromItemInfo]),
				FromItemInfo#ets_users_items.amount;
			_ ->
				TempAmount
		end, 
	Template = data_agent:item_template_get(FromItemInfo#ets_users_items.template_id),
	TotalCount = ToItemInfo#ets_users_items.amount + Amount,		
	if
		TotalCount > Template#ets_item_template.max_count ->
			NewToItemInfo = change_item_num(ToItemInfo, Template#ets_item_template.max_count),
			NewFromItemInfo = change_item_num(FromItemInfo, TotalCount - Template#ets_item_template.max_count),	%移动物品不保存日志			
			case FromBagType of
				?BAG_TYPE_COMMON ->
					case ToBagType of
						?BAG_TYPE_COMMON ->
							{common_bag, State, [NewToItemInfo|[NewFromItemInfo]], []};
						?BAG_TYPE_STORE ->
							{ok, State, [NewFromItemInfo], [], [NewToItemInfo], []}
					end;
				?BAG_TYPE_STORE ->
					case ToBagType of
						?BAG_TYPE_COMMON ->
							{ok, State, [NewToItemInfo], [], [NewFromItemInfo], []};
						?BAG_TYPE_STORE ->
							{depot_bag, State, [NewToItemInfo|[NewFromItemInfo]], []}
					end
			end;
		
		true ->
			NewToItemInfo = change_item_num(ToItemInfo, TotalCount),
			delete_item(FromItemInfo, {0,?CONSUME_ITEM_MOVE,State#item_status.user_id,State#item_status.level}),
			case FromBagType of
				?BAG_TYPE_COMMON ->
					BagNullCells = lists:sort([FromItemInfo#ets_users_items.place|State#item_status.null_cells]),
					NewState = State#item_status{null_cells=BagNullCells},	
					case ToBagType of
						?BAG_TYPE_COMMON ->
							{common_bag, NewState, [NewToItemInfo], [FromItemInfo#ets_users_items.place]};
						?BAG_TYPE_STORE ->
							{ok, NewState, [], [FromItemInfo#ets_users_items.place], [NewToItemInfo], []}
					end;
				?BAG_TYPE_STORE->
					DepotNullCells = lists:sort([FromItemInfo#ets_users_items.place|State#item_status.depot_null_cells]),
					NewState = State#item_status{depot_null_cells=DepotNullCells},
					case ToBagType of
						?BAG_TYPE_COMMON ->
							{ok, NewState, [NewToItemInfo], [], [], [FromItemInfo#ets_users_items.place]};
						?BAG_TYPE_STORE ->
							{depot_bag, NewState, [NewToItemInfo], [FromItemInfo#ets_users_items.place]}
					end
			end							
	end.

move_item_pet_equip(State, FromPlace, ToPlace, PetLevel, PetId, MaxCount) ->
	if	PetLevel > 0  ->
			move_item_to_pet_equip(State, FromPlace, PetLevel, PetId);
		true ->
			move_item_from_pet_equip(State, FromPlace, ToPlace, PetId, MaxCount)
	end.

move_item_from_pet_equip(State, FromPlace, ToPlace, PetId, MaxCount) ->
	case item_util:get_pet_equip_by_place(PetId, FromPlace) of
		[] ->
			{error, State};
		[FromItem] ->
			ToItem = item_util:get_user_item_by_place(State#item_status.user_id, ToPlace),
			if 
 				ToItem =/= [] orelse ToPlace > (MaxCount + ?BAG_BEGIN_CELL - 1) ->
					if
						State#item_status.null_cells =:= [] ->
							{error, State};
						true ->
							[Cell|NewNullCells] = State#item_status.null_cells,
							NewFromItem = change_item_bagtype(FromItem,?BAG_TYPE_COMMON,Cell, 0),
							%%NewNullCells = lists:delete(Cell, State#item_status.null_cells),
							NewState = State#item_status{null_cells=NewNullCells},
							{ok, NewState, [NewFromItem], [],[],[FromPlace]}
					end;				
				true ->
					Cell = ToPlace,
					NewFromItem = change_item_bagtype(FromItem,?BAG_TYPE_COMMON,Cell, 0),
					NewNullCells = lists:delete(Cell, State#item_status.null_cells),
					NewState = State#item_status{null_cells=NewNullCells},
					{ok, NewState, [NewFromItem], [],[],[FromPlace]}
			end
	end.

move_item_to_pet_equip(State, FromPlace, PetLevel, PetId) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, FromPlace) of
		[ItemInfo] ->
			ItemTemplae = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			if 	ItemTemplae#ets_item_template.need_level > PetLevel ->
					{error, State};%%等级不足
				ItemInfo#ets_users_items.category_id < ?CATE_PET_EQUIP_ARMET 
						orelse ItemInfo#ets_users_items.category_id > ?CATE_PET_EQUIP_PENDANT ->%%费宠物装备不能装备到宠物背包
					{error, State};
				true ->
					move_item_to_pet_equip1(State,ItemInfo,ItemTemplae,PetId)
			end;			
		[] ->
			{error, State}
	end.
move_item_to_pet_equip1(State,FromItem,FromTemplate,PetId) ->
 	Cell = item_util:get_equip_cell(FromItem#ets_users_items.category_id),
	        if 
		        Cell < 0 ->
			       {error, State};
		        true ->
			         case item_util:get_pet_equip_by_place(PetId, Cell) of
				        [] ->
						   OldCell = FromItem#ets_users_items.place,
					       NewFromItem = change_item_bagtype(FromItem, ?BAG_TYPE_PET, Cell, PetId),
						   if
							   NewFromItem#ets_users_items.is_bind =:= ?NOBIND 
														    andalso FromTemplate#ets_item_template.bind_type =:= ?BING_TYPE_0 ->
								   NewFromItem1 = lib_item:change_item_isbind(NewFromItem, ?BIND);
							   true ->
								   NewFromItem1 = NewFromItem
						   end,
					       NewNullCells = lists:sort([OldCell|State#item_status.null_cells]),
					       NewState = State#item_status{null_cells=NewNullCells},
					       {ok, NewState, [], [OldCell],[NewFromItem1],[]};
				        [ToItem] ->
					       FromPlace = FromItem#ets_users_items.place,
					       NewFromItem = change_item_bagtype(FromItem, ?BAG_TYPE_PET, Cell, PetId),
						   if
							   NewFromItem#ets_users_items.is_bind =:= ?NOBIND 
														    andalso FromTemplate#ets_item_template.bind_type =:= ?BING_TYPE_0 ->
								   NewFromItem1 = lib_item:change_item_isbind(NewFromItem, ?BIND);
							   true ->
								   NewFromItem1 = NewFromItem
						   end,				   
					       ToFromItem = change_item_bagtype(ToItem, ?BAG_TYPE_COMMON, FromPlace, 0),
					         {ok, State, [ToFromItem], [],[NewFromItem1],[]}
			        end
	       end.


%%拖动物品，其中有一个是装备格子
move_item_equip(State, FromPlace, ToPlace, MaxCount, PlayerStatus) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, FromPlace) of
		[ItemInfo] ->
			move_item_equip_1(State, ItemInfo, ToPlace, MaxCount, PlayerStatus);
		_ ->
			{error, State}
	end.

move_item_equip_1(State, FromItem, ToPlace, MaxCount, PlayerStatus) ->
	ItemTemplae = data_agent:item_template_get(FromItem#ets_users_items.template_id),
	Can_Destroy = ItemTemplae#ets_item_template.can_destroy,
	if 
		 ToPlace < 0 andalso Can_Destroy =:= 1->
			 %%添加道具消耗/产出记录
			 %lib_statistics:add_item_log(FromItem#ets_users_items.template_id, ?ITEM_THROW, 1),
			 delete_item(FromItem, {0,?CONSUME_ITEM_THROW,State#item_status.user_id,State#item_status.level}),
			 NewNullCells = lists:sort([FromItem#ets_users_items.place|State#item_status.null_cells]),
		  	 NewState = State#item_status{null_cells=NewNullCells},
		 	 {ok, NewState, [], [FromItem#ets_users_items.place]};
		 FromItem#ets_users_items.category_id > ?CATE_CLOTH_LIUXING ->
			{error, State};
		 ToPlace < ?BAG_BEGIN_CELL ->
			 move_item_to_equip(State, FromItem, PlayerStatus);
		
		true ->
			move_item_from_equip(State, FromItem, ToPlace, MaxCount, PlayerStatus)
	end.

%%判断是否可用，判断性别，判断职业
check_item_to_equip(ItemTemplate, PlayerStatus) ->
	CheckItemSex = check_item_to_sex(ItemTemplate, PlayerStatus),
	CheckItemCareer = check_item_to_career(ItemTemplate, PlayerStatus),	
	if			
%%		ItemTemplate#ets_item_template.can_use =/= 1 ->
%%			{error};
		PlayerStatus#ets_users.level < ItemTemplate#ets_item_template.need_level ->
			{error};  
		
		CheckItemSex =/= ok ->
			{error};
		CheckItemCareer =/= ok ->
			{error};
					
		true ->
			{ok}
	end.

check_item_to_sex(ItemTemplate, PlayerStatus) ->
	if
		ItemTemplate#ets_item_template.need_sex =/= 0 ->
%% 			if
%% 				ItemTemplate#ets_item_template.need_sex =/= PlayerStatus#ets_users.sex ->
%% 					error;
%% 				true ->
%% 					ok				
%% 			end;
			case PlayerStatus#ets_users.sex of
				1 when ItemTemplate#ets_item_template.need_sex == 1 ->
					ok;
				0 when ItemTemplate#ets_item_template.need_sex == 2 ->
					ok;
				_ ->
					error
			end;
		true ->
			ok
	end.
check_item_to_career(ItemTemplate, PlayerStatus) ->
	if
		ItemTemplate#ets_item_template.need_career =/= 0 ->
			if
				ItemTemplate#ets_item_template.need_career =/= PlayerStatus#ets_users.career ->	
					error;
				true ->
					ok
			end;
		true ->
			ok
	end.


%%todo不加判断，如果穿上的格子不合适，自动找合适的格子	
move_item_to_equip(State, FromItem, PlayerStatus) ->	
%% 	FromTemplate = 	item_util:get_item_template(FromItem#ets_users_items.template_id),	
	FromTemplate = data_agent:item_template_get(FromItem#ets_users_items.template_id),
	case check_item_to_equip(FromTemplate, PlayerStatus) of
		{error} ->
			{error, State};
		{ok} ->
			%%查找装备格子，没格子不能安装
	        Cell = item_util:get_equip_cell(FromTemplate#ets_item_template.category_id),
	        if 
		        Cell < 0 ->
			       {error, State};
		        true ->
			         case item_util:get_user_item_by_place(State#item_status.user_id, Cell) of
				        [] ->
							lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_HAS_EQUIPMENT,{Cell,1}}]),
					       OldCell = FromItem#ets_users_items.place,
					       NewFromItem = change_item_cell(FromItem, Cell),
						   %%装备后绑定
						   if
							   NewFromItem#ets_users_items.is_bind =:= ?NOBIND 
														    andalso FromTemplate#ets_item_template.bind_type =:= ?BING_TYPE_0 ->
								   NewFromItem1 = lib_item:change_item_isbind(NewFromItem, ?BIND);
							   true ->
								   NewFromItem1 = NewFromItem
						   end, 
						
					       NewNullCells = lists:sort([OldCell|State#item_status.null_cells]),
					       NewState = State#item_status{null_cells=NewNullCells},
					         {ok, NewState, [NewFromItem1], [OldCell]};
				        [ToItem] ->
					       FromPlace = FromItem#ets_users_items.place,
					       NewFromItem = change_item_cell(FromItem, ToItem#ets_users_items.place),		
						   %%装备后绑定
						   if
							   NewFromItem#ets_users_items.is_bind =:= ?NOBIND 
														    andalso FromTemplate#ets_item_template.bind_type =:= ?BING_TYPE_0 ->
								   NewFromItem1 = lib_item:change_item_isbind(NewFromItem, ?BIND);
							   true ->
								   NewFromItem1 = NewFromItem
						   end, 					
						   						   
					       ToFromItem = change_item_cell(ToItem, FromPlace),
					         {ok, State, [NewFromItem1|[ToFromItem]], []}
			        end
	       end
	end.

%%todo from装备判断
move_item_from_equip(State, FromItem, ToPlace, MaxCount, PlayerStatus) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, ToPlace) of
		[] ->
			OldCell = FromItem#ets_users_items.place,
			if 
 				ToPlace > MaxCount + ?BAG_BEGIN_CELL - 1 ->
					if
						State#item_status.null_cells =:= [] ->
							{error, State};
						true ->
							[Cell|_] = State#item_status.null_cells,
							NewFromItem = change_item_cell(FromItem, Cell),
							NewNullCells = lists:delete(Cell, State#item_status.null_cells),
							NewState = State#item_status{null_cells=NewNullCells},
							{ok, NewState, [NewFromItem], [OldCell]}
					end;
				true ->
					Cell = ToPlace,
					NewFromItem = change_item_cell(FromItem, Cell),
					NewNullCells = lists:delete(Cell, State#item_status.null_cells),
					NewState = State#item_status{null_cells=NewNullCells},
					{ok, NewState, [NewFromItem], [OldCell]}
			end;
		[ToItem] ->
			move_item_from_equip_1(State, FromItem, ToItem, PlayerStatus)
	end.

%%类型相同交换位置
move_item_from_equip_1(State, FromItem, ToItem, PlayerStatus) ->
	FromTemplate = data_agent:item_template_get(FromItem#ets_users_items.template_id),
	ToTemplate = data_agent:item_template_get(ToItem#ets_users_items.template_id),
	if	
		FromTemplate#ets_item_template.category_id =:= ToTemplate#ets_item_template.category_id ->
			move_item_from_equip_2(State,FromItem);
%% 			case check_item_to_equip(ToTemplate, PlayerStatus) of
%% 				{ok} ->
%% 					
%% 					FromPlace = FromItem#ets_users_items.place,
%% 					NewFromItem = change_item_cell(FromItem, ToItem#ets_users_items.place),
%% 					ToFromItem = change_item_cell(ToItem, FromPlace),
%% 					{ok, State, [NewFromItem|[ToFromItem]],[]};
%% 				_ ->
%% 					move_item_from_equip_2(State,FromItem)
%% 			end;
		true ->
			move_item_from_equip_2(State,FromItem)
	end.

%%装备类型不同
move_item_from_equip_2(State, FromItem) ->
	if
		length(State#item_status.null_cells) > 0 ->
			[Cell|NewNullCells1] = State#item_status.null_cells,			
			OldCell = FromItem#ets_users_items.place,
			NewFromItem = change_item_cell(FromItem, Cell),
			NewState = State#item_status{null_cells=NewNullCells1},
			{ok, NewState, [NewFromItem], [OldCell]};
		true ->
			{error, State}
	end.


%%物品整理
array_item(ItemStatus, MaxCell, BagType) ->
	case BagType of
		?BAG_TYPE_COMMON ->
			ItemList = item_util:get_bag_list(ItemStatus#item_status.user_id),		
			ItemList1 = item_util:sort(ItemList, template_id),
			[Num, _] = lists:foldl(fun array_item_1/2, [?BAG_BEGIN_CELL, {}], ItemList1),
			NewItemList = item_util:get_bag_list(ItemStatus#item_status.user_id),
%% 			NullCells = lists:seq(Num, MaxCell + ?BAG_BEGIN_CELL - 1),
			NullCells = 
				case Num > MaxCell + ?BAG_BEGIN_CELL - 1 of
					true ->
						[];
					_ ->
						lists:seq(Num, MaxCell + ?BAG_BEGIN_CELL - 1)
				end,
			
			NewItemStatus = ItemStatus#item_status{null_cells = NullCells },
			{common_bag, NewItemStatus, NewItemList, NullCells};
		?BAG_TYPE_STORE ->
			ItemList = item_util:get_depot_bag_list(ItemStatus#item_status.user_id),
			ItemList1 = item_util:sort(ItemList, template_id),
			[Num, _] = lists:foldl(fun array_item_1/2, [?DEPOT_BEGIN_CELL, {}], ItemList1),
			NewItemList = item_util:get_depot_bag_list(ItemStatus#item_status.user_id),
%% 			NullCells = lists:seq(Num, MaxCell + ?DEPOT_BEGIN_CELL - 1),
			NullCells = 
				case Num > MaxCell + ?DEPOT_BEGIN_CELL - 1 of
					true ->
						[];
					_ ->
						lists:seq(Num, MaxCell + ?DEPOT_BEGIN_CELL - 1)
				end,
		
			NewItemStatus = ItemStatus#item_status{depot_null_cells = NullCells },
			{store_bag, NewItemStatus, NewItemList, NullCells};
		_ ->
			{fail}
	end.

%%整理背包
array_item_1(ItemInfo, [Cell,OldItemInfo]) ->
    case is_record(OldItemInfo, ets_users_items) of
        %%与上一格子物品类型相同
        true when ItemInfo#ets_users_items.template_id =:= OldItemInfo#ets_users_items.template_id
                  andalso ItemInfo#ets_users_items.is_bind =:= OldItemInfo#ets_users_items.is_bind ->
			array_item_2(ItemInfo,[Cell, OldItemInfo]);
        %%与上一格子类型不同
		true ->
            NewItemInfo = change_item_cell(ItemInfo, Cell),
            [Cell + 1, NewItemInfo];
        false ->
 			NewItemInfo = change_item_cell(ItemInfo, Cell),
            [Cell + 1, NewItemInfo]
    end.

array_item_2(ItemInfo, [Cell, OldItemInfo]) ->
	Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	case Template#ets_item_template.max_count > 1 of
		true -> 
			[NewItemCount, OldItemCount] = update_overcount_items(OldItemInfo, [ItemInfo#ets_users_items.amount, Template#ets_item_template.max_count]),
			case NewItemCount > 0 of
				%%还有剩余
				true ->
					NewItemInfo = change_item_cell(ItemInfo,Cell),
					NewItemInfo1 = change_item_num(NewItemInfo, NewItemCount),	%%整理背包不记录日志
                    [Cell + 1, NewItemInfo1];
				%%没有剩余
				false ->
					delete_item(ItemInfo, {0,?CONSUME_ITEM_ARRANGE,ItemInfo#ets_users_items.user_id,0}),%背包整理，不计算等级
					NewOldItemInfo = OldItemInfo#ets_users_items{ amount=OldItemCount },
					[Cell, NewOldItemInfo]
			end;
		%%不可叠加
		false ->
			NewItemInfo = change_item_cell(ItemInfo, Cell),
			[Cell+1, NewItemInfo]
	end.

%%更新原有的可叠加物品
update_overcount_items(ItemInfo, [Count, MaxCount]) ->
	if ItemInfo#ets_users_items.amount =/= MaxCount  ->
		   case Count + ItemInfo#ets_users_items.amount > MaxCount of
			   %%总数超出可叠加数
			   true ->
				   OldAmount = MaxCount,
				   NewAmount = Count + ItemInfo#ets_users_items.amount - MaxCount;
			   false ->
				   OldAmount = Count + ItemInfo#ets_users_items.amount,
				   NewAmount = 0
		   end,
		   change_item_num(ItemInfo, OldAmount);
	   true ->
		   NewAmount = Count,
		   OldAmount = MaxCount
	end,
	[NewAmount,OldAmount].

%%检查仓库取款 存款操作
check_depot_copper(PlayerStatus, Type, Copper) ->
	PlayerCopper = PlayerStatus#ets_users.copper,
	PlayerDepotCopper =  PlayerStatus#ets_users.depot_copper,
	case Type of
		?DEPOSITMONEY ->
			if
				PlayerCopper >= Copper->
					{ok, (PlayerDepotCopper+Copper), 0, Copper};
				true ->
					{error, "存款失败"}
			end;
		?DRAWMONEY ->
			if
				PlayerDepotCopper >= Copper ->
					{ok, (PlayerDepotCopper-Copper), Copper, 0};
				true ->
					{error, "取款失败"}
			end
	end.
			
 
%%道具拆分
split_item(State, Place, Count) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, Place) of
		[ItemInfo] ->
			if
				length(State#item_status.null_cells) > 0 andalso Count < ItemInfo#ets_users_items.amount andalso Count > 0 ->
					OldItemInfo = change_item_num(ItemInfo, ItemInfo#ets_users_items.amount - Count),%%才分道具不入日志
					[Cell|NewNullCells] = State#item_status.null_cells,
					NewState = State#item_status{null_cells = NewNullCells},
					
					Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
					
%%					Item = item_util:create_new_item(Template, Count, Cell, State#item_status.user_id),
					Item = item_util:create_new_item(Template, Count, Cell, State#item_status.user_id, ItemInfo#ets_users_items.is_bind, ItemInfo#ets_users_items.strengthen_level),
					
					
		  			NewItemInfo = lib_item:add_item(Item),				
					{ok, NewState, [OldItemInfo|[NewItemInfo]]};
				true ->
					{error, State}
			end;
		[] ->
			{error, State}
	end.
 
%%道具回收
item_retrieve(State, Place) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, Place) of
		[ItemInfo] ->
			Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			if
				Template#ets_item_template.can_recycle =:= 1 ->					
					delete_item(ItemInfo, {0,?CONSUME_ITEM_RETRIEVE,State#item_status.user_id,State#item_status.level}),
					NewNullCells = lists:sort([Place|State#item_status.null_cells]),
					NewState = State#item_status{null_cells = NewNullCells},				
					case item_util:open_item_script(Template#ets_item_template.script, State) of
						{ok, [AddCopper, AddBinCopper, AddYuanBao, AddBindYuanBao, ItemList]} ->
							{ok, NewState, ItemList, AddYuanBao, AddBindYuanBao, AddCopper, AddBinCopper};	
						
						{error} -> 
                           {error, State}
					end;
				true ->
					{error, State}
			end;
		[] ->
			{error, State}
	end.

%%道具出售
item_sell(State, Place, Count) ->
	ItemInfo = 
		case item_util:get_user_item_by_place(State#item_status.user_id, Place) of
			[] ->
				[];
			[Item] ->
				Item
		end,
	if
		is_record(ItemInfo, ets_users_items) =:= true andalso ItemInfo#ets_users_items.amount >= Count ->
			Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			if is_record(Template, ets_item_template) andalso Template#ets_item_template.can_sell =:= 1 ->
					case Template#ets_item_template.sell_type of
						?NOBINDCOPPER ->
							AddCopper = Template#ets_item_template.sell_copper * Count,
							AddBindCopper = 0;
						
						_ ->  % 其他按绑定算
							AddCopper = 0,
							AddBindCopper = Template#ets_item_template.sell_copper * Count
					end,
					item_sell_2(AddCopper, AddBindCopper, ItemInfo, Place, Count, State);
				true ->
					{error, State}
			end;
		true -> 
			{error, State}
	end.


%%出售物品
item_sell_2(AddCopper, AddBindCopper, ItemInfo, Place, Count, State) ->
	%lib_statistics:add_item_log(ItemInfo#ets_users_items.template_id, ?ITEM_DECOMPSE, Count),
	if
		ItemInfo#ets_users_items.amount =:= Count ->
			NewNullCells = lists:sort([Place|State#item_status.null_cells]),
			delete_item(ItemInfo, {0,?CONSUME_ITEM_SELL,State#item_status.user_id,State#item_status.level}),
			NewState = State#item_status{null_cells = NewNullCells},
			[1, NewState, [], [Place], AddCopper, AddBindCopper];
		
		true ->
			NewItemInfo = reduce_item_num(ItemInfo, {ItemInfo#ets_users_items.amount - Count,?CONSUME_ITEM_SELL,State#item_status.level,State#item_status.user_id}),
			[1, State, [NewItemInfo], [], AddCopper, AddBindCopper]
	end.


%% 喂养
item_feed(State,List) ->
	F = fun(Place,{State1,PL,Exp}) ->
				ItemInfo = 
					case item_util:get_user_item_by_place(State1#item_status.user_id, Place) of
						[] ->
							[];
						[Item] ->
							Item
					end,
				if
					is_record(ItemInfo, ets_users_items) =:= true ->
						Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
						if is_record(Template, ets_item_template) andalso Template#ets_item_template.can_feed =:= 1 ->
							   AddExp = Template#ets_item_template.feed_count * ItemInfo#ets_users_items.amount,
							   State2 = item_feed_1(ItemInfo, Place, State1),
							   {State2,[Place|PL],Exp+AddExp};						   	
						   true ->
							   {State1,PL,Exp}
						end;
					true ->
						 {State1,PL,Exp}				
				end
		end,
	{NewState,PL1,AllExp} = lists:foldl(F, {State,[],0}, List),
	
	[1,NewState,[],PL1,AllExp].

item_feed_1( ItemInfo, Place, State) ->
	Count = ItemInfo#ets_users_items.amount,
	NewNullCells = lists:sort([Place|State#item_status.null_cells]),
	delete_item(ItemInfo, {0,?CONSUME_ITEM_FEED,State#item_status.user_id,State#item_status.level}),
	State#item_status{null_cells = NewNullCells}.

		
	
%% 	if 
%% 		length(State#item_status.temp_bag) =< ?TEMP_BAG_MAX_CELL ->
%% 			if
%% 				ItemInfo#ets_users_items.amount =:= Count ->	
%% 					NewNullCells = lists:sort([Place|State#item_status.null_cells]),									
%% 					
%% 					delete_item(ItemInfo, 0),
%% %%					delete_item(ItemInfo, 1),	
%% 					
%% 					Cell = State#item_status.temp_bag_place,					
%% 					ItemInfo1 = ItemInfo#ets_users_items{place = Cell},						
%% 					NewTempBag = [ItemInfo1|State#item_status.temp_bag],					
%% 					NewState = State#item_status{null_cells = NewNullCells,
%% 										         temp_bag   = NewTempBag,
%% 												 temp_bag_place = Cell+1},									
%% 					[1, NewState, [], [Place], AddCopper, AddBindCopper, ItemInfo1, []];
%% 				true ->
%% 					NewItemInfo = change_item_num(ItemInfo, ItemInfo#ets_users_items.amount - Count),					
%% 					Cell = State#item_status.temp_bag_place,					
%% 					ItemInfo1 = ItemInfo#ets_users_items{place = Cell},						
%% 					NewTempBag = [ItemInfo1|State#item_status.temp_bag],
%% 					NewState = State#item_status{temp_bag = NewTempBag,
%% 												 temp_bag_place = Cell+1},
%% 			[1, NewState, [NewItemInfo], [], AddCopper, AddBindCopper, ItemInfo1, []]
%% 			end;
%% 		
%% 		
%% 		true ->
%% 			if
%% 				ItemInfo#ets_users_items.amount =:= Count ->	
%% 					NewNullCells = lists:sort([Place|State#item_status.null_cells]),
%% 					delete_item(ItemInfo, 1),
%% 					
%% 					Term = lists:last(State#item_status.temp_bag),
%% 					TempBag = lists:delete(Term, State#item_status.temp_bag),										
%% 					NewState = State#item_status{null_cells = NewNullCells, 
%% 												 temp_bag   = TempBag},												
%% 					Cell = NewState#item_status.temp_bag_place,					
%% 					ItemInfo1 = ItemInfo#ets_users_items{place = Cell},					
%% 					NewTempBag = [ItemInfo1|NewState#item_status.temp_bag],					
%% 					NewState1 = NewState#item_status{temp_bag   = NewTempBag,
%% 													 temp_bag_place = Cell+1},			
%% 					[1, NewState1, [], [Place], AddCopper, AddBindCopper, ItemInfo1, [Term#ets_users_items.place]];
%% 				true ->
%% 					NewItemInfo = change_item_num(ItemInfo, ItemInfo#ets_users_items.amount - Count),																
%% 					Term = lists:last(State#item_status.temp_bag),
%% 					TempBag = lists:delete(Term, State#item_status.temp_bag),										
%% 					NewState = State#item_status{temp_bag = TempBag},						
%% 					Cell = NewState#item_status.temp_bag_place,					
%% 					ItemInfo1 = ItemInfo#ets_users_items{place = Cell},						
%% 					NewTempBag = [ItemInfo1|NewState#item_status.temp_bag],					
%% 					NewState1 = NewState#item_status{temp_bag = NewTempBag,
%% 												     temp_bag_place = Cell+1},				
%% 			[1, NewState1, [NewItemInfo], [], AddCopper, AddBindCopper, ItemInfo1, [Term#ets_users_items.place]]
%% 			end
%% 	end.
%% 		

%%道具回购
item_buy_back(ItemInfo, State) ->
	 [Cell|NewNullCells] = State#item_status.null_cells,  
	 NewTempBag = lists:delete(ItemInfo, State#item_status.temp_bag), 
	 DeleteList  = ItemInfo#ets_users_items.place,  
	 ItemInfo1 = ItemInfo#ets_users_items{place = Cell},
	 NewState  = State#item_status{null_cells = NewNullCells,
								   temp_bag   = NewTempBag},	 
	 NewItemInfo = lib_item:add_item(ItemInfo1),
	 {ok, NewState, [NewItemInfo], [DeleteList]}.

get_iteminfo_by_tempbag(Place, Lists) ->
	Even = fun(L) ->(fun(X)-> X#ets_users_items.place =:= L end) end,
	Pred = Even(Place),
	lists:filter(Pred , Lists).

%%使用判断
check_item_use(Place, ItemStatus, Level, Location) ->
	case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, Place) of
		[ItemInfo] ->
			case data_agent:item_template_get(ItemInfo#ets_users_items.template_id) of
				[] ->
					{error};
				Template when(Template#ets_item_template.can_use =:= 1)->
					{MapId,PosX,PosY} = Location,
					Is_Copy_Scene = lib_map:is_copy_scene(MapId),
					if
						%%背包扩充判断
						Template#ets_item_template.category_id =:= ?CATE_EXPANSION ->
							if
								ItemStatus#item_status.maxbagnull >= ?MAXCOMMONCOUNT ->
									{error};
								true ->
									{ok, ItemInfo, Template}
							end;
						%%仓库扩充判断
						Template#ets_item_template.category_id =:= ?CATE_DEPOT_EXPANSION ->
							if
								ItemStatus#item_status.maxdepotnull >= ?MAXDEPOTCOUNT ->
									{error};
								true ->
									{ok, ItemInfo, Template}
							end;	
						%% vip 卡会产生物品
						Template#ets_item_template.category_id =:= ?CATE_VIPCARD ->
							if
								erlang:length(ItemStatus#item_status.null_cells) < Template#ets_item_template.propert2 ->
									{error};
								true ->
									{ok, ItemInfo, Template}
							end;

						Template#ets_item_template.need_level > Level ->
							{error};
						
						Is_Copy_Scene =:= true andalso Template#ets_item_template.category_id =:= ?CATE_CARRY_CITY ->
							{error};
						Is_Copy_Scene =:= true andalso Template#ets_item_template.category_id =:= ?CATE_CARRY_SHOE ->
							{error};
						Template#ets_item_template.category_id =:= ?CATE_MOUNTS ->
							case lib_mounts:check_mounts_count(ItemStatus#item_status.pid) of
								{ok} ->
									{ok, ItemInfo, Template};
								_ ->
									{error}
							end;
						Template#ets_item_template.category_id =:= ?CATE_TREASURE_MAP ->
							if
								Template#ets_item_template.propert1 =:= MapId andalso
								abs(Template#ets_item_template.propert2 - PosX) =< 75 andalso
								abs(Template#ets_item_template.propert3 - PosY) =< 75 ->
									{ok, ItemInfo, Template};
								true ->
									?DEBUG("location is error:~p",[Template]),
									{error}
							end;
						Template#ets_item_template.category_id =:= ?CATE_MOUNTS_SKILL_BOOK ->
							case lib_mounts:check_skill_use(Template,ItemStatus#item_status.pid) of
								{ok} ->
									{ok, ItemInfo, Template};
								_ ->
									{error}
							end;
						true ->
							{ok, ItemInfo, Template}
					end;
				_ ->
					{error}
			end;
		[] ->
			{error}
	end.


check_item_use(Place,Count, ItemStatus ) ->
	case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, Place) of
		[ItemInfo] ->
			case data_agent:item_template_get(ItemInfo#ets_users_items.template_id) of
				[] ->
					{error};
				Template when(Template#ets_item_template.can_use =:= 1) ->
					if
						ItemInfo#ets_users_items.amount >= Count ->
							{ok, ItemInfo, Template};
						true ->
							{error}					
					end;
				_ ->
					{error}
			end;
		[] ->
			{error}
	end.


%%物品使用cd 判断
item_use(ItemInfo, Template, State) ->
	CdTime = get({?ITEM_CD, Template#ets_item_template.category_id}),
	Now = misc_timer:now_milseconds(),
	if 
		CdTime =:= undefined orelse CdTime < Now ->
			 NextCdTime = Now + Template#ets_item_template.cd,
			 put({?ITEM_CD, Template#ets_item_template.category_id}, NextCdTime),
			 item_use_1(ItemInfo, Template, State);
		
		true ->
			{error, "cdtime"}
	end.
			
%%道具使用
item_use_1(ItemInfo, Template, State) ->
	if
		ItemInfo#ets_users_items.amount =:= 1 ->
			NewNullCells = lists:sort([ItemInfo#ets_users_items.place|State#item_status.null_cells]),
			NewState = State#item_status{null_cells = NewNullCells},
			delete_item(ItemInfo, {0,?CONSUME_ITEM_USE,State#item_status.user_id,State#item_status.level}),
			DeleteList = [ItemInfo#ets_users_items.place],
			NewItemInfo = [];
		true ->
			NewItemInfo =[reduce_item_num(ItemInfo, {ItemInfo#ets_users_items.amount -1,?CONSUME_ITEM_USE,State#item_status.level,State#item_status.user_id})],
			NewState = State,
			DeleteList = []
	end,
	case Template#ets_item_template.category_id of
		?CATE_REDINSTANT -> %%补血
			{add_hp_mp, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert2, 0]};		
		?CATE_BLUEINSTANT ->%%魔法
			{add_hp_mp, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert2]};
		?CATE_REDPACKAGE -> %%需要改为持续 补血
			{add_hp_mp, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert2, 0]};		
		?CATE_BLUEPACKAGE ->%%需要改为持续 魔法
			{add_hp_mp, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert2]};
		?CATE_ACTIVITY ->   %%集锦类
			case item_util:open_item_script(Template#ets_item_template.script, NewState) of
				{ok, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList1, MailItemList, NewState1]} ->
					{open_box, [NewState1, lists:append(ItemList1, NewItemInfo), DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao,MailItemList]};
				_ -> 
					{error, "open bag is error."}
			end;	
		?CATE_BOX ->   %%礼包
			case item_util:open_item_script(Template#ets_item_template.script, NewState) of
				{ok, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList1, MailItemList, NewState1]} ->		
					{open_box, [NewState1, lists:append(ItemList1, NewItemInfo), DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao,MailItemList]};
				_ -> 
					{error, "open bag is error."}
			end;
		?CATE_NOVICE_BOX ->   %%新手礼包
			case item_util:open_item_script(Template#ets_item_template.script, NewState) of
				{ok, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, ItemList1, MailItemList, NewState1]} ->									
					{open_box, [NewState1, lists:append(ItemList1, NewItemInfo), DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao,MailItemList]};
				_ -> 
					{error, "open bag is error."}
			end;	
		?CATE_HORN ->      %%喇叭	
			{chat_horn, [NewItemInfo, DeleteList, NewState]};
		?CATE_CURREXP ->   %%经验
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1, 0, 0]};
		?CATE_LIFTEXP ->   %%历练
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert1, 0]};
		?CATE_MOON_CAKE ->%% 月饼
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1, Template#ets_item_template.propert2, 0]};
		?CATE_ADD_EXPLOIT ->%% 功勋增长
			{add_curexp_exploit, [NewState, NewItemInfo, DeleteList,Template#ets_item_template.propert1]};
		?CATE_ADD_PET_EXP ->%%宠物经验增长
			{add_curexp_pet_exp, [NewState, NewItemInfo, DeleteList,Template#ets_item_template.propert1]};
		?CATE_ADD_PHYSICAL -> %%体力
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, 0, 0, Template#ets_item_template.propert1]};
		?CATE_BUFF ->      %%buff
			{add_buff, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert5]};	
		?CATE_WINE ->
			{add_buff, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert5]};
			
		?CATE_INCOME  ->   %%银票(增加非绑定的铜币)
			if
				ItemInfo#ets_users_items.is_bind =:= 0 ->
					{add_copper, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1, 0]};
				true ->
					{add_copper, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert1]}
			end;

			
		?CATE_EXPANSION -> %%背包扩充
			{add_expansion, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1, 0]};
		?CATE_DEPOT_EXPANSION -> %%仓库扩充
			{add_expansion, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert1]};
		
		?CATE_CARRY_CITY -> %%回城符  (暂时回到门派出生点)
			{return_to_city, [NewState, NewItemInfo, DeleteList]};
		?CATE_CARRY_SHOE -> %%随机传送鞋
			{random_to_transfer, [NewState, NewItemInfo, DeleteList]};
		?CATE_TREASURE_MAP -> %%藏宝图
			{enter_treasure_map, [NewState, NewItemInfo, DeleteList]};
		?CATE_REDUCE_PK_VALUE ->
			{reduce_pk_value, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1]};
		?CATE_DMOGORGON ->%%神魔令
			{shenmo_accept_task, [NewState, NewItemInfo, DeleteList, ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2]};
		?CATE_VIPCARD -> %%VIP卡
			{vip_card, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1]};
		?CATE_MOUNTS -> %% 坐骑卡
			{mounts_card,[NewState,NewItemInfo,DeleteList]};
		?CATE_MOUNTS_SKILL_BOOK -> %% 坐骑技能书
			{mounts_skill,[NewState,NewItemInfo,DeleteList]};
		?CATE_ADD_USER_TITLE -> %%增加称号
			{add_user_title,[NewState,NewItemInfo,DeleteList, Template#ets_item_template.propert1]};
		_ ->
			{other, [NewState, NewItemInfo, DeleteList]}
%% 			{error, "cate is not use."}
	end.


%%物品使用cd 判断
item_use(ItemInfo, Count,Template, State) ->
	CdTime = get({?ITEM_CD, Template#ets_item_template.category_id}),
	Now = misc_timer:now_milseconds(),
	if 
		CdTime =:= undefined orelse CdTime < Now ->
			 NextCdTime = Now + Template#ets_item_template.cd,
			 put({?ITEM_CD, Template#ets_item_template.category_id}, NextCdTime),
			 item_use_1(ItemInfo, Count,Template, State);
		
		true ->
			{error, "cdtime"}
	end.
		

%%道具使用
item_use_1(ItemInfo, Count,Template, State) ->
	if
		ItemInfo#ets_users_items.amount =:= Count ->
			NewNullCells = lists:sort([ItemInfo#ets_users_items.place|State#item_status.null_cells]),
			NewState = State#item_status{null_cells = NewNullCells},
			delete_item(ItemInfo, {0,?CONSUME_ITEM_USE,State#item_status.user_id,State#item_status.level}),
			DeleteList = [ItemInfo#ets_users_items.place],
			NewItemInfo = [];
		true ->
			NewItemInfo =[reduce_item_num(ItemInfo, {ItemInfo#ets_users_items.amount -Count,?CONSUME_ITEM_USE,State#item_status.level,State#item_status.user_id})],
			NewState = State,
			DeleteList = []
	end,
	case Template#ets_item_template.category_id of
		?CATE_BOX ->   %%礼包
			open_box_batch(Count,{Template,NewState,NewItemInfo,DeleteList,0,0,0,0,[]});
		?CATE_CURREXP ->   %%经验
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1*Count, 0, 0]};
		?CATE_LIFTEXP ->   %%历练
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert1*Count, 0]};
		?CATE_ADD_PHYSICAL -> %%体力
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, 0, 0, Template#ets_item_template.propert1*Count]};
		?CATE_MOON_CAKE ->%% 月饼
			{add_curexp_lifexp_phy, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1*Count, Template#ets_item_template.propert2*Count, 0]};
		?CATE_INCOME  ->   %%银票(增加非绑定的铜币)
			if
				ItemInfo#ets_users_items.is_bind =:= 0 ->
					{add_copper, [NewState, NewItemInfo, DeleteList, Template#ets_item_template.propert1 * Count, 0]};
				true ->
					{add_copper, [NewState, NewItemInfo, DeleteList, 0, Template#ets_item_template.propert1 * Count]}
			end;

		_ ->
			{other, [NewState, NewItemInfo, DeleteList]}
%% 			{error, "cate is not use."}
	end.

open_box_batch(0,{_Template,NewState,NewItemInfo,DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao,MailItemList}) ->
	{open_box, [NewState, NewItemInfo, DeleteList, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao,MailItemList]};

open_box_batch(Count,{Template,NewState,NewItemInfo,ODeleteList, OAddCopper, OAddBindCopper, OAddYuanBao, OAddBindYuanBao,OMailItemList}) ->
	case item_util:open_item_script(Template#ets_item_template.script, NewState) of
		{ok, [AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, NewItemList, MailItemList, NewState1]} ->	
			F = fun(ItemInfo,List) ->
						case lists:keyfind(ItemInfo#ets_users_items.place, #ets_users_items.place, List) of
							false ->
								List ++ [ItemInfo];
							_ ->
								lists:keyreplace(ItemInfo#ets_users_items.place, #ets_users_items.place, List, ItemInfo)
						end
				end,
			NewItemList1 = lists:foldl(F,NewItemInfo , NewItemList),
			open_box_batch(Count-1,{Template,NewState1,NewItemList1, ODeleteList, OAddCopper+AddCopper, OAddBindCopper+AddBindCopper, OAddYuanBao+AddYuanBao, OAddBindYuanBao+AddBindYuanBao,lists:append(OMailItemList,MailItemList)});
		_ ->
			{error, "open bag is error."}
	end.


%% %%判断付款类型 return {BindCopper, Copper, BindYuanBao, YunBao}
%% check_pay_type(Template, Amount, YuanBao, BindYuanBao, Copper, BindCopper, ShopTemplate) ->
%% 	ReduceCopper = Template#ets_item_template.copper * Amount,
%% 	ReduceBindCopper = Template#ets_item_template.copper * Amount,
%% 	ReduceYuanBao = Template#ets_item_template.yuan_bao * Amount,
%% 	ReduceBindYuanBao = Template#ets_item_template.yuan_bao * Amount,
%% 	if				
%% 		ShopTemplate#ets_shop_template.pay_type =:= 0 
%% 		  andalso (Copper + BindCopper) >=  ReduceBindCopper ->
%% 			{ReduceBindCopper, 0, 0, 0};		
%% 		ShopTemplate#ets_shop_template.pay_type =:= 1 
%% 		  andalso YuanBao  >= ReduceYuanBao ->
%% 			{0, 0, 0, ReduceYuanBao};
%% 		ShopTemplate#ets_shop_template.pay_type =:= 2
%% 		  andalso (BindYuanBao + YuanBao) >= ReduceBindYuanBao ->
%% 			{0, 0, ReduceBindYuanBao, 0};	
%% 		ShopTemplate#ets_shop_template.pay_type =:= 3 
%% 		  andalso Copper >= ReduceCopper ->
%% 			{0, ReduceCopper, 0, 0};
%% 		true ->
%% 			{error}
%% 	end.

%%判断付款类型 return {BindCopper, Copper, BindYuanBao, YunBao}
check_pay_type(Amount, YuanBao, BindYuanBao, Copper, BindCopper, ShopTemplate) ->
	ReduceValue = ShopTemplate#ets_shop_template.price * Amount,
	if				
		ShopTemplate#ets_shop_template.pay_type =:= 0 
		  andalso (Copper + BindCopper) >=  ReduceValue ->
			{ReduceValue, 0, 0, 0};		
		ShopTemplate#ets_shop_template.pay_type =:= 1 
		  andalso YuanBao  >= ReduceValue ->
			{0, 0, 0, ReduceValue};
		ShopTemplate#ets_shop_template.pay_type =:= 2
		  andalso BindYuanBao >= ReduceValue ->
			{0, 0, ReduceValue, 0};	
		ShopTemplate#ets_shop_template.pay_type =:= 3 
		  andalso Copper >= ReduceValue ->
			{0, ReduceValue, 0, 0};
		ShopTemplate#ets_shop_template.pay_type =:= 8 ->
			{guild_feats, ReduceValue};						%帮派个人贡献购买
		true ->
			{error}
	end.

%%自动购买并使用，所以就直接使用物品
pay_buy(YuanBao, BindYuanBao, Copper, BindCopper, ShopId, TemplateId, Amount)->
	%%?DEBUG("dhwang_test--TemplateId:~p",[TemplateId]),
	%%?DEBUG("dhwang_test--TemplateId:~p",[ShopId]),
	case item_util:get_shop_template(ShopId, TemplateId) of
		[] ->
			{error};
		[ShopTemplate|_] ->		
			if is_record(ShopTemplate, ets_shop_template) ->		
				%%?DEBUG("dhwang_test--ShopTemplate:~p",[ShopTemplate]),
				case check_pay_type(Amount, YuanBao, BindYuanBao, Copper, BindCopper, ShopTemplate) of
					{guild_feats, Feats} ->
						{guild_feats, Feats};
					{error} ->
						{error};
					{ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao} ->
						{ok, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao}	
				end;
			true ->
				{error}
			end
	end.
%%神木蚕丝兑换道具
check_item_exchang_buy(ShopItemID,Amount,State) ->
	if
		Amount >= ?MINAMOUNT andalso Amount < ?MAXAMOUNT -> 
			case data_agent:shop_template_get(ShopItemID) of
				ShopTemplate when is_record(ShopTemplate, ets_shop_template) ->
					case data_agent:item_template_get(ShopTemplate#ets_shop_template.template_id) of
						[] ->
							{error, ?ER_NOT_EXSIT_DATA};
						ItemTemplate ->
							NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
							if
								NeedCellNum > erlang:length(State#item_status.null_cells)->
											{error, ?ER_NOT_ENOUGH_BAG};
								true ->
									ExItemId = case ShopTemplate#ets_shop_template.pay_type of
										?CURRENCY_TYPE_TIMBER ->
											?ITEM_ID_TIMBER_PATCH;
										?CURRENCY_TYPE_SILK ->
											?ITEM_ID_SILK_PATCH;
										?CURRENCY_TYPE_MOONCAKE ->
											?ITEM_ID_MONNCAKE_PATCH;
										_ ->
											0
									end,
									if
										ExItemId =:= 0 ->
											{error, ?ER_PAY_TYPE};
										true ->
											{ItemList, Count} = get_bag_item_list_by_templateId(ExItemId, State#item_status.user_id),
											if
												ShopTemplate#ets_shop_template.price * Amount =< Count ->
													{ok, ItemTemplate, ItemList, ShopTemplate#ets_shop_template.price * Amount};%%兑换出来物品全部绑定
												true ->
													{error, ?ER_NOT_ENOUGH_MATERIAL}
											end
									end
							end
					end;
				_ ->
					{error, ?ER_WRONG_VALUE}
			end;
		true ->
			{error, ?ER_WRONG_VALUE}	
	end.

%%功勋兑换
check_exploit_buy(Exploit,ShopItemID,Amount,State) ->
	if
		Amount >= ?MINAMOUNT andalso Amount < ?MAXAMOUNT -> 
			case data_agent:shop_template_get(ShopItemID) of
				ShopTemplate when is_record(ShopTemplate, ets_shop_template) ->
					case data_agent:item_template_get(ShopTemplate#ets_shop_template.template_id) of
						[] ->
							{error_1};
						ItemTemplate ->
									NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
									if
										NeedCellNum > erlang:length(State#item_status.null_cells )->
											{error_2};
										true ->
											if
												ShopTemplate#ets_shop_template.pay_type =:= ?CURRENCY_TYPE_EXPLOIT
													andalso ShopTemplate#ets_shop_template.price * Amount =< Exploit ->
													{ok, ItemTemplate, ShopTemplate#ets_shop_template.is_bind, ShopTemplate#ets_shop_template.price * Amount};
												true ->
													{error_3}
											end
									end
					end;
				_ ->
					{error_4}
			end;
		true ->
			{error}	
	end.

%%购买判断
check_buy(YuanBao, BindYuanBao, Copper, BindCopper, ShopItemID, Amount, MapID,PosX,PosY, VipID,State) -> 
	if
		Amount >= ?MINAMOUNT andalso Amount < ?MAXAMOUNT -> 
			case data_agent:shop_template_get(ShopItemID) of
				ShopTemplate when is_record(ShopTemplate, ets_shop_template) ->
					case data_agent:item_template_get(ShopTemplate#ets_shop_template.template_id) of
						[] ->
							{error};
						ItemTemplate ->
							%%{ShopID,_,_} = ShopTemplate#ets_shop_template.shop_id,
							CheckPos = case data_agent:shop_npc_get(ShopTemplate#ets_shop_template.shop_id) of
										   [] ->
											   true;
										   ShopNPCTemplate when is_record(ShopNPCTemplate, ets_shop_npc_template) ->
											   case data_agent:npc_get(ShopNPCTemplate#ets_shop_npc_template.npc_id) of
												   [] ->
													   false;
												   NPC ->
													   if
														   NPC#ets_npc_template.map_id =:= MapID
														   andalso abs(NPC#ets_npc_template.pos_x - PosX) < ?BUG_ITEM_DISTANT 
														   andalso abs(NPC#ets_npc_template.pos_y - PosY) < ?BUG_ITEM_DISTANT ->
															   true;
														   true ->
															   false
													   end
											   end
									   end,
							if
								CheckPos =:= true orelse VipID > 0 ->
									NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
									if
										NeedCellNum > erlang:length(State#item_status.null_cells )->
											{bagfull};
										true ->
											case check_pay_type(Amount, YuanBao, BindYuanBao, Copper, BindCopper, ShopTemplate) of
%% 												{guild_feats, Feats} ->
%% 													{guild_feats, ShopTemplate#ets_shop_template.category_id, ItemTemplate, ShopTemplate#ets_shop_template.is_bind, Feats};
												{ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao} ->
													{ok, ItemTemplate, ShopTemplate#ets_shop_template.is_bind, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao};
												_ ->
													{error}
											end
									end;
								true ->
									{error}	
							end
					end;
				_ ->
					{error}
			end;
		true ->
			{error}	
	end.	

%%判断幸运符信息  并返回幸运符列表
func_check_place(-1, _State, _PlaceList, _LuckList) ->
	{error};
func_check_place(0, _State, _PlaceList, LuckList) ->
	{ok, LuckList};
func_check_place(Count, State, [Place|PlaceList], LuckList) ->
%%	[LuckInfo] = item_util:get_user_item_by_place(State#item_status.user_id, Place),
	LuckInfo = 
		case item_util:get_user_item_by_place(State#item_status.user_id, Place) of
			[] ->
				[];
			[Luck] ->
				Luck
		end,
	
	if
		is_record(LuckInfo, ets_users_items) =:= false ->
			func_check_place(-1, State, PlaceList, LuckList);
		true ->
			func_check_place(Count-1, State, PlaceList, lists:append(LuckList, [LuckInfo]))
	end.

%%装备强化判断
check_streng(State, ItemPlace, StonePlace, PetId, Copper, BindCopper) ->	
	if	PetId > 0 ->
			TempItemInfo = item_util:get_pet_equip_by_place(PetId, ItemPlace);
		true ->
			TempItemInfo = item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace)
	end,	
	TempStoneInfo = item_util:get_user_item_by_place(State#item_status.user_id, StonePlace),	
	if
		TempItemInfo =:= [] orelse TempStoneInfo =:= [] ->
			{error};
		true ->
			[ItemInfo] = TempItemInfo,
			[StoneInfo] = TempStoneInfo,
			ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),

					if
						is_record(ItemInfo, ets_users_items) =:= false orelse is_record(StoneInfo, ets_users_items) =:= false 
						  orelse ItemTemplate#ets_item_template.can_strengthen =/= 1
							orelse ItemInfo#ets_users_items.strengthen_level >= ?MAX_STRENGTHEN_LEVEL -> %%缺少等级与强化石等级判断
							{error1};						
						true ->		
							Strenglevel = ItemInfo#ets_users_items.strengthen_level div ?STRENGTHEN_LEVEL_UNIT,
							StrengthenTemplate = data_agent:item_strengthen_template_get(Strenglevel),
							if 
								is_record(StrengthenTemplate, ets_strengthen_template) =:= false 
										orelse StrengthenTemplate#ets_strengthen_template.need_stone =/= StoneInfo#ets_users_items.template_id
										orelse StrengthenTemplate#ets_strengthen_template.need_copper > Copper + BindCopper ->
									{error2};
								true ->
									{ok, ItemInfo, StoneInfo, StrengthenTemplate#ets_strengthen_template.need_copper}
							end
					end			
	end.
		
%% 减少幸运符列表
func_change_luckstone(LuckList, _PlaceList, State, ItemInfoList, DeleteList) ->
	FSort = fun(Info, Acc) ->
					case lists:keyfind(Info, 1, Acc)  of
						false ->
							[{Info, 1}|Acc];
						Tuple ->
							{Info, Amount} = Tuple,
							NewInfo = lists:keyreplace(Info, 1, Acc, {Info, Amount + 1}),
							NewInfo
					end
			end,
	NewLuckList = lists:foldl(FSort, [], LuckList),
	F = fun({Info, Amount}, [State1, InfoList, DeleteList1]) ->
				[NewState, NewInfo, Delete] = change_item_num_in_commonbag(Info, Info#ets_users_items.place, Amount, State1,?CONSUME_ITEM_USE),
				[NewState, lists:append(NewInfo, InfoList), lists:append(Delete, DeleteList1)]
		end,
	[NewState, ItemList1, DeleteList1] = lists:foldl(F, [State, [], []], NewLuckList),
	[NewState, lists:append(ItemList1, ItemInfoList), lists:append(DeleteList1, DeleteList)].


streng_stone_1(GuardTemplate, StrengLevel) ->	                                                               
	case GuardTemplate#ets_item_template.propert3 of
		1 ->
			case lists:member(StrengLevel, ?PRIMARYSTERENGLIST) of
				true ->
					{ok};
				false ->
					{error, "type is not conform1"}
			end;		
		2 ->
			case lists:member(StrengLevel, ?MIDDLESTRENGLIST) of
				true ->
					{ok};
				false ->
					{error, "type is not conform2"}
			end;		
		3 ->
			case lists:member(StrengLevel, ?HIGHTSTRENGLIST) of
				true ->
					{ok};
				false ->
					{error, "type is not conform3"}
			end;
		_ ->
			{error, "data is error"}
	end.
	

%%一键强化强化
item_streng_akey(State, ItemInfo, StoneInfo, StonePlace, GuardPlace, VipRate, Copper) ->			
	Level = ItemInfo#ets_users_items.strengthen_level div ?STRENGTHEN_LEVEL_UNIT,	
	StrengthenTemplate = data_agent:item_strengthen_template_get(Level),
	if is_record(StrengthenTemplate, ets_strengthen_template)=:= true ->			
			if GuardPlace > 0 ->
				case item_util:get_user_item_by_place(State#item_status.user_id, GuardPlace) of
					[] ->
						[NewState, NewInfo2, DeleteList2] = [State, [], []],
						IsProtect = 0;											
					[GuardInfo] when GuardInfo#ets_users_items.template_id =:= StrengthenTemplate#ets_strengthen_template.perfect_stone->
						[NewState, NewInfo2, DeleteList2] = change_item_num_in_commonbag(GuardInfo, GuardPlace, 1, State, ?CONSUME_ITEM_STRENG),
						IsProtect = 1;
					[_] ->
						[NewState, NewInfo2, DeleteList2] = [State, [], []],
						IsProtect = 0	
				end;
			true ->
				[NewState, NewInfo2, DeleteList2] = [State, [], []],
				IsProtect = 0
			end,
			if IsProtect =:= 1 ->  %%% 判断是否使用完美符
				[NewState2, NewInfo, DeleteList] = change_item_num_in_commonbag(StoneInfo, StonePlace, 1, NewState,?CONSUME_ITEM_STRENG),
				StrengNum = 1,
				Success = 1;
			true ->
				{ItemList, Amount} = get_bag_item_list_by_templateId(StoneInfo#ets_users_items.template_id, NewState#item_status.user_id),
				CanStrengNum1 = Copper div StrengthenTemplate#ets_strengthen_template.need_copper, 
				if CanStrengNum1 > Amount ->
					CanStrengNum = Amount;					
				true ->
					CanStrengNum = CanStrengNum1
				end,
				{Success, StrengNum} = streng_rand_num(StrengthenTemplate, ItemInfo#ets_users_items.fail_acount, CanStrengNum, VipRate),
				[NewState2, NewInfo, DeleteList, _] = use_item(ItemList, StrengNum, NewState, [], [])
			end,
			if Success =:= 0 -> 
					NewFailAcount = ItemInfo#ets_users_items.fail_acount + StrengNum,
					Res = 1,%% 每次强化都成功只是有没有升级不一定
					NewLevel = Level * ?STRENGTHEN_LEVEL_UNIT + util:rand(1, 99),
					ItemInfo1 = strengthen_level_open_enchase(NewLevel, ItemInfo, State#item_status.user_pid);					
				true ->
					NewFailAcount = 0,
					Res = 1,
					if Level =:= 0 ->
						NewLevel = (Level + 2) * ?STRENGTHEN_LEVEL_UNIT;
					true ->
						NewLevel = (Level + 1) * ?STRENGTHEN_LEVEL_UNIT
					end,
					lib_target:cast_check_target(State#item_status.user_pid,[{?TARGET_STRENGTHEN,{ItemInfo#ets_users_items.place,NewLevel}}]),
					ItemInfo1 = strengthen_level_open_enchase(NewLevel, ItemInfo, State#item_status.user_pid)%%只为了通知
					%ItemInfo1 = ItemInfo
			end,
			IsBind =if ItemInfo1#ets_users_items.is_bind =:=1 orelse StoneInfo#ets_users_items.is_bind =:=1 -> 1;
							true -> 0   end,
			NewItemInfo = ItemInfo1#ets_users_items{strengthen_level = NewLevel, fail_acount = NewFailAcount,is_bind = IsBind},
%% 			NewItemInfo	= strengthen_level_open_enchase(NewLevel, NewItemInfo1, State#item_status.user_pid),
			NewItemInfo1 = item_util:update_item_to_bag(NewItemInfo),%%更新缓存
			[StrengNum,{Res, IsProtect, NewItemInfo1, lists:append(NewInfo2, NewInfo), lists:append(DeleteList2, DeleteList), NewLevel, NewState2}];
		true ->
			%%io:format("StrengthenTemplate is null, streng level is ~p~n",[Level]),
			[0,{error}]
	end.

streng_rand_num(StrengthenTemplate, FailNum, Amount, VipRate) ->
	if FailNum > StrengthenTemplate#ets_strengthen_template.min_num ->
		Min = 0;
	true ->
		Min = StrengthenTemplate#ets_strengthen_template.min_num - FailNum
	end,
	
	if Min >= Amount ->
		%%NewFailNum = FailNum + Amount,
		{0,Amount};%%失败，随机次数，失败次数
	true ->
		NewFailNum = FailNum + Min,		
		Rate = StrengthenTemplate#ets_strengthen_template.success_rate + VipRate,
		if Rate =:= 100 ->
			Min1 = Min + 1;
		true ->
			Min1 = Min
		end,
		case streng_rand_num1(Amount - Min1, Rate, NewFailNum, StrengthenTemplate#ets_strengthen_template.max_num) of
			{Num, 100} ->
				%%?DEBUG("dhwang_test--strengnum:~p",[Num]),		
				{1, Amount - Num};
			{0, _} ->
				{0, Amount};
			_error ->
				?DEBUG("streng rand error :~p", [_error]),
				{0, 0}
		end
	end.

%%强化随机次数
streng_rand_num1(0,Rate,_FailNum, _Max) ->
	{0,Rate};
streng_rand_num1(Amount,100,_FailNum, _Max) ->
	{Amount,100};
streng_rand_num1(Amount, Rate, FailNum, Max) ->
	Random = util:rand(1, 100),
	if
		FailNum >= Max ->
			streng_rand_num1(Amount - 1 , 100, FailNum, Max);
		Random =< Rate ->
			streng_rand_num1(Amount - 1, 100, FailNum, Max);
		true ->
			streng_rand_num1(Amount - 1, Rate, FailNum + 1, Max)
	end.

%%装备强化
item_streng(State, ItemInfo, StoneInfo, StonePlace, GuardPlace, VipRate) ->			
	Level = ItemInfo#ets_users_items.strengthen_level div ?STRENGTHEN_LEVEL_UNIT,	
	StrengthenTemplate = data_agent:item_strengthen_template_get(Level),
	if is_record(StrengthenTemplate, ets_strengthen_template)=:= true ->
			[NewState, NewInfo, DeleteList] = change_item_num_in_commonbag(StoneInfo, StonePlace, 1, State, ?CONSUME_ITEM_STRENG),			
			Rate1 = get_streng_rate(ItemInfo#ets_users_items.fail_acount, StrengthenTemplate, VipRate),
			if GuardPlace > 0 ->
				case item_util:get_user_item_by_place(State#item_status.user_id, GuardPlace) of
					[] ->
						[NewState2, NewInfo2, DeleteList2] = [NewState, [], []],
						IsProtect = 0,
						Rate = Rate1;						
					[GuardInfo] when GuardInfo#ets_users_items.template_id =:= StrengthenTemplate#ets_strengthen_template.perfect_stone->
						[NewState2, NewInfo2, DeleteList2] = change_item_num_in_commonbag(GuardInfo, GuardPlace, 1, NewState,?CONSUME_ITEM_STRENG),
						IsProtect = 0,
						Rate = 100;
					[_] ->
						[NewState2, NewInfo2, DeleteList2] = [NewState, [], []],
						IsProtect = 0,
						Rate = Rate1	
				end;
			true ->
				[NewState2, NewInfo2, DeleteList2] = [NewState, [], []],
				IsProtect = 0,
				Rate = Rate1
			end,
			Random = util:rand(1, 100),
			if Random > Rate -> 
					NewFailAcount = ItemInfo#ets_users_items.fail_acount + 1,
					Res = 1,%% 每次强化都成功只是有没有升级不一定
					NewLevel = Level * ?STRENGTHEN_LEVEL_UNIT + util:rand(1, 99),
					ItemInfo1 = strengthen_level_open_enchase(NewLevel, ItemInfo, State#item_status.user_pid);					
				true ->
					NewFailAcount = 0,
					Res = 1,
					if Level =:= 0 ->
						NewLevel = (Level + 2) * ?STRENGTHEN_LEVEL_UNIT;
					true ->
						NewLevel = (Level + 1) * ?STRENGTHEN_LEVEL_UNIT
					end,
					lib_target:cast_check_target(State#item_status.user_pid,[{?TARGET_STRENGTHEN,{ItemInfo#ets_users_items.place,NewLevel}}]),
					ItemInfo1 = strengthen_level_open_enchase(NewLevel, ItemInfo, State#item_status.user_pid)
			end,
			IsBind =if ItemInfo1#ets_users_items.is_bind =:=1 orelse StoneInfo#ets_users_items.is_bind =:=1 -> 1;
							true -> 0   end,
			NewItemInfo = ItemInfo1#ets_users_items{strengthen_level = NewLevel, fail_acount = NewFailAcount,is_bind = IsBind},
			NewItemInfo1 = item_util:update_item_to_bag(NewItemInfo),%%更新缓存
			{Res, IsProtect, NewItemInfo1, lists:append(NewInfo2, NewInfo), lists:append(DeleteList2, DeleteList), NewLevel, NewState2};
		true ->
			%%io:format("StrengthenTemplate is null, streng level is ~p~n",[Level]),
			{error}
	end.

strengthen_level_open_enchase(Level, ItemInfo, Pid) ->
	if %%判断强化等级
		
		Level rem ?STRENGTHEN_LEVEL_UNIT =:= 0 andalso Level > 600 ->
			TLevel = Level div ?STRENGTHEN_LEVEL_UNIT,
			gen_server:cast(Pid, {'chat_sysmsg_1',?_LANG_NOTICE_STRENG, ItemInfo#ets_users_items.id, ItemInfo#ets_users_items.template_id,TLevel-1});
		true ->
			ok
	end,
 	if
		Level > 6 * ?STRENGTHEN_LEVEL_UNIT andalso ItemInfo#ets_users_items.enchase4 =:= -1 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase4 = 0},
			NewItemInfo;
		Level > 8 * ?STRENGTHEN_LEVEL_UNIT andalso ItemInfo#ets_users_items.enchase5 =:= -1 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase5 = 0},
			NewItemInfo;
		Level > 10 * ?STRENGTHEN_LEVEL_UNIT andalso ItemInfo#ets_users_items.enchase6 =:= -1 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase6 = 0},
			NewItemInfo;
		true ->
			ItemInfo
	end.

transform_strengthen_level_open_enchase(Level, ItemInfo) ->
	NewItemInfo1 = if Level > 6 * ?STRENGTHEN_LEVEL_UNIT andalso ItemInfo#ets_users_items.enchase4 =:= -1 ->
			ItemInfo#ets_users_items{enchase4 = 0};
	   true ->
			ItemInfo
	end,
	NewItemInfo2 = if Level > 8 * ?STRENGTHEN_LEVEL_UNIT andalso NewItemInfo1#ets_users_items.enchase5 =:= -1 ->
			NewItemInfo1#ets_users_items{enchase5 = 0};
	   true ->
			NewItemInfo1
	end,
	if Level > 10 * ?STRENGTHEN_LEVEL_UNIT andalso NewItemInfo2#ets_users_items.enchase6 =:= -1 ->
			NewItemInfo2#ets_users_items{enchase6 = 0};
	   true ->
			NewItemInfo2
	end.


get_streng_rate(FailAcount, StrengthenTemplate, VipRate) ->
	if 
		FailAcount <  StrengthenTemplate#ets_strengthen_template.min_num ->
			0;
		FailAcount >= StrengthenTemplate#ets_strengthen_template.max_num ->
			100;
		true ->
			Rate = StrengthenTemplate#ets_strengthen_template.success_rate + VipRate,
			Rate
	end.
	
									  						
%%打孔前判断	
check_hole(ItemStatus, ItemPlace, TapPlace, Copper,BindCopper)  ->   	
	ItemInfo = 
		case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace) of
			[] ->
				[];
			[TempItemInfo] ->
				TempItemInfo
		end,
	TapInfo = 
		case item_util:get_user_item_by_place(ItemStatus#item_status.user_id,  TapPlace) of
			[] ->
				[];
			[TempTapInfo] ->
				TempTapInfo
		end,
	
	if
		is_record(ItemInfo, ets_users_items) =:= false orelse is_record(TapInfo, ets_users_items) =:= false ->
			{error, "record is not exist"};
		true ->
			Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),  
			ItemCateId = Template#ets_item_template.category_id,
			CanHole = Template#ets_item_template.can_enchase,	
			TapTemplate = data_agent:item_template_get(TapInfo#ets_users_items.template_id),
			TapCateId = TapTemplate#ets_item_template.category_id,	
			if  
				ItemInfo#ets_users_items.is_exist  =/= 1 orelse TapInfo#ets_users_items.is_exist =/= 1 
				  orelse CanHole  =/= 1 orelse ItemCateId > ?MAXITEMCATE orelse TapCateId =/= ?CATE_STILETTO ->
					{fail, 0};
				true ->		
					case check_hole_copper(Template, ItemInfo) of
						{ok, HoleNeedCopper} ->														
							if
								Copper + BindCopper < HoleNeedCopper  ->	
									 {fail, 0};	  
								 true ->																											 
									  {ok, ItemInfo, TapInfo, HoleNeedCopper}
							 end;
						{fail, 0} ->
							 {fail, 0}
					end    
			end
	end.

check_hole_copper(_Template, ItemInfo) ->
	       %%装备开孔收费			
		   HoleTemplate = data_agent:item_hole_template_get(1),					  
		   if 
				ItemInfo#ets_users_items.enchase1 =:= -1 ->
						CopperModules = HoleTemplate#ets_hole_template.enchase1,
				        {ok, CopperModules};
				ItemInfo#ets_users_items.enchase2 =:= -1 ->
						CopperModules = HoleTemplate#ets_hole_template.enchase2,
						{ok, CopperModules};
				ItemInfo#ets_users_items.enchase3 =:= -1 ->
						CopperModules = HoleTemplate#ets_hole_template.enchase3,
						{ok, CopperModules};
				
%%				ItemInfo#ets_users_items.enchase4 =:= -1 ->
%%						CopperModules = HoleTemplate#ets_hole_template.enchase4,
%%						{ok, CopperModules};
%%				ItemInfo#ets_users_items.enchase5 =:= -1 ->
%%						CopperModules = HoleTemplate#ets_hole_template.enchase5,
%%						{ok, CopperModules};
							  
				true ->
						{fail,0}
		  end.

%%打孔处理
tap_hole(ItemStatus, ItemInfo, TapInfo, TapPlace, VipRateAdd) ->
    %%更新打孔石数量
    [NewItemStatus, NewTapInfo, DeleteList] = lib_item:change_item_num_in_commonbag(TapInfo, TapPlace, 1, ItemStatus,?CONSUME_ITEM_USE),
    case item_tap_hole(ItemInfo, VipRateAdd) of 
		{ok, NewItemInfo} ->
	           EnchaseList = [NewItemInfo#ets_users_items.enchase1,
				              NewItemInfo#ets_users_items.enchase2,
				              NewItemInfo#ets_users_items.enchase3,
				              NewItemInfo#ets_users_items.enchase4,
				              NewItemInfo#ets_users_items.enchase5],			   
			   change_item_hole(NewItemInfo, EnchaseList),	
			   if
				   ItemInfo#ets_users_items.is_bind =/= ?BIND_TYPE_1 andalso  TapInfo#ets_users_items.is_bind =:= ?BIND_TYPE_1 ->
					   NewItemInfo1 = change_item_isbind(NewItemInfo, ?BIND),
					   {ok, NewItemStatus, 1, lists:append(NewTapInfo, [NewItemInfo1]), DeleteList};
				   true ->
					   {ok, NewItemStatus, 1, lists:append(NewTapInfo, [NewItemInfo]), DeleteList}
			   end;
		
		{fail, ItemInfo} ->			   
		          {fail, NewItemStatus, 0, NewTapInfo, DeleteList}
	end.

%%打孔几率处理
item_tap_hole(ItemInfo, VipRateAdd)  ->
	ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	EquipLevel   = ItemTemplate#ets_item_template.need_level, 
	HoleTemplate = data_agent:item_hole_template_get(0),
	%%装备开孔几率 	
    if  
         ItemInfo#ets_users_items.enchase1 =:= -1 ->  	
			case  item_tap_hole1(HoleTemplate#ets_hole_template.enchase1, VipRateAdd, EquipLevel) of
				{ok}   ->
					NewItemInfo = ItemInfo#ets_users_items{enchase1 = 0},	
					  {ok, NewItemInfo};
				  {fail} ->
					  {fail, ItemInfo}
			end;     
         ItemInfo#ets_users_items.enchase2 =:= -1 ->
           case  item_tap_hole1(HoleTemplate#ets_hole_template.enchase2, VipRateAdd, EquipLevel) of
				  {ok}   ->
					NewItemInfo = ItemInfo#ets_users_items{enchase2 = 0},
					  {ok, NewItemInfo};
				  {fail} ->
					  {fail, ItemInfo}
			end;		 
         ItemInfo#ets_users_items.enchase3 =:= -1 ->
           case  item_tap_hole1(HoleTemplate#ets_hole_template.enchase3, VipRateAdd, EquipLevel) of
				  {ok}   ->
					NewItemInfo = ItemInfo#ets_users_items{enchase3 = 0},             
					  {ok, NewItemInfo};
				  {fail} ->
					  {fail, ItemInfo}
			end;		         
         true ->
            {fail, ItemInfo}
    end.           
	
item_tap_hole1(Ratio, VipRateAdd,  _EquipLevel) ->

	Random = util:rand(1, 100),	
		if 
			Ratio + VipRateAdd >= Random  ->
				{ok};
			true ->
				{fail}
		end.

%%装备修理判断
check_mend(PlayerStatus, ItemPlace) ->
	case  ItemPlace  of
		?ALLITEMFIX ->
			%%全部装备修理处理
		    check_mend_all(PlayerStatus);			
		_ ->
			%%单件装备修理处理
			check_mend_single(PlayerStatus, ItemPlace)
	end.
				
%%单件装备修理检查
check_mend_single(PlayerStatus, ItemPlace) ->  
	case  item_util:get_user_item_by_place(PlayerStatus#ets_users.id, ItemPlace) of
		[ItemInfo] ->	 	
          Template     = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),  
          CanRepair    = Template#ets_item_template.can_repair,         
          DurableUpper = Template#ets_item_template.durable_upper,
          RepairModulus= Template#ets_item_template.repair_modulus,  
		  %%花费 = （当前耐久与最大耐久之差） * 修理系数
          RepairCost1  = (DurableUpper - ItemInfo#ets_users_items.durable)*RepairModulus,
		  RepairCost   = tool:ceil(RepairCost1),
          AllBind      = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,          
         if 
          %%能否修理
          CanRepair =/= 1 ->
            {fail, ["不能修理"]};
          %%耐久判断
          ItemInfo#ets_users_items.durable >= DurableUpper ->
            {fail, ["无需修理"]};
          %%余额判断
          AllBind  =< RepairCost ->
            {fail, ["当前金钱不足，无法修理"]};
                  
          true ->
            {ok, [ItemInfo], RepairCost}
        end;
	
	   [] ->
            {fail, []}
    end.

%%全部装备修理判断     
check_mend_all(PlayerStatus) ->	
	L = lists:seq(?EQUIPSTEREPLACE, ?EQUIPENDPLACE, 1),
	[_, AllRepairCost, ItemInfoList] = lists:foldl(fun  func_check_mend/2, [PlayerStatus, 0, []], L),	
	AllPlayerBind = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
	if  
		erlang:length(ItemInfoList) =:= 0 ->
			{fail, ["无需修理"]};
		AllPlayerBind =< AllRepairCost ->
			{fail,["当前金钱不足，无法修理"]};		
		true ->
			{ok, ItemInfoList, AllRepairCost}
	end.

func_check_mend(ItemPlace, [PlayerStatus, AllRepairCost, ItemInfoList]) ->
      case check_mend_single(PlayerStatus, ItemPlace) of
		{ok, ItemInfo, RepairCost} ->
		 	 [PlayerStatus, AllRepairCost+RepairCost, lists:append(ItemInfoList, ItemInfo)];                                    
		_ ->
             [PlayerStatus, AllRepairCost, ItemInfoList]
    end.					

%%装备修理处理
mend_item(ItemStatus, ItemInfo) ->
	[NewItemStatus, NewItemList] = lists:foldl(fun func_mend_item/2 , [ItemStatus, []], ItemInfo),
	{ok, NewItemStatus, NewItemList}.
	
func_mend_item(SingleItemInfo, [ItemStatus, ItemList]) ->
	Template = data_agent:item_template_get(SingleItemInfo#ets_users_items.template_id),
	DurableUpper = Template#ets_item_template.durable_upper,	
	NewItemInfo = lib_item:change_item_durable(SingleItemInfo, DurableUpper),   
	[ItemStatus, lists:append(ItemList, [NewItemInfo])].


%%道具镶嵌检查
check_enchase([ItemPlace, StonePlace, HolePlace, Copper, BindCopper, ItemStatus]) ->	
	ItemInfo =
		case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
		end,
	StoneInfo = 
		case item_util:get_user_item_by_place(ItemStatus#item_status.user_id, StonePlace) of
			[] ->
				[];
			[Stone] ->
				Stone
		end,
	
	
	if
		is_record(ItemInfo, ets_users_items) =:= false orelse is_record(StoneInfo, ets_users_items) =:= false ->
			{fail, "record is not exist"};
		true ->
			check_enchase_all(ItemInfo, StoneInfo, HolePlace, Copper, BindCopper )
	end.
	
check_enchase_all(ItemInfo, StoneInfo, HolePlace, Copper, BindCopper) -> 
		
      ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id), 
	  StoneTemplate = data_agent:item_template_get(StoneInfo#ets_users_items.template_id), 
	  StoneCategoryId = StoneTemplate#ets_item_template.category_id,	  
	  StoneLevel = StoneTemplate#ets_item_template.propert3,	
	    
%%	  ItemQuality = ItemTemplate#ets_item_template.quality,
%%	  ItemLevel = ItemTemplate#ets_item_template.need_level,	  
	  
	  StoneListTemplate = data_agent:item_enchase_stone_template_get(ItemTemplate#ets_item_template.category_id),   	  
	  case [StoneListTemplate] of
		  [] ->
				%%?DEBUG("check_enchase error:~p",[1]),
			  {fail, 1};		  
		  [_] ->						  
	          StoneList1 = StoneListTemplate#ets_item_stone_template.stone_list,
	          StoneList2 = erlang:binary_to_list(StoneList1),
	          StoneList = string:tokens(StoneList2, ","),  
	         case lists:filter(fun(X) -> tool:to_integer(X) =:= StoneCategoryId end, StoneList) of
		     	[] ->	
						%%?DEBUG("check_enchase error:~p",[2]),			     
			            {fail, 2};
		      	[_] ->		     
			 	     case check_enchase_stone(ItemInfo, HolePlace, StoneCategoryId) of
				      	{fail, 0} ->
								%%?DEBUG("check_enchase error:~p",[HolePlace]),
							  {fail, 3};
					    {ok, 1} ->																			
						   ItemChenaseTemp = data_agent:item_enchase_template_get(StoneLevel),						   						 						 						   
						   ReduceCopper = ItemChenaseTemp#ets_enchase_template.copper,
						   								   
								if 
									Copper +  BindCopper =< ReduceCopper ->
										%%?DEBUG("check_enchase error:~p",[4]),
										{fail, 4};
									true ->
										{ok, ReduceCopper, ItemInfo, StoneInfo}
								end
				     end
	         end
	  end.

check_enchase_stone(ItemInfo, HolePlace, StoneCategoryId) ->
	%?DEBUG("check_enchase_stone:~p",[{HolePlace,StoneCategoryId}]),
	if 
		HolePlace =:= 1 ->
			EnchaseList = [ItemInfo#ets_users_items.enchase2, ItemInfo#ets_users_items.enchase3,
							ItemInfo#ets_users_items.enchase4, ItemInfo#ets_users_items.enchase5],
			check_enchase_stone1(ItemInfo#ets_users_items.enchase1, StoneCategoryId, EnchaseList);
        HolePlace =:= 2 ->
			EnchaseList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase3,
							ItemInfo#ets_users_items.enchase4, ItemInfo#ets_users_items.enchase5],
			check_enchase_stone1(ItemInfo#ets_users_items.enchase2, StoneCategoryId, EnchaseList);
        HolePlace =:= 3 ->
			EnchaseList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2,
							ItemInfo#ets_users_items.enchase4, ItemInfo#ets_users_items.enchase5],
			check_enchase_stone1(ItemInfo#ets_users_items.enchase3, StoneCategoryId, EnchaseList);
		HolePlace =:= 4 ->
			EnchaseList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2,
							ItemInfo#ets_users_items.enchase3, ItemInfo#ets_users_items.enchase5],
			if(ItemInfo#ets_users_items.enchase4 =:= -1 andalso ItemInfo#ets_users_items.strengthen_level > 6 * ?STRENGTHEN_LEVEL_UNIT) ->
					Enchase4 = 0;
				true ->
					Enchase4 = ItemInfo#ets_users_items.enchase4
			end,
			check_enchase_stone1(Enchase4, StoneCategoryId, EnchaseList);
		HolePlace =:= 5 ->
			EnchaseList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2,
							ItemInfo#ets_users_items.enchase3, ItemInfo#ets_users_items.enchase4],
			if(ItemInfo#ets_users_items.enchase5 =:= -1 andalso ItemInfo#ets_users_items.strengthen_level > 8 * ?STRENGTHEN_LEVEL_UNIT) ->
					Enchase5 = 0;
				true ->
					Enchase5 = ItemInfo#ets_users_items.enchase5
			end,
			check_enchase_stone1(Enchase5, StoneCategoryId, EnchaseList);
		HolePlace =:= 6 ->
			EnchaseList = [0],
			if(ItemInfo#ets_users_items.enchase6 =:= -1 andalso ItemInfo#ets_users_items.strengthen_level > 10 * ?STRENGTHEN_LEVEL_UNIT) ->
					Enchase6 = 0;
				true ->
					Enchase6 = ItemInfo#ets_users_items.enchase6
			end,
			check_enchase_stone1(Enchase6, StoneCategoryId, EnchaseList);
      true ->
		?DEBUG("check_enchase_stone error:~p",[{HolePlace,StoneCategoryId}]),
         {fail, 0}
  end. 

check_enchase_stone1(EnchaseTemplateId, StoneCategoryId, EnchaseList) ->
	%?DEBUG("check_enchase_stone1:~p",[{EnchaseTemplateId, StoneCategoryId, EnchaseList}]),
	case EnchaseTemplateId of
		 -1 ->
			 {fail, 0};
		 0 ->
			check_enchase_stone2(StoneCategoryId, EnchaseList);
		_ ->
			 {fail, 0}		     
	end.
   
check_enchase_stone2(StoneCategoryId, EnchaseList) ->
	case lists:filter(fun(X)->X > 0 end, EnchaseList) of
				 [] ->
					 {ok, 1};
				 List ->
					 F = fun(X, [CateId, Flag]) ->
								 Temp = data_agent:item_template_get(X),
								 if
									 Temp#ets_item_template.category_id =:= CateId ->
										 [CateId, Flag+1];
									 true ->
										 [CateId, Flag]
								 end
						 end,
					 [_, Flag] = lists:foldl(F, [StoneCategoryId, 0], List),
					 if
						 Flag > 0 ->
							 {fail, 0};
						 true ->
							 {ok, 1}
					 end
	end.
					 
%%道具镶嵌处理		
enchase_item(ItemStatus, ItemInfo, StoneInfo, HolePlace, StonePlace, UserID, Level) ->	
	%%装备镶嵌数
	HoleList = [ItemInfo#ets_users_items.enchase1, ItemInfo#ets_users_items.enchase2, ItemInfo#ets_users_items.enchase3],
	HoleNum = lists:foldl(fun(Info, Num) -> 
								  if Info > 0 ->
										 Num +1;
									 true ->
										 Num
								  end end, 0, HoleList) + 1 ,
	 %%更新宝石数量
	 [NewItemStatus, NewStoneInfo, DeleteList] = lib_item:change_item_num_in_commonbag(StoneInfo, StonePlace, 1, ItemStatus, ?CONSUME_ITEM_ENCHASE),		
	 %%更新装备信息
	case enchase_item1(ItemInfo, StoneInfo, HolePlace) of
		{ok, NewItemInfo} ->			
%% 			EnchaseList = [NewItemInfo#ets_users_items.enchase1,
%% 				           NewItemInfo#ets_users_items.enchase2,
%% 				           NewItemInfo#ets_users_items.enchase3,
%% 				           NewItemInfo#ets_users_items.enchase4,
%% 				           NewItemInfo#ets_users_items.enchase5,
%% 							NewItemInfo#ets_users_items.enchase6],			
%% 			change_item_enchase(NewItemInfo, EnchaseList),
						
			%%添加镶嵌统计记录
			ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id), 
			CategoryId = ItemTemplate#ets_item_template.category_id,
			lib_statistics:add_enchase_log(UserID, 1, HoleNum, CategoryId, StoneInfo#ets_users_items.template_id, Level),	
			if
				NewItemInfo#ets_users_items.is_bind =:= ?NOBIND andalso StoneInfo#ets_users_items.is_bind =:= ?BIND ->
					NewItemInfo1 = lib_item:change_item_isbind(NewItemInfo, ?BIND),
					{ok, NewItemStatus, 1, [NewItemInfo1|NewStoneInfo], DeleteList};
				true ->
					NewItemInfo1 = item_util:update_item_to_bag(NewItemInfo),
					{ok, NewItemStatus, 1, [NewItemInfo1|NewStoneInfo], DeleteList}
			end;
		{fail, 0} ->			
			{fail, error}
	end.

enchase_item1(ItemInfo, StoneInfo, HolePlace) ->
	if 
		HolePlace =:= 1 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase1 = StoneInfo#ets_users_items.template_id},
			{ok, NewItemInfo};
		HolePlace =:= 2 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase2 = StoneInfo#ets_users_items.template_id},
			{ok, NewItemInfo};
		HolePlace =:= 3 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase3 = StoneInfo#ets_users_items.template_id},
			{ok, NewItemInfo};
		HolePlace =:= 4 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase4 = StoneInfo#ets_users_items.template_id},
			{ok, NewItemInfo};
		HolePlace =:= 5 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase5 = StoneInfo#ets_users_items.template_id},
			{ok, NewItemInfo};
		HolePlace =:= 6 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase6 = StoneInfo#ets_users_items.template_id},
			{ok, NewItemInfo};
		true ->
			{fail, 0}
	end.

%%宝石摘取检查
check_pick_stone(ItemState, ItemPlace, HolePlace, Copper, BindCopper) ->
	case item_util:get_user_item_by_place(ItemState#item_status.user_id, ItemPlace) of
		[] ->
			{error, "record is not exist"};
		[ItemInfo] ->
			case check_pick_stone_2(ItemInfo, HolePlace) of
				{error} ->
					{error, "stone is not exist"};
				{ok, StoneTempId} ->
					StoneTempalte = data_agent:item_template_get(StoneTempId),
%%					ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
					
					StoneLevel = StoneTempalte#ets_item_template.propert3,					
					PickStoneTemp = data_agent:item_pick_stone_template_get(StoneLevel),
				    NeedCopper1 = PickStoneTemp#ets_pick_stone_template.copper_modulus,
					SuccRate = PickStoneTemp#ets_pick_stone_template.success_rates,
					
%%					NeedCopper = (ItemTemplate#ets_item_template.need_level)*CopperModulus + 88,
%%					NeedCopper1 = tool:ceil(NeedCopper),
					
					if 
						NeedCopper1 > Copper + BindCopper ->
							{error, "copper is not enough"};
						erlang:length(ItemState#item_status.null_cells) < 1 ->
							{error, "null cell is not enough"};
						true ->
							{ok, ItemInfo,StoneTempalte,StoneLevel,SuccRate,NeedCopper1}
					end
			end
	end.
	
check_pick_stone_2(ItemInfo, HolePlace) ->
	case HolePlace of
		1 ->
			StoneTempId = ItemInfo#ets_users_items.enchase1;
		2 ->
			StoneTempId = ItemInfo#ets_users_items.enchase2;
		3 ->
			StoneTempId = ItemInfo#ets_users_items.enchase3;
		4 ->
			StoneTempId = ItemInfo#ets_users_items.enchase4;
		5 ->
			StoneTempId = ItemInfo#ets_users_items.enchase5;
		6 ->
			StoneTempId = ItemInfo#ets_users_items.enchase6;	
		_ ->
			StoneTempId = 0
	end,
	if
		StoneTempId > 0 ->
			{ok, StoneTempId};
		true ->
			{error}
	end.

%%宝石摘取
pick_up_stone(State,ItemInfo,StoneTempalte,StoneLevel,SuccRate,PickPlace,HolePlace, UserID, Level) ->
	case item_util:get_user_item_by_place(State#item_status.user_id, PickPlace) of
		[] ->
%% 			%%没有摘取符
			{error, 0};
		
		[PickInfo] ->
			PickTemplate = data_agent:item_template_get(PickInfo#ets_users_items.template_id),
			case pick_up_stone_2(PickTemplate, StoneLevel) of
				{error, _Res} ->
					%%摘取符错误
					{error, 1};
				{ok} ->
					ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id), 
					CategoryId = ItemTemplate#ets_item_template.category_id,
					lib_statistics:add_enchase_log(UserID, 2, HolePlace, CategoryId,
												   StoneTempalte#ets_item_template.template_id, Level),
					[NewState, NewInfo, DeleteList] = lib_item:change_item_num_in_commonbag(PickInfo, PickPlace, 1, State,?CONSUME_ITEM_USE),
					Random = util:rand(1, 100),
					SuccRate1 = tool:ceil(SuccRate),
					if
						SuccRate1 >= Random ->
							%%摘取成功  更新装备信息  
							NewItemInfo = pick_up_stone_1(ItemInfo, HolePlace),
%% 							EnchaseList = [NewItemInfo#ets_users_items.enchase1,
%% 										   NewItemInfo#ets_users_items.enchase2,
%% 										   NewItemInfo#ets_users_items.enchase3,
%% 										   NewItemInfo#ets_users_items.enchase4,
%% 										   NewItemInfo#ets_users_items.enchase5],
							NewItemInfo1 = change_item_enchase(NewItemInfo, []),
							%%更新摘取下来的宝石信息
							{NewState1, ItemList, _Amount} = add_item_amount_summation(StoneTempalte, 1, NewState, [], ?BIND, ?CANSUMMATION),	
							{ok, NewState1, 1, [NewItemInfo1| lists:append(NewInfo, ItemList)], DeleteList};
						
						true ->
							%%失败
							{ok, NewState, 0, NewInfo, DeleteList}
					end
			end
	end.

pick_up_stone_1(ItemInfo, HolePlace) ->
	if
		HolePlace =:= 1 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase1=0};
		HolePlace =:= 2 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase2=0};
		HolePlace =:= 3 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase3=0};
		HolePlace =:= 4 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase4=0};
		HolePlace =:= 5 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase5=0};
		HolePlace =:= 6 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase6=0}
	end,
	NewItemInfo.

pick_up_stone_2(PickTemplate, StoneLevel) ->	                                                               
	case PickTemplate#ets_item_template.propert3 of
		1 ->
			case lists:member(StoneLevel, ?PRIMARYPICKLIST) of
				true ->
					{ok};
				false ->
					{error, "type is not conform1"}
			end;		
		2 ->
			case lists:member(StoneLevel, ?MIDDLEPICKLIST) of
				true ->
					{ok};
				false ->
					{error, "type is not conform2"}
			end;		
		3 ->
			case lists:member(StoneLevel, ?HIGHTPICKLIST) of
				true ->
					{ok};
				false ->
					{error, "type is not conform3"}
			end
	end.
			

%%道具合成检查
check_item_compose(State, FormuleId, Copper, ComposeNum) ->
	FormulaTemp = data_agent:item_formula_template_get(FormuleId),
%% 	io:format("formulaTemp info:~p~n",[FormulaTemp]),
	TemplateId1 = FormulaTemp#ets_formula_template.item1,
	Amount1 = FormulaTemp#ets_formula_template.amount1,
	TemplateId2 = FormulaTemp#ets_formula_template.item2,
	Amount2 = FormulaTemp#ets_formula_template.amount2,
	TemplateId3 = FormulaTemp#ets_formula_template.item3,
	Amount3 = FormulaTemp#ets_formula_template.amount3,
	TemplateId4 = FormulaTemp#ets_formula_template.item4,
	Amount4 = FormulaTemp#ets_formula_template.amount4,
	TemplateId5 = FormulaTemp#ets_formula_template.item5,
	Amount5 = FormulaTemp#ets_formula_template.amount5,
	TemplateId6 = FormulaTemp#ets_formula_template.item6,
	Amount6 = FormulaTemp#ets_formula_template.amount6,
	
	BagItemAcount1 = item_util:get_count_by_templateid(State#item_status.user_id, TemplateId1, ?BAG_TYPE_COMMON),
	BagItemAcount2 = item_util:get_count_by_templateid(State#item_status.user_id, TemplateId2, ?BAG_TYPE_COMMON),
	BagItemAcount3 = item_util:get_count_by_templateid(State#item_status.user_id, TemplateId3, ?BAG_TYPE_COMMON),
	BagItemAcount4 = item_util:get_count_by_templateid(State#item_status.user_id, TemplateId4, ?BAG_TYPE_COMMON),
	BagItemAcount5 = item_util:get_count_by_templateid(State#item_status.user_id, TemplateId5, ?BAG_TYPE_COMMON),
	BagItemAcount6 = item_util:get_count_by_templateid(State#item_status.user_id, TemplateId6, ?BAG_TYPE_COMMON),
	
	if
		BagItemAcount1 <  Amount1 * ComposeNum ->
			{error, "not enough"};
		BagItemAcount2 <  Amount2  * ComposeNum ->
			{error, "not enough"};
		BagItemAcount3 <  Amount3  * ComposeNum ->
			{error, "not enough"};
		BagItemAcount4 <  Amount4  * ComposeNum ->
			{error, "not enough"};
		BagItemAcount5 <  Amount5  * ComposeNum ->
			{error, "not enough"};
		BagItemAcount6 <  Amount6  * ComposeNum ->
			{error, "not enough"};
		true ->
			NeedCopper = FormulaTemp#ets_formula_template.cost_copper,
			if
				NeedCopper > Copper ->
					{error, "copper is not enough"};
				erlang:length(State#item_status.null_cells) < 1 ->
					{error, "null cell is not enough"};
				
				true ->
					{ok, NeedCopper, FormulaTemp}
			end
	end.

check_item_uplevel(State,PetId,ItemPlace,Copper) ->
	if	PetId > 0 ->
			ItemInfoList = item_util:get_pet_equip_by_place(PetId, ItemPlace);
		true ->
			ItemInfoList = item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace)
	end,
	case  ItemInfoList of
		[] ->
            {error, ["item is not exist", ItemPlace]};
		[ItemInfo] ->			
			UpgradeTemp = data_agent:item_uplevel_template_get(ItemInfo#ets_users_items.template_id),
			if 
				is_record(UpgradeTemp, ets_item_uplevel_template) =:= true -> 
					
							NeedCopper = UpgradeTemp#ets_item_uplevel_template.uplevel_copper,
							MaterialList = UpgradeTemp#ets_item_uplevel_template.uplevel_material,
							TargetId = UpgradeTemp#ets_item_uplevel_template.uplevel_target_id,		
					
					if
						Copper >= NeedCopper ->
							case item_util:check_enough_material(State#item_status.user_id,MaterialList)of								
								[] ->
									{ok,[ItemInfo,MaterialList,TargetId,NeedCopper]};
								_NewMaterialList ->
									{error, ["not enough material",_NewMaterialList]}
							end;
						true ->
							{error, ["not enough copper", NeedCopper]}
					end;					
				true ->
					{error, ["item can't upgrade", ItemInfo#ets_users_items.template_id]}
			end 
	end.

%%装备升级精炼检查
check_item_upgrade(State,PetId,ItemPlace,Copper) ->
	if	PetId > 0 ->
			ItemInfoList = item_util:get_pet_equip_by_place(PetId, ItemPlace);
		true ->
			ItemInfoList = item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace)
	end,	
	case  ItemInfoList of
		[] ->
            {error, ["item is not exist", ItemPlace]};
		[ItemInfo] ->			
			UpgradeTemp = data_agent:item_upgrade_template_get(ItemInfo#ets_users_items.template_id),
			if 
				is_record(UpgradeTemp, ets_item_upgrade_template) =:= true  -> 
				
							NeedCopper = UpgradeTemp#ets_item_upgrade_template.upquality_copper,
							MaterialList = UpgradeTemp#ets_item_upgrade_template.upquality_material,
							TargetId = UpgradeTemp#ets_item_upgrade_template.upquality_target_id,
					if
						Copper >= NeedCopper ->
							case item_util:check_enough_material(State#item_status.user_id,MaterialList)of
								[_NewMaterialList] ->
									{error, ["not enough material",_NewMaterialList]};
								[] ->
									{ok,[ItemInfo,MaterialList,TargetId,NeedCopper]}
							end;
						true ->
							{error, ["not enough copper", NeedCopper]}
					end;					
				true ->
					{error, ["item can't upgrade", ItemInfo#ets_users_items.template_id]}
			end 
	end.
	

%%装备升级与精炼
item_upgrade(State, ItemInfo, MaterialList, TargetId) ->
	{NewState, NewItemList, NewDelList, NewBindFlag} = item_upgrade1(MaterialList,State,[],[],0),
	
	TargetItem = data_agent:item_template_get(TargetId),

	if ItemInfo#ets_users_items.is_bind =:= ?NOBIND andalso NewBindFlag > 0 ->
		NewItemInfo = ItemInfo#ets_users_items{is_bind = ?BIND, template_id = TargetId};
	true ->
		NewItemInfo = ItemInfo#ets_users_items{template_id = TargetId}
	end,
	NewItemInfo1 = item_util:update_item_to_bag(NewItemInfo),%%更新缓存
	{ok, NewState, 1, TargetItem, NewItemInfo1, NewItemList, NewDelList}.

item_upgrade1([], State, ItemList, DelList, BindFlag) ->
	{State, ItemList, DelList, BindFlag};
item_upgrade1([{Id, NeedNum}|Arry], State, ItemList, DelList, BindFlag) ->
	{NewState, NewItemList, NewDelList, NewBindFlag} = lib_item:reduce_item_to_users(Id, NeedNum, State, ItemList, DelList,?CONSUME_ITEM_UPGRADE),
	item_upgrade1(Arry, NewState, NewItemList, NewDelList, NewBindFlag + BindFlag).

%%道具合成
item_compose(State, FormulaTemp, ComposeNum) ->
	TemplateId1 = FormulaTemp#ets_formula_template.item1,
	Amount1 = FormulaTemp#ets_formula_template.amount1,
	TemplateId2 = FormulaTemp#ets_formula_template.item2,
	Amount2 = FormulaTemp#ets_formula_template.amount2,
	TemplateId3 = FormulaTemp#ets_formula_template.item3,
	Amount3 = FormulaTemp#ets_formula_template.amount3,
	TemplateId4 = FormulaTemp#ets_formula_template.item4,
	Amount4 = FormulaTemp#ets_formula_template.amount4,
	TemplateId5 = FormulaTemp#ets_formula_template.item5,
	Amount5 = FormulaTemp#ets_formula_template.amount5,
	TemplateId6 = FormulaTemp#ets_formula_template.item6,
	Amount6 = FormulaTemp#ets_formula_template.amount6,
	
	{State1, ItemList1, DelList1, BindFlag1} = lib_item:reduce_item_to_users(TemplateId1,Amount1 * ComposeNum,State,[],[],?CONSUME_ITEM_COMPOSE),
	{State2, ItemList2, DelList2, BindFlag2} = lib_item:reduce_item_to_users(TemplateId2,Amount2 * ComposeNum,State1,ItemList1,DelList1,?CONSUME_ITEM_COMPOSE),
	{State3, ItemList3, DelList3, BindFlag3} = lib_item:reduce_item_to_users(TemplateId3,Amount3 * ComposeNum,State2,ItemList2,DelList2,?CONSUME_ITEM_COMPOSE),
	{State4, ItemList4, DelList4, BindFlag4} = lib_item:reduce_item_to_users(TemplateId4,Amount4 * ComposeNum,State3,ItemList3,DelList3,?CONSUME_ITEM_COMPOSE),
	{State5, ItemList5, DelList5, BindFlag5} = lib_item:reduce_item_to_users(TemplateId5,Amount5 * ComposeNum,State4,ItemList4,DelList4,?CONSUME_ITEM_COMPOSE),
	{State6, ItemList6, DelList6, BindFlag6} = lib_item:reduce_item_to_users(TemplateId6,Amount6 * ComposeNum,State5,ItemList5,DelList5,?CONSUME_ITEM_COMPOSE),
	
	SuccRate1 = FormulaTemp#ets_formula_template.success_rate,
	SuccRate = tool:ceil(SuccRate1),
	Random = util:rand(1, 100),
	if
		SuccRate < Random ->
			%%合成失败		
			{ok, State6, 0, ItemList6, DelList6};
		true ->
			%%合成成功 增加物品
			CreateTempId = FormulaTemp#ets_formula_template.create_id,
			CreateAcount = FormulaTemp#ets_formula_template.create_amount * ComposeNum,
			Template = data_agent:item_template_get(CreateTempId),
			
			%%道具合成的材料是绑定的话  生成的物品需不需要改为绑定? 优先扣除玩家身上绑定的材料  会导致只要有绑定的材料就会生成绑定的物品！
			if
				BindFlag1 + BindFlag2 + BindFlag3 + BindFlag4 + BindFlag5 + BindFlag6 > 0 ->			
					BindFlag = ?BIND;
				Template#ets_item_template.bind_type =:= ?BIND_TYPE_1 ->
					BindFlag = ?BIND;

				true ->
					BindFlag = ?NOBIND
			end,
			
			{State7, NewItemList, _Amount} = lib_item:add_item_amount_summation(Template,CreateAcount,State6,[], BindFlag, ?CANSUMMATION),			
			{ok, State7, 1, lists:append(ItemList6, NewItemList), DelList6}
	end.

func_item_place(InfoList) ->
	F = fun(Info, NewInfoList) ->
				case lists:keyfind(Info#ets_users_items.place, 1, NewInfoList) of
					false ->
						[{Info#ets_users_items.place, 1, Info} | NewInfoList];
					Old ->
						{Place, Amount, Info1} = Old,
						NewInfoList1 = lists:keydelete(Place, 1, NewInfoList),
						[{Place, Amount+1, Info1} | NewInfoList1]
				end
		end,
	InfoList1 = lists:foldl(F, [], InfoList),
	case func_item_place_1(InfoList1, 0) of
		0 ->
			ok;
		_ ->
			error
	end.

func_item_place_1([], Res) ->
	Res;
func_item_place_1([{_Place, Amount, Info}|List], Res) ->
	if
		Info#ets_users_items.amount < Amount ->
			func_item_place_1([], Res+1);
		true ->
			func_item_place_1(List, Res)
	end.

%%宝石合成检查
check_stone_compose(State,StoneId,ComposeNum,Copper) ->
	{ItemList, Amount} = get_bag_item_list_by_templateId(StoneId, State#item_status.user_id),	
	if
		ComposeNum =< 0 orelse Amount < ComposeNum * ?COMSTONE_STONE_NUM ->			
			{error, "not enough stone"};
		true ->
			[ItemInfo|_] = ItemList,
			Temp = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			StoneCompTemp = data_agent:item_stone_decompose_template_get(Temp#ets_item_template.propert3),
			NeedCopper = StoneCompTemp#ets_stone_compose_template.copper * ComposeNum,
			if
				NeedCopper > Copper ->
					{error, "copper is not enough"};
				erlang:length(State#item_status.null_cells) < 1 ->
					{error, "null cells is not enough"};
				true ->												
					{ok, ItemList, NeedCopper}
			end
	end.

%%背包宝石淬炼检查
check_bag_stone_quench(State, StonePlace, QuenchPlace, Copper, YuanBao, IsYuanBao) ->
	TempItem1 = item_util:get_user_item_by_place(State#item_status.user_id, StonePlace),	
	TempItem2 = item_util:get_user_item_by_place(State#item_status.user_id, QuenchPlace),	
	if	TempItem1 =:= [] orelse TempItem2 =:= [] ->
		{error, "item is not enough"};
	true ->
		[TempItemInfo1] = TempItem1,
		[TempItemInfo2] = TempItem2,
		StId = TempItemInfo1#ets_users_items.template_id,	
		IsFine = 
		if StId >= ?FINE_STONE_BEGID andalso StId =< ?FINE_STONE_ENDID ->
			1;
		StId >= ?ORD_STONE_BEGID andalso StId =< ?ORD_STONE_ENDID ->
			0;
		true ->
			-1
		end,
		if IsFine =:= -1 ->
			{error, "error stone"};
		true ->
			Temp = data_agent:item_template_get(TempItemInfo1#ets_users_items.template_id),
			QuenchTemp = data_agent:item_template_get(TempItemInfo2#ets_users_items.template_id),
			%% 检查淬炼石等级是否和宝石等级匹配
			case check_quench_stone(QuenchTemp, Temp#ets_item_template.propert3) of
				{error, ErrMsg} ->	
					{error, ErrMsg};
				{ok} ->		
					NeedCopper = ?STONE_QUENCH_PRICE,
					NeedYuanBao = lists:nth(QuenchTemp#ets_item_template.propert3, ?QUENCH_COST_YUANBAO),
					if
						NeedCopper > Copper ->
							{error, "copper is not enough"};
						erlang:length(State#item_status.null_cells) < 1 ->
							{error, "null cells is not enough"};
						IsYuanBao =:= 1 andalso YuanBao < NeedYuanBao ->
							{error, "yuanbao is not enough"};
						IsYuanBao =:= 1 ->											
							{ok, [TempItemInfo1], [TempItemInfo2], NeedCopper, NeedYuanBao, IsFine};
						true ->
							{ok, [TempItemInfo1], [TempItemInfo2], NeedCopper, 0, IsFine}
					end;
				_ ->
					{error, "error"}
			end
		end
	end.

%% 装备宝石淬炼检查
check_equip_stone_quench(ItemState, ItemPlace, HolePlace, Quench_StoneId, Copper, YuanBao, IsYuanBao) ->
	{ItemList, Amount} = get_bag_item_list_by_templateId(Quench_StoneId, ItemState#item_status.user_id),
	if ItemList =:= [] ->
			{error, "item not enough"};
		true ->
			case item_util:get_user_item_by_place(ItemState#item_status.user_id, ItemPlace) of
				[] ->
					{error, "record is not exist"};
				[ItemInfo] ->
					case check_pick_stone_2(ItemInfo, HolePlace) of
						{error} ->
							{error, "stone is not exist"};
						{ok, StoneTempId} ->
							StoneTempalte = data_agent:item_template_get(StoneTempId),					
							StoneLevel = StoneTempalte#ets_item_template.propert3,
							[QuenchInfo|_] = ItemList,
							QuenchTemp = data_agent:item_template_get(QuenchInfo#ets_users_items.template_id),							
							%% 检查淬炼石等级是否和宝石等级匹配
							case check_quench_stone(QuenchTemp, StoneLevel) of
								{error, ErrMsg} ->	
									{error, ErrMsg};
								{ok} ->				
									NeedCopper = ?STONE_QUENCH_PRICE,
									NeedYuanBao = lists:nth(QuenchTemp#ets_item_template.propert3, ?QUENCH_COST_YUANBAO),																		
									if 
										Amount < 1 ->
											{error, "not enough stone"};
										NeedCopper > Copper ->
											{error, "copper is not enough"};
										IsYuanBao =:= 1 andalso YuanBao < NeedYuanBao ->
											{error, "yuanbao is not enough"};
										IsYuanBao =:= 1 ->																						
											{ok, ItemList, NeedCopper, NeedYuanBao};
										true ->
											{ok, ItemList, NeedCopper, 0}
									end
							end
					end
			end
	end.

%%宝石等级是否与淬炼石等级匹配
check_quench_stone(QuenchTemplate, StoneLevel) ->	                                                               
	case QuenchTemplate#ets_item_template.propert3 of
		1 ->
			case lists:member(StoneLevel, ?PRIQUENCHLEVEL) of
				true ->
					{ok};
				false ->
					{error, "type is not conform1"}
			end;		
		2 ->
			case lists:member(StoneLevel, ?MIDQUENCHLEVEL) of
				true ->
					{ok};
				false ->
					{error, "type is not conform2"}
			end;		
		3 ->
			case lists:member(StoneLevel, ?HIGHTQUENCHLEVEL) of
				true ->
					{ok};
				false ->
					{error, "type is not conform3"}
			end;
		_ ->
			{error, "error stone"}
	end.


%%宝石合成检查
check_stone_compose(State, StoneNum, PlaceList, Copper, BindCopper) ->
	case lib_item:func_check_place(StoneNum, State, PlaceList, []) of
		{error} ->
			{error, "record is not exist"};
		{ok, InfoList} ->
			case func_item_place(InfoList) of
				error ->
					{error, "itemamount is not exist"};
				_ ->
					if
						StoneNum =/= 4 ->
							{error, "stone num is error"};
						true ->
							check_stone_compose_1(State, PlaceList, InfoList, Copper, BindCopper)
					end
			end
	end.

check_stone_compose_1(State, PlaceList, InfoList, Copper, BindCopper) ->
	case check_stone_compose_2(InfoList) of
		{error, Res} ->				
			{error,  Res};
		{ok, ComStoneTemp} ->	
			StoneCompTemp = data_agent:item_stone_decompose_template_get(ComStoneTemp#ets_item_template.propert3),
			NeedCopper = StoneCompTemp#ets_stone_compose_template.copper,
			if
				NeedCopper > Copper + BindCopper ->
					{error, "copper is not enough"};
				erlang:length(State#item_status.null_cells) < 1 ->
					{error, "null cells is not enough"};
				true ->												
					{ok, PlaceList, InfoList, NeedCopper, ComStoneTemp}
			end
	end.
			
check_stone_compose_2([Info|StoneInfoList]) ->
	case lists:filter(fun(X) ->X#ets_users_items.template_id =/= Info#ets_users_items.template_id end, StoneInfoList) of
		[] ->
			Temp = data_agent:item_template_get(Info#ets_users_items.template_id),
			if				
				Temp#ets_item_template.category_id < ?COMSTONECATAMIN andalso Temp#ets_item_template.category_id > ?COMSTONECATAMAX ->
					{error, "stone type is error"};
				true ->
					{ok, Temp}
			end;		
		_ ->
			{error, "stone is not the same"}
	end.

check_stone_compose_3(ItemLevel, StoneLevel, ItemTemp) ->
	if
		ItemTemp#ets_item_template.category_id =/= ?CATE_COMPOSE_LUCKY_SYMBOL ->
			{error, "stone type is error"};
		true ->
			case ItemLevel of
				1 ->
					PRISTONELEVEL = [1,2,3],
%% 					case lists:member(StoneLevel, ?PRISTONELEVEL) of
					case lists:member(StoneLevel, PRISTONELEVEL) of
						true ->
							{ok};
						false ->
							{error, "stone type is error"}
					end;
				2 ->
					MIDSTONELEVEL = [4,5,6],
%% 					case lists:member(StoneLevel, ?MIDSTONELEVEL) of
					case lists:member(StoneLevel, MIDSTONELEVEL) of
						true ->
							{ok};
						false ->
							{error, "stone type is error"}
					end;
				3 ->
					HIGHTSTONELEVEL = [7,8],
%% 					case lists:member(StoneLevel, ?HIGHTSTONELEVEL) of
					case lists:member(StoneLevel, HIGHTSTONELEVEL) of
						true ->
							{ok};
						false ->
							{error, "stone type is error"}
					end
			end
	end.

item_exchang_buy(ItemStatus, ItemList, Amount, ExCount ,ITemp) ->
	{BindList,UNBindList} = order_by_Bind(ItemList),
	{ItemList1, DeleteList, _RealNum, ItemStatus1} = item_stone_compose1(BindList ++ UNBindList, Amount, ITemp, [], [], 0, ItemStatus),
	{ItemStatus2, ItemList2, _Amount2} = lib_item:add_item_amount_summation(ITemp, ExCount, ItemStatus1, [], 1, ?CANSUMMATION),
	{ItemStatus2, ItemList1 ++ ItemList2, DeleteList}.


item_stone_compose(ItemStatus, ItemList, ComposeNum, UseBind) ->
	{BindList,UNBindList} = order_by_Bind(ItemList),
	[Info|_] = ItemList,
	CreaTemp = data_agent:item_template_get(Info#ets_users_items.template_id + 1),
	
	case UseBind of
		1 ->
			{ItemList4, DeleteList, RealNum, State} = item_stone_compose1(BindList, ComposeNum, CreaTemp, [], [], 0, ItemStatus),
			if 
				ComposeNum > RealNum ->
					{ItemList2, DeleteList2, RealNum2, NewState} = item_stone_compose1(ItemList4++UNBindList, ComposeNum - RealNum, CreaTemp, [], [], 0,State),
						TempNum = RealNum rem ?COMSTONE_STONE_NUM,
						if 
							RealNum =/= 0 ->
								{NewState2, ItemList1, _Amount} = lib_item:add_item_amount_summation(CreaTemp, (RealNum + ?COMSTONE_STONE_NUM - 1) div ?COMSTONE_STONE_NUM , NewState,
			 												 [], 1, ?CANSUMMATION);
							true ->
								NewState2 = NewState,
								ItemList1 = []
						end,
						if
							(RealNum2 - TempNum) div ?COMSTONE_STONE_NUM =/= 0 ->
								{NewState3, ItemList3, _Amount3} = lib_item:add_item_amount_summation(CreaTemp, (RealNum2 - TempNum)div ?COMSTONE_STONE_NUM , NewState2,
			 												 [], 0, ?CANSUMMATION);
							true ->
								NewState3 = NewState2,
								ItemList3 = []
						end,
						[NewItemInfo|_] =  ItemList3 ++ ItemList1,
						{NewState3, 1, 0, ItemList2 ++ ItemList3 ++ ItemList1, DeleteList2++DeleteList, NewItemInfo,CreaTemp#ets_item_template.propert3};
				true ->
					{NewState, ItemList1, _Amount} = lib_item:add_item_amount_summation(CreaTemp, RealNum div ?COMSTONE_STONE_NUM , State,
			 												 [], 1, ?CANSUMMATION),
					[NewItemInfo|_] = ItemList1,
					{NewState, 1, 0, ItemList1 ++ ItemList4, DeleteList, NewItemInfo,CreaTemp#ets_item_template.propert3}
			end;
		0 ->
			
			{ItemList4, DeleteList, RealNum, State} = item_stone_compose1(UNBindList, ComposeNum, CreaTemp, [], [], 0, ItemStatus),
			if 
				ComposeNum > RealNum ->
					{ItemList2, DeleteList2, RealNum2, NewState} = item_stone_compose1(ItemList4++BindList, ComposeNum - RealNum, CreaTemp, [], [], 0,State),
						TempNum = RealNum rem ?COMSTONE_STONE_NUM,
						if 
							RealNum =/= 0 ->
								{NewState2, ItemList1, _Amount} = lib_item:add_item_amount_summation(CreaTemp, RealNum div ?COMSTONE_STONE_NUM , NewState,
			 												 [], 0, ?CANSUMMATION);
							true ->
								NewState2 = NewState,
								ItemList1 = []
						end,
						if
							(RealNum2 + TempNum)div ?COMSTONE_STONE_NUM =/= 0 ->
								{NewState3, ItemList3, _Amount3} = lib_item:add_item_amount_summation(CreaTemp, (RealNum2 + TempNum)div ?COMSTONE_STONE_NUM , NewState2,
			 												 [], 1, ?CANSUMMATION);
							true ->
								NewState3 = NewState2,
								ItemList3 = []
						end,
						[NewItemInfo|_] =  ItemList3 ++ ItemList1,
						{NewState3, 1, 0, ItemList2 ++ ItemList3 ++ ItemList1, DeleteList2++DeleteList, NewItemInfo,CreaTemp#ets_item_template.propert3};
				true ->
					{NewState, ItemList1, _Amount} = lib_item:add_item_amount_summation(CreaTemp, RealNum div ?COMSTONE_STONE_NUM , State,
			 												 [], 0, ?CANSUMMATION),
					[NewItemInfo|_] = ItemList1,
					{NewState, 1, 0, ItemList1 ++ ItemList4, DeleteList,  NewItemInfo,CreaTemp#ets_item_template.propert3}
			end
	end.

order_by_Bind(ItemList) ->
	F = fun(ItemInfo, {BindList, UNBindList}) ->
			if
				ItemInfo#ets_users_items.is_bind =:= 1 ->
					{[ItemInfo|BindList],UNBindList};
				true ->
					{BindList,[ItemInfo|UNBindList]}
			end
		end,
	lists:foldl(F, {[],[]}, ItemList).



item_stone_compose1([],_ComposeNum, _CreaTemp, ItemList, DeleteList, RealNum, State) ->
	{ItemList, DeleteList, RealNum, State};
item_stone_compose1([_], 0, _CreaTemp, ItemList, DeleteList, RealNum, State) ->
	{ItemList, DeleteList, RealNum, State};
item_stone_compose1([ItemInfo|List], ComposeNum, CreaTemp, ItemList, DeleteList, RealNum, State) ->
	if 
		ItemInfo#ets_users_items.amount >= ComposeNum ->
			[NewState, NewInfo, Delete] = change_item_num_in_commonbag(ItemInfo, ItemInfo#ets_users_items.place, ComposeNum, State,?CONSUME_ITEM_COMPOSE),
			{NewInfo++ItemList, DeleteList++Delete, RealNum + ComposeNum, NewState };
		true ->
%% 			UseNum1 = ItemInfo#ets_users_items.amount - ItemInfo#ets_users_items.amount rem ?COMSTONE_STONE_NUM,
%% 			if
%% 				UseNum1 =:= 0 ->
					UseNum = ItemInfo#ets_users_items.amount,
%% 				true ->
%% 					UseNum = UseNum1
%% 			end,
			[NewState, NewInfo, Delete] = change_item_num_in_commonbag(ItemInfo, ItemInfo#ets_users_items.place, UseNum, State,?CONSUME_ITEM_COMPOSE),
			item_stone_compose1(List,ComposeNum - UseNum, CreaTemp,
								 NewInfo++ItemList, DeleteList++Delete, RealNum + UseNum, NewState)
	end.

%%宝石合成处理
%% item_stone_compose(State, ItemPlace, PlaceList, InfoList, ComStoneTemp) ->
%% 	case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace) of
%% 		[] ->	
%% 			IsLuck = 0,
%% 			item_stone_compose_2(State, PlaceList, InfoList, ComStoneTemp, IsLuck);
%% 		[ItemInfo] ->
%% 			IsLuck = 1,
%% 			ItemTemp = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
%% 			case check_stone_compose_3(ItemTemp#ets_item_template.propert3, ComStoneTemp#ets_item_template.propert3, ItemTemp) of
%% 				{ok} ->
%% 					item_stone_compose_1(State, ItemPlace, ItemInfo, PlaceList, InfoList, ComStoneTemp, ItemInfo, IsLuck);
%% 				{error, Res} ->
%% 					{error, Res}
%% 			end
%% 	end.
			
item_stone_compose_1(State, ItemPlace, ItemInfo, PlaceList, InfoList, ComStoneTemp, ItemInfo, IsLuck) ->
	%%减少合成符
%% 	[NewState, NewItemInfo, ItemDeleteList] = lib_item:change_item_num_in_commonbag(ItemInfo, ItemPlace, 1, State),
	%%减少宝石列表的宝石
	[NewState1, NewInfo1, DeleteList1] = func_change_luckstone(InfoList, PlaceList, State, ItemInfo, []),	
	SuccRate = 100,
	Random = 100,
	if
		SuccRate < Random ->
			%%宝石合成失败
			{NewState1, 0, IsLuck, NewInfo1, DeleteList1};
		true ->
			%%宝石合成成功  生成高一等级的宝石
			CreaTemp = data_agent:item_template_get(ComStoneTemp#ets_item_template.template_id + 1),
			
			case lists:filter(fun(X) ->X#ets_users_items.is_bind =:= ?BIND end, InfoList) of
				[] when CreaTemp#ets_item_template.bind_type =/= ?BIND_TYPE_1, ItemInfo#ets_users_items.is_bind =/= ?BIND_TYPE_1->
					BindFlag = 0;
				_ ->
					BindFlag = 1
			end,
			
			{NewState2, ItemList1, _Amount} = lib_item:add_item_amount_summation(CreaTemp, 1, NewState1, [], BindFlag, ?CANSUMMATION),				
			{NewState2, 1, IsLuck, lists:append(ItemList1, NewInfo1), DeleteList1}
	end.
				
item_stone_compose_2(State, PlaceList, InfoList, ComStoneTemp, IsLuck) ->
	%%减少宝石列表的宝石
	[NewState, NewInfo, DeleteList] = func_change_luckstone(InfoList, PlaceList, State, [], []),
	
%% 	case erlang:length(InfoList) of
%% 		2 ->
%% 			SuccRate = 25;
%% 		3 ->
%% 			SuccRate = 50;
%% 		4 ->
%% 			SuccRate = 75
%% 	end,
%% 	Random = util:rand(1, 100),
	SuccRate = 100,
	Random = 100,
	if
		SuccRate < Random ->
			%%宝石合成失败
			{NewState, 0, IsLuck, NewInfo, DeleteList};
		true ->
			%%宝石合成成功  生成高一等级的宝石
			CreaTemp = data_agent:item_template_get(ComStoneTemp#ets_item_template.template_id + 1),
			
			case lists:filter(fun(X) ->X#ets_users_items.is_bind =:= ?BIND end, InfoList) of
				[] when CreaTemp#ets_item_template.bind_type =/= ?BIND_TYPE_1 ->
					BindFlag = 0;
				_ ->
					BindFlag = 1
			end,
			
			{NewState1, ItemList1, _Amount} = lib_item:add_item_amount_summation(CreaTemp, 1, NewState, [], BindFlag, ?CANSUMMATION),			
		
			{NewState1, 1, IsLuck, lists:append(ItemList1, NewInfo), DeleteList}
	end.

%% 背包宝石淬炼
item_bag_stone_quench(State, [ItemInfo1|_], [ItemInfo2|_], IsYuanBao, IsFine) ->
	[NewState1, NewInfo1, Delete1] = change_item_num_in_commonbag(ItemInfo1, ItemInfo1#ets_users_items.place, 1, State,?CONSUME_ITEM_COMPOSE),
	[NewState2, NewInfo2, Delete2] = change_item_num_in_commonbag(ItemInfo2, ItemInfo2#ets_users_items.place, 1, NewState1,?CONSUME_ITEM_COMPOSE),
	%% 如果宝石是绑定的或者淬炼石是绑定的，淬炼出来的宝石就是绑定的
	IsBind =
	if	ItemInfo1#ets_users_items.is_bind =:= ?BIND orelse ItemInfo2#ets_users_items.is_bind =:= ?BIND	->
			?BIND;
		true ->
			?NOBIND
	end,
	{Add_Stone_Index, Res} = 
	if IsFine =:= 0 ->
			if IsYuanBao =:= 1 ->
				{?PERFECTID_ADDNUM, ?PERFECT_QUENCH};
			true ->
				Random = util:rand(1, 5),
				if Random =:= 1 ->
					{?PERFECTID_ADDNUM, ?PERFECT_QUENCH};
				true ->
					{?QUENCHID_ADDNUM, ?UNPERFECT_QUENCH}
				end
			end;
	true ->
			if IsYuanBao =:= 1 ->
				{?QUENCHID_ADDNUM, ?PERFECT_QUENCH};
			true ->
				Random = util:rand(1, 5),
				if Random =:= 1 ->
					{?QUENCHID_ADDNUM, ?PERFECT_QUENCH};
				true ->
					{0, ?UNPERFECT_QUENCH}
				end
			end
	end,
	CreaTemp = data_agent:item_template_get(ItemInfo1#ets_users_items.template_id + Add_Stone_Index),
	{NewState3, NewItemList, _Amount} = add_item_amount_summation(CreaTemp, 1 , NewState2, [], IsBind, ?CANSUMMATION),
	[NewInfo|_] = NewItemList,
	{NewState3, Res, NewInfo1 ++ NewInfo2 ++ NewItemList, Delete1 ++ Delete2, NewInfo, CreaTemp#ets_item_template.propert3}.

%%装备宝石淬炼
item_equip_stone_quench(State, [ItemInfo2|_], ItemPlace, HolePlace, IsYuanBao, UserID, Level) ->
	ItemInfo1 =
		case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
		end,
	case quench_stone(ItemInfo1, HolePlace, IsYuanBao) of
		{fail, _} ->
			{error, "update stone fail"};
		{ok, NewItemInfo, StoneTemplateId} ->
			ItemTemplate = data_agent:item_template_get(ItemInfo1#ets_users_items.template_id),
			if  ItemTemplate =:= [] ->
					error;
				true ->
					CategoryId = ItemTemplate#ets_item_template.category_id,
					%%增加装备宝石变动记录
					lib_statistics:add_enchase_log(UserID, 1, 1, CategoryId,
												   StoneTemplateId, Level)
			end,
			NewItemInfo1 = change_item_enchase(NewItemInfo, []),
			[NewState, NewItemInfo2, Delete2] = change_item_num_in_commonbag(ItemInfo2, ItemInfo2#ets_users_items.place, 1, State,?CONSUME_ITEM_COMPOSE),
			{NewState, 1, [NewItemInfo1|NewItemInfo2], Delete2}
	end.

%%升级装备上的宝石
quench_stone(ItemInfo, HolePlace, IsYuanBao) ->
	%% 淬炼后宝石templateid增加的数值
	UpAddTemplateNum = 
	if
		IsYuanBao =:= 1 ->
			?PERFECTID_ADDNUM;
		true ->
			Random = util:rand(1, 5),
			if Random > 1 ->
			   		?QUENCHID_ADDNUM;
			   true ->
					?PERFECTID_ADDNUM
			end
	end,
	if 
		ItemInfo =:= [] ->
			{fail, 0};
		HolePlace =:= 1 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase1 = ItemInfo#ets_users_items.enchase1+UpAddTemplateNum},
			{ok, NewItemInfo, NewItemInfo#ets_users_items.enchase1};
		HolePlace =:= 2 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase2 = ItemInfo#ets_users_items.enchase2+UpAddTemplateNum},
			{ok, NewItemInfo, NewItemInfo#ets_users_items.enchase2};
		HolePlace =:= 3 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase3 = ItemInfo#ets_users_items.enchase3+UpAddTemplateNum},
			{ok, NewItemInfo, NewItemInfo#ets_users_items.enchase3};
		HolePlace =:= 4 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase4 = ItemInfo#ets_users_items.enchase4+UpAddTemplateNum},
			{ok, NewItemInfo, NewItemInfo#ets_users_items.enchase4};
		HolePlace =:= 5 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase5 = ItemInfo#ets_users_items.enchase5+UpAddTemplateNum},
			{ok, NewItemInfo, NewItemInfo#ets_users_items.enchase5};
		HolePlace =:= 6 ->
			NewItemInfo = ItemInfo#ets_users_items{enchase6 = ItemInfo#ets_users_items.enchase6+UpAddTemplateNum},
			{ok, NewItemInfo, NewItemInfo#ets_users_items.enchase6};
		true ->
			{fail, 0}
	end.

%%精致宝石分解
item_bag_stone_decompose(State, StonePlace, Copper) ->
	Info1 = item_util:get_user_item_by_place(State#item_status.user_id, StonePlace),		
	if	Info1 =:= [] ->
			{error, "item is not enough"};
		true ->
			[TempItemInfo] = Info1,
			if ?STONE_QUENCH_PRICE > Copper ->
					{error, "copper is not enough"};
				true ->					
					%% 对宝石Id求余，如果百位数在211和411之间就是精致宝石 如果大于等于411就是完美宝石
					case TempItemInfo#ets_users_items.template_id rem 1000 of
						Num when Num >= 211 andalso Num < 411 ->
							{TempState, NewInfo, ItemList1, DeleteList}	= change_stone_decompose(TempItemInfo, StonePlace, State),
							StoneTemplate = data_agent:item_template_get(TempItemInfo#ets_users_items.template_id - ?QUENCHID_ADDNUM),
							{NewState2, ItemList2, _Amount1} = add_item_amount_summation(StoneTemplate, 1, TempState, [], ?BIND, ?CANSUMMATION),
							{NewState2, 1, ?STONE_QUENCH_PRICE, NewInfo ++ ItemList1 ++ ItemList2, DeleteList};
						Num when Num >= 411	->		
							{TempState, NewInfo, ItemList1, DeleteList}	= change_stone_decompose(TempItemInfo, StonePlace, State),
							StoneTemplate = data_agent:item_template_get(TempItemInfo#ets_users_items.template_id - ?PERFECTID_ADDNUM),	
 							{NewState2, ItemList2, _Amount1} = add_item_amount_summation(StoneTemplate, 1, TempState, [], ?BIND, ?CANSUMMATION),
							{NewState2, 1, ?STONE_QUENCH_PRICE, NewInfo ++ ItemList1 ++ ItemList2, DeleteList};
						_ ->
							{error, "error template id"}
					end
			end
	end.

get_quench_id_by_stone_level(Level) ->
	if Level >= 1 andalso Level < 4 ->
			?QUENCH_ID_1;
		Level >= 4 andalso Level < 7 ->
			?QUENCH_ID_2;
		Level >= 7 andalso Level < 11 ->
			?QUENCH_ID_3;
		true ->
			0
	end.

change_stone_decompose(TempItemInfo, StonePlace, State) -> 
	Temp = data_agent:item_template_get(TempItemInfo#ets_users_items.template_id),
	[NewState, NewInfo, DeleteList] = change_item_num_in_commonbag(TempItemInfo, StonePlace, 1, State,?CONSUME_ITEM_USE),
	Random = util:rand(1, 5),
	{TempState, ItemList1} =
	if Random =:= 1 ->
			case get_quench_id_by_stone_level(Temp#ets_item_template.propert3) of 
				0 ->
					{NewState, []};
				Temp_id ->
					QuenchTemplate = data_agent:item_template_get(Temp_id),
					{NewState1, ItemList, _Amount} = add_item_amount_summation(QuenchTemplate, 1, NewState, [], ?BIND, ?CANSUMMATION),
					{NewState1, ItemList}
			end;
		true ->
			{NewState, []}
	end,
	{TempState, NewInfo, ItemList1, DeleteList}.

%%装备分解
check_decompose(State, ItemPlace, Copper, BindCopper) ->
	ItemInfo =
		case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
		end,
	
	if
		is_record(ItemInfo, ets_users_items) =:= false ->
			{error, "record is not exist"};
		true ->
			ItemTemp = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			ItemCataId = ItemTemp#ets_item_template.category_id,
			ItemQuality = ItemTemp#ets_item_template.quality,
			%%判断是否是装备类型
			check_decompose_1(State, ItemInfo, ItemCataId, Copper, BindCopper, ItemQuality, ItemTemp)
	end.

check_decompose_1(State, ItemInfo, ItemCataId, Copper, BindCopper, ItemQuality, ItemTemp) ->
	if
		ItemCataId >= ?SMALLITEMCATE andalso ItemCataId  =< ?MAXITEMCATE andalso ItemTemp#ets_item_template.can_recycle =:= ?CANRETRIEVE ->
			
%%			case lists:filter(fun(X) ->X =:=ItemCataId end, ?NODECOMPOSEITEM) of
%%				[] ->
%%					check_decompose_2(State, ItemInfo, Copper, BindCopper, ItemQuality, ItemTemp);
%%				_ ->
%%					{error, "cate is error1"}
%%			end;
			
			check_decompose_2(State, ItemInfo, Copper, BindCopper, ItemQuality, ItemTemp);
			
		true ->
			{error, "cate is error2"}
	end.
	
check_decompose_2(State, ItemInfo, Copper, BindCopper, ItemQuality, ItemTemp) ->
	StrengLevel = ItemInfo#ets_users_items.strengthen_level,
	DecomposeTemp = data_agent:item_decompose_template_get(ItemQuality),
	NeedCopper = DecomposeTemp#ets_decompose_template.needcopper,
	SuccRate = DecomposeTemp#ets_decompose_template.succ_rate,
	if
%%		StrengLevel >= ?PROTSTRENGLEVEL ->
%%			{error, "strenglevel is more than 3"};
		
		NeedCopper > Copper + BindCopper ->
			{error, "copper is not enough"};
		erlang:length(State#item_status.null_cells) < 1->
			{error, "null cell is not exist"};
		
%% 		ItemInfo#ets_users_items.enchase1 >= 0 ->
%% 			{error, "holded"};
%% 		ItemInfo#ets_users_items.enchase2 >= 0 ->
%% 			{error, "holded"};
%% 		ItemInfo#ets_users_items.enchase3 >= 0 ->
%% 			{error, "holded"};
%% 		ItemInfo#ets_users_items.enchase4 >= 0 ->
%% 			{error, "holded"};
%% 		ItemInfo#ets_users_items.enchase5 >= 0 ->
%% 			{error, "holded"};
		
		true ->
			{ok, ItemInfo, SuccRate, NeedCopper, ItemTemp}
	end.

%%装备分解
item_decompse(ItemInfo, ItemPlace, SuccRate, State, ItemTemp) ->
	%lib_statistics:add_item_log(ItemInfo#ets_users_items.template_id, ?ITEM_DECOMPSE, 1),
	%%减少装备 
	[NewState, NewItemInfo, ItemDeleteList] = lib_item:change_item_num_in_commonbag(ItemInfo, ItemPlace, 1, State, ?CONSUME_ITEM_DECOMPSE),
	SuccRate1 = tool:ceil(SuccRate),
	Random = util:rand(1, 100),
	if
		SuccRate1 < Random ->
			%%装备分解失败
			{NewState, 0, NewItemInfo, ItemDeleteList};
		true ->
			TemplateId = ItemTemp#ets_item_template.propert3,
			Acount1 = ItemTemp#ets_item_template.propert4,
			if
				Acount1 > 0 ->
					Acount2 = Acount1;
				true ->
					Acount2 = 1
			end,
					
			Template = data_agent:item_template_get(TemplateId),
			case is_record(Template, ets_item_template) of
				true ->
					Acount = util:rand(1, Acount2),
					if
						ItemInfo#ets_users_items.is_bind =:= ?NOBIND andalso Template#ets_item_template.bind_type =/= ?BIND_TYPE_1 ->
							BindFlag = ?NOBIND;
						true ->
							BindFlag = ?BIND
					end,
					{NewState1, ItemList, _Amount} = lib_item:add_item_amount_summation(Template, Acount, NewState, [], BindFlag, ?CANSUMMATION),
					{NewState1, 1, lists:append(NewItemInfo, ItemList), ItemDeleteList};
				_ ->
					{NewState, 0, NewItemInfo, ItemDeleteList}
			end
	end.


%%装备融合检查
check_item_fision(State, BulePlace, PurplePlace1, PurplePlace2,Copper, BindCopper) ->
%%	[BuleItemInfo] = item_util:get_user_item_by_place(State#item_status.user_id, BulePlace),
%%	[PurpleItemInfo1] = item_util:get_user_item_by_place(State#item_status.user_id, PurplePlace1),
%%	[PurpleItemInfo2] = item_util:get_user_item_by_place(State#item_status.user_id, PurplePlace2),
	
	BuleItemInfo =
		case item_util:get_user_item_by_place(State#item_status.user_id, BulePlace) of
			[] ->
				[];
			[Bule] ->
				Bule
		end,
	
	PurpleItemInfo1 =
		case item_util:get_user_item_by_place(State#item_status.user_id, PurplePlace1) of
			[] ->
				[];
			[Purple1] ->
				Purple1
		end,
	
	PurpleItemInfo2 =
		case item_util:get_user_item_by_place(State#item_status.user_id, PurplePlace2) of
			[] ->
				[];
			[Purple2] ->
				Purple2
		end,
	
	
	if
		is_record(BuleItemInfo, ets_users_items) =:= false orelse is_record(PurpleItemInfo1, ets_users_items) =:= false
		  orelse is_record(PurpleItemInfo2, ets_users_items) =:= flase ->
			{error, "record is not exist"};
		true ->
			BuleTemp = data_agent:item_template_get(BuleItemInfo#ets_users_items.template_id),
			PurpleTemp1 = data_agent:item_template_get(PurpleItemInfo1#ets_users_items.template_id),
			PurpleTemp2 = data_agent:item_template_get(PurpleItemInfo2#ets_users_items.template_id),
			
			if
				BuleTemp#ets_item_template.quality =/= ?BULEQUALITY 
					    orelse PurpleTemp1#ets_item_template.quality =/= ?PURPLEQUALITY 
						orelse PurpleTemp2#ets_item_template.quality =/= ?PURPLEQUALITY  ->						
					{error, "item quality is error"};
				BuleTemp#ets_item_template.category_id < ?SMALLITEMCATE orelse BuleTemp#ets_item_template.category_id > ?MAXITEMCATE ->
					{error, "bule item type is error"};
				PurpleTemp1#ets_item_template.category_id < ?SMALLITEMCATE orelse PurpleTemp1#ets_item_template.category_id > ?MAXITEMCATE ->
					{error, "purple item1 type is error"};
				PurpleTemp2#ets_item_template.category_id < ?SMALLITEMCATE orelse PurpleTemp2#ets_item_template.category_id > ?MAXITEMCATE ->
					{error, "purple item2 type is error"};
				PurpleTemp1#ets_item_template.need_career =/= BuleTemp#ets_item_template.need_career 
				  orelse PurpleTemp2#ets_item_template.need_career =/= BuleTemp#ets_item_template.need_career ->
					{error, "item career is error"};
				Copper + BindCopper < ?FISIONNEEDCOPPER ->
					{error, "copper is not enough"};
				
				true ->
					{ok, BuleItemInfo, PurpleItemInfo1, PurpleItemInfo2}
			end
	end.

%%装备融合处理
item_fision(State,BuleItemInfo,PurpleItemInfo1,PurplePlace1,PurpleItemInfo2,PurplePlace2) ->
	%%两件紫装减少
	[NewState, NewItemInfo, ItemDeleteList] = lib_item:change_item_num_in_commonbag(PurpleItemInfo1, PurplePlace1, 1, State,?CONSUME_ITEM_FISION),
	[NewState1, NewItemInfo1, ItemDeleteList1] = lib_item:change_item_num_in_commonbag(PurpleItemInfo2, PurplePlace2, 1, NewState,?CONSUME_ITEM_FISION),
	%%装备品质提升
	NewTempId = BuleItemInfo#ets_users_items.template_id,
	NewBuleItemInfo = lib_item:change_item_templateid(BuleItemInfo, NewTempId+1),
	if
		BuleItemInfo#ets_users_items.is_bind =:= ?NOBIND ->
			if
				PurpleItemInfo1#ets_users_items.is_bind =:= ?BIND orelse PurpleItemInfo2#ets_users_items.is_bind =:= ?BIND ->
					NewBuleItemInfo1 = lib_item:change_item_isbind(BuleItemInfo, ?BIND),
					{NewState1, lists:append([NewBuleItemInfo1|NewItemInfo], NewItemInfo1), lists:append(ItemDeleteList, ItemDeleteList1)};
				true ->
					{NewState1, lists:append([NewBuleItemInfo|NewItemInfo], NewItemInfo1), lists:append(ItemDeleteList, ItemDeleteList1)}
			end;
		true ->
			{NewState1, lists:append([NewBuleItemInfo|NewItemInfo], NewItemInfo1), lists:append(ItemDeleteList, ItemDeleteList1)}
	end.

%%装备洗练检查
check_item_rebuild(PlayerStatus, State, PetId, ItemPlace, StonePlace, Copper, Locks) ->
	ItemInfo = 
	if	PetId > 0 ->
			case item_util:get_pet_equip_by_place(PetId, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
			end;
		true ->
			case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
			end
	end,
		
	StoneInfo = 
		case item_util:get_user_item_by_place(State#item_status.user_id, StonePlace) of
			[] ->
				[];
			[Stone] ->
				Stone
		end,
		
	if
		is_record(ItemInfo, ets_users_items) =:= false ->
			{error, "record is not exist"};
		is_record(StoneInfo, ets_users_items) =:= false ->
			{error, "record is not exist"};
		true ->
			ItemTemplate = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
			StoneTemplate = data_agent:item_template_get(StoneInfo#ets_users_items.template_id),
			 if
				 is_record(ItemTemplate, ets_item_template) =/= true ->
					 {error, "ItemTemplate type is error"};
				 is_record(StoneTemplate, ets_item_template) =/= true ->
					 {error, "StoneTemplate type is error"};
				 ItemTemplate#ets_item_template.category_id < ?SMALLITEMCATE 
							 orelse ItemTemplate#ets_item_template.category_id > ?MAXITEMCATE ->
					 {error, "item type is error"};
				 ItemTemplate#ets_item_template.can_rebuild =/= ?CANREBUILD ->
					 {error, "item cata is error"};
				 ItemTemplate#ets_item_template.quality =:= 0 ->
					 {error, "item quality is error"};
				 erlang:length(ItemTemplate#ets_item_template.free_property) < 1 ->
					  {error, "item free_property is error"};

				 StoneTemplate#ets_item_template.category_id =/= ?CATE_REBUILD ->
					 {error , "stone cata is error"};
				 StoneTemplate#ets_item_template.propert3 < ItemTemplate#ets_item_template.quality ->
					 {error, "stone level is error"};			 
				 true ->					 
					 ItemQuality = ItemTemplate#ets_item_template.quality,
					 DecomposeTempalte = data_agent:item_decompose_copper_template_get(ItemQuality),
					 NeedCopper = DecomposeTempalte#ets_decompose_copper_template.needcopper,
					 %%io:format("rebuild locks info:~p~n",[Locks]),
					 CheckLock = check_rebuild_lock(Locks,State#item_status.user_id),
					
					 if
						 NeedCopper > Copper ->
							 {error, "copper is not enough"};
						 CheckLock =:= false ->
							 {error, "lock is not enough"};
						 true ->
							 {ok, ItemInfo, StoneInfo, NeedCopper, ItemTemplate}
					 end
			 end
	end.

%%装备强化等级转移
check_item_transform(State, _OpType,ItemPlace1,ItemPlace2,Copper) ->
	ItemInfo1 = case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace1) of
				[] ->
					false;
				[Item1] ->
					Item1
				end,
	ItemInfo2 = case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace2) of
				[] ->
					false;
				[Item2] ->
					Item2
				end,
	NeedCopper = ?TRANSFORM_PRICE, %%转移所需价格零时固定
	if
		Copper < NeedCopper ->
			{error, "copper is not enough"};
		ItemInfo1 =:= false orelse  ItemInfo2 =:= false ->
			{error, "item is not exist"};
		ItemInfo1#ets_users_items.strengthen_level div ?STRENGTHEN_LEVEL_UNIT < 1 + ItemInfo2#ets_users_items.strengthen_level div ?STRENGTHEN_LEVEL_UNIT ->
			{error, "item streng level error"};
		true ->
			Item1Template = data_agent:item_template_get(ItemInfo1#ets_users_items.template_id),
			Item2Template = data_agent:item_template_get(ItemInfo2#ets_users_items.template_id),
			if
				is_record(Item1Template, ets_item_template) =/= true orelse is_record(Item2Template, ets_item_template) =/= true ->
					{error, "item type error"};
				Item1Template#ets_item_template.category_id =/= Item2Template#ets_item_template.category_id ->
					{error, "item equip position error"};
				%%Item1Template#ets_item_template.quality > Item2Template#ets_item_template.quality ->
				%%	{error, "item quality error"};
				true ->
					{ok, ItemInfo1, ItemInfo2, NeedCopper}			
			end
	end.

check_rebuild_lock({LockPlace,Num}, UserId) ->
	if
		Num =:= 0 ->
			true;
		Num < 0 ->
			false;
		true ->	
			Amount = item_util:get_count_by_templateid(0, ?REBUILD_LOCK_STONE),
			if 	Amount < Num ->
				false;
			true ->
				true				
%% 			case item_util:get_user_item_by_place(UserId, LockPlace) of
%% 				[] ->
%% 					false;
%% 				[Lock] ->
%% 					if is_record(Lock, ets_users_items) =:= false
%% 							orelse Lock#ets_users_items.amount < Num ->
%% 						false;
%% 					true ->
%% 						LockTemplate = data_agent:item_template_get(Lock#ets_users_items.template_id),
%% 						if
%% 							is_record(LockTemplate, ets_item_template) =/= true 
%% 									orelse LockTemplate#ets_item_template.category_id =/= ?CATE_REBUILD_LOCK ->
%% 								false;
%% 							true ->
%% 								true
%% 						end
%% 					end
			end
	end.

%%装备强化等级洗炼属性转移处理
item_transform(State, ItemInfo1, ItemInfo2, _OpType1) ->
	%LostLevel1 = util:rand(1,200),
	%if
	%	ItemInfo1#ets_users_items.strengthen_level - LostLevel1 > ?STRENGTHEN_LEVEL_UNIT ->
	%		LostLevel = LostLevel1;
	%	true ->
	%		LostLevel = ItemInfo1#ets_users_items.strengthen_level
	%end,
	OpType = ?TRANSFORM_STRENGTHEN,
	if ItemInfo1#ets_users_items.is_bind =:= ?BIND_TYPE_1 orelse ItemInfo2#ets_users_items.is_bind =:= ?BIND_TYPE_1 ->
					BindType = ?BIND_TYPE_1;
				true ->
					BindType = ItemInfo2#ets_users_items.is_bind
	end,
	if 
		OpType =:= ?TRANSFORM_STRENGTHEN ->
			
			NewItemInfo2 = transform_strengthen_level_open_enchase(ItemInfo1#ets_users_items.strengthen_level,
							 ItemInfo2#ets_users_items{strengthen_level = ItemInfo1#ets_users_items.strengthen_level,
														 fail_acount = 0, is_bind = BindType}),
			NewItemInfo1 = ItemInfo1#ets_users_items{strengthen_level = 0, fail_acount = 0};
		OpType =:= ?TRANSFORM_REBUILD ->
			ItemOther2 = ItemInfo2#ets_users_items.other_data#item_other{prop_list = ItemInfo2#ets_users_items.other_data#item_other.prop_list,
																		rebuild_list = ItemInfo2#ets_users_items.other_data#item_other.rebuild_list},
			NewItemInfo2 = ItemInfo2#ets_users_items{data = ItemInfo1#ets_users_items.data, other_data = ItemOther2},
			NewItemInfo1 = ItemInfo1#ets_users_items{data = ""};
		true ->
			ItemOther2 = ItemInfo2#ets_users_items.other_data#item_other{prop_list = ItemInfo2#ets_users_items.other_data#item_other.prop_list,
																		rebuild_list = ItemInfo2#ets_users_items.other_data#item_other.rebuild_list},
			NewItemInfo2 = transform_strengthen_level_open_enchase(ItemInfo1#ets_users_items.strengthen_level,
							 ItemInfo2#ets_users_items{strengthen_level = ItemInfo1#ets_users_items.strengthen_level, fail_acount = 0,
														data = ItemInfo1#ets_users_items.data, other_data = ItemOther2, is_bind = BindType}),
			NewItemInfo1 = ItemInfo1#ets_users_items{strengthen_level = 0, fail_acount = 0,data = ""}
	end,
	NewItemInfo11 = item_util:update_item_to_bag(NewItemInfo1),%%更新缓存
	NewItemInfo21 = item_util:update_item_to_bag(NewItemInfo2),%%更新缓存	
	IsUpdate = if
				   NewItemInfo11#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso  NewItemInfo11#ets_users_items.place < ?BAG_BEGIN_CELL ->
					   1;
				   NewItemInfo21#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso  NewItemInfo21#ets_users_items.place < ?BAG_BEGIN_CELL ->
					   1;
				   true ->
					   0
			   end,
	{State,1,lists:append([NewItemInfo21],[NewItemInfo11]),IsUpdate}.

%%替换洗炼属性
item_replace_rebuild(State, PetId, ItemPlace) ->
	ItemInfo = 
	if	PetId > 0 ->
			case item_util:get_pet_equip_by_place(PetId, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
			end;
		true ->
			case item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace) of
			[] ->
				[];
			[Item] ->
				Item
			end
	end,
	if 
		ItemInfo =:= false ->
			{error,0,"item is not exist"};
		true ->
			RebuildList = ItemInfo#ets_users_items.other_data#item_other.rebuild_list,
			if length(RebuildList) > 0  ->
				NewRebuildList = item_rebuildList_to_propList(RebuildList,[]),
				Data = tool:intlist_to_string_1(NewRebuildList),
				NewOtherData = ItemInfo#ets_users_items.other_data#item_other{prop_list = NewRebuildList,rebuild_list = []},
				NewItemInfo = ItemInfo#ets_users_items{other_data = NewOtherData, data = Data},
				NewItemInfo1 = item_util:update_item_to_bag(NewItemInfo),
				
				{ok,ItemInfo#ets_users_items.id,NewItemInfo1};
			true ->
				{error, ItemInfo#ets_users_items.id,"rebuild_list is empty"}
			end
	end.

item_rebuildList_to_propList([],NewList) ->
	NewList;
item_rebuildList_to_propList([{Index,Type, Value, Rate}|List], NewList) ->
	item_rebuildList_to_propList(List, lists:append(NewList,[{Index, Type, Value, Rate - 2}])).
%%装备洗练处理
item_rebuild(State, ItemInfo, StoneInfo, StonePlace, _Lucks, ItemTemplate, LockList) ->
	%%扣除洗练石	
	[NewState, NewStoneInfo, StoneDeleteList] = lib_item:change_item_num_in_commonbag(StoneInfo, StonePlace, 1, State, ?CONSUME_ITEM_REBUILD),	
	%%{_LockPlace, Num} = Lucks,
	Num = erlang:length(LockList),
	BindFlag = StoneInfo#ets_users_items.is_bind =:= ?BIND_TYPE_1,
	if Num < 1 ->	
			item_rebuild_1(NewState, ItemInfo,BindFlag, ItemTemplate, NewStoneInfo, StoneDeleteList, LockList);	
		true -> 
			{NewState1, ItemList, DeleteList, BindFlag2} = reduce_item_to_users(?REBUILD_LOCK_STONE, Num, NewState, NewStoneInfo, StoneDeleteList, ?CONSUME_ITEM_REBUILD),
			BindFlag1 =  BindFlag andalso BindFlag2,
			item_rebuild_1(NewState1, ItemInfo,BindFlag1, ItemTemplate, ItemList, DeleteList, LockList)			
	end.

%% 检查装备熔炼 ItemPlace1: 熔炼装备1位置 ItemPlace2: 熔炼装备2位置 ItemID3: 熔炼符ID
check_equip_funsion(State, ItemPlace1, ItemPlace2, ItemID3, Copper) ->
	TempItem1 = item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace1),	
	TempItem2 = item_util:get_user_item_by_place(State#item_status.user_id, ItemPlace2),
	if	TempItem1 =:= [] orelse TempItem2 =:= [] ->
		{error, "item is not enough"};
	ItemID3 =/= ?FUSION_TALLY ->
		{error, "fusion tally error"};
	Copper < ?FUSION_COPPER ->
		{error, "copper not enough"};
	true ->
		ItemInfo1 = check_enchase1(TempItem1),
		ItemInfo2 = check_enchase1(TempItem2),
		if ItemInfo1 =:= false orelse ItemInfo2 =:= false ->
			{error, "item enchase stone not empty"};
		true ->
%% 获取熔炼模版，可以交换物品id进行获取
			Fusion_Temp1 = data_agent:item_fusion_template_get({ItemInfo1#ets_users_items.template_id, ItemInfo2#ets_users_items.template_id}),
			Fusion_Temp2 = data_agent:item_fusion_template_get({ItemInfo2#ets_users_items.template_id, ItemInfo1#ets_users_items.template_id}),
			if Fusion_Temp1 =:= [] andalso Fusion_Temp2 =:= [] ->
				Fusion_Temp = [];
			Fusion_Temp1 =:= [] ->
				Fusion_Temp = Fusion_Temp2;
			Fusion_Temp2 =:= [] ->
				Fusion_Temp = Fusion_Temp1;
			true ->
				Fusion_Temp = Fusion_Temp1
			end,
			if Fusion_Temp =:= [] ->
				{error, "item error"};
			true ->
				{ItemList1, Amount} = get_bag_item_list_by_templateId(ItemID3, State#item_status.user_id),
				if Fusion_Temp#ets_item_fusion_template.fusion_num > Amount ->
					{error, "fusion tally not enough"};
				true ->
					{ok, ItemInfo1, ItemInfo2, ItemList1, Fusion_Temp#ets_item_fusion_template.fusion_num, 
						Fusion_Temp#ets_item_fusion_template.fusion_item_template_id, ?FUSION_COPPER}
				end
			end
		end
	end.

check_enchase1([ItemInfo]) ->
	if ItemInfo#ets_users_items.enchase1 > 0 orelse ItemInfo#ets_users_items.enchase2 > 0 orelse ItemInfo#ets_users_items.enchase3 > 0 orelse
		ItemInfo#ets_users_items.enchase4 > 0 orelse ItemInfo#ets_users_items.enchase5 > 0 orelse 
		ItemInfo#ets_users_items.enchase6 > 0 ->
		false;
	true ->
		ItemInfo
	end.



%% 装备熔炼
equip_funsion(State, ItemInfo1, ItemInfo2, ItemList1, Amount, NewItem_id) ->
%% 	CreaTemp = data_agent:item_template_get(NewItem_id),
%% 	{NewState, NewItemList, _Amount} = add_item_amount_summation(CreaTemp, 1 , State, [], ?BIND, ?CANSUMMATION),
%% 	[NewItemInfo|_] = NewItemList, 
	NewItemInfo = ItemInfo1#ets_users_items{is_bind = ?BIND, template_id = NewItem_id},
	%% 取2件装备强化等级高的那个值
	if ItemInfo1#ets_users_items.strengthen_level > ItemInfo2#ets_users_items.strengthen_level ->
		Str_Level = ItemInfo1#ets_users_items.strengthen_level;
	true ->
		Str_Level = ItemInfo2#ets_users_items.strengthen_level
	end,
	NewItemInfo2 = transform_strengthen_level_open_enchase(Str_Level, NewItemInfo#ets_users_items{strengthen_level = Str_Level, fail_acount = 0}),
	%% 使用主装备的鉴定属性
%% 	RebuildList = ItemInfo1#ets_users_items.other_data#item_other.prop_list,
%% 	io:format("Format rebuildlist ~p~n", [{RebuildList}]),
%% 	TempItemInfo = 
%% 	if length(RebuildList) > 0  ->
%% 		NewRebuildList = item_rebuildList_to_propList(RebuildList,[]),
%% 		Data = tool:intlist_to_string_1(NewRebuildList),
%% 		NewOtherData = NewItemInfo2#ets_users_items.other_data#item_other{prop_list = NewRebuildList,rebuild_list = []},
%% 		NewItemInfo2#ets_users_items{other_data = NewOtherData, data = Data};
%% 	true ->
%% 		NewItemInfo2
%% 	end,
	NewItemInfo3 = item_util:update_item_to_bag(NewItemInfo2),
	IsUpdate =
	if (ItemInfo1#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso ItemInfo1#ets_users_items.place < ?BAG_BEGIN_CELL) orelse
		 (ItemInfo2#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON andalso ItemInfo2#ets_users_items.place < ?BAG_BEGIN_CELL) ->
		1;
	true ->
		0
	end,
	{true, NewState2, DelList2} = reduce_item_to_info(ItemInfo2, State, ?CONSUME_ITEM_FUSION),
	[NewState3, NewInfo, DelList3, _] = use_item(ItemList1, Amount, NewState2, [], []),
	{NewState3, 1, [NewItemInfo3|NewInfo], DelList2 ++ DelList3, IsUpdate}.

								  			
%%------------------------------天工炉洗练处理-------------------------------------
item_rebuild_1(State, ItemInfo, BindFlag, ItemTemp, ItemList, DeleteList, LockList) ->
	{PropValueList, PropNum, RebuildPropTemp, TotalRate} = item_rebuild_4(ItemTemp, erlang:length(LockList)), %% 返回基础信息并随机出属性条数
	%%io:format("LockList ~p~n",[[PropValueList, PropNum, RebuildPropTemp, TotalRate]]),		
	item_rebuild_2(State, ItemInfo, BindFlag, ItemList, DeleteList, PropNum, PropValueList, RebuildPropTemp, TotalRate, LockList).

item_rebuildList_to_propList([],NewList, _State) ->
	NewList;
item_rebuildList_to_propList([{Index, Type, Value, _State}|List], NewList, State) ->
	item_rebuildList_to_propList(List, [{Index, Type, Value, State}|NewList], State).

item_rebuild_2(State, ItemInfo, BindFlag, ItemList, DeleteList, PropNum, PropValueList, RebuildPropTemp, TotalRate, LockList) ->
	LockNum = erlang:length(LockList),
	if LockNum > 0 ->
		{LockPorpList2, DateList3, RealLockNum} = item_rebuild_7(ItemInfo#ets_users_items.other_data#item_other.prop_list,LockList);
		%%LockPorpList2 = tool:reversion(LockPorpList1);		
	true ->	
		LockPorpList2 = item_rebuildList_to_propList(ItemInfo#ets_users_items.other_data#item_other.prop_list, [], 0),
		RealLockNum = 0,
		DateList3 = []
	end,
	{DateList2} = item_rebuild_5(PropNum, PropValueList, [], RebuildPropTemp, TotalRate,RealLockNum),

	%%判断是否第一次洗炼，如果是则直接替换
	{LockPorpList, DateList4} = check_first_rebuild(LockPorpList2 ,lists:append(DateList3, DateList2)),

	NewOtherData = ItemInfo#ets_users_items.other_data#item_other{rebuild_list = DateList4, prop_list = LockPorpList},
	
	LastDatalist = lists:append(LockPorpList,DateList4),

	%%添加洗练记录
	%%lib_statistics:add_rebuild_log(DateList1, ItemInfo#ets_users_items.template_id),
	%%列表数据转化为字符串保存
	StrDataList = tool:intlist_to_string_1(LastDatalist),
	%%io:format("Lock rebuild Info: ~p~n",[StrDataList]),
	NewItemInfo1 = ItemInfo#ets_users_items{other_data = NewOtherData, data = StrDataList},
	NewItemInfo2 = item_util:update_item_to_bag(NewItemInfo1),
	if
		NewItemInfo2#ets_users_items.is_bind =/= ?BIND_TYPE_1 andalso BindFlag ->
			NewItemInfo = lib_item:change_item_isbind(NewItemInfo2, ?BIND_TYPE_1);
		true ->
			NewItemInfo = NewItemInfo2
	end,
	{State, 1, NewItemInfo,ItemList,DeleteList }.

check_first_rebuild(PropList, RebuildList) ->
	if length(PropList) =:= 0 ->
		NewPropList = item_rebuildList_to_propList(RebuildList,[]),
		{NewPropList, PropList};
	true ->
		{PropList, RebuildList}
	end.

%% 返回基础信息并随机出属性条数
item_rebuild_4(ItemTemp, LockNum) ->
	PropValueList = ItemTemp#ets_item_template.other_data#other_item_template.prop_value_list,
	TotalRate = ItemTemp#ets_item_template.other_data#other_item_template.max_rate,
	F = fun(LNum, MaxNum, Num) ->
			if LNum >= MaxNum ->
				0;
			LNum >= Num ->
				1;
			true ->
				Num - LNum
			end
		end,	
	%%io:format("item quality :~p ,LockNum:~p~n",[ItemTemp#ets_item_template.quality, LockNum]),
	case ItemTemp#ets_item_template.quality of
		1 ->
			RandRate = util:rand(1, 100), 
			if
				RandRate > 0 andalso RandRate =< 40 ->
					PropNum = 1;
				RandRate > 40 andalso RandRate =< 65 -> 
					PropNum = 2;
				RandRate > 65 andalso RandRate =< 90 -> 
					PropNum = 3;
				true ->
					PropNum = 4
			end,		
			PropNum1 = F(LockNum,4,PropNum);
		2 ->
			RandRate = util:rand(1, 90), 
			if
				RandRate > 0 andalso RandRate =< 30 ->
					PropNum = 1;
				RandRate > 30 andalso RandRate =< 60 -> 
					PropNum = 2;
				RandRate > 60 andalso RandRate =< 80 -> 
					PropNum = 3;
				%RandRate > 80 andalso RandRate =< 90 -> 
				%	PropNum = 4;
				true ->
					PropNum = 4
			end,
			PropNum1 = F(LockNum,5,PropNum);
		3 ->%% 最多5条
			RandRate = util:rand(1, 100), 
			if
				RandRate > 0 andalso RandRate =< 40 ->
					PropNum = 2;
				RandRate > 40 andalso RandRate =< 70 -> 
					PropNum = 3;
				RandRate > 70 andalso RandRate =< 90 -> 
					PropNum = 4;
				true ->
					PropNum = 5
			end,
			PropNum1 = F(LockNum,5,PropNum);		
		4 ->%% 最多6条
			RandRate = util:rand(1, 100), 
			if
				RandRate > 0 andalso RandRate =< 35 ->
					PropNum = 2;
				RandRate > 35 andalso RandRate =< 65 -> 
					PropNum = 3;
				RandRate > 65 andalso RandRate =< 85 -> 
					PropNum = 4;
				RandRate > 85 andalso RandRate =< 95 -> 
					PropNum = 5;
				true ->
					PropNum = 6
			end,
			PropNum1 = F(LockNum,6,PropNum);
		5 ->%% 最多6条
			RandRate = util:rand(1, 100), 
			if
				RandRate > 0 andalso RandRate =< 40 ->
					PropNum = 3;
				RandRate > 40 andalso RandRate =< 70 -> 
					PropNum = 4;
				RandRate > 70 andalso RandRate =< 90 -> 
					PropNum = 5;
				true ->
					PropNum = 6
			end,
			PropNum1 = F(LockNum,6,PropNum);
		_ ->
			PropNum = 0,
			PropNum1 = 0
	end,
	%%?DEBUG("item_rebuild_prop_template_get PropNum:~p", [PropNum1]),
	RebuildPropTemp = data_agent:item_rebuild_prop_template_get({ItemTemp#ets_item_template.quality,
																 PropNum1 + LockNum}),
	{PropValueList, PropNum1, RebuildPropTemp, TotalRate}.

%% 根据随机值返回随机出来的属性
item_rebuild_6([], _Random, ValueList) ->
	ValueList;
item_rebuild_6([{Type, Value, Rate} | List], Random,  ValueList) ->
	if
		Random =< Rate ->
			item_rebuild_6([], Random, [{Type, Value, Rate}]);
		true ->
			item_rebuild_6(List, Random, ValueList)
	end.

%% 返回随机属性列表
item_rebuild_5(0, _PropValueList, DataList, _RebuildPropTemp, _TotalRate, _Index) ->
	{DataList};
item_rebuild_5(PropNum, PropValueList, DateList, RebuildPropTemp, TotalRate, Index) ->
	Random = util:rand(1, TotalRate),
	[{Type, AllValue, _Rate}] =  item_rebuild_6(PropValueList, Random, []),
	if
		AllValue =< 1 ->
			NewValue = 1;
		AllValue < 9 ->
			NewValue = util:rand(1, AllValue);
		
		true ->
			RandRate = util:rand(1, 100),
			SetionValue = AllValue/9,	
			%%SetionValue = tool:ceil(SetionValue1),
			%%?DEBUG("RebuildPropTemp info:~p",[RebuildPropTemp]),
			Setion1 = RebuildPropTemp#ets_rebuild_prop_template.section1,
			Setion2 = Setion1 + RebuildPropTemp#ets_rebuild_prop_template.section2,
			Setion3 = Setion2 + RebuildPropTemp#ets_rebuild_prop_template.section3,   
			Setion4 = Setion3 + RebuildPropTemp#ets_rebuild_prop_template.section4,
			Setion5 = Setion4 + RebuildPropTemp#ets_rebuild_prop_template.section5,
			Setion6 = Setion5 + RebuildPropTemp#ets_rebuild_prop_template.section6,
			Setion7 = Setion6 + RebuildPropTemp#ets_rebuild_prop_template.section7,
		    Setion8 = Setion7 + RebuildPropTemp#ets_rebuild_prop_template.section8,
			 
			if
				RandRate > 0  andalso RandRate =<  Setion1 ->
					NewValue = 	tool:ceil(SetionValue);
				RandRate > Setion1 andalso RandRate =< Setion2 ->
					NewValue = 	tool:ceil(SetionValue * 2);
				RandRate > Setion2 andalso RandRate =< Setion3 ->
					NewValue = 	tool:ceil(SetionValue * 3);
				RandRate > Setion3 andalso RandRate =< Setion4 ->
					NewValue = 	tool:ceil(SetionValue * 4);
				RandRate > Setion4 andalso RandRate =< Setion5 ->
					NewValue = 	tool:ceil(SetionValue * 5);
				RandRate > Setion5 andalso RandRate =< Setion6 ->
					NewValue = 	tool:ceil(SetionValue * 6);
				RandRate > Setion6 andalso RandRate =< Setion7 ->
					NewValue = 	tool:ceil(SetionValue * 7);
				RandRate > Setion7 andalso RandRate =< Setion8 ->
					NewValue = 	tool:ceil(SetionValue * 8);
				
				true ->
					NewValue = 	tool:ceil(SetionValue * 9)
			end
	end,
	if
		NewValue > AllValue ->
			NewValue1 = AllValue;
		true ->
			NewValue1 = NewValue
	end,
	
	item_rebuild_5(PropNum - 1, PropValueList, [{Index, Type, NewValue1, 2} | DateList], RebuildPropTemp, TotalRate, Index + 1). 
	
item_rebuild_7(PropList, LockList) ->
	PropNum = erlang:length(PropList),
	%%io:format("List info:~p~n",[[PropList, LockList]]),
	F1 = fun(Index, L) ->
			if Index >= 0 andalso  Index < PropNum ->
				L ++ [Index];
			true ->
				L
			end
		end,
	NewLockList = lists:foldl(F1, [], LockList),
	F = fun(LockIndex, {PorpList1, Index}) ->
			Prop = indexfind(PropList,LockIndex),
			if Prop =:= [] ->
				{PorpList1, Index};
			true ->
				{Type,Value,State} = Prop,
				{[{Index,Type,Value,State}|PorpList1],Index + 1}
			end
		end,
	
	{List, LockNum} = lists:foldl(F, {[],0}, NewLockList),
	NewPorpList = change_prop_lock_state(PropList, NewLockList, []), 	
	{NewPorpList,List,LockNum}.

change_prop_lock_state([],_LockList, PorpList) ->
	PorpList;
change_prop_lock_state([{Index,Type,Value,_State}|L],LockList,PorpList) ->
	case lists:filter(fun(T) -> Index =:= T end, LockList) of
		[] ->
			NewPorpList = lists:append(PorpList, [{Index,Type,Value,0}]);
		[_] ->
			NewPorpList = lists:append(PorpList, [{Index,Type,Value,1}])
	end,
	change_prop_lock_state(L,LockList, NewPorpList).

		
indexfind([],_Index) ->
	[];
indexfind([{Id,Type,Value,_State}|L], Index) ->
	if
		Id =:= Index ->
			{Type,Value,3};
		true ->
			indexfind(L, Index)
	end.
%%------------------------------------------------------------------------------------------------


%% PK红名死亡掉落物品
item_drop_by_pk_death(ItemState, UserId) ->
	CommonList = item_util:get_bag_list(UserId),
	case lists:filter(fun(Info) ->Info#ets_users_items.is_bind =/= ?BIND end, CommonList) of
		[] ->
			%%搜索身上装备
			EquipList = item_util:get_equip_list(UserId),
			case lists:filter(fun(Equip) ->Equip#ets_users_items.is_bind =/= ?BIND end, EquipList) of
				[] ->
					{error};
				EquipList1 ->
					Random = util:rand(1, erlang:length(EquipList1)),
					EquipInfo = lists:nth(Random, EquipList1),
					[NewItemState, EquipList, DeleteList] = lib_item:change_item_num_in_commonbag(EquipInfo, 
																							   EquipInfo#ets_users_items.place,
																							   EquipInfo#ets_users_items.amount, 
																							   ItemState,
																							   ?CONSUME_ITEM_PK_DROP),	
					{ok, NewItemState, [], EquipList, DeleteList}
			end;
		CommonList1 ->
			Random = util:rand(1, erlang:length(CommonList1)),
			ItemInfo = lists:nth(Random, CommonList1),
			[NewItemState, ItemList, DeleteList] = lib_item:change_item_num_in_commonbag(ItemInfo, 
																							   ItemInfo#ets_users_items.place,
																							   ItemInfo#ets_users_items.amount, 
																							   ItemState,
																							    ?CONSUME_ITEM_PK_DROP),				
			{ok, NewItemState, ItemList, [], DeleteList}
	end.
%% 增加物品物品（addType,写日志时候使用）
add_item(TemplateId, Amount, IsBind, _AddType, State) ->
	case data_agent:item_template_get(TemplateId) of
		Template when is_record(Template,ets_item_template) ->
			Cells1 = Amount/Template#ets_item_template.max_count,
			Cells = tool:ceil(Cells1),
			
			if
				erlang:length(State#item_status.null_cells) < Cells ->
					{fail, false};
				true ->
					{NewState, ItemList, _Amount} = add_item_amount_summation(Template, Amount, State, [], IsBind, ?CANSUMMATION),
					{ok, true, ItemList, NewState}
			end;
		_ ->
			{fail, false}
	end.				
add_item_or_mail(TemplateId, Amount, IsBind, _AddType, State) ->
	case data_agent:item_template_get(TemplateId) of
		Template when is_record(Template,ets_item_template) ->
			Cells1 = Amount/Template#ets_item_template.max_count,
			Cells = tool:ceil(Cells1),
			
			if
				erlang:length(State#item_status.null_cells) < Cells ->
					{fail, false};
				true ->
					{NewState, ItemList, _Amount} = add_item_amount_summation(Template, Amount, State, [], IsBind, ?CANSUMMATION),
					{ok, true, ItemList, NewState}
			end;
		_ ->
			{fail, false}
	end.
%% 拾取掉落物品
pick_up_item(TemplateId, Amount, IsBind, State) ->	
	case data_agent:item_template_get(TemplateId) of
		Template when is_record(Template,ets_item_template) ->
			Cells1 = Amount/Template#ets_item_template.max_count,
			Cells = tool:ceil(Cells1),
			
			if
				erlang:length(State#item_status.null_cells) < Cells ->
					{fail, false};
				true ->
					
					{NewState, ItemList, _Amount} = add_item_amount_summation(Template, Amount, State, [], IsBind, ?CANSUMMATION),
					Reply = true,
		%% 			%%拾取的物品如果是装备类型  则洗练一次
		%% 			case func_item_rebuild_1(Template, ItemList) of
		%% 				{error} ->
		%% 					{ok, Reply, ItemList, NewState};
		%% 				{ok, NewItemList} ->
		%% 					{ok, Reply, NewItemList, NewState}
		%% 			end
					{ok, Reply, ItemList, NewState}
			end;
		_ ->
			{fail, false}
	end.



%-----------------------------------------帮会物品-------------------------
guild_warehouse_put_item(UserID,Place) ->
	case item_util:get_user_item_by_place(UserID,Place) of
		[] ->
			{false,?_LANG_GUILD_ERROR_WAREHOUSE_USER_NO_ITEM};
		[Item] when Item#ets_users_items.is_bind =/= ?BIND ->
			ItemID = Item#ets_users_items.id,
			lib_item:change_item_cell(Item, -2),			%帮会place改-2
			ets:delete(?ETS_USERS_ITEMS, ItemID),
			{ok,ItemID,Place,Item};
		_ ->
			{false,?_LANG_GUILD_ERROR_WAREHOUSE_ITEM_BIND}
	end.

guild_warehouse_get_item(ItemStatus, Item) ->
	if 
		length(ItemStatus#item_status.null_cells) > 0 ->	
			[Cell|NewNullCells] = ItemStatus#item_status.null_cells,
			ItemInfo = Item#ets_users_items{place = Cell,
											bag_type  = ?BAG_TYPE_COMMON,
											user_id = ItemStatus#item_status.user_id},
			NewItemInfo = lib_item:add_item(ItemInfo),
			NewState = ItemStatus#item_status{null_cells = NewNullCells},
			[NewState, [NewItemInfo], 1];
		true ->
			[ItemStatus, [], 0]	
	end.
	
% -----------------------------------------邮件----------------------------
%% 邮件发送物品
mail_send_items(UserId, Attach, State) ->
	F = fun(Place, [Items, Acc, Mark, NullCell]) ->
				case item_util:get_user_item_by_place(UserId, Place) of
					[] ->
						[Items, Acc, Mark, NullCell];
					[Item] when Item#ets_users_items.is_bind =/= ?BIND ->  %% 需要判断能否发送，绑定不能发送	
						ItemId = Item#ets_users_items.id,
						Template = data_agent:item_template_get(Item#ets_users_items.template_id),
						NewItem = change_item_cell(Item, -1),

						delete_item(NewItem, {1,?CONSUME_ITEM_MAIL,State#item_status.user_id,State#item_status.level}),

						Item0 = [Item|Items],
						Acc0 = [ItemId|Acc],
						Mark0 = [tool:to_list(Template#ets_item_template.name)|Mark],
						NewNullCell = [Place|NullCell],
						[Item0, Acc0, Mark0, NewNullCell];
					_ ->
						[Items, Acc, Mark, NullCell]
				end
		end,
	[ItemList,Items, NameList, NullCells] = lists:foldl(F, [[],[],[], []], Attach),
	item_util:save_dic(),
	[ItemList,Items, NameList, NullCells].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%					
mail_item_add(ItemStatus, Item) ->
	if 
		length(ItemStatus#item_status.null_cells) > 0 ->	
			[Cell|NewNullCells] = ItemStatus#item_status.null_cells,
			ItemInfo = Item#ets_users_items{place = Cell,
											bag_type  = ?BAG_TYPE_COMMON,
											user_id = ItemStatus#item_status.user_id,
											is_exist = 1},
			NewItemInfo = lib_item:add_item(ItemInfo),
			NewState = ItemStatus#item_status{null_cells = NewNullCells},
			[NewState, [NewItemInfo], 1];
		true ->
			[ItemStatus, [], 0]	
	end.

%%物品激活到宠物列表
pet_to_list(ItemStatus, ItemId) ->
	case item_util:get_user_item_by_id(ItemStatus#item_status.user_id, ItemId) of
		[] ->
			%%物品不存在
			{error, "pet_to_list item is not"};
		ItemInfo ->
			pet_to_list1(ItemStatus, ItemInfo)
	end.

pet_to_list1(ItemStatus, ItemInfo) ->
	case data_agent:item_template_get(ItemInfo#ets_users_items.template_id) of
		[] ->
			{error, "pet_to_list template is not"};
		Template when Template#ets_item_template.category_id =:= ?CATE_PET -> 
			
	        NewNullCells = lists:sort([ItemInfo#ets_users_items.place|ItemStatus#item_status.null_cells]),
			NewItemStatus = ItemStatus#item_status{null_cells = NewNullCells},
			delete_item(ItemInfo, {0,?CONSUME_ITEM_USE,ItemStatus#item_status.user_id,ItemStatus#item_status.level}),
			DeleteList = [ItemInfo#ets_users_items.place],
			NewItemInfo = [],
	       
 	        {ok, {NewItemStatus,  ItemInfo,Template,DeleteList}};
		_ ->
	        {error, "pet_to_list category is not"}
	end.
		

%%宠物到背包物品,宠物Id即物品Id
pet_to_bag(ItemStatus, PetId) ->
	case item_util:get_user_item_by_id(ItemStatus#item_status.user_id, PetId) of
		[] ->
			%%物品不存在
			{error, "pet_to_bag item is not"};
		ItemInfo when ItemInfo#ets_users_items.bag_type == ?BAG_TYPE_PET ->
			pet_to_bag1(ItemStatus, ItemInfo);
		_ ->
			{error, "pet_to_bag item is not pet bag"}
	end.

pet_to_bag1(ItemStatus, ItemInfo) ->
	if ItemInfo#ets_users_items.enchase1 =:= 1 ->
		   lib_chat:chat_sysmsg([ItemInfo#ets_users_items.user_id,?CHAT,?None,?ORANGE,?_LANG_PET_CALL_BACK_FIRST]);
	   true ->
		   if length(ItemStatus#item_status.null_cells) > 0 ->
				  [Cell|NewCells] = ItemStatus#item_status.null_cells,
		          lib_pet:pet_to_bag(ItemInfo#ets_users_items.id),
		          NewItemInfo = change_item_bagtype(ItemInfo, ?BAG_TYPE_COMMON, Cell, 0),
		          NewItemStatus = ItemStatus#item_status{null_cells=NewCells},
			      {ok, {NewItemStatus, NewItemInfo}};	   
			  true ->
		          {error, "pet_to_bag1 is not cell"}
		   end
	end.
		
%%宠物出战
pet_fight(UserId, PetId) ->
	case lib_pet:get_user_pet_by_id(PetId) of
		[] ->
			{error, "pet_fight pet is not exist"};
%% 		Pet when Pet#ets_users_pets.user_id == UserId ->
%% 			{ok, Pet#ets_users_pets.template_id, Pet#ets_users_pets.nick};
		_ ->
			{error, "pet_fight pet is not exist"}
	end.

%%宠物召回	
pet_call_back(UserId, PetId) ->
	case lib_pet:get_user_pet_by_id(PetId) of
		[] ->
			{error, "pet_call_back is not exist"};
		Pet when Pet#ets_users_pets.user_id == UserId ->
			pet_call_back1(UserId, PetId);
		_ ->
			{error, "pet_call_back pet is not exist"}
	end.

pet_call_back1(UserId, PetId) ->		
	case item_util:get_user_item_by_id(UserId, PetId) of
		[] ->
			%% 物品不存在
			{error, "pet_call_back1 item is not"};
		_ItemInfo ->
			%% enchase1 0 不出战，1出战，enchase1考虑改为property为通用
%% 			ItemInfo#ets_users_items{enchase1 = 0},
			ok
	end.

%% 添加任务奖励
add_task_award(State, TaskAwards) ->
%% 	F = fun(Award, {ItemList, AccState}) ->
%% 				case pick_up_item(Award#ets_task_award_template.template_id, 
%% 								  Award#ets_task_award_template.amount, Award#ets_task_award_template.is_bind, State) of
%% 					{ok, _Reply, NewItemList, NewState} ->
%% 						{lists:append(NewItemList, ItemList), NewState};
%% 					_ ->
%% 						{ItemList, AccState}
%% 				end
%% 		end,
	F = fun(Award, {ItemList, AccState}) ->
				case pick_up_item(Award#ets_task_award_template.template_id, 
								  Award#ets_task_award_template.amount, Award#ets_task_award_template.is_bind, AccState) of
					{ok, _Reply, NewItemList, NewState} ->
						%lib_statistics:add_item_log(Award#ets_task_award_template.template_id, ?ITEM_TASK_AWARD, 
						%							Award#ets_task_award_template.amount),					
						{lists:append(NewItemList, ItemList), NewState};
					_ ->
						{ItemList, AccState}
				end
		end,
	{NewItemList, NewState} = lists:foldl(F, {[], State}, TaskAwards),
	{ok, NewState, NewItemList}.

%% 扣除任务需要物品
task_reduce_item(State, TargetObjects, TargetAmounts, IsBind) ->
	case task_check_items(TargetObjects, TargetAmounts, State#item_status.user_id, IsBind) of
		true ->
			%% 扣除物品
 			task_reduce_items(TargetObjects, TargetAmounts, State, [], []);
		_ ->
			{error, "task item is vaild"}
	end.
task_reduce_items([], _, State, ItemList, DelList) ->
	{ok, State, ItemList, DelList};
task_reduce_items([{TemplateId, _TotalAmount}|TargetObjects], [Amount|TargetAmounts], State, ItemList, DelList) ->
	case reduce_item_to_users(TemplateId, Amount, State,?CONSUME_ITEM_TASK) of
		{true, NewState, NewItemList, NewDelList} ->
			task_reduce_items(TargetObjects, TargetAmounts, NewState, 
							  lists:append(NewItemList, ItemList), lists:append(NewDelList, DelList));
		_ ->
			{ok ,State, ItemList, DelList}
	end.



task_check_items([], _, _UseId, _IsBind) ->
	true;
task_check_items([{TemplateId, _TotalAmount}|TargetObjects], [Amount|TargetAmounts], UserId, IsBind) ->
	case check_item_to_users(TemplateId, Amount, UserId) of
		true ->
			case IsBind =:= undefined of
				true ->
					task_check_items(TargetObjects, TargetAmounts, UserId, IsBind);
				_ ->
					case item_util:get_user_item_by_templateid(UserId, TemplateId) of
	    				[] ->
							false;
						ItemInfo when ItemInfo#ets_users_items.is_bind =:= IsBind ->
							task_check_items(TargetObjects, TargetAmounts, UserId, IsBind);
						_ ->
							false
					end
			end;
		_ ->
			false
	end.

%%根据模板ID判断玩家背包有无此物品
check_item_by_templateid(TemplateId, ItemStatus) ->
	ItemTemplate = data_agent:item_template_get(TemplateId),
	ItemList = item_util:get_item_list(ItemStatus#item_status.user_id, ?BAG_TYPE_COMMON),
	case lists:filter(fun(X)->X#ets_users_items.template_id =:= TemplateId end, ItemList) of
         [] ->
             {error, "it is not exist"};
         NewItemList ->
            %%优先使用绑定的
             case lists:filter(fun(X)->X#ets_users_items.is_bind =:= ?BIND end, NewItemList) of
				 [] ->
					 [ItemInfo|_] = NewItemList,
					 {ok, ItemInfo, ItemTemplate, ItemStatus};
				
				 NewBindItemList ->
					 [ItemInfo|_] = NewBindItemList,
					 {ok, ItemInfo, ItemTemplate, ItemStatus}			
			 end
	end.

%%减少当前装备的物品的耐久
reduce_equip_durable(ItemStatus, Percent) ->					
	EquipList = item_util:get_equip_list(ItemStatus#item_status.user_id),
	if
		erlang:length(EquipList) > 0 ->
			[_, NewItemLIst] = lists:foldl(fun func_reduce_equip_durable/2, [Percent, []], EquipList),
			{ok, NewItemLIst, ItemStatus};
		true ->
			{error}
	end.

func_reduce_equip_durable(EquipInfo, [Perc, NewEquipList]) ->
	EquipTemplate = data_agent:item_template_get(EquipInfo#ets_users_items.template_id),
	ReduceDurable1 = EquipTemplate#ets_item_template.durable_upper * Perc,
	ReduceDurable  = tool:ceil(ReduceDurable1),
	EquipDurable = EquipInfo#ets_users_items.durable,
	NewEquipDurable =  EquipDurable - ReduceDurable,
	if 
		ReduceDurable =:= 0 ->
			[Perc, NewEquipList];
		
		true ->
			if
				NewEquipDurable >= 0 ->
					NewEquipInfo = lib_item:change_item_durable(EquipInfo, NewEquipDurable),
					[Perc, lists:append(NewEquipList, NewEquipInfo)];
				true ->
					NewEquipInfo = lib_item:change_item_durable(EquipInfo, 0),
					[Perc, lists:append(NewEquipList, NewEquipInfo)]
			end
	end.

%%获取武器的category_id
get_weapon_categoryid(ItemStatus, EquipPlace) ->
	EquipList = item_util:get_equip_list(ItemStatus#item_status.user_id),
	case lists:filter(fun(X)->X#ets_users_items.place =:= EquipPlace end, EquipList) of
		[] ->
			{0};
		[EquipInfo] ->
			EquipTemplate = data_agent:item_template_get(EquipInfo#ets_users_items.template_id),
			{EquipTemplate#ets_item_template.category_id}
	end.

%%神魔令刷新
shenmo_refresh_state(ShenmoItemId, LingLongItemId, ItemStatus) ->
	case item_util:get_user_item_by_id(ItemStatus#item_status.user_id, ShenmoItemId) of
		[] ->
			{error, "error: the item is no DMOGORGON"};
		ShenmoItem ->
			case ShenmoItem#ets_users_items.enchase2 =/= ?DMOGORGON_MAX_STATE of
				true ->
					shenmo_refresh_state1(ShenmoItem, LingLongItemId, ItemStatus);
				_ ->
					{error, "error: the state of task is max"}
			end
	end.

shenmo_refresh_state1(ShenmoItem, LingLongItemId, ItemStatus) ->
	case item_util:get_user_item_by_id(ItemStatus#item_status.user_id, LingLongItemId) of
		[] ->
			{error, "error: the item is not LENGGONG_STONE"};
		LinglongItem ->
			case data_agent:item_template_get(LinglongItem#ets_users_items.template_id) of
				[] ->
					{error, "error: can not find ItemTemp for LENGGONG_STONE"};
				ItemTemp when ItemTemp#ets_item_template.category_id =:= ?CATE_LENGGONG_STONE ->
					shenmo_refresh_state2(ShenmoItem, ItemTemp#ets_item_template.template_id, ItemStatus)
			end
	end.

shenmo_refresh_state2(ShenmoItem, ItemTempId, ItemStatus) ->
	case check_item_to_users(ItemTempId, 1, ItemStatus#item_status.user_id) of
		true ->
			TaskState = util:rand(0, ?DMOGORGON_MAX_STATE),
			NewItem = ShenmoItem#ets_users_items{enchase2=TaskState},
			{true, NewItemStatus, ItemList, DelList} = reduce_item_to_users(ItemTempId, 1, ItemStatus,?CONSUME_ITEM_USE),
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			{ok, NewItem};
		_ ->
			lib_chat:chat_sysmsg_pid([ItemStatus#item_status.pid, ?FLOAT, ?None, ?ORANGE, ?_LANG_TASK_SHENMO_REFRESH_EXIST]),
			{error, "error: no LingLing Stone"}
	end.

%% 购买优惠商品检测
check_discount_buy(YuanBao, BindYuanBao, Copper, BindCopper, ShopItemID, Amount, BoughtItems, State) -> 
	case mod_shop:get_shop_item_by_id(ShopItemID) of
		[] ->
			{error, "error: no ShopItem"};
		ShopItem when is_record(ShopItem, ets_shop_discount_template)->
			check_discount_buy1(YuanBao, BindYuanBao, Copper, BindCopper, Amount, BoughtItems, State, ShopItem);
		_ ->
			{error, "error: not ShopItem Template"}
	end.

check_discount_buy1(YuanBao, BindYuanBao, Copper, BindCopper, Amount, BoughtItems, State, ShopItem) ->
	LimitCount = ShopItem#ets_shop_discount_template.limit_count,
	case lists:keyfind(ShopItem#ets_shop_discount_template.id, #discount_items.item_id, BoughtItems) of
		false ->
			case Amount =< LimitCount orelse LimitCount == 0 of
				true ->
					check_discount_buy2(YuanBao, BindYuanBao, Copper, BindCopper, Amount, State, ShopItem,LimitCount-Amount);
				_ ->
%% 					{error, "error: the count for bought items is out"}
					{false, ?GET_TRAN(?_LANG_SHOP_LIMIT, [LimitCount])}
			end;
		OldItem ->
			case (OldItem#discount_items.item_count + Amount =< LimitCount) orelse LimitCount == 0 of
				true ->
					check_discount_buy2(YuanBao, BindYuanBao, Copper, BindCopper, Amount, State, ShopItem,LimitCount - (OldItem#discount_items.item_count + Amount));
				_ ->
%% 					{error, "error: the total count for bought items is out"}
					{false, ?GET_TRAN(?_LANG_SHOP_LIMIT, [LimitCount])}
			end
	end.

check_discount_buy2(YuanBao, BindYuanBao, Copper, BindCopper, Amount, State, ShopItem,LimitCount) ->
	case Amount > 0 andalso Amount =< ShopItem#ets_shop_discount_template.other_data#other_discount.left_count of
		true ->
			check_discount_buy3(YuanBao, BindYuanBao, Copper, BindCopper, Amount, State, ShopItem,LimitCount);
		_ ->
%% 			{error, "error: the Amount of items you buy is out"}
			{false, ?GET_TRAN(?_LANG_SHOP_LIMIT, [ShopItem#ets_shop_discount_template.limit_count])}
	end.

check_discount_buy3(YuanBao, BindYuanBao, Copper, BindCopper, Amount, State, ShopItem,LimitCount) ->
	case data_agent:item_template_get(ShopItem#ets_shop_discount_template.template_id) of
		[] ->
			{error, "error: the Item is not exist"};
		ItemTemplate ->
			NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
			if NeedCellNum > erlang:length(State#item_status.null_cells )->
					{error, "error: not enough space in bag"};
				true ->
					case check_discount_pay_type(Amount, YuanBao, BindYuanBao, Copper, BindCopper, ShopItem) of
						{error, Reason} ->
							{error, Reason};
						{ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao} ->
							case ShopItem#ets_shop_discount_template.other_data#other_discount.cheap_type =:= 1 
								orelse ShopItem#ets_shop_discount_template.other_data#other_discount.cheap_type =:= 2 of
								true ->
									LeftCount = ShopItem#ets_shop_discount_template.other_data#other_discount.left_count - Amount,
									ElemOther = ShopItem#ets_shop_discount_template.other_data#other_discount{left_count=LeftCount},
									mod_shop:update_shop_item(ShopItem#ets_shop_discount_template{other_data=ElemOther}),
									NewAmount = LeftCount;
								_ ->
									NewAmount = 0
							end,
							{ok, ItemTemplate, ShopItem, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, NewAmount,LimitCount}	
					end
			end
	end.


check_discount_pay_type(Amount, YuanBao, BindYuanBao, Copper, BindCopper, ShopItem) ->
	ReduceValue = ShopItem#ets_shop_discount_template.price * Amount,
	if				
		ShopItem#ets_shop_discount_template.pay_type =:= 0 
		  andalso (Copper + BindCopper) >=  ReduceValue ->
			{ReduceValue, 0, 0, 0};		
		ShopItem#ets_shop_discount_template.pay_type =:= 1 
		  andalso YuanBao  >= ReduceValue ->
			{0, 0, 0, ReduceValue};
		ShopItem#ets_shop_discount_template.pay_type =:= 2
		  andalso BindYuanBao >= ReduceValue ->
			{0, 0, ReduceValue, 0};	
		ShopItem#ets_shop_discount_template.pay_type =:= 3 
		  andalso Copper >= ReduceValue ->
			{0, ReduceValue, 0, 0};
		true ->
			{error, "error: pay_type is error"}
	end.


%% 购买公会商品检测
check_guild_shop_buy(GuildId,  ShopItemID, Amount, BoughtItems, State) ->
	case data_agent:shop_template_get(ShopItemID) of
		ShopTemplate when is_record(ShopTemplate, ets_shop_template) ->
			case data_agent:item_template_get(ShopTemplate#ets_shop_template.template_id) of
				[] ->
					{false,?_LANG_GUILD_SHOP_ITEM_NOT_EXIST};
				ItemTemplate ->
					check_guild_shop_buy1(GuildId,ItemTemplate,ShopTemplate,Amount,BoughtItems,State)
			end;
		_ ->
			{false,?_LANG_GUILD_SHOP_ITEM_NOT_EXIST}
	end.


check_guild_shop_buy1(GuildId,ItemTemplate,ShopTemplate,Amount,BoughtItems,State) ->
	NeedCellNum = util:ceil(Amount/ItemTemplate#ets_item_template.max_count),
	if
		NeedCellNum > erlang:length(State#item_status.null_cells )->
			{false,?_LANG_GUILD_SHOP_BAG_ERROR};
		true ->
			case mod_guild:get_guild_user_info(GuildId,State#item_status.user_id) of
				[] ->
					{false,?_LANG_GUILD_SHOP_GUILD_NOT_EXIST};
				MemberInfo ->
					check_guild_shop_buy2(MemberInfo,ItemTemplate,ShopTemplate,Amount,BoughtItems)
			end
	end.

check_guild_shop_buy2(MemberInfo,ItemTemplate,ShopTemplate,Amount,BoughtItems) ->
	case check_pay_type(Amount,0 ,0 , 0, 0, ShopTemplate) of
		{guild_feats, Feats} -> %% 少了　ShopTemplate#ets_shop_template.category_id　的决断
			if
				MemberInfo#ets_users_guilds.current_feats >= Feats ->
					check_guild_shop_buy3(ItemTemplate,ShopTemplate,Amount,BoughtItems,Feats);
				true ->
					{false,?_LANG_GUILD_SHOP_FEATS_NOT}
			end
	end.

check_guild_shop_buy3(ItemTemplate,ShopTemplate,Amount,BoughtItems,Feats) ->
	LimitCount = ShopTemplate#ets_shop_template.sale_num,
	Now = misc_timer:now_seconds(),
	{Today, _NextDay} = util:get_midnight_seconds(Now),
	case lists:keyfind(ShopTemplate#ets_shop_template.id, #discount_items.item_id, BoughtItems) of
		false ->
			case Amount =< LimitCount orelse LimitCount == 0  of
				true ->
					{ok, ItemTemplate, ShopTemplate#ets_shop_template.is_bind, Feats,Today};
				_ ->
					{false,?_LANG_GUILD_SHOP_TIMES_OUT}
			end;
		OldItem ->
			CheckCount = if
							 OldItem#discount_items.finish_time < Today ->
								 Amount;
							 true ->
								 OldItem#discount_items.item_count + Amount
						 end,
			case (CheckCount =< LimitCount) orelse LimitCount == 0 of
				true ->
					{ok, ItemTemplate, ShopTemplate#ets_shop_template.is_bind, Feats,Today};
				_ ->
					{false,?_LANG_GUILD_SHOP_TIMES_OUT}
			end
	end.


%%开箱子
open_box_in_yuanbao(YuanBao, Career, Box_Type, NickName, State) ->
	case Box_Type of
		1 ->
			case item_util:get_user_item_by_templateid(0,?TONGBAO) of
				[] ->
					NeedYuanBao = 5;
				Item when(Item#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON) ->
					NeedYuanBao = 0;
				_ ->
					NeedYuanBao = 5
			end;
			
		2 ->
			NeedYuanBao = 45;
		3 ->
			NeedYuanBao = 225;
		4 ->
			case item_util:get_user_item_by_templateid(0,?YINBAO) of
				[] ->
					NeedYuanBao = 10;
				Item when(Item#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON) ->
					NeedYuanBao = 0;
				_ ->
					NeedYuanBao = 10
			end;
		5 ->
			NeedYuanBao = 95;
		6 ->
			NeedYuanBao = 450;
		7 ->
			NeedYuanBao = 20;
		8 ->
			NeedYuanBao = 190;
		9 ->
			NeedYuanBao = 900;
		_ ->
			NeedYuanBao = -1
	end,
	if
		NeedYuanBao =:= -1  ->
			error;
		YuanBao <  NeedYuanBao ->
			error;	
		erlang:length(State#item_status.maxboxnull) < 60 ->
			error;
		true ->
			open_box_in_yuanbao_1(State#item_status.user_id, Box_Type, Career, State, NeedYuanBao, NickName)
	end.
			
open_box_in_yuanbao_1(UserId,Box_Type, Career, State, NeedYuanBao, NickName) ->
	if
		Box_Type =< 3 ->
			Type = 1;
		Box_Type =< 6 ->
			Type = 2;
		true ->
			Type = 3
	end,
	case data_agent:item_box_template_get({Type, Career}) of
		[] ->
			error;
		List ->
			NewList = List#ets_box_data.data,
			open_box_in_yuanbao_2(UserId,NewList, Box_Type, Type, NeedYuanBao, NickName, State)
	end.

open_box_in_yuanbao_2(UserId,List, Box_Type, Type, NeedYuanBao, NickName, State) ->
	Type1 = lists:member(Box_Type, [1,4,7]),
	Type2 = lists:member(Box_Type, [2,5,8]),
	Type3 = lists:member(Box_Type, [3,6,9]),
	if
		Type1 =:= true ->
			Times = 1;
		Type2 =:= true ->
			Times = 10;
		Type3 =:= true ->
			Times = 50;
		true ->
			Times = 0
	end,
	
	{true, NewItemStatus, ItemList, DelList} = if
												   NeedYuanBao =:= 0 ->
													   case Box_Type of
														   1 ->
															   lib_item:reduce_item_to_users(?TONGBAO, 1, State,?CONSUME_ITEM_USE);
														   4 ->
															   lib_item:reduce_item_to_users(?YINBAO, 1, State,?CONSUME_ITEM_USE);
														   _ ->
															   {true, State, [], []}
													   end;
												   true ->
													   {true, State, [], []}
											   end,
	Bind = NeedYuanBao =:= 0,
	
	case open_box_in_yuanbao_5(Times, [], List, Bind) of
		[] ->
			error;
		OpenBoxList ->
			F1 = fun({Template_Id, Amount, Streng_Level, IsBind, Modulus}, BoxList) ->
						 case lists:keyfind(Template_Id, 1, BoxList) of
							 false ->
								 [{Template_Id, Amount, Streng_Level, IsBind, Modulus}|BoxList];
							 Old ->
								 {_,Amount1,_,_,_} = Old,
								 BoxList1 = lists:keydelete(Template_Id, 1, BoxList),
								 [{Template_Id, Amount+Amount1, Streng_Level, IsBind, Modulus}|BoxList1]
						 end
				 end,
			NewOpenBoxList = lists:foldl(F1, [], OpenBoxList),
			
			F2 = fun(Info, [Count, Type_Lv, Now]) ->
						 {Template_Id, Amount, _, _, _} = Info,
						 lib_statistics:add_magic_log(UserId,Count, Type_Lv, Template_Id, Amount, Now),
						 [0, Type_Lv, Now]
				 end,
			lists:foldl(F2, [Times, Type, misc_timer:now_seconds()], NewOpenBoxList),
			
			%%发送至全局的箱子数据
			case open_box_in_yuanbao_8(NewOpenBoxList) of
				[] ->
					[];
				TemplateId ->
					gen_server:cast(mod_box_agent:get_open_box_pid(), {'update_box_data', {NickName, Type, TemplateId}})
			end,
					
			ToCDate = open_box_in_yuanbao_6(NewOpenBoxList, [[], NewItemStatus#item_status.user_id]),
																							
			F = fun({Template_Id, Amount, Streng_Level, IsBind, _Modulus}, [Status, ItemList]) ->
						case data_agent:item_template_get(Template_Id) of
							Template when is_record(Template, ets_item_template) ->								
								{NewStatus, ItemInfoList, _} = lib_item:add_item_in_box(Template, Amount, IsBind, Streng_Level, [], Status),							  												
								[NewStatus, lists:append(ItemInfoList, ItemList)];
							_ ->
								[Status, ItemList]
						end
				end,
			[NewState, NewItemList] = lists:foldl(F, [NewItemStatus, []], NewOpenBoxList),
				
			{ok, NewState, NewItemList, NeedYuanBao, ToCDate,ItemList, DelList}
	end.
	

open_box_in_yuanbao_4([], _Random, BoxItem, _Bind) ->
	BoxItem;
open_box_in_yuanbao_4([{Rate, Template_Id, Amount, Streng_Level, Is_Bind, Modulus} | BoxItemList], Random, BoxItem, Bind) ->	
	if
		Random =< Rate ->
			if	Bind =:= true ->
					IsBind = ?BIND;
				true -> 
					IsBind = Is_Bind
			end,
			open_box_in_yuanbao_4([], Random, [{Template_Id, Amount, Streng_Level, IsBind, Modulus}],Bind);
		true ->
			open_box_in_yuanbao_4(BoxItemList, Random, BoxItem,Bind )
	end.
	
open_box_in_yuanbao_5(0, OpenBoxList, _List, _Bind) ->
	OpenBoxList;
open_box_in_yuanbao_5(Times, OpenBoxList, List, Bind) ->
%%	NewList = open_box_in_yuanbao_3(List, [[], 0]),
	Random = util:rand(1, 10000),
	NewItem = open_box_in_yuanbao_4(List, Random, [], Bind),
	open_box_in_yuanbao_5(Times-1, lists:append(OpenBoxList, NewItem), List, Bind).


%%生成临时数据给客户端显示
open_box_in_yuanbao_7(_Template, 0, _Streng_Level, _IsBind, _UserId, List) ->
	List;
open_box_in_yuanbao_7(Template, Amount, Streng_Level, IsBind, UserId, List) ->
	if
		Amount > Template#ets_item_template.max_count ->
			Info = item_util:create_new_item(Template, Template#ets_item_template.max_count, 0, UserId, IsBind, Streng_Level, ?BAG_TYPE_BOX),
			open_box_in_yuanbao_7(Template, Amount-Template#ets_item_template.max_count, Streng_Level, IsBind, UserId, [Info|List]);
		true ->
			Info = item_util:create_new_item(Template, Amount, 0, UserId, IsBind, Streng_Level, ?BAG_TYPE_BOX),
			open_box_in_yuanbao_7(Template, 0, Streng_Level, IsBind, UserId, [Info|List])
	end.


open_box_in_yuanbao_6([], [ItemList, _UserId]) ->
	ItemList;
open_box_in_yuanbao_6([{Template_Id, Amount, Streng_Level, IsBind, _Modulus} | OpenBoxList], [ItemList, UserId]) ->
	case data_agent:item_template_get(Template_Id) of
		Template when is_record(Template, ets_item_template) ->
			List = open_box_in_yuanbao_7(Template, Amount, Streng_Level, IsBind, UserId, []),
			open_box_in_yuanbao_6(OpenBoxList, [lists:append(ItemList, List), UserId]);
		_ ->
			open_box_in_yuanbao_6(OpenBoxList, [ItemList, UserId])
	end.
		

%%开箱子开出珍贵物品给予系统提示
open_box_in_yuanbao_8(OpenBoxList) ->
	case lists:sort(fun({_,_,_,_,Modulus1},{_,_,_,_,Modulus2})->Modulus1>Modulus2 end, OpenBoxList) of
		[] ->
			[];
		List ->
			BestItem = lists:nth(1, List),
			{Template_Id,_,_,_,Modulus} = BestItem,
			if
				Modulus > 0 ->
					Template_Id;
				true ->
					[]
			end
	end.
					
			
		

%%移动箱子物品到背包
move_boxitem_to_bag(Type, ItemId, State) ->
	if
		Type =:= 1 ->
			case item_util:get_user_item_by_id(State#item_status.user_id, ItemId) of
				[] ->
					{error, 1};
				Info ->
					if
						erlang:length(State#item_status.null_cells) < 1 ->
							{error, 1};
						Info#ets_users_items.bag_type =/= ?BAG_TYPE_BOX ->
							{error, 1};
						true ->
							[ItemList, NewState] = move_boxitem_to_bag_1(Info, [[], State]),
							{ok, 1, ItemList, NewState}	
					end
			end;
		
		Type =:= 2 ->
			case item_util:get_item_list(State#item_status.user_id, ?BAG_TYPE_BOX) of
				[] ->
					{error, 2};
				BoxItemList ->
					if
						erlang:length(State#item_status.null_cells) < erlang:length(BoxItemList) ->
							{error, 2};
						true ->
							[ItemList, NewState] = lists:foldl(fun move_boxitem_to_bag_1/2, [[], State], BoxItemList),
							{ok, 2, ItemList, NewState}
					end
			end;
		
		true ->
			error
	end.
												
move_boxitem_to_bag_1(Info, [List, State]) ->
	[BagCell|NewBagNulls] = State#item_status.null_cells,
	BoxNulls = State#item_status.maxboxnull,
	BoxCell = Info#ets_users_items.place,
	NewBoxNulls = lists:sort([BoxCell|BoxNulls]),
	NewInfo = change_item_bagtype(Info, ?BAG_TYPE_COMMON, BagCell, 0),
	NewState = State#item_status{
								 null_cells = NewBagNulls,
								 maxboxnull = NewBoxNulls
								},
	[[NewInfo|List], NewState].



%%-----------神秘商店------------------------------------	

smshop_ref(PlayerStatus,Info) ->
	Now =  misc_timer:now_seconds(),
	DiffDay = util:get_diff_days(Now,Info#ets_users_smshop.vip_ref_date),
	if
		DiffDay =/= 0->
			NewInfo = item_util:update_smshop_info(Info),
			
			NewInfo1 = NewInfo#ets_users_smshop{last_ref_date = Now,vip_ref_date =Now,vip_ref_times = 1 },
			{ok,NewInfo1,0};

		PlayerStatus#ets_users.vip_id  band ?VIP_BSL_HALFYEAR =/= 0
		  andalso Info#ets_users_smshop.vip_ref_times < ?MAX_SMSHOP_REF_TIMES ->
			NewInfo = item_util:update_smshop_info(Info),
			NewInfo1 = NewInfo#ets_users_smshop{last_ref_date = Now, vip_ref_date =Now,vip_ref_times = Info#ets_users_smshop.vip_ref_times+1 },
			{ok,NewInfo1,0};
		true ->
			if
				PlayerStatus#ets_users.yuan_bao >= ?SMSHOPREFYUANBAO ->
					NewInfo = item_util:update_smshop_info(Info),
					NewInfo1 = NewInfo#ets_users_smshop{last_ref_date = Now},
					{ok,NewInfo1,?SMSHOPREFYUANBAO};
				true ->
					{false,""}
			end
	end.
		
 
%% 购买
smshop_buy(PlayerStatus,SMShopInfo,Place,ItemState) ->
	ItemList = SMShopInfo#ets_users_smshop.items_list,
	{_,Id,State} = lists:keyfind(Place, 1, ItemList),
	case check_smshop_buy(PlayerStatus,Id,State,ItemState) of
		{false,Msg}->
			{false,Msg};
		{ok,ItemTemplate,Modulus,IsBind,Acount,ReduceYunBao,ReduceCopper} ->
			if
				Modulus > 0 ->
					mod_smshop_agent:update_smshop_data(PlayerStatus#ets_users.nick_name,ItemTemplate#ets_item_template.template_id);
				true ->
					ok
			end,
			UpdateInfo = {Place,Id,1},
			NewList = lists:keyreplace(Place, 1, ItemList, UpdateInfo),
			NewInfo = SMShopInfo#ets_users_smshop{items_list = NewList},
			{ok,UpdateInfo,NewInfo, ItemTemplate,IsBind,Acount,ReduceYunBao,ReduceCopper}
	end.	


check_smshop_buy(PlayerStatus,Id,State,ItemState) ->
	if
		State =:= 0 ->
			check_smshop_buy_1(PlayerStatus,Id,ItemState);
		true ->
			{false,?_LANG_SMSHOP_ITEM_NONE}
	end.		

  

check_smshop_buy_1(PlayerStatus,Id,ItemState) ->
	case data_agent:smshop_template_get(Id) of
		[] ->
			{false,?_LANG_SMSHOP_ITEM_NONE1};
		SmshopTemplate ->
			case data_agent:item_template_get(SmshopTemplate#ets_smshop_template.template_id) of
				[] ->
					{false,?_LANG_SMSHOP_ITEM_NONE2};
				ItemTemplate ->
					check_smshop_buy_2(PlayerStatus,SmshopTemplate,ItemTemplate,ItemState)
			end
	end.
	
	
check_smshop_buy_2(PlayerStatus,SmshopTemplate,ItemTemplate,ItemState) ->
	NeedCellNum = util:ceil(SmshopTemplate#ets_smshop_template.amount/ItemTemplate#ets_item_template.max_count),
	if
		NeedCellNum > erlang:length(ItemState#item_status.null_cells )->
			{false,?_LANG_GUILD_SHOP_BAG_ERROR};
		true ->
			check_smshop_buy_3(PlayerStatus,SmshopTemplate,ItemTemplate)
	end.


check_smshop_buy_3(PlayerStatus,SmshopTemplate,ItemTemplate) ->
	case check_smshop_buy_type(PlayerStatus,SmshopTemplate) of
		{ ReduceYunBao,ReduceCopper } ->
			{ok,ItemTemplate,SmshopTemplate#ets_smshop_template.modulus,SmshopTemplate#ets_smshop_template.is_bind,SmshopTemplate#ets_smshop_template.amount, ReduceYunBao,ReduceCopper};
		_ ->
			{false,?_LANG_SMSHOP_ITEM_PAY_TYPE_ERROR}
	end.
	
	
check_smshop_buy_type(PlayerStatus,SmshopTemplate) ->
	ReduceValue = SmshopTemplate#ets_smshop_template.price,
	if
		SmshopTemplate#ets_smshop_template.pay_type =:= 1  andalso PlayerStatus#ets_users.yuan_bao  >= ReduceValue ->
			{ReduceValue,0};
		SmshopTemplate#ets_smshop_template.pay_type =:= 3  andalso PlayerStatus#ets_users.copper >= ReduceValue ->
			{0,ReduceValue};
		true ->
			false
	end.
	

	

%% 使用玫瑰花

rose_play(PlayerStatus,UserId,Type, Amount,IsAuto,State) ->
	if
		Type =:= 0 orelse Type =:= 4 ->
			Amity = 1,
			Price = 1,
			TemplateId = 207001;
		Type =:= 1 orelse Type =:= 5 ->
			Amity = 9,
			Price = 9,
			TemplateId = 207002;
		Type =:= 2 orelse Type =:= 6 ->
			Amity = 99,
			Price = 99,
			TemplateId = 207003;
		Type =:= 3 orelse Type =:= 7 ->
			Amity = 999,
			Price = 999,
			TemplateId = 207004;
		true ->
			Amity = 999,
			Price = 999,
			TemplateId = 207004
	end,
		
	case check_item_to_users(TemplateId, Amount, State#item_status.user_id) of
		true ->
			{true, NewItemStatus, ItemList, DelList} = reduce_item_to_users(TemplateId, Amount, State,?CONSUME_ITEM_USE),
			{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
			{ok,NewItemStatus,Amity*Amount};
		false when(IsAuto=:=1) ->
			{ItemList, Count} = get_bag_item_list_by_templateId(TemplateId, State#item_status.user_id),
			TmpCount = Amount - Count,
			TmpYuanbao = TmpCount * Price,
			case lib_player:check_nobind_cash(PlayerStatus,TmpYuanbao,0) of
					true ->
%% 						PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,TmpYuanbao,0,0,0,{?CONSUME_YUANBAO_ROSE,TemplateId,TmpCount}),
						{true, NewItemStatus, ItemList, DelList} = reduce_item_to_users(TemplateId, TmpCount, State,?CONSUME_ITEM_USE),
						{ok, BinData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList, DelList]),
						lib_send:send_to_sid(NewItemStatus#item_status.pid, BinData),
						{ok,NewItemStatus,Amity*Amount,TmpYuanbao};
					_ ->
						{false,?_LANG_FRIEND_ROSE_NULL}
			end;
		_ ->
			{false,?_LANG_FRIEND_ROSE_NULL}
	end.

send_player_rose(PlayerStatus,Target,UserId,Type,Amount,Nick,TotalAmity) ->
	{ok,Bin} = pt_14:write(?PP_ROSE_PLAY, [PlayerStatus#ets_users.id,
														   PlayerStatus#ets_users.nick_name,
														   PlayerStatus#ets_users.sex,
														   UserId,
														   Nick,
														   Type,
														   Amount
														   ]),
 					lib_send:send_to_all(Bin),

					SexA = PlayerStatus#ets_users.sex,
					SexT = Target#ets_users.sex,
					Str = if
							SexA =:= SexT andalso SexA  =:= 1 ->
								?_LANG_NOTICE_ROLE_PLAY4;
							SexA =:= SexT andalso SexA  =:= 0 ->
								?_LANG_NOTICE_ROLE_PLAY5;
							SexA =/= SexT ->
								?_LANG_NOTICE_ROLE_PLAY6;
							true ->
								?_LANG_NOTICE_ROLE_PLAY6
						end,
					StrType = if 
										Type =:= 0 orelse Type =:= 4 -> 
											"1";
										Type =:= 1 orelse Type =:= 5 -> 
											"9";
										Type =:= 2 orelse Type =:= 6 -> 
											"99";
										Type =:= 3 orelse Type =:= 7 -> 
											"999";
										true ->
											"1"
									end,
					ChatAllStr = ?GET_TRAN(Str, [ PlayerStatus#ets_users.nick_name,Nick,Amount,StrType]),
					lib_chat:chat_sysmsg_roll([ChatAllStr]),

					lib_friend:add_amity(PlayerStatus#ets_users.other_data#user_other.pid_send,
																					  PlayerStatus#ets_users.id,
																					  PlayerStatus#ets_users.nick_name,
																					  UserId,
																					  TotalAmity).

%%====================================================================
%% Private functions
%%====================================================================


