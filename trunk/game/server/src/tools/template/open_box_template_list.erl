%% Author: 
%% Created: 
%% Description: 
-module(open_box_template_list).

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
	
					Record = list_to_tuple([ets_open_box_template] ++ Info),
					Bin = create_template_all:write_string(Record#ets_open_box_template.itemlist),	
					
					<<
					(Record#ets_open_box_template.type):32/signed,
				    Bin/binary
				                
					>>					  
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.
%%
%% Local Functions
%%

