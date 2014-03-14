%% Author: Administrator
%% Created: 2011-5-25
%% Description: TODO: Add description to door_data
-module(exp_data).

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
					list_to_tuple([ets_exp_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%


%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_exp_template", "get/1", "经验模板数

据表"),
    F =
    fun(ExpInfo) ->
        Header = header(ExpInfo#ets_exp_template.level),
        Body = body(ExpInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Level) when is_integer(Level) ->
    lists:concat(["get(", Level, ") ->\n"]).

body(Info) ->
    #ets_exp_template{level = Lv,
					  exp = Exp,
        			  total_exp = Total_Exp
    } = Info,
    io_lib:format(
    "    #ets_exp_template{level = ~p,\n"
    "					  exp = ~p,\n"
    " 					  total_exp = ~p\n"
    "    };\n",
    [Lv, Exp, Total_Exp]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%
