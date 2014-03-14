%% Author: Administrator
%% Created: 2011-5-30
%% Description: TODO: Add description to title_data
-module(title_data).

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
					list_to_tuple([ets_title_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_title_template", "get/1", "人物称号模板数据表"),
    F =
    fun(TitleInfo) ->
        Header = header(TitleInfo#ets_title_template.id),
        Body = body(TitleInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_title_template{id = Id,
        			  type = Type,
					  character = Character,
					  data = Data
    } = Info,
	
	
	BuffData = tool:split_string_to_intlist(Data),

	
	F = fun(Buff, List) ->
			    case Buff of
						   {Type1, Value} 
							 ->
							   lists:concat([List, "{", Type1, ",", Value, "},"]);
						   {Type1, Type2, Value}->
							   lists:concat([List, "{", Type1, ",", Type2, ",", Value, "},"]);
						   _ ->
							   List
					   end
		end,
	TempList = lists:foldl(F, [], BuffData),	
	
	if
		length(TempList) > 0 ->
			TempList1 = lists:sublist(TempList, 1, length(TempList) -1),
			InfoList = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoList = "[]"
	end,	
	
	
	
    io_lib:format(
    "    #ets_exp_template{id = ~p,\n"
    " 					  type = ~p,\n"
    " 					  character = ~p,\n"
	" 					  data = ~s\n"				 				 				 				 
    "    };\n",
    [Id, Type, Character, InfoList]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

