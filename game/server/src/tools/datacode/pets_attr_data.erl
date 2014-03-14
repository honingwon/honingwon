%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to pets_attr_data
-module(pets_attr_data).

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
					list_to_tuple([ets_pets_attr_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_pets_attr_template", "get/1", "宠物基础属性模板数据表"),
    F =
    fun(PetsAttrInfo) ->
        Header = header(PetsAttrInfo#ets_pets_attr_template.template_id),
        Body = body(PetsAttrInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_pets_attr_template{template_id = TemplateId,
					  level = Level,
        			  attack = Attack,
					  defence = Defence,
					  duck = Duck,
					  hit_target = HitTarget,
					  attack_q = AttackQ,
					  defence_q = DefenceQ,
					  duck_q = DuckQ,
					  hit_target_q = HitTargetQ,
					  update_exp = UpdateExp,
					  total_exp = TotalExp
    } = Info,
    io_lib:format(
    "    #ets_exp_template{template_id = ~p,\n"
    "					  level = ~p,\n"
    " 					  attack = ~p,\n"
    " 					  defence = ~p,\n"
    " 					  duck = ~p,\n"
    " 					  hit_target = ~p,\n"
	"					  attack_q = ~p,\n"
    " 					  defence_q = ~p,\n"
    " 					  duck_q = ~p,\n"
    " 					  hit_target_q = ~p,\n"
	" 					  update_exp = ~p,\n"
    " 					  total_exp = ~p\n"				 				 				 				 
    "    };\n",
    [TemplateId, Level, Attack, Defence, Duck, HitTarget, AttackQ,
	 DefenceQ, DuckQ, HitTargetQ, UpdateExp, TotalExp]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

