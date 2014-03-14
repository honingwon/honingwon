%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to item_template_list
-module(item_template_list).

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
					Record = list_to_tuple([ets_item_template] ++ Info),
					
					NameBin 			= create_template_all:write_string(Record#ets_item_template.name),
					DescriptionBin 		= create_template_all:write_string(Record#ets_item_template.description),
					Free_propertyBin 	= create_template_all:write_string(Record#ets_item_template.free_property),
					Regular_propertyBin = create_template_all:write_string(Record#ets_item_template.regular_property),
					Hide_propertyBin 	= create_template_all:write_string(Record#ets_item_template.hide_property),
					Attach_skillBin 	= create_template_all:write_string(Record#ets_item_template.attach_skill),
					ScriptBin 			= create_template_all:write_string(Record#ets_item_template.script),
					
					<<(Record#ets_item_template.category_id):32/signed,
					  (Record#ets_item_template.template_id):32/signed,
					  NameBin/binary,
					  (Record#ets_item_template.pic):32/signed,
					  (Record#ets_item_template.icon):32/signed,
					  DescriptionBin/binary,
					  (Record#ets_item_template.quality):32/signed,
					  (Record#ets_item_template.need_level):32/signed,
					  (Record#ets_item_template.need_sex):32/signed,
					  (Record#ets_item_template.need_career):32/signed,
					  (Record#ets_item_template.max_count):32/signed,
					  (Record#ets_item_template.attack):32/signed,
					  (Record#ets_item_template.defense):32/signed,
					  (Record#ets_item_template.sell_copper):32/signed,
					  (Record#ets_item_template.sell_type):32/signed,
%% 					  (Record#ets_item_template.copper):32/signed,
%% 					  (Record#ets_item_template.yuan_bao):32/signed,				  
%% 					  (Record#ets_item_template.bind_copper):32/signed,
%% 					  (Record#ets_item_template.bind_yuan_bao):32/signed,
     				  (Record#ets_item_template.suit_id):32/signed,
					  (Record#ets_item_template.repair_modulus):32/signed,
					  (Record#ets_item_template.bind_type):32/signed,
					  (Record#ets_item_template.durable_upper):32/signed,
					  (Record#ets_item_template.cd):32/signed,
					  (Record#ets_item_template.can_use):8,
					  (Record#ets_item_template.can_strengthen):8,
					  (Record#ets_item_template.can_enchase):8,
					  (Record#ets_item_template.can_rebuild):8,
					  (Record#ets_item_template.can_recycle):8,
					  (Record#ets_item_template.can_improve):8,
					  (Record#ets_item_template.can_unbind):8,
					  (Record#ets_item_template.can_repair):8,
					  (Record#ets_item_template.can_destroy):8,
					  (Record#ets_item_template.can_sell):8,
					  (Record#ets_item_template.can_trade):8,
					   Free_propertyBin/binary,
					   Regular_propertyBin/binary,
					   Hide_propertyBin/binary,
					   Attach_skillBin/binary,
					  (Record#ets_item_template.hide_attack):32/signed,
					  (Record#ets_item_template.hide_defense):32/signed,
					  (Record#ets_item_template.valid_time):32/signed,
					   ScriptBin/binary,
					   (Record#ets_item_template.propert1):32/signed,
					   (Record#ets_item_template.propert2):32/signed,
					   (Record#ets_item_template.propert3):32/signed,
					   (Record#ets_item_template.propert4):32/signed,
					   (Record#ets_item_template.propert5):32/signed,
					   (Record#ets_item_template.propert6):32/signed,
					  (Record#ets_item_template.propert7):32/signed,
					  (Record#ets_item_template.propert8):32/signed>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.



%%
%% Local Functions
%%

