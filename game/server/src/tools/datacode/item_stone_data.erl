%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to item_stone_data
-module(item_stone_data).

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
					list_to_tuple([ets_item_stone_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_item_stone_template", "get/1", "装备类型对应镶嵌的石头类型模板数据表"),
    F =
    fun(ItemStoneInfo) ->
        Header = header(ItemStoneInfo#ets_item_stone_template.category_id),
        Body = body(ItemStoneInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_item_stone_template{category_id = CategoryId,					  
					  stone_list = StoneList
    } = Info,
    io_lib:format(
    "    #ets_exp_template{category_id = ~p,\n"
	" 					  stone_list = ~p\n"				 				 				 				 
    "    };\n",
    [CategoryId, StoneList]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

