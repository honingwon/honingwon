%% Author:
%% Created: 
%% Description: TODO: 用户技能处理
-module(db_agent_skill).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([
		 get_user_all_skill/1,
		 get_user_skill_bar/1
		 ]).

%%
%% API Functions
%%

%获取玩家所有技能
get_user_all_skill(UserID) ->
	Ret = ?DB_MODULE:select_all(t_users_skills, "template_id, valid_date, lv", 
								[{user_id, UserID}, {is_exist, 1}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%获取玩家快捷栏信息
get_user_skill_bar(UserID) ->
	Ret = ?DB_MODULE:select_all(t_users_skill_bar,"bar_index,type,template_id,group_id",
								[{user_id, UserID}]),
	case Ret of
		[] -> [];
		_ -> Ret
	end.


%%
%% Local Functions
%%

