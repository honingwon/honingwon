%% Author: wangdahai
%% Created: 2013-4-3
%% Description: TODO: Add description to lib_token_task
-module(lib_token_task).
-include("common.hrl").
%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([init_template_token_task/0,
		init_token_publish/0,
		get_user_token_task/1,
		load_log/1,
		list_to_string/1,
		get_token_task_id/1,
		receive_token_task/2,
		get_token_task_award/3,
		publish_token_task/2,
		publish_token_receive/2,
		clear_receive_token_task/1,
		finish_token_task/1,
		send_user_token_info/1]).

-define(MAX_DAY_RECEIVE_NUM, 5). %%天最高可接数
-define(MAX_DAY_PUBLISH_NUM, 5). %%天最高可发数
-define(FINISH_TOKEN_TASK_NEED_YUANBAO, 2).%% 立即完成江湖令需要消耗的元宝数
-define(TOKEN_TASK_PUBLISH_ITEMS,[206001,206002,206003,206004]).
-define(MAX_TOKEN_TASK_TYPE, 4). %% 最大江湖令任务类型
-define(MIN_TOKEN_TASK_TYPE, 1). %% 最小江湖令任务类型
-define(MIN_TOKEN_TASK_OPEN_LEVLE, 40). %%江湖令开放等级

%%
%% API Functions
%%

init_template_token_task() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_token_task_template] ++ Info),
				ets:insert(?ETS_TOKEN_TASK_TEMPLATE, Record)
		end,
	case db_agent_template:get_token_task_template() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->
			skip
	end,
	ok.

init_token_publish() ->
	F = fun(Info, State) ->
			Record = list_to_tuple([ets_token_publish_info] ++ Info),
			{TokenId,Num1,Num2,Num3,Num4} = State#mod_token_task_state.token_count,
			NewTokenId = if
				Record#ets_token_publish_info.token_id > TokenId ->
					Record#ets_token_publish_info.token_id;
				true ->
					TokenId
			end,
			case Record#ets_token_publish_info.type of
				1 ->
					NewList = State#mod_token_task_state.token_publish_list_1 ++ [Record],
					State#mod_token_task_state{token_publish_list_1 = NewList, token_count = {NewTokenId,Num1 + 1,Num2,Num3,Num4}};
				2 ->
					NewList = State#mod_token_task_state.token_publish_list_2 ++ [Record],
					State#mod_token_task_state{token_publish_list_2 = NewList, token_count = {NewTokenId,Num1,Num2 + 1,Num3,Num4}};
				3 ->
					NewList = State#mod_token_task_state.token_publish_list_3 ++ [Record],
					State#mod_token_task_state{token_publish_list_3 = NewList, token_count = {NewTokenId,Num1,Num2,Num3 + 1,Num4}};
				4 ->
					NewList = State#mod_token_task_state.token_publish_lsit_4 ++ [Record],
					State#mod_token_task_state{token_publish_lsit_4 = NewList, token_count = {NewTokenId,Num1,Num2,Num3,Num4 + 1}};
				_ ->
					?WARNING_MSG("init_token_publish Error:~p",{Record}),
					State
			end			
		end,
	case db_agent_token_task:get_token_list() of
		[] ->
			#mod_token_task_state{};
		List when is_list(List) ->
			lists:foldl(F, #mod_token_task_state{}, List);
		_ ->
			#mod_token_task_state{}
	end.

get_user_token_task(UserID) ->
	Token = case db_agent_user:get_user_token_task(UserID) of
			[] ->
				#ets_user_token{user_id = UserID,  receive_log = <<>>, publish_log = <<>>};
			Info ->
				list_to_tuple([ets_user_token] ++ Info)				
	end,
	ReceiveLog = load_log(Token#ets_user_token.receive_log),
	PublishLog = load_log(Token#ets_user_token.publish_log),
	Token#ets_user_token{receive_log = ReceiveLog, publish_log = PublishLog}.

%%只使用在数字中
load_log(Log) ->
	Log1 = binary_to_list(Log),
	F = fun(Value, L) ->
			[Value - 48|L] 
		end,
	if
		Log1 =:= [] ->
			NewLog = [0,0,0,0];
		true ->
			NewLog = Log1
	end,
	lists:foldr(F, [], NewLog).

list_to_string(Log) ->
	F = fun(Value, S) ->
		Value1 = integer_to_list(Value),
		string:concat(S, Value1)
		end,
	lists:foldl(F, [], Log).

%% 接收江湖令
receive_token_task(Type, PlayerState) ->
	TokenInfo = PlayerState#ets_users.other_data#user_other.token_info,
	%ReceiveCount = get_receive_count(TokenInfo#ets_user_token.receive_log),
	if
		PlayerState#ets_users.level >= ?MIN_TOKEN_TASK_OPEN_LEVLE andalso TokenInfo#ets_user_token.receive_task_id =:= 0 ->
		case check_token_reset(TokenInfo) of
			{ok} ->
				ReceiveCount = get_receive_count(TokenInfo#ets_user_token.receive_log),
				if ReceiveCount < ?MAX_DAY_RECEIVE_NUM ->
						receive_token_task1(Type, TokenInfo, PlayerState);
					true ->
						PlayerState
				end;				
			{reset, NewTokenInfo} ->
				receive_token_task1(Type, NewTokenInfo, PlayerState)
		end;
		true ->
			PlayerState
	end.
%% 发布江湖令任务
publish_token_task(Type, PlayerState) ->
	TokenInfo = PlayerState#ets_users.other_data#user_other.token_info,
	case check_token_reset(TokenInfo) of
		{ok} ->
			NewTokenInfo = TokenInfo;
		{reset, NewTokenInfo} ->
			NewTokenInfo
	end,
	PublishCount = get_receive_count(NewTokenInfo#ets_user_token.publish_log),
	if
		PlayerState#ets_users.level >= ?MIN_TOKEN_TASK_OPEN_LEVLE andalso
		PublishCount < ?MAX_DAY_RECEIVE_NUM
		andalso Type =< ?MAX_TOKEN_TASK_TYPE andalso Type >= ?MIN_TOKEN_TASK_TYPE->			
			publish_token_task1(Type,TokenInfo,PlayerState);
		true ->
			PlayerState
	end.
%%发布的江湖令被领取
publish_token_receive(Type, TokenInfo) ->
	case Type of
		1 ->
			TokenInfo#ets_user_token{receive_num1 = TokenInfo#ets_user_token.receive_num1 + 1};
		2 ->
			TokenInfo#ets_user_token{receive_num2 = TokenInfo#ets_user_token.receive_num2 + 1};
		3 ->
			TokenInfo#ets_user_token{receive_num3 = TokenInfo#ets_user_token.receive_num3 + 1};
		4 ->
			TokenInfo#ets_user_token{receive_num4 = TokenInfo#ets_user_token.receive_num4 + 1};
		_ ->
			TokenInfo
	end.

%%发送江湖令信息验证时间是否过期，需要重置
send_user_token_info(PlayerStatus) ->
	TokenInfo = PlayerStatus#ets_users.other_data#user_other.token_info,
	case check_token_reset(TokenInfo) of
		{ok} ->
			NewPlayerStatus = PlayerStatus;
		{reset, NewTokenInfo} ->
			NewOther = PlayerStatus#ets_users.other_data#user_other{token_info = NewTokenInfo},
			NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther}
	end,
	{ok, Bin} = pt_24:write(?PP_TOKEN_USER_INFO, NewPlayerStatus#ets_users.other_data#user_other.token_info),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
	NewPlayerStatus.

%% 检查江湖令是否需要重置
check_token_reset(TokenInfo) ->
	%LastDay = misc_timer:get_day(TokenInfo#ets_user_token.last_receive_time),
	Now = misc_timer:now_seconds(),
	%Day = misc_timer:get_day(Now),
	case util:is_same_date(TokenInfo#ets_user_token.last_receive_time, Now) of
		true ->
			{ok};
		false ->
			NewTokenInfo = #ets_user_token{last_receive_time = Now,
									receive_task_id = TokenInfo#ets_user_token.receive_task_id,
									user_id = TokenInfo#ets_user_token.user_id},
			db_agent_user:update_user_token_task(NewTokenInfo#ets_user_token.user_id, NewTokenInfo),
			{reset, NewTokenInfo}
	end.

%% 立即完成江湖令任务
finish_token_task(PlayerStatus) ->
	TonkenInfo = PlayerStatus#ets_users.other_data#user_other.token_info,
	case lib_player:check_cash(PlayerStatus, ?FINISH_TOKEN_TASK_NEED_YUANBAO, 0) of
		true when(TonkenInfo#ets_user_token.receive_task_id > 0) ->			
			{Copper , BindCopper , Exp } = get_token_task_award(TonkenInfo#ets_user_token.receive_task_id rem 10,
												 TonkenInfo#ets_user_token.receive_task_id div 10, false),%%发送奖励
			NewTonkenInfo = TonkenInfo#ets_user_token{receive_task_id = 0},
			
			case  gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_task, {submit_token, PlayerStatus}) of
				[YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards] -> %%江湖令任务不接受任务上配置的奖励
					lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_TASK,{1100001,1}}]),
					db_agent_user:update_user_token_task(PlayerStatus#ets_users.id, NewTonkenInfo),
					{ok, Bin} = pt_24:write(?PP_TOKEN_TRUST_FINISH, 1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
					PlayerStatus1 = lib_player:add_task_award(PlayerStatus, 0, 0, Copper, BindCopper, Exp, 0, [],1100001),%%江湖令专用任务编号
					PlayerStatus2 = lib_player:reduce_cash_and_send(PlayerStatus1, ?FINISH_TOKEN_TASK_NEED_YUANBAO, 0, 0, 0,
															{?CONSUME_YUANBAO_FINISH_TOKEN,TonkenInfo#ets_user_token.receive_task_id rem 10,1}),
					NewOther = PlayerStatus2#ets_users.other_data#user_other{token_info = NewTonkenInfo},
					PlayerStatus2#ets_users{other_data = NewOther};
				_er ->
					PlayerStatus
			end;			
		_e ->
			PlayerStatus
	end.

%% 清除江湖令领取的任务
clear_receive_token_task(PlayerStatus) ->
	TonkenInfo = PlayerStatus#ets_users.other_data#user_other.token_info,
	if
		TonkenInfo#ets_user_token.receive_task_id > 0 ->
			NewTonkenInfo = TonkenInfo#ets_user_token{receive_task_id = 0},
			db_agent_user:update_user_token_task(PlayerStatus#ets_users.id, NewTonkenInfo),
			NewOther = PlayerStatus#ets_users.other_data#user_other{token_info = NewTonkenInfo},
			PlayerStatus#ets_users{other_data = NewOther};
		true ->
			PlayerStatus
	end.
%%
%% Local Functions
%%
publish_token_task1(Type,TokenInfo,PlayerState) ->
	%ItemID = lists:nth(Type, ?TOKEN_TASK_PUBLISH_ITEMS),
	TokenTemp = data_agent:token_task_template_get(Type),
	case gen_server:call(PlayerState#ets_users.other_data#user_other.pid_item, {publish_token_task, TokenTemp#ets_token_task_template.item_id}) of
		true ->
			publish_token_task2(Type,TokenInfo,PlayerState);
		_ ->
			PlayerState
	end.
	%%消耗物品
publish_token_task2(Type,TokenInfo,PlayerState) ->
	TokenPid = mod_token_task:get_token_pid(),
	gen_server:cast(TokenPid, {publish_token_task, PlayerState#ets_users.id, PlayerState#ets_users.level , Type}),
	PublishLog = update_token_task_num(TokenInfo#ets_user_token.publish_log,[],Type),
	Now = misc_timer:now_seconds(),
	NewTokenInfo = TokenInfo#ets_user_token{last_receive_time = Now, publish_log = PublishLog},
	db_agent_user:update_user_token_task(NewTokenInfo#ets_user_token.user_id, NewTokenInfo),
	NewOther = PlayerState#ets_users.other_data#user_other{token_info = NewTokenInfo},	
	{Copper , BindCopper , Exp } = get_token_task_award(Type, PlayerState#ets_users.level, true),%%发送奖励
	NewPlayerState = lib_player:add_task_award(PlayerState, 0, 0, Copper, BindCopper, Exp, 0, [], 1100002),
	gen_server:cast(PlayerState#ets_users.other_data#user_other.pid, {'finish_active',PlayerState, ?ACTIVE_TOKEN,0}),%%更新活跃度
	{ok,Bin} = pt_24:write(?PP_TOKEN_TASK_PUBLISH, 1),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, Bin),
	{ok,BinData} = pt_24:write(?PP_TOKEN_USER_INFO, NewTokenInfo),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, BinData),
	NewPlayerState#ets_users{other_data = NewOther}.

receive_token_task1(Type, TokenInfo, PlayerState) ->
	TokenPid = mod_token_task:get_token_pid(),
	TaskId = get_token_task_id(PlayerState#ets_users.level),
	case gen_server:call(TokenPid, {receive_task, Type, PlayerState#ets_users.other_data#user_other.pid_send})of
		[] ->
			PlayerState;
		PublishInfo when(TaskId > 0) ->
			case gen_server:call(PlayerState#ets_users.other_data#user_other.pid_task,{check_token_task, TaskId})of
				ok ->
					?DEBUG("PublishInfo:~p",[1]),
					gen_server:cast(PlayerState#ets_users.other_data#user_other.pid_task,{'accept',TaskId,PlayerState}),
					UserId = PublishInfo#ets_token_publish_info.publish_user_id,
					UserPid = lib_player:get_player_pid(UserId),
					Award = get_token_task_award(Type, PlayerState#ets_users.level, true),
					if UserPid =/= [] ->
			   			gen_server:cast(UserPid, {publish_token_receive, Type, Award});
			   		true ->
						db_agent_user:add_token_task_award(Award, UserId)
					end,
					db_agent_user:update_user_token_receive_num(Type,UserId),
					receive_token_task2(Type, TokenInfo, PlayerState);
				{error, Msg} ->
					lib_chat:chat_sysmsg_pid([PlayerState#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
					PlayerState
			end;
		_ ->
			PlayerState
	end.

receive_token_task2(Type, TokenInfo, PlayerState) ->	
	%receive_token_task3(PlayerState),
	gen_server:cast(PlayerState#ets_users.other_data#user_other.pid, {'finish_active',PlayerState, ?ACTIVE_TOKEN,0}),%%更新活跃度
	{ok,Bin} = pt_24:write(?PP_TOKEN_TASK_ACCEPT, 1),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, Bin),
	NewReceiveLog = update_token_task_num(TokenInfo#ets_user_token.receive_log, [], Type),
	Now = misc_timer:now_seconds(),
	ReceiveTaskId = PlayerState#ets_users.level * 10 + Type,
	NewTokenInfo = TokenInfo#ets_user_token{receive_log = NewReceiveLog, last_receive_time = Now,receive_task_id = ReceiveTaskId},
	db_agent_user:update_user_token_task(PlayerState#ets_users.id, NewTokenInfo),
	{ok, BinData} = pt_24:write(?PP_TOKEN_USER_INFO, NewTokenInfo),
	lib_send:send_to_sid(PlayerState#ets_users.other_data#user_other.pid_send, BinData),
	NewOther = PlayerState#ets_users.other_data#user_other{token_info = NewTokenInfo},
	PlayerState#ets_users{other_data = NewOther}.


%% 领取奖励关联的具体任务
get_token_task_id(Level) ->
	MinLevel = (Level div 5) * 5,
	case ets:match(?ETS_TASK_TEMPLATE, #ets_task_template{task_id = '$1',min_level = MinLevel, _ = '_', type = ?TOKEN_TASK_TYPE,_ = '_'}) of
		[] ->
			0;
		[[TaskTemplateId]|_] ->
			TaskTemplateId
	end.
%% receive_token_task3(PlayerStatus) ->
%% 	Level = PlayerStatus#ets_users.level,
%% 	MinLevel = (Level div 5) * 5,
%% 	case ets:match(?ETS_TASK_TEMPLATE, #ets_task_template{task_id = '$1',min_level = MinLevel, _ = '_', type = ?TOKEN_TASK_TYPE,_ = '_'}) of
%% 		[] ->
%% 			?WARNING_MSG("token_task not have template task for level:~p",[Level]);
%% 		[[TaskTemplateId]|_] ->
%% 			
%% 	end.

update_token_task_num([],LogList,Type) ->
	?WARNING_MSG("update_token_task_num error:~p",[{LogList,Type}]),
	LogList;
update_token_task_num([Value|Log], LogList, Type) ->
	if
		Type > 1 ->
			update_token_task_num(Log,LogList++[Value], Type - 1);
		true ->
			 LogList++[Value+1|Log]			 
	end.

%计算领取或发布总数量
get_receive_count(ReceiveLog) ->
	F = fun(Info, Count) ->
			Count + Info
		end,
	lists:foldl(F, 0, ReceiveLog).
%计算江湖令任务奖励
get_token_task_award(Type, Level, Half) ->
	TokenTemp =	data_agent:token_task_template_get(Type),
	Copper = Level * TokenTemp#ets_token_task_template.copper,
	BindCopper = Level * TokenTemp#ets_token_task_template.copper_bind,
	Exp = Level * Level * TokenTemp#ets_token_task_template.exp,
	if
		Half =:= true ->
			{round(Copper * 0.3), round(BindCopper * 0.3), round(Exp * 0.3)};
		true ->
			{Copper , BindCopper , Exp }
	end.