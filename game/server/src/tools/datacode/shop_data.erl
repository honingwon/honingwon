%% Author: Administrator
%% Created: 2011-5-25
%% Description: TODO: Add description to door_data
-module(shop_data).

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

create([Infos]) ->
	FInfo = fun(Info) ->
					list_to_tuple([ets_shop_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_shop_template", "get/1", "商店模板数据表"),
    F =
    fun(ShopInfo) ->
        Header = header(ShopInfo#ets_shop_template.id),
        Body = body(ShopInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_shop_template{shop_id = ShopId,
					  category_id = CategoryId,
        			  template_id = TemplateId,
					  state = State,
					  pay_type = PayType,
					  price = Price,
					  is_bind = IsBind
    } = Info,
    io_lib:format(
    "    #ets_exp_template{shop_id = ~p,\n"
    "					  category_id = ~p,\n"
    " 					  template_id = ~p,\n"
    " 					  state = ~p,\n"
    " 					  pay_type = ~p,\n"
    " 					  price = ~p,\n"
    " 					  is_bind = ~p\n"				 				 				 				 
    "    };\n",
    [ShopId, CategoryId, TemplateId, State, PayType, Price, IsBind]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

