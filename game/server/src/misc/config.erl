-module(config). 
-include("common.hrl").

-include_lib("stdlib/include/ms_transform.hrl"). 

-define(APP, server).

-export([get_log_level/0, get_infant_ctrl/0, get_infant_post_site/0, get_server_no/0, get_tcp_listener/0,
        get_mysql_config/1, get_mongo_config/0, get_slave_mongo_config/0, has_slave_mongo_config/0,
        get_read_data_mode/0, get_gateway_node/0, get_service_wait_time/0, get_map_here/0,
        get_guest_account_url/0, get_can_gmcmd/0, get_strict_md5/0, get_http_ips/0,
		 get_test_host/0, get_login_site/0, get_infant_key/0, get_guild_insert_site/0,
		 get_test_ip/0, get_nick_insert_site/0,get_service_hf_time/0,get_login_server_id/0,
		 get_test_port/0,
		 get_ticket/0,
		 get_operate_type/0,
		 get_service_start_time/0,
		 get_protocol_key/0]).

%% 获取 application的配置信息
get_log_level() ->
    case application:get_env(?APP, log_level) of
	{ok, Log_level} -> Log_level;
	_ -> 3
    end.

%%获取默认登录站点
get_login_site() ->
	case application:get_env(?APP, login_site) of
	{ok, Log_Site} -> 
		Log_Site;
	undefined -> 
		throw(undefined)
    end.
%%获取联运平台类型
get_operate_type() ->
	case application:get_env(?APP, operate_type) of
	{ok, Operate_Type} -> 
		Operate_Type;
	undefined -> 
		throw(undefined)
    end.

%%获取防沉迷提交站点
get_infant_post_site() ->
	case application:get_env(?APP, infant_post_site) of
	{ok,Site} ->
		Site;
		undefined -> 
			throw(undefined)
    end.
	
%% 获取 防沉迷开关
get_infant_ctrl() ->
    case application:get_env(?APP, infant_ctrl) of
	{ok, Mode} -> tool:to_integer(Mode);
	_ -> 0
    end.

%% 获取 防沉迷验证KEY
get_infant_key() ->
	case application:get_env(?APP, infant_key) of
		{ok,Key} ->
			Key;
		undefined -> 
			throw(undefined)
    end.

%%或取注册帐号插入SITE
get_nick_insert_site() ->
	case application:get_env(?APP, nick_insert_site) of
		{ok,Site} ->
			Site;
		undefined -> 
			[]
    end. 

%%或取帮派名称插入SITE
get_guild_insert_site() ->
	case application:get_env(?APP, guild_insert_site) of
		{ok,Site} ->
			Site;
		undefined -> 
			[]
    end. 
  

%% 获取开服编号
get_server_no() ->
    case application:get_env(?APP, server_no) of
		{ok, Server_no} -> 
			Server_no;
		_ -> 
			"0"
    end.

get_tcp_listener() ->
    case application:get_env(?APP, tcp_listener) of
 	{ok, false} -> throw(undefined);
	{ok, Tcp_listener} -> 
		try
			{_, Ip} = lists:keyfind(ip, 1, Tcp_listener),
			{_, Port} = lists:keyfind(port, 1, Tcp_listener),
			
			[Ip, Port]
		catch
		 	_:_ -> exit({bad_config, {server, {tcp_listener, config_error}}})
		end;
 	undefined -> throw(undefined)
    end.

get_mysql_config(Data_Config) ->
    case application:get_env(?APP, Data_Config) of
 	{ok, false} -> throw(undefined);
	{ok, Mysql_config} -> 
					{_, Host} = lists:keyfind(host, 1, Mysql_config),
					{_, Port} = lists:keyfind(port, 1, Mysql_config),
					{_, User} = lists:keyfind(user, 1, Mysql_config),
					{_, Password} = lists:keyfind(password, 1, Mysql_config),
					{_, DB} = lists:keyfind(db, 1, Mysql_config),
					{_, Encode} = lists:keyfind(encode, 1, Mysql_config),
					[Host, Port, User, Password, DB, Encode];		
 	undefined -> throw(undefined)
    end.

get_mongo_config() ->
    case application:get_env(?APP, emongo_config) of
 	{ok, false} -> throw(undefined);
	{ok,Emongo_config} -> 
					{_, PoolId} = lists:keyfind(poolId, 1, Emongo_config),
					{_, EmongoSize} = lists:keyfind(emongoSize, 1, Emongo_config),
					{_, EmongoHost} = lists:keyfind(emongoHost, 1, Emongo_config),
					{_, EmongoPort} = lists:keyfind(emongoPort, 1, Emongo_config),
					{_, EmongoDatabase} = lists:keyfind(emongoDatabase, 1, Emongo_config),
					[PoolId, EmongoHost, EmongoPort, EmongoDatabase, EmongoSize];		
 	undefined -> throw(undefined)
    end.

get_slave_mongo_config() ->
    case application:get_env(?APP, slave_emongo_config) of
 	{ok, false} -> throw(undefined);
	{ok,Emongo_config} -> 
					{_, PoolId} = lists:keyfind(poolId, 1, Emongo_config),
					{_, EmongoSize} = lists:keyfind(emongoSize, 1, Emongo_config),
					{_, EmongoHost} = lists:keyfind(emongoHost, 1, Emongo_config),
					{_, EmongoPort} = lists:keyfind(emongoPort, 1, Emongo_config),
					{_, EmongoDatabase} = lists:keyfind(emongoDatabase, 1, Emongo_config),
					[PoolId, EmongoHost, EmongoPort, EmongoDatabase, EmongoSize];		
 	undefined -> get_mongo_config()
    end.

has_slave_mongo_config() ->
	case application:get_env(?APP, slave_emongo_config) of
		{ok, false} -> false;
		{ok, _Emongo_config} -> true
	end.

get_read_data_mode() ->
    case application:get_env(?APP, base_data_from_db) of
		{ok, Mode} -> tool:to_integer(Mode);
	 	_ -> 0
    end.

get_gateway_node() ->
    case application:get_env(?APP, gateway_node) of
	{ok, Gateway_node} -> Gateway_node;
	_ -> undefined
    end.

get_service_wait_time() ->
	case application:get_env(?APP, service_wait_time) of
	{ok,Wait_time} ->Wait_time;
	_ -> undefined
	end.

get_map_here() ->
	case application:get_env(?APP, map_here) of
		undefined ->
			[];
		{ok, all} -> 
   			MS = ets:fun2ms(fun(S) when S#ets_map_template.type =/= 2 -> 
									S#ets_map_template.map_id	
							end),
   			ets:select(?ETS_MAP_TEMPLATE, MS);
		{ok, L} when is_list(L) ->
			L1 = lists:filter(fun(Id) ->
									  case ets:lookup(?ETS_MAP_TEMPLATE, Id) of
										  [] ->
											  false;
										  [Map] ->
											  %% 副本的不创建  type 1普通，2副本
											  if
												  Map#ets_map_template.type =:= 1 ->
													true;
												  true ->
													  false
											  end											  
									  end
							  end,
							  L),
			L1;
		_ ->
			[]
	end.


get_guest_account_url() ->
    case application:get_env(?APP, guest_account_url) of
			{ok, Guest_account_url} -> Guest_account_url;
	_ -> ""
    end.	

get_can_gmcmd() ->
    case application:get_env(?APP, can_gmcmd) of
			{ok, Can_gmcmd} -> Can_gmcmd;
	_ -> 0
    end.  

get_strict_md5() ->
    case application:get_env(?APP, strict_md5) of
			{ok, Strict_md5} -> Strict_md5;
	_ -> 1
    end.  	

get_http_ips() ->
    case application:get_env(?APP, http_ips) of
			{ok, Http_ips} -> Http_ips;
	_ -> []
    end.  	

get_test_host() ->
    case application:get_env(?APP, test_host) of
			{ok, Test_host} -> Test_host;
	_ -> 1
    end.  	

get_test_ip() ->
    case application:get_env(?APP, test_ip) of
			{ok, Test_Ip} -> Test_Ip;
	_ -> []
    end.  

get_test_port() ->
    case application:get_env(?APP, test_port) of
			{ok, Test_port} -> Test_port;
	_ -> []
    end.

get_ticket() ->
	case application:get_env(?APP, ticket) of
			{ok, Ticket} -> Ticket;
	_ -> []
    end.

get_service_start_time() ->
	case application:get_env(?APP, service_start_time) of
		{ok, StartTime} -> 
			calendar:datetime_to_gregorian_seconds(StartTime)-?DIFF_SECONDS_0000_1900;
		_ -> 
			0
    end.

get_service_hf_time() ->
	case application:get_env(?APP, service_hf_time) of
		{ok, StartTime} -> 
			calendar:datetime_to_gregorian_seconds(StartTime)-?DIFF_SECONDS_0000_1900;
		_ -> 
			0
    end.

get_login_server_id() ->
	case application:get_env(?APP, login_server_id) of
		{ok, ServerIdList} ->
			ServerIdList;
		_ ->
			[]
	end.


get_protocol_key() ->
	case application:get_env(?APP, protocol_key) of
		{ok, Key} ->  Key;
		_ -> 
			0
    end.
