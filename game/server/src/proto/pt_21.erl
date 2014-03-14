%%%-------------------------------------------------------------------
%%% Module  : pt_21
%%% Author  : lxb
%%% Created : 2012-9-25
%%% Description : 帮派模块
%%%-------------------------------------------------------------------
-module(pt_21).
-export([read/2, write/2]).
-include("common.hrl").


%%
%% API Functions
%%

%%
%%客户端 -> 服务端 ----------------------------
%%
%% 帮会创建
read(?PP_CLUB_CREATE, <<CreateType:32, Bin/binary>> ) ->
	{Name, Bin1} = pt:read_string(Bin),
	{Declear, _Bin2} = pt:read_string(Bin1),
	{ok, [Name, Declear, CreateType]};

%% 帮会查询
read(?PP_CLUB_QUERYLIST, <<PageIndex:16, PageSize:8, Bin/binary>> ) ->
	{Name, _Bin1} = pt:read_string(Bin),
	{ok, [PageIndex,PageSize,Name]};

%% 帮会细节
read(?PP_CLUB_DETAIL, <<GuildID:64>>) ->
	{ok, [GuildID]};

%% 帮会更新
read(?PP_CLUB_SET_NOTICE,<<Bin/binary>>) ->
	{Declaration, _Bin1} = pt:read_string(Bin),
	{ok, [Declaration]};


%% 帮会贡献
read(?PP_CLUB_CONTRIBUTION,<<Type:32,Num:32>>) ->
	{ok,[Type,Num]};

%% 帮会解散
read(?PP_CLUB_DISMISS,<<>>) ->
	{ok, []};

%% 帮会退出
read(?PP_CLUB_EXIT,<<>>) ->
	{ok, []};

%% 帮会升级
read(?PP_CLUB_LEVELUP,<<>>) ->
	{ok, []};

%% 帮会踢出
read(?PP_CLUB_KICKOUT,<<TargetUserID:64>>) ->
	{ok,[TargetUserID]};

%% 帮会转让
read(?PP_CLUB_TRANSFER,<<TargetUserID:64>>) ->
	{ok,[TargetUserID]};

%% 帮会扩展 1 荣誉 2 正式 3预备     返回操作者 两个处理
read(?PP_CLUB_EXTEND_ADD,<<Type:32>>) ->
	{ok,[Type]};


%% 帮会申请列表
read(?PP_CLUB_QUERYTRYIN,<<PageIndex:8,PageSize:8>>) ->
	{ok,[PageIndex,PageSize]};

%% 申请答复
read(?PP_CLUB_TRYINRESPONSE,<<UserID:64,Accept:8,PageIndex:8,PageSize:8>>) ->
	{ok,[UserID,Accept,PageIndex,PageSize]};

%% 职务列表更新
read(?PP_CLUB_DUTY_UPDATE,<<>>) ->
	{ok,[]};

%% 清除申请列表 -返回 pp_club_querytype,total = 0 current = 0
read(?PP_CLUB_CLEARTRYIN,<<>>) ->
	{ok,[]};

%帮会职务更改
read(?PP_CLUB_DUTY_CHANGE,<<UserID:64,Duty:8>>) ->
	{ok,[UserID,Duty]};

%% 帮会新成员加入
read(?PP_CLUB_NEW_PLAYER_IN,<<UserID:64,Type:8>>) ->
	{ok,[UserID,Type]};

%% %%职务列表
%% read(?PP_CLUB_EVENT_UPDATE,<<>>) ->
%% 	{ok,[]};

%% 扩展列表
read(?PP_CLUB_EXTEND_UPDATE,<<>>) ->
	{ok,[]};

%%申请加入帮会
read(?PP_CLUB_TRYIN,<<GuildID:64>>) ->
	{ok,[GuildID]};

read(?PP_CLUB_LEVELUP_UPDATE,<<>>) ->
	{ok,[]};


%% 帮会邀请
read(?PP_CLUB_INVITE,<<Bin/binary>>) ->
	{NickName, _Bin1} = pt:read_string(Bin),
	{ok,[NickName]};

%% 帮会邀请答复
read(?PP_CLUB_INVITE_RESPONSE,<<Accept:8,GuildID:64>>) ->
	{ok,[Accept,GuildID]};

read(?PP_CLUB_TRANSFER_RESPONSE,<<Accept:8,LeaderID:64>>) ->
	{ok,[Accept,LeaderID]};

read(?PP_CLUB_GET_NOTICE,<<>>) ->
	{ok, []};


read(?PP_CLUB_WEAL_UPDATE, <<>>) ->
	{ok, []};
	
%========

read(?PP_CLUB_STORE_PAGEUPDATE,<<PageIndex:8>>) ->
	{ok,[PageIndex]};

read(?PP_CLUB_STORE_REQUEST_LIST,<<PageIndex:8>>) ->
	{ok,[PageIndex]};

read(?PP_CLUB_STORE_MY_REQUEST_LIST,<<PageIndex:8>>) ->
	{ok,[PageIndex]};

read(?PP_CLUB_STORE_GET,<<ItemID:64>>) ->
	{ok,[ItemID]};

read(?PP_CLUB_STORE_PUT,<<Place:8>>) ->
	{ok,[Place]};

read(?PP_CLUB_STORE_CHECK,<<ID:64,Type:8>>) ->
	{ok,[ID,Type]};

read(?PP_CLUB_STORE_EVENT,<<>>) ->
	{ok,[]};

read(?PP_CLUB_STORE_ITEM_CANCEL,<<ID:64>>) ->
	{ok,[ID]};


read(?PP_CLUB_SELF_EXPLOIT_UPDATE,<<>>) ->
	{ok,[]};

%% 宣战
read(?PP_CLUB_WAR_DECLEAR_INIT, <<PageIndex:16, PageSize:8>>) ->
	{ok,[PageIndex, PageSize]};

read(?PP_CLUB_WAR_DEAL_INIT, <<PageIndex:16, PageSize:8>>) ->
	{ok,[PageIndex, PageSize]};

read(?PP_CLUB_WAR_ENEMY_INIT, <<PageIndex:16, PageSize:8>>) ->
	{ok,[PageIndex, PageSize]};

read(?PP_CLUB_WAR_DECLEAR,<<GuildID:64, DeclaerType:8, PageIndex:16, PageSize:8>>) ->
	{ok, [GuildID, DeclaerType, PageIndex, PageSize]};

read(?PP_CLUB_WAR_DEAL, <<GuildID:64, DealType:8, PageIndex:16, PageSize:8>>) ->
	{ok, [GuildID, DealType, PageIndex, PageSize]};

read(?PP_CLUB_WAR_STOP, <<GuildID:64, PageIndex:16, PageSize:8>>) ->
	{ok, [GuildID, PageIndex, PageSize]};


  
read(?PP_CLUB_GETWEAL, <<>>) ->
	{ok,[]};



%% 帮会成员
read(?PP_CLUB_QUERYMEMBER, <<>>) ->
	{ok,[]};



read(?PP_CLUB_ENTER, _) ->
	{ok,[]};

read(?PP_CLUB_LEAVE_SCENCE, _) ->
	{ok, []};

read(?PP_CLUB_MEMBER_LIST, _) ->
	{ok, []};

read(?PP_CLUB_UPGRADE_DEVICE,<<Type:8>>) ->
	{ok,[Type]};
%% 帮会活动召唤
read(?PP_CLUB_SUMMON, <<Id:32>>) ->
	{ok, [Id]};	
read(?PP_CLUB_SUMMON_NUM, _) ->
	{ok, []};
%% 帮会祈祷
read(?PP_CLUB_PRAYER, _) ->
	{ok, []};
%% 帮会限制次数列表
read(?PP_CLUB_LIMIT_NUM_LIST, _) ->
	{ok, []};
%------------------ 已对---------------

read(Cmd, _R) ->
	?WARNING_MSG("pt_21 read error:~w",[Cmd]),
    {error, no_match}.


%%
%%服务端 -> 客户端 ----------------------------
%%
%% 帮会创建
write(?PP_CLUB_CREATE,[GuildID,GuildName,Camp,GuildJob]) ->
	GuildBin = pt:write_string(GuildName),
	{ok,pt:pack(?PP_CLUB_CREATE,<< GuildID:64,Camp:8,GuildJob:8,GuildBin/binary>>)};




%帮会列表
write(?PP_CLUB_QUERYLIST,[C,L]) ->
	N = length(L),
	F = fun([GuildID,GuildName,GuildLevel,MasterId,MasterName,MasterType,Money,Member,RequestsNumber,Notice,FurnaceLevel,ShopLevel]) ->
				  GuildBin = pt:write_string(GuildName),
				  MasterBin = pt:write_string(MasterName),
				  NoticeBin = pt:write_string(Notice),
            <<  
			   GuildID:64,
			   GuildBin/binary,
			   GuildLevel:8,
			   MasterId:64,
			   MasterBin/binary,
			   MasterType:8,
			   Money:32,
			   Member:16,			 
			   RequestsNumber:16,
			   NoticeBin/binary,
			   FurnaceLevel:8,
			   ShopLevel:8>>
    end,
    LB = tool:to_binary([F([X#ets_guilds.id,X#ets_guilds.guild_name,X#ets_guilds.guild_level,X#ets_guilds.master_id, X#ets_guilds.master_name,
							X#ets_guilds.master_type,X#ets_guilds.money,X#ets_guilds.total_member,X#ets_guilds.requests_number,
							X#ets_guilds.declaration,X#ets_guilds.furnace_level,X#ets_guilds.shop_level]) || X <- L]),
	 {ok, pt:pack(?PP_CLUB_QUERYLIST, <<C:32, N:32, LB/binary>>)};


%帮会信息
write(?PP_CLUB_DETAIL,[GuildInfo]) ->
	Current = GuildInfo#ets_guilds.total_member,
	NameBin = pt:write_string(GuildInfo#ets_guilds.guild_name),
	MasterBin = pt:write_string(GuildInfo#ets_guilds.master_name),
%% 	QQBin = pt:write_string(GuildInfo#ets_guilds.qq),
%% 	YYBin = pt:write_string(GuildInfo#ets_guilds.yy),
	DeclatationBin = pt:write_string(GuildInfo#ets_guilds.declaration),
	
	{ok, pt:pack(?PP_CLUB_DETAIL,
	<<
	  NameBin/binary,
      (GuildInfo#ets_guilds.master_id):64,
	  MasterBin/binary,
	  (GuildInfo#ets_guilds.master_type):8,
	  (GuildInfo#ets_guilds.guild_level):8,
	  (GuildInfo#ets_guilds.furnace_level):8,
	  (GuildInfo#ets_guilds.shop_level):8,
	  (GuildInfo#ets_guilds.rank):32,
	  Current:32,
	  (GuildInfo#ets_guilds.money):32,
	  (GuildInfo#ets_guilds.maintain_fee):32,
%% 	  QQBin/binary,
%% 	  YYBin/binary,
	  DeclatationBin/binary
	  >>)};

%% 帮会信息更新
write(?PP_CLUB_SET_NOTICE,[Declaration]) ->
	DeclatationBin = pt:write_string(Declaration),
	{ok, pt:pack(?PP_CLUB_SET_NOTICE,<<
									   DeclatationBin/binary
									   >>)};


write(?PP_CLUB_GET_NOTICE,[Declaration]) ->
	DeclatationBin = pt:write_string(Declaration),
	{ok, pt:pack(?PP_CLUB_SET_NOTICE,<<
									   DeclatationBin/binary
									   >>)};


% 仓库记事更新
write(?PP_CLUB_STORE_EVENT,L) ->
	N = length(L),
	F = fun([LogContent,LogType,Date]) ->
			LogBin = pt:write_string(LogContent),
            << 
			   LogType:32,
			   Date:32,
			   LogBin/binary>>
    end,
    LB = tool:to_binary([F([Content,Type,Date]) || [_,_,Type,Content,Date,_] <- L]),
	{ok, pt:pack(?PP_CLUB_STORE_EVENT, <<N:32, LB/binary>>)};

  
% 帮会贡献
write(?PP_CLUB_CONTRIBUTION,[TotalMoney,UserID,TotalFeats,CurrentFeats]) ->
	{ok, pt:pack(?PP_CLUB_CONTRIBUTION,<<TotalMoney:32,UserID:64,TotalFeats:32,CurrentFeats:32>>)};


% 帮会扩展返回
write(?PP_CLUB_EXTEND_UPDATE,[Level,Honor,Common,Associate]) ->
	{ok, pt:pack(?PP_CLUB_EXTEND_UPDATE,<<Level:8,Honor:8,Common:8,Associate:8>>)};

%% 帮会申请列表
write(?PP_CLUB_QUERYTRYIN,[L,Total]) ->
	N = length(L),
	F = fun([ID,Name,Career,Level,VipId,Sex,Time]) ->
				NameBin = pt:write_string(Name),
				<<ID:64,
				  VipId:8,
				  NameBin/binary,
				  Career:8,
				  Level:8,
				  Sex:8,
				  Time:32
				  >>
		end,
	LB = tool:to_binary([F([X#ets_users_guilds_request.user_id,
						   	X#ets_users_guilds_request.other_data#other_users_guilds_request.nick_name,
						   	X#ets_users_guilds_request.other_data#other_users_guilds_request.career,
						   	X#ets_users_guilds_request.other_data#other_users_guilds_request.level,
							X#ets_users_guilds_request.other_data#other_users_guilds_request.vipid,
							X#ets_users_guilds_request.other_data#other_users_guilds_request.sex,
							X#ets_users_guilds_request.request_date]) || X <- L]),
	{ok, pt:pack(?PP_CLUB_QUERYTRYIN,<<Total:32,N:32,LB/binary>>)};

write(?PP_CLUB_STORE_REQUEST_LIST,[L,Total]) ->
	N = length(L),
	F = fun({Info,Info1}) -> 
				ItemBin = pt:packet_item(Info),
				NameBin = pt:write_string(Info1#ets_guilds_items_request.other_data),
				<<ItemBin/binary,
				  NameBin/binary,
				  (Info1#ets_guilds_items_request.id):64,
				  (Info1#ets_guilds_items_request.request_date):32
				  >>
		end,
	LB = tool:to_binary([F(CInfo)|| CInfo <- L]),
	
	{ok, pt:pack(?PP_CLUB_STORE_REQUEST_LIST,<<Total:32,N:32,LB/binary>>)};


write(?PP_CLUB_STORE_MY_REQUEST_LIST,[L,Total]) ->
	N = length(L),
	F = fun({Info,Info1}) -> 
				ItemBin = pt:packet_item(Info),
				<<ItemBin/binary,
				  (Info1#ets_guilds_items_request.id):64>>
		end,
	LB = tool:to_binary([F(CInfo)|| CInfo <- L]),
	
	{ok, pt:pack(?PP_CLUB_STORE_MY_REQUEST_LIST,<<Total:32,N:32,LB/binary>>)};

%% 帮会仓库物品申请
write(?PP_CLUB_STORE_GET,[]) ->
	{ok, pt:pack(?PP_CLUB_STORE_GET,<<1:8>>)};

%% 帮会仓库物品存入
write(?PP_CLUB_STORE_PUT,[]) ->
	{ok, pt:pack(?PP_CLUB_STORE_GET,<<1:8>>)};

%% 物品审核操作
write(?PP_CLUB_STORE_CHECK,[]) ->
	{ok,pt:pack(?PP_CLUB_STORE_CHECK,<<1:8>>)};
%% 个人物品取消申请
write(?PP_CLUB_STORE_ITEM_CANCEL,[]) ->
	{ok,pt:pack(?PP_CLUB_STORE_ITEM_CANCEL,<<1:8>>)};


  
%% 职务列表更新
write(?PP_CLUB_DUTY_UPDATE,[GuildInfo,UserID,MemberType]) -> 
	{ok, pt:pack(?PP_CLUB_DUTY_UPDATE,<<
										(GuildInfo#ets_guilds.current_vice_master_member):8,
										(GuildInfo#ets_guilds.current_honorary_member):8,
										(GuildInfo#ets_guilds.total_member):8,
										(UserID):64,
										(MemberType):8
										>>)};

%% 帮会升级更新			
write(?PP_CLUB_LEVELUP_UPDATE,[Level,NC,NA,NR,CC,CA,CR]) ->
	{ok, pt:pack(?PP_CLUB_LEVELUP_UPDATE,<<
										   Level:8,
										   NC:32,
										   NA:32,
										   NR:32,
										   CC:32,
										   CA:32,
										   CR:32
										   >>)};


%% 帮会邀请
write(?PP_CLUB_INVITE,[Nick,GuildName,GuildID]) ->
	NickBin = pt:write_string(Nick),
	GuildBin = pt:write_string(GuildName),
	{ok,pt:pack(?PP_CLUB_INVITE,<<
								  NickBin/binary,
								  GuildBin/binary,
								  GuildID:64
								  >>)};

%% 帮会退出/踢出/解散关闭帮会窗体
write(?PP_CLUB_EXIT,[]) ->
	{ok, pt:pack(?PP_CLUB_EXIT,<<>>)};

%% 帮会新成员加入
write(?PP_CLUB_NEW_PLAYER_IN,[UserID,Nick]) ->
	NickBin = pt:write_string(Nick),
	{ok, pt:pack(?PP_CLUB_NEW_PLAYER_IN,<<UserID:64,NickBin/binary>>)};

%% 帮会新成员欢迎成功
write(?PP_CLUB_NEW_PLAYER_WELCOME_SUCCEED,[]) ->
	{ok, pt:pack(?PP_CLUB_NEW_PLAYER_WELCOME_SUCCEED,<<>>)};

%% 帮会转让
write(?PP_CLUB_TRANSFER,[Nick,ID]) ->
	NickBin = pt:write_string(Nick),
	{ok, pt:pack(?PP_CLUB_TRANSFER,<<
									 NickBin/binary,
									 ID:64
									 >>)};



write(?PP_CLUB_STORE_PAGEUPDATE,[L]) ->
	C = length(L),
	F = fun(Info) -> 
				pt:packet_item(Info)
		end,
	LB = tool:to_binary([F(CInfo)|| CInfo <- L]),
	{ok, pt:pack(?PP_CLUB_STORE_PAGEUPDATE,<<C:32,
											 LB/binary>>)};
	

write(?PP_CLUB_SELF_EXPLOIT_UPDATE,[Feats]) ->
	{ok, pt:pack(?PP_CLUB_SELF_EXPLOIT_UPDATE,<<Feats:32>>)};
				  

write(?PP_CLUB_ONLINE_UPDATE,[ID,LastOnlineTime,Online]) ->
	{ok, pt:pack(?PP_CLUB_ONLINE_UPDATE,<<ID:64,LastOnlineTime:32,Online:8>>)};
				  
write(?PP_CLUB_ENTER, [Res]) ->
	{ok, pt:pack(?PP_CLUB_ENTER, <<Res:8>>)};

write(?PP_CLUB_LEAVE_SCENCE, [Res]) ->
	{ok, pt:pack(?PP_CLUB_LEAVE_SCENCE, <<Res:8>>)};


write(?PP_CLUB_MEMBER_LEAVE,[TargetUserID]) ->
	{ok, pt:pack(?PP_CLUB_MEMBER_LEAVE, <<TargetUserID:64>>)};

write(?PP_CLUB_WAR_REQUEST_RESPONSE,[]) ->
	{ok, pt:pack(?PP_CLUB_WAR_REQUEST_RESPONSE, <<>>)};

write(?PP_CLUB_WAR_ENEMY_LIST_UPDATE,[EnemyList]) ->
	C = length(EnemyList),
	F =fun(X) -> 
			   {ID} = X,
			   <<ID:32>>
	   end,
	LB = tool:to_binary([F(Corp)||Corp <- EnemyList]),
	{ok, pt:pack(?PP_CLUB_WAR_ENEMY_LIST_UPDATE, <<C:32,LB/binary>>)};


write(?PP_CLUB_WEAL_UPDATE, [Weal,NeedFeats,Get, Feats,TotalFeats]) ->
	{ok, pt:pack(?PP_CLUB_WEAL_UPDATE,<<Weal:32,NeedFeats:32,Get:8,TotalFeats:32, Feats:32>>)};

%% 帮会活动召唤
write(?PP_CLUB_SUMMON, [Res,Value]) ->
	{ok, pt:pack(?PP_CLUB_SUMMON,<<Res:8,Value:32>>)};

%% 帮会召唤成功通知帮会中成员
write(?PP_CLUB_SUMMON_NOTICE,[Type,Str]) ->
	StrBin = pt:write_string(Str),
	{ok, pt:pack(?PP_CLUB_SUMMON_NOTICE, <<Type:16,StrBin/binary>>)};

%% 帮会祈福返回信息
write(?PP_CLUB_PRAYER, [Res,ItemId]) ->
	{ok, pt:pack(?PP_CLUB_PRAYER, <<Res:8,ItemId:32>>)};
%% 帮会限制次数列表
write(?PP_CLUB_LIMIT_NUM_LIST, [List]) ->
	N = length(List),
	F = fun(Info,Bin) ->
			{Type,V} = Info,
			<<Type:16,V:16,Bin/binary>>
		end,
	Bin = lists:foldl(F, <<>>, List),
	{ok, pt:pack(?PP_CLUB_LIMIT_NUM_LIST, <<N:16,Bin/binary>>)};
%% 
write(?PP_CLUB_SUMMON_NUM,[Num1,Num2,Time]) ->
	{ok, pt:pack(?PP_CLUB_SUMMON_NUM, <<Num1:16,Num2:16,Time:32>>)};
%% 帮会成员表
write(?PP_CLUB_MEMBER_LIST, [GuildInfo]) ->
	MemberList = GuildInfo#ets_guilds.other_data#other_guilds.members,
	N = length(MemberList),
		
	F = fun([ID,Name,VipId,MemberType,Career,Sex,Level,CurrentFeats,TotalFeats,OutTime,FightCapacity, Online]) ->
				NameBin = pt:write_string(Name),
				<<
				  ID:64,
				  NameBin/binary,
				  VipId:8,
				  MemberType:8,
				  Career:8,
				  Sex:8,
				  Level:8,
				  CurrentFeats:32,
				  TotalFeats:32,
				  OutTime:32,
				  FightCapacity:32,
				  Online:8
				  >>
		end,
	
	LB = tool:to_binary([F([X#ets_users_guilds.user_id,
							X#ets_users_guilds.other_data#other_users_guilds.nick_name,
						    X#ets_users_guilds.other_data#other_users_guilds.vipid,
						    X#ets_users_guilds.member_type,
						    X#ets_users_guilds.other_data#other_users_guilds.career,
						    X#ets_users_guilds.other_data#other_users_guilds.sex,
						    X#ets_users_guilds.other_data#other_users_guilds.level,
						    X#ets_users_guilds.current_feats,
						    X#ets_users_guilds.total_feats,
						    X#ets_users_guilds.other_data#other_users_guilds.last_online_time,
							X#ets_users_guilds.other_data#other_users_guilds.fight,
						    X#ets_users_guilds.other_data#other_users_guilds.online
							]) || X <- MemberList]),

	{ok, pt:pack(?PP_CLUB_MEMBER_LIST, <<(GuildInfo#ets_guilds.current_vice_master_member):32,
										 (GuildInfo#ets_guilds.current_honorary_member):32,
										 (GuildInfo#ets_guilds.total_member):32,
										 N:32,
										 LB/binary >>)};


write(?PP_CLUB_UPGRADE_DEVICE,[Suc]) ->
	{ok, pt:pack(?PP_CLUB_UPGRADE_DEVICE,<<Suc:8>>)};
			

	
%---------------------------已对--------------------------------------------------	
	

write(Cmd, _R) ->
	?WARNING_MSG("pt_21 ~s_error cmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
    {ok, pt:pack(0, <<>>)}.


write_corps_member_list([],Bin,MasterName,MasterLevel,MasterCareer) -> {Bin,MasterName,MasterLevel,MasterCareer};
write_corps_member_list([H|T],Bin,MasterName,MasterLevel,MasterCareer) ->
	NameBin = pt:write_string(H#ets_users_guilds.other_data#other_users_guilds.nick_name),
	NewBin = <<Bin/binary,
			   (H#ets_users_guilds.user_id):64,
			   NameBin/binary,
			   (H#ets_users_guilds.corp_job):8
			 >>,
	case H#ets_users_guilds.corp_job of
		?GUILD_CORP_JOB_LEADER ->
			write_corps_member_list(T,
									NewBin,
									NameBin,
									H#ets_users_guilds.other_data#other_users_guilds.level,
									H#ets_users_guilds.other_data#other_users_guilds.career);
		_ ->
			write_corps_member_list(T,
									NewBin,
									MasterName,
									MasterLevel,
									MasterCareer)
	end.
			   
		

%%
%% Local Functions
%%

