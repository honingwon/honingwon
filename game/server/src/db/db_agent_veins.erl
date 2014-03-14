%% Author: wangdahai
%% Created: 2012-9-11
%% Description: TODO: 用户筋脉数据库操作
-module(db_agent_veins).

%%
%% Include files
%%

-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([get_user_all_veins/1]).

%%
%% API Functions
%%

%获取玩家所有筋脉信息
get_user_all_veins(UserID) ->
	Ret = ?DB_MODULE:select_all(t_users_veins, "acupoint_type, acupoint_levl, gengu_levl, luck", 
								[{user_id, UserID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%%
%% Local Functions
%%

