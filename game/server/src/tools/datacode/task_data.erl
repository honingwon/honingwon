%% Author: Administrator
%% Created: 2011-5-30
%% Description: TODO: Add description to task_data
-module(task_data).

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
					list_to_tuple([ets_task_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_task_template", "get/1", "任务模板数据表"),
    F =
    fun(TaskInfo) ->
        Header = header(TaskInfo#ets_task_template.task_id),
        Body = body(TaskInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_task_template{task_id = TaskId,
					  min_level = MinLevel,
        			  max_level = MaxLevel,
					  camp = Camp,
					  career = Career,
					  sex = Sex,
					  type = Type,
					  need_copper = NeedCopper,
					  need_item_id = NeedItemId,
					  pre_task_id = PreTaskId,
					  next_task_id = NextTaskId,
					  can_repeat = CanRepeat,
					  can_jump = CanJump,
					  can_reset = CanReset,
					  can_entrust = CanEntrust,
					  entrust_time = EntrustTime,
					  entrust_copper = EntrustCopper,
					  entrust_yuan_bao = EntrustYuanBao,
					  repeat_count = RepeatCount,
        			  repeat_day = RepeatDay,
					  time_limit = TimeLimit,
					  begin_date = BeginDate,
					  end_date = EndDate,
					  can_transfer = CanTransfer,
					  npc = Npc,
					  condition = Condition,
					  award_yuan_bao = AwardYuanBao,
					  award_copper = AwardCopper,
					  award_bind_copper = AwardBindCopper,
					  award_exp = AwardExp,
					  task_award_id = TaskAwardId,
					  show_level = ShowLevel,
					  auto_accept = AutoAccept,
					  auto_finish = AutoFinish
    } = Info,
    io_lib:format(
    "    #ets_exp_template{task_id = ~p,\n"
    "					  min_level = ~p,\n"
    " 					  max_level = ~p,\n"
    " 					  camp = ~p,\n"
    " 					  career = ~p,\n"
    " 					  sex = ~p,\n"
	"					  type = ~p,\n"
    " 					  need_copper = ~p,\n"
    " 					  need_item_id = ~p,\n"
    " 					  pre_task_id = ~p,\n"
	" 					  next_task_id = ~p,\n"
	" 					  can_repeat = ~p,\n"
    " 					  can_jump = ~p,\n"
	"					  can_reset = ~p,\n"
    " 					  can_entrust = ~p,\n"
    " 					  entrust_time = ~p,\n"
    " 					  entrust_copper = ~p,\n"
    " 					  entrust_yuan_bao = ~p,\n"
	"					  repeat_count = ~p,\n"
    " 					  repeat_day = ~p,\n"
    " 					  time_limit = ~p,\n"
    " 					  begin_date = ~p,\n"
    " 					  end_date = ~p,\n"
    " 					  can_transfer = ~p,\n"
	" 					  npc = ~p,\n"
	" 					  condition = ~p,\n"
    " 					  award_yuan_bao = ~p,\n"
	"					  award_copper = ~p,\n"
    " 					  award_bind_copper = ~p,\n"
    " 					  award_exp = ~p,\n"
    " 					  task_award_id = ~p,\n"
	" 					  show_level = ~p,\n"
    " 					  auto_accept = ~p,\n"
	"					  auto_finish = ~p\n"				 				 				 				 
    "    };\n",
    [TaskId, MinLevel, MaxLevel, Camp, Career, Sex, Type, NeedCopper,
	 NeedItemId, PreTaskId, NextTaskId, CanRepeat, CanJump, CanReset, CanEntrust, 	 
	 EntrustTime, EntrustCopper, EntrustYuanBao, RepeatCount, RepeatDay, 
	 TimeLimit, BeginDate, EndDate, CanTransfer, 
	 Npc, Condition, AwardYuanBao, AwardCopper, AwardBindCopper, AwardExp, TaskAwardId, 
	 ShowLevel, AutoAccept, AutoFinish]).

last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

