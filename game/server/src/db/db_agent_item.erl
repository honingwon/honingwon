%% Author: Administrator
%% Created: 2011-3-9
%% Description: TODO: Add description to db_agent_item
-module(db_agent_item).

-include("common.hrl").

-export([add_item/1,
		 change_item_owner/3,
		 get_user_items_by_id/1,
		 get_item_for_id/3,
		 get_item_for_only_id/3,
		 change_item_num/2,
		 change_item_durable/2,
		 change_item_hole/2,
		 %change_item_streng/2,
		 change_item_templateid/2,
		 delete_item/1,
		 %change_item_cell/2,
		 get_item_by_itemid/1,
		 %change_item_bagtype/3,
		 update_item_enchase1/2,
		 update_item_enchase2/2,
		 update_item_enchase3/2,
		 change_user_item_data/2,
		 change_item_isbind/2,
		 %update_pet_name/2,
		 update_item/1,
		 get_user_items_by_id_and_bag/2,
		 get_user_pet_equip_by_id/2,
		 get_smshop_info_by_userid/1,
		 add_smshop_info_by_userid/1,
		 update_smshop_timer_by_userid/2,
		 update_smshop_info/1,
		 update_smshop_info_item/1
		]).
-export([
		 add_sale_item/1,
		 update_item_state/2,
		 load_all_sale/0,
		 get_sale_item_for_id/2,
		 get_sale_item_for_id/1,
		 delete_sale_item/1,
		 update_sale_item/2,
		 load_all_sale_items/0
		]).
%%
%% API Functions
%%
load_all_sale_items() ->
	?DB_MODULE:select_all(t_users_items, "*", [{bag_type, ?BAG_TYPE_SALE}]).
delete_sale_item(DeleteSaleItemList) ->
%% 	?DB_MODULE:delete(t_users_sales, DeleteSaleItemList).
	?DB_MODULE:update(t_users_sales, [{is_exist, 0}], DeleteSaleItemList).

update_sale_item(ItemValueList,ItemWhereList) ->
	?DB_MODULE:update(t_users_sales, ItemValueList, ItemWhereList).

% 加载所有寄售记录
load_all_sale() ->
	?DB_MODULE:select_all(t_users_sales, "*", [{is_exist, 1}]).

%% 更新寄售物品状态
update_item_state(ItemValueList, ItemWhereList) ->
	?DB_MODULE:update(t_users_items, ItemValueList, ItemWhereList).

%% 插入数据库后再查询获取信息包含id, 
get_sale_item_for_id(UserId, ItemId) ->
	?DB_MODULE:select_row(t_users_sales, "*",
								 [{user_id, UserId},
								  {item_id, ItemId}],
								  [{id, desc}],
								  [1]).	
%% 根据用户id，寄售类型(?SALES_TYPE_YB_SALE, ?SALES_TYPE_COPPER_SALE)获取最新寄售的货币记录id
get_sale_item_for_id(WhereList) ->
	%% [{user_id, UserId}, {type, Type}] = WhereList,
	?DB_MODULE:select_row(t_users_sales, "*",
								 WhereList,
								  [{id, desc}],
								  [1]).	
%% 添加寄售物品
add_sale_item(SaleItem) ->
	Value = lists:nthtail(2, tuple_to_list(SaleItem#ets_users_sales{other_data = ""})),
	[id | FieldList] = record_info(fields, ets_users_sales),
	Ret = ?DB_MODULE:insert(t_users_sales, FieldList, Value),
	case ?DB_MODULE =:= db_mysql of
		true ->
			Ret;
		false ->
			{mongo, Ret}
	end.

%% 添加新物品信息
add_item(ItemInfo) ->
	ValueList = lists:nthtail(2, tuple_to_list(ItemInfo#ets_users_items{other_data = ""})),
    [id | FieldList] = record_info(fields, ets_users_items),
	Ret = ?DB_MODULE:insert(t_users_items, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
    		Ret;
		true ->
			{mongo, Ret}
	end.

%% get_add_goods(PlayerId, GoodsTypeId, Location, Cell, Num) ->
%% 	?DB_MODULE:select_row(goods, "*",
%% 								 [{player_id, PlayerId},
%% 								  {goods_id, GoodsTypeId},
%% 								  {location, Location},
%% 								  {cell, Cell},
%% 								  {num, Num}],
%% 								  [{id, desc}],
%% 								  [1]).


%% 更新物品信息

update_item(Info) ->
	if (Info#ets_users_items.is_exist =:= 0 andalso Info#ets_users_items.category_id > ?CATE_MAX_EQUIP_ID)->
			?DB_MODULE:delete(t_users_items,[{id, Info#ets_users_items.id}]);
		true ->
			update_item1(Info)
	end.
update_item1(Info) ->
			?DB_MODULE:update(t_users_items,
					  [{user_id, Info#ets_users_items.user_id},
					   {template_id, Info#ets_users_items.template_id},
					   {pet_id, Info#ets_users_items.pet_id},	
					   {bag_type, Info#ets_users_items.bag_type},
					   {is_bind, Info#ets_users_items.is_bind},
					   {strengthen_level, Info#ets_users_items.strengthen_level},
					   {fail_acount, Info#ets_users_items.fail_acount},
					   {amount, Info#ets_users_items.amount},
					   {place, Info#ets_users_items.place},
					   {create_date, Info#ets_users_items.create_date},
					   {state, Info#ets_users_items.state},
					   {durable, Info#ets_users_items.durable},
					   {enchase1, Info#ets_users_items.enchase1},
					   {enchase2, Info#ets_users_items.enchase2},
					   {enchase3, Info#ets_users_items.enchase3},
					   {enchase4, Info#ets_users_items.enchase4},
					   {enchase5, Info#ets_users_items.enchase5},
					   {enchase6, Info#ets_users_items.enchase6},
					   {fight, Info#ets_users_items.fight},
					   {data, Info#ets_users_items.data},
					   {is_exist, Info#ets_users_items.is_exist}
					   ],
					  [{id, Info#ets_users_items.id}]
					  ).
	


%% 更改物品拥有者
change_item_owner(ItemId, UserId, Cell) ->
	?DB_MODULE:update(t_users_items,
					  			[{bag_type, ?BAG_TYPE_COMMON},{user_id, UserId}, {place, Cell}],
					  			[{id, ItemId}]).



%% 更改物品数量
change_item_num(ItemId, Amount) ->	
	?DB_MODULE:update(t_users_items,
								 [{amount, Amount}],
								 [{id, ItemId}]).

%% 更改物品耐久值
change_item_durable(ItemId, Durable) ->	
	?DB_MODULE:update(t_users_items,
					             [{durable, Durable}],
					             [{id, ItemId}]).

%% 更改物品的模板ID
change_item_templateid(ItemId, TempId) ->
	?DB_MODULE:update(t_users_items,
					             [{template_id, TempId}],
					             [{id, ItemId}]).

change_item_isbind(ItemId, IsBind) ->
	?DB_MODULE:update(t_users_items,
					             [{is_bind, IsBind}],
					             [{id, ItemId}]).


change_user_item_data(ItemId, Data) ->
	?DB_MODULE:update(t_users_items,
					             [{data, Data}],
					             [{id, ItemId}]).


%% 更改物品打孔数量
change_item_hole(ItemId, [Enchase1, Enchase2, Enchase3, Enchase4, Enchase5]) ->
	?DB_MODULE:update(t_users_items,
					             [{enchase1, Enchase1},{enchase2, Enchase2},{enchase3, Enchase3},{enchase4, Enchase4},{enchase5, Enchase5}],					            
					             [{id, ItemId}]).

%% 更改物品的强化等级
%% change_item_streng(ItemId, StrengLevel) ->
%% 	?DB_MODULE:update(t_users_items,
%% 					  [{strengthen_level, StrengLevel}],
%% 					  [{id, ItemId}]).

%% 改变物品位置
%% change_item_cell(ItemId, Cell) ->
%% 	?DB_MODULE:update(t_users_items,
%% 					  [{place, Cell}],
%% 					  [{id, ItemId}]).
%% 改变物品背包
%% change_item_bagtype(ItemId, BagType, Cell) ->
%% 	?DB_MODULE:update(t_users_items,
%% 					  [{place, Cell}, {bag_type, BagType}],
%% 					  [{id, ItemId}]).

%% 删除物品
delete_item(ItemId) ->
	?DB_MODULE:delete(t_users_items,
								 [{id, ItemId}]).


%% 通过用户id获取物品
get_user_items_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_items, "*", [{user_id, UserId}, {place, ">=", 0}, {is_exist, "=", 1}]).

%%通过用户id和背包类型获取物品
get_user_items_by_id_and_bag(UserId, BagType) ->
	?DB_MODULE:select_all(t_users_items, "*", [{user_id, UserId}, {place, ">=", 0}, {place, "<", ?BAG_BEGIN_CELL},
											   {bag_type, "=", BagType}, {is_exist, "=", 1}]).
%%通过宠物id查询宠物装备
get_user_pet_equip_by_id(UserId, PetId) ->
	?DB_MODULE:select_all(t_users_items, "*", [{user_id, UserId}, {place, ">=", 0}, {pet_id, "=", PetId},
											   {bag_type, "=", ?BAG_TYPE_PET}, {is_exist, "=", 1}]).

%% 插入数据库后再查询获取信息包含id
get_item_for_id(UserId, TemplateId, Place) ->
	?DB_MODULE:select_row(t_users_items, "*",
								 [{user_id, UserId},
								  {template_id, TemplateId},
								  {place, Place}],
								  [{id, desc}],
								  [1]).


%% 插入数据库后再查询id
get_item_for_only_id(UserId, TemplateId, Place) ->
	?DB_MODULE:select_one(t_users_items, "id",
								 [{user_id, UserId},
								  {template_id, TemplateId},
								  {place, Place}],
								  [{id, desc}],
								  [1]).


%% 获取物品信息根据itemid
get_item_by_itemid(ItemId) ->
	?DB_MODULE:select_row(t_users_items, "*" ,[{id, ItemId}]).

update_item_enchase1(Id,State) ->
	?DB_MODULE:update(t_users_items,[{enchase1,State}],[{id,Id}]).

update_item_enchase2(Id,State) ->
	?DB_MODULE:update(t_users_items,[{enchase2,State}],[{id,Id}]).

update_item_enchase3(Id,State) ->
	?DB_MODULE:update(t_users_items,[{enchase3,State}],[{id,Id}]).


%%更新物品数据库中的宠物名字 
%% update_pet_name(PetId,Name) ->
%% 	?DB_MODULE:update(t_users_items,[{data,Name}],[{id,PetId}]).


get_smshop_info_by_userid(UserId) ->
	?DB_MODULE:select_row(t_users_smshop, "*" ,[{user_id, UserId}]).

add_smshop_info_by_userid(Info) ->
	DBData = tool:intlist_to_string_3(Info#ets_users_smshop.items_list),
	DBInfo = Info#ets_users_smshop{items_list = DBData},
	ValueList = lists:nthtail(1, tuple_to_list(DBInfo)),
	FieldList = record_info(fields, ets_users_smshop),
	Ret = ?DB_MODULE:insert(t_users_smshop, FieldList, ValueList).
	
update_smshop_timer_by_userid(UserId,Date) ->
	?DB_MODULE:update(t_users_smshop, [{last_ref_date, Date}], [{user_id, UserId}]).


update_smshop_info(Info) ->
	DBData = tool:intlist_to_string_3(Info#ets_users_smshop.items_list),
	?DB_MODULE:update(t_users_smshop, [{items_list, DBData},
									   {vip_ref_times, Info#ets_users_smshop.vip_ref_times},
									   {vip_ref_date, Info#ets_users_smshop.vip_ref_date},
									   {last_ref_date, Info#ets_users_smshop.last_ref_date}], 
					  					[{user_id, Info#ets_users_smshop.user_id}]).

update_smshop_info_item(Info) ->
	DBData = tool:intlist_to_string_3(Info#ets_users_smshop.items_list),
	?DB_MODULE:update(t_users_smshop, [{items_list, DBData}],
					  					[{user_id, Info#ets_users_smshop.user_id}]).


%%
%% Local Functions
%%

