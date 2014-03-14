%% Author: 
%% Created: 
%% Description: 
-module(suit_num_template_list).

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
	
					Record = list_to_tuple([ets_suit_num_template] ++ Info),
					NameBin = create_template_all:write_string(Record#ets_suit_num_template.suit_name),	
					
					<<
					(Record#ets_suit_num_template.suit_num):32/signed,
					NameBin/binary,
					(Record#ets_suit_num_template.cloth_id):32/signed,
					(Record#ets_suit_num_template.armet_id):32/signed,
					(Record#ets_suit_num_template.cuff_id):32/signed,
					(Record#ets_suit_num_template.shoe_id):32/signed,
					(Record#ets_suit_num_template.caestus_id):32/signed,
					(Record#ets_suit_num_template.necklack_id):32/signed
                    
					>>					  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

