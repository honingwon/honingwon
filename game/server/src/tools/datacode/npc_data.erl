%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to npc_data
-module(npc_data).

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
					list_to_tuple([ets_npc_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_npc_template", "get/1", "NPC模板数据表"),
    F =
    fun(NpcInfo) ->
        Header = header(NpcInfo#ets_npc_template.npc_id),
        Body = body(NpcInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_npc_template{npc_id = NpcId,
					  map_id = MapId,
					  pos_x = PosX,
					  pos_y = PosY
    } = Info,
    io_lib:format(
    "    #ets_exp_template{npc_id = ~p,\n"
    " 					  map_id = ~p,\n"
	"					  pos_x = ~p,\n"
    " 					  pos_y = ~p\n"				 				 				 				 
    "    };\n",
    [NpcId, MapId, PosX, PosY]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

