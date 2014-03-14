%%% -------------------------------------------------------------------
%%% Author  : Administrator
%%% Description :
%%%
%%% Created : 2011-5-9
%%% -------------------------------------------------------------------
-module(db_agent_duplicate).


%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include("common.hrl").

%% Exported Functions
%%
-export([
		 get_user_duplicate_by_id/1,
		 add_duplicate/1,
         update_duplicate/1,
		 get_king_fight/0,
		 add_king_fight/1,
		 update_king_fight/1,
		 delete_king_fight/0,
		 add_king_winner/1,
		 update_king_winner_days/1,
		 update_king_winner_guard_list/1,
		 get_king_winner/0,
		 get_king_fight_attack/0,
		 get_king_winner_by_id/1
		 ]).

%%
%% API Functions
%%

%% 获取用户副本
get_user_duplicate_by_id(UserId) ->
	?DB_MODULE:select_all(t_users_duplicate, "*", [{user_id, UserId}]).

%% 添加新副本
add_duplicate(Info) ->
	ValueList = lists:nthtail(1, tuple_to_list(Info#ets_users_duplicate{other_data=""})),
	FieldList = record_info(fields, ets_users_duplicate),
	Ret = ?DB_MODULE:insert(t_users_duplicate, FieldList, ValueList),
	if 
		?DB_MODULE =:= db_mysql ->
		   Ret;
		true ->
		   {mongo, Ret}
	end.

%% 更新副本
update_duplicate(Info) ->	
	?DB_MODULE:update(t_users_duplicate,					  		  
					  [
					   {sum_num, Info#ets_users_duplicate.sum_num},
					   {today_num, Info#ets_users_duplicate.today_num},
					   {reset_num, Info#ets_users_duplicate.reset_num},
					   {last_time, Info#ets_users_duplicate.last_time}],
					  
					  [{user_id, Info#ets_users_duplicate.user_id},
					   {duplicate_id, Info#ets_users_duplicate.duplicate_id}]
					 ).

%% 获取王城战竞争公会列表
get_king_fight() ->
	?DB_MODULE:select_all(t_king_fight, "*", []).

%% 王城战增加竞争公会
add_king_fight(Info) ->
	?DB_MODULE:insert(t_king_fight, [{guild_id, Info#r_king_fight.guild_id},{guild_name, Info#r_king_fight.guild_name}, {state,Info#r_king_fight.state}, {guild_money, Info#r_king_fight.guild_money}]).

%% 王城战更改竞争公会
update_king_fight(Info) ->
	?DB_MODULE:update(t_king_fight, [{guild_money, Info#r_king_fight.guild_money},{state,Info#r_king_fight.state}], [{guild_id, Info#r_king_fight.guild_id}]).

%% 获取王城战进攻帮会
get_king_fight_attack() ->
	?DB_MODULE:select_row(t_king_fight, "*", [{state,1}]).

%% 清空竞争公会列表
delete_king_fight() ->
	?DB_MODULE:delete(t_king_fight, []).

%% 增加王城战胜利公会
add_king_winner(Info) ->
	NowTime = misc_timer:now_seconds(),
	?DB_MODULE:insert(t_king_winner_guard, [{guild_id, Info#ets_king_war_info.defence_guild_id}, {city_master, Info#ets_king_war_info.city_master},{guild_name,Info#ets_king_war_info.defence_guild_name},{days,Info#ets_king_war_info.days},{time, NowTime}]).

%%更新王城公会信息
update_king_winner_days(Info) ->
	NowTime = misc_timer:now_seconds(),
	?DB_MODULE:update(t_king_winner_guard, [{days, Info#ets_king_war_info.days},{city_master, Info#ets_king_war_info.city_master},{time, NowTime}],[{guild_id, Info#ets_king_war_info.defence_guild_id}]).

%%更新王城公会信息
update_king_winner_guard_list(Info) ->
	NowTime = misc_timer:now_seconds(),
	?DB_MODULE:update(t_king_winner_guard, [{guard_list,tool:intlist_to_string(Info#ets_king_war_info.guard_list)},{time, NowTime}],[{guild_id, Info#ets_king_war_info.defence_guild_id}]).

%% 获取王城战胜利公会
get_king_winner() ->
	Time = ?DB_MODULE:select_one(t_king_winner_guard, "MAX(time)", []),
	?DB_MODULE:select_row(t_king_winner_guard, "*", [{time,Time}]).

%% 获取王城战胜利公会
get_king_winner_by_id(ID) ->
	?DB_MODULE:select_row(t_king_winner_guard, "*", [{guild_id,ID}]).

%%获取王城战进攻帮会、防守帮会信息
%% get_king_fight_info() ->
%% 	AttackGuild = ?DB_MODULE:select_one(t_king_fight,"guild_name",[{state,1}]),
%% 	DefInfo = ?DB_MODULE:select_row(t_king_winner_guard,"*",[],[time,desc],[1]),
%% 	{AttackGuild,DefInfo}.


