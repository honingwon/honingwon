%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to hole_data
-module(hole_data).

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
					list_to_tuple([ets_hole_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_hole_template", "get/1", "打孔模板数据表"),
    F =
    fun(HoleInfo) ->
        Header = header(HoleInfo#ets_hole_template.holeflag),
        Body = body(HoleInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_hole_template{holeflag = Holeflag,
					  enchase1 = Enchase1,
        			  enchase2 = Enchase2,
					  enchase3 = Enchase3,
					  enchase4 = Enchase4,
					  enchase5 = Enchase5
    } = Info,
    io_lib:format(
    "    #ets_exp_template{holeflag = ~p,\n"
    "					  enchase1 = ~p,\n"
    " 					  enchase2 = ~p,\n"
    " 					  enchase3 = ~p,\n"
	"					  enchase4 = ~p,\n"
	" 					  enchase5 = ~p\n"				 				 				 				 
    "    };\n",
    [Holeflag, Enchase1, Enchase2, Enchase3, Enchase4, Enchase5]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

