%% Author: Administrator
%% Created: 2011-5-26
%% Description: TODO: Add description to streng_rate_data
-module(streng_rate_data).

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
	FInfo = fun(Info) ->
					list_to_tuple([ets_streng_rate_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_streng_rate_template", "get/1", "强化成功几率加成模板数据表"),
    F =
    fun(StrengRateInfo) ->
        Header = header(StrengRateInfo#ets_streng_rate_template.id),
        Body = body(StrengRateInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_streng_rate_template{id = Id,
					  category_id = CategoryId,
					  streng_level = StrengLevel,
					  streng_rates = StrengRates,
					  props = Props				  
    } = Info,
	

	BuffData = tool:split_string_to_intlist(Props),
	
	F = fun(Buff, List) ->
			    case Buff of
						   {Type1, Value} 
							 ->
							   lists:concat([List, "{", Type1, ",", Value, "},"]);
						   _ ->
							   List
					   end
		end,
	TempListData = lists:foldl(F, [], BuffData),	
	
	if
		length(TempListData) > 0 ->
			TempList1 = lists:sublist(TempListData, 1, length(TempListData) -1),
			InfoListData = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoListData = "[]"
	end,
	
	
    io_lib:format(
    "    #ets_streng_rate_template{id = ~p,\n"
	" 					  category_id = ~p,\n"
	" 					  streng_level = ~p,\n"
	" 					  streng_rates = ~p,\n"
    " 					  props = ~p\n"				 				 				 				 
    "    };\n",
    [Id,CategoryId, StrengLevel,StrengRates,InfoListData]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

