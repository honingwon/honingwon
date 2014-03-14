%% Author: liaoxiaobo
%% Created: 2013-4-23
%% Description: TODO: Add description to lib_target
-module(lib_target).

%%
%% Include files
%%
-include("common.hrl").


-define(DIC_USERS_TARGETS, dic_users_targets). 							%% 目标成就字典
-define(DIC_USERS_HISTORY_ACHIEVEMENT,dic_users_history_achievement). 	%% 成就历史数据

%%
%% Exported Functions
%%
-export([
		 cast_check_target/2,
		 get_dic/0,
		 get_history_dic/0,
		 init_template_target/0,
		 get_user_total_achieve/1,
		 get_user_achieves_attr_by_ids/1,
		 get_user_curr_achieves/1,
		 init_target_online/1,
		 get_targets_info/0,
		 check_target/3,
		 get_award/2
		
		]).

%%
%% API Functions
%%

%% 检测目标数据
cast_check_target(Pid,ConditionList) ->
	gen_server:cast(Pid,{'check_target',ConditionList}).


%% 初始化目标成就数据
init_template_target() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_target_template] ++ Info),
				Items = tool:split_string_to_intlist(Record#ets_target_template.awards),
				Data = tool:to_list(Record#ets_target_template.data),
				
				Objects = string:tokens(Data, "|"),
				FObject = fun(O, {Target, Amounts, Ids}) ->
								  Values = string:tokens(tool:to_list(O), ","),
								  case length(Values) of
									  2  ->
										  Id = tool:to_integer(lists:nth(1, Values)),
										  Amount = tool:to_integer(lists:nth(2, Values)),
										  {[{Id, Amount} | Target], Amount + Amounts, [Id | Ids]};
									 
									  _ ->
										  {Target, Amounts, Ids}
								  end										  
						  end,
				{TargetObjects, TargetAmounts, TargetIds} = lists:foldl(FObject, {[], 0, []}, Objects),
				
				
				Other = #other_target_template{
											   target_objects = TargetObjects,
											   target_amounts = TargetAmounts,
											   target_ids = TargetIds
											  },
				NewRecord = Record#ets_target_template{other_data = Other,awards = Items},	
				ets:insert(?ETS_TARGET_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_target_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

	
%% 初始化在线数据
init_target_online(UserId) ->
	
	%% 初始化成就历史数据
	F = fun(Info) ->
				list_to_tuple([ets_users_targets] ++ Info)
		end,
	case db_agent_target:get_user_history_targets_by_id(UserId) of
		[] ->
			put(?DIC_USERS_HISTORY_ACHIEVEMENT, []);
		List1 when is_list(List1) ->
			List2 = [ F(I) || I <- List1 ],
			put(?DIC_USERS_HISTORY_ACHIEVEMENT, List2)
	end,
		
	F1 = fun(Info,{List,Num}) ->
				Re = list_to_tuple([ets_users_targets] ++ Info),

				if
					Re#ets_users_targets.is_receive =:= 0 andalso Re#ets_users_targets.is_finish =:= 1  ->
						{[Re |List], Num + 1};
					true ->
						{[Re |List], Num}
				end
		end,
	case db_agent_target:get_user_targets_by_id(UserId) of
		[] ->
			put(?DIC_USERS_TARGETS, []),
			0;
		List when is_list(List) ->
			{NewList,Num} = lists:foldl(F1, {[],0}, List),
			put(?DIC_USERS_TARGETS, NewList),
			Num;
		_ ->
			put(?DIC_USERS_TARGETS, []),
			0
	end.
	
	


%%获取玩家全部成就
get_user_total_achieve(UserID) ->
	Achievedata = 
		case  db_agent_target:get_users_achieve(UserID) of
			[] ->
				"";
			[List] ->
				List
		end,
	AchieveStr = tool:to_list(Achievedata),
	
	case erlang:length( AchieveStr ) of
		0 ->
			[];
		_ ->
			AchieveList = string:tokens(AchieveStr, ","),
			F = fun(X, L) ->
						{X1,_} = string:to_integer(X),
						[X1|L]
				end,
			AchieveTitleList = lists:foldl(F, [], AchieveList),
			
			AchieveTitleList
	end.


get_dic() ->
	case get(?DIC_USERS_TARGETS) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

save_dic(NewList) ->
	put(?DIC_USERS_TARGETS, NewList).


get_history_dic() ->
	case get(?DIC_USERS_HISTORY_ACHIEVEMENT) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

save_history_dic(NewList) ->
	put(?DIC_USERS_HISTORY_ACHIEVEMENT, NewList).


get_targets_info() ->
	ok.

check_target(Pid,UserId,List) ->
	check_target(Pid,UserId,{[],[]},List).
	

check_target(_Pid,_UserId,{UL,FL},[]) ->
	{UL,FL};
check_target(Pid,UserId,{UL,FL},[H|T]) ->
	{Condition,Count} = H,
	{UpdateTargetList,FinishList} = check_target1(Pid,UserId,Condition,Count),
	check_target(Pid,UserId,{UpdateTargetList ++ UL,FinishList++FL},T).
							   


check_target1(Pid,UserId,?TARGET_EQUIPMENT,{Count1,Count2}) ->
	{UpdateTargetList,FinishList} = check_target1(Pid,UserId,?TARGET_EQUIPMENT1,{0,Count1}),
	{UpdateTargetList1,FinishList1} = check_target1(Pid,UserId,?TARGET_EQUIPMENT2,{0,Count2}),
	{UpdateTargetList ++ UpdateTargetList1,FinishList++FinishList1};
	

%% 检测目标
%% Count:{0,Num} {id,Num}
check_target1(Pid,UserId,Condition,Count) ->
	case data_agent:target_template_condition_get(Condition) of
		[] ->
			{[],[]};
		TemplateList ->
			TargetList = get_dic(),
			check_target_1(Pid,UserId,TargetList,TemplateList,Count)
	end.

check_target_1(Pid,UserId,TargetList,TemplateList,Count) ->
	Now = misc_timer:now_seconds(),
	F = fun(Template,{TargetList,UpdateTargetList,FinishList,Now}) ->
				case lists:keyfind(Template#ets_target_template.target_id, #ets_users_targets.target_id, TargetList) of
					false ->
						Target = #ets_users_targets{
										   user_id = UserId,
										   target_id  = Template#ets_target_template.target_id,
										   type = Template#ets_target_template.type,
										   is_finish = 0,
										   data = 0
										   },
				
						case check_finish(Pid, Template,Target,Count,Now) of
							{1,NewTarget} ->
								{ [ NewTarget|TargetList] ,[{0,NewTarget}|UpdateTargetList],[ NewTarget | FinishList],Now};
							{0,NewTarget} ->
								{ [ NewTarget|TargetList] ,[{0,NewTarget}|UpdateTargetList], FinishList ,Now};
							_ ->
								{TargetList,UpdateTargetList , FinishList ,Now}
						end;
					Target ->
						case Target#ets_users_targets.is_finish =:= 1 of
							true ->
								{TargetList,UpdateTargetList,FinishList,Now};
							_ ->
								case check_finish( Pid,Template,Target,Count,Now) of
									{1,NewTarget} ->
										NewTargetList = lists:keyreplace(NewTarget#ets_users_targets.target_id, #ets_users_targets.target_id, TargetList, NewTarget),
										{ NewTargetList ,[{1,NewTarget}|UpdateTargetList] ,[ NewTarget | FinishList] ,Now};
									{0,NewTarget} ->
										NewTargetList = lists:keyreplace(NewTarget#ets_users_targets.target_id, #ets_users_targets.target_id, TargetList, NewTarget),
										{ NewTargetList ,[{1,NewTarget}|UpdateTargetList], FinishList ,Now};
									_ ->
										{TargetList,UpdateTargetList , FinishList ,Now}
								end
						end
				end
		end,
	{NewTargetList,UpdateTargetList, FinishList ,_} = lists:foldl(F, {TargetList,[],[],Now}, TemplateList),
	
	F1 = fun(Info) ->
				 case Info of
					 {0,Info1} ->
						 db_agent_target:add_target(Info1),
						 Info1;
					 {_,Info1} ->
						 db_agent_target:update_target1(Info1),
						 Info1
				 end
		 end,
	NewUpdateTargetList = [F1(X) || X <- UpdateTargetList],
	save_dic(NewTargetList),
	{NewUpdateTargetList , FinishList}.

%% 判断编号是否在target_ids 中
check_target_id(Template,Id) ->
	List = Template#ets_target_template.other_data#other_target_template.target_ids,
	lists:any(fun(X) -> X =:= Id end, List).
			
%% 检测是否完成
check_finish(Pid,Template,Info,{Id,Num},Now) ->
	case Template#ets_target_template.other_data#other_target_template.target_ids =:= [0] orelse check_target_id(Template,Id) of
		true ->
			CheckNum = if
%% 						   Template#ets_target_template.is_cumulation =:= 1  ->
%% 							   Info#ets_users_targets.data + 1;
						   Template#ets_target_template.is_cumulation =:= 1 ->
							   Info#ets_users_targets.data + Num;
						   true ->
							   Num
					   end,
			NewInfo = Info#ets_users_targets{data = CheckNum},
			if
				Template#ets_target_template.other_data#other_target_template.target_amounts =< CheckNum ->
					if
						Template#ets_target_template.title_id > 0 ->
							gen_server:cast(Pid,{'add_title',Template#ets_target_template.title_id});
						true ->
							skip
					end,
					{1,NewInfo#ets_users_targets{is_finish = 1, finish_date = Now}};
				true ->
					
					{0,NewInfo}
			end;
		_ ->
			{2,Info}
	end.


	


%% 添加成就
add_achieve(AchieveId, PlayerStatus) ->
	case lists:member(AchieveId, PlayerStatus#ets_users.other_data#user_other.total_achieve) of
		true ->
			{ok, PlayerStatus};
		_ ->
			NewAchieves = PlayerStatus#ets_users.other_data#user_other.total_achieve ++ [AchieveId],
			NewOther = PlayerStatus#ets_users.other_data#user_other{total_achieve = NewAchieves},
			NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther},
			{ok, NewPlayerStatus}
	end.

%% 获取成就中的HP值
get_user_achieves_attr_by_ids(AchieveIds) ->
	F = fun(Id,Totalhp) ->
				case  data_agent:target_template_get(Id) of
					[] ->
						Totalhp;
					TargetsInfo ->
						Totalhp + TargetsInfo#ets_target_template.award_data
				end
		end,
	lists:foldl(F, 0, AchieveIds).

%% 获取成就值
get_user_curr_achieves(AchieveIds) ->
	F = fun(Id,TotalAchieve) ->
				case  data_agent:target_template_get(Id) of
					[] ->
						TotalAchieve;
					TargetsInfo ->
						TotalAchieve + TargetsInfo#ets_target_template.award_achievement
				end
		end,
	lists:foldl(F, 0, AchieveIds).


%% 获取奖励
get_award(PlayerStatus,Id) ->
	case data_agent:target_template_get(Id) of
		[] ->
			false; 
		Template ->
			TargetList = get_dic(),
			case lists:keyfind(Template#ets_target_template.target_id, #ets_users_targets.target_id, TargetList) of
				false ->
					false;
				Info when(Info#ets_users_targets.is_receive =:= 0 andalso Info#ets_users_targets.is_finish =:= 1) ->
					Now = misc_timer:now_seconds(),
					
					NewTarget = Info#ets_users_targets{is_receive = 1},
					
					db_agent_target:update_target(NewTarget),
					Newlist = lists:keyreplace(NewTarget#ets_users_targets.target_id, #ets_users_targets.target_id, TargetList, NewTarget),
					save_dic(Newlist),
					
					case Template#ets_target_template.type of
						0 ->
							get_award1(Template,PlayerStatus),
							{ok,PlayerStatus};
						_ ->
							NewPlayerStatus = get_award2(Template,Now,PlayerStatus),
							
							HistoryList = get_history_dic(),
							case length(HistoryList) >=10 of
								true ->
									HistoryList1 = lists:sublist(HistoryList, 1, 9);
								_ ->
									HistoryList1 = HistoryList
							end,
							NewHistoryList = [ NewTarget|HistoryList1],
							save_history_dic(NewHistoryList),
							
							{ok, Bin} = pt_29:write(?PP_TARGET_HISTORY_UPDATE, [[NewTarget]]),
							lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
						
							{update,NewPlayerStatus}

					end;
					
				_ ->
					false
			end
	end.

get_award1(Template,PlayerStatus) ->
    %% 物品奖励
	if
		length(Template#ets_target_template.awards) > 0 ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,
							{'target_add_item',
							Template#ets_target_template.awards,
							PlayerStatus#ets_users.other_data#user_other.pid_send });
		true ->
			skip
	end.

get_award2(Template,Now,PlayerStatus) ->
	%% 元宝奖励
	NewPlayerStatus = if
		Template#ets_target_template.award_yuan_bao > 0 ->
			PlayerStatus1 = lib_player:add_cash_and_send(PlayerStatus, 0, Template#ets_target_template.award_yuan_bao,  0, 0,
															{?GAIN_MONEY_TARGET_AWARD,Template#ets_target_template.target_id,1}),
%% 			lib_statistics:add_consume_yuanbao_log(PlayerStatus1#ets_users.id, 0, Template#ets_target_template.award_yuan_bao, 
%% 									   0, ?CONSUME_YUANBAO_TASK_AWARD, Now, 0, 0,
%% 									   PlayerStatus1#ets_users.level),
			PlayerStatus1;
		true ->
			PlayerStatus
	end,
	%% 
	{ok,NewPlayerStatus1} = add_achieve(Template#ets_target_template.target_id, NewPlayerStatus),
	if
		Template#ets_target_template.award_achievement > 0 ->
			NewValue = NewPlayerStatus1#ets_users.achieve_data + Template#ets_target_template.award_achievement,
			NewPlayerStatus1#ets_users{achieve_data = NewValue };
		true ->
			NewPlayerStatus1
	end.
%% 	if
%% 		Template#ets_target_template.title_id > 0 ->
%% 			{ok,NewPlayerStatus3} = lib_player:add_title(Template#ets_target_template.title_id, NewPlayerStatus2),
%% 			NewPlayerStatus3;
%% 		true ->
%% 			NewPlayerStatus2
%% 	end.
	


