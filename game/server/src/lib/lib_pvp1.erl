%% Author: wangdahai
%% Created: 2013-4-18
%% Description: TODO: Add description to lib_pvp1
-module(lib_pvp1).
-include("common.hrl").


%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([pvp1_start_mach/1,pvp1_mach/2, join_active/2, quit_active/3, get_pvp1_award/1]).

-define(Active_Map_Id, 1000000).%活动对应地图编号，副本编号

%%
%% API Functions
%%
%% 报名参加活动
join_active(UserInfo,List) ->
	case is_record(UserInfo, pvp1_user_info) of
		true ->
			{ok, [UserInfo|List]};
		false ->
			{false}
	end.
%% 退出活动
quit_active(UserId,List1,List2) ->
	NewList1 = lists:keydelete(UserId, #pvp1_user_info.user_id, List1),
	NewList2 = lists:keydelete(UserId, #pvp1_user_info.user_id, List2),
	{ok, NewList1, NewList2}.

%%将报名的用户到时后移动到
pvp1_start_mach(List) ->
	New = misc_timer:now_seconds(),
	F = fun(Info,{List1,List2}) ->
			if
				Info#pvp1_user_info.join_time + 6 =< New ->
					{List1,[Info|List2]};
				true ->
					{[Info|List1],List2}
			end
		end,
	lists:foldl(F, {[],[]}, List).

pvp1_mach(List, N) ->
	if 
		length(List) >= 2 andalso N < 21 ->
			[Info|L] = List,
			NewList = pvp1_mach1(L,{Info,[],[],100}),
			pvp1_mach(NewList, N + 1);
		true ->
			List
	end. 

pvp1_mach1([],{I, List, T, _TLevel}) ->
	%%通知两人进入副本
	%?DEBUG("PVP1:~p",[{I,T}]),
	{ok, PVP_Dup_Pid} = mod_pvp_duplicate:start(?Active_Map_Id,?PVP1_ACTIVE_ID),%%副本Id需要配置
	gen_server:cast(I#pvp1_user_info.user_pid, {enter_pvp_duplicate,?PVP1_ACTIVE_ID, PVP_Dup_Pid,0}),%%用户自行发包进入
	gen_server:cast(T#pvp1_user_info.user_pid, {enter_pvp_duplicate,?PVP1_ACTIVE_ID, PVP_Dup_Pid,1}),	
	List;
pvp1_mach1([Info|L],{I, List, T, TLevel}) ->
	TL = abs(Info#pvp1_user_info.level - I#pvp1_user_info.level),
	if	
		TL =:= 0 andalso Info#pvp1_user_info.career =/= I#pvp1_user_info.career ->
			%?DEBUG("PVP1:~p",[{I,Info}]),
			{ok, PVP_Dup_Pid} = mod_pvp_duplicate:start(?Active_Map_Id,?PVP1_ACTIVE_ID),%%副本Id需要配置
			gen_server:cast(I#pvp1_user_info.user_pid, {enter_pvp_duplicate,?PVP1_ACTIVE_ID, PVP_Dup_Pid,0}),%%用户自行发包进入
			gen_server:cast(Info#pvp1_user_info.user_pid, {enter_pvp_duplicate,?PVP1_ACTIVE_ID, PVP_Dup_Pid,1}),	
			%%通知两人进入副本
			%%直接调用pvp地图创建方法。
			case T of
				[] ->
					L;
				_ ->
					L ++ [T|List]
			end;
		T =:= [] ->
			pvp1_mach1(L,{I, List, Info, TL});		
		TL < TLevel ->
			pvp1_mach1(L,{I, [T|List], Info, TL});
		TL =:= TLevel andalso Info#pvp1_user_info.career =/= I#pvp1_user_info.career ->
			pvp1_mach1(L,{I, [T|List], Info, TL});
		true ->
			pvp1_mach1(L,{I, [Info|List], T, TLevel})
	end.

get_pvp1_award(Result)->
	Rand = util:rand(0,2),
	Award = case Result of
		0 ->
			2;
		1 ->
			3;
		2 ->
			1;
		_ ->
			1
	end,
	if
		Rand =:= 0 ->
			[{?CURRENCY_TYPE_EXPLOIT,Award}];
		true ->
			[{?CURRENCY_TYPE_EXPLOIT,Award},{?CURRENCY_TYPE_EXPLOIT,Rand}]
	end.
%%
%% Local Functions
%%

