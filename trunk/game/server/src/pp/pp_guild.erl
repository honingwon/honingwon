%%%-------------------------------------------------------------------
%%% Module  : pp_guild
%%% Author  : lxb
%%% Created : 2012-9-25
%%% Description : 帮派模块
%%%-------------------------------------------------------------------
-module(pp_guild).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 handle/3
		 ]).

%%
%% API Functions
%%

	

%帮会列表
handle(?PP_CLUB_QUERYLIST, PlayerStatus,[PageIndex,PageSize,Name]) ->
	mod_guild:get_guild_list(Name,PageIndex,PageSize,PlayerStatus#ets_users.other_data#user_other.pid_send);

%帮会信息
handle(?PP_CLUB_DETAIL, PlayerStatus, [GuildID]) ->
	mod_guild:get_guild_info(GuildID,PlayerStatus#ets_users.other_data#user_other.pid_send);

%帮会信息更新
handle(?PP_CLUB_SET_NOTICE,PlayerStatus,[Declaration]) ->
	 mod_guild:edit_guild_declaretion(PlayerStatus#ets_users.club_id,
											   PlayerStatus#ets_users.id,
											   Declaration,											 
											   PlayerStatus#ets_users.other_data#user_other.pid_send);

%帮会新人加入  
handle(?PP_CLUB_NEW_PLAYER_IN,Player1,[PlayerID,Type]) -> %Player1老成员，Player2新人
	 if PlayerID =:= Player1#ets_users.id ->
			skip;
		true ->
			case lib_player:get_online_player_info_by_id(PlayerID) of
				[] ->
					skip;
			Player2 ->
				 {NP1,NP2,Word1,Word2} = case Type of 
					1 ->
						NewPlayer1 = lib_player:add_currexp_and_liftexp(0, 88, 0, Player1),
						{ok, Bin1} = pt_20:write(?PP_UPDATE_USER_INFO,  NewPlayer1),
						lib_send:send_to_sid(NewPlayer1#ets_users.other_data#user_other.pid_send, Bin1),
						NewPlayer2 = lib_player:add_currexp_and_liftexp(0, 88, 0, Player2),
						{ok, Bin2} = pt_20:write(?PP_UPDATE_USER_INFO,  NewPlayer2),
						lib_send:send_to_sid(NewPlayer2#ets_users.other_data#user_other.pid_send, Bin2),
						{NewPlayer1,NewPlayer2,"调教","历练"};
					2 ->
						NewPlayer1 = lib_player:add_exp(Player1,88),
						NewPlayer2 = lib_player:add_exp(Player2,88),
						{NewPlayer1,NewPlayer2,"教导","经验"};
					3 ->
						NewPlayer1 = lib_player:add_cash_and_send(Player1, 0, 0, 0, 88),
						NewPlayer2 = lib_player:add_cash_and_send(Player2, 0, 0, 0, 88),
						{NewPlayer1,NewPlayer2,"调戏","铜币"}
				 end,
				 MsgNew = ?GET_TRAN(?_LANG_GUILD_WELCOME_PLAYER_NEW,[NP1#ets_users.nick_name,Word1,88,Word2]),
				 MsgOld = ?GET_TRAN(?_LANG_GUILD_WELCOME_PLAYER_OLD,[NP2#ets_users.nick_name,Word1,88,Word2]),
				 {ok,BinChatMsgNew} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,MsgNew]),
				 {ok,BinChatMsgOld} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,MsgOld]),
				 lib_send:send_to_sid(NP1#ets_users.other_data#user_other.pid_send, BinChatMsgOld),
				 lib_send:send_to_sid(NP2#ets_users.other_data#user_other.pid_send, BinChatMsgNew),
				 {ok,Data} = pt_21:write(?PP_CLUB_NEW_PLAYER_WELCOME_SUCCEED, []),
				 lib_send:send_to_sid(NP1#ets_users.other_data#user_other.pid_send, Data)
		end
end;

%% 帮会创建
handle(?PP_CLUB_CREATE, PlayerStatus, [Name, Declear, CreateType]) ->
	case CreateType of
		?GUILD_CREATE_TYPE_CARD ->	%% 扣物品，走物品流程
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{create_guild,
																				   Name,
																				   Declear,
																				   CreateType,
																				   PlayerStatus#ets_users.other_data#user_other.pid_send,
																				   PlayerStatus#ets_users.other_data#user_other.pid,
																				   PlayerStatus#ets_users.club_id,
																				   PlayerStatus#ets_users.nick_name,
																				   PlayerStatus#ets_users.career,
																				   PlayerStatus#ets_users.sex,
																				   PlayerStatus#ets_users.level,
																				   PlayerStatus#ets_users.vip_id,
																				   PlayerStatus#ets_users.id});
		_ -> %% 扣钱
			NewPlayer = lib_player:create_guild_by_money(PlayerStatus,
														 Name,
														 Declear,
														 CreateType
														 ),
			{update, NewPlayer}
	end;
	
%帮会贡献
handle(?PP_CLUB_CONTRIBUTION,PlayerStatus,[Type,Num]) ->
	case gen_server:call(mod_guild:get_mod_guild_pid(), {contribution_money,Type,Num,PlayerStatus}) of
		{ok, ReduceYuanBao,ReduceCopper} ->
			NewPlayerStatus = lib_player:reduce_cash_and_send(PlayerStatus,ReduceYuanBao,0,ReduceCopper,0,{?CONSUME_MONEY_GUILD_DONATE,0,0}),
			{update, NewPlayerStatus};
		{false} ->
			ok
	end;
%% 	case Type of
%% 		1 ->
%% 			%%用call,扣钱相关
%% 			case gen_server:call(mod_guild:get_mod_guild_pid(), {contribution_money,Type,Num,PlayerStatus}) of
%% 				{ok, NewPlayerStatus} ->
%% 					{update, NewPlayerStatus};
%% 				{false} ->
%% 					ok
%% 			end;
%% 		_ ->	%%扣物品，走物品流程
%% 			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{contribution,
%% 																				   PlayerStatus#ets_users.id,
%% 																				   PlayerStatus#ets_users.club_id,
%% 																				   PlayerStatus#ets_users.nick_name,
%% 																				   Type,
%% 																				   Num,
%% 																				   PlayerStatus#ets_users.other_data#user_other.pid_send})
%% 	end;

%% 帮会解散
handle(?PP_CLUB_DISMISS,PlayerStatus,[]) ->
	mod_guild:disband_guild(PlayerStatus#ets_users.club_id,
							PlayerStatus#ets_users.id,
							PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 帮会退出
handle(?PP_CLUB_EXIT,PlayerStatus,[]) ->
	mod_guild:leave_guild(PlayerStatus);

%% 帮会升级
handle(?PP_CLUB_LEVELUP,PlayerStatus,[]) ->
	mod_guild:update_guild_level_setting(PlayerStatus#ets_users.id,
										 PlayerStatus#ets_users.other_data#user_other.pid,
										 PlayerStatus#ets_users.other_data#user_other.pid_send,
										 PlayerStatus#ets_users.club_id);

%% 帮会踢出
handle(?PP_CLUB_KICKOUT,PlayerStatus,[TargetUserID]) ->
	mod_guild:kick_guild_user(PlayerStatus#ets_users.id,
							  PlayerStatus#ets_users.nick_name,
							  TargetUserID,
							  PlayerStatus#ets_users.club_id,
							  PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 帮会转让
handle(?PP_CLUB_TRANSFER,PlayerStatus,[TargetUserID]) ->
	mod_guild:demise_chief(PlayerStatus#ets_users.club_id,
						   PlayerStatus#ets_users.id,
						   PlayerStatus#ets_users.nick_name,
						   TargetUserID,
						   PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 帮会转让回应
handle(?PP_CLUB_TRANSFER_RESPONSE,PlayerStatus,[Accept,LeaderID]) ->
	case Accept of
		1 ->
			mod_guild:agree_demise_chief(LeaderID,
										 PlayerStatus#ets_users.id,
										 PlayerStatus#ets_users.nick_name,
										 PlayerStatus#ets_users.club_id,
										 PlayerStatus#ets_users.other_data#user_other.pid_send );
		_ ->
			%发信息给会长
			skip
	end;

%% %% 帮会扩展
%% handle(?PP_CLUB_EXTEND_ADD,PlayerStatus,[Type]) ->
%% 	case Type of
%% 		1 ->
%% 			EType = ?GUILD_MEMBER_HONORARY;
%% 		2 ->
%% 			EType = ?GUILD_MEMBER_COMMON;
%% 		_ ->
%% 			EType = ?GUILD_MEMBER_ASSOCIATE
%% 	end,
%% 	mod_guild:update_guild_member_setting(PlayerStatus#ets_users.id,
%% 										  EType,
%% 										  PlayerStatus#ets_users.club_id,
%% 										  PlayerStatus#ets_users.other_data#user_other.pid_send);


%% 帮会加入申请
handle(?PP_CLUB_TRYIN,PlayerStatus,[GuildID]) ->
	mod_guild:request_join_guild(PlayerStatus#ets_users.id,
								 PlayerStatus#ets_users.level,
								 GuildID,
								 PlayerStatus#ets_users.other_data#user_other.pid_send);
	
%% 帮会申请列表
handle(?PP_CLUB_QUERYTRYIN,PlayerStatus,[PageIndex,PageSize]) ->
	mod_guild:get_guild_users_request(PlayerStatus#ets_users.club_id,
									  PlayerStatus#ets_users.id,
									  PageIndex,
									  PageSize,
									  PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 申请答复
handle(?PP_CLUB_TRYINRESPONSE,PlayerStatus,[UserID,Accept,PageIndex,PageSize]) ->
	case Accept of
		1 ->
			mod_guild:agree_guild_users_request(PlayerStatus#ets_users.id,
												UserID,
												PlayerStatus#ets_users.other_data#user_other.pid_send,
												PlayerStatus#ets_users.club_id,
												PageIndex,
												PageSize);
		_ ->
			mod_guild:disagree_guild_users_request(PlayerStatus#ets_users.club_id,
												   PlayerStatus#ets_users.id,
												   UserID,
												   PlayerStatus#ets_users.other_data#user_other.pid_send,
												   PageIndex,
												   PageSize )
	end;


%% 清除申请列表 -返回 pp_club_querytype,total = 0 current = 0
handle(?PP_CLUB_CLEARTRYIN,PlayerStatus,[]) ->
	mod_guild:clear_guild_users_request(PlayerStatus#ets_users.club_id,
										PlayerStatus#ets_users.id,
										PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 职务更新
handle(?PP_CLUB_DUTY_UPDATE,PlayerStatus,[]) ->
	mod_guild:get_guild_info_and_member(PlayerStatus#ets_users.club_id,
										PlayerStatus#ets_users.id,
										PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 职务变更
handle(?PP_CLUB_DUTY_CHANGE,PlayerStatus,[UserID,Duty]) ->
	 mod_guild:edit_guild_user_member_type(PlayerStatus#ets_users.id,
										   UserID,
										   Duty,
										   PlayerStatus#ets_users.club_id,
										   PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 扩展更新
handle(?PP_CLUB_EXTEND_UPDATE,PlayerStatus,[]) ->
	mod_guild:get_guild_extend_info(PlayerStatus#ets_users.club_id,
									PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 帮会等级信息更新
handle(?PP_CLUB_LEVELUP_UPDATE,PlayerStatus,[]) ->
	mod_guild:get_guild_levelup_info(PlayerStatus#ets_users.club_id,
									PlayerStatus#ets_users.other_data#user_other.pid_send);



handle(?PP_CLUB_INVITE,PlayerStatus,[NickName]) ->
	mod_guild:invite_join_guild(PlayerStatus#ets_users.club_id,
								PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.nick_name,
								NickName,
								PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(?PP_CLUB_INVITE_RESPONSE,PlayerStatus,[Accept,GuildID]) ->
	case Accept of
		1 ->
			mod_guild:agree_guild_users_invite(PlayerStatus#ets_users.id,
											   GuildID,
											   PlayerStatus#ets_users.club_id,
											   PlayerStatus#ets_users.other_data#user_other.pid_send,
											   PlayerStatus#ets_users.nick_name);
		_ ->
			%发信息给会长
			skip
	end;


handle(?PP_CLUB_STORE_PAGEUPDATE,PlayerStatus,[PageIndex]) ->
	mod_guild:get_item_list_in_guild_warehouse(PlayerStatus#ets_users.club_id,
											   PlayerStatus#ets_users.id,
											   PageIndex,
											   PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(?PP_CLUB_STORE_REQUEST_LIST,PlayerStatus,[PageIndex]) ->
	mod_guild:get_guild_item_request_all(PlayerStatus#ets_users.club_id,
										 PlayerStatus#ets_users.id,
										 PageIndex,
										 PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(?PP_CLUB_STORE_MY_REQUEST_LIST,PlayerStatus,[PageIndex]) ->
	mod_guild:get_guild_item_request(PlayerStatus#ets_users.club_id,
										 PlayerStatus#ets_users.id,
										 PageIndex,
										 PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(?PP_CLUB_STORE_GET,PlayerStatus,[ItemID]) ->
	mod_guild:request_guild_item(PlayerStatus#ets_users.club_id,
								 PlayerStatus#ets_users.id,
								 ItemID,
								 PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(?PP_CLUB_STORE_PUT,PlayerStatus,[Place]) ->	
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{put_item_in_guild_warehouse,
																		   PlayerStatus#ets_users.nick_name,
										  									PlayerStatus#ets_users.id,
										  									PlayerStatus#ets_users.club_id,
										  									Place,
										  									PlayerStatus#ets_users.other_data#user_other.pid_send
																		   });

handle(?PP_CLUB_STORE_CHECK,PlayerStatus,[ID,Type]) ->
	mod_guild:invite_guild_item(PlayerStatus#ets_users.club_id,
								PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.nick_name,
								ID,
								Type,
								PlayerStatus#ets_users.other_data#user_other.pid_send);
	
handle(?PP_CLUB_STORE_EVENT,PlayerStatus,[]) ->
	 mod_guild:get_guild_warehouse_logs(PlayerStatus#ets_users.club_id,
										PlayerStatus#ets_users.other_data#user_other.pid_send);


handle(?PP_CLUB_STORE_ITEM_CANCEL,PlayerStatus,[ID]) ->
	 mod_guild:cancel_guild_item_request(PlayerStatus#ets_users.club_id,
										 PlayerStatus#ets_users.id,
										ID,
										PlayerStatus#ets_users.other_data#user_other.pid_send);


handle(?PP_CLUB_SELF_EXPLOIT_UPDATE,PlayerStatus,[]) ->
	mod_guild:get_guild_user_info(PlayerStatus#ets_users.club_id,
								  PlayerStatus#ets_users.id,
								  PlayerStatus#ets_users.other_data#user_other.pid_send);	


handle(?PP_CLUB_WAR_DEAL_INIT, PlayerStatus, [PageIndex, PageSize]) ->
	gen_server:cast(mod_guild:get_mod_guild_pid(),{club_war_deal_init,
												   PageIndex,
												   PageSize,
												   PlayerStatus#ets_users.club_id,
												   PlayerStatus#ets_users.id,
												   PlayerStatus#ets_users.other_data#user_other.pid_send});
	
handle(?PP_CLUB_WAR_ENEMY_INIT, PlayerStatus, [PageIndex, PageSize]) ->
	gen_server:cast(mod_guild:get_mod_guild_pid(),{club_war_enemy_init,
												   PageIndex,
												   PageSize,
												   PlayerStatus#ets_users.club_id,
												   PlayerStatus#ets_users.id,
												   PlayerStatus#ets_users.other_data#user_other.pid_send});
	  
handle(?PP_CLUB_WAR_DECLEAR, PlayerStatus, [TargetGuildID, DeclearType, PageIndex, PageSize]) ->
	case DeclearType of
		?GUILD_BATTLE_DECLEAR_FORCE ->	%% 强行宣战，走物品流程
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{club_war_declear,
												   TargetGuildID,
												   DeclearType,
												   PageIndex,
												   PageSize,
												   PlayerStatus#ets_users.club_id,
												   PlayerStatus#ets_users.id,
												   PlayerStatus#ets_users.other_data#user_other.pid_send});
		_ ->
			gen_server:cast(mod_guild:get_mod_guild_pid(),{club_war_declear,
												   TargetGuildID,
												   DeclearType,
												   PageIndex,
												   PageSize,
												   PlayerStatus#ets_users.club_id,
												   PlayerStatus#ets_users.id,
												   PlayerStatus#ets_users.other_data#user_other.pid_send})
	end;
		
handle(?PP_CLUB_WAR_DEAL, PlayerStatus, [TargetGuildID, DealType, PageIndex, PageSize]) ->
	gen_server:cast(mod_guild:get_mod_guild_pid(),{club_war_deal,
												   TargetGuildID,
												   DealType,
												   PageIndex,
												   PageSize,
												   PlayerStatus#ets_users.club_id,
												   PlayerStatus#ets_users.id,
												   PlayerStatus#ets_users.other_data#user_other.pid_send});
		  
handle(?PP_CLUB_WAR_STOP, PlayerStatus, [TargetGuildID, PageIndex, PageSize]) ->
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{club_war_stop,
																		   TargetGuildID,
																		   PageIndex,
																		   PageSize,
																		   PlayerStatus#ets_users.club_id,
																		   PlayerStatus#ets_users.id,
												   PlayerStatus#ets_users.other_data#user_other.pid_send});
%% 	
%% 	gen_server:cast(mod_guild:get_mod_guild_pid(),{club_war_stop,
%% 												   TargetGuildID,
%% 												   PageIndex,
%% 												   PageSize,
%% 												   PlayerStatus#ets_users.club_id,
%% 												   PlayerStatus#ets_users.id,
%% 												   PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 												   PlayerStatus#ets_users.other_data#user_other.pid_item});


handle(?PP_CLUB_WEAL_UPDATE, PlayerStatus, []) ->
	gen_server:cast(mod_guild:get_mod_guild_pid(), {club_weal_update,
													PlayerStatus#ets_users.id,
													PlayerStatus#ets_users.club_id,
													PlayerStatus#ets_users.level,
													PlayerStatus#ets_users.other_data#user_other.pid_send});

handle(?PP_CLUB_GETWEAL, PlayerStatus, []) ->
	gen_server:cast(mod_guild:get_mod_guild_pid(), {club_getweal,
													PlayerStatus#ets_users.id,
													PlayerStatus#ets_users.club_id,
													PlayerStatus#ets_users.level,
													PlayerStatus#ets_users.other_data#user_other.pid_send,
													PlayerStatus#ets_users.other_data#user_other.pid});



%-=--------------------------已对-----------------------------

%% 帮会成员
handle(?PP_CLUB_QUERYMEMBER, PlayerStatus,[]) ->
	L = mod_guild:get_guild_users_list(PlayerStatus#ets_users.club_id),
	{ok,BinData} = pt_21:write(?PP_CLUB_QUERYMEMBER,[L]),
	mod_map_agent: send_to_area_scene(
									PlayerStatus#ets_users.current_map_id,
									PlayerStatus#ets_users.pos_x,
									PlayerStatus#ets_users.pos_y,
									BinData,
									undefined),
	ok;

%% 进入帮派驻地
handle(?PP_CLUB_ENTER, PlayerStatus, _) ->
	case PlayerStatus#ets_users.club_id > 0 of
		true ->
			{MapId, PosX, PosY} = ?GUILD_MAP,
			Result =
				case erlang:is_pid(PlayerStatus#ets_users.other_data#user_other.pid_guild_map) of
					true ->
						{ok, PlayerStatus#ets_users.other_data#user_other.pid_guild_map,
						 PlayerStatus#ets_users.other_data#user_other.guild_map_id};						
					_ ->					
						mod_guild:get_guild_map_info(PlayerStatus#ets_users.club_id)
				end,
			
			case Result of
				{ok, MapPid, MapOnlyId} ->
					mod_map:leave_scene(PlayerStatus#ets_users.id, 
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id, 
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
								PlayerStatus#ets_users.pos_x, 
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid,
								PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),

					Other = PlayerStatus#ets_users.other_data#user_other{
																 pid_map = MapPid,
																 walk_path_bin=undefined,
																 pid_dungeon= undefined,
																 map_template_id = MapId,
																 pid_guild_map = MapPid,
																 guild_map_id = MapOnlyId
																 },
					{OldMapId,OldX,OldY} = case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
						true ->
							{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y};
						_ ->
							{PlayerStatus#ets_users.current_map_id,PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y}
					end,
					NowTime = misc_timer:now_seconds(),
					NewStatus1 = PlayerStatus#ets_users{current_map_id=MapOnlyId,
														pos_x=PosX,
														pos_y=PosY,
														old_map_id = OldMapId,
											  			old_pos_x = OldX,
											   			old_pos_y = OldY,
														is_horse = 0,
														pk_mode = ?PKMode_CLUB,
														pk_mode_change_date = NowTime,
														other_data=Other
													  },
					
					NewStatus = lib_player:calc_speed(NewStatus1, 0),
					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [MapId, NewStatus#ets_users.pos_x, NewStatus#ets_users.pos_y]),
					lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, EnterData),	
					
					{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, MapId),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, ReturnData),						

					{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_CLUB, NowTime]),
					lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, BinData),
					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus]),
					mod_map_agent:send_to_area_scene(NewStatus#ets_users.current_map_id,
									  				NewStatus#ets_users.pos_x,
									  				NewStatus#ets_users.pos_y,
									  				PlayerData,
									  				undefined),
					
					{ok, Bin} = pt_21:write(?PP_CLUB_ENTER, [1]),
					lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
					
					{update_map, NewStatus};
				_ ->
					skip
			end;
		false ->
			skip
	end;

%% 退出帮会地图
handle(?PP_CLUB_LEAVE_SCENCE, PlayerStatus, _) ->
	case lib_duplicate:quit_club_map(PlayerStatus) of
		{ok, NewStatus} ->
			{update_map, NewStatus};
		_ ->
			skip
	end;
	


handle(?PP_CLUB_MEMBER_LIST,PlayerStatus,_) ->
	mod_guild:get_guild_users_list_info(PlayerStatus#ets_users.club_id,													
										PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(?PP_CLUB_SUMMON_NUM,PlayerStatus,_) ->
	mod_guild:get_guild_summon_num(PlayerStatus#ets_users.club_id,													
										PlayerStatus#ets_users.other_data#user_other.pid_send);

%% 帮会活动召唤
handle(?PP_CLUB_SUMMON, PlayerStatus, [Id]) ->
	 if
		PlayerStatus#ets_users.other_data#user_other.map_template_id =:= ?GUILD_MAP_ID ->
			case data_agent:get_guild_summon_template(Id) of
				[] ->
					{ok,Bin} = pt_21:write(?PP_CLUB_SUMMON,[0,?ER_WRONG_VALUE]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin);
				Temp ->
					mod_guild:update_guild_summon(PlayerStatus#ets_users.id,
									PlayerStatus#ets_users.other_data#user_other.pid,
									PlayerStatus#ets_users.other_data#user_other.pid_send,
									PlayerStatus#ets_users.club_id,
									Temp)
			end;
		true ->
			{ok,Bin} = pt_21:write(?PP_CLUB_SUMMON,[0,?ER_MAP_LIMIT]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin)
	end;
%% 帮会祈福
handle(?PP_CLUB_PRAYER, PlayerStatus, _) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {guild_prayer, PlayerStatus#ets_users.club_id}) of
		[0,Er] ->
			{ok,Bin} = pt_21:write(?PP_CLUB_PRAYER,[0,Er]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin);
		[1,TemplateId] ->
			case mod_guild:reduce_guild_user_feats(PlayerStatus#ets_users.club_id, PlayerStatus#ets_users.id, 1, ?GUILD_PRAYER_PRICE,13,?GUILD_PRAYER_MAX_NUM) of
				{true, NewFeats,_Times} ->
					{ok,FeatsBin} = pt_21:write(?PP_CLUB_SELF_EXPLOIT_UPDATE,[NewFeats]),
					lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, FeatsBin);
				_er ->
					?ERROR_MSG("PP_CLUB_PRAYER error:~p",[_er])		
			end,
			{ok,Bin} = pt_21:write(?PP_CLUB_PRAYER,[1,TemplateId]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin)			
	end;
%% 帮会祈福
handle(?PP_CLUB_LIMIT_NUM_LIST, PlayerStatus, _) ->
	List = case mod_guild:get_guild_user_info(PlayerStatus#ets_users.club_id, PlayerStatus#ets_users.id) of
		[] ->
			[];
		MemberInfo ->
			PrayerNum = lib_guild:pub_get_guild_user_feats_use_timers(MemberInfo, 13),
			[{13,PrayerNum}]
	end,
	{ok, Bin} = pt_21:write(?PP_CLUB_LIMIT_NUM_LIST,[List]),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, Bin);

%% 帮会设施升级
handle(?PP_CLUB_UPGRADE_DEVICE,PlayerStatus,[Type]) ->
	mod_guild:update_guild_device_level(PlayerStatus#ets_users.id,
										 PlayerStatus#ets_users.other_data#user_other.pid,
										 PlayerStatus#ets_users.other_data#user_other.pid_send,
										 PlayerStatus#ets_users.club_id,
										 Type
										 );


%% 获取公告	
handle(?PP_CLUB_GET_NOTICE,PlayerStatus,[]) ->
	 mod_guild:get_guild_declaretion(PlayerStatus#ets_users.club_id,
											   PlayerStatus#ets_users.id,
											   PlayerStatus#ets_users.other_data#user_other.pid_send);

handle(Cmd, _Status, V) ->
	?WARNING_MSG("pp_guild cmd is not: ~p ~p", [Cmd,V]).

%%
%% Local Functions
%%

