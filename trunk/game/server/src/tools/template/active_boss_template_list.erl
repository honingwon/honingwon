%% Author: 
%% Created: 
%% Description: 
-module(active_boss_template_list).

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
	
					Record = list_to_tuple([ets_activity_boss_template] ++ Info),
				    DescriptBin = 	create_template_all:write_string(Record#ets_activity_boss_template.descript),		
					AwardBin = 	create_template_all:write_string(Record#ets_activity_boss_template.awards),			
					<<
					(Record#ets_activity_boss_template.id):32/signed,
					(Record#ets_activity_boss_template.flash_time):32/signed,
					DescriptBin/binary,
					(Record#ets_activity_boss_template.equip_level):32/signed,
					AwardBin/binary			
					>>
					 				  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

