%%%-------------------------------------------------------------------
%%% Module  : pp_trade
%%% Author  : 
%%% Description : 交易系统
%%%-------------------------------------------------------------------
-module(pp_trade).



%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").


%%--------------------------------------------------------------------
%% External exports
-export([handle/3]).

%%====================================================================
%% External functions
%%====================================================================
%% ----------------------------------------------------------------
%% 27001 发出交易请求
%% ----------------------------------------------------------------
handle(?PP_TRADE_REQUEST, PlayerStatus, [TargetUserId]) ->
	case lib_trade:request_trade(PlayerStatus, TargetUserId) of
		[ok, TargetPid] ->
			{ok , BinData} = pt_27:write(?PP_TRADE_REQUEST, [1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			 %% 通知对方收到交易请求
			{ok , BinData2} = pt_27:write(?PP_TRADE_REQUEST_RESPONSE, [PlayerStatus#ets_users.id, PlayerStatus#ets_users.nick_name]),
			lib_send:send_to_sid(TargetPid, BinData2),
			ok;
		_ ->
			{ok , BinData} = pt_27:write(?PP_TRADE_REQUEST, [0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			ok
	end;



%% ----------------------------------------------------------------
%% 27003 同意交易请求
%% ----------------------------------------------------------------
handle(?PP_TRADE_ACCEPT, PlayerStatus, [BResult, AUserId]) ->
	[Result, APlayerStatus] = lib_trade:accept_trade(PlayerStatus, BResult, AUserId),
	case BResult of
		1 -> %% 同意交易请求
			case Result of
				1 -> %% 同意且成功
%% 					{ok, BinData} = pt_27:write(?PP_TRADE_ACCEPT, [Result]),
%% 					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),

					ANick = APlayerStatus#ets_users.nick_name,
					BUserId = PlayerStatus#ets_users.id,
					BNick = PlayerStatus#ets_users.nick_name,
					
					{ok, Bin2A} = pt_27:write(?PP_TRADE_START, [BUserId, BNick]),
					{ok, Bin2B} = pt_27:write(?PP_TRADE_START, [AUserId, ANick]),
					%% 通知双方进入交易状态
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin2B),
%% 					lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, Bin2A),
					%% 更新同意方交易状态
					
					Other = PlayerStatus#ets_users.other_data#user_other{trade_status = {1, AUserId}},
					PlayerStatusRest = PlayerStatus#ets_users{other_data = Other},
					%% 通知发起方更新交易状态
%% 					gen_server:cast(lib_player:get_player_pid(AUserId),  {'trade_change_state',
%% 																		   Bin2A, 
%% 																		  {1, BUserId},
%% 																		  []}),
					gen_server:cast(APlayerStatus#ets_users.other_data#user_other.pid,  {'trade_change_state',
																							  Bin2A,
																							  {1, BUserId},
																							  []}),
					
					
					{update_db, PlayerStatusRest}; 
				
				_ -> %% 同意但失败
					{ok, BinData} = pt_27:write(?PP_TRADE_ACCEPT, [Result]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					ok
			end;
		
		0 -> %% 拒绝交易请求
			case Result of
				1 ->%% 发起方在线
					{ok, BinData} = pt_27:write(?PP_TRADE_ACCEPT_RESPONSE, [1,PlayerStatus#ets_users.id, PlayerStatus#ets_users.nick_name]),
					lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData);
				_ ->	
					skip
			end,
			{ok, BinDataB} = pt_27:write(?PP_TRADE_ACCEPT, [0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinDataB),
			ok
	end;



%% ----------------------------------------------------------------
%%  添加交易物品、铜币
%% ----------------------------------------------------------------
handle(?PP_TRADE_ITEM_ADD, PlayerStatus, [Type, BUserId, Place]) ->
	[Result, ATradeList, BPlayerStatus, ItemInfo] = lib_trade:trade_item_add(PlayerStatus, Type, BUserId, Place),
	case Result of
		1 -> %% 添加成功
			Other = PlayerStatus#ets_users.other_data#user_other{trade_list = ATradeList},
			PlayerStatusRest = PlayerStatus#ets_users{other_data =  Other},
			{ok, BinData} = pt_27:write(?PP_TRADE_ITEM_ADD, [Result, Place]),
					
			lib_send:send_to_sid(PlayerStatusRest#ets_users.other_data#user_other.pid_send, BinData),
			{ok, BinData2} = pt_27:write(?PP_TRADE_ITEM_ADD_RESPONSE, [ItemInfo]),

			%% 通知对方更新交易列表
%% 			gen_server:cast(lib_player:get_player_pid(BUserId), {'trade_change_state',
%% 																 BinData2,
%% 																 BPlayerStatus#ets_users.other_data#user_other.trade_status,
%% 																 BPlayerStatus#ets_users.other_data#user_other.trade_list}),
			gen_server:cast(BPlayerStatus#ets_users.other_data#user_other.pid, {'trade_change_state',
																				BinData2,
																				BPlayerStatus#ets_users.other_data#user_other.trade_status,
																				BPlayerStatus#ets_users.other_data#user_other.trade_list}),
			{ok, PlayerStatusRest};
		
		_ -> %% 添加失败
			{ok, BinData} = pt_27:write(?PP_TRADE_ITEM_ADD, [0, Place]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			ok
	end;



%% ----------------------------------------------------------------
%%  移除交易物品、铜币
%% ----------------------------------------------------------------
handle(?PP_TRADE_ITEM_REMOVE, PlayerStatus, [Place]) ->
	{ATrade, BUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	if 
		ATrade =/= 1 -> %% 不在交易中的状态 
			{ok, BinData} = pt_27:write(?PP_TRADE_ITEM_REMOVE, [0, Place]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			ok;
		
		true ->
			[Result, ATradeList, BPlayerStatus, ItemInfo] = lib_trade:item_remove(PlayerStatus, Place),
			case Result of
				1 ->%% 移除成功
					{ok, BinData} = pt_27:write(?PP_TRADE_ITEM_REMOVE, [Result, Place]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
										
					ItemId = ItemInfo#ets_users_items.id,
					{ok, BinData2} = pt_27:write(?PP_TRADE_ITEM_REMOVE_RESPONSE, [ItemId]),
					%% 通知对方交易栏移除
	
					%% 通知对方更新交易状态
%% 					gen_server:cast(lib_player:get_player_pid(BUserId),  {'trade_change_state',
%% 																		  BinData2,
%% 																		  BPlayerStatus#ets_users.other_data#user_other.trade_status,
%% 																		  BPlayerStatus#ets_users.other_data#user_other.trade_list}),
					gen_server:cast(BPlayerStatus#ets_users.other_data#user_other.pid,  {'trade_change_state',
																						 BinData2,
																		                 BPlayerStatus#ets_users.other_data#user_other.trade_status,
																		                 BPlayerStatus#ets_users.other_data#user_other.trade_list}),
					
					PlayerStatusRest = lib_trade:trade_change_state(PlayerStatus,
																	PlayerStatus#ets_users.other_data#user_other.trade_status,
																	ATradeList),
					{ok, PlayerStatusRest};
				
				0 ->
					{ok, BinData} = pt_27:write(?PP_TRADE_ITEM_REMOVE, [Result, Place]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData);
				
				_ ->
					fail
			end
	end;



%% ----------------------------------------------------------------
%%  锁定交易
%% ----------------------------------------------------------------
handle(?PP_TRADE_LOCK, PlayerStatus, []) ->
	{_ATrade, BUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	case lib_player:get_online_player_info_by_id(BUserId) of
		[] ->
			NewPlayerStatus = lib_trade:trade_status_reset(PlayerStatus),
			{ok, NewPlayerStatus};
		
		BPlayerStatus ->		
			{ok, BinData} = pt_27:write(?PP_TRADE_LOCK_RESPONSE, []),
			lib_send:send_to_sid(BPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			NewPlayerStatus = lib_trade:trade_change_state(PlayerStatus,
														   {2, BUserId},
														   PlayerStatus#ets_users.other_data#user_other.trade_list),
			{ok, NewPlayerStatus}
	end;


%% ----------------------------------------------------------------
%%  确定交易
%% ----------------------------------------------------------------
handle(?PP_TRADE_SURE, PlayerStatus, []) ->
	{_ATrade, BUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	[Result, APlayerStatus, BPlayerStatus] = lib_trade:sure_trade(PlayerStatus, BUserId),
	
	case Result of %% 点击确定交易后的结果
		0 -> %% 一方确定，一方锁定
			{ok, BinData} = pt_27:write(?PP_TRADE_SURE_RESPONSE, []),
			lib_send:send_to_sid(BPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{ok, BinData2} = pt_27:write(?PP_TRADE_SURE, [1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData2),
			{ok, APlayerStatus};	
		
		1 -> %% 完成交易
			{ok, BinData} = pt_27:write(?PP_TRADE_RESULT, [Result]),
			lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			 %% 通知对方更新交易
%% 			gen_server:cast(lib_player:get_player_pid(BUserId),{'trade_change_state',
%% 																BinData,
%% 																{0, 0},
%% 																[]}),
			gen_server:cast(BPlayerStatus#ets_users.other_data#user_other.pid,{'trade_change_state',
																			   BinData,
																               {0, 0},
																               []}),
			NewAplyerStatus = lib_trade:trade_change_state(APlayerStatus, {0, 0}, []),	
			{ok, NewAplyerStatus};
		
		2 -> %% 对方不在线，交易失败
			{ok, BinData} = pt_27:write(?PP_TRADE_RESULT, [0]),
			lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{ok, APlayerStatus};
		
		3 -> %% 自己背包满，交易失败
			{ok, BinData} = pt_27:write(?PP_TRADE_RESULT, [0]),
			lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{ok, APlayerStatus};
		
		4 -> %% 对方背包满，交易失败
			{ok, BinData} = pt_27:write(?PP_TRADE_RESULT, [0]),
			lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{ok, APlayerStatus};
		
		5 -> %% 对方未锁定，交易失败
			{ok, BinData} = pt_27:write(?PP_TRADE_RESULT, [0]),
			lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{ok, APlayerStatus};
		
		6 -> %% 数据错误
			{ok, BinData} = pt_27:write(?PP_TRADE_RESULT, [0]),
			lib_send:send_to_sid(APlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{ok, APlayerStatus}
	end;	



%% ----------------------------------------------------------------
%%  取消交易
%% ----------------------------------------------------------------
handle(?PP_TRADE_CANCEL, PlayerStatus, []) ->
	case lib_trade:cancel_trade_1(PlayerStatus) of
		{ok, APlayerStatus} ->
			{ok, APlayerStatus};
		_ ->
			ok
	end;


%% ----------------------------------------------------------------
%%  交易栏铜币更新
%% ----------------------------------------------------------------
handle(?PP_TRADE_COPPER, PlayerStatus, [Amount]) ->
	{_ATrade, BUserId} = PlayerStatus#ets_users.other_data#user_other.trade_status,
	[Result, ATradeList, BPlayerStatus, []] = lib_trade:money_trade(PlayerStatus#ets_users.other_data#user_other.trade_list,
																	2,
																	BUserId,
																	Amount,
																	PlayerStatus#ets_users.copper),
	case Result of
		1 ->
			Other = PlayerStatus#ets_users.other_data#user_other{trade_list = ATradeList},
			PlayerStatusRest = PlayerStatus#ets_users{other_data =  Other},
			{ok, BinData} = pt_27:write(?PP_TRADE_COPPER, [Amount]),

			%% 通知对方交易栏铜币更新
%% 			gen_server:cast(lib_player:get_player_pid(BUserId),{'trade_change_state',
%% 																BinData,
%% 																BPlayerStatus#ets_users.other_data#user_other.trade_status,
%% 																BPlayerStatus#ets_users.other_data#user_other.trade_list}),
			gen_server:cast(BPlayerStatus#ets_users.other_data#user_other.pid,{'trade_change_state',
																			   			BinData,
																                        BPlayerStatus#ets_users.other_data#user_other.trade_status,
																                        BPlayerStatus#ets_users.other_data#user_other.trade_list}),
			{ok, PlayerStatusRest};
		
		_ ->
			ok
	end;


handle(_Cmd, _Status, _Data) ->
	?WARNING_MSG("pp_trade cmd:~w",[_Cmd]), 
    {error, "pp_trade no match"}.

