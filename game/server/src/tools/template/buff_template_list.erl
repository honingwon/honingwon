%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to buff_template_list
-module(buff_template_list).

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
						
					Record 			= list_to_tuple([ets_buff_template] ++ Info),
					NameBin 		= create_template_all:write_string(Record#ets_buff_template.name),
                    Pic_pathBin 	= create_template_all:write_string(Record#ets_buff_template.pic_path),
                    DescriptionBin 	= create_template_all:write_string(Record#ets_buff_template.description),
					SkillEffectBin 	= create_template_all:write_string(Record#ets_buff_template.skill_effect_list),
					
					
                  <<(Record#ets_buff_template.buff_id):32/signed,
 					(Record#ets_buff_template.group_id):32/signed,
					 NameBin/binary,
                     Pic_pathBin/binary,
					 DescriptionBin/binary,
					(Record#ets_buff_template.active_totaltime):32/signed,
					(Record#ets_buff_template.active_timespan):32/signed,
					(Record#ets_buff_template.type):32/signed,
					(Record#ets_buff_template.limit_totaltime):32/signed,
					SkillEffectBin/binary			
                    >>
				end,
	
	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

