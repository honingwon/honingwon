%% Author: 
%% Created: 
%% Description: 
-module(streng_parameters_template_list).

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
	
					Record = list_to_tuple([ets_streng_modulus_template] ++ Info),
				
					
					<<
					(Record#ets_streng_modulus_template.id):32/signed,
					(Record#ets_streng_modulus_template.quality):32/signed,
					(Record#ets_streng_modulus_template.min_level):32/signed,
					(Record#ets_streng_modulus_template.max_level):32/signed,
					(Record#ets_streng_modulus_template.mudulus):32/signed
				
					>>
					  
					  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

