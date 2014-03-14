%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to active_everyday_data
-module(active_everyday_data).

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
					list_to_tuple([ets_active_everyday_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_active_everyday_template", "get/1", "每日活动配置模板数据表"),
    F =
    fun(ActiveEverydayInfo) ->
        Header = header(ActiveEverydayInfo#ets_active_everyday_template.id),
        Body = body(ActiveEverydayInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_active_everyday_template{id = Id,
					  type = Type,
					  active_id = ActiveId,
					  duplicate_id = DuplicateId,
					  boss_id = BossId,
					  task_id = TaskId
    } = Info,
    io_lib:format(
    "    #ets_exp_template{id = ~p,\n"
	" 					  type = ~p\n"		
	" 					  active_id = ~p\n"	
	" 					  duplicate_id = ~p\n"		
	" 					  boss_id = ~p\n"				
	" 					  task_id = ~p\n"				 				 				 				 
    "    };\n",
    [Id, Type, ActiveId, DuplicateId, BossId, TaskId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%




%%
%% Local Functions
%%

