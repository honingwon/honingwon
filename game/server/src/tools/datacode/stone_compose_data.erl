%% Author: Administrator
%% Created: 2011-5-26
%% Description: TODO: Add description to stone_compose_data
-module(stone_compose_data).

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
					list_to_tuple([ets_stone_compose_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_stone_compose_template", "get/1", "宝石合成铜币消耗模板数据表"),
    F =
    fun(StoneComposeInfo) ->
        Header = header(StoneComposeInfo#ets_stone_compose_template.stone_level),
        Body = body(StoneComposeInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_stone_compose_template{stone_level = StoneLevel,
					  copper = Copper
    } = Info,
    io_lib:format(
    "    #ets_stone_compose_template{stone_level = ~p,\n"
    " 					  copper = ~p\n"				 				 				 				 
    "    };\n",
    [StoneLevel, Copper]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

