%% Author: Administrator
%% Created: 2011-6-7
%% Description: TODO: Add description to formula_data
-module(formula_data).

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
					list_to_tuple([ets_formula_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_formula_table_template", "get/1", "物品配方表模板数据表"),
    F =
    fun(FormulaInfo) ->
        Header = header(FormulaInfo#ets_formula_template.formula_id),
        Body = body(FormulaInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_formula_template{formula_id = FormulaId,
					  create_id = CreateId,
					  create_amount = CreateAmount,
					  success_rate = SuccessRate,
					  cost_copper = CostCopper,
					  item1 = Item1,
					  amount1 = Amount1,
					  item2 = Item2,
					  amount2 = Amount2,
					  item3 = Item3,
					  amount3 = Amount3,
					  item4 = Item4,
					  amount4 = Amount4,
					  item5 = Item5,
					  amount5 = Amount5,
					  item6 = Item6,
					  amount6 = Amount6
    } = Info,
    io_lib:format(
    "    #ets_exp_template{formula_id = ~p,\n"
    "					  create_id = ~p,\n"
	"					  create_amount = ~p,\n"
	"					  success_rate = ~p,\n"
	"					  cost_copper = ~p,\n"
	"					  item1 = ~p,\n"
	"					  amount1 = ~p,\n"
	"					  item2 = ~p,\n"
	"					  amount2 = ~p,\n"
	"					  item3 = ~p,\n"
	"					  amount3 = ~p,\n"
	"					  item4 = ~p,\n"
	"					  amount4 = ~p,\n"
	"					  item5 = ~p,\n"
	"					  amount5 = ~p,\n"
	"					  item6 = ~p,\n"
	" 					  amount6 = ~p\n"					 				 				 				 
    "    };\n",
    [FormulaId,CreateId, CreateAmount, SuccessRate, CostCopper, Item1, Amount1,
	  Item2, Amount2, Item3, Amount3, Item4, Amount4, Item5, Amount5, Item6, Amount6]).

last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

