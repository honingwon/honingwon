%%%-------------------------------------------------------------------
%%% Module  : lib_pet
%%% Author  : 
%%% Description : 宠物
%%%-------------------------------------------------------------------
-module(lib_pet).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

-define(MAX_PET_LEVEL, 100).	
-define(MAX_PET_COUNT,3).
-define(DIC_USERS_PET, dic_users_pet). %% 玩家宠物字典

-define(MAX_STAIRS,12).

-define(SKILL_BOOK_LIST,[]). %%技能书列表 

-define(PET_SKILL_BOOK_ONCE_YUNBAO,10).
-define(PET_SKILL_BOOK_GROUP_YUNBAO,110).
-define(PET_SKILL_BOOK_SUB_LIST,[261010,261020,261050,261060,261120,261130,261140,261150,261160,261170,261180,261190,261200,261210]). %%技能书前缀列表

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([
		 init_template/0,
		 init_online_pet/2,
		 get_fight_pet_info/0,
		 get_pets/2,
		 get_pet_by_id/1,
		 check_pet_count/1,
		 pet_to_list/3,
		 update_pet_state/3,
		 pet_stairs_lvup/2,
		 pet_grow_up_lvup/2,
		 pet_qualification_lvup/2,
		 skill_book_use/2,
		 seal_skill/3,
		 delete_skill/3,
		 ref_skill_book/2,
		 get_skill_book/2,
		 pet_released/2,
		 add_pet_exp_and_lvup/4,
		 add_pet_exp_and_lvup/3,
		 add_battle_pet_exp/2,
		 update_energy/1,
		 get_other_pet_info/4,
		 get_fight_pet/0,
		 get_fight_pet_info_by_pid/1,
		 get_pet_ids/0,
		 calc_properties/1,
		 update_xisui/3,
		 update_ronghe/3,
		 update_pet_name/3,
		 update_add_energy/2
		]).

%%====================================================================
%% External functions
%%====================================================================

%% ------------------------初始化模板数据 start--------------------------
init_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_template] ++ (Info)),
				  Template_Id = {Record#ets_pet_template.template_id, Record#ets_pet_template.level},
				  NewRecord = Record#ets_pet_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_PET_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_pet_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,	
	init_stairs_template(),
	init_qualification_template(),
	init_grow_up_template(),
	init_star_template(),
	init_diamond_template(),
	init_exp_template(),
	init_qualification_exp_template(),
	init_grow_up_exp_template(),
	ok.

init_stairs_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_stairs_template] ++ (Info)),
				  Template_Id = {Record#ets_pet_stairs_template.template_id, Record#ets_pet_stairs_template.stairs},
				  NewRecord = Record#ets_pet_stairs_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_PET_STAIRS_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_pet_stairs_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_qualification_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_qualification_template] ++ (Info)),
				  Template_Id = {Record#ets_pet_qualification_template.template_id, Record#ets_pet_qualification_template.qualification},
				  NewRecord = Record#ets_pet_qualification_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_PET_QUALIFICATION_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_pet_qualification_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_grow_up_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_grow_up_template] ++ (Info)),
				  Template_Id = {Record#ets_pet_grow_up_template.template_id, Record#ets_pet_grow_up_template.grow_up},
				  NewRecord = Record#ets_pet_grow_up_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_PET_GROW_UP_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_pet_grow_up_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_star_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_star_template] ++ (Info)),
				  Template_Id = {Record#ets_pet_star_template.template_id, Record#ets_pet_star_template.star},
				  NewRecord = Record#ets_pet_star_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_PET_STAR_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_pet_star_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_diamond_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_diamond_template] ++ (Info)),
				  Template_Id = {Record#ets_pet_diamond_template.template_id, Record#ets_pet_diamond_template.diamond},
				  NewRecord = Record#ets_pet_diamond_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_PET_DIAMOND_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_pet_diamond_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.


init_exp_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_exp_template] ++ (Info)),
                  ets:insert(?ETS_PET_EXP_TEMPLATE, Record)
           end,
    case db_agent_template:get_pet_exp_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_qualification_exp_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_qualification_exp_template] ++ (Info)),
                  ets:insert(?ETS_PET_QUALIFICATION_EXP_TEMPLATE, Record)
           end,
    case db_agent_template:get_pet_qualification_exp_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_grow_up_exp_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_pet_grow_up_exp_template] ++ (Info)),
                  ets:insert(?ETS_PET_GROW_UP_EXP_TEMPLATE, Record)
           end,
    case db_agent_template:get_pet_grow_up_exp_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.


%% ------------------------初始化模板数据 end--------------------------


%% 初始化在线玩家宠物
init_online_pet(UserID, ItemPid) ->
	F = fun(Info)->
				Record = list_to_tuple([ets_users_pets] ++ (Info)),
				SkillList = init_pet_skill(Record#ets_users_pets.id),
				Other = #pet_other {item_pid = ItemPid, skill_list = SkillList},				
				Record1 = Record#ets_users_pets{ other_data  = Other},
				calc_properties( Record1)
		end,
	List = db_agent_pet:get_user_all_pet(UserID),
	NewList = [F(Info) || Info <- List],
	update_pet_dic(NewList),
	ok.

init_pet_by_id(Id, PetID) ->
	Info = db_agent_pet:get_pet_info_by_condition([{id,PetID}],[],[]),
	case Info =/= [] of
		true ->
			ItemList = item_util:get_offline_pet_equip_list(Id, PetID),
			Record = list_to_tuple([ets_users_pets] ++ (Info)),
			SkillList = init_pet_skill(Record#ets_users_pets.id),
			Other = #pet_other {skill_list = SkillList},
			Record1 = Record#ets_users_pets{ other_data  = Other},
			PetInfo = calc_properties(Record1, ItemList),
			{PetInfo, ItemList};
		_ ->
			[]
	end.



init_pet_skill(ID) ->
	F = fun(Info) ->
				   Record = list_to_tuple([ets_users_pets_skills] ++ (Info)),
				   D = lib_skill:get_skill_from_template(Record#ets_users_pets_skills.template_id),
				   #r_use_skill{
					   skill_id = Record#ets_users_pets_skills.template_id,
					   skill_percent = 0,
					   skill_lv = D#ets_skill_template.current_level,
					   skill_group = D#ets_skill_template.group_id,
					   skill_lastusetime = 0,
					   skill_colddown = D#ets_skill_template.cold_down_time 
					  }
	  end,
	List = db_agent_pet:get_pet_all_skills(ID),
	NewList = [F(Info) || Info <- List],
	NewList.


get_pet_dic() ->
	case get(?DIC_USERS_PET) of 
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

update_pet_dic(List)->
	put(?DIC_USERS_PET,List).

get_pet_by_id(ID) ->
	List = get_pet_dic(),
	case lists:keyfind(ID, #ets_users_pets.id, List) of
		false ->
			[];
		Info ->
			Info
	end.

delete_pet_by_id(ID) ->
	List = get_pet_dic(),
	NewList = lists:keydelete(ID, #ets_users_pets.id, List),
	update_pet_dic(NewList).

update_pet_by_id(Pet) ->
	List = get_pet_dic(),
	NewList = lists:keyreplace(Pet#ets_users_pets.id, #ets_users_pets.id, List,Pet),
	update_pet_dic(NewList).

%% 获得自己的宠物信息
get_pets(ID,PidSend) ->
	List = case ID =:= 0 of
			   true ->
				   get_pet_dic();
			   _ ->
				   [get_pet_by_id(ID)]
		   end,
	{ok,Bin} = pt_25:write(?PP_PET_LIST_UPDATE,[List]),
	lib_send:send_to_sid(PidSend,Bin).

get_pet_ids() ->
	List = get_pet_dic(),
	F = fun(Info, L) ->
			[Info#ets_users_pets.id|L]
		end,
	lists:foldl(F, [], List).

%% 获取他人宠物信息 不在线则读数据库
get_other_pet_info(SelfUserId,UserID,PetID,PidSend) ->
	case get_other_pet_info1(SelfUserId,UserID,PetID, PidSend) of
		user_online ->
			skip;
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 ?_LANG_PET_ERROR_NONE]);
		{Info,ItemList} ->
			{ok,Bin} = pt_25:write(?PP_PET_GET_OTHER_PETS,[Info,ItemList]),
			lib_send:send_to_sid(PidSend,Bin)
	end.

get_other_pet_info1(SelfUserId,Id,PetID,PidSend) ->
	case Id =:= SelfUserId of
		true ->
			case get_pet_by_id(PetID) of
				[] ->
					[];
				PetInfo ->
					ItemList = gen_server:call(PetInfo#ets_users_pets.other_data#pet_other.item_pid, {'get_pet_equip_list', PetID}),
					{PetInfo,ItemList}
			end;
		_ ->
			case lib_player:get_online_info(Id) of
				[] -> %不在线
					init_pet_by_id(Id, PetID);
				I ->
					gen_server:cast(I#ets_users.other_data#user_other.pid , {'get_pet_info', PetID, PidSend}),
					user_online
			end
	end.


%% 获得出战宠物信息
get_fight_pet_info() ->
	List = get_pet_dic(),
	case lists:keyfind(?PET_FIGHT_STATE, #ets_users_pets.state, List) of
		false ->
			[0,0,0,[],undefined];
		Info ->
			[Info#ets_users_pets.id,
			 Info#ets_users_pets.template_id,
			 Info#ets_users_pets.replace_template_id,
			 Info#ets_users_pets.other_data#pet_other.skill_list,
			 Info#ets_users_pets.name]
	end.

%% 获得出战宠物信息
get_fight_pet() ->
	List = get_pet_dic(),
	case lists:keyfind(?PET_FIGHT_STATE, #ets_users_pets.state, List) of
		false ->
			undefined;
		Info ->
			Info
	end.

%% 获取出战宠物信息
get_fight_pet_info_by_pid(Pid) ->
	case gen_server:call(Pid, {get_fight_pet}) of
		undefined ->
			undefined;
		Info ->
			Info
	end.
	



%% ----------------------使用道具创建一个宠物 start ------------------------
check_pet_count(PidSend) ->
	case check_pet_count() of
		{ok} ->
			{ok};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			{error}
	end.

check_pet_count() ->
	L = get_pet_dic(),
	Len = length(L),
	case Len + 1 > ?MAX_PET_COUNT of
		true ->
			{false,?_LANG_PET_ERROR_UP};
		_ ->
			{ok}
	end.

%% 生成一个宠物
pet_to_list(ItemInfo,Template,PlayerStatus) ->
	case pet_to_list_1(ItemInfo,Template,PlayerStatus) of
		{ok,Pet} ->
			lib_pet_battle:crate_pet_battle_info(Pet,PlayerStatus#ets_users.level),
			{ok,Bin} = pt_25:write(?PP_PET_LIST_UPDATE,[[Pet]]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 Msg])
	end.

pet_to_list_1(ItemInfo,Template,PlayerStatus) ->
	Pet = create_pet(ItemInfo,Template,PlayerStatus#ets_users.other_data#user_other.pid_item),
	case db_agent_pet:create_pet(Pet) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			
			DBpet = db_agent_pet:get_pet_info_by_condition([{user_id, Pet#ets_users_pets.user_id},
																	 {template_id, Pet#ets_users_pets.template_id}],
																	[{id,desc}],
																	[1]),
			DBpetInfo = list_to_tuple([ets_users_pets] ++ DBpet),
			DBpetInfo1 = DBpetInfo#ets_users_pets{other_data = Pet#ets_users_pets.other_data},
			
			Time = misc_timer:now_seconds(),
			case DBpetInfo1#ets_users_pets.other_data#pet_other.skill_list  of
				[] ->
					skip;
				[Skill1] ->
					db_agent_pet:update_pet_skill(DBpetInfo1#ets_users_pets.id,0,Skill1#r_use_skill.skill_id,Skill1#r_use_skill.skill_lv,Time)
			end,
			
			List = get_pet_dic(),
			update_pet_dic([DBpetInfo1|List]),
			case Template#ets_item_template.propert5 of
				3 ->
					TL = [{?TARGET_PET,{?TARGET_Q1,1}}];
				4 ->
					TL = [{?TARGET_PET,{?TARGET_Q2,1}}];
				_ ->
					TL = []
			end,
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_PET,{0,1}} | TL]),
					
			{ok,DBpetInfo1};
        _Other ->
            {false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	 end.

%% 创建一个宠物
create_pet(ItemInfo,Template,ItemPid) ->
	RS = case lib_skill:get_skill_from_template_by_group_and_lv(Template#ets_item_template.propert6,Template#ets_item_template.propert7) of
		[] ->
			[];
		Skill ->
			[#r_use_skill{
					   skill_id = Skill#ets_skill_template.skill_id,
					   skill_percent = 0,
					   skill_lv = Skill#ets_skill_template.current_level,
					   skill_group = Skill#ets_skill_template.group_id,
					   skill_lastusetime = 0,
					   skill_colddown = Skill#ets_skill_template.cold_down_time 
					  }]
			
	end,
	Other = #pet_other{ item_pid = ItemPid, 
							skill_list = RS,
						    skill_cell_num = 4},
	
	Type = util:rand(1, 3),
	Att = data_agent:pet_template_get({Template#ets_item_template.propert1, 1}),
	Pet = #ets_users_pets{	
						      user_id = ItemInfo#ets_users_items.user_id,                       %% 用户Id	
						      template_id = Template#ets_item_template.propert1,               %% 模板ID
							  type = Type,
						      replace_template_id =  Template#ets_item_template.propert1,       %% 模板ID
	                          name = Att#ets_pet_template.name,
							  quality = Template#ets_item_template.propert5 ,                   %% 品质
						      stairs = Template#ets_item_template.propert2,                     %% 阶级	
						      level = Template#ets_item_template.propert3,               		%% 宠物等级	
						      exp = Template#ets_item_template.propert4 ,                        %% 经验	
							  energy = 100,
							  current_quality = 1,
							  current_grow_up = 1,
							  other_data = Other
							},
	
 	Pet1 = calc_properties(Pet),
	Pet1.



%% ----------------------使用道具创建一个宠物 end ------------------------

%% ----------------------宠物放生 start ------------------------
%% 放生
pet_released(PlayerStatus,ID) ->
	case pet_released(ID) of
		{ok,Pet} ->
			%% 放生成功			
			lib_pet_battle:set_pet_to_wild(Pet#ets_users_pets.id),%%宠物斗坛里设置该宠物为野生
			{ok,Bin} = pt_25:write(?PP_PET_LIST_UPDATE,[[Pet]]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);
		
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.
pet_released(ID) ->
	L = get_pet_dic(),
	Len = length(L),
	case Len =:= 1 of
		true ->
			{false,?_LANG_PET_ERROR_FIGHT_NONE3};
		_ ->
			pet_released1(ID)
	end.

pet_released1(ID) ->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Info ->
			pet_released2(Info)
	end.

pet_released2(Info) ->
	case Info#ets_users_pets.state =/= ?PET_FIGHT_STATE of
		true ->
			pet_released3(Info);
		_ ->
			{false,?_LANG_PET_ERROR_FIGHT_NONE2}
	end.	

pet_released3(Info) ->
	NewInfo = Info#ets_users_pets{is_exit = 0},
	db_agent_pet:update_pet([{is_exit, 0}],[{id,Info#ets_users_pets.id}]),
	delete_pet_by_id(Info#ets_users_pets.id),
	{ok,NewInfo}.

%% ----------------------宠物放生 end ------------------------

%% ----------------------宠物修改状态 start ------------------------
%% 修改状态
update_pet_state(PlayerStatus,ID,State) ->
	case update_pet_state(ID,State) of
		{ok,[],NewList} -> 
			{ok,Bin} = pt_25:write(?PP_PET_STATE_CHANGE,[NewList]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NewList};
		{ok,Pet1,[]}-> 
			{ok,Bin} = pt_25:write(?PP_PET_STATE_CHANGE,[[Pet1]]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,[Pet1]};
		{ok,Pet1,NeedUpdate}-> 
			{ok,Bin} = pt_25:write(?PP_PET_STATE_CHANGE,[[Pet1|NeedUpdate]]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,[Pet1|NeedUpdate]};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.

update_pet_state(ID,State) ->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			if 
				Pet#ets_users_pets.state =:= State ->
					{false,?_LANG_PET_ERROR_IS_THIS_STATE};
				State =:= ?PET_FIGHT_STATE ->
					update_pet_state1(ID,Pet);
				State =:= ?PET_CALL_BACK_STATE ->
					update_pet_state2([Pet]);
				true ->
					{false,?_LANG_OPERATE_ERROR}
			end
	end.

%% 出战
update_pet_state1(ID,Pet) ->
	List = get_pet_dic(),
	case length(List) of
		1 ->
			case update_pet_state1_3(ID,Pet) of
				{false,Msg} ->
					{false,Msg};
				Pet1 ->
					{ok,Pet1,[]}
			end;
				
		_ ->
			update_pet_state1_1(List,ID,Pet)
	end.

update_pet_state1_1(List,ID,Pet) ->
	case Pet#ets_users_pets.energy > 0 of
		true ->
			update_pet_state1_2(List,ID,Pet);
		_ ->
			{false,?_LANG_PET_ERROR_ENERGY_NONE}
	end.
	
update_pet_state1_2(List,ID,Pet) ->
	F = fun(Info,L) ->
				case Info#ets_users_pets.state =:= ?PET_FIGHT_STATE of
					true ->
						Pet1 = Info#ets_users_pets{state = ?PET_CALL_BACK_STATE},
						db_agent_pet:update_pet([{state , Pet1#ets_users_pets.state }],[{id,Pet1#ets_users_pets.id}]),
						update_pet_by_id(Pet1),
						[Pet1|L];
					_ ->
						L
				end
		end,
	NeedUpdate = lists:foldl(F, [], List),
	case update_pet_state1_3(ID,Pet) of
		{false,Msg} ->
			{false,Msg};
		Pet1 ->
			{ok,Pet1,NeedUpdate}
	end.
	

update_pet_state1_3(ID,Pet) ->
	case Pet#ets_users_pets.energy > 0 of
		true ->
			Pet1 = Pet#ets_users_pets{state = ?PET_FIGHT_STATE},
			db_agent_pet:update_pet([{state , Pet1#ets_users_pets.state }],[{id,ID}]),
			update_pet_by_id(Pet1),
			Pet1;
		_ ->
			{false,?_LANG_PET_ERROR_ENERGY_NONE}
	end.


%% 休息
update_pet_state2(List) ->
	F = fun(Pet) ->
				Pet1 = Pet#ets_users_pets{state = ?PET_CALL_BACK_STATE},
				db_agent_pet:update_pet([{state , Pet1#ets_users_pets.state }],[{id,Pet1#ets_users_pets.id}]),
				update_pet_by_id(Pet1),
				Pet1
		end,	
	NewList = [F(Info) || Info <- List],
	{ok,[],NewList}.
	
%% ----------------------宠物修改状态 end ------------------------


%% 宠物洗髓
update_xisui(PlayerStatus,ID,Type) ->
	case update_xisui_1(PlayerStatus,ID,Type) of
		{ok,PlayerStatus1,Pet} ->
			{ok,Bin} = pt_25:write(?PP_PET_XISUI_UPDATE,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_LIST_UPDATE,[[Pet]]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
		
			{ok,PlayerStatus1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.


update_xisui_1(PlayerStatus,ID,Type) ->
	case Type > 0 andalso Type < 4 of
		true ->
			update_xisui_1_1(PlayerStatus,ID,Type);
		_ ->
			{false,?_LANG_PET_ERROR_TYPE_NONE1}
	end.

update_xisui_1_1(PlayerStatus,ID,Type) ->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			update_xisui_2(PlayerStatus,Pet,Type)
	end.

update_xisui_2(PlayerStatus,Pet,Type) ->
	if
		Pet#ets_users_pets.type =:= Type ->
			{false,?_LANG_PET_ERROR_TYPE_NONE};
		true ->
			update_xisui_3(PlayerStatus,Pet,Type)
	end.


update_xisui_3(PlayerStatus,Pet,Type) ->
	case lib_player:check_cash(PlayerStatus,10,0) of
		true ->
			update_xisui_4(PlayerStatus,Pet,Type);
		_ ->
			{false,?_LANG_PET_MSG_NOT_ENOUGH_YUAN_BAO}
	end.


update_xisui_4(PlayerStatus,Pet,Type) ->
	PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 10, 0, 0, 0,{?CONSUME_YUANBAO_XISUI_PET,Pet#ets_users_pets.template_id,1}),
	update_xisui_5(PlayerStatus1,Pet,Type).

update_xisui_5(PlayerStatus,Pet,Type) ->
	Pet1 =  Pet#ets_users_pets{type = Type},
	
	NewPet = calc_properties( Pet1),
	
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,
								 [{?TARGET_PET,{?TARGET_PET_FIGHT, NewPet#ets_users_pets.fight}}]),
	
%% 	PlayerStatus1 = lib_player:calc_pet_properties(PlayerStatus,NewPet),
	if 	NewPet#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
			PlayerStatus1 = lib_player:calc_pet_BattleInfo(PlayerStatus,NewPet);
		true ->
			PlayerStatus1 = PlayerStatus
	end,
	
	db_agent_pet:update_pet([{type , NewPet#ets_users_pets.type }
								  ],[{id,NewPet#ets_users_pets.id}]),
	update_pet_by_id(NewPet),
	{ok,PlayerStatus1,NewPet}.


%% 宠物融合
update_ronghe(PlayerStatus,MainID,MasterID) ->
	case update_ronghe_1(PlayerStatus,MainID,MasterID) of
		{ok,UpdatePets} ->
			{ok,Bin} = pt_25:write(?PP_PET_INHERIT,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_LIST_UPDATE,[UpdatePets]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.


update_ronghe_1(PlayerStatus,MainID,MasterID) ->
	case get_pet_by_id(MainID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			update_ronghe_2(PlayerStatus,Pet,MasterID)
	end.

update_ronghe_2(PlayerStatus,MainPet,MasterID) ->
	case get_pet_by_id(MasterID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_pet_equip_list', MasterID}) of
				[] ->
					update_ronghe_3(PlayerStatus,MainPet,Pet);
				_ ->
					{false,?_LANG_PET_ERROR_FIGHT_NONE5}
			end			
	end.

update_ronghe_3(PlayerStatus,MainPet,MasterPet) ->
	case MainPet#ets_users_pets.state =/= ?PET_FIGHT_STATE of
		true ->
			update_ronghe_4(PlayerStatus,MainPet,MasterPet);
		_ ->
			{false,?_LANG_PET_ERROR_FIGHT_NONE4}
	end.


update_ronghe_4(PlayerStatus,MainPet,MasterPet) ->
	case MasterPet#ets_users_pets.state =/= ?PET_FIGHT_STATE of
		true ->
			update_ronghe_5(PlayerStatus,MainPet,MasterPet);
		_ ->
			{false,?_LANG_PET_ERROR_FIGHT_NONE4}
	end.


update_ronghe_5(PlayerStatus,MainPet,MasterPet) ->
	Level = erlang:max(MainPet#ets_users_pets.level, MasterPet#ets_users_pets.level),
	Exp = erlang:max(MainPet#ets_users_pets.exp, MasterPet#ets_users_pets.exp),
	Stairs = erlang:max(MainPet#ets_users_pets.stairs, MasterPet#ets_users_pets.stairs),
	Quality = erlang:max(MainPet#ets_users_pets.current_quality, MasterPet#ets_users_pets.current_quality),
	QualityExp = erlang:max(MainPet#ets_users_pets.quality_exp, MasterPet#ets_users_pets.quality_exp),
	Grow = erlang:max(MainPet#ets_users_pets.current_grow_up, MasterPet#ets_users_pets.current_grow_up),
	GrowExp = erlang:max(MainPet#ets_users_pets.grow_exp, MasterPet#ets_users_pets.grow_exp),
	


	StyleId = if  Stairs =:= 12 ->
					  200 + MainPet#ets_users_pets.template_id;
				  true ->
					  util:floor(Stairs / 4) * 100 + MainPet#ets_users_pets.template_id 
			  end,
	

	NewPet =  MainPet#ets_users_pets{
								   level = Level,
								   exp = Exp,
								   stairs = Stairs,
								   current_quality = Quality,
								   quality_exp = QualityExp,
								   current_grow_up = Grow,
								   grow_exp = GrowExp,
									replace_template_id = StyleId},

	
	Newpet1 = calc_properties( NewPet),
	
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_PET,{?TARGET_PET_FIGHT,
																										Newpet1#ets_users_pets.fight}}]),
	
	db_agent_pet:update_pet([{level , Newpet1#ets_users_pets.level },
							 {exp , Newpet1#ets_users_pets.exp },
							 {stairs , Newpet1#ets_users_pets.stairs },
							 {current_quality , Newpet1#ets_users_pets.current_quality },
							 {quality_exp , Newpet1#ets_users_pets.quality_exp },
							 {current_grow_up , Newpet1#ets_users_pets.current_grow_up },
							 {grow_exp , Newpet1#ets_users_pets.grow_exp },
							 {replace_template_id , Newpet1#ets_users_pets.replace_template_id },
							 {fight , Newpet1#ets_users_pets.fight }
								  ],[{id,Newpet1#ets_users_pets.id}]),
	update_pet_by_id(Newpet1),
	
	NewMasterPet = MasterPet#ets_users_pets{is_exit = 0},
	db_agent_pet:update_pet([{is_exit, 0}],[{id,MasterPet#ets_users_pets.id}]),
	
	lib_pet_battle:set_pet_to_wild(MasterPet#ets_users_pets.id),%%宠物斗坛里被融合的宠物变为野生

	delete_pet_by_id(MasterPet#ets_users_pets.id),
	{ok,[Newpet1] ++ [NewMasterPet]}.


%% ----------------------改名 start ------------------------
%% 宠物改名
update_pet_name(PlayerStatus,ID,Name) ->
	case update_pet_name_1(PlayerStatus,ID,Name) of
		{ok,PlayerStatus1,Pet} ->
			lib_pet_battle:update_pet_battle_nick(ID,Name),
			{ok,Bin} = pt_25:write(?PP_PET_NAME_UPDATE,[1,ID,Name]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,Bin),
			{ok,PlayerStatus1,Pet};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			{false}
	end.

update_pet_name_1(PlayerStatus,ID,Name) ->
	case validate_name(Name) of  %% 名合法性检测
		{false, Msg} ->
			{false,Msg};
		true ->
			case get_pet_by_id(ID) of
				[] ->
					{false,?_LANG_PET_ERROR_NONE};
				Pet ->
					update_pet_name_2(PlayerStatus,Pet,Name)
			end
	end.

	
update_pet_name_2(PlayerStatus,Pet,Name) ->
	NeedCopper =  5000,
	case lib_player:check_cash(PlayerStatus,0,NeedCopper) of
		true ->
			update_pet_name_3(PlayerStatus,Pet,Name);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.


update_pet_name_3(PlayerStatus,Pet,Name) ->
	NewPet = Pet#ets_users_pets{name = Name},
	db_agent_pet:update_pet([{name, NewPet#ets_users_pets.name }
										
										  ],[{id,NewPet#ets_users_pets.id}]),
			
	
	update_pet_by_id(NewPet),
	{ok,PlayerStatus,NewPet}.
%% ----------------------改名 end ------------------------

%% ----------------------喂养 start ------------------------
%% 喂养
update_add_energy(PlayerStatus,ID) ->
	case update_add_energy_1(PlayerStatus,ID) of
		{ok,Pet} ->
			%% 通知饥饿度
			{ok, BinData} = pt_25:write(?PP_PET_ENERGY_UPDATE, [Pet#ets_users_pets.id,  Pet#ets_users_pets.energy]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinData);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.

update_add_energy_1(PlayerStatus,ID) ->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			update_add_energy_2(PlayerStatus,Pet)
	end.

update_add_energy_2(PlayerStatus,Pet) ->
	case Pet#ets_users_pets.energy >= 100 of
		true ->
			{false,?_LANG_PET_ENERGY_FULL};
		_ ->
			update_add_energy_3(PlayerStatus,Pet)
	end.

update_add_energy_3(PlayerStatus,Pet) ->
%% 	ItemTemplateId = case Pet#ets_users_pets.quality of
%% 			0 ->
%% 				260006;
%% 			1 ->
%% 				260007;
%% 			2 ->
%% 				260008;
%% 			_ ->
%% 				260009
%% 			end,
	case check_and_reduce_item_to_users( 260007,PlayerStatus#ets_users.other_data#user_other.pid_item) of
		true ->
			update_add_energy_4(PlayerStatus,Pet);
		 _ ->
			{false,?_LANG_PET_ENERGY_ITEM_NONE}
	end.

update_add_energy_4(PlayerStatus,Pet) ->
	NewPet = Pet#ets_users_pets{energy = erlang:min(Pet#ets_users_pets.energy + 10,100)},
	db_agent_pet:update_pet([{energy, NewPet#ets_users_pets.energy }
										
										  ],[{id,NewPet#ets_users_pets.id}]),
			
	
	update_pet_by_id(NewPet),
	{ok,NewPet}.

%% ----------------------喂养 end ------------------------

%% ----------------------进阶 start ------------------------
%% 进阶
pet_stairs_lvup(PlayerStatus,ID) ->
	case pet_stairs_lvup1(PlayerStatus,ID) of
		{ok,fail,PlayerStatus1} -> %% 物品扣除成功,并进阶失败
			{ok,Bin} = pt_25:write(?PP_PET_STAIRS_UPDATE,[0]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,Bin),
			{ok,PlayerStatus1};
		{ok,PlayerStatus1,Pet,Re} -> %% 物品扣除成功,并进阶成功
			{ok,Bin} = pt_25:write(?PP_PET_STAIRS_UPDATE,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_ATT_UPDATE,[Pet]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,
									<<Bin/binary,Bin1/binary>>),
			case Re =/= 0 of
				true ->
					{ok,PlayerStatus1,Pet};
				_ ->
					{ok,PlayerStatus1}
			end;
		
		{false,Msg} -> %% 失败
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false

	end.


pet_stairs_lvup1(PlayerStatus,ID)->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			pet_stairs_lvup2(PlayerStatus,Pet)
	end.
			
pet_stairs_lvup2(PlayerStatus,Pet)->
	UpLevel =  Pet#ets_users_pets.stairs + 1,
	if
		UpLevel > ?MAX_STAIRS ->
			{false,?_LANG_PET_ERROR_MAX_STAIRS};
		true ->
			pet_stairs_lvup3(PlayerStatus,Pet,UpLevel)
	end.

pet_stairs_lvup3(PlayerStatus,Pet ,UpLevel) ->
	NeedCopper =  500 + UpLevel*100,
	case lib_player:check_cash(PlayerStatus,0,NeedCopper) of
		true ->
			pet_stairs_lvup4(PlayerStatus,Pet,NeedCopper,UpLevel);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.

pet_stairs_lvup4(PlayerStatus,Pet,NeedCopper,UpLevel)->
	ItemTemplateId = if
			UpLevel =< 2 ->
				260022;
			UpLevel =< 4 ->
				260023;
			UpLevel =< 6 ->
				260024;
			UpLevel =< 8 ->
				260025;
			true ->
				260026
			end,
	case check_and_reduce_item_to_users( ItemTemplateId,PlayerStatus#ets_users.other_data#user_other.pid_item) of
		true ->
			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			pet_stairs_lvup5(PlayerStatus1,Pet,UpLevel);
		 _ ->
			{false,?_LANG_PET_ERROR_STAIRS_ITEM_NONE}
	end.

	
pet_stairs_lvup5(PlayerStatus,Pet,CheckLevel)->
	Rate = if 
			   CheckLevel =< 2 ->
				   10000;
			   CheckLevel =< 4 ->
				   7500;
			   CheckLevel =< 6 ->
				   5000;
			   CheckLevel =< 8 ->
				   4000;
			   CheckLevel =< 9 ->
				   3000;
			   CheckLevel =< 10 ->
				   2000;
			   CheckLevel =< 12 ->
				   1000;
			   true ->
				   1000	   
		   end,
	
	Random = util:rand(1, 10000),
	if
		Rate + PlayerStatus#ets_users.other_data#user_other.vip_pet_stair_rate >= Random ->
			pet_stairs_lvup6(PlayerStatus,Pet);
		true ->
			{ok,fail,PlayerStatus}
	end.

pet_stairs_lvup6(PlayerStatus,Pet)->
	CheckLevel = Pet#ets_users_pets.stairs + 1,
	StyleId = if  CheckLevel =:= 12 ->
					  200 + Pet#ets_users_pets.template_id;
				  true ->
					  util:floor(CheckLevel / 4) * 100 + Pet#ets_users_pets.template_id 
			  end,
	
	if
		 Pet#ets_users_pets.replace_template_id =/= StyleId andalso Pet#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
%% 			 Other = PlayerStatus#ets_users.other_data#user_other{pet_id = Pet#ets_users_pets.template_id,
%% 																  pet_template_id =  Pet#ets_users_pets.template_id,
%% 																  style_id =  Pet#ets_users_pets.replace_template_id }
%% 	
%% 	.pet_id,
%% 				PetTemplateId = User#ets_users.other_data#user_other.pet_template_id,
%% 				PetStyleId = User#ets_users.other_data#user_other.style_id,
%% 				
			 
			 Re = StyleId;
		 true ->
			 Re = 0
	end,
	Pet1 =  Pet#ets_users_pets{stairs = Pet#ets_users_pets.stairs + 1,replace_template_id = StyleId},
	
	
	
	Newpet1 = calc_properties( Pet1),

	if 	Newpet1#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
			PlayerStatus1 = lib_player:calc_pet_BattleInfo(PlayerStatus,Newpet1);
		true ->
			PlayerStatus1 = PlayerStatus
	end,
	
	db_agent_pet:update_pet([{stairs , Newpet1#ets_users_pets.stairs },
							{replace_template_id ,StyleId },
							{fight ,Newpet1#ets_users_pets.fight }
								  ],[{id,Newpet1#ets_users_pets.id}]),
	update_pet_by_id(Newpet1),
	
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_PET,{?TARGET_PET_FIGHT,
																										Newpet1#ets_users_pets.fight}},
																						  {?TARGET_PET,{?TARGET_STAIRS,Newpet1#ets_users_pets.stairs}}
																						  ]	),
	{ok,PlayerStatus1,Newpet1,Re}.
		

%% ----------------------进阶 start ------------------------


%% ----------------------进化 start ------------------------
%% 进化
pet_grow_up_lvup(PlayerStatus,ID) ->
	case pet_grow_up_lvup_1(PlayerStatus,ID) of
		{ok,up,PlayerStatus1,Pet} ->
			{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[Pet]),
			{ok,Bin1} = pt_25:write(?PP_PET_GROW_UPDATE,[Pet#ets_users_pets.id,Pet#ets_users_pets.grow_exp]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send, <<Bin/binary,Bin1/binary>>),
			{ok,PlayerStatus1};
		{ok,noup,PlayerStatus1,Pet} ->
			{ok,Bin} = pt_25:write(?PP_PET_GROW_UPDATE,[Pet#ets_users_pets.id,Pet#ets_users_pets.grow_exp]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send, Bin),
			{ok};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	
	end.
pet_grow_up_lvup_1(PlayerStatus,ID)->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			pet_grow_up_lvup_2(PlayerStatus,Pet)
	end.

pet_grow_up_lvup_2(PlayerStatus,Pet)->
	if
		Pet#ets_users_pets.other_data#pet_other.up_grow_up + Pet#ets_users_pets.other_data#pet_other.up_grow_up2 > Pet#ets_users_pets.current_grow_up ->
			pet_grow_up_lvup_3(PlayerStatus,Pet);
		true ->
			{false,?_LANG_PET_ERROR_GROW_UP_UP}
	end.

pet_grow_up_lvup_3(PlayerStatus,Pet)->
	ItemTemplateId = if
			Pet#ets_users_pets.current_grow_up =< 20 ->
				260012;
			Pet#ets_users_pets.current_grow_up =< 40 ->
				260013;
			Pet#ets_users_pets.current_grow_up =< 60 ->
				260014;
			Pet#ets_users_pets.current_grow_up =< 80 ->
				260015;
			true ->
				260016
			end,
	case check_and_reduce_item_to_users( ItemTemplateId,PlayerStatus#ets_users.other_data#user_other.pid_item) of
		false ->
			{false,?_LANG_PET_ERROR_GROW_ITEM_NONE};
		true ->
			Template = data_agent:item_template_get(ItemTemplateId),
			AddExp = Template#ets_item_template.propert1,
			pet_grow_up_lvup_4(PlayerStatus,Pet,AddExp)
	end.

			
pet_grow_up_lvup_4(PlayerStatus,Pet,AddExp) ->
	Exp = Pet#ets_users_pets.grow_exp,
	NewExp = Exp + AddExp,
	CheckLevel = get_level_by_exp_1(NewExp),
	{Type,NewPet,NewPlayerStatus} = if 
						CheckLevel > Pet#ets_users_pets.current_grow_up -> 
							Pet1 = Pet#ets_users_pets{current_grow_up = CheckLevel,grow_exp = NewExp },
							Newpet1 = calc_properties(Pet1),
							%%PlayerStatus1 = lib_player:calc_pet_properties(PlayerStatus,Newpet),
							if 	Newpet1#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
									PlayerStatus1 = lib_player:calc_pet_BattleInfo(PlayerStatus,Newpet1);
								true ->
									PlayerStatus1 = PlayerStatus
							end,
							lib_target:cast_check_target(PlayerStatus1#ets_users.other_data#user_other.pid_target,
														 [{?TARGET_PET, {?TARGET_PET_FIGHT,Newpet1#ets_users_pets.fight}},
														  {?TARGET_PET,{?TARGET_DIAMOND,Newpet1#ets_users_pets.other_data#pet_other.diamond}},
														  {?TARGET_PET,{?TARGET_GROW_UP,Newpet1#ets_users_pets.current_grow_up}}
														  ]),
							{up,Newpet1,PlayerStatus1};
						true ->
							Pet1 = Pet#ets_users_pets{grow_exp = NewExp },
							{noup,Pet1,PlayerStatus}
					end,
	
	pet_grow_up_lvup_5(NewPet),
	{ok,Type,NewPlayerStatus,NewPet}.


pet_grow_up_lvup_5(Newpet) ->
	db_agent_pet:update_pet([{current_grow_up , Newpet#ets_users_pets.current_grow_up },
							 {grow_exp , Newpet#ets_users_pets.grow_exp },
							 {fight , Newpet#ets_users_pets.fight }
								   
								  ],[{id,Newpet#ets_users_pets.id}]),
	update_pet_by_id(Newpet).

%% ----------------------进化 start ------------------------


%% ----------------------提升 start ------------------------
%% 提升
pet_qualification_lvup(PlayerStatus,ID) ->
	case pet_qualification_lvup_1(PlayerStatus,ID) of
		{ok,up,PlayerStatus1,Pet} ->
			{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[Pet]),
			{ok,Bin1} = pt_25:write(?PP_PET_QUALITY_UPDATE,[Pet#ets_users_pets.id,Pet#ets_users_pets.quality_exp]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok,PlayerStatus1};
		{ok,noup,PlayerStatus1,Pet} ->
			{ok,Bin} = pt_25:write(?PP_PET_QUALITY_UPDATE,[Pet#ets_users_pets.id,Pet#ets_users_pets.quality_exp]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send, Bin),
			{ok};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	
	end.

pet_qualification_lvup_1(PlayerStatus,ID)->
	case get_pet_by_id(ID) of
		[] ->
			{false,?_LANG_PET_ERROR_NONE};
		Pet ->
			pet_qualification_lvup_2(PlayerStatus,Pet)
	end.

pet_qualification_lvup_2(PlayerStatus,Pet)->
	if
		Pet#ets_users_pets.other_data#pet_other.up_quality + Pet#ets_users_pets.other_data#pet_other.up_quality2 > Pet#ets_users_pets.current_quality ->
			pet_qualification_lvup_3(PlayerStatus,Pet);
		true ->
			{false,?_LANG_PET_ERROR_QUALIFICATION_UP}
	end.
	
	
pet_qualification_lvup_3(PlayerStatus,Pet)->
	ItemTemplateId = if
			Pet#ets_users_pets.current_quality =< 20 ->
				260017;
			Pet#ets_users_pets.current_quality =< 40 ->
				260018;
			Pet#ets_users_pets.current_quality =< 60 ->
				260019;
			Pet#ets_users_pets.current_quality =< 80 ->
				260020;
			true ->
				260021
			end,
	case check_and_reduce_item_to_users( ItemTemplateId,PlayerStatus#ets_users.other_data#user_other.pid_item) of
		false ->
			{false,?_LANG_PET_ERROR_QUALIFICATION_NONE};
		true ->
			Template = data_agent:item_template_get(ItemTemplateId),
			AddExp = Template#ets_item_template.propert1,
			pet_qualification_lvup_4(PlayerStatus,Pet,AddExp)
	end.

			
pet_qualification_lvup_4(PlayerStatus,Pet,AddExp) ->
	Exp = Pet#ets_users_pets.quality_exp,
	NewExp = Exp + AddExp,
	CheckLevel = get_level_by_exp_2(NewExp),
	{Type,NewPet,NewPlayerStatus} = if 
						CheckLevel > Pet#ets_users_pets.current_quality -> 
							Pet1 = Pet#ets_users_pets{current_quality = CheckLevel,quality_exp = NewExp },
							Newpet1 = calc_properties(Pet1),
							if 	Newpet1#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
									PlayerStatus1 = lib_player:calc_pet_BattleInfo(PlayerStatus,Newpet1);
								true ->
									PlayerStatus1 = PlayerStatus
							end,
							
							lib_target:cast_check_target(PlayerStatus1#ets_users.other_data#user_other.pid_target,
														 [{?TARGET_PET,{?TARGET_PET_FIGHT,Newpet1#ets_users_pets.fight}},
														  {?TARGET_PET,{?TARGET_STAR,Newpet1#ets_users_pets.other_data#pet_other.star}},
														  {?TARGET_PET,{?TARGET_QUALIFICATION,Newpet1#ets_users_pets.current_quality}}
														  ]),
							{up,Newpet1,PlayerStatus1};
						true ->
							Pet1 = Pet#ets_users_pets{quality_exp = NewExp },
							{noup,Pet1,PlayerStatus}
					end,
	
	pet_qualification_lvup_5(NewPet),
	{ok,Type,NewPlayerStatus,NewPet}.


pet_qualification_lvup_5(Newpet) ->
	db_agent_pet:update_pet([{current_quality , Newpet#ets_users_pets.current_quality },
							 {quality_exp , Newpet#ets_users_pets.quality_exp },
							 {fight , Newpet#ets_users_pets.fight }
								   
								  ],[{id,Newpet#ets_users_pets.id}]),
	update_pet_by_id(Newpet).


%% ----------------------提升 end ------------------------

add_pet_exp(PlayerStatus,PetInfo,AddExp) ->
	PetLv = PetInfo#ets_users_pets.level,
			PetExp = PetInfo#ets_users_pets.exp,
			NewPetExp = AddExp + PetExp,
			CheckLevel = get_level_by_exp(NewPetExp),
			{_Type,NewPlayerStatus,NewPet} = 
				if
					CheckLevel > PetLv -> 
						PetInfo1 = PetInfo#ets_users_pets{level = CheckLevel,exp = NewPetExp },
						PetInfo2 =  calc_properties( PetInfo1),
						{ok,Bin} = pt_25:write(?PP_PET_UPGRADE,[PetInfo2#ets_users_pets.id, CheckLevel]),
						{ok,Bin1} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo2]),
						lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
						if 	PetInfo2#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
									PlayerStatus1 = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo2);
								true ->
									PlayerStatus1 = PlayerStatus
						end,
						lib_target:cast_check_target(PlayerStatus1#ets_users.other_data#user_other.pid_target,
													 [{?TARGET_PET,{?TARGET_PM_LEVEL,CheckLevel}},
													  {?TARGET_PET,{?TARGET_PET_FIGHT,PetInfo2#ets_users_pets.fight}}
													  ]),
						
						{up,PlayerStatus1,PetInfo2};
				   	true ->
					   	PetInfo1 = PetInfo#ets_users_pets{exp = NewPetExp },
					   	{ok,PlayerStatus,PetInfo1}
				end,
			update_pet_by_id(NewPet),
			db_agent_pet:update_pet([{level, NewPet#ets_users_pets.level },
										   {exp , NewPet#ets_users_pets.exp },
										   {fight , NewPet#ets_users_pets.fight }
										
										  ],[{id,NewPet#ets_users_pets.id}]),
			{NewPet#ets_users_pets.id,NewPlayerStatus,NewPetExp}.

%%增加宠物经验及升级(宠物斗坛专用)
add_pet_exp_and_lvup(PlayerStatus,PetID,AddExp) ->
	List = get_pet_dic(),
	case lists:keyfind(PetID, #ets_users_pets.id, List) of
		false ->
			{0,PlayerStatus,0};
		PetInfo ->
			add_pet_exp(PlayerStatus,PetInfo,AddExp)
	end.		

%%增加宠物经验及升级(enchase2,enchase3)
add_pet_exp_and_lvup(PlayerStatus,MonLv,ExpFix,ExpMon) ->
	List = get_pet_dic(),
	case lists:keyfind(?PET_FIGHT_STATE, #ets_users_pets.state, List) of
		false ->
			{0,PlayerStatus,0};
		PetInfo ->
			AddExp = lib_exp:get_exp_for_pet(PetInfo#ets_users_pets.level,MonLv,ExpFix,ExpMon),
			add_pet_exp(PlayerStatus,PetInfo,AddExp)
	end.
%%增加出战宠物经验
add_battle_pet_exp(PlayerStatus,AddExp) ->
	List = get_pet_dic(),
	case lists:keyfind(?PET_FIGHT_STATE, #ets_users_pets.state, List) of
		false ->
			{0,PlayerStatus,0};
		PetInfo ->
			add_pet_exp(PlayerStatus,PetInfo,AddExp)
	end.
%% 更新饥饿度
update_energy(PlayerStatus) ->
	List = get_pet_dic(),
	case lists:keyfind(?PET_FIGHT_STATE, #ets_users_pets.state, List) of
		false ->
			none;
		PetInfo ->
			PetEnergy = PetInfo#ets_users_pets.energy,
			NewPetExp = erlang:max(PetEnergy - 1, 0),
			PetInfo1 = PetInfo#ets_users_pets{energy = NewPetExp },
			db_agent_pet:update_pet([{energy, PetInfo1#ets_users_pets.energy }
										
										  ],[{id,PetInfo1#ets_users_pets.id}]),
			
			%% 通知饥饿度
			{ok, BinData} = pt_25:write(?PP_PET_ENERGY_UPDATE, [PetInfo1#ets_users_pets.id,  PetInfo1#ets_users_pets.energy]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinData),
			if
				NewPetExp =:= 0 ->
					{ok,[],NewList} = update_pet_state2([PetInfo1]),
					{ok,Bin} = pt_25:write(?PP_PET_STATE_CHANGE,[NewList]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
					{up,PetInfo1};
				true ->
					update_pet_by_id(PetInfo1),
					none
			end
	end.



%% ----------------------技能 start ------------------------

%% 技能书使用
skill_book_use(PlayerStatus,Place) ->
	case skill_book_use_1(PlayerStatus,Place) of
		{ok,Pet,PlayerStatus1} ->
			{ok,Bin} = pt_25:write(?PP_PET_LIST_UPDATE,[[Pet]]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,PlayerStatus1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.

skill_book_use_1(PlayerStatus,Place) ->
	List = get_pet_dic(),
	case lists:keyfind(?PET_FIGHT_STATE, #ets_users_pets.state, List) of
		false ->
			{false,?_LANG_PET_ERROR_FIGHT_NONE1};
		PetInfo ->
			skill_book_use_2(PlayerStatus,Place,PetInfo)
	end.

skill_book_use_2(PlayerStatus,Place,PetInfo) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_item_info_by_place', Place}) of
		[] ->
			{false,?_LANG_ERROR_ITEM_NONE};
		[ItemInfo] ->
			skill_book_use_3(PlayerStatus,ItemInfo,PetInfo)
	end.

skill_book_use_3(PlayerStatus,ItemInfo,PetInfo) ->
	Template = data_agent:item_template_get(ItemInfo#ets_users_items.template_id),
	case Template#ets_item_template.category_id =:= ?CATE_PET_SKILL_BOOK of
		true ->
			skill_book_use_4(PlayerStatus,ItemInfo,Template,PetInfo);
		_ ->
			{false,?_LANG_PET_ERROR_ITEM_TYPE_NONE}
	end.

skill_book_use_4(PlayerStatus,ItemInfo,Template,PetInfo) ->	
	IsSeal = Template#ets_item_template.propert1,
	StudySkillGroupID = Template#ets_item_template.propert2,
	StudySkillLevel = Template#ets_item_template.propert3,
	L = PetInfo#ets_users_pets.other_data#pet_other.skill_list,
	case lists:keyfind(StudySkillGroupID, #r_use_skill.skill_group, L)  of
		false ->
			if 
				IsSeal =:= 1 orelse StudySkillLevel=:=1 ->
					skill_book_use_4_1(PlayerStatus,PetInfo,ItemInfo,StudySkillGroupID,StudySkillLevel);
				true ->
				   {false,?_LANG_PET_ERROR_STUDY_LOW}
			end;
				
		USkill ->
			if 
				IsSeal =:= 1 ->
				   {false,?_LANG_PET_ERROR_TYPE_HAS_STUDY};
				true ->
					skill_book_use_4_2(PlayerStatus,PetInfo,USkill,ItemInfo,StudySkillGroupID,StudySkillLevel)
			end
	end.

skill_book_use_4_1(PlayerStatus,PetInfo,ItemInfo,StudySkillGroupID,StudySkillLevel) ->
	Len = length(PetInfo#ets_users_pets.other_data#pet_other.skill_list),
	case (Len + 1) =< PetInfo#ets_users_pets.other_data#pet_other.skill_cell_num of
		true ->
			skill_book_use_5(PlayerStatus,PetInfo,ItemInfo,StudySkillGroupID,StudySkillLevel);
		false ->
			{false,?_LANG_PET_ERROR_SKILL_CELL_FULL}
	end.

skill_book_use_4_2(PlayerStatus,PetInfo,USkill,ItemInfo,StudySkillGroupID,StudySkillLevel) ->
	if 
		(USkill#r_use_skill.skill_lv + 1) =:= StudySkillLevel ->
			skill_book_use_6(PlayerStatus,USkill,PetInfo,ItemInfo,StudySkillGroupID,StudySkillLevel);
		USkill#r_use_skill.skill_lv >= StudySkillLevel ->
			{false,?_LANG_PET_ERROR_HAS_STUDY};
		true ->
			{false,?_LANG_PET_ERROR_STUDY_LOW}
	end.

skill_book_use_5(PlayerStatus,PetInfo,ItemInfo,StudySkillGroupID,StudySkillLevel) ->
	%% 扣除物品
	gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'reduce_item_to_users_by_iteminfo',ItemInfo,?CONSUME_ITEM_USE}),
	L = PetInfo#ets_users_pets.other_data#pet_other.skill_list,
	Skill = lib_skill:get_skill_from_template_by_group_and_lv(StudySkillGroupID,StudySkillLevel),
	Time = misc_timer:now_seconds(),
	RS = #r_use_skill{
					   skill_id = Skill#ets_skill_template.skill_id,
					   skill_percent = 0,
					   skill_lv = Skill#ets_skill_template.current_level,
					   skill_group = Skill#ets_skill_template.group_id,
					   skill_lastusetime = 0,
					   skill_colddown = Skill#ets_skill_template.cold_down_time 
					  },
	SL = L ++ [RS],
	OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{ skill_list = SL },
	NewPet = PetInfo#ets_users_pets{ other_data = OtherInfo },
	
	Other = PlayerStatus#ets_users.other_data#user_other{pet_skill_list = SL},
	
	PlayerStatus1 = PlayerStatus#ets_users{other_data = Other},
	
	db_agent_pet:update_pet_skill(PetInfo#ets_users_pets.id,0,Skill#ets_skill_template.skill_id,Skill#ets_skill_template.current_level,Time),
	
	NewPet1 = calc_properties(NewPet),
	
	db_agent_pet:update_pet([
							 {fight , NewPet1#ets_users_pets.fight }
							],[{id,NewPet#ets_users_pets.id}]),

	
	lib_target:cast_check_target(PlayerStatus1#ets_users.other_data#user_other.pid_target,
														 [{?TARGET_PET,{?TARGET_PET_FIGHT,NewPet1#ets_users_pets.fight}}]),
	
	update_pet_by_id(NewPet1),
	PlayerStatus2 = update_playerstatus(PlayerStatus1),
	
	{ok,NewPet1,PlayerStatus2}.

skill_book_use_6(PlayerStatus,USkill,PetInfo,ItemInfo,StudySkillGroupID,StudySkillLevel) ->
	%% 扣除物品
	gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'reduce_item_to_users_by_iteminfo',ItemInfo,?CONSUME_ITEM_USE}),
	L = PetInfo#ets_users_pets.other_data#pet_other.skill_list,
	Skill = lib_skill:get_skill_from_template_by_group_and_lv(StudySkillGroupID,StudySkillLevel),
	RS = #r_use_skill{
					   skill_id = Skill#ets_skill_template.skill_id,
					   skill_percent = 0,
					   skill_lv = Skill#ets_skill_template.current_level,
					   skill_group = Skill#ets_skill_template.group_id,
					   skill_lastusetime = 0,
					   skill_colddown = Skill#ets_skill_template.cold_down_time 
					  },
	SL = lists:keyreplace(StudySkillGroupID,  #r_use_skill.skill_group, L, RS),
	OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{ skill_list = SL },
	NewPet = PetInfo#ets_users_pets{ other_data = OtherInfo },
	
	Other = PlayerStatus#ets_users.other_data#user_other{pet_skill_list = SL},	
	PlayerStatus1 = PlayerStatus#ets_users{other_data = Other},
	
	db_agent_pet:update_pet_skill(NewPet#ets_users_pets.id,USkill#r_use_skill.skill_id ,Skill#ets_skill_template.skill_id,StudySkillLevel,0),
	NewPet1 = calc_properties(NewPet),
	
	db_agent_pet:update_pet([
							 {fight , NewPet1#ets_users_pets.fight }
							],[{id,NewPet#ets_users_pets.id}]),
	
	lib_target:cast_check_target(PlayerStatus1#ets_users.other_data#user_other.pid_target,
														 [{?TARGET_PET,{?TARGET_PET_FIGHT,NewPet1#ets_users_pets.fight}}]
														 ),
	update_pet_by_id(NewPet1),
	PlayerStatus2 = update_playerstatus(PlayerStatus1),
	{ok,NewPet1,PlayerStatus2}.

	
%% 封印技能
seal_skill(PlayerStatus,PetId,GroupID) ->
	case seal_skill_1(PlayerStatus,PetId,GroupID) of
		{ok,NewPet} ->
			{ok,Bin} = pt_25:write(?PP_PET_REMOVE_SKILL,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_LIST_UPDATE,[[NewPet]]),
%% 			{ok,Bin1} = pt_25:write(?PP_PET_SKILL_UPDATE,[PetId,SkillList]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>);
		{ok,NewPet,PlayerStatus1} ->
		  	{ok,Bin} = pt_25:write(?PP_PET_REMOVE_SKILL,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_LIST_UPDATE,[[NewPet]]),
			
%% 			{ok,Bin1} = pt_25:write(?PP_PET_SKILL_UPDATE,[PetId,SkillList]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok,PlayerStatus1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.

seal_skill_1(PlayerStatus,PetId,GroupID) ->
	List = get_pet_dic(),
	case lists:keyfind(PetId, #ets_users_pets.id, List) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		Info ->
			seal_skill_2(PlayerStatus,Info,GroupID)
	end.

seal_skill_2(PlayerStatus,Info,GroupID) ->
	SkillList = Info#ets_users_pets.other_data#pet_other.skill_list,
	case lists:keyfind(GroupID, #r_use_skill.skill_group, SkillList) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		SkillInfo ->
			seal_skill_3(PlayerStatus,Info,SkillInfo)
	end.

seal_skill_3(PlayerStatus,Info,SkillInfo) ->
	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
	if 
		length(NullCells) > 0 ->
			case check_and_reduce_item_to_users( ?ITEM_PET_SKILL_SEAL,PlayerStatus#ets_users.other_data#user_other.pid_item) of
				true ->
					seal_skill_4(PlayerStatus,Info,SkillInfo);
				_ ->
					{false,?_LANG_PET_ERROR_SEAL_NONE}
			end;
		true ->
			{false,?_LANGUAGE_SALE_MSG_BAG_FULL}
	end.


seal_skill_4(PlayerStatus,Info,SkillInfo) ->
	SkillTemplate = lib_skill:get_skill_from_template( SkillInfo#r_use_skill.skill_id),
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'pet_book_seal',SkillTemplate#ets_skill_template.seal_id}) of
		true ->
			seal_skill_5(PlayerStatus,Info,SkillInfo);
		{false,Msg} ->
			{false,Msg}
	end.
	
seal_skill_5(PlayerStatus,Info,SkillInfo) ->
	SkillList = Info#ets_users_pets.other_data#pet_other.skill_list,
	NewList = lists:keydelete(SkillInfo#r_use_skill.skill_group, #r_use_skill.skill_group, SkillList),
	OtherInfo = Info#ets_users_pets.other_data#pet_other{ skill_list = NewList },
	NewPet = Info#ets_users_pets{ other_data = OtherInfo },
	
	db_agent_pet:delete_pet_skills([{id,NewPet#ets_users_pets.id},{template_id,SkillInfo#r_use_skill.skill_id}]),
	
	NewPet1 = calc_properties(NewPet),
	
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,
														 [{?TARGET_PET,{?TARGET_PET_FIGHT,NewPet1#ets_users_pets.fight}}]),
	
	update_pet_by_id(NewPet1),
	case NewPet1#ets_users_pets.state =:= ?PET_FIGHT_STATE of
		true ->
			Other = PlayerStatus#ets_users.other_data#user_other{pet_skill_list = NewList},	
			PlayerStatus1 = PlayerStatus#ets_users{other_data = Other},
			PlayerStatus2 = update_playerstatus(PlayerStatus1),
			{ok,NewPet1,PlayerStatus2};
		_ ->
			{ok,NewPet1}
	end.

	

%% 删除技能
delete_skill(PlayerStatus,PetId,GroupID) ->
	case delete_skill_1(PlayerStatus,PetId,GroupID) of
		{ok,NewPet} ->
			{ok,Bin} = pt_25:write(?PP_PET_REMOVE_SKILL1,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_LIST_UPDATE,[[NewPet]]),
%% 			{ok,Bin1} = pt_25:write(?PP_PET_SKILL_UPDATE,[PetId,SkillList]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>);
		{ok,NewPet,PlayerStatus1} ->
		  	{ok,Bin} = pt_25:write(?PP_PET_REMOVE_SKILL1,[1]),
			{ok,Bin1} = pt_25:write(?PP_PET_LIST_UPDATE,[[NewPet]]),
%% 			{ok,Bin1} = pt_25:write(?PP_PET_SKILL_UPDATE,[PetId,SkillList]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok,PlayerStatus1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.

delete_skill_1(PlayerStatus,PetId,GroupID) ->
	List = get_pet_dic(),
	case lists:keyfind(PetId, #ets_users_pets.id, List) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		Info ->
			delete_skill1(PlayerStatus,Info,PetId,GroupID)
	end.

delete_skill1(PlayerStatus,Info,PetId,GroupID) ->
	SkillList = Info#ets_users_pets.other_data#pet_other.skill_list,
	case lists:keyfind(GroupID, #r_use_skill.skill_group, SkillList) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		SkillInfo ->
			delete_skill2(PlayerStatus,Info,GroupID,SkillInfo,PetId)
	end.

delete_skill2(PlayerStatus,Info,GroupID,SkillInfo,PetId) ->
	SkillList = Info#ets_users_pets.other_data#pet_other.skill_list,
	NewList = lists:keydelete(GroupID, #r_use_skill.skill_group, SkillList),
	OtherInfo = Info#ets_users_pets.other_data#pet_other{ skill_list = NewList },
	NewPet = Info#ets_users_pets{ other_data = OtherInfo },
	db_agent_pet:delete_pet_skills([{id,PetId},{template_id,SkillInfo#r_use_skill.skill_id}]),
	
	
	NewPet1 = calc_properties(NewPet),
	update_pet_by_id(NewPet1),
	
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,
														 [{?TARGET_PET, {?TARGET_PET_FIGHT,NewPet1#ets_users_pets.fight}}]
														),
	
	case NewPet1#ets_users_pets.state =:= ?PET_FIGHT_STATE of
		true ->
			Other = PlayerStatus#ets_users.other_data#user_other{pet_skill_list = NewList},	
			PlayerStatus1 = PlayerStatus#ets_users{other_data = Other},
			PlayerStatus2 = update_playerstatus(PlayerStatus1),
			{ok,NewPet1,PlayerStatus2};
		_ ->
			{ok,NewPet1}
	end.



update_playerstatus(PlayerStatus) ->
	NewPlayerStatus = lib_player:calc_properties_send_self(PlayerStatus),
%% 	{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
%% 	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
	NewPlayerStatus.
	


%% 刷新技能书
ref_skill_book(PlayerStatus,Type)->
	case ref_skill_book1(PlayerStatus,Type) of
		{ok,NewPlayerStatus} ->
			{ok,Bin} = pt_25:write(?PP_PET_GET_SKILL_BOOK_LIST,[NewPlayerStatus#ets_users.pet_skill_books,
																   NewPlayerStatus#ets_users.pet_skill_books_luck]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.
	
ref_skill_book1(PlayerStatus,Type) ->
	case Type of
		0 -> %% 刷新一个 绑定
			ref_skill_book_1(PlayerStatus);
		1 -> %% 刷新一个 非绑定
			ref_skill_book_2(PlayerStatus);
		2 -> %% 刷新一组 绑定
			ref_skill_book_3(PlayerStatus);
		3 -> %% 刷新一组 非绑定
			ref_skill_book_4(PlayerStatus);
		_ ->
			{false,?_LANG_OPERATE_ERROR}
	end.

ref_skill_book_1(PlayerStatus) ->
	case lib_player:check_bind_yuanbao(PlayerStatus,?PET_SKILL_BOOK_ONCE_YUNBAO) of
		true ->
			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, ?PET_SKILL_BOOK_ONCE_YUNBAO, 0, 0,{?CONSUME_YUANBAO_REFRESH_PET,0,1}),
			ref_skill_book_5(PlayerStatus1,1,1);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_2(PlayerStatus) ->
	case lib_player:check_yuanbao(PlayerStatus,?PET_SKILL_BOOK_ONCE_YUNBAO) of
		true ->
			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,  ?PET_SKILL_BOOK_ONCE_YUNBAO, 0,0, 0,{?CONSUME_YUANBAO_REFRESH_PET,0,1}),
			ref_skill_book_5(PlayerStatus1,1,0);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_3(PlayerStatus) ->
	case lib_player:check_bind_yuanbao(PlayerStatus,?PET_SKILL_BOOK_GROUP_YUNBAO) of
		true ->
			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, ?PET_SKILL_BOOK_GROUP_YUNBAO, 0, 0,{?CONSUME_YUANBAO_REFRESH_PET,0,12}),
			ref_skill_book_5(PlayerStatus1,12,1);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_4(PlayerStatus) ->
	case lib_player:check_yuanbao(PlayerStatus,?PET_SKILL_BOOK_GROUP_YUNBAO) of
		true ->
			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,  ?PET_SKILL_BOOK_GROUP_YUNBAO, 0,0, 0,{?CONSUME_YUANBAO_REFRESH_PET,0,12}),
			ref_skill_book_5(PlayerStatus1,12,0);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_5(PlayerStatus,Num,Bind) ->
	Luck = PlayerStatus#ets_users.pet_skill_books_luck,
	{List,NewLuck} = ref_skill_book_6(Num,[],Luck),
	NewList = ref_skill_book_7(List,[],{0,Bind}),
	NewPlayerStatus = PlayerStatus#ets_users{
						   pet_skill_books_luck = NewLuck,
						   pet_skill_books = NewList
						  },
	db_agent_user:update_pet_skill_books(NewPlayerStatus#ets_users.id,
											NewPlayerStatus#ets_users.pet_skill_books,
											NewPlayerStatus#ets_users.pet_skill_books_luck),
	{ok,NewPlayerStatus}.

ref_skill_book_6(0,List,Luck) ->
	{List,Luck};
ref_skill_book_6(Num,List,Luck) ->
	Item = get_book(Luck),
	NewList = [ Item | List],
	NewLuck = Luck + 1,
	NewLuck1 = if
				  NewLuck >=1000 ->
					  1000;
				  true ->
					  NewLuck
			   end,
	ref_skill_book_6(Num -1,NewList,NewLuck1).

ref_skill_book_7([],BookList,_)->
	BookList;
ref_skill_book_7([ { Type,Type1 } | List],BookList,{Place,Bind})->
	ItemId = case Type =:= 0 of
				 true ->
					 260027;
				 _ ->
					 Sub = lists:nth(Type1, ?PET_SKILL_BOOK_SUB_LIST),
					 Sub + Type
			 end,
	ref_skill_book_7(List,[{Place,ItemId,Bind,Type} | BookList],{Place + 1,Bind}).


%% 获取技能书
get_skill_book(PlayerStatus,Place) ->
	case get_skill_book_1(PlayerStatus,Place) of
		{ok,NewPlayerStatus} ->
			{ok,Bin} = pt_25:write(?PP_PET_SKILL_ITEM_GET,[1,NewPlayerStatus#ets_users.pet_skill_books_luck]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.

get_skill_book_1(PlayerStatus,Place) ->
	NullCell = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'get_null_cells'}),
	case length(NullCell) > 0 of
		true ->
			get_skill_book_2(PlayerStatus,Place);
		_ ->
			{false,?_LANG_DAILY_AWARD_ITEM_ERROR}
	end.

		

get_skill_book_2(PlayerStatus,Place) ->
	BookList = PlayerStatus#ets_users.pet_skill_books,
	case lists:keyfind(Place, 1, BookList) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		{Place,TemplateId,IsBind,_Type} ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, { 'pet_books_add',TemplateId, 1, IsBind }),
			NewPlayerStatus = PlayerStatus#ets_users{pet_skill_books = [],
																  pet_skill_books_luck = 0},
			db_agent_user:update_pet_skill_books(NewPlayerStatus#ets_users.id,
															 NewPlayerStatus#ets_users.pet_skill_books,
															 NewPlayerStatus#ets_users.pet_skill_books_luck
															),
			{ok,NewPlayerStatus};
		_ ->
			{false,?_LANG_OPERATE_ERROR}
	end.


%% ----------------------技能 end ------------------------

calc_properties(PetInfo) ->
	calc_properties(PetInfo, online).
%% 刷新属性
calc_properties(PetInfo, State) ->%%当角色不在线的时候需要特殊处理state需要传入装备信息
	PetInfo1 = 
		case data_agent:pet_template_get({PetInfo#ets_users_pets.template_id, PetInfo#ets_users_pets.level}) of
			[] ->
				PetInfo;
			Attr ->
				OtherInfo = #pet_other{
										item_pid = PetInfo#ets_users_pets.other_data#pet_other.item_pid,
										up_quality = Attr#ets_pet_template.up_quality,
										up_grow_up = Attr#ets_pet_template.up_grow_up,
										attack = Attr#ets_pet_template.attack,
										magic_attack = Attr#ets_pet_template.magic_attack,
										far_attack = Attr#ets_pet_template.far_attack,
										mump_attack = Attr#ets_pet_template.mump_attack,
										power_hit = Attr#ets_pet_template.power_hit,
										hit = Attr#ets_pet_template.hit,
										skill_list = PetInfo#ets_users_pets.other_data#pet_other.skill_list,
										skill_cell_num = 4
									   },
				PetInfo#ets_users_pets{other_data = OtherInfo}
		end,
	PetInfo2 = calc_properties1(PetInfo1),
	PetInfo3 = calc_properties2(PetInfo2),
	PetInfo4 = calc_properties3(PetInfo3),
	PetInfo5 = calc_properties4(PetInfo4),
	PetInfo6 = calc_properties5(PetInfo5),
	PetInfo7 = lib_skill:cale_pasv_skill_pet(PetInfo6#ets_users_pets.other_data#pet_other.skill_list,[],PetInfo6),
	if	State =:= online ->
			PetInfo8 = calc_properties7(PetInfo7);
		true ->
			PetInfo8 = calc_properties7_1(PetInfo7, State)
	end,
	
	PetInfo9 = calc_properties6(PetInfo8),
	PetInfo10 = check_career(PetInfo9),
	if	State =:= online ->
			lib_pet_battle:update_pet_battle_fight(PetInfo10);
		true ->
			skip
	end,
	PetInfo10.

calc_properties7_1(PetInfo, ItemList) -> 
	Record = item_util:calc_equip_properties(ItemList),
	PetOther = PetInfo#ets_users_pets.other_data,
	OtherInfo = PetOther#pet_other{
										  	attack = PetOther#pet_other.attack + Record#other_item_template.attack,
											magic_attack = PetOther#pet_other.magic_attack + Record#other_item_template.magichurt,
											far_attack = PetOther#pet_other.far_attack + Record#other_item_template.farhurt,
											mump_attack = PetOther#pet_other.mump_attack + Record#other_item_template.mumphurt,
											hit = PetOther#pet_other.hit + Record#other_item_template.hit_target,
											power_hit = PetOther#pet_other.power_hit + Record#other_item_template.power_hit
										 },
	PetInfo#ets_users_pets{other_data = OtherInfo}.
%% 装备
calc_properties7(PetInfo) ->
	if 	PetInfo#ets_users_pets.other_data#pet_other.item_pid =:= undefine ->
			PetInfo;
		true ->
			case gen_server:call(PetInfo#ets_users_pets.other_data#pet_other.item_pid, {'get_pet_equip_properties',PetInfo#ets_users_pets.id,undefine}) of
		[ok, Record] ->
			%%?DEBUG("calc_properties7:~p",[Record]),
			PetOther = PetInfo#ets_users_pets.other_data,
			OtherInfo = PetOther#pet_other{
										  	attack = PetOther#pet_other.attack + Record#other_item_template.attack,
											magic_attack = PetOther#pet_other.magic_attack + Record#other_item_template.magichurt,
											far_attack = PetOther#pet_other.far_attack + Record#other_item_template.farhurt,
											mump_attack = PetOther#pet_other.mump_attack + Record#other_item_template.mumphurt,
											hit = PetOther#pet_other.hit + Record#other_item_template.hit_target,
											power_hit = PetOther#pet_other.power_hit + Record#other_item_template.power_hit
										 },
			 PetInfo#ets_users_pets{other_data = OtherInfo};
		_ ->
			PetInfo
			end
	end.
	
%% 品阶
calc_properties1(PetInfo) ->
	case data_agent:pet_stairs_template_get({PetInfo#ets_users_pets.template_id, PetInfo#ets_users_pets.stairs}) of
		[] ->
			PetInfo;
		Attr ->
			 OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{
										  	attack = Attr#ets_pet_stairs_template.attack + PetInfo#ets_users_pets.other_data#pet_other.attack,
											magic_attack = Attr#ets_pet_stairs_template.magic_attack + PetInfo#ets_users_pets.other_data#pet_other.magic_attack,
											far_attack = Attr#ets_pet_stairs_template.far_attack + PetInfo#ets_users_pets.other_data#pet_other.far_attack,
											mump_attack = Attr#ets_pet_stairs_template.mump_attack + PetInfo#ets_users_pets.other_data#pet_other.mump_attack,
											hit = Attr#ets_pet_stairs_template.hit + PetInfo#ets_users_pets.other_data#pet_other.hit,
											power_hit = Attr#ets_pet_stairs_template.power_hit + PetInfo#ets_users_pets.other_data#pet_other.power_hit,
										  	up_quality2 = Attr#ets_pet_stairs_template.up_quality + PetInfo#ets_users_pets.other_data#pet_other.up_quality2,
										 	up_grow_up2 = Attr#ets_pet_stairs_template.up_grow_up + PetInfo#ets_users_pets.other_data#pet_other.up_grow_up2
										 },
			 PetInfo#ets_users_pets{other_data = OtherInfo}
	end.


%% 资质
calc_properties2(PetInfo) ->
	case data_agent:pet_qualification_template_get({PetInfo#ets_users_pets.template_id, PetInfo#ets_users_pets.current_quality}) of
		[] ->
			PetInfo;
		Attr ->
			OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{
										 magic_attack2 = Attr#ets_pet_qualification_template.magic_attack + PetInfo#ets_users_pets.other_data#pet_other.magic_attack2,
										 far_attack2 = Attr#ets_pet_qualification_template.far_attack + PetInfo#ets_users_pets.other_data#pet_other.far_attack2,
										 mump_attack2 = Attr#ets_pet_qualification_template.mump_attack + PetInfo#ets_users_pets.other_data#pet_other.mump_attack2,
										 hit2 = Attr#ets_pet_qualification_template.hit + PetInfo#ets_users_pets.other_data#pet_other.hit2,
										 power_hit2 = Attr#ets_pet_qualification_template.power_hit + PetInfo#ets_users_pets.other_data#pet_other.power_hit2,
										 skill_cell_num = erlang:min(erlang:max(util:floor((PetInfo#ets_users_pets.current_quality - 20) / 10),0),4) + PetInfo#ets_users_pets.other_data#pet_other.skill_cell_num
										 },
			PetInfo#ets_users_pets{other_data = OtherInfo}
	end.

%% 成长
calc_properties3(PetInfo) ->
	case data_agent:pet_grow_up_template_get({PetInfo#ets_users_pets.template_id, PetInfo#ets_users_pets.current_grow_up}) of
		[] ->
			PetInfo;
		Attr ->
			 OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{
										  attack2 = Attr#ets_pet_grow_up_template.attack + PetInfo#ets_users_pets.other_data#pet_other.attack2,
										  hit2 = Attr#ets_pet_grow_up_template.hit + PetInfo#ets_users_pets.other_data#pet_other.hit2,
										  power_hit2 = Attr#ets_pet_grow_up_template.power_hit + PetInfo#ets_users_pets.other_data#pet_other.power_hit2,
										  skill_cell_num = erlang:min(erlang:max(util:floor((PetInfo#ets_users_pets.current_grow_up - 20) / 10),0),4) + PetInfo#ets_users_pets.other_data#pet_other.skill_cell_num
										 },
			 PetInfo#ets_users_pets{other_data = OtherInfo}
	end.


%% 星级
calc_properties4(PetInfo) ->
	Other1 = PetInfo#ets_users_pets.other_data#pet_other{
																 star = PetInfo#ets_users_pets.current_quality div 10
																},
	PetInfo1 = PetInfo#ets_users_pets{other_data = Other1},
	case data_agent:pet_star_template_get({PetInfo1#ets_users_pets.template_id, PetInfo1#ets_users_pets.other_data#pet_other.star}) of
		[] ->
			PetInfo1;
		Attr ->
			 OtherInfo = PetInfo1#ets_users_pets.other_data#pet_other{
										 attack2 = Attr#ets_pet_star_template.attack + PetInfo1#ets_users_pets.other_data#pet_other.attack2,
										 hit2 = Attr#ets_pet_star_template.hit + PetInfo1#ets_users_pets.other_data#pet_other.hit2
										 },
			 PetInfo1#ets_users_pets{other_data = OtherInfo}
	end.


%% 钻
calc_properties5(PetInfo) ->
	Other1 = PetInfo#ets_users_pets.other_data#pet_other{
														 diamond = PetInfo#ets_users_pets.current_grow_up div 10
														},
	
	PetInfo1 = PetInfo#ets_users_pets{other_data = Other1},
	case data_agent:pet_diamond_template_get({PetInfo1#ets_users_pets.template_id, PetInfo1#ets_users_pets.other_data#pet_other.diamond}) of
		[] ->
			PetInfo;
		Attr ->
			 OtherInfo = PetInfo1#ets_users_pets.other_data#pet_other{
											magic_attack2 = Attr#ets_pet_diamond_template.magic_attack + PetInfo1#ets_users_pets.other_data#pet_other.magic_attack2,
										 	far_attack2 = Attr#ets_pet_diamond_template.far_attack + PetInfo1#ets_users_pets.other_data#pet_other.far_attack2,
										 	mump_attack2 = Attr#ets_pet_diamond_template.mump_attack + PetInfo1#ets_users_pets.other_data#pet_other.mump_attack2,
										  	power_hit2 = Attr#ets_pet_diamond_template.power_hit  + PetInfo1#ets_users_pets.other_data#pet_other.power_hit2
										 },
			 PetInfo1#ets_users_pets{other_data = OtherInfo}
	end.

calc_properties6(PetInfo) ->
	Fight = calc_fight(PetInfo),
	PetInfo#ets_users_pets{fight = Fight}.

check_career(PetInfo) ->
	case PetInfo#ets_users_pets.type of
		1 ->
			OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{far_attack = 0,
										magic_attack = 0,
										far_attack2 = 0,
										magic_attack2 = 0},
			 PetInfo#ets_users_pets{other_data = OtherInfo};
		2 ->
			OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{far_attack = 0,
										mump_attack = 0,
										far_attack2 = 0,
										mump_attack2 = 0},
			 PetInfo#ets_users_pets{other_data = OtherInfo};
		_ ->
			OtherInfo = PetInfo#ets_users_pets.other_data#pet_other{mump_attack = 0,
										magic_attack = 0,
										mump_attack2 = 0,
										magic_attack2 = 0},
			PetInfo#ets_users_pets{other_data = OtherInfo}
	end.


%% 经验计算等级
get_level_by_exp(Exp)->
	List = ets:tab2list(?ETS_PET_EXP_TEMPLATE),
	F = fun(V1,V2) -> V1#ets_pet_exp_template.level < V2#ets_pet_exp_template.level end,
	LSort = lists:sort(F,List),
	get_level_by_exp1(LSort, Exp).

get_level_by_exp1([], _) ->
	?MAX_PET_LEVEL;

get_level_by_exp1([H|T], Exp) ->
	if 
		H#ets_pet_exp_template.total_exp > Exp ->
			H#ets_pet_exp_template.level -1;
		true ->
			get_level_by_exp1(T, Exp)
	end.


get_level_by_exp_1(Exp)->
	List = ets:tab2list(?ETS_PET_GROW_UP_EXP_TEMPLATE),
	F = fun(V1,V2) -> V1#ets_pet_grow_up_exp_template.level < V2#ets_pet_grow_up_exp_template.level end,
	LSort = lists:sort(F,List),
	get_level_by_exp1_1(LSort, Exp).

get_level_by_exp1_1([], _) ->
	?MAX_PET_LEVEL;

get_level_by_exp1_1([H|T], Exp) ->
	if 
		H#ets_pet_grow_up_exp_template.total_exp > Exp ->
			H#ets_pet_grow_up_exp_template.level -1;
		true ->
			get_level_by_exp1_1(T, Exp)
	end.


get_level_by_exp_2(Exp)->
	List = ets:tab2list(?ETS_PET_QUALIFICATION_EXP_TEMPLATE),
	F = fun(V1,V2) -> V1#ets_pet_qualification_exp_template.level < V2#ets_pet_qualification_exp_template.level end,
	LSort = lists:sort(F,List),
	get_level_by_exp1_2(LSort, Exp).

get_level_by_exp1_2([], _) ->
	?MAX_PET_LEVEL;

get_level_by_exp1_2([H|T], Exp) ->
	if 
		H#ets_pet_qualification_exp_template.total_exp > Exp ->
			H#ets_pet_qualification_exp_template.level -1;
		true ->
			get_level_by_exp1_2(T, Exp)
	end.


get_book(Luck) ->
	Rate = trunc((Luck/(Luck+70000)+0.0006) * 10000),
	Rate1 = trunc(Rate + (Luck/(Luck+4000)+0.006) * 10000),
	Rate2 = trunc(Rate1 + (Luck/(Luck+300)+0.01) * 10000),
	Rate3 = 10000,
	Random = util:rand(1, 10000),
	List = [{Rate,0},{Rate1,3},{Rate2,2},{Rate3,1}],
	{_, Type} = get_book(List, Random, []),
	Random1 = util:rand(1, 14),
	{Type,Random1}.


get_book([], _Random, BoxItem) ->
	BoxItem;
get_book([{Rate, Type} | BoxItemList], Random, BoxItem) ->
	if
		Random =< Rate ->
			get_book([], Random, {Rate, Type});
		true ->
			get_book(BoxItemList, Random, BoxItem )
	end.


check_and_reduce_item_to_users(TemplateId,ItemPid) ->
	gen_server:call(ItemPid, {'check_and_reduce_item_to_users', TemplateId, ?CONSUME_ITEM_USE}).

calc_fight(Pet) ->
	Fight = Pet#ets_users_pets.other_data#pet_other.attack + Pet#ets_users_pets.other_data#pet_other.attack2 + 
%% 	Pet#ets_users_pets.other_data#pet_other.defence + Pet#ets_users_pets.other_data#pet_other.defence2 +
%% 	(Pet#ets_users_pets.other_data#pet_other.total_hp + Pet#ets_users_pets.other_data#pet_other.total_hp2) * 0.2 +
	(Pet#ets_users_pets.other_data#pet_other.magic_attack + Pet#ets_users_pets.other_data#pet_other.magic_attack2 +
	Pet#ets_users_pets.other_data#pet_other.mump_attack + Pet#ets_users_pets.other_data#pet_other.mump_attack2 + 
	Pet#ets_users_pets.other_data#pet_other.far_attack +  Pet#ets_users_pets.other_data#pet_other.far_attack2 ) * 1.5 +
%% 	(Pet#ets_users_pets.other_data#pet_other.magic_defense + Pet#ets_users_pets.other_data#pet_other.magic_defense2+
%% 	Pet#ets_users_pets.other_data#pet_other.mump_defense + Pet#ets_users_pets.other_data#pet_other.mump_defense2+
%% 	Pet#ets_users_pets.other_data#pet_other.far_defense + Pet#ets_users_pets.other_data#pet_other.far_defense2) * 0.5,
	(Pet#ets_users_pets.other_data#pet_other.power_hit +Pet#ets_users_pets.other_data#pet_other.power_hit2 +
	Pet#ets_users_pets.other_data#pet_other.hit + Pet#ets_users_pets.other_data#pet_other.hit2
%% 	Pet#ets_users_pets.other_data#pet_other.duck + 
%% 	Pet#ets_users_pets.other_data#pet_other.deligency
	) * 5,
	round(Fight).


%% 检测
validate_name(Name) ->
	validate_name(len, Name).

validate_name(len, Name) ->
	case asn1rt:utf8_binary_to_list(list_to_binary(Name)) of
		{ok, CharList} ->
			Len = misc:string_width(CharList),   
			if
				Len < 4 ->
					{false, ?_LANG_PET_CREATE_TOO_SHORT};
				Len > 14 ->
					{false, ?_LANG_PET_CREATE_TOO_LONG};
				true ->
					case misc:name_ver(CharList) of
						true ->
                    		validate_name(sen_words, Name);
						_ ->
							{false, ?_LANG_PET_CREATE_NOT_VALID}
					end
			end;
		{error, _Reason} ->
            %%非法字符
			{false, ?_LANG_PET_CREATE_NOT_VALID}
	end;


%%是否包含敏感词
%%Name:角色名
validate_name(sen_words, Name) ->
    case lib_words_ver:words_ver(Name) of
        true ->
			true;  
        false ->
            %包含敏感词
            {false, ?_LANG_PET_CREATE_NOT_VALID} 
    end;

validate_name(_, _Name) ->
    {false, 2}.
