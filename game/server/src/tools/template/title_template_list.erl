%% Author: linwei
%% Created: 2011-4-2
%% Description: TODO: Add description to title_template_list
-module(title_template_list).


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
					Record = list_to_tuple([ets_title_template] ++ Info),
					
					NameBin = create_template_all:write_string(Record#ets_title_template.name),
					DataBin = create_template_all:write_string(Record#ets_title_template.data),
					DescribeBin = create_template_all:write_string(Record#ets_title_template.describe),
					
					<<(Record#ets_title_template.id):32/signed,
					  NameBin/binary,
					  (Record#ets_title_template.type):8,
					  (Record#ets_title_template.character):8,
					  DataBin/binary,
					  DescribeBin/binary>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

