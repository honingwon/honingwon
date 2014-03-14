%%%-------------------------------------------------------------------
%%% Module  : lib_guild
%%% Author  : lxb
%%% Created : 2012-9-25
%%% Description : 帮派
%%%-------------------------------------------------------------------
-module(lib_guild).
-include_lib("stdlib/include/ms_transform.hrl").


%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").
-include("record.hrl").

%%-define(Macro, value).
%%-record(state, {}).
-define(GUILD_TRAN_CONTRIBUTION, 3000).%%开启帮会运镖扣除的帮会物资
-define(GUILD_TRAN_ACTIVITY, 75).%%开启帮会运镖扣除的帮会繁荣
-define(GUILD_REQUES_PAGE_COUNT, 6).%% 帮会申请列表每页数量

-define(GUILD_ACTIVE_RAID_TIME, 1200000). %%帮会突袭活动持续时间
%%--------------------------------------------------------------------
%% External exports
-export([
		 get_guilds_dic/0,
		 init_template_guild/0,
		 init_template_guild_furnace_level/0,
		 init_template_guild_shop_level/0,
		 init_guild/0,
		 init_guilds_day_update/1,
		 init_guild_warehouse/0,
		 init_guild_items_request/0,
		 init_leave_guilds_users/0,
		 init_guild_users_request/0,
		 init_guild_summon_template/0,
		 init_guild_prayer_template/0,
		 create_guild/12,
%% 		 create_corp/1,
		 get_guild_prayer_info/0, %%随机获取一个祈福物品
		 get_guild_info/1,
		 get_guild_info/2,
		 get_guild_list/4,
		 get_guild_users_list/1,
		 get_guild_users_request/5,		 
%% 		 get_guild_logs/2,
		 get_guild_warehouse_logs/2,
		 get_guild_info_and_member/3,
%% 		 get_guild_corps_list/1,
		
		 
		 agree_guild_users_request/6,
		 disagree_guild_users_request/6,
		 agree_guild_users_invite/5,
		 clear_guild_users_request/3,
		 
		 contribution_money/3,
		 add_guild_feats/4,
%% 		 contribution/6,
		 
		 request_join_guild/4,
		 invite_join_guild/5,
%% 		 invite_join_corp/6,
		 
		 leave_guild/1,
		 kick_guild_user/5,
		 disband_guild/3,
		 
		 edit_guild_declaretion/4,
		 get_guild_declaretion/3,

%% 		 get_guild_extend_info/2,
		 get_guild_levelup_info/2,
		 get_guild_users_list_info/2,
		 get_guild_summon_num/2,
		 get_guild_user_info/3,
		 
%% 		 update_guild_member_setting/4,
		 demise_chief/5,
		 agree_demise_chief/5,
		 update_guild_level_setting/4,
		 update_guild_device_level/5,
		 update_guild_summon/5,
%% 		 create_log/2,
%% 		 create_log_and_return/2,
%% 		 edit_corps_declaration/4,
%% 		 set_corp_leader/5,
%% 		 kick_corp_user/4,
%% 		 edit_corp_name/5,
		 get_item_list_in_guild_warehouse/4,
		 create_warehouse_log/3,
		 
		 get_mails_total_count/1,
		 check_mail_send/5,
		 send_guild_member_online/6,
		 
%% 		 guild_transport/1,
%% 		 check_guild_transport/1,
%% 		 check_guild_transport_cast/3,
		
		 get_guild_info_for_user/1,
		 member_level_up/2,
		 get_guild_map_info/1,
		 get_guild_level/1,
		 guild_task_award/6,
		 edit_guild_user_member_type/5,
		 
		 club_war_declear_init/5,
		 club_war_deal_init/5,
		 club_war_enemy_init/5,
		 club_war_declear/7,
		 club_war_deal/7,
		 club_war_stop/6,
		 
		 send_stop_war_to_all/0,
		 send_stop_war_to_all_local/0,
		 
		 club_weal_update/4,
		 get_club_weal/5,
		 reduce_guild_user_feats/6,
		 get_guild_user_feats_use_timers/3,
		 pub_get_guild_user_feats_use_timers/2,
%% 		 get_item_in_guild_warehouse/5,
%% 		 get_item_in_guild_warehouse_refresh/7,
		 put_item_in_guild_warehouse/2,
		 put_item_in_guild_warehouse_refresh/7,
		 
		 get_guild_user_info/2,
		 get_guild/1,
		 change_guild_money/3,
		 
		 
		 check_guild_name_isexist/1,
		 open_active_summon_monster/1,
		 
		 get_guild_item_request_all/4,
		 get_guild_item_request/4,
		 request_guild_item/4,
		 invite_guild_item/6,
		 cancel_guild_item_request/4
		 ]).

%%====================================================================
%% External functions
%%====================================================================
%% 进程字典辅助方法

get_users_guilds_dic() ->
	case get(?DIC_USERS_GUILDS) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

get_users_guild(ID) ->
	L = get_users_guilds_dic(),
	case lists:keyfind(ID, #r_users_guilds.user_id, L) of
		false ->
			[];
		User ->
			User
	end.

update_users_guild(Info) ->
	case is_record(Info, r_users_guilds) of
		true ->
			List = get_users_guilds_dic(),
			List1 = lists:keydelete(Info#r_users_guilds.user_id, #r_users_guilds.user_id, List),
			put(?DIC_USERS_GUILDS, [Info|List1]);
		_ ->
			?WARNING_MSG("update_users_guild:~w",[Info])
	end,
	ok.

delete_users_guilds_by_id(ID) ->
	List = get_users_guilds_dic(),
	List1 = lists:keydelete(ID, #r_users_guilds.user_id, List),
	put(?DIC_USERS_GUILDS, List1),
	ok.
	
%% delete_users_guilds(Info) ->
%% 	case is_record(Info, r_users_guilds) of
%% 		true ->
%% 			List = get_users_guilds_dic(),
%% 			List1 = lists:keydelete(Info#r_users_guilds.user_id, #r_users_guilds.user_id, List),
%% 			put(?DIC_USERS_GUILDS, List1);
%% 		_ ->
%% 			?WARNING_MSG("delete_users_guild:~w",[Info])
%% 	end,
%% 	ok.



%% 帮会
get_guilds_dic() ->
	case get(?DIC_GUILDS) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

sort_guilds_dic() ->
	F = fun(V1,V2) ->
				if V1#ets_guilds.guild_level > V2#ets_guilds.guild_level ->
					   true;
				   V1#ets_guilds.guild_level =:= V2#ets_guilds.guild_level ->
					   if
						   V1#ets_guilds.money > V2#ets_guilds.money ->
							   true;
						   V1#ets_guilds.money =:= V2#ets_guilds.money ->
							   V1#ets_guilds.create_date < V2#ets_guilds.create_date;
						   true ->
							   false
					   end;
				   true ->
					   false
				end
		end,
	L = get_guilds_dic(),
	NL = lists:sort(F,L),
	put(?DIC_GUILDS, NL).

get_guild(ID) ->
	L = get_guilds_dic(),
	case lists:keyfind(ID, #ets_guilds.id, L) of
		false ->
			[];
		GuildInfo ->
			GuildInfo
	end.

get_guild_item_request_by_guild_id(GuildID)->
	DicRequestName = lists:concat([guilds_item_request_,GuildID]),
	case get(DicRequestName) of
			   undefined ->
				   [];
			   DicL ->
				   DicL
		   end.

get_guild_item_request_by_id(GuildID,ID)->
	List = get_guild_item_request_by_guild_id(GuildID),
	
	case lists:keyfind(ID, #ets_guilds_items_request.id, List) of
		false ->
			[];
		Info ->
			Info
	end.
	

get_guild_item_request_by_user_id(GuildID,UserID)->
	List = get_guild_item_request_by_guild_id(GuildID),
	
	F = fun(Request,L) ->
				case Request#ets_guilds_items_request.user_id =:= UserID of
					true ->
						[Request|L];
					_ ->
						L
				end
		end,
	lists:foldr(F,[],List).	

get_guild_item_request_by_item_id(GuildID,ItemID)->
	List = get_guild_item_request_by_guild_id(GuildID),
	
	F = fun(Request,L) ->
				case Request#ets_guilds_items_request.item_id =:= ItemID of
					true ->
						[Request|L];
					_ ->
						L
				end
		end,
	lists:foldr(F,[],List).	

get_guild_item_request_by_user_item_id(GuildID,UserID,ItemID)->
	List = get_guild_item_request_by_guild_id(GuildID),
	F = fun(Request,L) ->
				case Request#ets_guilds_items_request.item_id =:= ItemID andalso Request#ets_guilds_items_request.user_id =:= UserID of
					true ->
						[Request|L];
					_ ->
						L
				end
		end,
	NewLIst = lists:foldl(F,[],List),
	NewLIst.

		
update_guild_item_request_dic(GuildID,List,Sort) ->
	NewList = case Sort of
				  true ->
					  F = fun(V1,V2) -> V1#ets_guilds_items_request.request_date  > V2#ets_guilds_items_request.request_date  end,
					  lists:sort(F,List);
				  _ ->
					  List
			  end,

	DicRequestName = lists:concat([guilds_item_request_,GuildID]),
	put(DicRequestName,NewList).

delete_guild_item_request_by_id(GuildID,ID) ->
	List = get_guild_item_request_by_guild_id(GuildID),
	NewList = lists:keydelete(ID, #ets_guilds_items_request.id, List),
	update_guild_item_request_dic(GuildID,NewList,false).

delete_guild_item_request_by_user_id(GuildID,UserID) ->
	List = get_guild_item_request_by_guild_id(GuildID),
	F = fun(Request,L) ->
				case Request#ets_guilds_items_request.user_id =:= UserID of
					true ->
						L;
					_ ->
						[Request|L]
				end
		end,
	db_agent_guild:update_guilds_items_request([{is_exist,0}],[{user_id,UserID}]),
	NewList = lists:foldr(F,[],List),
	update_guild_item_request_dic(GuildID,NewList,false).

delete_guild_item_request_by_item_id(GuildID,ItemID) ->
	List = get_guild_item_request_by_guild_id(GuildID),
	F = fun(Request,L) ->
				case Request#ets_guilds_items_request.item_id =:= ItemID of
					true ->
						L;
					_ ->
						[Request|L]
				end
		end,
	db_agent_guild:update_guilds_items_request([{is_exist,0}],[{item_id,ItemID}]),
	NewList = lists:foldr(F,[],List),
	update_guild_item_request_dic(GuildID,NewList,false).

get_guild_prayer_info() ->
	[Record] = ets:lookup(?ETS_GUILD_PRAYER_LIST, 1),
	MaxRate = Record#ets_guild_prayer_list.max_rate,
	RateNum = util:rand(1, MaxRate),
	case get_guild_prayer_info1(Record#ets_guild_prayer_list.list, RateNum) of
		0 ->
			[H|_] = Record#ets_guild_prayer_list.list,
				H#ets_guild_prayer_template.item_id;
		ItemId ->
			ItemId
	end.

get_guild_prayer_info1([],_RateNum) ->
	0;
get_guild_prayer_info1([H|L],RateNum) ->
	if
		H#ets_guild_prayer_template.rate =< RateNum ->
			H#ets_guild_prayer_template.item_id;
		true ->
			get_guild_prayer_info1(L,RateNum)
	end.
	

get_guild_user_info(GuildID, UserID) ->
	case get_guild(GuildID) of
		[] ->
			[];
		GuildInfo ->
			get_guild_user_info1(GuildInfo#ets_guilds.other_data#other_guilds.members, UserID)
	end.

get_guild_user_info1(MemberList, UserID) ->
	case lists:keyfind(UserID, #ets_users_guilds.user_id, MemberList) of
		false ->
			[];
		MemberInfo ->
			MemberInfo
	end.

%% 更改公会财富
change_guild_money(GuildId, Money, Type) ->
	case get_guild(GuildId) of
		[] ->
			{error, "no guile"};
		GuildInfo ->
			if GuildInfo#ets_guilds.money < Money andalso Type =:= reduce ->
				{error, "not enough money"};
			true ->
				if Type =:= add ->
					NewMoney = GuildInfo#ets_guilds.money + Money;
				Type =:= reduce ->
					NewMoney = GuildInfo#ets_guilds.money - Money;
				true ->
					NewMoney = GuildInfo#ets_guilds.money
				end,
				NewGuild = GuildInfo#ets_guilds{money = NewMoney},
				db_agent_guild:update_guild([{money,NewMoney}],[{id,NewGuild#ets_guilds.id}]),					
				update_guilds_dic(NewGuild),
				ok
			end
	end.

%% 因为需要排行，不能随意打乱顺序
update_guilds_dic(Info) ->
	case is_record(Info, ets_guilds) of
		true ->
			List = get_guilds_dic(),
			List1 = case lists:keymember(Info#ets_guilds.id, #ets_guilds.id, List) of
						false ->%% 新插入的需要放在最后
							List ++ [Info];
						_ ->
							lists:keyreplace(Info#ets_guilds.id, #ets_guilds.id, List, Info)
					end,
			put(?DIC_GUILDS, List1);
		_ ->
			?WARNING_MSG("update_guild_dic:~w",[Info])
	end,
	ok.

update_guilds_member(Member, NeedSort) ->
	case is_record(Member, ets_users_guilds) of
		true ->
			case get_guild(Member#ets_users_guilds.guild_id) of
				[] ->
					ok;
				GuildInfo ->
					update_guilds_member1(GuildInfo,Member,NeedSort)
			end;
		_ ->
			?WARNING_MSG("update_guild_member:~w",[Member])
	end,
	ok.

update_guilds_member1(GuildInfo, Member, NeedSort) -> 
	List = GuildInfo#ets_guilds.other_data#other_guilds.members,
	List1 = case lists:keymember(Member#ets_users_guilds.user_id,#ets_users_guilds.user_id,List) of
				false ->
					List ++ [Member];
				_ ->
					TmpL = lists:keyreplace(Member#ets_users_guilds.user_id,#ets_users_guilds.user_id,List,Member),
					if NeedSort =:= true ->
						   sort_guilds_member_dic(TmpL);
					   true ->
						   TmpL
					end
			end,	
	OtherData = GuildInfo#ets_guilds.other_data#other_guilds{members = List1},
	update_guilds_dic(GuildInfo#ets_guilds{other_data = OtherData}).


sort_guilds_member_dic(L) ->
	F = fun(V1,V2) ->
				V1#ets_users_guilds.member_type < V2#ets_users_guilds.member_type
		end,
	lists:sort(F,L).


delete_guilds_member(Member) ->
	case is_record(Member, ets_users_guilds) of
		true ->
			case get_guild(Member#ets_users_guilds.guild_id) of
				[] ->
					ok;
				GuildInfo ->
					delete_guilds_member1(GuildInfo,Member)
			end;
		_ ->
			?WARNING_MSG("update_guild_member:~w",[Member])
	end,
	ok.

delete_guilds_member1(GuildInfo, Member) ->
	List = lists:keydelete(Member#ets_users_guilds.user_id,
						   #ets_users_guilds.user_id, 
						   GuildInfo#ets_guilds.other_data#other_guilds.members),
	OtherData = GuildInfo#ets_guilds.other_data#other_guilds{members = List},
	update_guilds_dic(GuildInfo#ets_guilds{other_data = OtherData}).


%% update_guilds_corps(Corp) ->
%% 	case is_record(Corp, ets_guilds_corps) of
%% 		true ->
%% 			case get_guild(Corp#ets_guilds_corps.guild_id) of
%% 				[] ->
%% 					ok;
%% 				GuildInfo ->
%% 					update_guilds_corps1(GuildInfo, Corp)
%% 			end;
%% 		_ ->
%% 			?WARNING_MSG("update_guild_corp:~w",[Corp])
%% 	end,
%% 	ok.

%% update_guilds_corps1(GuildInfo, Corp) ->
%% 	List = lists:keydelete(Corp#ets_guilds_corps.id,
%% 						   #ets_guilds_corps.id,
%% 						   GuildInfo#ets_guilds.other_data#other_guilds.guilds_corps),
%% 	List1 = [Corp|List],
%% 		OtherData = GuildInfo#ets_guilds.other_data#other_guilds{guilds_corps = List1},
%% 	update_guilds_dic(GuildInfo#ets_guilds{other_data = OtherData}).

delete_guilds_dic(GuildId) ->
	List = get_guilds_dic(),
	List1 = lists:keydelete(GuildId, #ets_guilds.id, List),
	put(?DIC_GUILDS, List1),
	ok.

%% 获得离开了帮会的记录
get_leave_guilds_dic() ->
	case get(?DIC_LEAVE_GUILDS_USERS) of
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

get_leave_guilds(UserID) ->
	L = get_leave_guilds_dic(),
	case lists:keyfind(UserID, #ets_users_guilds.user_id, L) of
		false ->
			[];
		User ->
			User
	end.

update_leave_guilds_dic(Info) ->
	case is_record(Info, ets_users_guilds) of
		true ->
			List = get_leave_guilds_dic(),
			List1 = lists:keydelete(Info#ets_users_guilds.user_id, #ets_users_guilds.user_id, List),
			put(?DIC_LEAVE_GUILDS_USERS, [Info|List1]);
		_ ->
			?WARNING_MSG("update_guild_dic:~w",[Info])
	end,
	ok.

delete_leave_guilds_dic(Info) ->
	List = get_leave_guilds_dic(),
	List1 = lists:keydelete(Info#ets_users_guilds.user_id, #ets_users_guilds.user_id, List),
	put(?DIC_LEAVE_GUILDS_USERS, List1).

%%=====================帮会申请======================

get_guilds_request_dic() ->
	case get(?DIC_USERS_GUILDS_REQUEST) of
		undefined ->
			[];
		List when is_list(List)->
			List;
		_ ->
			[]
	end.

get_guild_request_by_guildid(GuildID) ->
	L = get_guilds_request_dic(),
	F = fun(Info) ->
				if Info#ets_users_guilds_request.guild_id =:= GuildID ->
					   true;
				   true ->
					   false
				end
		end,
	lists:filter(F, L).

get_guild_request(GuildID, UserID) ->
	L = get_guilds_request_dic(),
	F = fun(Info) ->
				if Info#ets_users_guilds_request.user_id =:= UserID andalso 
													 Info#ets_users_guilds_request.guild_id =:= GuildID ->
					   true;
				   true ->
					   false
				end
		end,
	lists:filter(F, L).

update_guilds_request(Request) ->
	case is_record(Request, ets_users_guilds_request) of
		true ->
			update_guilds_request1(Request);
		_ ->
			?WARNING_MSG("update_guild_request:~w",[Request])
	end,
	ok.
  
update_guilds_request1(Request) ->
	L = get_guilds_request_dic(),
	F = fun(Info) ->
				if Info#ets_users_guilds_request.user_id =:= Request#ets_users_guilds_request.user_id andalso
					 Info#ets_users_guilds_request.guild_id =:= Request#ets_users_guilds_request.guild_id ->
					   false;
				   true ->
					   true
				end
		end,
	List = lists:filter(F,L),
	List1 = [Request|List],
	put(?DIC_USERS_GUILDS_REQUEST, List1).


delete_guilds_request_by_request(GuildID, UserID) ->
	L = get_guilds_request_dic(),
	F = fun(Info) ->
				if Info#ets_users_guilds_request.user_id =:= UserID andalso
					 Info#ets_users_guilds_request.guild_id =:= GuildID ->
					   false;
				   true ->
					   true
				end
		end,
	List = lists:filter(F,L),
	put(?DIC_USERS_GUILDS_REQUEST, List).

delete_guilds_request_by_guildid(GuildID) ->
	L = get_guilds_request_dic(),
	F = fun(Info) ->
				if Info#ets_users_guilds_request.guild_id =:= GuildID ->
					   false;
				   true ->
					   true
				end
		end,
	List = lists:filter(F,L),
	put(?DIC_USERS_GUILDS_REQUEST, List).

delete_guilds_request_by_userid(UserID) ->
	L = get_guilds_request_dic(),
	F = fun(Info) ->
				if Info#ets_users_guilds_request.user_id =:= UserID ->
					   false;
				   true ->
					   true
				end
		end,
	List = lists:filter(F,L),
	put(?DIC_USERS_GUILDS_REQUEST, List).

%======================================

%帮会模板
init_template_guild() ->
	F = fun(Guild) ->
		GuildInfo = list_to_tuple([ets_guilds_template] ++ Guild),	
  		ets:insert(?ETS_GUILD_TEMPLATE, GuildInfo)
	end,
	L = db_agent_template:get_guilds_template(),
	lists:foreach(F, L),
	ok.

%帮会活动召唤模版
init_guild_summon_template() ->
	F = fun(Info) ->
		Record = list_to_tuple([ets_guild_summon_template] ++ Info),
		SummonList = tool:split_string_to_intlist(Record#ets_guild_summon_template.summon_list),
		NewRecord = Record#ets_guild_summon_template{summon_list = SummonList},
		ets:insert(?ETS_GUILD_SUMMON_TEMPLATE, NewRecord)
		end,
	L = db_agent_template:get_guild_summon_template(),
	lists:foreach(F, L),
	ok.
%帮会祈福模版
init_guild_prayer_template() ->
	F = fun(Info,{List,MaxRate}) ->
			Record = list_to_tuple([ets_guild_prayer_template] ++ Info),
			NewMaxRate = MaxRate + Record#ets_guild_prayer_template.rate,
			NewRecord = Record#ets_guild_prayer_template{rate = NewMaxRate},
			{[NewRecord|List], NewMaxRate}
		end,
	L = db_agent_template:get_guild_prayer_template(),
	{List,MaxRate} = lists:foldl(F, {[],0}, L),
	PList = #ets_guild_prayer_list{id = 1, max_rate = MaxRate, list = List},
	ets:insert(?ETS_GUILD_PRAYER_LIST, PList),
	ok.
%帮会神炉等级模板
init_template_guild_furnace_level() ->
	F = fun(Guild) ->
		Info = list_to_tuple([ets_guilds_furnace_leve_template] ++ Guild),	
  		ets:insert(?ETS_FURNACE_LEVEL_TEMPLATE, Info)
	end,
	L = db_agent_template:get_guilds_furnace_leve_template(),
	lists:foreach(F, L),
	ok.

%帮会商城等级模板
init_template_guild_shop_level() ->
	F = fun(Guild) ->
		Info = list_to_tuple([ets_guilds_shop_leve_template] ++ Guild),	
  		ets:insert(?ETS_SHOP_LEVEL_TEMPLATE, Info)
	end,
	L = db_agent_template:get_guilds_shop_leve_template(),
	lists:foreach(F, L),
	ok.

%加载帮会
init_guild() ->
	F = fun(Guild) ->
				GuildInfo = list_to_tuple([ets_guilds] ++ Guild),
				MemberList = init_guilds_users(GuildInfo#ets_guilds.id),
				Other_Data = #other_guilds{
										   members = MemberList
										   },
				update_guilds_dic(GuildInfo#ets_guilds{other_data = Other_Data})
		end,
	L = ?DB_MODULE:select_all(t_guilds,"*",[],[],[]),
	lists:foreach(F,L),
	sort_guilds_dic(),
	ok.

%% %加载军团信息
%% init_guild_corps(GuildID) ->
%% 	F = fun(Corp) ->
%% 				list_to_tuple([ets_guilds_corps] ++ Corp)
%% 		end,
%% 	L = ?DB_MODULE:select_all(t_guilds_corps,"*",[{guild_id,GuildID}],[],[]),
%% 	[F(X) || X <- L].

%加载帮会成员信息
init_guilds_users(GuildID) ->
	F = fun(Member, L) ->
				NewMember = list_to_tuple([ets_users_guilds] ++ Member),
				case lib_player:get_player_info_guild_use_by_id(NewMember#ets_users_guilds.user_id) of
					{UserName, Career, Level,VipId,Sex, Fight,LastOnlineTime,Online} ->
						OtherData = #other_users_guilds{
														nick_name = UserName,
														career = Career,
														level = Level,
														vipid = VipId,
														sex = Sex,
														fight = Fight,
														last_online_time = LastOnlineTime,
														online = Online
														},
						update_users_guild(#r_users_guilds{guild_id = NewMember#ets_users_guilds.guild_id,
														   user_id = NewMember#ets_users_guilds.user_id}),
						[NewMember#ets_users_guilds{other_data = OtherData}|L];
					_ ->
						L
				end
		end,
	L = ?DB_MODULE:select_all(t_users_guilds, "*", [{guild_id, GuildID},{is_exists,1}], [{member_type,desc}], []),
	lists:foldl(F,[],L).

%加载帮会申请/邀请信息
init_guild_users_request() ->
	F = fun(Member) ->
				NewMember = list_to_tuple([ets_users_guilds_request] ++ Member),
				case lib_player:get_player_info_guild_use_by_id(NewMember#ets_users_guilds_request.user_id) of
					{UserName, Career, Level,VipId,Sex,  Fight,LastOnlineTime,Online} ->
						OtherData = #other_users_guilds_request{
																nick_name = UserName,
																career = Career,
																level = Level,
																vipid = VipId,
																sex = Sex,
																online = Online
																},
						update_guilds_request(NewMember#ets_users_guilds_request{other_data = OtherData});
					_ ->
						skip
				end
		end,
	L = ?DB_MODULE:select_all(t_users_guilds_request, "*", [], [], []),
	lists:foreach(F,L),
	ok.

%加载帮会的仓库信息，使用进程字典
init_guild_warehouse() ->
	F = fun(Item) ->
				NewItem = list_to_tuple([ets_guilds_items] ++ Item),
				case db_agent_item:get_item_by_itemid(NewItem#ets_guilds_items.item_id) of
			  		[] -> 
				  		skip;
			  		I -> 
						NI = list_to_tuple([ets_users_items | I]),
						DicWareName = lists:concat([guilds_warehouse_,NewItem#ets_guilds_items.guild_id]),
						OldL = 
							case get(DicWareName) of
								undefined ->
									[];
								DicL ->
									DicL
							end,
						NewL = [NewItem#ets_guilds_items{other_data=NI#ets_users_items{other_data=#item_other{}}}|OldL],
						F1 = fun(V1,V2) -> V1#ets_guilds_items.put_date < V2#ets_guilds_items.put_date end,
						LSort = lists:sort(F1,NewL),
						put(DicWareName,LSort)
		  		end
		end,
 	L = db_agent_guild:get_guild_warehouse_all(),
	lists:foreach(F,L),
	ok.

%% 加载帮会的仓库申请列表
init_guild_items_request()->
	F = fun(Record) ->
			Request = list_to_tuple([ets_guilds_items_request] ++ Record),
			NickName = case lib_player:get_player_info_guild_use_by_id(Request#ets_guilds_items_request.user_id) of
					{UserName, _Career, _Level,_VipId,_Sex,_,_, _Online} ->
						UserName;
					_ ->
						""
				end,
			Request1 = Request#ets_guilds_items_request{ other_data = NickName},
			DicWareName = lists:concat([guilds_item_request_,Request1#ets_guilds_items_request.guild_id]),
			OldL = 
				case get(DicWareName) of
					undefined ->
						[];
					DicL ->
						DicL
				end,
			NewL = [Request1|OldL],
			put(DicWareName,NewL)
				
	end,
	L = db_agent_guild:get_guild_items_request_all(),
	lists:foreach(F,L),
	ok.

%% 加载离开了帮会的人的信息
init_leave_guilds_users() ->
	F = fun(Record) ->
				LeaveMember = list_to_tuple([ets_users_guilds] ++ Record),
				Other = #other_users_guilds{},
		   		NewLeaveMember = LeaveMember#ets_users_guilds{other_data = Other},
				update_leave_guilds_dic(NewLeaveMember)
		end,
	L = ?DB_MODULE:select_all(t_users_guilds, "*", [{is_exists,0}], [], []),
	lists:foreach(F,L).

init_guilds_day_update(Is_Init) ->
	
	List1 = get_guilds_dic(),
	Now = misc_timer:now_seconds(),
	if Is_Init =:= 0 ->
			Next_Tike = ?ONE_DAY_SECONDS;
		true ->
			Next_Tike = ?ONE_DAY_SECONDS - util:get_today_current_second()
			%?DEBUG("init_guilds_day_update :~p",[Next_Tike])
	end,	
	erlang:send_after(Next_Tike * 1000, self(), {guilds_day_update}),
	
	F = fun(GuildInfo,{List,UpList}) ->
%% 			NewOther = if Is_Init =:= 0 ->
%% 					MList = reset_prayer_num(GuildInfo#ets_guilds.other_data#other_guilds.members),
%% 					GuildInfo#ets_guilds.other_data#other_guilds{members = MList};
%% 				true ->
%% 					GuildInfo#ets_guilds.other_data
%% 			end,
			Res = util:is_same_date(Now,GuildInfo#ets_guilds.last_send_date),
			if
				GuildInfo#ets_guilds.last_send_date =/= 0 andalso Res =:= false ->					
					NewGuildInfo = GuildInfo#ets_guilds{last_send_date = 0,today_send_mails = 0,summon_collect_num = 0,summon_monster_num = 0},
					{[NewGuildInfo|List],[GuildInfo#ets_guilds.id|UpList]};
				true ->
					{[GuildInfo|List],UpList}
			end
		end,
	{NewList,UList} = lists:foldr(F, {[],[]}, List1),
	put(?DIC_GUILDS, NewList),
	if UList =/= [] ->
			db_agent_guild:update_guilds_day_data(UList);
		true ->
			ok
	end.

reset_prayer_num(List) ->
	F = fun(Info,L) ->
			NewOther = Info#ets_users_guilds.other_data#other_users_guilds{prayer_num = 0},
			[Info#ets_users_guilds{other_data = NewOther}|L]
		end,
	lists:foldl(F, [], List).

%=========================================================

%% 获取帮会仓库内容列表
get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex, PidSend)->
	case get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex) of
		{ok,L} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_PAGEUPDATE,[L]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex)->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			DicWareName = lists:concat([guilds_warehouse_,Member#ets_users_guilds.guild_id]),
			Other_Data = Member#ets_users_guilds.other_data#other_users_guilds{warehouse_pageindex=PageIndex},
			update_guilds_member(Member#ets_users_guilds{other_data=Other_Data},false),
			case get(DicWareName) of
				undefined ->
					{ok,[]};
				DicL ->
					get_item_list_in_guild_warehouse1(DicL,PageIndex)
			end
	end.

get_item_list_in_guild_warehouse1(L,PageIndex) ->
	CountL = length(L),
	CutIndex = (PageIndex - 1) * ?GUILD_WAREHOUSE_PAGE_SIZE,
	if CountL < CutIndex ->
		   {ok,[]};
	   true ->
		   if CountL - CutIndex > ?GUILD_WAREHOUSE_PAGE_SIZE ->
				  get_item_list_in_guild_warehouse2(lists:sublist(L, CutIndex + 1, ?GUILD_WAREHOUSE_PAGE_SIZE));
			 true ->
				 get_item_list_in_guild_warehouse2(lists:nthtail(CutIndex,L))
			end
	end.

get_item_list_in_guild_warehouse2(L) ->
	F = fun(Info) ->
				Info#ets_guilds_items.other_data
		end,
	T = [F(X) || X <- L],
	{ok,T}.


%% -----------------------申请列表 start---------------------------
%% 获取申请列表
get_guild_item_request_all(GuildID,UserID,PageIndex,PidSend)->
	case get_guild_item_request_all(GuildID, UserID,PageIndex) of
		{Count,L} ->
			DicWareName = lists:concat([guilds_warehouse_,GuildID]),
			DicL = case get(DicWareName) of
					   undefined ->
						   [];
					   DicL1 ->
						   DicL1
				   end,
			F = fun(Info, List) ->
					case lists:keyfind(Info#ets_guilds_items_request.item_id, #ets_guilds_items.item_id, DicL) of
						false ->
							List;
						GuildItem ->
							[{GuildItem#ets_guilds_items.other_data,Info}|List]
					end
				end,
			NewList = lists:foldr(F, [], L),
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_REQUEST_LIST,[NewList,Count]),
			lib_send:send_to_sid(PidSend,Bin);
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILD_ERROR_TRYIN_NULL])
	end.

get_guild_item_request_all(GuildID, UserID,PageIndex)->
	case get_guild_user_info(GuildID, UserID) of
		[] -> 
			[];
		Member->
			if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
				Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT	->
				   L = get_guild_item_request_by_guild_id(GuildID),
				   get_guild_item_request_all(L,PageIndex);
			   true ->
				   []
			end
	end.

get_guild_item_request_all(L,PageIndex) ->
	CountL = length(L),
	CutIndex = (PageIndex - 1) * ?GUILD_REQUES_PAGE_COUNT,
	if CountL < CutIndex ->
		   [];
	   true ->
		   if CountL - CutIndex > ?GUILD_REQUES_PAGE_COUNT ->
				  {CountL,lists:sublist(L, CutIndex + 1, ?GUILD_REQUES_PAGE_COUNT)};
			 true ->
				 {CountL,lists:nthtail(CutIndex,L)}
			end
	end.

%% -----------------------申请列表 end---------------------------

%% 获取个人申请列表
get_guild_item_request(GuildID,UserID,PageIndex,PidSend)->
	case get_guild_item_request(GuildID, UserID,PageIndex) of
		{Count,L} ->
			DicWareName = lists:concat([guilds_warehouse_,GuildID]),
			DicL = get(DicWareName),
			F = fun(Info, List) ->
					case lists:keyfind(Info#ets_guilds_items_request.item_id, #ets_guilds_items.item_id, DicL) of
						false ->
							List;
						GuildItem ->
							[{GuildItem#ets_guilds_items.other_data,Info}|List]
					end
				end,
			NewList = lists:foldr(F, [], L),
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_MY_REQUEST_LIST,[NewList,Count]),
			lib_send:send_to_sid(PidSend,Bin);
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILD_ERROR_TRYIN_NULL])
	end.

get_guild_item_request(GuildID, UserID,PageIndex)->
	case get_guild_user_info(GuildID, UserID) of
		[] -> 
			[];
		_Member->
			L = get_guild_item_request_by_user_id(GuildID,UserID),
			get_guild_item_request(L,PageIndex)
	end.

get_guild_item_request(L,PageIndex) ->
	CountL = length(L),
	CutIndex = (PageIndex - 1) * ?GUILD_REQUES_PAGE_COUNT,
	if CountL < CutIndex ->
		   [];
	   true ->
		   if CountL - CutIndex > ?GUILD_REQUES_PAGE_COUNT ->
				  {CountL,lists:sublist(L, CutIndex + 1, ?GUILD_REQUES_PAGE_COUNT)};
			 true ->
				 {CountL,lists:nthtail(CutIndex,L)}
			end
	end.


%% -----------------------申请物品 start---------------------------
%% 申请物品
request_guild_item(GuildID,UserID,ItemID,PidSend)->
	case request_guild_item1(GuildID, UserID, ItemID) of
		{ok} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_GET,[]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg]);
		{false,_Msg,PageIndex} ->
			case get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex) of
				{ok,L1} ->
					{ok,Bin} = pt_21:write(?PP_CLUB_STORE_PAGEUPDATE,[L1]),
					lib_send:send_to_sid(PidSend,Bin);
				{false,_Msg1} ->
					lib_chat:chat_sysmsg_pid([PidSend,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 _Msg1])
			end
	end.

request_guild_item1(GuildID, UserID, ItemID)->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			PageIndex = Member#ets_users_guilds.other_data#other_users_guilds.warehouse_pageindex,
			request_guild_item2(GuildID,UserID, ItemID,PageIndex)
	end.

request_guild_item2(GuildID,UserID,ItemID,PageIndex) ->
	case get_guild_item_request_by_user_item_id(GuildID,UserID,ItemID) of
		[] ->
			case request_guild_item3(GuildID,UserID, ItemID) of
				{ok} ->
					{ok};
				{false, Msg} ->
					{false, Msg, PageIndex}
			end;
		_ ->			
			{false,?_LANG_GUILD_ERROR_ITEM_REQUEST_HAS}
	end.

request_guild_item3(GuildID,UserID,ItemID) ->
	OldL = get_guild_item_request_by_guild_id(GuildID),
	NickName = case lib_player:get_player_info_guild_use_by_id(UserID) of
					{UserName, _Career, _Level,_VipId,_Sex,_,_, _Online} ->
						UserName;
					_ ->
						""
				end,
	Item = #ets_guilds_items_request{user_id = UserID,
											 item_id = ItemID,
											 guild_id = GuildID,
											 request_date = misc_timer:now_seconds(),
											 is_exist = 1
											},
	
			
	%% 插入数据库
	db_agent_guild:insert_guilds_items_request(Item),
	DBNewItem = db_agent_guild:get_guild_items_request_by_condition([{item_id, ItemID},{user_id, UserID},{is_exist, 1}]),
	DBNewItemInfo = list_to_tuple([ets_guilds_items_request] ++ DBNewItem),
    DBNewItemInfo1 = DBNewItemInfo#ets_guilds_items_request{other_data = NickName},
	NewL = [DBNewItemInfo1|OldL],
	update_guild_item_request_dic(GuildID,NewL,false),
	{ok}.


%% -----------------------申请物品 end---------------------------



%% -----------------------审核物品 start---------------------------
invite_guild_item( GuildID,UserID,Nick, RequestId,Type,PidSend) ->
	case invite_guild_item(GuildID,UserID, Nick,Type, RequestId) of
		{ok,0,_PageIndex} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_CHECK,[]),
			lib_send:send_to_sid(PidSend,Bin);
		{ok,1,PageIndex} ->
			{ok,Bin1} = pt_21:write(?PP_CLUB_STORE_CHECK,[]),
			 lib_send:send_to_sid(PidSend,Bin1),
			 case get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex) of
				{ok, L} ->
					{ok,Bin} = pt_21:write(?PP_CLUB_STORE_PAGEUPDATE,[L]),
					lib_send:send_to_sid(PidSend,Bin);
				{false,_Msg1} ->
							lib_chat:chat_sysmsg_pid([PidSend,
											 		 ?FLOAT,
											 		 ?None,
											 		 ?ORANGE,
													 _Msg1])   
			 end;
		{false,_Msg1} ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 _Msg1])
	end.

invite_guild_item( GuildID,UserID,  Nick,Type,RequestId) ->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			invite_guild_item1(Member, Nick, GuildID, UserID,Type, RequestId)
	end.

invite_guild_item1(Member, Nick, GuildID, UserID,Type, RequestId) ->
	case get_guild_item_request_by_id(GuildID,RequestId) of
		[] ->
			{false,?_LANG_GUILD_ERROR_ITEM_REQUEST_NONE};
		Info ->
			
			if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
				Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT ->
				   invite_guild_item2(Member, Nick, GuildID, UserID, RequestId,Info,Type);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
			end
	end.

invite_guild_item2(Member,Nick, GuildID, UserID,RequestId,Info,Type) ->

	%% 发送物品
	case Type of
		0 ->
			db_agent_guild:update_guilds_items_request([{is_exist,0}],[{id,RequestId}]),
			delete_guild_item_request_by_id(GuildID,RequestId),
			Content = ?GET_TRAN(?_LANGUAGE_GUILD_MAIL_CONTENT_FAIL, [Nick]),
			
			lib_mail:send_sys_mail(Nick, UserID,Info#ets_guilds_items_request.other_data , Info#ets_guilds_items_request.user_id ,[], ?MAIL_TYPE_GUILD_BROAD, ?_LANGUAGE_GUILD_MAIL_TITLE,Content, 0, 0, 0, 0);
		1 ->
			invite_guild_item3( GuildID, UserID,Nick,Info),
			delete_guild_item_request_by_item_id(GuildID,Info#ets_guilds_items_request.item_id);
		_ ->
		   skip
	end,
	{ok,Type,Member#ets_users_guilds.other_data#other_users_guilds.warehouse_pageindex}.

%% 同意
invite_guild_item3( GuildID, UserID,Nick,Info) ->
	DicWareName = lists:concat([guilds_warehouse_,GuildID]),
	DicL = get(DicWareName),
	case lists:keyfind(Info#ets_guilds_items_request.item_id, #ets_guilds_items.item_id, DicL) of
		false ->
			false;
		GuildItem ->
			invite_guild_item4(Info#ets_guilds_items_request.item_id,GuildID,UserID,Info#ets_guilds_items_request.user_id,Nick),
			Item = GuildItem#ets_guilds_items.other_data,
			[ItemTemplate] = ets:lookup(?ETS_ITEM_TEMPLATE,Item#ets_users_items.template_id),
			LogContent = ?GET_TRAN(?_LANG_GUILDS_ITEMS_GET,[Nick, ItemTemplate#ets_item_template.name]),
			create_warehouse_log(GuildID,LogContent,?GUILD_LOG_ITEM_GET),
			Content = ?GET_TRAN(?_LANGUAGE_GUILD_MAIL_CONTENT_SUCCESS, [Nick]),
			lib_mail:send_sys_mail(Nick, UserID, Info#ets_guilds_items_request.other_data,Info#ets_guilds_items_request.user_id , [Item], ?MAIL_TYPE_GUILD_BROAD, ?_LANGUAGE_GUILD_MAIL_TITLE,  Content, 0, 0, 0, 0),
			NewDicL = lists:keydelete(Info#ets_guilds_items_request.item_id, #ets_guilds_items.item_id, DicL),
			db_agent_guild:delete_guild_item([{item_id,Info#ets_guilds_items_request.item_id}]),
			put(DicWareName,NewDicL)
	end.

invite_guild_item4(ItemID,GuildID,UserID,UID,Nick) ->
	L = get_guild_item_request_by_item_id(GuildID,ItemID),
	F = fun(Info) ->
				case get_guild_user_info(GuildID, Info#ets_guilds_items_request.user_id) of
					[] ->
						skip;
					Member ->
						if
							Info#ets_guilds_items_request.user_id =/= UID ->
								Content = ?GET_TRAN(?_LANGUAGE_GUILD_MAIL_CONTENT_FAIL, [Nick]),
								lib_mail:send_sys_mail(Nick, UserID,Info#ets_guilds_items_request.other_data,Info#ets_guilds_items_request.user_id , [], ?MAIL_TYPE_GUILD_BROAD, ?_LANGUAGE_GUILD_MAIL_TITLE,  Content, 0, 0, 0, 0);
							true ->
								skip
						end
				end		
			end,
	lists:foreach(F, L).
	
	

%% -----------------------审核物品 end---------------------------

%% -----------------------取消物品申请 start---------------------------
cancel_guild_item_request(GuildID,UserID, RequestId,PidSend) ->
	case cancel_guild_item_request(GuildID,UserID, RequestId) of
		{ok} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_ITEM_CANCEL,[]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg1} ->
			lib_chat:chat_sysmsg_pid([PidSend,
							 		 ?FLOAT,
							 		 ?None,
							 		 ?ORANGE,
									 _Msg1])
	end.

cancel_guild_item_request(GuildID,UserID, RequestId) ->
	case get_guild_item_request_by_id(GuildID,RequestId) of
		[] ->
			{false,?_LANG_GUILD_ERROR_ITEM_REQUEST_NONE};
		Info ->
			if Info#ets_guilds_items_request.user_id =:= UserID ->
				   cancel_guild_item_request1(GuildID,RequestId);
			   true ->
				   {false,?_LANG_GUILD_ERROR_ITEM_REQUEST_NONE}
			end
	end.

cancel_guild_item_request1(GuildID,RequestId) ->
	db_agent_guild:update_guilds_items_request([{is_exist,0}],[{id,RequestId}]),
	delete_guild_item_request_by_id(GuildID,RequestId),
	{ok}.

	
%% -----------------------取消物品申请 end---------------------------
		
%将东西放入仓库并获得新的仓库内容列表
%========================================================================

put_item_in_guild_warehouse(GuildID,UserID) ->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		_Member ->
			case put_item_in_guild_warehouse1(GuildID) of
				{ok} ->
					{ok};
				{false, Msg} ->
					{false, Msg}
			end
	end.

put_item_in_guild_warehouse1(GuildID) ->
	DicWareName = lists:concat([guilds_warehouse_,GuildID]),
	OldL = case get(DicWareName) of
			   undefined ->
				   [];
			   DicL ->
				   DicL
		   end,
	if length(OldL) < ?GUILD_WAREHOUSE_MAX ->
		   {ok};
	   true ->
		   {false,?_LANG_GUILD_ERROR_WAREHOUSE_MAX}
	end.

put_item_in_guild_warehouse_refresh(NickName,GuildID, UserID, ItemID,ItemTemplateID,Item, PidSend) ->
	 DicWareName = lists:concat([guilds_warehouse_,GuildID]),
	 OldL = case get(DicWareName) of
			   undefined ->
				   [];
			   DicL ->
				   DicL
		   end,
	 [ItemTemplate] = ets:lookup(?ETS_ITEM_TEMPLATE,ItemTemplateID),
	 LogContent = ?GET_TRAN(?_LANG_GUILDS_ITEMS_PUT,[NickName,ItemTemplate#ets_item_template.name]),
	 create_warehouse_log(GuildID,LogContent,?GUILD_LOG_ITEM_PUT),
	 NewGuildItem = #ets_guilds_items{item_id=ItemID,
									 guild_id = GuildID,
									 put_date = misc_timer:now_seconds(),
									 other_data = Item},
	 db_agent_guild:create_guild_item(NewGuildItem),
	 NewL = [NewGuildItem|OldL],
	 F = fun(V1,V2) -> V1#ets_guilds_items.put_date < V2#ets_guilds_items.put_date end,
	 LSort = lists:sort(F,NewL),
	 put(DicWareName,LSort),
	 Member = get_guild_user_info(GuildID, UserID),
	 PageIndex = Member#ets_users_guilds.other_data#other_users_guilds.warehouse_pageindex,
	 case get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex) of
		{ok, L} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_PAGEUPDATE,[L]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg1} ->
					lib_chat:chat_sysmsg_pid([PidSend,
									 		 ?FLOAT,
									 		 ?None,
									 		 ?ORANGE,
											 _Msg1])   
	end,
	{ok}.
	 
	
%==========================================================================
%% 
%% get_item_in_guild_warehouse(UserID,GuildID,ItemID,ItemNum,PidSend) ->
%% 	case get_item_in_guild_warehouse1(UserID, GuildID, ItemID, ItemNum) of
%% 		{ok} ->
%% 			{ok};
%% 		{false,Msg} ->
%% 			{false, Msg};
%% 		{false, Msg, PageIndex} ->
%% 			case get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex) of
%% 				{ok,L1} ->
%% 					{ok,Bin} = pt_21:write(?PP_CLUB_STORE_PAGEUPDATE,[L1]),
%% 					lib_send:send_to_sid(PidSend,Bin);
%% 				{false,_Msg1} ->
%% 					lib_chat:chat_sysmsg_pid([PidSend,
%% 									 		 ?FLOAT,
%% 									 		 ?None,
%% 									 		 ?ORANGE,
%% 											 _Msg1])
%% 			end,
%% 			{false, Msg}
%% 	end.
%% 
%% get_item_in_guild_warehouse1(UserID, GuildID, ItemID, ItemNum) ->
%% 	case get_guild_user_info(GuildID, UserID) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		Member ->
%% 			PageIndex = Member#ets_users_guilds.other_data#other_users_guilds.warehouse_pageindex,
%% 			case get_item_in_guild_warehouse2(GuildID, ItemID, Member, ItemNum) of
%% 				{ok} ->
%% 					{ok};
%% 				{false, Msg} ->
%% 					{false, Msg, PageIndex}
%% 			end
%% 	end.
%% 
%% get_item_in_guild_warehouse2( GuildID, ItemID, Member, ItemNum) ->
%% 	DicWareName = lists:concat([guilds_warehouse_,GuildID]),
%% 	case get(DicWareName) of
%% 		undefined ->
%% 			{false,?_LANG_GUILD_ERROR_WAREHOUSE_NULL};
%% 		DicL ->
%% 			get_item_in_guild_warehouse3(DicL,ItemID,Member, ItemNum)
%% 	end.
%% 
%% get_item_in_guild_warehouse3(DicL,ItemID,Member, ItemNum) ->
%% 	case lists:keyfind(ItemID,#ets_guilds_items.item_id,DicL) of
%% 		false ->
%% 			{false,?_LANG_GUILD_ERROR_WAREHOUSE_NOT_ITEM};
%% 		_GuildItem ->
%% 			get_item_in_guild_warehouse4(Member, ItemNum)
%% 	end.
%% 
%% get_item_in_guild_warehouse4(Member, ItemNum) ->
%% 	if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
%% 		Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT orelse
%% 		Member#ets_users_guilds.total_feats >= ItemNum ->
%% 		   {ok};
%% 	   true ->
%% 		   {false,?_LANG_GUILD_ERROR_NO_FEATS}
%% 	end.

%% %% 物品模块正常后调用此处
%% get_item_in_guild_warehouse_refresh(ItemID,ItemTemplateID,ItemNum,GuildID,UserID,NickName,PidSend) ->
%% 	Member = get_guild_user_info(GuildID, UserID),
%% 	PageIndex = Member#ets_users_guilds.other_data#other_users_guilds.warehouse_pageindex,
%% 	DicWareName = lists:concat([guilds_warehouse_,GuildID]),
%% 	DicL = get(DicWareName),
%% 	[ItemTemplate] = ets:lookup(?ETS_ITEM_TEMPLATE,ItemTemplateID),
%% 	LogContent = ?GET_TRAN(?_LANG_GUILDS_ITEMS_GET,[NickName,ItemTemplate#ets_item_template.name]),
%% 	create_warehouse_log(GuildID,LogContent,?GUILD_LOG_ITEM_GET),
%% 	NewMember = if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
%% 									 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT->
%% 					   Member;
%% 				   true ->
%% 					   TmpFeats = Member#ets_users_guilds.total_feats - ItemNum, %每个消耗1点贡献
%% 					   Member#ets_users_guilds{total_feats = TmpFeats}
%% 				end,
%% 	db_agent_guild:update_user_guild([{total_feats,NewMember#ets_users_guilds.total_feats}],
%% 									 [{user_id,NewMember#ets_users_guilds.user_id}]),
%% 	update_guilds_member(NewMember,false),
%% 	NewDicL = lists:keydelete(ItemID, #ets_guilds_items.item_id, DicL),
%% 	db_agent_guild:delete_guild_item([{item_id,ItemID}]),
%% 	put(DicWareName,NewDicL),
%% 	case get_item_list_in_guild_warehouse(GuildID, UserID, PageIndex) of
%% 		{ok, L} ->
%% 			{ok,Bin} = pt_21:write(?PP_CLUB_STORE_PAGEUPDATE,[L]),
%% 			lib_send:send_to_sid(PidSend,Bin);
%% 		{false,_Msg1} ->
%% 					lib_chat:chat_sysmsg_pid([PidSend,
%% 									 		 ?FLOAT,
%% 									 		 ?None,
%% 									 		 ?ORANGE,
%% 											 _Msg1])   
%% 	end,
%% 	{ok}.



	
%==========================================================================

%创建帮会
create_guild(GuildName,Declear, CreateType, PidSend, Pid, OldGuildID, NickName, Career,Sex, UserLevel,VipId, UserID) ->
	case create_guild0(GuildName,Declear, CreateType, OldGuildID, NickName, Career, Sex,UserLevel,VipId, UserID) of
		{ok, UserGuild,Guild} ->
			{ok, BinData} = pt_21:write(?PP_CLUB_CREATE, [
														  Guild#ets_guilds.id,
														  Guild#ets_guilds.guild_name,
														  Guild#ets_guilds.camp,
														  UserGuild#ets_users_guilds.member_type
														  ]),
			lib_send:send_to_sid(PidSend,BinData),			
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILDS_CREATE_GUILD_SUCCESS]),
			
			ChatAllStr = ?GET_TRAN(?_LANG_GUILD_CREATE_TO_WORLD, [GuildName]),
			
			lib_chat:chat_sysmsg([?FLOAT,?None,?ORANGE,ChatAllStr]),
			
			gen_server:cast(Pid,{join_guild, 
							 Guild#ets_guilds.id,
							 Guild#ets_guilds.guild_name,
							 UserGuild#ets_users_guilds.member_type,
							 Guild#ets_guilds.guild_level,
							 Guild#ets_guilds.furnace_level}),
			{ok};
		{false,Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  Msg]),
			{false}
	end.

%帮会创建
create_guild0(GuildName, Declear, Type, OldGuildID, NickName, Career,Sex, UserLevel,VipId, UserID) ->
	if OldGuildID > 0 ->
		   {false, ?_LANG_GUILD_ERROR_ALREADY_HAVE_GUILD};
	   true ->
		   case get_leave_guilds(UserID) of
			   [] ->
				   create_guild1(GuildName,Declear,Type, NickName, Career,Sex, UserLevel,VipId, UserID,0,[]);
			   Member ->
				   LeaveTime = misc_timer:now_seconds() - Member#ets_users_guilds.join_date,
				   if LeaveTime < ?GUILD_LEAVE_JOIN_TIME ->
						  {false, ?_LANG_GUILD_ERROR_LEAVE_TIME_NOT_ENOUGH};
					  true ->
						  db_agent_guild:delete_guild_user([{user_id,Member#ets_users_guilds.user_id}]),
						  delete_leave_guilds_dic(Member),
						  create_guild1(GuildName,Declear,Type, NickName, Career,Sex, UserLevel,VipId, UserID,
										Member#ets_users_guilds.get_weal_date,
										Member#ets_users_guilds.other_data#other_users_guilds.use_feats_list)
				   end
		   end
	end.

create_guild1(GuildName,Declear,Type, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	 case lib_words_ver:words_ver(tool:to_list(GuildName)) of
        true ->
			create_guild2(GuildName,Declear,Type, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList); 
        _ ->
            %包含敏感词
            {false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID} 
    end.

create_guild2(GuildName,Declear,Type, NickName, Career, Sex,UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	BGuildName = tool:to_binary(GuildName),
	L = get_guilds_dic(),
	case lists:keymember(BGuildName, #ets_guilds.guild_name, L) of
		false ->
			create_guild2_1(GuildName,Declear,Type, NickName, Career,Sex, UserLevel, VipId,UserID,GetWealDate,FeatsList);
		_ ->
			{false, ?_LANG_GUILD_ERROR_NAME_ALREADY_HAVE}
	end.

create_guild2_1(GuildName,Declear,Type, NickName, Career, Sex,UserLevel, VipId,UserID,GetWealDate,FeatsList) ->
	BGuildName = tool:to_binary(GuildName),
	case check_guild_name_isexist(BGuildName) of
		1 ->
		   create_guild2_2(GuildName,Declear, Type, NickName, Career, Sex,UserLevel,VipId, UserID,GetWealDate,FeatsList);
	   _ ->
		   {false, ?_LANG_GUILD_ERROR_NAME_ALREADY_HAVE}
	end.

create_guild2_2(GuildName,Declear,Type, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	case asn1rt:utf8_binary_to_list(list_to_binary(GuildName)) of
		{ok, CharList} ->
			Len = misc:string_width(CharList),   
			if
				Len < 4 ->
					{false, ?_LANG_GUILD_ERROR_CREATE_TOO_SHORT};
				Len > 14 ->
					{false, ?_LANG_GUILD_ERROR_CREATE_TOO_LONG};
				true ->
					create_guild2_3(GuildName,Declear, Type, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList)
			end;
		{error, _Reason} ->
            %%非法字符
			{false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID}
	end.

create_guild2_3(GuildName,Declear, Type, NickName, Career, Sex,UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	 case lib_words_ver:words_ver(tool:to_list(Declear)) of
        true ->
			create_guild2_4(GuildName,Declear, Type, NickName, Career, Sex,UserLevel,VipId, UserID,GetWealDate,FeatsList); 
        _ ->
            %包含敏感词
            {false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID} 
    end.

create_guild2_4(GuildName,Declear, Type, NickName, Career, Sex,UserLevel, VipId,UserID,GetWealDate,FeatsList) ->
	case asn1rt:utf8_binary_to_list(list_to_binary(Declear)) of
		{ok, CharList} ->
			Len = misc:string_width(CharList),   
			if
				Len > ?GUILD_DECLARATION_MAX ->
					{false, ?_LANG_GUILD_ERROR_CREATE_TOO_LONG};
				true ->
					create_guild3(GuildName, Declear, Type, NickName, Career,Sex, UserLevel, VipId,UserID,GetWealDate,FeatsList)
			end;
		{error, _Reason} ->
            %%非法字符
			{false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID}
	end.

create_guild3(GuildName,Declear, Type, NickName, Career, Sex,UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	case UserLevel >= ?GUILD_BUILD_LEVEL of
		true ->
			case Type of
				?GUILD_CREATE_MONEY ->
					create_guild4_money(GuildName,Declear, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList);
				_ ->
					create_guild4_card(GuildName,Declear, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList)
			end;
		_ ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_LEVEL}
	end.
%%=================扣钱流程===================================================
create_guild4_money(GuildName,Declear, NickName, Career, Sex,UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	 DefaultGuildSetting = data_agent:get_guild_setting(1),	%%创建1级
	 create_guild6(GuildName,Declear,DefaultGuildSetting, NickName, Career,Sex, UserLevel, VipId,UserID,GetWealDate,FeatsList).

%==================扣物品流程=================================================

create_guild4_card(GuildName,Declear, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList) ->
	DefaultGuildSetting = data_agent:get_guild_setting(2),	%%创建2级
	create_guild6(GuildName,Declear,DefaultGuildSetting, NickName, Career,Sex, UserLevel,VipId, UserID,GetWealDate,FeatsList).

	 
create_guild6(GuildName, Declear, GuildSetting, NickName, Career,Sex, UserLevel, VipId,UserID,GetWealDate,FeatsList) ->
	%创建
	 Time = misc_timer:now_seconds(),
	 Other = #other_guilds{online_honor = 1 },
	 Guild = #ets_guilds{ 
						 guild_name = GuildName,                            %% 帮会名称	
      					 guild_level = GuildSetting#ets_guilds_template.guild_level,                        %% 帮会级别	
      					 master_id = UserID,                       %% 管理员	
      					 master_name = NickName,                       %% 管理员名字
						 master_type = VipId ,
      					 maintain_fee = 0,                       %% 维护费用
      					 activity = 0,                           %% 活跃度	
      					 money = 0,                             %% 铜币	
						 total_member = 1,
      					 requests_number = 0,                    %% 申请数	
      					 declaration = Declear,                       %% 宣言	
      					 qq = "",                                  %% qq	
      					 yy = "",                                 %% yy	
      					 camps_number = 0,                       %% 军团数	
      					 enemy_clubs = "",                        %% 敌对帮会	
						 furnace_level = 1,					  	%% 帮会演武堂等级
      					 shop_level = 1,						  %% 帮会商店等级
						 create_date = Time										
      					 },
	 
	 case db_agent_guild:create_guild(Guild) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			DBGuild = db_agent_guild:get_guild_info_by_condition([{guild_name, GuildName}]),
			DBGuildInfo = list_to_tuple([ets_guilds] ++ DBGuild),
			NewDBGuildInfo = DBGuildInfo#ets_guilds{other_data = Other},
			update_guilds_dic(NewDBGuildInfo),
			create_guild7(NewDBGuildInfo, NickName, Career,Sex, UserLevel, UserID,VipId,GetWealDate,FeatsList);
        _Other ->
            {false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	 end.


create_guild7(Guild, NickName, Career,Sex, UserLevel, UserID,VipId,GetWealDate,FeatsList) ->
	Other_Data = #other_users_guilds{
									 	nick_name = NickName, %%姓名
										career = Career,		%%职业
										level = UserLevel,		%%等级
										sex = Sex,
										online = 1,		%%是否在线
										vipid = VipId,
										use_feats_list = FeatsList
									
									 },
	UserGuild = #ets_users_guilds{
								   user_id = UserID,
								   guild_id = Guild#ets_guilds.id,
								   member_type = ?GUILD_JOB_PRESIDENT,
								   get_weal_date = GetWealDate,
								   corp_id = 0,
								   corp_job = ?GUILD_CORP_JOB_NOT_IN,
								   join_date = Guild#ets_guilds.create_date,																   
								   is_exists = 1,
								   other_data = Other_Data
								   },
	case db_agent_guild:create_guild_user(UserGuild) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			
			update_guilds_member(UserGuild,false),
			update_users_guild(#r_users_guilds{guild_id = Guild#ets_guilds.id,user_id = UserID}),
			{ok,UserGuild,Guild};
		_Other ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	end.

%% %写日志
%% create_log(PlayerStatus, LogContent) ->
%% 	case create_log_and_return(PlayerStatus,LogContent) of
%% 		{ok,L} ->
%% 			{ok,BinData} = pt_21:write(?PP_CLUB_EVENT_UPDATE,L),
%% 			lib_send:send_to_guild_user(PlayerStatus#ets_users.club_id,BinData);
%% 		{false,_Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg])
%% 	end.
%% 
%% create_log_and_return(PlayerStatus,LogContent) ->
%% 	case create_log0(PlayerStatus,LogContent) of
%% 		{ok} ->
%% 			{ok,get_guild_logs(PlayerStatus#ets_users.club_id)};
%% 		Ret ->
%% 			Ret
%% 	end.
%% 
%% create_log0(PlayerStatus,LogContent) ->
%% 	case get_guild_user_info(PlayerStatus#ets_users.club_id, PlayerStatus#ets_users.id) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		Member ->
%% 			create_log1(Member,LogContent)
%% 	end.
%% 
%% create_log1(Member,LogContent) ->
%% 	case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT of
%% 		true ->
%% 			create_log2(Member#ets_users_guilds.guild_id,LogContent,?GUILD_LOG_MASTER);
%% 		_ ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
%% 	end.

create_log2(GuildID,LogContent,LogType) ->
	LogInfo = #ets_guilds_logs{
							   guild_id = GuildID,
							   log_type = LogType,
							   log_content = LogContent,
							   log_date = misc_timer:now_seconds()
							   },
	case db_agent_guild:create_log(LogInfo) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			
			{ok};
		_Other ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	end.

%写仓库日志
create_warehouse_log(GuildID,LogContent,LogType) ->
	LogInfo = #ets_guilds_logs{
							   guild_id = GuildID,
							   log_type = LogType,
							   log_content = LogContent,
							   log_date = misc_timer:now_seconds()
							   },
	case db_agent_guild:create_log(LogInfo) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			
			{ok};
		_Other ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	end.


%修改宣言
edit_guild_declaretion(GuildID, UserID,Declaration,PidSend) ->
	case edit_guild_declaretion(GuildID, UserID, Declaration) of
		{ok} ->
			{ok,BinData} = pt_21:write(?PP_CLUB_SET_NOTICE,[Declaration]),
			lib_send:send_to_sid(PidSend,BinData),
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,?_LANG_GUILD_CONTROL_SUCCESS]),
			lib_send:send_to_sid(PidSend,BinChatMsg);
		{false,_DMsg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _DMsg])
	end.



%%修改宣言
edit_guild_declaretion(GuildID, UserID, Declaration) ->
	 case lib_words_ver:words_ver(tool:to_list(Declaration)) of
        true ->
			edit_guild_declaration1(GuildID, UserID, Declaration); 
        _ ->
            %包含敏感词
            {false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID} 
    end.

edit_guild_declaration1(GuildID, UserID, Declaration) ->
	case asn1rt:utf8_binary_to_list(list_to_binary(Declaration)) of
		{ok, CharList} ->
			Len = misc:string_width(CharList),   
			if
				Len > ?GUILD_DECLARATION_MAX ->
					{false, ?_LANG_GUILD_ERROR_CREATE_TOO_LONG};
				true ->
					edit_guild_declaration2(GuildID, UserID, Declaration)
			end;
		{error, _Reason} ->
            %%非法字符
			{false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID}
	end.

edit_guild_declaration2(GuildID, UserID, Declaration) ->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			edit_guild_declaration3(Member,Declaration)
	end.

edit_guild_declaration3(Member,Declaration) ->
	case  Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT 
			orelse Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
		true ->
			edit_guild_declaration4(Member,Declaration);
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}	
	end.

edit_guild_declaration4(Member,Declaration) ->
	GuildInfo = get_guild(Member#ets_users_guilds.guild_id),
	db_agent_guild:update_guild([{declaration,Declaration}],[{id,GuildInfo#ets_guilds.id}]),
	update_guilds_dic(GuildInfo#ets_guilds{declaration = Declaration}),
	{ok}.


%获取公告
get_guild_declaretion(GuildID, UserID,PidSend) ->
	case get_guild_declaretion(GuildID, UserID) of
		{ok,Content} ->
			{ok,BinData} = pt_21:write(?PP_CLUB_GET_NOTICE,[Content]),
			lib_send:send_to_sid(PidSend,BinData);
		{false,_DMsg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _DMsg])
	end.

get_guild_declaretion(GuildID, UserID) ->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case get_guild(Member#ets_users_guilds.guild_id) of
				[] ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}	;
				GuildInfo ->
					{ok,GuildInfo#ets_guilds.declaration}
			end
	end.


%% %%修改QQ，YY
%% edit_guild_qq_yy(GuildID, UserID, QQ, YY) ->
%% 	 case lib_words_ver:words_ver(tool:to_list(QQ)) andalso lib_words_ver:words_ver(tool:to_list(YY)) of
%%         true ->
%% 			edit_guild_qq_yy1(GuildID, UserID, QQ, YY); 
%%         _ ->
%%             %包含敏感词
%%             {false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID} 
%%     end.
%% 
%% edit_guild_qq_yy1(GuildID, UserID, QQ, YY) ->
%% 	case asn1rt:utf8_binary_to_list(list_to_binary(QQ)) of
%% 		{ok, CharList} ->
%% 			Len = misc:string_width(CharList),  
%% 			if
%% 				Len > ?GUILD_QQ_MAX ->
%% 					{false, ?_LANG_GUILD_ERROR_CREATE_TOO_LONG};
%% 				true ->
%% 					edit_guild_qq_yy2(GuildID, UserID, QQ, YY)
%% 			end;
%% 		{error, _Reason} ->
%%             %%非法字符
%% 			{false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID}
%% 	end.
%% 
%% edit_guild_qq_yy2(GuildID, UserID, QQ, YY) ->
%% 	case asn1rt:utf8_binary_to_list(list_to_binary(YY)) of
%% 		{ok, CharList} ->
%% 			Len = misc:string_width(CharList),   
%% 			if
%% 				Len > ?GUILD_YY_MAX ->
%% 					{false, ?_LANG_GUILD_ERROR_CREATE_TOO_LONG};
%% 				true ->
%% 					edit_guild_qq_yy3(GuildID, UserID, QQ, YY)
%% 			end;
%% 		{error, _Reason} ->
%%             %%非法字符
%% 			{false, ?_LANG_GUILD_ERROR_NAME_NOT_VALID}
%% 	end.
%% 
%% edit_guild_qq_yy3(GuildID, UserID, QQ, YY) ->
%% 	case get_guild_user_info(GuildID, UserID) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		Member ->
%% 			edit_guild_qq_yy4(Member,QQ,YY)
%% 	end.
%% 
%% edit_guild_qq_yy4(Member,QQ,YY) ->
%% 	case  Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT 
%% 			orelse Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
%% 		true ->
%% 			edit_guild_qq_yy5(Member,QQ,YY);
%% 		_ ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}	
%% 	end.
%% 
%% edit_guild_qq_yy5(Member,QQ,YY) ->
%% 	GuildInfo = get_guild(Member#ets_users_guilds.guild_id),
%%     db_agent_guild:update_guild([{qq,QQ},{yy,YY}],[{id,GuildInfo#ets_guilds.id}]),
%% 	update_guilds_dic(GuildInfo#ets_guilds{qq=QQ,yy=YY}),
%% 	{ok}.

%% 成功:{ok,TotalMoney,UserId,TotalFeats,CurrentFeats,TodayFeats,UserFeats,GuildMoney,NewStatus}.
%% 失败:{false,msg}
%% 可以 cast
add_guild_feats(PlayerStatus,UserFeats,GuildMoney,ContributionType) ->
	case get_guild_user_info(PlayerStatus#ets_users.club_id,PlayerStatus#ets_users.id) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		ControlMember ->
			case get_guild(ControlMember#ets_users_guilds.guild_id) of
				[] ->
					{false,?_LANG_GUILD_ERROR_NOT_GUILD};
				GuildInfo ->
					case contribution_money3(GuildInfo,ControlMember,0,UserFeats,GuildMoney, ContributionType, PlayerStatus,0,0) of
						{ok,TotalMoney,UserID,TotalFeats,CurrentFeats,_TodayFeats,UserFeats, GuildMoney,ReduceYuanBao,ReduceCopper} ->
							{ok,ContributionBin} = pt_21:write(?PP_CLUB_CONTRIBUTION,[TotalMoney,UserID,TotalFeats,CurrentFeats]),
							lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,ContributionBin);
						 _ ->
							skip
					end
			end
	end.

send_contribution_msg(GuildID,UserName,YuanBao,Copper,GuildMoney) ->
	if 
		YuanBao =/= 0 ->
			Msg = ?GET_TRAN(?_LANG_GUILD_CONTRIBUTION_YUANBAO,[UserName,YuanBao,GuildMoney]),
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,Msg]),
			lib_send:send_to_guild_user(GuildID,BinChatMsg);
		Copper =/= 0 ->
			Msg1 = ?GET_TRAN(?_LANG_GUILD_CONTRIBUTION_COPPER,[UserName,Copper,GuildMoney]),
			{ok,BinChatMsg1} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,Msg1]),
			lib_send:send_to_guild_user(GuildID,BinChatMsg1);
		true ->
			skip
	end.		

%% 贡献
contribution_money(PlayerStatus,  Number, ContributionType) ->
	case contribution_money1(PlayerStatus#ets_users.club_id,PlayerStatus,Number, ContributionType) of
		{ok,TotalMoney,UserID,TotalFeats,CurrentFeats,_TodayFeats, _UserFeats, _GuildMoney,ReduceYuanBao,ReduceCopper} ->
			
			{ok,ContributionBin} = pt_21:write(?PP_CLUB_CONTRIBUTION,[TotalMoney,UserID,TotalFeats,CurrentFeats]),
			io:format("Format ~p~n", [{TotalMoney,UserID,TotalFeats,CurrentFeats}]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,ContributionBin),
			send_contribution_msg(PlayerStatus#ets_users.club_id,PlayerStatus#ets_users.nick_name,ReduceYuanBao,ReduceCopper,_GuildMoney),
			{ok, ReduceYuanBao,ReduceCopper};
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg]),
			{false}
	end.

contribution_money1(GuildID,PlayerStatus,Number, ContributionType) ->
	case get_guild_user_info(GuildID,PlayerStatus#ets_users.id) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		ControlMember ->
			contribution_money2(ControlMember,PlayerStatus,Number, ContributionType)
	end.

contribution_money2(ControlMember,PlayerStatus,Number, ContributionType) ->
	case get_guild(ControlMember#ets_users_guilds.guild_id) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_GUILD};
		GuildInfo ->
			case contribution_money2_1(Number,ContributionType) of
				{true,TmpMoney,TmpMoney1,UserFeats,GuildMoney} ->
					%% 钱的信息
					case lib_player:check_nobind_cash(PlayerStatus,TmpMoney1,TmpMoney) of
						true ->
%% 							NewStatus1 = lib_player:reduce_cash_and_send(PlayerStatus,TmpMoney1,0,TmpMoney,0,{?CONSUME_MONEY_GUILD_DONATE,ControlMember#ets_users_guilds.guild_id,1}),
							lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_DONATE_COPPER,{0,TmpMoney}},{?TARGET_DONATE_YUANBAO,{0,TmpMoney1}}]),
							contribution_money3(GuildInfo,ControlMember,Number,UserFeats,GuildMoney, ContributionType, PlayerStatus,TmpMoney1,TmpMoney);
						_ -> 
							{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_CASH}
					end;
				{false} ->
					{false,?_LANG_OPERATE_ERROR}
			end
	end.

contribution_money2_1(Number,ContributionType)->
	case ContributionType of
		1 -> %% 铜币
			TmpMoney = Number * 2000,
			TmpMoney1 = 0,
			UserFeats = Number,				%% 贡献
			GuildMoney = Number,			%% 工会财富
			{true,TmpMoney,TmpMoney1,UserFeats,GuildMoney};
		2 -> %% 元宝
			TmpMoney = 0,
			TmpMoney1 = Number,
			UserFeats = Number * 5, 	%% 贡献
			GuildMoney = Number  * 5,	%% 工会财富
			{true,TmpMoney,TmpMoney1,UserFeats,GuildMoney};
		_ ->
			{false}
	end.

	
contribution_money3(GuildInfo,ControlMember,Number,UserFeats,GuildMoney, ContributionType, PlayerStatus,ReduceYuanBao,ReduceCopper) ->
	Time = misc_timer:now_seconds(),
	%% 注意每日功勋上限
	OldFeatsList = ControlMember#ets_users_guilds.other_data#other_users_guilds.feats_list,
	{OldOutFeatsList,_, OldTodayFeats} = feats_detail(OldFeatsList, Time, ContributionType),
	
	TotalFeats = ControlMember#ets_users_guilds.total_feats + UserFeats,
	CurrentFeats = ControlMember#ets_users_guilds.current_feats + UserFeats,
	TodayFeats = OldTodayFeats + UserFeats,
	NewFeatsList = [{Time,ContributionType,UserFeats}|OldOutFeatsList],
	Other = ControlMember#ets_users_guilds.other_data#other_users_guilds{feats_list = NewFeatsList},
	NewMember = ControlMember#ets_users_guilds{total_feats = TotalFeats,current_feats = CurrentFeats,other_data = Other},
	db_agent_guild:update_user_guild([{total_feats,TotalFeats},{current_feats,CurrentFeats}],[{user_id,NewMember#ets_users_guilds.user_id}]),
	
%% 	Money = Number ,		%% 工会财富
 	TotalMoney = GuildInfo#ets_guilds.money + GuildMoney,
	NewGuild = GuildInfo#ets_guilds{money = TotalMoney},
	db_agent_guild:update_guild([{money,TotalMoney}],[{id,NewGuild#ets_guilds.id}]),
					
	update_guilds_dic(NewGuild),
	update_guilds_member(NewMember,false),

	lib_target:cast_check_target(PlayerStatus#ets_users.other_data#user_other.pid_target,[{?TARGET_GUILD_FEAT,{0,TotalFeats}}]),
	
	{ok,TotalMoney,NewMember#ets_users_guilds.user_id,TotalFeats,CurrentFeats,TodayFeats,UserFeats,GuildMoney,ReduceYuanBao,ReduceCopper}.
	
	

%% %捐献
%% contribution(UserID,GuildID,UserName,Number,PidSend, ContributionType) ->
%% 	case contribution(GuildID, UserID, Number, ContributionType) of 
%% 		{ok,TotalGuildFeats,UserID,TotalFeats,TodayFeats,UserFeats, Contribution} ->
%% 			{ok,ContributionBin} = pt_21:write(?PP_CLUB_CONTRIBUTION,[TotalGuildFeats,UserID,0,TotalFeats,TodayFeats]),
%% 			lib_send:send_to_sid(PidSend,ContributionBin),
%% 			case get_guild_info(GuildID) of
%% 				{ok,GuildInfo} ->
%% 					if UserFeats > 0 ->
%% 						   UserInMsg = ?GET_TRAN(?_LANG_GUILD_PLAYER_CONTRIBUTION,[UserName,
%% 																			   tool:to_list(Contribution),
%% 																			  tool:to_list(UserFeats)]);
%% 					   true ->
%% 						   UserInMsg = ?GET_TRAN(?_LANG_GUILD_PLAYER_CONTRIBUTION1,[UserName,
%% 																			  tool:to_list(Contribution)])
%% 									   end,	
%% 					{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,UserInMsg]),
%% 					{ok,BinData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
%% 					lib_send:send_to_guild_user(GuildID,BinData),
%% 					lib_send:send_to_guild_user(GuildID,BinChatMsg),
%% 					{ok};
%% 				{false,_Msg} ->
%% 					lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg]),
%% 					{false}
%% 			end;
%% 		{false,_Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg]),
%% 			{false}
%% 	end.

%% contribution(GuildID, UserID, Number, ContributionType) ->
%% 	case get_guild_user_info(GuildID, UserID) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		ControlMember ->
%% 			contribution1(ControlMember,Number,ContributionType)
%% 	end.
%% 
%% contribution1(ControlMember,Number, ContributionType) ->
%% 	case get_guild(ControlMember#ets_users_guilds.guild_id) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_GUILD};
%% 		GuildInfo ->
%% 			%物品信息
%% 			Time = misc_timer:now_seconds(),
%% 			%% 注意每日功勋上限
%% 			OldFeatsList = ControlMember#ets_users_guilds.other_data#other_users_guilds.feats_list,
%% 			{OldOutFeatsList, OldTodayFeats} = feats_detail(OldFeatsList, Time, ContributionType),
%% 			TmpUserFeats = Number * 5,				%%贡献
%% 			if OldTodayFeats + TmpUserFeats =< ?GUILD_FEATS_LIMIT ->
%% 					UserFeats = TmpUserFeats;
%% 				true ->
%% 					UserFeats = ?GUILD_FEATS_LIMIT - OldTodayFeats
%% 			end,
%% 			TotalFeats = ControlMember#ets_users_guilds.total_feats + UserFeats,
%% 			TodayFeats = OldTodayFeats + UserFeats,
%% 			NewFeatsList = [{Time,ContributionType,UserFeats}|OldOutFeatsList],
%% 					
%% 			Other = ControlMember#ets_users_guilds.other_data#other_users_guilds{feats_list = NewFeatsList},
%% 			NewMember = ControlMember#ets_users_guilds{
%% 															   total_feats = TotalFeats,
%% 															   other_data = Other},
%% 			db_agent_guild:update_user_guild([{total_feats,TotalFeats}],
%% 													 [{user_id,NewMember#ets_users_guilds.user_id}]),
%% 					
%%  			TmpGuildFeats = Number * 1000,		%% 帮会贡献
%%  			TotalGuildFeats = GuildInfo#ets_guilds.money + TmpGuildFeats,
%% 			NewGuild = GuildInfo#ets_guilds{money = TotalGuildFeats},
%% 			db_agent_guild:update_guild([{money,TotalGuildFeats}],[{id,NewGuild#ets_guilds.id}]),
%% 					
%% 			update_guilds_dic(NewGuild),
%% 			update_guilds_member(NewMember,false),
%% 			{ok,TotalGuildFeats,NewMember#ets_users_guilds.user_id,TotalFeats,TodayFeats,UserFeats,TmpGuildFeats}
%% 	end.

%% 
feats_detail(FeatsList,CheckTime,CheckType) ->
	case CheckType of
		0 -> %% 全部
			F = fun(X,L) ->
						{List,_,Count} = L,
						{Time,_Type,Feats} = X,
						case util:is_same_date(Time,CheckTime) of
							true ->
								NL = [X|List],
								NCount = Feats + Count;
							_ ->
								NL = List,
								NCount = Count
						end,
						{NL,NL,NCount}
				end;
		CheckType -> %% 指定类型
			F = fun(X,L) ->
						{List,List1,Count} = L,
						{Time,Type,Feats} = X,
						case util:is_same_date(Time,CheckTime) of
							true ->
								NL = [X|List],
								case CheckType =:= Type of
									true ->
										NL1 = [X|List1],
										NCount = Feats + Count;
									_ ->
										NL1 = List1,
										NCount = Count
								end;
							_ ->
								NL = List,
								NL1 = List1,
								NCount = Count
						end,
						{NL,NL1,NCount}
				end
	end,	
	lists:foldl(F, {[],[],0}, FeatsList).



%% -----------------------------  帮会升级等级 end --------------------------------
%% 帮会升级等级
update_guild_level_setting(ControlUserID,Pid,PidSend,GuildID) ->
	case update_guild_level_setting(Pid,GuildID, ControlUserID) of
		{ok,GuildInfo} ->
			sort_guilds_dic(),
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,?_LANG_GUILD_LEVELUP]),
			lib_send:send_to_guild_user(GuildID,BinChatMsg),
			{ok,BinData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
			lib_send:send_to_guild_user(GuildID,BinData);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

update_guild_level_setting(Pid,GuildID, ControlUserID) ->
	case get_guild_user_info(GuildID,ControlUserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		ControlMember ->
			update_guild_level_setting1(Pid,ControlMember)
	end.

update_guild_level_setting1(Pid,ControlMember) ->
	case ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT of
		true ->
			update_guild_level_setting2(Pid,ControlMember#ets_users_guilds.guild_id);
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
	end.

update_guild_level_setting2(Pid,GuildID) ->
	GuildInfo = get_guild(GuildID),
	NextLevel = GuildInfo#ets_guilds.guild_level + 1,
	case data_agent:get_guild_setting(NextLevel) of
		[] -> {false, ?_LANG_GUILD_ERROR_SETTING_MAX_LEVEL};
		GuildSetting ->
			NewGuildInfo= GuildInfo#ets_guilds{
											   money = GuildInfo#ets_guilds.money - GuildSetting#ets_guilds_template.need_money,
											   guild_level = GuildSetting#ets_guilds_template.guild_level
											  },
			update_guild_level_setting3(Pid,NewGuildInfo)
	end.

update_guild_level_setting3(Pid,NewGuildInfo) ->
	case NewGuildInfo#ets_guilds.money >= 0 of
		true ->
			gen_server:cast(Pid,{guild_level_update,NewGuildInfo#ets_guilds.guild_level}),
			db_agent_guild:update_guild([
										 {money,NewGuildInfo#ets_guilds.money},
										 {guild_level,NewGuildInfo#ets_guilds.guild_level}
										 ]
			  							,[{id,NewGuildInfo#ets_guilds.id}]),
			update_guilds_dic(NewGuildInfo),
			LogContent = ?GET_TRAN(?_LANG_GUILDS_LEVEL_UP_LOG,[NewGuildInfo#ets_guilds.guild_level]),
			create_log2(NewGuildInfo#ets_guilds.id,LogContent,?GUILD_LOG_SYSTEM),
			{ok, NewGuildInfo};
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_NEED}
	end.

%% -----------------------------  帮会升级 end --------------------------------

%% -------------------------------召唤start--------------------------------------------
update_guild_summon(ControlUserID,Pid,PidSend,GuildID,SummonInfo) ->
	case update_guild_summon(Pid,GuildID, ControlUserID,SummonInfo) of
		{ok,GuildInfo} ->
			case SummonInfo#ets_guild_summon_template.type of
				0 ->
%% 					Msg = ?GET_TRAN(?_LANGUAGE_GUILD_SUMMON_MONSTER,[GuildInfo#ets_guilds.guild_name,
%% 																	SummonInfo#ets_guild_summon_template.name,GuildInfo#ets_guilds.guild_name]),
					Msg1 = ?GET_TRAN(?_LANGUAGE_GUILD_SUMMON_MONSTER1,[SummonInfo#ets_guild_summon_template.name]);
				_ ->
%% 					Msg = ?GET_TRAN(?_LANGUAGE_GUILD_SUMMON_COLLECT,[GuildInfo#ets_guilds.guild_name,
%% 																	SummonInfo#ets_guild_summon_template.name,GuildInfo#ets_guilds.guild_name]),
					Msg1 = ?GET_TRAN(?_LANGUAGE_GUILD_SUMMON_COLLECT1,[SummonInfo#ets_guild_summon_template.name])					
			end,
			{ok,Bin} = pt_21:write(?PP_CLUB_SUMMON,[1,0]),
			lib_send:send_to_sid(PidSend, Bin),
			{ok,SummonBin} = pt_21:write(?PP_CLUB_SUMMON_NUM,[GuildInfo#ets_guilds.summon_monster_num,
															GuildInfo#ets_guilds.summon_collect_num,
															GuildInfo#ets_guilds.other_data#other_guilds.summon_collent_time]),
			lib_send:send_to_sid(PidSend, SummonBin),
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,Msg1]),
			lib_send:send_to_guild_user(GuildID,BinChatMsg),
			{ok,BinChatMsg1} = pt_21:write(?PP_CLUB_SUMMON_NOTICE,[SummonInfo#ets_guild_summon_template.type,Msg1]),
			lib_send:send_to_guild_user(GuildID,BinChatMsg1);			
		{false,Msg} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_SUMMON,[0,Msg]),
			lib_send:send_to_sid(PidSend, Bin)
	end.

update_guild_summon(Pid,GuildID,ControlUserID,SummonInfo) ->	
	case get_guild_user_info(GuildID,ControlUserID) of
		[] ->
			{false,?ER_NOT_ENOUGH_POWER};
		ControlMember ->
			case ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT 
					orelse ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				true ->
					update_guild_summon1(Pid,GuildID,SummonInfo);
				_ ->
					{false,?ER_NOT_ENOUGH_POWER}
			end
	end.
update_guild_summon1(_Pid,GuildID,SummonInfo) ->
	GuildInfo = get_guild(GuildID),
	Now = misc_timer:now_seconds(),
	if	%%如果是召集采集物		
		GuildInfo#ets_guilds.money < SummonInfo#ets_guild_summon_template.guild_money ->
			{false,?ER_NOT_ENOUGH_GUILD_MONEY};
		GuildInfo#ets_guilds.guild_level < SummonInfo#ets_guild_summon_template.guild_level ->
			{false,?ER_NOT_ENOUGH_GUILD_LEVEL};
		true ->
			case SummonInfo#ets_guild_summon_template.type of
				0 ->
					if
						GuildInfo#ets_guilds.summon_monster_num >= 5 ->
							{false,?ER_NOT_ENOUGH_SUMMON_NUM};
						true ->
							update_guild_summon1_0(SummonInfo#ets_guild_summon_template.summon_list,GuildInfo#ets_guilds.other_data#other_guilds.map_pid),
							NewGuildInfo = GuildInfo#ets_guilds{
												summon_monster_num = GuildInfo#ets_guilds.summon_monster_num + 1,
												last_send_date = Now,
												money = GuildInfo#ets_guilds.money - SummonInfo#ets_guild_summon_template.guild_money},
							db_agent_guild:update_guild([
										 {money,NewGuildInfo#ets_guilds.money},
										 {last_send_date,NewGuildInfo#ets_guilds.last_send_date},
										 {summon_monster_num,NewGuildInfo#ets_guilds.summon_monster_num}],
										[{id,NewGuildInfo#ets_guilds.id}]),
							update_guilds_dic(NewGuildInfo),
							{ok,NewGuildInfo}
					end;					
				1 ->
					if
						GuildInfo#ets_guilds.other_data#other_guilds.summon_collent_time + 600 > Now ->
							{false,?ER_SUMMON_COLLECT_TIME_LIMIT};
						GuildInfo#ets_guilds.summon_collect_num >= 5 ->
							{false,?ER_NOT_ENOUGH_SUMMON_NUM};
						true ->							
							update_guild_summon1_1(SummonInfo#ets_guild_summon_template.summon_list,GuildInfo#ets_guilds.other_data#other_guilds.map_pid),
							NewOther = GuildInfo#ets_guilds.other_data#other_guilds{summon_collent_time = Now},
							NewGuildInfo = GuildInfo#ets_guilds{
												summon_collect_num = GuildInfo#ets_guilds.summon_collect_num + 1,
												last_send_date = Now,
												money = GuildInfo#ets_guilds.money - SummonInfo#ets_guild_summon_template.guild_money,
												other_data = NewOther},
							db_agent_guild:update_guild([
										 {money,NewGuildInfo#ets_guilds.money},
										 {last_send_date,NewGuildInfo#ets_guilds.last_send_date},
										 {summon_collect_num,NewGuildInfo#ets_guilds.summon_collect_num}],
										[{id,NewGuildInfo#ets_guilds.id}]),
							update_guilds_dic(NewGuildInfo),
							{ok,NewGuildInfo}
					end;
				_ ->
					{false,?ER_NOT_EXSIT_DATA}
			end
	end.

update_guild_summon1_6(List, MPid) ->
	F = fun(Id) ->
			gen_server:cast(MPid, {create_monster, Id})
		end,
	lists:foreach(F, List).
update_guild_summon1_0(List, MPid) ->
	F = fun({Id}) ->
			gen_server:cast(MPid, {create_monster, Id})
		end,
	lists:foreach(F, List).
update_guild_summon1_1(List, MPid) ->
	F = fun({Id}) ->
			gen_server:cast(MPid, {create_collect, Id})
		end,
	lists:foreach(F, List).

%% -------------------------------召唤end----------------------------------------------

%% -----------------------------  帮会设施升级 start --------------------------------
update_guild_device_level(ControlUserID,Pid,PidSend,GuildID,Type) ->
	case update_guild_device_level(Pid,GuildID, ControlUserID,Type) of
		{ok,GuildInfo} ->
			case Type of
				1 ->
					Msg = ?_LANG_GUILD_LEVELUP2;
				_ ->
					Msg = ?_LANG_GUILD_LEVELUP1
			end,
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  Msg]),
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,Msg]),

			lib_send:send_to_guild_user(GuildID,BinChatMsg),
			
			{ok,BinData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
			lib_send:send_to_guild_user(GuildID,BinData);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

update_guild_device_level(Pid,GuildID,ControlUserID,Type) ->	
	case get_guild_user_info(GuildID,ControlUserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		ControlMember ->
			update_guild_device_level1(Pid,ControlMember,Type)
	end.

update_guild_device_level1(Pid,ControlMember,Type)->
	case ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT  of
		true ->
			update_guild_device_level2(Pid,ControlMember#ets_users_guilds.guild_id,Type);
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
	end.

update_guild_device_level2(Pid,GuildID,Type)->
	case Type of
		1 ->
			update_guild_device_level2_1(Pid,GuildID);
		2 ->
			update_guild_device_level2_2(GuildID);
		_ ->
			{false, ?_LANG_OPERATE_ERROR}
	end.

update_guild_device_level2_1(Pid,GuildID) ->
	GuildInfo = get_guild(GuildID),
	NextLevel = GuildInfo#ets_guilds.furnace_level + 1,
	case data_agent:get_guild_furnace_level(NextLevel) of
		[] -> 
			{false, ?_LANG_GUILD_ERROR_SETTING_MAX_LEVEL};
		GuildSetting ->
			NewGuildInfo= GuildInfo#ets_guilds{
											   money = GuildInfo#ets_guilds.money - GuildSetting#ets_guilds_furnace_leve_template.need_money,
											   furnace_level = NextLevel											   
											  },
			update_guild_device_level2_1_1(Pid,NewGuildInfo,GuildSetting#ets_guilds_furnace_leve_template.need_club_level)
	end.

update_guild_device_level2_1_1(Pid,NewGuildInfo,NeedGuildLevel) ->
	case  NewGuildInfo#ets_guilds.guild_level >= NeedGuildLevel of
		true ->
			update_guild_device_level2_1_2(Pid,NewGuildInfo);
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_LEVEL}
	end.


update_guild_device_level2_1_2(Pid,NewGuildInfo) ->
	case NewGuildInfo#ets_guilds.money >= 0 of
		true ->
			gen_server:cast(Pid,{furnace_level_update,NewGuildInfo#ets_guilds.furnace_level}),
			db_agent_guild:update_guild([
										 {money,NewGuildInfo#ets_guilds.money},
										 {furnace_level,NewGuildInfo#ets_guilds.furnace_level}
										 ]
			  							,[{id,NewGuildInfo#ets_guilds.id}]),
			update_guilds_dic(NewGuildInfo),
			LogContent = ?GET_TRAN(?_LANG_GUILDS_FURNACE_LEVEL_UP_LOG,[NewGuildInfo#ets_guilds.furnace_level]),
			create_log2(NewGuildInfo#ets_guilds.id,LogContent,?GUILD_LOG_SYSTEM),
			{ok, NewGuildInfo};
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY}
	end.


update_guild_device_level2_2(GuildID) ->
	GuildInfo = get_guild(GuildID),
	NextLevel = GuildInfo#ets_guilds.shop_level + 1,
	case data_agent:get_guild_shop_level(NextLevel) of
		[] -> 
			{false, ?_LANG_GUILD_ERROR_SETTING_MAX_LEVEL};
		GuildSetting ->
			NewGuildInfo= GuildInfo#ets_guilds{
											   money = GuildInfo#ets_guilds.money - GuildSetting#ets_guilds_shop_leve_template.need_money,
											   shop_level = NextLevel										   
											  },
			update_guild_device_level2_2_1(NewGuildInfo,GuildSetting#ets_guilds_shop_leve_template.need_club_level)
	end.


update_guild_device_level2_2_1(NewGuildInfo,NeedGuildLevel) ->
	case  NewGuildInfo#ets_guilds.guild_level >= NeedGuildLevel of
		true ->
			update_guild_device_level2_2_2(NewGuildInfo);
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_LEVEL}
	end.


update_guild_device_level2_2_2(NewGuildInfo) ->
	case NewGuildInfo#ets_guilds.money >= 0 of
		true ->
			db_agent_guild:update_guild([
										 {money,NewGuildInfo#ets_guilds.money},
										 {shop_level,NewGuildInfo#ets_guilds.shop_level}
										 ]
			  							,[{id,NewGuildInfo#ets_guilds.id}]),
			update_guilds_dic(NewGuildInfo),
			LogContent = ?GET_TRAN(?_LANG_GUILDS_SHOP_LEVEL_UP_LOG,[NewGuildInfo#ets_guilds.furnace_level]),
			create_log2(NewGuildInfo#ets_guilds.id,LogContent,?GUILD_LOG_SYSTEM),
			{ok, NewGuildInfo};
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY}
	end.







%% -----------------------------  帮会设施升级 end --------------------------------

%% 
%% %帮会会员栏扩展
%% update_guild_member_setting(ControlUserID,Type,GuildID,PidSend) ->
%% 	case update_guild_member_setting(GuildID, ControlUserID, Type) of
%% 		{ok,Level,Honor,Common,Associate} ->
%% 			{ok,BinData} =	pt_21:write(?PP_CLUB_EXTEND_UPDATE,[Level,Honor,Common,Associate]),
%% 			lib_send:send_to_guild_user(GuildID,BinData),
%% 			case get_guild_info(GuildID) of
%% 				{ok,GuildInfo} ->
%% 					{ok,BinDetail} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
%% 					lib_send:send_to_guild_user(GuildID,BinDetail);
%% 				{false,_Msg} ->
%% 					lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg])
%% 			end;
%% 		{false, _Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg])
%% 	end.
%% 
%% update_guild_member_setting(GuildID, ControlUserID, Type) ->
%% 	case get_guild_user_info(GuildID, ControlUserID) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		ControlMember ->
%% 			update_guild_member_setting1(ControlMember,Type)
%% 	end.
%% 
%% update_guild_member_setting1(ControlMember,Type) ->
%% 	case ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT of
%% 		true ->
%% 			update_guild_member_setting2(ControlMember,Type);
%% 		_ ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
%% 	end.
%% 
%% update_guild_member_setting2(ControlMember,Type) ->
%% 	case get_guild(ControlMember#ets_users_guilds.guild_id) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_GUILD};
%% 		GuildInfo ->
%% 			GuildSetting = data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level),
%% 			TMoney = GuildInfo#ets_guilds.money - ?GUILD_UPDATE_MEMBER_MONEY,
%% 			case Type of
%% 				?GUILD_MEMBER_HONORARY -> 
%% 					TMem = GuildInfo#ets_guilds.total_honorary_member + 1,
%% 					NewGuildInfo = GuildInfo#ets_guilds{total_honorary_member=TMem , money = TMoney},
%% 					UpdateL = [{total_honorary_member,TMem},{money,TMoney}],
%% 					CMem = GuildSetting#ets_guilds_template.honorary_member;
%% 				?GUILD_MEMBER_COMMON -> 
%% 					TMem = GuildInfo#ets_guilds.total_common_member + 1,
%% 					NewGuildInfo = GuildInfo#ets_guilds{total_common_member=TMem, money = TMoney },
%% 					UpdateL = [{total_common_member,TMem},{money,TMoney}],
%% 					CMem = GuildSetting#ets_guilds_template.common_member;
%% 				?GUILD_MEMBER_ASSOCIATE -> 
%% 					TMem = GuildInfo#ets_guilds.total_associate_member + 1,
%% 					NewGuildInfo = GuildInfo#ets_guilds{total_associate_member=TMem, money = TMoney },
%% 					UpdateL = [{total_associate_member,TMem},{money,TMoney}],
%% 					CMem = GuildSetting#ets_guilds_template.associate_member
%% 			end,
%% 			update_guild_member_setting3(TMoney,TMem,CMem,NewGuildInfo,UpdateL)
%% 	end.
%% 
%% update_guild_member_setting3(TMoney,TMem,CMem,NewGuildInfo,UpdateL) ->
%% 	case TMoney >= 0 of
%% 		true ->
%% 			update_guild_member_setting4(TMem,CMem,NewGuildInfo,UpdateL);
%% 		_ ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY}
%% 	end.
%% 
%% update_guild_member_setting4(TMem,CMem,NewGuildInfo,UpdateL) ->
%% 	case CMem >= TMem of
%% 		true ->
%% 			db_agent_guild:update_guild(UpdateL,[{id,NewGuildInfo#ets_guilds.id}]),
%% 			update_guilds_dic(NewGuildInfo),
%% 			{ok,NewGuildInfo#ets_guilds.guild_level,
%% 			 NewGuildInfo#ets_guilds.total_honorary_member,
%% 			 NewGuildInfo#ets_guilds.total_common_member,
%% 			 NewGuildInfo#ets_guilds.total_associate_member};
%% 		_ ->
%% 			{false,?_LANG_GUILD_ERROR_SETTING_MAX_NUMBER}
%% 	end.



%% ------------------------- 任命 start ---------------------------------
%修改帮会用户类型，数量在前端
edit_guild_user_member_type(ControlUserID,UserID,Type,GuildID,PidSend) ->
	case edit_guild_user_member_type(GuildID,ControlUserID,UserID,Type) of
		{ok,MsgType,NickName} ->
			ChatMsg = ?GET_TRAN(?_LANG_GUILDS_MEMBER_JOB_CHANGE,[NickName,MsgType]),
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,ChatMsg]),
			lib_send:send_to_guild_user(GuildID,BinChatMsg),
			GuildInfo = get_guild(GuildID),
			{ok,BinData} = pt_21:write(?PP_CLUB_DUTY_UPDATE,[GuildInfo,UserID,Type]),
			lib_send:send_to_guild_user(GuildID,BinData),
			{ok,BinCDData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
			lib_send:send_to_guild_user(GuildID,BinCDData);
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg]);
		_ ->
			skip
	end.

edit_guild_user_member_type(GuildID,ControlUserID,UserID,Type) ->
	case get_guild_user_info(GuildID,ControlUserID) of
		false ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		ControlMember ->
			case Type =/= ?GUILD_JOB_PRESIDENT of
				true ->
					edit_guild_user_member_type1(ControlMember,UserID,Type);
				_ ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
			end
	end.

edit_guild_user_member_type1(ControlMember,UserID,Type) ->
	case ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT  of
		true ->
			edit_guild_user_member_type2(ControlMember,UserID,Type);
		_ ->
			case ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT andalso
													Type =/= ?GUILD_JOB_VICE_PERSIDENT of
				true ->	%% 副帮主只任命副帮主以下
					edit_guild_user_member_type2(ControlMember,UserID,Type);
				_ ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}	
			end
	end.

edit_guild_user_member_type2(ControlMember,UserID,Type) ->
	case get_guild_user_info(ControlMember#ets_users_guilds.guild_id, UserID) of
		false ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			edit_guild_user_member_type3(ControlMember,Member,Type)
	end.

edit_guild_user_member_type3(ControlMember,Member,Type) ->
	case (ControlMember#ets_users_guilds.guild_id =:= Member#ets_users_guilds.guild_id) and
		 (Member#ets_users_guilds.member_type =/= ?GUILD_JOB_PRESIDENT) 	of
		true ->
			edit_guild_user_member_type4(Member,Type);
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
	end.	

edit_guild_user_member_type4(Member,Type) ->
	case get_guild(Member#ets_users_guilds.guild_id) of
		false ->
			{false,?_LANG_GUILD_ERROR_NOT_GUILD};
		GuildInfo ->
			edit_guild_user_member_type5(Member,GuildInfo,Type)
	end.

edit_guild_user_member_type5(Member,GuildInfo,Type) ->
	case data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level) of
		[] -> {false, ?_LANG_GUILD_ERROR_LEVEL};
		GuildSetting ->
			edit_guild_user_member_type6(Member,GuildInfo,GuildSetting,Type)
	end.

edit_guild_user_member_type6(Member,GuildInfo,GuildSetting,Type) ->
	if
%% 		GuildInfo#ets_guilds.total_member + 1 >  GuildSetting#ets_guilds_template.total_member 
%% 			{false,?_LANG_GUILD_ERROR_FULL_MEMBER};
		Type =:= ?GUILD_JOB_VICE_PERSIDENT andalso 
			GuildInfo#ets_guilds.current_vice_master_member + 1 >  GuildSetting#ets_guilds_template.vice_master_member ->
			{false,?_LANG_GUILD_ERROR_FULL_VICE_MASTER_MEMBER};
		Type =:= ?GUILD_MEMBER_HONORARY andalso 
			GuildInfo#ets_guilds.current_honorary_member + 1 >  GuildSetting#ets_guilds_template.honorary_member ->
			{false,?_LANG_GUILD_ERROR_FULL_HONORARY_MEMBER};
		true ->
			edit_guild_user_member_type7(Member,GuildInfo,Type)
	end.



edit_guild_user_member_type7(Member,GuildInfo,Type) ->
	db_agent_guild:update_user_guild([{member_type,Type}],[{user_id,Member#ets_users_guilds.user_id}]),
	
	case lib_player:get_online_info(Member#ets_users_guilds.user_id) of
		[] ->
			skip;
		OldLeaderPlayer ->
			gen_server:cast(OldLeaderPlayer#ets_users.other_data#user_other.pid,{guild_job_change,Type})
	end,
	
%% 	gen_server:cast(Member#ets_users.other_data#user_other.pid,{guild_job_change,Type}),
	
	case Member#ets_users_guilds.member_type of
		?GUILD_JOB_VICE_PERSIDENT ->
			NewGuildInfo = GuildInfo#ets_guilds{current_vice_master_member = GuildInfo#ets_guilds.current_vice_master_member - 1};
		?GUILD_MEMBER_HONORARY ->
			NewGuildInfo = GuildInfo#ets_guilds{current_honorary_member = GuildInfo#ets_guilds.current_honorary_member - 1};
		_ ->
			NewGuildInfo = GuildInfo
	end,
		
	
	{ VM , CM, MsgType } = 
		case Type of 
			?GUILD_JOB_VICE_PERSIDENT ->
				{NewGuildInfo#ets_guilds.current_vice_master_member + 1 ,NewGuildInfo#ets_guilds.current_honorary_member , ?_LANG_GUILDS_VICE_PERSIDENT};
			?GUILD_MEMBER_HONORARY -> 
				{NewGuildInfo#ets_guilds.current_vice_master_member ,NewGuildInfo#ets_guilds.current_honorary_member+1 , ?_LANG_GUILDS_HONORARY};
			?GUILD_MEMBER_COMMON -> 
				{NewGuildInfo#ets_guilds.current_vice_master_member, NewGuildInfo#ets_guilds.current_honorary_member, ?_LANG_GUILDS_COMMON}
		end,
	
	db_agent_guild:update_guild(
	  [{current_vice_master_member,VM},
	   {current_honorary_member,CM}]
	  ,[{id,NewGuildInfo#ets_guilds.id}]),
	
	update_guilds_dic(NewGuildInfo#ets_guilds{current_vice_master_member = VM,
												current_honorary_member = CM}),
	update_guilds_member(Member#ets_users_guilds{member_type = Type},true),
	{ok,MsgType,Member#ets_users_guilds.other_data#other_users_guilds.nick_name}.

	
	
%% 
%% 				
%% edit_guild_user_member_type4(Member,Type) ->
%% 	case get_guild(Member#ets_users_guilds.guild_id) of
%% 		false ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_GUILD};
%% 		GuildInfo ->
%% 			
%% 			
%% %% 			NickName = 
%% %% 				case lib_player:get_online_info(Member#ets_users_guilds.user_id) of
%% %% 					[] ->
%% %% 						[TmpNickName,_,_,_] = db_agent_user:get_user_friend_info_by_UserId(Member#ets_users_guilds.user_id),
%% %% 						TmpNickName;
%% %% 					MemberPlayer ->
%% %% 						gen_server:cast(MemberPlayer#ets_users.other_data#user_other.pid,{guild_job_change,Type}),
%% %% 						MemberPlayer#ets_users.nick_name
%% %% 				end,
%% 			NickName = Member#ets_users_guilds.other_data#other_users_guilds.nick_name,
%% 		
%% 			db_agent_guild:update_user_guild([{member_type,Type}],[{user_id,Member#ets_users_guilds.user_id}]),
%% 			
%% 			edit_guild_user_member_type5(Member#ets_users_guilds{member_type = Type},Type,GuildInfo,NickName)
%% %% 			if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT andalso Type =:= ?GUILD_MEMBER_HONORARY ->
%% %% 				   MsgType = ?_LANG_GUILDS_HONORARY,
%% %% 				   update_guilds_member(Member#ets_users_guilds{member_type = Type},true),
%% %% 				   {ok,MsgType,NickName};
%% %% 			   Member#ets_users_guilds.member_type =:= ?GUILD_MEMBER_HONORARY andalso Type =:= ?GUILD_JOB_VICE_PERSIDENT ->
%% %% 				   MsgType = ?_LANG_GUILDS_VICE_PERSIDENT,
%% %% 				   update_guilds_member(Member#ets_users_guilds{member_type = Type},true),
%% %% 				   {ok,MsgType,NickName};
%% %% 			   true ->
%% %% 				   edit_guild_user_member_type5(Member#ets_users_guilds{member_type = Type},Type,GuildInfo,NickName)
%% %% 			end
%% 	end.
%% 
%% edit_guild_user_member_type5(Member,Type,GuildInfo,NickName) ->
%% 	case Type of 
%% 		?GUILD_JOB_VICE_PERSIDENT ->
%% 			
%% 			MsgType = ?_LANG_GUILDS_VICE_PERSIDENT;
%% 		?GUILD_MEMBER_HONORARY -> 
%% 			MsgType = ?_LANG_GUILDS_HONORARY;
%% 		?GUILD_MEMBER_COMMON -> 
%% 			MsgType = ?_LANG_GUILDS_COMMON
%% 	end,
%% 	update_guilds_member(Member,true),
%% 	
%% 	NewGuildInfo = 
%% 	
%% 	NewGuildInfo = get_guild(GuildInfo#ets_guilds.id),
%% 	
%% 	{HM,CM,AM} = edit_guild_user_member_type5_1(NewGuildInfo#ets_guilds.other_data#other_guilds.members, 0,0,0),
%% 	db_agent_guild:update_guild(
%% 	  [{current_honorary_member,HM},{current_common_member,CM},{current_associate_member,AM}]
%% 	  ,[{id,NewGuildInfo#ets_guilds.id}]),
%% 	update_guilds_dic(NewGuildInfo#ets_guilds{current_honorary_member = HM,
%% 												current_common_member = CM,
%% 												current_associate_member = AM}),
%% 	
%% 	{ok,MsgType,NickName}.
%% 
%% edit_guild_user_member_type5_1([],HM,CM,AM) -> {HM,CM,AM};
%% edit_guild_user_member_type5_1(MemberL, HM,CM,AM) ->
%% 	[H|T] = MemberL,
%% 	case H#ets_users_guilds.member_type of
%% 		?GUILD_MEMBER_COMMON ->
%% 			NewHM = HM,
%% 			NewCM = CM + 1,
%% 			NewAM = AM;
%% 		?GUILD_MEMBER_ASSOCIATE ->
%% 			NewHM = HM,
%% 			NewCM = CM,
%% 			NewAM = AM + 1;
%% 		_ ->
%% 			NewHM = HM + 1,
%% 			NewCM = CM,
%% 			NewAM = AM
%% 	end,
%% 	edit_guild_user_member_type5_1(T,NewHM,NewCM,NewAM).

%% ------------------------- 任命 end ---------------------------------


%获取帮会及成员信息
get_guild_info_and_member(GuildID,UserID,PidSend) ->
	case get_guild(GuildID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT]);
		GuildInfo ->
			case get_guild_user_info(GuildID, UserID) of
				[] ->
					lib_chat:chat_sysmsg_pid([PidSend,
											  ?FLOAT,
											  ?None,
											  ?ORANGE,
											  <<>>]);
				Member ->
					{ok,Bin} = pt_21:write(?PP_CLUB_DUTY_UPDATE,[GuildInfo,
																 Member#ets_users_guilds.user_id,
																 Member#ets_users_guilds.member_type]),
					lib_send:send_to_sid(PidSend,Bin)
			end
	end.

%% %读取帮会扩展
%% get_guild_extend_info(GuildID, PidSend) ->
%% 	case get_guild_info(GuildID) of
%% 		{ok,GuildInfo} ->
%% 			{ok,Bin} = pt_21:write(?PP_CLUB_EXTEND_UPDATE,[GuildInfo#ets_guilds.guild_level,
%% 														   GuildInfo#ets_guilds.total_honorary_member,
%% 															GuildInfo#ets_guilds.total_common_member,
%% 															GuildInfo#ets_guilds.total_associate_member]),
%% 			lib_send:send_to_sid(PidSend,Bin);
%% 		{false,_Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg])
%% 	end.

%读取帮会升级
get_guild_levelup_info(GuildID,PidSend) ->
	case get_guild_info(GuildID) of
		{ok,GuildInfo} ->
			GuildSetting = 
			case data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level + 1) of
				[] ->
					#ets_guilds_template{need_contribute=0,need_activity=0,need_money=0};
				V ->
					V
			end,
			{ok,Bin} = pt_21:write(?PP_CLUB_LEVELUP_UPDATE,[GuildInfo#ets_guilds.guild_level,
															GuildSetting#ets_guilds_template.need_contribute,
															GuildSetting#ets_guilds_template.need_activity,
															GuildSetting#ets_guilds_template.need_money,
															GuildInfo#ets_guilds.money]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])%,
			%?PRINT("MSG ~p ~n",[_Msg])
	end.


get_guild_users_list_info(GuildID,PidSend) ->
	case get_guild_info(GuildID) of
		{ok,GuildInfo} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_MEMBER_LIST,[GuildInfo]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

get_guild_summon_num(GuildID,PidSend) ->
	case get_guild_info(GuildID) of
		{ok,GuildInfo} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_SUMMON_NUM,[GuildInfo#ets_guilds.summon_monster_num,
														GuildInfo#ets_guilds.summon_collect_num,
														GuildInfo#ets_guilds.other_data#other_guilds.summon_collent_time]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.
%读取帮会信息
get_guild_info(GuildID, PidSend) ->
	case get_guild_info(GuildID) of
		{ok,GuildInfo} ->
			{ok,BinData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
			lib_send:send_to_sid(PidSend,BinData);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

get_guild_info(GuildID) ->
	case get_guild(GuildID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_GUILD};
		GuildInfo ->
			{ok,GuildInfo}
	end.

%读取帮会成员信息
get_guild_user_info(GuildID, UserID,PidSend) ->
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  <<>>]);
		Member ->
			{ok,Bin} = pt_21:write(?PP_CLUB_SELF_EXPLOIT_UPDATE,[Member#ets_users_guilds.current_feats]),
			lib_send:send_to_sid(PidSend,Bin)
	end.


%% % 读帮会记事
%% get_guild_logs(GuildID,PidSend) ->
%% 	case get_guild_logs(GuildID) of
%% 		{false,_Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg]);
%% 		L ->
%% 			{ok,BinData} = pt_21:write(?PP_CLUB_EVENT_UPDATE,L),
%% 			lib_send:send_to_sid(PidSend,BinData)
%% 	end.

%% get_guild_logs(GuildID) ->
%% 	db_agent_guild:get_guild_logs(GuildID).

%获取帮会仓库日志列表
get_guild_warehouse_logs(GuildID,PidSend) ->
	case get_guild_warehouse_logs(GuildID) of
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg]);
		L ->
			{ok,BinData} = pt_21:write(?PP_CLUB_STORE_EVENT,L),
			lib_send:send_to_sid(PidSend,BinData)
	end.

get_guild_warehouse_logs(GuildID) ->
	db_agent_guild:get_guild_warehouse_logs(GuildID).
		

%分页读取帮会,Name=[]查全部
get_guild_list(Name,PageIndex,PageSize,PidSend) ->
	case get_guild_list(Name,PageIndex,PageSize) of
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg]);
		{C,L} ->
			{ok,BinData} = pt_21:write(?PP_CLUB_QUERYLIST,[C,L]),
			lib_send:send_to_sid(PidSend,BinData)
	end.

get_guild_list(Name,PageIndex,PageSize) ->
	case Name of
		[] ->
			GuildList = get_guilds_dic(),
			C = length(GuildList),
			Start = (PageIndex-1) * PageSize + 1,
			if Start > C ->
				   L = [];
			   true ->
				   L = lists:sublist(GuildList, Start , PageSize)
			end,
			{C,L};
		_ ->
			BName = tool:to_binary(Name),
			GuildList = get_guilds_dic(),
			case lists:keyfind(BName, #ets_guilds.guild_name, GuildList) of
				false ->
					{0,[]};
				GuildInfo ->
					{1,[GuildInfo]}
			end
	end.

%读取帮会成员
get_guild_users_list(GuildID) ->
	case get_guild(GuildID) of
		[] ->
			[];
		GuildInfo ->
			L = GuildInfo#ets_guilds.other_data#other_guilds.members,
			F = fun(V1,V2) -> V1#ets_users_guilds.member_type < V2#ets_users_guilds.member_type end,
			lists:sort(F, L)
	end.

%读取帮会成员，不需要排序
%% get_guild_users_list_no_sort(GuildID) ->
%% 	case get_guild(GuildID) of
%% 		[] ->
%% 			[];
%% 		GuildInfo ->
%% 			GuildInfo#ets_guilds.other_data#other_guilds.members
%% 	end.

%% %获取帮会军团列表 todo 军团成员未处理
%% get_guild_corps_list(GuildID) ->
%% 	case get_guild(GuildID) of
%% 		[] ->
%% 			[];
%% 		GuildInfo ->
%% 			GuildInfo#ets_guilds.other_data#other_guilds.guilds_corps
%% 	end.


%读取申请列表-页码1开始
get_guild_users_request(GuildID, UserID, PageIndex, PageSize, PidSend) ->
	case get_guild_users_request(GuildID, UserID, PageIndex, PageSize) of
		{Count,L} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_QUERYTRYIN,[L,Count]),
			lib_send:send_to_sid(PidSend,Bin);
		[] ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILD_ERROR_TRYIN_NULL])
	end.


get_guild_users_request(GuildID, UserID, PageIndex, PageSize) ->
	case get_guild_user_info(GuildID, UserID) of
		[] -> 
			[];
		Member->
			if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
				Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT orelse
				Member#ets_users_guilds.member_type =:= ?GUILD_MEMBER_HONORARY	->
%% 				   GuildInfo = get_guild(GuildID),
%% 				   L = GuildInfo#ets_guilds.other_data#other_guilds.requests,
				   L = get_guild_request_by_guildid(GuildID),
				   CountL = length(L),
				   CutIndex = (PageIndex - 1) * PageSize + 1,
				   if CutIndex > CountL ->
						  {CountL, []};
					  true ->
						  {CountL,lists:sublist(L , CutIndex , PageSize)}
				   end;
			   true ->
				   []
			end
	end.

%清除申请列表
clear_guild_users_request(GuildID,UserID,PidSend) ->
	case clear_guild_users_request(GuildID,UserID) of
		{ok} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_QUERYTRYIN,[[],0]),
			lib_send:send_to_sid(PidSend,Bin);
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

clear_guild_users_request(GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] -> 
			[];
		Member ->
			clear_guild_users_request1(Member)
	end.

clear_guild_users_request1(Member) ->
	if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT ->
			clear_guild_users_request2(Member#ets_users_guilds.guild_id);
		true ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
	end.

clear_guild_users_request2(GuildID) ->
	db_agent_guild:delete_guild_user_request([{guild_id,GuildID}]),
	GuildInfo = get_guild(GuildID),
	db_agent_guild:update_guild([{requests_number,0}],
								[{id,GuildInfo#ets_guilds.id}]),
	
	update_guilds_dic(GuildInfo#ets_guilds{requests_number = 0}),
	
	delete_guilds_request_by_guildid(GuildID),
	{ok}.



%请求转让帮会
demise_chief(GuildID,LeaderID,LeaderName,UserID,PidSend) ->
	case demise_chief(GuildID,LeaderID,LeaderName,UserID) of
		{ok,TargetUserPid,LeaderID,LeaderName} ->
			{ok,Bin} = pt_21:write(?PP_CLUB_TRANSFER,[LeaderName,LeaderID]),
			lib_send:send_to_sid(TargetUserPid,Bin);
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.
	
demise_chief(GuildID, LeaderID,LeaderName,UserID) ->
	case get_guild_user_info(GuildID, LeaderID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		LeaderMember ->
			if LeaderMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT ->
				   demise_chief1(LeaderMember,LeaderName,UserID);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
			end
	end.

demise_chief1(LeaderMember,LeaderName,UserID) ->
	case get_guild_user_info(LeaderMember#ets_users_guilds.guild_id, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_SAME_GUILD};
		UserMember ->
			if LeaderMember#ets_users_guilds.guild_id =:= UserMember#ets_users_guilds.guild_id ->
				   demise_chief2(LeaderMember#ets_users_guilds.user_id,LeaderName,UserID);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_SAME_GUILD}
			end
	end.

demise_chief2(LeaderID,LeaderName,UserID) ->
	case lib_player:get_online_info(UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ONLINE};
		User ->
			if User#ets_users.level >= ?GUILD_BUILD_LEVEL ->
			%注意要写日志记录这个事件
					{ok,User#ets_users.other_data#user_other.pid_send,LeaderID, LeaderName}; %用于返回时重复验证
			   true ->
				   {false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_LEVEL}
			end
	end.
%% -----------------------同意转让帮会 start---------------------------
%同意转让帮会
agree_demise_chief(LeaderID,UserID,UserName,GuildID,PidSend) ->
	case agree_demise_chief(GuildID,LeaderID,UserID,UserName) of
		{ok} ->
			case get_guild_info(GuildID) of
				{ok,GuildInfo} ->
%% 					MemberL = get_guild_users_list(GuildID),
					{ok,BinData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
					lib_send:send_to_guild_user(GuildID,BinData);
				{false,_Msg} ->
					lib_chat:chat_sysmsg_pid([PidSend,
											  ?FLOAT,
											  ?None,
											  ?ORANGE,
											  _Msg])
			end;
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

agree_demise_chief(GuildID,LeaderID,UserID,UserName) ->
	case get_guild_user_info(GuildID, LeaderID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		LeaderMember ->
			if LeaderMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT ->
				   agree_demise_chief1(LeaderMember,UserID,UserName);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
			end
	end.

agree_demise_chief1(LeaderMember,UserID,UserName) ->
	case get_guild_user_info(LeaderMember#ets_users_guilds.guild_id, UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_SAME_GUILD};
		UserMember ->
			if LeaderMember#ets_users_guilds.guild_id =:= UserMember#ets_users_guilds.guild_id ->
				   agree_demise_chief2(LeaderMember,UserMember,UserName);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_SAME_GUILD}
			end
	end.

agree_demise_chief2(LeaderMember,UserMember,UserName) ->
	GuildInfo = get_guild(LeaderMember#ets_users_guilds.guild_id),
	%交换身份
	NewLeader = UserMember#ets_users_guilds{member_type = LeaderMember#ets_users_guilds.member_type },
	NewUser = LeaderMember#ets_users_guilds{member_type = UserMember#ets_users_guilds.member_type },
	
	NewGuildInfo = GuildInfo#ets_guilds{master_name = UserName ,master_id = NewLeader#ets_users_guilds.user_id , master_type = NewLeader#ets_users_guilds.other_data#other_users_guilds.vipid},
	
	db_agent_guild:update_user_guild([{member_type,NewLeader#ets_users_guilds.member_type}],
											 [{user_id,NewLeader#ets_users_guilds.user_id}]),
	db_agent_guild:update_user_guild([{member_type,NewUser#ets_users_guilds.member_type}],
											 [{user_id,NewUser#ets_users_guilds.user_id}]),
	db_agent_guild:update_guild([{master_name,UserName},{master_id,NewGuildInfo#ets_guilds.master_id}],[{id,NewGuildInfo#ets_guilds.id}]),
	update_guilds_dic(NewGuildInfo),
	update_guilds_member(NewUser,false),
	update_guilds_member(NewLeader,true),	%% 第二次处理后排序
	case lib_player:get_online_info(LeaderMember#ets_users_guilds.user_id) of
		[] ->
			skip;
		OldLeaderPlayer ->
			gen_server:cast(OldLeaderPlayer#ets_users.other_data#user_other.pid,{guild_job_change,UserMember#ets_users_guilds.member_type})
	end,
	case lib_player:get_online_info(UserMember#ets_users_guilds.user_id) of
		[] ->
			skip;
		NewLeaderPlayer ->
			gen_server:cast(NewLeaderPlayer#ets_users.other_data#user_other.pid,{guild_job_change,LeaderMember#ets_users_guilds.member_type})
	end,
	{ok}.

%% -----------------------同意转让帮会 end---------------------------


%% -----------------------玩家申请处理 start---------------------------
%玩家申请处理
agree_guild_users_request(ControlUserID,UserID,PidSend,GuildID,PageIndex,PageSize) ->
	case agree_guild_users_request(GuildID,ControlUserID,UserID) of
		{ok,TargetUserName} ->
			case get_guild_users_request(GuildID,ControlUserID,PageIndex,PageSize) of
				{Count,L} ->
					{ok,Bin} = pt_21:write(?PP_CLUB_QUERYTRYIN,[L,Count]),
					lib_send:send_to_sid(PidSend,Bin),
					lib_chat:chat_sysmsg_pid([PidSend,
											  ?FLOAT,
											  ?None,
											  ?ORANGE,
											  ?_LANG_GUILD_REQUEST_SUCCESS]),
					case get_guild_info(GuildID) of
						{ok,GuildInfo} ->
							UserMsg = ?GET_TRAN(?_LANG_GUILD_REQUEST_TARGET_SUCCESS,[GuildInfo#ets_guilds.guild_name]),
							lib_chat:chat_sysmsg([UserID,
												  ?CHAT,
												  ?None,
												  ?ORANGE,
												  UserMsg]),
%% 							MemberL = get_guild_users_list(GuildID),
							{ok,BinData} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
							UserInMsg = ?GET_TRAN(?_LANG_GUILD_PLAYER_IN,[TargetUserName]),
							{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,UserInMsg]),
							{ok,PlayerInData} = pt_21:write(?PP_CLUB_NEW_PLAYER_IN,[UserID,TargetUserName]),
							lib_send:send_to_guild_user(GuildID,BinData),
							lib_send:send_to_guild_user(GuildID,PlayerInData),
							lib_send:send_to_guild_user(GuildID,BinChatMsg);
						{false,_Msg} ->
							lib_chat:chat_sysmsg_pid([PidSend,
													  ?FLOAT,
													  ?None,
													  ?ORANGE,
													  _Msg])
					end;
				[] ->
					lib_chat:chat_sysmsg_pid([PidSend,
											  ?FLOAT,
											  ?None,
											  ?ORANGE,
											  ?_LANG_GUILD_ERROR_TRYIN_NULL])
			end;
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

agree_guild_users_request(GuildID,ControlUserID,UserID) ->
	case get_guild_user_info(GuildID,ControlUserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
				Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT orelse 
				Member#ets_users_guilds.member_type =:= ?GUILD_MEMBER_HONORARY ->
				   agree_guild_users_request1(UserID,Member#ets_users_guilds.guild_id);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
			end
	end.

agree_guild_users_request1(UserID,GuildID) ->
 	GuildInfo = get_guild(GuildID),
	case get_guild_request(GuildID, UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NEVER_TRYIN};
		_ ->
			agree_guild_users_request2(UserID, GuildInfo)
	end.			

agree_guild_users_request2(UserID, GuildInfo) ->
	GuildSetting = data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level),
	if GuildSetting#ets_guilds_template.total_member >= GuildInfo#ets_guilds.total_member + 1 ->
		   agree_guild_users_request3(UserID,GuildInfo);
	   true ->
		   {false,?_LANG_GUILD_ERROR_FULL_MEMBER}
	end.

agree_guild_users_request3(UserID,GuildInfo) ->
	case get_leave_guilds(UserID) of
		[] -> 
			agree_guild_users_request3_1(0,[],UserID,GuildInfo);
%% 			agree_guild_users_request4(UserID,GuildInfo);
		LeaveMember ->
			LeaveTime = misc_timer:now_seconds() - LeaveMember#ets_users_guilds.join_date,
			if LeaveTime < ?GUILD_LEAVE_JOIN_TIME ->
					{false, ?_LANG_GUILD_ERROR_TARGET_LEAVE_TIME_NOT_ENOUGH};
			   true ->
				   db_agent_guild:delete_guild_user([{user_id,LeaveMember#ets_users_guilds.user_id}]),
				   delete_leave_guilds_dic(LeaveMember),
				   agree_guild_users_request3_1(LeaveMember#ets_users_guilds.get_weal_date,
												LeaveMember#ets_users_guilds.other_data#other_users_guilds.use_feats_list,
												UserID,GuildInfo)
			end
	end.

agree_guild_users_request3_1(GetWealDate,FeatsList,UserID, GuildInfo) ->
	case get_users_guild(UserID) of
		[] ->
			agree_guild_users_request4(GetWealDate,FeatsList,UserID,GuildInfo);
		_ ->
			{false, ?_LANG_GUILD_ERROR_ALREADY_HAVE_GUILD1}
	end.
	
agree_guild_users_request4(GetWealDate,FeatsList,UserID,GuildInfo) ->
	{Name,Career,Level,VipId,Sex,Fight,LastOnlineTime,Online} = lib_player:get_player_info_guild_use_by_id(UserID),
	Other_Data = #other_users_guilds{
									 	nick_name = Name, %%姓名
										career = Career,		%%职业
										level = Level,		%%等级
										vipid = VipId,		%% vip等级
										fight = Fight,
										last_online_time = LastOnlineTime,
										sex = Sex,
										use_feats_list = FeatsList,
										online = Online		%%是否在线
									 },
	UserGuild = #ets_users_guilds{
								   user_id = UserID,
								   guild_id = GuildInfo#ets_guilds.id,
								   member_type = ?GUILD_MEMBER_COMMON,
								   get_weal_date = GetWealDate,
%% 								   corp_id = 0,
%% 								   corp_job = ?GUILD_CORP_JOB_NOT_IN,
								   join_date = misc_timer:now_seconds(),
								   other_data = Other_Data
								   },
	case db_agent_guild:create_guild_user(UserGuild) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			UserPid = lib_player:get_player_pid(UserID),
			if UserPid =/= [] ->
					gen_server:cast(UserPid,{join_guild, GuildInfo#ets_guilds.id,GuildInfo#ets_guilds.guild_name,?GUILD_MEMBER_COMMON,GuildInfo#ets_guilds.guild_level,GuildInfo#ets_guilds.furnace_level});
			   true ->
				   skip
			end,
			db_agent_guild:delete_guild_user_request([{user_id,UserID}]),
			agree_guild_users_request5(GuildInfo,Name,UserGuild);
		_Other ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	end.

agree_guild_users_request5(GuildInfo,Name,UserGuild) ->
	AssMem = GuildInfo#ets_guilds.total_member + 1,
	ReqNum = GuildInfo#ets_guilds.requests_number - 1,
	NewGuildInfo = GuildInfo#ets_guilds{total_member=AssMem,requests_number = ReqNum },
	db_agent_guild:update_guild([{total_member,AssMem},{requests_number,ReqNum}],
								[{id,GuildInfo#ets_guilds.id}]),
%% 	?DEBUG("~w",[NewGuildInfo#ets_guilds.requests_number]),
	update_guilds_dic(NewGuildInfo),
	update_guilds_member(UserGuild,false),
	delete_guilds_request_by_userid(UserGuild#ets_users_guilds.user_id),
	update_users_guild(#r_users_guilds{guild_id = GuildInfo#ets_guilds.id,user_id = UserGuild#ets_users_guilds.user_id}),
	{ok,Name}.



%% -----------------------玩家申请处理 end---------------------------

%% -----------------------拒绝申请 start---------------------------
%% 拒绝申请
disagree_guild_users_request(GuildID,ControlUserID,UserID,PidSend,PageIndex,PageSize) ->
	case disagree_guild_users_request(GuildID,ControlUserID,UserID) of
		{ok} ->
			case get_guild_users_request(GuildID,ControlUserID,PageIndex,PageSize) of
				{Count,L} ->
					{ok,Bin} = pt_21:write(?PP_CLUB_QUERYTRYIN,[L,Count]),
					lib_send:send_to_sid(PidSend,Bin);
				[] ->
					lib_chat:chat_sysmsg_pid([PidSend,
											  ?FLOAT,
											  ?None,
											  ?ORANGE,
											  ?_LANG_GUILD_ERROR_TRYIN_NULL])
			end;
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

disagree_guild_users_request(GuildID, ControlUserID,UserID) ->
	case get_guild_user_info(GuildID, ControlUserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			if Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
				Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT ->
				   disagree_guild_users_request1(UserID,Member#ets_users_guilds.guild_id);
			   true ->
				   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
			end
	end.

disagree_guild_users_request1(UserID,GuildID) ->
	case get_guild_request(GuildID, UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NEVER_TRYIN};
		_ ->
			disagree_guild_users_request2(UserID,GuildID)
	end.

disagree_guild_users_request2(UserID,GuildID) ->
	GuildInfo = get_guild(GuildID),
	ReqNum = GuildInfo#ets_guilds.requests_number - 1,
	NewGuildInfo = GuildInfo#ets_guilds{requests_number = ReqNum },
	db_agent_guild:update_guild([{requests_number,ReqNum}],
								[{id,NewGuildInfo#ets_guilds.id}]),
	update_guilds_dic(NewGuildInfo),
	
	db_agent_guild:delete_guild_user_request([{user_id,UserID},{guild_id,GuildID}]),
	delete_guilds_request_by_request(GuildID,UserID),
	{ok}.

%% -----------------------拒绝申请  end ---------------------------

%% -----------------------同意邀请  start ---------------------------
%同意邀请
agree_guild_users_invite(UserID,GuildID,UserGuildID,PidSend,UserNick) ->
	case agree_guild_users_invite(UserID,GuildID) of
		{ok} ->
			case get_guild_info(GuildID) of
				{ok,GuildInfo} ->
					UserMsg = ?GET_TRAN(?_LANG_GUILD_REQUEST_TARGET_SUCCESS,[GuildInfo#ets_guilds.guild_name]),
							lib_chat:chat_sysmsg_pid([PidSend,
												  ?CHAT,
												  ?None,
												  ?ORANGE,
												  UserMsg]),
							
							UserInMsg = ?GET_TRAN(?_LANG_GUILD_PLAYER_IN,[UserNick]),
							{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,UserInMsg]),
							lib_send:send_to_guild_user(GuildInfo#ets_guilds.id,BinChatMsg),
							{ok,BinData} = pt_21:write(?PP_CLUB_NEW_PLAYER_IN,[UserID,UserNick]),
							lib_send:send_to_guild_user(GuildInfo#ets_guilds.id,BinData),
%% 							MemberL = get_guild_users_list(UserGuildID),
							{ok,BinData1} = pt_21:write(?PP_CLUB_DETAIL,[GuildInfo]),
							lib_send:send_to_guild_user(GuildInfo#ets_guilds.id,BinData1);
						{false,_Msg} ->
							lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])%,
							%?PRINT("MSG ~p ~n",[_Msg])
					end;
		{ok,_CorpName} ->
			skip;
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE, _Msg]);
		_ ->
			skip
	end.

agree_guild_users_invite(UserID,GuildID) ->
	case get_leave_guilds(UserID) of
		[] ->
			agree_guild_users_invite2(0,[],UserID,GuildID);
		Leave ->
			LeaveTime = misc_timer:now_seconds() - Leave#ets_users_guilds.join_date,
			if LeaveTime < ?GUILD_LEAVE_JOIN_TIME ->
				   {false, ?_LANG_GUILD_ERROR_LEAVE_TIME_NOT_ENOUGH};
			   true ->
				  agree_guild_users_invite2(Leave#ets_users_guilds.get_weal_date,
											Leave#ets_users_guilds.other_data#other_users_guilds.use_feats_list,UserID,GuildID)
			end
	end.

%% agree_guild_users_invite1(UserID, GuildID) ->
%% 	case get_users_guild(UserID) of
%% 		[] ->
%% 			case get_leave_guilds(UserID) of
%% 				[] ->
%% 					agree_guild_users_invite2(UserID,GuildID);
%% 				Leave ->
%% 					LeaveTime = misc_timer:now_seconds() - Leave#ets_users_guilds.join_date,
%% 					if LeaveTime < ?GUILD_LEAVE_JOIN_TIME ->
%% 						   {false, ?_LANG_GUILD_ERROR_LEAVE_TIME_NOT_ENOUGH};
%% 					   true ->
%% 						   agree_guild_users_invite2(UserID,GuildID)
%% 					end
%% 			end;
%% 		_ ->
%% 			ok
%% 		
%% 	end.
%% 			
					
agree_guild_users_invite2(GetWealDate,FeatsList,UserID,GuildID) ->
	case get_guild(GuildID) of
		[] -> 
			{false, ?_LANG_GUILD_ERROR_NOT_GUILD};
		GuildInfo ->
			GuildSetting = data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level),
			if GuildSetting#ets_guilds_template.total_member >= GuildInfo#ets_guilds.total_member + 1 ->
		   		agree_guild_users_invite5(GetWealDate,FeatsList,UserID,GuildInfo);
	   		true ->
		   		{false,?_LANG_GUILD_ERROR_FULL_MEMBER}
			end
	end.

agree_guild_users_invite5(GetWealDate,FeatsList,UserID,GuildInfo) -> 
	{Name,Career,Level,VipId,Sex,Fight,LastOnlineTime,Online} = lib_player:get_player_info_guild_use_by_id(UserID),
	
	Other_Data = #other_users_guilds{
									 	nick_name = Name, %%姓名
										career = Career,		%%职业
										level = Level,		%%等级
										vipid = VipId,		%% vip等级
										sex = Sex,
										fight = Fight,
										last_online_time = LastOnlineTime,
										online = Online,		%%是否在线
										use_feats_list = FeatsList
									 },
	UserGuild = #ets_users_guilds{
								   user_id = UserID,
								   guild_id = GuildInfo#ets_guilds.id,
								   member_type = ?GUILD_MEMBER_COMMON,	
								   get_weal_date = GetWealDate,
%% 								   corp_id = 0,
%% 								   corp_job = ?GUILD_CORP_JOB_NOT_IN,
								   join_date = misc_timer:now_seconds(),
								   other_data = Other_Data
								   },
	case db_agent_guild:create_guild_user(UserGuild) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			UserPid = lib_player:get_player_pid(UserID),
			if UserPid =/= [] ->
					gen_server:cast(UserPid,{join_guild, GuildInfo#ets_guilds.id,GuildInfo#ets_guilds.guild_name,?GUILD_MEMBER_COMMON,GuildInfo#ets_guilds.guild_level,GuildInfo#ets_guilds.furnace_level});
			   true ->
				   skip
			end,
			db_agent_guild:delete_guild_user_request([{user_id,UserID}]),
			agree_guild_users_invite5_1(GuildInfo,UserGuild);
		_Other ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	end.

agree_guild_users_invite5_1(GuildInfo,UserGuild) ->
	AssMem = GuildInfo#ets_guilds.total_member + 1,
	NewGuildInfo = GuildInfo#ets_guilds{total_member=AssMem },
	db_agent_guild:update_guild([{total_member,AssMem}],
								[{id,GuildInfo#ets_guilds.id}]),
	update_guilds_dic(NewGuildInfo),
	update_guilds_member(UserGuild,false),
	delete_guilds_request_by_userid(UserGuild#ets_users_guilds.user_id),
	update_users_guild(#r_users_guilds{guild_id = GuildInfo#ets_guilds.id,user_id = UserGuild#ets_users_guilds.user_id}),
	{ok}.




%% -----------------------同意邀请  end ---------------------------


%% -----------------------申请加入帮会 start ---------------------------

%%申请加入帮会
request_join_guild(UserID,UserLevel,GuildID,PidSend) ->
	case request_join_guild(UserID,UserLevel,GuildID) of
		{ok} ->
			ok;
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
  									?FLOAT,
  									?None,
  									?ORANGE,
  									_Msg])
	end.
	
%% 	case get_guild(GuildID) of
%% 		[] ->
%% 			skip;
%% 		GuildInfo ->
%% 			
%% 			
%% 			F = fun(X, CountL) -> 
%% 						{CH,CM,CA} = CountL,
%% 						if X#ets_users_guilds.member_type =:= 4 ->
%% 					   			{CH,CM+1,CA};
%% 					   		X#ets_users_guilds.member_type =:= 5 ->
%%    								{CH,CM,CA + 1};
%%    							true ->
%%   								 {CH+1,CM,CA}
%% 						end
%% 				end,
%% 			{OCH,OCM,OCA} = lists:foldr(F,{0,0,0},GuildInfo#ets_guilds.other_data#other_guilds.members),
%% 			update_guilds_dic(GuildInfo#ets_guilds{current_honorary_member=OCH,
%%    													current_common_member = OCM,
%%    													current_associate_member = OCA
%%    													})
%% 	end,
%% 	case request_join_guild(UserID,UserLevel,GuildID) of
%% 		{ok} ->
%% 			ok;
%% 		{false, _Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%%   									?FLOAT,
%%   									?None,
%%   									?ORANGE,
%%   									_Msg])
%% 	end.

request_join_guild(UserID,UserLevel,GuildID) ->
 	case get_guild(GuildID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_GUILD};
		GuildInfo ->
			request_join_guild1(UserID,UserLevel,GuildInfo)
	end.
	
request_join_guild1(UserID,UserLevel,GuildInfo) ->
	if UserLevel >= ?GUILD_JOIN_LEVEL ->
		   request_join_guild1_1(UserID,GuildInfo);
	   true ->
		   {false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_LEVEL}
	end.

request_join_guild1_1(UserID,GuildInfo) ->
	case get_users_guild(UserID) of
		[] -> 
			request_join_guild1_2(UserID,GuildInfo);
		_Record ->
			{false, ?_LANG_GUILD_ERROR_ALREADY_HAVE_GUILD1}
	end.

request_join_guild1_2(UserID,GuildInfo) ->
	case get_leave_guilds(UserID) of
		[] ->
			request_join_guild2(UserID, GuildInfo);
		Leave ->
			LeaveTime = misc_timer:now_seconds() - Leave#ets_users_guilds.join_date,
			if LeaveTime < ?GUILD_LEAVE_JOIN_TIME ->
					{false, ?_LANG_GUILD_ERROR_LEAVE_TIME_NOT_ENOUGH};
			   true ->
				   db_agent_guild:delete_guild_user([{user_id,Leave#ets_users_guilds.user_id}]),
				   request_join_guild2(UserID,GuildInfo)
			end
	end.


request_join_guild2(UserID,GuildInfo) ->
	case get_guild_request(GuildInfo#ets_guilds.id, UserID) of
		[] ->
			request_join_guild3(UserID,GuildInfo);
		[Request] ->
			update_guilds_request(Request#ets_users_guilds_request{request_date=misc_timer:now_seconds()}),
			{false, ?_LANG_GUILD_ERROR_ALREADY_TRYIN}
	end.

request_join_guild3(UserID,GuildInfo) ->
	GuildSetting = data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level),
%% 	if GuildSetting#ets_guilds_template.total_requests_number >= GuildInfo#ets_guilds.requests_number ->
		   request_join_guild4(UserID,GuildInfo).
%% 	   true ->
%% 		   {false,?_LANG_GUILD_ERROR_REQUEST_FULL_MEMBER}
%% 	end.

request_join_guild4(UserID,GuildInfo) ->
	{UserName,Career,Level,VipId,Sex,Fight,LastOnlineTime,Online} = lib_player:get_player_info_guild_use_by_id(UserID),
	RequestTime = misc_timer:now_seconds(),
	UserGuildRequest = #ets_users_guilds_request{
								   user_id = UserID,
								   guild_id = GuildInfo#ets_guilds.id,
								   request_date = RequestTime
								   },
	case db_agent_guild:create_guild_user_request(UserGuildRequest) of
		{mongo, _Id} ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE};
		1 ->
			%写ets记录
			update_guilds_request(UserGuildRequest#ets_users_guilds_request{
									other_data=#other_users_guilds_request{
												nick_name = UserName,
											   	career = Career,
											   	level = Level,
												vipid = VipId,
												sex = Sex,
											   	online = Online
												}}),
			
			AssMem = GuildInfo#ets_guilds.requests_number + 1,
			NewGuildInfo = GuildInfo#ets_guilds{requests_number = AssMem },
			db_agent_guild:update_guild([{requests_number,AssMem}],
								[{id,GuildInfo#ets_guilds.id}]),
			update_guilds_dic(NewGuildInfo),
			{ok};
		_Other ->
			{false, ?_LANG_GUILD_ERROR_DB_CAUSE}
	end.

%% 邀请加入帮会 
invite_join_guild(GuildID,InviteUserID,InviteUserName,UserNick,UserPidSend) ->
	case invite_join_guild(GuildID,InviteUserID,InviteUserName,UserNick) of
		{ok,PidSend,InviteUserName,GuildID,GuildName} ->
			lib_chat:chat_sysmsg_pid([UserPidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  ?_LANG_GUILD_PLAYER_INVITE]),
			{ok,Bin} = pt_21:write(?PP_CLUB_INVITE,[InviteUserName,GuildName,GuildID]),
			lib_send:send_to_sid(PidSend,Bin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([UserPidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

invite_join_guild(GuildID,InviteUserID,InviteUserName,UserNick) ->
	case db_agent_user:get_user_friend_info_by_Nick(UserNick) of
		[UserID, _FriendSex, _UserLevel, _FriendOnline] ->
			case get_guild_user_info(GuildID,InviteUserID) of
				[] -> 
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				InviteMember ->
					if InviteMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
						InviteMember#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT ->
						   invite_join_guild1(InviteUserName,UserID,InviteMember#ets_users_guilds.guild_id);
					   true ->
						   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
					end
			end;
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER}
	end.

invite_join_guild1(InviteUserName,UserID,GuildID) ->
	case lib_player:get_online_info(UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ONLINE};
		User ->
			invite_join_guild2(InviteUserName,UserID,GuildID,User#ets_users.level,User#ets_users.other_data#user_other.pid_send)
	end.

invite_join_guild2(InviteUserName,UserID,GuildID,UserLevel,UserPidSend) ->
	case UserLevel >= ?GUILD_JOIN_LEVEL of
		true ->
			case get_guild(GuildID) of
				[] -> {false, ?_LANG_GUILD_ERROR_NOT_GUILD};
				GuildInfo ->
					GuildSetting = data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level),
%% 					if GuildSetting#ets_guilds_template.total_requests_number >= GuildInfo#ets_guilds.requests_number ->
						   invite_join_guild3(InviteUserName,UserID,GuildID,GuildInfo#ets_guilds.guild_name,UserPidSend)
%% 					   true ->
%% 						   {false,?_LANG_GUILD_ERROR_REQUEST_FULL_MEMBER}
%% 					end
			end;
		_ ->
			{false,?_LANG_GUILD_ERROR_INVITE_NOT_ENOUGH_LEVEL}
	end.

invite_join_guild3(InviteUserName, UserID,GuildID, GuildName,UserPidSend) ->
	case get_users_guild(UserID) of
		[] -> 
			invite_join_guild4(InviteUserName, UserID,GuildID, GuildName,UserPidSend);
		_Record ->
			{false, ?_LANG_GUILD_ERROR_TARGET_ALREADY_HAVE_GUILD}
	end.

invite_join_guild4(InviteUserName, UserID,GuildID, GuildName,UserPidSend) ->
	case get_leave_guilds(UserID) of
		[] ->
			{ok,UserPidSend,InviteUserName,GuildID,GuildName};
		Leave ->
			LeaveTime = misc_timer:now_seconds() - Leave#ets_users_guilds.join_date,
			if LeaveTime < ?GUILD_LEAVE_JOIN_TIME ->
					{false, ?_LANG_GUILD_ERROR_TARGET_LEAVE_TIME_NOT_ENOUGH};
			   true ->
				   db_agent_guild:delete_guild_user([{user_id,Leave#ets_users_guilds.user_id}]),
				   {ok,UserPidSend,InviteUserName,GuildID,GuildName}
			end
	end.

%% %邀请加入军团
%% invite_join_corp(GuildID,InviteUserID,InviteUserName,UserNick,CorpName,PidSend) ->
%% 	case invite_join_corp(GuildID,
%% 						  InviteUserID,
%% 						  InviteUserName,
%% 						  UserNick,
%% 						  CorpName) of
%% 		{ok,UserPid,MasterNick,ClubName,ClubID,InviteCorpName,CorpID} -> 
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									 ?FLOAT,
%% 									 ?None,
%% 									 ?ORANGE,
%% 									 ?_LANG_GUILD_PLAYER_INVITE]),
%% 			{ok,Bin} = pt_21:write(?PP_CLUB_ARMY_INVITE,[MasterNick,ClubName,ClubID,InviteCorpName,CorpID]),
%% 			lib_send:send_to_sid(UserPid,Bin);
%% 		{ok, TargetUserPidSend, InviteMasterNick, InviteCorpName, InviteCorpID} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									 ?FLOAT,
%% 									 ?None,
%% 									 ?ORANGE,
%% 									 ?_LANG_GUILD_PLAYER_INVITE]),
%% 			{ok,Bin} = pt_21:write(?PP_CLUB_ARMY_INVITE,[InviteMasterNick,"",0,InviteCorpName,InviteCorpID]),
%% 			lib_send:send_to_sid(TargetUserPidSend,Bin);
%% 		{false,_Msg} ->
%% 			lib_chat:chat_sysmsg_pid([PidSend,
%% 									  ?FLOAT,
%% 									  ?None,
%% 									  ?ORANGE,
%% 									  _Msg])
%% 	end.
%% 
%% 
%% invite_join_corp(GuildID,InviteUserID,InviteUserName,UserNick,CorpName) ->
%% 	case db_agent_user:get_user_friend_info_by_Nick(UserNick) of
%% 		[UserID, _FriendSex, _FriendLevel, _FriendOnline] ->
%% 			case get_guild_user_info(GuildID,InviteUserID) of
%% 				[] -> 
%% 					{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 				InviteMember ->
%% 					if InviteMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
%% 						InviteMember#ets_users_guilds.corp_job =:= ?GUILD_JOB_VICE_PERSIDENT ->
%% 						   invite_join_corp1(InviteUserName,
%% 											 UserID,
%% 											 InviteMember#ets_users_guilds.guild_id,
%% 											 CorpName);
%% 					   true ->
%% 						   {false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
%% 					end
%% 			end;
%% 		_ ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER}
%% 	end.
%% 
%% invite_join_corp1(InviteUserName,UserID,GuildID,CorpName) ->
%% 	GuildInfo = get_guild(GuildID),
%% 	OldCorpName = tool:to_binary(CorpName),
%% 	case lists:keyfind(OldCorpName, #ets_guilds_corps.corp_name, GuildInfo#ets_guilds.other_data#other_guilds.guilds_corps) of
%% 		false ->
%% 			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		Corp ->
%% 			if ?GUILD_CORP_MEMBER_MAX > Corp#ets_guilds_corps.member_number ->
%% 				   invite_join_corp2(InviteUserName,UserID,GuildID,Corp,GuildInfo);
%% 			   true ->
%% 				   {false, ?_LANG_GUILD_ERROR_CORP_FULL_MEMBER}
%% 			end
%% 	end.
%% 
%% invite_join_corp2(InviteUserName,UserID,GuildID,Corp,GuildInfo) ->
%% 	if Corp#ets_guilds_corps.guild_id =:= GuildID ->
%% 		   invite_join_corp3(InviteUserName,UserID,GuildID,Corp#ets_guilds_corps.corp_name,Corp#ets_guilds_corps.id,GuildInfo);
%% 	   true ->
%% 		   {false, ?_LANG_GUILD_ERROR_NOT_CORP}
%% 	end.
%% 
%% invite_join_corp3(InviteUserName,UserID,GuildID,CorpName,CorpID,GuildInfo) ->
%% 	case get_users_guild(UserID) of
%% 		[] -> 
%% 			invite_join_guild_corp2(InviteUserName,UserID,GuildID,CorpName,CorpID,GuildInfo); %跳至邀请加入帮会及军团
%% 		Record ->
%% 			if Record#r_users_guilds.guild_id =:= GuildID ->
%% 				   invite_join_corp4(InviteUserName,UserID,CorpName,CorpID);
%% 			   true ->
%% 				   {false, ?_LANG_GUILD_ERROR_NOT_SAME_GUILD}
%% 			end
%% 	end.
%% 
%% invite_join_corp4(InviteUserName,UserID,CorpName,CorpID) ->
%% 	case lib_player:get_online_info(UserID) of
%% 		[] ->
%% 			{false, ?_LANG_GUILD_ERROR_NOT_ONLINE};
%% 		User ->
%% 			{ok,User#ets_users.other_data#user_other.pid_send,InviteUserName,CorpName,CorpID}
%% 	end.
%% 
%% invite_join_guild_corp2(InviteUserName,UserID,GuildID,CorpName,CorpID,GuildInfo) ->
%% 	TotalMember = GuildInfo#ets_guilds.total_honorary_member + GuildInfo#ets_guilds.total_common_member 
%% 		 		+ GuildInfo#ets_guilds.total_associate_member,
%% 	CurrentMember =  GuildInfo#ets_guilds.current_honorary_member +
%%      		 GuildInfo#ets_guilds.current_common_member +  GuildInfo#ets_guilds.current_associate_member,
%% 	if TotalMember > CurrentMember ->
%% 		   invite_join_guild_corp3(InviteUserName,UserID,GuildInfo#ets_guilds.guild_name,GuildID,CorpName,CorpID);
%% 	   true ->
%% 		   {false,?_LANG_GUILD_ERROR_FULL_MEMBER}
%% 	end.
%% 
%% invite_join_guild_corp3(InviteUserName,UserID,GuildName,GuildID,CorpName,CorpID) ->
%% 	case lib_player:get_online_info(UserID) of
%% 		[] ->
%% 			{false, ?_LANG_GUILD_ERROR_NOT_ONLINE};
%% 		User ->
%% 			{ok,User#ets_users.other_data#user_other.pid_send,InviteUserName,GuildName,GuildID,CorpName,CorpID}
%% 	end.

%%------------------------ 退出帮会 start --------------------------------------

%退出帮会
leave_guild(PlayerStatus) ->
	case leave_guild0(PlayerStatus) of
		{ok,NewPlayerStatus} ->
			{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,?_LANG_GUILD_PLAYER_LEAVE]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinChatMsg),
			{ok,BinExit} = pt_21:write(?PP_CLUB_EXIT,[]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send,BinExit),
			case get_guild_info(PlayerStatus#ets_users.club_id) of
				{ok,GuildInfo} ->
					{ok,BinData} = pt_21:write(?PP_CLUB_MEMBER_LIST,[GuildInfo]),
					lib_send:send_to_guild_user(PlayerStatus#ets_users.club_id,BinData),
					
					UserInMsgAll = ?GET_TRAN(?_LANG_GUILD_PLAYER_LEAVE_TO_ALL,[PlayerStatus#ets_users.nick_name]),
					{ok,BinChatMsgAll} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,UserInMsgAll]),
					lib_send:send_to_guild_user(GuildInfo#ets_guilds.id,BinChatMsgAll);
				{false,_Msg} ->
					lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
			end,
			{ok,NewPlayerStatus};
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PlayerStatus#ets_users.other_data#user_other.pid_send,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

leave_guild0(PlayerStatus) ->
	case get_guild_user_info(PlayerStatus#ets_users.club_id,PlayerStatus#ets_users.id) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_GUILD};
		UserGuild ->
			leave_guild1(UserGuild,PlayerStatus)
	end.

leave_guild1(UserGuild,PlayerStatus) ->
	case UserGuild#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT of
		true ->
			{false, ?_LANG_GUILD_ERROR_LEADER_NOT_ALLOW};
		_ ->
			case get_guild(UserGuild#ets_users_guilds.guild_id) of
				[] ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid,{guild_kick}),
					{ok,PlayerStatus#ets_users{club_id=0}};
				GuildInfo ->
					gen_server:cast(PlayerStatus#ets_users.other_data#user_other.pid,{guild_kick}),
					case UserGuild#ets_users_guilds.member_type of 
						?GUILD_JOB_VICE_PERSIDENT -> 
							AssMem = GuildInfo#ets_guilds.current_vice_master_member - 1,
							AssMem1 = GuildInfo#ets_guilds.total_member - 1,
							NewGuildInfo = GuildInfo#ets_guilds{current_vice_master_member=AssMem,total_member=AssMem1},
							db_agent_guild:update_guild([{current_vice_master_member,AssMem},{total_member,AssMem1}],[{id,GuildInfo#ets_guilds.id}]);
						?GUILD_MEMBER_HONORARY ->  
							AssMem = GuildInfo#ets_guilds.current_honorary_member - 1,
							AssMem1 = GuildInfo#ets_guilds.total_member - 1,
							NewGuildInfo = GuildInfo#ets_guilds{current_honorary_member=AssMem,total_member=AssMem1},
							db_agent_guild:update_guild([{current_honorary_member,AssMem},{total_member,AssMem1}],[{id,GuildInfo#ets_guilds.id}]);
						_ ->
							AssMem = GuildInfo#ets_guilds.total_member - 1,
							NewGuildInfo = GuildInfo#ets_guilds{total_member=AssMem},
							db_agent_guild:update_guild([{total_member,AssMem}],[{id,GuildInfo#ets_guilds.id}])
					end,
					update_guilds_dic(NewGuildInfo),
					leave_guild2(UserGuild,PlayerStatus)
			end
	end.

leave_guild2(UserGuild,PlayerStatus) ->
	LeaveTime = misc_timer:now_seconds(),
	db_agent_guild:update_user_guild([{join_date,LeaveTime},
									  {is_exists,0}],[{user_id,UserGuild#ets_users_guilds.user_id}]),
	delete_users_guilds_by_id(UserGuild#ets_users_guilds.user_id),
	delete_guilds_member(UserGuild),
	update_leave_guilds_dic(UserGuild#ets_users_guilds{join_date=LeaveTime,is_exists=0}),
	delete_users_guilds_by_id(UserGuild#ets_users_guilds.user_id),
	delete_guild_item_request_by_user_id(UserGuild#ets_users_guilds.guild_id,UserGuild#ets_users_guilds.user_id),
	
%% 	if UserGuild#ets_users_guilds.corp_id > 0 ->
%% 		   GuildInfo = get_guild(UserGuild#ets_users_guilds.guild_id),
%% 		   case lists:keyfind(GuildInfo#ets_users_guilds.corp_id,#ets_guilds_corps.id,GuildInfo#ets_guilds.other_data#other_guilds.guilds_corps) of
%% 			   false->
%% 				   skip;
%% 			   CorpInfo ->
%% 				    case CorpInfo#ets_guilds_corps.leader_id =:= UserGuild#ets_users_guilds.user_id of
%% 					   true ->
%% 						  Leader = 0;
%% 					  _ ->
%% 						  Leader = CorpInfo#ets_guilds_corps.leader_id
%% 				   end,
%% 				   MemNum = CorpInfo#ets_guilds_corps.member_number - 1,
%% 				   NewCorpInfo = CorpInfo#ets_guilds_corps{member_number = MemNum,leader_id =Leader},
%% 				   db_agent_guild:update_corp([{member_number,MemNum},{leader_id,Leader}],[{corp_id,CorpInfo#ets_guilds_corps.id}]),
%% 					update_guilds_corps(NewCorpInfo)
%% 		   end;
%% 	   true ->
%% 		   skip
%% 	end,
	{ok,PlayerStatus#ets_users{club_id=0}}.

%% ------------------------ 退出帮会 end --------------------------------------

%踢出玩家
kick_guild_user(ControlUserID,ControlUserNick,UserID,GuildID,PidSend) ->
	case kick_guild_user(GuildID,ControlUserID,ControlUserNick,UserID) of
		{ok, KickPlayer,NewGuildInfo} ->
			{ok,BinData} = pt_21:write(?PP_CLUB_MEMBER_LIST,[NewGuildInfo]),
			lib_send:send_to_guild_user(GuildID,BinData),
%% 			UserInMsgAll = ?GET_TRAN(?_LANG_GUILD_PLAYER_KICKOUT_TO_ALL,[KickPlayer#ets_users.nick_name]),
%% 			{ok,BinChatMsgAll} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,UserInMsgAll]),
%% 			lib_send:send_to_guild_user(GuildID,BinChatMsgAll),
			case KickPlayer of
				[] ->
					ok;
				_ ->
					{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,?_LANG_GUILD_PLAYER_KICKOUT]),
					{ok,BinExit} = pt_21:write(?PP_CLUB_EXIT,[]),
					lib_send:send_to_sid(KickPlayer#ets_users.other_data#user_other.pid_send,<<BinChatMsg/binary,BinExit/binary>>)
			end;
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])%,
			%?PRINT("MSG ~p ~n",[_Msg])
	end.

kick_guild_user(GuildID,ControlUserID,ControlUserNick,UserID) ->
	case get_guild_user_info(GuildID,ControlUserID) of
		[] -> 
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		ControlMember ->
			case get_guild_user_info(GuildID, UserID) of
				[] ->
					{false, ?_LANG_GUILD_ERROR_NOT_GUILD};
				UserGuild ->
					if 
						(ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse 
						 ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT orelse
						 ControlMember#ets_users_guilds.member_type =:= ?GUILD_MEMBER_HONORARY ) andalso
						 ControlMember#ets_users_guilds.member_type < UserGuild#ets_users_guilds.member_type ->
							kick_guild_user1(UserGuild,ControlMember#ets_users_guilds.other_data#other_users_guilds.nick_name ,
											ControlUserID,ControlUserNick,ControlMember#ets_users_guilds.guild_id);
					   true ->
						   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
					end
			end
	end.





kick_guild_user1(UserGuild,UserNick,ControlUserID,ControlUserNick,GuildID) ->
%% 	case get_guild_user_info(GuildID, UserID) of
%% 		[] ->
%% 			{false, ?_LANG_GUILD_ERROR_NOT_GUILD};
%% 		UserGuild ->
			if UserGuild#ets_users_guilds.guild_id =:= GuildID ->
				   case get_guild(UserGuild#ets_users_guilds.guild_id) of
					   [] ->
						   {ok};
					   GuildInfo ->
						   NewPlayer =
							   case lib_player:get_online_info(UserGuild#ets_users_guilds.user_id) of
								   [] ->
									   db_agent:mp_save_user_table(UserGuild#ets_users_guilds.user_id,[club_id],[0]),
									   [];
								   Player ->
									   gen_server:cast(Player#ets_users.other_data#user_other.pid,{guild_kick}),
									   Player#ets_users{club_id = 0}
							   end,
						   Content = ?GET_TRAN(?_LANGUAGE_GUILD_MAIL_CONTENT_KICK_OUT, [ControlUserNick]),
						   lib_mail:send_sys_mail(ControlUserNick, ControlUserID,UserNick, UserGuild#ets_users_guilds.user_id ,[],
												   ?MAIL_TYPE_GUILD_BROAD, 
												  ?_LANGUAGE_GUILD_MAIL_USER_MANAGE_TITLE,
												  Content, 0, 0, 0, 0),
						   case UserGuild#ets_users_guilds.member_type of 
							   ?GUILD_JOB_VICE_PERSIDENT ->
								   AssMem = GuildInfo#ets_guilds.current_vice_master_member - 1,
								   AssMem1 = GuildInfo#ets_guilds.total_member - 1,
								   NewGuildInfo = GuildInfo#ets_guilds{current_vice_master_member=AssMem,total_member=AssMem1},
								   db_agent_guild:update_guild([{current_vice_master_member,AssMem},{total_member,AssMem1}],[{id,GuildInfo#ets_guilds.id}]);
							   ?GUILD_MEMBER_HONORARY ->  
								   AssMem = GuildInfo#ets_guilds.current_honorary_member - 1,
								   AssMem1 = GuildInfo#ets_guilds.total_member - 1,
								   NewGuildInfo = GuildInfo#ets_guilds{current_honorary_member=AssMem,total_member=AssMem1},
								   db_agent_guild:update_guild([{current_honorary_member,AssMem},{total_member,AssMem1}],[{id,GuildInfo#ets_guilds.id}]);
							   _ ->
								   AssMem = GuildInfo#ets_guilds.total_member - 1,
								   NewGuildInfo = GuildInfo#ets_guilds{total_member=AssMem},
								   db_agent_guild:update_guild([{total_member,AssMem}],[{id,GuildInfo#ets_guilds.id}])
						   end,
						   update_guilds_dic(NewGuildInfo),
						   kick_guild_user2(UserGuild,NewPlayer,NewGuildInfo)
				   end;
			   true ->
				  {false, ?_LANG_GUILD_ERROR_NOT_GUILD}
%% 			end
	end.

kick_guild_user2(UserGuild,NewPlayer,NewGuildInfo) ->
	LeaveTime = misc_timer:now_seconds(),
	db_agent_guild:update_user_guild([{join_date,LeaveTime},
									  {is_exists,0}],[{user_id,UserGuild#ets_users_guilds.user_id}]),
 	delete_users_guilds_by_id(UserGuild#ets_users_guilds.user_id),
	delete_guilds_member(UserGuild),
	update_leave_guilds_dic(UserGuild#ets_users_guilds{join_date=LeaveTime,is_exists=0}),
	delete_users_guilds_by_id(UserGuild#ets_users_guilds.user_id),
	delete_guild_item_request_by_user_id(UserGuild#ets_users_guilds.guild_id,UserGuild#ets_users_guilds.user_id),
	
%% 	if UserGuild#ets_users_guilds.corp_id > 0 ->
%% 		   case lists:keyfind(NewGuildInfo#ets_users_guilds.corp_id,#ets_guilds_corps.id,NewGuildInfo#ets_guilds.other_data#other_guilds.guilds_corps) of
%% 			   false->
%% 				   skip;
%% 			   CorpInfo ->
%% 				    case CorpInfo#ets_guilds_corps.leader_id =:= UserGuild#ets_users_guilds.user_id of
%% 					   true ->
%% 						  Leader = 0;
%% 					  _ ->
%% 						  Leader = CorpInfo#ets_guilds_corps.leader_id
%% 				   end,
%% 				   MemNum = CorpInfo#ets_guilds_corps.member_number - 1,
%% 				   NewCorpInfo = CorpInfo#ets_guilds_corps{member_number = MemNum,leader_id =Leader},
%% 				   db_agent_guild:update_corp([{member_number,MemNum},{leader_id,Leader}],[{corp_id,CorpInfo#ets_guilds_corps.id}]),
%% 					update_guilds_corps(NewCorpInfo)
%% 		   end;
%% 	   true ->
%% 		   skip
%% 	end,
	{ok, NewPlayer,get_guild(NewGuildInfo#ets_guilds.id)}.




%%============================= 解散帮会 start ==========================================
%% 解散帮会
disband_guild(GuildID,UserID,PidSend) ->
	case disband_guild(GuildID,UserID) of
		{ok,_GuildID} ->
			ok;
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,
									  ?FLOAT,
									  ?None,
									  ?ORANGE,
									  _Msg])
	end.

disband_guild(GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_GUILD};
		UserGuild ->
			disband_guild1(UserGuild)
	end.

disband_guild1(UserGuild) ->
	case UserGuild#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT of
		true ->
			disband_guild2(UserGuild);
		_ ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
	end.

disband_guild2(UserGuild) ->
	{ok,BinExit} = pt_21:write(?PP_CLUB_EXIT,[]),
	lib_send:send_to_guild_user(UserGuild#ets_users_guilds.guild_id,BinExit),
	{ok,BinChatMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,?_LANG_GUILD_DISMISS]),
	lib_send:send_to_guild_user(UserGuild#ets_users_guilds.guild_id,BinChatMsg),
	LeaveTime = misc_timer:now_seconds(),
	L = get_guild_users_list(UserGuild#ets_users_guilds.guild_id),
	F = fun(UserGuildDel) ->
				delete_users_guilds_by_id(UserGuildDel#ets_users_guilds.user_id),
				update_leave_guilds_dic(UserGuildDel#ets_users_guilds{join_date=LeaveTime,is_exists=0}),
				delete_users_guilds_by_id(UserGuildDel#ets_users_guilds.user_id),
				db_agent_guild:update_user_guild([{join_date,LeaveTime},
												  {is_exists,0}],
												 [{user_id,UserGuildDel#ets_users_guilds.user_id}]),
				case lib_player:get_online_info(UserGuildDel#ets_users_guilds.user_id) of
					[] -> 
						skip;
					User -> 
						gen_server:cast(User#ets_users.other_data#user_other.pid,{guild_kick})
				end
		end,
	lists:foreach(F,L),
	delete_guilds_dic(UserGuild#ets_users_guilds.guild_id),
	db_agent_guild:delete_guild_user_request([{guild_id,UserGuild#ets_users_guilds.guild_id}]),
	db_agent_guild:delete_corp([{guild_id,UserGuild#ets_users_guilds.guild_id}]),
	db_agent_guild:delete_guild([{id,UserGuild#ets_users_guilds.guild_id}]),
	{ok, UserGuild#ets_users_guilds.guild_id}.
	
%%============================= 解散帮会 end ==========================================


%变更上下线状态
send_guild_member_online(UserID,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	case get_users_guild(UserID) of
		[] ->
			skip;
		Record ->
			case get_guild_user_info(Record#r_users_guilds.guild_id,Record#r_users_guilds.user_id) of
				[] ->
					skip;
				UserGuild ->
					send_guild_member_online1(UserGuild,Fight,LastOnlineTime,Online,Pid,PidSend)
			end
	end.

send_guild_member_online1(UserGuild,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	case get_guild(UserGuild#ets_users_guilds.guild_id) of
		[] ->
			skip;
		GuildInfo ->
			%%验证现在的帮会战状态，如果有就发信息通知
			
			send_guild_member_online3(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend)
	end.

send_guild_member_online3(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	case UserGuild#ets_users_guilds.member_type of
		?GUILD_JOB_PRESIDENT ->
			send_guild_member_online4_1(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend);
		?GUILD_JOB_VICE_PERSIDENT ->
			send_guild_member_online4_1(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend);
		?GUILD_MEMBER_HONORARY ->
			send_guild_member_online4_1(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend);
		_ ->
			send_guild_member_online4_2(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend)
%% 		?GUILD_MEMBER_ASSOCIATE ->
%% 			send_guild_member_online4_3(UserGuild,GuildInfo,Online,Pid,PidSend)
	end.

send_guild_member_online4_1(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	case Online of
		0 ->
			OtherData = GuildInfo#ets_guilds.other_data,
			NewOtherData = OtherData#other_guilds{online_honor = OtherData#other_guilds.online_honor - 1},
			update_guilds_dic(GuildInfo#ets_guilds{other_data=NewOtherData});
		1 ->
			OtherData = GuildInfo#ets_guilds.other_data,
			NewOtherData = OtherData#other_guilds{online_honor = OtherData#other_guilds.online_honor + 1},
			update_guilds_dic(GuildInfo#ets_guilds{other_data=NewOtherData})
	end,
	send_guild_member_online5(UserGuild,GuildInfo#ets_guilds.id,Fight,LastOnlineTime,Online,Pid,PidSend).

send_guild_member_online4_2(UserGuild,GuildInfo,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	case Online of
		0 ->
			OtherData = GuildInfo#ets_guilds.other_data,
			NewOtherData = OtherData#other_guilds{online_honor = OtherData#other_guilds.online_common - 1},
			update_guilds_dic(GuildInfo#ets_guilds{other_data=NewOtherData});
		1 ->
			OtherData = GuildInfo#ets_guilds.other_data,
			NewOtherData = OtherData#other_guilds{online_honor = OtherData#other_guilds.online_common + 1},
			update_guilds_dic(GuildInfo#ets_guilds{other_data=NewOtherData})
	end,
	send_guild_member_online5(UserGuild,GuildInfo#ets_guilds.id,Fight,LastOnlineTime,Online,Pid,PidSend).
			
%% send_guild_member_online4_3(UserGuild,GuildInfo,Online,Pid,PidSend) ->
%% 	case Online of
%% 		0 ->
%% 			OtherData = GuildInfo#ets_guilds.other_data,
%% 			NewOtherData = OtherData#other_guilds{online_honor = OtherData#other_guilds.online_associate - 1},
%% 			update_guilds_dic(GuildInfo#ets_guilds{other_data=NewOtherData});
%% 		1 ->
%% 			OtherData = GuildInfo#ets_guilds.other_data,
%% 			NewOtherData = OtherData#other_guilds{online_honor = OtherData#other_guilds.online_associate + 1},
%% 			update_guilds_dic(GuildInfo#ets_guilds{other_data=NewOtherData})
%% 	end,
%% 	send_guild_member_online5(UserGuild,GuildInfo#ets_guilds.id,Online,Pid,PidSend).

send_guild_member_online5(UserGuild,GuildID,Fight,LastOnlineTime,Online,Pid,PidSend) ->
	Other_Data = UserGuild#ets_users_guilds.other_data#other_users_guilds{
																		  fight = Fight,
																		  last_online_time = LastOnlineTime,
																		  online = Online,		
																		  pid = Pid,
																		  pid_send = PidSend
																		 },
	NewUserGuild = UserGuild#ets_users_guilds{other_data = Other_Data},
	update_guilds_member(NewUserGuild,false),
	{ok,Bin} = pt_21:write(?PP_CLUB_ONLINE_UPDATE,[UserGuild#ets_users_guilds.user_id,LastOnlineTime,Online]),
	lib_send:send_to_guild_user(GuildID,Bin).

%%获取当天已发邮件数量
get_mails_total_count(ControlUserID) ->
	case get_users_guild(ControlUserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Record ->
			case get_guild_user_info(Record#r_users_guilds.guild_id,Record#r_users_guilds.user_id) of
				[] ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				ControlMember ->
					if ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT
						orelse  ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT ->
						   get_mails_total_count1(ControlMember#ets_users_guilds.guild_id);
					   true ->
						   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
					end
			end
	end.

get_mails_total_count1(GuildID) ->
	case get_guild(GuildID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		GuildInfo ->
			GuildSetting = data_agent:get_guild_setting(GuildInfo#ets_guilds.guild_level),
			get_mails_total_count2(GuildInfo,GuildSetting#ets_guilds_template.total_mails)
	end.

get_mails_total_count2(GuildInfo,TotalMails) ->
	%Now = misc_timer:now_seconds(),
	%case util:is_same_date(GuildInfo#ets_guilds.last_send_date,Now) of
	%	true ->
			{ok,GuildInfo#ets_guilds.today_send_mails,TotalMails,GuildInfo#ets_guilds.id}.
	%	_ ->
	%		NewGuildInfo = GuildInfo#ets_guilds{today_send_mails = 0,last_send_date=Now},
	%		db_agent_guild:update_guild([{today_send_mails,0},{last_send_date,Now}],
	%											[{id,NewGuildInfo#ets_guilds.id}]),
	%		update_guilds_dic(NewGuildInfo),
	%		{ok,NewGuildInfo#ets_guilds.today_send_mails,TotalMails,GuildInfo#ets_guilds.id}
	%end.
	

%%判断是否可以继续发邮件，可以时对记录进行处理并发邮件
check_mail_send(ControlUserID,PidSend,NickName,Title,Context) ->
	case get_mails_total_count(ControlUserID) of
		{ok,TodayMails,TotalMails,GuildID} ->
			check_mail_send1(ControlUserID,NickName,TodayMails,TotalMails,GuildID,PidSend,Title,Context);
		{false,_Msg} ->
			{ok, DataBin} = pt_19:write(?PP_MAIL_GUILD, 0),
		   	lib_send:send_to_sid(PidSend, DataBin)
	end.

check_mail_send1(ControlUserID,NickName,TodayMails,TotalMails,GuildID,PidSend,Title,Context) ->
	case TodayMails < TotalMails of
		true ->
			check_mail_send2(ControlUserID,NickName,TodayMails + 1,TotalMails,GuildID,PidSend,Title,Context);
		_ ->
			%{false,?_LANG_GUILD_ERROR_MAX_MAILS}
			{ok, DataBin} = pt_19:write(?PP_MAIL_GUILD, 0),
		   	lib_send:send_to_sid(PidSend, DataBin)
	end.

check_mail_send2(ControlUserID,NickName,AlreadySendMails,TotalMails,GuildID,PidSend,Title,Context) ->
	Record = get_users_guild(ControlUserID),
	GuildInfo = get_guild(Record#r_users_guilds.guild_id),
	NewGuildInfo = GuildInfo#ets_guilds{today_send_mails = AlreadySendMails},
	db_agent_guild:update_guild([{today_send_mails,AlreadySendMails}],
								[{id,NewGuildInfo#ets_guilds.id}]),
	update_guilds_dic(NewGuildInfo),
	MemberList = get_guild_users_list(GuildID),
	lib_mail:send_guild_mail(MemberList,Title,Context,ControlUserID,NickName),
	
	{ok, DataBin} = pt_19:write(?PP_MAIL_GUILD, 1),
	{ok, DataBin1} = pt_19:write(?PP_GET_MAIL_GUILD_NUM, [TotalMails,AlreadySendMails]),
	lib_send:send_to_sid(PidSend, <<DataBin/binary, DataBin1/binary>>).
	
%% 帮会玩家升级
member_level_up(UserID,Level) ->
	case get_users_guild(UserID) of
		[] ->
			ok;
		Record ->
			case get_guild_user_info(Record#r_users_guilds.guild_id,Record#r_users_guilds.user_id) of
				[] ->
					ok;
				Member ->
					member_level_up1(Member,Level)
			end
	end.

member_level_up1(Member, Level) ->
	OtherData = Member#ets_users_guilds.other_data#other_users_guilds{level = Level},
	update_guilds_member(Member#ets_users_guilds{other_data = OtherData},false).
%% 	if Member#ets_users_guilds.corp_id =/= 0 ->
%% 			member_level_up2(Member,Level);
%% 	   true ->
%% 		   ok
%% 	end.

%% member_level_up2(Member,Level) ->
%% 	GuildInfo = get_guild(Member#ets_users_guilds.guild_id),
%% 	case lists:keyfind(Member#ets_users_guilds.corp_id,#ets_guilds_corps.id, GuildInfo#ets_guilds.other_data#other_guilds.guilds_corps) of
%% 		false ->
%% 			ok;
%% 		CorpInfo when CorpInfo#ets_guilds_corps.member_number >0 ->
%% 			TotalLevel = CorpInfo#ets_guilds_corps.member_number * CorpInfo#ets_guilds_corps.avg_level + Level,
%% 			AvgLevel = TotalLevel / CorpInfo#ets_guilds_corps.member_number,
%% 			NewCorpInfo = CorpInfo#ets_guilds_corps{avg_level = AvgLevel},
%% 			db_agent_guild:update_corp([{avg_level,AvgLevel}],[{id,NewCorpInfo#ets_guilds_corps.id}]),
%% 			update_guilds_corps(NewCorpInfo),
%% 			ok;
%% 		_ ->
%% 			skip
%% 	
%% 	end.

%人物升级时通知军团信息更新
%% corp_member_level_change(ControlUserID,Level) ->
%% 	case ets:lookup(?ETS_USERS_GUILDS,ControlUserID) of
%% 		[] ->
%% 			{false};
%% 		[ControlMember] ->
%% 			case ControlMember#ets_users_guilds.corp_id =:= 0 of
%% 				true ->
%% 					{false};
%% 				_ ->
%% 					case ets:lookup(?ETS_GUILDS_CORPS,ControlMember#ets_users_guilds.corp_id) of
%% 						[] ->
%% 							{false};
%% 						[CorpInfo] ->
%% 							TotalLevel = CorpInfo#ets_guilds_corps.member_number * CorpInfo#ets_guilds_corps.avg_level + Level,
%% 							AvgLevel = TotalLevel / CorpInfo#ets_guilds_corps.member_number,
%% 							NewCorpInfo = CorpInfo#ets_guilds_corps{avg_level = AvgLevel},
%% 							db_agent_guild:update_corp([{avg_level,AvgLevel}],
%% 							   [{id,NewCorpInfo#ets_guilds_corps.id}]),
%% 							ets:insert(?ETS_GUILDS_CORPS,NewCorpInfo),
%% 							{ok}
%% 					end
%% 			end
%% 	end.

%% %帮会运镖
%% guild_transport(ControlUserID) ->
%% 	case get_users_guild(ControlUserID) of
%% 		[] ->
%% 			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 		Record ->
%% 			case get_guild_user_info(Record#r_users_guilds.guild_id,Record#r_users_guilds.user_id) of
%% 				[] ->
%% 					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
%% 				ControlMember ->
%% 					if ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
%% 														  ControlMember#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT  ->
%% 						   guild_transport1(ControlMember#ets_users_guilds.guild_id);
%% 					   true ->
%% 						   {false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT}
%% 					end
%% 			end
%% 	end.
%% 	
%% guild_transport1(GuildID) ->
%% 	GuildInfo = get_guild(GuildID),
%% 	if GuildInfo#ets_guilds.contribution < ?GUILD_TRAN_CONTRIBUTION ->
%% 			{false, ?_LANG_GUILD_TEANSPORT_CONTRIBUTION};
%% 	    GuildInfo#ets_guilds.activity < ?GUILD_TRAN_ACTIVITY ->
%% 			{false, ?_LANG_GUILD_TEANSPORT_ACTIVITY};
%% 		true ->
%% 			guild_transport2(GuildInfo)
%% 	end.
%% 
%% guild_transport2(GuildInfo) ->
%% 	Now = misc_timer:now_seconds(),
%% 	
%% 	case util:is_same_date(GuildInfo#ets_guilds.last_guild_transport,Now) of
%% 		true ->
%% 			{false, ?_LANG_GUILD_TRANSPORT_ALREADY_START};
%% 		false ->
%% 			NewContribution = GuildInfo#ets_guilds.contribution - ?GUILD_TRAN_CONTRIBUTION,
%% 			NewActivity = GuildInfo#ets_guilds.activity - ?GUILD_TRAN_ACTIVITY,
%% 			NewGuildInfo = GuildInfo#ets_guilds{last_guild_transport= Now, contribution=NewContribution, activity=NewActivity},
%% 			db_agent_guild:update_guild([{last_guild_transport,Now}],
%% 								[{id,NewGuildInfo#ets_guilds.id}]),
%% 			update_guilds_dic(NewGuildInfo),
%% 			{ok, Now, GuildInfo#ets_guilds.id, GuildInfo#ets_guilds.guild_name}
%% 	end.
%% 		
%% %检查是否在帮会运镖时间内，返回{ok,运镖启动时间}或{false}
%% check_guild_transport(GuildID) ->
%% 	if GuildID > 0 ->
%% 		   case get_guild(GuildID) of
%% 			   [] ->
%% 				   {false};
%% 			   GuildInfo ->
%% 				   check_guild_transport1(GuildInfo#ets_guilds.last_guild_transport)
%% 		   end;
%% 	   true ->
%% 		   {false}
%% 	end.
%% 
%% check_guild_transport1(GuildTime) ->
%% 	Now = misc_timer:now_seconds(),
%% 	if (Now - GuildTime) =< ?GUILD_TRANSPORT_TIME ->
%% 		   {ok, (?GUILD_TRANSPORT_TIME + GuildTime - Now)};
%% 	   true ->
%% 		   {false}
%% 	end.
%% 
%% check_guild_transport_cast(GuildID, PlayerPid, {Mod, Fun}) ->
%% 	if GuildID > 0 ->
%% 		case get_guild(GuildID) of
%% 		   false ->
%% 				skip;
%% 			GuildInfo ->
%% 				   check_guild_transport_cast1(PlayerPid, GuildInfo#ets_guilds.last_guild_transport, {Mod, Fun})
%% 		   end;
%% 	   true ->
%% 		   skip
%% 	end.
%% 
%% check_guild_transport_cast1(PlayerPid, GuildTime, {Mod, Fun}) ->
%% 	Now = misc_timer:now_seconds(),
%% 	if (Now - GuildTime) =< ?GUILD_TRANSPORT_TIME ->
%% 		   erlang:apply(Mod, Fun, [PlayerPid, ?GUILD_TRANSPORT_TIME + GuildTime - Now]);
%% 	   true ->
%% 		   {false}
%% 	end.

% 获取帮会信息，用户登录时使用
get_guild_info_for_user(UserID) ->
	case get_users_guild(UserID) of
		[] ->
			{0};
		Record ->
			case get_guild_user_info(Record#r_users_guilds.guild_id, Record#r_users_guilds.user_id) of
				[] ->
					{0};
				GuildUserInfo ->
					get_guild_info_for_user1(
											 GuildUserInfo#ets_users_guilds.guild_id,
									 		 GuildUserInfo#ets_users_guilds.member_type,
											 GuildUserInfo#ets_users_guilds.current_feats,
											 GuildUserInfo#ets_users_guilds.total_feats)
%% 				_ ->
%% 					{0}
			end
%% 		_ ->
%% 			{0}
	end.

get_guild_info_for_user1(GuildID,GuildJob,CurrentFeats,TotalFeats) ->
	case get_guild_info(GuildID) of
		{ok,GuildInfo} ->
			EnemyList = get_enemy_list(GuildInfo#ets_guilds.other_data#other_guilds.enemy_guild,[]),
			{GuildID,
			 GuildInfo#ets_guilds.guild_name,
			 GuildJob,
			 GuildInfo#ets_guilds.other_data#other_guilds.map_pid,
			 GuildInfo#ets_guilds.other_data#other_guilds.map_only_id,
			 EnemyList,
			 GuildInfo#ets_guilds.guild_level,
			 GuildInfo#ets_guilds.furnace_level,
			 CurrentFeats,
			 TotalFeats};
		_ ->
			{0}
	end.

get_enemy_list([], L) -> L;
get_enemy_list(Enemy,L) ->
	[H|T] = Enemy,
	NL = [{H#ets_guilds.id}|L],
	get_enemy_list(T,NL).

%% 帮派地图信息
get_guild_map_info(GuildId) ->
	case get_guild_info(GuildId) of
		{ok, GuildInfo} ->
			{MapPid, MapOnlyId} =
				case GuildInfo#ets_guilds.other_data#other_guilds.map_pid =:= undefined of
					true ->
						{MapId, _,_ } = ?GUILD_MAP,
						UniqueId = mod_increase:get_guild_auto_id(),
%% 						Id = MapId * 10000 + UniqueId, 
						Id = lib_map:create_copy_id(MapId, UniqueId),
						{Map_pid, _} = mod_map:get_scene_pid(Id, undefined, undefined),
						Other = GuildInfo#ets_guilds.other_data#other_guilds{map_pid=Map_pid, map_only_id=Id},
						NewGuildInfo = GuildInfo#ets_guilds{other_data=Other},
						update_guilds_dic(NewGuildInfo),
						case gen_server:call(mod_active:get_active_pid(), {is_active_open,?GUILD_POUNCE_ACTIVE_ID}) of
							true ->
								case data_agent:get_active_refesh_monster_template(?GUILD_POUNCE_ACTIVE_ID) of
									[] ->
										ok;
									Temp ->
										[{_,MList,_}] = Temp#ets_active_refresh_monster_template.maps,
										update_guild_summon1_6(MList, NewGuildInfo#ets_guilds.other_data#other_guilds.map_pid),
										erlang:send_after(?GUILD_ACTIVE_RAID_TIME, NewGuildInfo#ets_guilds.other_data#other_guilds.map_pid, {raid_active_award})
								end;								
							false ->
								ok
						end,
						{Map_pid, Id};
					_ ->
						{GuildInfo#ets_guilds.other_data#other_guilds.map_pid,
						 GuildInfo#ets_guilds.other_data#other_guilds.map_only_id}
				end,
			{ok, MapPid, MapOnlyId};
		_ ->
			{error, "guild is not exist"}
	end.
%%帮会突袭活动召唤
open_active_summon_monster(List) ->
	F = fun(GInfo) ->
			case GInfo#ets_guilds.other_data#other_guilds.map_pid =/= undefined  of
				true ->
					update_guild_summon1_6(List, GInfo#ets_guilds.other_data#other_guilds.map_pid),
					erlang:send_after(?GUILD_ACTIVE_RAID_TIME, GInfo#ets_guilds.other_data#other_guilds.map_pid, {raid_active_award});
				false ->
					ok
			end
		end,
	GList = get_guilds_dic(),
	lists:foreach(F, GList).

%% 帮派级别信息
get_guild_level(GuildId) ->
	case get_guild_info(GuildId) of
		{ok,GuildInfo} ->
			GuildInfo#ets_guilds.guild_level;
		_ ->
			0
	end.

%% 完成帮派任务获得奖励
guild_task_award(GuildId, UserId, Contribution, Money, Activity, Feats) ->
	case get_guild_user_info(GuildId, UserId) of
		[] ->
			skip;
		GuildUserInfo when GuildUserInfo#ets_users_guilds.is_exists == 1 ->
			guild_task_award1(GuildUserInfo, Contribution, Money, Activity, Feats);
		_ ->
			skip
	end.

guild_task_award1(GuildUserInfo, Contribution, Money, Activity, Feats) ->
	NewContribution = 
		case Contribution >= 0 of
			true ->
				Contribution;
			_ ->
				0
		end,
	NewMoney = 
		case Money >= 0 of
			true ->
				Money;
			_ ->
				0
		end,
	NewActivity = 
		case Activity >= 0 of
			true ->
				Activity;
			_ ->
				0
		end,
	NewFeats = 
		case Feats >= 0 of
			true ->
				Feats;
			_ ->
				0
		end,
	case get_guild_info(GuildUserInfo#ets_users_guilds.guild_id) of
		{ok, GuildInfo} ->
%% 			LastContribution = GuildInfo#ets_guilds.contribution + NewContribution,
			LastMoney = GuildInfo#ets_guilds.money + NewMoney,
%% 			LastActivity = GuildInfo#ets_guilds.activity + NewActivity,
			CurFeats = GuildUserInfo#ets_users_guilds.current_feats + NewFeats,
			LastFeats = GuildUserInfo#ets_users_guilds.total_feats + NewFeats,
			UpdateGuild = [
					   {money,LastMoney}
					   ],
			db_agent_guild:update_guild(UpdateGuild,[{id,GuildInfo#ets_guilds.id}]),
			db_agent_guild:update_user_guild([{current_feats,CurFeats}, 
											  {total_feats,LastFeats}], 
											 [{user_id, GuildUserInfo#ets_users_guilds.user_id}, 
											  {guild_id, GuildUserInfo#ets_users_guilds.guild_id}]),
			NewGuildInfo = GuildInfo#ets_guilds{
												money = LastMoney
											   											   },
			update_guilds_dic(NewGuildInfo),
			NewGuildUserInfo = GuildUserInfo#ets_users_guilds{current_feats = CurFeats,total_feats = LastFeats},
			update_guilds_member(NewGuildUserInfo,false);
		_ ->
			skip
	end.
%% get_guild_info_for_user2(ClubName,PlayerStatus) ->
%% 	case  get_guild_user_info(PlayerStatus#ets_users.id) of
%% 		{ok,GuildUserInfo} ->
%% 			Other_data = PlayerStatus#ets_users.other_data#user_other{
%% 																	 club_name = ClubName,
%% 																	 club_job = GuildUserInfo#ets_users_guilds.member_type
%% 																	 },
%% 			PlayerStatus#ets_users{other_data = Other_data};
%% 		_ ->
%% 			PlayerStatus
%% 	end.

%% 帮派宣战

club_war_declear_init(PageIndex,PageSize,GuildID,UserID,PidSend) ->
	case club_war_declear_init(PageIndex,PageSize,GuildID,UserID) of
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg]);
		{ok, C, L} ->
			GuildInfo = get_guild(GuildID),
			{ok, Bin} = pt_21:write(?PP_CLUB_WAR_DECLEAR_INIT,[C,L,GuildInfo#ets_guilds.other_data#other_guilds.enemy_guild]),
			lib_send:send_to_sid(PidSend,Bin)
	end.

club_war_declear_init(PageIndex,PageSize,GuildID,UserID) ->	
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
											 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				false ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				_ ->
					club_war_declear_init1(PageIndex,PageSize,GuildID)
			end
	end.

club_war_declear_init1(PageIndex,PageSize,GuildID) ->
	TmpGuildList = get_guilds_dic(),
	GuildList = lists:keydelete(GuildID, #ets_guilds.id, TmpGuildList),
	C = length(GuildList),
	Start = (PageIndex-1) * PageSize + 1,
	if Start > C  ->
		   L = [];
	   true ->
		   L = lists:sublist(GuildList, Start , PageSize)
	end,
	{ok,C,L}.

club_war_deal_init(PageIndex,PageSize,GuildID,UserID,PidSend) ->
	case club_war_deal_init(PageIndex,PageSize,GuildID,UserID) of
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg]);
		{ok, C, L} ->
			{ok, Bin} = pt_21:write(?PP_CLUB_WAR_DEAL_INIT,[C,L]),
			lib_send:send_to_sid(PidSend,Bin)
	end.

club_war_deal_init(PageIndex,PageSize,GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
											 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				false ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				_ ->
					club_war_deal_init1(PageIndex,PageSize,GuildID)
			end
	end.

club_war_deal_init1(PageIndex,PageSize,GuildID) ->
	GuildInfo = get_guild(GuildID),
	DealList = GuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
	C = length(DealList),
	Start = (PageIndex-1) * PageSize + 1,
	if Start > C  ->
		   L = [];
	   true ->
		   L = lists:sublist(DealList, Start , PageSize)
	end,
	{ok,C,L}.


club_war_enemy_init(PageIndex,PageSize,GuildID,UserID,PidSend) ->
	case club_war_enemy_init(PageIndex,PageSize,GuildID,UserID) of
		{false, _Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg]);
		{ok, C, L} ->
			{ok, Bin} = pt_21:write(?PP_CLUB_WAR_ENEMY_INIT,[C,L]),
			lib_send:send_to_sid(PidSend,Bin)
	end.

club_war_enemy_init(PageIndex,PageSize,GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
											 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				false ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				_ ->
					club_war_enemy_init1(PageIndex,PageSize,GuildID)
			end
	end.

club_war_enemy_init1(PageIndex,PageSize,GuildID) ->
	GuildInfo = get_guild(GuildID),
	DealList = GuildInfo#ets_guilds.other_data#other_guilds.enemy_guild,
	C = length(DealList),
	Start = (PageIndex-1) * PageSize + 1,
	if Start > C  ->
		   L = [];
	   true ->
		   L = lists:sublist(DealList, Start , PageSize)
	end,
	{ok,C,L}.
	
club_war_declear(TargetGuildID,DeclearType,PageIndex,PageSize,GuildID,UserID,PidSend) ->
	case club_war_declear(TargetGuildID,DeclearType,GuildID,UserID) of
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg]),
			{false};
		{ok} ->
			{ok, C, L} = club_war_declear_init1(PageIndex,PageSize,GuildID),
			GuildInfo = get_guild(GuildID),
			{ok, Bin} = pt_21:write(?PP_CLUB_WAR_DECLEAR_INIT,[C,L,GuildInfo#ets_guilds.other_data#other_guilds.enemy_guild]),
			lib_send:send_to_sid(PidSend,Bin),
			{ok}
	end.

club_war_declear(TargetGuildID,DeclearType,GuildID,UserID) ->
	NowSeconds = util:get_today_current_second(),
	if ?GUILD_BATTLE_START_SECONDS < NowSeconds andalso ?GUILD_BATTLE_END_SECONDS > NowSeconds ->
		   club_war_declear1(TargetGuildID,DeclearType,GuildID,UserID);
	   true -> 
		   {false, ?_LANG_GUILD_ERROR_NOT_BATTLE_TIME}
	end.

club_war_declear1(TargetGuildID,DeclearType,GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
											 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				false ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				_ ->
					club_war_declear2(TargetGuildID,DeclearType,GuildID)
			end
	end.

club_war_declear2(TargetGuildID,DeclearType,GuildID) ->
	case get_guild(GuildID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		GuildInfo ->
			case GuildInfo#ets_guilds.guild_level >= ?GUILD_BATTLE_GUILD_LEVEL of
				true ->
					club_war_declear3(TargetGuildID,DeclearType,GuildInfo);
				_ ->
					{false, ?_LANG_GUILD_ERROR_NOT_BATTLE_LEVEL}
			end
	end.

club_war_declear3(TargetGuildID,DeclearType,GuildInfo) ->
	case get_guild(TargetGuildID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		TargetGuildInfo ->
			case TargetGuildInfo#ets_guilds.guild_level >= ?GUILD_BATTLE_GUILD_LEVEL of
				true ->
					club_war_declear4(TargetGuildInfo,DeclearType,GuildInfo);
				_ ->
					{false, ?_LANG_GUILD_ERROR_TARGET_NOT_BATTLE_LEVEL}
			end
	end.

club_war_declear4(TargetGuildInfo,DeclearType,GuildInfo) ->
	case lists:keyfind(GuildInfo#ets_guilds.id, #ets_guilds.id, 
					   TargetGuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild) of
		false ->
			club_war_declear5(TargetGuildInfo,DeclearType,GuildInfo);
		_ ->
			{false, ?_LANG_GUILD_ERROR_TARGET_ALREADY_DECLEAR}
	end.

club_war_declear5(TargetGuildInfo,DeclearType,GuildInfo) ->
	case lists:keyfind(GuildInfo#ets_guilds.id, #ets_guilds.id, 
					   TargetGuildInfo#ets_guilds.other_data#other_guilds.enemy_guild) of
		false ->
			club_war_declear6(TargetGuildInfo,DeclearType,GuildInfo);
		_ ->
			{false, ?_LANG_GUILD_ERROR_TARGET_ALREADY_WAR}
	end.

%% 判断都过，放入宣战列表
club_war_declear6(TargetGuildInfo,DeclearType,GuildInfo) ->
	case DeclearType of
		?GUILD_BATTLE_DECLEAR_FREE ->
			TMPDeclearList = TargetGuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
			DeclearList = [GuildInfo#ets_guilds{other_data=[]}|TMPDeclearList],
			Other_data = TargetGuildInfo#ets_guilds.other_data#other_guilds{declear_war_guild = DeclearList},
			update_guilds_dic(TargetGuildInfo#ets_guilds{other_data = Other_data}),
			%%通知对方
			LeaderL = get_leader_from_member(TargetGuildInfo#ets_guilds.other_data#other_guilds.members,[]),
			{ok,BinNotice} = pt_21:write(?PP_CLUB_WAR_REQUEST_RESPONSE,[]),
			club_war_declear7(LeaderL,BinNotice),
			{ok};
		?GUILD_BATTLE_DECLEAR_FORCE -> 	%强行
			club_war_deal3(TargetGuildInfo,?GUILD_BATTLE_DEAL_ACCEPT,GuildInfo),
			{ok}
	end.

club_war_declear7([],_Bin) -> ok;
club_war_declear7(LeaderL,Bin) ->
	[H|T] = LeaderL,
	if H#ets_users_guilds.other_data#other_users_guilds.pid_send =/= undefined ->
		   lib_send:send_to_sid(H#ets_users_guilds.other_data#other_users_guilds.pid_send, Bin),
		   club_war_declear7(T,Bin);
	   true ->
		   club_war_declear7(T,Bin)
	end.
	

club_war_deal(TargetGuildID,DealType,PageIndex,PageSize,GuildID,UserID,PidSend) ->
	case club_war_deal(TargetGuildID,DealType,GuildID,UserID) of
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg]);
		{ok} ->
			{ok, C, L} = club_war_deal_init1(PageIndex,PageSize,GuildID),
			{ok, Bin} = pt_21:write(?PP_CLUB_WAR_DEAL_INIT,[C,L]),
			lib_send:send_to_sid(PidSend,Bin)
	end.
		
club_war_deal(TargetGuildID,DealType,GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
											 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				false ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				_ ->
					club_war_deal1(TargetGuildID,DealType,GuildID)
			end
	end.

club_war_deal1(TargetGuildID,DealType,GuildID) ->
	case get_guild(GuildID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		GuildInfo ->
			club_war_deal2(TargetGuildID,DealType,GuildInfo)
	end.

club_war_deal2(TargetGuildID,DealType,GuildInfo) ->
	case get_guild(TargetGuildID) of
		[] ->
			{false};	%% 已没有这个对象， 刷新当前页
		TargetGuildInfo ->
			club_war_deal3(TargetGuildInfo,DealType,GuildInfo)
	end.

club_war_deal3(TargetGuildInfo,DealType,GuildInfo) ->
	case DealType of
		?GUILD_BATTLE_DEAL_ACCEPT ->
			TmpTargetDeclearList = TargetGuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
			TargetDeclearList = lists:keydelete(GuildInfo#ets_guilds.id,#ets_guilds.id,TmpTargetDeclearList),
			TmpTargetEnemyList = TargetGuildInfo#ets_guilds.other_data#other_guilds.enemy_guild,
			TargetEnemyList = [GuildInfo#ets_guilds{other_data=[]}|TmpTargetEnemyList],
			TargetOther = TargetGuildInfo#ets_guilds.other_data#other_guilds{declear_war_guild = TargetDeclearList,
																	 enemy_guild = TargetEnemyList},
			update_guilds_dic(TargetGuildInfo#ets_guilds{other_data = TargetOther}),
			TargetMsg = ?GET_TRAN(?_LANG_GUILD_WAR,[GuildInfo#ets_guilds.guild_name]),
			{ok,BinTargetMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,TargetMsg]),
			lib_send:send_to_guild_user(TargetGuildInfo#ets_guilds.id,BinTargetMsg),
			notice_members_add_enemy(TargetGuildInfo#ets_guilds.other_data#other_guilds.members,
									 GuildInfo#ets_guilds.id),
			
			TmpGuildDeclearList = GuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
			GuildDeclearList = lists:keydelete(TargetGuildInfo#ets_guilds.id,#ets_guilds.id,TmpGuildDeclearList),
			TmpGuildEnemyList = GuildInfo#ets_guilds.other_data#other_guilds.enemy_guild,
			GuildEnemyList = [TargetGuildInfo#ets_guilds{other_data=[]}|TmpGuildEnemyList],
			GuildOther = GuildInfo#ets_guilds.other_data#other_guilds{declear_war_guild = GuildDeclearList,
															  enemy_guild = GuildEnemyList},
			update_guilds_dic(GuildInfo#ets_guilds{other_data = GuildOther}),
			
			GuildMsg = ?GET_TRAN(?_LANG_GUILD_WAR,[TargetGuildInfo#ets_guilds.guild_name]),
			{ok,BinGuildMsg} = pt_16:write(?PP_SYS_MESS,[?CHAT,?None,?ORANGE,GuildMsg]),
			lib_send:send_to_guild_user(GuildInfo#ets_guilds.id,BinGuildMsg),
			notice_members_add_enemy(GuildInfo#ets_guilds.other_data#other_guilds.members,
									 TargetGuildInfo#ets_guilds.id),
			
			%% 未通知人物身上敌对id改变
			
			{ok};
		_ ->
			TmpGuildDeclearList = GuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
			GuildDeclearList = lists:keydelete(TargetGuildInfo#ets_guilds.id,#ets_guilds.id,TmpGuildDeclearList),
			GuildOther = GuildInfo#ets_guilds.other_data#other_guilds{declear_war_guild = GuildDeclearList},
			update_guilds_dic(GuildInfo#ets_guilds{other_data = GuildOther}),
			{ok}
	end.

notice_members_add_enemy([],_ID) -> ok;
notice_members_add_enemy(Members, ID) ->
	[H|T] = Members,
	case H#ets_users_guilds.other_data#other_users_guilds.pid of
		undefined ->
			notice_members_add_enemy(T, ID);
		_ ->
			gen_server:cast(H#ets_users_guilds.other_data#other_users_guilds.pid,{add_guild_enemy,ID}),
			notice_members_add_enemy(T,ID)
	end.

club_war_stop(TargetGuildID,PageIndex,PageSize,GuildID,UserID,PidSend) ->
	case club_war_stop(TargetGuildID,GuildID,UserID) of
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg]),
			{false};
		{ok} ->
			{ok, C, L} = club_war_enemy_init1(PageIndex,PageSize,GuildID),
			{ok, Bin} = pt_21:write(?PP_CLUB_WAR_ENEMY_INIT,[C,L]),
			lib_send:send_to_sid(PidSend,Bin),
			{ok}
	end.
		
club_war_stop(TargetGuildID,GuildID,UserID) ->
	case get_guild_user_info(GuildID,UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			case Member#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
											 Member#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT of
				false ->
					{false,?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
				_ ->
					club_war_stop1(TargetGuildID,GuildID)
			end
	end.

club_war_stop1(TargetGuildID,GuildID) ->
	case get_guild(GuildID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		GuildInfo ->
			club_war_stop2(TargetGuildID,GuildInfo)
	end.

club_war_stop2(TargetGuildID,GuildInfo) ->
	case get_guild(TargetGuildID) of
		[] ->
			{false};	%% 已没有这个对象， 刷新当前页
		TargetGuildInfo ->
			club_war_stop3(TargetGuildInfo,GuildInfo)
	end.

club_war_stop3(TargetGuildInfo,GuildInfo) ->
	TmpTargetDeclearList = TargetGuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
	TargetDeclearList = lists:keydelete(GuildInfo#ets_guilds.id,#ets_guilds.id,TmpTargetDeclearList),
	TmpTargetEnemyList = TargetGuildInfo#ets_guilds.other_data#other_guilds.enemy_guild,
	TargetEnemyList = lists:keydelete(GuildInfo#ets_guilds.id,#ets_guilds.id,TmpTargetEnemyList),
	TargetOther = TargetGuildInfo#ets_guilds.other_data#other_guilds{declear_war_guild = TargetDeclearList,
																	 enemy_guild = TargetEnemyList},
	update_guilds_dic(TargetGuildInfo#ets_guilds{other_data = TargetOther}),
	notice_members_remove_enemy(TargetGuildInfo#ets_guilds.other_data#other_guilds.members,
									 GuildInfo#ets_guilds.id),
	
	
	TmpGuildDeclearList = GuildInfo#ets_guilds.other_data#other_guilds.declear_war_guild,
	GuildDeclearList = lists:keydelete(TargetGuildInfo#ets_guilds.id,#ets_guilds.id,TmpGuildDeclearList),
	TmpGuildEnemyList = GuildInfo#ets_guilds.other_data#other_guilds.enemy_guild,
	GuildEnemyList = lists:keydelete(TargetGuildInfo#ets_guilds.id,#ets_guilds.id,TmpGuildEnemyList),
	GuildOther = GuildInfo#ets_guilds.other_data#other_guilds{declear_war_guild = GuildDeclearList,
															  enemy_guild = GuildEnemyList},
	update_guilds_dic(GuildInfo#ets_guilds{other_data = GuildOther}),
	notice_members_remove_enemy(GuildInfo#ets_guilds.other_data#other_guilds.members,
									 TargetGuildInfo#ets_guilds.id),
	
	{ok}.

notice_members_remove_enemy([], _ID) -> ok;
notice_members_remove_enemy(Members, ID) ->
	[H|T] = Members,
	case H#ets_users_guilds.other_data#other_users_guilds.pid of
		undefined ->
			notice_members_remove_enemy(T, ID);
		_ ->
			gen_server:cast(H#ets_users_guilds.other_data#other_users_guilds.pid,{remove_guild_enemy,ID}),
			notice_members_remove_enemy(T,ID)
	end.


%% 
club_weal_update(UserID, GuildID, Level, PidSend) ->
	case club_weal_update1(UserID, GuildID, Level) of
		{ok, Weal, CanGet, Feats,TotalFeats} ->
			{ok,WealBin} = pt_21:write(?PP_CLUB_WEAL_UPDATE, [Weal, ?GUILD_WEAL_NEED_FEATS, CanGet, Feats,TotalFeats]),
			lib_send:send_to_sid(PidSend,WealBin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg])
	end.

club_weal_update1(UserID, GuildID, Level) ->
	case get_guild(GuildID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		GuildInfo ->
			Weal = (500+Level*100)*(30+GuildInfo#ets_guilds.guild_level * 6)* 1,
			club_weal_update2(UserID,GuildID, Weal)
	end.

club_weal_update2(UserID,GuildID,Weal) ->
	Time = misc_timer:now_seconds(),
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			 case util:is_same_date(Time,Member#ets_users_guilds.get_weal_date) of
				 true ->
					 {ok, Weal, 0, Member#ets_users_guilds.current_feats, Member#ets_users_guilds.total_feats};
				 _ ->
					 {ok, Weal, 1, Member#ets_users_guilds.current_feats,Member#ets_users_guilds.total_feats}
			 end
	end.



get_club_weal(UserID,GuildID,Level,PidSend,Pid ) ->
	case get_club_weal1(UserID,GuildID,Level,Pid) of
		{ok,Weal, Feats,TotalFeats} ->
			{ok,WealBin} = pt_21:write(?PP_CLUB_WEAL_UPDATE, [Weal, ?GUILD_WEAL_NEED_FEATS, 0, Feats,TotalFeats]),
			lib_send:send_to_sid(PidSend,WealBin);
		{false,_Msg} ->
			lib_chat:chat_sysmsg_pid([PidSend,?FLOAT,?None,?ORANGE,_Msg])
	end.

get_club_weal1(UserID,GuildID,Level,Pid) ->
	Time = misc_timer:now_seconds(),
	case get_guild_user_info(GuildID, UserID) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		Member ->
			 case util:is_same_date(Time,Member#ets_users_guilds.get_weal_date) of
				 true ->
					 {false, ?_LANG_GUILD_ERROR_WEAL_ALREADY_GET};
				 _ ->
					 get_club_weal2(Member,Level,Pid,Time)
			 end
	end.

get_club_weal2(Member,Level,Pid,Time) ->
	case get_guild(Member#ets_users_guilds.guild_id) of
		[] ->
			{false, ?_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT};
		GuildInfo ->
			Weal = (500+Level*100)*(30+GuildInfo#ets_guilds.guild_level * 6)* 1,
			NeedFeats = ?GUILD_WEAL_NEED_FEATS,
			case  Member#ets_users_guilds.current_feats >= NeedFeats of
				true ->
					TmpFeats = Member#ets_users_guilds.current_feats - NeedFeats,
					NewMember = Member#ets_users_guilds{current_feats = TmpFeats, get_weal_date = Time },
					db_agent_guild:update_user_guild([{current_feats,TmpFeats},{get_weal_date,Time}],
													 [{user_id,NewMember#ets_users_guilds.user_id}]),
					update_guilds_member(NewMember,false),
					gen_server:cast(Pid,{'guild_weal',Weal}),
					{ok,Weal,NewMember#ets_users_guilds.current_feats, NewMember#ets_users_guilds.total_feats};
				_ ->
					{false, ?_LANG_GUILD_ERROR_NO_FEATS}
			end
	end.
																			 
%% 扣除功勋
reduce_guild_user_feats(GuildId,NeedLevel, UserId,  Feats,Type,Timers) ->
	case get_guild_info(GuildId) of
		{ok, GuildInfo} ->
			case GuildInfo#ets_guilds.shop_level >= NeedLevel of
				true ->
					reduce_guild_user_feats1(GuildId, UserId, Feats,Type,Timers);
				_ ->
					{false,?_LANG_GUILD_ERROR_NO_FEATS}
			end;
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_GUILD}
	end.
	
reduce_guild_user_feats1(GuildId, UserId, Feats,Type,Timers) ->
	case get_guild_user_info(GuildId, UserId) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER};
		GuildUserInfo when GuildUserInfo#ets_users_guilds.is_exists == 1
		  andalso GuildUserInfo#ets_users_guilds.current_feats >= Feats->
			Time = misc_timer:now_seconds(),
	
			OldFeatsList = GuildUserInfo#ets_users_guilds.other_data#other_users_guilds.use_feats_list,
			{OldOutFeatsList, OldOutFeatsList1,OldTodayFeats} = feats_detail(OldFeatsList, Time, Type),
			OldTimes = length(OldOutFeatsList1),
			UserFeats = OldTodayFeats + Feats,
			if Timers =:=0 orelse OldTimes+1 =< Timers ->
				   NewFeatsList = [{Time,Type,UserFeats}|OldOutFeatsList],
				   %%if
					%%	Type =:= 13 -> %%如果是祈福消耗则增加一次祈福次数
					%%		Other = GuildUserInfo#ets_users_guilds.other_data#other_users_guilds{use_feats_list = NewFeatsList,
					%%				prayer_num = GuildUserInfo#ets_users_guilds.other_data#other_users_guilds.prayer_num +1};
					%%	true ->
							Other = GuildUserInfo#ets_users_guilds.other_data#other_users_guilds{use_feats_list = NewFeatsList},
				   %%end,
				   LastFeats = GuildUserInfo#ets_users_guilds.current_feats - Feats,
				   db_agent_guild:update_user_guild([{current_feats,LastFeats}], 
											 [{user_id, GuildUserInfo#ets_users_guilds.user_id}, 
											  {guild_id, GuildUserInfo#ets_users_guilds.guild_id}]),
				   
				   NewGuildUserInfo = GuildUserInfo#ets_users_guilds{current_feats = LastFeats,other_data = Other},
				   update_guilds_member(NewGuildUserInfo,false),
				   
				   {true, NewGuildUserInfo#ets_users_guilds.current_feats,OldTimes+1};
			   true ->
				  {false,?_LANG_GUILD_ERROR_TIMERS_FEATS}
			end;
		_ ->
			{false,?_LANG_GUILD_ERROR_NO_FEATS}
	end.
	

get_guild_user_feats_use_timers(GuildId,UserId,Type)->
	case get_guild_user_info(GuildId, UserId) of
		[] ->
			{false,?_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER};
		GuildUserInfo when GuildUserInfo#ets_users_guilds.is_exists == 1 ->

			Time = misc_timer:now_seconds(),
	
			OldFeatsList = GuildUserInfo#ets_users_guilds.other_data#other_users_guilds.use_feats_list,
			{_,OldOutFeatsList, _OldTodayFeats} = feats_detail(OldFeatsList, Time, Type),
			OldTimes = length(OldOutFeatsList),
			{true,OldTimes};
		_ ->
			{false,?_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER}
	end.

pub_get_guild_user_feats_use_timers(GuildUserInfo,Type) ->
	OldFeatsList = GuildUserInfo#ets_users_guilds.other_data#other_users_guilds.use_feats_list,
	{_,OldOutFeatsList, _OldTodayFeats} = feats_detail(OldFeatsList, misc_timer:now_seconds(), Type),
	length(OldOutFeatsList).


%%====================================================================
%% Private functions
%%====================================================================

%%检查全局帮派名字是否被使用（ 1：可以使用； 0：被使用）
check_guild_name_isexist(Guild_Name) ->
	case config:get_guild_insert_site() of
		[] ->
			1;
		Insert_Site ->
			Nick = http_lib:url_decode(tool:to_list(Guild_Name)),
			Address = Insert_Site ++ "?club_name=" ++ Nick ++ "&server_id=" ++ config:get_server_no(),
			tool:to_integer(misc:get_http_content(Address))
	end.



get_leader_from_member([],Leaders) -> Leaders;
get_leader_from_member(Members,Leaders) ->
	if length(Leaders) =:= 2 ->
		   Leaders;
	   true ->
		   [H|T] = Members,
		   if H#ets_users_guilds.member_type =:= ?GUILD_JOB_PRESIDENT orelse
									H#ets_users_guilds.member_type =:= ?GUILD_JOB_VICE_PERSIDENT ->
				  get_leader_from_member(T,[H|Leaders]);
			  true ->
				  get_leader_from_member(T,Leaders)
		   end
	end.

%% send_stop_war_to_all() ->
%% 	send_stop_war_to_all_local(),
%% 	mod_node_interface:broadcast_stop_war_to_world(ets:tab2list(?ETS_SERVER_NODE)).
send_stop_war_to_all() ->
	DicL = get_guilds_dic(),
	F = fun(X) ->
		Other_Guilds = X#ets_guilds.other_data#other_guilds{declear_war_guild=[], enemy_guild = []},
		NewGuilds = X#ets_guilds{other_data = Other_Guilds},
		update_guilds_dic(NewGuilds)
	end,
	lists:foreach(F, DicL),
	send_stop_war_to_all_local(),
	mod_node_interface:broadcast_stop_war_to_world(ets:tab2list(?ETS_SERVER_NODE)).

send_stop_war_to_all_local() ->
	MS = ets:fun2ms(fun(T) -> 
					 T#ets_users.other_data#user_other.pid
					end),
	L = ets:select(?ETS_ONLINE, MS),
	do_stop_war(L).

do_stop_war(L) ->
	[gen_server:cast(Sid, {remove_all_guild_enemy}) || Sid <- L].
