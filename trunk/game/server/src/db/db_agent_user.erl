%% Author: Administrator
%% Created: 2011-3-12
%% Description: TODO: Add description to db_agent_user
-module(db_agent_user).


%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 get_user_friend_info_by_UserId/1,
		 get_user_friend_info_by_Nick/1,
		 get_user_infant_by_username/2,
		 get_donttalk_status/1,
		 set_donttalk_status/3,
		 delete_forbid_status/1,
		 update_user_skill/5,
		 update_user_skill_bar/5,
		 update_mounts_skill_books/3,
		 update_pet_skill_books/3,
		 update_user_veins/5,
		 update_user_veins_cd/3,
		 update_user_welfare/2,
		 update_user_challenge/2,
		 update_user_exploit/2,
		 expend_user_exploit/2,
		 add_token_task_award/2,
		 save_user_infant/5,
		 get_users_title/1,
		 get_user_welfare/1,
		 get_user_exploit/1,		 
		 get_user_token_task/1,
		 get_user_challenge/1,
		 get_user_bank/1,
		 update_user_bank_state/3,
		 add_user_bank/1,
		 update_user_token_receive_num/2,
		 update_user_token_task/2,
		 update_users_title/2,
		 update_transport_info/3,
		 update_transport_quality/2,
		 get_user_info_by_UserId/1,
		 get_user_info_by_Nick/1,
		 delete_forbid_status_by_id/1,
		 set_forbid_status_by_nick/2,
		 set_forbid_status_by_id/2,
		 get_user_active/1,
		 update_user_active/5,
		 insert_user_active/5,
		 get_user_activity_open_server/1,
		 update_user_activity_open_server/2,
		 update_user_activity_open_server_wards/3,
		 get_user_yellow_box/1,
		 insert_user_yellow_box/4,
		 update_user_yellow_box/3,
		 get_activity_seven_data/0,
		 insert_activity_seven_data/1,
		 update_activity_seven_data/1,
		 get_top_money/0
		 ]).

%%
%% API Functions
%%
get_user_info_by_UserId(UserId) ->
	?DB_MODULE:select_row(t_users, "nick_name, sex, level, state, career", [{id, UserId}]).

get_user_info_by_Nick(Nick) ->
	?DB_MODULE:select_row(t_users, "id, sex, level, state, career", [{nick_name, Nick}]).

get_user_friend_info_by_UserId(UserId) ->	
	?DB_MODULE:select_row(t_users, "nick_name, sex, level, state", [{id, UserId}]).

get_user_friend_info_by_Nick(Nick) ->
	?DB_MODULE:select_row(t_users, "id, sex, level, state", [{nick_name, Nick}]).

%% get_user_socket_by_UserId(UserId) ->
%% 	?DB_MODULE:select_row(t_users_info, "socket", [{id, UserId}]).

get_user_infant_by_username(UserName, Site) ->
	?DB_MODULE:select_row(t_users_infant,"card_name, card_id", [{user_name, UserName},{site, Site}]).

%% 获取角色禁言信息
get_donttalk_status(Id) ->
	?DB_MODULE:select_row(t_users, "ban_chat_date",[{id, Id}]).

%%获取玩家称号
get_users_title(Id) ->
	?DB_MODULE:select_row(t_users_titles, "titles",[{user_id, Id}]).

%%获取玩家福利信息
get_user_welfare(Id) ->
	?DB_MODULE:select_row(t_user_welfare, "*",[{user_id, Id}]).

%% 获取玩家功勋信息
get_user_exploit(Id) ->
	?DB_MODULE:select_row(t_user_exploit, "*",[{user_id, Id}]).

%%获取玩家江湖令信息
get_user_token_task(Id) ->
	?DB_MODULE:select_row(t_user_token, "*",[{user_id, Id}]).

%%获取玩家试炼信息
get_user_challenge(Id) ->
	?DB_MODULE:select_row(t_user_challenge, "*", [{user_id, Id}]).

%%获取玩家银行投资信息
get_user_bank(Id) ->
	?DB_MODULE:select_all(t_user_bank, "*", [{user_id, Id}]).

%% 更新玩家银行投资领取信息
update_user_bank_state(Id,Type,State) ->
	?DB_MODULE:update(t_user_bank, [{state, State}],[{user_id, Id},{type, Type}]).
%% 新增加玩家银行投资
add_user_bank(BankInfo) ->
	?DB_MODULE:insert(t_user_bank, [user_id,type,money,state,add_time],
						[BankInfo#ets_user_bank.user_id,BankInfo#ets_user_bank.type,
						BankInfo#ets_user_bank.money,BankInfo#ets_user_bank.state,BankInfo#ets_user_bank.add_time]).

%% 设置角色禁言信息
set_donttalk_status(Id,BanChatDate,BanChat) ->
	?DB_MODULE:update(t_users, [ {ban_chat_date, BanChatDate},{ban_chat,BanChat}],
								 [{id, Id}]).

%%取消禁号
delete_forbid_status_by_id(UserID) ->
	?DB_MODULE:update(t_users, [{forbid, 1}],
								 [{id, UserID}]).

%%取消禁号
delete_forbid_status(Nicname) ->
		?DB_MODULE:update(t_users, [{forbid, 1}],
								 [{nick_name, Nicname}]).

set_forbid_status_by_nick(Nicname,ForbidDate) ->
	?DB_MODULE:update(t_users, [{forbid, 0},{forbid_date,ForbidDate}],
								 [{nick_name, Nicname}]).

%% 禁号
set_forbid_status_by_id(UserID,ForbidDate) ->
	?DB_MODULE:update(t_users, [{forbid, 0},{forbid_date,ForbidDate}],
								 [{id, UserID}]).

%% 保存技能信息
update_user_skill(UserId,OldTemplateId,TemplateId,Lv,ValidDate) ->
	case Lv =:= 1 of
		true ->
			?DB_MODULE:insert(t_users_skills, [user_id,template_id,begin_date,valid_date,is_exist,lv],
							  				  [UserId,TemplateId,1,ValidDate,1,Lv]);
		_ ->
			?DB_MODULE:update(t_users_skills, [{template_id,TemplateId},{valid_date,ValidDate},{lv,Lv}],
							  					[{user_id,UserId},{template_id,OldTemplateId}])
	end.
		
update_user_skill_bar(UserId,Bar_Index,Type,TemplateId,GroupId) ->
	[Count] = ?DB_MODULE:select_count(t_users_skill_bar,[{user_id,UserId},{bar_index,Bar_Index}]),
	case Count > 0 of
		true ->
			?DB_MODULE:update(t_users_skill_bar, [{type,Type},{template_id,TemplateId},{group_id,GroupId}],
							  					[{user_id,UserId},{bar_index,Bar_Index}]);
		_ ->
			?DB_MODULE:insert(t_users_skill_bar, [user_id,bar_index,type,template_id,group_id],
							  					[UserId,Bar_Index,Type,TemplateId,GroupId])
	end.


update_mounts_skill_books(UserId,List,Luck) ->
	Books = util:term_to_string(List),
	?DB_MODULE:update(t_users, [{mounts_skill_books,Books},{mounts_skill_books_luck,Luck}],
							  					[{user_id,UserId}]).

update_pet_skill_books(UserId,List,Luck) ->
	Books = util:term_to_string(List),
	?DB_MODULE:update(t_users, [{pet_skill_books,Books},{pet_skill_books_luck,Luck}],
							  					[{user_id,UserId}]).

%% 保存筋脉信息
update_user_veins(UserId,AcupointType,AcupointLv,GenguLv,Luck) ->
	if (AcupointLv =:= 1 andalso GenguLv =:= 0) or (AcupointLv =:= 0 andalso GenguLv =:= 1) ->
		?DB_MODULE:insert(t_users_veins, [user_id,acupoint_type,acupoint_levl,gengu_levl,luck],
							  				  [UserId,AcupointType,AcupointLv,GenguLv,Luck]);
	true ->
		?DB_MODULE:update(t_users_veins,[{acupoint_levl, AcupointLv},{gengu_levl, GenguLv},{luck, Luck}],
											[{user_id, UserId},{acupoint_type, AcupointType}])
	end.
update_user_veins_cd(UserId, Time, AcupointType) ->
	?DB_MODULE:update(t_users, [{veins_cd, Time},{veins_acupoint_uping, AcupointType}], [{user_id, UserId}]).

%% 保存奖励信息
update_user_welfare(Userid,Welfare) ->
	?DB_MODULE:replace(t_user_welfare,[{user_id,Userid},
										{reset_time,Welfare#ets_user_welfare.reset_time},
										{login_day,Welfare#ets_user_welfare.login_day},
										{receive_time,Welfare#ets_user_welfare.receive_time},
										{vip_receive_time,Welfare#ets_user_welfare.vip_receive_time},
										{duplicate_num,Welfare#ets_user_welfare.duplicate_num},
										{multi_duplicate_num,Welfare#ets_user_welfare.multi_duplicate_num},
										{off_line_times,Welfare#ets_user_welfare.off_line_times}]).

%%保存试炼副本信息
update_user_challenge(UserId, Info) ->
	?DB_MODULE:replace(t_user_challenge,[{user_id,UserId},
										{challenge_num, Info#r_user_challenge_info.challenge_num},
										{challenge_star, Info#r_user_challenge_info.challenge_star},
										{last_challenge_time, Info#r_user_challenge_info.last_challenge_time}]).

%% 保存功勋信息
update_user_exploit(Userid, Exploit) ->
	?DB_MODULE:replace(t_user_exploit,[{user_id,Userid},
										{exploit, Exploit#user_exploit_info.exploit},
										{pvp1_day_award, Exploit#user_exploit_info.pvp1_day_award},
										{achieve_time, Exploit#user_exploit_info.achieve_time}]).
%% 消耗功勋
expend_user_exploit(Userid, Value) ->
	?DB_MODULE:update(t_user_exploit,[{exploit,Value}],[{user_id,Userid}]).

%% 保存用户江湖令信息
update_user_token_task(Userid,Token) ->
	ReceiveLog = lib_token_task:list_to_string(Token#ets_user_token.receive_log),
	PublishLog = lib_token_task:list_to_string(Token#ets_user_token.publish_log),
	?DB_MODULE:replace(t_user_token,[{user_id,Userid},
									{receive_log, ReceiveLog},
									{publish_log, PublishLog},
									{last_receive_time, Token#ets_user_token.last_receive_time},
									{receive_task_id, Token#ets_user_token.receive_task_id},
									{receive_num1, Token#ets_user_token.receive_num1},
									{receive_num2, Token#ets_user_token.receive_num2},
									{receive_num3, Token#ets_user_token.receive_num3},
									{receive_num4, Token#ets_user_token.receive_num4}]).

%% 更新用户发布的江湖令被领取记录
update_user_token_receive_num(Type, Userid) ->
	case Type of
		1 ->
			?DB_MODULE:update(t_user_token,[{receive_nun1,1,add}],[{user_id,Userid}]);
		2 ->
			?DB_MODULE:update(t_user_token,[{receive_nun2,1,add}],[{user_id,Userid}]);
		3 ->
			?DB_MODULE:update(t_user_token,[{receive_nun3,1,add}],[{user_id,Userid}]);
		4 ->
			?DB_MODULE:update(t_user_token,[{receive_nun4,1,add}],[{user_id,Userid}]);
		_ ->
			ok
	end.
add_token_task_award(Award, Userid) ->
	{Copper , BindCopper , Exp } = Award,
	?DB_MODULE:update(t_user,[{copper,Copper,add},{bind_copper,BindCopper,add},{exp,Exp,add}],[{id,Userid}]).
get_user_active(UserId) ->
	?DB_MODULE:select_row(t_users_active, "*",[{user_id, UserId}]).

%% 更新活动数据
update_user_active(UserId,DayActive,Rewards,Date,Times) ->
	?DB_MODULE:update(t_users_active,[{day_active,DayActive},{rewards,Rewards},{date, Date},{times, Times}],
											[{user_id, UserId}]).

insert_user_active(UserId,DayActive,Rewards,Date,Times) ->
	?DB_MODULE:insert(t_users_active,[user_id,day_active,rewards,date,times],
							  				  [UserId,DayActive,Rewards,Date,Times]).


%%更新玩家称号
update_users_title(UserId, Title) ->
	[Count] = ?DB_MODULE:select_count(t_users_titles,[{user_id,UserId}]),
	case Count > 0 of
		true ->
			?DB_MODULE:update(t_users_titles, [{titles,Title}],[{user_id, UserId}]);
		_ ->
			?DB_MODULE:insert(t_users_titles, [user_id,titles],[UserId,Title])
	end.
  

%% 保存防沉迷信息
save_user_infant(UserName, Site, CardName, CardID, Date) ->
	[Count] = ?DB_MODULE:select_count(t_users_infant,[{user_name,UserName}]),
	case Count > 0 of
		true ->
			?DB_MODULE:update(t_users_infant, [{site,Site},{card_name,CardName},{card_id,CardID},{date, Date}],
							  					[{user_name,UserName}]);
		_ ->
			?DB_MODULE:insert(t_users_infant, [user_name, site, card_name, card_id, date],
							  [UserName, Site, CardName, CardID, Date])
	end.


%% 保存角色运镖品质
update_transport_quality(Quality, UserId) ->
	?DB_MODULE:update(t_users, [{escort_id, Quality}],[{id, UserId}]).

%%保存角色运镖信息：运镖次数、每天第一次运镖时间
update_transport_info(TodayTimes, FirstTransTime, UserId) ->
	case FirstTransTime =/= 0 of
		true ->
			?DB_MODULE:update(t_users, [{today_escort_times, TodayTimes},{first_escort_date,FirstTransTime}],[{id, UserId}]);
		_ ->
			?DB_MODULE:update(t_users, [{today_escort_times, TodayTimes}],[{id, UserId}])
	end.


%%获取玩家充值/消耗活动数据
get_user_activity_open_server(Id) ->
	?DB_MODULE:select_all(t_users_open_server, "*",[{user_id, Id}]).


update_user_activity_open_server(Re, Info) ->
	case Re of
		1 ->
			NewRewardsIdStr = tool:intlist_to_string_2(Info#ets_users_open_server.rewards_ids),
			?DB_MODULE:update(t_users_open_server, [{num, Info#ets_users_open_server.num},
													{last_date, Info#ets_users_open_server.last_date},
													{rewards_ids, NewRewardsIdStr}],
							  [{user_id,Info#ets_users_open_server.user_id}, {group_id,Info#ets_users_open_server.group_id}]);
		_ ->
			ValueList = lists:nthtail(1, tuple_to_list(Info#ets_users_open_server{other_data = ""})),
		    FieldList = record_info(fields, ets_users_open_server),
			?DB_MODULE:insert(t_users_open_server, FieldList, ValueList)
	end.

update_user_activity_open_server_wards( Rewards_ids,UserId,GroupId) ->
	?DB_MODULE:update(t_users_open_server, [{rewards_ids, Rewards_ids}],[{user_id,UserId}, {group_id,GroupId}]).
		

%% 获取玩家黄钻数据
get_user_yellow_box(Id) ->
	?DB_MODULE:select_row(t_users_yellow_box, "*",[{user_id, Id}]).


insert_user_yellow_box(Id,Value,Value1,Value2) ->
	?DB_MODULE:insert(t_users_yellow_box, [user_id,is_rece_new_pack,rece_day_pack_date,level_up_pack], [Id,Value,Value1,Value2]).
  
update_user_yellow_box(Type,Id,Value)->
	case Type of
		0 ->
			?DB_MODULE:update(t_users_yellow_box, [{rece_day_pack_date,Value}],[{user_id,Id}]);
		1 ->
			?DB_MODULE:update(t_users_yellow_box, [{level_up_pack,Value}],[{user_id,Id}]);
		2 ->
			?DB_MODULE:update(t_users_yellow_box, [{is_rece_new_pack,Value}],[{user_id,Id}]);
		_ ->
			ok
	end.


get_activity_seven_data() ->
	?DB_MODULE:select_all(t_activity_seven_data, "*",[]).

get_top_money() ->
	?DB_MODULE:select_all(t_users, "id, nick_name, money,0", [],[{money,desc}],[3]).

insert_activity_seven_data(Info) ->
	ValueList = top_three_info_to_List(Info#ets_activity_seven_data.top_three,[]),
	Value = tool:intlist_to_string_1(ValueList),
	
	FieldList = record_info(fields, ets_activity_seven_data),
	?DB_MODULE:insert(t_activity_seven_data, FieldList, [Info#ets_activity_seven_data.id,Value,Info#ets_activity_seven_data.is_end]).

update_activity_seven_data(Info) ->
	ValueList = top_three_info_to_List(Info#ets_activity_seven_data.top_three,[]),
	Value = tool:intlist_to_string_1(ValueList),
	?DB_MODULE:update(t_activity_seven_data, [{top_three,Value},{is_end,Info#ets_activity_seven_data.is_end}],[{id,Info#ets_activity_seven_data.id}]).


top_three_info_to_List([],NewList) ->
	NewList;
top_three_info_to_List([H|T], NewList) ->
	NickName = case H#activity_seven_data.nick_name of
				   V  when is_binary(V) ->
					   binary_to_list(H#activity_seven_data.nick_name) ;
				   V1 ->
					  V1
			   end,
			
	top_three_info_to_List(T, lists:append(NewList,[{H#activity_seven_data.user_id, NickName, H#activity_seven_data.num, H#activity_seven_data.is_get}])).

%%
%% Local Functions
%%

