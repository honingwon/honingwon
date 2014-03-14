%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to formula_table_data
-module(formula_table_data).

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
					list_to_tuple([ets_formula_table_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_formula_table_template", "get/1", "程式表模板数据表"),
    F =
    fun(FormulaTableInfo) ->
        Header = header(FormulaTableInfo#ets_formula_table_template.type),
        Body = body(FormulaTableInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_formula_table_template{type = Type,
					  formulaid = Formulaid,
					  create_id = CreateId
    } = Info,
    io_lib:format(
    "    #ets_exp_template{type = ~p,\n"
    "					  formulaid = ~p,\n"
	" 					  create_id = ~p\n"					 				 				 				 
    "    };\n",
    [Type, Formulaid, CreateId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

