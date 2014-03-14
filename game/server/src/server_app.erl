%%%-----------------------------------
%%% @Module  : server_app
%%% @Created : 2011.02.22 
%%% @Description: 游戏服务器应用启动
%%%-----------------------------------
-module(server_app).
-behaviour(application).

-include("common.hrl").

-export([start/2, stop/1]).

start(normal, []) ->	
	ets:new(?ETS_SYSTEM_INFO, [set, public, named_table]),
	ets:new(?ETS_MONITOR_PID, [set, public, named_table]),
	ets:new(?ETS_STAT_SOCKET, [set, public, named_table]),
	ets:new(?ETS_STAT_DB, [set, public, named_table]),
	
	Log_level = config:get_log_level(),
	loglevel:set(tool:to_integer(Log_level)),	
    {ok, SupPid} = server_sup:start_link(),
	misc_timer:start(server_sup),
	
	
	db_agent_template:init_db(),
	db_agent_admin:init_db(),
 	db_agent:init_db(),
		
	[Ip, Port] = config:get_tcp_listener(),
	Server_no = config:get_server_no(),
	Node_type = 1,
	ping_other_nodes(Server_no),
	
	misc:write_system_info({self(), log_level}, log_level, Log_level),
	misc:write_system_info({self(), server_no}, server_no, Server_no),
	
    server:start([Ip, tool:to_integer(Port), Server_no, Node_type]),
    {ok, SupPid}.
  
stop(_State) ->  void. 

ping_other_nodes(Server_no) ->
	ping_gateway(),
    case db_agent_server:select_all_server(Server_no) of
        [] -> [];
        Servers ->
            F = fun([_Server_node, _Server_no, Node, _Node_type, _Ip, _Port]) ->
                    Node0 = list_to_atom(binary_to_list(Node)),
					catch net_adm:ping(Node0)
                end,
            [F(S) || S <- Servers]
    end.

ping_gateway()->
	case config:get_gateway_node() of
		undefined -> no_action;
		Gateway_node ->	
			catch net_adm:ping(Gateway_node)
	end.

