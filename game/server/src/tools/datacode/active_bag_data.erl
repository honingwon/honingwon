%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to active_bag_data
-module(active_bag_data).

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
					list_to_tuple([ets_active_bag_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_active_bag_template", "get/1", "活跃度礼包模板数据表"),
    F =
    fun(ActiveBagInfo) ->
        Header = header(ActiveBagInfo#ets_active_bag_template.num),
        Body = body(ActiveBagInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_active_bag_template{num = Num,
					  bag_id = BagId,
					  need_active = NeedActive
    } = Info,
    io_lib:format(
    "    #ets_exp_template{num = ~p,\n"
	" 					  bag_id = ~p\n"					
	" 					  need_active = ~p\n"				 				 				 				 
    "    };\n",
    [Num, BagId, NeedActive]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

