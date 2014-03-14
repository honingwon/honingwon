%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to movie_template_list
-module(movie_template_list).

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
					Record = list_to_tuple([ets_movie_template] ++ Info),
					
					FrameBin = create_template_all:write_string(Record#ets_movie_template.frame),
					
					<<(Record#ets_movie_template.move_id):32/signed,
					  FrameBin/binary,
					  (Record#ets_movie_template.offset_x):32/signed,
					  (Record#ets_movie_template.offset_y):32/signed,
					  (Record#ets_movie_template.pic_path):32/signed,
					  (Record#ets_movie_template.amount):32/signed,
					  (Record#ets_movie_template.bound):32/signed,
					  (Record#ets_movie_template.item):32/signed,
					  (Record#ets_movie_template.add_mode):32/signed,
					  (Record#ets_movie_template.is_move):8,
					  (Record#ets_movie_template.comp_effect):32/signed
					  >>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

