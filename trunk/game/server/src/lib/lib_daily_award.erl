%% Author: Administrator
%% Created: 2011-5-29
%% Description: TODO: Add description to lib_daily_award
-module(lib_daily_award).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([init_template_daily_award/0,
		 get_daily_award_template_list_and_send/3,
		 get_daily_award/2,check_daily_award_string/1,
		 update_daily_award_by_timer/2]).

-define(AWARD_OFFSET_TIME,5).	%奖励的容错时间，秒
-define(DAILY_AWARD_STRING,"000000000000000").%奖励字符串，15个0

%%
%% API Functions
%%
%%加载模板
init_template_daily_award() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_daily_award_template] ++ Info),	
				Items = tool:split_string_to_intlist(Record#ets_daily_award_template.item_template_ids),
				NewRecord = Record#ets_daily_award_template{item_template_ids = Items},
				ets:insert(?ETS_DAILY_AWARD_TEMPLATE, NewRecord)
		end,
	L = db_agent_template:get_daily_award_template(),
	lists:foreach(F, L),
	ok.

%% 奖励记录在数据库中的结构为 "000000000000000"目前15个标志位  标志位0/1，标志位为1表示已领取，标志位为0表示未领取
%% 领取时间根据t_daily_award_template表获取

check_daily_award_string(User) ->
	DailyAward1 = tool:to_list(User#ets_users.daily_award),
	DailyAward = if length(DailyAward1) =:= 15 ->
								DailyAward1;
							true -> 
								?DAILY_AWARD_STRING
						end,
	User#ets_users{daily_award = DailyAward}.

get_daily_award_list(User) ->
	AwardList = User#ets_users.daily_award.

%% 获取每日奖励
get_daily_award(User,Number) ->	
	{RU,Success} = case Number of 
		0 ->
			{NewUser,ItemList} = get_daily_award0(User,15,[]),			
			send_reward1(NewUser, ItemList,User#ets_users.daily_award);
		Num ->
			case get_daily_award1(User,Num) of
				{false,Msg} ->
					lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]),
					{User,0};
				{NewUser,ItemList} ->
					send_reward1(NewUser, ItemList,User#ets_users.daily_award)
			end
	end,
	
	{ok,Bin} = pt_20:write(?PP_PLAYER_DAILY_AWARD, [Number,Success]),
	lib_send:send_to_sid(RU#ets_users.other_data#user_other.pid_send,Bin),
	RU.

send_reward1(User,ItemList,AwardString) ->
	ItemNum = length(ItemList),
	NullCells = gen_server:call(User#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
	if 
		length(NullCells) >= ItemNum ->
			send_reward2(User,ItemList);
		true ->
			lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			R = User#ets_users{daily_award = AwardString},%如果没有发则还原AwardString
			{R,0}
	end.
	
send_reward2(User,ItemList) ->
	gen_server:cast(User#ets_users.other_data#user_other.pid_item, {'play_active', ItemList}),
	{User,1}.

get_daily_award0(User,0,ItemList) ->
	{User,ItemList};
get_daily_award0(User,Num,ItemList) ->
	case get_daily_award1(User,Num) of
		{false,Msg} ->
			get_daily_award0(User,Num-1,ItemList);
		{NewUser,[Item]} ->
			get_daily_award0(NewUser,Num-1,[Item|ItemList])
	end.

%判断是否已领
get_daily_award1(User,Num) ->
	case lists:nth(Num, User#ets_users.daily_award) of
		49 ->
			{false,"已领"};
		48 ->
			get_daily_award2(User,Num);
		E ->
			?DEBUG("get_daily_award error ~p",[E]),
			{false,""}
	end.

%判断时间
get_daily_award2(User,Num) ->
	case ets:lookup(?ETS_DAILY_AWARD_TEMPLATE, Num) of
		[] ->
			{false,""};
		[Info] ->
			if Info#ets_daily_award_template.need_seconds > User#ets_users.online_time + ?AWARD_OFFSET_TIME ->
					{false,"时间未到"};
				true ->
					get_daily_award3(User,Info,Num)
			end
	end.

%道具
get_daily_award3(User,Award,Num) -> 
	if
		length(Award#ets_daily_award_template.item_template_ids) > 0 ->
			NewDailyAward = nthreplace(User#ets_users.daily_award,Num,[],49),
			NewUser = User#ets_users{daily_award = NewDailyAward},
			{NewUser,Award#ets_daily_award_template.item_template_ids};
	    true ->
		    {false,""}
	end.

%领取成功
%% get_daily_award4(Award,State) ->
%% 	if Award#ets_daily_award_template.bind_copper > 0  
%% 		 orelse Award#ets_daily_award_template.copper > 0
%% 		 orelse Award#ets_daily_award_template.bind_yuan_bao > 0
%% 		 orelse Award#ets_daily_award_template.yuan_bao > 0 ->
%% 	   
%% 		   %%添加元宝日志
%% %% 		   lib_statistics:add_consume_yuanbao_log(State#ets_users.id, Award#ets_daily_award_template.yuan_bao,
%% %% 											   Award#ets_daily_award_template.bind_yuan_bao, 0, 
%% %% 											   ?CONSUME_YUANBAO_DAILY_AWARDS, misc_timer:now_seconds(), 0, 0,
%% %% 										       State#ets_users.level),
%% 		   NewState = lib_player:add_cash_and_send(State,
%% 								 Award#ets_daily_award_template.yuan_bao,
%% 								 Award#ets_daily_award_template.bind_yuan_bao,
%% 								 Award#ets_daily_award_template.copper,
%% 								 Award#ets_daily_award_template.bind_copper,{?GAIN_MONEY_DAILY_AWARD,Award#ets_daily_award_template.award_id,1});
%% 	   true ->
%% 		   NewState = State
%% 	end,
%% 
%% 	Time = misc_timer:now_seconds(),
%% 	case util:is_same_date(Time, NewState#ets_users.daily_award_date) of
%% 		true ->
%% 			NewAwardID = Award#ets_daily_award_template.award_id + 1;
%% 		_ ->
%% 			NewAwardID = 1
%% 	end,
%% 	case data_agent:get_daily_award_template(NewAwardID) of
%% 		[] ->
%% 			{ok,Bin} = pt_20:write(?PP_PLAYER_DAILY_AWARD_REMOVE, []),
%% 			lib_send:send_to_sid(NewState#ets_users.other_data#user_other.pid_send,Bin),
%% 			TMPAward = Award#ets_daily_award_template.award_id * 10 + 2,
%% 			NewState#ets_users{daily_award_date = Time, daily_award =TMPAward};
%% 		[NewAward] ->
%% 			{ok,Bin} = pt_20:write(?PP_PLAYER_DAILY_AWARD,[NewAwardID,
%% 														   NewAward#ets_daily_award_template.need_seconds]),
%% 			lib_send:send_to_sid(NewState#ets_users.other_data#user_other.pid_send,Bin),
%% 			TMPAward = NewAwardID * 10,
%% 			NewState#ets_users{daily_award_date = Time, daily_award = TMPAward}
%% 	end.

%%  定时器
update_daily_award_by_timer(State,Now) ->
	LastTime = State#ets_users.daily_award_date,
	NowTime = tool:floor(Now / 1000),
	case util:is_same_date(NowTime, LastTime) of
		true ->
			State;
		false ->
			State#ets_users{daily_award = ?DAILY_AWARD_STRING}
	end.
	
%% 根据当前人身上的状态,初始化可以领取的奖励
%% 跨日处理 尾数为2要处理，其他在领取时处理
get_daily_award_template_list_and_send(AwardString,LastDate,PidSend) ->
	Now = misc_timer:now_seconds(),
	{NewAwardString,NewLastDate} = 
				case util:is_same_date(Now,LastDate) of
					true ->
						{AwardString,LastDate};
					_ ->
						{?DAILY_AWARD_STRING,Now}
				end.

%%
%% Local Functions
%%
%%替换list中指定位置的数据
nthreplace([C|S],N,List,Star) when N > 1 ->
	nthreplace(S, N - 1, List ++ [C],Star);
nthreplace([_C|S],_N,List,Star) ->
	List ++ [Star|S].