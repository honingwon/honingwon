%% Author: Administrator
%% Created: 2011-5-19
%% Description: TODO: Add description to lib_statistics
-module(lib_statistics).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").


%%--------------------------------------------------------------------
%% External exports
-export([insert_task_log/0, update_task_log/3, add_task_log/3, add_map_player/2,
		 insert_online/0,stop_global_server/0, stop_local_server/0, insert_login_log/6,
		 insert_strength_log/0, add_strengthen_log/6, update_strenthen_log/6, 
		 insert_compose_log/0, add_compose_log/4, update_compose_log/4,
		 insert_enchase_log/0, add_enchase_log/6, update_enchase_log/6, 
		 insert_magic_log/0, add_magic_log/6, update_magic_log/6,
		 insert_rebuild_log/0, add_rebuild_log/7, update_rebuild_log/7, add_rebuild_log/2, 
		 add_pk_log/6, update_pk_log/6, insert_pk_log/0,
		 add_trade_log/7, update_trade_log/7, insert_trade_log/0,
		 add_consume_yuanbao_log/9, update_consume_yuanbao_log/9, insert_consume_yuanbao_log/0,
		 insert_consume_copper_log/0,add_consume_copper_log/8,update_consume_copper_log/8,
		 add_item_log/3, update_item_log/1, insert_item_log/1,
		 insert_hole_log/4, add_hole_log/4, init_multexp_rate/0,
		 set_multexp/1,get_sys_multexp_rate/1]).

-define(DIC_TASKS_LOG, dic_tasks_log). 					%% 任务日志字典
-define(DIC_COMPOSE_LOG, dic_compose_log). 				%% 合成日志字典
-define(DIC_STRENGTH_LOG, dic_strength_log). 			%% 强化日志字典
-define(DIC_ENCHASE_LOG, dic_enchase_log).				%% 镶嵌/摘取日志字典
-define(DIC_REBUILD_LOG, dic_rebuild_log).				%% 洗练日志字典
-define(DIC_PK_LOG, dic_pk_log).						%% PK日志字典
-define(DIC_CONSUME_YUANBAO_LOG, dic_consume_yuanbao_log).		%% 元宝行为日志日志字典
-define(DIC_CONSUME_COPPER_LOG, dic_consume_copper_log).		%% 铜币行为日志日志字典
-define(DIC_TRADE_LOG, dic_trade_log).					%% 交易日志
-define(DIC_ITEM_LOG, dic_item_log).					%% 物品消耗/产出日志
-define(DIC_MAGIC_LOG, dic_magic_log).					%% 魔法箱子日志

%%
%% Exports Functions
%%
%%停止单节点统计进程
stop_local_server() ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'stop_server'}).

%%停止全局节点进程
stop_global_server() ->
	Global_Statistics_pid = mod_global_statistics:get_mod_global_statistics_pid(),
	gen_server:cast(Global_Statistics_pid,{'stop_server'}).

%%添加登入登出日志
insert_login_log(UserId, Login_Time, 0, IP, Career, Level) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'login_log', UserId, Login_Time, 0, IP, Career, Level}).
	
%%添加在线人数记录
insert_online() ->
	TotalCount = misc_admin:get_online_count(num),
	Now = misc_timer:now(),
	LinuxNow = misc_timer:now_seconds(),
	{{Y,Month,D},{H,Minute,_S}} = calendar:now_to_local_time(Now),
	db_agent_admin:insert_online(TotalCount, LinuxNow, Y, Month, D, H, Minute).

%%更新任务日志
add_task_log(Id, State, Type) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_task_log', Id, State, Type}).

%%更新任务日志 State(任务状态) 1接受 2完成 3放弃
update_task_log(TaskId, State, Type) ->
	List = get_dic(?DIC_TASKS_LOG),
		case lists:keyfind({TaskId, State}, 
						   #task_log.log_flag, List) of
					false ->
						NewInfo = #task_log{task_id = TaskId, task_state = State, task_type = Type, count = 1,
											log_flag = {TaskId, State}},
						NewList = [NewInfo|List];
					Old ->
						List1 = lists:keydelete({TaskId, State}, #task_log.log_flag, List),	
						NewInfo = Old#task_log{count = Old#task_log.count + 1 },	
						NewList = [NewInfo|List1]	
				end,
	put(?DIC_TASKS_LOG, NewList).

%%保存任务日志（计数器）
insert_task_log() ->
	List = get_dic(?DIC_TASKS_LOG),
	insert_task_log1(List, [], misc_timer:now_seconds()).

insert_task_log1([], LeftList, _Time) ->
	put(?DIC_TASKS_LOG, LeftList);

insert_task_log1([Info|List], LeftList, Time) ->
	Ret = db_agent_admin:insert_task_log(Info, Time),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_task_log1(List, New_LeftList , Time).

%%更新合成日志
add_compose_log(CreateLevel, IsSuccess, Stone_count, Compose_count) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_compose_log', CreateLevel, IsSuccess, Stone_count, Compose_count}).

%%更新合成日志 State(任务状态) 1接受 2完成 3放弃
update_compose_log(CreateLevel, IsSuccess, Stone_count, Compose_count) ->
	List = get_dic(?DIC_COMPOSE_LOG),
	case lists:keyfind(CreateLevel, 
					   #compose_log.compose_level, List) of
		false ->
			NewInfo = #compose_log{compose_level = CreateLevel, success_count = IsSuccess, count = 1,
								   stone_count = Stone_count, compose_count = Compose_count},
			NewList = [NewInfo|List];
		Old ->
			List1 = lists:keydelete(CreateLevel, #compose_log.compose_level, List),	
			NewInfo = Old#compose_log{compose_count = Old#compose_log.compose_count + Compose_count, 
									  count = Old#compose_log.count + 1,
									  stone_count = Old#compose_log.stone_count,
									  success_count = Old#compose_log.success_count + IsSuccess},	
			NewList = [NewInfo|List1]	
	end,
	put(?DIC_COMPOSE_LOG, NewList).

%%合成任务日志（计数器）
insert_compose_log() ->
	List = get_dic(?DIC_COMPOSE_LOG),
	insert_compose_log1(List, [], misc_timer:now_seconds()).

insert_compose_log1([], LeftList, _Time) ->
	put(?DIC_COMPOSE_LOG, LeftList);

insert_compose_log1([Info|List], LeftList, Time) ->
	Ret = db_agent_admin:insert_compose_log(Info, Time),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_compose_log1(List, New_LeftList , Time).

%%保存强化日志
add_strengthen_log(UserID, Level, LuckNum, IsProtect, Strength_Level, IsSuccess) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_strenthen_log',  UserID, Level, LuckNum, IsProtect, IsSuccess, Strength_Level}).

%%更新强化日志 
update_strenthen_log(UserID, Level, LuckNum, IsProtect, IsSuccess, Strength_Level) ->
	List = get_dic(?DIC_STRENGTH_LOG),
	NewInfo = #strength_log{user_id = UserID, level = Level, luck_num = LuckNum,
							is_protect = IsProtect, is_success = IsSuccess, strength_level = Strength_Level},
	put(?DIC_STRENGTH_LOG, [NewInfo|List]).

%%强化日志
insert_strength_log() ->
	List = get_dic(?DIC_STRENGTH_LOG),
	insert_strength_log1(List, [], misc_timer:now_seconds()).

insert_strength_log1([], LeftList, _Time) ->
	put(?DIC_STRENGTH_LOG, LeftList);

insert_strength_log1([Info|List], LeftList, Time) ->
	Ret = db_agent_admin:insert_strength_log(Info, Time),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_strength_log1(List, New_LeftList , Time).

%%保存镶嵌日志
add_enchase_log(UserID, Type, HoleNum, CategoryId, StoneId, Level) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_enchase_log',  UserID, Type, HoleNum, CategoryId, StoneId, Level}).

%%更新镶嵌日志 
update_enchase_log(UserID, Type, HoleNum, CategoryId, StoneId, Level) ->
	List = get_dic(?DIC_ENCHASE_LOG),
	NewInfo = #enchase_log{user_id = UserID, type = Type, hole_num = HoleNum,
							category_id = CategoryId, stone_id = StoneId, level = Level},
	put(?DIC_ENCHASE_LOG, [NewInfo|List]).

%%镶嵌日志
insert_enchase_log() ->
	List = get_dic(?DIC_ENCHASE_LOG),
	insert_enchase_log1(List, [], misc_timer:now_seconds()).

insert_enchase_log1([], LeftList, _Time) ->
	put(?DIC_ENCHASE_LOG, LeftList);

insert_enchase_log1([Info|List], LeftList, Time) ->
	Ret = db_agent_admin:insert_enchase_log(Info, Time),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_enchase_log1(List, New_LeftList , Time).

%%更新洗练日志
add_rebuild_log(DataList, TemplateID) ->
	ItemTemplate = data_agent:item_template_get(TemplateID),
	Attribute_Num = length(DataList),
	Quality = ItemTemplate#ets_item_template.quality,
	Free_Data = tool:split_string_to_intlist(ItemTemplate#ets_item_template.free_property),
	{_, Star_one, Star_two, Star_three, Star_four, Star_five} = lists:foldl(
																  
	fun(Info, {List, One, Two, Three, Four, Five, Six, Seven, Eight, Night}) ->
			{Type, Value} = Info,
			{_, FreeValue} = lists:keyfind(Type, 1, List),
			Star = tool:ceil(Value / (FreeValue / 5)),
			case Star of
				1 ->
					{List, One + 1, Two, Three, Four, Five};
				2 ->
					{List, One, Two + 1, Three, Four, Five};
				3 ->
					{List, One, Two, Three + 1, Four, Five};
				4 ->
					{List, One, Two, Three, Four + 1, Five};
				_ ->
					{List, One, Two, Three, Four, Five + 1}
			end
	end, {Free_Data, 0, 0, 0, 0, 0, 0, 0, 0, 0}, DataList),
	add_rebuild_log(Quality, Attribute_Num, Star_one, Star_two, Star_three, Star_four, Star_five).
	
	
add_rebuild_log(Quality, Attribute_Num, Star_one, Star_two, Star_three, Star_four, Star_five) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_rebuild_log', Quality, Attribute_Num, Star_one, Star_two, Star_three, Star_four, Star_five}).

%%更新洗练日志 
update_rebuild_log(Quality, Attribute_Num, Star_one, Star_two, Star_three, Star_four, Star_five) ->
	List = get_dic(?DIC_REBUILD_LOG),
		case lists:keyfind({Quality, Attribute_Num}, 				  
						   #rebuild_log.log_flag, List) of
					false ->
						NewInfo = #rebuild_log{quality = Quality, attribute_num = Attribute_Num, count = 1, one_star = Star_one,
											   two_star = Star_two, three_star = Star_three, four_star = Star_four,
											   five_star = Star_five, log_flag = {Quality, Attribute_Num}},
						NewList = [NewInfo|List];
					Old ->
						List1 = lists:keydelete({Quality, Attribute_Num}, #rebuild_log.log_flag, List),	
						NewInfo = Old#rebuild_log{count = Old#rebuild_log.count + 1, 
												  one_star = Old#rebuild_log.one_star + Star_one,
												  two_star = Old#rebuild_log.two_star + Star_three,
												  four_star = Old#rebuild_log.four_star + Star_four,
												  five_star = Old#rebuild_log.five_star + Star_five},	
						NewList = [NewInfo|List1]	
				end,
	put(?DIC_REBUILD_LOG, NewList).

%%保存洗练日志（计数器）
insert_rebuild_log() ->
	List = get_dic(?DIC_REBUILD_LOG),
	insert_rebuild_log1(List, [], misc_timer:now_seconds()).

insert_rebuild_log1([], LeftList, _Time) ->
	put(?DIC_REBUILD_LOG, LeftList);

insert_rebuild_log1([Info|List], LeftList, Time) ->
	Ret = db_agent_admin:insert_rebuild_log(Info, Time),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_rebuild_log1(List, New_LeftList , Time).


%%保存打孔日志
add_hole_log(UserID, Level, HoleNum, IsSuccess) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'save_hole_log', UserID, Level, HoleNum, IsSuccess}).

insert_hole_log(UserID, Level, HoleNum, IsSuccess) ->
	db_agent_admin:insert_hole_log(UserID, Level, HoleNum, IsSuccess).

%%保存PK日志
add_pk_log(Killer_id, Killer_Lv, Killer_PK, Dead_id, Dead_Lv, Drops) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_pk_log', Killer_id, Killer_Lv, Killer_PK, Dead_id, Dead_Lv, Drops}).

%%更新pk日志 
update_pk_log(Killer_id, Killer_Lv, Killer_PK, Dead_id, Dead_Lv, Drops) ->
	List = get_dic(?DIC_PK_LOG),
	NewInfo = #pk_log{killer_id = Killer_id, killer_level = Killer_Lv, killer_pk = Killer_PK,
					  dead_id = Dead_id, dead_level = Dead_Lv,
					  utime = misc_timer:now_seconds(), drops = Drops},
	put(?DIC_PK_LOG, [NewInfo|List]).

%%pk日志
insert_pk_log() ->
	List = get_dic(?DIC_PK_LOG),
	insert_pk_log1(List, []).

insert_pk_log1([], LeftList) ->
	put(?DIC_PK_LOG, LeftList);

insert_pk_log1([Info|List], LeftList) ->
	Ret = db_agent_admin:insert_pk_log(Info),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_pk_log1(List, New_LeftList).

%%添加元宝消费日志
add_consume_yuanbao_log(Uid, YuanBao, Bind_Yuanbao, Is_Consume, Type, Time, Template_id, Amount, Level) ->
		if YuanBao > 0 orelse Bind_Yuanbao > 0 ->
			   Statistics_pid = mod_statistics:get_mod_statistics_pid(),
			   gen_server:cast(Statistics_pid,{'update_consume_yuanbao_log', Uid, YuanBao, Bind_Yuanbao, Is_Consume, Type, Time, Template_id, Amount, Level});
		   true ->
			   skip                                                         
		end.
 
%%添加铜币消费日志
add_consume_copper_log(UID, Copper, Bind_Copper, Type, Time, Template_id, Amount, Level) ->
	if Copper > 0 orelse Bind_Copper > 0 ->
			   Statistics_pid = mod_statistics:get_mod_statistics_pid(),
			   gen_server:cast(Statistics_pid,{'update_consume_copper_log', UID, Copper, Bind_Copper, Type, Time, Template_id, Amount, Level});
		   true ->
			   skip                                                         
		end.

%%更新元宝消费日志 
update_consume_yuanbao_log(UID, YuanBao, Bind_Yuanbao, Is_Consume, Type, Time, Template_id, Amount, Level) ->
	List = get_dic(?DIC_CONSUME_YUANBAO_LOG),
	NewInfo = #consume_yuanbao_log{user_id = UID,						
								  yuanbao = YuanBao,						
								  bind_yuanbao = Bind_Yuanbao,					
								  is_consume = Is_Consume,				
								  type = Type,						
								  utime = Time,						
								  template_id = Template_id,					
								  amount = Amount,
								  level = Level},
	put(?DIC_CONSUME_YUANBAO_LOG, [NewInfo|List]).
%%更新铜币消费日志
update_consume_copper_log(UID, Copper, Bind_Copper, Type, Time, Template_id, Amount, Level) ->
	List = get_dic(?DIC_CONSUME_COPPER_LOG),
	NewInfo = #consume_copper_log{user_id = UID,						
								  copper = Copper,						
								  bind_copper = Bind_Copper,				
								  type = Type,						
								  utime = Time,						
								  template_id = Template_id,					
								  amount = Amount,
								  level = Level},
	put(?DIC_CONSUME_COPPER_LOG, [NewInfo|List]).

%%元宝消费日志
insert_consume_yuanbao_log() ->
	List = get_dic(?DIC_CONSUME_YUANBAO_LOG),
	insert_consume_yuanbao_log1(List, []).

insert_consume_yuanbao_log1([], LeftList) ->
	put(?DIC_CONSUME_YUANBAO_LOG, LeftList);
insert_consume_yuanbao_log1([Info|List], LeftList) ->
	Ret = db_agent_admin:insert_consume_yuanbao_log(Info),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_consume_yuanbao_log1(List, New_LeftList).

%%铜币消费日志
insert_consume_copper_log() ->
	List = get_dic(?DIC_CONSUME_COPPER_LOG),
	insert_consume_copper_log1(List, []).

insert_consume_copper_log1([], LeftList) ->
	put(?DIC_CONSUME_COPPER_LOG, LeftList);
insert_consume_copper_log1([Info|List], LeftList) ->
	Ret = db_agent_admin:insert_consume_copper_log(Info),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_consume_copper_log1(List, New_LeftList).

%%添加交易日志
add_trade_log(FID, First_Copper, First_Itmes, SID, Second_Copper, Second_Itmes, Trade_Date) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_trade_log', FID, First_Copper, First_Itmes, SID, Second_Copper, Second_Itmes, Trade_Date}).

%%更新交易日志 
update_trade_log(FID, First_Copper, First_Items, SID, Second_Copper, Second_Itmes, Trade_Date) ->
	List = get_dic(?DIC_TRADE_LOG),
	NewInfo = #trade_log{
						 first_trade_id = FID,						
						 first_trade_copper = First_Copper,						
						 first_trade_items = First_Items,					
						 second_trade_id = SID,				
						 second_trade_copper = Second_Copper,						
						 second_trade_items = Second_Itmes,						
						 trade_date = Trade_Date},
	put(?DIC_TRADE_LOG, [NewInfo|List]).

%%元宝消费日志
insert_trade_log() ->
	List = get_dic(?DIC_TRADE_LOG),
	insert_trade_log1(List, []).

insert_trade_log1([], LeftList) ->
	put(?DIC_TRADE_LOG, LeftList);

insert_trade_log1([Info|List], LeftList) ->
	Ret = db_agent_admin:insert_trade_log(Info),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_trade_log1(List, New_LeftList).

%%添加地图在线人数
add_map_player(Map_id, Amount) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'add_map_player', Map_id, Amount}).

%%保存物品消耗日志
%% add_item_consume_log(UserId,ItemId,TemplateId,Type,Amount,UseNum,Level) ->
%% 	Res = lists:keyfind(TemplateId, 1, ?ITEM_LOG_FILTER_LIST),
%% 	if	
%% 		Res =:= false ->
%% 					Statistics_pid = mod_statistics:get_mod_statistics_pid(),
%% 					gen_server:cast(Statistics_pid,{'update_item_log',UserId,ItemId,TemplateId,Type,Amount,UseNum,Level});
%% 		true ->
%% 					skip
%% 	end.	

%%保存物品消耗/产出日志
add_item_log(Template_ID, Type, Count) ->
	case data_agent:item_template_get(Template_ID) of 
		LogTemplate when is_record(LogTemplate, ets_item_template) ->	
			Res = lists:keyfind(LogTemplate#ets_item_template.category_id, 1, ?EQUIP_LIST),
			if 
				LogTemplate#ets_item_template.quality > 0 andalso Res =/= false ->
					Statistics_pid = mod_statistics:get_mod_statistics_pid(),
					gen_server:cast(Statistics_pid,{'update_item_log', Type, LogTemplate#ets_item_template.quality, Count});
				true ->
					skip
			end;
		_ ->
			skip
	end.


%%更新物品日志 Type: 1掉落 2使用获得 3任务获得 4分解消失 5出售消失 6丢弃消失
update_item_log(ItemLog) ->
	List = get_dic(?DIC_ITEM_LOG),	
	put(?DIC_ITEM_LOG, [ItemLog|List]).

%%物品日志
insert_item_log(Time) ->
	List = get_dic(?DIC_ITEM_LOG),
	insert_item_log1(List, Time, []).

insert_item_log1([], _Time, LeftList) ->
	put(?DIC_ITEM_LOG, LeftList);
insert_item_log1([Info|List], Time, LeftList) ->
	case is_record(Info,item_log) of
		true ->
			Ret = db_agent_admin:insert_item_log(Info, Time),	
			case Ret of 
			1 ->
				New_LeftList = LeftList;
			_er ->
				New_LeftList = [Info|LeftList]
			end,
			insert_item_log1(List, Time, New_LeftList);
		false ->
			insert_item_log1(List, Time, LeftList)
	end.
	

%%保存魔法日志
add_magic_log(UserID,Count, Type, Template_ID, Amount, Utime) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'add_magic_log',  UserID,Count, Type, Template_ID, Amount, Utime}).

%%更新魔法日志 
update_magic_log(UserID,Count, Type, Template_ID, Amount, Utime) ->
	List = get_dic(?DIC_MAGIC_LOG),
	
	case lists:keyfind({Type, Template_ID,UserID},   #magic_log.log_flag, List) of
		false ->
			NewInfo = #magic_log{user_id = UserID,count = Count, type = Type, amount = Amount, template_id = Template_ID, utime = Utime,
											log_flag = {Type, Template_ID,UserID}},
			NewList = [NewInfo|List];
		Old ->
			List1 = lists:keydelete({Type, Template_ID,UserID}, #magic_log.log_flag, List),
			NewInfo = Old#magic_log{count = Old#magic_log.count + Count , amount = Old#magic_log.amount + Amount },	
			NewList = [NewInfo|List1]	
	end,
	put(?DIC_MAGIC_LOG, NewList).


%%插入魔法日志
insert_magic_log() ->
	List = get_dic(?DIC_MAGIC_LOG),
	insert_magic_log1(List, []).

insert_magic_log1([], LeftList) ->
	put(?DIC_MAGIC_LOG, LeftList);

insert_magic_log1([Info|List], LeftList) ->
	Ret = db_agent_admin:insert_magic_log(Info),
	case Ret of 
		1 ->
			New_LeftList = LeftList;
		_ ->
			New_LeftList = [Info|LeftList]
	end,
	insert_magic_log1(List, New_LeftList).

%%设置系统多倍经验
set_multexp({ID, IsOpen, Exp_rate, Begin_date, Wnd_date, Begin_time, End_time}) ->
	Statistics_pid = mod_statistics:get_mod_statistics_pid(),
	gen_server:cast(Statistics_pid,{'update_multexp', {ID, IsOpen, Exp_rate, Begin_date, Wnd_date, Begin_time, End_time}}).

%%系统重启初始化多倍经验
init_multexp_rate() ->
	get_sys_multexp_rate(db_agent_admin:get_all_multexp()).
	
get_sys_multexp_rate(OldList) ->
	if
		OldList =:= [] ->
			{0,[]};
		true ->
			Now = misc_timer:now_seconds(),
			Linux_Now = misc_timer:now(),
			{{_Y,_Month,_D},{H,_Minute,_S}} = calendar:now_to_local_time(Linux_Now),
			[Final_Rate, Exp_List] =
				lists:foldl( fun(Info1, [Rate, List]) ->
						  Info = tool:to_tuple(Info1),
						  {_ID, Exp_rate, Begin_date, End_date, Begin_time, End_time} = Info,
						  if End_date < Now ->
								 [Rate, List];
						    Now > Begin_date  andalso H > Begin_time   andalso H < End_time ->
								[Rate * Exp_rate / 10, [Info|List]];
							 true ->
								 [Rate, [Info|List]]
						  end
				  end, [1, []], OldList),			
			{Final_Rate, Exp_List}
	end.

%%
%% Local Functions
%%
get_dic(Dic) ->
	case get(Dic) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.