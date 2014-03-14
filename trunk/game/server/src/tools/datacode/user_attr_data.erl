%% Author: Administrator
%% Created: 2011-5-27
%% Description: TODO: Add description to user_attr_data
-module(user_attr_data).

%%
%% Include files
-include("common.hrl").
%%

%%
%% Exported Functions
%%
-export([create/1]).

%%
%% API Functions
%%

create([Infos]) ->
	FInfo = fun(Info) ->
					list_to_tuple([ets_user_attr_template] ++ Info)
			end,
	List = lists:map(FInfo, Infos),
	
	gen(List).
%%
%% Local Functions
%%

%% 生成代码
gen(L) ->
	ModuleInfo = create_all_data:module_define("data_user_attr_template", "get/1", "用户属性模板数据表"),
    F =
    fun(UserAttrInfo) ->
        Header = header(UserAttrInfo#ets_user_attr_template.career),
        Body = body(UserAttrInfo),
        [Header, Body]
    end,
    [ModuleInfo, lists:map(F, L), last_clause()].


header(Id) when is_integer(Id) ->
    lists:concat(["get(", Id, ") ->\n"]).

body(Info) ->
    #ets_user_attr_template{career = Career,
					  level = Level,
        			  current_hp = CurrentHp,
					  current_mp = CurrentMp,
					  attack = Attack,
					  mump_attack = MumpAttack,
					  far_attack = FarAttack,
					  magic_attack = MagicAttack,
					  defense = Defense,
					  mump_defense = MumpDefense,
					  far_defense = FarDefense,
					  magic_defense = MagicDefense,
					  hit_target = HitTarget,
					  duck = Duck,
					  deligency = Deligency,
					  power_hit = PowerHit,
					  max_physical = MaxPhysical,
					  max_experiences = MaxExperiences,
					  mump_avoid_in_hurt = MumpAvoidInHurt,
					  far_avoid_in_hurt = FarAvoidInHurt,
					  magic_avoid_in_hurt = MagicAvoidInHurt,
					  keep_off = KeepOff,
					  attack_suppression = AttackSuppression,
					  defense_suppression = DefenseSuppression,
					  attack_speed = AttackSpeed
    } = Info,
    io_lib:format(
    "    #ets_exp_template{career = ~p,\n"
    "					  level = ~p,\n"
    " 					  current_hp = ~p,\n"
    " 					  current_mp = ~p,\n"
    " 					  attack = ~p,\n"
    " 					  mump_attack = ~p,\n"
	"					  far_attack = ~p,\n"
    " 					  magic_attack = ~p,\n"
    " 					  defense = ~p,\n"
    " 					  mump_defense = ~p,\n"
    " 					  far_defense = ~p,\n"
	"					  magic_defense = ~p,\n"
    " 					  hit_target = ~p,\n"
    " 					  duck = ~p,\n"
    " 					  deligency = ~p,\n"
    " 					  power_hit = ~p,\n"
	"					  max_physical = ~p,\n"
    " 					  max_experiences = ~p,\n"
    " 					  mump_avoid_in_hurt = ~p,\n"
    " 					  far_avoid_in_hurt = ~p,\n"
    " 					  magic_avoid_in_hurt = ~p,\n"
	" 					  keep_off = ~p,\n"
    " 					  attack_suppression = ~p,\n"
    " 					  defense_suppression = ~p,\n"
    " 					  attack_speed = ~p\n"				 				 				 				 
    "    };\n",
    [Career, Level, CurrentHp, CurrentMp, Attack, MumpAttack, FarAttack,
	 MagicAttack, Defense, MumpDefense, FarDefense, MagicDefense, HitTarget, Duck, 
	 Deligency, PowerHit, MaxPhysical, MaxExperiences, MumpAvoidInHurt, 
	 FarAvoidInHurt, MagicAvoidInHurt, KeepOff, AttackSuppression, DefenseSuppression, AttackSpeed]).


last_clause() ->
    "get(_) -> [].\n".


%%
%% Local Functions
%%

