%% Author: liaoxiaobo
%% Created: 2013-4-24
%% Description: TODO: Add description to pp_target
-module(pp_target).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([handle/3]).

%%
%% API Functions
%%

handle(?PP_TARGET_LIST_UPDATE, PlayerStatus, []) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_target, {'get_target_list',PlayerStatus#ets_users.achieve_data}),
	ok;



handle(?PP_TARGET_HISTORY_UPDATE, PlayerStatus, []) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_target, {'get_target_history_list'}),
	ok;

handle(?PP_TARGET_GET_AWARD, PlayerStatus, [Id]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_target, {'get_target_award',PlayerStatus,Id}) of
		{Res,NewPlayerStatus} ->
			case Res of
				update ->
					NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
					{update_map, NewPlayerStatus1};
				_ ->
					ok
			end;
		_ ->
			ok
	end;

%%=================================结婚系统====================================================
handle(?PP_MARRY_REQUEST, PlayerStatus, [Id,Type]) ->
	case lib_marry:marry_request(PlayerStatus,Id,Type) of
		{ok,NewStatus} ->			
			{update, NewStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?FLOAT,?None,?RED,Msg]),
			ok
	end;
%% 返回求婚结果
handle(?PP_MARRY_ECHO, PlayerStatus, [Type]) ->%%1 同意，2拒绝，3理由拒绝
	{Res,NewStatus} = 
	if Type > 0 andalso Type < 4 ->
			lib_marry:marry_echo(PlayerStatus,Type);
	   true ->
			lib_marry:marry_echo(PlayerStatus,2)
	end,
	if	Res =:= 1 ->%%如果成功需要等待服务端回应
			skip;
		true ->
			{ok,Bin} = pt_29:write(?PP_MARRY_ECHO, Res),
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin)
	end,
	{update, NewStatus};

handle(?PP_MARRY_HALL_INFO, PlayerStatus, []) ->
	lib_marry_duplicate:get_marry_hall_info(PlayerStatus),
	ok;

%% 发送请帖
handle(?PP_SEND_INVITATION_CARD, PlayerStatus, [List]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {send_invitation_card, List}),
	ok;
%% 送礼
handle(?PP_GIVE_GIFT, PlayerStatus, [Type,Id]) ->
	case lib_marry:give_gife(PlayerStatus, Type,Id) of
		{ok,NewStatus} ->
			{ok,Bin} = pt_29:write(?PP_GIVE_GIFT, [1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update, NewStatus};
		{error, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?FLOAT,?None,?RED,Msg]),
			{ok,Bin} = pt_29:write(?PP_GIVE_GIFT, [0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			ok
	end;

handle(?PP_SEE_GIFT_LIST, PlayerStatus, []) ->
	?DEBUG("PP_SEE_GIFT_LIST:~p",[1]),
	lib_marry_duplicate:see_gift_list(PlayerStatus),
	ok;
%% 发送喜糖
handle(?PP_SEND_CANDY, PlayerStatus, [Type]) ->
	case lib_marry_duplicate:send_candy(Type,PlayerStatus) of
		{ok, Id1, Id2, NewStatus} ->
			{ok, Bin} = pt_29:write(?PP_SEND_CANDY, [1,Type]),
			if	Id1 =:= 0 ->
					skip;
				true ->
					TId = if Id1 =:= NewStatus#ets_users.id -> Id2; true -> Id1 end,
					case lib_player:get_online_info(TId) of
						[] -> skip;
						TInfo ->
							lib_send:send_to_sid(TInfo#ets_users.other_data#user_other.pid_send, Bin)
					end
			end,
			lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update, NewStatus};
		{error, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
												  ?FLOAT,?None,?RED,Msg]),
			%{ok, Bin} = pt_29:write(?PP_SEND_CANDY, [0,Type]),
			%lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			ok
	end;
%% 开始拜堂
handle(?PP_START_MARRY, PlayerStatus, []) ->
	lib_marry_duplicate:start_marry(PlayerStatus),
	ok;

%% 离开礼堂
handle(?PP_QUIT_HALL,PlayerStatus, []) ->
	NewStatus = lib_marry_duplicate:quit_hall(PlayerStatus, quit_hall),
	{update_map, NewStatus};
%% 返回结婚关系列表
handle(?PP_MARRY_LIST,PlayerStatus, []) ->	
	{ok, Bin} = pt_29:write(?PP_MARRY_LIST, [PlayerStatus#ets_users.other_data#user_other.marry_list]),

	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
	ok;
%% 离婚1普通，2强制收费		
handle(?PP_DIVORCE, PlayerStatus, [Id,Type]) ->
	case lib_marry:divorce(Id, Type, PlayerStatus) of
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
			{ok, Bin} = pt_29:write(?PP_DIVORCE, [0,0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			ok;
		NewStatus ->
			{ok, Bin} = pt_29:write(?PP_DIVORCE, [1,Id]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			{ok, Bin1} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus]),
			mod_map_agent:send_to_area_scene(NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,NewStatus#ets_users.pos_y,Bin1),	
			{update_map, NewStatus}
	end;	
%% 修改小妾为妻，原妻变妾10两
handle(?PP_MARRY_CHANGE, PlayerStatus, [Id]) ->
	case lib_marry:marry_change(Id, PlayerStatus) of
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
			{ok, Bin} = pt_29:write(?PP_MARRY_CHANGE, [0,Id]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			ok;
		NewStatus ->
			{ok, Bin} = pt_29:write(?PP_MARRY_CHANGE, [1,Id]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			{ok, Bin1} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus]),
			mod_map_agent:send_to_area_scene(NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,NewStatus#ets_users.pos_y,Bin1),	
			{update_map, NewStatus}
	end;
%% 普通离婚处理
handle(?PP_DIVORCE_REPLY, PlayerStatus, [Id,Res]) ->
	case lib_marry:divorce_reply(Id,Res,PlayerStatus) of
		{false, Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
			{ok, Bin} = pt_29:write(?PP_DIVORCE_REPLY, [0]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			ok;
		NewStatus ->
			{ok, Bin} = pt_29:write(?PP_DIVORCE_REPLY, [1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			{update_map, NewStatus}
	end;

handle(_Cmd, _Status, _Data) ->
    {error, "pp_target no match"}.


%%
%% Local Functions
%%

