%% Author: liaoxiaobo
%% Created: 2012-11-6
%% Description: TODO: Add description to pt_25
-module(pt_25).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%

-export([read/2, write/2]).


%%
%% API Functions
%%

%% 宠物出战状态改变
read(?PP_PET_STATE_CHANGE,<<ID:64,State:8>>) ->
	{ok, [ID,State]}; 


%% 宠物进阶
read(?PP_PET_STAIRS_UPDATE,<<ID:64>>) ->
	{ok, [ID]}; 

%% 宠物提升
read(?PP_PET_GROW_UPDATE,<<ID:64>>) ->
	{ok, [ID]};

%% 宠物进化
read(?PP_PET_QUALITY_UPDATE,<<ID:64>>) ->
	{ok, [ID]}; 

read(?PP_PET_RELEASE,<<ID:64>>) ->
	{ok, [ID]}; 

read(?PP_PET_REMOVE_SKILL,<<ID:64,GroupSkillId:32>>) ->
	{ok, [ID,GroupSkillId]}; 

%% 宠物悟道技能
read(?PP_PET_SKILL_ITEM_REFRESH,<<Type:8>>) ->
	{ok, [Type]}; 

%% 宠物技能书获取
read(?PP_PET_SKILL_ITEM_GET,<<Place:8>>) ->
	{ok, [Place]}; 

%% 宠物技能删除
read(?PP_PET_REMOVE_SKILL1,<<ID:64,GroupSkillId:32>>) ->
	{ok, [ID,GroupSkillId]}; 

read(?PP_PET_GET_SKILL_BOOK_LIST,<<>>) ->
	{ok, []}; 

read(?PP_PET_GET_OTHER_PETS,<<UserID:64,MountsID:64>>) ->
	{ok, [UserID,MountsID]}; 

%% 宠物召唤
read(?PP_PET_CALL,<<ItemId:64>>) ->
  	{ok, [ItemId]}; 

 %% 宠物技能学习
read(?PP_PET_SKILL_STUDY,<<Place:8>>) ->
  	{ok, [Place]}; 

%% 宠物洗髓
read(?PP_PET_XISUI_UPDATE,<<ID:64,Type:8>>) ->
  	{ok, [ID,Type]}; 

%% 宠物改名
read(?PP_PET_NAME_UPDATE,<<ID:64,Bin/binary>>) ->
	{Name, _} = pt:read_string(Bin),
  	{ok, [ID,Name]}; 

%% 宠物喂养
read(?PP_PET_ENERGY_UPDATE,<<ID:64>>) ->
	{ok, [ID]}; 


%% 宠物主动攻击
read(?PP_PET_ATTACK, <<TargetID:64,Type:8,SkillGroupID:32,X:32,Y:32>> ) ->
	{ok, [TargetID,Type,SkillGroupID,X,Y]};

%% 宠物融合
read(?PP_PET_INHERIT, <<MainID:64,MasterID:64>> ) ->
	{ok, [MainID,MasterID]};

%%加入宠物斗坛
read(?PP_PET_BATTLE_JOIN,<<>>) ->
	{ok,[]};

%%宠物斗坛可挑战信息列表
read(?PP_PET_BATTLE_CHALLENGE_LIST,<<PetID:64>>) ->
	{ok,[PetID]};

%%宠物斗坛挑战
read(?PP_PET_BATTLE_CHALLENGE,<<PetID:64,ChallengeID:64>>) ->
	{ok,[PetID,ChallengeID]};

%%宠物斗坛减少CD并且战斗
read(?PP_PET_BATTLE_CD_AND_BATTLE,<<PetID:64,ChallengeID:64>>) ->
	{ok,[PetID,ChallengeID]};

%%宠物斗坛冠军榜
read(?PP_PET_BATTLE_CHAMPION,<<>>) ->
	{ok,[]};

%%宠物斗坛次数时间
read(?PP_PET_BATTLE_TIME,<<Type:8>>) ->
	{ok,[Type]};

%%宠物斗坛排行奖励
read(?PP_PET_BATTLE_TOP_AWARD,<<>>) ->
	{ok,[]};

read(Cmd, _R) ->
	?WARNING_MSG("pt_25 read:~w", [Cmd]),
    {error, no_match}.

write(?PP_PET_BATTLE_JOIN,[MyPetList,ChampionList,Logs,AwardList,Count,TotalTimes,Time,AwardState]) ->
	{Len1,Bin1} = write_pet_battle_pet_list(MyPetList),
	{Len2,Bin2} = write_pet_battle_pet_list(ChampionList),
	{Len3,Bin3} = write_pet_battle_logs(Logs),
	{Len4,Bin4} = wirte_pet_battle_award_list(AwardList),
	{ok, pt:pack(?PP_PET_BATTLE_JOIN,<<Len1:8,Bin1/binary,Len2:8,Bin2/binary,Len3:8,Bin3/binary,Len4:8,Bin4/binary,Count:32,TotalTimes:32,Time:32,AwardState:8>>)};

write(?PP_PET_BATTLE_CHALLENGE,[Pet,CPet,Result,Coper,Exp,ItemTemID]) ->
	PetID = Pet#ets_pet_battle.pet_id,
	CPetID = CPet#ets_pet_battle.pet_id,
	PetRPID = Pet#ets_pet_battle.replace_template_id,
	CPetRPID = CPet#ets_pet_battle.replace_template_id,
	PetFight = Pet#ets_pet_battle.fight,
	CPetFight = CPet#ets_pet_battle.fight,
	PetNcik = pt:write_string(Pet#ets_pet_battle.name),
	CPetNcik = pt:write_string(CPet#ets_pet_battle.name),
	SL1 = tool:split_string_to_intlist(Pet#ets_pet_battle.skill_list),
	SL2 = tool:split_string_to_intlist(CPet#ets_pet_battle.skill_list),
	{Len1,Bin1} = write_pet_skill_list(SL1),
	{Len2,Bin2} = write_pet_skill_list(SL2),
	Bin = <<PetID:64,PetRPID:32,PetFight:32,PetNcik/binary,CPetID:64,CPetRPID:32,CPetFight:32,CPetNcik/binary,Result:8,Coper:32,Exp:32,ItemTemID:32,Len1:8,Bin1/binary,Len2:8,Bin2/binary>>,
	{ok, pt:pack(?PP_PET_BATTLE_CHALLENGE,<<Bin/binary>>)};

write(?PP_PET_BATTLE_CHALLENGE_LIST,[PetID,List]) ->
	{Len,	Bin} = write_pet_battle_pet_list(List),
	{ok, pt:pack(?PP_PET_BATTLE_CHALLENGE_LIST,<<PetID:64,Len:8,Bin/binary>>)};

write(?PP_PET_BATTLE_CHAMPION,[List]) ->
	{Len,	Bin} = write_pet_battle_pet_list(List),
	{ok, pt:pack(?PP_PET_BATTLE_CHAMPION,<<Len:8,Bin/binary>>)};

write(?PP_PET_BATTLE_WINNING,[Log]) ->
	PetNameBin = pt:write_string(Log#pet_battle_log.pet_name),
	CPetNameBin = pt:write_string(Log#pet_battle_log.challenge_pet_name),
			Bin =		<<
						  (Log#pet_battle_log.pet_id):64,
						  PetNameBin/binary,
						  (Log#pet_battle_log.challenge_pet_id):64,
						  CPetNameBin/binary,
						  (Log#pet_battle_log.top):32,
						  (Log#pet_battle_log.state):8,
						  (Log#pet_battle_log.winning):32
						  >>,
	{ok, pt:pack(?PP_PET_BATTLE_WINNING,<<Bin/binary>>)};

write(?PP_PET_BATTLE_LOG,[List]) ->
	{Len,	Bin} = write_pet_battle_logs(List),
	{ok, pt:pack(?PP_PET_BATTLE_LOG,<<Len:8,Bin/binary>>)};

write(?PP_PET_BATTLE_TIME,[Count,Times,Time]) ->
	{ok, pt:pack(?PP_PET_BATTLE_TIME,<<Count:32,Times:32,Time:32>>)};

write(?PP_PET_BATTLE_SELF_PET,[Pets]) ->
	{Len,Bin} = write_pet_battle_pet_list(Pets),
	{ok, pt:pack(?PP_PET_BATTLE_SELF_PET,<<Len:8,Bin/binary>>)};

write(?PP_PET_BATTLE_SELF_LOG,[]) ->
	{ok, pt:pack(?PP_PET_BATTLE_SELF_LOG,<<>>)};

write(?PP_PET_BATTLE_TOP_AWARD,[State]) ->
	{ok, pt:pack(?PP_PET_BATTLE_TOP_AWARD,<<State:8>>)};

write(?PP_PET_LIST_UPDATE,[List]) ->
	Len = length(List),
	F = fun(Info) ->
				case Info#ets_users_pets.is_exit =:= 0 of
					true ->
						<<(Info#ets_users_pets.id):64,0:8>>;
					_ ->
						NameBin = pt:write_string(Info#ets_users_pets.name),
						SL = length(Info#ets_users_pets.other_data#pet_other.skill_list),
						SkillBin = write_skill(Info#ets_users_pets.other_data#pet_other.skill_list,<<>>),
						UBin = write_pet_att_update(Info),
						<<
						  (Info#ets_users_pets.id):64,
						  1:8,
						  (Info#ets_users_pets.template_id):32,
						  (Info#ets_users_pets.replace_template_id):32,
						  (Info#ets_users_pets.quality):8,
						  (Info#ets_users_pets.type):8,
						  (Info#ets_users_pets.energy):8,
						  (Info#ets_users_pets.state):8,
						  (Info#ets_users_pets.other_data#pet_other.diamond):8,
						  (Info#ets_users_pets.other_data#pet_other.star):8,
						  NameBin/binary,
						  (Info#ets_users_pets.stairs):8,
						  (Info#ets_users_pets.level):8,
						  (Info#ets_users_pets.exp):32,
						  (Info#ets_users_pets.current_grow_up):8,
						  (Info#ets_users_pets.grow_exp):32,
						  (Info#ets_users_pets.current_quality):8,
						  (Info#ets_users_pets.quality_exp):32,
						  UBin/binary,	
						  SL:8,		  
						  SkillBin/binary
						  >>
				end
		end,
	
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_PET_LIST_UPDATE,<<Len:8,Bin/binary>>)};

write(?PP_PET_GET_OTHER_PETS,[Info, ItemList]) ->
	Bin = case Info#ets_users_pets.is_exit =:= 0 of
			  true ->
				  <<(Info#ets_users_pets.id):64,0:8>>;
			  _ ->
				  NameBin = pt:write_string(Info#ets_users_pets.name),
				  SL = length(Info#ets_users_pets.other_data#pet_other.skill_list),
				  SkillBin = write_skill(Info#ets_users_pets.other_data#pet_other.skill_list,<<>>),
				  UBin = write_pet_att_update(Info),
				  ItemBin = pt:packet_item_list(ItemList),
				  <<
				  (Info#ets_users_pets.id):64,
				  1:8,
				  (Info#ets_users_pets.template_id):32,
				  (Info#ets_users_pets.replace_template_id):32,
				  (Info#ets_users_pets.quality):8,
				  (Info#ets_users_pets.type):8,
				  (Info#ets_users_pets.energy):8,
				  (Info#ets_users_pets.state):8,
				  (Info#ets_users_pets.other_data#pet_other.diamond):8,
				  (Info#ets_users_pets.other_data#pet_other.star):8,
				  NameBin/binary,
				  (Info#ets_users_pets.stairs):8,
				  (Info#ets_users_pets.level):8,
				  (Info#ets_users_pets.exp):32,
				  (Info#ets_users_pets.current_grow_up):8,
				  (Info#ets_users_pets.grow_exp):32,
				  (Info#ets_users_pets.current_quality):8,
				  (Info#ets_users_pets.quality_exp):32,
				  UBin/binary,	
				  SL:8,		  
				  SkillBin/binary,
				  ItemBin/binary
				  >>
		  end,
	{ok, pt:pack(?PP_PET_GET_OTHER_PETS,Bin)};


write(?PP_PET_RELEASE,[ID]) ->
	{ok, pt:pack(?PP_PET_RELEASE,<<ID:64>>)};

write(?PP_PET_SKILL_UPDATE,[ID,SkillList]) ->
	SL = length(SkillList),
	SkillBin = write_skill(SkillList,<<>>),
	{ok, pt:pack(?PP_PET_SKILL_UPDATE,<<ID:64,SL:8,SkillBin/binary>>)};

write(?PP_PET_STATE_CHANGE,[List]) ->
	Len = length(List),
	F = fun(Info) ->
				<<
				  (Info#ets_users_pets.id):64,
				  (Info#ets_users_pets.state):8
				>>
		end,
	Bin =  tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_PET_STATE_CHANGE,<<Len:8,Bin/binary>>)};

%% 进阶
write(?PP_PET_STAIRS_UPDATE,[Res]) ->
	{ok, pt:pack(?PP_PET_STAIRS_UPDATE,<<Res:8>>)};

%% 进化
write(?PP_PET_GROW_UPDATE,[ID,Res]) ->
	{ok, pt:pack(?PP_PET_GROW_UPDATE,<<ID:64,Res:32>>)};

%% 提升
write(?PP_PET_QUALITY_UPDATE,[ID,Res]) ->
	{ok, pt:pack(?PP_PET_QUALITY_UPDATE,<<ID:64,Res:32>>)};

%% 属性更新
write(?PP_PET_ATT_UPDATE,[Info]) ->
	UBin = write_pet_att_update(Info), 
	Bin = <<
			(Info#ets_users_pets.id):64,
			(Info#ets_users_pets.replace_template_id):32,
			(Info#ets_users_pets.other_data#pet_other.diamond):8,
			(Info#ets_users_pets.other_data#pet_other.star):8,
			(Info#ets_users_pets.stairs):8,
			(Info#ets_users_pets.current_grow_up):8,
		    (Info#ets_users_pets.grow_exp):32,
		    (Info#ets_users_pets.current_quality):8,
		    (Info#ets_users_pets.quality_exp):32,
			UBin/binary
		  >>,
	{ok, pt:pack(?PP_PET_ATT_UPDATE,Bin)};


%% 经验更改
write(?PP_PET_EXP_UPDATE,[Info]) ->
	Bin = <<
			(Info#ets_users_pets.id):64,
			(Info#ets_users_pets.level):8,
			(Info#ets_users_pets.exp):64
		  >>,
	{ok, pt:pack(?PP_PET_EXP_UPDATE,Bin)};

write(?PP_PET_ENERGY_UPDATE,[ID,Energy]) ->
	Bin = <<
			ID:64,
			Energy:8
		  >>,
	{ok, pt:pack(?PP_PET_ENERGY_UPDATE,Bin)};

write(?PP_PET_UPGRADE,[ID,Level]) ->
	{ok, pt:pack(?PP_PET_UPGRADE,<<ID:64,Level:8>>)};


write(?PP_PET_REMOVE_SKILL,[Res]) ->
	{ok, pt:pack(?PP_PET_REMOVE_SKILL,<<Res:8>>)};

write(?PP_PET_REMOVE_SKILL1,[Res]) ->
	{ok, pt:pack(?PP_PET_REMOVE_SKILL1,<<Res:8>>)};

write(?PP_PET_INHERIT,[Res]) ->
	{ok, pt:pack(?PP_PET_INHERIT,<<Res:8>>)};

write(?PP_PET_XISUI_UPDATE,[Res]) ->
	{ok, pt:pack(?PP_PET_XISUI_UPDATE,<<Res:8>>)};

write(?PP_PET_GET_SKILL_BOOK_LIST,[List,Luck]) ->
	Len = length(List),
	F = fun({Place,ItemId,Bind,_Type}) ->
				<<
				  (Place):32,
				  (ItemId):32,
				  (Bind):8
				>>
		end,
	Bin =  tool:to_binary([F(Info) || Info <- List]),
	{ok, pt:pack(?PP_PET_GET_SKILL_BOOK_LIST,<<Luck:16,Len:8,Bin/binary>>)};


write(?PP_PET_SKILL_ITEM_GET,[Res,Luck]) ->
	{ok, pt:pack(?PP_PET_SKILL_ITEM_GET,<<Res:8,Luck:16>>)};

write(?PP_PET_NAME_UPDATE,[Res,ID,Name]) ->
	Bin = pt:write_string(Name),
	{ok, pt:pack(?PP_PET_NAME_UPDATE,<<Res:8,ID:64,Bin/binary>>)};

write(?PP_PET_NAME_RELY,[ID,  Name]) ->
	Bin = pt:write_string(Name),
	{ok, pt:pack(?PP_PET_NAME_RELY,<<ID:64,Bin/binary>>)};



write(Cmd, _R) ->
	?WARNING_MSG("pt_25,write:~w",[Cmd]),
	{ok, pt:pack(0, <<>>)}.
%%
%% Local Functions
%%

wirte_pet_battle_award_list(AwardList) ->
	Len = length(AwardList),%%正常情况下最多3个
	F = fun(Info) ->
		<<Info:32>>
	end,
	Bin =tool:to_binary([F(Info) || Info <- AwardList]),
	{Len,Bin}.

write_pet_battle_logs(Logs) ->
	Len = length(Logs),%%正常情况下最多10个
		
	F = fun(Info) ->
				PetNameBin = pt:write_string(Info#pet_battle_log.pet_name),
				NickBin = pt:write_string(Info#pet_battle_log.nick),
				CPetNameBin = pt:write_string(Info#pet_battle_log.challenge_pet_name),
				CNickBin = pt:write_string(Info#pet_battle_log.challenge_nick),
						<<
						  (Info#pet_battle_log.pet_id):64,
						  PetNameBin/binary,						  
						  NickBin/binary,
						  (Info#pet_battle_log.challenge_pet_id):64,
						  CPetNameBin/binary,
						  CNickBin/binary,
						  (Info#pet_battle_log.top):32,
						  (Info#pet_battle_log.state):8,
						  (Info#pet_battle_log.winning):32
						  >>
		end,
	
	if Len =/= 0 ->
		Bin = tool:to_binary([F(Info) || Info <- Logs]),
		{Len,Bin};
		true -> 
		{Len,<<>>}
	end.

write_pet_battle_pet_list(List) ->
	Len = length(List),%%冠军榜3个，自己1-3个，挑战列表6个
	F = fun(Info) ->
				NameBin = pt:write_string(Info#ets_pet_battle.name),
						<<
						  (Info#ets_pet_battle.pet_id):64,
						  (Info#ets_pet_battle.template_id):32,
						  (Info#ets_pet_battle.replace_template_id):32,
						  (Info#ets_pet_battle.stairs):8,
						  (Info#ets_pet_battle.level):8,	
						  (Info#ets_pet_battle.quality):8,
						  (Info#ets_pet_battle.fight):32,
						  (Info#ets_pet_battle.top):16,
						  (Info#ets_pet_battle.win):16,
						  (Info#ets_pet_battle.total):16,
						  NameBin/binary
						  >>
		end,
	
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{Len,Bin}.

write_pet_skill_list(List) ->
	Len = length(List),
	F = fun({Info}) ->
			<<Info:32>>
		end,
	
	Bin = tool:to_binary([F(Info) || Info <- List]),
	{Len,Bin}.

read_item(0,L,<<_Bin/binary>>) ->
	L;

read_item(Count,L, <<Place:32,Bin/binary>>) ->
	L1 = L ++ [Place],
	read_item(Count - 1, L1, Bin).

write_skill([],<<Bin/binary>>) -> Bin;
write_skill([H|T],<<Bin/binary>>)->
	NewBin = <<
			   Bin/binary,
			   (H#r_use_skill.skill_group):32,
			   (H#r_use_skill.skill_lv):8
			   >>,
	write_skill(T, NewBin).

write_pet_att_update(Info) ->
	<<
	  (Info#ets_users_pets.fight):32,
	  (Info#ets_users_pets.other_data#pet_other.skill_cell_num):8,
	  (Info#ets_users_pets.other_data#pet_other.up_grow_up  + Info#ets_users_pets.other_data#pet_other.up_grow_up2):8,
	  (Info#ets_users_pets.other_data#pet_other.up_quality  + Info#ets_users_pets.other_data#pet_other.up_quality2):8,
	  (Info#ets_users_pets.other_data#pet_other.hit ):16,
	  (Info#ets_users_pets.other_data#pet_other.hit2):16,
	  (Info#ets_users_pets.other_data#pet_other.power_hit ):16,
	  (Info#ets_users_pets.other_data#pet_other.power_hit2):16,
	  (Info#ets_users_pets.other_data#pet_other.attack ):16,
	  (Info#ets_users_pets.other_data#pet_other.attack2):16,
	  (Info#ets_users_pets.other_data#pet_other.magic_attack ):16,
	  (Info#ets_users_pets.other_data#pet_other.magic_attack2):16,
	  (Info#ets_users_pets.other_data#pet_other.far_attack ):16,
	  (Info#ets_users_pets.other_data#pet_other.far_attack2):16,
	  (Info#ets_users_pets.other_data#pet_other.mump_attack ):16,
	  (Info#ets_users_pets.other_data#pet_other.mump_attack2):16
	  >>.
	
