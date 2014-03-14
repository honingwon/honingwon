%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to shop_template_list
-module(shop_discount_template_list).

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
					Record = list_to_tuple([ets_shop_discount_template] ++ Info),
					
%% 					StartTimeBin = create_template_all:write_string(Record#ets_shop_discount_template.start_time),
%% 					FinishTimeBin = create_template_all:write_string(Record#ets_shop_discount_template.finish_time),
					StartDateBin = create_template_all:write_string(Record#ets_shop_discount_template.start_date),
					FinishDateBin = create_template_all:write_string(Record#ets_shop_discount_template.finish_date),
					
					<<(Record#ets_shop_discount_template.id):32/signed,
					  (Record#ets_shop_discount_template.template_id):32/signed,
					  (Record#ets_shop_discount_template.state):32/signed,
					  (Record#ets_shop_discount_template.pay_type):32/signed,
					  (Record#ets_shop_discount_template.price):32/signed,
					  (Record#ets_shop_discount_template.old_price):32/signed,
					  (Record#ets_shop_discount_template.is_bind):8,
					  (Record#ets_shop_discount_template.max_count):32/signed,
					   StartDateBin/binary,
					   FinishDateBin/binary,
					  (Record#ets_shop_discount_template.start_time):32/signed,
					  (Record#ets_shop_discount_template.finish_time):32/signed,
					  (Record#ets_shop_discount_template.which_day):8>>
			   end,

	Bin = tool:to_binary([FInfo(X)||X <- Infos]),
	{ok, <<Len:32/signed, Bin/binary>>}.

%%
%% Local Functions
%% 


