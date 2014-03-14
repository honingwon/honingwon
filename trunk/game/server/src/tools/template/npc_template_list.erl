%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to npc_template_list
-module(npc_template_list).

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
			Record 	= 	list_to_tuple([ets_npc_template] ++ Info),
			NameBin = 	create_template_all:write_string(Record#ets_npc_template.name),
			Function_nameBin = 	create_template_all:write_string(Record#ets_npc_template.function_name),
			Pic_pathBin 	= 	create_template_all:write_string(Record#ets_npc_template.pic_path),
			DialogBin 		= 	create_template_all:write_string(Record#ets_npc_template.dialog),
			DeploysBin 		= 	create_template_all:deploy_string(tool:to_list(Record#ets_npc_template.deploys)),
					
					<<(Record#ets_npc_template.npc_id):32/signed,
					   NameBin/binary,
					   Function_nameBin/binary,
					   Pic_pathBin/binary,
					   DialogBin/binary,
					  (Record#ets_npc_template.map_id):16/signed,
					  (Record#ets_npc_template.pos_x):16/signed,
					  (Record#ets_npc_template.pos_y):16/signed,
					  DeploysBin/binary
					>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%