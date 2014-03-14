%% Author: Administrator
%% Created: 2011-3-15
%% Description: TODO: Add description to door_template_list
-module(door_template_list).

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
					Record = list_to_tuple([ets_door_template] ++ Info),
					<<(Record#ets_door_template.door_id):16/signed,
					  (Record#ets_door_template.current_map_id):16/signed,
					  (Record#ets_door_template.next_map_id):16/signed,
					  (Record#ets_door_template.next_door_id):16/signed,
					  (Record#ets_door_template.pos_x):16/signed,
					  (Record#ets_door_template.pos_y):16/signed>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

