%%%-------------------------------------------------------------------
%%% Module  : server
%%% Author  : 
%%% Description : 游戏服务器
%%%-------------------------------------------------------------------
-module(server).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").


%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([start/1]).

%%====================================================================
%% External functions
%%====================================================================
start([Ip, Port, Server_no, Node_type]) ->
    misc:write_system_info(self(), tcp_listener, {Ip, Port, now()}),
	crypto:start(),
    inets:start(),
	
    ok = start_node_interface([Ip, Port, Server_no, Node_type]),	%%开启服务器路由，连接其他节点	
	timer:sleep(1000),	
    ok = start_kernel(),						%%开启核心服务
	ok = start_rand(),							%%随机种子
%% 	ok = start_mon(),							%%开启怪物监控树
	ok = start_collect(),						%%开户采集监控树
	ok = start_team_manager(),					%%开启组队管理进程
	ok = start_guild(),							%%开启帮会监控树
	ok = start_sale(), 
	ok = start_token_task(),
	ok = start_active_manage(),
	ok = start_top_manage(),
	ok = start_statistics(),					%%开启本节点统计监控树
	ok = start_global_statistics(),				%%开启全局节点统计监控树
    ok = start_client(),						%%开启客户端连接监控树
    ok = start_tcp(Port),						%%开启tcp listener监控树
	ok = start_map_agent(),						%%开启场景代理监控树
	ok = start_pet_battle(),						%%宠物战信息监控树

 	ok = start_map(),							%%实例化地图		

%% 	ok = start_stall(),                         %%开启摆摊监控树
	
	ok = start_increase(),						%%开启自增监控树
	
	ok = start_duplicate(),                     %%开启副本监控树
	
	ok = start_open_box(),                      %%开启开箱子监控树

	ok = start_open_smshop(),                   %%开启神秘商店监控树
	
	ok = start_shop(),							%%开启商城监控树
	
	ok = start_first_manage(),					%%开启天下第一管理

	ok = start_tokey(),							%% 开启获取充值tokey监控树

	ok = start_activity_seven(),			    %%开启七天活动监控树

	ok = start_sysmsg(),						%%开启公告监控树
	
	%ok = start_free_war(),						%% 开启自由战场
	
	ok = start_boss_manage(),					%%开启野外boss管理
%% 	io:format("the global Pro ok! Please start the next node...~n"),
	?INFO_MSG("~s", ["the global Pro ok! Please start the next node..."]),
	ok.	

%%====================================================================
%% Private functions
%%====================================================================
%%开启核心服务
start_kernel() ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {mod_kernel,
                {mod_kernel, start_link,[]},
                permanent, 10000, supervisor, [mod_kernel]}),
    ok.

%%随机种子
start_rand() ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {mod_rand,
                {mod_rand, start_link,[]},
                permanent, 10000, supervisor, [mod_rand]}),
    ok.

%%开启怪物监控树
%% start_mon() ->
%% 	{ok, _} = supervisor:start_child(
%% 				server_sup,
%% 				{mod_mon_create,
%% 				 {mod_mon_create, start_link,[]},
%% 				 permanent, 10000, worker, [mod_mon_create]}),
%% 	ok.

%%开启采集监控树
start_collect() ->
	{ok, _} = supervisor:start_child(
				server_sup,
				{mod_collect_create,
				 {mod_collect_create, start_link,[]},
				 permanent, 10000, worker, [mod_collect_create]}),
	ok.

%%开启npc监控树
%% start_npc() ->
%%     {ok,_} = supervisor:start_child(
%%                server_sup,
%%                {mod_npc_create,
%%                 {mod_npc_create, start_link,[]},
%%                 permanent, 10000, worker, [mod_npc_create]}),
%%     ok.


%%开启组队管理进程
start_team_manager() ->
	_Pid = mod_team_agent:get_mod_team_agent_pid(),
	ok.

%%开启帮会监控树
start_guild() ->
	_Pid = mod_guild:get_mod_guild_pid(),
	ok.


start_statistics() ->
	_Pid = mod_statistics:start_mod_statistics(),
	ok.

start_global_statistics() ->
	_Pid = mod_global_statistics:start_mod_global_statistics(),
	ok.


%%开启场景代理监控树
start_map_agent() ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {mod_map_agent,
                {mod_map_agent, start_link, [{mod_map_agent, 0}]},
                permanent, 10000, supervisor, [mod_map_agent]}),
    ok.

%% 开启本节点场景(按照配置文件)
start_map() ->
	lists:foreach(fun(SId)->  
				  	mod_map:get_scene_pid(SId, undefined, undefined)
				  end, 
				  config:get_map_here()),
	ok.


%%开启客户端监控树
start_client() ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {tcp_client_sup,
                {tcp_client_sup, start_link,[]},
                transient, infinity, supervisor, [tcp_client_sup]}),
    ok.

%%开启tcp listener监控树
start_tcp(Port) ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {tcp_listener_sup,
                {tcp_listener_sup, start_link, [Port]},
                transient, infinity, supervisor, [tcp_listener_sup]}),
    ok.

%%开启节点接口进程
start_node_interface([Ip, Port, Server_no, Node_type]) ->
    {ok,_} = supervisor:start_child(
               server_sup,
               {mod_node_interface,
                {mod_node_interface, start_link,[Ip, Port, Server_no, Node_type]},
                permanent, 10000, supervisor, [mod_node_interface]}),
    ok.

%% 开启mod_stall_server 监控树
start_stall() ->
	mod_stall_server_sup:start(),
	ok.

%% 开启mod_stall_server 监控树
start_increase() ->
	mod_increase:get_mod_increase_pid(),
	ok.

start_sale() ->
	mod_sale:get_mod_sale_pid(),
	ok.

start_token_task() ->
	mod_token_task:get_token_pid(),
	ok.

%%开启野外boss管理
start_boss_manage() ->
	mod_boss_manage:get_boss_manage_pid(),
	ok.

%%开启活动管理模块
start_active_manage() ->
	mod_active:get_active_pid(),
	ok.

start_pet_battle() ->
	mod_pet_battle:get_mod_pet_battle_pid(),
	ok.

%%开启排行榜管理模块
start_top_manage() ->
	mod_top:get_mod_top_pid(),
	ok.

%% 开启自由战场模块
start_free_war() ->
	%mod_free_war:get_mod_free_war_pid(),
	ok.

%% 开启mod_duplicate_server
start_duplicate() ->
	mod_duplicate_agent:get_duplicate_pid(),
	ok.

start_open_box() ->
	mod_box_agent:get_open_box_pid(),
	ok.


start_open_smshop() ->
	mod_smshop_agent:get_open_smshop_pid(),
	ok.

start_shop() ->
	mod_shop:get_mod_shop_pid(),
	ok.

start_first_manage() ->
	mod_first_manage:get_mod_first_manage_pid(),
	ok.

start_tokey() ->
	mod_tokey:get_mod_tokey_pid(),
	ok.

start_activity_seven() ->
	mod_activity_seven:get_mod_activity_seven_pid(),
	ok.

start_sysmsg() ->
	mod_sysmsg:get_mod_sysmsg_pid(),
	ok.

start_top() ->
	mod_top:get_mod_top_pid(),
	ok.


