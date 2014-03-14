%% Author: wangdahai
%% Created: 2012-9-10
%% Description: TODO: Add description to lib_veins
-module(lib_veins).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-define(ACUPOINT_BAI_HUI,1).		%%百汇穴 生命加成
-define(ACUPOINT_JIAN_JING,2).		%%肩井穴 防御加成
-define(ACUPOINT_TAI_YUAN,3).		%%太渊穴 斗气防御加成
-define(ACUPOINT_GUAN_YUAN,4).		%%关元穴 远程防御加成
-define(ACUPOINT_QI_HAI,5).			%%气海穴 魔法防御加成
-define(ACUPOINT_MING_MEN,6).		%%命门穴 攻击加成
-define(ACUPOINT_WEI_ZHONG,7).		%%委中穴 斗气、远程、魔法攻击加成
-define(ACUPOINT_YONG_QUAN,8).		%%涌泉 普通伤害加成
-define(DIC_USERS_VEINS, dic_users_veins).	%%筋脉字典									
-define(VEINS_CD_TIME, 10).			%%CD单位秒
-define(VEINS_SPEED_UP_ONE_HOUR, 3600).		%%加速一小时
-define(VEINS_YUANBAO_ACCELERATE, 180).		%%元宝加速消耗单价180s/YUANBAO
-define(VEINS_ONE_HOUR_YUANBAO, 20).		%%一小时加速需要元宝个数20个
-define(MAX_GENGU_LEVEL, 20).		%%根骨最大等级
-define(VEINS_GENGU_SUCCESS_RATE, 100).		%%根骨升级失败增加的幸运值 成功几率=基础成功率+失败次数/(失败次数+100)
-define(VEINS_LEVEL_LIMIT, 30).				%%人物等级限制30+修炼类型当前等级
									%%修炼消耗历练，铜币 =\
%%有两个时间点需要保存数据库，cd时长，失败次数

-export([
		init_template_veins/0,	
		get_user_veins/3,	
		update_acupoint/2,
		update_gengu/2,
		upgrade_acupoint_lv/1,
		calc_veins_attribute/1,
		clear_cd/3,
		get_max_gengu_level/1
]).

%%
%% API Functions
%%
init_template_veins() ->
	ets:delete_all_objects(?ETS_VEINS_TEMPLATE),	
	F = fun(Info) ->
				Record = list_to_tuple([ets_veins_template] ++ Info),
				ets:insert(?ETS_VEINS_TEMPLATE, Record)
		end,
	case db_agent_template:get_veins_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ets:delete_all_objects(?ETS_VEINS_EXTRA_TEMPLATE),
	F1 = fun(Info) ->
			Record = list_to_tuple([ets_veins_extra_template] ++ Info),
			ets:insert(?ETS_VEINS_EXTRA_TEMPLATE, Record)			
		end,
	case db_agent_template:get_veins_extra_template() of
		[] ->
			skip;
		List1 when is_list(List1) ->
			lists:foreach(F1, List1);
		_ ->
			skip
	end,
	ok.

%% 获取筋脉额外奖励返回格式[]/T
get_veins_extra_award(PlayerStatus) ->
	L = PlayerStatus#ets_users.other_data#user_other.veins_list,
	case lists:keyfind(?ACUPOINT_YONG_QUAN, #r_user_veins.acupoint_type, L) of
		false ->
			[];
		UserVeins ->
			get_veins_extra_award1(UserVeins#r_user_veins.acupoint_level,[])
	end.
get_veins_extra_award1(1,List) ->
	List;
get_veins_extra_award1(Level,List) ->
	%获得涌泉等级相对应的额外奖励，没有则查找低N个等级的，直到1级	
	case data_agent:get_veins_extra_from_template(Level) of
		[] ->
			get_veins_extra_award1(Level-1,List);
		T ->
			T
	end.	


get_max_gengu_level(PlayerStatus) ->
	F = fun(Info,Lv) ->
			Lv + Info#r_user_veins.gengu_level
		end,
	lists:foldl(F, 0, PlayerStatus#ets_users.other_data#user_other.veins_list).

%% get_max_gengu_level(PlayerStatus) ->
%% 	get_max_gengu_level1(PlayerStatus#ets_users.other_data#user_other.veins_list,0).
%% 
%% get_max_gengu_level1([],Lv) ->Lv;
%% get_max_gengu_level1([H|L],Lv) ->
%% 	if	H#r_user_veins.gengu_level > Lv ->
%% 			get_max_gengu_level1(L,H#r_user_veins.gengu_level);
%% 		true ->
%% 			get_max_gengu_level1(L,Lv)
%% 	end.

%%升级穴位等级
update_acupoint(PlayerStatus, AcupointType) ->
	L = PlayerStatus#ets_users.other_data#user_other.veins_list,
	case lists:keyfind(AcupointType, #r_user_veins.acupoint_type, L) of
		false -> %学习			
			UpdateLv = 1;
%% 			Learn = true;
		UserVeins -> %升级，级别升到LV+1
%% 			Learn = false,   
			UpdateLv = UserVeins#r_user_veins.acupoint_level + 1
	end,
	case check_acupoint_upgrade_limit(PlayerStatus,AcupointType,UpdateLv,L) of
		true ->
			Veins = get_veins_from_template(AcupointType, UpdateLv),
			if is_record(Veins, ets_veins_template) ->
					update_acupoint_learn(PlayerStatus,Veins);
			true ->
				PlayerStatus
			end;
		_er ->
			?DEBUG("upgrade info:~p",[_er]),
			PlayerStatus
	end.

update_gengu(PlayerStatus, AcupointType) ->
	L = PlayerStatus#ets_users.other_data#user_other.veins_list,
	case lists:keyfind(AcupointType, #r_user_veins.acupoint_type, L) of
		false -> %学习			
			UpdateLv = 1,
			Learn = true,
			Veins = #r_user_veins{
								acupoint_type = AcupointType,		%% 穴位类型
								award_attribute = check_award_attribute(AcupointType,PlayerStatus#ets_users.career),	%% 奖励属性
								acupoint_level = 0,	%% 穴位等级
								award_acupoint_count = 0,%% 穴位奖励总点数
								gengu_level = 0,		%% 根骨等级template中公用
								award_gengu_count = 0	%% 根骨奖励总点数								
								};
		Veins -> %升级，级别升到LV+1
			Learn = false,
			UpdateLv = Veins#r_user_veins.gengu_level + 1			
	end,
	case PlayerStatus#ets_users.level >= ?VEINS_LEVEL_LIMIT andalso Veins#r_user_veins.acupoint_level > 0 of
		true when UpdateLv =< 20 ->
			TVeins = get_veins_from_template(AcupointType, UpdateLv),
			if is_record(TVeins, ets_veins_template) ->
				%%扣除根骨提升判断是否有足够的根骨升级符（升级只需要一个根骨符）
				case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'update_gengu',1}) of
					ok ->
						NewStatus2 = PlayerStatus,
%% 						SuccessRate = get_gengu_success_rade(UpdateLv, Veins#r_user_veins.luck) + PlayerStatus#ets_users.other_data#user_other.vip_vein_rate,
						if
							Veins#r_user_veins.luck < TVeins#ets_veins_template.need_gengu_amulet ->
								Success = false =:= false,
								SuccessRate = 0;
							true ->
								SuccessRate = TVeins#ets_veins_template.gengu_success_rate + Veins#r_user_veins.luck * 5 + PlayerStatus#ets_users.other_data#user_other.vip_vein_rate,
								Success = util:rand(1, 10000) >= SuccessRate
						end,
						if(Success) ->
							NewVeins = Veins#r_user_veins{luck = Veins#r_user_veins.luck + 1},
							%%发送筋脉更新包
							{ok, Bdata} = pt_20:write(?PP_VEINS_GENGU_UPDATE,[0, AcupointType, UpdateLv - 1, NewVeins#r_user_veins.luck]),
							lib_send:send_to_sid(NewStatus2#ets_users.other_data#user_other.pid_send, Bdata),
							%%更新数据库
							if(Learn) ->						
								NewVeinsList = [NewVeins|L];
							true ->	
								NewVeinsList = lists:keyreplace(NewVeins#r_user_veins.acupoint_type,
													#r_user_veins.acupoint_type,
													L,
													NewVeins)
							end,
							NewOtherData = NewStatus2#ets_users.other_data#user_other{veins_list = NewVeinsList},
							NewStatus = NewStatus2#ets_users{other_data = NewOtherData},
							%%更新数据库
							db_agent_user:update_user_veins(NewStatus#ets_users.id,AcupointType,NewVeins#r_user_veins.acupoint_level,UpdateLv - 1,NewVeins#r_user_veins.luck),
							NewStatus;
						true ->
							NewVeins = Veins#r_user_veins{	
											gengu_level = UpdateLv,	%% 等级
											luck = 0,
											award_gengu_count = round(Veins#r_user_veins.award_acupoint_count * TVeins#ets_veins_template.award_gengu / 100)
											},
							if(Learn) ->						
								NewVeinsList = [NewVeins|L];
							true ->	
								NewVeinsList = lists:keyreplace(NewVeins#r_user_veins.acupoint_type,
													#r_user_veins.acupoint_type,
													L,
													NewVeins)
							end,
							%%更新排行榜
							GenguLevel = get_gengu_level_count(NewVeinsList, 0),
							TopInfo = #top_info{top_type = ?TOP_TYPE_GENGU, user_id = NewStatus2#ets_users.id, value = GenguLevel},
							mod_top:update_top_info(NewStatus2#ets_users.other_data#user_other.pid, ?DIC_TOP_GENGU_DISCOUNT,NewStatus2#ets_users.career, NewStatus2#ets_users.sex, TopInfo),
							NewOtherData = NewStatus2#ets_users.other_data#user_other{veins_list = NewVeinsList},
							NewStatus = NewStatus2#ets_users{other_data = NewOtherData},
							lib_target:cast_check_target(NewStatus2#ets_users.other_data#user_other.pid_target, [{?TARGET_VEINS,{UpdateLv,1}}]),
							%%发送筋脉更新包
							{ok, Bdata} = pt_20:write(?PP_VEINS_GENGU_UPDATE,[1, AcupointType, UpdateLv, 0]),
							lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bdata),
							%%更新数据库
							db_agent_user:update_user_veins(NewStatus#ets_users.id,AcupointType,NewVeins#r_user_veins.acupoint_level,UpdateLv,NewVeins#r_user_veins.luck),
							%%处理属性变化
							%重新计算所有装备和被动技能值
							NewPlayerStatus = lib_player:calc_properties_send_self(NewStatus),
%% 							{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
%% 							lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
							NewPlayerStatus
						end;
					_er->
						?DEBUG("use gengu amulet error:~p",[_er]),
						PlayerStatus
				end;
			true ->
				PlayerStatus
			end;
		_ ->
			PlayerStatus
	end.

clear_cd(PlayerStatus, Clear_Type, Place) ->
	NeedTime =  PlayerStatus#ets_users.veins_cd - misc_timer:now_seconds(),
	if
		(NeedTime > 0) ->
			case Clear_Type of
				1 -> %%直接完成
					clear_cd1(NeedTime, PlayerStatus);
				2 -> %%加速一个小时，优先使用加速卡
					clear_cd2(NeedTime, PlayerStatus, Place);
				3 ->%% 加速一个小时，
					clear_cd2(NeedTime, PlayerStatus, 0);
				_ ->
					?DEBUG("error clearType:~p",[Clear_Type]),
					PlayerStatus
			end;
		true ->
			PlayerStatus
	end.
%%直接完成
clear_cd1(NeedTime, PlayerStatus) ->
	NeedYuanBao = trunc((NeedTime + ?VEINS_YUANBAO_ACCELERATE - 1) / ?VEINS_YUANBAO_ACCELERATE),
	if
				PlayerStatus#ets_users.yuan_bao > 0 ->
					if (NeedYuanBao > PlayerStatus#ets_users.yuan_bao) ->
						NewYuanBao = PlayerStatus#ets_users.yuan_bao,
						DiffTime = PlayerStatus#ets_users.veins_cd - NewYuanBao * ?VEINS_YUANBAO_ACCELERATE,
						NewStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,NewYuanBao,0,0,0,{?CONSUME_YUANBAO_VEINS_CD,?VEINS_YUANBAO_ACCELERATE,DiffTime}),
						NewStatus2 = NewStatus1#ets_users{veins_cd = DiffTime},
						{ok, Bdata} = pt_20:write(?PP_VEINS_CLEAR_CD,[NewStatus2#ets_users.veins_cd]),
						lib_send:send_to_sid(NewStatus2#ets_users.other_data#user_other.pid_send, Bdata);
					true ->
						NewYuanBao = NeedYuanBao,
						NewStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,NewYuanBao,0,0,0,{?CONSUME_YUANBAO_VEINS_CD,?VEINS_YUANBAO_ACCELERATE,NeedTime}),
						NewStatus2 = NewStatus1#ets_users{veins_cd = 0}
					end,
					lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,[{?TARGET_ACCELERATOR,{1,NewYuanBao}}]),
					Pid = NewStatus2#ets_users.other_data#user_other.pid_veins,
					case is_pid(Pid) of
						true ->
							fsm_veins:reduce_practice_time(Pid, NewYuanBao * ?VEINS_YUANBAO_ACCELERATE),
							NewStatus2;
						false ->
							upgrade_acupoint_lv(NewStatus2)
					end;	
				true ->
					PlayerStatus
	end.
%%加速一个小时，优先使用加速卡
clear_cd2(NeedTime, PlayerStatus, Place) ->
	if
		Place > 0 ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'use_veins_speed_up_card', Place}) of
				{ok} ->
					lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,[{?TARGET_ACCELERATOR,{2,1}}]),
					clear_cd3(NeedTime, ?VEINS_SPEED_UP_ONE_HOUR, PlayerStatus);
				Error ->
					?DEBUG("clear_cd error info:~p",[Error]),
					PlayerStatus
			end;
		true ->
			if
				?VEINS_ONE_HOUR_YUANBAO =< PlayerStatus#ets_users.yuan_bao ->
					NewStatus = lib_player:reduce_cash_and_send(PlayerStatus,?VEINS_ONE_HOUR_YUANBAO,0,0,0,{?CONSUME_YUANBAO_VEINS_CD,?VEINS_YUANBAO_ACCELERATE,?VEINS_SPEED_UP_ONE_HOUR}),
					lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target ,[{?TARGET_ACCELERATOR,{1,?VEINS_ONE_HOUR_YUANBAO}}]),
					clear_cd3(NeedTime, ?VEINS_SPEED_UP_ONE_HOUR, NewStatus);
				true ->
					PlayerStatus
			end
	end.
clear_cd3(NeedTime, ClearTime, PlayerStatus) ->
	if 
		NeedTime =< ClearTime ->	
			NewStatus = PlayerStatus#ets_users{veins_cd = 0},
			ClearTime1 = NeedTime;
		true ->			
			NewStatus = PlayerStatus#ets_users{veins_cd = PlayerStatus#ets_users.veins_cd - ClearTime},
			{ok, Bdata} = pt_20:write(?PP_VEINS_CLEAR_CD,[NewStatus#ets_users.veins_cd]),
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bdata),
			ClearTime1 = ClearTime
	end,
	Pid = NewStatus#ets_users.other_data#user_other.pid_veins,
	case is_pid(Pid) of
			true ->
				fsm_veins:reduce_practice_time(Pid, ClearTime1),
				NewStatus;
			false ->
				upgrade_acupoint_lv(NewStatus)
	end.


%%穴位升级并发送消息
upgrade_acupoint_lv(PlayerStatus) ->
	L = PlayerStatus#ets_users.other_data#user_other.veins_list,
	AcupointType = PlayerStatus#ets_users.veins_acupoint_uping,
	{UserVeins,NewVeins_List} = upgarde_acupoint(PlayerStatus, L,AcupointType,PlayerStatus#ets_users.career),
	NewOtherData = PlayerStatus#ets_users.other_data#user_other{veins_list = NewVeins_List},
	NewStatus = PlayerStatus#ets_users{other_data = NewOtherData,
										 veins_acupoint_uping = 0,
										 veins_cd = 0},
	%AcupointLevel = get_acupoint_level_count(L, 0),
	%TopInfo = #top_info{top_type = ?TOP_TYPE_VEINS, user_id = NewStatus#ets_users.id, value = AcupointLevel},
	%mod_top:update_top_info(NewStatus#ets_users.other_data#user_other.pid, ?DIC_TOP_VEINS_DISCOUNT, NewStatus#ets_users.career, NewStatus#ets_users.sex, TopInfo),
	%%?DEBUG("dhwang_test--TopInfo:~p",[TopInfo]),
	lib_target:cast_check_target(NewStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_HOLE,{UserVeins#r_user_veins.acupoint_type,UserVeins#r_user_veins.acupoint_level}}]),
	%%发送筋脉更新包
	{ok, Bdata} = pt_20:write(?PP_VEINS_ACUPOINT_UPDATE,[AcupointType, UserVeins#r_user_veins.acupoint_level, NewStatus#ets_users.veins_cd]),
	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bdata),
	%%更新数据库
	
	db_agent_user:update_user_veins(NewStatus#ets_users.id,AcupointType,UserVeins#r_user_veins.acupoint_level,UserVeins#r_user_veins.gengu_level,UserVeins#r_user_veins.luck),
	db_agent_user:update_user_veins_cd(NewStatus#ets_users.id, NewStatus#ets_users.veins_cd, NewStatus#ets_users.veins_acupoint_uping),
	%%处理属性变化
	%重新计算所有装备和被动技能值
				  NewPlayerStatus1 = lib_player:calc_properties_send_self(NewStatus),
%% 				  {ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus1),
%% 				  lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send, PlayerBin),
	NewPlayerStatus1.

get_veins_from_template(AcupointType, Lv) ->
	AcupointId = AcupointType * 10000 + Lv,
	data_agent:get_veins_from_template(AcupointId).
get_veins_award_attribut(AcupointType) ->
	Veins = data_agent:get_veins_from_template(AcupointType * 10000 + 1),
   	Veins#ets_veins_template.award_attribute_type.
%取人物筋脉，返回值为{{ets_user},[VeinsList]}
get_user_veins(UserID, TUser, Pid_target) ->
	Career = TUser#ets_users.career,
	F = fun(Veins,L) -> 
				[AcupointType,AcupointLv,GenguLv,Luck] = Veins,
				AcupointTemplate = get_veins_from_template(AcupointType, AcupointLv),
				GenguTemplate = get_veins_from_template(AcupointType, GenguLv),
				if 
					AcupointTemplate =:= [] -> 
						AwardAcupointCount = 0,
						AwardAttribute = GenguTemplate#ets_veins_template.award_attribute_type;
					true ->
						AwardAcupointCount = AcupointTemplate#ets_veins_template.award_acupoint_count,
						AwardAttribute = AcupointTemplate#ets_veins_template.award_attribute_type
				end,
				if
					GenguTemplate =:= [] ->
						AwardGenguCount = 0;
					true ->
						AwardGenguCount = round(AwardAcupointCount * GenguTemplate#ets_veins_template.award_gengu / 100)
				end,
				Record = #r_user_veins{
										acupoint_type = AcupointType,	%% 穴位类型
										award_attribute = check_award_attribute(AwardAttribute, Career), %% 奖励属性
										acupoint_level = AcupointLv,		%% 穴位等级
										award_acupoint_count = AwardAcupointCount,%% 穴位奖励总点数
										gengu_level = GenguLv,		%% 根骨等级
										award_gengu_count = AwardGenguCount,	%% 根骨奖励总点数
										luck = Luck
									  },
				[Record|L]
		end,
	Veins_List = lists:foldl(F,[],db_agent_veins:get_user_all_veins(UserID)),
	CDTimeOut = TUser#ets_users.veins_cd =< misc_timer:now_seconds(),
	if TUser#ets_users.veins_cd > 0 andalso CDTimeOut ->		
		{UserVeins,NewList} = upgarde_acupoint(TUser, Veins_List, TUser#ets_users.veins_acupoint_uping, Career),
		FPid = undefined,		
		NewTUser = TUser#ets_users{veins_acupoint_uping = 0, veins_cd = 0},
		lib_target:cast_check_target(Pid_target,[{?TARGET_HOLE,{UserVeins#r_user_veins.acupoint_type,UserVeins#r_user_veins.acupoint_level}}]),
	
		db_agent_user:update_user_veins(NewTUser#ets_users.id,TUser#ets_users.veins_acupoint_uping,UserVeins#r_user_veins.acupoint_level,
										UserVeins#r_user_veins.gengu_level,UserVeins#r_user_veins.luck),
		db_agent_user:update_user_veins_cd(NewTUser#ets_users.id, NewTUser#ets_users.veins_cd, NewTUser#ets_users.veins_acupoint_uping);
						
	TUser#ets_users.veins_cd > 0 ->
		{ok, FPid} = fsm_veins:start_link(TUser#ets_users.veins_cd, self()),
		NewTUser = TUser,
		NewList = Veins_List;
	true ->
		NewTUser = TUser,
		FPid = undefined,
		NewList = Veins_List
	end,
	{NewTUser,NewList,FPid}.

%%穴位升级返回经脉更新列表
upgarde_acupoint(UserInfo, VeinsList, AcupointType, Career) ->
	case lists:keyfind(AcupointType, #r_user_veins.acupoint_type, VeinsList) of
			false ->
			UpdateLv = 1,
			Learn = true,
				Veins = #r_user_veins{
								acupoint_type = AcupointType,		%% 穴位类型
								award_attribute = check_award_attribute(get_veins_award_attribut(AcupointType), Career),	%% 奖励属性
								acupoint_level = 0,	%% 穴位等级
								award_acupoint_count = 0,%% 穴位奖励总点数
								gengu_level = 0,		%% 根骨等级template中公用
								award_gengu_count = 0	%% 根骨奖励总点数								
								};
			Veins ->
				Learn = false,
				UpdateLv = Veins#r_user_veins.acupoint_level + 1
	end,
	
	case check_acupoint_upgrade_limit(UserInfo,AcupointType,UpdateLv,VeinsList) of
		true ->
			TVeins = get_veins_from_template(AcupointType, UpdateLv);
		_er ->
			?WARNING_MSG("upgrade info:~p",[{_er,AcupointType,UpdateLv}]),
			TVeins = []
	end,
	if is_record(TVeins, ets_veins_template) ->
		if(Learn) ->
			NewVeins = Veins#r_user_veins{	
											acupoint_level = UpdateLv,	%% 穴位等级
											award_acupoint_count = TVeins#ets_veins_template.award_acupoint_count%% 穴位奖励总点数
											},
			NewVeinsList = [NewVeins|VeinsList];
		true ->			
			NewVeins = Veins#r_user_veins{	
											acupoint_level = UpdateLv,	%% 穴位等级
											award_acupoint_count = TVeins#ets_veins_template.award_acupoint_count,%% 穴位奖励总点数
											award_gengu_count = get_gengu_effect(
																		Veins#r_user_veins.gengu_level,
																		UpdateLv,
																		TVeins#ets_veins_template.award_acupoint_count,
																		AcupointType
																		)
											},
			NewVeinsList = lists:keyreplace(NewVeins#r_user_veins.acupoint_type,
								#r_user_veins.acupoint_type,
								VeinsList,
								NewVeins)
		end;
	true ->
		NewVeins = Veins,
		NewVeinsList = VeinsList
	end,
	{NewVeins,NewVeinsList}.
%%根骨升级返回经脉更新列表
%% upgarde_gengu(VeinsList, AcupointType, Career) ->
%% 	case lists:keyfind(AcupointType, #r_user_veins.acupoint_type, VeinsList) of
%% 			false ->
%% 			UpdateLv = 1,
%% 			Learn = true,
%% 				Veins = #r_user_veins{
%% 								acupoint_type = AcupointType,		%% 穴位类型
%% 								award_attribute = check_award_attribute(get_veins_award_attribut(AcupointType), Career),	%% 奖励属性
%% 								acupoint_level = 0,	%% 穴位等级
%% 								award_acupoint_count = 0,%% 穴位奖励总点数
%% 								gengu_level = 0,		%% 根骨等级template中公用
%% 								award_gengu_count = 0	%% 根骨奖励总点数								
%% 								};
%% 			Veins ->
%% 				Learn = false,
%% 				UpdateLv = Veins#r_user_veins.gengu_level + 1
%% 	end,
%% 	TVeins = get_veins_from_template(AcupointType, UpdateLv),
%% 	if is_record(TVeins, ets_veins_template) ->
%% 		NewVeins = Veins#r_user_veins{	
%% 											gengu_level = UpdateLv,	%% 等级
%% 											award_gengu_count = TVeins#ets_veins_template.award_gengu_count
%% 											},
%% 		if(Learn) ->						
%% 			NewVeinsList = [NewVeins|VeinsList];
%% 		true ->	
%% 			NewVeinsList = lists:keyreplace(NewVeins#ets_veins_template.acupoint_type,
%% 								#r_user_veins.acupoint_type,
%% 								VeinsList,
%% 								NewVeins)
%% 		end;
%% 	true ->
%% 		NewVeinsList = VeinsList
%% 	end,
%% 	NewVeinsList.

get_gengu_level_count([], Level) ->
	Level;
get_gengu_level_count([H|L], Level) ->
	NewLevel = Level + H#r_user_veins.gengu_level,
	get_gengu_level_count(L, NewLevel).

get_acupoint_level_count([], Level) ->
	Level;
get_acupoint_level_count([H|L], Level) ->
	NewLevel = Level + H#r_user_veins.acupoint_level,
	get_acupoint_level_count(L, NewLevel).

%%换算根骨提升点数
get_gengu_effect(Gengulv, _Acupointlv, AcupointAward, Tenfold) ->
	if	
		Gengulv =:= 0 ->
			0;
%% 		(Tenfold =:= ?ACUPOINT_BAI_HUI) ->
%% 			round(AcupointAward * (Gengulv/?MAX_GENGU_LEVEL) + (Gengulv + Acupointlv)*10);
%% 		true ->
%% 			round(AcupointAward * (Gengulv/?MAX_GENGU_LEVEL) + (Gengulv + Acupointlv))
		true ->
			case get_veins_from_template(Tenfold, Gengulv) of
				TVeins when is_record(TVeins, ets_veins_template) ->
					round(AcupointAward * TVeins#ets_veins_template.award_gengu / 100);
				_ ->
					0
			end
	end.
get_gengu_success_rade(GenguLv,FailNum) ->
		trunc(((1 - GenguLv/(GenguLv + 20) + 0.5/GenguLv - 0.475) +  FailNum/(FailNum + 30))*1000).

%%
%% Local Functions
%%
%%检查升级前置条件是否满足返回true/false
check_acupoint_upgrade_limit(PlayerStatus, AcupointType, Lv, Veins_List) ->
	Now = misc_timer:now_seconds(),
	if
		Now < PlayerStatus#ets_users.veins_cd -> 
			in_cd;
		PlayerStatus#ets_users.level < ?VEINS_LEVEL_LIMIT + Lv ->
			limit_level;
		AcupointType =:= ?ACUPOINT_BAI_HUI ->
			if 
				Lv =:= 1 ->
					true;
				true ->	
					case lists:keyfind(?ACUPOINT_YONG_QUAN, #r_user_veins.acupoint_type, Veins_List) of
						false ->
							false;
						UseVeins when UseVeins#r_user_veins.acupoint_level =:= Lv - 1 ->
								true;
							_er ->
								_er
					end
			end;
		true ->	
			case lists:keyfind(AcupointType - 1, #r_user_veins.acupoint_type, Veins_List) of
						false ->
							false;
						UseVeins when UseVeins#r_user_veins.acupoint_level =:= Lv ->
								true;
							_er ->
								_er
			end
	end.

%% check_gengu_upgrade_limit(PlayerStatus, AcupointType, Lv) ->
%% 	if PlayerStatus#ets_users.level < VEINS_LEVEL_LIMIT ->
%% 		false;
%% 	true ->
%% 		true
%% 	end.

update_acupoint_learn(PlayerStatus,Veins) ->
	EnoughCopper = lib_player:check_cash(PlayerStatus,0,Veins#ets_veins_template.need_copper),
	EnoughLifeExp = Veins#ets_veins_template.need_life_exp =< PlayerStatus#ets_users.life_experiences,
	if EnoughCopper andalso EnoughLifeExp ->
		%%扣除费用
		NewStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,0,0,0,Veins#ets_veins_template.need_copper),
		NewStatus2 = lib_player:reduce_life_experiences(NewStatus1,Veins#ets_veins_template.need_life_exp),
		{ok, HPBIn} = pt_20:write(?PP_PLAYER_SELF_LIFEEXP,[NewStatus2#ets_users.life_experiences]),
		lib_send:send_to_sid(NewStatus2#ets_users.other_data#user_other.pid_send, HPBIn),
		
		PracticeTime = Veins#ets_veins_template.need_times + misc_timer:now_seconds(),
		Pid = NewStatus2#ets_users.other_data#user_other.pid_veins,
		case is_pid(Pid) of
			true ->
				fsm_veins:start_practice(Pid,PracticeTime),
				NewStatus3 = NewStatus2;
			false ->
				{ok,FPid} = fsm_veins:start_link(PracticeTime, self()),
				NewOtherData = NewStatus2#ets_users.other_data#user_other{pid_veins = FPid},
				NewStatus3 = NewStatus2#ets_users{other_data = NewOtherData}
		end,
			
		NewStatus = NewStatus3#ets_users{
										 veins_acupoint_uping = Veins#ets_veins_template.acupoint_type,
										 veins_cd = PracticeTime},
		
		%%发送筋脉更新包
		{ok, Bdata} = pt_20:write(?PP_VEINS_ACUPOINT_UPDATE,[Veins#ets_veins_template.acupoint_type, Veins#ets_veins_template.acupoint_level - 1, NewStatus#ets_users.veins_cd]),
		lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bdata),
		%%更新数据库
		db_agent_user:update_user_veins_cd(NewStatus#ets_users.id, NewStatus#ets_users.veins_cd, NewStatus#ets_users.veins_acupoint_uping),
		%%处理属性变化
		%重新计算所有装备和被动技能值
				  NewPlayerStatus1 = lib_player:calc_properties_send_self(NewStatus),
%% 				  {ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus1),
%% 				  lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send, PlayerBin),
		NewPlayerStatus1;
	true ->
		PlayerStatus
	end.

check_award_attribute(AwardAttribute, Career) ->
	if AwardAttribute =:= ?ATTR_MUMPHURTATT ->
		AwardAttribute1 = ?ATTR_MUMPHURTATT + Career - 1;
	true ->
		AwardAttribute1 = AwardAttribute
	end,
	AwardAttribute1.

get_attribute(Value, Career) ->
	case Career of
		?CAREER_YUEWANG ->
			{Value,0,0};
		?CAREER_HUAJIAN ->
			{0,Value,0};
		?CAREER_TANGMEN ->	
			{0,0,Value}
	end.

calc_veins_attribute(Status) ->
	OtherData = calc_active_effect(Status#ets_users.other_data#user_other.veins_list, Status#ets_users.other_data),
	case get_veins_extra_award(Status) of
		[] ->
			NewOtherData = OtherData;
		ExtraAward ->
			{MumpHurt,MagicHurt,FarHurt} = get_attribute(ExtraAward#ets_veins_extra_template.attribute_attack, Status#ets_users.career),
			NewOtherData = OtherData#user_other{
							total_hp = OtherData#user_other.total_hp + ExtraAward#ets_veins_extra_template.hp,
							defense =  OtherData#user_other.defense + ExtraAward#ets_veins_extra_template.defense,
							mump_defense =  OtherData#user_other.mump_defense + ExtraAward#ets_veins_extra_template.mump_defense,
							magic_defense =  OtherData#user_other.magic_defense + ExtraAward#ets_veins_extra_template.magic_defense,
							far_defense =  OtherData#user_other.far_defense + ExtraAward#ets_veins_extra_template.far_defense,
							mump_hurt =  OtherData#user_other.mump_hurt + MumpHurt,
							magic_hurt =  OtherData#user_other.magic_hurt + MagicHurt,
							far_hurt =  OtherData#user_other.far_hurt + FarHurt,
							attack =  OtherData#user_other.attack + ExtraAward#ets_veins_extra_template.attack,
							damage =  OtherData#user_other.damage + ExtraAward#ets_veins_extra_template.damage							
							}
	end,
	NewStatus = Status#ets_users{other_data = NewOtherData},
	NewStatus.

%% calc_gengu_award(UserVeins) ->
%% 	if
%% 		UserVeins#r_user_veins.gengu_level =:= 0 ->
%% 			0;
%% 		true ->
%% 			case UserVeins#r_user_veins.award_attribute of
%% 				?ATTR_HP ->
%% 					round( UserVeins#r_user_veins.award_acupoint_count * UserVeins#r_user_veins.gengu_level/100 +
%% 						(UserVeins#r_user_veins.gengu_level + UserVeins#r_user_veins.acupoint_level) * 10);
%% 				_ ->
%% 					round(UserVeins#r_user_veins.award_acupoint_count * UserVeins#r_user_veins.gengu_level/100 +
%% 						(UserVeins#r_user_veins.gengu_level + UserVeins#r_user_veins.acupoint_level))
%% 			end
%% 	end.
	

%%返回 user_other
calc_active_effect([], OtherData) ->
	OtherData;
calc_active_effect(UserVeins_List, OtherData)->
	[UserVeins|L] = UserVeins_List,
	case UserVeins#r_user_veins.award_attribute of
		?ATTR_HP ->
			Value = OtherData#user_other.total_hp  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{total_hp  = Value};
		?ATTR_DEFENSE ->
			Value = OtherData#user_other.defense  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{defense  = Value};
		?ATTR_MUMPDEFENSE ->
			Value = OtherData#user_other.mump_defense  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{mump_defense  = Value};
		?ATTR_MAGICDEFENCE ->
			Value = OtherData#user_other.magic_defense  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{magic_defense  = Value};
		?ATTR_FARDEFENSE ->
			Value = OtherData#user_other.far_defense  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{far_defense  = Value};
		?ATTR_ATTACK ->
			Value = OtherData#user_other.attack  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{attack  = Value};
		?ATTR_MUMPHURTATT ->
			Value = OtherData#user_other.mump_hurt  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{mump_hurt  = Value};
		?ATTR_MAGICHURTATT ->
			Value = OtherData#user_other.magic_hurt  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{magic_hurt  = Value};
		?ATTR_FARHURTATT ->
			Value = OtherData#user_other.far_hurt  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{far_hurt  = Value};
		?ATTR_DAMAGE ->
			Value = OtherData#user_other.damage  + UserVeins#r_user_veins.award_acupoint_count + UserVeins#r_user_veins.award_gengu_count,
			NewOtherData = OtherData#user_other{damage  = Value};
		
		_ ->
			NewOtherData = OtherData
	end,
	calc_active_effect(L, NewOtherData).
