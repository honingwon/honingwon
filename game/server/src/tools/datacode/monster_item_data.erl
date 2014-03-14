%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to monster_item_data
-module(monster_item_data).

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
					list_to_tuple([ets_monster_item_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_monster_item_template", "get/1", "怪物掉落物品模板数据表"),
    F =
    fun(MonsterItemInfo) ->
        Header = header(MonsterItemInfo#ets_monster_item_template.item_template_id),
        Body = body(MonsterItemInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_monster_item_template{item_template_id = ItemTemplateId,
					  monster_template_id = MonsterTemplateId,
        			  state = State,
					  random = Random,
					  amount = Amount,
					  isbind = Isbind,
					  fight_type = FightType,
					  total_random = TotalRandom
    } = Info,
    io_lib:format(
    "    #ets_exp_template{item_template_id = ~p,\n"
    "					  monster_template_id = ~p,\n"
    " 					  state = ~p,\n"
	" 					  random = ~p,\n"
    " 					  amount = ~p,\n"
	"					  isbind = ~p,\n"
	"					  fight_type = ~p,\n"
	" 					  total_random = ~p\n"				 				 				 				 
    "    };\n",
    [ItemTemplateId, MonsterTemplateId, State, Random, Amount, Isbind, FightType, TotalRandom]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

