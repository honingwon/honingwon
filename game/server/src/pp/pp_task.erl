%%%-------------------------------------------------------------------
%%% Module  : pp_task
%%% Author  : 
%%% Description : 任务
%%%-------------------------------------------------------------------
-module(pp_task).



%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================


%% 接受任务
handle(?PP_TASK_QUERY, PlayerStatus, []) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task, {'query_all'}),
	ok;

%% 接受任务
handle(?PP_TASK_ACCEPT, PlayerStatus, [TaskId]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task,
					{'accept',
					 TaskId,
					 PlayerStatus
%% 					 PlayerStatus#ets_users.sex,
%% 					 PlayerStatus#ets_users.camp,
%% 					 PlayerStatus#ets_users.career,
%% 					 PlayerStatus#ets_users.level,
%% 					 PlayerStatus#ets_users.pos_x,
%% 					 PlayerStatus#ets_users.pos_y					
					}),
	ok;


%% 任务取消
handle(?PP_TASK_CANCEL, PlayerStatus, [TaskId]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task,
					{'cancel',
					 TaskId
					}),
	ok;

%% 任务提交,可以改为cast来调用
handle(?PP_TASK_SUBMIT, PlayerStatus, [TaskId]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_task,
							{'submit',
					 		TaskId,
							PlayerStatus					
							}) of
		[YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards] ->
			NewPlayerStatus = lib_player:add_task_award(PlayerStatus, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards, TaskId),
			case NewPlayerStatus#ets_users.level  =/= PlayerStatus#ets_users.level of
				true ->
					{update_map, NewPlayerStatus};
				_ ->
					{update, NewPlayerStatus}
			end;			
		_ ->
			ok
	end;

%% 任务提交,可以改为cast来调用
handle(?PP_TASK_SUBMIT_YUANBAO, PlayerStatus, [TaskId]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_task,
							{'submit_by_yuanbao',
					 		TaskId,
							PlayerStatus					
							}) of
		[NeedYuanBao,YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards] ->
			NewPlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus, NeedYuanBao, 0,  0,0,{?CONSUME_TASK_SUBMIT,TaskId,1}),
			NewPlayerStatus = lib_player:add_task_award(NewPlayerStatus1, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards, TaskId),
			case NewPlayerStatus#ets_users.level  =/= PlayerStatus#ets_users.level of
				true ->
					{update_map, NewPlayerStatus};
				_ ->
					{update, NewPlayerStatus}
			end;			
		_ ->
			ok
	end;


%% 任务委托
handle(?PP_TASK_TRUST, PlayerStatus, [List]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_task, 
						 {'trust',
						  PlayerStatus,
						  List
						  }) of
		[YuanBao, Copper] -> %% 任务委托都扣除非绑定的
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, YuanBao, 0, Copper, 0,{?CONSUME_YUANBAO_TASK_TRUST,0,length(List)}),
			
			%%元宝消费统计
%% 			lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, YuanBao, 0, 
%% 										   1, ?CONSUME_YUANBAO_TASK_TRUST, misc_timer:now_seconds(), 0, 0,
%% 										   PlayerStatus#ets_users.level),
%% 			{ok, NewPlayerStatus};
			{update, NewPlayerStatus};
		_ ->
			?WARNING_MSG("PP_TASK_TRUST is error id:~w", [PlayerStatus#ets_users.id]),
			ok
	end;

%% 客服端控制任务
handle(?PP_TASK_CLIENT, PlayerStatus, [TaskId, RequireCount]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task, {'client', TaskId, RequireCount}),
	ok;

%% 镖车信息
handle(?PP_TASK_TRANSPORT_INIT,PlayerStatus,[]) ->
	{ok,Bin} = pt_24:write(?PP_TASK_TRANSPORT_INIT,[PlayerStatus#ets_users.escort_id]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin);


%%镖车刷新
handle(?PP_TASK_QUALITY_REFRESH, PlayerStatus, [IsAutoRef,NeedQuality])->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_task,
					{'transport_add',
					  IsAutoRef,NeedQuality,PlayerStatus }) of
		{ok,NewPlayerStatus,ReduceCopper} ->
			NewPlayerStatus1 = lib_player:reduce_cash_and_send(NewPlayerStatus, 0, 0,  0,ReduceCopper),
%% 			%%添加消费记录
%% 			lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, ReduceYunBao, ReduceBindYuanBao, 
%% 										   1, ?CONSUME_YUANBAO_ITEM_BUY, misc_timer:now_seconds(), TemplateID, Count,
%% 										   PlayerStatus#ets_users.level);
			{update, NewPlayerStatus1};
		_ ->
			ok
	end;
	

%%开启帮会运镖
handle(?PP_TASK_START_CLUB_TRANSPORT, PlayerStatus, []) ->
	case mod_guild:guild_transport(PlayerStatus#ets_users.id) of
		{ok,_StartTime,GuildID, GuildName} ->
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,?_LANG_GUILD_TRANSPORT_SUCCESS]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinChatMsg),
			{ok,BinAllMsg} = pt_24:write(?PP_TASK_START_CLUB_TRANSPORT, ?GUILD_TRANSPORT_TIME),
			lib_send:send_to_guild_user(GuildID,BinAllMsg),
			ChatAllStr = ?GET_TRAN(?_LANG_GUILD_TEANSPORT_TO_WORLD, [GuildName]),
%% 			lib_chat:chat_sysmsg([ChatAllStr]),
			lib_chat:chat_sysmsg([?ROLL,?None,?ORANGE, ChatAllStr]),
			ok;
		{false,Msg} ->
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?FLOAT,?None,?ORANGE,Msg]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinChatMsg),
			ok
	end;

%%领取发布的江湖令任务
handle(?PP_TOKEN_TASK_ACCEPT, PlayerStatus, [Type]) ->
	NewPlayerStatus = lib_token_task:receive_token_task(Type, PlayerStatus),
	{update, NewPlayerStatus};

%% 发布江湖令任务
handle(?PP_TOKEN_TASK_PUBLISH, PlayerStatus, [Type]) ->
	NewPlayerStatus = lib_token_task:publish_token_task(Type, PlayerStatus),
	case NewPlayerStatus#ets_users.level  =/= PlayerStatus#ets_users.level of
		true ->
			{update_map, NewPlayerStatus};
		_ ->
			{update, NewPlayerStatus}
	end;
%% 立即完成江湖令任务
handle(?PP_TOKEN_TRUST_FINISH, PlayerStatus, _) ->
	NewPlayerStatus = lib_token_task:finish_token_task(PlayerStatus),
	case NewPlayerStatus#ets_users.level  =/= PlayerStatus#ets_users.level of
		true ->
			{update_map, NewPlayerStatus};
		_ ->
			{update, NewPlayerStatus}
	end;

%% 请求江湖令发布信息
handle(?PP_TOKEN_PUBLISH_LIST, PlayerStatus, _) ->
	TokenPid = mod_token_task:get_token_pid(),
	gen_server:cast(TokenPid, {send_publish_count, PlayerStatus#ets_users.other_data#user_other.pid_send}),
	{update, PlayerStatus};

%% 请求用户江湖令信息
handle(?PP_TOKEN_USER_INFO, PlayerStatus, _) ->
	NewPlayerStatus = lib_token_task:send_user_token_info(PlayerStatus),
	{update, NewPlayerStatus};

%% 运镖求救
handle(?PP_TAsk_TRANSPORT_HELP, PlayerStatus, _) ->
	
	ok;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_task no match"}.

%%====================================================================
%% Private functions
%%====================================================================


