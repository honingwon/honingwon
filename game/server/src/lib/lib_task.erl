%%%-------------------------------------------------------------------
%%% Module  : lib_task

%%% Author  : 
%%% Description : 任务
%%%-------------------------------------------------------------------
-module(lib_task).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").


-define(DROP_RANDOM, 10000).
-define(DIC_USERS_TASKS, dic_users_tasks). 	%% 任务字典
-define(ESCORT_TASKS_ID,51400).				%% 拉镖任务编号
-define(REFRESH_COPPER,2000).				%% 刷新拉镖任务所需要的铜币

%% -define(DROP_MONSTER_ITEM, drop_monster_item).
-define(DARTS_LEFT_TIME, 60).%%运镖任务限定时间,单位分钟
-define(ASCORT_MAX_STATE, 4).%%运镖加货最高奖励
-define(SHENMO_MAX_STATE, 5).%%神魔令任务最高品质
-define(TEMP_JIAHUO, 109059).%%加货令模板ID
-define(TEMP_LINGLONG, 142001).%%玲珑石模板ID
-define(ESCORT_EXP_TIMES, 1.5).%%帮会运镖经验倍数
-define(ESCORT_COPPER_TIMES, 1.5).%%帮会运镖金钱倍数
-define(AWARD_SEX_CAREER, [{1,1},
					 {1,2},
					 {1,3},
					 {2,1},
					 {2,2},
					 {2,3}]).	%% 任务奖励分类
%%--------------------------------------------------------------------
%% External exports
-export([
		 update_template_task/0,
		 
		 init_template_task/0,
		 init_task_online/1,
		 accept/2,
%% 		 init_task_award/1,
%% 		 get_task_by_id/1,
		 change_require_count/1,
		 task_offline/0,
%% 		 get_user_all_task/1,
		 cancel_task/2,
		 check_token_task/1,
		 submit_task/2,
		 submit_task_by_GM/2,
		 submit_task_by_yuanbao/2,
		 submit_token/1,
		 kill_monster/2,
		 drop_kill_monster/2,
		 trust_task/2,
		 collect_item/2,
		 buy_item/3,
		 check_trust_task/1,
		 refresh_repeat_task/3,
		 save_dic/0,
		 get_dic/0,
		 transport_add/3,
		 check_attacked/1,
		 check_dead/4,
		 check_player_dead/4,
		 client_control/2,
		 get_escort_info/1,
		 get_token_task/0,
%% 		 cancel_token_task/1,
		 init_escort_time/2,
		 accept_shenmo/10,
%% 		 recharge/0,
		 cancel_task_by_condition/0
		 ]).

%%====================================================================
%% External functions
%%====================================================================
update_template_task() ->
	ets:delete_all_objects(?ETS_TASK_TEMPLATE),
	ok = init_template_task1(),
	ok.

%% 初始化任务模板
init_template_task() ->
	ok = init_template_task_award(),
	ok = init_template_task_state(),
	ok = init_template_task1(),
	ok.

%% 任务奖励
init_template_task_award() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_task_award_template] ++ Info),
				ets:insert(?ETS_TASK_AWARD_TEMPLATE, Record)
		end,
	case db_agent_template:get_task_award_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.
%%	任务状态
init_template_task_state() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_task_state_template] ++ Info),
				Awards = init_task_award(Record#ets_task_state_template.task_award_id),
				Data = tool:to_list(Record#ets_task_state_template.data),
				Objects = string:tokens(Data, "|"),
				FObject = fun(O, {Target, Amounts, Ids}) ->
								  Values = string:tokens(tool:to_list(O), ","),
								  case length(Values) of
									  2  ->
										  Id = tool:to_integer(lists:nth(1, Values)),
										  Amount = tool:to_integer(lists:nth(2, Values)),
										  {[{Id, Amount} | Target], [Amount | Amounts], [Id | Ids]};
									  3 ->
										  Id = tool:to_integer(lists:nth(1, Values)),
										  Amount = tool:to_integer(lists:nth(2, Values)),
										  {[{Id, Amount} | Target], [Amount | Amounts], [Id | Ids]};
									  _ ->
										  {Target, Amounts, Ids}
								  end										  
						  end,
				{TargetObjects, TargetAmounts, TargetIds} = lists:foldl(FObject, {[], [], []}, Objects),
				
				FAward = fun({Sex, Career}) ->
					filter_award(Sex, Career, Awards, [])
				end,
				AwardsList = lists:map(FAward, ?AWARD_SEX_CAREER),

				Other = #other_task_template_state{
												   awards=AwardsList,
												   target_objects=TargetObjects,
												   target_amounts=TargetAmounts,
												   target_ids=TargetIds
												  },
				NewRecord = Record#ets_task_state_template{other_data=Other},			
				ets:insert(?ETS_TASK_STATE_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_task_state_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,

	ok.

filter_award(Sex, Career, [], NewAward) ->
	{{Sex, Career} ,NewAward};
filter_award(Sex, Career, [Award|AwardAll], NewAward) ->
	if Award#ets_task_award_template.sex == 0 orelse Award#ets_task_award_template.sex == Sex ->
		   if Award#ets_task_award_template.career == 0 orelse Award#ets_task_award_template.career == Career ->
				  filter_award(Sex, Career, AwardAll ,[Award|NewAward]);
			  true ->
				  filter_award(Sex, Career, AwardAll,NewAward)
		   end;
	   true ->
		   filter_award(Sex, Career, AwardAll ,NewAward)
	end.

%% 任务模板
init_template_task1() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_task_template] ++ Info),
				Awards = init_task_award(Record#ets_task_template.task_award_id),
				States = init_task_state(Record#ets_task_template.task_id),
				
				FTaskList = fun(Id, Acc) ->
									AId = tool:to_integer(Id),
									if	AId > 0 ->
											[AId|Acc];
										true ->
											Acc
									end
							end,
				
				PreTaskList = lists:foldl(FTaskList, [], string:tokens(tool:to_list(Record#ets_task_template.pre_task_id), "|")),
				NextTaskList = lists:foldl(FTaskList, [], string:tokens(tool:to_list(Record#ets_task_template.next_task_id), "|")),
				
				Other = #other_task_template{awards=Awards, states=States,pre_task_list=PreTaskList,next_task_list=NextTaskList},
				BeginDate = tool:date_to_unix(tool:to_list(Record#ets_task_template.begin_date)),
				EndDate = tool:date_to_unix(tool:to_list(Record#ets_task_template.end_date)),
				
				NewRecord = Record#ets_task_template{begin_date=BeginDate, end_date=EndDate, other_data=Other},		
				ets:insert(?ETS_TASK_TEMPLATE, NewRecord)
		end,
	case db_agent_template:get_task_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	
	ok.

%% 返回任务奖励数据列表
init_task_award(AwardIds) ->
	AwardList = string:tokens(tool:to_list(AwardIds), ","),	
	F = fun(Id, Infos) ->
				case data_agent:task_template_award_get(tool:to_integer(Id)) of
					[] ->
						[];
					Info ->
						[Info|Infos]
				end
		end,
	lists:foldl(F, [], AwardList).
%% 返回任务状态列表 
init_task_state(TaskId) ->
	MS = ets:fun2ms(fun(T) when T#ets_task_state_template.task_id =:= TaskId ->
							T
					end),
	List =  ets:select(?ETS_TASK_STATE_TEMPLATE, MS),
	
	F = fun(T1, T2) ->
				if	T1#ets_task_state_template.task_state_id<T2#ets_task_state_template.task_state_id ->
						true;
					true ->
						false
				end
		end,
	lists:sort(F, List).
	
	
%% 初始化玩家在线任务
init_task_online(UserId)->
	Now = misc_timer:now_seconds(),
	F = fun(Info, Acc) -> 
				Record = list_to_tuple([ets_users_tasks] ++ Info),
				RequireList = string:tokens(tool:to_list(Record#ets_users_tasks.require_count), ","),
				FReq = fun(Amount, AmountList) ->
							   [tool:to_integer(Amount)|AmountList]
					   end,					   
				Requries = lists:foldl(FReq, [], RequireList),
				Other = #other_task{requires=Requries},

				case data_agent:task_template_get(Record#ets_users_tasks.task_id) of
					[] ->
						Acc;
					Template ->
						%% 隔天刷新自动清除
						IsSameDay = util:is_same_date(Record#ets_users_tasks.finish_date, Now),						
						IsExist = case Template#ets_task_template.can_reset of
								  1 when IsSameDay =:= false ->
									  0;
								  _ ->
									  Record#ets_users_tasks.is_exist
							  end,
						NewOther = Other#other_task{condition=Template#ets_task_template.condition},
						NewRecord = Record#ets_users_tasks{other_data=NewOther,is_exist=IsExist},
						check_need_items(NewRecord, true),				
%% 						ets:insert(?ETS_USERS_TASKS, NewRecord)
						
%% 						if 
%% 							length(Template#ets_task_template.other_data#other_task_template.states) >0 ->
%% 								StateInfo = lists:nth(1, Template#ets_task_template.other_data#other_task_template.states),
%% 								case StateInfo#ets_task_state_template.condition =:= ?TASK_RECHARGE of
%% 									true when Record#ets_users_tasks.is_finish =:= 0  ->
%% 										case db_agent_admin:get_pay_info(UserId) of
%% 											[] ->
%% 												NewRecord1 = NewRecord;
%% 											_ ->
%% 												NewRecord1 = NewRecord#ets_users_tasks{require_count = "0"}
%% 										end;
%% 									_ ->
%% 										NewRecord1 = NewRecord
%% 								end;
%% 							true ->
%% 								NewRecord1 = NewRecord
%% 						end,															
						[NewRecord|Acc]
				end
		end,
	case db_agent_task:get_user_tasks_by_id(UserId) of
		[] ->
			put(?DIC_USERS_TASKS, []);
		List when is_list(List) ->
			NewList = lists:foldl(F, [], List),
			put(?DIC_USERS_TASKS, NewList);
		_ ->
			put(?DIC_USERS_TASKS, [])
	end,
	ok.

task_offline() ->
%%     ets:match_delete(?ETS_USERS_TASKS, #ets_users_tasks{user_id=UserId, _='_' }),
	save_dic(),
	erase(?DIC_USERS_TASKS),
    ok.

%%	----------------------------辅助方法-----------------------
%% 获取任务列表
get_dic() ->
	case get(?DIC_USERS_TASKS) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.


save_dic() ->
	List = get_dic(),
	save_dic1(List, []).
%% save_dic(List) ->
%% 	save_dic1(List, []).

save_dic1([], NewList) ->
	put(?DIC_USERS_TASKS, NewList),
	NewList;
save_dic1([Info|List], NewList) ->
	NewInfo =
		case Info#ets_users_tasks.other_data#other_task.dirty_state of
			2 ->
			 	case db_agent_task:add_task(Info) of
					1 ->
						Other = Info#ets_users_tasks.other_data#other_task{dirty_state = 0},
						Info#ets_users_tasks{other_data=Other};
					_ ->
%% 						?WARNING_MSG("add_task:~w", [Info]),
						Info
				end;					
			1 ->
				case db_agent_task:update_task(Info) of
					1 ->
						Other = Info#ets_users_tasks.other_data#other_task{dirty_state = 0},
						Info#ets_users_tasks{other_data=Other};
					_ ->
%% 						?WARNING_MSG("update_task:~w", [Info]),
						Info
				end;
			_ ->
				Info
		end,
	save_dic1(List, [NewInfo|NewList]).
			

%% 更新
update_dic(Info) ->
	case is_record(Info, ets_users_tasks) of
		true ->	
			List = get_dic(),
			NewList = 
				case lists:keyfind(Info#ets_users_tasks.task_id, #ets_users_tasks.task_id, List) of
					false ->
						Other = Info#ets_users_tasks.other_data#other_task{dirty_state=2},
						NewInfo = Info#ets_users_tasks{other_data=Other},
						[NewInfo|List];
					Old when  Old#ets_users_tasks.other_data#other_task.dirty_state < 1 ->
						List1 = lists:keydelete(Info#ets_users_tasks.task_id, #ets_users_tasks.task_id, List),
						Other = Info#ets_users_tasks.other_data#other_task{dirty_state=1},
						NewInfo = Info#ets_users_tasks{other_data=Other},			
			    		[NewInfo|List1];
					Old ->
						List1 = lists:keydelete(Info#ets_users_tasks.task_id, #ets_users_tasks.task_id, List),	
						Other = Info#ets_users_tasks.other_data#other_task{dirty_state=Old#ets_users_tasks.other_data#other_task.dirty_state},
						NewInfo = Info#ets_users_tasks{other_data=Other},
					    [NewInfo|List1]
				end,
			put(?DIC_USERS_TASKS, NewList),
			ok;
		_ ->
			?WARNING_MSG("update_dic:~w", [Info]),
			skip
	end.

%% get_ets_list(Tab, Pattern) ->
%%     L = ets:match_object(Tab, Pattern),
%%     case is_list(L) of
%%         true -> 
%% 			L;
%%         false -> 
%% 			[]
%%     end.

%% 通过玩家和任务id获取任务
get_task_by_id(TaskId) ->
	case get_dic() of
		[] ->
			[];
		List ->
			case lists:keyfind(TaskId, #ets_users_tasks.task_id, List) of
				false ->
					[];
				Info ->
					Info
			end
	end.
%%检查江湖令任务是否可以领取
check_token_task(TaskId) ->
	case data_agent:task_template_get(TaskId) of
		[] ->
			{error, ?_LANG_TASK_ADD_NOT_EXIST};
		Template ->
	 	case get_task_by_id(Template#ets_task_template.task_id) of
		 [] ->
			 ok;
		 Info ->
			 %Now = misc_timer:now_seconds(),
			 RepeatDay = util:get_diff_days(Info#ets_users_tasks.finish_date, misc_timer:now_seconds()),
			 if
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.is_finish =:= 0 ->
					 {error, ?_LANG_TASK_ADD_HAS_ACCEPT};
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.is_finish =:= 1 
				   andalso Template#ets_task_template.can_repeat == 0 ->
					 {error, ?_LANG_TASK_ADD_NOT_REPEAT};
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.repeat_count < 1
				   andalso RepeatDay < Template#ets_task_template.repeat_day ->
					 {error, ?_LANG_TASK_ADD_DAY_REPEAT};
				 true ->
					ok
			 end
	 	end
	end.

%% 获取玩家领取的江湖令任务
get_token_task() ->
	case get_dic() of
		[] ->
			[];
		List ->
			get_token_task1(List)
	end.
get_token_task1([]) ->
	[];
get_token_task1([H|L]) ->
	if
		H#ets_users_tasks.task_id >= ?MIN_TOKEN_TASK_ID andalso H#ets_users_tasks.is_finish =/= 1 ->
			case data_agent:task_template_get(H#ets_users_tasks.task_id) of
				[] ->
					[];
				Template when Template#ets_task_template.type =:= ?TOKEN_TASK_TYPE ->
					H;
				_ ->
					[]					
			end;
		true ->
			get_token_task1(L)
	end.



%% 	Pattern = #ets_users_tasks{user_id=UserId, task_id=TaskId,  _='_' },
%% 	get_ets_list(?ETS_USERS_TASKS, Pattern).
%% 获取玩家所有任务
%% get_user_all_task(UserId) ->
%% 	Pattern = #ets_users_tasks{user_id=UserId,  _='_' },
%% 	get_ets_list(?ETS_USERS_TASKS, Pattern).

%% add_task(TaskInfo) ->
%% 	db_agent_task:add_task(TaskInfo),
%% 	ets:insert(?ETS_USERS_TASKS, TaskInfo).

%% update_task(OldInfo, NewInfo) ->
%% 	ets:delete_object(?ETS_USERS_TASKS, OldInfo),
%% 	db_agent_task:update_task(NewInfo),
%% 	ets:insert(?ETS_USERS_TASKS, NewInfo).

%%  =================================任务处理==================================



%% ---------------------------------------接受任务------------------------------------------------
accept(PlayerStatus, TaskId) ->
	case data_agent:task_template_get(TaskId) of
		[] ->
			?DEBUG("accept:~p",[{TaskId}]),
			{error, "?_LANG_TASK_ADD_NOT_EXIST"};
		Template ->
%%			accept1(UserId, Template,  Sex, Camp, Career, Level, PosX, PosY)%%暂时注释，日后放开
			accept3(PlayerStatus, Template, PlayerStatus#ets_users.level, 
										PlayerStatus#ets_users.pos_x, 
										PlayerStatus#ets_users.pos_y, 
										PlayerStatus#ets_users.sex, 
										PlayerStatus#ets_users.camp, 
										PlayerStatus#ets_users.career) 
	end.

accept3(PlayerStatus, Template, Level, PosX, PosY, Sex, Camp, Carrer) ->
	case Template#ets_task_template.type of
		?TASK_TYPE_GUILD ->
			accept5(PlayerStatus, Template, Level, Sex, Camp, Carrer);
%% 		?TASK_TYPE_FIRST_RECHARGE ->
%% 			accept5(PlayerStatus, Template, Level, Sex, Camp, Carrer);
		?TOKEN_TASK_TYPE ->
			accept5(PlayerStatus, Template, Level, Sex, Camp, Carrer);
		_ ->
			accept4(PlayerStatus, Template, Level, PosX, PosY, Sex, Camp, Carrer)
	end.

accept4(PlayerStatus, Template, Level, PosX, PosY, Sex, Camp, Carrer) ->			 
	case data_agent:npc_get(Template#ets_task_template.npc) of
		[] ->
			{error, "?_LANG_TASK_ADD_NOT_NPC"};
		NPC ->
			if
				abs(NPC#ets_npc_template.pos_x - PosX) < ?ACCEPT_DISTANT 
				andalso abs(NPC#ets_npc_template.pos_y - PosY) < ?ACCEPT_DISTANT ->
					accept5(PlayerStatus, Template, Level, Sex, Camp, Carrer);
				true ->
					{error, "?_LANG_TASK_ADD_FAR_NPC"}
			end
	end.
%% 1男2女
accept5(PlayerStatus, Template, Level, Sex, Camp, Carrer)->
	BSex  = case Sex == 1 of
			 true ->
				 1;
			 _ ->
				 2
		 end,
		
	Now = misc_timer:now_seconds(),
	if 
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.begin_date > Now ->
			{error, "?_LANG_TASK_ADD_BEGIN_DATE" };
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.end_date < Now ->
			{error, "?_LANG_TASK_ADD_END_DATE"};
		Template#ets_task_template.min_level > Level ->
			{error, "?_LANG_TASK_ADD_MIN_LEVEL"};
		Template#ets_task_template.max_level < Level ->
			{error, "?_LANG_TASK_ADD_MAX_LEVEL"};
		Template#ets_task_template.sex =/= -1 andalso Template#ets_task_template.sex =/= BSex ->
			{error, "?_LANG_TASK_ADD_NOT_SEX"};
		Template#ets_task_template.camp =/= -1 andalso Template#ets_task_template.camp =/= Camp ->
			{error, "?_LANG_TASK_ADD_NOT_CAMP"};
		Template#ets_task_template.career =/= -1 andalso Template#ets_task_template.career =/= Carrer ->
			{error, "?_LANG_TASK_ADD_NOT_CAREER"};
		true ->
%% 			accept_check(UserId, Template)
			accept6(PlayerStatus, Template)
	end.


accept6(PlayerStatus, Template) ->
	if 
		length(Template#ets_task_template.other_data#other_task_template.pre_task_list) > 0 ->
			case check_pre_task_is_finish(PlayerStatus#ets_users.id, Template#ets_task_template.other_data#other_task_template.pre_task_list) of
				false ->
					{error, "?_LANG_TASK_ADD_PRE_TASK"};
				true ->
					 accept7(PlayerStatus, Template)
			end;
		true ->
			 accept7(PlayerStatus, Template)
	end.

accept7(PlayerStatus, Template)->
	 case get_task_by_id(Template#ets_task_template.task_id) of
		 [] ->
			 accept8(PlayerStatus, Template, undefined);
		 Info ->
			 Now = misc_timer:now_seconds(),
			 RepeatDay = util:get_diff_days(Info#ets_users_tasks.finish_date, Now),
			 if
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.is_finish =:= 0 ->
					 {error, "?_LANG_TASK_ADD_HAS_ACCEPT"};
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.is_finish =:= 1 
				   andalso Template#ets_task_template.can_repeat == 0 ->
					 {error, "?_LANG_TASK_ADD_NOT_REPEAT"};
				 %% todo	应改为0晨为准，不能以24小时来判断
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.repeat_count < 1
%% 				   andalso Now < Info#ets_users_tasks.finish_date + Template#ets_task_template.repeat_day ->
				   andalso RepeatDay < Template#ets_task_template.repeat_day ->
					 {error, "?_LANG_TASK_ADD_DAY_REPEAT"};
				 true ->
					 accept8(PlayerStatus, Template, Info)
			 end
	 end.

accept8(PlayerStatus, Template, Info) ->
	Condition = 
		case length(Template#ets_task_template.other_data#other_task_template.states) >0 of
			true ->
				StateInfo = lists:nth(1, Template#ets_task_template.other_data#other_task_template.states),
				StateInfo#ets_task_state_template.condition;
			_ ->
				Template#ets_task_template.condition
		end,
	case Condition of
		?TASK_ESCORT_DARTS ->
			accept9(PlayerStatus, Template, Info);
		_ ->
			ItemTempId = Template#ets_task_template.need_item_id,
			case ItemTempId > 0 of
				true ->
					ItemCount = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'count_by_tempId',ItemTempId}),
					case ItemCount > 0 of
						true ->
							accept9(PlayerStatus, Template, Info);
						_ ->
							{error, "error: item is not exist"}
					end;
				_ ->
					accept9(PlayerStatus, Template, Info)
			end
	end.

accept9(PlayerStatus, Template, Info) ->
	case Template#ets_task_template.type =:= ?TASK_TYPE_GUILD 
			andalso PlayerStatus#ets_users.club_id > 0 of
		true ->
			GuildLevel = mod_guild:get_guild_level(PlayerStatus#ets_users.club_id),
			case GuildLevel >= Template#ets_task_template.min_guild_level 
				andalso GuildLevel =< Template#ets_task_template.max_guild_level of
				true ->
					accept10(PlayerStatus, Template, Info);
				_ ->
					{error, "error: guild level is out of level interval"}
			end;
		_ ->
			accept10(PlayerStatus, Template, Info)
	end.

accept10(Player, Template, Info) ->
	State = 0,
	Now = misc_timer:now_seconds(),
	if 
		length(Template#ets_task_template.other_data#other_task_template.states) >0 ->
			%% 运镖任务直接设计State
			case Template#ets_task_template.condition of
				?TASK_ESCORT_DARTS ->
					NewState = Player#ets_users.escort_id,
					set_escort_info(Player, NewState, Now+?DARTS_LEFT_TIME*60);
				_ ->
					NewState = State
			end,
			StateInfo = lists:nth(NewState + 1, Template#ets_task_template.other_data#other_task_template.states),
			
			Requires = StateInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts;
		true ->
			NewState = 0,
			Requires =[]
	end,

	StrRequires = change_require_count(Requires),
%% 	Other = #other_task{
%% 						is_new=1,
%% 						requires = Requires
%% 						},
	
	case Info of
		undefined ->
			Other = #other_task{
						is_new=1,
						requires = Requires,
						condition= Template#ets_task_template.condition
						},
			NewInfo = #ets_users_tasks{
									   task_id = Template#ets_task_template.task_id,
									   user_id = Player#ets_users.id,
									   repeat_count = Template#ets_task_template.repeat_count - 1,
									   finish_date = Now,
									   state = NewState,
									   is_trust = 0,
									   is_exist = 1,
									   is_finish = 0,
									   require_count = StrRequires,
									   other_data = Other
									  };
		_ ->
			Other = #other_task{
						is_new=1,
						requires = Requires,
						condition= Template#ets_task_template.condition
						},
			
%% 			           //新的一天则重新更新
			RepeatDay = util:get_diff_days(Info#ets_users_tasks.finish_date, Now),
			RepeatCount = case RepeatDay >= Template#ets_task_template.repeat_day of
								  true ->
									  Template#ets_task_template.repeat_count;
								  _ ->
									  Info#ets_users_tasks.repeat_count
							  end,
			
			%% todo 任务已经在数据库存在，进行了更新
			NewInfo = #ets_users_tasks{
									   task_id = Template#ets_task_template.task_id,
									   user_id = Player#ets_users.id,
%% 									   repeat_count = Info#ets_users_tasks.repeat_count - 1,
									   repeat_count = RepeatCount - 1,
									   finish_date = Now,
									   state = NewState,
									   is_exist = 1,
									   is_trust = 0,
									   is_finish = 0,
									   require_count = StrRequires,
									   other_data = Other
									  }
	end,
	lib_statistics:add_task_log(Template#ets_task_template.task_id, 1, Template#ets_task_template.type),
	%%运镖任务处理
	case Template#ets_task_template.condition of
		?TASK_ESCORT_DARTS ->
			case get_same_tasks(NewInfo#ets_users_tasks.task_id, ?TASK_ESCORT_DARTS) of
				[] ->
					TaskInfo = NewInfo;
				EscortTasks ->
					TaskInfo = update_escort_tasks(EscortTasks, NewInfo, Template#ets_task_template.repeat_count)
			end,
			{LastInfo, EscortTimer} = {TaskInfo, ?DARTS_LEFT_TIME*60};
		_ ->
			{LastInfo, EscortTimer} = {NewInfo, -1}
	end,
	
	ItemTempId = Template#ets_task_template.need_item_id,
	case ItemTempId > 0 of
		true ->
			gen_server:cast(Player#ets_users.other_data#user_other.pid_item, {'reduce_item_in_commonbag', ItemTempId, 1,?CONSUME_ITEM_TASK});
		_ ->
			skip
	end,
	
	check_need_items(LastInfo, true),
%% 	if 
%% 		length(Template#ets_task_template.other_data#other_task_template.states) >0 ->
%% 			StateInfo1 = lists:nth(1, Template#ets_task_template.other_data#other_task_template.states),
%% 			case StateInfo1#ets_task_state_template.condition =:= ?TASK_RECHARGE of
%% 				true ->
%% 					case db_agent_admin:get_pay_info(Player#ets_users.id) of
%% 						[] ->
%% 							NewRecord1 = LastInfo;
%% 						_ ->
%% 							NewRecord1 = LastInfo#ets_users_tasks{require_count = "0"}
%% 					end;
%% 				_ ->
%% 					NewRecord1 = LastInfo
%% 			end;
%% 		true ->
%% 			NewRecord1 = LastInfo
%% 	end,
	update_dic(LastInfo),
	{ok, LastInfo, EscortTimer, Template#ets_task_template.condition}.
				
%%-------------------------wjf-------------------------------------
%% 取消江湖令任务
%% cancel_token_task(PlayerPid) ->
%% 	case get_token_task() of
%% 		[] ->
%% 			{error, "not have token task"};
%% 		Info ->
%% 			if 
%% 				%%Info#ets_users_tasks.is_finish =:= 1 orelse Info#ets_users_tasks.is_exist =:= 0 ->
%% 				%%	{error, "cancel_token_task,?_LANG_TASK_ADD_NOT_EXIST"};		
%% 				Info#ets_users_tasks.is_trust =:= 1 ->
%% 					{error, "task is trusting"};
%% 				true -> 
%% 					{TaskInfo, Condition} = cancel_task1(PlayerPid, Info),
%% 					{ok, TaskInfo, Condition}
%% 			end
%% 	end.
%% 取消任务
cancel_task(PlayerPid, TaskId) ->
	case get_task_by_id(TaskId) of
		[] ->
			{error, ?_LANG_TASK_ADD_NOT_EXIST};
		Info ->
			if 
				Info#ets_users_tasks.is_finish =:= 1 orelse Info#ets_users_tasks.is_exist =:= 0 ->
					{error, "?_LANG_TASK_ADD_NOT_EXIST"};		
				Info#ets_users_tasks.is_trust =:= 1 ->
					{error, "task is trusting"};
				true -> 
					{TaskInfo, Condition} = cancel_task1(PlayerPid, Info),
					if
						TaskId >= ?MIN_TOKEN_TASK_ID ->
							gen_server:cast(PlayerPid, {clear_receive_token_task});
						true ->
							ok
					end,
					{ok, TaskInfo, Condition}
			end
	end.

cancel_task1(PlayerPid, Info) ->
	check_need_items(Info, false),	
	{TaskInfo, Condition} = 
		case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
			[] ->
				Other = #other_task{is_new=0},
				NewInfo = Info#ets_users_tasks{
								   is_exist = 0,
								   other_data = Other,
								   repeat_count = Info#ets_users_tasks.repeat_count + 1
								  },
				{NewInfo, 1};
			Template ->
				lib_statistics:add_task_log(Info#ets_users_tasks.task_id, 3, Template#ets_task_template.type),
				case Template#ets_task_template.condition of
					?TASK_ESCORT_DARTS ->
						gen_server:cast(PlayerPid, {'cancel_escort'}),
						Other = #other_task{is_new=0, condition = Template#ets_task_template.condition},
						NewInfo = Info#ets_users_tasks{
								   is_exist = 0,
								   is_finish = 0,
								   other_data = Other
								  },
						{NewInfo, Template#ets_task_template.condition};
					?TASK_SHENMO ->
						Other = #other_task{is_new=0},
						NewInfo = Info#ets_users_tasks{
								   is_exist = 0,
								   other_data = Other
								  },
						{NewInfo, Template#ets_task_template.condition};
					?TOKEN_TASK_TYPE ->
						Other = #other_task{is_new=0},
						NewInfo = Info#ets_users_tasks{
								   is_exist = 0,
								   other_data = Other
								  },
						{NewInfo, Template#ets_task_template.condition};
					_Type when Template#ets_task_template.type =:= ?TASK_TYPE_DIVISION orelse Template#ets_task_template.type =:= ?TASK_TYPE_TRIALS ->
						Other = #other_task{is_new = 0},
						NewInfo = Info#ets_users_tasks{
								   is_exist = 1,
								   is_finish = 1,
								   other_data = Other
								  },
						{NewInfo, Template#ets_task_template.condition};
					_ -> 
						Other = #other_task{is_new=0},
						NewInfo = Info#ets_users_tasks{
								   is_exist = 0,
								   other_data = Other,
								   repeat_count = Info#ets_users_tasks.repeat_count + 1
								  },
						{NewInfo, Template#ets_task_template.condition}
				end
		end,
	update_dic(TaskInfo),
	{TaskInfo, Condition}.

%% ----------------------------------------委托任务----------------------------------------

trust_task(PlayerStatus, List) ->
	{_Player, TaskList, TotalYuanBao, TotalCopper} = lists:foldl(fun fun_trust_task/2, {PlayerStatus, [], 0, 0}, List),
	{ok, TaskList, TotalYuanBao, TotalCopper}.
%% 	{NewPlayerStatus1, List1} = lists:foldl(F, {PlayerStatus, []}, List),
%% 	{NewPlayerStatus1, List1}.

fun_trust_task({TaskId, Type, Count}, {Player, TaskList, TotalYuanBao, TotalCopper}) ->
	Res = 
		case data_agent:task_template_get(TaskId) of
			[] ->
				false;
			Template when  Template#ets_task_template.can_entrust =:= 1 ->
				case fun_trust_task1(Player, Template, Type, Count) of
					true ->
						case get_task_by_id(TaskId) of
							[] ->
								trust_task_new(Player, Template, Type, Count);
							Info when Info#ets_users_tasks.is_trust =:= 0 ->
								trust_task_old(Player, Info, Template, Type, Count);
							_ ->
								false
						end; 
					false ->
						false
				end;
			_ ->
				false
		end,
	case Res of
		{ok, NewPlayer, TaskInfo, YuanBao, Copper} ->
			{NewPlayer, [TaskInfo|TaskList], TotalYuanBao + YuanBao, TotalCopper + Copper};
		_ ->
			{Player, TaskList, TotalYuanBao, TotalCopper}
	end.	
%% 金钱是否足够, TYPE, 1铜币，2元宝
fun_trust_task1(Player, Template, Type, Count) ->
	case Type of
		1 when Player#ets_users.copper >= Template#ets_task_template.entrust_copper * Count  ->        
			true;
		2 when Player#ets_users.yuan_bao  >= Template#ets_task_template.entrust_yuan_bao * Count ->
			true;
		_ ->
			false
	end.

can_accept_task(Template, Sex, Level, Camp, Career) ->
	BSex  = case Sex == 1 of
			 true ->
				 1;
			 _ ->
				 2
		 end,
	Now = misc_timer:now_seconds(),
	if 
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.begin_date > Now ->
			flase;
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.end_date < Now ->
			flase;
		Template#ets_task_template.min_level > Level ->
			flase;
		Template#ets_task_template.max_level < Level ->
			flase;
		Template#ets_task_template.sex =/= -1 andalso Template#ets_task_template.sex =/= BSex ->
			flase;
		Template#ets_task_template.camp =/= -1 andalso Template#ets_task_template.camp =/= Camp ->
			flase;
		Template#ets_task_template.career =/= -1 andalso Template#ets_task_template.career =/= Career ->
			flase;
		true ->
			true
	end.

%% 委托没有接受过的任务
trust_task_new(PlayerStatus, Template, Type, Count) ->
	case can_accept_task(Template, PlayerStatus#ets_users.sex, PlayerStatus#ets_users.level, PlayerStatus#ets_users.camp, PlayerStatus#ets_users.career) of
		true ->
			trust_task_count(PlayerStatus, undefined, Template, Type, Count, Template#ets_task_template.repeat_count - Count);
		false ->
			false
	end.

%% 委托已经接受过的任务
trust_task_old(PlayerStatus, Info, Template, Type, Count) ->
	Now = misc_timer:now_seconds(),
	case util:is_same_date(Now, Info#ets_users_tasks.finish_date) of
		true when Info#ets_users_tasks.is_finish =/= 1 andalso Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.repeat_count + 1 >= Count  ->
			trust_task_count(PlayerStatus, Info, Template, Type, Count, Info#ets_users_tasks.repeat_count + 1 - Count);
		true when Info#ets_users_tasks.repeat_count >= Count ->
			trust_task_count(PlayerStatus, Info, Template, Type, Count, Info#ets_users_tasks.repeat_count - Count);
		false when Template#ets_task_template.repeat_count >= Count ->
			trust_task_count(PlayerStatus, Info, Template, Type, Count, Template#ets_task_template.repeat_count - Count);
		_ ->
			false
	end.
%% 任务委托次数  TYPE, 1铜币，2元宝
trust_task_count(PlayerStatus, Info, Template, Type, Count, RepeatCount) ->
	{Copper, YuanBao} = 
		case Type of
			1 ->
				{Template#ets_task_template.entrust_copper * Count, 0};
			_ ->
				{0, Template#ets_task_template.entrust_yuan_bao * Count}
		end,
				 
	Now = misc_timer:now_seconds(),
	EndTime = Now + tool:ceil(Template#ets_task_template.entrust_time / 1000 * Count),
	
	State = 0,
	if 
		length(Template#ets_task_template.other_data#other_task_template.states) >0 ->
			StateInfo = lists:nth(State + 1, Template#ets_task_template.other_data#other_task_template.states),
			Requires = StateInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts;
		true ->
			Requires =[]
	end,

	StrRequires = change_require_count(Requires),
	Other = #other_task{
						is_new=1,
						requires = Requires
						},
	NewInfo = #ets_users_tasks{
								task_id = Template#ets_task_template.task_id,
								user_id = PlayerStatus#ets_users.id,
								repeat_count = RepeatCount,
								finish_date = Now,
								state = State,
								is_exist = 1,
								is_finish = 0,
								require_count = StrRequires,
								other_data = Other,
								is_trust = 1,
								trust_end_time = EndTime,
								trust_count = Count
								},
	case Info of
		undefined ->
			skip;
		_ ->
			%% 如果任务还没完成，去掉剩的条件
			check_need_items(Info, false)
%% 			update_task(Info, NewInfo)
		end,
	update_dic(NewInfo),

	NewPlayerStatus = PlayerStatus#ets_users{
											 copper = PlayerStatus#ets_users.copper - Copper,
											 yuan_bao = PlayerStatus#ets_users.yuan_bao - YuanBao
											 },
	{ok, NewPlayerStatus, NewInfo, YuanBao, Copper}.

%% ----------------------------------------委托任务完成----------------------------------------
check_trust_task(_UserId) ->
%% 	TaskList = get_user_all_task(UserId),
	TaskList = get_dic(),
	Now = misc_timer:now_seconds(),
	F = fun(Info, {List, TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, AwardList}) ->
			if Info#ets_users_tasks.is_trust =:= 1 
				 andalso Info#ets_users_tasks.is_finish =/= 1
				 andalso Info#ets_users_tasks.trust_end_time =< Now ->
				   case finish_trust_task(Info) of
					   {ok, NewInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, Awards} ->
						   {[NewInfo|List], TotalYuanBao + YuanBao, TotalBindYuanBao + BindYuanBao, TotalCopper + Copper, 
							TotalBindCopper + BindCopper, TotalExp + Experience, lists:append(AwardList, Awards)};
					   _ ->
						   {TaskList, TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, AwardList}
				   	end;
			   true ->
			  	 {List, TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, AwardList}
			end
		end,
	{NewList, TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, AwardList} = lists:foldl(F, {[], 0, 0, 0, 0, 0, []}, TaskList),
		
	{ok, NewList, TotalYuanBao, TotalBindYuanBao, TotalCopper, TotalBindCopper, TotalExp, AwardList}.
							   
finish_trust_task(Info) ->
	case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
		[] ->
			false;
		Template ->
%% 			StateInfo = lists:last(Template#ets_task_template.other_data#other_task_template.states),
			finish_trust_task1(Info, Template#ets_task_template.other_data#other_task_template.states)
	end.
			
			
finish_trust_task1(Info, StateInfos) ->
	Other = #other_task{
						is_new = 0,
						is_new_finish = 0
						},
	NewInfo = Info#ets_users_tasks{
								   is_finish = 1,	
								   is_trust = 0,									 
%% 								   finish_date = misc_timer:now_seconds(),
%% 								   finish_date = Info#ets_users_tasks.trust_end_time,
								   other_data = Other
								  },
	
%% 	update_task(Info, NewInfo),
	update_dic(NewInfo),
	{YuanBao, BindYuanBao, Copper, BinCopper, Exp} = add_state_award(StateInfos, {0, 0, 0, 0, 0}),
	{ok, NewInfo, YuanBao, BindYuanBao, Copper, BinCopper, Exp, []}.
%% 	{ok, 
%% 	 NewInfo,	 
%% 	 StateInfo#ets_task_state_template.award_yuan_bao * Info#ets_users_tasks.trust_count,
%% 	 StateInfo#ets_task_state_template.award_bind_yuan_bao * Info#ets_users_tasks.trust_count,
%% 	 StateInfo#ets_task_state_template.award_copper * Info#ets_users_tasks.trust_count,
%% 	 StateInfo#ets_task_state_template.award_bind_copper * Info#ets_users_tasks.trust_count,
%% 	 StateInfo#ets_task_state_template.award_exp * Info#ets_users_tasks.trust_count,
%% 	 []}.
%% 	 StateInfo#ets_task_state_template.other_data#other_task_template_state.awards}.%% 奖励物品要翻倍需要特殊处理

%% 叠加状态奖励
add_state_award([], {YuanBao, BindYuanBao, Copper, BinCopper, Exp}) ->
	{YuanBao, BindYuanBao, Copper, BinCopper, Exp};
add_state_award([StateInfo|List], {YuanBao, BindYuanBao, Copper, BinCopper, Exp}) ->
	add_state_award(List, {YuanBao + StateInfo#ets_task_state_template.award_yuan_bao,
	 BindYuanBao + StateInfo#ets_task_state_template.award_bind_yuan_bao,
	 Copper + StateInfo#ets_task_state_template.award_copper,
	 BinCopper + StateInfo#ets_task_state_template.award_bind_copper,
	 Exp + StateInfo#ets_task_state_template.award_exp}).
	


%% ----------------------------------------提交任务----------------------------------------
submit_token(PlayerStatus) ->
	case get_token_task() of
		[] ->
			{error, "not have token task"};
		Info when Info#ets_users_tasks.is_finish =:= 1 
		  orelse Info#ets_users_tasks.is_exist =:= 0 ->
			{error, "task is finish or not exist"};
		Info when Info#ets_users_tasks.is_trust =:= 1 ->
			{error, "task is trusting"};
		Info ->											 
			case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
				[] ->
					{error, "template is not"};
				Template -> 
					StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , 
						  Template#ets_task_template.other_data#other_task_template.states),
					submit_task6(StateInfo, Info, Template, PlayerStatus)
			end
	end.

submit_task_by_GM(PlayerStatus, TaskId) ->
	case get_task_by_id(TaskId) of
		[] ->
			{error, "task is not exist"};
		Info when Info#ets_users_tasks.is_finish =:= 1 
		  orelse Info#ets_users_tasks.is_exist =:= 0 ->
			{error, "task is finish or not exist"};
		Info when Info#ets_users_tasks.is_trust =:= 1 ->
			{error, "task is trusting"};
		Info ->											 
			case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
				[] ->
					{error, "template is not"};
				Template -> 
					StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , 
						  Template#ets_task_template.other_data#other_task_template.states),
					submit_task6(StateInfo, Info, Template, PlayerStatus)
			end
	end.


%% 任务直接完成
submit_task_by_yuanbao(PlayerStatus, TaskId) ->
	case get_task_by_id(TaskId) of
		[] ->
			{error, "task is not exist"};
		Info when Info#ets_users_tasks.is_finish =:= 1 
		  orelse Info#ets_users_tasks.is_exist =:= 0 ->
			{error, "task is finish or not exist"};
		Info when Info#ets_users_tasks.is_trust =:= 1 ->
			{error, "task is trusting"};
		Info ->											 
			case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
				[] ->
					{error, "template is not"};
				Template -> 
					StateInfo = lists:nth(Info#ets_users_tasks.state + 1 ,  Template#ets_task_template.other_data#other_task_template.states),
					NeedYuanbao = 2,
					case check_can_subimt_by_yuanbao(PlayerStatus, Template,StateInfo,NeedYuanbao) of
						true ->
							case submit_task6(StateInfo, Info, Template, PlayerStatus) of
								{ok, TaskInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards} ->
									{ok, NeedYuanbao,TaskInfo, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards};
								_ ->
									{error, "error"}
							end;
						_ ->
							{error, "error"}
					end
			end
	end.

check_can_subimt_by_yuanbao(PlayerStatus, Template,StateInfo,NeedYuanbao) ->
	 if
		 Template#ets_task_template.type =/= ?TASK_TYPE_GUILD andalso Template#ets_task_template.type =/= ?TASK_TYPE_DIVISION andalso Template#ets_task_template.type =/= ?TASK_TYPE_TRIALS  ->
			 false;
		 PlayerStatus#ets_users.yuan_bao < NeedYuanbao ->
			 false;
		 true ->
			 NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
			 Awards = get_award_by_sex_and_career(
						   PlayerStatus#ets_users.sex,
						   PlayerStatus#ets_users.career,
						   StateInfo#ets_task_state_template.other_data#other_task_template_state.awards),
			 case length(NullCells) < 1 andalso length(Awards) > 0 of
				 true ->
					 false;
				 _ ->
					 true
			 end
	end.
		 

submit_task(PlayerStatus, TaskId) ->
	case get_task_by_id(TaskId) of
		[] ->
			{error, "task is not exist"};
		Info when Info#ets_users_tasks.is_finish =:= 1 
		  orelse Info#ets_users_tasks.is_exist =:= 0 ->
			{error, "task is finish or not exist"};
		Info when Info#ets_users_tasks.is_trust =:= 1 ->
			{error, "task is trusting"};
		Info ->											 
			submit_task1(Info, PlayerStatus)
	end.
submit_task1(Info, PlayerStatus) ->
	case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
		[] ->
			{error, "template is not"};
		Template -> 
			submit_task2(Info, Template, PlayerStatus)
	end.
submit_task2(Info, Template, PlayerStatus) ->
%% 	?DEBUG("dhwang_test--Template:~p",[Template]),
%% 	?DEBUG("dhwang_test--StateInfo:~p",[Template#ets_task_template.other_data#other_task_template.states]),
	StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , 
						  Template#ets_task_template.other_data#other_task_template.states),

%% 	case data_agent:npc_get(Template#ets_task_template.npc) of
%% 	case StateInfo#ets_task_state_template.condition =:= ?TASK_RECHARGE of
%% 		true ->
%% 			submit_task3(Info, Template, PlayerStatus, StateInfo);
%% 		_ ->
	case data_agent:npc_get(StateInfo#ets_task_state_template.npc) of
		[] ->
			{error, "npc is not"};
		NPC ->
			if
				Template#ets_task_template.type =:= ?TOKEN_TASK_TYPE -> %% 江湖令
					submit_task3(Info, Template, PlayerStatus, StateInfo);
				abs(NPC#ets_npc_template.pos_x - PlayerStatus#ets_users.pos_x) < ?ACCEPT_DISTANT 
					andalso abs(NPC#ets_npc_template.pos_y - PlayerStatus#ets_users.pos_y) < ?ACCEPT_DISTANT ->
					submit_task3(Info, Template, PlayerStatus, StateInfo);
				true ->
					{error, "user is not npc area"}
			end
	end.
%% 	end. 
submit_task3(Info, Template, PlayerStatus, StateInfo) ->
	Now = misc_timer:now_seconds(),
	if 
		%% 能重复任务，时间超过当日为过期
%% 		Template#ets_task_template.can_reset =:= 1 andalso Info#ets_users.finish_date > Now ->
%% 			{error, "day time is out"};
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.end_date < Now ->
			{error, "time is out"};
		true ->
			submit_task4(Info, Template, PlayerStatus, StateInfo)
	end.

submit_task4(Info, Template, PlayerStatus, StateInfo) ->
	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
	Awards = get_award_by_sex_and_career(
			   PlayerStatus#ets_users.sex,
			   PlayerStatus#ets_users.career,
			   StateInfo#ets_task_state_template.other_data#other_task_template_state.awards),
	case length(NullCells) < 1 andalso length(Awards) > 0 of
		true ->
			{error, "error: empty cells < 1, task can not finish"};
		_ ->
			submit_task5(Info, Template, PlayerStatus, StateInfo)
	end.

submit_task5(Info, Template, PlayerStatus, StateInfo) ->
	CanSubmit = case StateInfo#ets_task_state_template.condition of
				?TASK_DIALOG ->
					true;
				?TASK_DROP_MONSTER ->
					check_require(Info#ets_users_tasks.other_data#other_task.requires);
				?TASK_KILL_MONSTER ->
					check_require(Info#ets_users_tasks.other_data#other_task.requires);
				?TASK_COLLECT_ITEM ->
					check_require(Info#ets_users_tasks.other_data#other_task.requires);
				?TASK_CLIENT_CONTROL ->
%% 					check_client_ctrl(Info#ets_users_tasks.require_count);
					true;
				?TASK_COLLECT ->
					check_collect_item(PlayerStatus, 
									   StateInfo#ets_task_state_template.other_data#other_task_template_state.target_objects,
									   StateInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts,
									   undefined);
				?TASK_COLLECT_NPC ->
					check_collect_item(PlayerStatus, 
									   StateInfo#ets_task_state_template.other_data#other_task_template_state.target_objects,
									   StateInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts,
									   undefined);
				?TASK_USER_LEVEL ->
					check_user_level(StateInfo, PlayerStatus#ets_users.level);
				?TASK_ESCORT_DARTS ->
					true;
				?COPY_KILLMONSTER ->
					check_require(Info#ets_users_tasks.other_data#other_task.requires);
				?TASK_SHENMO ->
					true;
%% 				?TASK_RECHARGE ->
%% 					true;
					
				?TASK_PURCHASE ->
					true;
				?COPY_DIALOG ->
					true;
				?COPY_COLLECT ->
					check_collect_item(PlayerStatus, 
									   StateInfo#ets_task_state_template.other_data#other_task_template_state.target_objects,
									   StateInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts,
									   undefined);
				?COPY_COLLECT_ITEM ->
					check_require(Info#ets_users_tasks.other_data#other_task.requires);
				_ ->
					false
				end,
	case CanSubmit of
		true ->
			submit_task6(StateInfo, Info, Template, PlayerStatus);
		_ ->
			{error, "task can not finish"}
	end.

submit_task6(StateInfo, Info, Template, PlayerStatus) ->
	StateLen = length(Template#ets_task_template.other_data#other_task_template.states) - 1,

	%% 拉镖任务直接完成，不修改状态
	NewInfo = 
		case Info#ets_users_tasks.state < StateLen 
					andalso Template#ets_task_template.condition =/= ?TASK_ESCORT_DARTS 
					andalso Template#ets_task_template.condition =/= ?TASK_SHENMO of  
				  true ->
					  NextStatInfo = lists:nth(Info#ets_users_tasks.state + 2, Template#ets_task_template.other_data#other_task_template.states),
					  Requires = NextStatInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts,
					  StrRequires = change_require_count(Requires),
			    	  Other = #other_task{
										is_new = 0,
										requires = Requires
										},
					  Info#ets_users_tasks{
											state = Info#ets_users_tasks.state + 1,
											require_count = StrRequires,
											other_data = Other
											};
				_ ->
					lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_TASK,{Template#ets_task_template.task_id,1}}]),
					Other = #other_task{
										is_new = 0,
										is_new_finish = 1
										},
					case Template#ets_task_template.condition of
						?TASK_ESCORT_DARTS  ->
							Info#ets_users_tasks{
												 is_exist = 0,
												 is_finish = 1, 
												 finish_date = misc_timer:now_seconds(),
												 other_data = Other
												 };
						_ ->
							Info#ets_users_tasks{
										 is_finish = 1,										 
										 finish_date = misc_timer:now_seconds(),
										 other_data = Other
										 }
					end
			  end,
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid, {'finish_active',PlayerStatus, ?TASKACTIVE,Template#ets_task_template.task_id}),
	Awards = get_award_by_sex_and_career(
			   PlayerStatus#ets_users.sex,
			   PlayerStatus#ets_users.career,
			   StateInfo#ets_task_state_template.other_data#other_task_template_state.awards),
	
	{YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp} = 
		{						
		 StateInfo#ets_task_state_template.award_yuan_bao,
		 StateInfo#ets_task_state_template.award_bind_yuan_bao,
		 StateInfo#ets_task_state_template.award_copper,
		 StateInfo#ets_task_state_template.award_bind_copper,
		 StateInfo#ets_task_state_template.award_exp,
		 StateInfo#ets_task_state_template.award_life_experience
		 		
		 },
	
	%%处理帮会运镖
	{NewExp1, NewCopper} = case Template#ets_task_template.condition =:= ?TASK_ESCORT_DARTS of
		true ->
			case gen_server:call(mod_active:get_active_pid(), {is_active_open, ?ESCORT_ACTIVE_ID}) of
				true ->
					{round(Experience * ?ESCORT_EXP_TIMES), round(Copper * ?ESCORT_COPPER_TIMES)};
				_ ->
					{Experience, Copper}
			end;
		_ ->
			{Experience, Copper}
	end,
	
	%判断玩家vip等级加成
	Vip_id = PlayerStatus#ets_users.vip_id,
	NewExp = 
		if Vip_id  band ?VIP_BSL_HALFYEAR =/= 0 orelse Vip_id  band ?VIP_BSL_GM =/= 0 ->
				tool:to_integer(NewExp1*1.1);
			Vip_id  band ?VIP_BSL_MONTH =/= 0 orelse Vip_id  band ?VIP_BSL_NEWPLAYERLEADER =/= 0 orelse Vip_id  band ?VIP_BSL_ONEHOUR =/= 0->
				tool:to_integer(NewExp1*1.06);
			Vip_id  band ?VIP_BSL_WEEK =/= 0 orelse Vip_id  band ?VIP_BSL_DAY =/= 0->
				tool:to_integer(NewExp1*1.03);
			true ->
				NewExp1
		end,
	
	%%运镖结束，修改角色状态
	case Template#ets_task_template.condition of
		?TASK_ESCORT_DARTS -> 
			NewState = PlayerStatus#ets_users.escort_id,
			case NewState rem 5 of
				4 ->%%橙色镖车，全服通告
					ChatAllStr = ?GET_TRAN(?_LANG_CHAT_SUBMIT_PURPLE_CAR, [PlayerStatus#ets_users.nick_name]),
					lib_chat:chat_sysmsg_roll([ChatAllStr]);
				_ ->
					skip
			end,
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid, {'finish_escort', NewExp, NewCopper});
		_ ->
			skip
	end,
	
	 
	%%帮会任务
	case Template#ets_task_template.type =:= ?TASK_TYPE_GUILD 
			andalso PlayerStatus#ets_users.club_id > 0 of 
		true ->
			mod_guild:guild_task_award(PlayerStatus#ets_users.club_id,
									   PlayerStatus#ets_users.id, 
										StateInfo#ets_task_state_template.award_contribution,
										StateInfo#ets_task_state_template.award_money,
										StateInfo#ets_task_state_template.award_activity,
										StateInfo#ets_task_state_template.award_feats);
		_ ->
			skip
	end,
	
	check_need_items(NewInfo, true),
	update_dic(NewInfo),
	lib_statistics:add_task_log(Template#ets_task_template.task_id, 2, Template#ets_task_template.type),
	
	{ok, NewInfo, YuanBao, BindYuanBao, NewCopper, BindCopper, NewExp, LifeExp, Awards}.
				

get_award_by_sex_and_career(Sex, Career, AwardList) ->
	TempSex = case Sex of 
				  0 ->
					  2;
				  _ ->
					  1
			  end,
	{_Key, Awards} = lists:keyfind({TempSex, Career}, 1, AwardList),
	Awards.
						
%% -------------------------------------------杀怪刷新任务----------------------------------------			
kill_monster(_UserId, MonsterId) ->
%% 	TaskList = get_user_all_task(UserId),
	TaskList = get_dic(),
	kill_monster1(TaskList, MonsterId, []).	
kill_monster1([], _MonsterId, NewList) ->
	{ok, NewList};
kill_monster1([H|L], MonsterId, NewList) ->
	if H#ets_users_tasks.is_finish =:= 0 andalso H#ets_users_tasks.is_exist =:= 1 ->
		   case kill_monster2(H, MonsterId) of
			   {true, NewInfo} ->
				   kill_monster1(L, MonsterId, [NewInfo|NewList]);
			   false ->
				   kill_monster1(L, MonsterId, NewList)
		   end;
	   true ->
		   kill_monster1(L, MonsterId, NewList)
	end.
kill_monster2(Info, MonsterId) ->
	case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
		[] ->
			false;
		Template -> 
			StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , Template#ets_task_template.other_data#other_task_template.states),
			kill_monster3(Info, StateInfo, MonsterId)
	end.
kill_monster3(Info, StateInfo, MonsterId) ->
	if StateInfo#ets_task_state_template.condition =:= ?TASK_KILL_MONSTER 
		orelse StateInfo#ets_task_state_template.condition =:= ?COPY_KILLMONSTER ->
		kill_monster4(MonsterId,
					  StateInfo#ets_task_state_template.other_data#other_task_template_state.target_objects,
					  Info#ets_users_tasks.other_data#other_task.requires,
				      Info,
					  [],
					  false);
	   true ->
		   false
	end.		
kill_monster4(_KillId, [], _AmountList, Info, NewAmountList, IsChange) ->
	case IsChange of
		true ->
    		NewAmountList1 = lists:reverse(NewAmountList),
			Other = Info#ets_users_tasks.other_data#other_task{requires=NewAmountList1, is_new=0},
			StrRequires = change_require_count(NewAmountList1),
			NewInfo = Info#ets_users_tasks{require_count=StrRequires,other_data=Other},
%% 			update_task(Info, NewInfo),
			update_dic(NewInfo),
			{true, NewInfo};
		_ ->
			false
	end;
kill_monster4(KillId, [{MonsterId, _Total}|MonsterList], [Amount|AmountList], Info, NewAmountList, IsChange) ->
	if MonsterId =:= KillId andalso Amount > 0 ->
		kill_monster4(KillId, MonsterList, AmountList, Info, [Amount - 1|NewAmountList], true);
	true ->
		kill_monster4(KillId, MonsterList, AmountList, Info, [Amount|NewAmountList], IsChange)
	end.


%% ---------------------------------计算任务需要掉落---------------------------
%% 减少计算物品数量
reduce_need_items(Condition, Id ,Amount) ->
	case get({Condition, Id}) of
		undefined ->
			skip;
		OldAmount ->
			put({Condition, Id}, OldAmount - Amount)
	end.

%% 任务变化计算任务物品数量
check_need_items(Info, IsAdd) ->
	case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
		[] ->
			skip;
		Template ->
			if Info#ets_users_tasks.is_finish =/= 1 
				 andalso Info#ets_users_tasks.is_exist =/= 0 
				 andalso Info#ets_users_tasks.is_trust =/= 1->
				   StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , 
						  Template#ets_task_template.other_data#other_task_template.states),
					   check_need_items1(Info, StateInfo, IsAdd);
			   true ->
				   skip
			end
	end.
 	
check_need_items1(Info, StateInfo, IsAdd) ->
	case StateInfo#ets_task_state_template.condition of
		?TASK_DROP_MONSTER ->
			check_need_bag_items(?TASK_DROP_MONSTER, Info, StateInfo, IsAdd);
		?TASK_COLLECT_ITEM ->
			check_need_bag_items(?TASK_COLLECT_ITEM, Info, StateInfo, IsAdd);
		?COPY_COLLECT_ITEM ->
			%% todo 当有普通的采集处理。
			check_need_bag_items(?TASK_COLLECT_ITEM, Info, StateInfo, IsAdd);
		?TASK_PURCHASE ->
			check_need_bag_items(?TASK_PURCHASE, Info, StateInfo, IsAdd);
		_ ->
			skip
	end.

check_need_bag_items(Condition, Info, StateInfo, IsAdd) ->
	AmountList = Info#ets_users_tasks.other_data#other_task.requires,
	IdList = StateInfo#ets_task_state_template.other_data#other_task_template_state.target_ids,
	check_need_bag_items1(Condition, AmountList, IdList, IsAdd).

check_need_bag_items1(_Condition, [], _Ids, _IsAdd) ->
	ok;
check_need_bag_items1(Condition, [Amount|AmountList], [Id|IdList], IsAdd) ->
	case get({Condition, Id}) of
		undefined ->
			if IsAdd =:= true ->
					put({Condition, Id}, Amount);
				true ->
					skip
			end;					   
		OldAmount ->
			if  IsAdd =:= true ->
					put({Condition, Id}, Amount + OldAmount);
				true ->
					put({Condition, Id}, Amount - OldAmount)
			end
	end,
	check_need_bag_items1(Condition, AmountList, IdList, IsAdd).
	

%% -------------------------------------------杀怪掉落--------------------------------------
drop_kill_monster(UserId, DropList) ->
	if length(DropList) > 0 ->
		   drop_kill_monster1(UserId, DropList);
	   true ->
		   {ok, []}
	end.
drop_kill_monster1(_UserId, DropList) ->
		F = fun(Info, Acc) ->
				ItemTemplateId = Info#ets_monster_item_template.item_template_id,
				Random = Info#ets_monster_item_template.random,
				Amount = Info#ets_monster_item_template.amount,
				case get({?TASK_DROP_MONSTER, ItemTemplateId}) of
					undefined ->
						Acc;
					NeedAmount when NeedAmount > 0 ->
						case util:rand(0, ?DROP_RANDOM) of
							DropRand when Random > DropRand ->
							    DropAmount = util:rand(1, Amount),
							    [{ItemTemplateId, DropAmount}|Acc];
						 	_ ->
								Acc
						end;
					_ ->
						Acc
				end
		end,
	  
	RealDrop = lists:foldr(F, [], DropList),
	if length(RealDrop) > 0 ->
%% 		   case get_user_all_task(UserId) of
		   case get_dic() of
			   [] ->
				   {ok, []};
			   TaskList ->
				   drop_kill_monster2(TaskList, RealDrop, [])				   
		   end;
	   true ->
		   {ok, []}
	end.

drop_kill_monster2(_TaskList, [], NewList) ->
	{ok, NewList};
drop_kill_monster2(TaskList, [Drop|DropList], NewList) ->
	case get_task_item(TaskList, Drop, ?TASK_DROP_MONSTER) of
		{true, NewInfo} ->
			drop_kill_monster2(TaskList, DropList, [NewInfo|NewList]);
		false ->
			drop_kill_monster2(TaskList, DropList, NewList)
	end.

%% -------------------------------------------采集--------------------------------------
collect_item(_UserId, TemplateId) ->
%% 	case get_user_all_task(UserId) of
	case get_dic() of
		[] ->
			{ok, []};
		TaskList ->
			%% 采集，每次只有一个
			case get_task_item(TaskList, {TemplateId, 1}, ?TASK_COLLECT_ITEM) of
				{true, NewInfo} ->
					{ok, [NewInfo]};
				_ ->
					{ok, []}
			end
	end.	


%% -------------------------------------------获得购买--------------------------------------
buy_item(_UserId, TemplateId,Count) ->
	case get_dic() of
		[] ->
			{ok, []};
		TaskList ->
			case get_task_item(TaskList, {TemplateId, Count}, ?TASK_PURCHASE) of
				{true, NewInfo} ->
					{ok, [NewInfo]};
				_ ->
					{ok, []}
			end
	end.


%% -------------------------------------------任务物品收集--------------------------------------
get_task_item([], _Drop, _Condition) ->
	false;
get_task_item([Info|TaskList], Drop, Condition) ->
	case get_task_item1(Info, Drop, Condition) of
		{true, NewInfo} ->
			{true, NewInfo};
		false ->
			get_task_item(TaskList, Drop, Condition)
	end.	
			
%% drop_kill_monster4(Info, Drop) ->
get_task_item1(Info, Drop, Condition) ->
	case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
		[] ->
			false;
		Template -> 
			if Info#ets_users_tasks.is_finish =/= 1 andalso Info#ets_users_tasks.is_exist =/= 0 ->
					StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , Template#ets_task_template.other_data#other_task_template.states),
					get_task_item2(Info, StateInfo, Drop, Condition);
			   true ->
				   false
			end
	end.

get_task_item2(Info, StateInfo, Drop, Condition) ->
%% 	if StateInfo#ets_task_state_template.condition =:= ?TASK_DROP_MONSTER ->
	if StateInfo#ets_task_state_template.condition =:= Condition ->
		get_task_item3(Drop,
					  StateInfo#ets_task_state_template.other_data#other_task_template_state.target_objects,
					  Info#ets_users_tasks.other_data#other_task.requires,
				      Info,
					  [],
					  false,
					  Condition);
	   true ->
		   false
	end.	

get_task_item3(_Drop, [], _AmountList, Info, NewAmountList, IsChange, _Condition) ->
	case IsChange of
		true ->
    		NewAmountList1 = lists:reverse(NewAmountList),
			Other = Info#ets_users_tasks.other_data#other_task{requires=NewAmountList1, is_new=0},
			StrRequires = change_require_count(NewAmountList1),
			NewInfo = Info#ets_users_tasks{require_count=StrRequires,other_data=Other},
%% 			update_task(Info, NewInfo),
			update_dic(NewInfo),
			{true, NewInfo};
		_ ->
			false
	end;
get_task_item3({ItemTemplateId, DropAmount}, [{ItemId, _Total}|ItemList], [Amount|AmountList], Info, NewAmountList, IsChange, Condition) ->
	if ItemTemplateId =:= ItemId andalso Amount > 0 ->
		   Reduce = case DropAmount > Amount of
						true ->
							Amount;
						_ ->
							DropAmount
					end,
		   reduce_need_items(Condition, ItemTemplateId, Reduce),
		   get_task_item3({ItemTemplateId, 0}, ItemList, AmountList, Info, [Amount - Reduce|NewAmountList], true, Condition);
	true ->
		   get_task_item3({ItemTemplateId, Amount}, ItemList, AmountList, Info, [Amount|NewAmountList], IsChange, Condition)
	end.
				
%% -------------------------------------------任务提交判断--------------------------------------
%% 杀怪任务
check_require([]) ->
	true;
check_require([H|Requires]) ->
	if 
		H > 0 ->
			false;
		true ->
			check_require(Requires)
	end.

%%客户端控制任务判断
check_client_ctrl(RequireCount) ->
	if RequireCount =:= "0" ->
			true;
	   true ->
			false
	end.
  
%% 物品
check_collect_item(PlayerStatus, TargetObjects, TargetAmounts, IsBind) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
					{'task_reduce_item',
					 TargetObjects,
					 TargetAmounts,
					 IsBind
					 }) of
		true ->
			true;
		_ ->
			false
	end.
%% 等级判断
check_user_level(_StateInfo, _Level) ->
	true.

%% 判断需要扣除物品是否为绑定
%% check_bind_item(PidItem, ItemTempId) ->
%% 	case ItemTempId > 0 of
%% 		true ->
%% 			case gen_server:cast(PidItem, {'is_item_not_bind', ItemTempId}) of
%% 				true ->
%% 					true;
%% 				_ ->
%% 					false
%% 			end;
%% 		_ ->
%% 			false
%% 	end.

%% 拼凑字符串给客服端用的
change_require_count(Requires)->
	F = fun(Amount, StrAmount) ->
				if 
					length(StrAmount) =:=0 ->
						lists:concat([Amount]);
					true ->
						lists:concat([StrAmount, "," ,Amount])
				end
		end,
	lists:foldl(F, "", Requires).


%% ----------------------------------------前置任务判断--------------------------------
check_pre_task_is_finish(_UserId, []) ->
	false;
check_pre_task_is_finish(UserId, [PreId|L]) ->
	case get_task_by_id(PreId) of
		[] ->
			check_pre_task_is_finish(UserId, L);
		PreInfo ->
			if 
				PreInfo#ets_users_tasks.is_finish =:= 1 ->
				   true;
				true ->
					check_pre_task_is_finish(UserId, L)
			end
	end.
			
%% ----------------------------------------隔天任务刷新--------------------------------
refresh_repeat_task(UserId, LastDate, Now) ->
	case util:is_same_date(LastDate, Now) of
		true ->
			skip;
		false ->
			refresh_repeat_task1(UserId, Now)
	end.
	
refresh_repeat_task1(_UserId, Now) ->
%% 	case get_user_all_task(UserId) of
	case get_dic() of
		[] ->
			skip;
		List ->
			refresh_repeat_task2(List, Now)
	end.

refresh_repeat_task2(List, Now) ->
	F = fun(Info, TaskList) ->
				case refresh_repeat_task3(Info, Now) of
					{ok, NewInfo} ->
						[NewInfo|TaskList];
					_ ->
						TaskList
				end
		end,
	NewList = lists:foldl(F, [], List),
	{ok, NewList}.
				
refresh_repeat_task3(Info, Now) ->
	case util:is_same_date(Info#ets_users_tasks.finish_date, Now) of
		true ->
			skip;
		false ->
				Template = data_agent:task_template_get(Info#ets_users_tasks.task_id),
				if Template#ets_task_template.can_repeat =/= 1  ->
					   false;
				   Info#ets_users_tasks.is_finish =:= 1 orelse Info#ets_users_tasks.is_exist =:= 0 orelse Info#ets_users_tasks.task_id >= ?MIN_TOKEN_TASK_ID  ->
			
					   NewInfo = Info#ets_users_tasks{
													  repeat_count = Template#ets_task_template.repeat_count,
													  finish_date = Now
													  },
%% 					   update_task(Info, NewInfo),
					   update_dic(NewInfo),
					   {ok, NewInfo};
				   true -> %% 任务进行中
					   NewInfo = Info#ets_users_tasks{
													  repeat_count = Template#ets_task_template.repeat_count - 1,
													  finish_date = Now
													  },
%% 					   update_task(Info, NewInfo),
					   update_dic(NewInfo),
					   {ok, NewInfo}
				end
	end.
	
					
%%------------------------------- 运镖  -------------------------------



%%更新押镖信息
set_escort_info(Player, NewState, FinishTime) ->
	{EscortState, Color} = case NewState rem 5 of
		0 -> 
			{0, ?_LANG_TASK_CARGO_COLOR_WHITE};
		1 ->
			{1, ?_LANG_TASK_CARGO_COLOR_GREEN};
		2 ->
			{2, ?_LANG_TASK_CARGO_COLOR_BLUE};
		3 ->
			{3, ?_LANG_TASK_CARGO_COLOR_PURPLE};
		4 ->%%拿到紫色镖车，全服通告
%% 			ChatAllStr = ?GET_TRAN(?_LANG_CHAT_ACCEPT_PURPLE_CAR, [Player#ets_users.nick_name]),
%% 			lib_chat:chat_sysmsg([?CHAT,?None,?ORANGE, ChatAllStr]),
			{4, ?_LANG_TASK_CARGO_COLOR_ORANGE};
		_ ->
			""
	end,
	
	%%接镖成功增加的hp、mp
	gen_server:cast(Player#ets_users.other_data#user_other.pid, {'update_escort_info', FinishTime, 30, 0, 0, EscortState}).
	
%% 	%%聊天系统中显示接镖信息
%% 	ChatStr = ?GET_TRAN(?_LANG_CHAT_ACCEPT_DARTS, [Color]),
%% 	lib_chat:chat_sysmsg_pid([Player#ets_users.other_data#user_other.pid_send, ?ROLL, ?None, ?ORANGE, ChatStr]).

%%----------------------- 刷新镖车相关操作 ---------------------------

%% 刷新镖车
transport_add(PlayerStatus,IsAutoRef, NeedQuality) ->
	if
		IsAutoRef =/= 0 andalso IsAutoRef =/=1 ->
			NewIsAutoRef = 0;
		true ->
			NewIsAutoRef = IsAutoRef
	end,

	{Timers,IsSuc,NewQuality} =  transport_add1(PlayerStatus,0, NewIsAutoRef,NeedQuality,0,PlayerStatus#ets_users.escort_id,1),
	NewPlayerStatus = PlayerStatus#ets_users{escort_id = NewQuality },
	db_agent_user:update_transport_quality(NewQuality,PlayerStatus#ets_users.id),
	{ok,NewPlayerStatus,IsSuc,Timers,Timers * ?REFRESH_COPPER}.
		



transport_add1(_PlayerStatus,IsSuc,_IsAutoRef,_NeedQuality,Timers,NewQuality,0) ->
	{Timers,IsSuc,NewQuality};

transport_add1(PlayerStatus,IsSuc,IsAutoRef,NeedQuality,Timers,NewQuality,1) ->
	case check_transport_add(PlayerStatus,IsAutoRef,NeedQuality,NewQuality,Timers) of
		{ok} ->
			
			RandomPer = util:rand(0, 100),
			Success = 
				if 
					PlayerStatus#ets_users.escort_id =:= 0 andalso RandomPer =< 80 ->
						true;
					PlayerStatus#ets_users.escort_id =:= 1 andalso RandomPer =< 60 ->
						true;
					PlayerStatus#ets_users.escort_id =:= 2 andalso RandomPer =< 50 ->
						true;
					PlayerStatus#ets_users.escort_id =:= 3 andalso RandomPer =< 20 ->
						true;					
					true ->
						false
				end,
			case Success of
				true ->
					NewIsSuc = 1,
					NewQuality1 = NewQuality + 1;
				_ ->
					NewIsSuc = IsSuc,
					NewQuality1 = NewQuality
			end,
			transport_add1(PlayerStatus,NewIsSuc,IsAutoRef,NeedQuality,Timers+1,NewQuality1,IsAutoRef);
		_ ->
			transport_add1(PlayerStatus,IsSuc,IsAutoRef,NeedQuality,Timers,NewQuality,0)
	end.
		
			
%% 判断镖车是否已经是先达到需求,铜币
check_transport_add(PlayerStatus,IsAutoRef,NeedQuality,TempQuality,Timers) ->
	case (IsAutoRef =:= 0 andalso TempQuality >= 4 ) orelse (IsAutoRef =:= 1 andalso TempQuality >= NeedQuality) of
		true -> 
			{false, 1};
		_ ->
			case (PlayerStatus#ets_users.bind_copper + PlayerStatus#ets_users.copper) - ?REFRESH_COPPER * (Timers + 1) >= 0 of
				true ->
					{ok};
				_ ->
					{false, 2}
			end
	end.

	


%%----------------------- 抢镖 ------------------------
%%角色被攻击
check_attacked(PlayerId) ->
	skip.
%% 	case Player#ets_users.darts_left_time > 0 of
%% 		true ->
%% 			%%镖被抢时在个人中心发求救
%% 			skip;
%% 		_ ->
%% 			skip
%% 	end.
%%角色被击毙,即镖车被抢
check_dead(Player, AttackerPid, AttName, AttType) -> 
	gen_server:cast(Player#ets_users.other_data#user_other.pid_task, {'check_player_dead', Player, AttackerPid, AttName, AttType}).

check_player_dead(Player, AttackerPid, AttName, AttType) ->
	case get_escort_task() of
		%% 直接查出user_task
		{ok, UserTask} ->
			TaskTemp = data_agent:task_template_get(UserTask#ets_users_tasks.task_id),
			StateInfo = lists:nth(UserTask#ets_users_tasks.state+1, TaskTemp#ets_task_template.other_data#other_task_template.states),
			AwardExp = StateInfo#ets_task_state_template.award_exp,
			AwardCopper = StateInfo#ets_task_state_template.award_copper,
			
			{NewAwardExp,NewAwardCopper } = case gen_server:call(mod_active:get_active_pid(), {is_active_open, ?ESCORT_ACTIVE_ID}) of
				true ->
					{round(AwardExp * ?ESCORT_EXP_TIMES), round(AwardCopper * ?ESCORT_COPPER_TIMES)};
				_ ->
					{AwardExp, AwardCopper}
			end,
		
			gen_server:cast(Player#ets_users.other_data#user_other.pid, {'kill_escort', AttackerPid, AttName, NewAwardExp, NewAwardCopper, AttType}),
			
			OtherTask = UserTask#ets_users_tasks.other_data#other_task{condition = TaskTemp#ets_task_template.condition},
			LastInfo = UserTask#ets_users_tasks{
								   is_exist = 1,
								   is_finish = 1,
								   finish_date = misc_timer:now_seconds(),
								   other_data = OtherTask
								  },
			update_dic(LastInfo),
			{ok, LastInfo};
		{error, Reason}->
			{error, Reason}
	end.
%%----------------------- 神魔令 ---------------------
%%接受神魔令任务
accept_shenmo(UserId, PlayerPid, PidSend, Level, Sex, Camp, Career, TaskId, TaskState, ShenmoTimes) ->
	case data_agent:task_template_get(TaskId) of
		[] ->
			{error, "?_LANG_TASK_ADD_NOT_EXIST"};
		Template ->
			accept_shenmo2(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes, Level, Sex, Camp, Career) 
	end.
%% 1男2女
accept_shenmo2(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes, Level, Sex, Camp, Carrer)->
	BSex  = case Sex == 1 of
			 true ->
				 1;
			 _ ->
				 2
		 end,
	Now = misc_timer:now_seconds(),
	if 
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.begin_date > Now ->
			{error, "?_LANG_TASK_ADD_BEGIN_DATE" };
		Template#ets_task_template.time_limit =:= 1 andalso Template#ets_task_template.end_date < Now ->
			{error, "?_LANG_TASK_ADD_END_DATE"};
		Template#ets_task_template.min_level > Level ->
			{error, "?_LANG_TASK_ADD_MIN_LEVEL"};
		Template#ets_task_template.max_level < Level ->
			{error, "?_LANG_TASK_ADD_MAX_LEVEL"};
		Template#ets_task_template.sex =/= -1 andalso Template#ets_task_template.sex =/= BSex ->
			{error, "?_LANG_TASK_ADD_NOT_SEX"};
		Template#ets_task_template.camp =/= -1 andalso Template#ets_task_template.camp =/= Camp ->
			{error, "?_LANG_TASK_ADD_NOT_CAMP"};
		Template#ets_task_template.career =/= -1 andalso Template#ets_task_template.career =/= Carrer ->
			{error, "?_LANG_TASK_ADD_NOT_CAREER"};
		true ->
			accept_shenmo3(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes)
	end.
%%判断前置任务是否已完成
accept_shenmo3(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes) ->
	if 
		length(Template#ets_task_template.other_data#other_task_template.pre_task_list) > 0 ->
			case check_pre_task_is_finish(UserId, Template#ets_task_template.other_data#other_task_template.pre_task_list) of
				false ->
					{error, "?_LANG_TASK_ADD_PRE_TASK"};
				true ->
					 accept_shenmo5(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes)
			end;
		true ->
			 accept_shenmo5(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes)
	end.

accept_shenmo5(UserId, PlayerPid, PidSend, Template, TaskState, ShenmoTimes)->
	 case get_task_by_id(Template#ets_task_template.task_id) of
		 [] ->
			 accept_shenmo6(UserId, PlayerPid, Template, undefined, TaskState, ShenmoTimes);
		 Info ->
			 if
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.is_finish =:= 0 ->
					 {error, "?_LANG_TASK_ADD_HAS_ACCEPT"};
				 Info#ets_users_tasks.is_exist =:= 1 andalso Info#ets_users_tasks.is_finish =:= 1 
				   andalso Template#ets_task_template.can_repeat == 0 ->
					 {error, "?_LANG_TASK_ADD_NOT_REPEAT"};
				 Info#ets_users_tasks.is_exist =:= 1 andalso ShenmoTimes > Template#ets_task_template.repeat_count ->
					 ShenmoMaxStr = ?GET_TRAN(?_LANG_TASK_SHENMO_MAX_TIMES, [Template#ets_task_template.repeat_count]),
					 lib_chat:chat_sysmsg_pid([PidSend, ?FLOAT, ?None, ?ORANGE, ShenmoMaxStr]),
					 {error, "_LANG_TASK_SHENMO_MAX_TIMES"};
				 true ->
					 accept_shenmo6(UserId, PlayerPid, Template, Info, TaskState, ShenmoTimes)
			 end
	 end.

%%判断传入的任务
accept_shenmo6(UserId, PlayerPid, Template, Info, TaskState, ShenmoTimes) ->
	StateCount = length(Template#ets_task_template.other_data#other_task_template.states),
	case TaskState < StateCount of
		true ->
			accept_shenmo7(UserId, PlayerPid, Template, Info, TaskState, ShenmoTimes);
		_ ->
			{error, "error: the input TaskState is out of index"}
	end.

accept_shenmo7(UserId, PlayerPid, Template, Info, TaskState, ShenmoTimes) ->
	Now = misc_timer:now_seconds(),
	if 
		length(Template#ets_task_template.other_data#other_task_template.states) >0 ->
			StateInfo = lists:nth(TaskState+1, Template#ets_task_template.other_data#other_task_template.states),
			Requires = StateInfo#ets_task_state_template.other_data#other_task_template_state.target_amounts;
		true ->
			Requires =[]
	end,
	
	StrRequires = change_require_count(Requires),
	case Info of
		undefined ->
			Other = #other_task{
						is_new=1,
						requires = Requires,
						condition= Template#ets_task_template.condition
						},
			NewInfo = #ets_users_tasks{
									   task_id = Template#ets_task_template.task_id,
									   user_id = UserId,
									   repeat_count = Template#ets_task_template.repeat_count - 1,
									   finish_date = Now,
									   state = TaskState,
									   is_trust = 0,
									   is_exist = 1,
									   is_finish = 0,
									   require_count = StrRequires,
									   other_data = Other
									  };
		_ ->
			Other = #other_task{
						is_new=1,
						requires = Requires,
						dirty_state = 1,
						condition= Template#ets_task_template.condition
						},
			
%% 			           //新的一天则重新更新
			RepeatDay = util:get_diff_days(Info#ets_users_tasks.finish_date, Now),
			RepeatCount = case RepeatDay >= Template#ets_task_template.repeat_day of
								  true ->
									  Template#ets_task_template.repeat_count;
								  _ ->
									  Info#ets_users_tasks.repeat_count
							  end,
			
			%% todo 任务已经在数据库存在，进行了更新
			NewInfo = #ets_users_tasks{
									   task_id = Template#ets_task_template.task_id,
									   user_id = UserId,
%% 									   repeat_count = Info#ets_users_tasks.repeat_count - 1,
									   repeat_count = RepeatCount - 1,
									   finish_date = Now,
									   state = TaskState,
									   is_exist = 1,
									   is_trust = 0,
									   is_finish = 0,
									   require_count = StrRequires,
									   other_data = Other
									  }
	end,
	lib_statistics:add_task_log(Template#ets_task_template.task_id, 1, Template#ets_task_template.type),
	%%更新神魔令使用次数
	gen_server:cast(PlayerPid, {'update_shenmo_times', ShenmoTimes+1}),
	
	case ShenmoTimes+1 >= Template#ets_task_template.repeat_count of
		true ->
			case get_same_tasks(NewInfo#ets_users_tasks.task_id, ?TASK_SHENMO) of
				[] ->
					skip;
				EscortTasks ->
					Fun2 = fun(Elem) ->
						NewElem = Elem#ets_users_tasks{repeat_count = 0},
						update_dic(NewElem)
					end,
					lists:foreach(Fun2, EscortTasks)
			end,
			TaskInfo = NewInfo#ets_users_tasks{repeat_count = 0};
		_ ->
			TaskInfo = NewInfo,
			skip
	end,
	check_need_items(TaskInfo, true),
	update_dic(TaskInfo),
	{ok, TaskInfo}.
%%----------------------------------------------------
%%更改任务状态
client_control(TaskId, ReqireCount) ->
	case get_task_by_id(TaskId) of
		[] ->
			{error, "task is not exist"};
		Info when Info#ets_users_tasks.is_exist =:=1 
		  andalso Info#ets_users_tasks.is_finish =:= 0
		  andalso Info#ets_users_tasks.is_trust =:= 0 ->
			client_control1(Info, ReqireCount);
		_ ->
			{error, "task is exeption"}
	end.
client_control1(Info, RequireCount) ->
 	case data_agent:task_template_get(Info#ets_users_tasks.task_id) of
		[] ->
			{error, "template is not exist"};
		Template ->
			client_control2(Info, Template,RequireCount)
	end.
client_control2(Info, Template,RequireCount) ->
	StateInfo = lists:nth(Info#ets_users_tasks.state + 1 , 
						  Template#ets_task_template.other_data#other_task_template.states),
	case StateInfo#ets_task_state_template.condition == ?TASK_CLIENT_CONTROL of
		true ->
			StrRequires = change_require_count([RequireCount]),
			NewInfo = Info#ets_users_tasks{require_count=StrRequires},
			update_dic(NewInfo),
			{ok, NewInfo};
		_ ->
			{error, "condition is error"}
	end.

get_escort_info(FinishTime) ->
	case get_escort_task() of
		{ok, UserTask} ->
			case FinishTime > 0 of
				true ->
					Now = misc_timer:now_seconds(),
					{ok, UserTask#ets_users_tasks.task_id, FinishTime-Now, UserTask#ets_users_tasks.state};
				_ ->
					finish_escort_info(UserTask#ets_users_tasks.task_id),
					{error, "error: DartsLeftTime is 0, but the escort task is not finished"}
			end;
		{error, Msg} ->
			{error, Msg}
	end.

finish_escort_info(TaskId) ->
	case TaskId > 0 of
		true ->
			case get_task_by_id(TaskId) of
				[] ->
			 		skip;
				Info ->
					TaskInfo = Info#ets_users_tasks{is_finish = 1},
					update_dic(TaskInfo)
			end;
		_ ->
			skip
	end.
	
%%根据角色ID获取运镖任务
get_escort_task() ->
	List = get_dic(),
	FFun = fun(Elem, AccIn) ->
		case Elem#ets_users_tasks.is_exist =:=1 
		  	andalso Elem#ets_users_tasks.is_finish =:= 0
		  	andalso Elem#ets_users_tasks.is_trust =:= 0 of
			true ->
				[Elem|AccIn];
			_ ->
				AccIn
		end
	end,
	
	
	case lists:foldl(FFun, [], List) of
		[] ->
			{error, "error: not task for userId"};
		NewList ->
			Fun = fun(Elem, AccIn) ->
				case data_agent:task_template_get(Elem#ets_users_tasks.task_id) of
					[] ->
						AccIn;
					TaskTemp when TaskTemp#ets_task_template.condition =:= ?TASK_ESCORT_DARTS->
						[Elem|AccIn];
					_ ->
						AccIn
				end
			end,
			case lists:foldl(Fun, [], NewList) of
				[] ->
					{error, "error: not escort task for userId"};
				TaskList ->
					{ok, lists:nth(1, TaskList)}
			end
	end.

%% 玩家重新登录时初始运镖时间计数器
init_escort_time(TaskPid, FinishTime) ->
	gen_server:cast(TaskPid, {'init_escort_info', FinishTime}).

%%运镖任务，如果任务的重复次数到达最大值，则将全部repeatCount清为0
update_escort_tasks(EscortTasks, CurrInfo, MaxRepeatCount) ->
	Fun = fun(Elem, AccIn) ->
		AccIn + (MaxRepeatCount-Elem#ets_users_tasks.repeat_count)
	end,
	Count = lists:foldl(Fun, 0, [CurrInfo|EscortTasks]),
	case Count >= MaxRepeatCount of
		true ->	
			Fun2 = fun(Elem) ->
				NewElem = Elem#ets_users_tasks{
											   repeat_count = 0,
												finish_date = CurrInfo#ets_users_tasks.finish_date
												},
				update_dic(NewElem)
			end,
			lists:foreach(Fun2, EscortTasks),
			CurrInfo#ets_users_tasks{repeat_count = 0};
		_ ->
			Fun3 = fun(Elem) ->
				NewElem = Elem#ets_users_tasks{
											   finish_date = CurrInfo#ets_users_tasks.finish_date
												},
				update_dic(NewElem)
			end,
			lists:foreach(Fun3, EscortTasks),
			CurrInfo
	end.

%%获取同种类型任务中repeat_count字段不为0的任务，如运镖、神魔令任务
get_same_tasks(TaskId, TaskCondition) ->
	List = get_dic(),
	FFun = fun(Elem, AccIn) ->
		case Elem#ets_users_tasks.task_id =/= TaskId
			andalso Elem#ets_users_tasks.repeat_count > 0 
			andalso Elem#ets_users_tasks.other_data#other_task.condition =:= TaskCondition of
			true ->
				[Elem|AccIn];
			_ ->
				AccIn
		end
	end,
	lists:foldl(FFun, [], List).

%%充值
%% recharge() ->
%% 	List = get_dic(),
%% 	Fun = fun(Elem, AccIn) ->
%% 		case data_agent:task_template_get(Elem#ets_users_tasks.task_id) of
%% 			[] ->
%% 				AccIn;
%% 			TaskTemp->
%% 				if 
%% 					length(TaskTemp#ets_task_template.other_data#other_task_template.states) >0 ->
%% 					   StateInfo = lists:nth(1, TaskTemp#ets_task_template.other_data#other_task_template.states),
%% 					   case StateInfo#ets_task_state_template.condition =:= ?TASK_RECHARGE of
%% 						   true ->
%% 							   TaskInfo = Elem#ets_users_tasks{require_count = "0"},
%% 							   update_dic(TaskInfo),
%% 							   [TaskInfo|AccIn];
%% 						   _ ->
%% 							   AccIn
%% 					   end;
%% 					true ->
%% 						AccIn
%% 				end
%% 		end
%% 	end,
%% 	{ok, lists:foldl(Fun, [], List)}.

%%根据任务分类取消所接的任务
cancel_task_by_condition() ->
	List = get_dic(),
	NotFinishFun = fun(Elem, AccIn) ->
		case Elem#ets_users_tasks.is_finish == 0 
			andalso Elem#ets_users_tasks.is_exist == 1 of
			true ->
				[Elem|AccIn];
			_ ->
				AccIn
		end
	end,
	NotFinishList = lists:foldl(NotFinishFun, [], List),
	Fun = fun(Elem, AccIn) ->
		case data_agent:task_template_get(Elem#ets_users_tasks.task_id) of
			[] ->
				AccIn;
			TaskTemp when TaskTemp#ets_task_template.type =:= ?TASK_TYPE_GUILD ->
				TaskInfo = Elem#ets_users_tasks{is_exist = 0},
				update_dic(TaskInfo),
				[TaskInfo|AccIn];
			_ ->
				AccIn
		end
	end,
	{ok, lists:foldl(Fun, [], NotFinishList)}.
%%====================================================================
%% Private functions
%%====================================================================


