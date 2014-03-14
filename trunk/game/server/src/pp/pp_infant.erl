%%%-------------------------------------------------------------------
%%% Module  : pp_infant
%%% Author  : 
%%% Description : 防沉迷
%%%-------------------------------------------------------------------
-module(pp_infant).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================

%%防沉迷信息提交
handle(?PP_INFANT_POST, PlayerStatus, [CardName, CardID]) ->
	%% Res验证成功与否  Type 1成年 2未成年
	{Res, Type, NewPlayerStatus} = lib_infant:infant_post(PlayerStatus, CardName, CardID),
	{ok, ResBin} = pt_26:write(?PP_INFANT_POST, [Res, Type]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResBin),
%% 	{ok, NewPlayerStatus};
	{update, NewPlayerStatus};

%%排行榜
handle(?PP_TOP_LIST, PlayerStatus, _) ->
	List = ets:tab2list(?ETS_TOP_BINARY_DATA),
	F = fun(Info, B) ->
			{_,Bin} = Info,
			<<B/binary,Bin/binary>>
		end,
	BinData = lists:foldl(F, <<>>, List),
	{ok, ResBin} = pt_26:write(?PP_TOP_LIST, [BinData]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResBin),
	{ok, PlayerStatus};

%% 副本排行榜
handle(?PP_DUPLICATE_TOP_LIST, PlayerStatus, [DuplicateId]) ->
	lib_top:send_to_dup_top(DuplicateId, PlayerStatus#ets_users.other_data#user_other.pid_send),
	{ok, PlayerStatus};

handle(?PP_CHALLENGE_TOP_INFO, PlayerStatus, [DuplicateId,Index]) ->
	lib_top:get_challenge_top(DuplicateId, Index, PlayerStatus#ets_users.other_data#user_other.pid_send),
	{ok, PlayerStatus};

handle(_Cmd, _Status, _Data) ->
    {error, "pp_infant no match"}.

%%====================================================================
%% Private functions
%%====================================================================


