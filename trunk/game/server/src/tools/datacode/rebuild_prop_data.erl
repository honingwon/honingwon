%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to rebuild_prop_data
-module(rebuild_prop_data).

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
					list_to_tuple([ets_rebuild_prop_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_rebuild_prop_template", "get/1", "洗练属性几率模板数据表"),
    F =
    fun(RebuildPropInfo) ->
        Header = header(RebuildPropInfo#ets_rebuild_prop_template.quality),
        Body = body(RebuildPropInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_rebuild_prop_template{quality = Quality,
					  prop_num = PropNum,
        			  rate = Rate,
					  section1 = Section1,
					  section2 = Section2,
					  section3 = Section3,
					  section4 = Section4,
					  section5 = Section5
    } = Info,
    io_lib:format(
    "    #ets_exp_template{quality = ~p,\n"
    "					  prop_num = ~p,\n"
    " 					  rate = ~p,\n"
    " 					  section1 = ~p,\n"
    " 					  section2 = ~p,\n"
    " 					  section3 = ~p,\n"
	"					  section4 = ~p,\n"
    " 					  section5 = ~p\n"				 				 				 				 
    "    };\n",
    [Quality, PropNum, Rate, Section1, Section2, Section3, Section4, Section5]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

