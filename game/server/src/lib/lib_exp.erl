%% Author: xiaoxin
%% Created: 2011-3-24
%% Description: TODO: Add description to lib_exp
-module(lib_exp).

%%
%% Include files
%%
-include("common.hrl").
-define(MAX_LEVEL, 120).
%%
%% Exported Functions
%%
-export([
		 init_template_exp/0, 
		 get_level_by_exp/1,
	     get_exp/5,
		 get_exp_for_pet/4
		 ]).

%%
%% API Functions
%%
%%初始化经验模板
init_template_exp() -> 
	F = fun(Info) ->
		Record = list_to_tuple([ets_exp_template] ++ Info),	
  		ets:insert(?ETS_EXP_TEMPLATE, Record)
	end,
	L = db_agent_template:get_exp_template(),
	lists:foreach(F, L),
	ok.
%% 经验计算等级
get_level_by_exp(Exp)->
	List = ets:tab2list(?ETS_EXP_TEMPLATE),
	F = fun(V1,V2) -> V1#ets_exp_template.level < V2#ets_exp_template.level end,
	LSort = lists:sort(F,List),
	get_level_by_exp1(LSort, Exp).
get_level_by_exp1([], _) ->
	?MAX_LEVEL;
get_level_by_exp1([H|T], Exp) ->
	if 
		H#ets_exp_template.total_exp > Exp ->
			H#ets_exp_template.level -1;
		true ->
			get_level_by_exp1(T, Exp)
	end.

get_exp(PlayerLevel,MonLevel,ExpFix,MonExp,Number) ->
	if Number == 1 ->
		   get_exp_by_single(PlayerLevel,MonLevel,ExpFix,MonExp);
	   true ->
		   get_exp_by_team(PlayerLevel,MonLevel,ExpFix,MonExp,Number)
	end.

get_exp_by_single(PlayerLevel,MonLevel,ExpFix,MonExp) ->
	LevelCheck = abs(PlayerLevel - MonLevel),
	if LevelCheck =< ?Exp_Max_Level ->
			ExpFix + util:floor(MonExp * (1 - (LevelCheck * ?Exp_Max_Params)) + ?ExpX );
	   LevelCheck =< ?Exp_Common_Level ->
			ExpFix + util:floor((MonExp * (1 - (LevelCheck * ?Exp_Common_Params))) + 
									(PlayerLevel * ?Exp_Player_Params) + 
									(MonLevel * ?Exp_Monster_Params) + ?ExpX);
	   true ->
			ExpFix + util:floor((PlayerLevel * ?Exp_Player_Params) + 
									(MonLevel * ?Exp_Monster_Params) + ?ExpX)
	end.

get_exp_by_team(PlayerLevel,MonLevel,ExpFix,MonExp,Number) ->
	 LevelCheck = abs(PlayerLevel - MonLevel),
	 TMP = 1 - (Number*?Exp_Team_Number_Params) + ?Exp_Team_Number_Params,
	 TmpParams =
		 case TMP > 0.5 of
			 true ->
				 TMP;
			 _ ->
				 0.5
		 end,
	 if LevelCheck =< ?Exp_Max_Level ->
			 ExpFix + util:floor(MonExp * (1 - (LevelCheck * ?Exp_Max_Params))*TmpParams + ?ExpX );
		LevelCheck =< ?Exp_Common_Level ->
			 ExpFix + util:floor((MonExp * (1 - (LevelCheck * ?Exp_Common_Params)))*TmpParams + 
									(PlayerLevel * ?Exp_Team_Player_Params) + 
									(MonLevel * ?Exp_Team_Monster_Params) + ?ExpX);
		true ->
			 util:floor((PlayerLevel * ?Exp_Team_Player_Params) + 
									(MonLevel * ?Exp_Team_Monster_Params) + ?ExpX)
	end.

get_exp_for_pet(PetLevel,MonLevel,ExpFix,MonExp) ->
	LevelCheck = abs(PetLevel - MonLevel),
	if LevelCheck =< ?Exp_Max_Level ->
		   util:floor((ExpFix + MonExp)/?Exp_Pet_Params * (1 - (LevelCheck * ?Exp_Max_Params)) + ?ExpX);
	   LevelCheck =< ?Exp_Common_Level ->
		   util:floor((ExpFix + MonExp)/?Exp_Pet_Params * (1 - (LevelCheck * ?Exp_Common_Params)) + 
									(PetLevel * ?Exp_Pet_Pet_Params) + 
									(MonLevel * ?Exp_Pet_Monster_Params) + ?ExpX);
	   true ->
		   util:floor((PetLevel * ?Exp_Pet_Pet_Params) + 
									(MonLevel * ?Exp_Pet_Monster_Params) + ?ExpX)
	end.



%%
%% Local Functions
%%

