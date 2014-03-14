%% Author: wangdahai
%% Created: 2012-9-4
%% Description: TODO: Add description to lib_gm_cmd
-module(lib_gm_cmd).
-include("common.hrl").

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([get_gm_cmd/1, exe_gm_cmd/3]).

-define(ADD_EXP,"addexp").
-define(ADD_MONEY,"addmoney").
-define(ADD_YUANBAO,"addyuanbao").
-define(ADD_LILIAN,"addlilian").
-define(ADD_ITEM,"additem").
-define(FLY_MAP,"fly").
-define(ENTER_COPY,"in_copy").
-define(QUIT_COPY,"out_copy").
-define(ACCEPT_TASK,"accept_task").
-define(SUBMIT_TASK,"submit_task").
-define(CREATE_MONSTER,"create_mon").
%%
%% API Functions
%%

%% return false | {[cmd],[par]}
get_gm_cmd(MSG) ->
	case config:get_can_gmcmd() of
		0 ->
			false;
		_ ->
			[Flag|List] = tool:to_list(MSG),
			if Flag == 64 andalso length(List) > 0 ->
				case pop_cmd(List, []) of
					false -> 
						false;
					{CMD, Par} ->
		
						if length(Par) > 0 ->
							%%?DEBUG("dhwang_test--CmdInfo:~s.",[MSG]),
							{lists:reverse(CMD, []), Par};
						true ->
							false
						end
				end;		 
			true ->
				false
			end
	end.

exe_gm_cmd(Status, CMD, Par) ->
	
	case CMD of
		?ADD_EXP ->
			NewStatus = lib_player:add_exp(Status,list_to_integer(Par)),
%% 			io:format("exe cmd success cmd:~p,par:~p~n",[CMD, Par]),
			{ok, NewStatus};
		?ADD_MONEY ->
			NewStatus = lib_player:add_cash_and_send(Status, 0, 0,list_to_integer(Par), 0,{?GAIN_MONEY_GM,0,1}),
%% 			io:format("exe cmd success cmd:~p,par:~p~n",[CMD, Par]),
			{ok, NewStatus};
		?ADD_YUANBAO ->
			NewStatus = lib_player:add_cash_and_send(Status, list_to_integer(Par), 0, 0, 0,{?GAIN_MONEY_GM,0,1}),
%% 			io:format("exe cmd success cmd:~p,par:~p~n",[CMD, Par]),
			{ok, NewStatus};
		?ADD_LILIAN ->
			NewStatus = lib_player:add_life_experiences(Status, list_to_integer(Par)),
			lib_player:add_exp(NewStatus,0),%%用来发送经验更新包
%% 			io:format("exe cmd success cmd:~p,par:~p~n",[CMD, Par]),
			{ok, NewStatus};
		?ADD_ITEM ->
			[ItemId, Num] = string:tokens(Par, "|"),

		  	ItemPid = Status#ets_users.other_data#user_other.pid_item,

		  	[Res|_] = gen_server:call(ItemPid, {'gm_add_item', list_to_integer(ItemId), list_to_integer(Num)}),	%%发送给物品进程，收取物品
			
			{ok, Status};
		?FLY_MAP ->
			fly_map(Status, Par);
		?ENTER_COPY ->
			enter_copy(Status, Par);
		?QUIT_COPY ->
			case lib_duplicate:quit_duplicate(Status) of
				{ok, NewStatus} ->
					{update_map, NewStatus};
				_ ->
					{ok, Status}
			end;
		?ACCEPT_TASK ->
			TaskId = list_to_integer(Par),
			gen_server:cast(Status#ets_users.other_data#user_other.pid_task,
					{'accept',
					 TaskId,
					 Status}),
			{ok, Status};
		?SUBMIT_TASK ->
			TaskId = list_to_integer(Par),
			submit_task(Status, TaskId);
		?CREATE_MONSTER ->
			MonId = list_to_integer(Par),
			gen_server:cast(Status#ets_users.other_data#user_other.pid_map, {create_boss, MonId, Status#ets_users.pos_x,
																			 Status#ets_users.pos_y, 0,misc_timer:now_seconds()});
		_ ->
			{error,"error GM CMD"}
	end.


%%
%% Local Functions
%%
%% 
submit_task(PlayerStatus, TaskId) ->
case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_task,
							{'submit_gm',
					 		TaskId,
							PlayerStatus					
							}) of
		[YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards] ->
			NewPlayerStatus = lib_player:add_task_award(PlayerStatus, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards,TaskId),
			case NewPlayerStatus#ets_users.level  =/= PlayerStatus#ets_users.level of
				true ->
					{update_map, NewPlayerStatus};
				_ ->
					{update, NewPlayerStatus}
			end;			
		_ ->
			{ok, PlayerStatus}
end.

%%进入副本，使用前请先离开副本
enter_copy(PlayerStatus, Par) ->
	case string:tokens(Par, "|") of
		[DId,MIndex] ->
			MissionIndex = list_to_integer(MIndex),
			DuplicateId = list_to_integer(DId);
		_ ->
			MissionIndex = 1,
			DuplicateId = list_to_integer(Par)
	end,	
	lib_duplicate:enter_duplicate_by_fly(PlayerStatus, DuplicateId, MissionIndex).

%%飞跃地图
fly_map(Status, Par) ->
			case string:tokens(Par, "|") of
				[MapId1, Pos_x1, Pos_y1] ->				
					{MapId, Pos_x, Pos_y} = {list_to_integer(MapId1),list_to_integer(Pos_x1),list_to_integer(Pos_y1)};
				_->
					{MapId, Pos_x, Pos_y} = {1004,2513,1499}
			end,
			case lib_map:is_stand_pos_to_grid(MapId, Pos_x, Pos_y) of
			true ->
				{MapId2, Pos_x2, Pos_y2} = {MapId, Pos_x, Pos_y};
			_ ->
				case lib_map:get_map_default_point(MapId) of
					[{Pos_x2, Pos_y2}]->
						MapId2 = MapId;
					[] ->
						{MapId2, Pos_x2, Pos_y2} = {1004,2513,1499}
				end
			end,
			case lib_map:is_copy_scene(Status#ets_users.current_map_id) of
				true ->
					{error,"error GM FLY"};
			_ ->
				case gen_server:call(Status#ets_users.other_data#user_other.pid_item, {'transfer_shoe_use', [MapId2, 
																											   Pos_x2,
																											   Pos_y2, 
																											   100,
																											   ?VIP_BSL_HALFYEAR]}) of
				[0] ->
					%%返回成功与否
					{ok, BinData} = pt_14:write(?PP_USE_TRANSFER_SHOE, 0),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, BinData),
					{error,"error GM FLY"};				
				_ ->
					%%更新玩家位置
					{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(Status, MapId2, Pos_x2, Pos_y2),
					%%返回成功与否
					{ok, BinData} = pt_14:write(?PP_USE_TRANSFER_SHOE, 1),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					{update_map, NewPlayerStatus}
				end
			end.


pop_cmd([126|L], CMD) -> {CMD, L};
pop_cmd([], _) -> false;
pop_cmd([H|L], CMD) ->
	pop_cmd(L, [H|CMD]).
	


