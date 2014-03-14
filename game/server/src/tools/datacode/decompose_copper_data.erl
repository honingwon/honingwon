%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to decompose_data
-module(decompose_copper_data).

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
					list_to_tuple([ets_decompose_copper_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_decompose_copper_template", "get/1", "铜币分解模板数据表"),
    F =
    fun(DecomposeCopperInfo) ->
        Header = header(DecomposeCopperInfo#ets_decompose_copper_template.quality),
        Body = body(DecomposeCopperInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_decompose_copper_template{quality = Quality,
      						needcopper = Needcopper
    } = Info,
    io_lib:format(
    "    #ets_exp_template{quality = ~p,\n"
    " 					  needcopper = ~p\n"				 				 				 				 
    "    };\n",
    [Quality, Needcopper]).

last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

