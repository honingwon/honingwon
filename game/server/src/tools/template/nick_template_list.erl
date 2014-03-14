%% Author: Administrator
%% Created: 2011-3-28
%% Description: TODO: Add description to nick_template_list
-module(nick_template_list).


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
					Record = list_to_tuple([ets_nick_template] ++ Info),
					
					 ContentBin = create_template_all:write_string( Record#ets_nick_template.content),
					
					<<(Record#ets_nick_template.type):32/signed,
					  ContentBin/binary>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.



%%
%% Local Functions
%%

