%% Author: liaoxiaobo
%% Created: 2012-11-6
%% Description: TODO: Add description to pp_mounts
-module(pp_mounts).
-export([handle/3]).
-include("common.hrl").
%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([]).

%%
%% API Functions
%%

%% 获得坐骑列表
handle(?PP_MOUNT_LIST_UPDATE, PlayerStatus, [ID]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
					{apply_cast,lib_mounts,get_mounts,
					 [ID,PlayerStatus#ets_users.other_data#user_other.pid_send]}),
	ok;

%% 坐骑出战状态改变
handle(?PP_MOUNT_STATE_CHANGE, PlayerStatus, [ID,State]) ->
	Pet = lib_pet:get_fight_pet(),
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'update_mounts_state',PlayerStatus,ID,State}) of
		{ok, NewPlayerStatus} ->
			NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
%% 			{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
%% 			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
			{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus1]),
			%%样式广播周围玩家
			mod_map_agent:send_to_area_scene(
			  NewPlayerStatus1#ets_users.current_map_id,
			  NewPlayerStatus1#ets_users.pos_x,
			  NewPlayerStatus1#ets_users.pos_y,
			  PlayerScenBin),
			{update_map, NewPlayerStatus1};
		_ ->
			ok
	end;
%% 	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
%% 					{apply_cast,lib_mounts,update_mounts_state,
%% 					 [ID,State,PlayerStatus#ets_users.other_data#user_other.pid_send]}),
%% 	ok;

%% 放生
handle(?PP_MOUNT_RELEASE, PlayerStatus, [ID]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
					{apply_cast,lib_mounts,mounts_released,
					 [ID,PlayerStatus#ets_users.other_data#user_other.pid_send]}),
	ok;

%% 喂养
handle(?PP_MOUNT_UPGRADE, PlayerStatus, [ID,List]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
										{
										 'item_feed',
										 PlayerStatus,
										 ID,
										 List
										 }) of
				{ok,0} ->
					ok;
				{ok,1} ->
					NewPlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus),
					{update, NewPlayerStatus1};
				_ ->
					ok
			end;
%% 	        {ok, ResData} = pt_28:write(?PP_MOUNT_UPGRADE, Res),
%% 	        lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResData),
		_ ->
			ok
	end;

%% 进阶
handle(?PP_MOUNT_STAIRS_UPDATE, PlayerStatus, [ID]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'mounts_stairs_lvup', PlayerStatus, ID}) of
		{ok, NeedCopper,Re} ->
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
			case Re =:= 1 of
				true ->
					{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus1]),
					%%样式广播周围玩家
					mod_map_agent:send_to_area_scene(
					  NewPlayerStatus1#ets_users.current_map_id,
					  NewPlayerStatus1#ets_users.pos_x,
					  NewPlayerStatus1#ets_users.pos_y,
					  PlayerScenBin);
				_ ->
					skip
			end,
		
			{update, NewPlayerStatus1};
		_ ->
			ok
	end;	

%% 坐骑洗练
handle(?PP_MOUNT_REFINED_UPDATE, PlayerStatus, [ID, IsYuanBao]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {mounts_refined_update, PlayerStatus, ID, IsYuanBao}) of
		{ok, NeedYuanBao, NeedCopper} ->
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, NeedYuanBao, 0, 0, NeedCopper),
			NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
			{update, NewPlayerStatus1};
		_ ->
			ok
	end;


%% 进化
handle(?PP_MOUNT_GROW_UPDATE, PlayerStatus, [ID,IsProt]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'mounts_grow_up_lvup', 
																				 PlayerStatus, 
																				 IsProt,
																				 ID}) of
		{ok, NeedCopper} ->
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
			{update, NewPlayerStatus1};
		false ->
			ok
	end;	

%% 提升
handle(?PP_MOUNT_QUALITY_UPDATE, PlayerStatus, [ID,IsProt]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'mounts_qualification_lvup', PlayerStatus,IsProt, ID}) of
		{ok, NeedCopper} ->
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, NeedCopper),
			NewPlayerStatus1 = lib_player:calc_properties_send_self(NewPlayerStatus),
			{update, NewPlayerStatus1};
		false ->
			ok
	end;	
	

%% 封印
handle(?PP_MOUNT_REMOVE_SKILL, PlayerStatus, [ID,SkillGroupID]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'seal_skill', PlayerStatus,ID,SkillGroupID}) of
		{ok} ->
			PlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus),
			{update, PlayerStatus1};
		false ->
			ok
	end;	

%% 删除
handle(?PP_MOUNT_REMOVE_SKILL1, PlayerStatus, [ID,SkillGroupID]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'delete_skill', PlayerStatus,ID,SkillGroupID}) of
		{ok} ->
			PlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus),
			{update, PlayerStatus1};
		false ->
			ok
	end;	



%% 悟道
handle(?PP_MOUNT_SKILL_ITEM_REFRESH, PlayerStatus, [Type]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'ref_skill_book', PlayerStatus, Type}) of
		{ok, NewPlayerStatus,ReduceYuanBao, ReduceBindYuanBao} ->
			NewPlayerStatus1 = lib_player:reduce_cash_and_send(NewPlayerStatus,  ReduceYuanBao, ReduceBindYuanBao,0, 0,{?CONSUME_YUANBAO_REFRESH_MOUNTS,0,Type}),
			{update, NewPlayerStatus1};
		false ->
			ok
	end;
	

%% 技能书获得
handle(?PP_MOUNT_SKILL_ITEM_GET, PlayerStatus, [Place]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_skill_book', PlayerStatus, Place}) of
		{ok, NewPlayerStatus} ->
			{update, NewPlayerStatus};
		false ->
			ok
	end;


%% 获取当前技能书的列表
handle(?PP_MOUNT_GET_SKILL_BOOK_LIST, PlayerStatus, []) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
					{apply_cast,lib_mounts,get_skill_book_list,
					 [
					  PlayerStatus#ets_users.mounts_skill_books,
					  PlayerStatus#ets_users.mounts_skill_books_luck,
					  PlayerStatus#ets_users.other_data#user_other.pid_send]}),
	ok;


%% 获取坐骑信息
handle(?PP_MOUNT_GET_OTHER_MOUNTS, PlayerStatus, [UserID,MountsID]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
					{apply_cast,lib_mounts,get_other_mounts_info,
					 [
					  PlayerStatus#ets_users.id,
					  UserID,
					  MountsID,
					  PlayerStatus#ets_users.other_data#user_other.pid_send]}),
	ok;


%% 坐骑融合
handle(?PP_MOUNT_INHERIT, PlayerStatus, [MainID,MasterID]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
					{apply_cast,lib_mounts,update_ronghe,
					 [
					  PlayerStatus,
					  MainID,MasterID]}),
	ok;


handle(Cmd, _, _) ->
	?WARNING_MSG("pp_mounts cmd is not : ~w",[Cmd]),
	ok.



