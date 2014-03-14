%% Author: Administrator
%% Created: 2011-3-9
%% Description: TODO: Add description to pp_item
-module(pp_item).
-export([handle/3]).
-include("common.hrl").

%%
%% API Functions
%%

%%获得个人所有物品 
handle(?PP_ITEM_PLACE_UPDATE, PlayerStatus, _) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'query_all'}),
	ok;


%%获取仓库所有物品
handle(?PP_DEPOT_ITEM_UPDATE, PlayerStatus, _) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'depot_all'}),
	ok;

%% %%仓库存款 取款操作
%% handle(?PP_DEPOT_MONEY_OPERATE, PlayerStatus, [Type, Copper]) ->
%% 	case lib_item:check_depot_copper(PlayerStatus, Type, Copper) of
%% 		{ok, DepotCopper, AddCopper, ReduceCopper} ->						
%% 			%%更新货币信息
%% 			NewPlayerStatus = PlayerStatus#ets_users{depot_copper=DepotCopper},
%% 			NewPlayerStatus1 = lib_player:reduce_cash(NewPlayerStatus, 0, 0, ReduceCopper, 0),
%% 			NewPlayerStatus2 = lib_player:add_cash(NewPlayerStatus1, 0, AddCopper, 0),			
%% 			{ok, CashData} = pt_20:write(?PP_UPDATE_SELF_INFO, [NewPlayerStatus2#ets_users.yuan_bao,
%% 																NewPlayerStatus2#ets_users.copper,
%% 																NewPlayerStatus2#ets_users.bind_copper,
%% 																NewPlayerStatus2#ets_users.depot_copper,
%% 																NewPlayerStatus2#ets_users.bind_yuan_bao]),
%% 			lib_send:send_to_sid(NewPlayerStatus2#ets_users.other_data#user_other.pid_send, CashData),	
%% 			
%% 			%%返回是否成功
%% 			{ok, BinDate} = pt_14:write(?PP_DEPOT_MONEY_OPERATE, 1),
%% 			lib_send:send_to_sid(NewPlayerStatus2#ets_users.other_data#user_other.pid_send, BinDate),
%% 			{update, NewPlayerStatus2};
%% 		
%% 		{error, _Res} ->
%% 			{ok, BinDate} = pt_14:write(?PP_DEPOT_MONEY_OPERATE, 0),
%% 			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinDate),
%% 			ok
%% 	end;

%%物品移动
handle(?PP_ITEM_MOVE, PlayerStatus, [FromBagType, FromPlace, ToBagType, ToPlace, Amount]) ->
	if FromBagType =:= ToBagType andalso FromPlace =:= ToPlace ->
		   ?WARNING_MSG("PP_ITEM_MOVE:the same place:~w",[PlayerStatus#ets_users.id]),
		   ok;
	   true ->
		if
			FromBagType =:= ?BAG_TYPE_COMMON andalso ToBagType =:= ?BAG_TYPE_COMMON ->%%背包操作
				if
					(FromPlace < ?BAG_BEGIN_CELL orelse ToPlace < ?BAG_BEGIN_CELL) ->
						Pet = lib_pet:get_fight_pet(),
						case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'equip', PlayerStatus, FromPlace, ToPlace,Pet}) of
							{ok} ->								
								NewPlayerStatus = lib_player:calc_properties_send_self(PlayerStatus),
								{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus]),
								%%样式广播周围玩家
								mod_map_agent:send_to_area_scene(
								  NewPlayerStatus#ets_users.current_map_id,
								  NewPlayerStatus#ets_users.pos_x,
								  NewPlayerStatus#ets_users.pos_y,
								  PlayerScenBin),
								{update_map, NewPlayerStatus};							
							_ ->
								ok						 
						end;
					true ->
						gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'move',FromBagType,FromPlace,ToBagType,ToPlace,Amount}),
						ok
						
				end;
			FromBagType =:= ?BAG_TYPE_PET orelse ToBagType =:= ?BAG_TYPE_PET ->%%宠物背包操作只能操作出战宠物
				if	(FromBagType =/= ?BAG_TYPE_PET andalso FromBagType =/= ?BAG_TYPE_COMMON)
					orelse (ToBagType =/= ?BAG_TYPE_PET andalso ToBagType =/= ?BAG_TYPE_COMMON) ->
						skip;
					true ->
						case lib_pet:get_pet_by_id(Amount) of %Amount中存放宠物ID
							[] ->
								skip;
							Info ->
								PetLevel = if ToBagType =:= ?BAG_TYPE_PET -> Info#ets_users_pets.level; true -> 0 end,
								%%gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'pet_equip',PlayerStatus#ets_users.bag_max_count, FromPlace, ToPlace, PetLevel ,Amount})
								case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'pet_equip',PlayerStatus#ets_users.bag_max_count, FromPlace, ToPlace, PetLevel ,Amount}) of
									{ok} ->
										PetInfo = lib_pet:calc_properties(Info),
										{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo]),
										lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
										if	Info#ets_users_pets.state =:= ?PET_FIGHT_STATE ->
												NewPlayerStatus = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo),
												{update_map, PlayerStatus};
											true ->
												ok
										end;										
									_ ->
										skip
								end
						end					
				end;				
			true ->
				if  FromBagType =:= ?BAG_TYPE_COMMON andalso FromPlace < ?BAG_BEGIN_CELL ->
						skip;
					ToBagType =:= ?BAG_TYPE_COMMON andalso ToPlace < ?BAG_BEGIN_CELL ->
						skip;
					true ->
						gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'move',FromBagType,FromPlace,ToBagType,ToPlace,Amount}),			
						ok		
				end
		end
	end;
%% 	pp_map:handle(?PP_ENTER_FREE_WAR, PlayerStatus, []);

handle(?PP_ITEM_EXPLOIT_BUY,PlayerStatus, [ShopItemID, Count]) ->
	Exploit = PlayerStatus#ets_users.other_data#user_other.exploit_info#user_exploit_info.exploit,
 	[Res, ReduceExploit,TemplateID] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{exploit_buy,Exploit,ShopItemID, Count}),
	
	if
		Res =:= 1 ->
			NewExploit = PlayerStatus#ets_users.other_data#user_other.exploit_info#user_exploit_info{exploit = Exploit - ReduceExploit},
			NewOther = PlayerStatus#ets_users.other_data#user_other{exploit_info = NewExploit},
			db_agent_user:expend_user_exploit(PlayerStatus#ets_users.id ,Exploit - ReduceExploit),
			NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther};			

%% 			lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, 0, ReduceExploit, %%后期增加消耗日志
%% 										   1, ?CONSUME_EXPLOIT_ITEM_BUY, misc_timer:now_seconds(), TemplateID, Count,
%% 										   PlayerStatus#ets_users.level);
		true ->
			NewPlayerStatus = PlayerStatus
	end,
	
	%%返回是否成功
	{ok, ResData} = pt_14:write(?PP_ITEM_EXPLOIT_BUY, [Res, ReduceExploit, Exploit - ReduceExploit]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResData),	
	{update, NewPlayerStatus};
%%神木蚕丝兑换道具
handle(?PP_ITEM_EXCHANG_BUY,PlayerStatus, [ShopItemID, Count]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {item_exchang_buy,ShopItemID, Count}),
	ok;
%%物品购买
handle(?PP_ITEM_BUY, PlayerStatus, [ShopItemID, Count,BuyAndUse]) ->
	YuanBao = PlayerStatus#ets_users.yuan_bao,
	BindYuanBao = PlayerStatus#ets_users.bind_yuan_bao,
	Copper = PlayerStatus#ets_users.copper,
	BindCopper = PlayerStatus#ets_users.bind_copper,
	[Res,ItemList, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, TemplateID] = 
		gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, 
						{'buy',
						 YuanBao,
						 BindYuanBao,
						 Copper,
						 BindCopper,
						 ShopItemID,
						 Count,
						 PlayerStatus#ets_users.club_id,
						 PlayerStatus#ets_users.id,
						 PlayerStatus#ets_users.current_map_id,
						 PlayerStatus#ets_users.pos_x,
						 PlayerStatus#ets_users.pos_y,
						 lib_vip:change_dbvip_to_vipid(PlayerStatus#ets_users.vip_id)
						}),
	
	if
		ShopItemID =:= 1002 orelse ShopItemID =:= 4002 ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task, {'buy_item',TemplateID,Count});
		true ->
			ok
	end,

	%%todo 先扣绑定，再扣非绑定
	NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYunBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper,
														{?CONSUME_MONEY_ITEM_BUY,TemplateID,Count}),
	%%添加消费记录
%% 	lib_statistics:add_consume_yuanbao_log(NewPlayerStatus#ets_users.id, ReduceYunBao, ReduceBindYuanBao, 
%% 										   1, ?CONSUME_YUANBAO_ITEM_BUY, misc_timer:now_seconds(), TemplateID, Count,
%% 										   NewPlayerStatus#ets_users.level),
	
	%%返回是否成功
	{ok, ResData} = pt_14:write(?PP_ITEM_BUY, Res),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, ResData),
	if
		ItemList =/= [] ->
			[H|_] = ItemList,
			if
				BuyAndUse =:= 1 ->
					case pp_player:handle(?PP_PLAYER_VIP_USE, NewPlayerStatus, [H#ets_users_items.place]) of
						{update,NewPlayerStatus1} ->
							{update, NewPlayerStatus1};
						_ ->
							{update, NewPlayerStatus}
					end;
				true ->
					{update, NewPlayerStatus}
			end;
		true ->
			{update, NewPlayerStatus}
	end;				
	
	

%%背包整理
handle(?PP_ITEM_ARRANGE, PlayerStatus, BagType) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			if
				BagType =:= ?BAG_TYPE_STORE ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{'array_item',
																						   PlayerStatus#ets_users.depot_max_number,
																				           BagType});
				true ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{'array_item',
																						   PlayerStatus#ets_users.bag_max_count,
																				           BagType})
			end,
			ok;
		_ ->
			ok
	end;

handle(?PP_BAG_EXTEND, PlayerStatus, BagType) ->
	if  
		PlayerStatus#ets_users.yuan_bao < 48 ->
			ok;
		BagType =:= ?BAG_TYPE_STORE orelse BagType =:=  ?BAG_TYPE_COMMON ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'add_cells', BagType})of
				{add_expansion, AddComExpan, AddDepotExpan} ->
					%%更新格子数量
					%%扣除费用
					NewPlayerStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,48, 0, 0, 0,{?CONSUME_YUANBAO_BAG_EXTEND,BagType,1}),
					NewPlayerStatus = lib_player:add_expansion(NewPlayerStatus1, AddComExpan, AddDepotExpan,1),
			        {ok, Data} = pt_14:write(?PP_BAG_EXTEND, [NewPlayerStatus#ets_users.bag_max_count,
													  NewPlayerStatus#ets_users.depot_max_number]),
			        lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Data),		
			        {update, NewPlayerStatus};
				_ ->
					?ERROR_MSG("add_cells error:~p",[BagType]),
					{error, PlayerStatus}
			end;
		true ->
			?DEBUG("BAG_EXTEND error bagType:~p",[BagType]),
			ok
%% 			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{'array_item',
%% 																						   PlayerStatus#ets_users.bag_max_count,
%% 																				           BagType})
	end;
%%道具拆解
handle(?PP_ITEM_SPLIT, PlayerStatus, [Place, Count]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{'spilt_item', Place, Count}),
			ok;
		_ ->
			ok
	end;

%%道具出售
handle(?PP_ITEM_SELL, PlayerStatus, [Place, Count]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			[ok, Res, AddCopper, AddBindCopper] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{
																  'item_sell',
																   Place,
																   Count}),
			NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, 0, 0, AddCopper, AddBindCopper,{?GAIN_MONEY_ITEM_SELL,Place, Count}),
	        {ok, ResData} = pt_14:write(?PP_ITEM_SELL, Res),
	        lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, ResData),
	        {update, NewPlayerStatus};
		_ ->
			ok
	end;

%%装备开孔
handle(?PP_ITEM_TAP, PlayerStatus, [ItemPlace, TapPlace]) ->
	Copper = PlayerStatus#ets_users.copper,
	BindCopper = PlayerStatus#ets_users.bind_copper,
    [Res, ReduceCopper, ItemId, HoleNum] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'hole',	
																												   ItemPlace, 
																												   TapPlace,
																												   Copper,
																												   BindCopper,
																												   PlayerStatus#ets_users.other_data#user_other.vip_hole_rate}),
	%%添加打孔日志数据
	lib_statistics:add_hole_log(PlayerStatus#ets_users.id, PlayerStatus#ets_users.level, HoleNum + 1, Res),
	 %%更新货币
	 NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, ReduceCopper),
		
	%%返回成功与否
	{ok, BinData} = pt_14:write(?PP_ITEM_TAP, [Res, ItemId]),
    lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	{update, NewPlayerStatus};



%% 批量使用物品
handle(?PP_ITEM_BATCH_USE,PlayerStatus,[Place, Count]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'item_batch_use', Place, Count}) of
				[add_copper, AddCopper,AddBindCopper] ->
					%%更新货币
			        NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, 0, 0, AddCopper, AddBindCopper,{?GAIN_MONEY_ITEM_USE,Place, Count}),	
				
			        {update, NewPlayerStatus};

				[add_curexp_lifexp_phy, CurrExp, LiftExp, PhyExp] ->
					NewPlayerState = lib_player:add_currexp_and_liftexp(CurrExp, LiftExp, PhyExp, PlayerStatus),
					%%更新玩家信息公开信息
			        {ok, Bin} = pt_20:write(?PP_UPDATE_USER_INFO,  NewPlayerState),
			        lib_send:send_to_sid(NewPlayerState#ets_users.other_data#user_other.pid_send, Bin),
			        {update, NewPlayerState};
				
				[open_box, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, MailItemList] ->
					%%更新货币
					NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper,{?GAIN_MONEY_OPEN_BOX,Place, Count}),	
					%%元宝操作日志
%% 					lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, AddYuanBao, AddBindYuanBao, 
%% 												   0, ?CONSUME_YUANBAO_OPENBOX, misc_timer:now_seconds(), 0, 0,
%% 												   PlayerStatus#ets_users.level),
			        %%发邮件附件
			        if
						erlang:length(MailItemList) < 1 ->
							{update, NewPlayerStatus};
						true ->
							lib_mail:send_box_items_to_mail([NewPlayerStatus#ets_users.nick_name, NewPlayerStatus#ets_users.id, MailItemList,
															  NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.nick_name]),
							{update, NewPlayerStatus}
					end;
				
				_ ->
					{error, PlayerStatus}
			end;
		
		_ ->
			ok
	end;



%%道具使用
handle(?PP_ITEM_USE, PlayerStatus, Place) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} when (PlayerStatus#ets_users.current_hp > 1) ->
			Location = {PlayerStatus#ets_users.current_map_id, PlayerStatus#ets_users.pos_x, PlayerStatus#ets_users.pos_y},
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'item_use', PlayerStatus#ets_users.career,Place, PlayerStatus#ets_users.level,
						PlayerStatus#ets_users.other_data#user_other.mount_skill_yaoxiao, Location}) of
				[open_box, AddCopper, AddBindCopper, AddYuanBao, AddBindYuanBao, MailItemList] ->
					%%更新货币
					NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper,{?GAIN_MONEY_OPEN_BOX,Place,1}),	
					%%元宝操作日志
%% 					lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, AddYuanBao, AddBindYuanBao, 
%% 												   0, ?CONSUME_YUANBAO_OPENBOX, misc_timer:now_seconds(), 0, 0,
%% 												   PlayerStatus#ets_users.level),
			        %%发邮件附件
			        if
						erlang:length(MailItemList) < 1 ->
							{update, NewPlayerStatus};
						true ->
							lib_mail:send_box_items_to_mail([NewPlayerStatus#ets_users.nick_name, NewPlayerStatus#ets_users.id, MailItemList,
															  NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.nick_name]),
					    {update, NewPlayerStatus}
					end;
				
				[add_hp_mp, Hp, Mp] ->
					NewPlayerState = lib_player:add_hp_and_mp(Hp, Mp, PlayerStatus),
					%%消息广播
					{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[PlayerStatus#ets_users.id, 1, ?ELEMENT_PLAYER,Hp,Mp,
																			NewPlayerState#ets_users.current_hp, 
																			NewPlayerState#ets_users.current_mp]),
			        mod_map_agent:send_to_area_scene(
							NewPlayerState#ets_users.current_map_id,
							NewPlayerState#ets_users.pos_x,
							NewPlayerState#ets_users.pos_y,
							HPMPBin,
							undefined),
			        {update_map, NewPlayerState};
				
				[add_curexp_lifexp_phy, CurrExp, LiftExp, PhyExp] ->
					NewPlayerState = lib_player:add_currexp_and_liftexp(CurrExp, LiftExp, PhyExp, PlayerStatus),
					%%更新玩家信息公开信息
			        {ok, Bin} = pt_20:write(?PP_UPDATE_USER_INFO,  NewPlayerState),
			        lib_send:send_to_sid(NewPlayerState#ets_users.other_data#user_other.pid_send, Bin),
			        {update, NewPlayerState};
				[add_curexp_exploit, AddExploit] ->
					NewExploitInfo = lib_exploit:add_exploit(PlayerStatus#ets_users.other_data#user_other.exploit_info, AddExploit),
					{ok,Bin} = pt_14:write(?PP_ITEM_EXPLOIT_BUY, [-1, AddExploit, NewExploitInfo#user_exploit_info.exploit]),
					%{ok,Bin} = pt_23:write(?PP_PVP_EXPLOIT_INFO, [NewExploitInfo]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
					NewOther = PlayerStatus#ets_users.other_data#user_other{exploit_info = NewExploitInfo},
					NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther},
					{update, NewPlayerStatus};
				[add_curexp_pet_exp, AddExp] ->
					{_,NewPlayerStatus,_} = lib_pet:add_battle_pet_exp(PlayerStatus,AddExp),
					{update, NewPlayerStatus};
				[add_copper, AddCopper,AddBindCopper] ->
					%%更新货币
			        NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, 0, 0, AddCopper, AddBindCopper,{?GAIN_MONEY_ITEM_USE,Place, 1}),		
			        {update, NewPlayerStatus};
				
				[add_buff, BuffId] ->	
					NewPlayerStatus = lib_buff:add_buff(BuffId, PlayerStatus),							
			        {update_map, NewPlayerStatus};
				
				[add_expansion, AddComExpan, AddDepotExpan] ->
					%%更新格子数量
					NewPlayerStatus = lib_player:add_expansion(PlayerStatus, AddComExpan, AddDepotExpan,2),
			        {ok, Data} = pt_14:write(?PP_BAG_EXTEND, [NewPlayerStatus#ets_users.bag_max_count,
													  NewPlayerStatus#ets_users.depot_max_number]),
			        lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Data),		
			        {update, NewPlayerStatus};
				
				[return_to_city] ->
					%%使用回城符
					{ok, NewPlayerStatus} = lib_player:return_to_city(PlayerStatus),
			        {update_map, NewPlayerStatus};
				
				[enter_treasure_map, DuplicateId] ->
					lib_duplicate:enter_duplicate_by_fly(PlayerStatus, DuplicateId, 1);

				[random_to_transfer] ->
					%%使用随机传送鞋
					{ok, NewPlayerStatus} = lib_player:random_to_transfer(PlayerStatus),
					{update_map, NewPlayerStatus};
				
				[reduce_pk_value, ReducePkValue] ->
					NewPlayerStatus = lib_player:reduce_pk_value(PlayerStatus, ReducePkValue),
					{ok, Data} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Data),
					{update, NewPlayerStatus};
				
				[shenmo_accept_task, TaskId, TaskState] ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task, 
							{'accept_shenmo', TaskId, TaskState, 
							 PlayerStatus#ets_users.level,
							 PlayerStatus#ets_users.sex, 
							 PlayerStatus#ets_users.camp, 
							 PlayerStatus#ets_users.career,
							 PlayerStatus#ets_users.shenmo_times}),
			       {update, PlayerStatus};
				
				%% vip
%% 				[vip_card, VipClass] ->
%% 					NewPlayerStatus = lib_player:update_vip(PlayerStatus,VipClass),
%% 					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD, [NewPlayerStatus]),
%% 					mod_map_agent: send_to_area_scene(
%% 									NewPlayerStatus#ets_users.current_map_id,
%% 									NewPlayerStatus#ets_users.pos_x,
%% 									NewPlayerStatus#ets_users.pos_y,
%% 									PlayerData,
%% 									undefined),
%% 					Now = misc_timer:now_seconds(),
%% 					IsGetAward1 = 
%% 						case util:is_same_date(Now,NewPlayerStatus#ets_users.vip_yuanbao_date) of
%% 							true ->
%% 								1;
%% 							_ ->
%% 								0
%% 						end,
%% 					IsGetAward2 = 
%% 						case util:is_same_date(Now,NewPlayerStatus#ets_users.vip_money_date) of
%% 							true ->
%% 								1;
%% 							_ ->
%% 								0
%% 						end,
%% 					IsGetAward3 = 
%% 						case util:is_same_date(Now,NewPlayerStatus#ets_users.vip_buff_date) of
%% 							true ->
%% 								1;
%% 							_ ->
%% 								0
%% 						end,
%% 					{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [NewPlayerStatus#ets_users.vip_id,
%% 															  NewPlayerStatus#ets_users.vip_date,
%% 															  NewPlayerStatus#ets_users.vip_tranfer_shoes,
%% 															  NewPlayerStatus#ets_users.vip_bugle,
%% 															  IsGetAward1,IsGetAward2,IsGetAward3]),
%% 					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, VipBin),
%% 					{update, NewPlayerStatus};
				%% 宠物
				[pet_card] ->
					ok;
				[pet_skill] ->
					ok;
				%% 坐骑
				[mounts_card] ->
					ok;
				[mounts_skill] ->
					NewPlayerStatus = lib_player:calc_properties_send_self(PlayerStatus),
					{update, NewPlayerStatus};
				[skill,Type,SkillId] ->
					
					ok;
				[add_user_title, TitleId] ->
					{ok, NewPlayerStatus} = lib_player:check_add_title(TitleId, PlayerStatus),
					{update, NewPlayerStatus};					
				_ ->
					{error, PlayerStatus}
			end;
		
		_ ->
			ok
	end;


%%使用快捷栏物品
handle(?PP_SKILLBAR_ITEM_USE, PlayerStatus, [ItemTemplateID]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'use_item_by_templateid', ItemTemplateID}) of
				[open_box, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper] ->
					%%更新货币
					NewPlayerStatus = lib_player:add_cash_and_send(PlayerStatus, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper,{?GAIN_MONEY_OPEN_BOX,ItemTemplateID, 1}),
					{update, NewPlayerStatus};
				
				[add_hp_mp, Hp, Mp] ->
					NewPlayerState = lib_player:add_hp_and_mp(Hp, Mp, PlayerStatus),
					%%消息广播
					{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[PlayerStatus#ets_users.id, 1, ?ELEMENT_PLAYER, Hp, Mp,
																			NewPlayerState#ets_users.current_hp, 
																			NewPlayerState#ets_users.current_mp]),
			        mod_map_agent:send_to_area_scene(
							NewPlayerState#ets_users.current_map_id,
							NewPlayerState#ets_users.pos_x,
							NewPlayerState#ets_users.pos_y,
							HPMPBin,
							undefined),
					{update_map, NewPlayerState};
				_ ->
					error
			end;
		_ ->
			ok
	end;

%%道具强化
handle(?PP_ITEM_STRENG, PlayerStatus, [ItemPlace, StonePlace, GuardPlace, AKey, PetId]) ->
	Copper = PlayerStatus#ets_users.copper,
	BindCopper = PlayerStatus#ets_users.bind_copper,
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,{'item_streng', 
																			    ItemPlace, StonePlace, GuardPlace, AKey, PetId, Copper, BindCopper,
																			   PlayerStatus#ets_users.other_data#user_other.vip_strength_rate}) of
		{ok,  NeedCopper, Res, IsProtect, Level, ItemId,BagType,Place} ->	
			if
				BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
					NewPlayerStatus = lib_player:calc_properties_send_self_area(PlayerStatus);
				BagType =:= ?BAG_TYPE_PET ->
					case lib_pet:get_pet_by_id(PetId) of
							[] ->
								NewPlayerStatus = PlayerStatus;
							Info ->
								PetInfo = lib_pet:calc_properties(Info),
								{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo]),
								lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
								NewPlayerStatus = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo)
					end;
				true ->
					NewPlayerStatus = PlayerStatus
			end,
			
			%%添加强化日志
			lib_statistics:add_strengthen_log(NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.level, 0, IsProtect, Level, Res),
			%%更新金钱
			NewPlayerStatus1 = lib_player:reduce_cash_and_send(NewPlayerStatus, 0, 0, 0, NeedCopper),	
			%%返回成功与否
			{ok, BinData} = pt_14:write(?PP_ITEM_STRENG, [Res, ItemId]),
			lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send, BinData),
			
			if	Res =:= 1 ->
					lib_active:finish_active(NewPlayerStatus1,?STRENG_EQUIP,0);
				true ->
					skip
			end,			
			{update, NewPlayerStatus1};
			
		_er ->
%% 			{error, PlayerStatus}
			?DEBUG("item streng error:~p",[_er]),
			error
	end;


%%装备修理
handle(?PP_ITEM_REPAIR, PlayerStatus, ItemPlace) ->
    [NewPlayerStatus, RepairCost] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'mend', 
																							 PlayerStatus, 
																							 ItemPlace}),
	%%更新货币
	NewPlayerStatus1 = lib_player:reduce_cash_and_send(NewPlayerStatus, 0, 0, 0, RepairCost),	
	{update_map, NewPlayerStatus1};


%%道具镶嵌
handle(?PP_ITEM_ENCHASE, PlayerStatus, [ItemPlace, StonePlace, HolePlace]) ->
	Copper = PlayerStatus#ets_users.copper,
	BindCopper = PlayerStatus#ets_users.bind_copper,
	[Res, ReduceCopper, ItemId, BagType,Place] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												{'enchase', [ ItemPlace, StonePlace, HolePlace,Copper,BindCopper, PlayerStatus#ets_users.id, PlayerStatus#ets_users.level]}),			
	
	if
		BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
			NewPlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus);
		true ->
			NewPlayerStatus1 = PlayerStatus
	end,
	
	%%更新货币
	NewPlayerStatus = lib_player:reduce_cash_and_send(NewPlayerStatus1, 0, 0, 0, ReduceCopper),
	%%返回成功与否
	{ok, BinData} = pt_14:write(?PP_ITEM_ENCHASE, [Res, ItemId]),
    lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	{update, NewPlayerStatus};

	
%%宝石摘取
handle(?PP_ITEM_STONE_PICK, PlayerStatus, [ItemPlace, PickPlace, HolePlace]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper,
			BindCopper = PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper, ItemId, BagType,Place] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
														  {'pick_stone', [ItemPlace, PickPlace, HolePlace, Copper, BindCopper,
																		   PlayerStatus#ets_users.id, PlayerStatus#ets_users.level]}),
			if
				BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
					NewPlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus);
				true ->
					NewPlayerStatus1 = PlayerStatus
			end,
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(NewPlayerStatus1, 0, 0, 0, ReduceCopper),	
	        %%返回成功与否
	        {ok, BinData} = pt_14:write(?PP_ITEM_STONE_PICK, [Res, ItemId]),
            lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	        {update, NewPlayerStatus};
		_ ->
			ok
	end;

	
%%道具合成
handle(?PP_ITEM_COMPOSE, PlayerStatus, [FormuleId,ComposeNum]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												  {'item_compose', [FormuleId, Copper, ComposeNum]}),
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, ReduceCopper),
			%%返回成功与否
	        {ok, BinData} = pt_14:write(?PP_ITEM_COMPOSE, Res),
            lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	        {update, NewPlayerStatus};
		_ ->
			ok
	end;

%%装备品质提升
handle(?PP_ITME_UPGRADE, PlayerStatus, [PetId,ItemPlace,Material1,Material2,Material3]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper, NewPlayerStatus1] = 
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												  {'item_upgrade', [PlayerStatus,PetId, ItemPlace,Material1,Material2,Material3,Copper]}) of
				[Res1, ReduceCopper1, BagType,Place] ->
					if
						BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
							NewPlayerStatus2 = lib_player:calc_properties_send_self(PlayerStatus);
						BagType =:= ?BAG_TYPE_PET ->
							case lib_pet:get_pet_by_id(PetId) of
								[] ->
									NewPlayerStatus2 = PlayerStatus;
								Info ->
									PetInfo = lib_pet:calc_properties(Info),
									{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo]),
									lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
									NewPlayerStatus2 = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo)
							end;
						true ->
							NewPlayerStatus2 = PlayerStatus
					end,
					[Res1, ReduceCopper1, NewPlayerStatus2];
				_er ->
					?WARNING_MSG("PP_ITEM_UPGRADE error:~p",[{_er,PlayerStatus#ets_users.id,ItemPlace,Material1,Material2,Material3}])
			end,
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(NewPlayerStatus1, 0, 0, 0, ReduceCopper),
			%%返回成功与否
	        {ok, BinData} = pt_14:write(?PP_ITME_UPGRADE, Res),
            lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	        {update, NewPlayerStatus};
		_ ->
			ok
	end;	
handle(?PP_ITEM_UPLEVEL, PlayerStatus, [PetId,ItemPlace,Material1,Material2,Material3]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper, NewPlayerStatus1] = 
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												  {'item_uplevel', [PlayerStatus, PetId,ItemPlace,Material1,Material2,Material3,Copper]}) of
				[Res1, ReduceCopper1, BagType,Place] ->
					if
						BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
							NewPlayerStatus2 = lib_player:calc_properties_send_self(PlayerStatus);
						BagType =:= ?BAG_TYPE_PET ->
							case lib_pet:get_pet_by_id(PetId) of
								[] ->
									NewPlayerStatus2 = PlayerStatus;
								Info ->
									PetInfo = lib_pet:calc_properties(Info),
									{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo]),
									lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
									NewPlayerStatus2 = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo)
							end;
						true ->
							NewPlayerStatus2 = PlayerStatus
					end,
					[Res1, ReduceCopper1, NewPlayerStatus2];
				_er ->
					?WARNING_MSG("PP_ITEM_UPLEVEL error:~p",[{_er,PlayerStatus#ets_users.id,ItemPlace,Material1,Material2,Material3}])
			end,
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(NewPlayerStatus1, 0, 0, 0, ReduceCopper),
			%%返回成功与否
	        {ok, BinData} = pt_14:write(?PP_ITEM_UPLEVEL, Res),
            lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	        {update, NewPlayerStatus};
	_ ->
			ok
	end;	
%%宝石合成
handle(?PP_STONE_COMPOSE, PlayerStatus, [StoneId,ComposeNum,UseBind]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper,
			BindCopper = PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												  {'stone_compose', [StoneId,ComposeNum,UseBind,Copper + BindCopper]}),
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, ReduceCopper),
			%%返回成功与否
			{ok, BinData} = pt_14:write(?PP_STONE_COMPOSE, Res),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{update, NewPlayerStatus};
		_ ->
			ok
	end;

%%宝石淬炼
handle(?PP_STONE_QUENCH, PlayerStatus, [StonePlace, QuenchPlace, IsYuanBao, IsBag, ItemPlace, HolePlace]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper,
			BindCopper = PlayerStatus#ets_users.bind_copper,
			YuanBao = PlayerStatus#ets_users.yuan_bao,
			[Res, ReduceCopper, NeedYuanBao] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												  {'stone_quench', [StonePlace,QuenchPlace,Copper + BindCopper,
											 YuanBao, IsYuanBao, IsBag, ItemPlace, HolePlace, PlayerStatus#ets_users.id, PlayerStatus#ets_users.level]}),
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, NeedYuanBao, 0, 0, ReduceCopper),
			%%返回成功与否
			{ok, BinData} = pt_14:write(?PP_STONE_QUENCH, Res),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{update, NewPlayerStatus};
		_ ->
			ok
	end;

%%精致宝石分解
handle(?PP_STONE_DECOMPOSE, PlayerStatus, StonePlace) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper,
			BindCopper = PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
												  {'stone_decompose', [StonePlace, Copper + BindCopper]}),
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, ReduceCopper),
			%%返回成功与否
			{ok, BinData} = pt_14:write(?PP_STONE_DECOMPOSE, Res),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{update, NewPlayerStatus};
		_ ->
			ok
	end;

%%道具分解
handle(?PP_ITEM_DECOMPOSE, PlayerStatus, ItemPlace) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper,
			BindCopper = PlayerStatus#ets_users.bind_copper,
			[Res, ReduceCopper] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
										  {'item_decompose', ItemPlace, Copper, BindCopper}),
			%%扣取金钱
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, ReduceCopper),	
			%%返回成功与否
			{ok, BinData} = pt_14:write(?PP_ITEM_DECOMPOSE, Res),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
			{update, NewPlayerStatus};
		_ ->
			ok
	end;

	
%%装备融合
handle(?PP_ITEM_FUSION, PlayerStatus, [BulePlace, PurplePlace1, PurplePlace2]) ->
	case PlayerStatus#ets_users.other_data#user_other.trade_status of
		{0, 0} ->
			Copper = PlayerStatus#ets_users.copper,
			BindCopper = PlayerStatus#ets_users.bind_copper,
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
								 {'item_fusion', BulePlace, PurplePlace1, PurplePlace2, Copper, BindCopper}) of
				[1] ->
					%%扣取金钱
					NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, 0, 0, 0, ?FISIONNEEDCOPPER),
					%%返回成功与否
					{ok, BinData} = pt_14:write(?PP_ITEM_FUSION, 1),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					{update, NewPlayerStatus};
				_ ->
					{ok, BinData} = pt_14:write(?PP_ITEM_FUSION, 0),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					ok
			end;
		_ ->
			ok
	end;


%%装备洗练
handle(?PP_ITEM_REBUILD, PlayerStatus, [PetId, ItemPlace, StonePlace, Locks, LockList]) ->
	Copper = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
	[Res, ReduceCopper, ItemId, BagType,Place,Len] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
										  {'item_rebuild', PlayerStatus, PetId, ItemPlace, StonePlace, Locks, Copper, LockList}),
	
	if
		Len =:=0 andalso BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
			NewPlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus);
		Len =:=0 andalso BagType =:= ?BAG_TYPE_PET ->
					case lib_pet:get_pet_by_id(PetId) of
							[] ->
								NewPlayerStatus1 = PlayerStatus;
							Info ->
								PetInfo = lib_pet:calc_properties(Info),
								{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo]),
								lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
								NewPlayerStatus1 = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo)
					end;
		true ->
			NewPlayerStatus1 = PlayerStatus
	end,
	if	Res =:= 1 ->
			lib_active:finish_active(NewPlayerStatus1,?REBUILD_EQUIP,0);
		true ->
			skip
	end,
	
	%%扣取金钱
	NewPlayerStatus = lib_player:reduce_cash_and_send(NewPlayerStatus1, 0, 0, 0, ReduceCopper),	
	%%返回成功与否
	{ok, BinData} = pt_14:write(?PP_ITEM_REBUILD, [Res, ItemId]),
    lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	{update, NewPlayerStatus};

%%装备洗练属性替换
handle(?PP_ITEM_REPLACE_REBUILD, PlayerStatus, [PetId, ItemPlace]) ->
	Pet = lib_pet:get_fight_pet(),
	[Res, ItemId, BagType,Place] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
										  {'item_replace_rebuild', PlayerStatus, PetId, ItemPlace}),
	if
		BagType =:= ?BAG_TYPE_COMMON andalso Place < ?BAG_BEGIN_CELL ->
			NewPlayerStatus = lib_player:calc_properties_send_self(PlayerStatus);
		BagType =:= ?BAG_TYPE_PET ->
					case lib_pet:get_pet_by_id(PetId) of
							[] ->
								NewPlayerStatus = PlayerStatus;
							Info ->
								PetInfo = lib_pet:calc_properties(Info),
								{ok,Bin} = pt_25:write(?PP_PET_ATT_UPDATE,[PetInfo]),
								lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,Bin),
								NewPlayerStatus = lib_player:calc_pet_BattleInfo(PlayerStatus,PetInfo)
					end;
		true ->
			NewPlayerStatus = PlayerStatus
	end,
	
	%%返回成功与否
	{ok, BinData} = pt_14:write(?PP_ITEM_REPLACE_REBUILD, [Res, ItemId]),
    lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
	{update, NewPlayerStatus};

handle(?PP_ITEM_TRANSFORM, PlayerStatus, [OpType,ItemPlace1,ItemPlace2]) ->
	Copper = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
	[Res, ReduceCopper,IsUpdate] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
										  {'item_transform', OpType,ItemPlace1,ItemPlace2,Copper}),
	if
		IsUpdate =:= 1 ->
			NewPlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus);
		true ->
			NewPlayerStatus1 = PlayerStatus
	end,
	
	%%扣取金钱
	NewPlayerStatus = lib_player:reduce_cash_and_send(NewPlayerStatus1, 0, 0, 0, ReduceCopper),
	{ok, Bin} = pt_14:write(?PP_ITEM_TRANSFORM, Res),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
	
	{update, NewPlayerStatus};	

%% 装备熔炼
handle(?PP_EQUIP_FUSION, PlayerStatus, [ItemPlace1, ItemPlace2, ItemID3]) ->
	Copper = PlayerStatus#ets_users.copper + PlayerStatus#ets_users.bind_copper,
	[Res, ReduceCopper, IsUpdate] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item,
										  {'equip_fusion', ItemPlace1, ItemPlace2, ItemID3, Copper}),
	%% 装备是否在身上
	if IsUpdate =:= 1 ->
			NewPlayerStatus = lib_player:calc_properties_send_self(PlayerStatus);
		true ->
			NewPlayerStatus = PlayerStatus
	end,
	NewPlayerStatus1 = lib_player:reduce_cash_and_send(NewPlayerStatus, 0, 0, 0, ReduceCopper),

	{ok, Bin} = pt_14:write(?PP_EQUIP_FUSION, Res),
	lib_send:send_to_sid(NewPlayerStatus1#ets_users.other_data#user_other.pid_send, Bin),
	
	{update, NewPlayerStatus1};

%% 查询物品
handle(?PP_ITEM_REFER, PlayerStatus, [UserId, ItemId]) ->
	case lib_player:get_player_pid(UserId) of
		[] ->
			case db_agent_item:get_item_by_itemid(ItemId) of
				[] ->
					[];
				I -> 
					Info = list_to_tuple([ets_users_items | I]),
					Iitem = Info#ets_users_items{other_data=#item_other{}},
					{ok, BinData} = pt_14:write(?PP_ITEM_REFER, Iitem),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData)
			end;
		Pid ->
			gen_server:cast(Pid, {'item_refer', PlayerStatus#ets_users.other_data#user_other.pid_send, ItemId})
	end,
	ok;

%% 使用飞天鞋
handle(?PP_USE_TRANSFER_SHOE, PlayerStatus, [MapId, Pos_X, Pos_Y]) ->
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
		true ->
			ok;
		_ ->
			{PlayerStatus1,IsGetAward1,IsGetAward2,IsGetAward3} = lib_vip:check_vip_refresh(PlayerStatus),
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'transfer_shoe_use', [MapId, 
																											   Pos_X, 
																											   Pos_Y, 
																											   PlayerStatus1#ets_users.vip_tranfer_shoes,
																											   lib_vip:change_dbvip_to_vipid(PlayerStatus1#ets_users.vip_id)]}) of
				[0] ->
					%%返回成功与否
					{ok, BinData} = pt_14:write(?PP_USE_TRANSFER_SHOE, 0),
					lib_send:send_to_sid(PlayerStatus1#ets_users.other_data#user_other.pid_send, BinData),
					{update, PlayerStatus1};
				[_, LeftTranferShoes] ->	%%使用vip飞鞋飞
					NewPlayerStatus0 = PlayerStatus1#ets_users{vip_tranfer_shoes = LeftTranferShoes},
					Now = misc_timer:now_seconds(),
					
					{ok,VipBin} = pt_20:write(?PP_PLAYER_VIP_DETAIL, [NewPlayerStatus0#ets_users.vip_id,
																	  NewPlayerStatus0#ets_users.vip_date,
																	  NewPlayerStatus0#ets_users.vip_tranfer_shoes,
																	  NewPlayerStatus0#ets_users.vip_bugle,
																	  IsGetAward1,IsGetAward2,IsGetAward3]),
					lib_send:send_to_sid(NewPlayerStatus0#ets_users.other_data#user_other.pid_send, VipBin),
					
					%%更新玩家位置
					{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(NewPlayerStatus0, MapId, Pos_X, Pos_Y),
					%%返回成功与否
					{ok, BinData} = pt_14:write(?PP_USE_TRANSFER_SHOE, 1),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					{update_map, NewPlayerStatus};
				_ ->
					%%更新玩家位置
					{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(PlayerStatus, MapId, Pos_X, Pos_Y),
					%%返回成功与否
					{ok, BinData} = pt_14:write(?PP_USE_TRANSFER_SHOE, 1),
					lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinData),
					{update_map, NewPlayerStatus}
			end
	end;

%% 神魔令保存任务
handle(?PP_SHENMO_SAVE_TASK, PlayerStatus, [ItemId, TaskId]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'shenmo_save_task', ItemId, TaskId}),
	ok;

%% 保存神魔令任务品质
handle(?PP_SHENMO_REFRESH_STATE, PlayerStatus, [ShenmoItemId, LingLongItemId]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
					{'shenmo_refresh_state', ShenmoItemId, LingLongItemId}),
	ok;

%% %% 测试用自动购买
%% handle(?PP_ITEM_BUY_AUTO, PlayerStatus, [TemplateId, Amount]) ->
%% 	Id = item_util:auto_buy_need(TemplateId),
%% 	case Id of
%% 		0 ->
%% 			ingore;
%% 		_ ->
%% 			handle(?PP_ITEM_BUY, PlayerStatus, [Id, Amount])
%% 	end;

%% handle(?PP_ITEM_DISCOUNT, _, _) ->
%% 	skip;

%% 获取每天优惠抢购物品信息
handle(?PP_ITEM_DISCOUNT, PlayerStatus, []) ->
	mod_shop:get_discount_goods(PlayerStatus#ets_users.other_data#user_other.pid_send),
	skip;


%%淘宝
handle(?PP_OPEN_BOX, PlayerStatus, [Box_Type]) ->
		case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, 
						 {'open_box_in_yuanbao', 
						  PlayerStatus#ets_users.yuan_bao, 
						  PlayerStatus#ets_users.career, 
						  Box_Type, 
						  PlayerStatus#ets_users.nick_name}) of
		{ok, ReduceYuanbao, ItemList_String} ->
 			%%元宝消费统计
%% 			lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, ReduceYuanbao, 0,
%% 												   1, ?CONSUME_MAGIC_BOX, misc_timer:now_seconds(), ItemList_String, Box_Type,
%% 												   PlayerStatus#ets_users.level),
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYuanbao, 0, 0, 0,{?CONSUME_YUANBAO_OPEN_BOX,ItemList_String, Box_Type}),
			lib_active:finish_active(NewPlayerStatus,?TAO_BAO,0),
			{update_db, NewPlayerStatus};
		_ ->
			ok
	end;

%%获取箱子所有数据
handle(?PP_BOX_ALL_DATA, PlayerStatus, _) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_box_all_data'}),
	ok;

%%移动箱子物品
handle(?PP_MOVE_BOX_DATA, PlayerStatus, [Type, ItemId]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'move_box_data', Type, ItemId}),
	ok;


%%获取开箱记录
handle(?PP_ALL_WORLD_BOXDATA, PlayerStatus, _) ->
	 List = gen_server:call(mod_box_agent:get_open_box_pid(), {'get_box_data'}),
	 {ok, BinData} = pt_14:write(?PP_ALL_WORLD_BOXDATA, List),
	 lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData);
	


%% 定时获取商品剩余数量
handle(?PP_ITEM_REAL_TIME, PlayerStatus, [GoodsId]) ->
	mod_shop:update_goods_real_time(GoodsId,PlayerStatus#ets_users.id, PlayerStatus#ets_users.other_data#user_other.pid_send),
	skip;

%%优惠商品
handle(?PP_ITEM_DISCOUNT_BUY, PlayerStatus, [ShopItemID, Count]) ->
	YuanBao = PlayerStatus#ets_users.yuan_bao,
	BindYuanBao = PlayerStatus#ets_users.bind_yuan_bao,
	Copper = PlayerStatus#ets_users.copper,
	BindCopper = PlayerStatus#ets_users.bind_copper,
	[Res, ReduceBindCopper, ReduceCopper, ReduceBindYuanBao, ReduceYunBao, TemplateID, SurplusCount,LimitCount] = 
		gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, 
						{'buy_discount',
							YuanBao,
							BindYuanBao,																			 																									 
							Copper,
							BindCopper,
							ShopItemID,																																			 
							Count,
						 	PlayerStatus#ets_users.other_data#user_other.pid_send}),
	
	%%todo 先扣绑定，再扣非绑定
	NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYunBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper,
														{?CONSUME_MONEY_ITEM_DISCOUNT_BUY, TemplateID, Count}),
	%%添加消费记录
%% 	lib_statistics:add_consume_yuanbao_log(PlayerStatus#ets_users.id, ReduceYunBao, ReduceBindYuanBao, 
%% 										   1, ?CONSUME_YUANBAO_ITEM_BUY, misc_timer:now_seconds(), TemplateID, Count,
%% 										   PlayerStatus#ets_users.level),
	
	case Res == 1 of
		true ->
			%%返回是否成功
			{ok, ResData} = pt_14:write(?PP_ITEM_DISCOUNT_BUY, [Res, ShopItemID, SurplusCount,LimitCount]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResData);
		_ ->
			skip
	end,
	{update, NewPlayerStatus};


%% 玩家购买帮会商品记录
handle(?PP_ITEM_USER_GUILD_SHOP,PlayerStatus,[]) ->
	List = mod_shop:get_user_guild_shop(PlayerStatus#ets_users.id),
	{ok, ResData} = pt_14:write(?PP_ITEM_USER_GUILD_SHOP, [List]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResData);
		

%% 帮会商品购买
handle(?PP_ITEM_GUILD_SHOP_BUY, PlayerStatus, [ShopItemID, Count]) ->
	GuildId = PlayerStatus#ets_users.club_id,
	[Res, Feats,UpdateDiscountItem] = gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'buy_guild_shop',GuildId,ShopItemID, Count}),
	case Res == 1 of
		true ->
			%%返回是否成功
			case mod_guild:reduce_guild_user_feats(GuildId, PlayerStatus#ets_users.id, 1, Feats,12,0) of
				{true, NewFeats,_Times} ->		
					{ok,FeatsBin} = pt_21:write(?PP_CLUB_SELF_EXPLOIT_UPDATE,[NewFeats]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, FeatsBin);
				_er ->
					?ERROR_MSG("PP_ITEM_GUILD_SHOP_BUY error:~p",[_er])
			end,
			
			{ok, ResData} = pt_14:write(?PP_ITEM_GUILD_SHOP_BUY, [Res, UpdateDiscountItem]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, ResData);
		_ ->
			skip
	end,
	skip;

%% 发送神秘商店更新最后时间
handle(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER,PlayerStatus,[]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'send_last_update'});

%%  神秘商店商品实时信息
handle(?PP_MYSTERY_SHOP_INFO,PlayerStatus,[]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'smshop_info',PlayerStatus});

%% 神秘商店商品主动刷新
handle(?PP_MYSTERY_SHOP_REFRESH,PlayerStatus,[]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'smshop_ref',PlayerStatus}) of
		{ok,NewInfo,ReduceYuanbao} ->
			
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYuanbao, 0, 0, 0,{?CONSUME_SMSHOP_REF,0, 0}),
			{ok, Data} = pt_14:write(?PP_MYSTERY_SHOP_INFO, [NewInfo#ets_users_smshop.items_list]),
			{ok, Data1} = pt_14:write(?PP_MYSTERY_SHOP_LAST_UPDATE_TIMER, [NewInfo#ets_users_smshop.last_ref_date,NewInfo#ets_users_smshop.vip_ref_times]),
			{ok, Data2} = pt_14:write(?PP_MYSTERY_SHOP_REFRESH, [1]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, <<Data/binary,Data1/binary,Data2/binary>>),
			{update, NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 Msg])
	end;


%% 神秘商店商品购买
handle(?PP_MYSTERY_SHOP_BUY,PlayerStatus,[Place]) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'smshop_buy',PlayerStatus,Place}) of
		{ok,[NewInfo, ReduceYunBao,ReduceCopper, TemplateID,Amount]} ->
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus, ReduceYunBao, 0, ReduceCopper, 0,{?CONSUME_SMSHOP_BUY,TemplateID, Amount}),
			{ok, Data} = pt_14:write(?PP_MYSTERY_SHOP_INFO, [NewInfo#ets_users_smshop.items_list]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, <<Data/binary>>),
			lib_active:finish_active(NewPlayerStatus,?BUY_SHOP,0),
			{update, NewPlayerStatus};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 Msg])
	end;

%% 最近神秘商店记录
handle(?PP_MYSTERY_SHOP_ALL_WORLD_DATA,PlayerStatus,[]) ->
	List = mod_smshop_agent:get_smshop_data(),
	{ok, BinData} = pt_14:write(?PP_MYSTERY_SHOP_ALL_WORLD_DATA, List),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData);

%% 请求获取
handle(?PP_ITEM_PET_PLACE_UPDATE,PlayerStatus, [PetId]) ->
	if	PetId > 0 ->
			List = [PetId];
		true ->
			List = lib_pet:get_pet_ids()
	end, 
	F = fun(Id) ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_pet_equip_list', Id}) of
				[] ->
					skip;
				ItemList ->
					{ok, BinData} = pt_14:write(?PP_ITEM_PET_PLACE_UPDATE, [Id,?ITEM_PICK_NONE,ItemList, []]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinData)
			end
		end,
	lists:foreach(F, List);
%% 玫瑰播放
handle(?PP_ROSE_PLAY,PlayerStatus,[UserId,Type,Amount,IsAuto,Nick]) ->
	{Re , Target}= if
		Amount > 0 ->
			case lib_player:get_online_info(UserId) of
				[] ->
					{{false,?_LANG_TEAM_VITITE_OFFLINE}, ""};
				T ->
					FI = case lib_friend:get_relation_info(lib_friend:get_relation_dic(),UserId) of
						[] -> 
							{{false,?_LANG_FRIEND_ERROR_FRIEND_NOT_EXISTS}, T};
						FriendInfo when (FriendInfo#ets_users_friends.state band ?RELATION_FRIEND =/= 0)->
							{{ok},T};
						_ ->
							{{false,?_LANG_FRIEND_ROSE_NOT_EXISTS},T}
					end
			end;
		true ->
			{false,?_LANG_FRIEND_ROSE_NULL}
	end,
	case Re of
		{ok} ->
			case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'rose_play',PlayerStatus,UserId, Type, Amount,IsAuto}) of
				{ok,TotalAmity} ->
					lib_item:send_player_rose(PlayerStatus,Target,UserId,Type,Amount,Nick,TotalAmity);
				{ok,TotalAmity,TmpYuanbao} ->
					lib_item:send_player_rose(PlayerStatus,Target,UserId,Type,Amount,Nick,TotalAmity),
					
					NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus,TmpYuanbao,0,0,0,{?CONSUME_YUANBAO_ROSE,Type,TotalAmity}),			
					{update_db,NewPlayerStatus};
				{false,Msg} ->
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 Msg])
			end;
		{false,Msg1} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 Msg1])
	end;

handle(Cmd, _, _) ->
	?WARNING_MSG("pp_item cmd is not : ~w",[Cmd]),
	ok.

%%
%% Local Functions
%%
