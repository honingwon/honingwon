%%%-------------------------------------------------------------------
%%% Module  : pp_stall
%%% Author  : 谢中良
%%% Created : 2011-3-18
%%% Description : 
%%%-------------------------------------------------------------------
-module(pp_stall).

%%--------------------------------------------------------------------
%% Include files 
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports 
%%--------------------------------------------------------------------
-export([handle/3]).

%%====================================================================
%% External functions 
%%====================================================================

handle(?PP_STALL_CREATE, PlayerStatus, [StallName, SellList, BuyList]) ->
	do_stall_create(?PP_STALL_CREATE, PlayerStatus, [StallName, SellList, BuyList]);
handle(?PP_STALL_CANCEL, PlayerStatus, _) ->
	do_stall_cancel(?PP_STALL_CANCEL, PlayerStatus);
handle(?PP_STALL_BUY, PlayerStatus, [RoleID, Buys]) ->
	do_stall_item_buy(PlayerStatus, RoleID, Buys);
handle(?PP_STALL_SALE, PlayerStatus, [RoleID, Sales]) ->
	do_stall_item_sale(PlayerStatus, RoleID, Sales);
handle(?PP_STALL_CHAT, PlayerStatus, [UserId, ChatMsg]) ->
	do_stall_chat(PlayerStatus, [UserId, ChatMsg]);
handle(?PP_STALL_QUERY, PlayerStatus, [RoleID]) ->
	do_stall_query(PlayerStatus,RoleID).

%%====================================================================
%% Local functions 
%%====================================================================
%% 摆摊条件检查
%% 1.当前位置能否摆摊
%% 2.是否已经在摆摊中
%%====================================================================
do_stall_create(?PP_STALL_CREATE, PlayerStatus, [StallName, SellList, BuyList]) ->
	case check_pos_can_stall() of
		ok ->
			case is_role_stalling() of
				false ->
					do_stall_create1(?PP_STALL_CREATE, PlayerStatus, StallName, SellList, BuyList);				
				true ->
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
											  ?ALTER,?None,?ORANGE,?_LANG_ALREADY_STALL])
			end;
		{error, _Reason} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
								  ?ALTER,?None,?ORANGE,?_LANG_STALL_LOCAL_ERROR])
	end.

do_stall_create1(?PP_STALL_CREATE, PlayerStatus, StallName, SellList, BuyList) ->
	PName = mod_stall_server:get_stall_process_name_by_mapid(PlayerStatus#ets_users.current_map_id),
	%%?PRINT("~ts:~w",["PNAME",PName]),
	case global:whereis_name(PName) of 
		undefined ->
			case mod_stall_server:start_stall_server(PlayerStatus#ets_users.current_map_id) of
				{ok,_} ->
					do_stall_create1(?PP_STALL_CREATE, PlayerStatus, StallName, SellList, BuyList);
				{error, R} ->
					?PRINT("~ts:~w~n",["mod_stall_server start Fail!",R])
			end;
		_ -> global:send(PName, {?PP_STALL_CREATE, PlayerStatus, StallName, SellList, BuyList})
	end.
	%%[StallName, SellList, BuyList] -> pt_15:read(?PP_STALL_CREATE, Bin).

do_stall_cancel(?PP_STALL_CANCEL, PlayerStatus) ->
	PName = mod_stall_server:get_stall_process_name_by_mapid(PlayerStatus#ets_users.current_map_id),
	global:send(PName, {?PP_STALL_CANCEL, PlayerStatus}).
do_stall_item_buy(PlayerStatus, RoleID, Buys) ->
	PName = mod_stall_server:get_stall_process_name_by_mapid(PlayerStatus#ets_users.current_map_id),
	global:send(PName, {?PP_STALL_BUY, PlayerStatus, RoleID, Buys}).
do_stall_item_sale(PlayerStatus, RoleID, Sales) ->
	PName = mod_stall_server:get_stall_process_name_by_mapid(PlayerStatus#ets_users.current_map_id),
	global:send(PName, {?PP_STALL_SALE, PlayerStatus, RoleID, Sales}).
do_stall_chat(PlayerStatus, [UserId, ChatMsg]) ->
	PName = mod_stall_server:get_stall_process_name_by_mapid(PlayerStatus#ets_users.current_map_id),
	global:send(PName, {?PP_STALL_CHAT, PlayerStatus, UserId, ChatMsg}).
do_stall_query(PlayerStatus, RoleID) ->
	PName = mod_stall_server:get_stall_process_name_by_mapid(PlayerStatus#ets_users.current_map_id),
	global:send(PName, {?PP_STALL_QUERY, PlayerStatus, RoleID}).

%% 当前位置能否摆摊
check_pos_can_stall() ->
	ok.
%% 是否已经在摆摊中
is_role_stalling() ->
	false.