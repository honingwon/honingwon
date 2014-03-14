%% Author: 
%% Created: 2011-4-13
%% Description: TODO: Add description to collect_template_list
-module(collect_template_list).

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
					Record = list_to_tuple([ets_collect_template] ++ Info),				
					PicpatchBin = create_template_all:write_string(Record#ets_collect_template.pic_patch),
					LocalBin = create_template_all:write_string(Record#ets_collect_template.local_point),
					LbornlBin = create_template_all:write_string(Record#ets_collect_template.lbornl_points),
					NameBin = create_template_all:write_string(Record#ets_collect_template.name),
					<<(Record#ets_collect_template.template_id):32/signed,
					  NameBin/binary,
					  (Record#ets_collect_template.type):32/signed,
					  (Record#ets_collect_template.min_level):32/signed,
					  (Record#ets_collect_template.max_level):32/signed,
					  (Record#ets_collect_template.award_hp):32/signed,
					  (Record#ets_collect_template.award_mp):32/signed,
					  (Record#ets_collect_template.award_life_experiences):32/signed,
					  (Record#ets_collect_template.award_exp):32/signed,
					  (Record#ets_collect_template.award_yuan_bao):32/signed,
					  (Record#ets_collect_template.award_bind_copper):32/signed,
					  (Record#ets_collect_template.award_copper):32/signed,
					  (Record#ets_collect_template.collect_time):32/signed,
					  (Record#ets_collect_template.reborn_time):32/signed,					  
					  PicpatchBin/binary,
					  (Record#ets_collect_template.map_id):32/signed,
					  LocalBin/binary,
					  LbornlBin/binary,
					  (Record#ets_collect_template.quality):32/signed>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

