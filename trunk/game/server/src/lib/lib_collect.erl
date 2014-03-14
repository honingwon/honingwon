%% Author: Administrator
%% Created: 2011-4-11
%% Description: TODO: Add description to lib_collect
-module(lib_collect).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 init_template_collect/0,
		 start_collect/3,
		 player_collect/3,
		 stop_collect/1
%% 		 get_collect_pid/2,
%% 		 create_collect_item/6,
%% 		 collect/3
		 ]).
%% 
%% %%
%% %% API Functions
%% %%
%% 
%%初始化采集模板
init_template_collect() -> 
	F = fun(Info) ->
				Record = list_to_tuple([ets_collect_template] ++ Info),		
  				ets:insert(?ETS_COLLECT_TEMPLATE, Record)
	end,
	L = db_agent_template:get_collect_template(),
	lists:foreach(F, L),
	ok.

start_collect(Status, CollectId, TemplateId) ->
	{_, Status1} = lib_sit:cancle_sit(Status),
	case data_agent:collect_get(TemplateId) of
		[] ->
			Status1;
		Info ->
			NewOther = Status#ets_users.other_data#user_other{%开始时间减少500确保时间差
								collect_status = {CollectId, TemplateId,Info#ets_collect_template.collect_time,misc_timer:now_milseconds() - 500}},
			Status#ets_users{other_data = NewOther}
	end.

player_collect(Status, CollectId, TemplateId) ->
	Res =
	case Status#ets_users.other_data#user_other.collect_status of
		{} ->
			?DEBUG("player_collect:~p",[Status#ets_users.other_data#user_other.collect_status]),
			{false,"采集失败"};
		{CId,TId,CD,STime} ->
			Now = misc_timer:now_milseconds(),
			if	CId =/= CollectId orelse TId =/= TemplateId ->					
					{false,"采集物不存在"};
				(CD + STime) > Now  ->
					?DEBUG("player_collect:~p",[{CD + STime,Now, Now - CD - STime }]),
					{false,"采集时间过短"};
				true ->
					gen_server:cast(Status#ets_users.other_data#user_other.pid_map, {
																		   'collect',
																		   CollectId,
																		   TemplateId,
																		   Status#ets_users.other_data#user_other.pid
																		   }),
					true
			end
	end,
	case Res of
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?ORANGE,Msg]);
		true ->
			skip
	end,
	NewOther = Status#ets_users.other_data#user_other{
								collect_status = {}},
	Status#ets_users{other_data = NewOther}.

stop_collect(Status) ->
	if	Status#ets_users.other_data#user_other.collect_status =:= {} ->
			Status;
		true ->
			NewOther = Status#ets_users.other_data#user_other{
								collect_status = {}},
			Status#ets_users{other_data = NewOther}
	end.

%% 取得采集的进程PID
%% get_collect_pid(MapId, CollectId) ->
%% 	CollectProcessName = misc:collect_process_name(MapId, CollectId),
%% 	case misc:whereis_name({global, CollectProcessName}) of
%% 		Pid when is_pid(Pid) ->
%% 			case misc:is_process_alive(Pid) of
%% 				true -> Pid;
%% 				_ ->
%% 					[]
%% 			end;
%% 		_ -> []
%% 	
%% 	end.
%% 
%% 
%% %% 创建采集物品
%% create_collect_item(Id, Template, MapId, X, Y, MapPid) ->
%% 	Info = #r_collect_info{
%% 						     unique_key = {MapId, Id}, 
%% 							 id = Id,			%% id
%% 							 template_id = Template#ets_collect_template.template_id,	%% 模板Id
%% 							 x = X,				%% X位置
%% 							 y = Y,				%% Y位置
%% 							 state = 1,			%% 0消亡 ，1正常，
%% 						  	 map_id = MapId,	%% 地图id
%% 							 map_pid = MapPid	%% 地图进程Id
%% 							},
%% 	Info.
%% 	
%% collect(MapId, CollectId, PlayerPid) ->
%% 	case get_collect_pid(MapId, CollectId) of
%% 		[] ->
%% 			skip;
%% 		Pid ->
%% 			gen_server:cast(Pid, {'collect', PlayerPid})
%% 	end.

%%
%% Local Functions
%%

