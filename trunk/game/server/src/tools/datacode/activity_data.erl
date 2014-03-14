%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to activity_data
-module(activity_data).

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
					list_to_tuple([ets_activity_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_activity_template", "get/1", "活动模板数据表"),
    F =
    fun(ActivityInfo) ->
        Header = header(ActivityInfo#ets_activity_template.active_id),		
        Body = body(ActivityInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_activity_template{active_id = ActiveId,
					  active_name = ActiveName,
        			  active_time = ActiveTime,
					  open_time = OpenTime,
					  days = Days,
					  min_level = MinLevel,
					  max_level = MaxLevel,
					  npc_id = NpcId,
					  descrition = Descrition,
					  exp_level = ExpLevel,
					  award_id = AwardId
    } = Info,
    io_lib:format(
    "    #ets_exp_template{active_id = ~p,\n"
    "					  active_name = ~p,\n"
    " 					  active_time = ~p,\n"
    " 					  open_time = ~p,\n"
    " 					  days = ~p,\n"
    " 					  min_level = ~p,\n"
	"					  max_level = ~p,\n"
    " 					  npc_id = ~p,\n"
    " 					  descrition = ~p,\n"
    " 					  exp_level = ~p,\n"
	" 					  award_id = ~p\n"				 				 				 				 
    "    };\n",
    [ActiveId, ActiveName, ActiveTime, OpenTime, Days, MinLevel, MaxLevel, NpcId,
	 Descrition, ExpLevel, AwardId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

