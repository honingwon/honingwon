%% Author: 
%% Created: 
%% Description: 
-module(active_template_list).

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
%% 					Record = list_to_tuple([ets_active_template] ++ Info),		
%% 					NameBin = create_template_all:write_string(Record#ets_active_template.active_name),
%% 					ActiveBin = create_template_all:write_string(Record#ets_active_template.active_time),
%% 					
%% 					
%% 					<<
%% 					(Record#ets_active_template.active_id):32/signed,
%% 					NameBin/binary,
%% 					(Record#ets_active_template.days):32/signed,
%% 					ActiveBin/binary,
%% 					(Record#ets_active_template.active_acount):32/signed,
%% 					(Record#ets_active_template.single_active):32/signed
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

