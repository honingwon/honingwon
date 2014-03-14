%% Author: Administrator
%% Created: 2011-5-26
%% Description: TODO: Add description to sit_award_data
-module(sit_award_data).

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
					list_to_tuple([ets_sit_award_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),

	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_sit_award_template", "get/1", "打坐奖励模板数据表"),
    F =
    fun(SitAwardInfo) ->
        Header = header(SitAwardInfo#ets_sit_award_template.level),
        Body = body(SitAwardInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_sit_award_template{level = Level,
					  single_exp = SingleExp,
					  normal_double_exp = NormalDoubleExp,
					  special_double_exp = SpecialDoubleExp,
					  single_lifeexp = SingleLifeExp,
					  normal_double_lifeexp = NormalDoubleLifeExp,
					  special_double_lifeexp = SpecialDoubleLifeExp,
					  hp = Hp,
					  mp = Mp		
    } = Info,
    io_lib:format(
    "    #ets_sit_award_template{level = ~p,\n"
    "					  single_exp = ~p,\n"
    " 					  normal_double_exp = ~p,\n"
    " 					  special_double_exp = ~p,\n"
    " 					  single_lifeexp = ~p,\n"
    " 					  normal_double_lifeexp = ~p,\n"
    " 					  special_double_lifeexp = ~p,\n"	
	" 					  hp = ~p,\n"
    " 					  mp = ~p\n"				 				 				 				 
    "    };\n",
    [Level, SingleExp, NormalDoubleExp, SpecialDoubleExp, SingleLifeExp, NormalDoubleLifeExp, SpecialDoubleLifeExp, Hp, Mp]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

