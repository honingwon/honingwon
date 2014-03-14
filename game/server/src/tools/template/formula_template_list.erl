%% Author: Administrator
%% Created: 2011-4-19
%% Description: 
-module(formula_template_list).

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
					Record = list_to_tuple([ets_formula_table_template] ++ Info),
					TypeBin = create_template_all:write_string(Record#ets_formula_table_template.create_name),
					
					<<(Record#ets_formula_table_template.type):32/signed,
					  (Record#ets_formula_table_template.formulaid):32/signed,
					  (Record#ets_formula_table_template.create_id):32/signed,
					  TypeBin/binary>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

