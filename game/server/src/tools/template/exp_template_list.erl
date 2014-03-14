%% Author: linwei
%% Created: 2011-3-24
%% Description: TODO: Add description to exp_template_list
-module(exp_template_list).

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
					Record = list_to_tuple([ets_exp_template] ++ Info),
					<<(Record#ets_exp_template.level):32/signed,
					  (Record#ets_exp_template.exp):32/signed,
					  (Record#ets_exp_template.total_exp):64/signed>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.


%%
%% Local Functions
%%

