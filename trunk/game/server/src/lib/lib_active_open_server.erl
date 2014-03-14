%% Author: liaoxiaobo
%% Created: 2013-6-19
%% Description: TODO: Add description to lib_active_open_server
-module(lib_active_open_server).

%%
%% Include files
%%
-include("common.hrl").

-define(DIC_USERS_ACTIVITY_OPEN_SERVER,dic_users_activity_open_server).


-define(PAY_TYPE,0). 		%% 充值
-define(USE_TYPE,1).  		%% 消耗
-define(LEVELUP_TYPE,7).  	%% 升级
-define(SINGLE_PAY_TYPE,4). %% 单笔充值
-define(VIP_TYPE,5).  		%% VIP
-define(EQUIP_TYPE,6).  	%% 紫装
-define(PAY_TYPE1,8).  	   %% 单日充值


%%
%% Exported Functions
%%
-export([
		 init_template/0,
		 init_user_activity_open_server/1,
		 user_pay/2,
		 user_use/2,
		 user_level_up/2,
		 user_single_pay/2,
		 use_vip/2,
		 user_equip/2,
		 get_all/0,
		 get_award/3,
		 get_max_single/1
		 ]).

%%
%% API Functions
%%

%% ------------------------初始化模板数据 start--------------------------
init_template() ->
	Now = misc_timer:now_seconds(),
	DiffDates = util:get_diff_days(config:get_service_start_time(), Now) + 1,
	
	F = fun(Info) ->
				  Record = list_to_tuple([ets_activity_open_server_template] ++ (Info)),
				  if
					  Record#ets_activity_open_server_template.time_type =:= 0 ->
						  Other = #other_activity_open_server_template{
																   start_time = Record#ets_activity_open_server_template.start_time,
																   end_time = Record#ets_activity_open_server_template.end_time
																  };
					  Record#ets_activity_open_server_template.time_type =:= 2 ->
						  Other = #other_activity_open_server_template{
																   start_time = Now,
																   end_time = Now + (1000 * 24*60*60)
																  };
					  true ->
						  if
							  Record#ets_activity_open_server_template.start_time >= DiffDates ->
								  EndTime = util:get_next_day_seconds(Now + (Record#ets_activity_open_server_template.start_time -DiffDates) * 24*60*60);
							  true ->
								  EndTime = util:get_next_day_seconds(Now + (Record#ets_activity_open_server_template.start_time -DiffDates) * 24*60*60)
						  end,
						  Other = #other_activity_open_server_template{
																   start_time = Now,
																   end_time = EndTime
																  }
				  end,
				  NewRecord = Record#ets_activity_open_server_template{other_data = Other},
                  ets:insert(?ETS_ACTIVITY_OPEN_SERVER_TEMPLATE, NewRecord)
           end,
    case db_agent_template:get_activity_open_server_template() of
        [] -> skip;
        List when is_list(List) ->
            lists:foreach(F, List);
        _ -> skip
    end,
	ok.




%% ------------------------初始化模板数据 end--------------------------

%% 初始化用户数据
init_user_activity_open_server(UserId) ->
	Now = misc_timer:now_seconds(), 
	%% 检查过期的
	case db_agent_user:get_user_activity_open_server(UserId) of
		[] ->
			List = [];
		List1 ->
			F1 = fun(Info1) ->
						 Record = list_to_tuple([ets_users_open_server] ++ (Info1)),
						 ReIds = tool:split_string_to_intlist1(Record#ets_users_open_server.rewards_ids),
						 Other =  #other_open_server{is_new = 0},
						 Record#ets_users_open_server{ rewards_ids = ReIds,other_data = Other}
				 end,
			List = [F1(X) || X <- List1]
	end,
	%% 初始化 活动组的数据
	TemplateList = ets:tab2list(?ETS_ACTIVITY_OPEN_SERVER_TEMPLATE),
	F = fun(Info,L) ->
				case lists:keyfind(Info#ets_activity_open_server_template.group_id, #ets_users_open_server.group_id, L) of
					false ->
						Other = #other_open_server{is_new = 1,
												   end_time = Info#ets_activity_open_server_template.other_data#other_activity_open_server_template.end_time },
						NewInfo = #ets_users_open_server{user_id = UserId,
													 type = Info#ets_activity_open_server_template.type,
													 group_id = Info#ets_activity_open_server_template.group_id,
													 rewards_ids = [],
													 other_data = Other
													},
						[NewInfo | L];
					Info1 ->
						Other = Info1#ets_users_open_server.other_data#other_open_server{
																						 end_time = Info#ets_activity_open_server_template.other_data#other_activity_open_server_template.end_time
																						},
						NewInfo = Info1#ets_users_open_server{ other_data = Other},
						lists:keyreplace(Info#ets_activity_open_server_template.group_id, #ets_users_open_server.group_id, L, NewInfo)
					
				end
		end,
	NewList = lists:foldl(F, List, TemplateList),
	update_dic(NewList).



%% 充值
user_pay(Num,PlayerStatus) ->
	{List,AllList} = get_activity_by_type(?PAY_TYPE),
	add_num(PlayerStatus,AllList,List,Num),
	{List1,AllList1} = get_activity_by_type(?PAY_TYPE1),
	add_num(PlayerStatus,AllList1,List1,Num).

%% 消耗元宝
user_use(Num,PlayerStatus) ->
	{List,AllList} = get_activity_by_type(?USE_TYPE),
	add_num(PlayerStatus,AllList,List,Num).

%% 升级
user_level_up(Num,PlayerStatus) ->
	{List,AllList} = get_activity_by_type(?LEVELUP_TYPE),
	add_num(PlayerStatus,AllList,List,Num).

%% 单笔充值
user_single_pay(Num,PlayerStatus) ->
	{List,AllList} = get_activity_by_type(?SINGLE_PAY_TYPE),
	case get_max_single(Num) of
		0 ->
			skip;
		ID ->
			case lists:keyfind(ID, #ets_users_open_server.group_id, List) of
				false ->
					skip;
				Info ->
					add_num(PlayerStatus,AllList,[Info],Num)
			end
	end.


get_max_single(Num) ->
	Pattern = #ets_activity_open_server_template{type = ?SINGLE_PAY_TYPE, _='_'},
	L = ets:match_object(?ETS_ACTIVITY_OPEN_SERVER_TEMPLATE,Pattern),
	List = case is_list(L) of
        true -> L;
        false -> []
    end,
	
	F = fun(L1, L2) ->
				L1#ets_activity_open_server_template.need_num > L2#ets_activity_open_server_template.need_num
		end,
	List1 = lists:sort(F, List),
	get_max_single(List1,{Num,0}).


get_max_single([],{_Num,ID}) ->
	ID;
get_max_single([H|T],{Num,_ID}) ->
	if
		Num >= H#ets_activity_open_server_template.need_num ->
			get_max_single([],{Num,H#ets_activity_open_server_template.group_id});
		true ->
			get_max_single(T,{Num,0})
	end.


%% VIP
use_vip(Num,PlayerStatus) ->
	{List,AllList} = get_activity_by_type(?VIP_TYPE),
	add_num(PlayerStatus,AllList,List,Num).

%% 紫装
user_equip(Num,PlayerStatus) ->
	{List,AllList} = get_activity_by_type(?EQUIP_TYPE),
	add_num(PlayerStatus,AllList,List,Num).


	
%% 奖励为多个物品
get_award(PlayerStatus,Gorup_ID,Id) ->
	List = get_all(),
	case lists:keyfind(Gorup_ID, #ets_users_open_server.group_id, List) of
		false ->
			{false,?_LANG_ACTIVITY_COLLECT_FAIL};
		Info ->
			case get_award1(PlayerStatus,List,Info,Gorup_ID,Id) of
				{true,NewList,Count} ->
					update_dic(NewList),
					{true,Count};
				{false,Msg} ->
					{false,Msg}
			end
	end.


get_award1(PlayerStatus,List,Info,Gorup_ID,Id) ->
	Now = misc_timer:now_seconds(), 
	RewardsIds = Info#ets_users_open_server.rewards_ids,
	case lists:any(fun(X) -> X =:= Id end , RewardsIds) of
		true ->
			{false,?_LANG_ACTIVITY_HAS_GET};
		_ ->
			TemplateInfo = data_agent:activity_open_server_template_get(Id),
			NullCells = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_null_cells'}),
			if 
				length(NullCells) >= 1 ->
					case TemplateInfo#ets_activity_open_server_template.type of
						?SINGLE_PAY_TYPE ->
							if
								Info#ets_users_open_server.num > 0 
								  andalso Now >= TemplateInfo#ets_activity_open_server_template.other_data#other_activity_open_server_template.start_time 
								  andalso Now =< TemplateInfo#ets_activity_open_server_template.other_data#other_activity_open_server_template.end_time ->
									get_award2(TemplateInfo#ets_activity_open_server_template.item,PlayerStatus),
									NewNum = Info#ets_users_open_server.num-1,
									NewInfo = Info#ets_users_open_server{num = NewNum},
									db_agent_user:update_user_activity_open_server(1,NewInfo),
									NewList = lists:keyreplace(Gorup_ID, #ets_users_open_server.group_id, List, NewInfo),
									{true,NewList,NewNum};
								true ->
									{false,?_LANG_ACTIVITY_COLLECT_FAIL}
							end;
						_ ->
							if
								Info#ets_users_open_server.num >= TemplateInfo#ets_activity_open_server_template.need_num
								  andalso Now >= TemplateInfo#ets_activity_open_server_template.other_data#other_activity_open_server_template.start_time 
								  andalso Now =< TemplateInfo#ets_activity_open_server_template.other_data#other_activity_open_server_template.end_time ->
									get_award2(TemplateInfo#ets_activity_open_server_template.item,PlayerStatus),
									NewRewardsIds = [ Id | RewardsIds],
									%% 更新数据库
									NewRewardsIdStr = tool:intlist_to_string_2(NewRewardsIds),
									db_agent_user:update_user_activity_open_server_wards(NewRewardsIdStr,PlayerStatus#ets_users.id,Gorup_ID),
									NewInfo = Info#ets_users_open_server{rewards_ids = NewRewardsIds },
									NewList = lists:keyreplace(Gorup_ID, #ets_users_open_server.group_id, List, NewInfo),
									{true,NewList,0};
								true ->
									{false,?_LANG_ACTIVITY_COLLECT_FAIL}
							end
					end;
				true ->
					{false,?_LANG_DAILY_AWARD_ITEM_ERROR}
			end
	end.

%% 物品奖励	   
get_award2(TemplateId,PlayerStatus) ->
	if
		TemplateId =/= 0 ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,
							{'activity_open_server_add_item',
							TemplateId
							});
		true ->
			skip
	end.



%%
%% Local Functions
%%



get_activity_by_type(Type) ->
	List = get_all(),
	F = fun(Info,L) ->
				if
					Info#ets_users_open_server.type =:= Type ->
						[Info | L];
					true ->
						L
				end
		end,
	{lists:foldl(F, [], List),List}.
						   
update_dic(List)->
	put(?DIC_USERS_ACTIVITY_OPEN_SERVER,List).


get_all() ->
	case get(?DIC_USERS_ACTIVITY_OPEN_SERVER) of 
		undefined ->
			[];
		List ->
			List
	end.

%% 类型分组
check_type(Type) ->
	case Type of
		?LEVELUP_TYPE ->
			0;
		?SINGLE_PAY_TYPE ->
			3;
		?EQUIP_TYPE ->
			0;
		?VIP_TYPE ->
			2;
		?PAY_TYPE1 ->
			4;
		_ ->
			1
	end.


%% 添加数据
add_num(PlayerStatus,AllList,List,Num) ->
	Now = misc_timer:now_seconds(), 
	F = fun(Info,L) ->
				case check_type(Info#ets_users_open_server.type) of
					0 ->
						LastDate = Now,
						RIDS = Info#ets_users_open_server.rewards_ids,
						if
							Info#ets_users_open_server.num > Num ->
								NewNum = Info#ets_users_open_server.num;
							true ->
								NewNum = Num
						end;
					2 ->
						LastDate = Now,
						RIDS = Info#ets_users_open_server.rewards_ids,
						if
							Info#ets_users_open_server.group_id =:= 50 + Num ->
								NewNum = Num;
							true ->
								NewNum = Info#ets_users_open_server.num
						end;
					3 ->
						LastDate = Now,
						RIDS = Info#ets_users_open_server.rewards_ids,
						NewNum = Info#ets_users_open_server.num+1;
					4 ->
						IsSameDate =  util:is_same_date_new(Info#ets_users_open_server.last_date ,Now),
						LastDate = Now,
						
						case IsSameDate of
							true ->
								RIDS = Info#ets_users_open_server.rewards_ids,
								NewNum = Info#ets_users_open_server.num + Num;
							_ ->
								RIDS = [],
								NewNum = Num
						end;
					_ ->
						NewNum = Info#ets_users_open_server.num + Num,
						RIDS = Info#ets_users_open_server.rewards_ids,
						LastDate = Now
				end,
				if
					Info#ets_users_open_server.other_data#other_open_server.is_new =:= 1 ->
						Other = Info#ets_users_open_server.other_data#other_open_server{is_new = 0 },
						%% 更新数据库
						NewInfo = Info#ets_users_open_server{num = NewNum,rewards_ids = RIDS,last_date = LastDate,other_data = Other},
						db_agent_user:update_user_activity_open_server(0,NewInfo);
					true ->
						%% 更新数据库
						NewInfo = Info#ets_users_open_server{num = NewNum,rewards_ids = RIDS,last_date = LastDate},
						db_agent_user:update_user_activity_open_server(1,NewInfo)
				end,
						
				[NewInfo | L]
		end,
	UpdateList = lists:foldl(F, [], List),
	F1 = fun(Info,List) ->
			lists:keyreplace( Info#ets_users_open_server.group_id, #ets_users_open_server.group_id, List, Info)
	end,
	NewList = lists:foldl(F1, AllList, UpdateList),
	
	{ok,Bin} = pt_20:write(?PP_PLAYER_ACTIVE_OPEN_SERVER,UpdateList),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
	
	
	case lists:keyfind(1, #ets_users_open_server.group_id, NewList) of
		false ->
			NewList1 = NewList;
		Info1 when (Info1#ets_users_open_server.num> 0 andalso Info1#ets_users_open_server.rewards_ids =:=[]) ->
			NewList1 = case get_award1(PlayerStatus,NewList,Info1,1,1) of
						   {true,NewList2,_} ->
							   {ok,Bin1} = pt_20:write(?PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD,[1,1,1]),
								lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin1),
							   
							   NewList2;
						   _ ->
							   NewList
					   end;
		_ ->
			NewList1 = NewList
	end,
			
	update_dic(NewList1).





