%% Author: Administrator
%% Created: 2011-5-26
%% Description: TODO: Add description to shop_category_data
-module(shop_category_data).

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
					list_to_tuple([ets_shop_category_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_shop_category_template", "get/1", "商店分类模板数据表"),
    F =
    fun(ShopCategoryInfo) ->
        Header = header(ShopCategoryInfo#ets_shop_category_template.category_id),
        Body = body(ShopCategoryInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_shop_category_template{category_id = CategoryId,
					  name = Name
    } = Info,
    io_lib:format(
    "    #ets_shop_category_template{category_id = ~p,\n"
    " 					  name = ~p\n"				 				 				 				 
    "    };\n",
    [CategoryId, Name]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

