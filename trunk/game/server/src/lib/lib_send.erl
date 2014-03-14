%%%-----------------------------------
%%% @Module  : lib_send
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description: 发送消息
%%%-----------------------------------
-module(lib_send). 
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([
        send_one/2,
        send_to_sid/2,
        send_to_all/1,
        send_to_local_all/1,	
        send_to_nick/2,
        send_to_uid/2,
        send_to_local_scene/2,
		send_to_local_scene/3,
        send_to_local_scene/4,
		send_to_local_scene/5,
		send_question_answer/6,
        send_to_team/3,
		do_broadcast/2,
		do_broadcast_id/2,
		send_to_relation_online_all/4,
		send_to_relation_online_local/4,
		%do_broadcast_id1/4,
		send_to_uid1/4,
		send_to_guild_user/2,
		send_to_local_guild_user/2
       ]).

%%发送信息给指定socket玩家.
%%Socket:游戏Socket
%%Bin:二进制数据
send_one(Socket, Bin) ->
    gen_tcp:send(Socket, Bin).

%%发送信息给指定sid玩家.
%%Pid_send:游戏发送进程Pid_send
%%Bin:二进制数据.
send_to_sid(Pid_send, Bin) ->
	try
		case is_pid(Pid_send) of
			true ->
				Pid_send ! {send, Bin};
			_ ->
				skip
		end
	catch
		_:Reason ->
			?WARNING_MSG("send_to_sid is exception:~w,Reason:~w",[Pid_send, Reason]),
			?WARNING_MSG("get_stacktrace:~p",[erlang:get_stacktrace()]),
			ok
	end.
%% 	Pid =  misc:rand_to_process(Pid_send),
%%     Pid ! {send, Bin}.

%%发送信息给指定玩家名.
%%Nick:名称 
%%Bin:二进制数据.
send_to_nick(Nick, Bin) ->
   case lib_player:get_role_id_by_name(Nick) of
		null -> 
			no_player;
		PlayerId -> 
			send_to_uid(PlayerId, Bin)
   end.

%%发送信息给指定玩家ID.
%%PlayerId:玩家ID
%%Bin:二进制数据.
send_to_uid(PlayerId, Bin) ->
	PlayerProcessName = misc:player_process_name(PlayerId),
	case misc:whereis_name({global, PlayerProcessName}) of
		Pid when is_pid(Pid) ->
			gen_server:cast(Pid,{send_to_sid, Bin});
		_ -> 
			no_pid
	end.

%%发送信息到本地场景(本节点在线玩家)
%%Q:场景ID
%%Bin:数据
send_to_local_scene(Q, Bin) ->
   	MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == Q-> 
						 T#ets_users.other_data#user_other.pid_send
						end),
   	L = ets:select(?ETS_ONLINE, MS),	
   	do_broadcast(L, Bin). 
send_to_local_scene(Q, Bin, ExceptId) ->
   	MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == Q 
						 andalso T#ets_users.id =/= ExceptId-> 
						 T#ets_users.other_data#user_other.pid_send
						end),
   	L = ets:select(?ETS_ONLINE, MS),	
   	do_broadcast(L, Bin). 

%%发送信息到场景(9宫格区域，不是整个场景)  (本节点在线玩家)
%%Q:场景ID
%%X,Y坐标
%%Bin:数据
send_to_local_scene(Q, X2, Y2, Bin) ->
	send_to_local_scene(Q, X2, Y2, Bin, "").
send_to_local_scene(Q, X2, Y2, Bin, ExceptId) ->
   	MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == Q->
						[
						 T#ets_users.id,
						 T#ets_users.other_data#user_other.pid_send, 
						 T#ets_users.pos_x,
						 T#ets_users.pos_y]
						end),
   	AllUser = ets:select(?ETS_ONLINE, MS),
	Slice9 = lib_map:get_9_slice(X2, Y2),
	F = fun([Id, Sid, X, Y]) ->
				InSlice = lib_map:is_pos_in_slice(X, Y, Slice9),
				if
					InSlice == true andalso ExceptId =/= Id->
						send_to_sid(Sid, Bin);
					true ->
						ok
				end
		end,
    [F([Id, Sid, X, Y]) || [Id, Sid, X, Y] <- AllUser].

%%发送答题答案
send_question_answer(Q,Limit,Index,Res,_List,_List2) ->
	MS = ets:fun2ms(fun(T) when T#ets_users.current_map_id == Q-> 
						 [
						 T#ets_users.other_data#user_other.pid,
						 T#ets_users.other_data#user_other.pid_send,
						 T#ets_users.level,
						 T#ets_users.pos_x]
						end),
   	AllUser = ets:select(?ETS_ONLINE, MS),	
	F = fun([Pid,Pid_send,Level,X]) ->
			V = Level * Level,
			%?DEBUG("send_question_answer:~p",[{Level,X,Res}]),
			if
				X > Limit andalso Res =:= 2 ->
					NewList = [{?CURRENCY_TYPE_EXP,V bsl 1},{?CURRENCY_TYPE_BIND_COPPER,V}],
					NewRes = 1;
				X =< Limit andalso Res =:= 1 ->
					NewList = [{?CURRENCY_TYPE_EXP,V bsl 1},{?CURRENCY_TYPE_BIND_COPPER,V}],
					NewRes = 1;
				true ->
					NewList = [{?CURRENCY_TYPE_EXP,V},{?CURRENCY_TYPE_BIND_COPPER,V bsr 1}],
					NewRes = 0
			end,
			gen_server:cast(Pid,{add_duplicate_award,NewList}),
			[{_,V1},{_,V2}] = NewList,
			{ok, Bin} = pt_23:write(?PP_ACTIVE_QUESTION_AWARD,[Index,NewRes,V1,V2]),
			lib_send:send_to_sid(Pid_send, Bin)
		end,
	[F([Pid,Pid_send,Level,X]) || [Pid,Pid_send,Level,X] <- AllUser].		


%% 发送信息到组队
%% PlayerId 本用户消息发送进程
%% TeamPid 组队PID
%% Bin 数据
send_to_team(PlayerId, TeamPid, Bin) ->
	case misc:is_process_alive(TeamPid) of 
		true ->
			gen_server:cast(TeamPid, {send_to_member, Bin});
   		false ->
            send_to_uid(PlayerId, Bin)
    end.
    
%% 发送信息到世界
send_to_all(Bin) ->
	send_to_local_all(Bin),
    mod_node_interface:broadcast_to_world(ets:tab2list(?ETS_SERVER_NODE), Bin).

send_to_local_all(Bin) ->
	MS = ets:fun2ms(fun(T) -> 
					 T#ets_users.other_data#user_other.pid_send
					end),
	L = ets:select(?ETS_ONLINE, MS),
    do_broadcast(L, Bin).

%% 发送消息给帮会用户
send_to_guild_user(GuildID,Bin) ->
	send_to_local_guild_user(GuildID,Bin),
    mod_node_interface:broadcast_to_world_guild_user(ets:tab2list(?ETS_SERVER_NODE), GuildID, Bin).

send_to_local_guild_user(GuildID,Bin) ->
	MS = ets:fun2ms(fun(X) when X#ets_users.club_id =:= GuildID -> X#ets_users.other_data#user_other.pid_send end),
	L = ets:select(?ETS_ONLINE, MS),
    do_broadcast(L, Bin).
	

%% 发送玩家上下线
send_to_relation_online_all(UserId,NickName ,State, Bin) ->
	send_to_relation_online_local(UserId,NickName, State, Bin),
	mod_node_interface:broadcast_to_relation_online(ets:tab2list(?ETS_SERVER_NODE), UserId,NickName, State, Bin).
	
send_to_relation_online_local(UserId,NickName, State, Bin) ->
	MS = ets:fun2ms(fun(T) -> 
					 T#ets_users.other_data#user_other.pid
					end),
	L = ets:select(?ETS_ONLINE, MS),
    do_broadcast_relation_online(L, UserId, NickName, State, Bin).

do_broadcast_relation_online(L, UserId, NickName, State, Bin) ->
	[gen_server:cast(Pid,{relation_online,UserId, NickName, State, Bin}) || Pid <- L].

%%系统公告发送
%send_to_sysmsg() ->
%    .
%% 对列表中的所有socket进行广播
do_broadcast(L, Bin) ->
    [send_to_sid(Sid, Bin) || Sid <- L].
%% 对列表中的所有玩家id进行广播
do_broadcast_id(L, Bin) ->
	[send_to_uid(Sid, Bin) || Sid <- L].
%%  
%do_broadcast_id1(L, Bin,State,UserId) ->
%	[send_to_uid1(S#ets_users_friends.friend_id,Bin,State,UserId) || S <- L].



send_to_uid1(Sid,Bin,State,UserId) ->
	send_to_uid(Sid,Bin),
	[Nick, _Sex, _Level, _State] = db_agent_user:get_user_friend_info_by_UserId(UserId),
	if State =:= 1->
		   MSG = ?GET_TRAN(?_LANG_FRIEND_ONLINE,[Nick]),
		   lib_chat:chat_sysmsg([Sid,?EVENT,?None,?ORANGE,MSG]);
	   true ->
		   MSG = ?GET_TRAN(?_LANG_FRIEND_OFFLINE,[Nick]),
		   lib_chat:chat_sysmsg([Sid,?EVENT,?None,?ORANGE,MSG])
	end.