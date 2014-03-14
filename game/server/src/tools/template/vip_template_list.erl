%% Author: 
%% Created: 
%% Description: 
-module(vip_template_list).

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
	
					Record = list_to_tuple([ets_vip_template] ++ Info),
					NameBin = create_template_all:write_string(Record#ets_vip_template.vip_name),
					<<
					(Record#ets_vip_template.vip_id):32/signed,
					NameBin/binary,				
					(Record#ets_vip_template.effect_date):32/signed,
					(Record#ets_vip_template.yuanbao):32/signed,
					(Record#ets_vip_template.tranfer_shoe):32/signed,			
					(Record#ets_vip_template.exp_rate):32/signed,
					(Record#ets_vip_template.strength_rate):32/signed,
					(Record#ets_vip_template.hole_rate):32/signed,
					(Record#ets_vip_template.lifeexp_rate):32/signed,
					(Record#ets_vip_template.title_id):32/signed				
					>>
					  
					  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

