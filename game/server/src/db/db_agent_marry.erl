%% Author: wangyuechun
%% Created: 2013-9-5
%% Description: TODO: 用户结婚数据库操作
-module(db_agent_marry).

%%
%% Include files
%%

-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").
%%
%% Exported Functions
%%
-export([get_user_marry/1,
		get_groom_info/1,
		update_marry/1,
		add_user_marry/1,
		divorce_up_marry_id/1,
		delete_marry/1]).

%%
%% API Functions
%%

%获取玩家所有结婚信息
get_user_marry(UserID) ->
	Ret = ?DB_MODULE:select_all(t_user_marry, "*", 
								[{user_id, UserID}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

get_groom_info(UserID) ->
	?DB_MODULE:select_row(t_users, "id,id,nick_name,nick_name,1,career,sex,0,0,0",[{id, UserID}]).


add_user_marry(MarryInfo) ->
	?DB_MODULE:insert(t_user_marry, [{user_id, MarryInfo#ets_user_marry.user_id},
									{marry_id,MarryInfo#ets_user_marry.marry_id},
									{groom_name, MarryInfo#ets_user_marry.groom_name},
									{bride_name, MarryInfo#ets_user_marry.bride_name},
									{marry_time, MarryInfo#ets_user_marry.marry_time},
									{type, MarryInfo#ets_user_marry.type},
									{career, MarryInfo#ets_user_marry.career},
									{sex, MarryInfo#ets_user_marry.sex},
									{state,MarryInfo#ets_user_marry.state},
									{divorce_state,MarryInfo#ets_user_marry.divorce_state}]).

update_marry(MarryInfo) ->
	?DB_MODULE:update(t_user_marry, [{type, MarryInfo#ets_user_marry.type},
									{state,MarryInfo#ets_user_marry.state},
									{divorce_state,MarryInfo#ets_user_marry.divorce_state}],
										 [{user_id,MarryInfo#ets_user_marry.user_id},
										  {marry_id,MarryInfo#ets_user_marry.marry_id}]).

delete_marry(MarryInfo) ->
	?DB_MODULE:delete(t_user_marry,[{user_id,MarryInfo#ets_user_marry.user_id},
										  {marry_id,MarryInfo#ets_user_marry.marry_id}]).

divorce_up_marry_id(Marry_Id) ->
	?DB_MODULE:update(t_users, [{marry_id,0}],[{id,Marry_Id}]).

%%
%% Local Functions
%%

