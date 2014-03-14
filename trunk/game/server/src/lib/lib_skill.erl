%%%-------------------------------------------------------------------
%%% Module  : lib_skill
%%% Author  : 冯伟平
%%% Description : 技能
%%%-------------------------------------------------------------------
-module(lib_skill).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

%%-define(Macro, value).
-define(OTHER_CAREER_NEED_SLOT,1). %学习其他职业技能需要的其他职业技能格子数量
-define(NOT_IN_SKILL_BAR,-1).		%不在技能栏时客户端传入的数值
-define(REMOVE_SKILL_BAR_VALUE,-1). %删除快捷栏内容时传递的值
-define(REMOVE_SKILL_BAR_TYPE,2).	%删除快捷栏时type传的值
-define(SKILL_BAR_SKILL,0).			%技能栏内容：技能
-define(SKILL_BAR_ITEM,1).			%技能栏内容：物品
-define(SKILL_BAR_NONE,2).			%技能栏内容：什么都没有
-define(SKILL_BAR_START,0).			%技能栏开始位置
-define(SKILL_GUILD,4).				%帮会技能
-define(SKILL_GUILD_UP_LIMIT,10).	%帮会升级上限次数
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([init_template_skill/0,
		 %get_default_skill_by_career/2,
		 get_default_skill_from_template/1,
		 get_skill_from_template/1,
		 get_user_skill/1,
		 get_user_skill_bar/1,
		 get_current_skill/2,
		 change_skillid_to_groupid/1,
		 get_skill_from_template_by_group_and_lv/2,
		 update_skill/2,
		 update_skill_bar/5,
%% 		 change_weapon_cause_update_skill_bar/3,
		 cale_pasv_skill/3,
		 check_skill_use_item/2,
		 cale_pasv_skill_pet/3]).

%%====================================================================
%% External functions
%%====================================================================
%%初始化技能模板
init_template_skill() -> 
	F = fun(Skill) ->
		SkillInfo = list_to_tuple([ets_skill_template] ++ Skill),		
		SkillEffect = tool:split_string_to_intlist(SkillInfo#ets_skill_template.skill_effect_list),
		SkillInfo1 = SkillInfo#ets_skill_template{skill_effect_list = SkillEffect},
  		ets:insert(?ETS_SKILL_TEMPLATE, SkillInfo1)
	end,
	
	L = db_agent_template:get_skill_template(),
	lists:foreach(F, L),
	ok.

%根据职业找默认技能，并写入数据库，注册时用
%get_default_skill_by_career(Id,Career) ->
	%Skill = get_default_skill_from_template(Career),
	%if Skill =/= [] ->
	%		db_agent_user:update_user_skill(Id,0,Skill#ets_skill_template.skill_id,
	%								Skill#ets_skill_template.current_level,0);
	%		%db_agent_user:update_user_skill_bar(Id,?SKILL_BAR_START,?SKILL_BAR_SKILL,
	%		%									Skill#ets_skill_template.skill_id,Skill#ets_skill_template.group_id);
	%   true ->
	%	   	skip
	%end.



%从template中找某个技能
get_skill_from_template(SkillID) ->
	data_agent:get_skill_from_template(SkillID).

get_skill_from_template_by_group_and_lv(GroupID,Lv) ->
	data_agent:get_skill_from_template_by_group_and_lv(GroupID,Lv).

%取人物技能，返回值为[{技能id,上次使用时间,lv,groupid},...]
get_user_skill(UserID) ->
	F = fun(Skill,L) -> 
				[SkillID,SkillListTime,SkillLv] = Skill,
				D = lib_skill:get_skill_from_template(SkillID),
				Record = #r_use_skill{
									  skill_id = SkillID,									%% 技能id
									  skill_percent = 0,									%% 技能机率
									  skill_lv = SkillLv,									%% 技能等级
									  skill_group = D#ets_skill_template.group_id,			%% 技能组
									  skill_lastusetime = SkillListTime,					%% 技能上次使用时间
									  skill_colddown = D#ets_skill_template.cold_down_time	%% 技能冷却时间
									  },
				[Record|L]
		end,
	lists:foldl(F,[],db_agent_skill:get_user_all_skill(UserID)).

%取人物快捷栏,返回值为[{bar_index,type,template_id,group_id}]
get_user_skill_bar(UserID) ->
	F = fun(Skillbar,L) -> [V1,V2,V3,V4] = Skillbar,[{V1,V2,V3,V4}|L] end,
	lists:foldl(F, [], db_agent_skill:get_user_skill_bar(UserID)).

%在用户的技能列表中取组ID对应的技能
get_current_skill(L,GroupID) ->
	case lists:keyfind(GroupID, #r_use_skill.skill_group, L) of 
		false ->
			{error};
		V ->
			V
	end.
%%在用户的技能列表中取技能ID对应的技能信息
get_current_skill_skillid(L,SkillID)->
	case lists:keyfind(SkillID, #r_use_skill.skill_id, L) of
		false ->
			{error};
		V ->
			V
	end.

%取头四位为组id
change_skillid_to_groupid(SkillID) ->
	tool:to_integer(string:sub_string(tool:to_list(SkillID),1,4)).


%调整技能快捷栏内容
update_skill_bar(PlayerStatus, Type, TemplateID, FromIndex, ToIndex) ->
	case Type of
		?SKILL_BAR_SKILL -> %技能,这里templateid是组id
			S = get_current_skill(PlayerStatus#ets_users.other_data#user_other.skill_list,TemplateID),
			case S of
				{error} ->
					PlayerStatus;
				V ->
					update_skill_bar1(PlayerStatus,Type,V#r_use_skill.skill_id,TemplateID,FromIndex,ToIndex)
			end;
		?SKILL_BAR_ITEM -> %物品
			case ToIndex of
				?REMOVE_SKILL_BAR_VALUE -> %拖出，不再判断有无该物品
					update_skill_bar1(PlayerStatus,Type,0,TemplateID,FromIndex,ToIndex);
				_ ->
					I = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'check_item',TemplateID},2000),
					case I of
						true ->
							update_skill_bar1(PlayerStatus,Type,0,TemplateID,FromIndex,ToIndex);
						_ ->
							PlayerStatus
					end
			end
	end.

%% %装备武器更换时调整快捷栏内容[{bar_index,type,template_id,group_id}]
%% change_weapon_cause_update_skill_bar(PlayerStatus, OldWeaponType, NewWeaponType) ->
%% 	if OldWeaponType =:= NewWeaponType orelse NewWeaponType =:= 0 ->
%% 		   PlayerStatus;
%% 	   true ->
%% 		   F = fun(V1,V2) -> V1#r_use_skill.skill_id < V2#r_use_skill.skill_id end,
%% 		   SkillList = lists:sort(F,PlayerStatus#ets_users.other_data#user_other.skill_list),
%% 		   %?PRINT("SKILLList:~p ~n",[SkillList]),
%% 		   {SkillBar,ChangeList} = change_weapon_cause_update_skill_bar1(PlayerStatus#ets_users.other_data#user_other.skill_bar,[],
%% 												 			SkillList,NewWeaponType,
%% 															PlayerStatus#ets_users.id,[]),
%% 		   {ok, BinSkillBar} = pt_20:write(?PP_SKILL_BAR_INIT,ChangeList),
%% 		   lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinSkillBar),
%% 		   OtherData = PlayerStatus#ets_users.other_data#user_other{skill_bar = SkillBar},
%% 		   PlayerStatus#ets_users{other_data = OtherData}
%% 	end.
%% 
%% change_weapon_cause_update_skill_bar1([],NewSkillBar, SkillList, NewWeaponType,UID, ChangeList) ->
%% 	change_weapon_cause_update_skill_bar2(SkillList, NewSkillBar, UID, NewWeaponType, 0, ChangeList);
%% change_weapon_cause_update_skill_bar1(OldSkillBar, NewSkillBar, SkillList,NewWeaponType,UID, ChangeList) ->
%% 	[H|T] = OldSkillBar,
%% 	{Index,Type,_,_} = H,
%% 	case Type of
%% 		?SKILL_BAR_SKILL ->
%% 			NewSkillBar1 = NewSkillBar,
%% 			NewChangeList = [{Index,?SKILL_BAR_NONE,?NOT_IN_SKILL_BAR,?NOT_IN_SKILL_BAR}|ChangeList];
%% 		_ ->
%% 			NewSkillBar1 = [H|NewSkillBar],
%% 			NewChangeList = ChangeList
%% 	end,
%% 	change_weapon_cause_update_skill_bar1(T,NewSkillBar1,SkillList,NewWeaponType,UID,NewChangeList).
%% 
%% change_weapon_cause_update_skill_bar2([], SkillBar, UID, _WeaponType, _Index, ChangeList) -> 
%% 	F = fun(X) -> {Index,Type,SkillID,GroupID} = X,
%% 				  db_agent_user:update_user_skill_bar(UID,Index,Type,SkillID,GroupID) end,
%% 	lists:foreach(F,ChangeList),
%% 	{SkillBar,ChangeList};
%% change_weapon_cause_update_skill_bar2(SkillList, SkillBar, UID, WeaponType, Index, ChangeList) ->
%% 	[H|T] = SkillList,
%% 	SkillInfo = get_skill_from_template(H#r_use_skill.skill_id),
%% 	%非被动技能才换上
%% 	case SkillInfo#ets_skill_template.active_type =/= ?PASV_SKILL andalso
%% 										   SkillInfo#ets_skill_template.active_item_category_id of
%% 		WeaponType ->
%% 			NullIndex = get_min_null_bar_index(SkillBar,Index),
%% 			Change = {NullIndex,?SKILL_BAR_SKILL,H#r_use_skill.skill_id,H#r_use_skill.skill_group},
%% 			case lists:keymember(NullIndex,1,ChangeList) of
%% 				true ->
%% 				   NewChangeList = lists:keyreplace(NullIndex,1,ChangeList,Change);
%% 			    _ ->
%% 				   NewChangeList = [Change|ChangeList]
%% 			end,
%% 			NewSkillBar = [Change|SkillBar],
%% 			NewIndex = NullIndex + 1;
%% 		_ ->
%% 			NewChangeList = ChangeList,
%% 			NewSkillBar = SkillBar,
%% 			NewIndex = Index
%% 	end,
%% 	change_weapon_cause_update_skill_bar2(T,NewSkillBar, UID ,WeaponType,NewIndex, NewChangeList).

%%====================================================================
%% Private functions
%%====================================================================
%根据职业找默认技能
get_default_skill_from_template(Career) -> 
	data_agent:get_default_skill_from_template(Career).

%% 学习或者升级技能
update_skill(PlayerStatus,SkillGroupID) ->
	case update_skill1(PlayerStatus,SkillGroupID) of
		{ok , NewPlayerStatus} ->
			NewPlayerStatus;
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg]),
			PlayerStatus;
		_ ->
			PlayerStatus
	end.


update_skill1(PlayerStatus,SkillGroupID) ->
	L = PlayerStatus#ets_users.other_data#user_other.skill_list,
	case lists:keyfind(SkillGroupID, #r_use_skill.skill_group, L) of
		false -> %%学习
			update_skill1_1(PlayerStatus,SkillGroupID);
		UseSkill ->
			update_skill1_2(PlayerStatus,SkillGroupID,UseSkill)
	end.

update_skill1_1(PlayerStatus,SkillGroupID)->
	Skill = get_skill_from_template_by_group_and_lv(SkillGroupID,1),
	if 
		is_record(Skill,ets_skill_template) ->
			update_skill4(PlayerStatus,Skill,0,true);
		true ->
			{false,?_LANG_SKILL_NONE}
	end.


update_skill1_2(PlayerStatus,SkillGroupID,UseSkill) ->
	UpdateLv = UseSkill#r_use_skill.skill_lv + 1,
	Skill = get_skill_from_template_by_group_and_lv(SkillGroupID,UpdateLv),
	if 
		is_record(Skill, ets_skill_template) ->
		   update_skill4(PlayerStatus,Skill,UseSkill#r_use_skill.skill_lastusetime,false);
		true ->
			{false,?_LANG_SKILL_NONE}
	end.

update_skill4(PlayerStatus,Skill,ValidDate,IsNew) ->
	case Skill#ets_skill_template.need_career =:= ?SKILL_GUILD of 
		true ->
			update_skill4_1(PlayerStatus,Skill,ValidDate,IsNew);
		_ ->
			update_skill4_2(PlayerStatus,Skill,ValidDate,IsNew)
	end.

update_skill4_2(PlayerStatus,Skill,ValidDate,IsNew) ->
	case lib_player:check_cash(PlayerStatus,0,Skill#ets_skill_template.need_copper) of
		true ->
			update_skill4_2_1(PlayerStatus,Skill,ValidDate,IsNew);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.

update_skill4_2_1(PlayerStatus,Skill,ValidDate,IsNew) ->
	case PlayerStatus#ets_users.life_experiences >= Skill#ets_skill_template.update_life_experiences of
		true ->
			update_skill4_2_2(PlayerStatus,Skill,ValidDate,IsNew);
		_ ->
			{false,?_LANG_SKILL_LIFE_EXP_LESS}
	end.

update_skill4_2_2(PlayerStatus,Skill,ValidDate,IsNew) ->
	case PlayerStatus#ets_users.level >= Skill#ets_skill_template.need_level of
		true ->
			update_skill4_2_3(PlayerStatus,Skill,ValidDate,IsNew);
		_ ->
			{false,?_LANG_SKILL_ERROR_LEVEL}
	end.

update_skill4_2_3(PlayerStatus,Skill,ValidDate,IsNew) ->
	SkillIdCheck = 
		case Skill#ets_skill_template.need_skill_id =:= 0 of
			true ->
				true;
			_ ->
				case get_current_skill(PlayerStatus#ets_users.other_data#user_other.skill_list,Skill#ets_skill_template.need_skill_id) of
					{error} ->
						false;
					 Info when Info#r_use_skill.skill_lv >= Skill#ets_skill_template.need_skill_level ->
						 true;
					 _  ->
						false
				end
		end,	
	
	case SkillIdCheck of
		true ->
			if
				PlayerStatus#ets_users.club_id > 0 ->
					case mod_guild:get_guild_user_feats_use_timers(PlayerStatus#ets_users.club_id, PlayerStatus#ets_users.id,11) of
						{true,Timers} ->
							update_skill6(PlayerStatus,Skill,Timers,ValidDate,IsNew);
						{false,_Msg} ->
							update_skill6(PlayerStatus,Skill,0,ValidDate,IsNew)
					end;
				true ->
					update_skill6(PlayerStatus,Skill,0,ValidDate,IsNew)
			end;
		_ ->
			{false,?_LANG_SKILL_PRE_NONE}
	end.
	

%% 帮会技能
update_skill4_1(PlayerStatus,Skill,ValidDate,IsNew) ->
	case lib_player:check_cash(PlayerStatus,0,Skill#ets_skill_template.need_copper) of
		true ->
			update_skill4_1_1(PlayerStatus,Skill,ValidDate,IsNew);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.

update_skill4_1_1(PlayerStatus,Skill,ValidDate,IsNew) ->
	case mod_guild:get_guild_info(PlayerStatus#ets_users.club_id) of
		{ok,GuildInfo} ->
			if
				GuildInfo#ets_guilds.furnace_level >= Skill#ets_skill_template.need_level ->
					update_skill5(PlayerStatus,Skill,ValidDate,IsNew);
				true ->
					{false,?_LANG_SKILL_GUILD_ERROR_LEVEL}
			end;
		_ ->
			{false,?_LANG_SKILL_GUILD_STUDY_NONE}
	end.


update_skill5(PlayerStatus,Skill,ValidDate,IsNew) ->
	case mod_guild:reduce_guild_user_feats(PlayerStatus#ets_users.club_id, PlayerStatus#ets_users.id, 1,
											Skill#ets_skill_template.need_feets,11,?SKILL_GUILD_UP_LIMIT) of
		{true, NewFeats,Times} ->
			{ok,FeatsBin} = pt_21:write(?PP_CLUB_SELF_EXPLOIT_UPDATE,[NewFeats]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,FeatsBin),
			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, Skill#ets_skill_template.need_copper),
			%%对这里的参数扣值并传递		
%% 			NewStatus1 = lib_player:reduce_cash_and_send(PlayerStatus1, 0, 0, 0, Skill#ets_skill_template.need_copper),
			update_skill7(PlayerStatus1,Skill,Times,ValidDate,IsNew);
		{false,Msg} ->
			{false,Msg};
		_ ->
			{false,?_LANG_OPERATE_ERROR}
	end.

update_skill6(PlayerStatus,Skill,Times,ValidDate,IsNew) ->
%% 	case IsNew of
%% 		true ->
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_STUDY_SKILL,{Skill#ets_skill_template.current_level,1}}]),
%% 		_ ->
%% 			skip
%% 	end,
	%%对这里的参数扣值并传递		
	NewStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, Skill#ets_skill_template.need_copper),
	NewStatus2 = lib_player:reduce_life_experiences(NewStatus1,Skill#ets_skill_template.update_life_experiences),
	{ok, LEBIn} = pt_20:write(?PP_PLAYER_SELF_LIFEEXP,[NewStatus2#ets_users.life_experiences]),
	lib_send:send_to_sid(NewStatus2#ets_users.other_data#user_other.pid_send, LEBIn),
	update_skill7(NewStatus2,Skill,Times,ValidDate,IsNew).


update_skill7(PlayerStatus,Skill,Times,ValidDate,IsNew) ->
	RS = #r_use_skill{
					   skill_id = Skill#ets_skill_template.skill_id,
					   skill_percent = 0,
					   skill_lv = Skill#ets_skill_template.current_level,
					   skill_group = Skill#ets_skill_template.group_id,
					   skill_lastusetime = ValidDate,
					   skill_colddown = Skill#ets_skill_template.cold_down_time 
					  },
	 
	SL = case lists:keyfind(RS#r_use_skill.skill_group, #r_use_skill.skill_group, PlayerStatus#ets_users.other_data#user_other.skill_list) of
			false ->
				[RS|PlayerStatus#ets_users.other_data#user_other.skill_list];
			 _ ->
				 lists:keyreplace(RS#r_use_skill.skill_group, #r_use_skill.skill_group, PlayerStatus#ets_users.other_data#user_other.skill_list, RS)
		 end,
		
	 Other = PlayerStatus#ets_users.other_data#user_other{ skill_list = SL },
	 NewPlayerStatus = PlayerStatus#ets_users{other_data = Other},
	 {ok, BinSkill} = pt_20:write(?PP_SKILL_INIT, [[RS],Times]),
	 lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send,BinSkill),
	
	 
	 {NewPlayerStatus2,OldTempID} =
		 case Skill#ets_skill_template.active_type =/= ?PASV_SKILL of
			 true ->
				if
					IsNew =:= true ->
						OSB = NewPlayerStatus#ets_users.other_data#user_other.skill_bar,
						NullIndex = get_min_null_bar_index(OSB,0),
						NewPlayerStatus1 = update_skill_bar(NewPlayerStatus, ?SKILL_BAR_SKILL, Skill#ets_skill_template.group_id, ?NOT_IN_SKILL_BAR, NullIndex),
						{ok, SkillIDBin} = pt_12:write(?PP_NEW_SKILL_ADD, Skill#ets_skill_template.group_id),
				 		lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send, SkillIDBin),
						{NewPlayerStatus1,0};
					true ->
						V = get_current_skill(PlayerStatus#ets_users.other_data#user_other.skill_list,Skill#ets_skill_template.group_id),
						{NewPlayerStatus,V#r_use_skill.skill_id}
				end;
			 _ ->			 
				 NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
%% 				 {ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus1),
%% 				 lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send, PlayerBin),
				 if
					 IsNew =:= true ->
						 {NewPlayerStatus1,0};
					 true ->
				 		V = get_current_skill(PlayerStatus#ets_users.other_data#user_other.skill_list,Skill#ets_skill_template.group_id),
				 		{NewPlayerStatus1,V#r_use_skill.skill_id}
				 end
		 end,


	 db_agent_user:update_user_skill(NewPlayerStatus#ets_users.id,OldTempID,Skill#ets_skill_template.skill_id,
								   Skill#ets_skill_template.current_level,ValidDate),
	{ok,NewPlayerStatus2}.




%% update_skill_all(PlayerStatus) ->
%% 	case update_skill_all_1(PlayerStatus) of
%% 		{ok , NewPlayerStatus} ->
%% 			NewPlayerStatus;
%% 		_ ->
%% 			PlayerStatus
%% 	end.
%% 
%% 
%% update_skill_all_1(PlayerStatus) ->
%% 	Skills = 
%% 	
%% 
%% check_skill_up(PlayerStatus,Skill) ->
%% 	case lib_player:check_cash(PlayerStatus,0,Skill#ets_skill_template.need_copper) of
%% 		true ->
%% 			check_skill_up_1(PlayerStatus,Skill);
%% 		_ ->
%% 			false
%% 	end.
%% 
%% check_skill_up_1(PlayerStatus,Skill) ->
%% 	case PlayerStatus#ets_users.life_experiences >= Skill#ets_skill_template.update_life_experiences of
%% 		true ->
%% 			check_skill_up_2(PlayerStatus,Skill);
%% 		_ ->
%% 			false
%% 	end.
%% 
%% check_skill_up_2(PlayerStatus,Skill) ->
%% 	case PlayerStatus#ets_users.level >= Skill#ets_skill_template.need_level of
%% 		true ->
%% 			check_skill_up_3(PlayerStatus,Skill);
%% 		_ ->
%% 			false
%% 	end.
%% 
%% check_skill_up_3(PlayerStatus,Skill) ->
%% 	case Skill#ets_skill_template.need_skill_id =:= 0 of
%% 		true ->
%% 			true;
%% 		_ ->
%% 			case get_current_skill(PlayerStatus#ets_users.other_data#user_other.skill_list,Skill#ets_skill_template.need_skill_id) of
%% 				{error} ->
%% 					false;
%% 				 Info when Info#r_use_skill.skill_lv >= Skill#ets_skill_template.need_skill_level ->
%% 					 true;
%% 				 _  ->
%% 					false
%% 			end
%% 	end.



check_skill_bar([],_Type,_TemplateID) -> {ok};
check_skill_bar(L,Type,TemplateID) ->
	[H|T] = L,
	{Index,TT,_,TID} = H,
	if TT =:= Type andalso TID =:= TemplateID -> %已有
			{find,Index};
		true ->
			check_skill_bar(T,Type,TemplateID)
	end.
	


%调整快捷栏内技能内容
%%对应技能时detailid为技能模板id，templateid为groupid
%%对应物品时detailid为0，templateid为物品模板id
update_skill_bar1(PlayerStatus,Type,DetailID,TemplateID,FromIndex,ToIndex) ->
	if FromIndex =:= ?NOT_IN_SKILL_BAR -> %拖入
		   case check_skill_bar(PlayerStatus#ets_users.other_data#user_other.skill_bar,Type,TemplateID) of %检查快捷栏里是否有重复了
			 {find, Index} ->
				 %找到重复的变成交换
				 update_skill_bar_c(PlayerStatus,Type,Index,ToIndex);
			 {ok} -> %空
				 update_skill_bar_a(PlayerStatus,Type,DetailID,TemplateID,ToIndex)
			end;
	   ToIndex =:= ?NOT_IN_SKILL_BAR -> %拖出
		   %?PRINT("BAR Out ~n"),
		   update_skill_bar_b(PlayerStatus,Type,FromIndex);
	   true -> %交换
		   %?PRINT("BAR Exchange ~n"),
		   update_skill_bar_c(PlayerStatus,Type,FromIndex,ToIndex)
	end.
%拖入,index是目标的位置
update_skill_bar_a(PlayerStatus,Type,DetailID,TemplateID,Index) ->
	Replace = lists:keyfind(Index,1,PlayerStatus#ets_users.other_data#user_other.skill_bar),
	Change = {Index,Type,DetailID,TemplateID},
	case Replace of
		false -> %插入
			L = [Change|PlayerStatus#ets_users.other_data#user_other.skill_bar];
		_ -> %替换
			L = lists:keyreplace(Index,1,PlayerStatus#ets_users.other_data#user_other.skill_bar,Change)
	end,
%% 	NewPlayerStatus = PlayerStatus#ets_users.other_data#user_other{skill_bar = L},
	Other = PlayerStatus#ets_users.other_data#user_other{skill_bar = L},
	NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},
	{ok, BinSkillBar} = pt_20:write(?PP_SKILL_BAR_INIT,[Change]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinSkillBar),
	db_agent_user:update_user_skill_bar(PlayerStatus#ets_users.id,Index,Type,DetailID,TemplateID),
	NewPlayerStatus.
%拖出,Index是原来的位置
update_skill_bar_b(PlayerStatus,_Type,Index) ->
	Replace = lists:keymember(Index,1,PlayerStatus#ets_users.other_data#user_other.skill_bar),
	case Replace of
		false ->
			PlayerStatus;
		_ ->
			Change = {Index,?REMOVE_SKILL_BAR_TYPE,?REMOVE_SKILL_BAR_VALUE,?REMOVE_SKILL_BAR_VALUE},
			L = lists:keydelete(Index,1,PlayerStatus#ets_users.other_data#user_other.skill_bar),
%% 			NewPlayerStatus = PlayerStatus#ets_users.other_data#user_other{skill_bar = L},
			Other = PlayerStatus#ets_users.other_data#user_other{skill_bar = L},
			NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},
			{ok,BinSkillBar} = pt_20:write(?PP_SKILL_BAR_INIT,[Change]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinSkillBar),
			db_agent_user:update_user_skill_bar(PlayerStatus#ets_users.id,Index,?REMOVE_SKILL_BAR_TYPE,?REMOVE_SKILL_BAR_VALUE,?REMOVE_SKILL_BAR_VALUE),
			NewPlayerStatus
	end.
%交换
update_skill_bar_c(PlayerStatus,_Type,FromIndex,ToIndex) ->
	%?PRINT("Exchange Skill Bar ~p ~p ~n",[FromIndex,ToIndex]),
	FromBar = lists:keyfind(FromIndex,1,PlayerStatus#ets_users.other_data#user_other.skill_bar),
	ToBar = lists:keyfind(ToIndex,1,PlayerStatus#ets_users.other_data#user_other.skill_bar),
	if FromBar =/= false andalso ToBar =/= false ->
		   %?PRINT("Both have ~n"),
		   {FBIndex,FBT,FBID,FBGID} = FromBar,
		   {TBIndex,TBT,TBID,TBGID} = ToBar,
		   NewFromBar = {FBIndex,TBT,TBID,TBGID},
		   NewToBar = {TBIndex,FBT,FBID,FBGID},
		   update_skill_bar_c_1(PlayerStatus,PlayerStatus#ets_users.other_data#user_other.skill_bar
									 ,FBIndex,TBIndex,NewFromBar,NewToBar);
	   FromBar =/= false ->
		   %?PRINT("From have ~n"),
%% 		   L = PlayerStatus#ets_users.other_data#user_other.skill_baets_users.other_data#user_other = [{ToIndex,-1,-1}|L],
		   L = PlayerStatus#ets_users.other_data#user_other.skill_bar,
		   LN = [{ToIndex,0,-1,-1}|L],
		   {_,FBT, FBID,FBGID} = FromBar,
		   NewFromBar = {FromIndex,?REMOVE_SKILL_BAR_TYPE,?REMOVE_SKILL_BAR_VALUE,?REMOVE_SKILL_BAR_VALUE},
		   NewToBar = {ToIndex,FBT,FBID,FBGID},
		   update_skill_bar_c_1(PlayerStatus,LN
									 ,FromIndex,ToIndex,NewFromBar,NewToBar);
	   ToBar =/= false ->
		   %?PRINT("To have ~n"),
		   L = PlayerStatus#ets_users.other_data#user_other.skill_bar,
		   LN = [{FromIndex,0,-1,-1}|L],
		   {_,TBT,TBID,TBGID} = ToBar,
		   NewFromBar = {FromIndex,TBT,TBID,TBGID},
		   NewToBar = {ToIndex,?REMOVE_SKILL_BAR_TYPE,?REMOVE_SKILL_BAR_VALUE,?REMOVE_SKILL_BAR_VALUE},
		   update_skill_bar_c_1(PlayerStatus,LN
									 ,FromIndex,ToIndex,NewFromBar,NewToBar);
	   true ->
		   PlayerStatus
	end.


update_skill_bar_c_1(PlayerStatus,L,FBIndex,TBIndex,FromBar,ToBar) ->
	%?PRINT("L: ~p ~n",[L]),
	L0 = lists:keyreplace(FBIndex,1,L,FromBar),
	L1 = lists:keyreplace(TBIndex,1,L0,ToBar),
	{ok,BinSkillBar} = pt_20:write(?PP_SKILL_BAR_INIT,[FromBar,ToBar]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinSkillBar),
	{FINX,FIT,FID,FGID} = FromBar,
	{TINX,TIT,TID,TGID} = ToBar,
	db_agent_user:update_user_skill_bar(PlayerStatus#ets_users.id,FINX,FIT,FID,FGID),
	db_agent_user:update_user_skill_bar(PlayerStatus#ets_users.id,TINX,TIT,TID,TGID),
%% 	PlayerStatus#ets_users.other_data#user_other{skill_bar = L1}.
	Other = PlayerStatus#ets_users.other_data#user_other{skill_bar = L1},
	PlayerStatus#ets_users{other_data=Other}.


%取人物快捷栏最小空位
get_min_null_bar_index(SkillBar,Index) ->
	case lists:keyfind(Index,1,SkillBar) of
		false ->
			Index;
		{_,?SKILL_BAR_NONE,_,_} ->
			Index;
		_ ->
			get_min_null_bar_index(SkillBar,Index+1)
	end.
	






%%------------------------被动技能----------------------------------------------------
calc_active_effect(Type,Aer,CalcV) ->
	case Type of
		?ATTR_ATTACK ->
			CalcT = Aer#ets_users.other_data#user_other.attack  + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{attack  = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DEFENSE ->
			CalcT = Aer#ets_users.other_data#user_other.defense + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DAMAGE ->
			CalcT = Aer#ets_users.other_data#user_other.damage + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPHURTATT ->
			CalcT = Aer#ets_users.other_data#user_other.mump_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{mump_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICHURTATT ->
			CalcT = Aer#ets_users.other_data#user_other.magic_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{magic_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARHURTATT ->
			CalcT = Aer#ets_users.other_data#user_other.far_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{far_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_ATT_ATTACK ->
			CalcT = Aer#ets_users.other_data#user_other.mump_hurt + CalcV,
			CalcT1 = Aer#ets_users.other_data#user_other.magic_hurt + CalcV,
			CalcT2 = Aer#ets_users.other_data#user_other.far_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{mump_hurt = CalcT,magic_hurt = CalcT1,far_hurt = CalcT2},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPDEFENSE ->
			CalcT = Aer#ets_users.other_data#user_other.mump_defense + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{mump_defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICDEFENCE ->
			CalcT = Aer#ets_users.other_data#user_other.magic_defense + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{magic_defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARDEFENSE ->
			CalcT = Aer#ets_users.other_data#user_other.far_defense + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{far_defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPHURT ->
			CalcT = Aer#ets_users.other_data#user_other.mump_damage + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{mump_damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICHURT ->
			CalcT = Aer#ets_users.other_data#user_other.magic_damage + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{magic_damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARHURT ->
			CalcT = Aer#ets_users.other_data#user_other.far_damage + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{far_damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_HP ->
			CalcT = Aer#ets_users.other_data#user_other.total_hp + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{total_hp = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MP ->
			CalcT = Aer#ets_users.other_data#user_other.total_mp + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{total_mp = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_POWERHIT ->
			CalcT = Aer#ets_users.other_data#user_other.power_hit + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{power_hit = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DELIGENCY ->
			CalcT = Aer#ets_users.other_data#user_other.deligency + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{deligency = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_HITTARGET ->
			CalcT = Aer#ets_users.other_data#user_other.hit_target + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{hit_target = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DUCK ->
			CalcT = Aer#ets_users.other_data#user_other.duck + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{duck = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPAVOIDINHURT ->
			CalcT = Aer#ets_users.other_data#user_other.magic_avoid_in_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{magic_avoid_in_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARAVOIDINHURT ->
			CalcT = Aer#ets_users.other_data#user_other.mump_avoid_in_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{mump_avoid_in_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICAVOIDINHURT ->
			CalcT = Aer#ets_users.other_data#user_other.far_avoid_in_hurt + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{far_avoid_in_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_SUPPRESSIVE_ATT ->
			CalcT = Aer#ets_users.other_data#user_other.attack_suppression + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{attack_suppression= CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_SUPPRESSIVE_DEFEN ->
			CalcT = Aer#ets_users.other_data#user_other.defense_suppression + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{defense_suppression = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_RESUME_HP_SPEED ->
			Aer;
		?ATTR_RESUME_MP_SPEED ->
			Aer;
%% 		?ATTR_HUMAN_ATTACK ->
%% 			Aer;
%% 		?ATTR_ORC_ATTACK ->
%% 			Aer;
%% 		?ATTR_NIGHTMARE_ATTACK ->
%% 			Aer;
%% 		?ATTR_EVILKIND_ATTACK ->
%% 			Aer;
%% 		?ATTR_HUMAN_DEFENSE ->
%% 			Aer;
%% 		?ATTR_ORC_DEFENSE ->
%% 			Aer;
%% 		?ATTR_NIGHTMARE_DEFENSE ->
%% 			Aer;
%% 		?ATTR_EVILKIND_DEFENSE ->
%% 			Aer;
%% 		?ATTR_HUMAN_DEMAGE ->
%% 			Aer;
%% 		?ATTR_ORC_DEMAGE ->
%% 			Aer;
%% 		?ATTR_NIGHTMARE_DEMAGE ->
%% 			Aer;
%% 		?ATTR_EVILKIND_DEMAGE ->
%% 			Aer;
%% 		?ATTR_DEMAGE_TO_SHANGWU ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_to_shangwu + CalcV,
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_to_shangwu = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?ATTR_DEMAGE_TO_XIAOYAO ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_to_xiaoyao + CalcV,
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_to_xiaoyao = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?ATTR_DEMAGE_TO_LIUXING ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_to_liuxing + CalcV,
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_to_liuxing = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_From_Shangwu ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_from_shangwu + CalcV,
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_from_shangwu = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_From_Xiaoyao ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_from_xiaoyao + CalcV,
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_from_xiaoyao = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_From_Liuxing ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_from_liuxing + CalcV,
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_from_liuxing = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
		?ATTR_KEEPOFF ->
			CalcT = Aer#ets_users.other_data#user_other.keep_off + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{keep_off = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MOVE_SPEED ->
			CalcT = Aer#ets_users.other_data#user_other.tmp_move_speed + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{tmp_move_speed = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_ATTACK_SPEED ->
			CalcT = Aer#ets_users.other_data#user_other.tmp_attack_speed + CalcV,
			OtherData = Aer#ets_users.other_data#user_other{tmp_attack_speed = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_PARALYZE_STATE ->
			Aer;
		?ATTR_FAINT_STATE ->
			Aer;
		?ATTR_CURSE_STATE ->
			Aer;
		?ATTR_CLOSE_MOVE_STATE ->
			Aer;
		?ATTR_CLOSE_SKILL_STATE ->
			Aer;
		?ATTR_RESISTANCE_PARALYZE_STATE ->
			Aer;
		?ATTR_RESISTANCE_FAINT_STATE ->
			Aer;
		?ATTR_RESISTANCE_CURSE_STATE ->
			Aer;
		?ATTR_RESISTANCE_CLOSE_MOVE_STATE ->
			Aer;
		?ATTR_RESISTANCE_CLOSE_SKILL_STATE ->
			Aer;
		_Other ->
			?WARNING_MSG("cale_pasv_effect_loop type:~w", [_Other]),
			Aer
	end.

calc_active_effect(Type,Aer,CalcV1,CalcV2) ->
	case Type of
		?ATTR_ATTACK ->
			CalcT = Aer#ets_users.other_data#user_other.attack + (Aer#ets_users.other_data#user_other.attack * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{attack = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DEFENSE ->
			CalcT = Aer#ets_users.other_data#user_other.defense + (Aer#ets_users.other_data#user_other.defense * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DAMAGE ->
			CalcT = Aer#ets_users.other_data#user_other.damage + (Aer#ets_users.other_data#user_other.damage * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPHURTATT ->
			CalcT = Aer#ets_users.other_data#user_other.mump_hurt + (Aer#ets_users.other_data#user_other.mump_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{mump_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICHURTATT ->
			CalcT = Aer#ets_users.other_data#user_other.magic_hurt + (Aer#ets_users.other_data#user_other.magic_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{magic_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARHURTATT ->
			CalcT = Aer#ets_users.other_data#user_other.far_hurt + (Aer#ets_users.other_data#user_other.far_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{far_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_ATT_ATTACK ->
			CalcT = Aer#ets_users.other_data#user_other.mump_hurt + (Aer#ets_users.other_data#user_other.mump_hurt * CalcV1 / CalcV2),
			CalcT1 = Aer#ets_users.other_data#user_other.magic_hurt + (Aer#ets_users.other_data#user_other.magic_hurt * CalcV1 / CalcV2),
			CalcT2 = Aer#ets_users.other_data#user_other.far_hurt + (Aer#ets_users.other_data#user_other.far_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{mump_hurt = CalcT,magic_hurt = CalcT1,far_hurt = CalcT2},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPDEFENSE ->
			CalcT = Aer#ets_users.other_data#user_other.mump_defense + (Aer#ets_users.other_data#user_other.mump_defense * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{mump_defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICDEFENCE ->
			CalcT = Aer#ets_users.other_data#user_other.magic_defense + (Aer#ets_users.other_data#user_other.magic_defense * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{magic_defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARDEFENSE ->
			CalcT = Aer#ets_users.other_data#user_other.far_defense + (Aer#ets_users.other_data#user_other.far_defense * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{far_defense = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPHURT ->
			CalcT = Aer#ets_users.other_data#user_other.mump_damage + (Aer#ets_users.other_data#user_other.mump_damage * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{mump_damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICHURT ->
			CalcT = Aer#ets_users.other_data#user_other.magic_damage + (Aer#ets_users.other_data#user_other.magic_damage * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{magic_damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARHURT ->
			CalcT = Aer#ets_users.other_data#user_other.far_damage + (Aer#ets_users.other_data#user_other.far_damage * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{far_damage = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_HP ->
			CalcT = Aer#ets_users.other_data#user_other.total_hp + (Aer#ets_users.other_data#user_other.total_hp * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{total_hp = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MP ->
			CalcT = Aer#ets_users.other_data#user_other.total_mp + (Aer#ets_users.other_data#user_other.total_mp * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{total_mp = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_POWERHIT ->
			CalcT = Aer#ets_users.other_data#user_other.power_hit + (Aer#ets_users.other_data#user_other.power_hit * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{power_hit = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DELIGENCY ->
			CalcT = Aer#ets_users.other_data#user_other.deligency + (Aer#ets_users.other_data#user_other.deligency * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{deligency = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_HITTARGET ->
			CalcT = Aer#ets_users.other_data#user_other.hit_target + (Aer#ets_users.other_data#user_other.hit_target * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{hit_target = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_DUCK ->
			CalcT = Aer#ets_users.other_data#user_other.duck + (Aer#ets_users.other_data#user_other.duck * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{duck  = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MUMPAVOIDINHURT ->
			CalcT = Aer#ets_users.other_data#user_other.magic_avoid_in_hurt + (Aer#ets_users.other_data#user_other.magic_avoid_in_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{magic_avoid_in_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_FARAVOIDINHURT ->
			CalcT = Aer#ets_users.other_data#user_other.mump_avoid_in_hurt + (Aer#ets_users.other_data#user_other.mump_avoid_in_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{mump_avoid_in_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MAGICAVOIDINHURT ->
			CalcT = Aer#ets_users.other_data#user_other.far_avoid_in_hurt + (Aer#ets_users.other_data#user_other.far_avoid_in_hurt * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{far_avoid_in_hurt = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_SUPPRESSIVE_ATT ->
			CalcT = Aer#ets_users.other_data#user_other.attack_suppression + (Aer#ets_users.other_data#user_other.attack_suppression * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{attack_suppression = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_SUPPRESSIVE_DEFEN ->
			CalcT = Aer#ets_users.other_data#user_other.defense_suppression + (Aer#ets_users.other_data#user_other.defense_suppression * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{defense_suppression = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_RESUME_HP_SPEED ->
			Aer;
		?ATTR_RESUME_MP_SPEED ->
			Aer;
%% 		?ATTR_HUMAN_ATTACK ->
%% 			Aer;
%% 		?ATTR_ORC_ATTACK ->
%% 			Aer;
%% 		?ATTR_NIGHTMARE_ATTACK ->
%% 			Aer;
%% 		?ATTR_EVILKIND_ATTACK ->
%% 			Aer;
%% 		?ATTR_HUMAN_DEFENSE ->
%% 			Aer;
%% 		?ATTR_ORC_DEFENSE ->
%% 			Aer;
%% 		?ATTR_NIGHTMARE_DEFENSE ->
%% 			Aer;
%% 		?ATTR_EVILKIND_DEFENSE ->
%% 			Aer;
%% 		?ATTR_HUMAN_DEMAGE ->
%% 			Aer;
%% 		?ATTR_ORC_DEMAGE ->
%% 			Aer;
%% 		?ATTR_NIGHTMARE_DEMAGE ->
%% 			Aer;
%% 		?ATTR_EVILKIND_DEMAGE ->
%% 			Aer;
%% 		?ATTR_DEMAGE_TO_SHANGWU ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_to_shangwu + (Aer#ets_users.other_data#user_other.damage_to_shangwu * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_to_shangwu = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_To_Xiaoyao ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_to_xiaoyao + (Aer#ets_users.other_data#user_other.damage_to_xiaoyao * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_to_xiaoyao = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_To_Liuxing ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_to_liuxing + (Aer#ets_users.other_data#user_other.damage_to_liuxing * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_to_liuxing = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_From_Shangwu ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_from_shangwu + (Aer#ets_users.other_data#user_other.damage_from_shangwu * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_from_shangwu = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_From_Xiaoyao ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_from_xiaoyao + (Aer#ets_users.other_data#user_other.damage_from_xiaoyao * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_from_xiaoyao = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
%% 		?Attr_Demage_From_Liuxing ->
%% 			CalcT = Aer#ets_users.other_data#user_other.damage_from_liuxing + (Aer#ets_users.other_data#user_other.damage_from_liuxing * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{damage_from_liuxing = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
		?ATTR_KEEPOFF ->
			CalcT = Aer#ets_users.other_data#user_other.keep_off + (Aer#ets_users.other_data#user_other.keep_off * CalcV1 / CalcV2),
			OtherData = Aer#ets_users.other_data#user_other{keep_off = CalcT},
			Aer#ets_users{other_data = OtherData};
		?ATTR_MOVE_SPEED ->
%% 			CalcT = Aer#ets_users.other_data#user_other.tmp_move_speed + (Aer#ets_users.other_data#user_other.move_speed * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{tmp_move_speed = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
			Aer;
		?ATTR_ATTACK_SPEED ->
%% 			CalcT = Aer#ets_users.other_data#user_other.tmp_attack_speed + (Aer#ets_users.other_data#user_other.attack_speed * CalcV1 / CalcV2),
%% 			OtherData = Aer#ets_users.other_data#user_other{tmp_attack_speed = CalcT},
%% 			Aer#ets_users{other_data = OtherData};
			Aer;
		?ATTR_PARALYZE_STATE ->
			Aer;
		?ATTR_FAINT_STATE ->
			Aer;
		?ATTR_CURSE_STATE ->
			Aer;
		?ATTR_CLOSE_MOVE_STATE ->
			Aer;
		?ATTR_CLOSE_SKILL_STATE ->
			Aer;
		?ATTR_RESISTANCE_PARALYZE_STATE ->
			Aer;
		?ATTR_RESISTANCE_FAINT_STATE ->
			Aer;
		?ATTR_RESISTANCE_CURSE_STATE ->
			Aer;
		?ATTR_RESISTANCE_CLOSE_MOVE_STATE ->
			Aer;
		?ATTR_RESISTANCE_CLOSE_SKILL_STATE ->
			Aer;
		_Other ->
			?WARNING_MSG("cale_pasv_effect_loop type:~w", [_Other]),
			Aer
	end.


calc_active_effect_pet(Type,Aer,CalcV) ->
	case Type of
		?ATTR_ATTACK ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.attack  + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{attack  = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_HITTARGET ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.hit + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{hit = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_MUMPHURTATT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.mump_attack + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{mump_attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_MAGICHURTATT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.magic_attack + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{magic_attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_FARHURTATT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.far_attack + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{far_attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_POWERHIT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.power_hit + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{power_hit = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_ATT_ATTACK ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.mump_attack + CalcV,
			CalcT1 = Aer#ets_users_pets.other_data#pet_other.magic_attack + CalcV,
			CalcT2 = Aer#ets_users_pets.other_data#pet_other.far_attack + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{mump_attack = CalcT,magic_attack = CalcT1,far_attack = CalcT2},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_POWERHIT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.power_hit + CalcV,
			OtherData = Aer#ets_users_pets.other_data#pet_other{power_hit = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		
		_Other ->
			?WARNING_MSG("calc_active_effect_pet type:~w", [_Other]),
			Aer
	end.

calc_active_effect_pet(Type,Aer,CalcV1,CalcV2) ->
	case Type of
		?ATTR_ATTACK ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.attack + (Aer#ets_users_pets.other_data#pet_other.attack * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_HITTARGET ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.hit + (Aer#ets_users_pets.other_data#pet_other.hit * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{hit = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_MUMPHURTATT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.mump_attack + (Aer#ets_users_pets.other_data#pet_other.mump_attack * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{mump_attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_MAGICHURTATT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.magic_attack + (Aer#ets_users_pets.other_data#pet_other.magic_attack * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{magic_attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		?ATTR_FARHURTATT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.far_attack + (Aer#ets_users_pets.other_data#pet_other.far_attack * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{far_attack = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		
		?ATTR_ATT_ATTACK ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.mump_attack + (Aer#ets_users_pets.other_data#pet_other.mump_attack * CalcV1 / CalcV2),
			CalcT1 = Aer#ets_users_pets.other_data#pet_other.magic_attack + (Aer#ets_users_pets.other_data#pet_other.magic_attack * CalcV1 / CalcV2),
			CalcT2 = Aer#ets_users_pets.other_data#pet_other.far_attack + (Aer#ets_users_pets.other_data#pet_other.far_attack * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{mump_attack = CalcT,magic_attack = CalcT1,far_attack = CalcT2},
			Aer#ets_users_pets{other_data = OtherData};
		
		?ATTR_POWERHIT ->
			CalcT = Aer#ets_users_pets.other_data#pet_other.power_hit + (Aer#ets_users_pets.other_data#pet_other.power_hit * CalcV1 / CalcV2),
			OtherData = Aer#ets_users_pets.other_data#pet_other{power_hit = CalcT},
			Aer#ets_users_pets{other_data = OtherData};
		
		_Other ->
			?WARNING_MSG("calc_active_effect_pet type:~w", [_Other]),
			Aer
	end.
		
cale_pasv_skill([],EffectList,PlayerStatus) ->
	cale_pasv_effect_loop(EffectList,PlayerStatus);
cale_pasv_skill(SkillList,EffectList,PlayerStatus) ->
	[H|T] = SkillList,
	SkillData = lib_skill:get_skill_from_template(H#r_use_skill.skill_id),
%% 	CheckSkillWeapon = check_skill_use_item(SkillData,PlayerStatus#ets_users.other_data#user_other.equip_weapon_type),
	NewEffectList = 
		if SkillData#ets_skill_template.active_type =:= ?PASV_SKILL orelse SkillData#ets_skill_template.active_type =:= ?OWNER_SKILL  ->
			   SkillData#ets_skill_template.skill_effect_list ++ EffectList;
		   true ->
			   EffectList
		end,
	cale_pasv_skill(T,NewEffectList,PlayerStatus).	 

%计算被动技能效果，到人
cale_pasv_effect_loop([], Aer) ->
    Aer;
cale_pasv_effect_loop([H | T], Aer) ->
	case H of
		{K,V} ->
			NewAer = calc_active_effect(K,Aer,V);
		{K,V1,V2} -> %%乘除法
			NewAer = calc_active_effect(K,Aer,V1,V2);
		_ ->
			NewAer = Aer
	end,
	cale_pasv_effect_loop(T, NewAer).




cale_pasv_skill_pet([],EffectList,Pet) ->
 	cale_pasv_effect_loop_pet(EffectList,Pet);

cale_pasv_skill_pet(SkillList,EffectList,Pet) ->
	[H|T] = SkillList,
	SkillData = lib_skill:get_skill_from_template(H#r_use_skill.skill_id),
	NewEffectList = 
		if SkillData#ets_skill_template.active_type =:= ?PET_PASV_SKILL ->
			   SkillData#ets_skill_template.skill_effect_list ++ EffectList;
		   true ->
			   EffectList
		end,
	cale_pasv_skill_pet(T,NewEffectList,Pet).	 

%计算被动技能效果，到宠物
cale_pasv_effect_loop_pet([], Aer) ->
    Aer;
cale_pasv_effect_loop_pet([H | T], Aer) ->
	case H of
		{K,V} ->
			NewAer = calc_active_effect_pet(K,Aer,V);
		{K,V1,V2} -> %%乘除法
			NewAer = calc_active_effect_pet(K,Aer,V1,V2);
		_ ->
			NewAer = Aer
	end,
	cale_pasv_effect_loop_pet(T, NewAer).
	
	
% 检查技能的物品可用性
check_skill_use_item(SkillData,ItemType) ->
	case SkillData#ets_skill_template.active_item_category_id of
		?Skill_Use_Item_None ->
			true;
		Type ->
			Type =:= ItemType
	end.	

%% guild_skill
guild_skill_detail(SkillUpList,CheckTime) ->
	F = fun(X,L) ->
				{List,Count} = L,
				{Time,_SkillId} = X,
				case util:is_same_date(Time,CheckTime) of
					true ->
						NL = [X|List],
						NCount = Count+1;
					_ ->
						NL = List,
						NCount = Count
				end,
				{NL,NCount}
		end,		

	lists:foldl(F, {[],0}, SkillUpList).
	
	
