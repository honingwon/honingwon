%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to active_welfare_data
-module(active_welfare_data).

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
					list_to_tuple([ets_active_welfare_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_active_welfare_template", "get/1", "福利模板数据表"),
    F =
    fun(ActiveWelfareInfo) ->
        Header = header(ActiveWelfareInfo#ets_active_welfare_template.welfare_id),
        Body = body(ActiveWelfareInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_active_welfare_template{welfare_id = WelfareId,
					  bag_id = BagId
    } = Info,
    io_lib:format(
    "    #ets_exp_template{welfare_id = ~p,\n"
	" 					  bag_id = ~p\n"				 				 				 				 
    "    };\n",
    [WelfareId, BagId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

