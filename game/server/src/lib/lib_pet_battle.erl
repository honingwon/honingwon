%%% -------------------------------------------------------------------
%%% Author  : wangyuechun
%%% Description :
%%%
%%% Created : 2013-10-9
%%% -------------------------------------------------------------------
-module(lib_pet_battle).

-define(PET_BATTLE_LEVEL,35).
-define(PET_BATTLE_ATK_SKILL_LIST, [{70020},{70030},{70060},{70070}]).%%宠物主动技能列表
-define(PET_BATTLE_TOP_AWARD_LIST,[292400,292401,292402,292403]).%%宠物斗坛排行榜奖励
-define(PET_BATTLE_WIN_AWARD,292404).%%宠物斗坛胜利礼包
-define(PET_BATTLE_PET_KINDS_LIST,[260001,260002,260003,260005]).%%宠物类型
-define(PET_BATTLE_CD,600).  %%宠物斗坛CD,10分钟
-define(PET_BATTLE_COUNT,1). %%宠物斗坛次数增加，1次
-define(PET_BATTLE_CD_SPEND,10).%%宠物斗坛减CD花费10银两
-define(PET_BATTLE_COUNT_SPEND,10).%%宠物斗坛次数增加花费10银两

%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").

%% --------------------------------------------------------------------
%% External exports
-export([join_top/1,
prepare_pet_battle/2,
pet_battle_challenge/3,
set_pet_to_wild/1,
update_pet_battle_fight/1,
send_pet_battle_champion_award/0,
send_pet_battle_top_award/1,
add_pet_battle_times/1,
reduce_pet_battle_cd/1,
crate_pet_battle_info/2,
init_wild_pet_battle/0,
pet_battle_challenge_again/3,
save_pet_battle_data/0,
send_pet_battle_winning/0,
update_pet_battle_nick/2,
reset_pet_battle_yesterday_top/0]).

%%玩家到达35级才能加入宠物斗坛
join_top(User) ->
	if User#ets_users.level >= ?PET_BATTLE_LEVEL ->		
		List = get_user_pets(User#ets_users.id),
		if length(List) > 0 ->
			F = fun(Info) ->
				case db_agent_pet:get_pet_battle_by_pet_id(Info#ets_users_pets.id) of
					[] ->
						init_wild_pet_battle(),
						crate_pet_battle_info(Info,35);
						%send_user_join_top(User#ets_users.other_data#user_other.pid_send,Info#ets_users_pets.name);
					_ ->
						skip
				end
			end,
			lists:foreach(F, List),
			[Pet|_] = List,
			NewUser = reset_pet_battle_times(User),
			send_join_top(NewUser),
			NewUser;
			%prepare_pet_battle(User,Pet#ets_users_pets.id),
		true ->
			User
		end;
	true ->
		User
	end.

%%准备宠物战斗，获取可挑战列表
prepare_pet_battle(User,PetID) ->
	case get_pet_battle_by_id(PetID) of
		[] ->
			skip;
		Pet ->
			Top = Pet#ets_pet_battle.top,
			Top1 = if Top < 4 ->
							-2;
						true ->
							Top - 6
						end,
			List = get_pet_battle_by_top(Top1, 6),
			send_pet_challenge_list(User#ets_users.other_data#user_other.pid_send,PetID,List)
	end.

%%宠物挑战
pet_battle_challenge(User,PetID,ChallengeID) ->	
	%PidSend = User#ets_users.other_data#user_other.pid_send,
	case pet_battle_challenge1(User,PetID,ChallengeID) of 
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]),
			prepare_pet_battle(User,PetID),
			User;
		{true, Pet, CPet} ->
			User1 = reduce_times_and_add_cd(User),
			NewUser = case  calc_pet_battle(Pet,CPet) of
					false ->
						pet_battle_lose(User1,Pet,CPet);
					true ->
						pet_battle_win(User1,Pet,CPet)
			end;
		_ ->
			User
	end.

pet_battle_challenge1(User,PetID,ChallengeID) ->
	case check_user_times(User) of 
		{false, Msg} ->
			{false, Msg};
		{true} ->
			Pet = get_pet_battle_by_id(PetID),
			CPet = get_pet_battle_by_id(ChallengeID),
			if Pet =:= [] orelse CPet =:=[] ->
					{false,?_LANG_PET_BATTLE_WRONG_PET};
				Pet#ets_pet_battle.user_id =:= CPet#ets_pet_battle.user_id ->
					{false,?_LANG_PET_BATTLE_SAME_PLAYER};
				Pet#ets_pet_battle.top < 4 andalso CPet#ets_pet_battle.top < 4 ->  %高手寂寞规则
					{true, Pet, CPet};
				Pet#ets_pet_battle.top < CPet#ets_pet_battle.top ->
					{false,?GET_TRAN(?_LANG_PET_BATTLE_LESS_TOP,[CPet#ets_pet_battle.top])};
				%Pet#ets_pet_battle.top - CPet#ets_pet_battle.top > 6 -> %%挑战排行高自己6级以上
				%	if CPet#ets_pet_battle.winning <10 ->
				%			{false,?_LANG_PET_BATTLE_WINNING_STOP};
				%		true ->
				%			{true, Pet, CPet}
				%	end;
				true ->
					{true, Pet, CPet}
			end;
		E ->
			?DEBUG("pet_battle_challenge1~p",[E])
	end.

%%挑战失败
pet_battle_lose(User,Pet,CPet) ->
	%%连胜终结
	IsSendWinning =
		if Pet#ets_pet_battle.winning >= 10 ->
			crate_pet_battle_log(Pet,CPet,4,User#ets_users.nick_name),
			true;
		true ->
			false
		end,
	NewPet = Pet#ets_pet_battle{
										total = Pet#ets_pet_battle.total +1,
										winning = 0
												},
	NewCPet = CPet#ets_pet_battle{
										total = CPet#ets_pet_battle.total +1,
										win = CPet#ets_pet_battle.win +1,
										winning = CPet#ets_pet_battle.winning +1
												},
	%连胜
	IsSendWinning1 =
		if NewCPet#ets_pet_battle.winning rem 10 =:=0 ->
			crate_pet_battle_log(NewCPet,NewPet,2,User#ets_users.nick_name),
			true;
		true ->
			false
		end,
	if IsSendWinning orelse  IsSendWinning1->
			send_pet_battle_winning();
		true ->
			skip
	end,
	update_pet_battle(NewPet),
	update_pet_battle(NewCPet),
	UserLv = User#ets_users.level,
	AwardExp = UserLv*UserLv*5,%奖励宠物经验=等级*等级*5
	AwardCoper = 100*UserLv,%失败奖励铜币=100*等级
	send_pet_battle_result(User#ets_users.other_data#user_other.pid_send,NewPet,NewCPet,0,AwardCoper,AwardExp,0),
	{_,NewUser1,_} = lib_pet:add_pet_exp_and_lvup(User,NewPet#ets_pet_battle.pet_id,AwardExp),
	NewUser = lib_player:add_cash_and_send(NewUser1, 0, 0, 0, AwardCoper).

%%挑战成功
pet_battle_win(User,Pet,CPet)	->
	{Top1,Top2} = if 
			Pet#ets_pet_battle.top < CPet#ets_pet_battle.top andalso Pet#ets_pet_battle.top < 3 ->
				{Pet#ets_pet_battle.top,CPet#ets_pet_battle.top};
			true ->
				{CPet#ets_pet_battle.top,Pet#ets_pet_battle.top}
		end,	
	%%连胜终结
	if CPet#ets_pet_battle.winning >= 10 ->
			crate_pet_battle_log(Pet,CPet,3,User#ets_users.nick_name),
			IsSendWinning = true;
		true ->
			IsSendWinning = false
	end,
	NewPet = Pet#ets_pet_battle{
										total = Pet#ets_pet_battle.total +1,
										win = Pet#ets_pet_battle.win +1,
										winning = Pet#ets_pet_battle.winning +1,
										top = Top1	%%变成被挑战者的排行
												},
	NewCPet = CPet#ets_pet_battle{
										total = CPet#ets_pet_battle.total +1,
										winning = 0,
										top = Top2	%%变成挑战者的排行
												},
	db_agent_pet:update_pet_battle_top(NewPet, NewCPet),
	
	crate_pet_battle_log(NewPet,NewCPet,0,NewPet#ets_pet_battle.user_id),
	send_pet_battle_logs(User),
	%%连胜
	if NewPet#ets_pet_battle.winning rem 10 =:=0 ->
			crate_pet_battle_log(NewPet,NewCPet,2,User#ets_users.nick_name),
			IsSendWinning1 = true;
		true ->
			IsSendWinning1 = false
	end,
	if IsSendWinning orelse IsSendWinning1 ->	
			send_pet_battle_winning();
		true ->
			skip
	end,
	if	NewCPet#ets_pet_battle.user_id =/= 0 ->	
		crate_pet_battle_log(NewCPet,NewPet,1,User#ets_users.nick_name),
		%通知战败方
		case lib_player:get_online_info(CPet#ets_pet_battle.user_id) of 
			[] -> 
				skip;
			CUser ->	
				send_pet_battle_self_log(CUser),
				send_pet_battle_logs(CUser)
		end;
		true ->
			skip
	end,

	update_pet_battle(NewPet),
	update_pet_battle(NewCPet),
	UserLv = User#ets_users.level,
	AwardExp = UserLv*UserLv*10,
	AwardCoper = 200*UserLv,
	send_pet_battle_result(User#ets_users.other_data#user_other.pid_send,NewPet,NewCPet,1,AwardCoper,AwardExp,?PET_BATTLE_WIN_AWARD),
	gen_server:cast(User#ets_users.other_data#user_other.pid_item, {add_item_or_mail,?PET_BATTLE_WIN_AWARD,1,?BIND,User#ets_users.nick_name,?ITEM_PICK_PET_BATTLE}),
	{_,NewUser1,_} = lib_pet:add_pet_exp_and_lvup(User,NewPet#ets_pet_battle.pet_id,AwardExp),%奖励宠物经验=等级*等级*10
	NewUser = lib_player:add_cash_and_send(NewUser1, 0, 0, 0, AwardCoper),%胜利奖励铜币=200*等级
	send_self_pet(User),
	prepare_pet_battle(User, NewPet#ets_pet_battle.pet_id), %%发送宠物新的挑战列表
	NewUser.

check_user_times(User) ->
	Now = misc_timer:now_seconds(),
	if User#ets_users.pet_battle_count < 1 ->
			{false, ?_LANG_PET_BATTLE_LESS_TIMES};
		User#ets_users.pet_battle_time > Now ->
			{false, ?_LANG_PET_BATTLE_IN_CD};
		true ->
			{true}
	end.		

%%计算宠物pk的胜负. true为Pet1赢,false为Pet2赢
calc_pet_battle(Pet1, Pet2) ->
%% 主动技能增加的额外胜率百分比
	F = fun({TemplateID}, Sum) ->
			Type = TemplateID div 10,
			Lv = TemplateID rem 10 + 1,
			Fight =
				case Type of
					70020 when Lv > 1 ->
						1.0 + 0.5 * (Lv - 1);
					70030 when Lv > 1 -> 
						1.0 + 0.2 * (Lv - 1);
					70060 when Lv > 1 ->
						1.0 + 0.3 * (Lv - 1);
					70070 when Lv > 1 ->
						1.0 + 0.5 * (Lv - 1);
					_ ->
						0
				end,
			Fight + Sum
		end,
	SkillList1 = tool:split_string_to_intlist(Pet1#ets_pet_battle.skill_list),
	SkillList2 = tool:split_string_to_intlist(Pet2#ets_pet_battle.skill_list),
	OtherFight1 = lists:foldl(F, 0, SkillList1),
	OtherFight2 = lists:foldl(F, 0, SkillList2),
	TotalFight1 = tool:ceil(Pet1#ets_pet_battle.fight * (1 + OtherFight1/100)),
	TotalFight2 = tool:ceil(Pet2#ets_pet_battle.fight * (1 + OtherFight2/100)),
%%根据公式计算宠物1和宠物2的胜率
	Per1 =
		if 
			TotalFight1 > TotalFight2 ->
				(TotalFight1 - TotalFight2)*100/Pet2#ets_pet_battle.fight + 50;
			TotalFight1 =< TotalFight2 ->
				100 - ((TotalFight2 - TotalFight1)*100/Pet1#ets_pet_battle.fight + 50);
			true ->
				0
		end,
	Per2 = 100 - Per1,
%%计算最终胜利结果
	Pet1Win = 
		if
			Per1 - Per2 >= 100 ->
				true;
			Per2 - Per1 >= 100 ->
				false;
			true ->
				Random = util:rand(0, 100),
				if
					Per1 >= Random ->
						true;
					Per1 < Random ->
						false;
					true ->
						true
				end
		end,
	Pet1Win.

pet_battle_challenge_again(User,PetID,ChallengeID) ->		
	case reduce_pet_battle_cd(User) of
		false ->
			User;
		NewUser ->
			pet_battle_challenge(NewUser,PetID,ChallengeID)
	end.

reduce_times_and_add_cd(User) ->
	Time = misc_timer:now_seconds() + ?PET_BATTLE_CD,
	update_pet_battle_times(User,-1,Time).

add_pet_battle_times(User) ->
	LogList = get_pet_battle_log_list(User#ets_users.id),
	TotalTimes = LogList#pet_battle_log_list.total_times,
	if User#ets_users.yuan_bao < ?PET_BATTLE_COUNT_SPEND ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO]),
			User;
		TotalTimes > 14 ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_PET_BATTLE_MAX_TIMES]),
			User;
		true ->
			NewLogList = LogList#pet_battle_log_list{total_times = TotalTimes + ?PET_BATTLE_COUNT},
			ets:insert(?ETS_PET_BATTLE_LOG, NewLogList),
			NewUser = update_pet_battle_times(User,?PET_BATTLE_COUNT,User#ets_users.pet_battle_time),
			lib_player:reduce_cash_and_send(NewUser, ?PET_BATTLE_COUNT_SPEND, 0, 0, 0,{?CONSUME_YUANBAO_PET_BATTLE_TIMES,TotalTimes,1})
	end.

reduce_pet_battle_cd(User) ->
	Time = misc_timer:now_seconds(),
	if User#ets_users.yuan_bao < ?PET_BATTLE_CD_SPEND ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO]),
			false;
		User#ets_users.pet_battle_time < Time ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_PET_BATTLE_NO_CD]),
			false;
		true ->
			NewUser = update_pet_battle_times(User,0,Time),
			lib_player:reduce_cash_and_send(NewUser, ?PET_BATTLE_CD_SPEND, 0, 0, 0,{?CONSUME_YUANBAO_PET_BATTLE_CD,Time,1})
	end.

update_pet_battle_times(User,Count,Time) ->
	NewUser = User#ets_users{ pet_battle_count = User#ets_users.pet_battle_count + Count,
													pet_battle_time = Time},
	send_pet_battle_time(NewUser),
	NewUser.

init_wild_pet_battle() ->
	case db_agent_pet:get_battle_top_last() of 
		0 -> init_wild_pet_battle1(1,550);
		Top ->
			if Top > 2000 ->
				skip;
			true ->
 				init_wild_pet_battle1(Top+1,4)
			end
	end.

init_wild_pet_battle1(PetID,0) ->
	init_over;
init_wild_pet_battle1(PetID,Count) ->
P = if  PetID > 549 ->
		50 / (PetID +100);
		true ->
		(600 -PetID) / 600
	end,
TemplateID = lists:nth(util:rand(1, 4), ?PET_BATTLE_PET_KINDS_LIST),
Quality = util:rand(0, 1) + tool:floor(5*P),
Stairs = util:rand(0, 1) + tool:floor(12*P),
ReplaceID = TemplateID + case Stairs div 4 of
												1 -> 100;
												2 -> 200;
												3 -> 200;
												_ -> 0
											end,
Level = util:rand(0, 1) + tool:floor(125*P),
Fight = tool:floor(40000*P),
Skill = case tool:floor(4*P) of
		4 -> 3;
		E -> E
	end,
SL1= [lists:concat(["70020", util:rand(0, 1)+Skill]), lists:concat(["70030", util:rand(0, 1)+Skill]),lists:concat(["70060", util:rand(0, 1)+Skill]),lists:concat(["70070", util:rand(0, 1)+Skill])],
SL = change_list_to_string(SL1),
crate_wild_pet(PetID+900000000000,TemplateID,ReplaceID,Fight,Quality,Level,Stairs,SL),
init_wild_pet_battle1(PetID +1,Count -1).
%%=============================数据操作=====start===================================


crate_wild_pet(PetID,TemplateID,ReplaceID,Fight,Quality,Level,Stairs,SL) ->
	Name = set_wild_pet_name(Stairs, TemplateID),
	WildPet = #ets_pet_battle{
									pet_id = PetID,												%%宠物ID
									user_id = 0,										%%玩家ID
									template_id = TemplateID,                        %% 模板ID	
									replace_template_id = ReplaceID,		%%外形
									name = Name,                              %% 昵称	
									fight = Fight,                    		  %% 战斗力
									quality = Quality,                            %% 品质
									level = Level,                              %% 宠物等级	
									stairs = Stairs,                             %% 品阶	
									top = db_agent_pet:get_battle_top_last() + 1,						%%  排行
									skill_list = SL														%% 技能列表
									},
	db_agent_pet:crate_pet_battle(WildPet).

%% 列表转化为字符串类型 [1|2|3|4]
change_list_to_string(List) ->
    F = fun(Type, [[_|Acce], String]) ->     
           if
              erlang:length(Acce) =:= 0 ->
				 String1 = lists:concat([Type, '']),
                 String2 = string:concat(String, String1),
                 [Acce, String2];
                
              true ->
                 String1 = lists:concat([Type, '|']),
                 String2 = string:concat(String, String1),
                 [Acce, String2]
            end
        end,
    [_, FinalString] = lists:foldl(F, [List, ""], List),
    FinalString.

filter_pet_skill_list(List) ->
	F = fun([Skill],L) ->
			PreTem = Skill div 10 ,
			case lists:keyfind(PreTem, 1, ?PET_BATTLE_ATK_SKILL_LIST) of 
				false ->
					L;
				Info ->
					[Skill|L]
			end
		end,
	lists:foldl(F, [], List).

%%创建宠物数据
crate_pet_battle_info(Info,Lv) ->
	if Lv < ?PET_BATTLE_LEVEL ->
			skip;
		true ->			
			List = db_agent_pet:get_pet_battle_skills(Info#ets_users_pets.id),
			SL1 = filter_pet_skill_list(List),
			SL = change_list_to_string(SL1),
			TopRecord = #ets_pet_battle{
									pet_id = Info#ets_users_pets.id,												%%宠物ID
									user_id = Info#ets_users_pets.user_id,										%%玩家ID
									template_id = Info#ets_users_pets.template_id,                        %% 模板ID	
									replace_template_id = Info#ets_users_pets.replace_template_id,		%%外形
									name = Info#ets_users_pets.name,                              %% 昵称	
									fight = Info#ets_users_pets.fight,                    		  %% 战斗力
									quality = Info#ets_users_pets.quality,                            %% 品质
									level = Info#ets_users_pets.level,                              %% 宠物等级	
									stairs = Info#ets_users_pets.stairs,                             %% 品阶	
									top = db_agent_pet:get_battle_top_last() + 1,						%%  排行
									skill_list = SL														%% 技能列表
									},
			db_agent_pet:crate_pet_battle(TopRecord),
			update_pet_battle(TopRecord)
	end.

%%创建宠物战斗日志
crate_pet_battle_log(Pet,CPet,State,UserNick) ->
	case State of
				4 -> %挑战失败连胜中断
					Nick = case CPet#ets_pet_battle.user_id of
						0 ->	"野生";
						E ->	lib_player:get_nick_by_id(E)
						end,
					Log = #pet_battle_log{
												pet_id = Pet#ets_pet_battle.pet_id,
												pet_name = Pet#ets_pet_battle.name,
												nick = UserNick,
												challenge_pet_id = CPet#ets_pet_battle.pet_id,
												challenge_pet_name = CPet#ets_pet_battle.name,
												challenge_nick = Nick,
												top = Pet#ets_pet_battle.top,
												state = State,
												winning = CPet#ets_pet_battle.top,
												time = misc_timer:now_milseconds()
												},
					update_battle_log(0, Log);
				3 -> %终结
					Nick = case CPet#ets_pet_battle.user_id of
						0 ->	"野生";
						E ->	lib_player:get_nick_by_id(E)
						end,
					Log = #pet_battle_log{
												pet_id = Pet#ets_pet_battle.pet_id,
												pet_name = Pet#ets_pet_battle.name,
												nick = UserNick,
												challenge_pet_id = CPet#ets_pet_battle.pet_id,
												challenge_pet_name = CPet#ets_pet_battle.name,
												challenge_nick = Nick,
												top = Pet#ets_pet_battle.top,
												state = State,
												winning = CPet#ets_pet_battle.top,
												time = misc_timer:now_milseconds()
												},
					update_battle_log(0, Log);
				2 -> %连胜纪录
					Nick = case Pet#ets_pet_battle.user_id of
						0 ->	"野生";
						E ->	lib_player:get_nick_by_id(E)
						end,
					Log = #pet_battle_log{
												pet_id = Pet#ets_pet_battle.pet_id,
												pet_name = Pet#ets_pet_battle.name,
												nick = Nick,
												challenge_pet_id = Pet#ets_pet_battle.user_id,
												top = Pet#ets_pet_battle.top,
												state = State,
												winning = Pet#ets_pet_battle.winning,
												time = misc_timer:now_milseconds()
												},
					update_battle_log(0, Log);
				_ ->%某某的宠物XX挑战YY成功 or 失败
					Nick = case CPet#ets_pet_battle.user_id of
						0 ->	"野生";
						E ->	lib_player:get_nick_by_id(E)
						end,
					Log = #pet_battle_log{
												pet_id = Pet#ets_pet_battle.pet_id,
												pet_name = Pet#ets_pet_battle.name,
												nick = UserNick,
												challenge_pet_id = CPet#ets_pet_battle.pet_id,
												challenge_pet_name = CPet#ets_pet_battle.name,
												challenge_nick = Nick,
												top = Pet#ets_pet_battle.top,
												state = State,
												winning = Pet#ets_pet_battle.winning,
												time = misc_timer:now_milseconds()
												},
					update_battle_log(Pet#ets_pet_battle.user_id, Log)
	end.

update_pet_battle_fight(Info) ->	
	case  get_pet_battle_by_id(Info#ets_users_pets.id) of 
			[] ->
				skip;
			Pet ->
				List = db_agent_pet:get_pet_battle_skills(Info#ets_users_pets.id),
				SL1 = filter_pet_skill_list(List),
				SL = change_list_to_string(SL1),
				NewPet = Pet#ets_pet_battle{
									replace_template_id = Info#ets_users_pets.replace_template_id,		%%外形
									name = Info#ets_users_pets.name,                              %% 昵称	
									fight = Info#ets_users_pets.fight,                    		  %% 战斗力
									quality = Info#ets_users_pets.quality,                            %% 品质
									level = Info#ets_users_pets.level,                              %% 宠物等级	
									stairs = Info#ets_users_pets.stairs,                             %% 品阶	
									skill_list = SL														%% 技能列表
									},
				update_pet_battle(NewPet)
	end.

update_pet_battle(Pet) ->
	ets:insert(?ETS_PET_BATTLE_DATA,Pet).

update_pet_battle_nick(PetID,Name) ->
	case  get_pet_battle_by_id(PetID) of 
			[] ->
				skip;
			Pet ->
				NewPet = Pet#ets_pet_battle{name = Name},
				update_pet_battle(NewPet)
	end.

get_user_pets(UserID) ->
	F = fun(Info)->
				list_to_tuple([ets_users_pets] ++ (Info))
		end,
	List = db_agent_pet:get_user_all_pet(UserID),
	[F(Info) || Info <- List].

get_pet_top_award_template(MyPetList) ->
	F = fun(Info) ->
			get_pet_battle_top_award(Info#ets_pet_battle.yesterday_top)
	end,
	[F(Pet) || Pet <- MyPetList].	

get_pet_battle_top_award(Top_Num) ->
	[[LastTop]] = db_agent_pet:get_pet_battle_yesterday_top_max(),
	Top1 = tool:ceil(LastTop / 3 ),
	Top2 = tool:ceil(LastTop / 3 * 2),
	if Top_Num  =:= 0 ->	
			0;
		Top_Num >= 1 andalso Top_Num < 4->
			lists:nth(1,?PET_BATTLE_TOP_AWARD_LIST);
		Top_Num >= 4 andalso Top_Num < Top1 ->
			lists:nth(2,?PET_BATTLE_TOP_AWARD_LIST);
		Top_Num >= Top1 andalso Top_Num < Top2 ->
			lists:nth(3,?PET_BATTLE_TOP_AWARD_LIST);
		true ->
			lists:nth(4,?PET_BATTLE_TOP_AWARD_LIST)
	end.

get_pet_battle_by_userid(UserID) ->
	List = db_agent_pet:get_pet_battle_by_user_id(UserID),
	F = fun([Info])->			
				get_pet_battle_by_id(Info)
		end,
	[F(Info) || Info <- List].

get_pet_battle_yesterday_award(User) ->
	List = db_agent_pet:get_pet_battle_yesterday_top(User#ets_users.id),
	F = fun([Info])->			
				if Info =/= 0 ->
					ItemID = get_pet_battle_top_award(Info),
					gen_server:cast(User#ets_users.other_data#user_other.pid_item, {add_item_or_mail,ItemID,1,?BIND,User#ets_users.nick_name,?ITEM_PICK_PET_BATTLE});
					true ->
						skip
				end
		end,
	[F(Info) || Info <- List].

get_pet_battle_by_id(PetID) ->
	case ets:lookup(?ETS_PET_BATTLE_DATA, PetID) of
		[] ->
			Info = db_agent_pet:get_pet_battle_by_pet_id(PetID),
			if Info =:= [] ->
					[];
				true ->
					T = list_to_tuple([ets_pet_battle] ++ (Info)),
					update_pet_battle(T),
					T
			end;
		[Pet] ->
			[Top] = db_agent_pet:get_pet_battle_top_by_pet_id(PetID),
			NewPet = Pet#ets_pet_battle{top = Top},
			update_pet_battle(NewPet),
			NewPet;
		E ->
			?DEBUG("error id:~p",[E]),
			[]
	end.

get_pet_battle_by_top(Top,Count) ->
	List = db_agent_pet:get_pet_battle_by_top(Top,Count),
	F = fun([ID],PetList)->
				Pet = get_pet_battle_by_id(ID),
				[Pet|PetList]
		end,
	lists:foldl(F, [], List).

%%设置野生宠物
set_pet_to_wild(PetID) ->
	case get_pet_battle_by_id(PetID) of
			[] ->
				skip;
			Pet ->
				Name = set_wild_pet_name(Pet#ets_pet_battle.quality,Pet#ets_pet_battle.template_id),
				NewPet = Pet#ets_pet_battle{
														name = Name,
														user_id = 0
															},
				update_pet_battle(NewPet),
				db_agent_pet:update_pet_battle(NewPet)
	end.

get_pet_battle_log_list(UserID) ->
	case ets:lookup(?ETS_PET_BATTLE_LOG, UserID) of
		[] ->
			Logs = #pet_battle_log_list{user_id = UserID},
			ets:insert(?ETS_PET_BATTLE_LOG, Logs),
			Logs;
		[Info] ->
			Info
	end.

get_pet_battle_logs(UserID) ->
	WinningLogList = get_pet_battle_log_list(0),
	%NewWinningList = lists:keydelete(UserID, #pet_battle_log.challenge_pet_id, WinningLogList#pet_battle_log_list.log_list),
	UserLogs = get_pet_battle_log_list(UserID),
	LogList = lists:append(WinningLogList#pet_battle_log_list.log_list, UserLogs#pet_battle_log_list.log_list),
	F2 = fun(Info) ->
		?DEBUG("Info:~p,~p,~p,~p",[Info#pet_battle_log.pet_id,Info#pet_battle_log.challenge_pet_id,Info#pet_battle_log.time,Info#pet_battle_log.state])
	end,
	%lists:foreach(F2, LogList),
	F = fun(X,Y) ->
		if X#pet_battle_log.time < Y#pet_battle_log.time ->
				false;
			true ->
				true
		end
	end,
	NewLogs1 = lists:sort(F, LogList),
	%?DEBUG("=========================",[]),
	%lists:foreach(F2, NewLogs1),
	Len = length(NewLogs1),
	if Len >10 ->
			{List2, _List3} = lists:split(10, NewLogs1),
			List2;
		true ->
			NewLogs1
	end.

delete_battle_log(UserID,PetID,CPetID) ->	
		Info = get_pet_battle_log_list(UserID),
		LogList = Info#pet_battle_log_list.log_list,
		F = fun(Log,List) ->
			if Log#pet_battle_log.pet_id =:=CPetID andalso Log#pet_battle_log.challenge_pet_id =:=PetID 
				andalso Log#pet_battle_log.state =:=1 ->
					List;
				true ->
					[Log|List]
			end
		end,
		NewRecord = lists:foldl(F, [], LogList),
		ets:insert(?ETS_PET_BATTLE_LOG,NewRecord).

update_battle_log(UserID,Log) ->
	case ets:lookup(?ETS_PET_BATTLE_LOG, UserID) of
		[] ->
			LogList = [Log],
			NewRecord = #pet_battle_log_list{ user_id = UserID,log_list = LogList},
			ets:insert(?ETS_PET_BATTLE_LOG,NewRecord);
		[Info] ->
			LogList = Info#pet_battle_log_list.log_list,
			NewList = 
				if	erlang:length(LogList) < 10 ->
					[Log|LogList];
				true ->
					List1 = [Log|LogList],
					%?DEBUG("List1:~p",[List1]),
					{List2, _List3} = lists:split(10, List1),
					%?DEBUG("List1:~p",[List2]),
					List2
				end,
			NewRecord = Info#pet_battle_log_list{log_list = NewList},
			ets:insert(?ETS_PET_BATTLE_LOG,NewRecord)
	end.

save_pet_battle_data() ->
	F = fun(Info) ->
				db_agent_pet:update_pet_battle(Info)
		end,
	List = ets:tab2list(?ETS_PET_BATTLE_DATA),
	[F(Info) || Info <- List],
	ok.

reset_pet_battle_yesterday_top() ->
	db_agent_pet:reset_pet_battle_yesterday_top(),
	F = fun(Info) ->
				List = Info#pet_battle_log_list{top_award = 0,total_times = 10},
				ets:insert(?ETS_PET_BATTLE_LOG, List)
		end,
	List = ets:tab2list(?ETS_PET_BATTLE_LOG),
	[F(Info) || Info <- List],
	send_pet_new_award_state(),
	ok.

send_pet_new_award_state() ->
	MS = ets:fun2ms(fun(T) ->
			T#ets_users.other_data#user_other.pid_send
			end),
	L = ets:select(?ETS_ONLINE, MS),
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_TOP_AWARD,[0]),
	F = fun(Sid) ->
		lib_send:send_to_sid(Sid, Data)
	end,
    [F(X) || X <- L].

get_top_award_state(UserID) ->
	Info1 = get_pet_battle_log_list(UserID),
	Info1#pet_battle_log_list.top_award.

update_top_award_state(UserID,State) ->
	Info = get_pet_battle_log_list(UserID),
	Logs = 	Info#pet_battle_log_list{top_award = State},
	ets:insert(?ETS_PET_BATTLE_LOG, Logs).

reset_pet_battle_times(User) ->
	LastBattleTime = User#ets_users.pet_battle_time - ?PET_BATTLE_CD,
	if LastBattleTime < 0 ->
			User#ets_users{pet_battle_count = 10};
		true ->
			Now = misc_timer:now_seconds(),
			case util:is_same_date(LastBattleTime,Now) of
				true ->
					User;
				E ->
					User#ets_users{pet_battle_count = 10}
			end
	end.	

%%=============================数据操作=====end===================================

%%=============================消息发送=====start===================================
send_join_top(User) ->
	MyPetList = get_pet_battle_by_userid(User#ets_users.id),
	ChampionList = get_pet_battle_by_top(1, 3),	
	AwardList = get_pet_top_award_template(MyPetList),
	Logs = get_pet_battle_logs(User#ets_users.id),
	Time = User#ets_users.pet_battle_time,
	Count = User#ets_users.pet_battle_count,
	LogList = get_pet_battle_log_list(User#ets_users.id),
	AwardState = LogList#pet_battle_log_list.top_award,
	TotalTimes = LogList#pet_battle_log_list.total_times,
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_JOIN, [MyPetList,ChampionList,Logs,AwardList,Count,TotalTimes,Time,AwardState]),
	lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send,Data).

send_pet_battle_self_log(User) ->
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_SELF_LOG,[]),
	lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send,Data).	

send_pet_battle_logs(User) ->
	Logs = get_pet_battle_logs(User#ets_users.id),
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_LOG,[Logs]),
	lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send,Data).

send_user_join_top(PidSend,Name) ->
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_JOIN,[Name]),
	lib_send:send_to_sid(PidSend,Data).

send_champion_list(PidSend) ->
	List = get_pet_battle_by_top(1, 3),
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_CHAMPION,[List]),
	lib_send:send_to_sid(PidSend,Data).

send_pet_battle_top_award(User) ->
	case get_top_award_state(User#ets_users.id) of
		0 ->
			get_pet_battle_yesterday_award(User),
			update_top_award_state(User#ets_users.id, 1);
		1 ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_PET_BATTLE_AWARD]);
		E ->
			?DEBUG("Error award state:~p",[E])			
	end,
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_TOP_AWARD,[1]),
	lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send,Data).

send_pet_battle_champion_award() ->
	case get_pet_battle_by_top(1, 3) of
		[] ->
			pet_list_empty;
		TopList ->
			send_pet_battle_champion_award1(TopList)
	end.

send_pet_battle_champion_award1(TopList) ->
	{MegaSecs, Secs, MicroSecs} = misc_timer:now(),	
	{{Y,Month,D},_} = calendar:now_to_local_time({MegaSecs, Secs - 60, MicroSecs}),
	send_pet_battle_champion_award1(TopList,{Y,Month,D}).

send_pet_battle_champion_award1([],_) ->
	ok;
send_pet_battle_champion_award1([Info|L],{Y,Month,D}) ->
	if Info#ets_pet_battle.user_id =:= 0 ->
			wild_pet;
		true ->
			case lib_player:get_nick_by_id(Info#ets_pet_battle.user_id) of
				null ->
					set_pet_to_wild(Info#ets_pet_battle.pet_id);
				Nick ->
					Template_id = lists:nth(1, ?PET_BATTLE_TOP_AWARD_LIST),
					case data_agent:item_template_get(Template_id) of
						Template when is_record(Template, ets_item_template) ->
							MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
							MailItem = item_util:add_item_and_get_id(MailItem1),
							Title = ?GET_TRAN(?_LANG_MAIL_PET_BATTLE_TOP_AWARD_TITLE,[Info#ets_pet_battle.top]),
							Content = ?GET_TRAN(?_LANG_MAIL_PET_BATTLE_TOP_AWARD_CONTENT,[Info#ets_pet_battle.name,Y,Month,D,Info#ets_pet_battle.top]),
							lib_mail:send_GM_items_to_mail([[MailItem], Nick, Info#ets_pet_battle.user_id, Title, Content]);
						_ ->
							ok
					end
			end
	end,
	send_pet_battle_champion_award1(L,{Y,Month,D}).

send_self_pet(User) ->
	MyPetList = get_pet_battle_by_userid(User#ets_users.id),
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_SELF_PET, [MyPetList]),
	lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send,Data).

send_pet_battle_result(PidSend,Pet,CPet,Result,Coper,Exp,ItemTemID) ->
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_CHALLENGE,[Pet,CPet,Result,Coper,Exp,ItemTemID]),
	lib_send:send_to_sid(PidSend,Data).

send_pet_challenge_list(PidSend,PetID,List) ->
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_CHALLENGE_LIST,[PetID,List]),
	lib_send:send_to_sid(PidSend,Data).

send_pet_battle_winning() ->
	MS = ets:fun2ms(fun(T) ->
			{T#ets_users.other_data#user_other.pid_send,T#ets_users.id}
			end),
	L = ets:select(?ETS_ONLINE, MS),
    do_broadcast(L).

do_broadcast(L) ->
	F = fun({Sid,UserID}) ->
		Logs = get_pet_battle_logs(UserID),
		{ok,Data} = pt_25:write(?PP_PET_BATTLE_LOG, [Logs]),
		lib_send:send_to_sid(Sid, Data)
	end,
    [F(X) || X <- L].		

send_pet_battle_time(User) ->
	Count = User#ets_users.pet_battle_count,
	Time = User#ets_users.pet_battle_time,
	PidSend = User#ets_users.other_data#user_other.pid_send,
	LogList = get_pet_battle_log_list(User#ets_users.id),
	{ok,Data} = pt_25:write(?PP_PET_BATTLE_TIME,[Count,LogList#pet_battle_log_list.total_times,Time]),
	lib_send:send_to_sid(PidSend,Data).

%%=============================消息发送====end====================================


%%设置野生宠物名称
set_wild_pet_name(Stairs,TemplateID) ->	
	Tatle = case TemplateID of
		260001 ->
			"野猪";
		260002 ->
			"仙狐";
		260003 ->
			"红鸟";
		260005 ->
			"白虎";
		_ -> 
			"野兽"
		end,

	Name = if Stairs < 4 ->
			lists:append("小",Tatle);
		Stairs >= 4 andalso Stairs < 8 ->
			lists:append("大",Tatle);
		Stairs >= 8 andalso Stairs < 12 ->
			lists:append(Tatle,"王");
		Stairs =:= 12 ->
			lists:append(Tatle,"至尊");
		true ->
			lists:append("奇怪的",Tatle)
		end,
	Name.
