%% Author: Administrator
%% Created: 2011-5-26
%% Description: TODO: Add description to streng_copper_data
-module(streng_copper_data).

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
					list_to_tuple([ets_streng_copper_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_streng_copper_template", "get/1", "强化花费金钱模板数据表"),
    F =
    fun(StrengCopperInfo) ->
        Header = header(StrengCopperInfo#ets_streng_copper_template.streng_level),
        Body = body(StrengCopperInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_streng_copper_template{streng_level = StrengLevel,
					  needcopper = NeedCopper
    } = Info,
    io_lib:format(
    "    #ets_streng_copper_template{streng_level = ~p,\n"
    " 					  needcopper = ~p\n"				 				 				 				 
    "    };\n",
    [StrengLevel, NeedCopper]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

