%% Author: Administrator
%% Created: 2011-3-16
%% Description: TODO: 任务信息
-module(pt_24).

-include("common.hrl").

-export([
		 read/2,
		 write/2
		 ]).


%%
%% API Functions
%%

%%
%%客户端 -> 服务端 ----------------------------
%%

%% 接受任务
read(?PP_TASK_ACCEPT, <<TaskId:32>>) ->
	{ok, [TaskId]};


%%取消任务
read(?PP_TASK_CANCEL, <<TaskId:32>>) ->
	{ok, [TaskId]};

%%提交任务
read(?PP_TASK_SUBMIT, <<TaskId:32,_:32>>) ->
	{ok, [TaskId]};

%%立即完成任务
read(?PP_TASK_SUBMIT_YUANBAO, <<TaskId:32,_:32>>) ->
	{ok, [TaskId]};

%% 任务委托
read(?PP_TASK_TRUST, <<Len:8, Bin/binary>>) ->
	List = read_trust_list(Len, Bin, []),
	{ok, [List]};

%%客户端控制任务状态
read(?PP_TASK_CLIENT, <<TaskId:32, RequireCount:8>>) ->
%% 	{RequireCount,_} = pt:read_string(Bin),
	{ok, [TaskId, RequireCount]};

%% 运镖信息
read(?PP_TASK_TRANSPORT_INIT,<<>>) ->
	{ok,[]};

%% 帮会运镖
read(?PP_TASK_START_CLUB_TRANSPORT, <<>>) ->
	{ok,[]};

%% 刷新运镖
read(?PP_TASK_QUALITY_REFRESH, <<IsAutoRef:8,NeedQuality:8>>) ->
	{ok, [IsAutoRef,NeedQuality]};

%% 接受江湖令任务
read(?PP_TOKEN_TASK_ACCEPT, <<Type:32>>) ->
	{ok, [Type]};

%% 发布江湖令任务
read(?PP_TOKEN_TASK_PUBLISH, <<Type:32>>) ->
	{ok, [Type]};

%% 查看自己的江湖令任务
read(?PP_TOKEN_USER_INFO, _) ->
	{ok, []};

%% 查看发布江湖令任务
read(?PP_TOKEN_PUBLISH_LIST, _) ->
	{ok, []};

%% 立即完成江湖令任务
read(?PP_TOKEN_TRUST_FINISH, _) ->
	{ok, []};

%%运镖求救
read(?PP_TAsk_TRANSPORT_HELP,_) ->
	{ok,[]};

read(_Cmd, _) ->
	?DEBUG("pt_24 task read cmd:~w is error",[_Cmd]),
	ok.

read_trust_list(0, _Bin, List) ->
	List;
read_trust_list(Len, Bin, List) ->
	<<TaskId:32, Type:8, Count:8, Bin1/binary>> = Bin,
	NewList = [{TaskId, Type, Count}|List],
	read_trust_list(Len-1, Bin1, NewList).

%%
%%服务端 -> 客户端 ----------------------------
%%

%% 任务更新
write(?PP_TASK_UPDATE, Infos) ->
%% 	?PRINT("PP_TASK_UPDATE:~w~n",[Infos]),
	Len = length(Infos),
	FTask = fun(Info)->
					RequireCountBin = pt:write_string(Info#ets_users_tasks.require_count),
					<<(Info#ets_users_tasks.task_id):32,
					  (Info#ets_users_tasks.other_data#other_task.is_new_finish):8,
					  (Info#ets_users_tasks.is_exist):8,
					  (Info#ets_users_tasks.is_finish):8,
					  (Info#ets_users_tasks.finish_date):32,
					  (Info#ets_users_tasks.state):32,
					  RequireCountBin/binary,
					  (Info#ets_users_tasks.repeat_count):32,
					  (Info#ets_users_tasks.other_data#other_task.is_new):8,
					  (Info#ets_users_tasks.is_trust):8,
					  (Info#ets_users_tasks.trust_end_time):32,
					  (Info#ets_users_tasks.trust_count):8
					>>
			end,
	Bin = tool:to_binary([FTask(X) || X <- Infos]),
	Data = <<Len:32, Bin/binary>>,
	{ok, pt:pack(?PP_TASK_UPDATE, Data)};


%% 任务奖励信息
%% write(?PP_TASK_UPDATE, [YuanBao, Copper, BindCopper]) ->
%%     {ok, pt:pack(?PP_UPDATE_SELF_INFO, <<YuanBao:32, Copper:32, BindCopper:32>>)};
						 
%%剩余运镖时间
write(?PP_TASK_ACCEPT, LimitTime) ->
	Data = <<LimitTime:8>>,
	{ok, pt:pack(?PP_TASK_ACCEPT, Data)};


%%运镖信息
write(?PP_TASK_TRANSPORT_INIT,[Quality]) ->
	{ok, pt:pack(?PP_TASK_TRANSPORT_INIT, <<Quality:8>>)};

%%刷新
write(?PP_TASK_QUALITY_REFRESH, [NewQuality,IsSuc,Copper]) ->
	{ok, pt:pack(?PP_TASK_QUALITY_REFRESH, <<NewQuality:8,IsSuc:8,Copper:32>>)};

%%启动帮会运镖广播
write(?PP_TASK_START_CLUB_TRANSPORT, Time) ->
	{ok, pt:pack(?PP_TASK_START_CLUB_TRANSPORT, <<Time:32>>)};


%% 接受江湖令任务
write(?PP_TOKEN_TASK_ACCEPT, Success) ->
	{ok, pt:pack(?PP_TOKEN_TASK_ACCEPT, <<Success:8>>)};

%% 发布江湖令任务
write(?PP_TOKEN_TASK_PUBLISH, Success) ->
	{ok, pt:pack(?PP_TOKEN_TASK_PUBLISH, <<Success:8>>)};

%% 查看自己的江湖令任务
write(?PP_TOKEN_USER_INFO, Token) ->
	Bin = write_user_token_info(Token),
	{ok, pt:pack(?PP_TOKEN_USER_INFO, Bin)};

%% 查看发布江湖令任务
write(?PP_TOKEN_PUBLISH_LIST,PublishInfo) ->
	{_,N1,N2,N3,N4} = PublishInfo,
	{ok, pt:pack(?PP_TOKEN_PUBLISH_LIST, <<N1:32,N2:32,N3:32,N4:32>>)};

%% 立即完成江湖令任务
write(?PP_TOKEN_TRUST_FINISH, Success) ->
	{ok, pt:pack(?PP_TOKEN_TRUST_FINISH, <<Success:8>>)};

write(_Cmd, _) ->
	?DEBUG("pt_24 task write cmd:~w is error",[_Cmd]),
	ok.

%%
%% Local Functions
%%
write_user_token_info(Token) ->
	F = fun(Info, Bin) ->
		<<Bin/binary, Info:16>>
		end,
	ReceiveLog = lists:foldl(F, <<>>, Token#ets_user_token.receive_log),
	PublishLog = lists:foldl(F, <<>>, Token#ets_user_token.publish_log),
	RN = length(Token#ets_user_token.receive_log),
	PN = length(Token#ets_user_token.publish_log),
	<<RN:16,ReceiveLog/binary,PN:16,PublishLog/binary,
		(Token#ets_user_token.receive_num1):16,
		(Token#ets_user_token.receive_num2):16,
		(Token#ets_user_token.receive_num3):16,
		(Token#ets_user_token.receive_num4):16>>.


