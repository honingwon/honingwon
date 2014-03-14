%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to pick_stone_data
-module(pick_stone_data).

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
					list_to_tuple([ets_pick_stone_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_pick_stone_template", "get/1", "宝石摘取系数模板数据表"),
    F =
    fun(PickStoneInfo) ->
        Header = header(PickStoneInfo#ets_pick_stone_template.stone_level),
        Body = body(PickStoneInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_pick_stone_template{stone_level = StoneLevel,
					  copper_modulus = CopperModulus,
					  success_rates = SuccessRates
    } = Info,
    io_lib:format(
    "    #ets_exp_template{stone_level = ~p,\n"
    "					  copper_modulus = ~p,\n"
    " 					  success_rates = ~p\n"				 				 				 				 
    "    };\n",
    [StoneLevel, CopperModulus, SuccessRates]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

