%% Author: wangdahai
%% Created: 2013-4-8
%% Description: TODO: Add description to db_agent_token_task
-module(db_agent_token_task).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([get_token_list/0,delete_token/1,add_token/1]).

%%
%% API Functions
%%

get_token_list() ->
	Ret = ?DB_MODULE:select_all(t_token_publish_info, "*", 
								[],[{type},{token_id}],[]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

delete_token(Token_id) ->
	?DB_MODULE:delete(t_token_publish_info, [{token_id, Token_id}]).

add_token(Publish_info) ->
	?DB_MODULE:insert(t_token_publish_info, [{token_id, Publish_info#ets_token_publish_info.token_id},
											{publish_user_id, Publish_info#ets_token_publish_info.publish_user_id},
											{publish_level, Publish_info#ets_token_publish_info.publish_level},
											{type, Publish_info#ets_token_publish_info.type}]).

%%
%% Local Functions
%%

