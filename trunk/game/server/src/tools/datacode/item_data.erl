%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to item_data
-module(item_data).

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
					list_to_tuple([ets_item_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_item_template", "get/1", "物品模板数据表"),
    F =
    fun(ItemInfo) ->
        Header = header(ItemInfo#ets_item_template.template_id),
        Body = body(ItemInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_item_template{template_id = TemplateId,
					  category_id = CategoryId,
					  quality = Quality,
					  need_level = NeedLevel,
					  need_sex = NeedSex,
					  need_career = NeedCareer,
					  max_count = MaxCount,
					  attack = Attack,
					  defense = Defense,
					  sell_copper = SellCopper,
					  sell_type = SellType,
					  copper = Copper,
					  bind_copper = BindCopper,
					  yuan_bao = YuanBao,
					  bind_yuan_bao = BindYuanBao,
					  suit_id = SuitId,
					  repair_modulus = RepairModulus,
        			  bind_type = BindType,
					  durable_upper = DurableUpper,
					  cd = Cd,
					  can_use = CanUse,
					  can_lock = CanLock,
					  can_strengthen = CanStrengthen,
					  can_enchase = CanEnchase,
					  can_rebuild = CanRebuild,
					  can_recycle = CanRecycle,
					  can_improve = CanImprove,
					  can_unbind = CanUnbind,
					  can_repair = CanRepair,
					  can_destroy = CanDestroy,
					  can_sell = CanSell,
					  can_trade = CanTrade,
					  free_property = FreeProperty,
					  regular_property = RegularProperty,
					  hide_property = HideProperty,
					  attach_skill = AttachSkill,
					  hide_attack = HideAttack,
					  hide_defense = HideDefense,
					  valid_time = ValidTime,
					  script = Script,
					  propert1 = Propert1,
					  propert2 = Propert2,
					  propert3 = Propert3,
					  propert4 = Propert4,
					  propert5 = Propert5,
					  propert6 = Propert6,
					  propert7 = Propert7,
					  propert8 = Propert8
    } = Info,
	
	
	
	
	
	
	
	
	
	
	BuffData1 = tool:split_string_to_intlist(FreeProperty),
	
	F1 = fun(Buff, List) ->
			    case Buff of
						   {Value1, Value2, Value3} 
							 ->
							   lists:concat([List, "{", Value1, ",", Value2, ",", Value3, "},"]);
						   _ ->
							   List
					   end
		end,
	TempListData1 = lists:foldl(F1, [], BuffData1),	
	
	if
		length(TempListData1) > 0 ->
			TempList1 = lists:sublist(TempListData1, 1, length(TempListData1) -1),
			InfoListData1 = lists:concat(["[", TempList1, "]"]);
		true ->
			InfoListData1 = "[]"
	end,
	
	
	
	BuffData2 = tool:split_string_to_intlist(RegularProperty),
	
	F2 = fun(Buff, List) ->
			    case Buff of
						   {Value1,Value2} 
							 ->
							   lists:concat([List, "{", Value1, ",", Value2,"},"]);
						   _ ->
							   List
					   end
		end,
	TempListData2 = lists:foldl(F2, [], BuffData2),	
	
	if
		length(TempListData2) > 0 ->
			TempList2 = lists:sublist(TempListData2, 1, length(TempListData2) -1),
			InfoListData2 = lists:concat(["[", TempList2, "]"]);
		true ->
			InfoListData2 = "[]"
	end,
	
	
	
	BuffData3 = tool:split_string_to_intlist(HideProperty),
	
	F3 = fun(Buff, List) ->
			    case Buff of
						   {Value1,Value2} 
							 ->
							   lists:concat([List, "{", Value1, ",", Value2,"},"]);
						   _ ->
							   List
					   end
		end,
	TempListData3 = lists:foldl(F3, [], BuffData3),	
	
	if
		length(TempListData3) > 0 ->
			TempList3 = lists:sublist(TempListData3, 1, length(TempListData3) -1),
			InfoListData3 = lists:concat(["[", TempList3, "]"]);
		true ->
			InfoListData3 = "[]"
	end,
	
	
	
    io_lib:format(
    "    #ets_exp_template{template_id = ~p,\n"
    " 					  category_id = ~p,\n"
    " 					  quality = ~p,\n"
	"					  need_level = ~p,\n"
	"					  need_sex = ~p,\n"
	"					  need_career = ~p,\n"
    " 					  max_count = ~p,\n"
    " 					  attack = ~p,\n"
    " 					  defense = ~p,\n"
	" 					  sell_copper = ~p,\n"
	" 					  sell_type = ~p,\n"
    " 					  copper = ~p,\n"
	"					  bind_copper = ~p,\n"
    "					  yuan_bao = ~p,\n"
    " 					  bind_yuan_bao = ~p,\n"
    " 					  suit_id = ~p,\n"
    " 					  repair_modulus = ~p,\n"
    " 					  bind_type = ~p,\n"
	"					  durable_upper = ~p,\n"
    " 					  cd = ~p,\n"
    " 					  can_use = ~p,\n"
    " 					  can_lock = ~p,\n"
    " 					  can_strengthen = ~p,\n"
	"					  can_enchase = ~p,\n"
    " 					  can_rebuild = ~p,\n"
    " 					  can_recycle = ~p,\n"
    " 					  can_improve = ~p,\n"
	" 					  can_unbind = ~p,\n"
	" 					  can_repair = ~p,\n"
    " 					  can_destroy = ~p,\n"
	"					  can_sell = ~p,\n"
    " 					  can_trade = ~p,\n"
    " 					  free_property = ~s,\n"
    " 					  regular_property = ~s,\n"
    " 					  hide_property = ~s,\n"
	" 					  attach_skill = ~p,\n"
	" 					  hide_attack = ~p,\n"
    " 					  hide_defense = ~p,\n"
	"					  valid_time = ~p,\n"
    " 					  script = ~p,\n"
    " 					  propert1 = ~p,\n"
    " 					  propert2 = ~p,\n"
    " 					  propert3 = ~p,\n"
	" 					  propert4 = ~p,\n"	
    " 					  propert5 = ~p,\n"
	" 					  propert6 = ~p,\n"
	" 					  propert7 = ~p,\n"	
    " 					  propert8 = ~p\n"				 				 				 				 
    "    };\n",
    [TemplateId, CategoryId, Quality, NeedLevel, NeedSex,
	 NeedCareer, MaxCount, Attack, Defense, SellCopper, SellType, Copper, 
	 BindCopper, YuanBao, BindYuanBao, SuitId, RepairModulus, BindType, 
	 DurableUpper, Cd, CanUse, CanLock, CanStrengthen, CanEnchase, CanRebuild,
	 CanRecycle, CanImprove, CanUnbind, CanRepair, CanDestroy, CanSell, CanTrade, 
	 InfoListData1, InfoListData2, InfoListData3, AttachSkill, HideAttack, HideDefense, ValidTime,
	 Script, Propert1, Propert2, Propert3, Propert4, Propert5, Propert6, Propert7, Propert8]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

