%% Author: 
%% Created: 
%% Description: 
-module(active_task_template_list).

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
					
					Record = list_to_tuple([ets_activity_task_template] ++ Info),
				    DescriptBin = 	create_template_all:write_string(Record#ets_activity_task_template.descript),		
					AwardBin = 	create_template_all:write_string(Record#ets_activity_task_template.award),			
					<<
					(Record#ets_activity_task_template.id):32/signed,
					DescriptBin/binary,
					(Record#ets_activity_task_template.exp_level):32/signed,
					AwardBin/binary			
					>>
					 				  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

