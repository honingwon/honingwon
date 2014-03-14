%% Author: 
%% Created: 
%% Description: 
-module(suit_props_template_list).

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
	
					Record = list_to_tuple([ets_suit_props_template] ++ Info),
					Bin1 = create_template_all:write_string(Record#ets_suit_props_template.suit_props),	
					Bin2 = create_template_all:write_string(Record#ets_suit_props_template.suit_hide_props),
					Bin3 = create_template_all:write_string(Record#ets_suit_props_template.description),
					<<
					(Record#ets_suit_props_template.id):32/signed,
					(Record#ets_suit_props_template.suit_num):32/signed,
					(Record#ets_suit_props_template.suit_amount):32/signed,
					Bin1/binary,
					Bin2/binary,										
					(Record#ets_suit_props_template.skill_id):32/signed,
					Bin3/binary	
					                   
					>>
			end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

