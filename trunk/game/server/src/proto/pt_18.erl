%%Author: 黄文龙
%%Created: 2011-3-12
%%Description: 好友信息
-module(pt_18).
-export([read/2, write/2]).
-include("common.hrl").

%%
%%客户端 -> 服务端 ----------------------------
%%
%%关系添加
read(?PP_FRIEND_UPDATE,Bin)->
	{Nick,Bin2}=pt:read_string(Bin),
	<<IsFriend:32>> = Bin2,			%修改
	{ok,[Nick,IsFriend]};

%%分组更新
read(?PP_FRIEND_GROUP_UPDATE,<<GId:64,Bin/binary>>)->
	{GName,_}=pt:read_string(Bin),
	{ok,[GId,GName]};

%%返回好友列表
read(?PP_FRIEND_LIST,<<>>) ->
	{ok,[ ]};

%%好友删除18012
read(?PP_FRIEND_DELETE, <<FriendId:64,State:32>>) ->
    {ok, [FriendId,State]};

%%好友同意拒绝
read(?PP_FRIEND_ACCEPT,<<UserId:64,IsFriend:8>>) ->
    {ok,[UserId,IsFriend]};

%%好友分组删除
read(?PP_FRIEND_GROUP_DELETE,<<GId:64>>) ->
	{ok,[GId]};

%%分组移动
read(?PP_FRIEND_GROUP_MOVE,<<FromGId:64,ToGId:64,FriendId:64>>) ->
	{ok,[FromGId,ToGId,FriendId]};
read(?PP_QUERY_USER_INFO, <<UserId:64>>) ->
	{ok,[UserId]};
%%好友搜索
read(?PP_QUERY_FRIEND_INFO, <<Bin/binary>>) ->
	{UserName,_}=pt:read_string(Bin),
	{ok,[UserName]};
%% 查询用户经脉信息
read(?PP_QUERY_USER_VEINS, <<UserId:64>>) ->
	{ok,[UserId]};
read(Cmd, _R) ->
	?WARNING_MSG("~ts:~p ~p~n",["pt_18 cmd error", Cmd, _R]),
	ok.

%% 
%%服务端 -> 客户端 ------------------------------------

%%好友上下线提醒
write(?PP_FRIEND_ONLINE_STATE,[UserId,State]) ->
	Data = <<UserId:64,State:8>>,
	{ok,pt:pack(?PP_FRIEND_ONLINE_STATE,Data)};

%%返回好友列表 
write(?PP_FRIEND_LIST, [FriendList,GroupList]) ->
	GLen = length(GroupList),
	FGroup = fun(GInfo) ->
					 GroupName = pt:write_string(GInfo#ets_users_groups.name),
					 <<(GInfo#ets_users_groups.id):64,
					  GroupName/binary
					  >>
			 end,
	Bin1 = tool:to_binary([FGroup(X)|| X <- GroupList]),
	FLen = length(FriendList),
	FFriend = fun(Info)->
					FriendNick = pt:write_string(Info#ets_users_friends.other_data#other_friend.nick_name),
					<<(Info#ets_users_friends.friend_id):64,
					  FriendNick/binary,
					  (Info#ets_users_friends.other_data#other_friend.sex):8,
					  (Info#ets_users_friends.other_data#other_friend.career):8,
					  (Info#ets_users_friends.other_data#other_friend.level):16,
					  (Info#ets_users_friends.state):32,
					  (Info#ets_users_friends.other_data#other_friend.state):32,
					  (Info#ets_users_friends.group_id):64,
					  (Info#ets_users_friends.amity):32
					>>
			end,
	Bin2 = tool:to_binary([FFriend(X) || X <- FriendList]),	
	Data = <<GLen:32,Bin1/binary, FLen:32,Bin2/binary>>,
	{ok, pt:pack(?PP_FRIEND_LIST, Data)};


%%好友更新 State是用户表的state表在线状态，FriendState是用户关系
write(?PP_FRIEND_UPDATE, [UserId,FriendNick,Sex,Level,State,FriendState,Career,Amity]) ->
    FriendNick1=pt:write_string(FriendNick),
	Data = <<UserId:64, FriendState:32,State:32,FriendNick1/binary,Sex:8,Level:8,Career:8,Amity:32>>,
    {ok, pt:pack(?PP_FRIEND_UPDATE, Data)};

%%分组更新
write(?PP_FRIEND_GROUP_UPDATE, [Id,Gname,IsExist]) ->
    Gname1=pt:write_string(Gname),
	if IsExist=:=1->
	Data = <<Id:64,1:8,Gname1/binary>>;
	   true ->
		   Data= <<Id:64,0:8>>
	end,
    {ok, pt:pack(?PP_FRIEND_GROUP_UPDATE, Data)};

%%好友删除 
write(?PP_FRIEND_DELETE,[Result,UserId]) ->
	Data= <<Result:8,UserId:64>>,
	{ok,pt:pack(?PP_FRIEND_DELETE,Data)};

%%添加好友响应
write(?PP_FRIEND_RESPONSE,[FriendId,UserId,UserNick]) ->
	    FriendNick1=pt:write_string(UserNick),
	Data = <<FriendId:64,UserId:64,FriendNick1/binary>>,
    {ok, pt:pack(?PP_FRIEND_RESPONSE, Data)};

%%好友分组删除 
write(?PP_FRIEND_GROUP_DELETE, [GId]) ->
	Data= <<GId:64>>,
	{ok,pt:pack(?PP_FRIEND_GROUP_DELETE,Data)};

%% 好友分组移动
write(?PP_FRIEND_GROUP_MOVE,[FromGId,ToGId,FriendId]) ->
	Data= <<FromGId:64,ToGId:64,FriendId:64>>,
	{ok,pt:pack(?PP_FRIEND_GROUP_MOVE,Data)};

%% 用户信息查询
write(?PP_QUERY_USER_INFO, [UserId, User, Items]) ->
	DetailPlayer = pt:packet_detail_player(User),
	ItemBin = pt:packet_item_list(Items),
	%ItemsLen = erlang:length(Items),
	%{ok, pt:pack(?PP_QUERY_USER_INFO, <<UserId:64, DetailPlayer/binary, ItemsLen:32, ItemBin/binary>>)};
	{ok, pt:pack(?PP_QUERY_USER_INFO, <<UserId:64, DetailPlayer/binary, ItemBin/binary>>)};

%% 查询用户经脉信息
write(?PP_QUERY_USER_VEINS, [UserId, List]) ->
	Size = length(List),
	Bin = pt:writeveins(List, <<>>),
	{ok, pt:pack(?PP_QUERY_USER_VEINS, <<UserId:64, Size:16, Bin/binary>>)};

%%好友搜索 
write(?PP_QUERY_FRIEND_INFO, [IsExist,Id,User]) ->
	if IsExist=:=0 ->
		   Data= <<0:8>>;
	   true ->
		   BaseBin =pt:packet_base_player(User),
		   Camp = User#ets_users.camp,
		   Career = User#ets_users.career, 
		   ClubNameBin = pt:write_string(User#ets_users.other_data#user_other.club_name),
		   Data= <<1:8,Id:64,BaseBin/binary,Camp:8,Career:8,ClubNameBin/binary>>
	end,
	{ok, pt:pack(?PP_QUERY_FRIEND_INFO, Data)};

%%好友模块提示信息
write(?PP_FRIEND_SYS_MSG,[Msg]) ->
	Data = <<Msg:8>>,
	{ok, pt:pack(?PP_FRIEND_SYS_MSG,Data)};

%% 好友度更新
write(?PP_FRIEND_AMITY_UPDATE,[FriendId,CheckAmity]) ->
	{ok, pt:pack(?PP_FRIEND_AMITY_UPDATE,<<FriendId:64,CheckAmity:32>>)};

write(Cmd, _R) ->
	?WARNING_MSG("~s_errorcmd_[~p] ",[misc:time_format(misc_timer:now()), Cmd]),
	{ok, pt:pack(0, <<>>)}.
 