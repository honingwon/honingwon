%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to active_rewards_data
-module(active_rewards_data).

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
					list_to_tuple([ets_active_rewards_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_active_rewards_template", "get/1", "活跃度奖励模板数据表"),
    F =
    fun(ActiveRewardsInfo) ->
        Header = header(ActiveRewardsInfo#ets_active_rewards_template.num),
        Body = body(ActiveRewardsInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_active_rewards_template{num = Num,
					  need_active = NeedActive,
					  rewards_exp = RewardsExp,
					  bind_copper = BindCopper
    } = Info,
    io_lib:format(
    "    #ets_exp_template{num = ~p,\n"
	" 					  need_active = ~p\n"		
	" 					  rewards_exp = ~p\n"				
	" 					  bind_copper = ~p\n"				 				 				 				 
    "    };\n",
    [Num, NeedActive, RewardsExp, BindCopper]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

