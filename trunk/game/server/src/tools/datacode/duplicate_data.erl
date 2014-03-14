%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to duplicate_data
-module(duplicate_data).

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
					list_to_tuple([ets_duplicate_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_duplicate_template", "get/1", "副本模板数据表"),
    F =
    fun(DuplicateInfo) ->
        Header = header(DuplicateInfo#ets_duplicate_template.duplicate_id),
        Body = body(DuplicateInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_duplicate_template{duplicate_id =DuplicateId ,	
      						day_times =DayTimes , 
      						npc = Npc,
      						recommend = Recommend,
      						type = Type,
      						showtype = Showtype,
      						min_level = MinLevel,	
      						max_level = MaxLevel,
      						min_player = MinPlayer,
      						max_player = MaxPlayer,
      						need_yuan_bao = NeedYuanBao,
     						need_bind_yuan_bao = NeedBindYuanBao,	
      						need_copper = NeedCopper,	
      						need_bind_copper = NeedBindCopper,	
      						need_item_id = NeedItemId,
      						mission = Mission,	
      						award_id = AwardId,
      						can_reset = CanReset,	
      						map_id = MapId,	
      						pos_x = PosX,
      						pos_y = PosY,
      						total_time = TotalTime,
							is_dynamic =IsDynamic,	
      						task_id = TaskId
    } = Info,
    io_lib:format(
    "    #ets_exp_template{duplicate_id = ~p,\n"
    " 					  day_times = ~p,\n"
    " 					  npc = ~p,\n"
    " 					  recommend = ~p,\n"
	"					  type = ~p,\n"
    " 					  showtype = ~p,\n"
    " 					  min_level = ~p,\n"
    " 					  max_level = ~p,\n"
	" 					  min_player = ~p,\n"
	" 					  max_player = ~p,\n"
    " 					  need_yuan_bao = ~p,\n"
	"					  need_bind_yuan_bao = ~p,\n"
    " 					  need_copper = ~p,\n"
    " 					  need_bind_copper = ~p,\n"
    " 					  need_item_id = ~p,\n"
    " 					  mission = ~p,\n"
	"					  award_id = ~p,\n"
    " 					  can_reset = ~p,\n"
    " 					  map_id = ~p,\n"
    " 					  pos_x = ~p,\n"
    " 					  pos_y = ~p,\n"
	"					  total_time = ~p,\n"
	" 					  is_dynamic = ~p,\n"
	"					  task_id = ~p\n"				 				 				 				 
    "    };\n",
    [DuplicateId, DayTimes, Npc, Recommend, Type, Showtype,
	 MinLevel, MaxLevel, MinPlayer, MaxPlayer, NeedYuanBao, NeedBindYuanBao, NeedCopper, 
	 NeedBindCopper, NeedItemId, Mission, AwardId, CanReset, 
	 MapId, PosX, PosY, TotalTime, IsDynamic, TaskId]).

last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

