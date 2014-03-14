%% Author: Administrator
%% Created: 2011-5-28
%% Description: TODO: Add description to collect_data
-module(collect_data).

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
					list_to_tuple([ets_collect_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_collect_template", "get/1", "采集模板数据表"),
    F =
    fun(CollectInfo) ->
        Header = header(CollectInfo#ets_collect_template.template_id),
        Body = body(CollectInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_collect_template{template_id = TemplateId,
					  type = Type,
					  min_level = MinLevel,
					  max_level = MaxLevel,
					  award_hp = AwardHp,
					  award_mp = AwardMp,
					  award_life_experiences = AwardLifeExperiences,
					  award_exp = AwardExp,
					  award_yuan_bao = AwardYuanBao,
					  award_bind_yuan_bao = AwardBindYuanBao,
					  award_bind_copper = AwardBindCopper,
					  award_copper = AwardCopper,
					  award_item = AwardItem,
					  collect_time = CollectTime,
					  reborn_time = RebornTime,
					  map_id = MapId,
					  lbornl_points = LbornlPoints,
					  quality = Quality,
					  script = Script
    } = Info,
	
	
	
	
	BuffData2 = binary_to_list(LbornlPoints),
	He = string:tokens(BuffData2, "|"),
	
	F1 = fun(Elem,List) ->
				lists:concat([List,"[",Elem,"],"])
		end,
	Buff = lists:foldl(F1, [], He),
	TempList2 = lists:sublist(Buff, 1, length(Buff) -1),
	InfoListData2 = lists:concat(["[", TempList2, "]"]),
	
	
	
	
	
	
	
    io_lib:format(
    "    #ets_exp_template{template_id = ~p,\n"
    " 					  type = ~p,\n"
    " 					  min_level = ~p,\n"
    " 					  max_level = ~p,\n"
	"					  award_hp = ~p,\n"
    " 					  award_mp = ~p,\n"
    " 					  award_life_experiences = ~p,\n"
    " 					  award_exp = ~p,\n"
	" 					  award_yuan_bao = ~p,\n"
	" 					  award_bind_yuan_bao = ~p,\n"
    " 					  award_bind_copper = ~p,\n"
	"					  award_copper = ~p,\n"
    " 					  award_item = ~p,\n"
    " 					  collect_time = ~p,\n"
    " 					  reborn_time = ~p,\n"
	"					  map_id = ~p,\n"
    " 					  lbornl_points = ~s,\n"
    " 					  quality = ~p,\n"
	" 					  script = ~p\n"				 				 				 				 
    "    };\n",
    [TemplateId, Type, MinLevel, MaxLevel, AwardHp, AwardMp,
	 AwardLifeExperiences, AwardExp, AwardYuanBao, AwardBindYuanBao, AwardBindCopper, AwardCopper, AwardItem, 
	 CollectTime, RebornTime, MapId, 
	 InfoListData2, Quality, Script]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

