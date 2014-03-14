%% Author: 
%% Created: 
%% Description: 
-module(active_rewards_template_list).

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
%% 					Record = list_to_tuple([ets_active_rewards_template] ++ Info),
%% 					
%% 					
%% 					
%% 					
%% 					<<
%% 					(Record#ets_active_rewards_template.num):32/signed,
%% 					(Record#ets_active_rewards_template.need_active):32/signed,
%% 				
%% 					(Record#ets_active_rewards_template.rewards_exp):32/signed,
%% 					(Record#ets_active_rewards_template.bind_copper):32/signed
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

