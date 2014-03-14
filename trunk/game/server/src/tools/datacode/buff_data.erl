%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to buff_data
-module(buff_data).

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
					list_to_tuple([ets_buff_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_buff_template", "get/1", "状态模板数据表"),
    F =
    fun(BuffInfo) ->
        Header = header(BuffInfo#ets_buff_template.buff_id),
        Body = body(BuffInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_buff_template{buff_id = BuffId,
					  group_id = GroupId,
					  type = Type,
					  hit_percent = HitPercent,
					  active_percent = ActivePercent,
					  active_timespan = ActiveTimespan,
					  active_totaltime = ActiveTotaltime,
					  limit_totaltime = LimitTotaltime,
					  skill_effect_list = SkillEffectList,
					  merge_type = MergeType,
					  replace_buffids = ReplaceBuffids,
					  cant_createbuffids = CantCreatebuffids
    } = Info,
	
	
	
	BuffEffect = tool:split_string_to_intlist(SkillEffectList),
	
	F = fun(Buff, List) ->
			    case Buff of
						   {Type3, Value} 
							 ->
							   lists:concat([List, "{", Type3, ",", Value, "},"]);
						   {Type1, Type2, Value}->
							   lists:concat([List, "{", Type1, ",", Type2, ",", Value, "},"]);
						   _ ->
							   List
					   end
		end,
	TempList = lists:foldl(F, [], BuffEffect),
	
	
	if
		length(TempList) > 0 ->
			TempList1 = lists:sublist(TempList, 1, length(TempList) -1),
			InfoList = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoList = "[]"
	end,	
	
	
	
    io_lib:format(
    "    #ets_exp_template{buff_id = ~p,\n"
    "					  group_id = ~p,\n"
    " 					  type = ~p,\n"
    " 					  hit_percent = ~p,\n"
    " 					  active_percent = ~p,\n"
	"					  active_timespan = ~p,\n"
    " 					  active_totaltime = ~p,\n"
	" 					  limit_totaltime = ~p,\n"
    " 					  skill_effect_list = ~s,\n"
	" 					  merge_type = ~p,\n"
    " 					  replace_buffids = ~p,\n"
	" 					  cant_createbuffids = ~p\n"				 				 				 				 
    "    };\n",
    [BuffId, GroupId, Type, HitPercent, ActivePercent, ActiveTimespan, ActiveTotaltime, LimitTotaltime, 
	 InfoList, MergeType, ReplaceBuffids, CantCreatebuffids]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

