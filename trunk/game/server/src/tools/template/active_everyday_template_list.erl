%% Author: 
%% Created: 
%% Description: 
-module(active_everyday_template_list).

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
%% 	
%% 					Record = list_to_tuple([ets_active_everyday_template] ++ Info),
%% 					
%% 					
%% 					
%% 					
%% 					<<
%% 					(Record#ets_active_everyday_template.id):32/signed,
%% 					(Record#ets_active_everyday_template.type):32/signed,
%% 				
%% 					(Record#ets_active_everyday_template.active_id):32/signed,
%% 					(Record#ets_active_everyday_template.duplicate_id):32/signed,
%% 					
%% 					(Record#ets_active_everyday_template.boss_id):32/signed,
%% 					(Record#ets_active_everyday_template.task_id):32/signed
%% 				
%% 	
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

