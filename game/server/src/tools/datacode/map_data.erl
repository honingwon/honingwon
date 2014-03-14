%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to map_data
-module(map_data).

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
					list_to_tuple([ets_map_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_map_template", "get/1", "地图模板数据表"),
    F =
    fun(MapInfo) ->
        Header = header(MapInfo#ets_map_template.map_id),
        Body = body(MapInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_map_template{map_id = MapId,
					  type = Type,
					  index = Index,
					  is_open = IsOpen,
					  requirement = Requirement,
					  area = Area,
					  return_map = ReturnMap,
					  rand_point = RandPoint
    } = Info,
	
	
	BuffData1 = tool:split_string_to_intlist(Requirement),
	
	F1 = fun(Buff, List) ->
			    case Buff of
						   {Type1, Value} 
							 ->
							   lists:concat([List, "{", Type1, ",", Value, "},"]);
						   _ ->
							   List
					   end
		end,
	TempListData1 = lists:foldl(F1, [], BuffData1),	
	
	if
		length(TempListData1) > 0 ->
			TempList1 = lists:sublist(TempListData1, 1, length(TempListData1) -1),
			InfoListData1 = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoListData1 = "[]"
	end,
	
	
	
	BuffData2 = tool:split_string_to_intlist(Area),
	
	F2 = fun(Buff, List) ->
			    case Buff of
						   {Value1,Value2,Value3,Value4,Value5} 
							 ->
							   lists:concat([List, "{", Value1, ",", Value2, 
											 ",",Value3,",",Value4,",",Value5,"},"]);
						   _ ->
							   List
					   end
		end,
	TempListData2 = lists:foldl(F2, [], BuffData2),	
	
	if
		length(TempListData2) > 0 ->
			TempList2 = lists:sublist(TempListData2, 1, length(TempListData2) -1),
			InfoListData2 = lists:concat(["[", TempList2, "]"]);
		true ->
			InfoListData2 = "[]"
	end,
	
	
	
	
	BuffData3 = tool:split_string_to_intlist(ReturnMap),
	
	F3 = fun(Buff, List) ->
			    case Buff of
						   {Value1,Value2,Value3} 
							 ->
							   lists:concat([List, "{", Value1, ",", Value2, 
											 ",",Value3,"},"]);
						   _ ->
							   List
					   end
		end,
	TempListData3 = lists:foldl(F3, [], BuffData3),	
	
	if
		length(TempListData3) > 0 ->
			TempList3 = lists:sublist(TempListData3, 1, length(TempListData3) -1),
			InfoListData3 = lists:concat(["[", TempList3, "]"]);
		true ->
			InfoListData3 = "[]"
	end,
	
	
	BuffData4 = tool:split_string_to_intlist(RandPoint),
	
	F4 = fun(Buff, List) ->
			    case Buff of
						   {Value1,Value2} 
							 ->
							   lists:concat([List, "{", Value1, ",", Value2,"},"]);
						   _ ->
							   List
					   end
		end,
	TempListData4 = lists:foldl(F4, [], BuffData4),	
	
	if
		length(TempListData4) > 0 ->
			TempList4 = lists:sublist(TempListData4, 1, length(TempListData4) -1),
			InfoListData4 = lists:concat(["[", TempList4, "]"]);
		true ->
			InfoListData4 = "[]"
	end,
	
	
    io_lib:format(
    "    #ets_exp_template{map_id = ~p,\n"
    "					  type = ~p,\n"
    " 					  index = ~p,\n"
    " 					  is_open = ~p,\n"
    " 					  requirement = ~s,\n"
	"					  area = ~s,\n"
    " 					  return_map = ~s,\n"
	" 					  rand_point = ~s\n"					 				 				 				 
    "    };\n",
    [MapId, Type, Index, IsOpen, InfoListData1, InfoListData2, InfoListData3, InfoListData4]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

