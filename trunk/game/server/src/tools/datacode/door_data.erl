%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to door_data
-module(door_data).

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
					list_to_tuple([ets_door_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_door_template", "get/1", "跳转门模板数据表"),
    F =
    fun(DoorInfo) ->
        Header = header(DoorInfo#ets_door_template.door_id),
        Body = body(DoorInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_door_template{door_id = DoorId,
      						current_map_id = CurrentMapId,
      						next_map_id =NextMapId , 
      						next_door_id = NextDoorId,
      						pos_x = PosX,
      						pos_y = PosY,	
      						other_data = OtherData
    } = Info,
    io_lib:format(
    "    #ets_exp_template{door_id = ~p,\n"
    " 					  current_map_id = ~p,\n"
    " 					  next_map_id = ~p,\n"
    " 					  next_door_id = ~p,\n"
    " 					  pos_x = ~p,\n"
	"					  pos_y = ~p,\n"
	" 					  other_data = ~p\n"				 				 				 				 
    "    };\n",
    [DoorId, CurrentMapId, NextMapId, NextDoorId, PosX, PosY, OtherData]).

last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

