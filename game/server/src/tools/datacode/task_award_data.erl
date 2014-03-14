%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to task_award_data
-module(task_award_data).

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
					list_to_tuple([ets_task_award_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_task_award_template", "get/1", "任务奖励模板数据表"),
    F =
    fun(TaskAwardInfo) ->
        Header = header(TaskAwardInfo#ets_task_award_template.award_id),
        Body = body(TaskAwardInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_task_award_template{award_id = AwardId,
					  sex = Sex,
        			  career = Career,
					  template_id = TemplateId,
					  amount = Amount,
					  validate = Validate,
					  is_bind = IsBind
    } = Info,
    io_lib:format(
    "    #ets_exp_template{award_id = ~p,\n"
    "					  sex = ~p,\n"
    " 					  career = ~p,\n"
    " 					  template_id = ~p,\n"
	" 					  amount = ~p,\n"
	" 					  validate = ~p,\n"
    " 					  is_bind = ~p\n"				 				 				 				 
    "    };\n",
    [AwardId, Sex, Career, TemplateId, Amount, Validate, IsBind]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

