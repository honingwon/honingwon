%% Author: Administrator
%% Created: 2011-5-6
%% Description: TODO: Add description to duplicate_template_list
-module(duplicate_template_list).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 create/1
		]).

%%
%% API Functions
%%

create([Infos]) ->
	Len = length(Infos),
	FInfo = fun(Info) ->
					Record = list_to_tuple([ets_duplicate_template] ++ Info),
					
					NameBin = create_template_all:write_string(Record#ets_duplicate_template.name),
					DescriptionBin = create_template_all:write_string(Record#ets_duplicate_template.description),
					MissionBin = create_template_all:write_string(Record#ets_duplicate_template.mission),
					AwardBin = create_template_all:write_string(Record#ets_duplicate_template.award_id),
					  
					<<(Record#ets_duplicate_template.duplicate_id):32/signed,
					  NameBin/binary,
					  DescriptionBin/binary,
					  (Record#ets_duplicate_template.day_times):16/signed,
					  (Record#ets_duplicate_template.npc):32/signed,
					  (Record#ets_duplicate_template.recommend):16/signed,
					  (Record#ets_duplicate_template.type):16/signed,
					  (Record#ets_duplicate_template.showtype):16/signed,
					  (Record#ets_duplicate_template.min_level):16/signed,
					  (Record#ets_duplicate_template.max_level):16/signed,
					  (Record#ets_duplicate_template.min_player):16/signed,
					  (Record#ets_duplicate_template.max_player):16/signed,
					  (Record#ets_duplicate_template.need_yuan_bao):32/signed,
					  (Record#ets_duplicate_template.need_bind_yuan_bao):32/signed,
					  (Record#ets_duplicate_template.need_copper):32/signed,
					  (Record#ets_duplicate_template.need_bind_copper):32/signed,
					  (Record#ets_duplicate_template.need_item_id):32/signed,
					  (Record#ets_duplicate_template.total_time):32/signed,
					  MissionBin/binary,
					  AwardBin/binary,
					  (Record#ets_duplicate_template.is_dynamic):8,
					  (Record#ets_duplicate_template.task_id):32/signed,
					  (Record#ets_duplicate_template.is_show_in_activity):8>>
			   end,
	
	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

