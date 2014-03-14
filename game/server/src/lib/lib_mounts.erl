%% Author: liaoxiaobo
%% Created: 2012-10-29
%% Description: TODO: Add description to lib_mounts
-module(lib_mounts).

%%
%% Include files
%%
-include("common.hrl").

-define(MAX_MOUNTS_LEVEL, 120).	
-define(MAX_MOUNTS_COUNT,3).
-define(MAX_STAIRS,60).
-define(DIC_USERS_MOUNTS, dic_users_mounts). %% 玩家坐骑字典

-define(SKILL_BOOK_LIST,[]). %%技能书列表 

-define(MOUNTS_SKILL_BOOK_ONCE_YUNBAO,10).
-define(MOUNTS_SKILL_BOOK_GROUP_YUNBAO,110).
-define(LOW_REFINED_PERCENT, 5).				%% 成功洗练后提升属性最低百分比
-define(HIGH_REFINED_PERCENT, 20).				%% 成功洗练后提升属性最高百分比
-define(REFINED_COPPER_HIGH, 90).				%% 铜币洗练初始成功率
-define(REFINED_YUANBAO_HIGH, 100).			%% 元宝洗练初始成功率
-define(REFINED_COPPER_LOW, 10).				%% 铜币洗练最低成功率
-define(REFINED_YUANBAO_LOW, 20).				%% 元宝洗练最低成功率
-define(REFINED_DOWN_PERLV, 2).					%% 洗练每上升一阶降低的成功率
-define(TYPE_HP, 1).
-define(TYPE_MP, 2).
-define(TYPE_ATTACK, 3).
-define(TYPE_DEFENCE, 4).
-define(TYPE_PROPERTY_ATTACK, 5).
-define(TYPE_MAG_DEFENCE, 6).
-define(TYPE_FAR_DEFENCE, 7).
-define(TYPE_MUMP_DEFENCE, 8).
-define(CHANGE, 1).
-define(NOCHANGE, 2).
-define(MAX, 3).
%%
%% Exported Functions
%%

%% -compile([export_all]).

-export([
		 init_template/0,
		 init_online_mounts/2,
		 get_mounts/2,
		 mounts_to_list/5,
		 mounts_stairs_lvup/3,
		 mounts_grow_up_lvup/4,
		 mounts_qualification_lvup/4,
		 add_exp_and_lvup/3,
		 update_mounts_state/3,
		 seal_skill/4,
		 delete_skill/3,
		 check_mounts_count/1,
		 check_skill_use/2,
		 mounts_released/2,
 		 get_skill_book_list/3,
		 ref_skill_book/2,
		 get_skill_book/3,
		 get_fight_mounts_info/0,
		 get_fight_mounts/0,
		 update_skill/3,
		 get_other_mounts_info/4,
		 get_mounts_by_id/1,
		 mounts_refined_update/3,
		 update_ronghe/3
		]).

%%
%% API Functions
%%


%% ------------------------初始化模板数据 start--------------------------
init_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_template.template_id, Record#ets_mounts_template.level},
				  NewRecord = Record#ets_mounts_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_mounts_template() of
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
	init_refined_template(),
	init_refined_template1(),
	ok.

init_stairs_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_stairs_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_stairs_template.template_id, Record#ets_mounts_stairs_template.stairs},
				  NewRecord = Record#ets_mounts_stairs_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_STAIRS_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_mounts_stairs_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_qualification_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_qualification_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_qualification_template.template_id, Record#ets_mounts_qualification_template.qualification},
				  NewRecord = Record#ets_mounts_qualification_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_QUALIFICATION_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_mounts_qualification_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_grow_up_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_grow_up_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_grow_up_template.template_id, Record#ets_mounts_grow_up_template.grow_up},
				  NewRecord = Record#ets_mounts_grow_up_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_GROW_UP_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_mounts_grow_up_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_star_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_star_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_star_template.template_id, Record#ets_mounts_star_template.star},
				  NewRecord = Record#ets_mounts_star_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_STAR_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_mounts_star_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_diamond_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_diamond_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_diamond_template.template_id, Record#ets_mounts_diamond_template.diamond},
				  NewRecord = Record#ets_mounts_diamond_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_DIAMOND_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_mounts_diamond_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List); 
        _ -> skip
    end,
	ok.


init_exp_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_exp_template] ++ (Info)),
                  ets:insert(?ETS_MOUNTS_EXP_TEMPLATE, Record)
           end,
    case db_agent_template:get_mounts_exp_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_refined_template1() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_mounts_refined_template] ++ (Info)),
				  Template_Id = {Record#ets_mounts_refined_template.template_id, Record#ets_mounts_refined_template.level},
				  NewRecord = Record#ets_mounts_refined_template{
														 template_id = Template_Id
														},
                  ets:insert(?ETS_MOUNTS_REFINED_TEMPLATE1, NewRecord)
           end,
	case db_agent_template:get_mounts_refined_template() of
		[] -> skip;
		List when is_list(List) ->	
			lists:foreach(F, List);
		_ -> skip
	end,
	ok.

init_refined_template() ->
	case db_agent_template:get_mounts_refined_template() of
		[] -> skip;
		List when is_list(List) ->	
			calc_refined_template(List, []);
		_ -> skip
	end,
	ok.

calc_refined_template(List, List1) ->
	[Info_|List2] = List,
	Info = list_to_tuple([ets_mounts_refined_template] ++ (Info_)),
	if 	List1 =:= [] ->
			Template_Id = {Info#ets_mounts_refined_template.template_id, Info#ets_mounts_refined_template.level},
			NewInfo = Info#ets_mounts_refined_template{template_id = Template_Id},
			ets:insert(?ETS_MOUNTS_REFINED_TEMPLATE, NewInfo),
			calc_refined_template(List, [NewInfo|List1]);
		List2 =:= [] ->
			List1;
		true ->
			[Info1_|_] = List2,
			Info1 = list_to_tuple([ets_mounts_refined_template] ++ (Info1_)),
			Template_Id = {Info#ets_mounts_refined_template.template_id, Info#ets_mounts_refined_template.level},
			NewInfo = Info#ets_mounts_refined_template{template_id = Template_Id, 
													total_hp = Info1#ets_mounts_refined_template.total_hp - Info#ets_mounts_refined_template.total_hp,
													total_mp = Info1#ets_mounts_refined_template.total_mp - Info#ets_mounts_refined_template.total_mp,
													attack = Info1#ets_mounts_refined_template.attack - Info#ets_mounts_refined_template.attack,
													defence = Info1#ets_mounts_refined_template.defence - Info#ets_mounts_refined_template.defence,
													property_attack = Info1#ets_mounts_refined_template.property_attack - Info#ets_mounts_refined_template.property_attack,
													magic_defence = Info1#ets_mounts_refined_template.magic_defence - Info#ets_mounts_refined_template.magic_defence,
													far_defence = Info1#ets_mounts_refined_template.far_defence - Info#ets_mounts_refined_template.far_defence,
													mump_defence = Info1#ets_mounts_refined_template.mump_defence - Info#ets_mounts_refined_template.mump_defence
														},
			ets:insert(?ETS_MOUNTS_REFINED_TEMPLATE, NewInfo),
			calc_refined_template(List2, [NewInfo|List1])
	end.
%% ------------------------初始化模板数据 end--------------------------

%% 初始化在线玩家坐骑
init_online_mounts(UserID,Career) ->
	F = fun(Info)->
				Record = list_to_tuple([ets_users_mounts] ++ (Info)),
				SkillList = init_mounts_skill(Record#ets_users_mounts.id),
				[Hp, Mp, Attack, Defence, Property_attack, Magic_defence, Far_defence, Mump_defence] 
					= tool:split_string_to_intlist(Record#ets_users_mounts.random_refined, ","),
				Other = #mounts_other {skill_list = SkillList, 
									total_hp3 = Hp, 
									total_mp3 = Mp, 
									attack3 = Attack, 
									defence3 = Defence, 
									property_attack3 = Property_attack, 
									magic_defence3 = Magic_defence,
									far_defence3 = Far_defence, 
									mump_defence3 = Mump_defence
									},
			
				Record1 = Record#ets_users_mounts{ other_data  = Other},
				calc_properties(Career, Record1)				
		end,
	List = db_agent_mounts:get_user_all_mounts(UserID),
	NewList = [F(Info) || Info <- List],
	update_mounts_dic(NewList),
	ok.

init_mounts_by_id(ID,Career) ->
	Info = db_agent_mounts:get_mounts_info_by_condition([{id,ID}],[],[]),
	case Info =/= [] of
		true ->
			Record = list_to_tuple([ets_users_mounts] ++ (Info)),
			SkillList = init_mounts_skill(Record#ets_users_mounts.id),
			[Hp, Mp, Attack, Defence, Property_attack, Magic_defence, Far_defence, Mump_defence] 
					= tool:split_string_to_intlist(Record#ets_users_mounts.random_refined, ","),
			Other = #mounts_other {skill_list = SkillList, 
									total_hp3 = Hp, 
									total_mp3 = Mp, 
									attack3 = Attack, 
									defence3 = Defence, 
									property_attack3 = Property_attack, 
									magic_defence3 = Magic_defence,
									far_defence3 = Far_defence, 
									mump_defence3 = Mump_defence
									},
			Record1 = Record#ets_users_mounts{ other_data  = Other},
			calc_properties(Career, Record1);
		
		_ ->
			[]
	end.



init_mounts_skill(ID) ->
	F = fun(Info) ->
				   Record = list_to_tuple([ets_users_mounts_skill] ++ (Info)),
				   D = lib_skill:get_skill_from_template(Record#ets_users_mounts_skill.template_id),
				   #r_use_skill{
					   skill_id = Record#ets_users_mounts_skill.template_id,
					   skill_percent = 0,
					   skill_lv = D#ets_skill_template.current_level,
					   skill_group = D#ets_skill_template.group_id,
					   skill_lastusetime = Record#ets_users_mounts_skill.study_time,
					   skill_colddown = D#ets_skill_template.cold_down_time 
					  }
	  end,
	List = db_agent_mounts:get_mounts_all_skills(ID),
	NewList = [F(Info) || Info <- List],
	NewList.


get_mounts_dic() ->
	case get(?DIC_USERS_MOUNTS) of 
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

update_mounts_dic(List)->
	put(?DIC_USERS_MOUNTS,List).

get_mounts_by_id(ID) ->
	List = get_mounts_dic(),
	case lists:keyfind(ID, #ets_users_mounts.id, List) of
		false ->
			[];
		Info ->
			Info
	end.

delete_mounts_by_id(ID) ->
	List = get_mounts_dic(),
	NewList = lists:keydelete(ID, #ets_users_mounts.id, List),
	update_mounts_dic(NewList).

update_mousts_by_id(Mounts) ->
	List = get_mounts_dic(),
	NewList = lists:keyreplace(Mounts#ets_users_mounts.id, #ets_users_mounts.id, List,Mounts),
	update_mounts_dic(NewList).


get_current_skill_skillid(SkillList,ID) ->
	case lists:keyfind(ID, #r_use_skill.skill_id , SkillList) of
		false ->
			{error};
		SkillInfo ->
			SkillInfo
	end.


%% 获得自己的坐骑信息
get_mounts(ID,PidSend) ->
	List = case ID =:= 0 of
			   true ->
				   get_mounts_dic();
			   _ ->
				   [get_mounts_by_id(ID)]
		   end,
	{ok,Bin} = pt_28:write(?PP_MOUNT_LIST_UPDATE,[List]),
	lib_send:send_to_sid(PidSend,Bin).


%% 获取他人坐骑信息 不在线则读数据库
get_other_mounts_info(SelfUserId,UserID,MountsID,PidSend) ->
	case get_other_mounts_info(SelfUserId,UserID,MountsID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 ?_LANG_MOUNTS_ERROR_NONE]);
		Info ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_GET_OTHER_MOUNTS,[Info]),
			lib_send:send_to_sid(PidSend,Bin)
	end.

get_other_mounts_info(SelfUserId,Id,MountsID) ->
	case Id =:= SelfUserId of
		true ->
			get_mounts_by_id(MountsID);
		_ ->
			case lib_player:get_online_info(Id) of
				[] -> %不在线
					{_,Career,_,_,_,_,_,_} = lib_player:get_player_info_guild_use_by_id(Id),
					init_mounts_by_id(MountsID,Career);
				I ->
					case gen_server:call(I#ets_users.other_data#user_other.pid_item , {'get_mounts_info', MountsID}) of
					{ok,Info} ->
						Info;
					_ ->
						[]
					end
			end
	end.


%% 获得出战坐骑信息
get_fight_mounts_info() ->
	List = get_mounts_dic(),
	case lists:keyfind(?MOUNTS_FIGHT_STATE, #ets_users_mounts.state, List) of
		false ->
			{false};
		Info ->
			{ok,Info}
	end.


%% 获得出战坐骑
%% {template_id,speed}
get_fight_mounts() ->
	List = get_mounts_dic(),
	case lists:keyfind(?MOUNTS_FIGHT_STATE, #ets_users_mounts.state, List) of
		false ->
			{0,[]};
		Info ->
			{Info#ets_users_mounts.template_id ,Info}
		
	end.


%% ----------------------使用道具创建一个坐骑 start ------------------------
check_mounts_count(PidSend) ->
	case check_mounts_count() of
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

check_mounts_count() ->
	L = get_mounts_dic(),
	Len = length(L),
	case Len + 1 > ?MAX_MOUNTS_COUNT of
		true ->
			{false,?_LANG_MOUNTS_ERROR_UP};
		_ ->
			{ok}
	end.

%% 生成一个坐骑
mounts_to_list(Career,ItemInfo,Template,PidSend,PlayerPid) ->
	case mounts_to_list(Career,ItemInfo,Template,PlayerPid) of
		{ok,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_LIST_UPDATE,[[Mounts]]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 Msg])
	end.

mounts_to_list(Career,ItemInfo,Template,PlayerPid) ->
	Mounts = create_mounts(Career,ItemInfo,Template),
	case db_agent_mounts:create_mounts(Mounts) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			DBMounts = db_agent_mounts:get_mounts_info_by_condition([{user_id, Mounts#ets_users_mounts.user_id},
																	 {template_id, Mounts#ets_users_mounts.template_id}],
																	[{id,desc}],
																	[1]),
			DBMountsInfo = list_to_tuple([ets_users_mounts] ++ DBMounts),
			DBMountsInfo1 = DBMountsInfo#ets_users_mounts{other_data = Mounts#ets_users_mounts.other_data},
			List = get_mounts_dic(),
			update_mounts_dic([DBMountsInfo1|List]),
			
			case Template#ets_item_template.propert5 of
				3 ->
					TL = [{?TARGET_MOUNTS,{?TARGET_Q1,1}}];
				4 ->
					TL = [{?TARGET_MOUNTS,{?TARGET_Q2,1}}];
				_ ->
					TL = []
			end,
			lib_target:cast_check_target(PlayerPid,[{?TARGET_MOUNTS,{0,1}} | TL]),
			
			{ok,DBMountsInfo1};
        _Other ->
            {false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	 end.

%% 创建一个坐骑
create_mounts(Career,ItemInfo,Template) ->
	Other = #mounts_other{ skill_list = [],
						   skill_cell_num = 4},
	Mounts = #ets_users_mounts{	
						      user_id = ItemInfo#ets_users_items.user_id,                       %% 用户Id	
						      template_id = Template#ets_item_template.propert1,               %% 坐骑模板ID
	                          name = Template#ets_item_template.name,
						      stairs = Template#ets_item_template.propert2,                     %% 阶级	
						      level = Template#ets_item_template.propert3,               		%% 坐骑等级	
						      exp = Template#ets_item_template.propert4 ,                        %% 经验	
							  other_data = Other
							},
 	Mounts1 = calc_properties(Career,Mounts),
	Mounts1.



%% ----------------------使用道具创建一个坐骑 end ------------------------

%% ----------------------坐骑放生 start ------------------------
%% 放生
mounts_released(ID,PidSend) ->
	case mounts_released(ID) of
		{ok,Mounts} ->
			%% 放生成功
			{ok,Bin} = pt_28:write(?PP_MOUNT_LIST_UPDATE,[[Mounts]]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.
mounts_released(ID) ->
	L = get_mounts_dic(),
	Len = length(L),
	case Len =:= 1 of
		true ->
			{false,?_LANG_MOUNTS_ERROR_FIGHT_NONE3};
		_ ->
			mounts_released1(ID)
	end.

mounts_released1(ID) ->
	case get_mounts_by_id(ID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Info ->
			mounts_released2(Info)
	end.

mounts_released2(Info) ->
	case Info#ets_users_mounts.state =/= ?MOUNTS_FIGHT_STATE of
		true ->
			mounts_released3(Info);
		_ ->
			{false,?_LANG_MOUNTS_ERROR_FIGHT_NONE2}
	end.	

mounts_released3(Info) ->
	NewInfo = Info#ets_users_mounts{is_exit = 0},
	db_agent_mounts:update_mounts([{is_exit, 0}],[{id,Info#ets_users_mounts.id}]),
	delete_mounts_by_id(Info#ets_users_mounts.id),
	{ok,NewInfo}.

%% ----------------------坐骑放生 end ------------------------

%% ----------------------坐骑修改状态 start ------------------------
%% 修改状态
update_mounts_state(ID,State,PidSend) ->
	case update_mounts_state(ID,State) of
		{ok,[],NewList} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_STATE_CHANGE,[NewList]),
			lib_send:send_to_sid(PidSend,Bin),
			{ok};
		{ok,Mounts1,[]}-> 
			{ok,Bin} = pt_28:write(?PP_MOUNT_STATE_CHANGE,[[Mounts1]]),
			lib_send:send_to_sid(PidSend,Bin),
			{ok,Mounts1};
		{ok,Mounts1,NeedUpdate}-> 
			{ok,Bin} = pt_28:write(?PP_MOUNT_STATE_CHANGE,[[Mounts1|NeedUpdate]]),
			lib_send:send_to_sid(PidSend,Bin),
			{ok,Mounts1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			{false}
	end.

update_mounts_state(ID,State) ->
	case get_mounts_by_id(ID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			if 
				Mounts#ets_users_mounts.state =:= State ->
					{false,?_LANG_MOUNTS_ERROR_IS_THIS_STATE};
				State =:= ?MOUNTS_FIGHT_STATE ->
					update_mounts_state1(ID,Mounts);
				State =:= ?MOUNTS_CALL_BACK_STATE ->
					update_mounts_state2([Mounts]);
				true ->
					{false,?_LANG_OPERATE_ERROR}
			end
	end.

%% 出战
update_mounts_state1(ID,Mounts) ->
	List = get_mounts_dic(),
	case length(List) of
		1 ->
			Mounts1 = update_mounts_state1_2(ID,Mounts),
			{ok,Mounts1,[]};
		_ ->
			update_mounts_state1_1(List,ID,Mounts)
	end.

update_mounts_state1_1(List,ID,Mounts) ->
	F = fun(Info,L) ->
				case Info#ets_users_mounts.state =:= ?MOUNTS_FIGHT_STATE of
					true ->
						Mounts1 = Info#ets_users_mounts{state = ?MOUNTS_CALL_BACK_STATE},
						db_agent_mounts:update_mounts([{state , Mounts1#ets_users_mounts.state }],[{id,Mounts1#ets_users_mounts.id}]),
						update_mousts_by_id(Mounts1),
						[Mounts1|L];
					_ ->
						L
				end
		end,
	NeedUpdate = lists:foldl(F, [], List),
	
	Mounts1 = update_mounts_state1_2(ID,Mounts),
	{ok,Mounts1,NeedUpdate}.

update_mounts_state1_2(ID,Mounts) ->
	Mounts1 = Mounts#ets_users_mounts{state = ?MOUNTS_FIGHT_STATE},
	db_agent_mounts:update_mounts([{state , Mounts1#ets_users_mounts.state }],[{id,ID}]),
	update_mousts_by_id(Mounts1),
	Mounts1.


%% 休息
update_mounts_state2(List) ->
	F = fun(Mounts) ->
				Mounts1 = Mounts#ets_users_mounts{state = ?MOUNTS_CALL_BACK_STATE},
				db_agent_mounts:update_mounts([{state , Mounts1#ets_users_mounts.state }],[{id,Mounts1#ets_users_mounts.id}]),
				update_mousts_by_id(Mounts1),
				Mounts1
		end,	
	NewList = [F(Info) || Info <- List],
	{ok,[],NewList}.
	
%% ----------------------坐骑修改状态 end ------------------------


%% ----------------------进阶 start ------------------------
%% 进阶
mounts_stairs_lvup(PlayerStatus,ItemStatus,ID) ->
	case mounts_stairs_lvup1(PlayerStatus,ItemStatus,ID) of
		{ok,fail,NeedCopper,NewItemStatus} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_STAIRS_UPDATE,[0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NeedCopper,NewItemStatus};
		{ok,NeedCopper,NewItemStatus,Mounts,Re} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_STAIRS_UPDATE,[1]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,
									<<Bin/binary,Bin1/binary>>),
			
			{ok,NeedCopper,Re,NewItemStatus};
		
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false

	end.
mounts_stairs_lvup1(PlayerStatus,ItemStatus,ID)->
	case get_mounts_by_id(ID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			mounts_stairs_lvup2(PlayerStatus,ItemStatus,Mounts)
	end.
			
mounts_stairs_lvup2(PlayerStatus,ItemStatus,Mounts)->
	UpLevel =  Mounts#ets_users_mounts.stairs + 1,
	NeedCopper =  500 + UpLevel*100,
	case lib_player:check_cash(PlayerStatus,0,NeedCopper) of
		true ->
			mounts_stairs_lvup3(PlayerStatus,ItemStatus,Mounts,NeedCopper);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.

mounts_stairs_lvup3(PlayerStatus,ItemStatus,Mounts,NeedCopper)->
	CheckLevel =  Mounts#ets_users_mounts.stairs + 1,
	if
		CheckLevel > ?MAX_STAIRS ->
			{false,?_LANG_MOUNTS_ERROR_MAX_STAIRS};
		true ->
			mounts_stairs_lvup4(PlayerStatus,ItemStatus,Mounts,NeedCopper)
	end.

mounts_stairs_lvup4(PlayerStatus,ItemStatus,Mounts,NeedCopper)->
	case use_item_by_type([?ITEM_MOUNTS_STAIRS_UP],ItemStatus) of
		false ->
			{false,?_LANG_MOUNTS_ERROR_STAIRS_ITEM_NONE};
		{ok,NewItemStatus} ->
%% 			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			mounts_stairs_lvup5(PlayerStatus,NeedCopper,NewItemStatus,Mounts)
	end.

	
mounts_stairs_lvup5(PlayerStatus,NeedCopper,NewItemStatus,Mounts)->
	CheckLevel =  Mounts#ets_users_mounts.stairs + 1,
	Rate = if 
		CheckLevel =< 2 ->
			10000;
	   	CheckLevel =< 6 ->
		   	9000;
	   	CheckLevel =< 11 ->
		   	8000;
	   	CheckLevel =< 16 ->
		   	7000;
	   	CheckLevel =< 21 ->
		   	6000;
		CheckLevel =< 26 ->
		   	5000;
	   	CheckLevel =< 31 ->
		   	4000;
	   	CheckLevel =< 36 ->
		   	3000;	
	   	CheckLevel =< 41 ->
		   	2000;
	  	CheckLevel =< 46 ->
		   	1000;
		CheckLevel =< 48 ->
		   	900;
		CheckLevel =< 50 ->
		   	800;
		CheckLevel =< 52 ->
		   	700;
		CheckLevel =< 60 ->
		   	500;	   
	   	true ->
		   	500	   
	end,
	
	Random = util:rand(1, 10000),
	if
		Rate + PlayerStatus#ets_users.other_data#user_other.vip_mounts_stair_rate >= Random   ->
			mounts_stairs_lvup6(PlayerStatus,NeedCopper,NewItemStatus,Mounts);
		true ->
			{ok,fail,NeedCopper,NewItemStatus}
	end.

mounts_stairs_lvup6(PlayerStatus,NeedCopper,NewItemStatus,Mounts)->
	CheckLevel = Mounts#ets_users_mounts.stairs + 1,
	Mounts1 =  Mounts#ets_users_mounts{stairs = CheckLevel},
	TL = [{?TARGET_MOUNTS,{?TARGET_STAIRS,CheckLevel}}],
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,[{?TARGET_MOUNTS,{?TARGET_STAIRS,CheckLevel}}]),
	Re = if
			  (CheckLevel rem 15) == 0 andalso Mounts#ets_users_mounts.state =:= ?MOUNTS_FIGHT_STATE ->
				  1;
			  true ->
				  0
		 end,
	
	NewMounts1 = calc_properties(PlayerStatus#ets_users.career, Mounts1),
	
	TL1 = [{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts1#ets_users_mounts.other_data#mounts_other.fight}}|TL],
	
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,TL1),

	db_agent_mounts:update_mounts([{stairs , NewMounts1#ets_users_mounts.stairs },
								  {fight , NewMounts1#ets_users_mounts.other_data#mounts_other.fight }
								  ],[{id,NewMounts1#ets_users_mounts.id}]),
	update_mousts_by_id(NewMounts1),
	
	
%% 	NewPlayerStatus = update_playerstatus(PlayerStatus,NewMounts1),
	{ok,NeedCopper,NewItemStatus,NewMounts1,Re}.
		

%% ----------------------进阶 end ------------------------


%% ----------------------进化 start ------------------------
%% 进化
mounts_grow_up_lvup(PlayerStatus,ItemStatus,IsProt,ID) ->
	case mounts_grow_up_lvup_1(PlayerStatus,ItemStatus,IsProt,ID) of
		{ok,fail,NeedCopper,NewItemStatus} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_GROW_UPDATE,[0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NeedCopper,NewItemStatus};
		{ok,fail,NeedCopper,NewItemStatus,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_GROW_UPDATE,[0]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,
								 <<Bin/binary,Bin1/binary>>),
			{ok,NeedCopper,NewItemStatus};
		{ok,NeedCopper,TL,NewItemStatus,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_GROW_UPDATE,[1]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,
								 <<Bin/binary,Bin1/binary>>),
			
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,TL),

			{ok,NeedCopper,NewItemStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	
	end.
mounts_grow_up_lvup_1(PlayerStatus,ItemStatus,IsProt,ID)->
	case get_mounts_by_id(ID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			mounts_grow_up_lvup_2(PlayerStatus,ItemStatus,IsProt,Mounts)
	end.

		
mounts_grow_up_lvup_2(PlayerStatus,ItemStatus,IsProt,Mounts)->
	CheckV = Mounts#ets_users_mounts.current_grow_up + 1,
	case (Mounts#ets_users_mounts.other_data#mounts_other.up_grow_up + Mounts#ets_users_mounts.other_data#mounts_other.up_grow_up2) < CheckV  of
		true ->
			{false,?_LANG_MOUNTS_ERROR_GROW_UP_UP};
		_ ->
			mounts_grow_up_lvup_3(PlayerStatus,ItemStatus,IsProt,Mounts,CheckV)
	end.

mounts_grow_up_lvup_3(PlayerStatus,ItemStatus,IsProt,Mounts,CheckV) ->
	NeedCopper =  500+CheckV*100,
	case lib_player:check_cash(PlayerStatus,0,NeedCopper) of
		true ->
			mounts_grow_up_lvup_4(PlayerStatus#ets_users.career,ItemStatus,IsProt,Mounts,CheckV,NeedCopper);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.

mounts_grow_up_lvup_4(Career,ItemStatus,IsProt,Mounts,CheckV,NeedCopper)->
	case use_item_by_type([?ITEM_MOUNTS_GROW_UP],ItemStatus) of
		false ->
			{false,?_LANG_MOUNTS_ERROR_GROW_ITEM_NONE};
		{ok,NewItemStatus} ->
%% 			lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			mounts_grow_up_lvup_5(Career,NeedCopper,NewItemStatus,IsProt,Mounts,CheckV)
	end.


mounts_grow_up_lvup_5(Career,NeedCopper,ItemStatus,IsProt,Mounts,CheckV) ->
	if 
		IsProt =:= 1 ->
			mounts_grow_up_lvup_5_1(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		true ->
			mounts_grow_up_lvup_5_2(Career,NeedCopper,ItemStatus,Mounts,CheckV)
	end.

mounts_grow_up_lvup_5_1(Career,NeedCopper,ItemStatus,Mounts,CheckV)->
	case use_item_by_type([?ITEM_MOUNTS_GROW_PROT],ItemStatus) of
		false ->
			mounts_grow_up_lvup_5_2(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		{ok,NewItemStatus} ->
			mounts_grow_up_lvup_5_3(Career,NeedCopper,NewItemStatus,Mounts,CheckV)
	end.

mounts_grow_up_lvup_5_2(Career,NeedCopper,ItemStatus,Mounts,CheckV)->
	Rate = if
			   CheckV =< 10 ->
				   10000;
			   CheckV =< 20 ->
				   8000;
			   CheckV =< 30 ->
				   7000;
			   CheckV =< 40 ->
				   6000;
			   CheckV =< 50 ->
				   4000;
			   CheckV =< 60 ->
				   3000;
			   CheckV =< 70 ->
				   2000;
			   CheckV =< 80 ->
				   1000;
			   CheckV =< 90 ->
				   500;
			   CheckV =< 100 ->
				   200;
			   true ->
				    200
		   end,
	
	Random = util:rand(1, 10000),
	if
		Random =< Rate ->
			mounts_grow_up_lvup_7(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		true ->
			if
				(CheckV-1) rem 10 =:= 0 ->
					{ok,fail,NeedCopper,ItemStatus};
				true ->
					mounts_grow_up_lvup_6(Career,NeedCopper,ItemStatus,Mounts,CheckV)
			end
	end.

mounts_grow_up_lvup_5_3(Career,NeedCopper,ItemStatus,Mounts,CheckV)->
	Rate = if
			   CheckV =< 10 ->
				   10000;
			   CheckV =< 20 ->
				   8000;
			   CheckV =< 30 ->
				   7000;
			   CheckV =< 40 ->
				   6000;
			   CheckV =< 50 ->
				   4000;
			   CheckV =< 60 ->
				   3000;
			   CheckV =< 70 ->
				   2000;
			   CheckV =< 80 ->
				   1000;
			   CheckV =< 90 ->
				   500;
			   CheckV =< 100 ->
				   200;
			   true ->
				    200
		   end,
	
	Random = util:rand(1, 10000),
	if
		Random =< Rate ->
			mounts_grow_up_lvup_7(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		true ->
			{ok,fail,NeedCopper,ItemStatus}
	end.

mounts_grow_up_lvup_6(Career,NeedCopper,ItemStatus,Mounts,CheckV) ->
	Mounts1 =  Mounts#ets_users_mounts{current_grow_up = CheckV-2},
	
	NewMounts = calc_properties(Career, Mounts1),
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts#ets_users_mounts.other_data#mounts_other.fight}} ]),
	mounts_grow_up_lvup_8(NewMounts),
	
%% 	NewPlayerStatus = update_playerstatus(PlayerStatus,NewMounts),
	
	{ok,fail,NeedCopper,ItemStatus,NewMounts}.


mounts_grow_up_lvup_7(Career,NeedCopper,ItemStatus,Mounts,CheckV) ->
	CheckV1 = CheckV div 10,
	Mounts1 =  Mounts#ets_users_mounts{current_grow_up = CheckV},
	TL = [{?TARGET_MOUNTS,{?TARGET_GROW_UP,CheckV}}],
	Mounts3 = 
		if
			Mounts1#ets_users_mounts.other_data#mounts_other.diamond =/= CheckV1 ->
				TL1 = [{?TARGET_MOUNTS,{?TARGET_DIAMOND,CheckV1}}| TL],
				Other1 = Mounts1#ets_users_mounts.other_data#mounts_other{diamond = CheckV1},
				Mounts1#ets_users_mounts{other_data = Other1};
			true ->
				TL1 = TL,
				Mounts1
		end,
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,TL1),
	
	NewMounts = calc_properties(Career, Mounts3),
	TL2 = [{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts#ets_users_mounts.other_data#mounts_other.fight}}|TL1],
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts#ets_users_mounts.other_data#mounts_other.fight}} ]),
	mounts_grow_up_lvup_8(NewMounts),
	
%% 	NewPlayerStatus = update_playerstatus(PlayerStatus,NewMounts),
						 
	{ok,NeedCopper,TL2,ItemStatus,NewMounts}.


mounts_grow_up_lvup_8(NewMounts) ->
	db_agent_mounts:update_mounts([
								   {current_grow_up , NewMounts#ets_users_mounts.current_grow_up },
								   {fight , NewMounts#ets_users_mounts.other_data#mounts_other.fight }
								   
								  ],[{id,NewMounts#ets_users_mounts.id}]),
	update_mousts_by_id(NewMounts).

%% ----------------------进化 start ------------------------


%% ----------------------提升 start ------------------------
%% 提升
mounts_qualification_lvup(PlayerStatus,ItemStatus,IsProt,ID) ->
	case mounts_qualification_lvup_1(PlayerStatus,ItemStatus,IsProt,ID) of
		{ok,fail,NeedCopper,NewItemStatus} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_QUALITY_UPDATE,[0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NeedCopper,NewItemStatus};
		{ok,fail,NeedCopper,NewItemStatus,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_QUALITY_UPDATE,[0]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,
								 <<Bin/binary,Bin1/binary>>),
			
			{ok,NeedCopper,NewItemStatus};
		{ok,NeedCopper,TL,NewItemStatus,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_QUALITY_UPDATE,[1]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,TL),
			{ok,NeedCopper,NewItemStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.


mounts_qualification_lvup_1(PlayerStatus,ItemStatus,IsProt,ID)->
	case get_mounts_by_id(ID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			mounts_qualification_lvup_2(PlayerStatus,ItemStatus,IsProt,Mounts)
	end.

mounts_qualification_lvup_2(PlayerStatus,ItemStatus,IsProt,Mounts)->
	CheckV = Mounts#ets_users_mounts.current_quality + 1,
	case (Mounts#ets_users_mounts.other_data#mounts_other.up_quality + Mounts#ets_users_mounts.other_data#mounts_other.up_quality2) < CheckV  of
		true ->
			{false,?_LANG_MOUNTS_ERROR_QUALIFICATION_UP};
		_ ->
			mounts_qualification_lvup_3(PlayerStatus,ItemStatus,IsProt,Mounts,CheckV)
	end.


mounts_qualification_lvup_3(PlayerStatus,ItemStatus,IsProt,Mounts,CheckV) ->
	NeedCopper =  500+CheckV*100,
	case lib_player:check_cash(PlayerStatus,0,NeedCopper) of
		true ->
			mounts_qualification_lvup_4(PlayerStatus#ets_users.career,NeedCopper,ItemStatus,IsProt,Mounts,CheckV,NeedCopper);
		_ ->
			{false,?_LANG_MAIL_LESS_COPPER}
	end.


mounts_qualification_lvup_4(Career,NeedCopper,ItemStatus,IsProt,Mounts,CheckV,NeedCopper)->
	case use_item_by_type([?ITEM_MOUNTS_QUALIFICATION_UP],ItemStatus) of
		false ->
			{false,?_LANG_MOUNTS_ERROR_QUALIFICATION_NONE};
		{ok,NewItemStatus} ->
%% 			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			mounts_qualification_lvup_5(Career,NeedCopper,NewItemStatus,IsProt,Mounts,CheckV)
	end.


mounts_qualification_lvup_5(Career,NeedCopper,ItemStatus,IsProt,Mounts,CheckV) ->
	if 
		IsProt =:= 1 ->
			mounts_qualification_lvup_5_1(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		true ->
			mounts_qualification_lvup_5_2(Career,NeedCopper,ItemStatus,Mounts,CheckV)
	end.

mounts_qualification_lvup_5_1(Career,NeedCopper,ItemStatus,Mounts,CheckV)->
	case use_item_by_type([?ITEM_MOUNTS_QUALIFICATION_PROT],ItemStatus) of
		false ->
			mounts_qualification_lvup_5_2(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		{ok,NewItemStatus} ->
			mounts_qualification_lvup_5_3(Career,NeedCopper,NewItemStatus,Mounts,CheckV)
	end.

mounts_qualification_lvup_5_2(Career,NeedCopper,ItemStatus,Mounts,CheckV)->
	Rate = if
			  CheckV =< 10 ->
				   10000;
			   CheckV =< 20 ->
				   8000;
			   CheckV =< 30 ->
				   7000;
			   CheckV =< 40 ->
				   6000;
			   CheckV =< 50 ->
				   4000;
			   CheckV =< 60 ->
				   3000;
			   CheckV =< 70 ->
				   2000;
			   CheckV =< 80 ->
				   1000;
			   CheckV =< 90 ->
				   500;
			   CheckV =< 100 ->
				   200;
			   true ->
				    200
		   end,
	
	Random = util:rand(1, 10000),
	if
		Random =< Rate ->
			mounts_qualification_lvup_7(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		true ->
			if
				(CheckV-1) rem 10 =:= 0 ->
					{ok,fail,NeedCopper,ItemStatus};
				true ->
					mounts_qualification_lvup_6(Career,NeedCopper,ItemStatus,Mounts,CheckV)
			end
	end.

mounts_qualification_lvup_5_3(Career,NeedCopper,ItemStatus,Mounts,CheckV)->
	Rate = if
			   CheckV =< 10 ->
				   10000;
			   CheckV =< 20 ->
				   8000;
			   CheckV =< 30 ->
				   7000;
			   CheckV =< 40 ->
				   6000;
			   CheckV =< 50 ->
				   4000;
			   CheckV =< 60 ->
				   3000;
			   CheckV =< 70 ->
				   2000;
			   CheckV =< 80 ->
				   1000;
			   CheckV =< 90 ->
				   500;
			   CheckV =< 100 ->
				   200;
			   true ->
				    200
		   end,
	
	Random = util:rand(1, 10000),
	if
		Random =< Rate ->
			mounts_qualification_lvup_7(Career,NeedCopper,ItemStatus,Mounts,CheckV);
		true ->
			{ok,fail,NeedCopper,ItemStatus}
	end.

mounts_qualification_lvup_6(Career,NeedCopper,ItemStatus,Mounts,CheckV) ->
	Mounts1 =  Mounts#ets_users_mounts{current_quality = CheckV-2},
	
	NewMounts = calc_properties(Career, Mounts1),
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts#ets_users_mounts.other_data#mounts_other.fight}} ]),
	mounts_qualification_lvup_8(NewMounts),
	
%% 	NewPlayerStatus = update_playerstatus(PlayerStatus,NewMounts),
	
	{ok,fail,NeedCopper,ItemStatus,NewMounts}.



mounts_qualification_lvup_7(Career,NeedCopper,ItemStatus,Mounts,CheckV) ->
	CheckV1 = CheckV div 10,
	Mounts1 =  Mounts#ets_users_mounts{current_quality = CheckV},
	TL = [{?TARGET_MOUNTS,{?TARGET_QUALIFICATION,CheckV}}],
	Mounts3 = 
		if
			Mounts1#ets_users_mounts.other_data#mounts_other.star =/= CheckV1 ->
				TL1 = [{?TARGET_MOUNTS,{?TARGET_STAR,CheckV1}} | TL],
				
				Other1 = Mounts1#ets_users_mounts.other_data#mounts_other{star = CheckV1},
				Mounts1#ets_users_mounts{other_data = Other1};
			true ->
				TL1 = TL,
				Mounts1
		end,
	
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,TL1),
	NewMounts = calc_properties(Career, Mounts3),
	TL2 = [{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts#ets_users_mounts.other_data#mounts_other.fight}}|TL1],
%% 	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMounts#ets_users_mounts.other_data#mounts_other.fight}} ]),
	mounts_qualification_lvup_8(NewMounts),
	
%% 	NewPlayerStatus = update_playerstatus(PlayerStatus,Mounts),
		
	{ok,NeedCopper,TL2,ItemStatus,NewMounts}.

mounts_qualification_lvup_8(NewMounts) ->
	db_agent_mounts:update_mounts([
								   {current_quality , NewMounts#ets_users_mounts.current_quality },
								   {fight , NewMounts#ets_users_mounts.other_data#mounts_other.fight }				   
								  ],[{id,NewMounts#ets_users_mounts.id}]),
	update_mousts_by_id(NewMounts).

%% ---------------------- 洗练 ------------------------------------
%%坐骑洗练
mounts_refined_update(PlayerStatus, ID, IsYuanBao) ->
	case mounts_refined_update1(PlayerStatus, ID, IsYuanBao) of
		{Type, Mounts, YuanBao, Copper} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_REFINED_UPDATE,[Mounts]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary, Bin1/binary>>),
			if Type =:= up ->
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 ?_LANG_MOUNTS_UP_REFINED]);
				true ->
					skip
			end,
			{ok, YuanBao, Copper};
%% 		{up, Mounts, YuanBao, Copper} -> 
%% 			{ok,Bin} = pt_28:write(?PP_MOUNT_REFINED_UPDATE,[Mounts]),
%% 			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
%% 			{ok, YuanBao, Copper};
		{fail, Msg, Copper} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			{ok, 0, Copper}
	end.

mounts_refined_update1(PlayerStatus, ID, IsYuanBao) ->
	case get_mounts_by_id(ID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			UpLevel = Mounts#ets_users_mounts.level,	%%当前坐骑洗练等阶上限
			CurrentLevel = Mounts#ets_users_mounts.current_refined + 1, %%坐骑当前洗练等阶
			NeedCopper = calc_refined_copper(CurrentLevel),
			NeedYuanBao = calc_refined_yuanbao(CurrentLevel),
			Career = PlayerStatus#ets_users.career,
			if Mounts#ets_users_mounts.current_refined >= UpLevel ->
					{fail, ?_LANG_MOUNTS_ERROR_MAX_REFINED, 0};
				IsYuanBao =:= 1 andalso PlayerStatus#ets_users.yuan_bao < NeedYuanBao ->
					{fail, ?_LANG_MOUNTS_ERROR_NO_YUANBAO, 0};
				IsYuanBao =:= 0 andalso (PlayerStatus#ets_users.bind_copper + PlayerStatus#ets_users.copper) < NeedCopper ->
					{fail, ?_LANG_MOUNTS_ERROR_NO_COPPER, 0};
				true ->									
					%% 元宝和铜币升级几率不一样
					if IsYuanBao =:= 1 ->
							Percent = ?REFINED_YUANBAO_HIGH;
%% 							Percent1 = ?REFINED_YUANBAO_HIGH - ?REFINED_DOWN_PERLV * Mounts#ets_users_mounts.current_refined,
%% 							Percent = max(Percent1, ?REFINED_YUANBAO_LOW);
						true ->
							Percent1 = ?REFINED_COPPER_HIGH - ?REFINED_DOWN_PERLV * Mounts#ets_users_mounts.current_refined,
							Percent = max(Percent1, ?REFINED_COPPER_LOW)
					end,
					case calc_random_refined_add(Percent, CurrentLevel, Mounts) of
						{fail, Res} ->
							{fail, Res, 0};
						List ->
					%% 元宝增加保底，如果没有属性提升就强制提升随机一处属性
							Refined_List = List,
%% 							if IsYuanBao =:= 1 ->
%% 									case lists:keyfind(?CHANGE, 3, List) of  %% 检查洗练是否成功
%% 										false ->									
%% 											F2 = fun(Info, List_) ->
%% 												{Num, AddNum, Res, Type} = Info,
%% 												if Res =:= ?MAX ->
%% 														List_;											
%% 													true ->
%% 														[{Num, AddNum, Res, Type}|List_]
%% 												end
%% 											end,
%% 											List1 = lists:foldl(F2, [], List), 							%% 把没有达到最大值的元素存进List1
%% 											Length = length(List1),
%% 											Baodi_Num = util:rand(1, Length),							%% 获取随机元素的序号
%% 											{Num, AddNum, _, Type} = lists:nth(Baodi_Num, List1),		%% 通过序号获取随机元素
%% 											{Num1, AddNum1, _, Type1} = calc_random_refined_add1(Num, AddNum, 100, Type),
%% 											lists:keyreplace(Type, 4, List, {Num1, AddNum1, ?CHANGE, Type1});
%% 										_ ->
%% 											List
%% 									end;
%% 								true ->
%% 									List
%% 							end,							
							case lists:keyfind(?CHANGE, 3, Refined_List) of
								false ->
									{fail, ?_LANG_MOUNTS_FAIL_REFINED, NeedCopper};
								_ ->
									{Type, NewMounts} = change_random_refined(Refined_List, Mounts, Career),
									if IsYuanBao =:= 1 ->
											{Type, NewMounts, NeedYuanBao, 0};
										true ->
											{Type, NewMounts, 0, NeedCopper}
									end
							end
					end
			end
	end.

calc_random_refined_add(Percent, Level, Mounts) ->
	case data_agent:mounts_refined_template_get({Mounts#ets_users_mounts.template_id, Level}) of
		[] ->
			{fail, ?_LANG_MOUNTS_FAIL_REFINED};
		Attr ->
			Info1 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.total_hp3, Attr#ets_mounts_refined_template.total_hp, Percent, ?TYPE_HP),
			Info2 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.total_mp3, Attr#ets_mounts_refined_template.total_mp, Percent, ?TYPE_MP),
			Info3 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.attack3, Attr#ets_mounts_refined_template.attack, Percent, ?TYPE_ATTACK),
			Info4 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.defence3, Attr#ets_mounts_refined_template.defence, Percent, ?TYPE_DEFENCE),        
			Info5 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.property_attack3, Attr#ets_mounts_refined_template.property_attack, Percent, ?TYPE_PROPERTY_ATTACK),
			Info6 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.magic_defence3, Attr#ets_mounts_refined_template.magic_defence, Percent, ?TYPE_MAG_DEFENCE),
			Info7 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.far_defence3, Attr#ets_mounts_refined_template.far_defence, Percent, ?TYPE_FAR_DEFENCE),
			Info8 = calc_random_refined_add1(Mounts#ets_users_mounts.other_data#mounts_other.mump_defence3, Attr#ets_mounts_refined_template.mump_defence, Percent, ?TYPE_MUMP_DEFENCE),
			[Info1] ++ [Info2] ++ [Info3] ++ [Info4] ++ [Info5] ++ [Info6] ++ [Info7] ++ [Info8]
	end.

%% 通过百分比增加坐骑洗练属性
calc_random_refined_add1(OldNum, AddNum, Percent, Type) ->
	if OldNum >= AddNum ->
			{AddNum, AddNum, ?MAX, Type};	
		true ->
			Random1 = util:rand(1, 100),
			if Random1 =< Percent ->
					Random2 = util:rand(?LOW_REFINED_PERCENT, ?HIGH_REFINED_PERCENT),
					NewNum = OldNum + tool:ceil(AddNum * Random2 / 100),
					{min(NewNum, AddNum), AddNum, ?CHANGE, Type};
				true ->
					{OldNum, AddNum, ?NOCHANGE, Type}
			end
	end.

%% 更新坐骑洗练信息
change_random_refined(List, Mounts, Career) ->
	F1 = fun(Info, Value) ->
			{Num, AddNum, _, _} = Info,
			if Num < AddNum ->
					not_max;
				true ->
					Value
			end
		end,
	Result = lists:foldl(F1, ?MAX, List),
	F_Sort = fun(X,Y) ->
				{_, _, _, Type11} = X,
				{_, _, _, Type22} = Y,
				Type11 > Type22
			end,
	List1 = lists:sort(F_Sort, List),
	F2 = fun(Info, List_) ->
			{Num, _, _, _} = Info,
			[Num|List_]
		end,
	List2 = lists:foldl(F2, [], List1),
	Str = tool:intlist_to_string_2(List2),
	Type = 
	if Result =:= ?MAX ->
			Mounts1 = Mounts#ets_users_mounts{current_refined = Mounts#ets_users_mounts.current_refined + 1,
												random_refined = "0,0,0,0,0,0,0,0"},
			[Hp, Mp, Attack, Defence, Property_attack, Magic_defence, Far_defence, Mump_defence] 
 						= [0,0,0,0,0,0,0,0],
			up;			
		true ->
			Mounts1 = Mounts#ets_users_mounts{random_refined = Str},
			[Hp, Mp, Attack, Defence, Property_attack, Magic_defence, Far_defence, Mump_defence] 
 						= List2,
			ok
	end,
	Other_data = Mounts1#ets_users_mounts.other_data#mounts_other{
									total_hp3 = Hp, 
									total_mp3 = Mp, 
									attack3 = Attack, 
									defence3 = Defence, 
									property_attack3 = Property_attack, 
									magic_defence3 = Magic_defence,
									far_defence3 = Far_defence, 
									mump_defence3 = Mump_defence
									},
	NewMounts = Mounts1#ets_users_mounts{other_data = Other_data},
	NewMounts1 = calc_properties(Career, NewMounts),
	db_agent_mounts:update_mounts([{current_refined, NewMounts1#ets_users_mounts.current_refined},
								   {random_refined , NewMounts1#ets_users_mounts.random_refined}
								  ],[{id, NewMounts1#ets_users_mounts.id}]),
	update_mousts_by_id(NewMounts1),
	{Type, NewMounts1}.
										
calc_refined_copper(Level) ->
	if Level * 800 < 80000 ->
			Level * 800;
		true ->
			80000
	end.

calc_refined_yuanbao(Level) ->
	Num = Level / 20,
	Num1 = Num * Num,
	6 * tool:ceil(Num1).
%% ----------------------洗练 end ----------------------------

%% ----------------------提升 start ------------------------
			

%% ----------------------喂养 start ------------------------


%%增加坐骑经验及升级
add_exp_and_lvup(PlayerStatus,MountsId,AddExp) ->
	case add_exp_and_lvup_0(PlayerStatus,MountsId,AddExp) of
		{ok,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_EXP_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok};
		{up,Mounts} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_EXP_UPDATE,[Mounts]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_ATT_UPDATE,[Mounts]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok,1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			{ok}
	end.

add_exp_and_lvup_0(PlayerStatus,MountsId,AddExp) ->
	case get_mounts_by_id(MountsId) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			add_exp_and_lvup_1(PlayerStatus,Mounts,AddExp)
	end.

add_exp_and_lvup_1(PlayerStatus,Mounts,AddExp) ->
	MountsExp = Mounts#ets_users_mounts.exp,
	NewMountsExp = MountsExp + AddExp,
	CheckLevel = get_level_by_exp(NewMountsExp),
	{Type,NewMounts} = if 
		CheckLevel > Mounts#ets_users_mounts.level -> 
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_PM_LEVEL,CheckLevel}}]),
			Mounts1 = Mounts#ets_users_mounts{level = CheckLevel,exp = NewMountsExp },
			Mounts3 =  calc_properties(PlayerStatus#ets_users.career, Mounts1),
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,Mounts3#ets_users_mounts.other_data#mounts_other.fight}} ]),
			{up,Mounts3};
	   true ->
		   Mounts1 = Mounts#ets_users_mounts{exp = NewMountsExp },
		   {ok,Mounts1}
	end,
	db_agent_mounts:update_mounts([{level, NewMounts#ets_users_mounts.level },
								   {exp , NewMounts#ets_users_mounts.exp },
								   {fight , NewMounts#ets_users_mounts.other_data#mounts_other.fight }
								
								  ],[{id,NewMounts#ets_users_mounts.id}]),
	update_mousts_by_id(NewMounts),
	{Type,NewMounts}.
	


%% ----------------------喂养 end ------------------------


%% 融合
update_ronghe(PlayerStatus,MainID,MasterID) ->
	case update_ronghe_1(PlayerStatus,MainID,MasterID) of
		{ok,UpdatePets} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_INHERIT,[1]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_LIST_UPDATE,[UpdatePets]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.


update_ronghe_1(PlayerStatus,MainID,MasterID) ->
	case get_mounts_by_id(MainID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			update_ronghe_2(PlayerStatus,Mounts,MasterID)
	end.

update_ronghe_2(PlayerStatus,MainMounts,MasterID) ->
	case get_mounts_by_id(MasterID) of
		[] ->
			{false,?_LANG_MOUNTS_ERROR_NONE};
		Mounts ->
			update_ronghe_3(PlayerStatus,MainMounts,Mounts)
	end.

update_ronghe_3(PlayerStatus,MainMounts,MasterMounts) ->
	case MainMounts#ets_users_mounts.state =/= ?MOUNTS_FIGHT_STATE of
		true ->
			update_ronghe_4(PlayerStatus,MainMounts,MasterMounts);
		_ ->
			{false,?_LANG_MOUNTS_ERROR_FIGHT_NONE4}
	end.


update_ronghe_4(PlayerStatus,MainMounts,MasterMounts) ->
	case MasterMounts#ets_users_mounts.state =/= ?MOUNTS_FIGHT_STATE of
		true ->
			update_ronghe_5(PlayerStatus,MainMounts,MasterMounts);
		_ ->
			{false,?_LANG_MOUNTS_ERROR_FIGHT_NONE4}
	end.


update_ronghe_5(PlayerStatus,MainMounts,MasterMounts) ->
	Level = erlang:max(MainMounts#ets_users_mounts.level, MasterMounts#ets_users_mounts.level),
	Exp = erlang:max(MainMounts#ets_users_mounts.exp, MasterMounts#ets_users_mounts.exp),
	Stairs = erlang:max(MainMounts#ets_users_mounts.stairs, MasterMounts#ets_users_mounts.stairs),
	Quality = erlang:max(MainMounts#ets_users_mounts.current_quality, MasterMounts#ets_users_mounts.current_quality),
	Grow = erlang:max(MainMounts#ets_users_mounts.current_grow_up, MasterMounts#ets_users_mounts.current_grow_up),
	Current_refined = max(MainMounts#ets_users_mounts.current_refined, MasterMounts#ets_users_mounts.current_refined),
	List_refined1 = tool:split_string_to_intlist(MainMounts#ets_users_mounts.random_refined, ","),
	List_refined2 = tool:split_string_to_intlist(MasterMounts#ets_users_mounts.random_refined, ","),
	F = fun(Num, Result) ->
			Result + Num
		end,
	Num1 = lists:foldl(F, 0, List_refined1),
	Num2 = lists:foldl(F, 0, List_refined2),
	if Num1 > Num2 ->
			[Hp, Mp, Attack, Defence, Property_attack, Magic_defence, Far_defence, Mump_defence] = List_refined1,
			Random_refined = MainMounts#ets_users_mounts.random_refined;
		true ->
			[Hp, Mp, Attack, Defence, Property_attack, Magic_defence, Far_defence, Mump_defence] = List_refined2,
			Random_refined = MasterMounts#ets_users_mounts.random_refined
	end,
	NewMainMounts =  MainMounts#ets_users_mounts{
								   level = Level,
								   exp = Exp,
								   stairs = Stairs,
								   current_quality = Quality,
								   current_grow_up = Grow, 
								   current_refined = Current_refined,
								   random_refined = Random_refined
								},
	Other_data = NewMainMounts#ets_users_mounts.other_data#mounts_other{
									total_hp3 = Hp, 
									total_mp3 = Mp, 
									attack3 = Attack, 
									defence3 = Defence, 
									property_attack3 = Property_attack, 
									magic_defence3 = Magic_defence,
									far_defence3 = Far_defence, 
									mump_defence3 = Mump_defence
									},
	NewMainMounts_ = NewMainMounts#ets_users_mounts{other_data = Other_data},
	NewMainMounts1 = calc_properties(PlayerStatus#ets_users.career,NewMainMounts_),
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,NewMainMounts1#ets_users_mounts.other_data#mounts_other.fight}} ]),
	db_agent_mounts:update_mounts([{level , NewMainMounts1#ets_users_mounts.level },
							 {exp , NewMainMounts1#ets_users_mounts.exp },
							 {stairs , NewMainMounts1#ets_users_mounts.stairs },
							 {current_quality , NewMainMounts1#ets_users_mounts.current_quality },
							 {current_grow_up , NewMainMounts1#ets_users_mounts.current_grow_up },
							 {fight , NewMainMounts1#ets_users_mounts.other_data#mounts_other.fight },
							 {current_refined , NewMainMounts1#ets_users_mounts.current_refined },
							 {random_refined , NewMainMounts1#ets_users_mounts.random_refined }
								  ],[{id,NewMainMounts1#ets_users_mounts.id}]),
	update_mousts_by_id(NewMainMounts1),
	
	NewMasterMounts = MasterMounts#ets_users_mounts{is_exit = 0},
	db_agent_mounts:update_mounts([{is_exit, 0}],[{id,NewMasterMounts#ets_users_mounts.id}]),
	
	delete_mounts_by_id(NewMasterMounts#ets_users_mounts.id),
	{ok,[NewMainMounts1] ++ [NewMasterMounts]}.


%% ----------------------技能 start ------------------------


check_skill_use(Template,PidSend) ->
	case check_skill_use(Template) of
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

check_skill_use(Template) ->
	List = get_mounts_dic(),
	case lists:keyfind(?MOUNTS_FIGHT_STATE, #ets_users_mounts.state, List) of
		false ->
			{false,?_LANG_MOUNTS_ERROR_FIGHT_NONE1};
		Info ->
			check_skill_use1(Template,Info)
	end.

check_skill_use1(Template,MoustsInfo) ->
	IsSeal = Template#ets_item_template.propert1,
	StudySkillGroupID = Template#ets_item_template.propert2,
	StudySkillLevel = Template#ets_item_template.propert3,
	L = MoustsInfo#ets_users_mounts.other_data#mounts_other.skill_list,
	
	case lists:keyfind(StudySkillGroupID, #r_use_skill.skill_group, L)  of
		false ->
			if 
				IsSeal =:= 1 orelse StudySkillLevel=:=1 ->
					check_skill_use2_1(MoustsInfo);
				true ->
				   {false,?_LANG_MOUNTS_ERROR_STUDY_LOW}
			end;
				
		USkill ->
			if 
				IsSeal =:= 1 ->
				   {false,?_LANG_MOUNTS_ERROR_TYPE_HAS_STUDY};
				true ->
					check_skill_use2(Template,MoustsInfo,USkill,StudySkillGroupID,StudySkillLevel)
			end
	end.
	

check_skill_use2(Template,MoustsInfo,USkill,StudySkillGroupID,StudySkillLevel) ->
	if 
		(USkill#r_use_skill.skill_lv + 1) =:= StudySkillLevel ->
			check_skill_use3(Template,MoustsInfo,StudySkillGroupID,StudySkillLevel);
		USkill#r_use_skill.skill_lv >= StudySkillLevel ->
			{false,?_LANG_MOUNTS_ERROR_HAS_STUDY};
		true ->
			{false,?_LANG_MOUNTS_ERROR_STUDY_LOW}
	end.

check_skill_use2_1(MoustsInfo) ->
	Len = length(MoustsInfo#ets_users_mounts.other_data#mounts_other.skill_list),
	case (Len + 1) =< MoustsInfo#ets_users_mounts.other_data#mounts_other.skill_cell_num of
		true ->
			{ok};
		false ->
			{false,?_LANG_MOUNTS_ERROR_SKILL_CELL_FULL}
	end.
	
	
check_skill_use3(Template,MoustsInfo,StudySkillGroupID,StudySkillLevel) ->
	Skill = lib_skill:get_skill_from_template_by_group_and_lv(StudySkillGroupID,StudySkillLevel),
	case Skill#ets_skill_template.need_skill_id =:= 0 of
		true ->
			{ok};
		_ ->
			Skill1 = lib_skill:get_skill_from_template_by_group_and_lv(Skill#ets_skill_template.need_skill_id,Skill#ets_skill_template.need_skill_level),
			if is_record(Skill1, ets_skill_template) ->
				   case get_current_skill_skillid(MoustsInfo#ets_users_mounts.other_data#mounts_other.skill_list,Skill1#ets_skill_template.skill_id) of
					   {error} ->
						   {false,?_LANG_SKILL_PRE_NONE};
					   _ ->
						   {ok}
				   end;
			   true ->
				   {false,?_LANG_SKILL_PRE_NONE}
			end
	end.
		
update_skill(ItemInfo,Template,PidSend) ->
	case update_skill(ItemInfo,Template) of
		{ok,MountsId,SkillList} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_SKILL_UPDATE,[MountsId,SkillList]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg])
	end.

update_skill(ItemInfo,Template) ->
	StudySkillGroupID = Template#ets_item_template.propert2,
	StudySkillLevel = Template#ets_item_template.propert3,
	List = get_mounts_dic(),
	case lists:keyfind(?MOUNTS_FIGHT_STATE, #ets_users_mounts.state, List) of
		false ->
			{false,?_LANG_MOUNTS_ERROR_FIGHT_NONE1};
		Info ->
			update_skill1(Info,StudySkillGroupID,StudySkillLevel)
	end.

update_skill1(Info,StudySkillGroupID,StudySkillLevel)->
	L = Info#ets_users_mounts.other_data#mounts_other.skill_list,
	case lists:keyfind(StudySkillGroupID, #r_use_skill.skill_group, L) of
		false -> %%学习
			update_skill2(Info#ets_users_mounts.id,StudySkillGroupID,StudySkillLevel,L,Info);
		SkillInfo ->
			update_skill3(Info#ets_users_mounts.id, SkillInfo , StudySkillGroupID,StudySkillLevel,L,Info)
	end.

update_skill2(MountsId,SkillGroupID,Level, L,Info) ->
	Skill = lib_skill:get_skill_from_template_by_group_and_lv(SkillGroupID,Level),
	Time = misc_timer:now_seconds(),
	
	R = #r_use_skill{
					   skill_id = Skill#ets_skill_template.skill_id,
					   skill_percent = 0,
					   skill_lv = Skill#ets_skill_template.current_level,
					   skill_group = Skill#ets_skill_template.group_id,
					   skill_lastusetime = Time,
					   skill_colddown = Skill#ets_skill_template.cold_down_time 
					  },
	
	SL = L ++ [R],
	
	OtherInfo = Info#ets_users_mounts.other_data#mounts_other{ skill_list = SL },
	NewMounts = Info#ets_users_mounts{ other_data = OtherInfo },
	db_agent_mounts:update_mounts_skill(MountsId,0,Skill#ets_skill_template.skill_id,Skill#ets_skill_template.current_level,Time),
	
	update_mousts_by_id(NewMounts),
	{ok,MountsId,NewMounts#ets_users_mounts.other_data#mounts_other.skill_list}.


update_skill3(MountsId,SkillInfo,SkillGroupID,Level,L,Info) ->
	SkillTemplate = lib_skill:get_skill_from_template_by_group_and_lv(SkillGroupID,Level),
	R = SkillInfo#r_use_skill{
					   skill_id = SkillTemplate#ets_skill_template.skill_id,
					   skill_lv = SkillTemplate#ets_skill_template.current_level,
					   skill_group = SkillTemplate#ets_skill_template.group_id,
					   skill_colddown = SkillTemplate#ets_skill_template.cold_down_time
					  },
	
	SL = lists:keyreplace(SkillGroupID, #r_use_skill.skill_group, L, R),
	
	OtherInfo = Info#ets_users_mounts.other_data#mounts_other{ skill_list = SL },
	NewMounts = Info#ets_users_mounts{ other_data = OtherInfo },
	
	db_agent_mounts:update_mounts_skill(MountsId,SkillInfo#r_use_skill.skill_id,SkillTemplate#ets_skill_template.skill_id,Level,0),
	update_mousts_by_id(NewMounts),
	{ok,MountsId,SL}.



	
%% 封印	
seal_skill(PlayerStatus,ItemStatus,MountsId,GroupID) ->
	case seal_skill_1(PlayerStatus,ItemStatus,MountsId,GroupID) of
		{ok,NewItemStatus,SkillList} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_REMOVE_SKILL,[1]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_SKILL_UPDATE,[MountsId,SkillList]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok,NewItemStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.


seal_skill_1(PlayerStatus,ItemStatus,MountsId,GroupID) ->
	List = get_mounts_dic(),
	case lists:keyfind(MountsId, #ets_users_mounts.id, List) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		Info ->
			seal_skill_2(PlayerStatus,ItemStatus,Info,GroupID)
	end.

seal_skill_2(PlayerStatus,ItemStatus,Info,GroupID) ->
	SkillList = Info#ets_users_mounts.other_data#mounts_other.skill_list,
	case lists:keyfind(GroupID, #r_use_skill.skill_group, SkillList) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		SkillInfo ->
			seal_skill_3(PlayerStatus,ItemStatus,Info,SkillInfo)
	end.

seal_skill_3(PlayerStatus,ItemStatus,Info,SkillInfo) ->
	if 
		length(ItemStatus#item_status.null_cells) > 0 ->
			case use_item_by_type([?ITEM_MOUNTS_SKILL_SEAL],ItemStatus) of
				false ->
					{false,?_LANG_MOUNTS_ERROR_SEAL_NONE};
				{ok,NewItemStatus} ->
					seal_skill_4(PlayerStatus,NewItemStatus,Info,SkillInfo)
			end;
		true ->
			{false,?_LANGUAGE_SALE_MSG_BAG_FULL}
	end.


seal_skill_4(PlayerStatus,ItemStatus,Info,SkillInfo) ->
	SkillTemplate = lib_skill:get_skill_from_template( SkillInfo#r_use_skill.skill_id),
	case lib_item:pick_up_item(SkillTemplate#ets_skill_template.seal_id, 1, 1, ItemStatus) of
		{fail, _Reply} ->
			{false,?_LANGUAGE_SALE_MSG_BAG_FULL};
		{ok, _Reply, ItemList, NewItemStatus} ->
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),	
			seal_skill_5(PlayerStatus,NewItemStatus,Info,SkillInfo)
	end.

	
seal_skill_5(PlayerStatus,ItemStatus,Info,SkillInfo) ->
	SkillList = Info#ets_users_mounts.other_data#mounts_other.skill_list,
	NewList = lists:keydelete(SkillInfo#r_use_skill.skill_group, #r_use_skill.skill_group, SkillList),
	OtherInfo = Info#ets_users_mounts.other_data#mounts_other{ skill_list = NewList },
	NewMounts = Info#ets_users_mounts{ other_data = OtherInfo },
	db_agent_mounts:delete_mounts_skills([{id,Info#ets_users_mounts.id},{template_id,SkillInfo#r_use_skill.skill_id}]),
	update_mousts_by_id(NewMounts),
	{ok,ItemStatus,NewList}.

	

%% 删除技能
delete_skill(PlayerStatus,MountsId,GroupID) ->
	case delete_skill_1(PlayerStatus,MountsId,GroupID) of
		{ok,SkillList} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_REMOVE_SKILL1,[1]),
			{ok,Bin1} = pt_28:write(?PP_MOUNT_SKILL_UPDATE,[MountsId,SkillList]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok};		
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.

delete_skill_1(PlayerStatus,MountsId,GroupID) ->
	List = get_mounts_dic(),
	case lists:keyfind(MountsId, #ets_users_mounts.id, List) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		Info ->
			delete_skill1(PlayerStatus,Info,MountsId,GroupID)
	end.

delete_skill1(PlayerStatus,Info,MountsId,GroupID) ->
	SkillList = Info#ets_users_mounts.other_data#mounts_other.skill_list,
	case lists:keyfind(GroupID, #r_use_skill.skill_group, SkillList) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		SkillInfo ->
			delete_skill2(PlayerStatus,Info,GroupID,SkillInfo,MountsId)
	end.

delete_skill2(PlayerStatus,Info,GroupID,SkillInfo,MountsId) ->
	SkillList = Info#ets_users_mounts.other_data#mounts_other.skill_list,
	NewList = lists:keydelete(GroupID, #r_use_skill.skill_group, SkillList),
	OtherInfo = Info#ets_users_mounts.other_data#mounts_other{ skill_list = NewList },
	NewMounts = Info#ets_users_mounts{ other_data = OtherInfo },
	db_agent_mounts:delete_mounts_skills([{id,MountsId},{template_id,SkillInfo#r_use_skill.skill_id}]),
	update_mousts_by_id(NewMounts),
	
%% 	NewPlayerStatus = case update_playerstatus(PlayerStatus,NewMounts) of
%% 						  {_,PlayerStatus1} ->
%% 							  PlayerStatus1;
%% 						  _ ->
%% 							  PlayerStatus
%% 					  end,

	{ok,NewList}.	


%% 获取当前技能书的列表
get_skill_book_list(List,Luck,PidSend)->
	{ok,Bin} = pt_28:write(?PP_MOUNT_GET_SKILL_BOOK_LIST,[List,Luck]),
	lib_send:send_to_sid(PidSend,Bin).

%% 刷新技能书
ref_skill_book(PlayerStatus,Type)->
	case ref_skill_book1(PlayerStatus,Type) of
		{ok,NewPlayerStatus,ReduceYuanBao, ReduceBindYuanBao} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_GET_SKILL_BOOK_LIST,[NewPlayerStatus#ets_users.mounts_skill_books,
																   NewPlayerStatus#ets_users.mounts_skill_books_luck]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NewPlayerStatus,ReduceYuanBao, ReduceBindYuanBao};
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
	case lib_player:check_bind_yuanbao(PlayerStatus,?MOUNTS_SKILL_BOOK_ONCE_YUNBAO) of
		true ->
%% 			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, ?MOUNTS_SKILL_BOOK_ONCE_YUNBAO, 0, 0,{?CONSUME_YUANBAO_REFRESH_MOUNTS,0,1}),
			ref_skill_book_5(PlayerStatus,1,1,0,?MOUNTS_SKILL_BOOK_ONCE_YUNBAO);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_2(PlayerStatus) ->
	case lib_player:check_yuanbao(PlayerStatus,?MOUNTS_SKILL_BOOK_ONCE_YUNBAO) of
		true ->
%% 			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,  ?MOUNTS_SKILL_BOOK_ONCE_YUNBAO, 0,0, 0,{?CONSUME_YUANBAO_REFRESH_MOUNTS,0,1}),
			ref_skill_book_5(PlayerStatus,1,0,?MOUNTS_SKILL_BOOK_ONCE_YUNBAO, 0);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_3(PlayerStatus) ->
	case lib_player:check_bind_yuanbao(PlayerStatus,?MOUNTS_SKILL_BOOK_GROUP_YUNBAO) of
		true ->
%% 			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, 0, ?MOUNTS_SKILL_BOOK_GROUP_YUNBAO, 0, 0,{?CONSUME_YUANBAO_REFRESH_MOUNTS,0,12}),
			ref_skill_book_5(PlayerStatus,12,1,0, ?MOUNTS_SKILL_BOOK_GROUP_YUNBAO);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_4(PlayerStatus) ->
	case lib_player:check_yuanbao(PlayerStatus,?MOUNTS_SKILL_BOOK_GROUP_YUNBAO) of
		true ->
%% 			PlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,  ?MOUNTS_SKILL_BOOK_GROUP_YUNBAO, 0,0, 0,{?CONSUME_YUANBAO_REFRESH_MOUNTS,0,12}),
			ref_skill_book_5(PlayerStatus,12,0, ?MOUNTS_SKILL_BOOK_GROUP_YUNBAO,0);
		_ ->
			{false,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO}
	end.

ref_skill_book_5(PlayerStatus,Num,Bind, ReduceYuanBao, ReduceBindYuanBao) ->
	Luck = PlayerStatus#ets_users.mounts_skill_books_luck,
	{List,NewLuck} = ref_skill_book_6(Num,[],Luck),
	NewList = ref_skill_book_7(List,[],{0,Bind}),
	NewPlayerStatus = PlayerStatus#ets_users{
						   mounts_skill_books_luck = NewLuck,
						   mounts_skill_books = NewList
						  },
	db_agent_user:update_mounts_skill_books(NewPlayerStatus#ets_users.id,
											NewPlayerStatus#ets_users.mounts_skill_books,
											NewPlayerStatus#ets_users.mounts_skill_books_luck),
	{ok,NewPlayerStatus,ReduceYuanBao, ReduceBindYuanBao}.

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
					 250001;
				 _ ->
					 251000 + Type1 * 10 + Type
			 end,
	ref_skill_book_7(List,[{Place,ItemId,Bind,Type} | BookList],{Place + 1,Bind}).


%% 获取技能书
get_skill_book(PlayerStatus,Place,ItemStatus) ->
	case get_skill_book1(PlayerStatus,Place,ItemStatus) of
		{ok,NewPlayerStatus,NewItemStatus} ->
			{ok,Bin} = pt_28:write(?PP_MOUNT_SKILL_ITEM_GET,[1,NewPlayerStatus#ets_users.mounts_skill_books_luck]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
			{ok,NewPlayerStatus,NewItemStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			false
	end.

get_skill_book1(PlayerStatus,Place,ItemStatus) ->
	BookList = PlayerStatus#ets_users.mounts_skill_books,
	case lists:keyfind(Place, 1, BookList) of
		false ->
			{false,?_LANG_OPERATE_ERROR};
		{Place,ItemId,IsBind,_Type} ->
			case lib_item:pick_up_item(ItemId, 1, IsBind, ItemStatus) of
				{fail, _Reply} ->
					{false,?_LANG_DAILY_AWARD_ITEM_ERROR};
				{ok, _Reply, ItemList, NewItemStatus} ->
					{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_SYS,ItemList, []]),
					lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
					NewPlayerStatus = PlayerStatus#ets_users{mounts_skill_books = [],
																  mounts_skill_books_luck = 0},
					db_agent_user:update_mounts_skill_books(NewPlayerStatus#ets_users.id,
															 NewPlayerStatus#ets_users.mounts_skill_books,
															 NewPlayerStatus#ets_users.mounts_skill_books_luck
															),
					{ok,NewPlayerStatus,NewItemStatus}
					
			end;
		_ ->
			{false,?_LANG_OPERATE_ERROR}
	end.


%% ----------------------技能 end ------------------------

%% 刷新属性
calc_properties(Career,MountsInfo) ->
	MountsInfo1 = 
		case data_agent:mounts_template_get({MountsInfo#ets_users_mounts.template_id, MountsInfo#ets_users_mounts.level}) of
			[] ->
				MountsInfo;
			Attr ->
				OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{
										speed = Attr#ets_mounts_template.speed,
										up_quality = Attr#ets_mounts_template.up_quality,
										up_grow_up = Attr#ets_mounts_template.up_grow_up,
										total_hp = Attr#ets_mounts_template.total_hp,
										total_mp = Attr#ets_mounts_template.total_mp,
										attack = Attr#ets_mounts_template.attack,
										defence = Attr#ets_mounts_template.defence,
										magic_attack = Attr#ets_mounts_template.magic_attack,
										far_attack = Attr#ets_mounts_template.far_attack,
										mump_attack = Attr#ets_mounts_template.mump_attack,
										magic_defense = Attr#ets_mounts_template.magic_defense,
										far_defense = Attr#ets_mounts_template.far_defense,
										mump_defense = Attr#ets_mounts_template.mump_defense,
										total_hp2 = 0,
										total_mp2 = 0,
										attack2 = 0,
										defence2 = 0,
										up_quality2 = 0,
										up_grow_up2 = 0,
										magic_attack2 = 0,
										far_attack2 = 0,
										mump_attack2 = 0,
										magic_defense2 = 0,
										far_defense2 = 0,
										mump_defense2 = 0,
										skill_list = MountsInfo#ets_users_mounts.other_data#mounts_other.skill_list,
										skill_cell_num = 4
									   },
				MountsInfo#ets_users_mounts{other_data = OtherInfo}
		end,
	MountsInfo2 = calc_properties1(MountsInfo1),
	MountsInfo3 = calc_properties2(MountsInfo2),
	MountsInfo4 = calc_properties3(MountsInfo3),
	MountsInfo5 = calc_properties4(MountsInfo4),
	MountsInfo6 = calc_properties5(MountsInfo5),
	MountsInfo7 = calc_properties6(MountsInfo6),
	MountsInfo8 = calc_properties7(MountsInfo7),
	
	check_career(Career,MountsInfo8).

%% 品质
calc_properties1(MountsInfo) ->
	case data_agent:mounts_stairs_template_get({MountsInfo#ets_users_mounts.template_id, MountsInfo#ets_users_mounts.stairs}) of
		[] ->
			MountsInfo;
		Attr ->
			 OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{
										  up_quality2 = Attr#ets_mounts_stairs_template.up_quality + MountsInfo#ets_users_mounts.other_data#mounts_other.up_quality2,
										  up_grow_up2 = Attr#ets_mounts_stairs_template.up_grow_up + MountsInfo#ets_users_mounts.other_data#mounts_other.up_grow_up2,
										  total_hp = Attr#ets_mounts_stairs_template.total_hp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_hp,
										  total_mp = Attr#ets_mounts_stairs_template.total_mp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_mp,
										  attack = Attr#ets_mounts_stairs_template.attack + MountsInfo#ets_users_mounts.other_data#mounts_other.attack,
										  defence = Attr#ets_mounts_stairs_template.defence + MountsInfo#ets_users_mounts.other_data#mounts_other.defence,
										  magic_attack = Attr#ets_mounts_stairs_template.magic_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_attack,
										  far_attack = Attr#ets_mounts_stairs_template.far_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.far_attack,
										  mump_attack = Attr#ets_mounts_stairs_template.mump_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_attack,
										  magic_defense = Attr#ets_mounts_stairs_template.magic_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_defense,
										  far_defense = Attr#ets_mounts_stairs_template.far_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.far_defense,
										  mump_defense = Attr#ets_mounts_stairs_template.mump_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_defense
										 },
			 MountsInfo#ets_users_mounts{other_data = OtherInfo}
	end.


%% 资质
calc_properties2(MountsInfo) ->
	case data_agent:mounts_qualification_template_get({MountsInfo#ets_users_mounts.template_id, MountsInfo#ets_users_mounts.current_quality}) of
		[] ->
			MountsInfo;
		Attr ->
			OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{
										 magic_attack2 = Attr#ets_mounts_qualification_template.magic_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_attack2,
										 far_attack2 = Attr#ets_mounts_qualification_template.far_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.far_attack2,
										 mump_attack2 = Attr#ets_mounts_qualification_template.mump_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_attack2,
										 magic_defense2 = Attr#ets_mounts_qualification_template.magic_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_defense2,
										 far_defense2 = Attr#ets_mounts_qualification_template.far_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.far_defense2,
										 mump_defense2 = Attr#ets_mounts_qualification_template.mump_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_defense2,
										 skill_cell_num =  erlang:min(erlang:max(util:floor((MountsInfo#ets_users_mounts.current_quality - 20) / 10),0),4) + MountsInfo#ets_users_mounts.other_data#mounts_other.skill_cell_num
										 },
			MountsInfo#ets_users_mounts{other_data = OtherInfo}
	end.

%% 成长
calc_properties3(MountsInfo) ->
	case data_agent:mounts_grow_up_template_get({MountsInfo#ets_users_mounts.template_id, MountsInfo#ets_users_mounts.current_grow_up}) of
		[] ->
			MountsInfo;
		Attr ->
			 OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{
										  total_hp2 = Attr#ets_mounts_grow_up_template.total_hp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_hp2,
										  total_mp2 = Attr#ets_mounts_grow_up_template.total_mp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_mp2,
										  attack2 = Attr#ets_mounts_grow_up_template.attack + MountsInfo#ets_users_mounts.other_data#mounts_other.attack2,
										  defence2 = Attr#ets_mounts_grow_up_template.defence + MountsInfo#ets_users_mounts.other_data#mounts_other.defence2,
										  skill_cell_num = erlang:min(erlang:max(util:floor((MountsInfo#ets_users_mounts.current_grow_up - 20) / 10),0),4) + MountsInfo#ets_users_mounts.other_data#mounts_other.skill_cell_num
										 },
			 MountsInfo#ets_users_mounts{other_data = OtherInfo}
	end.


%% 星级
calc_properties4(MountsInfo) ->
	Other1 = MountsInfo#ets_users_mounts.other_data#mounts_other{
																 star = MountsInfo#ets_users_mounts.current_quality div 10
																},
	MountsInfo1 = MountsInfo#ets_users_mounts{other_data = Other1},
	case data_agent:mounts_star_template_get({MountsInfo1#ets_users_mounts.template_id, MountsInfo1#ets_users_mounts.other_data#mounts_other.star}) of
		[] ->
			MountsInfo1;
		Attr ->
			 OtherInfo = MountsInfo1#ets_users_mounts.other_data#mounts_other{
										 magic_attack2 = Attr#ets_mounts_star_template.magic_attack + MountsInfo1#ets_users_mounts.other_data#mounts_other.magic_attack2,
										 far_attack2 = Attr#ets_mounts_star_template.far_attack + MountsInfo1#ets_users_mounts.other_data#mounts_other.far_attack2,
										 mump_attack2 = Attr#ets_mounts_star_template.mump_attack + MountsInfo1#ets_users_mounts.other_data#mounts_other.mump_attack2,
										 magic_defense2 = Attr#ets_mounts_star_template.magic_defense + MountsInfo1#ets_users_mounts.other_data#mounts_other.magic_defense2,
										 far_defense2 = Attr#ets_mounts_star_template.far_defense + MountsInfo1#ets_users_mounts.other_data#mounts_other.far_defense2,
										 mump_defense2 = Attr#ets_mounts_star_template.mump_defense + MountsInfo1#ets_users_mounts.other_data#mounts_other.mump_defense2
										 },
			 MountsInfo1#ets_users_mounts{other_data = OtherInfo}
	end.


%% 钻
calc_properties5(MountsInfo) ->
	Other1 = MountsInfo#ets_users_mounts.other_data#mounts_other{
																 diamond = MountsInfo#ets_users_mounts.current_grow_up div 10
																},
	MountsInfo1 = MountsInfo#ets_users_mounts{other_data = Other1},
	case data_agent:mounts_diamond_template_get({MountsInfo1#ets_users_mounts.template_id, MountsInfo1#ets_users_mounts.other_data#mounts_other.diamond}) of
		[] ->
			MountsInfo;
		Attr ->
			 OtherInfo = MountsInfo1#ets_users_mounts.other_data#mounts_other{
										  total_hp2 = Attr#ets_mounts_diamond_template.total_hp + MountsInfo1#ets_users_mounts.other_data#mounts_other.total_hp2,
										  total_mp2 = Attr#ets_mounts_diamond_template.total_mp + MountsInfo1#ets_users_mounts.other_data#mounts_other.total_mp2,
										  attack2 = Attr#ets_mounts_diamond_template.attack + MountsInfo1#ets_users_mounts.other_data#mounts_other.attack2,
										  defence2 = Attr#ets_mounts_diamond_template.defence + MountsInfo1#ets_users_mounts.other_data#mounts_other.defence2
										 },
			 MountsInfo1#ets_users_mounts{other_data = OtherInfo}
	end.

%% 洗练
calc_properties6(MountsInfo) ->
	case data_agent:mounts_refined_template_get1({MountsInfo#ets_users_mounts.template_id, MountsInfo#ets_users_mounts.current_refined}) of
		[] ->		
			
			OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{
						total_hp = MountsInfo#ets_users_mounts.other_data#mounts_other.total_hp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_hp3,
						total_mp = MountsInfo#ets_users_mounts.other_data#mounts_other.total_mp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_mp3,
						attack = MountsInfo#ets_users_mounts.other_data#mounts_other.attack + MountsInfo#ets_users_mounts.other_data#mounts_other.attack3,
						defence = MountsInfo#ets_users_mounts.other_data#mounts_other.defence + MountsInfo#ets_users_mounts.other_data#mounts_other.defence3,
						magic_attack = MountsInfo#ets_users_mounts.other_data#mounts_other.magic_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.property_attack3,
						far_attack = MountsInfo#ets_users_mounts.other_data#mounts_other.far_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.property_attack3,
						mump_attack = MountsInfo#ets_users_mounts.other_data#mounts_other.mump_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.property_attack3,
						magic_defense = MountsInfo#ets_users_mounts.other_data#mounts_other.magic_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_defence3,
						far_defense = MountsInfo#ets_users_mounts.other_data#mounts_other.far_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.far_defence3,
						mump_defense = MountsInfo#ets_users_mounts.other_data#mounts_other.mump_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_defence3
										 },
			 MountsInfo#ets_users_mounts{other_data = OtherInfo};
		Attr ->
			 OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{
						total_hp = Attr#ets_mounts_refined_template.total_hp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_hp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_hp3,
						total_mp = Attr#ets_mounts_refined_template.total_mp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_mp + MountsInfo#ets_users_mounts.other_data#mounts_other.total_mp3,
						attack = Attr#ets_mounts_refined_template.attack + MountsInfo#ets_users_mounts.other_data#mounts_other.attack + MountsInfo#ets_users_mounts.other_data#mounts_other.attack3,
						defence = Attr#ets_mounts_refined_template.defence + MountsInfo#ets_users_mounts.other_data#mounts_other.defence + MountsInfo#ets_users_mounts.other_data#mounts_other.defence3,
						magic_attack = Attr#ets_mounts_refined_template.property_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.property_attack3,
						far_attack = Attr#ets_mounts_refined_template.property_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.far_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.property_attack3,
						mump_attack = Attr#ets_mounts_refined_template.property_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_attack + MountsInfo#ets_users_mounts.other_data#mounts_other.property_attack3,
						magic_defense = Attr#ets_mounts_refined_template.magic_defence + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.magic_defence3,
						far_defense = Attr#ets_mounts_refined_template.far_defence + MountsInfo#ets_users_mounts.other_data#mounts_other.far_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.far_defence3,
						mump_defense = Attr#ets_mounts_refined_template.mump_defence + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_defense + MountsInfo#ets_users_mounts.other_data#mounts_other.mump_defence3
										 },
			 MountsInfo#ets_users_mounts{other_data = OtherInfo}
	end.

calc_properties7(MountsInfo) ->
	Fight = calc_fight(MountsInfo),
	Other = MountsInfo#ets_users_mounts.other_data#mounts_other{
																 fight = Fight
																},
	MountsInfo#ets_users_mounts{other_data = Other}.


check_career(Career,MountsInfo) ->
	case Career of
		?CAREER_YUEWANG ->
			OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{far_attack = 0,
										magic_attack = 0,
										far_attack2 = 0,
										magic_attack2 = 0},
			 MountsInfo#ets_users_mounts{other_data = OtherInfo};
		?CAREER_HUAJIAN ->
			OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{far_attack = 0,
										mump_attack = 0,
										far_attack2 = 0,
										mump_attack2 = 0},
			 MountsInfo#ets_users_mounts{other_data = OtherInfo};
		?CAREER_TANGMEN ->
			OtherInfo = MountsInfo#ets_users_mounts.other_data#mounts_other{mump_attack = 0,
										magic_attack = 0,
										mump_attack2 = 0,
										magic_attack2 = 0},
			MountsInfo#ets_users_mounts{other_data = OtherInfo};
		_ ->
			MountsInfo
	end.


%% 经验计算等级
get_level_by_exp(Exp)->
	List = ets:tab2list(?ETS_MOUNTS_EXP_TEMPLATE),
	F = fun(V1,V2) -> V1#ets_mounts_exp_template.level < V2#ets_mounts_exp_template.level end,
	LSort = lists:sort(F,List),
	get_level_by_exp1(LSort, Exp).

get_level_by_exp1([], _) ->
	?MAX_MOUNTS_LEVEL;

get_level_by_exp1([H|T], Exp) ->
	if 
		H#ets_mounts_exp_template.total_exp > Exp ->
			H#ets_mounts_exp_template.level -1;
		true ->
			get_level_by_exp1(T, Exp)
	end.


get_book(Luck) ->
	Rate = (Luck/(Luck+70000)+0.0006) * 10000,
	Rate1 = Rate + (Luck/(Luck+4000)+0.006) * 10000,
	Rate2 = Rate1 + (Luck/(Luck+300)+0.01) * 10000,
	Rate3 = 10000,
	Random = util:rand(1, 10000),
	List = [{Rate,0},{Rate1,3},{Rate2,2},{Rate3,1}],
	{_, Type} = get_book(List, Random, []),
	Random1 = util:rand(0, 11),
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


use_item_by_type(ItemList,ItemStatus) ->
	F = fun(TemplateId,{Type,ItemInfos}) ->
				if
					Type =:= false ->
						{false,[]};
					true ->
						case item_util:get_user_item_by_templateid(ItemStatus#item_status.user_id, TemplateId) of
							[] ->
								{false,[]};
							ItemInfo when(ItemInfo#ets_users_items.bag_type =:= ?BAG_TYPE_COMMON) ->
								{ok,[ItemInfo|ItemInfos]};
							_ ->
								{false,[]}
						end
				end
		end,
				
	CheckValue = lists:foldl(F, {ok,[]}, ItemList),
	F1 = fun(ItemInfo,{ItemList,DelList,ItemStatus}) ->
				 {true, ItemStatus1, ItemList1, DelList1} = lib_item:reduce_item_to_users(ItemInfo#ets_users_items.template_id, 1, ItemStatus,?CONSUME_ITEM_USE),
				 {ItemList ++ ItemList1,DelList ++ DelList1,ItemStatus1}
		 end,
				 
	case CheckValue of
		{ok,ItemInfos} ->
			{ItemList2,DelList2,NewItemStatus} = lists:foldl(F1, {[],[],ItemStatus}, ItemInfos),
			{ok, ItemData} = pt_14:write(?PP_ITEM_PLACE_UPDATE, [?ITEM_PICK_NONE,ItemList2, DelList2]),
			lib_send:send_to_sid(NewItemStatus#item_status.pid, ItemData),
			{ok,NewItemStatus};
		_ ->
			false
	end.

%% update_playerstatus(PlayerStatus,Mounts) ->
%% 	if
%% 		Mounts#ets_users_mounts.state == ?MOUNTS_FIGHT_STATE ->
%% 			[Record, StyleBin] = item_util:calc_equip_properties(PlayerStatus#ets_users.id, PlayerStatus#ets_users.other_data#user_other.pid_target),
%% 			{NewStyleBin,Mounts1} = item_util:update_stylebin(StyleBin,
%% 													 PlayerStatus#ets_users.other_data#user_other.weapon_state,
%% 													 PlayerStatus#ets_users.other_data#user_other.cloth_state),
%% 			NewPlayerStatus = lib_player:calc_properties(PlayerStatus, Record, NewStyleBin,  Mounts1),
%% 			lib_target:cast_check_target(NewPlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_MOUNTS,{?TARGET_MOUNTS_FIGHT,Mounts1#ets_users_mounts.other_data#mounts_other.fight}} ]),
%% 			{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
%% 			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
%% 			NewPlayerStatus;
%% 		true ->
%% 			PlayerStatus
%% 	end.

calc_fight(Mounts) ->
	Fight = Mounts#ets_users_mounts.other_data#mounts_other.attack + Mounts#ets_users_mounts.other_data#mounts_other.attack2 + 
	Mounts#ets_users_mounts.other_data#mounts_other.defence + Mounts#ets_users_mounts.other_data#mounts_other.defence2 +
	(Mounts#ets_users_mounts.other_data#mounts_other.total_hp + Mounts#ets_users_mounts.other_data#mounts_other.total_hp2) * 0.2 +
	(Mounts#ets_users_mounts.other_data#mounts_other.magic_attack + Mounts#ets_users_mounts.other_data#mounts_other.magic_attack2 +
	Mounts#ets_users_mounts.other_data#mounts_other.mump_attack + Mounts#ets_users_mounts.other_data#mounts_other.mump_attack2 + 
	Mounts#ets_users_mounts.other_data#mounts_other.far_attack +  Mounts#ets_users_mounts.other_data#mounts_other.far_attack2 ) * 1.5 +
	(Mounts#ets_users_mounts.other_data#mounts_other.magic_defense + Mounts#ets_users_mounts.other_data#mounts_other.magic_defense2+
	Mounts#ets_users_mounts.other_data#mounts_other.mump_defense + Mounts#ets_users_mounts.other_data#mounts_other.mump_defense2+
	Mounts#ets_users_mounts.other_data#mounts_other.far_defense + Mounts#ets_users_mounts.other_data#mounts_other.far_defense2) * 0.5,
%% 	(Mounts#ets_users_mounts.other_data#mounts_other.power_hit + 
%% 	Mounts#ets_users_mounts.other_data#mounts_other.hit_target + 
%% 	Mounts#ets_users_mounts.other_data#mounts_other.duck + 
%% 	Mounts#ets_users_mounts.other_data#mounts_other.deligency) * 10,
	round(Fight).
	
