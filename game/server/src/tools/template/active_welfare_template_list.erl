%% Author: 
%% Created: 
%% Description: 
-module(active_welfare_template_list).

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
					Record = list_to_tuple([ets_active_welfare_template] ++ Info),	
					NameBin = create_template_all:write_string(Record#ets_active_welfare_template.welfare_name),		
					DescriptBin =  create_template_all:write_string(Record#ets_active_welfare_template.descript),	
					AwardBin = create_template_all:write_string(Record#ets_active_welfare_template.bag_id),
					<<
					(Record#ets_active_welfare_template.welfare_id):32/signed,
					NameBin/binary,
					AwardBin/binary,
					DescriptBin/binary
					>>
					  
					  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

