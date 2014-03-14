%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to task_state_data
-module(task_state_data).

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
					list_to_tuple([ets_task_state_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_task_state_template", "get/1", "任务状态模板数据表"),
    F =
    fun(TaskStateInfo) ->
        Header = header(TaskStateInfo#ets_task_state_template.task_state_id),
        Body = body(TaskStateInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_task_state_template{task_state_id = TaskStateId,
					  task_id = TaskId,
        			  condition = Condition,
					  npc = Npc,
					  can_transfer = CanTransfer,
					  data = Data,
					  award_yuan_bao = AwardYuanBao,
					  award_bind_yuan_bao = AwardBindYuanBao,
					  award_copper = AwardCopper,
					  award_bind_copper = AwardBindCopper,
					  award_exp = AwardExp,
					  award_life_experience = AwardLifeExperience,
					  task_award_id = TaskAwardId
    } = Info,
	
	
	BuffData = tool:split_string_to_intlist(Data),
	
	AwardId = binary_to_list(TaskAwardId),
	
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
	TempListData = lists:foldl(F, [], BuffData),	
	
	if
		length(TempListData) > 0 ->
			TempList1 = lists:sublist(TempListData, 1, length(TempListData) -1),
			InfoListData = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoListData = "[]"
	end,

	
    io_lib:format(
    "    #ets_exp_template{task_state_id = ~p,\n"
    "					  task_id = ~p,\n"
    " 					  condition = ~p,\n"
    " 					  npc = ~p,\n"
    " 					  can_transfer = ~p,\n"
    " 					  data = ~s,\n"
    " 					  award_yuan_bao = ~p,\n"
    " 					  award_bind_yuan_bao = ~p,\n"
	" 					  award_copper = ~p,\n"
	" 					  award_bind_copper = ~p,\n"
    " 					  award_exp = ~p,\n"
	"					  award_life_experience = ~p,\n"
    " 					  task_award_id = [~s]\n"				 				 				 				 
    "    };\n",
    [TaskStateId, TaskId, Condition, Npc, CanTransfer, 
	 InfoListData, AwardYuanBao, AwardBindYuanBao, AwardCopper, AwardBindCopper, AwardExp, AwardLifeExperience, 
	 AwardId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

