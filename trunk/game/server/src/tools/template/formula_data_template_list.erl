%% Author: Administrator
%% Created: 2011-4-19
%% Description: 
-module(formula_data_template_list).

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
	Len = length(Infos),
	FInfo = fun(Info) ->
					Record = list_to_tuple([ets_formula_template] ++ Info),
					
					NameBin = create_template_all:write_string(Record#ets_formula_template.name),
					CreateNameBin = create_template_all:write_string(Record#ets_formula_template.create_name),
					
					<<(Record#ets_formula_template.formula_id):32/signed,
					  NameBin/binary,
					  (Record#ets_formula_template.create_id):32/signed,
					  CreateNameBin/binary,
					  
					  (Record#ets_formula_template.create_amount):32/signed,					  
					  (Record#ets_formula_template.success_rate):32/signed,					  
					  (Record#ets_formula_template.cost_copper):32/signed,
					  
					  (Record#ets_formula_template.item1):32/signed,					  
					  (Record#ets_formula_template.amount1):32/signed,
					  
					  (Record#ets_formula_template.item2):32/signed,
					  (Record#ets_formula_template.amount2):32/signed,
					  					  
					  (Record#ets_formula_template.item3):32/signed,
					  (Record#ets_formula_template.amount3):32/signed,
					  
					  (Record#ets_formula_template.item4):32/signed,
					  (Record#ets_formula_template.amount4):32/signed,
					  
					  (Record#ets_formula_template.item5):32/signed,
					  (Record#ets_formula_template.amount5):32/signed,
					  
					  (Record#ets_formula_template.item6):32/signed,
					  (Record#ets_formula_template.amount6):32/signed
					 
					  >>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

