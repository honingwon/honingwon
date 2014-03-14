%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to duplicate_mission_data
-module(duplicate_mission_data).

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
					list_to_tuple([ets_duplicate_mission_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_duplicate_mission_template", "get/1", "副本关卡模板数据表"),
    F =
    fun(DuplicateMissionInfo) ->
        Header = header(DuplicateMissionInfo#ets_duplicate_mission_template.mission_id),
        Body = body(DuplicateMissionInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_duplicate_mission_template{mission_id = MissionId,	
      					  need_times = NeedTimes,	
      					  code_id = CodeId,
      					  map_id = MapId,      
      					  pos_x = PosX,               
      					  pos_y = PosY ,      	
      					  monster_list = MonsterList ,
      					  script = Script , 
      					  award_id = AwardId
    } = Info,
    io_lib:format(
    "    #ets_exp_template{mission_id = ~p,\n"
    " 					  need_times = ~p,\n"
    " 					  code_id = ~p,\n"
    " 					  map_id = ~p,\n"
	"					  pos_x = ~p,\n"
    " 					  pos_y = ~p,\n"
    " 					  monster_list = ~p,\n"
    " 					  script = ~p,\n"
	" 					  award_id = ~p\n"				 				 				 				 
    "    };\n",
    [MissionId, NeedTimes, CodeId, MapId, PosX, PosY,
	 MonsterList, Script, AwardId]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

