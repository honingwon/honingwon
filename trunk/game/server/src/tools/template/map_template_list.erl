%% Author: linwei
%% Created: 2011-3-25
%% Description: TODO: Add description to map_template_list
-module(map_template_list).

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
					Record = list_to_tuple([ets_map_template] ++ Info),
					NameBin 	= create_template_all:write_string(Record#ets_map_template.name),
					RequirementBin 	= create_template_all:write_string(Record#ets_map_template.requirement),
					Default_Point_Bin = create_template_all:write_string(Record#ets_map_template.default_point),	
					
					Areas 	= string:tokens((tool:to_list(Record#ets_map_template.area)), "|"),
					AreasLen = length(Areas),
					
					FArea = fun(O)->
                         	Values = string:tokens(tool:to_list(O), ","),
			             	Area0 = tool:to_integer(lists:nth(1, Values)),
						 	Area1 = tool:to_integer(lists:nth(2, Values)),
               		     	Area2 = tool:to_integer(lists:nth(3, Values)),
 						 	Area3 = tool:to_integer(lists:nth(4, Values)),
							Area4 = tool:to_integer(lists:nth(5, Values)),
						 	<<Area0:8,
							  Area1:16/signed,
						  	  Area2:16/signed,
						  	  Area3:16/signed,
						  	  Area4:16/signed>>
							end,
					AreasBin = tool:to_binary([FArea(X)||X <- Areas]),
					
				Conditions = tool:split_string_to_intlist(Record#ets_map_template.requirement),
				FCondition = fun({Condition, Require}, Acc) ->
								case Condition of
									1 ->
										Acc#map_other{min_level=Require};
									2 ->
										Acc#map_other{max_level=Require};
									_ ->
										Acc
								end
							end,
				NewOther = lists:foldl(FCondition, #map_other{}, Conditions),
					<<(Record#ets_map_template.map_id):32/signed,
					  (Record#ets_map_template.path):32/signed,
					  (Record#ets_map_template.type):8,
					  NameBin/binary,
					  RequirementBin/binary,
					  (Record#ets_map_template.music):32/signed,
					  (NewOther#map_other.min_level):16/signed,
					  (NewOther#map_other.max_level):16/signed,
					  (Record#ets_map_template.index):32/signed,
					  (Record#ets_map_template.is_open):8,
 					  Default_Point_Bin/binary,
					  AreasLen:32/signed,
					  AreasBin/binary
					  >>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.




%%
%% Local Functions
%%

