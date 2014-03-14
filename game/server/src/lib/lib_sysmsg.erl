%% Author: liaoxiaobo
%% Created: 2013-4-10
%% Description: TODO: Add description to lib_sysmsg
-module(lib_sysmsg).

-include("common.hrl").
-include("record.hrl").

%%
%% Exported Functions
%%
-export([
		 init_sys_msg/0,
		 timer_sys_msg/0,
		 update_sys_msg/8
		]).


-define(DIC_SYS_MSG, dic_sys_msg).

%%
%% API Functions
%%

init_sys_msg() ->
	F = fun(Info) ->
				R = list_to_tuple([ets_sys_msg] ++ Info),
				Other = #sys_msg_other{last_send_time = 0},
				R#ets_sys_msg{other_data = Other}
           end,
	 case db_agent_admin:get_sys_msg() of
        [] -> skip;
        List when is_list(List) ->
			put(?DIC_SYS_MSG, [F(X)|| X <- List]);
        _ -> skip
    end,
	
	
	ok.

get_sys_msg_dic() ->
	case get(?DIC_SYS_MSG) of 
		undefined ->
			[];
		List when is_list(List) ->
			List;
		_ ->
			[]
	end.

update_sys_msg_dic(List)->
	put(?DIC_SYS_MSG,List).

update_sys_msg(ID,OP,MsgType, SendType, StartTime, EndTime, Interval, Content) ->
	List = get_sys_msg_dic(),
	case OP of
		1 ->
			case lists:keyfind(ID, #ets_sys_msg.id, List) of
				false ->
					insert_sys_msg(ID,MsgType, SendType, StartTime, EndTime, Interval, Content);
				_ ->
					delete_sys_msg(ID,List),
					insert_sys_msg(ID,MsgType, SendType, StartTime, EndTime, Interval, Content)
			end;
		2 ->
			delete_sys_msg(ID,List)
	end.

insert_sys_msg(ID,MsgType, SendType, StartTime, EndTime, Interval, Content) ->
	Ret = db_agent_admin:insert_sys_msg(ID,MsgType, SendType, StartTime, EndTime, Interval, Content),
	case Ret of
		1 ->
			DBInfo = [ID,MsgType, SendType, StartTime, EndTime, Interval, Content,0,""],
			R = list_to_tuple([ets_sys_msg] ++ DBInfo),
			Other = #sys_msg_other{last_send_time = 0},
			NewR = R#ets_sys_msg{other_data = Other},
			List = get_sys_msg_dic(),
			update_sys_msg_dic([NewR|List]);
		_ ->
			skip
	end.

delete_sys_msg(ID,List) ->
	db_agent_admin:del_sys_msg(ID),
	NewList = lists:keydelete(ID, #ets_sys_msg.id, List),
	update_sys_msg_dic(NewList).

	
			

timer_sys_msg() ->
	List = get_sys_msg_dic(),
	Now = misc_timer:now_seconds(),
	NewList = sys_msg_list(List,Now,[]),
	update_sys_msg_dic(NewList),
	ok.

sys_msg_list([],Time,List) ->
	List;

sys_msg_list([H|T],Time,List) ->
	SendType = H#ets_sys_msg.send_type,
	case SendType of
		1 -> %% 立即消息
			if
				H#ets_sys_msg.other_data#sys_msg_other.last_send_time > 0 ->
					sys_msg_list(T,Time,[H|List]);
				true ->
					NewSysMsg = send_msg(H,Time),
					sys_msg_list(T,Time,[NewSysMsg|List])
			end;
		_ -> %% 时间间隔
			if
				(H#ets_sys_msg.end_time > Time andalso H#ets_sys_msg.start_time < Time) andalso 
					(H#ets_sys_msg.other_data#sys_msg_other.last_send_time =:=0 
					orelse H#ets_sys_msg.other_data#sys_msg_other.last_send_time + H#ets_sys_msg.interval =< Time ) ->
					
					NewSysMsg = send_msg(H,Time),
					sys_msg_list(T,Time,[NewSysMsg|List]);
				true ->
					sys_msg_list(T,Time,[H|List])
			end
	end.


%% 发送
send_msg(SysMsg,Time) ->
	ChatStr = SysMsg#ets_sys_msg.content,
	lib_chat:chat_sysmsg([ChatStr]),
	Other = SysMsg#ets_sys_msg.other_data#sys_msg_other{last_send_time = Time},
	SysMsg#ets_sys_msg{other_data = Other}.



%%
%% Local Functions
%%

