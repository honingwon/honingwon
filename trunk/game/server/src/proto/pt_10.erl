%%%-----------------------------------
%%% @Module  : pt_10
%%% @Created : 2011.03.04
%%% @Description: 帐户信息
%%%-----------------------------------
-module(pt_10).
-export([read/2, 
		 write/2]).
-include("common.hrl").



%%
%%客户端 -> 服务端 ----------------------------
%%

%%登陆
read(?PP_ACCOUNT_LOGIN, <<Key:32,Bin/binary>>) ->
    {Username, Bin1} = pt:read_string(Bin),
	{Site, Bin2_2} = pt:read_string(Bin1),
	<<Server_id:16, Bin2/binary>> = Bin2_2,
	{Tick, Bin3} = pt:read_string(Bin2),
	{Sign, _} = pt:read_string(Bin3),
	case lists:any(fun(E)-> E =:= Server_id  end, config:get_login_server_id()) of
		true ->
			 {ok, login, [Key,Username, Site, Server_id, Tick, Sign]};
		false ->
			false
	end;
   


%%选择角色进入游戏
read(?PP_ACCOUNT_SELECT, <<Id:64>>) ->
    {ok, select , Id};

%%创建角色
read(?PP_ACCOUNT_CREATE, <<Career:32, Sex:8, Bin/binary>>) ->
    {Nickname, _} = pt:read_string(Bin),
    {ok, create, [Career, Sex, Nickname]};

%%心跳包
read(?PP_ACCOUNT_HEARTBEAT, <<_Tmp:8>>) ->
    {ok, heartbeat};

read(?PP_ACCOUNT_HEARTBEAT, _) ->
    {ok, heartbeat};

read(?PP_ACCOUNT_GUEST, <<_Tmp:8>>) ->
	{ok, guest_create, []};

read(?PP_ACCOUNT_GUEST_LOGIN, <<UserID:64, Bin/binary>>) ->
	{GuestName, _} = pt:read_string(Bin),
	{ok, guest_login, [UserID, GuestName]};

read(Cmd, _R) ->
	?WARNING_MSG("pt_14 read:~w", [Cmd]),
    {error, no_match}.

%%
%%服务端 -> 客户端 ------------------------------------
%%

%% 返回角色列表
write(?PP_ACCOUNT_USERSLIST_RETURN, [L, IP, Port]) ->
	List = 
		case length(L) of
			Count when Count > 0 ->
				[T|_] = L,
				[T];
			_ ->
				L
		end,
    N = length(List),
    F = fun([UserID, Username, Nickname, Sex, Level, _Vip]) ->
			UserBin = pt:write_string(Username),
			NickBin = pt:write_string(Nickname),
            <<UserID:64,  
			  Sex:8, 
			  Level:32, 
			  UserBin/binary,
			  NickBin/binary>>

    end,
    LB = tool:to_binary([F(X) || X <- List]), 
	IPBin =  pt:write_string(IP),
	
    {ok, pt:pack(?PP_ACCOUNT_USERSLIST_RETURN, <<N:16, LB/binary, IPBin/binary, Port:16>>)};


%%登陆返回
write(?PP_ACCOUNT_LOGIN, [IsSuccess, Msg]) ->
	MsgBin = pt:write_string(Msg),
	{ok ,pt:pack(?PP_ACCOUNT_LOGIN, <<IsSuccess:8, MsgBin/binary>>)};

%%创建角色返回
write(?PP_ACCOUNT_CREATE, [IsSucc, Msg, UserId]) ->
	MsgBin = pt:write_string(Msg),
	Data = <<IsSucc:8, MsgBin/binary, UserId:64>>,
    {ok, pt:pack(?PP_ACCOUNT_CREATE , Data)};


%%返回选择人物信息
write(?PP_ACCOUNT_SELECT, [User]) ->
	SelfPlayer =  pt:packet_self_player(User),
	UserID = User#ets_users.id,
%% 	CurrentMapID = User#ets_users.current_map_id,	
	CurrentMapID = User#ets_users.other_data#user_other.map_template_id,
	Data = <<UserID:64, SelfPlayer/binary, CurrentMapID:32>>,
%% 	?PRINT("PP_LOGIN:~w,~w,~w~n",[User#ets_users.nick_name,User#ets_users.exp,User#ets_users.attack]),
	{ok, pt:pack(?PP_LOGIN, Data)};


write(?PP_ACCOUNT_GUEST, [IsSucc, Msg, GuestName, GuestId]) ->
	MsgBin = pt:write_string(Msg),
	GuestNameBin = pt:write_string(GuestName),
	Data = <<IsSucc:8, MsgBin/binary, GuestNameBin/binary, GuestId:64>>,
	{ok, pt:pack(?PP_ACCOUNT_GUEST,Data)};

write(?PP_ACCOUNT_LOST_CONNECT,[Reason]) ->
	{ok, pt:pack(?PP_ACCOUNT_LOST_CONNECT, <<Reason:8>>)};

%% 返回：按照accid创建一个角色，或自动分配一个角色(accid=0)
%write(10010, [NewAccid, PlayerId, Accname]) ->
%    Accname1 = tool:to_binary(Accname),
%    NLen = byte_size(Accname1),	
 %   Data = <<NewAccid:32,
%			 PlayerId:64,
%			 NLen:16, 
%			 Accname1/binary>>,	
 %   {ok, pt:pack(10010, Data)};

write(Cmd, _R) ->
	?WARNING_MSG("pt_10,write:~w",[Cmd]),
    {ok, pt:pack(0, <<>>)}.





