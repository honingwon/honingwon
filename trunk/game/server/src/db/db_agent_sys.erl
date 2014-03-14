%% Author: wangdahai
%% Created: 2013-9-27
%% Description: TODO: Add description to db_agent_sys
-module(db_agent_sys).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([get_sys_first/0,add_sys_first/1,update_sys_first/1]).

%%
%% API Functions
%%
get_sys_first() ->
	Ret = ?DB_MODULE:select_all(t_sys_first, "*",[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

add_sys_first(Info) ->
	?DB_MODULE:insert(t_sys_first, [{type,Info#ets_sys_first.type},
									{user_id,Info#ets_sys_first.user_id},
									{expires_time,Info#ets_sys_first.expires_time},
									{name,Info#ets_sys_first.name}]).

update_sys_first(Info) ->
	?DB_MODULE:update(t_sys_first, [{user_id,Info#ets_sys_first.user_id},
									{expires_time,Info#ets_sys_first.expires_time}],
										 [{type, Info#ets_sys_first.type}]).

%%
%% Local Functions
%%

