%% Author: wangdahai
%% Created: 2013-3-21
%% Description: TODO: Add description to lib_welfare
-module(lib_welfare).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
			init_welfare_template/0,
			init_welfare_exp_template/0,
			get_user_welfare_info/1,
			receive_welfare/2,
			reset_login_day/4,
			reset_login_day/1,
			%update_welfare_duplicate_num/3,
			exchange_exp/2
			%update_daily_login_by_timer/3
			]).

%%
%% API Functions
%%
%% 初始化福利奖励信息
init_welfare_template() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_welfare_template] ++ Info),
				ets:insert(?ETS_WELFARE_TEMPLATE, Record)
		end,
	case db_agent_template:get_welfare_template() of
		[] -> 
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

%% 初始化经验福利兑换模版
init_welfare_exp_template() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_welfare_exp_template] ++ Info),
				ets:insert(?ETS_WELFARE_EXP_TEMPLATE, Record)
		end,
	case db_agent_template:get_welfare_exp_template() of
		[] -> 
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

%% 数据库中获取玩家福利信息
get_user_welfare_info({UserID,LastOnlineTime,Level,Vip_id}) ->
	Welfare = case db_agent_user:get_user_welfare(UserID) of
			[] ->
				#ets_user_welfare{};
			Info ->
				list_to_tuple([ets_user_welfare] ++ Info)				
	end,
	Now = misc_timer:now_seconds(),
	OffLineTime = Welfare#ets_user_welfare.off_line_times + Now - LastOnlineTime,
	if
		OffLineTime >= ?MAX_OFF_LINE_TIME ->
			Welfare1 = Welfare#ets_user_welfare{off_line_times = ?MAX_OFF_LINE_TIME };
		true ->
			Welfare1 = Welfare#ets_user_welfare{off_line_times = OffLineTime}
	end,
	Welfare2 = reset_login_day(Welfare1, Now, Level,Vip_id),
	db_agent_user:update_user_welfare(UserID,Welfare2),
	Welfare2.

%% update_daily_login_by_timer(State, Time, Now) ->
%% 	LastTime = tool:floor(Time/1000) ,
%% 	NowTime = tool:floor(Now / 1000),
%% 	case util:is_same_date(NowTime, LastTime) of
%% 		true ->
%% 			State;
%% 		false ->
%% 			?DEBUG("update_daily_login_by_timer:~p",[{LastTime, NowTime}]),
%% 			Welfare = State#ets_users.other_data#user_other.welfare_info,
%% 			if Welfare#ets_user_welfare.login_day >= 30 ->
%% 					NewWelfare = Welfare#ets_user_welfare{login_day = 1};
%% 				true ->
%% 					NewWelfare = Welfare#ets_user_welfare{login_day = Welfare#ets_user_welfare.login_day + 1}
%% 			end,
%% 			db_agent_user:update_user_welfare(State#ets_users.id,NewWelfare),
%% 			NewOther = State#ets_users.other_data#user_other{welfare_info = NewWelfare},
%% 			State#ets_users{other_data = NewOther}
%% 	end.


%% 更新福利中的副本剩余次数
%% update_welfare_duplicate_num(PlayerStatus,Num, Num1) ->
%% 	Welfare = PlayerStatus#ets_users.other_data#user_other.welfare_info,
%% 	NewNum = if 
%% 				Num + Welfare#ets_user_welfare.duplicate_num > ?MAX_DUPLICATE_NOT_ENTER_NUM ->
%% 					?MAX_DUPLICATE_NOT_ENTER_NUM;
%% 				true ->
%% 					Num + Welfare#ets_user_welfare.duplicate_num
%% 			end,
%% 	NewNum1 = if 
%% 				Num1 + Welfare#ets_user_welfare.multi_duplicate_num > ?MAX_DUPLICATE_NOT_ENTER_NUM ->
%% 					?MAX_DUPLICATE_NOT_ENTER_NUM;
%% 				true ->
%% 					Num1 + Welfare#ets_user_welfare.multi_duplicate_num
%% 			end,
%% 	NewWelfare = Welfare#ets_user_welfare{duplicate_num = NewNum, multi_duplicate_num = NewNum1},
%% 	db_agent_user:update_user_welfare(PlayerStatus#ets_users.id,NewWelfare),
%% 	NewOther = PlayerStatus#ets_users.other_data#user_other{welfare_info = NewWelfare},
%% 	NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther},
%% 	pp_player:handle(?PP_PLAYER_WELFARE_UPDATE, NewPlayerStatus,[]),
%% 	NewPlayerStatus.

%%兑换经验
exchange_exp(PlayerStatus,{Type,ExchangeType1,Num}) ->
	Welfare1 = PlayerStatus#ets_users.other_data#user_other.welfare_info,
	Welfare = reset_login_day(Welfare1, misc_timer:now_seconds(), PlayerStatus#ets_users.level,PlayerStatus#ets_users.vip_id),
	Point = case Type of
				1 ->
					Num1 = Welfare#ets_user_welfare.duplicate_num,
					ExchangeType = 1,
					Num1;
				2 ->
					Num1 = Welfare#ets_user_welfare.multi_duplicate_num,
					ExchangeType = 1,
					Num1;
				3 ->
					Num1 = Num,
					ExchangeType = ExchangeType1,
					Welfare#ets_user_welfare.off_line_times div 3600;
				_ ->
					Num1 = 0,
					ExchangeType = 1,
					0
			end,
	if
		Num1 =:= 0 ->
			 PlayerStatus;
		Point < Num1 ->
			PlayerStatus;
		true ->
			exchange_exp1(PlayerStatus,Type,ExchangeType,Num1)
	end.

exchange_exp1(PlayerStatus,Type,ExchangeType,Num) ->
	case data_agent:welfare_exp_template_get(Type) of
		[] ->
			PlayerStatus;
		Temp ->
			exchange_exp2(PlayerStatus,Type,ExchangeType,Num,Temp,PlayerStatus#ets_users.other_data#user_other.welfare_info)
	end.
exchange_exp2(PlayerStatus,Type,ExchangeType,Num,Temp,Welfare) ->
	case ExchangeType of
		1 ->
			exchange_exp3({0,0,Temp#ets_welfare_exp_template.award_exp * Num},
				PlayerStatus,Type,ExchangeType,Num,Welfare);
		2 ->
			exchange_exp3({Temp#ets_welfare_exp_template.copper * Num,0,Temp#ets_welfare_exp_template.copper_award_exp * Num},
				PlayerStatus,Type,ExchangeType,Num,Welfare);
		3 ->
			exchange_exp3({0,Temp#ets_welfare_exp_template.yuanbao * Num,Temp#ets_welfare_exp_template.yuanbao_award_exp * Num},
				PlayerStatus,Type,ExchangeType,Num,Welfare);
		_ ->
			 PlayerStatus
	end.
exchange_exp3({Copper,Yuanbao,AwardExp},PlayerStatus1,Type,ExchangeType,Num,Welfare) ->
	case lib_player:check_cash(PlayerStatus1, Yuanbao, Copper)of
		true ->
			%扣钱
			PlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus1, Yuanbao, 0, 0, Copper,{?CONSUME_YUANBAO_WELFARE_EXCHANGE,0,Num}),
			case Type of
				1 ->
					NewWelfare = Welfare#ets_user_welfare{duplicate_num = Welfare#ets_user_welfare.duplicate_num - Num},
					exchange_exp4(PlayerStatus, AwardExp, NewWelfare, Type,ExchangeType, NewWelfare#ets_user_welfare.duplicate_num);
				2 ->
					NewWelfare = Welfare#ets_user_welfare{multi_duplicate_num = Welfare#ets_user_welfare.multi_duplicate_num - Num},
					exchange_exp4(PlayerStatus, AwardExp, NewWelfare, Type, ExchangeType,NewWelfare#ets_user_welfare.multi_duplicate_num);
				3 ->
					NewWelfare = Welfare#ets_user_welfare{off_line_times = Welfare#ets_user_welfare.off_line_times - Num * 3600},
					exchange_exp4(PlayerStatus, AwardExp, NewWelfare, Type, ExchangeType,NewWelfare#ets_user_welfare.off_line_times)
			end;
		_ ->
			PlayerStatus1
	end.
exchange_exp4(PlayerStatus, AwardExp, Welfare, Type, ExchangeType, Num) ->
	NewStatus = lib_player:add_exp(PlayerStatus, AwardExp),
	NewOther = NewStatus#ets_users.other_data#user_other{welfare_info = Welfare},
	db_agent_user:update_user_welfare(PlayerStatus#ets_users.id,Welfare),
	{ok, BinData} = pt_20:write(?PP_PLAYER_WELFARE_EXP_EXCHANGE, [Type,ExchangeType, Num]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	NewStatus#ets_users{other_data = NewOther}.

receive_welfare(PlayerStatus,Type) ->
	{Res, NewWelfare} = receive_welfare1(PlayerStatus,Type),
	{ok,BinData} = pt_20:write(?PP_PLAYER_WELFARE_RECEIVE, [Res,Type]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	db_agent_user:update_user_welfare(PlayerStatus#ets_users.id,NewWelfare),
	NewOther = PlayerStatus#ets_users.other_data#user_other{welfare_info = NewWelfare},
	PlayerStatus#ets_users{other_data = NewOther}.

reset_login_day(PlayerStatus) ->
	Welfare = lib_welfare:reset_login_day(PlayerStatus#ets_users.other_data#user_other.welfare_info, misc_timer:now_seconds(),
											PlayerStatus#ets_users.level,PlayerStatus#ets_users.vip_id),
	NewOtherData = PlayerStatus#ets_users.other_data#user_other{welfare_info = Welfare},
	PlayerStatus#ets_users{other_data = NewOtherData}.


%%
%% Local Functions
%%
reset_login_day(Welfare1, Now, Level, Vip_id) ->
	TDays = util:get_diff_days(Welfare1#ets_user_welfare.reset_time,Now),
	IsVip = Vip_id  band ?VIP_BSL_HALFYEAR =/= 0,
	if
		TDays =:= 0 ->
			Welfare2 = Welfare1;
		(TDays =:= 1 orelse (IsVip andalso TDays < 4)) ->
			if	Welfare1#ets_user_welfare.login_day < 30 ->
					Welfare2 = Welfare1#ets_user_welfare{login_day = Welfare1#ets_user_welfare.login_day + 1, reset_time = Now};
				true ->
					Welfare2 = Welfare1#ets_user_welfare{reset_time = Now}
			end;
		true ->
			Welfare2 = Welfare1#ets_user_welfare{login_day = 1, reset_time = Now}
	end,
	Welfare3 = 	
	case lib_duplicate:refresh_free_duplicate_num(TDays,Now,Level) of
		false ->
			Welfare2;
		{Num, Num1} ->
			NewNum = if 
				Num + Welfare2#ets_user_welfare.duplicate_num > ?MAX_DUPLICATE_NOT_ENTER_NUM ->
					?MAX_DUPLICATE_NOT_ENTER_NUM;
				true ->
					Num + Welfare2#ets_user_welfare.duplicate_num
			end,
			NewNum1 = if 
				Num1 + Welfare2#ets_user_welfare.multi_duplicate_num > ?MAX_DUPLICATE_NOT_ENTER_NUM ->
					?MAX_DUPLICATE_NOT_ENTER_NUM;
				true ->
					Num1 + Welfare2#ets_user_welfare.multi_duplicate_num
			end,
			Welfare2#ets_user_welfare{duplicate_num = NewNum, multi_duplicate_num = NewNum1}
	end,
	if TDays > 0 ->
			db_agent_user:update_user_welfare(Welfare3#ets_user_welfare.user_id,Welfare3);
	   true -> skip
	end,
	Welfare3.

receive_welfare1(PlayerStatus,Type) ->
	Welfare = PlayerStatus#ets_users.other_data#user_other.welfare_info,
	Now = misc_timer:now_seconds(),
	case Type of
		0 ->
			ReceiveTime = Welfare#ets_user_welfare.receive_time;
		1 ->
			ReceiveTime = Welfare#ets_user_welfare.vip_receive_time;
		_ ->
			ReceiveTime = Now
	end,
	
	case util:is_same_date(Now, ReceiveTime)of
		false ->
			Welfare1 = reset_login_day(Welfare, Now, PlayerStatus#ets_users.level,PlayerStatus#ets_users.vip_id),
			receive_welfare2(PlayerStatus, Welfare1, Type);
		true ->
			{0,Welfare}
	end.

receive_welfare2(PlayerStatus, Welfare, Type) ->
	case data_agent:welfare_template_get(Welfare#ets_user_welfare.login_day) of
		[] ->
			{0,Welfare};
		Temp ->
			if
				Type =:= 0 ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'add_item',Temp#ets_welfare_template.award_item_id,
							Temp#ets_welfare_template.award_num,1,?ITEM_PICK_WELFARE_AWARD}),
					{1,Welfare#ets_user_welfare{receive_time = misc_timer:now_seconds()}};
				Type =:= 1 andalso PlayerStatus#ets_users.money > 0 ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'add_item',Temp#ets_welfare_template.vip_award_item_id,
											Temp#ets_welfare_template.vip_award_num,1,?ITEM_PICK_WELFARE_AWARD}),
					{1,Welfare#ets_user_welfare{vip_receive_time = misc_timer:now_seconds()}};
				true ->
					{0,Welfare}
			end	
	end.


