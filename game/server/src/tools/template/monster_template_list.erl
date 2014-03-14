%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to monster_template_list
-module(monster_template_list).

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
					Record 		= list_to_tuple([ets_monster_template] ++ Info),
					NameBin 	= create_template_all:write_string(Record#ets_monster_template.name),
					Pic_pathBin = create_template_all:write_string(Record#ets_monster_template.pic_path),
					
					Local_points = string:tokens((tool:to_list(Record#ets_monster_template.local_point)), ","),
					X = tool:to_integer(lists:nth(1, Local_points)),
                    Y = tool:to_integer(lists:nth(2, Local_points)),
					
					<<(Record#ets_monster_template.monster_id):32/signed,
					  NameBin/binary,
					  Pic_pathBin/binary,
					  (Record#ets_monster_template.max_hp):32/signed,
                      X:16/signed,
                      Y:16/signed,
					  (Record#ets_monster_template.map_id):16/signed,
					  (Record#ets_monster_template.level):16/signed
%% 					  (Record#ets_monster_template.guard_distince):32/signed,
%% 					  (Record#ets_monster_template.critical ):32/signed,
%% 					  (Record#ets_monster_template.tough ):32/signed
					  >>
			   end,

	Bin = tool:to_binary([FInfo(S)||S <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

