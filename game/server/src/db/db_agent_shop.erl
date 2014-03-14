%% Author: Administrator
%% Created: 2011-6-13
%% Description: TODO: Add description to db_agent_shop
-module(db_agent_shop).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([get_discount_by_id/1,
		 get_shop_discount/0,
		 create_discount/1,
		 update_discount/2,
		 delete_discount/1
		]).

%%
%% API Functions
%%
%% 根据条件查找优惠商品
get_discount_by_id(DiscountItemId) ->	
	?DB_MODULE:select_row(t_shop_discount, "*" ,[{item_id, DiscountItemId}]).

%%查出所有数据
get_shop_discount() ->
	?DB_MODULE:select_all(t_shop_discount, "*", []).

create_discount(DiscountItem) ->
	ValueList = lists:nthtail(1, tuple_to_list(DiscountItem#ets_shop_discount{other_data=''})),
	FieldList =  record_info(fields, ets_shop_discount),
	Ret = ?DB_MODULE:insert(t_shop_discount, FieldList, ValueList),
	case ?DB_MODULE of
		db_mysql ->
		   Ret;
	   	_ ->
		   {mongo, Ret}
	end.

update_discount(UpdateList, WhereList) ->
  	?DB_MODULE:update(t_shop_discount, UpdateList, WhereList).

delete_discount(WhereList) ->
	?DB_MODULE:delete(t_shop_discount,WhereList).
%%
%% Local Functions
%%

