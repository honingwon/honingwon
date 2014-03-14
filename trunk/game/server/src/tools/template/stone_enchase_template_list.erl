%% Author: Administrator
%% Created: 2011-4-19
%% Description: 
-module(stone_enchase_template_list).

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
					Record = list_to_tuple([ets_enchase_template] ++ Info),	
					
					<<
					  (Record#ets_enchase_template.stone_level):32/signed,
					  (Record#ets_enchase_template.copper):32/signed
					  >>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

