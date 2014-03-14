%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to daily_award_data
-module(daily_award_data).

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
					list_to_tuple([ets_daily_award_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_daily_award_template", "get/1", "每日奖励模板数据表"),
    F =
    fun(DailyAwardInfo) ->
        Header = header(DailyAwardInfo#ets_daily_award_template.award_id),
        Body = body(DailyAwardInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_daily_award_template{award_id = AwardId,
					  need_seconds = NeedSeconds,
        			  copper = Copper,
					  bind_copper = BindCopper,
					  yuan_bao = YuanBao,
					  bind_yuan_bao = BindYuanBao,
					  item_template_id = ItemTemplateId,
					  item_number = ItemNumber,
					  item_isbind = ItemIsbind
    } = Info,
    io_lib:format(
    "    #ets_exp_template{award_id = ~p,\n"
    "					  need_seconds = ~p,\n"
    " 					  copper = ~p,\n"
    " 					  bind_copper = ~p,\n"
    " 					  yuan_bao = ~p,\n"
    " 					  bind_yuan_bao = ~p,\n"
	"					  item_template_id = ~p,\n"
    " 					  item_number = ~p,\n"
	" 					  item_isbind = ~p\n"				 				 				 				 
    "    };\n",
    [AwardId, NeedSeconds, Copper, BindCopper, YuanBao, BindYuanBao, ItemTemplateId, ItemNumber, ItemIsbind]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

