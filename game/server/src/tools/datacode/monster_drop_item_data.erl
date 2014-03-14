%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to monster_drop_item_data
-module(monster_drop_item_data).

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
					list_to_tuple([ets_monster_drop_item_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_monster_drop_item_template", "get/1", "怪物掉落次数模板数据表"),
    F =
    fun(MonsterDropItemInfo) ->
        Header = header(MonsterDropItemInfo#ets_monster_drop_item_template.monster_template_id),
        Body = body(MonsterDropItemInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_monster_drop_item_template{monster_template_id = MonsterTemplateId,
					  drop_times = DropTimes,
        			  item_template_id = ItemTemplateId,
					  drop_rate = DropRate,
					  drop_number = DropNumber,
					  isbind = Isbind
    } = Info,
    io_lib:format(
    "    #ets_exp_template{monster_template_id = ~p,\n"
    "					  drop_times = ~p,\n"
    " 					  item_template_id = ~p,\n"
    " 					  drop_rate = ~p,\n"
	"					  drop_number = ~p,\n"
	" 					  isbind = ~p\n"				 				 				 				 
    "    };\n",
    [MonsterTemplateId, DropTimes, ItemTemplateId, DropRate, DropNumber, Isbind]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

