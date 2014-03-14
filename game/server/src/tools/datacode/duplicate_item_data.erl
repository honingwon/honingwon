%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to duplicate_item_data
-module(duplicate_item_data).

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
					list_to_tuple([ets_duplicate_item_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_duplicate_item_template", "get/1", "副本物品掉落模板数据表"),
    F =
    fun(DuplicateItemInfo) ->
        Header = header(DuplicateItemInfo#ets_duplicate_item_template.item_template_id),
        Body = body(DuplicateItemInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_duplicate_item_template{item_template_id = ItemTemplateId,
      					  duplicate_template_id = DuplicateTemplateId, 	
      					  state = State,	
      					  random = Random,	
      					  amount = Amount, 
      					  is_bind = IsBind 
    } = Info,
    io_lib:format(
    "    #ets_exp_template{item_template_id = ~p,\n"
    "					  duplicate_template_id = ~p,\n"
    " 					  state = ~p,\n"
    " 					  random = ~p,\n"
    " 					  amount = ~p,\n"
	" 					  is_bind = ~p\n"				 				 				 				 
    "    };\n",
    [ItemTemplateId, DuplicateTemplateId, State, Random, Amount, IsBind]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

