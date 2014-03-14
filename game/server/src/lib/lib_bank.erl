%% Author: wangdahai
%% Created: 2014-1-17
%% Description: TODO: Add description to lib_bank
-module(lib_bank).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-define(BANK_AWARD_LEVEL,[{40,0.3},{45,0.4},{50,0.4},{55,0.5},{60,0.5},{65,0.6},
							{70,0.6},{75,0.7},{80,0.7}]).%奖励等级分布
-define(BANK_TYPE_MONYE,[500,1000,3000,5000,10000]).%银行投资类型
-define(MAX_BANK_TYPE,5).
-define(BANK_MONTH_TYPE, 0).%30天理财
-define(BANK_MONTH_MONYE, 1500).%30天理财扣费
-define(MAX_BANK_BUY_MONEY, 10000).%投资最大可购买金额
-export([
			get_user_bank_info/1,
			buy_bank/2,
			get_bank_award/2
		]).

%%
%% API Functions
%%

%%加载玩家银行投资信息
get_user_bank_info(UserID) ->
	F = fun(Info, List) ->
			
			Record = list_to_tuple([ets_user_bank] ++ Info),
			[Record|List]
		end,
	BankList =
	case db_agent_user:get_user_bank(UserID) of
		[] ->
			[];
		L when is_list(L) ->
			lists:foldl(F, [], L);
		_ ->
			[]
	end,
	BankList.

buy_bank(Type, UserInfo) ->
	BankList = UserInfo#ets_users.other_data#user_other.bank_list,
	case lists:keyfind(Type, #ets_user_bank.type, BankList) of 
		false ->
			if	Type =:= ?BANK_MONTH_TYPE ->
					check_buy_bank1(Type, UserInfo#ets_users.yuan_bao, UserInfo#ets_users.id, ?BANK_MONTH_MONYE,?BANK_MONTH_MONYE);
				Type > ?BANK_MONTH_TYPE andalso Type =< ?MAX_BANK_TYPE ->
					NeedYuanbao = lists:nth(Type, ?BANK_TYPE_MONYE),
					case check_buy_money(BankList, NeedYuanbao) of
						true ->
							check_buy_bank1(Type, UserInfo#ets_users.yuan_bao, UserInfo#ets_users.id, NeedYuanbao, NeedYuanbao * 0.3);
						_ ->
							ErrStr = ?GET_TRAN(?_LANG_BANK_ERROR_BUY_LIMIT,[?MAX_BANK_BUY_MONEY]),
							{error,ErrStr}
					end;
				true ->
					{error,?_LANG_ER_WRONG_VALUE}
			end;
		_ ->
			{error,?_LANG_BANK_ERROR_EXISTS}
	end.

get_bank_award(Type, UserInfo) ->
	BankList = UserInfo#ets_users.other_data#user_other.bank_list,
	case lists:keyfind(Type, #ets_user_bank.type, BankList) of 
		false ->
			{error,?_LANG_BANK_ERROR_UNEXIST};
		Info ->
			if	Type =:= ?BANK_MONTH_TYPE ->					
					DiffDay = util:get_diff_days(Info#ets_user_bank.add_time, misc_timer:now_seconds()) + 1,
					if	DiffDay > Info#ets_user_bank.state andalso DiffDay < 31 ->
							db_agent_user:update_user_bank_state(UserInfo#ets_users.id,Type,DiffDay),
							AwardMoney = (DiffDay - Info#ets_user_bank.state) * Info#ets_user_bank.money * 0.7 * 0.1,
							NewInfo = Info#ets_user_bank{state = DiffDay},
							{ok,NewInfo,AwardMoney};
						true ->
							{error,?_LANG_BANK_ERROR_AWARD_IS_RECEIVED}
					end;
				true ->
					if	UserInfo#ets_users.level > Info#ets_user_bank.state ->
							AwardMoney = get_bank_award1(Info,UserInfo#ets_users.level),
							if	AwardMoney > 0 ->
									State = UserInfo#ets_users.level div 5 * 5,
									db_agent_user:update_user_bank_state(UserInfo#ets_users.id,Type,State),
									NewInfo = Info#ets_user_bank{state = State},
									{ok,NewInfo,AwardMoney};
								true ->
									{error,?_LANG_BANK_ERROR_AWARD_IS_RECEIVED}
							end;
						true ->
							{error,?_LANG_BANK_ERROR_AWARD_IS_RECEIVED}
					end
			end
	end.

%%
%% Local Functions
%%

get_bank_award1(BankInfo,Level) ->
	F = fun({Le, V}, AwardMoney) ->
			if	Le > BankInfo#ets_user_bank.state andalso Le =< Level ->
					AwardMoney + BankInfo#ets_user_bank.money * V;
				true ->
					AwardMoney
			end
		end,
	lists:foldl(F, 0, ?BANK_AWARD_LEVEL).


check_buy_money(List,Buy) ->
	F = fun(Info,Money) ->
			if	Info#ets_user_bank.type =:= ?BANK_MONTH_TYPE ->
					Money;
				true ->
					Money + Info#ets_user_bank.money
			end			
		end,	
	Count = lists:foldl(F, 0, List)	+ Buy,
	if	Count > ?MAX_BANK_BUY_MONEY ->
			false;
		true ->
			true
	end.

check_buy_bank1(Type, Yuanbao, UserId, NeedYuanbao,BackMoney) ->			 
			if	Yuanbao < NeedYuanbao ->
					ErrStr = ?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[NeedYuanbao]),
					{error,ErrStr};
				true ->
					Record = #ets_user_bank{user_id = UserId,
											type = Type,
											money = NeedYuanbao,
											state = 0,
											add_time = misc_timer:now_seconds()},					
					db_agent_user:add_user_bank(Record),
					{ok,Record,NeedYuanbao,BackMoney}
			end.
		
