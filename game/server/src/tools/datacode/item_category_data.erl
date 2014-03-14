%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to item_category_data
-module(item_category_data).

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
					list_to_tuple([ets_item_category_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_item_category_template", "get/1", "物品种类模板数据表"),
    F =
    fun(ItemCategoryInfo) ->
        Header = header(ItemCategoryInfo#ets_item_category_template.item_category_id),
        Body = body(ItemCategoryInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_item_category_template{item_category_id = ItemCategoryId,
					  place = Place
    } = Info,
    io_lib:format(
    "    #ets_exp_template{item_category_id = ~p,\n"
	" 					  place = ~p\n"				 				 				 				 
    "    };\n",
    [ItemCategoryId, Place]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

