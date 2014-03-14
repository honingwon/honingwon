%%%--------------------------------------
%%% @Module  : db_agent_server
%%% @Created : 2011.03.08
%%% @Description: 统一的数据库处理模块(服务器列表)
%%%--------------------------------------
-module(db_agent_server).

-include("common.hrl").

-export([add_server/1, del_server/1, select_all_server/1]).

%%加入节点到服务器集群
add_server([Server_node, Server_no, Node, Node_type,Ip, Port]) ->
	?DB_MODULE:replace(t_server_node, 
						[{server_node, Server_node},
						 {server_no, Server_no},
						 {node, Node}, 
						 {node_type, Node_type},
						 {ip, Ip},
						 {port, Port}				 
						]).

%%节点退出服务器集群
del_server(Server_node) ->
	?DB_MODULE:delete(t_server_node, [{server_node, Server_node}]).

%%获取所有节点
select_all_server(Server_no) ->
	?DB_MODULE:select_all(t_server_node, "*", [{server_no, Server_no}]).
