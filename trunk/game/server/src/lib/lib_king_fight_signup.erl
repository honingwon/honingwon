-module(lib_king_fight_signup).

-include("common.hrl").

-export([init_king_fight/0, get_my_guild_money/2, king_fight_sign_up/5, close_signup/1]).

-define(KING_FIGHT_DIC, king_fight_dic).  			%% 王城战报名进程字典
-define(SIGN_UP_MONEY, 1000).					  %% 比第一名高出的公会财富
-define(FIRST_MONEY, 10000).					  %% 竞拍最低价
-define(KING_FIGHT_TIME, {}).						%% 活动开启时间

init_king_fight() ->
	%% 数据库读取排行榜
	F = fun(Info, Acc) ->
				Record = list_to_tuple([r_king_fight] ++ Info),					
				[Record|Acc]
		end,
	List1 = 
	case db_agent_duplicate:get_king_fight() of
		[] ->
			[];
		List when is_list(List) ->
			lists:foldl(F, [], List);
		_ ->
			[]
	end,
	sort_guild_list(List1, #r_king_fight_signup{state =0}).

%% 排序列表，返回State
sort_guild_list(List, SignState) ->
	F1 = fun(Info1, Info2) ->
			Info1#r_king_fight.guild_money > Info2#r_king_fight.guild_money
		 end,
	NewList1 = lists:sort(F1, List),
	{Nick_name, Guild_money, GuildId} =
	if NewList1 =:= [] ->
		{"", 0, 0};
	true ->
		[GuildInfo|_] = NewList1,
		{GuildInfo#r_king_fight.guild_name, GuildInfo#r_king_fight.guild_money, GuildInfo#r_king_fight.guild_id}
	end,
	 
	SignState#r_king_fight_signup{
						state = SignState#r_king_fight_signup.state,
						guild_nick_name = Nick_name,
						guild_money = Guild_money,
						guild_id = GuildId,								
						guild_list = NewList1
						}.

%% 获取我的公会报名财富 未报名为0
get_my_guild_money(GuildId, State) ->
	case lists:keyfind(GuildId, #r_king_fight.guild_id, State#r_king_fight_signup.guild_list) of
		false ->
			0;
		GuildInfo ->
			GuildInfo#r_king_fight.guild_money
	end.

%% 为我的公会报名
king_fight_sign_up(GuildId, GuildName,GuildMoney, UserId, State) ->
	OldMoney = get_my_guild_money(GuildId, State),
	if State#r_king_fight_signup.guild_money =:= 0 ->
		NeedMoney = ?FIRST_MONEY;
	true ->
		NeedMoney = State#r_king_fight_signup.guild_money - OldMoney + ?SIGN_UP_MONEY
	end,
	%?DEBUG("~p",[{GuildId,State#r_king_fight_signup.king_guild_id}]),
	case mod_guild:get_guild_user_info(GuildId, UserId) of
		[] ->
			{error, ?_LANG_CHAT_GUILD_MSG};
		MemberInfo ->				
			if GuildMoney < NeedMoney ->
				{error, ?_LANG_KING_WAR_NO_MONEY};
			State#r_king_fight_signup.state =:= 0 ->
				{error, ?_LANG_KING_WAR_ACTIVE_NOT_OPEN};
			GuildId =:= State#r_king_fight_signup.guild_id ->
				{error, ?_LANG_KING_WAR_FIRST_AUCTION};
			GuildId =:= State#r_king_fight_signup.king_guild_id ->
				{error, ?_LANG_KING_WAR_IS_CITY_MASTER};
			MemberInfo#ets_users_guilds.member_type =/= ?GUILD_JOB_PRESIDENT
					andalso MemberInfo#ets_users_guilds.member_type =/= ?GUILD_JOB_VICE_PERSIDENT->
				{error, ?_LANG_KING_WAR_NO_PRESIDENT};
			true ->
				mod_guild:change_guild_money(GuildId, NeedMoney, reduce),
				if OldMoney =:= 0 ->
					GuildInfo = #r_king_fight{guild_id = GuildId, guild_name = GuildName,guild_money = OldMoney + NeedMoney},
					List = [GuildInfo|State#r_king_fight_signup.guild_list],
					db_agent_duplicate:add_king_fight(GuildInfo),
	 				{ok, sort_guild_list(List, State), OldMoney + NeedMoney};
				true ->
					GuildInfo = #r_king_fight{guild_id = GuildId,guild_name = GuildName, guild_money = OldMoney + NeedMoney},
					List = lists:keyreplace(GuildId, #r_king_fight.guild_id, State#r_king_fight_signup.guild_list, GuildInfo),
	 				db_agent_duplicate:update_king_fight(GuildInfo),
					{ok, sort_guild_list(List, State), OldMoney + NeedMoney}
				end
			end
	end.

%% 返还不是第一的公会财富 关闭报名 
close_signup(State) ->
	F = fun(Info) ->
			mod_guild:change_guild_money(Info#r_king_fight.guild_id, Info#r_king_fight.guild_money, add)
		end,
	if length(State#r_king_fight_signup.guild_list) >= 1 ->
		[Info|List1] = State#r_king_fight_signup.guild_list,
		lists:foreach(F, List1),
		db_agent_duplicate:delete_king_fight(),
		%% 将第一名保存进数据库
		db_agent_duplicate:add_king_fight(Info#r_king_fight{state = 1}),
		WarInfo = lib_king_fight:get_king_war_info(),
		lib_king_fight:update_king_war_info(WarInfo#ets_king_war_info{attack_guild_id = Info#r_king_fight.guild_id,attack_guild_name = Info#r_king_fight.guild_name}),
		lib_chat:chat_sysmsg_roll([?GET_TRAN(?_LANG_CHAT_ACTIVE_KING_FIGHT_AUCTION, [Info#r_king_fight.guild_name])]);
	true ->
		skip
	end,
	State#r_king_fight_signup{state = 0,guild_id = 0,guild_money =0,guild_nick_name = "",guild_list =[]}.

