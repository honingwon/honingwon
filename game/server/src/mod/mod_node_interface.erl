%%%------------------------------------
%%% @Module  : mod_node_interface
%%% @Created : 2011.03.08
%%% @Description: 服务器节点对服务外接口
%%%------------------------------------
-module(mod_node_interface).
-behaviour(gen_server).

-include("common.hrl").
-export([
            start_link/4,
            rpc_server_add/6,
            server_list/0,
            send_to_all/1,
            broadcast_to_world/2,
			broadcast_to_realm/3,
			boradcast_box_goods_msg/3,
			get_server_list/0,
			stop_game_server/1,
			load_base_data/2,
			online_state/0,
			get_system_load/0,
			broadcast_to_relation_online/5,
			broadcast_to_world_guild_user/3,
			set_game_server/2,
			broadcast_stop_war_to_world/1										
        ]).
 
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-define(KILL_SEND_TIME_OUT, 1 * 60 * 1000).
-define(KILL_SEND_COUNT, 500).
-define(MAX_PLAYER_COUNT, 3000).

%% ====================================================================
%% 对外函数
%% ====================================================================
%% 获取所有节点的列表(不包括当前节点)
%% 返回:[#t_server_node{} | ...]
server_list() ->
    ets:tab2list(?ETS_SERVER_NODE).

%% 接收其它节点的加入信息
rpc_server_add(Server_node, Server_no, Node, Node_type, Ip, Port) ->
	gen_server:cast(?MODULE, {rpc_server_add, Server_node, Server_no, Node, Node_type, Ip, Port}).

%% 广播到所有节点
send_to_all(Data) ->
    Servers = server_list(),
    broadcast_to_world(Servers, Data).

start_link(Ip, Port, Server_no, Node_type) ->
    gen_server:start_link({local,?MODULE}, ?MODULE, [Ip, Port, Server_no, Node_type], []).

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%% --------------------------------------------------------------------
init([Ip, Port, Server_no, Node_type]) ->
    net_kernel:monitor_nodes(true),   
    ets:new(?ETS_SERVER_NODE, [{keypos, #t_server_node.server_node}, named_table, public, set]),
	Server_node = lists:concat([Server_no, "__", node()]),
    State = #t_server_node{server_node = Server_node, server_no = Server_no, node = node(), node_type = Node_type, ip = Ip, port = Port},
	misc:write_system_info({self(), node_info}, server_node_info, State),
    add_server_to_db(State),
	erlang:send_after(100, self(), get_and_call_server),
	erlang:send_after(?KILL_SEND_TIME_OUT, self(), {kill_send_time_out}),
	misc:write_monitor_pid(self(),?MODULE, {}),
    {ok, State}.

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
			?WARNING_MSG("mod_node_interface handle_call is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
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
			?WARNING_MSG("mod_node_interface handle_cast is exception:~w~n,Info:~w",[Reason, Info]),
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
			?WARNING_MSG("mod_node_interface handle_info is exception:~w~n,Info:~w",[Reason, Info]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			{noreply, State}
	end.
%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_R, State) ->
	misc:delete_monitor_pid(self()),
    {ok, State}.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra)->
    {ok, State}.

%%---------------------do_call--------------------------------

do_call(Info, _, State) ->
	?WARNING_MSG("mod_node_interface call is not match:~w",[Info]),
    {reply, ok, State}.


%%---------------------do_cast--------------------------------
do_cast({rpc_server_add, Server_node, Server_no, Node, Node_type, Ip, Port}, State) ->
    case Node_type of
        0 -> skip;
        _ ->
            ets:insert(?ETS_SERVER_NODE, 
					   #t_server_node{server_node = Server_node, server_no = Server_no, node = Node, node_type = Node_type, ip = Ip, port = Port})
    end,
    {noreply, State};
do_cast(Info, State) ->
	?WARNING_MSG("mod_node_interface cast is not match:~w",[Info]),
    {noreply, State}.


%%---------------------do_info--------------------------------
%% 获取并通知当前所有节点
do_info(get_and_call_server, State) ->
	get_and_call_server(State),
	{noreply, State};

%% 处理新节点加入事件
do_info({nodeup, Node}, State) ->
    try
        rpc:cast(Node, mod_node_interface, rpc_server_add, 
				 [State#t_server_node.server_node,
				  State#t_server_node.server_no,
				  State#t_server_node.node,
				  State#t_server_node.node_type,
				  State#t_server_node.ip,
				  State#t_server_node.port])
    catch
        _:_ -> skip
    end,
    {noreply, State};

%% 处理节点关闭事件
do_info({nodedown, Node}, State) ->
    %% 检查是否战区节点，并做相应处理
    case ets:match_object(?ETS_SERVER_NODE, #t_server_node{node = Node, _ = '_'}) of
        [_Z] ->
            ets:match_delete(?ETS_SERVER_NODE, #t_server_node{node = Node, _ = '_'});
        _ ->
            skip
    end,
    {noreply, State};

%% 杀掉socket堵塞进程
do_info({kill_send_time_out}, State) ->
	erlang:send_after(?KILL_SEND_TIME_OUT, self(), {kill_send_time_out}),
	lists:foreach(  
	  fun(P)->  
			  case erlang:process_info(P, current_function) of 
				  {current_function,{prim_inet,send,3}} ->  
					  case erlang:process_info(P, message_queue_len) of
						  {message_queue_len, Count} when Count > ?KILL_SEND_COUNT ->
					  		  ?WARNING_MSG("~p~p~p ~p~n",[P, erlang:process_info(P,registered_name),erlang:process_info(P, current_function), erlang:process_info(P, message_queue_len)]), 
					  		  erlang:exit(P, kill); 
						  _ ->
							  ok
					  end;
				  _ ->
					  ok 
			  end 
	  end,erlang:processes()),
	{noreply, State};
	
do_info(Info, State) ->
	?WARNING_MSG("mod_node_interface info is not match:~w",[Info]),
    {noreply, State}.

%% ----------------------- 私有函数 ---------------------------------
%%加入节点信息到数据库
add_server_to_db(State) ->
    db_agent_server:add_server([State#t_server_node.server_node,
								State#t_server_node.server_no,
								State#t_server_node.node,
								State#t_server_node.node_type,
								State#t_server_node.ip,
								State#t_server_node.port]).

%%广播到所有节点的世界频道
broadcast_to_world([], _Data) -> ok;
broadcast_to_world([H | T], Data) ->
    rpc:cast(H#t_server_node.node, lib_send, send_to_local_all, [Data]),
	broadcast_to_world(T, Data).

broadcast_stop_war_to_world([]) -> ok;
broadcast_stop_war_to_world([H | T]) ->
	rpc:cast(H#t_server_node.node, lib_guild, send_stop_war_to_all_local, []),
	broadcast_stop_war_to_world(T).

%%广播到所有节点的一批用户
broadcast_to_world_guild_user([],_GuildID,_Bin) -> ok;
broadcast_to_world_guild_user([H |T], GuildID, Bin) ->
	rpc:cast(H#t_server_node.node, lib_send, send_to_local_guild_user, [GuildID,Bin]),
	broadcast_to_world_guild_user(T, GuildID, Bin ).

%广播到所有节点-玩家上线广播
broadcast_to_relation_online([], _UserID,_NickName, _State, _Bin) -> ok;
broadcast_to_relation_online([H | T], UserId,NickName, State, Bin) ->
	rpc:cast(H#t_server_node.node, lib_send, send_to_relation_online_local, [UserId,NickName, State, Bin]),
	broadcast_to_relation_online(T, UserId,NickName, State, Bin).

%%广播到其它节点的部落频道
broadcast_to_realm([], _Realm, _Data) -> ok;
broadcast_to_realm([H | T], Realm, Data) ->
    rpc:cast(H#t_server_node.node, lib_send, send_to_local_realm, [Realm, Data]),
    broadcast_to_realm(T, Realm, Data).

%%广播诛邪的系统公告
boradcast_box_goods_msg([], _Data, _BroadCastGoodsList) -> ok;
boradcast_box_goods_msg([H | T], Data, BroadCastGoodsList) ->
	rpc:cast(H#t_server_node.node, mod_box_log, broadcast_box_to_local_all, [Data, BroadCastGoodsList]),
	boradcast_box_goods_msg(T, Data, BroadCastGoodsList).

%% 安全退出游戏服务器集群
stop_game_server([]) -> ok;
stop_game_server([H | T]) ->
	rpc:cast(H#t_server_node.node, main, server_stop, []),
	stop_game_server(T).

%% 关闭游戏入口
set_game_server([], _IsOpen) -> ok;
set_game_server([H | T], IsOpen) ->
	rpc:cast(H#t_server_node.node, main, set_server_state, [IsOpen]),
	set_game_server(T, IsOpen).

%% 请求节点加载基础数据
load_base_data([], _Parm) -> ok;
load_base_data([H | T], Parm) ->
	rpc:cast(H#t_server_node.node, mod_kernel, load_base_data, Parm),
	load_base_data(T, Parm).

%%获取并通知所有节点本节点的信息
get_and_call_server(State) ->
    case db_agent_server:select_all_server(State#t_server_node.server_no) of
        [] -> [];
        Servers ->
            F = fun([Server_node, Server_no, Node, Node_type, Ip, Port]) ->
                    Server_node1 = binary_to_list(Server_node),
					Server_no1 = binary_to_list(Server_no),
					Node1 = list_to_atom(binary_to_list(Node)),
					Ip1 = binary_to_list(Ip),
					case Node1 /= State#t_server_node.node of % 自己不写入和不通知
                        true ->
                            case net_adm:ping(Node1) of
                                pong ->
                                    case Node_type =/= 0 of
                                        true ->
                                            ets:insert(?ETS_SERVER_NODE,
                                                #t_server_node{
													server_node = Server_node1,
													server_no = Server_no1,
                                                    node = Node1,
													node_type = Node_type,
                                                    ip = Ip1,
                                                    port = Port
                                                }
                                            );
                                        false ->
                                            ok
                                    end,
                                     %% 通知已有的节点加入当前节点，包括网关 
									try
                                    rpc:cast(Node1, mod_node_interface, rpc_server_add, 
											 [State#t_server_node.server_node,
											  State#t_server_node.server_no,
											  State#t_server_node.node,
											  State#t_server_node.node_type,
											  State#t_server_node.ip,
											  State#t_server_node.port])
									catch
										_:_ -> error
									end;
                                pang ->
                                    db_agent_server:del_server(Server_node)  %%退出服务器集群
                            end;
                        false ->
                            ok
                    end
                end,
            [F(S) || S <- Servers]
    end.

%% 获取服务器列表
get_server_list() ->
	List =
    case server_list() of
        [] -> [];
        Server ->
            F = fun(S) ->
                    [State, Num, System_Status] = 
						case rpc:call(S#t_server_node.node, mod_node_interface, online_state, []) of
                                {badrpc, _} ->	%%Todo 此处可改为 使用定时器，定时获取各节点信息
                                    [4, 0, 9999999999];
                                Ret ->
                                    Ret
                            end,
                    [S#t_server_node.ip, S#t_server_node.port, State, Num, System_Status]
                end,
            [F(S) || S <- Server]
    end,
	
%% 	[NodeState, NodeNum, NodeSystem_Status] = online_state(),
%% 	Node1 = [State#t_server_node.ip,State#t_server_node.port,NodeState, NodeNum, NodeSystem_Status],
%% 	NewList = [Node1|List],
	Server_member_list = lists:map(fun([_, _, _, Num, _]) -> Num end, List),
	Online_count = lists:sum(Server_member_list),
	List1 = lists:filter(fun([_,_,_,_,S1])-> S1 < 900000000 end, List),
	find_game_server_minimum(List1, Online_count). 

find_game_server_minimum(L, Online_count) ->
	TestHost = config:get_test_host(),
	if length(L) == 0 orelse TestHost == 1 -> 
%% 		   [];
		   	IP =  config:get_test_ip(),
			Port = tool:to_integer(config:get_test_port()),
		   {ok, IP, Port};
	   true -> 
		   if erlang:length(L) > 0 ->
		   		  NL = lists:sort(fun([_,_,_,_,S1],[_,_,_,_,S2]) -> S1 < S2 end, L),
				  [[Ip, Port, _State, _Num, _System_Status]|_] = NL,
%% 		   		  if Online_count > ?MAX_PLAYER_COUNT ->
				  if Online_count > 2500 ->
						  {full, Ip, Port};
					  true ->
		   				  {ok, Ip, Port}
		  		  end;
			  true ->
				  {error, 0, 0}
		   end
    end.
 
%% 在线状况
online_state() ->
	System_load = get_system_load(),
   	case ets:info(?ETS_ONLINE, size) of
       	undefined ->
           	[0, 0, System_load];
       	Num when Num < 200 -> %顺畅
           	[1, Num, System_load];
       	Num when Num > 200 , Num < 500 -> %正常
           	[2, Num, System_load];
       	Num when Num > 500 , Num < 800 -> %繁忙
           	[3, Num, System_load];
       	Num when Num > 800 -> %爆满
           	[4, Num, System_load]
	end.

get_system_load() ->

	[{_, _, Is_open}] = ets:lookup(service_open,1),
	
	case Is_open > 0 of
		true ->
			MapLoad = 0,

			ScenePlayerCount = 
		   		case ets:info(?ETS_ONLINE, size) of
		       		undefined -> 
						0;
					Num ->
						Num
				end,
			%% 	?PRINT("MapLoad:~w,~w",[MapLoad,ScenePlayerCount]),
			Mod_load = MapLoad , %If_mod_guild + If_mod_sale + If_mod_rank + If_mod_master_apprentice + If_mod_shop + If_mod_carry + If_mod_system + If_mod_kernel,
			misc_timer:cpu_time() + Mod_load + ScenePlayerCount/100;
		_ ->
			9999999999
	end.

