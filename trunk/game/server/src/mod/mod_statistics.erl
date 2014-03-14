%% Author: Administrator
%% Created: 2011-5-10
%% Description: TODO: Add description to mod_statistics
-module(mod_statistics).

-define(Scan_Tick, 60 * 1000).							%% 模块扫描，1分钟

-define(Consume_Copper_Ticks, 1).						%% 铜币记录，1分钟
-define(Strength_Log_Ticks, 1).							%% 强化人数，1分钟
-define(Enchase_Log_Ticks, 2).							%% 镶嵌人数，2分钟
-define(Consume_YuanBao_Ticks, 3).						%% 元宝记录，3分钟
-define(Pk_Log_Ticks, 4).								%% 战斗记录，4分钟
-define(Trade_Log_Ticks, 5).							%% 交易记录，5分钟
-define(Item_Log_Ticks,	6).								%% 物品日志，6分钟
-define(Magic_Log_Ticks, 7).							%% 魔法箱子，7分钟
-define(Compose_Log_Ticks, 8).							%% 合成任务，8分钟
-define(Rebuild_Log_Ticks, 9).							%% 洗练记录，9分钟
-define(Task_Log_Ticks,	10).	   						%% 任务记录，10分钟

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
-define(DIC_MAGIC_LGO, dic_item_log).					%% 魔法阵记录

%%
%% Include files
%%
-include("common.hrl").

%%
%% Exported Functions
%%
-export([start_link/0, start_mod_statistics/0, get_mod_statistics_pid/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
 
-record(state, {multexp_list = [], exp_rate = 0}).
%% Function: start_link/0
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%%启动统计监控模块 (加锁保证全局唯一)
start_mod_statistics() ->
	ProcessName = misc:create_process_name(statistics,[node()]),
	global:set_lock({ProcessName, undefined}),	
	ProcessPid =
		case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				case misc:is_process_alive(Pid) of
					true -> 
						Pid;
					false -> 
						start_statistics()
				end;
			_ ->
				start_statistics()
		end,	
	global:del_lock({ProcessName, undefined}),
	ProcessPid.

%%启动统计监控树模块
start_statistics() ->
	case supervisor:start_child(
       		server_sup, {mod_statistics,
            		{mod_statistics, start_link,[]},
               		permanent, 10000, supervisor, [mod_statistics]}) of
		{ok, Pid} ->
			Pid;
		_ ->
			undefined
	end.

get_mod_statistics_pid() ->
	ProcessName = misc:create_process_name(statistics,[node()]),
	case misc:whereis_name({global, ProcessName}) of
			Pid when is_pid(Pid) ->
				Pid;
			_ ->

				start_mod_statistics()
	end.

%%====================================================================
%% Callback functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%%--------------------------------------------------------------------
init([]) ->
	misc:write_monitor_pid(self(),?MODULE, {}),
	process_flag(trap_exit, true),
	ProcessName = misc:create_process_name(statistics,[node()]),
	misc:register(global, ProcessName, self()),
	
	put(?DIC_TASKS_LOG, []),
	put(?DIC_COMPOSE_LOG, []),
	put(?DIC_STRENGTH_LOG, []),
	put(?DIC_TRADE_LOG, []),
	put(?DIC_CONSUME_YUANBAO_LOG, []),
	put(?DIC_ENCHASE_LOG, []),	
	put(?DIC_PK_LOG, []),	
	put(?DIC_REBUILD_LOG, []),	
	erlang:send_after(?Scan_Tick, self(), {mod_scan, 0}),
	{Final_Rate, Multexp_List} = lib_statistics:init_multexp_rate(),
	{ok, #state{exp_rate = Final_Rate, multexp_list = Multexp_List}}.

%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_call(Info,_From, State) ->
	try
		do_call(Info,_From, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_statistics  handle_call is exception:~w~n,Info:~w",[Reason, Info]),
			{reply, ok, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_cast(Info, State) ->
	try
		do_cast(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_statistics  handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------
handle_info(Info, State) ->
	try
		do_info(Info, State)
	catch
		_:Reason ->
			?WARNING_MSG("mod_statistics  handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			{noreply, State}
	end.

%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
	misc:delete_monitor_pid(self()),
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------

%%---------------------do_call--------------------------------
%% 统一模块+过程调用(call)
do_call(Info, _, State) ->
	?WARNING_MSG("mod_statistics call is not match:~w",[Info]),
    {reply, ok, State}.

%%---------------------do_cast--------------------------------
%% 统一模块+过程调用(cast)
%%添加任务记录（计数器）
do_cast({'update_task_log', Task_id, Task_state, Task_type}, State) ->
	lib_statistics:update_task_log(Task_id, Task_state, Task_type),
	{noreply, State};

%%添加合成记录（计数器）
do_cast({'update_compose_log', CreateLevel, IsSuccess, Stone_count, Compose_count}, State) ->
	lib_statistics:update_compose_log(CreateLevel, IsSuccess, Stone_count, Compose_count),
	{noreply, State};

%%添加强化记录
do_cast({'update_strenthen_log', UserID, Level, LuckNum, IsProtect, IsSuccess, Strength_Level}, State) ->
	lib_statistics:update_strenthen_log(UserID, Level, LuckNum, IsProtect, IsSuccess, Strength_Level),
	{noreply, State};

%%添加镶嵌/摘取记录
do_cast({'update_enchase_log', UserID, Type, HoleNum, CategoryId, StoneId, Level}, State) ->
	lib_statistics:update_enchase_log(UserID, Type, HoleNum, CategoryId, StoneId, Level),
	{noreply, State};

%%添加洗练记录
do_cast({'update_rebuild_log', Quality, Attribute_Num, Star_one, Star_two, Star_three, Star_four, Star_five}, State) ->
	lib_statistics:update_rebuild_log(Quality, Attribute_Num, Star_one, Star_two, Star_three, Star_four, Star_five),
	{noreply, State};

%%添加PK记录
do_cast({'update_pk_log', Killer_id, Killer_Lv, Killer_PK, Dead_id, Dead_Lv, Drops}, State) ->
	lib_statistics:update_pk_log(Killer_id, Killer_Lv, Killer_PK, Dead_id, Dead_Lv, Drops),
	{noreply, State};

%%添加打孔记录
do_cast({'save_hole_log', UserID, Level, HoleNum, IsSuccess}, State) ->
	lib_statistics:insert_hole_log(UserID, Level, HoleNum, IsSuccess),
	{noreply, State};

%%添加元宝消费记录
do_cast({'update_consume_yuanbao_log', UID, YuanBao, Bind_Yuanbao, Is_Consume, Type, Time, Template_id, Amount, Level}, State) ->
	lib_statistics:update_consume_yuanbao_log(UID, YuanBao, Bind_Yuanbao, Is_Consume, Type, Time, Template_id, Amount, Level),
	{noreply, State};

%%添加铜币消耗记录
do_cast({'update_consume_copper_log', UID, Copper, Bind_Copper, Type, Time, Template_id, Amount, Level}, State) ->
	lib_statistics:update_consume_copper_log(UID, Copper, Bind_Copper, Type, Time, Template_id, Amount, Level),
	{noreply, State};

%%添加直接交易记录
do_cast({'update_trade_log', FID, First_Copper, First_Itmes, SID, Second_Copper, Second_Itmes, Trade_Date}, State) ->
	lib_statistics:update_trade_log(FID, First_Copper, First_Itmes, SID, Second_Copper, Second_Itmes, Trade_Date),
	{noreply, State};

%%添加地图在线人数
do_cast({'add_map_player', Map_id, Amount}, State) ->
	db_agent:insert_map_player(Map_id, Amount),
	{noreply, State};

%%添加物品消耗/产出记录
do_cast({'update_item_log', UserId,ItemId,TemplateId,Type,Amount,UseNum,Level}, State) ->
	Info = #item_log{user_id = UserId,
						 item_id = ItemId,
						 template_id = TemplateId,
						 type = Type,
						 amount = Amount,
						 usenum = UseNum,
						 time = misc_timer:now_seconds(),
						 level = Level},
	lib_statistics:update_item_log(Info),
	{noreply, State};

do_cast({'update_item_log', List}, State) ->
	List1 = get(?DIC_ITEM_LOG),
	put(?DIC_ITEM_LOG, List++List1),
	{noreply, State};

%%魔法箱子记录
do_cast({'add_magic_log', UserId,Count, Type, Template_ID, Amount, Utime}, State) ->
	lib_statistics:update_magic_log(UserId,Count, Type, Template_ID, Amount, Utime),
	{noreply, State};

%%登录记录
do_cast({'login_log', UserId, Login_Time, 0, IP, Career, Level}, State) ->
	db_agent_admin:insert_login_in_out(UserId, Login_Time, 0, IP, Career, Level),
	{noreply, State};

do_cast({'update_multexp', {ID, IsOpen, Exp_rate, Begin_date, End_date, Begin_time, End_time}}, State) ->
	case IsOpen of
		0 ->
			NewList =  lists:keydelete(ID, 1, State#state.multexp_list),
			NewState = State#state{multexp_list = NewList};
		_ ->
			NewState = State#state{multexp_list = [{ID,Exp_rate, Begin_date, End_date, Begin_time, End_time}
											 |State#state.multexp_list]}
	end,
	{noreply, NewState};

do_cast({'get_sys_multexp', Pid}, State) ->
	gen_server:cast(Pid, {'set_mulexp', State#state.exp_rate}),
	{noreply, State};

	
		
%%停止服务器
do_cast({'stop_server'}, State) ->
	Now = misc_timer:now_seconds(),
	lib_statistics:insert_strength_log(),
	lib_statistics:insert_task_log(),
	lib_statistics:insert_compose_log(),
	lib_statistics:insert_enchase_log(),
	lib_statistics:insert_rebuild_log(),
	lib_statistics:insert_pk_log(),
	lib_statistics:insert_consume_yuanbao_log(),
	lib_statistics:insert_consume_copper_log(),
	lib_statistics:insert_trade_log(),
	lib_statistics:insert_item_log(Now),
	lib_statistics:insert_magic_log(),	
	{stop, normal, State};

do_cast(Info, State) ->
	?WARNING_MSG("mod_statistics cast is not match:~w",[Info]),
    {noreply, State}.

%%---------------------do_info--------------------------------
%% 统一模块+过程调用(info)
do_info({mod_scan,Count}, State) ->
	erlang:send_after(?Scan_Tick, self(), {mod_scan, Count + 1}),
%% 	?WARNING_MSG("mod_scan:~w,~w",[Count,State#state.exp_rate]),
		 
	%%保存武器强化状态
	case Count rem ?Strength_Log_Ticks of 
		0 ->
			lib_statistics:insert_strength_log();
		_ ->
			skip
	end,
	
	%%保存武器镶嵌
	case Count rem ?Enchase_Log_Ticks of 
		0 ->
			lib_statistics:insert_enchase_log();
		_ ->
			skip
	end,
	
	%%保存元宝记录状态
	case Count rem ?Consume_YuanBao_Ticks of 
		0 ->
			lib_statistics:insert_consume_yuanbao_log();
		_ ->
			skip
	end,
	case Count rem ?Consume_Copper_Ticks of
		0 ->
			lib_statistics:insert_consume_copper_log();
		_ ->
			skip
	end,
	%%保存人物PK状态
	case Count rem ?Pk_Log_Ticks of 
		0 ->
			lib_statistics:insert_pk_log();
		_ ->
			skip
	end,
	
	%%保存玩家交易记录
	case Count rem ?Trade_Log_Ticks of 
		0 ->
			lib_statistics:insert_trade_log();
		_ ->
			skip
	end,
	
	%%保存武器合成状态
	case Count rem ?Compose_Log_Ticks of 
		0 ->
			lib_statistics:insert_compose_log();
		_ ->
			skip
	end,
	
	%%保存武器洗练状态
	case Count rem ?Rebuild_Log_Ticks of 
		0 ->
	lib_statistics:insert_rebuild_log();
		_ ->
			skip
	end,
	
	%%保存人物任务状态
	case Count rem ?Task_Log_Ticks of 
		0 ->
			lib_statistics:insert_task_log();
		_ ->
			skip
	end,
	
	%%保存物品（消耗/产出）日志
	case Count rem ?Item_Log_Ticks of 
		0 ->
			%Time = misc_timer:now_seconds(),
			lib_statistics:insert_item_log(0);
		_ ->
			skip
	end,
	
	%%魔法箱子日志
	case Count rem ?Magic_Log_Ticks of 
		0 ->
			lib_statistics:insert_magic_log();
		_ ->
			skip
	end,
	{Final_Rate, Exp_List} = lib_statistics:get_sys_multexp_rate(State#state.multexp_list),
	if 
		Final_Rate =:= State#state.exp_rate ->
			NewState = State;
		true ->
			Players = ets:tab2list(?ETS_ONLINE),
			FMult = fun(Info) ->
						case is_record(Info, ets_users) of
							true when is_record(Info#ets_users.other_data, user_other) =:= true 
							  andalso is_pid(Info#ets_users.other_data#user_other.pid) =:= true ->
								gen_server:cast(Info#ets_users.other_data#user_other.pid, {'set_mulexp', Final_Rate});
							_ ->
								?WARNING_MSG("exp_rate:~w", [Info])
						end
				end,
			lists:foreach(FMult, Players),
			NewState = State#state{exp_rate = Final_Rate, multexp_list = Exp_List}
	end,
	{noreply, NewState};

do_info(Info, State) ->
	?WARNING_MSG("mod_statics info is not match:~w",[Info]),
    {noreply, State}.


