%%%--------------------------------------
%%% @Module  : lib_player
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description:角色相关处理

%%%--------------------------------------
-module(lib_player).
-include("common.hrl").
-export([
		 init_user_attr_template/0,
		 init_user_title_template/0,
		 get_role_id_by_name/1,
		 is_exists_name/1,
		 get_info_by_id/1,
		 get_player_info_guild_use_by_id/1,
		 get_player_pid/1,
		 check_yuanbao/2,
		 check_bind_yuanbao/2,
		 check_cash/3,
		 reduce_cash/6,
		 %%update_cash/5,	%% 更新玩家身上的元宝、铜币、绑定铜币为指定值
		 reduce_cash_and_send/5,
		 reduce_cash_and_send/6,
		 add_cash_and_send/5, %%添加货币并发送
		 add_cash_and_send/6,
		 is_online/1,
		 get_online_info/1,
		 get_online_player_info_by_id/1,
		 get_player_info_by_id/1,
		 add_hp_and_mp/3,
		 reduce_hp_and_mp_by_self/3,
		 reduce_hp_and_mp/9,
		 reduce_pk_value/2,
		 get_infant_by_username/2,
		 add_exp/5,
		 add_exp/2,
		 add_exp/4,
		 add_honor/2,
		 add_duplicate_award/2,
		 relive/2,
		 reduce_experiences/1,
		 reduce_life_experiences/2,
		 relive_at_present/1,
		 relive_at_safety/1,
		 relive_with_dup_fresh/1,
		 notice_unlock/3,
         reduce_current_physical/2,
		 calc_properties/1,
		 calc_properties/5,
		 get_player_info/1,
		 login_in_duplicate/2,		
		 relive_to_city/1,
		 return_to_old_map/1,
		 return_to_city/1,
		 random_to_transfer/1,
		 use_transfer_shoe/4,
		 player_break_away/1,
		 calc_properties_send_self/1,
		 calc_properties_send_self_area/1,
		 change_pk_time/2,
		 change_pk_mode/2,
		 change_hide_title/2,
		 cale_attach_effect_loop/3,
		 get_user_title_attr_by_id/1,
		 get_nick_by_id/1,
		 add_life_experiences/2,
		 add_currexp_and_liftexp/4,
		 %notice_move/1,
		 %notice_hp/1,
		 collect_item/11,
		 add_expansion/4,
		 calc_speed/2, 
		 change_title/2,
		 get_user_total_titles/1,
		 check_add_title/2,
		 add_title/2,
		 check_remove_title/2,
		 pick_drop_item/2,
		 kill_player/1,
		 add_task_award/9,
		 kill_pk/2,
		 pvp_end/4,
		 update_pvp_first/3,
%% 		 get_actor_pk_list/2,
		 auto_add_hp_mp/3,
		 set_pk_dic/3,
		 send_to_message_to_gm/4,
		 change_stylebin/1,
		 update_escort_info/6,
		 check_rob_times/2,
%% 		 update_escort_cancel_style/6,
		 cancel_escort/1,
		 finish_escort/3,
		 kill_escort/6,
		 change_pk_mode_auto/1,
		 relive_by_skill/3,
		 load_pay/1,
		 user_buy_item_qq/2,
		 collect_activity_by_uid/5,
		 unite_pay/1,
		 add_exp_in_guild_bonfire/2,

		 collect_activity_by_code/7,
		 collect_activity_every_once/4,
		 update_vip/2,
		 update_now_state/1,
		 collect_activity_search/3,
		
		 set_guild_trans_time/2,
		 check_nobind_cash/3,
		 create_guild_by_money/4,
		 relive_war/2,
		 calc_pet_properties/2,
		 calc_pet_BattleInfo/2,
		 exchange_bind_yuanbao/2
		]).

%% 主城地图

-define(MAX_COPPER, 2000000000). 					%%最多铜币
-define(MAX_YUANBAO,1000000000).					%%最多元宝

-define(EXCHANGE_YUAN_BAO,88).                       %% 玩家兑换银两88
-define(EXCHANGE_YUAN_BAO1,288).                     %% 玩家兑换银两288
-define(EXCHANGE_YUAN_BAO2,588).                     %% 玩家兑换银两588
-define(EXCHANGE_YUAN_BAO_GET,176).                %% 玩家获得银两176
-define(EXCHANGE_YUAN_BAO_GET1,576).              %% 玩家获得银两576
-define(EXCHANGE_YUAN_BAO_GET2,1176).            %% 玩家获得银两1176
-define(EXCHANGE_YUAN_BAO_WARITE,2#1).        %% 标记玩家兑换银两88
-define(EXCHANGE_YUAN_BAO_WARITE1,2#10).     %% 标记玩家兑换银两288
-define(EXCHANGE_YUAN_BAO_WARITE2,2#100).   %% 标记玩家兑换银两588

-define(BUFF_FIRST_INACTIVE,9000002).  %天下第一buff活动中
-define(BUFF_FIRST_OUTACTIVE,9000003).  %天下第一buff活动后
-define(GUILD_FIGHT_BUFF, 9000005).		%% 帮会乱斗流血BUFF

%% 初始化人物基础属性表
init_user_attr_template() ->
	F= fun(Info) ->
			   Record = list_to_tuple([ets_user_attr_template] ++ (Info)),
			   Id = {Record#ets_user_attr_template.career, Record#ets_user_attr_template.level},
			   NewRecord = Record#ets_user_attr_template{
														career=Id
														},
 			   ets:insert(?ETS_USER_ATTR_TEMPLATE, NewRecord)
	   end,
	case db_agent_template:get_user_attr_template() of
		[] ->skip;
		List when is_list(List) ->
			lists:foreach(F,List)
	end,
	ok.


%% 初始化人物称号模板
init_user_title_template() ->
	F = fun(Info) ->
				Record = list_to_tuple([ets_title_template] ++ (Info)),
				SN = tool:split_string_to_intlist(Record#ets_title_template.data),
				Other_Title = #other_title{},
				Record1  = Record#ets_title_template{other_data = Other_Title },
				NewRecord = cale_attach_effect_loop(SN,Other_Title,Record1),
				ets:insert(?ETS_TITLE_TEMPLATE,NewRecord)
		end,
	case db_agent_template:get_title_template() of
		[] ->skip;
		List when is_list(List) ->
			lists:foreach(F,List)
	end,
	ok.

cale_attach_effect_loop([], _Other_Title,Record) ->
    Record;

cale_attach_effect_loop([{K, V} | T],Other_Title,Record) ->
			case K of
				?ATTACK_PHYSICS ->
					Other = Other_Title#other_title{
													attack_physics = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?DEFENCE_PHYSICS -> 
					Other = Other_Title#other_title{
													defence_physics = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?HURT_PHYSICS ->
					Other = Other_Title#other_title{
													hurt_physics = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTACK_VINDICTIVE ->
					Other = Other_Title#other_title{
													attack_vindictive = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);				
				?ATTACK_MAGIC -> 
					Other = Other_Title#other_title{
													attack_magic = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_HITTARGET -> 
					Other = Other_Title#other_title{
													hit_target = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_DUCK -> 
					Other = Other_Title#other_title{
													duck = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_DELIGENCY -> 
					Other = Other_Title#other_title{
													deligency = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_POWERHIT -> 
					Other = Other_Title#other_title{
													power_hit = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				?ATTR_HP -> 
					Other = Other_Title#other_title{
													max_physical = V
												   },
					NewRecord = Record#ets_title_template{
														  other_data = Other
														 },
                    cale_attach_effect_loop(T,Other,NewRecord);
				
				_Other ->
					?WARNING_MSG("cale_attach_effect_loop:~w", [_Other]),
					cale_attach_effect_loop(T,Other_Title,Record)
			end.


%% 根据角色名称查找ID
get_role_id_by_name(Nick) ->
    db_agent:get_role_id_by_name(Nick).

get_nick_by_id(Id) ->
	db_agent:get_nick_by_id(Id).

%% 检测指定名称的角色是否已存在
is_exists_name(Nick) ->
    case get_role_id_by_name(Nick) of
        null -> 
			false;
        _Other -> 
			true
    end.

%% 通过角色ID取得角色信息
get_info_by_id(UserId) ->
	db_agent:get_info_by_id(UserId).

%% 取得在线角色的进程PID
get_player_pid(UserId) ->
	PlayerProcessName = misc:player_process_name(UserId),
	case misc:whereis_name({global, PlayerProcessName}) of
		Pid when is_pid(Pid) ->
			case misc:is_process_alive(Pid) of
				true -> 
					Pid;
				_ ->
					[]
			end;
		_ -> []
	
	end.

%% 检测某个角色是否在线
is_online(PlayerId) ->
	case get_player_pid(PlayerId) of
		[] -> 
			false;
		_Pid -> 
			true
	end.

%% 获取在线玩家信息,进程
get_online_player_info_by_id(Id) ->
	case get_player_pid(Id) of
		[] -> [];
		Pid ->
             case catch gen:call(Pid,'$gen_call', 'PLAYER', 2000) of
             	{exit, _Reason} ->
              		[];
             	{ok, Player} ->
               		Player;
			 	Reason ->
					?WARNING_MSG("get_online_player_info_by_id:~w",[Reason]),
					[]
             end
	end.

%获取player对象
get_player_info(Pid) ->
	case catch gen:call(Pid,'$gen_call', 'PLAYER', 2000) of
		{exit, _Reason} ->
			[];
        {ok, Player} ->
			Player;
		Reason ->
			?WARNING_MSG("get_player_info:~w",[Reason]),
			[]
     end.

%% 取得在线角色的角色状态，ets和进程
get_online_info(Id) ->
	case ets:lookup(?ETS_ONLINE, Id) of
		[] ->
			get_online_player_info_by_id(Id);
		[R] ->
			case misc:is_process_alive(R#ets_users.other_data#user_other.pid) of
				true -> R;
				false ->
					ets:delete(?ETS_ONLINE, Id),
					[]
			end
	end.

%%获取玩家信息，不在线则读数据库
get_player_info_by_id(Id) ->
	case get_online_info(Id) of
		[] -> 
			case get_info_by_id(Id) of
				[] ->
					{false};
				Info1 ->
					Info = list_to_tuple([ets_users] ++ Info1),
					StyleBin = change_stylebin(Info#ets_users.style_bin),
					Other = #user_other{sit_state = 0},		
					Info#ets_users{style_bin = StyleBin, other_data=Other}
			end;			
		I -> 
			I
	end.

%%获取帮会用户列表里需要的用户信息,	返回{职业,等级,vip,性别,战斗力,离线时间,在线情况}
get_player_info_guild_use_by_id(Id) ->
	case get_online_info(Id) of
		[] -> %不在线
			case get_info_by_id(Id) of
				[] ->
					{false};
				Info1 ->
					Info = list_to_tuple([ets_users] ++ Info1),
					{Info#ets_users.nick_name,Info#ets_users.career,Info#ets_users.level,Info#ets_users.vip_id,Info#ets_users.sex,Info#ets_users.fight,Info#ets_users.last_online_date,0}
			end;
		I ->
			{I#ets_users.nick_name,I#ets_users.career,I#ets_users.level,I#ets_users.vip_id,I#ets_users.sex,I#ets_users.fight,0,1}
	end.

%%获取玩家防沉迷信息
get_infant_by_username(UserName, Site) ->
    InFant = (catch db_agent_user:get_user_infant_by_username(UserName, Site)),
	InFantInfo = list_to_tuple(InFant),
	InFantInfo.

get_user_title_attr_by_id(TitleId)->
	case  data_agent:user_title_template_get(TitleId) of
		[] ->
	    	 User_title_attr1= #other_title{};
		Title_attr ->
			  User_title_attr1 = Title_attr#ets_title_template.other_data
	end,
	User_title_attr1.


%%获取玩家全部称号
get_user_total_titles(UserID) ->
	Titledata  = 
		case  db_agent_user:get_users_title(UserID) of
			[] ->
				"";
			[List] ->
				List
		end,
	TitleStr = tool:to_list(Titledata),
	
	case erlang:length( TitleStr ) of
		0 ->
			[];
		_ ->
%% 			TitleList = string:tokens(TitleStr, ","),
%% 			F = fun(X, L) ->
%% 						{X1,_} = string:to_integer(X),
%% 						[X1|L]
%% 				end,
%% 			NewTitleList = lists:foldl(F, [], TitleList),
			tool:split_string_to_intlist(TitleStr)
%% 			NewTitleList
	end.

check_yuanbao(User,ReduceYuanBao) ->
	 User#ets_users.yuan_bao >= ReduceYuanBao.

check_bind_yuanbao(User,ReduceYuanBao) ->
	 User#ets_users.bind_yuan_bao >= ReduceYuanBao.
			
%检查
check_cash(User, ReduceYuanBao, ReduceCopper) ->
	TotalCopper = User#ets_users.bind_copper + User#ets_users.copper,
	TotalCopper >= ReduceCopper andalso User#ets_users.yuan_bao >= ReduceYuanBao.

check_nobind_cash(User,ReduceYuanBao, ReduceCopper) ->
	User#ets_users.copper >= ReduceCopper andalso User#ets_users.yuan_bao >= ReduceYuanBao.

	
%%扣除元宝和铜币（玩家信息，扣除非绑定元宝，扣除绑定元宝，扣除非绑定铜币，扣除绑定铜币：先扣绑定，再扣非绑定）
reduce_cash(User, ReduceYuanBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper,LogData) ->
	if
		ReduceYuanBao >=0 andalso ReduceCopper >=0 andalso ReduceBindCopper>=0 andalso ReduceBindYuanBao >= 0 ->
			BindCopper = User#ets_users.bind_copper,
			Copper = User#ets_users.copper,
			BindYuanBao = User#ets_users.bind_yuan_bao,
			YuanBao = User#ets_users.yuan_bao,
			
			%%扣除货币
			LeftBindCopper = erlang:max(BindCopper - ReduceBindCopper, 0 ),
	        TempCopper = case BindCopper >= ReduceBindCopper of
							 true -> 0;
							 _ ->
								ReduceBindCopper - BindCopper
						 end,				   
			LeftCopper = Copper - ReduceCopper - TempCopper,
			LeftBindYuanBao = erlang:max(BindYuanBao - ReduceBindYuanBao, 0 ),
			TempYuanBao = case BindYuanBao >= ReduceBindYuanBao of
							  true -> 0;
							  _ ->
								  ReduceBindYuanBao - BindYuanBao
						  end,		
			LeftYuanBao = YuanBao - ReduceYuanBao - TempYuanBao,
			if
				ReduceYuanBao > 0 orelse ReduceBindYuanBao > 0 ->
					{Type,TempId,Amount} = LogData,
					lib_statistics:add_consume_yuanbao_log(User#ets_users.id, ReduceYuanBao, ReduceBindYuanBao,
														   1, Type, misc_timer:now_seconds(), TempId, Amount, User#ets_users.level);
				true ->
					ok
			end,
			lib_active_open_server:user_use(ReduceYuanBao + TempYuanBao,User),
			User#ets_users{bind_copper = LeftBindCopper,
						   copper = LeftCopper,
						   yuan_bao = LeftYuanBao,
						   bind_yuan_bao = LeftBindYuanBao};
	true ->
			User
	end.


%% 更新玩家身上的元宝，铜币，绑定铜币为指定值
%% update_cash(User, YuanBao, FreeCopper, BindCopper, IsSend) ->
%% 	if
%% 		YuanBao >= 0 andalso
%% 		FreeCopper >=0 andalso
%% 		BindCopper >=0  ->
%% 			NewUser = User#ets_users{
%% 									 yuan_bao = YuanBao,
%% 									 copper = FreeCopper,
%% 									 bind_copper = BindCopper
%% 									 },
%% 			case IsSend of
%% 				true ->
%% 					{ok, BinData} = pt_20:write(?PP_UPDATE_SELF_INFO,
%% 												[NewUser#ets_users.yuan_bao,
%% 												 NewUser#ets_users.copper,
%% 												 NewUser#ets_users.bind_copper,
%% 												 NewUser#ets_users.depot_copper,
%% 												 NewUser#ets_users.bind_yuan_bao]),
%% 					lib_send:send_to_sid(NewUser#ets_users.other_data#user_other.pid_send, BinData);
%% 				false ->
%% 					skip
%% 			end,
%% 			NewUser;
%% 		true ->
%% 			User
%% 	end.

reduce_cash_and_send(User, ReduceYuanBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper) ->
	reduce_cash_and_send(User, ReduceYuanBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper,{?CONSUME_DEFAULT,0,0}).

%%扣除元宝和铜币，并发送包
reduce_cash_and_send(User, ReduceYuanBao, ReduceBindYuanBao, ReduceCopper, ReduceBindCopper,LogData) ->
	if
		ReduceYuanBao >=0 andalso ReduceCopper >=0 andalso ReduceBindCopper>=0 andalso ReduceBindYuanBao >= 0 ->
			BindCopper = User#ets_users.bind_copper,
			Copper = User#ets_users.copper,
			BindYuanBao = User#ets_users.bind_yuan_bao,
			YuanBao = User#ets_users.yuan_bao,
			
			%%扣除货币
			LeftBindCopper = erlang:max(BindCopper - ReduceBindCopper, 0 ),
	        TempCopper = case BindCopper >= ReduceBindCopper of
							 true -> 0;
							 _ ->
								ReduceBindCopper - BindCopper
						 end,				   
			LeftCopper = Copper - ReduceCopper - TempCopper,			
			LeftBindYuanBao = BindYuanBao - ReduceBindYuanBao,	
			LeftYuanBao = YuanBao - ReduceYuanBao,
			if
				ReduceYuanBao > 0 orelse ReduceBindYuanBao > 0 ->
					{Type,TempId,Amount} = LogData,
					lib_statistics:add_consume_yuanbao_log(User#ets_users.id, ReduceYuanBao, ReduceBindYuanBao,
														   1, Type, misc_timer:now_seconds(), TempId, Amount, User#ets_users.level);
				true ->
					ok
			end,
			NewUser = User#ets_users{bind_copper = LeftBindCopper,
						   copper = LeftCopper,
						   yuan_bao = LeftYuanBao,
						   bind_yuan_bao = LeftBindYuanBao},
			lib_active_open_server:user_use(ReduceYuanBao,User),
			{ok, CashData} = pt_20:write(?PP_UPDATE_SELF_INFO, 
										[NewUser#ets_users.yuan_bao,
										 NewUser#ets_users.copper,
										 NewUser#ets_users.bind_copper,
										 NewUser#ets_users.depot_copper,
										 NewUser#ets_users.bind_yuan_bao]),
			lib_send:send_to_sid(NewUser#ets_users.other_data#user_other.pid_send, CashData),
			NewUser;
	true ->
			User	
	end.

%%增加格子数量
add_expansion(PlayerStatus, AddComExpan, AddDepotExpan,Type) ->
	BagMaxCount = min((PlayerStatus#ets_users.bag_max_count+AddComExpan),  ?MAXCOMMONCOUNT),
	DepotMaxCount = min((PlayerStatus#ets_users.depot_max_number+AddDepotExpan),  ?MAXDEPOTCOUNT),
	
	if
		BagMaxCount =:= ?MAXCOMMONCOUNT ->
			List = [{?TARGET_EXPAND_ALL_BAG,{0,1}}];
		true ->
			List = []
	end,
	List1 = [  {?TARGET_EXPAND_BAG,{Type,AddComExpan}} | List ],
	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,List1),
	PlayerStatus#ets_users{
						   bag_max_count = BagMaxCount,
						   depot_max_number = DepotMaxCount   
						   }.


%扣除历练，传入要扣掉的值
reduce_life_experiences(PlayerStatus, LifeExperiences) -> 
	PlayerStatus#ets_users{
						   	life_experiences = PlayerStatus#ets_users.life_experiences - LifeExperiences
						   }.
						  
%%添加历练，传入要添加的值
add_life_experiences(PlayerStatus, AddExperiences1) ->
	if PlayerStatus#ets_users.pk_value > ?USER_PK_VALUE  orelse AddExperiences1 =< 0 ->
		   PlayerStatus;	%红名不加
	   true ->
			case PlayerStatus#ets_users.other_data#user_other.infant_state of
				4 ->
					AddExperiences = 0;
				3 ->
					AddExperiences = AddExperiences1 bsr 1;
				_ ->
					AddExperiences = AddExperiences1
			end,
			NewLiftExp = min(PlayerStatus#ets_users.other_data#user_other.total_life_experiences, 
							 PlayerStatus#ets_users.life_experiences + 
							tool:floor(AddExperiences * (1 + PlayerStatus#ets_users.other_data#user_other.vip_lifeexp_rate))),
			PlayerStatus#ets_users{
								   life_experiences = NewLiftExp
								   }
	end.

%%扣除历练和装备耐久
reduce_experiences(PlayerStatus)->
	if PlayerStatus#ets_users.pk_value >?USER_PK_VALUE andalso PlayerStatus#ets_users.camp =:= 0 ->
			Amout=(1-0.10),
			NewPlayerStatus = PlayerStatus#ets_users{
											 life_experiences = tool:floor(PlayerStatus#ets_users.life_experiences*Amout)
								            },
			{ok, Bin} = pt_20:write(?PP_PLAYER_SELF_LIFEEXP,[NewPlayerStatus#ets_users.life_experiences]),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, Bin),
			{ok,NewPlayerStatus};
	   true ->
		  {ok, PlayerStatus}
	end.



add_cash(User, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper,LogData) ->
	if
		AddYuanBao >=0 andalso AddCopper >=0 andalso AddBindCopper>=0 andalso AddBindYuanBao >= 0->
			NewUser = User#ets_users{bind_copper = (User#ets_users.bind_copper) + AddBindCopper,
						   copper = (User#ets_users.copper) + AddCopper,
						   yuan_bao = (User#ets_users.yuan_bao) + AddYuanBao,
						   bind_yuan_bao = (User#ets_users.bind_yuan_bao) + AddBindYuanBao},
						  if
							  AddCopper >= 0 ->
								  TemList = [{?TARGET_COPPER,{0,NewUser#ets_users.copper}}];
							  true ->
								  TemList = []
						  end,
						  if
							  AddYuanBao >= 0 ->
								  TemList1 = [{?TARGET_YUANBAO,{0,NewUser#ets_users.yuan_bao}} | TemList ];
							  true ->
								  TemList1 = TemList
						  end,
			lib_target:cast_check_target(User#ets_users.other_data#user_other.pid_target,TemList1),
			NowTime = misc_timer:now_seconds(),
			{Type, Template_id, Amount} = LogData, 
			if
				AddYuanBao > 0 orelse AddBindYuanBao > 0 -> %%增加元宝操作日志					
					lib_statistics:add_consume_yuanbao_log(NewUser#ets_users.id, AddYuanBao, AddBindYuanBao, 
													   0, Type, NowTime, Template_id, Amount, NewUser#ets_users.level);
				true ->
					skip
			end,
			if
				AddCopper > 0 orelse AddBindCopper > 0 ->
					lib_statistics:add_consume_copper_log(NewUser#ets_users.id, AddCopper, AddBindCopper, 
													    Type, NowTime, Template_id, Amount, NewUser#ets_users.level);
				true ->
					skip
			end,
			NewUser;
		true ->
			User
	end.

add_cash_and_send(User, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper) ->
	add_cash_and_send(User, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper, {?CONSUME_DEFAULT,0,0}).

add_cash_and_send(User, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper, LogData) ->
	NewUser = add_cash(User, AddYuanBao, AddBindYuanBao, AddCopper, AddBindCopper, LogData),
	if
		NewUser#ets_users.yuan_bao >= ?MAX_YUANBAO orelse NewUser#ets_users.copper >= ?MAX_COPPER ->
			gen_server:cast(NewUser#ets_users.other_data#user_other.pid,
							 {'forbid_login', 0, 144000, "too much money"}),
			?WARNING_MSG("lib_player, to much money,Copper:~w,Yuanbao:~w~n",[NewUser#ets_users.yuan_bao,NewUser#ets_users.copper]),
			NewUser;
		true ->
			{ok, CashData} = pt_20:write(?PP_UPDATE_SELF_INFO, 
										[NewUser#ets_users.yuan_bao,
										 NewUser#ets_users.copper,
										 NewUser#ets_users.bind_copper,
										 NewUser#ets_users.depot_copper,
										 NewUser#ets_users.bind_yuan_bao]),
			lib_send:send_to_sid(NewUser#ets_users.other_data#user_other.pid_send, CashData),
			NewUser
	end.

add_currexp_and_liftexp(CurrExp, LiftExp, PhyExp, User) ->
	if
		CurrExp >= 0 andalso LiftExp >= 0 andalso PhyExp >= 0 ->
			NewUser = add_exp(User, CurrExp),
			NewUser1 = add_life_experiences(NewUser, LiftExp),
			NewPhysical = min( NewUser1#ets_users.current_physical+PhyExp, NewUser1#ets_users.other_data#user_other.max_physical ),
			NewUser2 = NewUser1#ets_users{current_physical = NewPhysical},
			NewUser2;
		
		true ->
			User
	end.
			
add_hp_and_mp(Hp, Mp, PlayerStatus) ->
	TotalHp = PlayerStatus#ets_users.other_data#user_other.total_hp,
	TotalMp = PlayerStatus#ets_users.other_data#user_other.total_mp,
	CurrentHp = PlayerStatus#ets_users.current_hp,
	CurrentMp = PlayerStatus#ets_users.current_mp,
	NewCurrentHp = min(TotalHp + PlayerStatus#ets_users.other_data#user_other.tmp_totalhp, CurrentHp + Hp),
	NewCurrentMp = min( TotalMp + PlayerStatus#ets_users.other_data#user_other.tmp_totalmp, CurrentMp + Mp),
	NewPlayerStatus = PlayerStatus#ets_users{current_hp = NewCurrentHp,
											 current_mp =NewCurrentMp},
 	NewPlayerStatus.

%自己扣自己的血蓝
reduce_hp_and_mp_by_self(PlayerStatus,HP,MP) ->
	CurrentHP = max(0, PlayerStatus#ets_users.current_hp - HP),
	CurrentMP = max(0, PlayerStatus#ets_users.current_mp - MP),
	PlayerStatus#ets_users{current_hp = CurrentHP,
					   current_mp = CurrentMP}.

%% 扣hp mp AttPid 攻击者pid,攻击者id,AttName 攻击者名字
reduce_hp_and_mp(PlayerStatus, Hp, Mp, Type, AttPid, AttID, AttName, NowState, StandupDate) ->
	CurrentHp = PlayerStatus#ets_users.current_hp - Hp,
	CurrentMp = PlayerStatus#ets_users.current_mp - Mp,	
	if CurrentHp < 1 orelse NowState =:= ?ELEMENT_STATE_DEAD ->	%% 玩家死亡，
		   %%运镖通知
		   lib_task:check_dead(PlayerStatus, AttPid, AttName, Type),
		   if Type =:= ?ELEMENT_PLAYER orelse Type =:=?ELEMENT_PET ->
					%% 被人打死
					case PlayerStatus#ets_users.other_data#user_other.map_template_id of
						?DUPLICATE_PVP1_MAP_ID ->
							gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {player_dead, PlayerStatus#ets_users.id}),
							OtherData0 = PlayerStatus#ets_users.other_data#user_other{last_fight_target_time = misc_timer:now_seconds()};
						_ ->
							DeadMsg = ?GET_TRAN(?_LANG_PK_DEAD, [AttName]),
							lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, ?EVENT, ?None, ?ORANGE, DeadMsg]),
							%通知增加pk值
							remove_pk_dic_info_all(),
							OtherData0 = change_pk_time(PlayerStatus,?PK_Target),
							gen_server:cast(AttPid,{kill_player,
											PlayerStatus#ets_users.other_data#user_other.pid,
											PlayerStatus#ets_users.id,
											PlayerStatus#ets_users.level,
											PlayerStatus#ets_users.club_id,
											PlayerStatus#ets_users.pk_value,
											PlayerStatus#ets_users.nick_name})
					end;
				true ->
					case PlayerStatus#ets_users.other_data#user_other.map_template_id of
						?DUPLICATE_PVP1_MAP_ID ->
							gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_dungeon, {player_dead, PlayerStatus#ets_users.id});
						_ ->
							ok
					end,
					OtherData0 = PlayerStatus#ets_users.other_data#user_other{last_fight_target_time = misc_timer:now_seconds()}
			end,
		   notice_unlock(PlayerStatus#ets_users.other_data#user_other.pid_map,
						 PlayerStatus#ets_users.other_data#user_other.pid_locked_monster,
						 self()),
		  
		   OtherData = OtherData0#user_other{
%% 											 buff_list = [],
											 pid_locked_monster=[]},
		   NewPlayerStatus = PlayerStatus#ets_users{
						   current_hp = 0,
						   current_mp = CurrentMp,
						   other_data = OtherData
						   },
		   dead_event(NewPlayerStatus);	%% 在里面处理player_now_state
	   true ->
		   case Type of
				?ELEMENT_PLAYER ->
					lib_task:check_attacked(PlayerStatus#ets_users.id),
					set_pk_dic(PlayerStatus#ets_users.id,[{AttID}],1),
					OtherData0 = change_pk_time(PlayerStatus,?PK_Target);
				_ ->
					OtherData0 = PlayerStatus#ets_users.other_data#user_other{last_fight_target_time = misc_timer:now_seconds()}
			end,
		   	OtherData = OtherData0#user_other{player_now_state = NowState, 
											  player_standup_date = StandupDate},
		  	PlayerStatus#ets_users{
						   current_hp = CurrentHp,
						   current_mp = CurrentMp,
						   other_data = OtherData
						   }
	end.


%% 玩家死亡触发
dead_event(PlayerStatus) ->
	NowTime = misc_timer:now_seconds(),
	
	%% 更新队伍信息
	lib_team:update_team_hpmp(PlayerStatus),
	{ok, NewPlayerStatus} = reduce_experiences(PlayerStatus),
	%%更新身上的标志位
	Other_Data =NewPlayerStatus#ets_users.other_data#user_other{
																player_now_state = ?ELEMENT_STATE_DEAD,
																relive_time = NowTime},
	NewPlayerStatus2 = NewPlayerStatus#ets_users{other_data = Other_Data},
	%%广播通知
	{ok, DeadBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE,[NewPlayerStatus2]),
	mod_map_agent:send_to_area_scene(NewPlayerStatus2#ets_users.current_map_id,
							NewPlayerStatus2#ets_users.pos_x,
							NewPlayerStatus2#ets_users.pos_y,
							DeadBin),
	NewPlayerStatus2.


%% 杀死玩家处理
kill_player(PlayerPKValue) ->
	min(?PK_MAX_VALUE, PlayerPKValue + ?PK_KILL_ONE_VALUE).

change_pk_time(PlayerStatus, Mode) ->	%false表示同阵营 false表示白名,被击用不上
	OtherData = PlayerStatus#ets_users.other_data,
	case Mode =:= ?PK_Actor of 
		true ->
			OtherData#user_other{
								 	last_pk_actor_time = misc_timer:now_seconds()
								 };
		_ ->
			OtherData#user_other{
								 	last_pk_target_time = misc_timer:now_seconds()
								 }
	end.

%%=======================pk================================================

%%主动变更pk模式
%%修改，只有切换到和平模式需要判断时间
%%修改，红名不可切换到和平模式
change_pk_mode(PlayerStatus,Mode) ->
	NowTime = misc_timer:now_seconds(),
	if Mode =:= ?PKMode_PEACE 
	   andalso PlayerStatus#ets_users.level > ?PK_LEVEL andalso PlayerStatus#ets_users.pk_value < ?USER_PK_VALUE ->
		   case check_pk_mode_change_date(PlayerStatus#ets_users.pk_mode_change_date,NowTime) of
			   true ->
				   BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{pk_mode = Mode},
				   Other = PlayerStatus#ets_users.other_data#user_other{battle_info = BattleInfo},
				   PlayerStatus#ets_users{pk_mode = Mode,pk_mode_change_date = NowTime, other_data=Other};
			   _ ->
				   PlayerStatus
		   end;
	   PlayerStatus#ets_users.level > ?PK_LEVEL ->
		   CheckMode =
			   case Mode of
				   ?PKMode_TEAM ->PlayerStatus#ets_users.other_data#user_other.pid_team =/= undefined;
				   ?PKMode_CLUB ->PlayerStatus#ets_users.club_id > 0;
				   ?PKMode_CAMP ->PlayerStatus#ets_users.camp > 0;
				   ?PKMode_FREEDOM -> true;
				   ?PKMode_GOODNESS -> true;
				   _ -> false
			   end,
		   if CheckMode ->
				  BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{pk_mode = Mode},
				  Other = PlayerStatus#ets_users.other_data#user_other{battle_info = BattleInfo},
				  PlayerStatus#ets_users{pk_mode = Mode,pk_mode_change_date = NowTime, other_data=Other};
			  true ->
				  PlayerStatus
		   end;
	   true ->
		   PlayerStatus
	end.

check_pk_mode_change_date(Time, NowTime) ->
	CheckTime = NowTime - Time,
	if CheckTime > ?PK_Mode_Change_Time -> %大于
			true;
		true ->
			false
	end.

%% 被动变更PK模式
%% 目前处理原本是 队伍/帮会/阵营的pk模式
change_pk_mode_auto(PlayerStatus) ->
	if 
		PlayerStatus#ets_users.pk_value > ?USER_PK_VALUE orelse PlayerStatus#ets_users.pk_mode >= ?PKMode_FREEDOM ->
		   BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{pk_mode = ?PKMode_GOODNESS},
		   Other = PlayerStatus#ets_users.other_data#user_other{battle_info = BattleInfo},
		   PlayerStatus#ets_users{pk_mode = ?PKMode_GOODNESS, other_data=Other};
		true ->
		   BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{pk_mode = ?PKMode_PEACE},
		   Other = PlayerStatus#ets_users.other_data#user_other{battle_info = BattleInfo},
		   PlayerStatus#ets_users{pk_mode = ?PKMode_PEACE, other_data=Other}
	end.
		
pvp_end(ActiveId, Result, Award, Status) ->
	case ActiveId of
		?PVP1_ACTIVE_ID ->
			{NewAward,Exploit} = pvp1_award(Award,[],Status#ets_users.other_data#user_other.exploit_info),
			%?DEBUG("pvp_end(:~p",[{Result,NewAward,Exploit}]),
			NewOther = Status#ets_users.other_data#user_other{active_id = 0, exploit_info = Exploit},
			{ok,Bin1} = pt_23:write(?PP_PVP_EXPLOIT_INFO, [Exploit]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin1);
		_ ->
			NewAward = Award,
			NewOther = Status#ets_users.other_data#user_other{active_id = 0}
	end,
	NewStatus = Status#ets_users{other_data = NewOther},
	{ok, Bin} = pt_23:write(?PP_PVP_END, [ActiveId, Result, NewAward]),
	lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, Bin),
	NewStatus.

pvp1_award([],Award,Exploit) ->
	{Award,Exploit};
pvp1_award([H|L],Award,Exploit) ->
	{_Type, Value} = H,
	case lib_exploit:pvp1_add_exploit(Exploit, Value) of
		{false} ->
			{Award,Exploit};
		{ok,NewExploit} ->
			pvp1_award(L,Award++[H],NewExploit)
	end.

update_pvp_first(BuffId, Camp, Status) ->
	BattleInfo = Status#ets_users.other_data#user_other.battle_info#battle_info{camp = Camp},
	%?DEBUG("update_pvp_first:~p",[{BuffId, Camp}]),
	if	BuffId > 0 ->
			if BuffId =:= ?BUFF_FIRST_INACTIVE orelse BuffId =:= ?BUFF_FIRST_OUTACTIVE ->
				NewOther = Status#ets_users.other_data#user_other{war_state = Camp, battle_info = BattleInfo,buff_titleId = 1};
			BuffId =:= ?GUILD_FIGHT_BUFF ->
				NewOther = Status#ets_users.other_data#user_other{war_state = Camp, battle_info = BattleInfo,buff_titleId = 2};
			true ->
				NewOther = Status#ets_users.other_data#user_other{war_state = Camp, battle_info = BattleInfo,buff_titleId = 0}
			end,
			gen_server:cast(self(), {'add_player_buff',BuffId}),
			NewPlayerStatus = Status;
		true ->
			NewOther = Status#ets_users.other_data#user_other{war_state = Camp, battle_info = BattleInfo, buff_titleId = 0},
			NewPlayerStatus = Status
	end,
	%?DEBUG("tt:~p",[{NewPlayerStatus#ets_users.other_data#user_other.buff_list}]),
	NewStatus = NewPlayerStatus#ets_users{camp = Camp, other_data = NewOther},
	{ok, BinData} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewStatus]),
	mod_map_agent:send_to_area_scene(NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,NewStatus#ets_users.pos_y,BinData),
	{ok, Bin} = pt_12:write(?PP_MAP_USER_ADD, [NewStatus]),
	mod_map_agent:send_to_area_scene(NewStatus#ets_users.current_map_id,NewStatus#ets_users.pos_x,NewStatus#ets_users.pos_y,Bin),	
	NewStatus.

%=========================pk end=============================================

%%减少体力值
reduce_current_physical(PlayerState,CP) ->
	  Id = PlayerState#ets_users.id,
	  NewCP = PlayerState#ets_users.current_physical +  CP,
	  NewPlayer = PlayerState#ets_users{current_physical = NewCP},
	  db_agent:update_current_physical(Id,NewCP),
      {ok,NewPlayer}.
	  
%% 打怪增加经验值	
add_exp(PlayerStatus, FixExp, MonExp, MonsterLevel, Number) ->
	TempExp = lib_exp:get_exp(PlayerStatus#ets_users.level,MonsterLevel,FixExp,MonExp,Number),
	%?DEBUG("add_exp:~p",[{PlayerStatus#ets_users.other_data#user_other.exp_rate,PlayerStatus#ets_users.other_data#user_other.vip_exp_rate,TempExp}]),
	Exp = tool:floor(TempExp * (PlayerStatus#ets_users.other_data#user_other.exp_rate + 
								PlayerStatus#ets_users.other_data#user_other.sys_exp_rate + PlayerStatus#ets_users.other_data#user_other.vip_exp_rate)),
 	%% Exp =trunc(TempExp1 * PlayerStatus#ets_users.other_data#user_other.sys_exp_rate),
	%% Exp = TempExp1, 
	{PetID,PlayerStatus1, PetExp} = lib_pet:add_pet_exp_and_lvup(PlayerStatus,MonsterLevel,FixExp,MonExp),
	add_exp(PlayerStatus1, Exp, PetID, PetExp).

%% 添加人物和宠物经验
add_exp(PlayerStatus, Exp, PetId, PetExp) ->
	case PlayerStatus#ets_users.other_data#user_other.infant_state of
		4 ->
			PlayerStatus;
		3 ->
			add_exp1(PlayerStatus, Exp bsr 1 , PetId, PetExp);
		_ ->
			add_exp1(PlayerStatus, Exp, PetId, PetExp)
	end.

add_exp1(PlayerStatus, Exp, PetId, PetExp) ->
		

	NewExp = PlayerStatus#ets_users.exp + Exp,
	{ok,BinExp} = pt_20:write(?PP_UPDATE_SELF_EXP,[NewExp,PetId,PetExp,PlayerStatus#ets_users.life_experiences]),
	%%检查等级
	CheckLevel = lib_exp:get_level_by_exp(NewExp),
	if CheckLevel > PlayerStatus#ets_users.level -> %升级
		   %% 不能使用CALL
		   %mod_guild:corp_member_level_change(PlayerStatus#ets_users.id,CheckLevel),
		   lib_active_open_server:user_level_up(CheckLevel,PlayerStatus),
		   gen_server:cast(mod_guild:get_mod_guild_pid(),{member_level_up, PlayerStatus#ets_users.id, CheckLevel}),
		   gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item,{level_up, CheckLevel}),
		   %TopInfo = #top_info{top_type = ?TOP_TYPE_LEVEL, user_id = PlayerStatus#ets_users.id, value = CheckLevel},
		   %mod_top:update_top_info(PlayerStatus#ets_users.other_data#user_other.pid, ?DIC_TOP_LEVEL_DISCOUNT, PlayerStatus#ets_users.career, PlayerStatus#ets_users.sex, TopInfo),%%更新等级排行榜信息
		   case misc:is_process_alive(PlayerStatus#ets_users.other_data#user_other.pid_team) of
			   false ->
				   skip;
			   _ ->
				   gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_team, {'update_teammate_levelup', PlayerStatus#ets_users.id, CheckLevel})
		   end,
		   
		   PlayerStatus1 = PlayerStatus#ets_users{exp = NewExp, level = CheckLevel},
		   NewPlayerStatus = calc_properties_reload_all_send_self(PlayerStatus1),
		   {ok,BinLv} = pt_20:write(?PP_UPDATE_PLAYER_LEVEL,[
															 NewPlayerStatus#ets_users.id,
															 NewPlayerStatus#ets_users.level,
															 NewPlayerStatus#ets_users.other_data#user_other.total_hp,
															 NewPlayerStatus#ets_users.other_data#user_other.total_mp,
															 NewPlayerStatus#ets_users.current_hp,
															 NewPlayerStatus#ets_users.current_mp,
															 NewPlayerStatus#ets_users.other_data#user_other.total_life_experiences,
															 NewPlayerStatus#ets_users.life_experiences
															 ]),
		   mod_map_agent:send_to_area_scene(NewPlayerStatus#ets_users.current_map_id,NewPlayerStatus#ets_users.pos_x,NewPlayerStatus#ets_users.pos_y,BinLv),
			lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_LEVEL,{0,CheckLevel}}]);


	   true ->
		   NewPlayerStatus =PlayerStatus#ets_users{exp = NewExp}
	end, 
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, BinExp), %先等级再经验
	NewPlayerStatus.

%% 添加经验
add_exp(PlayerStatus, Exp) ->
	add_exp(PlayerStatus, Exp, 0,0).

%% 添加荣誉
add_honor(PlayerStatus, Honor) ->
	NewHonor = PlayerStatus#ets_users.honor + Honor,
	DayHonor = PlayerStatus#ets_users.day_honor + Honor,
	NewPlayerStatus = PlayerStatus#ets_users{honor=NewHonor, day_honor=DayHonor},
	{ok, DataBin} = pt_20:write(?PP_UPDATE_SELF_HONOR, NewPlayerStatus),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, DataBin),
	NewPlayerStatus.

%%添加副本通关奖励
add_duplicate_award(AwardList, PlayerStatus) ->
	{Yuanbao,BYuanbao,Copper,BCopper,Exp,Life} = add_duplicate_award1(AwardList, {0,0,0,0,0,0}),
	%Info = {Yuanbao,BYuanbao,Copper,BCopper,Exp,Life},
	if	Yuanbao > 0 
		orelse BYuanbao > 0 orelse Copper > 0 orelse BCopper > 0 ->
			NewPlayerStatus1 = add_cash_and_send(PlayerStatus, Yuanbao, BYuanbao, Copper, BCopper,
													{?GAIN_MONEY_DUPLICATE_AWARD,PlayerStatus#ets_users.other_data#user_other.map_template_id,1});
		true ->
			NewPlayerStatus1 = PlayerStatus
	end,
	NewPlayerStatus2 = add_exp(NewPlayerStatus1, Exp),
	NewPlayerStatus = add_life_experiences(NewPlayerStatus2, Life),
	NewPlayerStatus.

add_duplicate_award1([], Awards) ->
	Awards;
add_duplicate_award1([{Id,Value}|List], Awards) ->
	{Yuanbao,BYuanbao,Copper,BCopper,Exp,Life} = Awards,
	case Id of
		?CURRENCY_TYPE_YUANBO ->	
			NewAwards = {Yuanbao + Value,BYuanbao,Copper,BCopper,Exp,Life};
		?CURRENCY_TYPE_BIND_YUANBAO ->
			NewAwards = {Yuanbao,BYuanbao + Value,Copper,BCopper,Exp,Life};
		?CURRENCY_TYPE_COPPER ->
			NewAwards = {Yuanbao,BYuanbao,Copper + Value,BCopper,Exp,Life};
		?CURRENCY_TYPE_BIND_COPPER ->
			NewAwards = {Yuanbao,BYuanbao,Copper,BCopper + Value,Exp,Life};
		?CURRENCY_TYPE_EXP ->
			NewAwards = {Yuanbao,BYuanbao,Copper,BCopper,Exp + Value,Life};
		?CURRENCY_TYPE_LIFE ->
			NewAwards = {Yuanbao,BYuanbao,Copper,BCopper,Exp,Life + Value};
		_ ->
			NewAwards = Awards
	end,
	add_duplicate_award1(List, NewAwards).
%% 上线重连副本
login_in_duplicate(PlayerStatus, Pid) ->
	case gen_server:call(Pid, {'login_in_duplicate', {PlayerStatus#ets_users.id,PlayerStatus#ets_users.other_data#user_other.pid,
 PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerStatus#ets_users.vip_id, PlayerStatus#ets_users.sex}}) of
		{false} ->
			false;
		{Map_Pid, OnlyId, Duplicate_id, Map_Template_id} when is_pid(Map_Pid) ->
			%?DEBUG("login_in_duplicate:~p",[{Map_Pid, Duplicate_id, Map_Template_id,Pid}]),
			BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{camp = PlayerStatus#ets_users.camp},
			Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined,
																map_template_id = Map_Template_id,
																war_state = PlayerStatus#ets_users.camp,
																battle_info = BattleInfo,
																pid_map = Map_Pid,
														 		pid_dungeon=Pid,
														 		duplicate_id = Duplicate_id},
			NewStatus = PlayerStatus#ets_users{current_map_id = OnlyId, other_data=Other},			
			calc_speed(NewStatus, 0);
		_ ->
			false
	end.

%% 返回到旧的地图坐标
return_to_old_map(PlayerStatus) ->
	{CurrentMapId, PosX, PosY} = 
		if 
			PlayerStatus#ets_users.old_map_id =/= 0 andalso PlayerStatus#ets_users.old_map_id < 9999 ->
				WarState = lib_king_fight:is_king_war_time(),
				if PlayerStatus#ets_users.old_map_id =:= 1033 andalso WarState =:= true ->
						{1021,2540,3540};
					true ->
						{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y}
				end;
			PlayerStatus#ets_users.level < 20 ->
				lib_map:return_career_born(PlayerStatus#ets_users.career);
			true ->
				?MAIN_CITY
		end,
		BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{camp = 0},
		Other = PlayerStatus#ets_users.other_data#user_other{
														 war_state = 0,
														 battle_info = BattleInfo,
														 pid_map = undefined,
														 walk_path_bin=undefined,
														 map_template_id = CurrentMapId,
														 player_now_state = ?ELEMENT_STATE_COMMON
														},
	NewPlayerStatus = PlayerStatus#ets_users{
								current_map_id = CurrentMapId,
								camp = 0,
								pos_x = PosX,
								pos_y = PosY,
								other_data=Other
								},
	NewPlayerStatus.
%% 复活到城内 
relive_to_city(PlayerStatus) ->	
	{CurrentMapId, PosX, PosY} = 
		case PlayerStatus#ets_users.level < 20 of
			true ->
				lib_map:return_career_born(PlayerStatus#ets_users.career);
			_ ->
				?MAIN_CITY
		end,
	BattleInfo = PlayerStatus#ets_users.other_data#user_other.battle_info#battle_info{camp = 0},
	Other = PlayerStatus#ets_users.other_data#user_other{
														 war_state = 0,
														 battle_info = BattleInfo,
														 pid_map = undefined,
														 walk_path_bin=undefined,
														 map_template_id = CurrentMapId,
														 player_now_state = ?ELEMENT_STATE_COMMON
														},
	NewPlayerStatus = PlayerStatus#ets_users{
								camp = 0,
							    current_hp = PlayerStatus#ets_users.other_data#user_other.total_hp,
								current_mp = PlayerStatus#ets_users.other_data#user_other.total_mp,
								current_map_id = CurrentMapId,
								pos_x = PosX,
								pos_y = PosY,
								other_data=Other
								},
	NewPlayerStatus.


relive_by_skill(PlayerStatus, HPRate, MPRate) ->
	OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
	NewPlayerStatus = PlayerStatus#ets_users{current_hp = tool:floor(PlayerStatus#ets_users.other_data#user_other.total_hp * HPRate / 100),
										 current_mp = tool:floor(PlayerStatus#ets_users.other_data#user_other.total_mp * MPRate / 100),
										 other_data = OtherData},
	{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.current_hp, NewPlayerStatus#ets_users.current_mp]),
	mod_map_agent: send_to_area_scene(
							NewPlayerStatus#ets_users.current_map_id,
							NewPlayerStatus#ets_users.pos_x,
							NewPlayerStatus#ets_users.pos_y,
							BinData,
							undefined),
	%%lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send, 
	%%							  ?EVENT,?None,?RED,?_LANG_RELIVE_HEALTH]),
	{ok,NewPlayerStatus}.


%% type 1:回城复活，2：原地计时复活，3：原地健康复活，4：安全复活，5安全健康复活，6立即安全满血复活
relive(PlayerStatus, Type) ->
	%% 添加人物损耗
	if
		PlayerStatus#ets_users.current_hp > 0 ->
			Res = error;
		true ->
			Res = 
			case Type of
				2 ->
					relive2(PlayerStatus);
				3 ->
					relive3(PlayerStatus);
				4 ->
					relive5(PlayerStatus);
%% 				5 ->
%% 					relive6(PlayerStatus);
				6 ->
					relive7(PlayerStatus);
				7 ->
					relive8(PlayerStatus);
				_ ->
					relive1(PlayerStatus, Type)
			end
	end,
	case Res of
		{ok, NewPlayerStatus} ->
			lib_team:update_team_hpmp(NewPlayerStatus),
			{ok, NewPlayerStatus};
		_ ->
			ok
	end.
%% 	reduce_experiences(PlayerStatus).
 
%% 1:回城复活
relive1(PlayerStatus, _Type) ->
	case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
		true ->
%% 			case lib_duplicate:quit_duplicate(PlayerStatus, Type) of
%% 				{ok, NewPlayerStatus} ->										
%% 					OtherData = NewPlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
%% 					NewPlayerStatus1 = NewPlayerStatus#ets_users{
%% 																 current_hp =tool:to_integer(NewPlayerStatus#ets_users.other_data#user_other.total_hp * ?RELIVE_AT_PRESENT_DEATH_RATE),
%% 										                         current_mp =tool:to_integer(NewPlayerStatus#ets_users.other_data#user_other.total_mp * ?RELIVE_AT_PRESENT_DEATH_RATE),
%% 																 other_data = OtherData
%% 																},
%% 					{ok, NewPlayerStatus1};
%% 				_ ->
%% 					ok
%% 			end;	
			{ok, PlayerStatus};%%副本无回城复活
		_ ->
			mod_map:leave_scene(PlayerStatus#ets_users.id,
								 PlayerStatus#ets_users.other_data#user_other.pet_id,
						         PlayerStatus#ets_users.current_map_id, 
						         PlayerStatus#ets_users.other_data#user_other.pid_map, 
						         PlayerStatus#ets_users.pos_x, 
						         PlayerStatus#ets_users.pos_y,
						         PlayerStatus#ets_users.other_data#user_other.pid,
						         PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
			NewPlayerStatus1 = relive_to_city(PlayerStatus),
			NewPlayerStatus = NewPlayerStatus1#ets_users{
														current_hp =tool:to_integer(NewPlayerStatus1#ets_users.other_data#user_other.total_hp * ?RELIVE_AT_PRESENT_DEATH_RATE),
										                current_mp =tool:to_integer(NewPlayerStatus1#ets_users.other_data#user_other.total_mp * ?RELIVE_AT_PRESENT_DEATH_RATE)
														},
			{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [
										  NewPlayerStatus#ets_users.current_map_id,
										  NewPlayerStatus#ets_users.pos_x,
										  NewPlayerStatus#ets_users.pos_y]
										 ),
			lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
			{ok,NewPlayerStatus}
	end.

%%y原地复活  10秒后可用，只使用在世界地图
relive2(PlayerStatus) ->
case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
	?DUPLICATE_TYPE_WORLD ->
		NowTime=misc_timer:now_seconds(),
		MidTime=NowTime - PlayerStatus#ets_users.other_data#user_other.relive_time,
		if MidTime =< ?RELIVE_TIME ->
		   		skip;
	  		true ->
		  		relive_at_present(PlayerStatus)
		end;
	_ ->
		{ok, PlayerStatus}
end.

%%	原地健康复活,要消耗物品
relive3(PlayerStatus) ->
case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
	%MapTyep when(MapTyep =:= ?DUPLICATE_TYPE_NORMAL orelse MapTyep =:= ?DUPLICATE_TYPE_PASS orelse MapTyep =:= ?DUPLICATE_TYPE_CHALLENGE
	%				orelse MapTyep =:= ?DUPLICATE_TYPE_GUILD1 orelse MapTyep =:= ?DUPLICATE_TYPE_WORLD orelse MapTyep =:= ?DUPLICATE_TYPE_PVP2) ->
	MapTyep when 1 =:= 1 ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'use_relive_water'}) of
		{ok} ->
			NewPlayerStatus = relive4(PlayerStatus,?_LANG_RELIVE_HEALTH2),
			{ok, NewPlayerStatus};
		_ ->
			if
				PlayerStatus#ets_users.yuan_bao < ?RELIVE_YUAN_BAO ->
					%% 元宝不够
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
											   ?EVENT,?None,?RED,?_LANG_YUANBAO_NOT_ENOUGH]),
					{ok,PlayerStatus};
				true ->
					NewState = reduce_cash_and_send(PlayerStatus, ?RELIVE_YUAN_BAO, 0, 0, 0,
													{?CONSUME_YUANBAO_RELIVE,PlayerStatus#ets_users.other_data#user_other.map_template_id,1}),
%% 					lib_statistics:add_consume_yuanbao_log(NewState#ets_users.id, ?RELIVE_YUAN_BAO, 0,
%% 														   1, ?CONSUME_YUANBAO_RELIVE, misc_timer:now_seconds(), 0, 0,
%% 														   NewState#ets_users.level),
					
					NewPlayerStatus = relive4(NewState, ?_LANG_RELIVE_HEALTH), 
					{ok, NewPlayerStatus}
			end
	end;
	_ ->
		{ok, PlayerStatus}
end.

relive4(NewState,Chat) ->
	OtherData = NewState#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
	NewPlayerStatus = NewState#ets_users{current_hp = NewState#ets_users.other_data#user_other.total_hp + NewState#ets_users.other_data#user_other.tmp_totalhp,
										 current_mp = NewState#ets_users.other_data#user_other.total_mp + NewState#ets_users.other_data#user_other.tmp_totalmp,
										 other_data = OtherData},
	{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.current_hp, NewPlayerStatus#ets_users.current_mp]),
	mod_map_agent:send_to_area_scene(
	  NewPlayerStatus#ets_users.current_map_id,
	  NewPlayerStatus#ets_users.pos_x,
	  NewPlayerStatus#ets_users.pos_y,
	  BinData,
	  undefined),
	lib_chat:chat_sysmsg_pid([NewPlayerStatus#ets_users.other_data#user_other.pid_send, 
								  ?EVENT,?None,?RED,Chat]),
	NewPlayerStatus.

%%安全点复活
relive5(PlayerStatus) ->
%% 	NowTime=misc_timer:now_seconds(),
%% 	MidTime=NowTime - PlayerStatus#ets_users.other_data#user_other.relive_time,
%% 	if MidTime =< ?RELIVE_TIME ->
%% 		   skip;
%% 	   true ->
	case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
		MapTyep when(MapTyep =:= ?DUPLICATE_TYPE_NORMAL orelse MapTyep =:= ?DUPLICATE_TYPE_PASS orelse MapTyep =:= ?DUPLICATE_TYPE_OTHER
						orelse MapTyep =:= ?DUPLICATE_TYPE_GUILD1 orelse MapTyep =:= ?DUPLICATE_TYPE_CHALLENGE) ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON}, 
			NewPlayerStatus = PlayerStatus#ets_users{
										      current_hp =tool:to_integer(PlayerStatus#ets_users.other_data#user_other.total_hp * ?RELIVE_AT_PRESENT_DEATH_RATE),
										      current_mp =tool:to_integer(PlayerStatus#ets_users.other_data#user_other.total_mp * ?RELIVE_AT_PRESENT_DEATH_RATE),
											  other_data = OtherData
										     },
			relive_at_safety(NewPlayerStatus);
		_ ->
			{ok,PlayerStatus}
	end.
%%	安全点健康复活,要消耗物品 目前没有地方使用
relive6(PlayerStatus) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'use_relive_water'}) of
		{ok} ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
			NewPlayerStatus = PlayerStatus#ets_users{current_hp = PlayerStatus#ets_users.other_data#user_other.total_hp,
										 current_mp = PlayerStatus#ets_users.other_data#user_other.total_mp,
										 other_data = OtherData},
			relive_at_safety(NewPlayerStatus);
		_ ->
			if
				PlayerStatus#ets_users.yuan_bao < ?RELIVE_YUAN_BAO ->
					%% 元宝不够
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
											   ?EVENT,?None,?RED,?_LANG_YUANBAO_NOT_ENOUGH]),
					{ok,PlayerStatus};
				true ->
					NewState = reduce_cash_and_send(PlayerStatus, ?RELIVE_YUAN_BAO, 0, 0, 0,
													{?CONSUME_YUANBAO_RELIVE,PlayerStatus#ets_users.other_data#user_other.map_template_id,1}),
%% 					lib_statistics:add_consume_yuanbao_log(NewState#ets_users.id, ?RELIVE_YUAN_BAO, 0,
%% 														   1, ?CONSUME_YUANBAO_RELIVE, misc_timer:now_seconds(), 0, 0,
%% 														   NewState#ets_users.level),
					OtherData = NewState#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
					NewPlayerStatus = NewState#ets_users{current_hp = NewState#ets_users.other_data#user_other.total_hp + PlayerStatus#ets_users.other_data#user_other.tmp_totalhp,
										 current_mp = NewState#ets_users.other_data#user_other.total_mp + PlayerStatus#ets_users.other_data#user_other.tmp_totalmp,
										 other_data = OtherData},
					relive_at_safety(NewPlayerStatus)
			end
	end.
%%	安全点健康复活,信春哥，守护副本使用(藏宝副本零时使用)
relive7(PlayerStatus) ->
	case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
		MapTyep when(MapTyep =:= ?DUPLICATE_TYPE_GUARD orelse MapTyep =:= ?DUPLICATE_TYPE_MONEY orelse MapTyep =:= ?DUPLICATE_TYPE_GUILD1
						orelse MapTyep =:= ?DUPLICATE_TYPE_TREASURE orelse MapTyep =:= ?DUPLICATE_TYPE_PVP1) ->
			%?DEBUG("lib_map:get_map_type:~p",[PlayerStatus#ets_users.current_map_id]),
			OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
			NewPlayerStatus = PlayerStatus#ets_users{current_hp = PlayerStatus#ets_users.other_data#user_other.total_hp + PlayerStatus#ets_users.other_data#user_other.tmp_totalhp ,
										 current_mp = PlayerStatus#ets_users.other_data#user_other.total_mp + PlayerStatus#ets_users.other_data#user_other.tmp_totalmp,
										 other_data = OtherData},
			relive_at_safety(NewPlayerStatus);
		_type ->
			?DEBUG("lib_map:get_map_type:~p",[_type]),
			{ok,PlayerStatus}
	end.

relive8(PlayerStatus) ->
	case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
		?DUPLICATE_TYPE_PVP2 ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
			NewPlayerStatus = PlayerStatus#ets_users{current_hp = PlayerStatus#ets_users.other_data#user_other.total_hp + PlayerStatus#ets_users.other_data#user_other.tmp_totalhp,
										 			current_mp = PlayerStatus#ets_users.other_data#user_other.total_mp + PlayerStatus#ets_users.other_data#user_other.tmp_totalmp,
													other_data = OtherData},
			case PlayerStatus#ets_users.current_map_id of
				?PVP_FIRST_MAP_ID ->
					relive_at_war_pos(?PVP_FIRST_MAP_ID, NewPlayerStatus);
				?RESOURCE_WAR_MAP_ID ->
					relive_at_war_pos(?RESOURCE_WAR_MAP_ID, NewPlayerStatus);
				?ACTIVE_MONSTER_MAP_ID ->
					relive_at_war_pos(?ACTIVE_MONSTER_MAP_ID, NewPlayerStatus);
				?ACTIVE_GUILD_FIGHT_MAP_ID ->
					relive_at_war_pos(?ACTIVE_GUILD_FIGHT_MAP_ID, NewPlayerStatus);
				?ACTIVE_KING_FIGHT_MAP_ID ->
					relive_at_war_pos(?ACTIVE_KING_FIGHT_MAP_ID, NewPlayerStatus)
			end;		
		_type ->
			?DEBUG("lib_map:get_map_type:~p",[_type]),
			{ok,PlayerStatus}
	end.


%%使用回城卷
return_to_city(PlayerStatus) ->
	mod_map:leave_scene(PlayerStatus#ets_users.id, 
						PlayerStatus#ets_users.other_data#user_other.pet_id,
						PlayerStatus#ets_users.current_map_id, 
						PlayerStatus#ets_users.other_data#user_other.pid_map, 
						PlayerStatus#ets_users.pos_x, 
						PlayerStatus#ets_users.pos_y,
						PlayerStatus#ets_users.other_data#user_other.pid,
						PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),

	NewPlayerStatus = return_to_city_1(PlayerStatus),
	
	{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewPlayerStatus#ets_users.current_map_id,
										          NewPlayerStatus#ets_users.pos_x,
										          NewPlayerStatus#ets_users.pos_y]),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
	{ok, NewPlayerStatus}.

return_to_city_1(PlayerStatus) ->
	case data_agent:map_template_get(PlayerStatus#ets_users.current_map_id) of
		[] ->
			{CurrentMapId, PosX, PosY} = lib_map:return_career_born(PlayerStatus#ets_users.career);
		MapTemp ->
			 [{CurrentMapId, PosX, PosY}] = tool:split_string_to_intlist(MapTemp#ets_map_template.return_map)
	end,
	Other = PlayerStatus#ets_users.other_data#user_other{
														 walk_path_bin=undefined,
														 pid_map = undefined
														 },
	NewPlayerStatus = PlayerStatus#ets_users{							 	 
							    current_map_id = CurrentMapId,
								pos_x = PosX,
								pos_y = PosY,
								other_data=Other
								},
	NewPlayerStatus.


%%随机传送鞋
random_to_transfer(PlayerStatus) ->
	NewPlayerStatus = random_to_transfer_1(PlayerStatus),
	
	%%更新随机传送的位置
	{ok, EnterData} = pt_12:write(?PP_PLAYER_PLACE_UPDATE, [NewPlayerStatus#ets_users.id,
															NewPlayerStatus#ets_users.pos_x,
															NewPlayerStatus#ets_users.pos_y]),
	
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
	{ok, NewPlayerStatus}.
	

random_to_transfer_1(PlayerStatus) ->
	MapInfo = lib_map:get_base_scene_info(PlayerStatus#ets_users.current_map_id),
	%%RandomList = tool:split_string_to_intlist(MapInfo#ets_map_template.rand_point),
	RandomList =  MapInfo#ets_map_template.rand_point,
%%	F = fun({X, Y}, [{Pos_X, Pos_Y}, List]) ->
%%				if
%%					abs(Pos_X - X) > 10 andalso abs(Pos_Y - Y) > 10 ->
%%						[{Pos_X, Pos_Y}, [{X, Y} | List]];
%%					true ->
%%						List
%%				end
%%		end,
%%	[_, NewRandomList] = lists:foldl(F, [{PlayerStatus#ets_users.pos_x, PlayerStatus#ets_users.pos_y}, []], RandomList),
%%	RandomNum = util:rand(1, erlang:length(NewRandomList)),
%%	{New_X, New_Y} = lists:nth(RandomNum, NewRandomList),
	
	if	
		length(RandomList) > 0 ->
			RandomNum = util:rand(1, erlang:length(RandomList)),
			{New_X, New_Y} = lists:nth(RandomNum, RandomList),
	
			Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined},
			NewPlayerStatus = PlayerStatus#ets_users{							 	 							    
								pos_x = New_X,
								pos_y = New_Y,
								other_data=Other
								},
			NewPlayerStatus;
		true ->
			PlayerStatus
	end.
	
%%使用飞天鞋
use_transfer_shoe(PlayerStatus, MapId, Pos_X, PosY) ->
	mod_map:leave_scene(PlayerStatus#ets_users.id, 
						PlayerStatus#ets_users.other_data#user_other.pet_id,
						PlayerStatus#ets_users.current_map_id, 
						PlayerStatus#ets_users.other_data#user_other.pid_map, 
						PlayerStatus#ets_users.pos_x, 
						PlayerStatus#ets_users.pos_y,
						PlayerStatus#ets_users.other_data#user_other.pid,
						PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
	
	NewPlayerStatus = use_transfer_shoe_1(PlayerStatus, MapId, Pos_X, PosY),
	
	{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [lib_map:get_map_id(NewPlayerStatus#ets_users.current_map_id),
										          NewPlayerStatus#ets_users.pos_x,
										          NewPlayerStatus#ets_users.pos_y]),
	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
	{ok, NewPlayerStatus}.
	
use_transfer_shoe_1(PlayerStatus, MapId, Pos_X, PosY) ->
	Other = PlayerStatus#ets_users.other_data#user_other{
														 map_template_id = lib_map:get_map_id(MapId),
														 walk_path_bin=undefined,
														 pid_map = undefined
														},
	NewPlayerStatus = PlayerStatus#ets_users{	
								current_map_id = MapId,			 						 	 							    
								pos_x = Pos_X,
								pos_y = PosY,
								other_data=Other
								},
	NewPlayerStatus.	
														   
player_break_away(PlayerStatus) ->
	use_transfer_shoe(PlayerStatus,1021,2540,3540).

%%人物主动通知解除锁定状态（下线，死亡等）
notice_unlock(MapPid,LockIDs,SelfPid) ->
	gen_server:cast(MapPid,{hartedremove,LockIDs,SelfPid}).


%%原地复活或等待救援 ,回复玩家5%的生命和法力值
relive_at_present(PlayerStatus) ->
	OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON}, 
	NewPlayerStatus = PlayerStatus#ets_users{
										      current_hp =tool:to_integer(PlayerStatus#ets_users.other_data#user_other.total_hp * ?RELIVE_AT_PRESENT_DEATH_RATE),
										      current_mp =tool:to_integer(PlayerStatus#ets_users.other_data#user_other.total_mp * ?RELIVE_AT_PRESENT_DEATH_RATE),
											  other_data = OtherData
										     },
	{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [NewPlayerStatus#ets_users.id, NewPlayerStatus#ets_users.current_hp, NewPlayerStatus#ets_users.current_mp]),
    mod_map_agent: send_to_area_scene(
							           NewPlayerStatus#ets_users.current_map_id,
							           NewPlayerStatus#ets_users.pos_x,
							           NewPlayerStatus#ets_users.pos_y,
					                   BinData,
				     	               undefined
									   ),
	{ok,NewPlayerStatus}.

relive_at_war_pos(Type, PlayerStatus) ->
	Relive_Pos =
	if Type =:= ?PVP_FIRST_MAP_ID ->
			lib_pvp_first:get_relive_pos();
		Type =:= ?RESOURCE_WAR_MAP_ID ->
			lib_resource_war:get_relive_pos(PlayerStatus#ets_users.camp);
		Type =:= ?ACTIVE_MONSTER_MAP_ID ->
			lib_active_monster:get_relive_pos();
		Type =:= ?ACTIVE_GUILD_FIGHT_MAP_ID ->
			lib_guild_fight:get_relive_pos();
		Type =:= ?ACTIVE_KING_FIGHT_MAP_ID ->
			lib_king_fight:get_relive_pos(PlayerStatus#ets_users.camp);			
		true ->
			{}
	end,
	case Relive_Pos of 
		{} ->
			 {ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [PlayerStatus#ets_users.id, PlayerStatus#ets_users.current_hp, PlayerStatus#ets_users.current_mp]),
   			mod_map_agent: send_to_area_scene(
							           PlayerStatus#ets_users.current_map_id,
							           PlayerStatus#ets_users.pos_x,
							           PlayerStatus#ets_users.pos_y,
					                   BinData,
				     	               undefined
									   ),
			NewPlayerStatus = PlayerStatus;
		{PosX, PosY} -> 
			{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(PlayerStatus, PlayerStatus#ets_users.current_map_id, PosX, PosY)
	end,
	{ok,NewPlayerStatus}.


%% relive_at_war_pos1(PlayerStatus) ->
%% 	case lib_pvp_first:get_relive_pos() of
%% 		{} ->
%% 			{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [PlayerStatus#ets_users.id, PlayerStatus#ets_users.current_hp, PlayerStatus#ets_users.current_mp]),
%%    			mod_map_agent: send_to_area_scene(
%% 							           PlayerStatus#ets_users.current_map_id,
%% 							           PlayerStatus#ets_users.pos_x,
%% 							           PlayerStatus#ets_users.pos_y,
%% 					                   BinData,
%% 				     	               undefined
%% 									   ),
%% 			NewPlayerStatus = PlayerStatus;
%% 		{PosX,PosY} ->
%% 			{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(PlayerStatus, PlayerStatus#ets_users.current_map_id, PosX, PosY)
%% 	end,
%% 	{ok,NewPlayerStatus}.
%% 
%% relive_at_war_pos(PlayerStatus) ->
%% 	case lib_resource_war:get_relive_pos(PlayerStatus#ets_users.camp) of
%% 		{} ->
%% 			{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [PlayerStatus#ets_users.id, PlayerStatus#ets_users.current_hp, PlayerStatus#ets_users.current_mp]),
%%    			mod_map_agent: send_to_area_scene(
%% 							           PlayerStatus#ets_users.current_map_id,
%% 							           PlayerStatus#ets_users.pos_x,
%% 							           PlayerStatus#ets_users.pos_y,
%% 					                   BinData,
%% 				     	               undefined
%% 									   ),
%% 			NewPlayerStatus = PlayerStatus;
%% 		{PosX,PosY} ->
%% 			{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(PlayerStatus, PlayerStatus#ets_users.current_map_id, PosX, PosY)
%% 	end,
%% 	{ok,NewPlayerStatus}.
%% 
%% relive_at_war_pos2(PlayerStatus) ->
%% 	case lib_active_monster:get_relive_pos() of
%% 		{} ->
%% 			{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [PlayerStatus#ets_users.id, PlayerStatus#ets_users.current_hp, PlayerStatus#ets_users.current_mp]),
%%    			mod_map_agent: send_to_area_scene(
%% 							           PlayerStatus#ets_users.current_map_id,
%% 							           PlayerStatus#ets_users.pos_x,
%% 							           PlayerStatus#ets_users.pos_y,
%% 					                   BinData,
%% 				     	               undefined
%% 									   ),
%% 			NewPlayerStatus = PlayerStatus;
%% 		{PosX,PosY} ->
%% 			{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(PlayerStatus, PlayerStatus#ets_users.current_map_id, PosX, PosY)
%% 	end,
%% 	{ok,NewPlayerStatus}.

relive_with_dup_fresh(PlayerStatus) ->
	{PosX,PosY} = case lib_map:get_map_type(PlayerStatus#ets_users.current_map_id) of
		?DUPLICATE_TYPE_PVP2 ->
			case lib_resource_war:get_relive_pos(PlayerStatus#ets_users.camp) of
				{} ->
					{PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y};
				{Pos_x, Pos_y} ->
					{Pos_x, Pos_y}
			end;
		_ ->
			MapId = lib_map:get_map_id(PlayerStatus#ets_users.current_map_id),			
			case lib_map:get_map_default_point(MapId) of
				[{Pos_x, Pos_y}]->
					{Pos_x, Pos_y};
				[] ->
					{PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y}
			end
	end,
	OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON}, 
	NewPlayerStatus = PlayerStatus#ets_users{
										      current_hp =tool:to_integer(PlayerStatus#ets_users.other_data#user_other.total_hp * ?RELIVE_AT_PRESENT_DEATH_RATE),
										      current_mp =tool:to_integer(PlayerStatus#ets_users.other_data#user_other.total_mp * ?RELIVE_AT_PRESENT_DEATH_RATE),
											  pos_x = PosX,
							           		  pos_y = PosY,
											  other_data = OtherData
										     },
	NewPlayerStatus.

%%安全区复活玩家HP在调用前处理
relive_at_safety(PlayerStatus) ->
	MapId = lib_map:get_map_id(PlayerStatus#ets_users.current_map_id),
	case lib_map:get_map_default_point(MapId) of
		[{Pos_x, Pos_y}]->
			{ok, NewPlayerStatus} = lib_player:use_transfer_shoe(PlayerStatus, PlayerStatus#ets_users.current_map_id, Pos_x, Pos_y);
		[] ->
			{ok, BinData} = pt_12:write(?PP_PLAYER_RELIVE, [PlayerStatus#ets_users.id, PlayerStatus#ets_users.current_hp, PlayerStatus#ets_users.current_mp]),
   			mod_map_agent: send_to_area_scene(
							           PlayerStatus#ets_users.current_map_id,
							           PlayerStatus#ets_users.pos_x,
							           PlayerStatus#ets_users.pos_y,
					                   BinData,
				     	               undefined
									   ),
			NewPlayerStatus = PlayerStatus
	end,
	{ok,NewPlayerStatus}.

%% 计算人物属性
calc_properties_send_self(PlayerStatus) ->
	NewPlayerStatus = calc_properties(PlayerStatus),
	{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
	NewPlayerStatus.

%% 计算人物属性 并广播身边的玩家
calc_properties_send_self_area(PlayerStatus) ->
	NewPlayerStatus = calc_properties_send_self(PlayerStatus),

	{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [NewPlayerStatus]),
	mod_map_agent:send_to_area_scene(
									NewPlayerStatus#ets_users.current_map_id,
									NewPlayerStatus#ets_users.pos_x,
									NewPlayerStatus#ets_users.pos_y,
									PlayerScenBin),

	NewPlayerStatus.

%% 计算人物属性，回复血蓝，再发送包
calc_properties_reload_all_send_self(PlayerStatus) ->
	NewPlayerStatus = calc_properties(PlayerStatus),
	NewPlayerStatus1 = NewPlayerStatus#ets_users{
													 current_hp = (NewPlayerStatus#ets_users.other_data#user_other.total_hp),
													 current_mp = (NewPlayerStatus#ets_users.other_data#user_other.total_mp)},	
	{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, NewPlayerStatus1),
	lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin),
	NewPlayerStatus1.


calc_properties(PlayerStatus) ->
	case gen_server:call(PlayerStatus#ets_users.other_data#user_other.pid_item, {'get_equip_properties',PlayerStatus}) of
		[ok ,Record, StyleBin,  Mounts] ->
			Pet = lib_pet:get_fight_pet(),
			calc_properties(PlayerStatus, Record, StyleBin, Mounts,Pet);
		_ ->
			PlayerStatus
	end.


calc_properties(PlayerStatus, Record, StyleBin, Mounts,Pet) ->
	case data_agent:user_attr_template_get({PlayerStatus#ets_users.career, PlayerStatus#ets_users.level}) of
		[] ->
			NewPlayerStatus = PlayerStatus;
		Attr ->
			User_title_attr = get_user_title_attr_by_id(PlayerStatus#ets_users.title),	
			User_achieves_TotalHP = lib_target:get_user_achieves_attr_by_ids(PlayerStatus#ets_users.other_data#user_other.total_achieve),
			User_yellow = lib_yellow:get_yellow_effect(PlayerStatus#ets_users.other_data#user_other.is_yellow_high_vip,PlayerStatus#ets_users.other_data#user_other.yellow_vip_level),
			OtherData = PlayerStatus#ets_users.other_data#user_other{equip_weapon_type=0, 
																	 damage = 0,
																	attack =  Attr#ets_user_attr_template.attack + User_title_attr#other_title.attack_physics + Record#other_item_template.attack + User_yellow#other_yellow_template.attack_physics,
													  				defense = Attr#ets_user_attr_template.defense + User_title_attr#other_title.defence_physics + Record#other_item_template.defense + User_yellow#other_yellow_template.defence_physics,
													  				total_hp = Attr#ets_user_attr_template.current_hp + User_title_attr#other_title.max_physical + Record#other_item_template.hp + User_achieves_TotalHP + User_yellow#other_yellow_template.hp,
													  				total_mp = Attr#ets_user_attr_template.current_mp + Record#other_item_template.mp,
													  				total_life_experiences = Attr#ets_user_attr_template.max_experiences,
																	magic_hurt = Attr#ets_user_attr_template.magic_attack + User_title_attr#other_title.attack_magic + Record#other_item_template.magic_hurt + Record#other_item_template.magichurt,
													  				mump_hurt = Attr#ets_user_attr_template.mump_attack + User_title_attr#other_title.attack_vindictive + Record#other_item_template.mump_hurt + Record#other_item_template.mumphurt,
													  				far_hurt =  Attr#ets_user_attr_template.far_attack + User_title_attr#other_title.attack_range + Record#other_item_template.far_hurt + Record#other_item_template.farhurt,
													  
													  				hit_target =Attr#ets_user_attr_template.hit_target + User_title_attr#other_title.hit_target + Record#other_item_template.hit_target,
													 				duck = Attr#ets_user_attr_template.duck + User_title_attr#other_title.duck + Record#other_item_template.duck,
													  				keep_off = Attr#ets_user_attr_template.keep_off,
													  				power_hit = Attr#ets_user_attr_template.power_hit + User_title_attr#other_title.power_hit + Record#other_item_template.power_hit,
													  				deligency = Attr#ets_user_attr_template.deligency + User_title_attr#other_title.deligency + Record#other_item_template.deligency,
													  				mump_defense = Attr#ets_user_attr_template.mump_defense + Record#other_item_template.mumpdefense,
													  				far_defense = Attr#ets_user_attr_template.far_defense + Record#other_item_template.fardefense,
													  				magic_defense = Attr#ets_user_attr_template.magic_defense + Record#other_item_template.magicdefence,
																	max_physical = Attr#ets_user_attr_template.max_physical,
													  				mump_avoid_in_hurt = Attr#ets_user_attr_template.mump_avoid_in_hurt + Record#other_item_template.mump_avoid_in_hurt,
													  				far_avoid_in_hurt = Attr#ets_user_attr_template.far_avoid_in_hurt + Record#other_item_template.far_avoid_in_hurt,
													  				magic_avoid_in_hurt = Attr#ets_user_attr_template.magic_avoid_in_hurt + Record#other_item_template.magic_avoid_in_hurt,
													  				attack_suppression = Attr#ets_user_attr_template.attack_suppression + Record#other_item_template.attack_suppression ,
													  				defense_suppression = Attr#ets_user_attr_template.defense_suppression + Record#other_item_template.defense_suppression
																	},	
			
			
			TempNewPlayerStatus0 = PlayerStatus#ets_users{
													  style_bin = StyleBin,
												      other_data = OtherData
													  },
			PlayerStatus1 = lib_veins:calc_veins_attribute(TempNewPlayerStatus0),
			
			PlayerStatus2  = calc_mounst_properties(PlayerStatus1,Mounts),
			
			PlayerStatus3  = calc_pet_properties(PlayerStatus2,Pet),
			
			NewPlayer = lib_skill:cale_pasv_skill(TempNewPlayerStatus0#ets_users.other_data#user_other.skill_list,[],PlayerStatus3),
			
			CurrentHp = case NewPlayer#ets_users.current_hp > NewPlayer#ets_users.other_data#user_other.total_hp + NewPlayer#ets_users.other_data#user_other.tmp_totalhp of
				true ->
					NewPlayer#ets_users.other_data#user_other.total_hp;
				_ ->
					NewPlayer#ets_users.current_hp
			end,
			CurrentMp = case NewPlayer#ets_users.current_mp > NewPlayer#ets_users.other_data#user_other.total_mp + NewPlayer#ets_users.other_data#user_other.tmp_totalmp of
				true ->
					NewPlayer#ets_users.other_data#user_other.total_mp;
				_ ->
					NewPlayer#ets_users.current_mp
			end,
			NewPlayerStatus = NewPlayer#ets_users{
 													  current_hp = CurrentHp,
													  current_mp = CurrentMp
														   }			
	end,
	NewPlayerStatus2_1 = calc_speed(NewPlayerStatus, NewPlayerStatus#ets_users.is_horse),
	NewPlayerStatus2 = check_career(NewPlayerStatus2_1),
	case NewPlayerStatus2#ets_users.other_data#user_other.battle_info of
		undefined ->
			BattleInfo = lib_battle:init_battle_data_player(NewPlayerStatus2);	%%计算战斗属性
		OldBattleInfo ->
			BattleInfo = lib_battle:init_battle_data_player(NewPlayerStatus2,OldBattleInfo)	%%计算战斗属性
	end,
	Other2 = NewPlayerStatus2#ets_users.other_data#user_other{battle_info = BattleInfo},
	
	
	Fight = calc_fight(Other2),
	lib_target:cast_check_target(NewPlayerStatus2#ets_users.other_data#user_other.pid_target,[{?TARGET_FIGHT,{0,Fight}}]),
	NewPlayerStatus2#ets_users{ fight = Fight, other_data = Other2}.


%% 坐骑改变后属性的变化
calc_mounst_properties(PlayerStatus,Mounts) ->
	if
		is_record(Mounts, ets_users_mounts) ->
				
			%% 白 20% 绿 40% 蓝 60% 紫 80% 橙色 100%
			Quality = case data_agent:mounts_template_get({Mounts#ets_users_mounts.template_id, Mounts#ets_users_mounts.level}) of
							[] ->
								0;
							MountsTemplateInfo ->
								MountsTemplateInfo#ets_mounts_template.quality
						end,
		
			Rate = (Quality + 1 ) * 20  / 100,
			NewAttack = PlayerStatus#ets_users.other_data#user_other.attack + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.attack+ Mounts#ets_users_mounts.other_data#mounts_other.attack2) * Rate),
			NewDefense = PlayerStatus#ets_users.other_data#user_other.defense + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.defence + Mounts#ets_users_mounts.other_data#mounts_other.defence2 )* Rate),
			NewHP = PlayerStatus#ets_users.other_data#user_other.total_hp + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.total_hp + Mounts#ets_users_mounts.other_data#mounts_other.total_hp2) * Rate),
			NewMP = PlayerStatus#ets_users.other_data#user_other.total_mp + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.total_mp + Mounts#ets_users_mounts.other_data#mounts_other.total_mp2)* Rate),
			NewMagicHurt = PlayerStatus#ets_users.other_data#user_other.magic_hurt + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.magic_attack + Mounts#ets_users_mounts.other_data#mounts_other.magic_attack2)* Rate),
			NewFarHurt = PlayerStatus#ets_users.other_data#user_other.far_hurt + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.far_attack + Mounts#ets_users_mounts.other_data#mounts_other.far_attack2)* Rate),
			NewMumpHurt = PlayerStatus#ets_users.other_data#user_other.mump_hurt + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.mump_attack + Mounts#ets_users_mounts.other_data#mounts_other.mump_attack2)* Rate),
			NewMagicDefense = PlayerStatus#ets_users.other_data#user_other.magic_defense + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.magic_defense + Mounts#ets_users_mounts.other_data#mounts_other.magic_defense2)* Rate),
			NewFarDefense = PlayerStatus#ets_users.other_data#user_other.far_defense + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.far_defense+ Mounts#ets_users_mounts.other_data#mounts_other.far_defense2) * Rate),
			NewMumpDefense = PlayerStatus#ets_users.other_data#user_other.mump_defense + util:ceil((Mounts#ets_users_mounts.other_data#mounts_other.mump_defense + Mounts#ets_users_mounts.other_data#mounts_other.mump_defense2)* Rate),
			
			
			MountsSkillList = Mounts#ets_users_mounts.other_data#mounts_other.skill_list,
			OtherData = PlayerStatus#ets_users.other_data#user_other{ 
																	 attack = NewAttack,
																	 defense = NewDefense,
																	 total_hp = NewHP,
																	 total_mp = NewMP,
																	 magic_hurt = NewMagicHurt,
																	 far_hurt = NewFarHurt,
																	 mump_hurt = NewMumpHurt,
																	 magic_defense = NewMagicDefense,
																	 far_defense = NewFarDefense,
																	 mump_defense = NewMumpDefense,
																	 horse_speed = Mounts#ets_users_mounts.other_data#mounts_other.speed,
																	 mount_skill_yaoxiao = get_yaoxiao_level(MountsSkillList) * 0.2 + 1	
																	},
			
			NewPlayerStatus0 = PlayerStatus#ets_users{other_data = OtherData},
		
			NewPlayerStatus1 = lib_skill:cale_pasv_skill(MountsSkillList,[],NewPlayerStatus0),
			NewPlayerStatus2 = check_career(NewPlayerStatus1),
			
			NewPlayerStatus2;
		true ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{ 
																	 horse_speed = 0,
																	 mount_skill_yaoxiao = 1.0		
																	},
			NewPlayerStatus0 = PlayerStatus#ets_users{other_data = OtherData , is_horse = 0},
			NewPlayerStatus0
	end.

get_yaoxiao_level(SkillList) ->
	Skill = lists:keyfind(6006, #r_use_skill.skill_group, SkillList),
	case Skill of
		false ->
			0;
		S ->
			R = S#r_use_skill.skill_lv,
			R
	end.

calc_pet_properties(PlayerStatus,Pet) ->
	case Pet of
		undefined ->
			PlayerStatus;
		_ ->
			%%计算宠物装备
			BattleInfo = lib_battle:init_battle_data_pet(PlayerStatus,Pet),
			PlayerStatus1 = lib_skill:cale_pasv_skill(Pet#ets_users_pets.other_data#pet_other.skill_list,[],PlayerStatus),
			PlayerStatus2 = check_career(PlayerStatus1),
			Other = PlayerStatus2#ets_users.other_data#user_other{pet_battle_info = BattleInfo},
			PlayerStatus2#ets_users{ other_data = Other}
	end.

calc_pet_BattleInfo(PlayerStatus,Pet) ->
	case Pet of
		undefined ->
			PlayerStatus;
		_ ->
			%%计算宠物装备
			BattleInfo = lib_battle:init_battle_data_pet(PlayerStatus,Pet),
			Other = PlayerStatus#ets_users.other_data#user_other{pet_battle_info = BattleInfo},
			PlayerStatus#ets_users{ other_data = Other}
	end.

check_career(PlayerStatus) ->
	case PlayerStatus#ets_users.career of
		?CAREER_YUEWANG ->
			OtherInfo = PlayerStatus#ets_users.other_data#user_other{far_hurt = 0,magic_hurt = 0},
			 PlayerStatus#ets_users{other_data = OtherInfo};
		?CAREER_HUAJIAN ->
			OtherInfo = PlayerStatus#ets_users.other_data#user_other{far_hurt = 0, mump_hurt = 0},
			 PlayerStatus#ets_users{other_data = OtherInfo};
		?CAREER_TANGMEN ->
			OtherInfo = PlayerStatus#ets_users.other_data#user_other{magic_hurt = 0, mump_hurt = 0},
			PlayerStatus#ets_users{other_data = OtherInfo};
		_ ->
			PlayerStatus
	end.


%% 计算战斗力
calc_fight(OtherData) ->
	Fight = OtherData#user_other.attack +
	OtherData#user_other.defense +
	OtherData#user_other.damage +
	OtherData#user_other.total_hp * ?FIGHT_CALC_RATIO_02 +
	(OtherData#user_other.magic_hurt +
	OtherData#user_other.mump_hurt + 
	OtherData#user_other.far_hurt) * ?FIGHT_CALC_RATIO_15 +
	(OtherData#user_other.magic_defense + 
	OtherData#user_other.mump_defense + 
	OtherData#user_other.far_defense) * ?FIGHT_CALC_RATIO_05 +
	(OtherData#user_other.power_hit + 
	OtherData#user_other.hit_target + 
	OtherData#user_other.duck + 
	OtherData#user_other.deligency) * ?FIGHT_CALC_RATIO_50,
	round(Fight).

%% %% 运镖计算防御值
%% calc_defense(Level, CurrHp, Defense, MumpDefense, MagicDefense, Fardefense) ->
%% 	{TCurrHp, TDefense, TMumpDefense, TMagicDefense, TFardefense} = 
%% 		if Level >= 30 andalso Level < 50 ->
%% 				{10374, 400, 128, 128, 128};
%% 		   Level >= 50 andalso Level < 70 ->
%% 				{18000, 688, 218, 218, 218};
%% 		   Level >= 70->
%% 				{24300, 925, 292, 292, 292};
%% 		   true ->
%% 			   ?WARNING_MSG("Level is not :~w", [Level]),
%% 			   {10374, 400, 128, 128, 128}
%% 		end,
%% 	RCurrHp = 
%% 		case CurrHp > TCurrHp of
%% 			true ->
%% 				CurrHp;
%% 			_ ->
%% 				TCurrHp
%% 	end,
%% 	RDefense = 
%% 		case Defense > TDefense of
%% 			true ->
%% 				Defense;
%% 			_ ->
%% 				TDefense
%% 	end,
%% 	RMumpDefense = 
%% 		case MumpDefense > TMumpDefense of
%% 			true ->
%% 				MumpDefense;
%% 			_ ->
%% 				TMumpDefense
%% 	end,
%% 	RMagicDefense = 
%% 		case MagicDefense > TMagicDefense of
%% 			true ->
%% 				MagicDefense;
%% 			_ ->
%% 				TMagicDefense
%% 	end,
%% 	RFardefense = 
%% 		case Fardefense > TFardefense of
%% 			true ->
%% 				Fardefense;
%% 			_ ->
%% 				TFardefense
%% 	end,
%% 	{RCurrHp, RCurrHp, RDefense, RMumpDefense, RMagicDefense, RFardefense}.

%% 计算速度，要分坐骑，BUFF来计算
calc_speed(Status, TempIsHorse) -> 
%% 	IsHorse = 
%% 		case lib_map:is_copy_scene(Status#ets_users.current_map_id) of
%% 			true ->
%% 				0;
%% 			false ->
%% 				TempIsHorse
%% 		end,
	<<_:64, Mount:32, _Bin/binary>> = Status#ets_users.style_bin,
	IsHorse = TempIsHorse,
	{Speed, NewIsHorse} = 
		case Status#ets_users.darts_left_time > 0 of 
			true -> %% 如果拉镖中，速度
				{?SPEED_ESCORT, 0};
			_ ->
				if
					Status#ets_users.other_data#user_other.tmp_move_speed =:= 0 ->
						case IsHorse of
							1 when Mount > 0 ->
								{ util:ceil( ?SPEED_COMMON * (1+ Status#ets_users.other_data#user_other.horse_speed /100)) , IsHorse};
							_ ->
								{?SPEED_COMMON, 0}
						end;
					true ->
						case IsHorse of
							1 when Mount > 0 ->
								{ util:ceil( ?SPEED_COMMON * (1+ (Status#ets_users.other_data#user_other.horse_speed + Status#ets_users.other_data#user_other.tmp_move_speed) /100)) ,
								   IsHorse};
							_ ->
								{ util:ceil( ?SPEED_COMMON * (1+ Status#ets_users.other_data#user_other.tmp_move_speed /100)), 0}
						end
				end
				
		end,
	NewSpeed =
		if Speed > ?SPEED_COMMON * 2 ->
			?SPEED_COMMON * 2;
			Speed < ?SPEED_ESCORT ->
			?SPEED_ESCORT;
		true ->
			Speed
		end,
	Other = Status#ets_users.other_data#user_other{speed=NewSpeed},
	Status#ets_users{
					 is_horse = NewIsHorse,
					 other_data = Other
					}.
					
%移动时通知锁定其为目标的怪物
notice_move(Status) ->
	TargetIDList = Status#ets_users.other_data#user_other.pid_locked_target_monster,
	MapPID = Status#ets_users.other_data#user_other.pid_map,
	gen_server:cast(MapPID,{targetmove,TargetIDList,Status#ets_users.pos_x,Status#ets_users.pos_y}).
	%notice_move1(TargetIDList,MapPID,Status#ets_users.pos_x,Status#ets_users.pos_y).

%notice_move1([],_MapPID,_X,_Y) -> ok;
%notice_move1(TargetIDList,MapPID,X,Y) ->
%	[H|T] = TargetIDList,
%	{TargetID} = H,
%	gen_server:cast(MapPID,{targetmove,TargetID,X,Y}),
%	notice_move1(T,MapPID,X,Y).

%扣血时通知锁定其为目标的怪物
notice_hp(Status) ->
	TargetIDList = Status#ets_users.other_data#user_other.pid_locked_target_monster,
	MapPID = Status#ets_users.other_data#user_other.pid_map,
	gen_server:cast(MapPID,{targethp,TargetIDList,Status#ets_users.current_hp}).
	%notice_hp1(TargetIDList,MapPID,Status#ets_users.current_hp).

%notice_hp1([],_MapPID,_HP) -> ok;
%notice_hp1(TargetIDList,MapPID,HP) ->
%	[H|T] = TargetIDList,
%	{TargetID} = H,
%	gen_server:cast(MapPID,{targethp,TargetID,HP}),
%	notice_hp1(T,MapPID,HP).

%% 采集到物品
collect_item(PlayerStatus, TemplateId, HP, MP, Exp, LifeExperiences, YuanBoa, BindYuanBao, BindCopper, Copper, ItemId) ->
	%% 调用任务检查，需要加入物品是否需要任务检查
	gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_task, {'collect_item', TemplateId}),
	
	PlayerStatus1 = add_hp_and_mp(HP, MP, PlayerStatus),
	PlayerStatus2 = add_exp(PlayerStatus1, Exp),
	PlayerStatus3 = add_life_experiences(PlayerStatus2, LifeExperiences),
	PlayerStatus4 = add_cash_and_send(PlayerStatus3, YuanBoa, BindYuanBao,  Copper, BindCopper,
										{?GAIN_MONEY_COLLECT, TemplateId, 1}),
	if ItemId > 0 ->
		   gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, 
						   {'collect_add_item', ItemId, 1,PlayerStatus#ets_users.nick_name});
	   true ->
		   skip
	end,
	
	PlayerStatus4.
	
%%选择称号
change_title(Title, PlayerStatus) ->
	Now = misc_timer:now_seconds(),
	if
		Title =/= 0 ->
			case lists:keyfind(Title, 1, PlayerStatus#ets_users.other_data#user_other.total_title) of 
				{I,Timer} when (Timer > Now orelse Timer =:= 0) -> 
					Res = 1,
					NewPlayerStatus = PlayerStatus#ets_users{title = Title};
				_ ->
					Res = 0,
					NewPlayerStatus = PlayerStatus
			end;
		true ->
			Res = 1,
			NewPlayerStatus = PlayerStatus#ets_users{title = 0}
	end,
	{Res, NewPlayerStatus}.

%%隐藏称号
change_hide_title(PlayerStatus, IsHide) ->
	NewPlayerStatus = PlayerStatus#ets_users{is_hide = IsHide},
	NewPlayerStatus.

%% 不在线时保存DB
add_title(UserId,TitleId) ->
	case get_player_pid(UserId) of
		[] ->
			List = get_user_total_titles(UserId),
			update_user_title(UserId,TitleId,List);
		Pid ->
			gen_server:cast(Pid,{add_title,TitleId})
	end.


check_add_title(Title, PlayerStatus) ->
	OldTile = PlayerStatus#ets_users.other_data#user_other.total_title,
	if
		OldTile =:= [] ->
			{ok, BinData} = pt_12:write(?PP_PLAYER_FIRST_TITLE, [Title]);
		true ->
			BinData = <<>>
	end,
	case update_user_title(PlayerStatus#ets_users.id, Title, OldTile) of
		{ok,NewTitles} ->
			NewOther = PlayerStatus#ets_users.other_data#user_other{total_title = NewTitles},
			NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther},
			{ok, BinTitleData} = pt_12:write(?PP_PLAYER_TITLE_INFO, [NewPlayerStatus]),
		   	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, <<BinData/binary,BinTitleData/binary>>),
			{ok, NewPlayerStatus};
		_ ->
			{ok, PlayerStatus}
	end.

update_user_title(UserId,Title,OldTile) ->
	case data_agent:user_title_template_get(Title) of
		[] ->
			error;
		Template ->
			Now = misc_timer:now_seconds(),
			T = if 
					Template#ets_title_template.effec_time > 0 ->
						Now + Template#ets_title_template.effec_time;
					true ->
						0
				end,
			NewTitles = case lists:keyfind(Title, 1, OldTile) of
						   false ->
							   [{Title , T}| OldTile];
						   _ ->
							   lists:keyreplace(Title, 1,OldTile, 
												{Title , T})
					   end,
			Str = tool:intlist_to_string(NewTitles),
			db_agent_user:update_users_title(UserId, Str),
			{ok,NewTitles}
	end.

%检查玩家上次领取节日奖励是否在同一天	
%% check_festival_award_time(PlayerStatus,Now) ->	
%% 	LastTime = PlayerStatus#ets_users.festival_award_time,
%% 	SameDay = util:is_same_date_new(Now, LastTime),
%% 	SameDay.

%更新玩家上次领取节日奖励时间
%% update_user_festival_award_time(PlayerStatus) ->
%% 	Now = misc_timer:now_seconds(),
%% 	UserID = PlayerStatus#ets_users.id,
%% 	PlayerStatus#ets_users{festival_award_time = Now}.

check_remove_title(PlayerStatus,Now) ->
	NowTime = tool:floor(Now / 1000),
	OldList = PlayerStatus#ets_users.other_data#user_other.total_title,
	F = fun({TitleId,Time},{R,R1,RemoveList,NowTime,OldList})->
				if
					Time > 0 andalso Time < NowTime ->
						NewTitles = lists:keydelete(TitleId, 1, OldList),
						NewRemoveList = [TitleId|RemoveList],
						if
							TitleId =:= PlayerStatus#ets_users.title ->
								{1,TitleId,NewRemoveList,NowTime,NewTitles};
							true ->
								{1,R1,NewRemoveList,NowTime,NewTitles}
						end;
					true ->
						{R,R1,RemoveList,NowTime,OldList}
				end
		end,
	{R ,RemoveId,RemoveList,_,NewTitles} = lists:foldl(F, {0,0,[],NowTime,OldList}, OldList),
	if
		R =:= 1 ->
			if
				RemoveId =/= 0 ->
					PlayerStatus2 = PlayerStatus#ets_users{title = 0},
				
					{ok, BinData} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [PlayerStatus2]),
					%%广播周围玩家
					mod_map_agent:send_to_area_scene(
					  PlayerStatus2#ets_users.current_map_id,
					  PlayerStatus2#ets_users.pos_x,
					  PlayerStatus2#ets_users.pos_y,
					  BinData),
%% 					{ok, ResData} = pt_20:write(?PP_PLAYER_CHOOSE_TITLE, [1,PlayerStatus2#ets_users.title,PlayerStatus2#ets_users.is_hide]),
%% 					lib_send:send_to_sid(PlayerStatus2#ets_users.other_data#user_other.pid_send, ResData),
					PlayerStatus1 = lib_player:calc_properties_send_self(PlayerStatus2);
					
				true  ->
					PlayerStatus1 = PlayerStatus
			end,
			NewOther = PlayerStatus1#ets_users.other_data#user_other{total_title = NewTitles},
			Str = tool:intlist_to_string(NewTitles),
			db_agent_user:update_users_title(PlayerStatus1#ets_users.id, Str),
			NewPlayerStatus = PlayerStatus1#ets_users{other_data = NewOther},
			{ok, BinTitleData} = pt_12:write(?PP_PLAYER_ROLE_NAME_REMOVE, [NewPlayerStatus,RemoveList]),
		   	lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BinTitleData),
			
			
			
			{ok, NewPlayerStatus};
		true ->
			{ok, PlayerStatus}
	end.



%% 捡物品
pick_drop_item(PlayerStatus, DropId) ->
	case misc:is_process_alive(PlayerStatus#ets_users.other_data#user_other.pid_team) of
		true ->
			pick_drop_item_team(PlayerStatus, DropId);
		_ ->
			pick_drop_item_self(PlayerStatus, DropId)
	end.


pick_drop_item_team(PlayerStatus, DropId) ->
%%  队伍捡取
	mod_map:get_dropitem_in_map(PlayerStatus#ets_users.other_data#user_other.pid_map,
								DropId,
								PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.pos_x,
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid_team,
								PlayerStatus#ets_users.other_data#user_other.pid_item,
								PlayerStatus#ets_users.other_data#user_other.allot_mode,
								?PID_TEAM).
	
%%个人获取	
pick_drop_item_self(PlayerStatus, DropId) ->
	mod_map:get_dropitem_in_map(PlayerStatus#ets_users.other_data#user_other.pid_map,
								DropId,
								PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.pos_x,
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid_team,
								PlayerStatus#ets_users.other_data#user_other.pid_item,
								PlayerStatus#ets_users.other_data#user_other.allot_mode,
								?PID_ITEM).

%% 添加任务奖励
add_task_award(PlayerStatus, YuanBao, BindYuanBao, Copper, BindCopper, Experience, LifeExp, Awards, TaskId) ->
	case Awards of
		[] ->
			skip;
		Other ->
			gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid_item, {'task_award', Other})
	end,
	NewPlayerStatus = lib_player:add_life_experiences(PlayerStatus, LifeExp),
	case PlayerStatus#ets_users.other_data#user_other.infant_state of
				4 ->
					{Copper1, BindCopper1} = {0,0};
				3 ->
					{Copper1, BindCopper1} = {Copper bsr 1, BindCopper bsr 1};
				_ ->
					{Copper1, BindCopper1} = {Copper, BindCopper}
	end,
	New2PlayerStatus = add_cash_and_send(NewPlayerStatus, YuanBao, BindYuanBao,  Copper1, BindCopper1,{?GAIN_MONEY_TASK_AWARD,TaskId,1}),
	
	%%添加元宝操作日志
%% 	lib_statistics:add_consume_yuanbao_log(New2PlayerStatus#ets_users.id, YuanBao, BindYuanBao, 
%% 													   0, ?CONSUME_YUANBAO_TASK_AWARD, misc_timer:now_seconds(), 0, 0,
%% 													   New2PlayerStatus#ets_users.level),
	New3PlayerStatus = lib_player:add_exp(New2PlayerStatus, Experience),
	
	New3PlayerStatus.


%%减少pk值
reduce_pk_value(PlayerStatus, ReducePkValue) ->
	PkValue = max(0, PlayerStatus#ets_users.pk_value - ReducePkValue),
	NewPlayerStatus = PlayerStatus#ets_users{pk_value=PkValue},
	NewPlayerStatus.



%% 个人pk进程字典记录控制,SelfID自己的ID，TargetID对方ID，Type 0攻击，1被击
set_pk_dic(SelfID,TargetL,Type) ->
	Time = misc_timer:now_seconds(),
	case get(?DIC_USERS_PK) of
		undefined ->
			PKL = [];
		L ->
			PKL = L
	end,	
	F = fun({ID}) -> 
				PKAttack = lists:concat([pk_attack_,SelfID,ID]),
				PKDefense = lists:concat([pk_defense_,SelfID,ID]),
				case get_pk_dic_info_and_place(PKL,PKAttack,PKDefense,1) of
					{[],-1} ->	%无记录，直接插入
						insert_pk_dic_info(PKAttack,PKDefense,Type,Time);
					{[_TmpKey,LastPKAttackTime,LastPKDefenseTime],Place} ->	%查到记录，做对比
						 if Time - LastPKAttackTime > ?PK_LEAVE_TIME 
							andalso Time - LastPKDefenseTime > ?PK_LEAVE_TIME ->	%超时
								remove_pk_dic_info(Place),
								insert_pk_dic_info(PKAttack,PKDefense,Type,Time);
							true -> %没超时，直接更新
								update_pk_dic_info(Place,Time,Type)
						 end
				end
		end,
	lists:foreach(F,TargetL).
	
%找到pk字典里对应的记录
get_pk_dic_info_and_place([],_AttackDicKey,_DefenseDicKey,_Place) -> {[],-1};
get_pk_dic_info_and_place([H|T],AttackDicKey,DefenseDicKey,Place) ->
	[TmpKey,_LastPKAttackTime,_LastPKDefenseTime] = H,
	case TmpKey of
		AttackDicKey ->
			{H,Place};	
		DefenseDicKey ->
			{H,Place};	
		_ ->
			get_pk_dic_info_and_place(T,AttackDicKey,DefenseDicKey,Place+1)
	end.

insert_pk_dic_info(PKAttack,PKDefense,Type,Time) ->
	case get(?DIC_USERS_PK) of
		undefined ->
			PKL = [];
		L ->
			PKL = L
	end,
	case Type of
		0 ->
			NPKL = [[PKAttack,Time,0]|PKL];
		1 ->
			NPKL = [[PKDefense,0,Time]|PKL]
	end,
	put(?DIC_USERS_PK,NPKL),
	ok.

remove_pk_dic_info(Place) ->
	L = get(?DIC_USERS_PK),
	ListH = lists:sublist(L, Place -1 ),
	ListT = lists:nthtail(Place, L),
	NL = ListH ++ ListT,
	put(?DIC_USERS_PK,NL),
	ok.

remove_pk_dic_info_all() ->
	put(?DIC_USERS_PK,[]),
	ok.

update_pk_dic_info(Place,Time,Type) ->
	L = get(?DIC_USERS_PK),
	[TmpString,AttackTime,DefenseTime] = lists:nth(Place,L),
	ListH = lists:sublist(L, Place -1 ),
	ListT = lists:nthtail(Place, L),
	NL = ListH ++ ListT,
	case Type of
		0 ->
			put(?DIC_USERS_PK,[[TmpString,Time,DefenseTime]|NL]);
		1 ->
			put(?DIC_USERS_PK,[[TmpString,AttackTime,Time]|NL])
	end,
	ok.
	
%pk值验证，true要加，false不用
kill_pk(SelfID,TargetID) ->
	case get(?DIC_USERS_PK) of
		undefined ->
			PKL = [];
		L ->
			PKL = L
	end,
	PKAttack = lists:concat([pk_attack_,SelfID,TargetID]),
	PKDefense = lists:concat([pk_defense_,SelfID,TargetID]),
	case get_pk_dic_info_and_place(PKL,PKAttack,PKDefense,1) of
		{[],-1} ->	%无记录，
			{false};
		{[TmpKey,_LastPKAttackTime,_LastPKDefenseTime],Place} ->	%查到记录，做对比
			remove_pk_dic_info(Place),
			if TmpKey =:= PKAttack ->
				   {true};	
			   true ->
				   {false}
			end
	end.
	
%% get_actor_pk_list([],L) -> L;
%% get_actor_pk_list([H|T],L) ->
%% 	NL = [{H#battle_object_state.id}|L],
%% 	get_actor_pk_list(T,NL).



send_to_message_to_gm(PlayerStatus, Mtype, Mtitle, Content) ->
	Now = misc_timer:now_seconds(),

    User_id = PlayerStatus#ets_users.id,
	Account_name = PlayerStatus#ets_users.user_name,
	Nick_name = PlayerStatus#ets_users.nick_name,
	Level = PlayerStatus#ets_users.level,	
	IP = PlayerStatus#ets_users.ip,
	
	if
		erlang:length(Mtitle) =:= 0 orelse erlang:length(Content) =:= 0 ->
			{0};
		true ->
			db_agent_admin:insert_complain_info(IP, User_id, Account_name, Nick_name, Level, Now, Mtype, Mtitle, Content),
			{1}
	end.

%%改变数据库读取的人物样式
change_stylebin(StyleBin) ->
	List = string:tokens(tool:to_list(StyleBin), ","),
	if length(List) =:= 8 ->
		   List2 = lists:map(fun(Info) -> tool:to_integer(Info) end, List),
		   [Cloth|List3] = List2,
		   [Weapon|List4] = List3,
		   [Mount|List5] = List4,
		   [Wing|List6] = List5,
		   [StrengthLevelng|List7] = List6,
		   [MountsStrengthLevel|List8] = List7,
		   [WeaponState|List9] = List8,
		   [ClothState|_List10] = List9,
		   <<Cloth:32, Weapon:32, Mount:32, Wing:32,StrengthLevelng:32,MountsStrengthLevel:32,WeaponState:8,ClothState:8>>;
	   true ->
		   <<0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0>>
	end.


%%自动恢复血量
auto_add_hp_mp(State, Hp, Mp) ->
	if
		State#ets_users.current_hp > 0 andalso 
							((Hp > 0 andalso State#ets_users.current_hp < State#ets_users.other_data#user_other.total_hp + State#ets_users.other_data#user_other.total_hp) orelse
							(Mp > 0 andalso State#ets_users.current_mp < State#ets_users.other_data#user_other.total_mp + State#ets_users.other_data#user_other.total_mp)) ->
			NewStatus = lib_player:add_hp_and_mp(Hp, Mp, State),
						%%消息广播   
			{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[NewStatus#ets_users.id, 0, ?ELEMENT_PLAYER,  Hp, Mp,
																	NewStatus#ets_users.current_hp, 
																	NewStatus#ets_users.current_mp]),
			mod_map_agent:send_to_area_scene(
							NewStatus#ets_users.current_map_id,
							NewStatus#ets_users.pos_x,
							NewStatus#ets_users.pos_y,
							HPMPBin,
							undefined),
%% 			ets:insert(?ETS_ONLINE, NewStatus),
			mod_map:update_player_hp_mp(NewStatus#ets_users.current_map_id, 
								NewStatus#ets_users.other_data#user_other.pid_map, 
								NewStatus#ets_users.other_data#user_other.pid,
								NewStatus#ets_users.id,
								NewStatus#ets_users.current_hp,
								NewStatus#ets_users.current_mp);
 		true ->
 			NewStatus = State
 	end,
	NewStatus.

	
%% 运镖过程更新角色信息(接镖完成)
update_escort_info(Status, FinishTime, Speed, _AwareExp, _AwareCorper, EscortState) ->
	Other_data = Status#ets_users.other_data#user_other{speed=Speed, escort_state=EscortState},
	Status1 = Status#ets_users{darts_left_time = FinishTime, 
							   other_data = Other_data},
	
%% 	Status2 = add_exp(Status1, AwareExp),
%% 	Status3 = reduce_cash_and_send(Status2, 0, 0, AwareCorper, 0),
	Status4 = calc_properties_send_self(Status1),

	%%PK状态改为全体
	{ok,BinData} = pt_20:write(?PP_PLAYER_PK_MODE_CHANGE, [?PKMode_FREEDOM, misc_timer:now_seconds()]),
	lib_send:send_to_sid(Status4#ets_users.other_data#user_other.pid_send,BinData),
	BattleInfo = Status4#ets_users.other_data#user_other.battle_info#battle_info{pk_mode = ?PKMode_FREEDOM},
	Other = Status4#ets_users.other_data#user_other{battle_info = BattleInfo},
	Status5 = Status4#ets_users{pk_mode = ?PKMode_FREEDOM,other_data = Other},
	{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[Status5]),
	mod_map_agent: send_to_area_scene(Status5#ets_users.current_map_id,
									  Status5#ets_users.pos_x,
									  Status5#ets_users.pos_y,
									  PlayerData,
									  undefined),

 	{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [Status5]),
	mod_map_agent:send_to_area_scene(
									Status5#ets_users.current_map_id,
									Status5#ets_users.pos_x,
									Status5#ets_users.pos_y,
									PlayerScenBin),
	Status5.
%% 取消拉镖
cancel_escort(Status) ->
	Status1 = Status#ets_users{darts_left_time = 0 ,escort_id = 0},
	Status2 = calc_properties_send_self(Status1),
	{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [Status2]),
	mod_map_agent:send_to_area_scene(
									Status2#ets_users.current_map_id,
									Status2#ets_users.pos_x,
									Status2#ets_users.pos_y,
									PlayerScenBin),
	Status2.
%% 完成拉镖
finish_escort(Status, Experience, Copper) ->
	Status1 = Status#ets_users{darts_left_time = 0,escort_id = 0},
	Status2 = calc_properties_send_self(Status1),
%% 	%%聊天室发送信息
%% 	ChatStr = ?GET_TRAN(?_LANG_CHAT_FINISH_DARTS, [Experience, Copper]),
%% 	lib_chat:chat_sysmsg_pid([Status2#ets_users.other_data#user_other.pid_send, ?CHAT, ?None, ?ORANGE, ChatStr]),
	{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [Status2]),
	mod_map_agent:send_to_area_scene(
									Status2#ets_users.current_map_id,
									Status2#ets_users.pos_x,
									Status2#ets_users.pos_y,
									PlayerScenBin),
	Status2.
%% 拉镖被杀
kill_escort(Status, AttackerPid, AttName, Exp, Copper, AttType) ->
	AwardCopper = Copper div 2,
	%判断玩家vip等级加成
	Vip_id = Status#ets_users.vip_id,
	NewExp = 
		if Vip_id  band ?VIP_BSL_HALFYEAR =/= 0 orelse Vip_id  band ?VIP_BSL_GM =/= 0 ->
				tool:to_integer(Exp*1.1);
			Vip_id  band ?VIP_BSL_MONTH =/= 0 orelse Vip_id  band ?VIP_BSL_NEWPLAYERLEADER =/= 0 orelse Vip_id  band ?VIP_BSL_ONEHOUR =/= 0->
				tool:to_integer(Exp*1.06);
			Vip_id  band ?VIP_BSL_WEEK =/= 0 orelse Vip_id  band ?VIP_BSL_DAY =/= 0->
				tool:to_integer(Exp*1.03);
			true ->
				Exp
		end,
	Status1 = Status#ets_users{darts_left_time = 0,escort_id = 0},
	Status2 = calc_properties_send_self(Status1),	
	Status3 = add_task_award(Status2, 0, 0, AwardCopper, 0, NewExp, 0, [], 555201),	%拉镖专用编号
	case AttType of
		?ELEMENT_PLAYER ->
			gen_server:cast(AttackerPid, {'add_rob_aware', AwardCopper}),
			%%全服通告
			ChatAllStr = ?GET_TRAN(?_LANG_TASK_CARGO_GRABED, [ AttName,Status3#ets_users.nick_name]),
			lib_chat:chat_sysmsg_roll([ChatAllStr]);
		_ ->
			skip
	end,
	%%更新角色状态
	{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [Status3]),
	mod_map_agent:send_to_area_scene(
				Status3#ets_users.current_map_id,
				Status3#ets_users.pos_x,
				Status3#ets_users.pos_y,
				PlayerScenBin),
	Msg = ?GET_TRAN(?_LANG_TASK_CARGO_LOSS, []),
	lib_chat:chat_sysmsg_pid([Status3#ets_users.other_data#user_other.pid_send, ?EVENT, ?None, ?ORANGE, Msg]),
	Status3.

%%判断劫镖次数
check_rob_times(Status, MaxRobTimes) ->
	NowSecond = misc_timer:now_seconds(),
	RepeatDay = util:get_diff_days(Status#ets_users.today_escort_times, NowSecond),
	Status1 = if
					RepeatDay >= 1 ->
						IsUpdate = 1,
						Status#ets_users{today_escort_times = 0, escort_ref_date = NowSecond};
					true ->
						IsUpdate = 0,
						Status
				end,
	case Status1#ets_users.today_escort_times >= MaxRobTimes of
		true ->
			if
				IsUpdate =:= 1 ->
					db_agent_user:update_transport_info(Status1#ets_users.today_escort_times,
															Status1#ets_users.escort_ref_date,
															0,Status1#ets_users.id);
				true ->
					ok
			end,
			false;
		_ ->
			Status2 = Status1#ets_users{today_escort_times = Status1#ets_users.today_escort_times+1},
			db_agent_user:update_transport_info(Status2#ets_users.today_escort_times,0,Status2#ets_users.id),
			{ok,Status2}
	end.
	

	

%%更新界面帮会运镖剩余时间
set_guild_trans_time(PlayerPid, GuildTime) ->
	gen_server:cast(PlayerPid, {'update_guild_tran_time', GuildTime}).

%%登录加载充值信息
load_pay(Status) ->
 	Site = config:get_login_site(),
 	PayInfo = db_agent_admin:get_user_pay(Site, Status#ets_users.user_name),

 	case PayInfo of
 		[] ->
 			Status;
		_ ->
			user_buy_item_qq(PayInfo, Status)
 	end.
	
%% user_pay(PayInfo,Status) ->
%% 	PayNum = length(PayInfo),
%%   	case PayNum of
%% 		1 ->
%% 			[[Pay_id, Yuanbao]] = PayInfo,
%% 			Pay_YuanBao = Yuanbao,
%% 			lib_active_open_server:user_single_pay(Yuanbao,Status),
%% 			db_agent_admin:update_user_pay(Pay_id);
%% 		_ ->
%% 			Fun = fun(Info, {AddYuanBao,_Id}) ->
%% 					[Pay_id, Yuanbao] = Info,
%% 				  	db_agent_admin:update_user_pay(Pay_id),
%% 					
%% 					lib_active_open_server:user_single_pay(Yuanbao,Status),
%% 				  	{AddYuanBao + Yuanbao, Pay_id}
%% 			end,
%% 			{Pay_YuanBao,Pay_id} = lists:foldl(Fun, {0,0}, PayInfo)
%% 	end,	
%% 	gen_server:cast(Status#ets_users.other_data#user_other.pid_task, {'recharge'}),
%% 	NewStatus1 = add_cash_and_send(Status, Pay_YuanBao, 0, 0, 0,{?GAIN_MONEY_PAY, Pay_id, PayNum}),
%% 	lib_active_open_server:user_pay(Pay_YuanBao,Status),
%% 	NewStatus =  NewStatus1#ets_users{money = NewStatus1#ets_users.money + Pay_YuanBao},
%% 	mod_player:update_db(NewStatus),
%% 	NewStatus.

unite_pay(Status) ->
	case db_agent_admin:get_user_pay_by_server_id(Status#ets_users.site, Status#ets_users.user_name, Status#ets_users.server_id) of
		[] ->
			Status;
		List ->
			user_buy_item_qq(List,Status)
	end.

user_buy_item_qq(PayInfo,Status)->
	PayNum = length(PayInfo),
	Fun = fun(Info,{AddYuanBao,AddCoins,_Id}) ->
				  [Pay_id,ShopItemId,Count,YuanBao,Coins] = Info,
				  if
					  ShopItemId >= 9001 andalso ShopItemId =< 9004  ->
						  db_agent_admin:update_user_pay(Pay_id),
						  if
							  YuanBao > 0 ->
								  lib_active_open_server:user_single_pay(YuanBao,Status);
							  true ->
								  skip
						  end,
						  {AddYuanBao + YuanBao,AddCoins + Coins,Pay_id};
					  true ->
						   case gen_server:call(Status#ets_users.other_data#user_other.pid_item,{qpoint_buy, ShopItemId,Count}) of
							   {ok} ->
								   db_agent_admin:update_user_pay(Pay_id),
								   {AddYuanBao + YuanBao,AddCoins + Coins,Pay_id};
							   _ ->
								   {AddYuanBao,AddCoins,Pay_id}
						   end
				  end
	end,
	{Pay_YuanBao,Pay_Coins,Pay_id} =  lists:foldl(Fun, {0,0,0}, PayInfo),%%lists:foreach(Fun, PayInfo),

	lib_active_open_server:user_pay(Pay_YuanBao,Status),

	NewStatus1 = add_cash_and_send(Status, Pay_YuanBao, 0, 0, 0,{?GAIN_MONEY_PAY, Pay_id, PayNum}),
	
	NewStatus =  NewStatus1#ets_users{money = NewStatus1#ets_users.money + Pay_Coins},
 	mod_player:update_db(NewStatus),
 	NewStatus.


collect_activity_by_uid(UserID, Username, Level, Pid_Item, Pid_send) ->
	 Res = db_agent:get_activity_by_uid(UserID, Level),
	 function_collect_activity(Res, Pid_Item, Pid_send, UserID, Username, 0, 0).


%%激活码领取奖励
collect_activity_by_code(UserID, Username, Code, ActiveIndex, Gift_id, Pid_Item, Pid_send) ->
	case db_agent:get_activity_res(UserID, ActiveIndex) of
		[] ->
			Res = db_agent:get_activity_by_code(Code, ActiveIndex),
			function_collect_activity(Res, Pid_Item, Pid_send, UserID, Username, ActiveIndex, Gift_id);
		_ ->
			{ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [0, ActiveIndex]),
			lib_send:send_to_sid(Pid_send, ResBin)
	end.


collect_activity_every_once(UserID, ActiveIndex, Pid_Item, Pid_send) ->
	 Now = misc_timer:now_seconds(),
	 case db_agent:get_activity_every_by_uid(UserID) of
		 []  ->
			 db_agent:insert_activity_every_collect(UserID, Now, ActiveIndex),
			 [TemplateID, Amount, IsBind] = db_agent:get_activity_collect_award(ActiveIndex),
			  case  item_util:get_item_template(TemplateID) of
				 Template when is_record(Template, ets_item_template) ->
					 gen_server:cast(Pid_Item, {'activity_add_item', TemplateID,Amount,IsBind,Pid_send, ActiveIndex});
				 _ ->
					 {ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [0, ActiveIndex]),
					 lib_send:send_to_sid(Pid_send, ResBin)
			 end;
		 _ ->
			 {ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [0, ActiveIndex]),
			 lib_send:send_to_sid(Pid_send, ResBin)
	 end.
	  
function_collect_activity(Res, Pid_Item, Pid_send, UserID, Username, ActiveIndex, Gift_id) ->
	Now = misc_timer:now_seconds(),
	case Res of
		 []  ->
 			{ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [0, ActiveIndex]),
			lib_send:send_to_sid(Pid_send, ResBin);
		 [ID] ->
			 db_agent:update_activity_collect(ID, Now, UserID),
			 case  data_agent:item_template_get(Gift_id) of
				 Template when is_record(Template, ets_item_template) ->
					 gen_server:cast(Pid_Item, {'activity_add_item', Gift_id, 1, 1, Pid_send, Username, UserID, ActiveIndex});
				 _ ->
					 {ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [0, ActiveIndex]),
					 lib_send:send_to_sid(Pid_send, ResBin)
			 end;
		_ ->
			{ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_COLLECT, [0, ActiveIndex]),
			lib_send:send_to_sid(Pid_send, ResBin)
	 end.

%%帮派篝火
add_exp_in_guild_bonfire(GuildNum, PlayerStatus) ->
	case data_agent:get_sit_award_from_template(PlayerStatus#ets_users.level) of
		[] ->
			error;
		SitAwardTemp ->
			Bonfire_Exp = SitAwardTemp#ets_sit_award_template.bonfire_exp,
			if
				GuildNum =< 10 ->
					Bonfire_Exp_1 = 0;
				GuildNum > 10 andalso GuildNum =< 20 ->
					Bonfire_Exp_1 = Bonfire_Exp * 0.2;
				GuildNum > 20 andalso GuildNum =< 30 ->
					Bonfire_Exp_1 = Bonfire_Exp * 0.3;
				true  ->
					Bonfire_Exp_1 = Bonfire_Exp * 0.5
			end,
			%%喝酒经验加成
			BuffList = PlayerStatus#ets_users.other_data#user_other.buff_list,
			F = fun(Buff, [_Exp2]) ->
						if
							Buff#ets_users_buffs.template_id =:= 730001 ->
								Exp_3 = Bonfire_Exp * 0.1;
							Buff#ets_users_buffs.template_id =:= 730002 ->
								Exp_3 = Bonfire_Exp * 0.2;
							Buff#ets_users_buffs.template_id =:= 730003 ->
								Exp_3 = Bonfire_Exp * 0.3;
							Buff#ets_users_buffs.template_id =:= 730004 ->
								Exp_3 = Bonfire_Exp * 0.4;
							true ->
								Exp_3 = 0
						end,						
						[Exp_3]
				end,
			[Bonfire_Exp_2] = lists:foldl(F, [0], BuffList),
			Total_Exp1 = Bonfire_Exp + Bonfire_Exp_1 + Bonfire_Exp_2,
			Total_Exp = tool:ceil(Total_Exp1),
			{ok, Total_Exp}
	end.
		

%% 使用vip卡处理
update_vip(PlayerStatus,VipClass) ->
	lib_vip:update_vip(PlayerStatus,VipClass).

%%验证码领取查询
collect_activity_search(Pid_Send, UID, ActiveIndex) ->
	case db_agent:get_activity_res(UID, ActiveIndex) of
		[] ->
			Res = 0;
		_ ->
			Res = 1
	end,
	{ok, ResBin} = pt_20:write(?PP_PLAYER_ACTIVY_SEARCH, [Res, ActiveIndex]),
	lib_send:send_to_sid(Pid_Send, ResBin).
			

%% 战斗状态定时处理
update_now_state(PlayerStatus) ->
	case PlayerStatus#ets_users.other_data#user_other.player_now_state of
		?ELEMENT_STATE_FIGHT ->
			update_now_state1(PlayerStatus);
		_ ->
			{false,PlayerStatus}
	end.

update_now_state1(PlayerStatus) ->
	Now = misc_timer:now_seconds() - ?LEAVE_BATTLE_SECONDS,
	case Now > PlayerStatus#ets_users.other_data#user_other.last_fight_actor_time andalso
		Now > PlayerStatus#ets_users.other_data#user_other.last_fight_target_time andalso
		Now > PlayerStatus#ets_users.other_data#user_other.last_pk_actor_time andalso
		Now > PlayerStatus#ets_users.other_data#user_other.last_pk_target_time of
		 true ->
			OtherData = PlayerStatus#ets_users.other_data#user_other{player_now_state = ?ELEMENT_STATE_COMMON},
			{ok, PlayerStatus#ets_users{other_data = OtherData}};
		_ ->
			{false, PlayerStatus}
	end.
	 
%% 创建帮派，扣钱
create_guild_by_money(PlayerStatus, GuildName, Declear, CreateType) ->
	case check_nobind_cash(PlayerStatus,0,?GUILD_BUILD_COPPER) of
		true ->
			create_guild_by_money1(PlayerStatus, GuildName, Declear, CreateType);
		_ ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILD_ERROR_NOT_ENOUGH_CASH]),
			PlayerStatus
	end.

create_guild_by_money1(PlayerStatus, GuildName, Declear, CreateType) ->
	case gen_server:call(mod_guild:get_mod_guild_pid(),{create_guild,
						  GuildName,
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
						  PlayerStatus#ets_users.id}) of
		{ok} ->
			lib_player:reduce_cash_and_send(PlayerStatus,0,0,?GUILD_BUILD_COPPER,0);
		_ ->
			PlayerStatus
	end.



%% type 1:原地健康复活，2复活点1，3复活点2，4复活点3
relive_war(PlayerStatus, Type) ->
	Res =
		case Type of
			1 ->
				relive3(PlayerStatus);
			_ ->				
				mod_map:leave_scene(PlayerStatus#ets_users.id,
								 PlayerStatus#ets_users.other_data#user_other.pet_id,
						         PlayerStatus#ets_users.current_map_id, 
						         PlayerStatus#ets_users.other_data#user_other.pid_map, 
						         PlayerStatus#ets_users.pos_x, 
						         PlayerStatus#ets_users.pos_y,
						         PlayerStatus#ets_users.other_data#user_other.pid,
						         PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
				
				Other = PlayerStatus#ets_users.other_data#user_other{
														 pid_map = undefined,
														 walk_path_bin=undefined,
%% 														 map_template_id = CurrentMapId,
														 player_now_state = ?ELEMENT_STATE_COMMON
														},
				{PosX, PosY} = lib_free_war:get_born_pos(PlayerStatus#ets_users.other_data#user_other.war_state, Type),
				NewPlayerStatus = PlayerStatus#ets_users{
							    current_hp = PlayerStatus#ets_users.other_data#user_other.total_hp,
								current_mp = PlayerStatus#ets_users.other_data#user_other.total_mp,		 
%% 							    current_map_id = CurrentMapId,
								pos_x = PosX,
								pos_y = PosY,
								other_data=Other
								},
				{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [
										  NewPlayerStatus#ets_users.other_data#user_other.map_template_id,
										  NewPlayerStatus#ets_users.pos_x,
										  NewPlayerStatus#ets_users.pos_y]
										 ),
				lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, EnterData),
				{ok,NewPlayerStatus}
		end,
	case Res of
		{ok, NewPlayerStatus1} ->
			Now = misc_timer:now_seconds() + 5,
%% 			BattleInfo = NewPlayerStatus1#ets_users.other_data#user_other.battle_info#battle_info{invincible_date=Now},
%% 			UserOther = NewPlayerStatus1#ets_users.other_data#user_other{battle_info=BattleInfo},
%% 			NewPlayerStatus2 = NewPlayerStatus1#ets_users{other_data = UserOther},
			mod_map:update_online_dic_invincible(NewPlayerStatus1, Now),
			{ok, NewPlayerStatus1};
		_ ->
			ok
	end.			
		
%% 兑换银两
exchange_bind_yuanbao(PlayerStatus, Type) ->
	case Type of 
		1 ->
			exchange_bind_yuanbao1(PlayerStatus, Type,?EXCHANGE_YUAN_BAO,?EXCHANGE_YUAN_BAO_GET,?EXCHANGE_YUAN_BAO_WARITE);
		2 ->
			exchange_bind_yuanbao1(PlayerStatus, Type,?EXCHANGE_YUAN_BAO1,?EXCHANGE_YUAN_BAO_GET1,?EXCHANGE_YUAN_BAO_WARITE1);
		3 ->
			exchange_bind_yuanbao1(PlayerStatus, Type,?EXCHANGE_YUAN_BAO2,?EXCHANGE_YUAN_BAO_GET2,?EXCHANGE_YUAN_BAO_WARITE2)
	end.

exchange_bind_yuanbao1(PlayerStatus, Type,YuanBao,GetYuanBao,WriteYuanBao) ->
		if
			PlayerStatus#ets_users.exchange_bind_yuanbao band WriteYuanBao =/= 0 ->
			NewPlayerStatus = PlayerStatus;
		true ->
				PlayerStatus1 = reduce_cash_and_send(PlayerStatus, YuanBao, 0, 0, 0, {?CONSUME_EXCHANGE_YUAN_BAO,Type,1}),
				PlayerStatus2 = add_cash_and_send(PlayerStatus1, 0, GetYuanBao, 0, 0, {?GAIN_MONEY_EXCHANGE_YUAN_BAO,Type,1}),
				lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
								  ?FLOAT,
								  ?None,
								  ?ORANGE,
								  ?_LANG_EXCHANGE_SUC]),
				NewType = PlayerStatus2#ets_users.exchange_bind_yuanbao bor WriteYuanBao,
				{ok, Data} = pt_20:write(?PP_GET_BIND_YUANBAO, [NewType] ),
				lib_send:send_to_sid(PlayerStatus2#ets_users.other_data#user_other.pid_send, Data),
				NewPlayerStatus = PlayerStatus2#ets_users{exchange_bind_yuanbao = NewType}
		end,
	NewPlayerStatus.
			
