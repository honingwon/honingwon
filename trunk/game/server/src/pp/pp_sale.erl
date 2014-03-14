%%%-------------------------------------------------------------------
%%% Module  : pp_sale
%%% Author  : 
%%% Description : 寄售系统
%%%-------------------------------------------------------------------
-module(pp_sale).


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

%% ----------------------------------------------------------------------
%% 	22001 添加寄售
%% ----------------------------------------------------------------------
handle(?PP_SALES_ITEM_ADD, PlayerStatus, [Place, PriceType, Price, ValidTime]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			case mod_sale:add_sale_item(PlayerStatus, Place, PriceType, Price, ValidTime) of
				{ok, NewPlayerStatus} ->
					{ok, BinData} = pt_22:write(?PP_SALES_ITEM_ADD, 1),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					{update, NewPlayerStatus};
				{fail, Msg} ->
					do_error_msg(PlayerStatus, Msg),
			        {ok, BinData} = pt_22:write(?PP_SALES_ITEM_ADD, 0),
			        lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			        ok
			end;
		_ ->
			ok
	end;

%% ----------------------------------------------------------------------
%% 	22002  取回、撤消寄售
%% ----------------------------------------------------------------------
handle(?PP_SALES_ITEM_DELETE, PlayerStatus, [SaleId, Page]) ->
	case mod_sale:delete_sale_item(PlayerStatus, [SaleId, Page]) of		
		{ok, NewPlayerStatus, Type} ->
			{ok, BinData} = pt_22:write(?PP_SALES_ITEM_DELETE, [1, ""]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			case Type of
				item ->
					skip;
				_ ->
					{update_db, NewPlayerStatus}
			end;
		{fail, Msg} ->
			do_error_msg(PlayerStatus, Msg),
			{ok, BinData} = pt_22:write(?PP_SALES_ITEM_DELETE, [0,  Msg]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			ok
	end;

%% ----------------------------------------------------------------------
%% 	22006 查看已上架寄售（我的寄售）
%% ----------------------------------------------------------------------
handle(?PP_SALES_ITEM_QUERY_SELF, PlayerStatus, [Page]) ->
	mod_sale:list_sale_items_self(PlayerStatus, Page),
	ok;

%% ----------------------------------------------------------------------
%% 	22003 查找寄售(寄售类型、职业、品质、最低等级，最大等级、关键字、种类列表、页码)
%% ----------------------------------------------------------------------
handle(?PP_SALES_ITEM_QUERY, PlayerStatus, [Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page]) ->
%% 	[Sum, Page1, SaleList] = mod_sale:list_sale_items([PlayerStatus#ets_users.id, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page]),
%% 	{ok, BinData} = pt_22:write(?PP_SALES_ITEM_QUERY, [Sum, Page1, SaleList]),
%% 	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	
	mod_sale:list_sale_items([PlayerStatus#ets_users.id, Type, Career, Quality, LowLevel, UpLevel, KeyName, CategoryList, Page,PlayerStatus#ets_users.other_data#user_other.pid_send]),
	ok;

%% ----------------------------------------------------------------------
%% 	22004 购买寄售
%% ----------------------------------------------------------------------
handle(?PP_SALES_ITEM_BUY, PlayerStatus, [SaleId]) ->
	case mod_sale:buy_sale_item(PlayerStatus, [SaleId]) of
		{ok, NewPlayerStatus} ->  %% 购买成功
			{ok, BinData} = pt_22:write(?PP_SALES_ITEM_BUY, [1, SaleId]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{update_db, NewPlayerStatus};
		{fail, ErrorCode} ->      %% ErrorCode 失败代码
			{ok, BinData} = pt_22:write(?PP_SALES_ITEM_BUY, [ErrorCode, SaleId]),			
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			ok
	end;

%% ----------------------------------------------------------------------
%% 	22007 寄售售铜币、元宝
%% ----------------------------------------------------------------------
handle(?PP_SALES_MONEY_ADD, PlayerStatus, [PriceType, Amount, Price, ValidTime]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			case mod_sale:sale_money(PlayerStatus, PriceType, Amount, Price, ValidTime) of
				{ok, NewPlayerStatus} ->
					{ok, BinData} = pt_22:write(?PP_SALES_MONEY_ADD, [1]),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					{update_db, NewPlayerStatus};
				{fail, Msg} ->
					do_error_msg(PlayerStatus, Msg),
			        {ok, BinData} = pt_22:write(?PP_SALES_MONEY_ADD, [0]),
			        lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			        ok
			end;
		_ ->
			ok
	end;

%% ----------------------------------------------------------------------
%% 再售
%% ----------------------------------------------------------------------
handle(?PP_SALES_SALE_AGAIN, PlayerStatus, [SaleId]) ->
	case mod_sale:sale_again(PlayerStatus, SaleId) of
		{ok, NewPlayerStatus} ->
			{ok, BinData} = pt_22:write(?PP_SALES_SALE_AGAIN, [1, ""]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{update_db, NewPlayerStatus};
		{fail, Msg} ->
			do_error_msg(PlayerStatus, Msg),
			{ok, BinData} = pt_22:write(?PP_SALES_SALE_AGAIN, [0, Msg]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			ok
	end;
			
%% ----------------------------------------------------------------------
%% 错误处理
%% ----------------------------------------------------------------------
handle(_Cmd, _Status, _Data) ->
    {error, "pp_sale no match"}.

%%====================================================================
%% Private functions
%%====================================================================
do_error_msg(User, Msg) ->
	lib_chat:chat_sysmsg_pid([User#ets_users.other_data#user_other.pid_send, ?FLOAT,?None,?ORANGE, Msg]).
