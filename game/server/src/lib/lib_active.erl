%% Author: liaoxiaobo
%% Created: 2013-2-5
%% Description: TODO: Add description to lib_active
-module(lib_active).

%%
%% Include files
%%

-include("common.hrl").


-define(DIC_USERS_ACTIVE, dic_users_active). %% 玩家活跃度字典


-define(ACTIVE_TIME_TICK, 24 * 60 * 60 * 1000).

%%
%% Exported Functions
%%
-export([
		 init_template/0,
		 init_user_active/1,
		 get_active_info/0,
		 finish_active/3,
		 get_active_state/1,
		 get_active/1,
		 get_active_1/1,
		 get_reward/1
		 ]).

%%
%% API Functions
%%

%% ------------------------初始化模板数据 start--------------------------

init_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_active_template] ++ (Info)),
				  TastId = tool:split_string_to_intlist(Record#ets_active_template.task_id),
				  NewRecord = Record#ets_active_template{task_id = TastId},
                  ets:insert(?ETS_ACTIVE_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_active_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	init_active_rewards_template(),
	ok.


init_active_rewards_template() ->
	F = fun(Info) ->
				  Record = list_to_tuple([ets_active_rewards_template] ++ (Info)),
				  Items = tool:split_string_to_intlist(Record#ets_active_rewards_template.items),
				  NewRecord = Record#ets_active_rewards_template{items = Items},
                  ets:insert(?ETS_ACTIVE_REWARDS_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_active_rewards_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.



%% ------------------------初始化模板数据 end--------------------------

update_active_dic(Info)->
	put(?DIC_USERS_ACTIVE,Info).


get_active_info() ->
	case get(?DIC_USERS_ACTIVE) of 
		undefined ->
			[];
		Info ->
			Info
	end.


%% update_active_time(Id,Time,AddActive) ->
%% 	Info = get_active_info(),
%% 	NewTime = lists:keyreplace(Id, 1, Info#ets_users_active.times, {Id,Time}),
%% 	NewInfo = case AddActive > 0 of
%% 				true ->
%% 		  			Info#ets_users_active{ times = NewTime,day_active = Info#ets_users_active.day_active + AddActive};
%% 				_ ->
%% 					Info#ets_users_active{ times = NewTime}
%% 			  end,
%% 	update_active_dic(NewInfo),
%% 	save_user_active_data().


%% 初始化用户活动数据
init_user_active(UserId) ->
	Info = db_agent_user:get_user_active(UserId),
	InitTimes = init_active_times(),
	InitRState = init_active_rewards_state(),
	Now = misc_timer:now_seconds(),
	NewInfo = if 
				  Info =:= [] ->
					  Record = #ets_users_active{ user_id = UserId,times = InitTimes,date = Now,rewards = InitRState},
					  StrTimes = tool:intlist_to_string(Record#ets_users_active.times),
					  StrRewards = tool:intlist_to_string(Record#ets_users_active.rewards),
					  db_agent_user:insert_user_active(Record#ets_users_active.user_id,
											 Record#ets_users_active.day_active,
											 StrRewards,
											 Record#ets_users_active.date,
											 StrTimes),
					  Record;
				  true ->
					  Record = list_to_tuple([ets_users_active] ++ (Info)),
					  case util:is_same_date(Record#ets_users_active.date,Now) of
						  true ->
							  Times = tool:split_string_to_intlist(Record#ets_users_active.times),
							  Rewards = tool:split_string_to_intlist(Record#ets_users_active.rewards),
							  Record#ets_users_active{times =Times,rewards = Rewards};
						  _ ->
							  Times = InitTimes,
							  Record#ets_users_active{times =Times,date = Now,rewards = InitRState,day_active=0}
					  end							  
					 
			  end,
	update_active_dic(NewInfo).

%% 重置数据
reset_user_data(OldInfo) ->
	Now = misc_timer:now_seconds(),
	case util:is_same_date(OldInfo#ets_users_active.date,Now) of
		true ->
			OldInfo;
		_ ->
			Times = init_active_times(),
			Rewards = init_active_rewards_state(),
			OldInfo#ets_users_active{day_active = 0,rewards = Rewards,date = Now,times =Times }
	end.

%% 保存用户活动数据
save_user_active_data() ->
	Info = get_active_info(),
	if
		Info =/= []  ->
			Times = tool:intlist_to_string(Info#ets_users_active.times),
			Rewards = tool:intlist_to_string(Info#ets_users_active.rewards),
			db_agent_user:update_user_active(Info#ets_users_active.user_id,
											 Info#ets_users_active.day_active,
											 Rewards,
											 Info#ets_users_active.date,
											 Times
											 );
		true ->
			skip
	end.


%% 完成任务
finish_active(PlayerStatus,Type,Id) ->
	Info = data_agent:get_active_from_template(Type,Id),
	if
		Info =/= [] ->
			add_active(PlayerStatus,Info);
		true ->
			skip
	end.
	
%% 活动度增加
add_active(PlayerStatus,Info) ->
	if
		PlayerStatus#ets_users.level >= Info#ets_active_template.min_level  ->
			case get_active_info() of
				[] ->
					ok;
				ActiveInfo ->
					NewActiveInfo = reset_user_data(ActiveInfo),
					{_,Time} = lists:keyfind(Info#ets_active_template.id, 1, NewActiveInfo#ets_users_active.times),
					CheckTime = Time + 1,
					{NeedUpateTime,NeddUpdateActive} = if 
														   CheckTime =:= Info#ets_active_template.active_acount  ->
															   {1,1};
														   CheckTime > Info#ets_active_template.active_acount ->
															   {0,0};
														   true ->
															   {1,0}
													   end,
					if
						NeedUpateTime =:= 1 ->
							NewTime = lists:keyreplace(Info#ets_active_template.id, 
													   1, 
													   NewActiveInfo#ets_users_active.times, 
													   {Info#ets_active_template.id,CheckTime}),
							if 
								NeddUpdateActive =:= 1 ->
									DayActive = NewActiveInfo#ets_users_active.day_active + Info#ets_active_template.active;
								true ->
									DayActive = NewActiveInfo#ets_users_active.day_active
							end,
							NewActiveInfo1 = NewActiveInfo#ets_users_active{ times = NewTime,day_active = DayActive},
							update_active_dic(NewActiveInfo1),
							
							get_active_1(PlayerStatus),
							
							save_user_active_data();
						true ->
							skip
					end
			end;
		true ->
			skip
	end.




%% 获取活动度信息
get_active(PlayerStatus) ->
	case get_active_info() of
		[] ->
			ok;
		Info ->
			NewInfo = reset_user_data(Info),
			{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_INFO,[NewInfo]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin)
	end.

get_active_1(PlayerStatus) ->
	case get_active_info() of
		[] ->
			ok;
		Info ->
			NewInfo = reset_user_data(Info),
			RewardList = ets:tab2list(?ETS_ACTIVE_REWARDS_TEMPLATE),
			F = fun(Info,{T,V,Reward}) ->
						case lists:keyfind(Info#ets_active_rewards_template.id,1, Reward) of
							{_,0} ->
								if 
									V >= Info#ets_active_rewards_template.need_active ->
										{1,V,Reward};
									true ->
										{T,V,Reward}
								end;
							_ ->
								{T,V,Reward}
						end
				end,
			{T,_,_} = lists:foldl(F, {0,NewInfo#ets_users_active.day_active,NewInfo#ets_users_active.rewards}, RewardList),
			
			{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_NUM,[NewInfo#ets_users_active.day_active,T]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin)
	end.
	
%% 获取活跃度,可领取状态
get_active_state(PlayerStatus) ->
	case get_active_info() of
		[] ->
			ok;
		Info ->
			{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_STATE,[Info]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin)
	end.
	
%% 领取奖励
get_reward(PlayerStatus) ->
	case get_reward_1(PlayerStatus) of
		{ok,PlayerStatus1,Info} ->
			{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_AWARD,[1]),
			{ok,Bin1} = pt_20:write(?PP_PLAYER_ACTIVE_STATE,[Info]),
			lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send,<<Bin/binary,Bin1/binary>>),
			{ok,PlayerStatus1};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 Msg]),
			{false}
	end.


get_reward_1(PlayerStatus) ->
	case get_active_info() of
		[] ->
			{false,""};
		Info ->
			NewInfo = reset_user_data(Info),
			RewardList = ets:tab2list(?ETS_ACTIVE_REWARDS_TEMPLATE),
			F = fun(RInfo,{PlayerStatus,Reward}) ->
						get_reward_2(PlayerStatus,NewInfo,Reward,RInfo)
				end,
			{NewPlayerStatus,NewReward} = lists:foldl(F, {PlayerStatus,NewInfo#ets_users_active.rewards}, RewardList),
			NewInfo1 = NewInfo#ets_users_active{rewards = NewReward},
			update_active_dic(NewInfo1),
			save_user_active_data(),
			{ok,NewPlayerStatus,NewInfo1}
	end.

get_reward_2(PlayerStatus,NewInfo,Reward,RInfo) ->
	if
		NewInfo#ets_users_active.day_active >= RInfo#ets_active_rewards_template.need_active ->
			get_reward_3(PlayerStatus,RInfo,Reward);
		true ->
			{PlayerStatus,Reward}
	end.

get_reward_3(PlayerStatus,RInfo,Reward) ->
	case lists:keyfind(RInfo#ets_active_rewards_template.id,1, Reward) of
		false ->
			{PlayerStatus,Reward};
		{_,0} ->
			get_reward_4(PlayerStatus,RInfo,Reward);
		_ ->
			{PlayerStatus,Reward}
	end.
	
get_reward_4(PlayerStatus,RInfo,Reward) ->
	ItemNum = length(RInfo#ets_active_rewards_template.items),
	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
	if 
		length(NullCells) >= ItemNum ->
			get_reward_5(PlayerStatus,RInfo,Reward);
		true ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,?_LANG_DAILY_AWARD_ITEM_ERROR]),
			{PlayerStatus,Reward}
	end.
	
get_reward_5(PlayerStatus,RInfo,Reward) ->
	NewRewards = lists:keyreplace(RInfo#ets_active_rewards_template.id, 1,Reward, {RInfo#ets_active_rewards_template.id,1}),
	
	%% 发奖励
	NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, 0, RInfo#ets_active_rewards_template.bind_yuanbao,  0, 
													RInfo#ets_active_rewards_template.bind_copper,{?GAIN_MONEY_ACTIVE,RInfo#ets_active_rewards_template.id,1}),
	New1PlayerStatus = lib_player:add_exp(NewPlayerStatus, RInfo#ets_active_rewards_template.rewards_exp),
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'play_active', RInfo#ets_active_rewards_template.items}),

	{New1PlayerStatus,NewRewards}.

%% 初始化活动度值
init_active_times() ->
	List = ets:tab2list(?ETS_ACTIVE_TEMPLATE),
	F = fun(Info) ->
				{Info#ets_active_template.id,0}
		end,
	lists:map(F, List).

init_active_rewards_state() ->
	List = ets:tab2list(?ETS_ACTIVE_REWARDS_TEMPLATE),
	F = fun(Info) ->
				{Info#ets_active_rewards_template.id,0}
		end,
	lists:map(F, List).

