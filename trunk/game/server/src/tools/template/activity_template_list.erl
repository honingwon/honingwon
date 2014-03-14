%% Author: 
%% Created: 
%% Description: 
-module(activity_template_list).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
%% -export([create/1]).


%%
%% API Functions
%%


%% create([Infos]) ->
%% 	Len = length(Infos),
%% 	FInfo = fun(Info) ->
%% 					Record = list_to_tuple([ets_activity_template] ++ Info),
%% 					Bin = create_template_all:write_string(Record#ets_activity_template.open_time),		
%% 					NameBin = create_template_all:write_string(Record#ets_activity_template.active_name),
%% 					DesBin = create_template_all:write_string(Record#ets_activity_template.descrition),
%% 					AwardsBin = create_template_all:write_string(Record#ets_activity_template.award_id),
%% 					<<
%% 					(Record#ets_activity_template.active_id):32/signed,
%% 					NameBin/binary,
%% 					(Record#ets_activity_template.active_time):32/signed,
%% 					Bin/binary,
%% 					(Record#ets_activity_template.days):32/signed,
%% 					(Record#ets_activity_template.min_level):32/signed,
%% 					(Record#ets_activity_template.max_level):32/signed,
%% 					(Record#ets_activity_template.npc_id):32/signed,
%% 					DesBin/binary,
%% 					(Record#ets_activity_template.exp_level):32/signed,
%% 					AwardsBin/binary,
%% 					(Record#ets_activity_template.is_open):8
%% 					>>
%% 					  
%% 					  
%% 			   end,
%% 
%% 	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
%% 	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

