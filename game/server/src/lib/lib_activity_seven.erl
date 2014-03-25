%% Author: liaoxiaobo
%% Created: 2013-8-1
%% Description: TODO: Add description to lib_activity_seven
-module(lib_activity_seven).

%%
%% Include files
%%

-include("common.hrl").

-define(DIC_ACTIVITY_SEVEN,dic_activity_seven).


-define(SEVENTH_DAY, 	2#1000000).				%% 第七天
-define(SIXTH_DAY, 		2#100000).				%% 第六天
-define(FIFTH_DAY, 		2#10000).				%% 第五天
-define(FOURTH_DAY, 	2#1000).				%% 第四天
-define(THIRD_DAY, 		2#100).					%% 第三天
-define(SECOND_DAY, 	2#10).					%% 第二天
-define(FIRST_DAY, 		2#1).					%% 第一天



%%
%% Exported Functions
%%
-export([
		 init_template/0,
		 init_data/0,
		 get_all/0,
		 update/1,
		 get_reward/2,
		 get_day_reward/1
		]).

%%
%% API Functions
%%

update_dic(List)->
	put(?DIC_ACTIVITY_SEVEN,List).


get_all() ->
	case get(?DIC_ACTIVITY_SEVEN) of 
		undefined ->
			[];
		List ->
			List
	end.

init_template() ->
	Now = misc_timer:now_seconds(),
	DiffDates = util:get_diff_days(config:get_service_start_time(), Now) + 1,
	
	F1 = fun({T,C,I}, List) ->
				 [{{T,C}, I} |  List]
		end,
	
	F = fun(Info) ->
			  Record = list_to_tuple([ets_activity_seven_template] ++ (Info)),
			  Awards = tool:split_string_to_intlist(Record#ets_activity_seven_template.awards),
			  
			  NewAwards = lists:foldl(F1 , [], Awards),
			  
			  EndTime = util:get_next_day_seconds(Now + (Record#ets_activity_seven_template.end_time -DiffDates) * 24*60*60),
			  NewRecord = Record#ets_activity_seven_template{end_time = EndTime,awards = NewAwards},
              ets:insert(?ETS_ACTIVITY_SEVEN_TEMPLATE, NewRecord)
		end,
    case db_agent_template:get_activity_seven_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.

init_data() ->
	Now = misc_timer:now_seconds(), 
	case db_agent_user:get_activity_seven_data() of
		[] ->
			List = [];
		List1 ->
			F1 = fun(Info1) ->
						 Record = list_to_tuple([ets_activity_seven_data] ++ (Info1)),
%% 						 ?DEBUG("~w",[Record#ets_activity_seven_data.top_three]),
						 TopThree = split_string_to_intlist(Record#ets_activity_seven_data.top_three, "|", ","),
						 F2 = fun({UserID,NickName,Num,IsGet}) ->
									  list_to_tuple([activity_seven_data] ++ ([UserID,NickName,Num,IsGet]))
							  end,
						 TopThree1 = [F2(X) || X <- TopThree],
						 Record#ets_activity_seven_data{ top_three = TopThree1}
				 end,
			List = [F1(X) || X <- List1]
	end,
	%% 初始化 活动组的数据
	TemplateList = ets:tab2list(?ETS_ACTIVITY_SEVEN_TEMPLATE),
	F = fun(Info,L) ->
				IsEnd = if
							Info#ets_activity_seven_template.end_time =< Now ->
								1;
							true ->
								0
						end,
				case lists:keyfind(Info#ets_activity_seven_template.id, #ets_activity_seven_data.id, L) of
					false ->
						%%插入到数据库
						NewInfo = #ets_activity_seven_data{id = Info#ets_activity_seven_template.id, 
														   top_three = [],   
														   is_end = IsEnd},
						db_agent_user:insert_activity_seven_data(NewInfo),
						[NewInfo | L];
					Info1 ->
						NewInfo = Info1#ets_activity_seven_data{ is_end = IsEnd},
						lists:keyreplace(Info#ets_activity_seven_template.id, #ets_activity_seven_data.id, L, NewInfo)
				end
		end,
	NewList = lists:foldl(F, List, TemplateList),
%% 	?DEBUG("~w",[NewList]),
	update_dic(NewList),
	ok.


	
%%领取奖励 
%% get_reward(PlayerStatus,ID) ->
%% 	List = get_all(),
%% 	case lists:keyfind(ID, #ets_activity_seven_data.id, List) of
%% 		false ->
%% 			{false,?_LANG_ACTIVITY_COLLECT_FAIL};
%% 		Info ->
%% 			if
%% 				Info#ets_activity_seven_data.is_end =/= 1 ->
%% 					{fale,?_LANG_ACTIVITY_HAS_GET};
%% 				true ->
%% 					get_reward1(PlayerStatus,Info)
%% 			end
%% 	end.

get_reward(PlayerStatus,_ID) ->
	Now = misc_timer:now_seconds(), 
	DiffDates = util:get_diff_days(PlayerStatus#ets_users.register_date, Now) + 1,%%config:get_service_start_time(),
	ID = DiffDates,
			case ID of
				1 ->
					if
						PlayerStatus#ets_users.level >= 45 -> %% 等级达到40级
							get_reward1(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL1}
					end;
				2 ->
					if
						PlayerStatus#ets_users.fight >= 20000 -> %% 角色战斗力等级12000
							get_reward1(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL2}
					end;
				3 ->
					case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_fight_mounts'}) of
						{false} ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL3};
						{ok,Info} when Info#ets_users_mounts.fight >= 15000 ->
							get_reward1(PlayerStatus,ID);
						_ ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL4}
					end;
				4 ->
					PetFight = case lib_pet:get_fight_pet() of
						undefined ->
							-1;
						Info when is_record(Info, ets_users_pets) ->
							Info#ets_users_pets.fight;
						_ ->
							0
						end,
					if
						PetFight =:= -1 ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL5};
						PetFight >= 20000 ->
							get_reward1(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL6}
					end;
				5 -> %% 气海
					MaxVeinsLeve = lib_veins:get_max_gengu_level(PlayerStatus),
					case MaxVeinsLeve of
						V when V>=35 ->
							get_reward1(PlayerStatus,ID);
						_ ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL7}
					end;
				6 -> %% 武器强化 完美5
					case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{get_item_strengLv, 6}) of
						{V} when V>=700 ->
							get_reward1(PlayerStatus,ID);
						_ ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL8}
					end;
						
				7 ->
					if
						PlayerStatus#ets_users.money >= 5000 ->
							get_reward1(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL9}
					end;
				_ ->
					{false,?_LANG_ACTIVITY_ERROR}			
			end.

get_reward1(PlayerStatus,ID) ->
	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
	TemplateInfo = data_agent:activity_seven_template_get(ID),
	if 
		length(NullCells) >= 1 ->
			Value = 1 bsl ID,
			if
				PlayerStatus#ets_users.seven_award2_id band Value =:= 0 ->
					case lists:keyfind({PlayerStatus#ets_users.career,1}, 1, TemplateInfo#ets_activity_seven_template.awards) of
						{_,TemplateId} ->
							gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,
									{'activity_seven_add_item',
									 [{TemplateId,1}]});
						_ ->
							skip
					end,
					NewAwardId = PlayerStatus#ets_users.seven_award2_id bor Value,
					NewPlayerStatus = PlayerStatus#ets_users{seven_award2_id = NewAwardId},
					{ok,NewPlayerStatus};
				true ->
					{false,?_LANG_ACTIVITY_HAS_GET}
			end;			
		true ->
			{false,?_LANG_DAILY_AWARD_ITEM_ERROR}
	end.

%% get_reward1(PlayerStatus,Info) ->
%% 	List = Info#ets_activity_seven_data.top_three,
%% 	case lists:keyfind(PlayerStatus#ets_users.id, #activity_seven_data.user_id, List) of
%% 		false ->
%% 			{false,?_LANG_ACTIVITY_COLLECT_FAIL};
%% 		Top ->
%% 			if
%% 				Top#activity_seven_data.is_get =:= 0 ->
%% 					get_reward2(PlayerStatus,Info,Top);
%% 				true ->
%% 					{false,?_LANG_ACTIVITY_HAS_GET}			
%% 			end
%% 	end.

%% get_reward2(PlayerStatus,Info,Win) ->
%% 	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
%% 	TemplateInfo = data_agent:activity_seven_template_get(Info#ets_activity_seven_data.id),
%% 	if 
%% 		length(NullCells) >= 1 ->
%% 			NewWin = Win#activity_seven_data{is_get = 1},
%% 			NewTopThree = lists:keyreplace(PlayerStatus#ets_users.id,#activity_seven_data.user_id, Info#ets_activity_seven_data.top_three, NewWin),
%% 			
%% 			NewInfo = Info#ets_activity_seven_data{top_three = NewTopThree},
%% 			db_agent_user:update_activity_seven_data(NewInfo),
%% 			
%% 			[One,Two,Three] = Info#ets_activity_seven_data.top_three,
%% 			T = if
%% 					One#activity_seven_data.user_id =:= PlayerStatus#ets_users.id ->
%% 						1;
%% 					Two#activity_seven_data.user_id =:= PlayerStatus#ets_users.id ->
%% 						2;
%% 					Three#activity_seven_data.user_id =:= PlayerStatus#ets_users.id ->
%% 						3;
%% 					true ->
%% 						3
%% 				end,
%% 			case lists:keyfind({T,PlayerStatus#ets_users.career}, 1, TemplateInfo#ets_activity_seven_template.awards) of
%% 				{_,TemplateId} ->
%% 					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,
%% 									{'activity_seven_add_item',
%% 									 [{TemplateId,1}]});
%% 				_ ->
%% 					skip
%% 			end,
%% 			List = get_all(),
%% 			NewList = lists:keyreplace(NewInfo#ets_activity_seven_data.id, #ets_activity_seven_data.id, List, NewInfo),
%% 			update_dic(NewList),
%% 			{ok,NewInfo};
%% 		true ->
%% 			{false,?_LANG_DAILY_AWARD_ITEM_ERROR}
%% 	end.


%% 全民奖励
get_day_reward(PlayerStatus) ->
	Now = misc_timer:now_seconds(), 
	DiffDates = util:get_diff_days(PlayerStatus#ets_users.register_date, Now) + 1,%%config:get_service_start_time(),
	ID = DiffDates,
			case ID of
				1 ->
					if
						PlayerStatus#ets_users.level >= 43 -> %% 等级达到40级
							get_reward2(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL1}
					end;
				2 ->
					if
						PlayerStatus#ets_users.fight >= 13500 -> %% 角色战斗力等级12000
							get_reward2(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL2}
					end;
				3 ->
					case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_fight_mounts'}) of
						{false} ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL3};
						{ok,Info} when Info#ets_users_mounts.fight >= 10000 ->
							get_reward2(PlayerStatus,ID);
						_ ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL4}
					end;
				4 ->
					PetFight = case lib_pet:get_fight_pet() of
						undefined ->
							-1;
						Info when is_record(Info, ets_users_pets) ->
							Info#ets_users_pets.fight;
						_ ->
							0
						end,
					if
						PetFight =:= -1 ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL5};
						PetFight >= 13500 ->
							get_reward2(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL6}
					end;
				5 -> %% 气海
					MaxVeinsLeve = lib_veins:get_max_gengu_level(PlayerStatus),
					case MaxVeinsLeve of
						V when V>=16 ->
							get_reward2(PlayerStatus,ID);
						_ ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL7}
					end;
				6 -> %% 武器强化 完美5
					case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{get_item_strengLv, 5}) of
						{V} when V>=600 ->
							get_reward2(PlayerStatus,ID);
						_ ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL8}
					end;
						
				7 ->
					if
						PlayerStatus#ets_users.money >= 50 ->
							get_reward2(PlayerStatus,ID);
						true ->
							{false,?_LANG_ACTIVITY_COLLECT_FAIL9}
					end;
				_ ->
					{false,?_LANG_ACTIVITY_ERROR}			
			end.

get_reward2(PlayerStatus,ID) ->
	NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
	TemplateInfo = data_agent:activity_seven_template_get(ID),
	if 
		length(NullCells) >= 1 ->
			Value = 1 bsl ID,
			if
				PlayerStatus#ets_users.seven_award_id band Value =:= 0 ->
					
					if
						TemplateInfo#ets_activity_seven_template.item =:= 2 ->
							BindYuanbao = TemplateInfo#ets_activity_seven_template.count;
						true ->
							BindYuanbao = 0,
							gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,
								{'activity_seven_add_item',
								[{TemplateInfo#ets_activity_seven_template.item,TemplateInfo#ets_activity_seven_template.count}] })
					end,
					
					NewAwardId = PlayerStatus#ets_users.seven_award_id bor Value,
					NewPlayerStatus = PlayerStatus#ets_users{seven_award_id = NewAwardId},
					{ok,NewPlayerStatus,BindYuanbao};
				true ->
					{false,?_LANG_ACTIVITY_HAS_GET}
			end;
		true ->
			{false,?_LANG_DAILY_AWARD_ITEM_ERROR}
	end.



%% 排行更新时才更新
%% update(TopLists) ->
%% 	F = fun({Id,TopList}) ->
%% 				update_1(Id,TopList)
%% 		end,
%% 	lists:foreach(F, TopLists),
	
%% 	F1 = fun(Info) ->
%% 			  list_to_tuple([activity_seven_data] ++ (Info))             
%% 		end,
%%     case db_agent_user:get_top_money() of
%%         [] -> skip;
%%         List when is_list(List) ->
%%             List1 = [F1(X) || X <- List],
%% 			update_1(1,List1);
%%         _ -> skip
%%     end.

update({Id,TopList}) ->
	update_1(Id,TopList).
	
	

update_1(Id,TopList) ->
	List = get_all(),   
	Now = misc_timer:now_seconds(), 
	F = fun(I,List) ->
				
				 TemplateInfo = data_agent:activity_seven_template_get(I#ets_activity_seven_data.id),
				 if
					 TemplateInfo#ets_activity_seven_template.end_time =< Now ->
						 NewInfo = I#ets_activity_seven_data{is_end =1},
						 db_agent_user:update_activity_seven_data(NewInfo),
						 [NewInfo|List];
					 true ->
						 [I|List]
				 end
		end,
	NewList = lists:foldl(F, [], List),
	TemplateInfo = data_agent:activity_seven_template_get(Id),
	
	
	
	case lists:keyfind(Id, #ets_activity_seven_data.id, NewList) of
		false ->
			update_dic(NewList);
		Info ->
			NewInfo = Info#ets_activity_seven_data{top_three = TopList},
			db_agent_user:update_activity_seven_data(NewInfo),
			NewList1 = lists:keyreplace(NewInfo#ets_activity_seven_data.id, #ets_activity_seven_data.id, NewList, NewInfo),
			update_dic(NewList1)			
	end.


split_string_to_intlist(SL, Split1, Split2) ->
	NewSplit1 = tool:to_list(Split1),
 	NewSplit2 = tool:to_list(Split2),
	SList = string:tokens(tool:to_list(SL), NewSplit1),
	F = fun(X,L) -> 
			case string:tokens(X, NewSplit2) of
				[M,N,O,P] ->
					{V1,_} = string:to_integer(M),
					V2 = N,
					{V3,_} = string:to_integer(O),
					{V4,_} = string:to_integer(P),
					[{V1,V2,V3,V4}|L];			
				
				_ ->
					L
			end 
		end,
	lists:foldr(F,[],SList).




%%
%% Local Functions
%%

