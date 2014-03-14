%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to streng_addsuccrate_data
-module(streng_addsuccrate_data).

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
					list_to_tuple([ets_streng_addsuccrate_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_streng_addsuccrate_template", "get/1", "强化失败附加成功率模板数据表"),
    F =
    fun(StrengAddsuccrateInfo) ->
        Header = header(StrengAddsuccrateInfo#ets_streng_addsuccrate_template.failacount),
        Body = body(StrengAddsuccrateInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_streng_addsuccrate_template{failacount = Failacount,
					  addsuccrate = Addsuccrate
    } = Info,
    io_lib:format(
    "    #ets_exp_template{failacount = ~p,\n"
    " 					  addsuccrate = ~p\n"				 				 				 				 
    "    };\n",
    [Failacount, Addsuccrate]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

