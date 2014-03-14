%% Author: wangdahai
%% Created: 2013-9-2
%% Description: TODO: Add description to lib_marry
-module(lib_marry).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([marry_request/3,marry_request/6,get_user_marry/1,give_gife/3,pack_marry_title/1,
			marry_echo/2,marry_echo_no/4,marry_echo_yes/3,divorce/3,marry_change/2]).

-define(MARRY_PRICE1, 520).					%普遍婚礼价格
-define(MARRY_PRICE2, 1314).				%豪华婚礼价格
-define(MARRY_RING1, 274001).				%普通婚戒
-define(MARRY_RING2, 274002).				%豪华婚戒
-define(MARRY_NPC_ID, 102108).				%结婚npcID
-define(MARRY_MIN_AMITY, 1000).				%结婚所需最低好友度
-define(MARRY_MAX_WAIT_TIME, 180).			%结婚请求最大等待时间
-define(DIVORCE_PRICE, 10).				%强制离婚价格
-define(MARRY_CHANGE_PRICE, 100).			%变跟小妾关系价格
-define(MARRY_LEVE_LIMIT, 37).				%结婚等级限制
%%
%% API Functions
%%
get_user_marry(UserID) ->
	F = fun(Info,L) -> 
				Record = list_to_tuple([ets_user_marry] ++ Info),
				[Record|L]
		end,
	if	UserID > 0 ->
			List = lists:foldl(F,[],db_agent_marry:get_user_marry(UserID)),
			case db_agent_marry:get_groom_info(UserID) of
				[] ->
					List;
				GInfo ->
					R = list_to_tuple([ets_user_marry] ++ GInfo),
					[R|List]
			end;
		true ->
			[]
	end.

marry_request(PlayerStatus, Id,Type) ->
	NeedYuanbao = 
	case Type of
		1 -> ?MARRY_PRICE1;
		_ -> ?MARRY_PRICE2
	end,
	case data_agent:npc_get(?MARRY_NPC_ID) of
		[] -> {false,?_LANG_ER_NOT_EXSIT_DATA};
		NPC ->
			Now = misc_timer:now_seconds(),
			{Tid,_,_,Time} = PlayerStatus#ets_users.other_data#user_other.marry_status,
			if	Tid > 0 andalso (Time + ?MARRY_MAX_WAIT_TIME) > Now ->
					{false,?_LANG_ER_IS_PROPOSING};
				PlayerStatus#ets_users.level < ?MARRY_LEVE_LIMIT ->
					Msg = ?GET_TRAN(?_LANG_ER_NOT_ENOUGH_LEVEL,[?MARRY_LEVE_LIMIT]),
					{false,Msg};
				PlayerStatus#ets_users.marry_id > 0 andalso PlayerStatus#ets_users.marry_id =/= PlayerStatus#ets_users.id ->
					{false,?_LANG_ER_IS_MARRYED};
				PlayerStatus#ets_users.yuan_bao < NeedYuanbao ->
					{false,?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[NeedYuanbao])};
				PlayerStatus#ets_users.current_map_id =/= NPC#ets_npc_template.map_id orelse abs(PlayerStatus#ets_users.pos_x - NPC#ets_npc_template.pos_x) > ?ACCEPT_DISTANT
					orelse abs(PlayerStatus#ets_users.pos_y - NPC#ets_npc_template.pos_y) > ?ACCEPT_DISTANT ->
					{false,?GET_TRAN(?_LANG_ER_NOT_NEAR_NPC,[NPC#ets_npc_template.name])};
				true ->
					case lib_friend:get_friend_info(Id) of
						[] -> {false,?_LANG_ER_NOT_ENOUGH_AMITY};						
						[FInfo] when(FInfo#ets_users_friends.amity < ?MARRY_MIN_AMITY) ->
							{false,?_LANG_ER_NOT_ENOUGH_AMITY};
						[FInfo] when(FInfo#ets_users_friends.other_data#other_friend.state =:= 1) ->
							case lib_player:get_online_info(Id) of
								[] -> {false,?_LANG_ER_NOT_ON_LINE};
								FriendInfo when(FriendInfo#ets_users.level < ?MARRY_LEVE_LIMIT) ->
									{false,?GET_TRAN(?_LANG_ER_FRIEND_NOT_ENOUGH_LEVEL,[?MARRY_LEVE_LIMIT])};
								FriendInfo ->
									case lists:keyfind(2, #ets_user_marry.type, PlayerStatus#ets_users.other_data#user_other.marry_list) of
										false ->
											Relation = 1;
										_ ->
											Relation = 2
									end,									
									gen_server:cast(FriendInfo#ets_users.other_data#user_other.pid,{marry_request,PlayerStatus#ets_users.id,
																									PlayerStatus#ets_users.nick_name,Type,Relation,Now}),
									NewOther = PlayerStatus#ets_users.other_data#user_other{marry_status = {Id,Type,1,Now}}, 
									NewStatus = PlayerStatus#ets_users{other_data = NewOther},
									{ok,NewStatus}
							end;
						_ ->
							{false,?_LANG_ER_NOT_ON_LINE}
					end
			end
	end.
	
%%被邀请者处理方法
marry_request(Status,UserId,NickName,Type,Relation,Now) ->
	{Tid,_,_,Time} = Status#ets_users.other_data#user_other.marry_status,
	Res = 
	case Status#ets_users.other_data#user_other.marry_list of
		[] when(Tid > 0 andalso (Time + ?MARRY_MAX_WAIT_TIME) > Now) ->
			NewStatus = Status,
			{false,?_LANG_ER_IS_PROPOSED};		
		[] ->
			NewOther = Status#ets_users.other_data#user_other{marry_status = {UserId,Type,0,Now}},
			NewStatus = Status#ets_users{other_data = NewOther},
			{ok,Bin} = pt_29:write(?PP_MARRY_REQUEST_NOTICE, [Type,NickName,Relation]),
			lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
			ok;
		_ ->			
			NewStatus = Status,
			{false,?_LANG_ER_IS_MARRY}
	end,
	case lib_player:get_online_info(UserId) of
		[] -> skip;
		FriendInfo ->
			case Res of
				ok ->
					{ok,RBin} = pt_29:write(?PP_MARRY_REQUEST,1);
				{false,Msg} ->
					gen_server:cast(FriendInfo#ets_users.other_data#user_other.pid, {marry_request_error}),
					lib_chat:chat_sysmsg_pid([FriendInfo#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
					{ok,RBin} = pt_29:write(?PP_MARRY_REQUEST,0)
			end,
			lib_send:send_to_sid(FriendInfo#ets_users.other_data#user_other.pid_send, RBin)		
	end,
	{noreply, NewStatus}.
%%回复求婚
marry_echo(Status, Type) ->%%1 同意，2拒绝，3理由拒绝
	Now = misc_timer:now_seconds(),
	{Tid,MType,State,Time} = Status#ets_users.other_data#user_other.marry_status,
	Res = 
	if	Tid =:= 0 orelse State =/= 0 orelse (Time + ?MARRY_MAX_WAIT_TIME) < Now ->
			{false,Status,?_LANG_ER_NO_PROPOSE};
		true ->
			case data_agent:npc_get(?MARRY_NPC_ID) of
				[] -> {false,Status,?_LANG_ER_NOT_EXSIT_DATA};
				NPC ->				
					case lib_player:get_online_info(Tid) of
						[] when(Type =:= 1) -> {false,Status,?_LANG_ER_NOT_ON_LINE};
						[] ->
							NewOther = Status#ets_users.other_data#user_other{marry_status={0,0,0,0}},
							{ok, Status#ets_users{other_data = NewOther}};
						MarryInfo ->
							if	Type =/= 1 ->									
									gen_server:cast(MarryInfo#ets_users.other_data#user_other.pid, {marry_echo,Status#ets_users.id,Status#ets_users.nick_name,Type}),
									NewOther = Status#ets_users.other_data#user_other{marry_status={0,0,0,0}},
									{ok,Status#ets_users{other_data = NewOther}};							
								Status#ets_users.current_map_id =/= NPC#ets_npc_template.map_id orelse abs(Status#ets_users.pos_x - NPC#ets_npc_template.pos_x) > ?ACCEPT_DISTANT
										orelse abs(Status#ets_users.pos_y - NPC#ets_npc_template.pos_y) > ?ACCEPT_DISTANT ->
									{false,Status,?GET_TRAN(?_LANG_ER_NOT_NEAR_NPC,[NPC#ets_npc_template.name])};										
								true ->
									gen_server:cast(MarryInfo#ets_users.other_data#user_other.pid, {marry_echo,Status#ets_users.id,Status#ets_users.nick_name,Type}),						
									NewOther = Status#ets_users.other_data#user_other{marry_status={Tid,MType,2,Now}},
									{ok,Status#ets_users{other_data = NewOther}}
							end
					end
			end
	end,
	case Res of
		{false,NewStatus,Msg} ->
			lib_chat:chat_sysmsg_pid([NewStatus#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
			{0,NewStatus};
		{ok,NewStatus} ->
			{1,NewStatus}
	end.
%%根据求婚回复结果处理
marry_echo_no(Status, UserId, NickName, Res) ->
	{Tid,_,State,_} = Status#ets_users.other_data#user_other.marry_status,
	if Tid =:= UserId andalso State =:= 1 ->
		NewOther = Status#ets_users.other_data#user_other{marry_status = {0,0,0,0}},
		NewStatus =  Status#ets_users{other_data = NewOther},
		{ok,Bin} = pt_29:write(?PP_MARRY_ECHO_NOTICE, [NickName,Res]),
		lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
		NewStatus;
	   true ->
			Status
	end.

marry_echo_yes(Status, UserId, NickName) ->
	{Tid,Type,State,Time} = Status#ets_users.other_data#user_other.marry_status,
	{NeedYuanbao, Ring_Id} = 
	case Type of
		1 -> {?MARRY_PRICE1,?MARRY_RING1};
		_ -> {?MARRY_PRICE2,?MARRY_RING2}
	end,
	{Res,Msg}=
	case data_agent:npc_get(?MARRY_NPC_ID) of
		[] -> {false,?_LANG_ER_NOT_EXSIT_DATA};
		NPC ->			
			if	Tid =/= UserId orelse State =/= 1 ->
					{error,[]};
				Status#ets_users.yuan_bao < NeedYuanbao ->
					{false,?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[NeedYuanbao])};
				Status#ets_users.current_map_id =/= NPC#ets_npc_template.map_id orelse abs(Status#ets_users.pos_x - NPC#ets_npc_template.pos_x) > ?ACCEPT_DISTANT
					orelse abs(Status#ets_users.pos_y - NPC#ets_npc_template.pos_y) > ?ACCEPT_DISTANT ->
					{false,?GET_TRAN(?_LANG_ER_NOT_NEAR_NPC,[NPC#ets_npc_template.name])};
				true ->
					{ok,[]}
			end
	end,
	NewStatus = 
	case lib_player:get_online_info(UserId) of
		[] -> Status;
		FriendInfo ->
			case Res of
				error ->
					{ok,Bin} = pt_29:write(?PP_MARRY_ECHO, 0),
					lib_send:send_to_sid(FriendInfo#ets_users.other_data#user_other.pid_send, Bin),
					Status;
				false ->
					lib_chat:chat_sysmsg_pid([FriendInfo#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,?_LANG_ER_MARRY_LIMIT]),
					lib_chat:chat_sysmsg_pid([Status#ets_users.other_data#user_other.pid_send,?FLOAT,?None,?RED,Msg]),
					{ok,Bin} = pt_29:write(?PP_MARRY_ECHO, 0),
					lib_send:send_to_sid(FriendInfo#ets_users.other_data#user_other.pid_send, Bin),
					Status;
				ok ->
					{ok,Bin} = pt_29:write(?PP_MARRY_ECHO_NOTICE, [NickName,1]),
					lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
					{ok,Bin1} = pt_29:write(?PP_MARRY_ECHO, 1),
					lib_send:send_to_sid(FriendInfo#ets_users.other_data#user_other.pid_send, Bin1),
					{ok,Pid} = mod_marry_duplicate:start(Status#ets_users.id, Type),%%创建结婚地图副本
					MarryInfo = #ets_user_marry{user_id = Status#ets_users.id,
												marry_id = FriendInfo#ets_users.id,
												groom_name = Status#ets_users.nick_name,
												bride_name = FriendInfo#ets_users.nick_name,
												type = get_marry_type(Status#ets_users.other_data#user_other.marry_list),
												career = FriendInfo#ets_users.career,
												sex = FriendInfo#ets_users.sex,
												marry_time = misc_timer:now_seconds()
												},
					if	Status#ets_users.other_data#user_other.marry_list =:= [] ->
							GInfo = #ets_user_marry{user_id = Status#ets_users.id,
												marry_id = Status#ets_users.id,
												groom_name = Status#ets_users.nick_name,
												bride_name = Status#ets_users.nick_name,
												type = 1,
												career = Status#ets_users.career,
												sex = Status#ets_users.sex
												},							
							NewList = [GInfo,MarryInfo];
						true ->
							NewList = [MarryInfo|Status#ets_users.other_data#user_other.marry_list]
					end,
					%?DEBUG("get_online_info:~p",[NewList]),
					gen_server:cast(FriendInfo#ets_users.other_data#user_other.pid, {marry_success, Status#ets_users.id, Ring_Id,NewList}),
					gen_server:call(Pid, {enter_marry_duplicate,Status#ets_users.id,
																Status#ets_users.other_data#user_other.pid,
																Status#ets_users.nick_name,
																FriendInfo#ets_users.id,
																FriendInfo#ets_users.other_data#user_other.pid,
																FriendInfo#ets_users.nick_name}),
					NewOther = Status#ets_users.other_data#user_other{marry_status = {Tid,Type,2,Time},marry_list = NewList},
					update_marry(NewList,FriendInfo#ets_users.id),%通知其它列表
					Status1 = Status#ets_users{other_data = NewOther, marry_id = Status#ets_users.id},
					%发送结婚戒指
					gen_server:cast(Status#ets_users.other_data#user_other.pid_item, {'add_item_or_mail', Ring_Id, 1, ?BIND,Status#ets_users.nick_name,?ITEM_PICK_SYS}),
					
					db_agent_marry:add_user_marry(MarryInfo),%更新结婚数据到数据库
					
					lib_player:reduce_cash_and_send(Status1, NeedYuanbao, 0, 0, 0, {?CONSUME_YUANBAO_MARRY,UserId,1})
			end							
	end,
	NewStatus.

give_gife(Status, Type,Id) ->
	{NeedYuanbao,NeedMoney} = 
	case Type of
		1 -> {88,0};
		2 -> {0,888};
		3 -> {0,88888};
		_ -> {0,0}
	end,
	if 	NeedYuanbao + NeedMoney =:= 0 ->
			{error, ?_LANG_ER_WRONG_VALUE};
		NeedYuanbao > Status#ets_users.yuan_bao ->
			Msg = ?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[NeedYuanbao]),
			{error,Msg};
		NeedMoney > Status#ets_users.copper ->
			Msg = ?GET_TRAN(?_LANG_ER_NOT_ENOUGH_COPPER,[NeedMoney]),
			{error,Msg};
		true ->
			give_gife1(Id,Status,NeedYuanbao,NeedMoney)
	end.

divorce(Id, Type, Status) ->
	%?DEBUG("divorce:~p",[{Id, Type, Status#ets_users.id,Status#ets_users.marry_id}]),
	if	Status#ets_users.id =:= Status#ets_users.marry_id -> %%老公要求离婚
%% 			if	Type =:= 1 ->
%% 					divorce1(Id, Status, 1);
%% 				true ->
					divorce2(Id, Status, 1);
%% 			end;
		true ->
%% 			if	Type =:= 1 ->
%% 					divorce1(Id, Status, 2);
%% 				true ->
					divorce2(Id, Status, 2)
%% 			end
	end.

pack_marry_title(Status) ->
	if	Status#ets_users.id =:= Status#ets_users.marry_id  ->
			case lists:keyfind(2, #ets_user_marry.type, Status#ets_users.other_data#user_other.marry_list) of
				false ->
					case lists:keyfind(3, #ets_user_marry.type, Status#ets_users.other_data#user_other.marry_list) of
						false ->
							NickName = pt:write_string(""),
							<<0:16,NickName/binary>>;
						MInfo ->
							NickName = pt:write_string(MInfo#ets_user_marry.bride_name),
							<<1:16,NickName/binary>>
					end;
				MInfo ->
					NickName = pt:write_string(MInfo#ets_user_marry.bride_name),
					<<1:16,NickName/binary>>
			end;
		true ->
			case lists:keyfind(1, #ets_user_marry.type, Status#ets_users.other_data#user_other.marry_list) of
				false ->
					NickName = pt:write_string(""),
					<<0:16,NickName/binary>>;
				MInfo ->
					case lists:keyfind(Status#ets_users.id, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list) of
						false ->
							NickName = pt:write_string(""),
							<<0:16,NickName/binary>>;
						TInfo ->
							NickName = pt:write_string(MInfo#ets_user_marry.bride_name),
							<<(TInfo#ets_user_marry.type):16,NickName/binary>>
					end					
			end
	end.

marry_change(Id, Status) ->
	if	Status#ets_users.yuan_bao < ?MARRY_CHANGE_PRICE ->
			{false,?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[?MARRY_CHANGE_PRICE])};
		true ->
			marry_change1(Id, Status)
	end.

%% divorce_reply(Id, Res, Status) ->
%% 	Type = 
%% 	if	Id =:= Status#ets_users.id -> 2;%老婆操作
%% 		true ->	1%老公操作
%% 	end,
%% 	case lists:keyfind(Id, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list) of
%% 		false -> {false,?_LANG_ER_WRONG_VALUE};
%% 		MarryInfo when(MarryInfo#ets_user_marry.divorce_state =:= 1 andalso Type =:= 2) orelse
%% 					(MarryInfo#ets_user_marry.divorce_state =:= 2 andalso Type =:= 1) ->
%% 			if	Res =:= 0 ->
%% 					NewInfo = MarryInfo#ets_user_marry{divorce_state = Type + 2},
%% 					NewList = lists:keyreplace(MarryInfo#ets_user_marry.marry_time, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list, NewInfo),
%% 					db_agent_marry:update_marry(NewInfo),
%% 					divorce_reply1(Type,NewInfo,1);
%% 				true ->
%% 					NewList = lists:keydelete(MarryInfo#ets_user_marry.marry_time, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list),
%% 					db_agent_marry:delete_marry(MarryInfo),
%% 					%邮件
%% 					divorce_reply1(Type,MarryInfo,2)
%% 			end,
%% 			NewOther = Status#ets_users.other_data#user_other{marry_list = NewList},
%% 			Status#ets_users{other_data = NewOther};
%% 		_ ->
%% 			{false,?_LANG_ER_WRONG_VALUE}
%% 	end.

%% divorce_reply1(Type,MarryInfo,Res) ->%Res = 1 update 2 delete
%% 	NewId = if Type =:= 1 -> MarryInfo#ets_user_marry.marry_id; true -> MarryInfo#ets_user_marry.user_id end,
%% 	case lib_player:get_player_pid(NewId) of
%% 		[] -> skip;
%% 		Pid ->
%% 			gen_server:cast(Pid, {update_marry, Res, MarryInfo})
%% 	end.
	

%% Local Functions
give_gife1(Id,Status,NeedYuanbao,NeedMoney) ->
	ProcessName = misc:create_process_name(mod_marry_dup, [Id]),
	case misc:whereis_name({global, ProcessName}) of
		undefined ->
			{error,?_LANG_ER_NOT_EXSIT_MARRY};
		Pid ->
			case gen_server:call(Pid, {give_gift_enter, Status#ets_users.id, Status#ets_users.other_data#user_other.pid,
										Status#ets_users.nick_name, NeedYuanbao, NeedMoney}) of
				ok ->
					NewStatus = lib_player:reduce_cash_and_send(Status, NeedYuanbao, 0, NeedMoney, 0,{?CONSUME_MONEY_MARRY_GIVE_GIFT,Id,1}),
					{ok,NewStatus};
				_ ->
					{error,?_LANG_ER_MARRY_IS_FINISH}
			end
	end.

%% divorce1(Id, Status, Type) ->%%和平离婚
%% 	NewId = if Type =:= 1 -> Id ; true -> Status#ets_users.id end,
%% 	case lists:keyfind(NewId, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list) of
%% 		false -> {false,?_LANG_ER_WRONG_VALUE};
%% 		MarryInfo when MarryInfo#ets_user_marry.divorce_state =:= 0 ->
%% 			NewInfo = MarryInfo#ets_user_marry{divorce_state = Type},
%% 			NewList = lists:keyreplace(NewId, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list, NewInfo),
%% 			NewOther = Status#ets_users.other_data#user_other{marry_list = NewList},
%% 			case lib_player:get_player_pid(Id) of
%% 				[] -> skip;
%% 				Pid ->
%% 					gen_server:cast(Pid, {update_marry, 1, NewList})
%% 			end,
%% 			db_agent_marry:update_marry(NewInfo),
%% 			Status#ets_users{other_data = NewOther};
%% 		_ ->
%% 			{false,?_LANG_ER_WRONG_VALUE}
%% 	end.

update_marry(List,RId) ->
	F = fun(Info) ->
			if	Info#ets_user_marry.type > 1 andalso Info#ets_user_marry.marry_id =/= RId ->
					case lib_player:get_player_pid(Info#ets_user_marry.marry_id) of
						[] ->skip;
						Pid ->
							gen_server:cast(Pid, {update_marry, 1, false, List})
					end;
				true ->
					skip
			end
		end,
	lists:foreach(F, List).

divorce2(Id, Status, Type) ->%%强制离婚
		%?DEBUG("divorce2:~p",[{Id, Type}]),
 	if	Status#ets_users.yuan_bao < ?DIVORCE_PRICE ->
			{false,?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[?DIVORCE_PRICE])};
 		true ->
 			NewId = if Type =:= 1 -> Id ; true -> Status#ets_users.id end,
			case lists:keyfind(NewId, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list) of
				false -> {false,?_LANG_ER_WRONG_VALUE};
				MarryInfo ->
					NewList1 = lists:keydelete(NewId, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list),	
					NewList = if length(NewList1) < 2 -> []; true -> NewList1 end,
					case lib_player:get_player_pid(Id) of
						[] -> 
							if	Status#ets_users.id =:= Status#ets_users.marry_id orelse NewList =:= [] ->
									db_agent_marry:divorce_up_marry_id(Id);
								true -> skip
							end;
						Pid ->
							gen_server:cast(Pid, {update_marry, 2, true, NewList})
					end,
					divorce2_1(Type,MarryInfo),
					db_agent_marry:delete_marry(MarryInfo),
					%?DEBUG("divorce2:~p",[{Re,NewId,NewList}]),
					update_marry(NewList,0),
					if	Status#ets_users.id =/= Status#ets_users.marry_id orelse NewList =:= [] ->
							NewOther = Status#ets_users.other_data#user_other{marry_list = []},
							NewStatus = Status#ets_users{marry_id = 0, other_data = NewOther};
						true ->
							NewOther = Status#ets_users.other_data#user_other{marry_list = NewList},
							NewStatus = Status#ets_users{other_data = NewOther}
					end,					
					lib_player:reduce_cash_and_send(NewStatus, ?DIVORCE_PRICE, 0, 0, 0, {?CONSUME_YUANBAO_DIVORCE,NewId,1})
			end
 	end.
 divorce2_1(Type,MarryInfo) ->
	if	Type =:= 1 ->	
			Str = ?GET_TRAN(?_LANG_MAIL_DIVORCE_CONTENT,[MarryInfo#ets_user_marry.groom_name]),
			lib_mail:send_sys_mail(MarryInfo#ets_user_marry.groom_name, MarryInfo#ets_user_marry.user_id, MarryInfo#ets_user_marry.bride_name,
									 MarryInfo#ets_user_marry.marry_id, [], ?Mail_Type_Common, ?_LANG_MAIL_DIVORCE_TITLE, Str, 0, 0, 0, 0);
		true ->
			Str = ?GET_TRAN(?_LANG_MAIL_DIVORCE_CONTENT,[MarryInfo#ets_user_marry.bride_name]),
			lib_mail:send_sys_mail(MarryInfo#ets_user_marry.bride_name, MarryInfo#ets_user_marry.marry_id, MarryInfo#ets_user_marry.groom_name,
									 MarryInfo#ets_user_marry.user_id, [], ?Mail_Type_Common, ?_LANG_MAIL_DIVORCE_TITLE, Str, 0, 0, 0, 0)
	end.

marry_change1(Id, Status) ->
	case lists:keyfind(Id, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list) of
		false -> {false,?_LANG_ER_WRONG_VALUE};
		MarryInfo when MarryInfo#ets_user_marry.type =:= 3 ->
			NewInfo = MarryInfo#ets_user_marry{type = 2},
			db_agent_marry:update_marry(NewInfo),			
			NewList =
			case lists:keyfind(2, #ets_user_marry.type, Status#ets_users.other_data#user_other.marry_list) of
				false ->
					lists:keyreplace(Id, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list, NewInfo);	
				MInfo ->
					NInfo =  MInfo#ets_user_marry{type = 3},
					db_agent_marry:update_marry(NInfo),					
					List = lists:keyreplace(Id, #ets_user_marry.marry_id, Status#ets_users.other_data#user_other.marry_list, NewInfo),
					NewList1 = lists:keyreplace(NInfo#ets_user_marry.marry_id, #ets_user_marry.marry_id, List, NInfo),
					case lib_player:get_player_pid(NInfo#ets_user_marry.marry_id) of
						[] -> skip;
						Pid2 ->
							gen_server:cast(Pid2, {update_marry, 1,true, NewList1})
					end,
					Content2 = ?GET_TRAN(?_LANG_MAIL_MARRY_CHANGE2_CONTENT,[Status#ets_users.nick_name]),
					lib_mail:send_sys_mail(Status#ets_users.nick_name, Status#ets_users.id, NInfo#ets_user_marry.bride_name,
											NInfo#ets_user_marry.marry_id, [], ?Mail_Type_Common,?_LANG_MAIL_MARRY_CHANGE2_TITLE,Content2, 0, 0, 0, 0),
					NewList1
			end,
			case lib_player:get_player_pid(Id) of
				[] -> skip;
				Pid ->
					gen_server:cast(Pid, {update_marry, 1,true, NewList})
			end,
			Content1 = ?GET_TRAN(?_LANG_MAIL_MARRY_CHANGE1_CONTENT,[Status#ets_users.nick_name]),
			lib_mail:send_sys_mail(Status#ets_users.nick_name, Status#ets_users.id, NewInfo#ets_user_marry.bride_name,Id, [],
									?Mail_Type_Common, ?_LANG_MAIL_MARRY_CHANGE1_TITLE,Content1, 0, 0, 0, 0),
			update_marry(NewList,Id),%通知其它列表
			NewOther = Status#ets_users.other_data#user_other{marry_list = NewList},
			NewStatus = Status#ets_users{other_data = NewOther},
			lib_player:reduce_cash_and_send(NewStatus, ?MARRY_CHANGE_PRICE, 0, 0, 0, {?CONSUME_YUANBAO_CHANGE_MARRY,Id,1});
		_ ->
			{false,?_LANG_ER_WRONG_VALUE}
	end.

get_marry_type(List) ->%%1老公2老婆3小妾
	case lists:keyfind(2, #ets_user_marry.type, List) of
		false ->
			2;
		_ ->
			3
	end.





