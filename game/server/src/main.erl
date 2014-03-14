%%%--------------------------------------
%%% @Module  : main
%%% @Created : 2011.02.22 
%%% @Description:  服务器开启  
%%%--------------------------------------
-module(main).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl"). 

%%--------------------------------------------------------------------
%%-define(Macro, value).
%%-record(state, {}).
%%--------------------------------------------------------------------
-define(GATEWAY_APPS, [sasl, gateway]).
-define(SERVER_APPS, [sasl, server]).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
		 gateway_start/0, 
		 gateway_stop/0, 
		 server_start/0, 
		 server_stop_all/0, 
		 server_stop/0, 
		 info/0,
		 set_server_state_all/1,
		 set_server_state/1
		]).

%%启动网关
gateway_start()->
    try
        ok = start_applications(?GATEWAY_APPS)
    after
        timer:sleep(100)
    end.

%%停止网关
gateway_stop() ->
    ok = stop_applications(?GATEWAY_APPS).

%%启动游戏服务器
server_start()->
    try
        ok = start_applications(?SERVER_APPS)
    after
        timer:sleep(100)
    end.

%% 关闭所有游戏入口
set_server_state_all(IsOpen) ->
	mod_node_interface:set_game_server(ets:tab2list(?ETS_SERVER_NODE), IsOpen),
	set_server_state(IsOpen).

%% 关闭游戏入口
set_server_state(IsOpen) ->
	ets:insert(service_open, #service_open{id = 1, is_open = IsOpen}),
	ok.

%% 停止所有服务器
server_stop_all() ->
	mod_node_interface:stop_game_server(ets:tab2list(?ETS_SERVER_NODE)),
	lib_statistics:stop_global_server(),
	server_stop().

%%停止游戏服务器
server_stop() ->
	%%首先关闭外部接入，然后停止目前的连接，等全部连接正常退出后，再关闭应用
	catch gen_server:cast(mod_kernel, {set_load, 9999999999}),
    ok = mod_login:stop_all(),
	lib_statistics:stop_local_server(),
	timer:sleep(30*1000),
    ok = stop_applications(?SERVER_APPS),
    erlang:halt().
	
info() ->
    SchedId      = erlang:system_info(scheduler_id),
    SchedNum     = erlang:system_info(schedulers),
    ProcCount    = erlang:system_info(process_count),
    ProcLimit    = erlang:system_info(process_limit),
    ProcMemUsed  = erlang:memory(processes_used),
    ProcMemAlloc = erlang:memory(processes),
    MemTot       = erlang:memory(total),
    io:format( "abormal termination:
                       ~n   Scheduler id:                         ~p
                       ~n   Num scheduler:                        ~p
                       ~n   Process count:                        ~p
                       ~n   Process limit:                        ~p
                       ~n   Memory used by erlang processes:      ~p
                       ~n   Memory allocated by erlang processes: ~p
                       ~n   The total amount of memory allocated: ~p
                       ~n",
                            [SchedId, SchedNum, ProcCount, ProcLimit,
                             ProcMemUsed, ProcMemAlloc, MemTot]),
      ok.

%%############辅助调用函数##############
manage_applications(Iterate, Do, Undo, SkipError, ErrorTag, Apps) ->
    Iterate(fun (App, Acc) ->
                    case Do(App) of
                        ok -> [App | Acc];%合拢
                        {error, {SkipError, _}} -> Acc;
                        {error, Reason} ->
                            lists:foreach(Undo, Acc),
                            throw({error, {ErrorTag, App, Reason}})
                    end
            end, [], Apps),
    ok.

start_applications(Apps) ->
    manage_applications(fun lists:foldl/3,
                        fun application:start/1,
                        fun application:stop/1,
                        already_started,
                        cannot_start_application,
                        Apps).

stop_applications(Apps) ->
    manage_applications(fun lists:foldr/3,
                        fun application:stop/1,
                        fun application:start/1,
                        not_started,
                        cannot_stop_application,
                        Apps).
	
