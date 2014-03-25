%% Author: Administrator
%% Created: 2011-3-11
%% Description: TODO: 人物信息
-module(pt_20).
-export([read/2, write/2]).
-include("common.hrl").

%%
%% API Functions
%%




%%
%%客户端 -> 服务端 ----------------------------
%%
%% 获取用户自身其他信息
read(?PP_QUERY_SELF_OTHER, <<Query:32>>)->
	{ok, [Query]};

%% 游戏设置
read(?PP_CONFIG, <<Config:32>>) ->
    {ok, Config};

%% 服务端开服时间
read(?PP_SERVER_OPEN_DATE, _) ->
    {ok, []};

%% http 登陆
read(?PP_LOGIN, <<Key:32,UserId:64, _Version:32, _Rand:32, _IsGuest:8, Bin/binary>> ) ->
  {UserName, Bin1} = pt:read_string(Bin),
  {Site, Bin2_2} = pt:read_string(Bin1),
  <<Server_id:16, Bin2/binary>> = Bin2_2,
  {Tick, Bin3} = pt:read_string(Bin2),
  {Sign, _} = pt:read_string(Bin3),
  	case lists:any(fun(E)-> E =:= Server_id end, config:get_login_server_id()) of
		true ->
			{ok, http_login, [Key,UserName, Site, Server_id, Tick, Sign, UserId]};
		false ->
			false
	end;
  

%% 玩家主动攻击
read(?PP_PLAYER_ATTACK, <<ActorID:64,TargetID:64,Type:8,SkillGroupID:32,X:32,Y:32>> ) ->
	%?PRINT("ATTACK ~p ~p ~p ~p ~p ~p ~n",[ActorID,TargetID,Type,SkillGroupID,X,Y]),
	{ok, [ActorID,TargetID,Type,SkillGroupID,X,Y]};

%% 技能学习
read(?PP_SKILL_LEARNORUPDATE,<<SkillGroupID:32>>) ->
	{ok, [SkillGroupID]};

%% 技能拖入快捷栏 type 0 技能 1 物品，templateid 技能时为组id，物品为模板id
read(?PP_PLAYER_DRAG_SKILL,<<Type:8, TemplateID:32,FromIndex:16/signed,ToIndex:16/signed>>) ->
	{ok, [Type,TemplateID,FromIndex,ToIndex]};

%% 拾取
read(?PP_PLAYER_GET_DROPITEM,<<ID:32>>) ->
	{ok, [ID]};

%% 玩家上下马
read(?PP_PLAYER_SET_HORSE, <<IsHorse:8>>) ->
	{ok, [IsHorse]};

%%玩家选择称号
read(?PP_PLAYER_CHOOSE_TITLE, <<Title:32, IsHide:8>>) ->
	{ok, [Title, IsHide]};

%% 玩家PK模式变更
read(?PP_PLAYER_PK_MODE_CHANGE, <<Mode:8>>) ->
	{ok,[Mode]};

%% 玩家停止采集
read(?PP_PLAYER_COLLECT_STOP, _) ->
	{ok, []};

%% 玩家开始采集
read(?PP_PLAYER_COLLECT_START, <<CollectId:32,TemplateId:32>>) ->
	{ok, [CollectId,TemplateId]};

%% 玩家采集物品
read(?PP_PLAYER_COLLECT, <<CollectId:32,TemplateId:32>>) ->
	{ok, [CollectId,TemplateId]};

%% read(?PP_BUFF_CONTROL, <<IsStop:8>>) ->
%% 	{ok, [IsStop]};

%% 每日奖励
read(?PP_PLAYER_DAILY_AWARD, <<Number:32>>) ->
	{ok, [Number]};

%% 每日奖励
read(?PP_PLAYER_DAILY_AWARD_LIST, <<>>) ->
	{ok, []};

%% 回到京城防卡死
read(?PP_PLAYER_BREAK_AWAY, <<>>) ->
	{ok, []};

%% VIP细节
read(?PP_PLAYER_VIP_DETAIL, <<>>) ->
	{ok, []};

%% VIP奖励
read(?PP_PLAYER_VIP_AWARD, <<Place:8>>) ->
	{ok, [Place]};
%% 请求福利信息
read(?PP_PLAYER_WELFARE_UPDATE, _) ->
	{ok, []};
%% 领取福利
read(?PP_PLAYER_WELFARE_RECEIVE, <<Type:32>>) ->
	{ok, [Type]};
%% 兑换经验
read(?PP_PLAYER_WELFARE_EXP_EXCHANGE, <<Type:32,ExchangeType:32,Num:32>>) ->
	{ok, [Type,ExchangeType,Num]};
%% 重置连续登录天数
%% read(?PP_PLAYER_WELFARE_RESET_LOGIN_DAY, _)->
%% 	{ok, []};

%%激活码领取奖励
read(?PP_PLAYER_ACTIVY_COLLECT, <<ActiveIndex:32, Gift_ID:32, Bin/binary>>) ->
	{Code, _} = pt:read_string(Bin),
	{ok, [ActiveIndex, Gift_ID, Code]};

%%激活码领取查询
read(?PP_PLAYER_ACTIVY_SEARCH, <<Activy_id:32>>) ->
	{ok, [Activy_id]};
	
%% 获取个人荣誉值
read(?PP_UPDATE_SELF_HONOR, _) ->
	{ok, []};

%% 升级筋脉
read(?PP_VEINS_ACUPOINT_UPDATE, <<Acupoint_Type:32>>) ->
	{ok, [Acupoint_Type]};
%% 升级根骨
read(?PP_VEINS_GENGU_UPDATE, <<Acupoint_Type:32>>) ->
	{ok, [Acupoint_Type]};
%% 使用元宝清除CD  1为全部清除，2为清除一个小时
read(?PP_VEINS_CLEAR_CD, <<Clear_Type:32,Place:32>>) ->
	{ok, [Clear_Type,Place]};
%% 获取个人经脉信息
read(?PP_VEINS_INIT, _) ->
	{ok, []};

read(?PP_PLAYER_VIP_USE, <<Place:32>>) ->
	{ok, [Place]};

%% 活跃度礼包领取
read(?PP_PLAYER_ACTIVE_AWARD, _) ->
	{ok, []};

%% 活跃度活动数量信息
read(?PP_PLAYER_ACTIVE_INFO, _) ->
	{ok, []};

%% 活跃度,可领取状态
read(?PP_PLAYER_ACTIVE_STATE, _) ->
	{ok, []};

%% 隐藏时装
read(?PP_HIDE_FASHION, <<State:8>>) ->
	{ok, [State]};

%% 隐藏武饰
read(?PP_HIDE_WEAPONACCES, <<State:8>>) ->
	{ok, [State]};


%% 开服相关活动
read(?PP_PLAYER_ACTIVE_OPEN_SERVER, _) ->
	{ok, []};

%% 领取开服相关活动
read(?PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD, <<ID:16,GroupId:8>>) ->
	{ok, [ID,GroupId]};

read(?PP_PLAYER_YELLOW_INFO, _) ->
	{ok, []};

%%玩家黄钻奖励获取
read(?PP_PLAYER_YELLOW_GET_REWARD, <<Type:8>>) ->
	{ok, [Type]};

read(?PP_ACTIVE_SEVEN, _) ->
	{ok, []};

read(?PP_ACTIVE_SEVEN_GETREWARD, <<ID:8>>) ->
	{ok, [ID]};

read(?PP_ACTIVE_SEVEN_GET_ALL_REWARD, <<ID:8>>) ->
	{ok, [ID]};

%% 获取交易token 
read(?PP_QQ_BUY_GOODS,<<ShopItemID:32,ShopItemNum:32,ZoneID:16, Bin/binary>>) ->
	{OpenKey, Bin1} = pt:read_string(Bin),
	{Pf, Bin2} = pt:read_string(Bin1),
	{PfKey, Bin3} = pt:read_string(Bin2),
	{Domain, _Bin4} = pt:read_string(Bin3),
	{ok, [ZoneID,Domain,ShopItemID,ShopItemNum,OpenKey,Pf,PfKey]};
	
read(?PP_GET_BIND_YUANBAO,<<Type:8>>) ->
	{ok, [Type]};

read(?PP_DUPLICATE_SHENYOU,<<ID:32,Times:32,ExpPill:32>>) ->
	{ok,[ID,Times,ExpPill]};

read(?PP_DUPLICATE_SHENYOU_COMPLATE,<<>>) ->
	{ok,[]};

read(?PP_DUPLICATE_SHENYOU_INTERRUPT,<<>>) ->
	{ok,[]};

%% 使用vip卡
read(Cmd, _R) ->
	?WARNING_MSG("pt_20 read error:~w",[{Cmd,_R}]),
    {error, no_match}.

%%
%%服务端 -> 客户端 ----------------------------
%%

%%返回选择人物信息
write(?PP_LOGIN, [User]) ->
	SelfPlayer =  pt:packet_self_player(User),
	UserID = User#ets_users.id,
%% 	CurrentMapID = User#ets_users.current_map_id,	
	CurrentMapID = User#ets_users.other_data#user_other.map_template_id,
	Data = <<UserID:64, SelfPlayer/binary, CurrentMapID:32>>,
	{ok, pt:pack(?PP_LOGIN, Data)};

write(?PP_SERVER_OPEN_DATE,[Date,Date2]) ->
	{ok, pt:pack(?PP_SERVER_OPEN_DATE, <<Date:64,Date2:64>>)};


%% 个人货币信息
write(?PP_UPDATE_SELF_INFO, [YuanBao, Copper, BindCopper, DepotCopper, BindYuanBao]) ->
    {ok, pt:pack(?PP_UPDATE_SELF_INFO, <<YuanBao:32, Copper:32, BindCopper:32, DepotCopper:32, BindYuanBao:32>>)};
%% 	{ok, pt:pack(?PP_UPDATE_SELF_INFO, <<YuanBao:32, Copper:32, BindCopper:32, DepotCopper:32>>)};

%% 更新玩家信息公开信息
write(?PP_UPDATE_USER_INFO,User) ->	
     Data = <<
			  (User#ets_users.level):32,
			  (User#ets_users.other_data#user_other.total_hp + User#ets_users.other_data#user_other.tmp_totalhp):32,
              (User#ets_users.other_data#user_other.total_mp + User#ets_users.other_data#user_other.tmp_totalmp):32,
              (User#ets_users.current_hp):32,
              (User#ets_users.current_mp):32,
              (User#ets_users.exp):64,
              (User#ets_users.other_data#user_other.attack + User#ets_users.other_data#user_other.tmp_attack):32,
              (User#ets_users.other_data#user_other.defense + User#ets_users.other_data#user_other.tmp_defense):32,
              (User#ets_users.other_data#user_other.hit_target + User#ets_users.other_data#user_other.tmp_hit_target):32,
              (User#ets_users.other_data#user_other.duck + User#ets_users.other_data#user_other.tmp_duck):32,
              (User#ets_users.other_data#user_other.mump_hurt + User#ets_users.other_data#user_other.tmp_mump_hurt):32,
              (User#ets_users.other_data#user_other.mump_defense + User#ets_users.other_data#user_other.tmp_mump_defense):32,
              (User#ets_users.other_data#user_other.magic_hurt + User#ets_users.other_data#user_other.tmp_magic_hurt):32,
              (User#ets_users.other_data#user_other.magic_defense  + User#ets_users.other_data#user_other.tmp_magic_defense):32,
			  (User#ets_users.other_data#user_other.far_hurt +  User#ets_users.other_data#user_other.tmp_far_hurt):32,
			  (User#ets_users.other_data#user_other.far_defense +  User#ets_users.other_data#user_other.tmp_far_defense):32,
              (User#ets_users.other_data#user_other.power_hit +  User#ets_users.other_data#user_other.tmp_power_hit):32,
              (User#ets_users.other_data#user_other.max_physical ):32,
              (User#ets_users.current_physical):32,
              (User#ets_users.pk_value):32,
              (User#ets_users.life_experiences):32,
			  (User#ets_users.other_data#user_other.deligency + User#ets_users.other_data#user_other.tmp_deligency):32,
			  (User#ets_users.fight):32>>,
     {ok, pt:pack(?PP_UPDATE_USER_INFO, Data)};

%%  更新玩家地图信息
%% write(?PP_UPDATE_USER_INFO_REPLAY, [UserID, StyleBin, TotalHP, TotalMP, IsHorse]) ->
%%     Data = <<UserID:64,
%% 			 StyleBin/binary,
%% 			 IsHorse:8,
%% 			 TotalHP:32,
%%              TotalMP:32>>,
%%      {ok,pt:pack(?PP_UPDATE_USER_INFO_REPLAY, Data)};


%%  传递技能信息
write(?PP_SKILL_INIT, [L,GuildSkillUpTimes]) ->
	LenSkill = length(L),
	SkillBin = writeskill(L,<<>>),
	Data = <<LenSkill:32,
			 SkillBin/binary,
			GuildSkillUpTimes:8>>,
	{ok,pt:pack(?PP_SKILL_INIT,Data)};


%% 传递快捷栏信息
write(?PP_SKILL_BAR_INIT, L) ->
	LenSkillBar = length(L),
	SkillBarBin = writeskillbar(L,<<>>),
	Data = <<LenSkillBar:32,
			 SkillBarBin/binary>>,
	{ok,pt:pack(?PP_SKILL_BAR_INIT,Data)};

%% 空包返回 用于自动战斗判断
write(?PP_PLAYER_ATTACK, _) ->
	Data = <<>>,
	{ok,pt:pack(?PP_PLAYER_ATTACK,Data)};



%%个人血蓝体力更新
write(?PP_UPDATE_SELF_PHYSICAL,CP) ->
	Data = <<CP:32>>,
	{ok,pt:pack(?PP_UPDATE_SELF_PHYSICAL,Data)};

%%个人经验更新-传总exp,及战斗中的宠物的总exp
write(?PP_UPDATE_SELF_EXP,[EXP,PetID,PetEXP,LifeExp]) ->
	Data = <<EXP:64,
			 LifeExp:32,
			 PetID:64,
			 PetEXP:64>>,
	{ok,pt:pack(?PP_UPDATE_SELF_EXP,Data)};

%% 个人荣誉和击杀
write(?PP_UPDATE_SELF_HONOR, User) ->
	Data = <<(User#ets_users.honor):32,
		     (User#ets_users.day_honor):32,
		     (User#ets_users.kill_count):32,
			 (User#ets_users.day_kill_count):32
			 >>,
	{ok,pt:pack(?PP_UPDATE_SELF_HONOR,Data)};

%%升级更新
write(?PP_UPDATE_PLAYER_LEVEL,[ID, Level, TotalHP, TotalMP, CurrentHP, CurrentMP,TotalLifeExp, LifeExp]) ->
	Data = <<ID:64,
			 Level:16,
			 TotalHP:32,
             TotalMP:32,
             CurrentHP:32,
             CurrentMP:32,
			 TotalLifeExp:32,
			 LifeExp:32
			 >>,
	{ok,pt:pack(?PP_UPDATE_PLAYER_LEVEL,Data)};

%%buff
write(?PP_BUFF_UPDATE,[L,Type,ID,UpdateType, ChangeInfo]) ->
	BuffChange = tool:change_list_to_string(ChangeInfo),
	ChangeBin = pt:write_string(BuffChange),
	LenBuff = length(L),
	BuffBin = pt:writebuff(L,<<>>),
	Data = <<
			 Type:8,
			 ID:64,
			 LenBuff:16,
			 BuffBin/binary,
			 ChangeBin/binary
			 >>,
	{ok,pt:pack(?PP_BUFF_UPDATE,Data)};

%% 玩家上下马
%% write(?PP_PLAYER_SET_HORSE, [UserId, IsHorse]) ->
%% 	Data = <<
%% 			 UserId:64,
%% 			 IsHorse:8>>,
%% 	{ok,pt:pack(?PP_PLAYER_SET_HORSE, Data)};

%%玩家选择称号回应
write(?PP_PLAYER_CHOOSE_TITLE, [Res,Title,IsHide]) ->
	case Res =:= 1 of
		true ->
			Data = <<Res:8,Title:32,IsHide:8>>;
		_ ->
			Data = <<Res:8>>
	end,

	{ok, pt:pack(?PP_PLAYER_CHOOSE_TITLE, Data)};



%% 更新玩家的历练
write(?PP_PLAYER_SELF_LIFEEXP, [LifeExp]) ->
	Data = << 
			 LifeExp:32
			 >>,
	{ok,pt:pack(?PP_PLAYER_SELF_LIFEEXP,Data)};

%% 更新玩家的PK模式
write(?PP_PLAYER_PK_MODE_CHANGE, [Mode,Time]) ->
	Data = <<
			 Mode:8,
			 Time:32
			 >>,
	{ok,pt:pack(?PP_PLAYER_PK_MODE_CHANGE,Data)};

%% 更新玩家PK值
write(?PP_PLAYER_PK_VALUE_CHANGE, [PlayerID,PKValue]) ->
	Data = <<
			 PlayerID:64,
			 PKValue:32
			 >>,
	{ok, pt:pack(?PP_PLAYER_PK_VALUE_CHANGE,Data)};

%% 每日奖励
write(?PP_PLAYER_DAILY_AWARD, [Award,Success]) ->
	{ok, pt:pack(?PP_PLAYER_DAILY_AWARD,<<Award:8,Success:8>>)};

%% 每日奖励
write(?PP_PLAYER_DAILY_AWARD_LIST, [DailyAward,Seconds]) ->
	DABin = pt:write_string(DailyAward),
	Data = <<DABin/binary,Seconds:32>>,
	{ok, pt:pack(?PP_PLAYER_DAILY_AWARD_LIST,<<Data/binary>>)};

%%移除每日奖励
%% write(?PP_PLAYER_DAILY_AWARD_REMOVE, []) ->
%% 	{ok,pt:pack(?PP_PLAYER_DAILY_AWARD_REMOVE,<<>>)};

%% VIP细节
write(?PP_PLAYER_VIP_DETAIL, [VipID, VipLeftDate, VipLeftTranferShoe,VipBugle,IsGetAward1,IsGetAward2,IsGetAward3]) ->
	write(?PP_PLAYER_VIP_DETAIL, [0,VipID, VipLeftDate, VipLeftTranferShoe,VipBugle,IsGetAward1,IsGetAward2,IsGetAward3]);

write(?PP_PLAYER_VIP_DETAIL, [IsAlert,VipID, VipLeftDate, VipLeftTranferShoe,VipBugle,IsGetAward1,IsGetAward2,IsGetAward3]) ->
	{ok, pt:pack(?PP_PLAYER_VIP_DETAIL, <<IsAlert:8,
										  VipID:16,
										  VipLeftDate:32,
										  VipLeftTranferShoe:32,
										  VipBugle:32,
										  IsGetAward1:8,
										  IsGetAward2:8,
										  IsGetAward3:8>>)};

%% 成功使用VIP体验卡
write(?PP_PLAYER_VIP_ONE_HOUR, [Re]) ->
	{ok, pt:pack(?PP_PLAYER_VIP_ONE_HOUR, <<Re:8>>)};

%% VIP奖励
write(?PP_PLAYER_VIP_AWARD, [IsSucc,Place]) ->
	{ok, pt:pack(?PP_PLAYER_VIP_AWARD, <<IsSucc:8,Place:8>>)};

%% 福利信息
write(?PP_PLAYER_WELFARE_UPDATE, [Is_Receive,Is_VipReceive, WelfareInfo]) ->
	%?DEBUG("PP_PLAYER_WELFARE_UPDATE:~p",[{Is_Receive,Is_VipReceive,WelfareInfo}]),
	{ok, pt:pack(?PP_PLAYER_WELFARE_UPDATE, <<Is_Receive:8,Is_VipReceive:8,
										 (WelfareInfo#ets_user_welfare.login_day):16,
										 (WelfareInfo#ets_user_welfare.duplicate_num):16,
										 (WelfareInfo#ets_user_welfare.multi_duplicate_num):16,
										 (WelfareInfo#ets_user_welfare.off_line_times):32>>)};
%% 领取福利
write(?PP_PLAYER_WELFARE_RECEIVE, [Res,Type]) ->
	{ok, pt:pack(?PP_PLAYER_WELFARE_RECEIVE, <<Res:16,Type:32>>)};
%% 兑换经验
write(?PP_PLAYER_WELFARE_EXP_EXCHANGE, [Type,ExchangeType,Num]) ->
	{ok, pt:pack(?PP_PLAYER_WELFARE_EXP_EXCHANGE, <<Type:16,ExchangeType:16,Num:32>>)};

%% 重置连续登录
%% write(?PP_PLAYER_WELFARE_RESET_LOGIN_DAY, []) ->
%% 	{ok, pt:pack(?PP_PLAYER_WELFARE_RESET_LOGIN_DAY, <<1:16,1:16>>)};

%%验证码活动领取返回
write(?PP_PLAYER_ACTIVY_COLLECT, [Res, ActiveIndex]) ->
	Data = <<ActiveIndex:32, Res:8>>,
	{ok, pt:pack(?PP_PLAYER_ACTIVY_COLLECT, Data)};

%%活动领取查询
write(?PP_PLAYER_ACTIVY_SEARCH, [Res, ActiveIndex]) ->
	Data = <<ActiveIndex:32, Res:8>>,
	{ok, pt:pack(?PP_PLAYER_ACTIVY_SEARCH, Data)};
%% 升级筋脉
write(?PP_VEINS_ACUPOINT_UPDATE, [Acupoint_type, Lv, Time]) ->
	Data = <<Acupoint_type:32, Lv:32, Time:64>>,
	{ok, pt:pack(?PP_VEINS_ACUPOINT_UPDATE, Data)};
%% 升级根骨
write(?PP_VEINS_GENGU_UPDATE, [Success, Acupoint_type, Lv, Rate]) ->
	Data = <<Success:8, Acupoint_type:32, Lv:32, Rate:32>>,
	{ok, pt:pack(?PP_VEINS_GENGU_UPDATE, Data)};
%% 使用元宝清除CD
write(?PP_VEINS_CLEAR_CD, [Time]) ->
	Data = <<Time:64>>,
	{ok, pt:pack(?PP_VEINS_CLEAR_CD, Data)};
write(?PP_VEINS_INIT, [Time, AcupointType, L]) ->
	Size = length(L),
	VeinsBin = pt:writeveins(L, <<>>),
	{ok, pt:pack(?PP_VEINS_INIT, <<Time:64, AcupointType:32, Size:16, VeinsBin/binary>>)};
	
write(?PP_PLAYER_ACTIVE_AWARD,[Res]) ->
	{ok, pt:pack(?PP_PLAYER_ACTIVE_AWARD, <<Res:8>>)};

write(?PP_PLAYER_ACTIVE_INFO, [Info]) ->
	Data = write_active_info(Info#ets_users_active.times,<<>>),
	Size = length(Info#ets_users_active.times),
	DayActive = Info#ets_users_active.day_active,
	{ok, pt:pack(?PP_PLAYER_ACTIVE_INFO, <<DayActive:16,Size:8,Data/binary>>)};


write(?PP_PLAYER_ACTIVE_NUM, [N,T]) ->
	{ok, pt:pack(?PP_PLAYER_ACTIVE_NUM, <<N:16,T:8>>)};

%%返回背包已满采集物品发送到邮件中
write(?PP_PLAYER_COLLECT, State) ->
	{ok, pt:pack(?PP_PLAYER_COLLECT, <<State:32>>)};

write(?PP_PLAYER_ACTIVE_STATE, [Info]) ->
	Data = write_active_info(Info#ets_users_active.rewards,<<>>),
	Size = length(Info#ets_users_active.rewards),
	{ok, pt:pack(?PP_PLAYER_ACTIVE_STATE, <<Size:8,Data/binary>>)};

%% 开服相关活动
write(?PP_PLAYER_ACTIVE_OPEN_SERVER, List) ->
	Size = length(List),
	F = fun(Info) ->
				Len = length(Info#ets_users_open_server.rewards_ids),
				Bin = write_active_rewards(Info#ets_users_open_server.rewards_ids,<<>>),
				<<
				  (Info#ets_users_open_server.group_id):8,
				  (Info#ets_users_open_server.num):32,
				  (Info#ets_users_open_server.other_data#other_open_server.end_time):64,
				  Len:8,
				  Bin/binary
				  >>
		end,
	Data = tool:to_binary([F(X) || X <- List]),
	
	{ok, pt:pack(?PP_PLAYER_ACTIVE_OPEN_SERVER, <<Size:8,Data/binary>>)};

%% 开服首充活动
write(?PP_PLAYER_ACTIVE_FIRST_PAY, [Re]) ->
  {ok, pt:pack(?PP_PLAYER_ACTIVE_FIRST_PAY, <<Re:8>>)};


%% 领取开服相关活动
write(?PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD,[Re,ID,Gorup_ID]) ->
	 {ok, pt:pack(?PP_PLAYER_ACTIVE_OPEN_SERVER_AWARD, <<Re:8,ID:16,Gorup_ID:16>>)};

%% 玩家黄钻信息
write(?PP_PLAYER_YELLOW_INFO, [PlayerStatus]) ->
	Now = misc_timer:now_seconds(), 
	Value = case util:is_same_date(PlayerStatus#ets_users.other_data#user_other.rece_day_pack_date,Now) of
				true ->
					1;
				_ ->
					0
			end,
	{ok, pt:pack(?PP_PLAYER_YELLOW_INFO, <<
										 (PlayerStatus#ets_users.other_data#user_other.is_rece_new_pack):8,
										 (Value):8,
										 (PlayerStatus#ets_users.other_data#user_other.level_up_pack):8
										 >>)};

write(?PP_PLAYER_YELLOW_GET_REWARD, [Re,Type]) ->
  {ok, pt:pack(?PP_PLAYER_YELLOW_GET_REWARD, <<Re:8,Type:8>>)};

%%7天活动列表
%% write(?PP_ACTIVE_SEVEN, [GetValue,List]) ->
%% 	Size = length(List),
%% 	F = fun(Info) ->
%% 				Len = length(Info#ets_activity_seven_data.top_three),
%% 				Bin = write_user(Info#ets_activity_seven_data.top_three,<<>>),
%% 				<<(Info#ets_activity_seven_data.id):8,
%% 				  (Info#ets_activity_seven_data.is_end):8,
%% 				  Len:8,
%% 				  Bin/binary
%% 				  >>
%% 		end,
%% 	Data = tool:to_binary([F(X) || X <- List]),
%%    {ok, pt:pack(?PP_ACTIVE_SEVEN, <<GetValue:32,Size:8,Data/binary>>)};
write(?PP_ACTIVE_SEVEN, [RegistTiem,GetValue,GetValue2]) ->
   {ok, pt:pack(?PP_ACTIVE_SEVEN, <<RegistTiem:32,GetValue:32,GetValue2:32>>)};

write(?PP_ACTIVE_SEVEN_GETREWARD, [Re]) ->
  {ok, pt:pack(?PP_ACTIVE_SEVEN_GETREWARD, <<Re:8>>)};

write(?PP_ACTIVE_SEVEN_GET_ALL_REWARD, [Re]) ->
  {ok, pt:pack(?PP_ACTIVE_SEVEN_GET_ALL_REWARD, <<Re:8>>)};

write(?PP_QQ_BUY_GOODS,[Str]) ->
	Data = pt:write_string(Str),
	{ok, pt:pack(?PP_QQ_BUY_GOODS, <<Data/binary>>)};

write(?PP_GET_BIND_YUANBAO,[Re]) ->
	{ok, pt:pack(?PP_GET_BIND_YUANBAO, <<Re:8>>)};

write(?PP_DUPLICATE_SHENYOU,[ID,Times,ExpPill,Time]) ->
	{ok, pt:pack(?PP_DUPLICATE_SHENYOU, <<ID:32,Times:32,ExpPill:32,Time:32>>)};

write(?PP_DUPLICATE_SHENYOU_COMPLATE,[Re]) ->
	{ok, pt:pack(?PP_DUPLICATE_SHENYOU_COMPLATE, <<Re:8>>)};

write(?PP_DUPLICATE_SHENYOU_INTERRUPT,[Re]) ->
	?DEBUG("write(?PP_DUPLICATE_SHENYOU_INTERRUPT",[]),
	{ok, pt:pack(?PP_DUPLICATE_SHENYOU_INTERRUPT, <<Re:8>>)};

write(Cmd, _R) ->
	?WARNING_MSG("pt_20 ~s_errorcmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.

%%
%% Local Functions
%%


%% 递归技能
writeskill([], SkillBin) -> SkillBin;
writeskill([H | T], SkillBin) ->
	%{_Id,Validdate,Lv,GroupId} = H,
	IsExist = 1,
	%GroupId = lib_skill:change_skillid_to_groupid(Id),
    NewSkillBin = << SkillBin/binary,
					 (H#r_use_skill.skill_group):32,
					 IsExist:8,
					 (H#r_use_skill.skill_lastusetime):64,
					 (H#r_use_skill.skill_lv):16
					 >>,
	writeskill(T, NewSkillBin).


%% 递归快捷栏内容
writeskillbar([],SkillBarBin) -> SkillBarBin;
writeskillbar([H|T],SkillBarBin) ->
	{BarIndex,Type,_TemplateID,GroupID} = H,
	NewSkillBarBin = << SkillBarBin/binary,
						BarIndex:16,
						Type:8,
						GroupID:32>>,
	writeskillbar(T,NewSkillBarBin).


write_active_info([], Bin) -> Bin;
write_active_info([{Index,Time} | T], Bin) ->
	NewBin = << Bin/binary,
						(Index):8,
						(Time):8
						>>,
write_active_info(T, NewBin).


write_active_rewards([], Bin) -> Bin;
write_active_rewards([ID | T], Bin) ->
	NewBin = << Bin/binary,
						(ID):16
						>>,
write_active_rewards(T, NewBin).

write_user([], Bin) -> Bin;
write_user([Winner | T], Bin) ->
	NickBin = pt:write_string(Winner#activity_seven_data.nick_name),
	NewBin = <<Bin/binary,
			   (Winner#activity_seven_data.user_id):64,
			   NickBin/binary,
			   (Winner#activity_seven_data.num):32,
			   (Winner#activity_seven_data.is_get):8
			   >>,
	write_user(T, NewBin).


