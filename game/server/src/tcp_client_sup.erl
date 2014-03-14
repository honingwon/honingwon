%%%-----------------------------------
%%% @Module  : tcp_client_sup
%%% @Author  : txj
%%% @Created : 2011.02.22 
%%% @Description: 客户端服务监控树
%%%-----------------------------------
-module(tcp_client_sup).
-behaviour(supervisor).
-export([start_link/0]).
-export([init/1]).
start_link() ->
    supervisor:start_link({local,?MODULE}, ?MODULE, []).

init([]) ->
    {ok, {{simple_one_for_one, 10, 10},
          [{server_reader, {server_reader,start_link,[]},
            temporary, brutal_kill, worker, [server_reader]}]}}.
