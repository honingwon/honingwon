%% Author: Administrator
%% Created: 2011-4-19
%% Description: 
-module(hole_template_list).

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
					Record = list_to_tuple([ets_hole_template] ++ Info),	
					
					<<
					  (Record#ets_hole_template.holeflag):32/signed,
					  (Record#ets_hole_template.enchase1):32/signed,
                      (Record#ets_hole_template.enchase2):32/signed,
                      (Record#ets_hole_template.enchase3):32/signed,
                      (Record#ets_hole_template.enchase4):32/signed,
                      (Record#ets_hole_template.enchase5):32/signed

					  >>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

