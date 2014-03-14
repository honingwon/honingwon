%% Author: wangyuechun
%% Created: 2013-10-28
%% Description: TODO: Add description to lib_shenyou
-module(lib_shenyou).

%%
%% Include files
%%
-include("common.hrl").

%%
%% Exported Functions
%%
-export([start_shenyou/4,shenyou_complated/1,shenyou_interrupt/1,init_shenyou_template/0,shenyou_timeover/1,shenyou_login/1]).

%%
%% API Functions
%%
init_shenyou_template() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_shenyou_template] ++ Info),	
				Items = tool:split_string_to_intlist(Record#ets_shenyou_template.item_ids),
				NewRecord = Record#ets_shenyou_template{item_ids = Items},
				ets:insert(?ETS_SHENYOU_TEMPLATE, NewRecord)
		end,
	L = db_agent_template:get_shenyou_template(),
	lists:foreach(F, L),
	ok.


start_shenyou(User,SYID,Times,ExpPill) ->
	case check_duplicate(User,SYID,Times,ExpPill) of 
		{false,Msg} ->			
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]),
			User;
		{true,ShenyouTemp} ->
			start_shenyou1(User,ShenyouTemp,Times,ExpPill);
		E ->
			?DEBUG("error:~p",[E]),
			User
	end.

check_duplicate(User,ShenyouID,Times,ExpPill) ->
	case get_shenyou_template(ShenyouID) of
		[] ->
			{false,?_LANG_SHENYOU_CAN_NOT};
		ShenyouTemp ->			
			case ets:lookup(?ETS_DUPLICATE_TEMPLATE, ShenyouTemp#ets_shenyou_template.duplicate_id) of		
				[] ->
					{false,?_LANG_SHENYOU_NO_DUPLICATE};
				[DuplicateTemp] ->
					LeftTimes = DuplicateTemp#ets_duplicate_template.day_times - Times +1,
					check_state(User,ShenyouTemp,LeftTimes,Times,ExpPill)
			end
	end.

check_state(User,ShenyouTemp,LeftTimes,Times,ExpPill) ->
	Now = misc_timer:now_seconds(),
	Level = ShenyouTemp#ets_shenyou_template.level,
	Fight = ShenyouTemp#ets_shenyou_template.fight,	
	NeedCopper = tool:to_integer(ShenyouTemp#ets_shenyou_template.cost_copper * Times),
	case lib_duplicate:check_user_duplicate_times(User#ets_users.id, ShenyouTemp#ets_shenyou_template.duplicate_id, LeftTimes) of
		ok ->
			if 	User#ets_users.shenyou_time > Now ->
				{false,?GET_TRAN(?_LANG_SHENYOU_LESS_TIME,[User#ets_users.shenyou_time - Now])};
			User#ets_users.level < Level ->
				{false,?GET_TRAN(?_LANG_SHENYOU_LESS_LEVEL,[Level])};
			Times > 3 ->
				{false,?_LANG_SHENYOU_LESS_TIMES};
			User#ets_users.fight < Fight ->
				{false,?GET_TRAN(?_LANG_SHENYOU_LESS_FIGHT,[Fight])};
			User#ets_users.copper + User#ets_users.bind_copper < NeedCopper ->
				{false,?GET_TRAN(?_LANG_SHENYOU_LESS_COPPER,[NeedCopper])};
			ExpPill =/= 0 ->
				case gen_server:call(User#ets_users.other_data#user_other.pid_item,{'check_item',ExpPill}) of
					true ->
						{true,ShenyouTemp};
					false ->
						{false,?_LANG_SHENYOU_LESS_EXP_PILL}
				end;
			true ->
				{true,ShenyouTemp}
			end;
		error ->
			{false,?_LANG_SHENYOU_LESS_TIMES}
	end.

start_shenyou1(User,Temp,Times,ExpPill) ->
	TotalTime = tool:ceil(Temp#ets_shenyou_template.cost_time * Times),
	NextTime = TotalTime + misc_timer:now_seconds(),
	NeedCopper = tool:ceil(Temp#ets_shenyou_template.cost_copper * Times),
	NewUser1 = User#ets_users{shenyou_id = Temp#ets_shenyou_template.id,
												shenyou_time = NextTime,
												shenyou_exp_pill = ExpPill,
												shenyou_times = Times
												},
	NewUser2 = lib_player:reduce_cash_and_send(NewUser1, 0, 0, 0, NeedCopper),
	lib_duplicate:add_duplicate_times(NewUser2#ets_users.id, Temp#ets_shenyou_template.duplicate_id, Times),
	OtherData = NewUser2#ets_users.other_data,
	gen_server:cast(OtherData#user_other.pid, {'finish_active',NewUser2, ?DUPLICATEACTIVE,Temp#ets_shenyou_template.duplicate_id}),
	gen_server:call(OtherData#user_other.pid_item,{'reduce_item_to_users',ExpPill,?CATE_CURREXP}),
	erlang:send_after(TotalTime * 1000, OtherData#user_other.pid, {'shenyou_time_over'}),
	{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU, [Temp#ets_shenyou_template.id,Times,ExpPill,NextTime]),
	lib_send:send_to_sid(NewUser2#ets_users.other_data#user_other.pid_send, Data),
	NewUser2.	

shenyou_complated(User) ->
	if User#ets_users.shenyou_id =:= 0 ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_SHENYOU_NOT_ACTIVE]),
			{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU_COMPLATE, [0]),
			lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Data),
			User;
		true ->
			case  get_shenyou_template(User#ets_users.shenyou_id) of 
				[] ->
					User;
				Temp ->
					case shenyou_complated1(User,Temp) of
						{false,Msg} ->
							lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]),
							User;
						{true,User1} ->
							{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU_COMPLATE, [1]),
							lib_send:send_to_sid(User1#ets_users.other_data#user_other.pid_send, Data),
							send_shenyou_award(User1,Temp)
					end
			end
	end.

shenyou_complated1(User,Temp) ->
	CostYuanbao = tool:ceil(Temp#ets_shenyou_template.cost_yuanbao * User#ets_users.shenyou_times),
	Now = misc_timer:now_seconds(),
	if 
		User#ets_users.vip_id band ?VIP_BSL_HALFYEAR =/= 0 ->
			{true,User};
		User#ets_users.shenyou_time < Now ->
			{false,?_LANG_SHENYOU_TIME_OVER};
		User#ets_users.yuan_bao < CostYuanbao ->
			{false,?GET_TRAN(?_LANG_SHENYOU_LESS_YUANBAO,[CostYuanbao])};
		true ->
			User1 = lib_player:reduce_cash_and_send(User, CostYuanbao, 0, 0, 0),
			{true,User1}
	end.

shenyou_timeover(User) ->
	if User#ets_users.shenyou_id =:= 0 ->
			User;
		true ->
			case  get_shenyou_template(User#ets_users.shenyou_id) of 
				[] ->
					User;
				Temp ->
					{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU_COMPLATE, [1]),
					lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Data),
					send_shenyou_award(User,Temp)
			end
	end.

shenyou_login(User) ->
	Now = misc_timer:now_seconds(),
	if User#ets_users.shenyou_id =:= 0 ->
			User;
		User#ets_users.shenyou_time =< Now ->
			case  get_shenyou_template(User#ets_users.shenyou_id) of 
				[] ->
					User;
				Temp ->
					send_shenyou_award(User,Temp)
			end;
		true ->
			{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU, [User#ets_users.shenyou_id,User#ets_users.shenyou_times,User#ets_users.shenyou_exp_pill,User#ets_users.shenyou_time]),
				lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Data),
				LeftSecond = User#ets_users.shenyou_time - Now,
				erlang:send_after(LeftSecond * 1000, User#ets_users.other_data#user_other.pid, {'shenyou_time_over'}),
				User
	end.

shenyou_interrupt(User) ->
	case get_shenyou_template(User#ets_users.shenyou_id) of
		[] ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_SHENYOU_NOT_ACTIVE]),
			{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU_INTERRUPT, [0]),
			lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Data),
			User;
		Temp ->
			Times = User#ets_users.shenyou_times,
			Time1 = misc_timer:now_seconds() + Temp#ets_shenyou_template.cost_time * Times - User#ets_users.shenyou_time,
			Time = tool:ceil(Time1/Times),
			{ok,Data} = pt_20:write(?PP_DUPLICATE_SHENYOU_INTERRUPT, [1]),
			lib_send:send_to_sid(User#ets_users.other_data#user_other.pid_send, Data),
			case get_shenyou_award(User#ets_users.shenyou_id,Time) of
				{true,Temp1} ->
					send_shenyou_award(User,Temp1);
				{false} ->
					User#ets_users{shenyou_id = 0,
									shenyou_time = misc_timer:now_seconds(),
									shenyou_times = 0,
									shenyou_exp_pill = 0
									};
				E ->
					?DEBUG("error:~p",[E]),
					User
			end
	end.



get_shenyou_award(ID,Time) ->
	Temp = get_shenyou_template(ID),
	if Temp =:= [] ->
			{false};
		Temp#ets_shenyou_template.cost_time =< Time ->
			{true,Temp};
		true ->
			get_shenyou_award(ID-1,Time)
	end.
	
send_shenyou_award(User,Temp) ->
	Times = User#ets_users.shenyou_times,
	AddCopper = Temp#ets_shenyou_template.copper * Times,
	NewUser1 = lib_player:add_cash_and_send(User, 0, 0, 0, AddCopper,{?GAIN_MONEY_DUPLICATE_AWARD,Temp#ets_shenyou_template.duplicate_id,1}),

	ExpRate1 = 
		if	User#ets_users.shenyou_exp_pill =:= 2 ->
				1.0;
			User#ets_users.shenyou_exp_pill =:= 206056 ->
				0.5;
			true ->
				0.0
		end,
	Vip_id = User#ets_users.vip_id,
	ExpRate2 = 
		if Vip_id  band ?VIP_BSL_HALFYEAR =/= 0 orelse Vip_id  band ?VIP_BSL_GM =/= 0 ->
				0.3;
			Vip_id  band ?VIP_BSL_MONTH =/= 0 orelse Vip_id  band ?VIP_BSL_NEWPLAYERLEADER =/= 0 orelse Vip_id  band ?VIP_BSL_ONEHOUR =/= 0->
				0.2;
			Vip_id  band ?VIP_BSL_WEEK =/= 0 orelse Vip_id  band ?VIP_BSL_DAY =/= 0->
				0.1;
			true ->
				0.0
	end,
	NewExpRate = 1 + ExpRate1 + ExpRate2,
	AddExp = util:ceil(Temp#ets_shenyou_template.exp * NewExpRate * Times),
	AddLifeExp = Temp#ets_shenyou_template.life_exp * Times,
	NewUser2 =  lib_player:add_currexp_and_liftexp(AddExp, AddLifeExp, 0, NewUser1),
	
	gen_server:cast(NewUser2#ets_users.other_data#user_other.pid_item, {'shenyou_award', Temp#ets_shenyou_template.item_ids, NewUser2#ets_users.nick_name,NewUser2#ets_users.shenyou_times}),
	NewUser2#ets_users{shenyou_id = 0,
									shenyou_time = misc_timer:now_seconds(),
									shenyou_times = 0,
									shenyou_exp_pill = 0
									}.

%%
%% Local Functions
%%

get_shenyou_template(ID) ->
	case ets:lookup(?ETS_SHENYOU_TEMPLATE, ID) of
		[Temp] ->
			Temp;
		[] ->
			[]
	end.