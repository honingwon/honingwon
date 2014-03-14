%% Author: Administrator
%% Created: 2011-4-19
%% Description: 
-module(streng_template_list).

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
					Record = list_to_tuple([ets_streng_rate_template] ++ Info),				
					PropsBin = create_template_all:write_string(Record#ets_streng_rate_template.props),
					<<(Record#ets_streng_rate_template.id):32/signed,
					  (Record#ets_streng_rate_template.category_id):32/signed,
					  (Record#ets_streng_rate_template.streng_level):32/signed,
					  (Record#ets_streng_rate_template.streng_rates):32/signed,
					  PropsBin/binary
					  >>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%%

