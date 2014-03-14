%% Author: Administrator
%% Created: 2011-3-25
%% Description: TODO: Add description to pp_pet
-module(pp_pet).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 handle/3
		 ]).

%%
%% API Functions
%%

%% 加入宠物斗坛
handle(?PP_PET_BATTLE_JOIN, Status, []) ->
	Newstate = lib_pet_battle:join_top(Status),
	{update, Newstate};

%% 宠物斗坛挑战
handle(?PP_PET_BATTLE_CHALLENGE, Status, [PetID,ChallengeID]) ->
	Newstate = lib_pet_battle:pet_battle_challenge(Status,PetID,ChallengeID),
	{update, Newstate};

%% 宠物斗坛减少CD并战斗
handle(?PP_PET_BATTLE_CD_AND_BATTLE, Status, [PetID,ChallengeID]) ->
	Newstate = lib_pet_battle:pet_battle_challenge_again(Status,PetID,ChallengeID),
	{update, Newstate};

%宠物斗坛排行奖励
handle(?PP_PET_BATTLE_TOP_AWARD, Status, []) ->
	lib_pet_battle:send_pet_battle_top_award(Status);

%% 宠物斗坛挑战列表
handle(?PP_PET_BATTLE_CHALLENGE_LIST, Status, [PetID]) ->
	 lib_pet_battle:prepare_pet_battle(Status,PetID);

%% 宠物斗坛增加次数
handle(?PP_PET_BATTLE_TIME, Status, [Type]) ->
	Newstate = 
		case Type of
		1 ->
			lib_pet_battle:add_pet_battle_times(Status);
		2 ->
			case lib_pet_battle:reduce_pet_battle_cd(Status) of
				false ->
					Status;
				NewStaus ->
					NewStaus
			end
		end,
	{update, Newstate};

%% 获取列表
handle(?PP_PET_LIST_UPDATE, Status, []) ->
	 lib_pet:get_pets(0, Status#ets_users.other_data#user_other.pid_send);

%% 宠物召唤
handle(?PP_PET_CALL,Status,[ItemID]) ->
	case lib_pet:check_pet_count(Status#ets_users.other_data#user_other.pid_send) of
		{ok} ->
			case gen_server:call(Status#ets_users.other_data#user_other.pid_item, {'pet_to_list', ItemID}) of
				{ok,ItemInfo,Template} ->
					lib_pet:pet_to_list(ItemInfo, Template, Status);
				_ ->
					skip
			end;			
		_ ->
			skip
	end;
	
%% 宠物修改状态
handle(?PP_PET_STATE_CHANGE,Status,[ID,State]) ->
	case lib_pet:update_pet_state(Status,ID,State) of
		false ->
			skip;
		{ok,List} ->
			F = fun(Pet,[FS,FPet,Bin]) ->
						if
							Pet#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
								FightState = ?PET_FIGHT_STATE,
								{ok, BinData} = pt_12:write(?PP_MAP_PET_INFO_UPDATE, [Pet#ets_users_pets.id, 
																					  Pet#ets_users_pets.template_id,
																					  Pet#ets_users_pets.replace_template_id,
																					  Status#ets_users.id, 
																					  Pet#ets_users_pets.name]);
							true ->
								FightState = ?PET_CALL_BACK_STATE,
								{ok, BinData} = pt_12:write(?PP_MAP_PET_REMOVE, [Pet#ets_users_pets.id])
						end,
						if
							FS =:= 0 andalso FightState =:= 1 ->
								[1,Pet,<<BinData/binary,Bin/binary>>];
							true ->
								[FS,FPet,<<BinData/binary,Bin/binary>>]
						end
				end,
					
			[NewFightState,NewPet,NewBinData] = lists:foldl(F, [0,undefined,<<>>], List),
			mod_map_agent:send_to_area_scene(
									Status#ets_users.current_map_id,
									Status#ets_users.pos_x,
									Status#ets_users.pos_y,
									NewBinData,
									undefined),
			PlayerStatus1 = lib_player:calc_properties_send_self(Status),
			if
				NewFightState =:= ?PET_FIGHT_STATE ->
					Other = PlayerStatus1#ets_users.other_data#user_other{pet_id = NewPet#ets_users_pets.id,
																		  pet_template_id = NewPet#ets_users_pets.template_id ,
																		  style_id = NewPet#ets_users_pets.replace_template_id ,
																		  pet_nick = NewPet#ets_users_pets.name,
																		  pet_skill_list = NewPet#ets_users_pets.other_data#pet_other.skill_list
																		  };
				true ->
					Other = PlayerStatus1#ets_users.other_data#user_other{pet_id=0,
																   pet_template_id=0,
																   style_id=0,
																   pet_nick=undefined,
																   pet_battle_info = undefined,
																   pet_skill_list = []}
			end,
			NewStatus = PlayerStatus1#ets_users{other_data=Other},
			{update_map, NewStatus}
	end;
%% 宠物进阶
handle(?PP_PET_STAIRS_UPDATE,Status,[ID]) ->
	case lib_pet:pet_stairs_lvup(Status,ID) of
		false ->
			skip;
		{ok,PlayerStatus,Pet} ->
			Other = PlayerStatus#ets_users.other_data#user_other{ style_id = Pet#ets_users_pets.replace_template_id },
			NewStatus = PlayerStatus#ets_users{other_data=Other},
			{ok, BinData} = pt_12:write(?PP_MAP_PET_INFO_UPDATE, [Pet#ets_users_pets.id, 
																  Pet#ets_users_pets.template_id,
																  Pet#ets_users_pets.replace_template_id,
																  NewStatus#ets_users.id, 
																  Pet#ets_users_pets.name]),
			mod_map_agent:send_to_area_scene(
									NewStatus#ets_users.current_map_id,
									NewStatus#ets_users.pos_x,
									NewStatus#ets_users.pos_y,
									BinData,
									undefined),
			{update_map, NewStatus};
		{ok,PlayerStatus} ->
			{update_map, PlayerStatus}
	end;
%% 宠物进化
handle(?PP_PET_GROW_UPDATE,Status,[ID]) ->
	case lib_pet:pet_grow_up_lvup(Status,ID) of
		{ok,PlayerStatus} ->
			{update_map, PlayerStatus};
		_ ->
			skip		
	end;

%% 宠物提升
handle(?PP_PET_QUALITY_UPDATE,Status,[ID]) ->
	case lib_pet:pet_qualification_lvup(Status,ID) of
		{ok,PlayerStatus} ->
			{update_map, PlayerStatus};
		_ ->
			skip
	end;

%% 宠物技能学习
handle(?PP_PET_SKILL_STUDY,Status,[Place]) ->
	case lib_pet:skill_book_use(Status,Place) of 
		{ok,PlayerStatus} ->
			mod_map:update_online_dic_pet_skill(PlayerStatus),
			{update ,PlayerStatus};
		_ ->
			ok
	end;

%% 宠物技能遗忘
handle(?PP_PET_REMOVE_SKILL,Status,[ID,GroupSkillId]) ->
	case lib_pet:seal_skill(Status,ID,GroupSkillId) of 
		{ok,PlayerStatus} ->
			{update_map ,PlayerStatus};
		_ ->
			ok
	end;

%% 宠物技能删除
handle(?PP_PET_REMOVE_SKILL1,Status,[ID,GroupSkillId]) ->
	case lib_pet:delete_skill(Status,ID,GroupSkillId) of 
		{ok,PlayerStatus} ->
			{update_map ,PlayerStatus};
		_ ->
			ok
	end;

%% 获取当前技能书的列表
handle(?PP_PET_GET_SKILL_BOOK_LIST,Status,[]) ->
	{ok,Bin} = pt_25:write(?PP_PET_GET_SKILL_BOOK_LIST,[Status#ets_users.pet_skill_books,Status#ets_users.pet_skill_books_luck]),
	lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send,Bin);


%% 宠物悟道技能
handle(?PP_PET_SKILL_ITEM_REFRESH,Status,[Type]) ->
	case lib_pet:ref_skill_book(Status,Type) of 
		{ok,PlayerStatus} ->
			{update ,PlayerStatus};
		_ ->
			ok
	end;

%% 宠物技能书获取
handle(?PP_PET_SKILL_ITEM_GET,Status,[Place]) ->
	case lib_pet:get_skill_book(Status,Place) of 
		{ok,PlayerStatus} ->
			{update ,PlayerStatus};
		_ ->
			ok
	end;

%% 宠物放生
handle(?PP_PET_RELEASE,Status,[ID]) ->
	lib_pet:pet_released(Status,ID);


%% 宠物战斗
handle(?PP_PET_ATTACK, PlayerStatus, [TargetID,TargetType,SkillGroupID,X,Y]) ->
	%注意，传入的是技能的组id
	case lib_pet:get_fight_pet() of
		undefined ->
			failed;
		PetInfo ->
			case lib_skill:get_current_skill(PetInfo#ets_users_pets.other_data#pet_other.skill_list,SkillGroupID) of
				{error} ->
					failed;
				V ->
					SkillData = lib_skill:get_skill_from_template(V#r_use_skill.skill_id), %%技能判断
					case SkillData of
						[] ->
							failed;
						_ ->
							gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_map,
											{battle_start,[
														   PlayerStatus#ets_users.id,
														   TargetID,
														   SkillData,
														   PetInfo#ets_users_pets.other_data#pet_other.skill_list,
														   X,
														   Y,
														   TargetType,
														   ?ELEMENT_PET]})
					end
			end
	end;
	
	
%% 宠物洗髓
handle(?PP_PET_XISUI_UPDATE, PlayerStatus, [ID,Type]) ->
	case lib_pet:update_xisui(PlayerStatus,ID,Type) of 
		{ok,PlayerStatus1} ->
			{update_map ,PlayerStatus1};
		_ ->
			skip
	end;

%% 获取(他人)宠物信息
handle(?PP_PET_GET_OTHER_PETS,PlayerStatus, [UserID,PetID]) ->
	lib_pet:get_other_pet_info(PlayerStatus#ets_users.id,
							   UserID,
							   PetID,
							   PlayerStatus#ets_users.other_data#user_other.pid_send);


%% 宠物改名
handle(?PP_PET_NAME_UPDATE,PlayerStatus,[ID,Name]) ->
	case lib_pet:update_pet_name(PlayerStatus,
							   ID,
							   Name) of
		{ok,PlayerStatus1,Pet} ->
			if
				Pet#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
					Other = PlayerStatus1#ets_users.other_data#user_other{ pet_nick = Pet#ets_users_pets.name },
					NewStatus = PlayerStatus1#ets_users{other_data=Other},
					{ok, BinData} = pt_25:write(?PP_PET_NAME_RELY, [ID,  Name]),
					mod_map_agent:send_to_area_scene(
											PlayerStatus#ets_users.current_map_id,
											PlayerStatus#ets_users.pos_x,
											PlayerStatus#ets_users.pos_y,
											BinData,
											undefined),
					{update_map ,NewStatus};

				true ->
					{update_map ,PlayerStatus1}
			end;
		_ ->
			skip
	end;

%% 宠物喂养
handle(?PP_PET_ENERGY_UPDATE,PlayerStatus,[ID]) ->
	lib_pet:update_add_energy(PlayerStatus,
							   ID
							   );

%% 宠物融合
handle(?PP_PET_INHERIT,PlayerStatus,[MainID,MasterID]) ->
	lib_pet:update_ronghe(PlayerStatus,MainID,MasterID);

	

handle(Cmd, _Status, _) ->
	?WARNING_MSG("pp_pet cmd is not: ~w", [Cmd]).


%%
%% Local Functions
%%

