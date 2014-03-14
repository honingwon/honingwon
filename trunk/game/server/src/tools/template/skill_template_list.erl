%% Author: Administrator
%% Created: 2011-3-19
%% Description: TODO: Add description to skill_template_list
-module(skill_template_list).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create/1]).

-record(skillFlashTemplateInfo,{
      skill_group_id = 0,                           	
      name = "",                              %% 名称	
      description = "",                       %%技能描述
      category_id = 0,                        %% 技能种类归属	
      active_use_mp = "",                     %% 使用消耗MP	
      active_type = 0,                        %% 起效方式：主动，被动，辅助	
      active_side = 0,                        %% 起效方向：敌人，自身，自身团队	
      active_target_type = 0,                 %% 起效对象：不区分，玩家，指定怪物	
      active_target_monster_list = "",        %% 指定怪物列表	
      active_item_category_id = 0,            %% 技能指定装备种类类型	
      active_item_template_id = 0,            %% 技能指定装备类型	
      cold_down_time = "",                    %% 冷却时间	
      range = "",                             %% 使用距离	
      radius = "",                            %% 作用半径	
      effect_number = "",                     %% 影响人数	
      skill_effect_list = "",                 %% 技能效果列表，排列方式 type，影响值|type，影响值，分母。两位表示加法，三位表示乘法	
      buff_list = "",                         %% 状态类列表，排列方式  ID|ID	
	  sound=0,                                %% 音效
	  wind_effect = 0,                        %% 风位效果	
      attack_effect = "",                     %% 攻击动画	
      beattack_effect = "",                   %% 被击动画	
      pic_path = "",                          %% 图片路径	
      update_life_experiences = "",           %% 升级需要历练	
      default_skill = 0,                      %% 是否默认技能	
      straight_time = "",                     %% 硬直时间	
      prepare_time = "",                      %% 准备时间	
      place = 0,                              %% 技能树位置	
      need_copper = "",                       %% 需要铜币
      need_career = 0,                        %% 需要职业	
      need_level = "",                        %% 需要级别
      need_item_id="",                         %% 需要物品
	  is_shake = 0							  %% 是否震动
	
 }).

%%
%% API Functions
%%

create([Infos]) ->
	F = fun(Info, Acc) ->
			RecordInfo = list_to_tuple([ets_skill_template] ++ Info),
			
	case lists:keyfind(RecordInfo#ets_skill_template.group_id, 2, Acc) of
		false ->
			NewInfo=#skillFlashTemplateInfo{
	        	skill_group_id = RecordInfo#ets_skill_template.group_id,
				name 	= tool:to_list(RecordInfo#ets_skill_template.name),
				description 	=tool:to_list (RecordInfo#ets_skill_template.description),
				category_id 	= RecordInfo#ets_skill_template.category_id,
				active_use_mp 	=tool:to_list(RecordInfo#ets_skill_template.active_use_mp),
				active_type 	= RecordInfo#ets_skill_template.active_type,
				active_side 	= RecordInfo#ets_skill_template.active_side,
				active_target_type 			= RecordInfo#ets_skill_template.active_target_type,
				active_target_monster_list 	=tool:to_list(RecordInfo#ets_skill_template.active_target_monster_list),
				active_item_category_id 	= RecordInfo#ets_skill_template.active_item_category_id,
				active_item_template_id 	= RecordInfo#ets_skill_template.active_item_template_id,
				cold_down_time 		=tool:to_list(RecordInfo#ets_skill_template.cold_down_time),
				range 			=tool:to_list (RecordInfo#ets_skill_template.range),
				radius 			=tool:to_list(RecordInfo#ets_skill_template.radius),
				effect_number 	= tool:to_list(RecordInfo#ets_skill_template.effect_number),
				skill_effect_list =tool:to_list( RecordInfo#ets_skill_template.skill_effect_list),
				buff_list 		=tool:to_list (RecordInfo#ets_skill_template.buff_list),
				sound			=RecordInfo#ets_skill_template.sound,
				wind_effect		=RecordInfo#ets_skill_template.wind_effect,
				attack_effect 	= tool:to_list( RecordInfo#ets_skill_template.attack_effect),
				beattack_effect = tool:to_list(RecordInfo#ets_skill_template.beattack_effect),
				pic_path 		=tool:to_list (RecordInfo#ets_skill_template.pic_path),
				update_life_experiences =tool:to_list (RecordInfo#ets_skill_template.update_life_experiences),
				default_skill 	= RecordInfo#ets_skill_template.default_skill,
				straight_time 	=tool:to_list (RecordInfo#ets_skill_template.straight_time),
				prepare_time 	=tool:to_list (RecordInfo#ets_skill_template.prepare_time),
				place 			= RecordInfo#ets_skill_template.place,
				need_copper 	= tool:to_list(RecordInfo#ets_skill_template.need_copper),
				need_career		=RecordInfo#ets_skill_template.need_career,
				need_level 		=tool:to_list (RecordInfo#ets_skill_template.need_level),
				need_item_id 	=tool:to_list (RecordInfo#ets_skill_template.need_item_id),
				is_shake 		=RecordInfo#ets_skill_template.is_shake
										   
			},
			[NewInfo|Acc];
		Old ->
			Newlist = lists:delete(Old, Acc),
			ChangeInfo=#skillFlashTemplateInfo{
	        skill_group_id 	= Old#skillFlashTemplateInfo.skill_group_id,
			name 			= Old#skillFlashTemplateInfo.name,
			description 	= lists:concat([Old#skillFlashTemplateInfo.description,"|",tool:to_list (RecordInfo#ets_skill_template.description)]),
			category_id 	= Old#skillFlashTemplateInfo.category_id,
			active_use_mp 	= lists:concat([Old#skillFlashTemplateInfo.active_use_mp,"|",tool:to_list (RecordInfo#ets_skill_template.active_use_mp)]),
			active_type 	= Old#skillFlashTemplateInfo.active_type,
			active_side 	= Old#skillFlashTemplateInfo.active_side,
			active_target_type 			= Old#skillFlashTemplateInfo.active_target_type,
			active_target_monster_list 	= Old#skillFlashTemplateInfo.active_target_monster_list,
			active_item_category_id 	= Old#skillFlashTemplateInfo.active_item_category_id,
			active_item_template_id 	= Old#skillFlashTemplateInfo.active_item_template_id,
			cold_down_time      		=	lists:concat([Old#skillFlashTemplateInfo.cold_down_time,"|",tool:to_list (RecordInfo#ets_skill_template.cold_down_time)]),
			range 						=	lists:concat([Old#skillFlashTemplateInfo.range,"|",tool:to_list (RecordInfo#ets_skill_template.range)]),
			radius 						=	lists:concat([Old#skillFlashTemplateInfo.radius,"|",tool:to_list (RecordInfo#ets_skill_template.radius)]),
			effect_number 				=	lists:concat([Old#skillFlashTemplateInfo.effect_number,"|",tool:to_list (RecordInfo#ets_skill_template.effect_number)]),
			skill_effect_list 			=	lists:concat([Old#skillFlashTemplateInfo.skill_effect_list,"#",tool:to_list (RecordInfo#ets_skill_template.skill_effect_list)]),
			buff_list 		=	lists:concat([Old#skillFlashTemplateInfo.buff_list,"#",tool:to_list (RecordInfo#ets_skill_template.buff_list)]),
			sound			=	Old#skillFlashTemplateInfo.sound,
			wind_effect		=	Old#skillFlashTemplateInfo.wind_effect,
			attack_effect 	=	lists:concat([Old#skillFlashTemplateInfo.attack_effect,"|",tool:to_list (RecordInfo#ets_skill_template.attack_effect)]),
		    beattack_effect	=	lists:concat([Old#skillFlashTemplateInfo.beattack_effect,"|",tool:to_list (RecordInfo#ets_skill_template.beattack_effect)]),
			pic_path 		=	Old#skillFlashTemplateInfo.pic_path,
			default_skill 			= 	Old#skillFlashTemplateInfo.default_skill,
			update_life_experiences =	lists:concat([Old#skillFlashTemplateInfo.update_life_experiences,"|",tool:to_list (RecordInfo#ets_skill_template.update_life_experiences)]),
			straight_time 			=	lists:concat([Old#skillFlashTemplateInfo.straight_time,"|",tool:to_list (RecordInfo#ets_skill_template.straight_time)]),
			prepare_time 			=	lists:concat([Old#skillFlashTemplateInfo.prepare_time,"|",tool:to_list (RecordInfo#ets_skill_template.prepare_time)]),
			place 					=	Old#skillFlashTemplateInfo.place,
			need_copper 			=	lists:concat([Old#skillFlashTemplateInfo.need_copper,"|",tool:to_list (RecordInfo#ets_skill_template.need_copper)]),
			need_career 			= 	Old#skillFlashTemplateInfo.need_career,
			need_level 				=	lists:concat([Old#skillFlashTemplateInfo.need_level,"|",tool:to_list (RecordInfo#ets_skill_template.need_level)]),
			need_item_id 			=	lists:concat([Old#skillFlashTemplateInfo.need_item_id,"#",tool:to_list (RecordInfo#ets_skill_template.need_item_id)]),
			is_shake 		= Old#skillFlashTemplateInfo.is_shake
			},
			
			[ChangeInfo|Newlist]
	end
	end,
  Acc0=lists:foldl(F, [], Infos),
	
  Len = length(Acc0),
  FInfo = fun(Info1) ->
					Record = Info1,
					Active_use_mpBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.active_use_mp),
					NameBin 			= create_template_all:write_string(Record#skillFlashTemplateInfo.name),
					Pic_pathBin 		= create_template_all:write_string(Record#skillFlashTemplateInfo.pic_path),
					Active_target_monster_listBin = create_template_all:write_string(Record#skillFlashTemplateInfo.active_target_monster_list),
					Cold_down_timeBin = create_template_all:write_string(Record#skillFlashTemplateInfo.cold_down_time),
					Attack_effectBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.attack_effect),
					Beattack_effectBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.beattack_effect),
					RangeBin 			= create_template_all:write_string(Record#skillFlashTemplateInfo.range),
					RadiusBin 			= create_template_all:write_string(Record#skillFlashTemplateInfo.radius),
                    Prepare_timeBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.prepare_time),
                    Straight_timeBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.straight_time),
                    Need_cooperBin 		= create_template_all:write_string(Record#skillFlashTemplateInfo.need_copper),
                    Update_life_experiencesBin = create_template_all:write_string(Record#skillFlashTemplateInfo.update_life_experiences),
                    Need_levelBin 		= create_template_all:write_string(Record#skillFlashTemplateInfo.need_level),
					Need_item_idBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.need_item_id),
                    Skill_effect_listBin = create_template_all:write_string(Record#skillFlashTemplateInfo.skill_effect_list),
                    Need_levelBin 		= create_template_all:write_string(Record#skillFlashTemplateInfo.need_level),
                    Effect_numberBin 	= create_template_all:write_string(Record#skillFlashTemplateInfo.effect_number),
					DescriptionBin 		= create_template_all:write_string(Record#skillFlashTemplateInfo.description),
					BuffListBin 		= create_template_all:write_string(Record#skillFlashTemplateInfo.buff_list),
					
					<<(Record#skillFlashTemplateInfo.skill_group_id ):32,
					   Active_use_mpBin/binary,
					   NameBin/binary,
					   Pic_pathBin/binary,
					  (Record#skillFlashTemplateInfo.active_item_category_id):32/signed,
					  (Record#skillFlashTemplateInfo.active_item_template_id):32/signed,
					  (Record#skillFlashTemplateInfo.active_side):32/signed,
                       Active_target_monster_listBin/binary,
                      (Record#skillFlashTemplateInfo.active_target_type):32/signed,
                      (Record#skillFlashTemplateInfo.active_type):32/signed,
					  (Record#skillFlashTemplateInfo.category_id):32/signed,
                       Cold_down_timeBin/binary,
                       Attack_effectBin/binary,
                       Beattack_effectBin/binary,
                      (Record#skillFlashTemplateInfo.default_skill):8,
                       RangeBin/binary,
                       RadiusBin/binary,
                       Prepare_timeBin/binary,
                       Straight_timeBin/binary,
                      (Record#skillFlashTemplateInfo.place):16/signed,
                      (Record#skillFlashTemplateInfo.need_career):8,
                       Need_cooperBin/binary,
                       Update_life_experiencesBin/binary,
                       Need_levelBin/binary,
                       Need_item_idBin/binary,
                       Skill_effect_listBin/binary,
                       Effect_numberBin/binary,
					  DescriptionBin/binary,
 					  (Record#skillFlashTemplateInfo.wind_effect):32/signed,
					  (Record#skillFlashTemplateInfo.sound):32/signed,
					  (Record#skillFlashTemplateInfo.is_shake):8,
					  BuffListBin/binary
					
					  >>
			   end,
	Bin = tool:to_binary([FInfo(X)||X <- Acc0]),
	{ok, <<Len:32/signed, Bin/binary>>}.


%%
%% Local Functions
%%

