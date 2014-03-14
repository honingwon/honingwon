%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to active_data
-module(active_data).

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
					list_to_tuple([ets_active_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_active_template", "get/1", "活跃度模板数据表"),
    F =
    fun(ActiveInfo) ->
        Header = header(ActiveInfo#ets_active_template.active_id),
        Body = body(ActiveInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_active_template{active_id = ActiveId,
					  active_name = ActiveName,
					  days = Days,
					  active_time = ActiveTime,
					  active_acount = ActiveAcount,
					  single_active = SingleActive
    } = Info,
    io_lib:format(
    "    #ets_exp_template{active_id = ~p,\n"
	" 					  active_name = ~p\n"		
	" 					  days = ~p\n"		
	" 					  active_time = ~p\n"		
	" 					  active_acount = ~p\n"		
	" 					  single_active = ~p\n"				 				 				 				 
    "    };\n",
    [ActiveId, ActiveName, Days, ActiveTime, ActiveAcount, SingleActive]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

