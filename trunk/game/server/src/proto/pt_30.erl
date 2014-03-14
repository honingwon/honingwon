%% Author: Administrator
%% Created: 2011-3-21
%% Description: TODO: 系统信息
-module(pt_30).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
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
read(?PP_GM_SEND_MESSAGE, <<Mtype:32, Bin/binary>>) ->
	{Mtitle, Bin1} = pt:read_string(Bin),	
	{Content, _} = pt:read_string(Bin1),	
	{ok, [Mtype, Mtitle, Content]};

read(_Cmd, _) ->
	?DEBUG("pt_30 task read cmd:~w is error",[_Cmd]),
	ok.

%%
%%服务端 -> 客户端 ----------------------------
%%
write(?PP_SYS_DATE,Date) ->
	{ok, pt:pack(?PP_SYS_DATE , <<Date:32>>)};

write(?PP_GM_SEND_MESSAGE, IsSucc) ->
	{ok, pt:pack(?PP_GM_SEND_MESSAGE, <<IsSucc:8>>)};


write(_Cmd, _) ->
	?DEBUG("pt_30 task write cmd:~w is error",[_Cmd]),
	ok.



%%
%% Local Functions
%%

