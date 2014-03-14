%% Author: 
%% Created: 2011-3-28
%% Description: TODO: buff
-module(lib_buff).

%%
%% Include files
%%
-include("common.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-define(BUFF_TIME_ADD,1	).			%1时间叠，
-define(BUFF_TIME_RELOAD,2).		%2时间重置
-define(BUFF_TIME_NO,3). 			%3不能叠
  
%%
%% Exported Functions
%%
-export([
		 init_template_buff/0,
		 get_buff_from_template/1,
		 get_user_buff/1,
		 timer_buff_list/7,
		 send_buff_update/8,
		 auto_add_hp_mp_buff/1,
		 timer_exp_buff_list/6,
%% 		 frozen_exp_buff/2,
%% 		 free_exp_buff/3,
		 init_users_buff/2,
		 is_having_buff/3,
		 add_buff/2,
		 add_buff_to_buff_list/3,
		 filter_exist_buff/1,
		 add_buff_new/3	,
		 send_player_info/4,
		 remove_buff/2
		 ]).

%%
%%效果统计 结构 [{attack,100},...]
%%

%%
%% API Functions
%%
%%初始化buff模板
init_template_buff() -> 
	F = fun(Buff) ->
		BuffInfo = list_to_tuple([ets_buff_template] ++ Buff),		
		BuffEffect = tool:split_string_to_intlist(BuffInfo#ets_buff_template.skill_effect_list),
		CantCreatebuffids = tool:split_string_to_intlist(BuffInfo#ets_buff_template.cant_createbuffids),
		ReplaceBuffids = tool:split_string_to_intlist(BuffInfo#ets_buff_template.replace_buffids),
		BuffInfo1 = BuffInfo#ets_buff_template{skill_effect_list=BuffEffect,
												cant_createbuffids = CantCreatebuffids,
												replace_buffids = ReplaceBuffids},
  		ets:insert(?ETS_BUFF_TEMPLATE, BuffInfo1)
	end,
	L = db_agent_template:get_buff_template(),
	lists:foreach(F, L),
	ok.

%%初始化人物buff
init_users_buff(Users_Buffers, Time) ->
	F =	
		fun(Info, Now) -> 
				{Info#ets_users_buffs{begin_date = Now, valid_date = Now}, Now}
		end,
	{NewList, _} = lists:mapfoldl(F, Time, Users_Buffers),
	NewList.


%从template中找某个buff
get_buff_from_template(BuffID) ->
	data_agent:get_buff_from_template(BuffID).

%取人物buff(普通，血包，经验)
get_user_buff(UserID) ->
	TotalBuff = db_agent_buff:get_user_all_buff(UserID),
	[Buffs] = lists:foldl(fun get_user_buff2/2,[[]], TotalBuff),
	[_, Blood_Buff] = lists:foldl(fun get_user_buff1/2,[?BUFFBLOOD, []], TotalBuff),
	[_, Magic_Buff] = lists:foldl(fun get_user_buff1/2,[?BUFFMAGIC, []], TotalBuff),
	[_, Exp_Buff] = lists:foldl(fun get_user_buff1/2,[?BUFFEXP, []], TotalBuff),
	{Buffs, Blood_Buff, Magic_Buff, Exp_Buff}.

get_user_buff1(Info, [Type, L]) ->
	Record = list_to_tuple([ets_users_buffs] ++ Info),
	Other = #r_other_buff{is_new = 0},
	NewRecord = Record#ets_users_buffs{other_data = Other},
	if
		NewRecord#ets_users_buffs.type =:= Type ->

			[Type, [NewRecord|L]];
		true ->
			[Type, L]
	end.

get_user_buff2(Info, [L]) ->
	Record = list_to_tuple([ets_users_buffs] ++ Info),
	Other = #r_other_buff{is_new = 0},
	NewRecord = Record#ets_users_buffs{other_data = Other},
	if
		NewRecord#ets_users_buffs.type >= ?BUFFNORMAL ->

			[[NewRecord|L]];
		true ->
			[L]
	end.

%%判断是否已经有该buff
is_having_buff(BuffId, AddBuff, PlayerStatus) ->
	BuffList = PlayerStatus#ets_users.other_data#user_other.buff_list,
	Return = case BuffId of
		0 ->
			true;
		_ ->			
			case lists:keyfind(BuffId, #ets_users_buffs.template_id, BuffList) of
				false ->
					false;
				Buff when Buff#ets_users_buffs.is_exist =:= 1 ->
					true;
				_ ->
					false
			end
	end,
	if
		Return =:= true ->
			case lists:keyfind(AddBuff, #ets_users_buffs.template_id, BuffList) of
				false ->
					true;
				Buff1 when Buff1#ets_users_buffs.is_exist =:= 1 ->
					false;
				_ ->
					true
			end;
		true ->
			false
	end.
	

%%添加玩家Buff
add_buff(BuffId, PlayerStatus) ->
	case get_buff_from_template(BuffId) of
		BuffTemp when is_record(BuffTemp,ets_buff_template) ->
			BuffType = BuffTemp#ets_buff_template.type,
			case BuffType of
				?BUFFBLOOD ->  	%%血包Buff
					{BloodBuff, UpdateBuff} = add_hp_mp_buff(PlayerStatus#ets_users.id, 
																		 PlayerStatus#ets_users.other_data#user_other.blood_buff,
																		 BuffTemp, ?BUFFBLOOD),
					OtherData = PlayerStatus#ets_users.other_data#user_other{blood_buff = BloodBuff};
				?BUFFMAGIC ->	%%魔法Buff	
					{MagicBuff, UpdateBuff} = add_hp_mp_buff(PlayerStatus#ets_users.id, 
																		 PlayerStatus#ets_users.other_data#user_other.magic_buff,
																		 BuffTemp, ?BUFFMAGIC),
					OtherData = PlayerStatus#ets_users.other_data#user_other{magic_buff = MagicBuff};
				?BUFFEXP ->		%%多倍经验
					{NewExpBuff, UpdateBuff,  NewExpRate} = add_exp_buff(PlayerStatus#ets_users.other_data#user_other.exp_buff, 
																					BuffId, 1, PlayerStatus#ets_users.id),
					OtherData = PlayerStatus#ets_users.other_data#user_other{exp_buff = NewExpBuff, exp_rate = NewExpRate};
				_ ->
					{BL,UpdateBuff,RemoveBuffList} = add_buff_new(PlayerStatus#ets_users.id, [BuffTemp],
											 PlayerStatus#ets_users.other_data#user_other.buff_list),
 					%?DEBUG("~w~n~w~n~w",[BL,UpdateBuff,RemoveBuffList]),
					%?DEBUG("old:~w ~n rm:~w",[PlayerStatus#ets_users.other_data#user_other.remove_buff_list, RemoveBuffList]),
					OtherData = PlayerStatus#ets_users.other_data#user_other{remove_buff_list = RemoveBuffList  ,buff_list = BL}
			end,	
			
			NewPlayerStatus = PlayerStatus#ets_users{other_data = OtherData},
			if BuffType =< 3 ->
				   {ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[UpdateBuff,?ELEMENT_PLAYER,NewPlayerStatus#ets_users.id,1,
															   NewPlayerStatus#ets_users.other_data#user_other.buff_temp_info]),
				   lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BuffBin);
			   true ->
					send_buff_update(?ELEMENT_PLAYER, 
									 NewPlayerStatus#ets_users.id,
									 UpdateBuff,
									 1, 
									 NewPlayerStatus#ets_users.current_map_id,
									 NewPlayerStatus#ets_users.pos_x,
									 NewPlayerStatus#ets_users.pos_y,
									 NewPlayerStatus#ets_users.other_data#user_other.buff_temp_info)
%% 					if 
%% 					   length(RemoveBuff) > 0 ->
%% 							{ok,BuffBin2} = pt_20:write(?PP_BUFF_UPDATE,[RemoveBuff,?ELEMENT_PLAYER,NewPlayerStatus#ets_users.id,0,
%% 																		NewPlayerStatus#ets_users.other_data#user_other.buff_temp_info]),
%% 							lib_send:send_to_sid(NewPlayerStatus#ets_users.other_data#user_other.pid_send, BuffBin2);
%% 						true ->
%% 							skip
%% 					end
			end,
			NewPlayerStatus;
		_ ->
			?DEBUG("add_buff error buffid is not exit:~p",[BuffId]),
			PlayerStatus
	end.

%% 添加血包Buff,添加魔法包Buff
%% 如果存在替换,同一编号的时间叠加
add_hp_mp_buff(UserID, OldBuff, NewBuffTemplate, Type) ->
	OldBuffInfo = is_have_buff(0, OldBuff),
	TempBuff1 = lists:delete(OldBuffInfo, OldBuff),
	if
		OldBuffInfo =:= [] orelse OldBuffInfo#ets_users_buffs.template_id =/= NewBuffTemplate#ets_buff_template.buff_id ->
			if
				OldBuffInfo =:= [] -> 
					RemoveBuff = [],
					TempBuff = TempBuff1;								  
				true -> 
					RemoveBuff = [OldBuffInfo#ets_users_buffs{is_exist = 0}],
					OldOther = #r_other_buff{is_alter = 1},
					NewOldBUffInfo = OldBuffInfo#ets_users_buffs{other_data = OldOther, is_exist = 0},
					TempBuff = [NewOldBUffInfo|TempBuff1]
			end,
			Begin = 0,
			End = NewBuffTemplate#ets_buff_template.active_totaltime,
			Total_Value = End,
			case lists:keyfind(NewBuffTemplate#ets_buff_template.buff_id, #ets_users_buffs.template_id, TempBuff) of
				false ->
					TempBuff2 = TempBuff,
					Other = #r_other_buff{is_new = 1, is_alter = 1};
				OldInfo ->
					TempBuff2 = lists:keydelete(NewBuffTemplate#ets_buff_template.buff_id, #ets_users_buffs.template_id, TempBuff),
					Other = #r_other_buff{is_new =  OldInfo#ets_users_buffs.other_data#r_other_buff.is_new, is_alter = 1}
				end,
			BuffInfo = [UserID, NewBuffTemplate#ets_buff_template.buff_id, Begin, 0, End, Type, Total_Value, 1, Other],
			NewBuff = list_to_tuple([ets_users_buffs|BuffInfo]), 
			{[NewBuff|TempBuff2], [NewBuff|RemoveBuff] };
		true ->
			End = OldBuffInfo#ets_users_buffs.end_date,
			Other = OldBuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
			
			if 
				OldBuffInfo#ets_users_buffs.total_value > End + NewBuffTemplate#ets_buff_template.active_totaltime ->
					TotalValue = OldBuffInfo#ets_users_buffs.total_value;
				true ->
					TotalValue = OldBuffInfo#ets_users_buffs.total_value + NewBuffTemplate#ets_buff_template.active_totaltime
			end,
			
			NewBuff = OldBuffInfo#ets_users_buffs{end_date = erlang:min(End + NewBuffTemplate#ets_buff_template.active_totaltime,20000000),
												  total_value = erlang:min(TotalValue, 20000000),
												  other_data = Other},
		
			{[NewBuff|TempBuff1], [NewBuff]}
	end.



%% 调整后的添加buff方法
add_buff_new(UserID, AddBuffList, OwnBuffList) ->
	add_buff1(UserID, AddBuffList, OwnBuffList, [],[]).

add_buff1(_UserID, [], OwnBuffList, ChangeBuffList,RemoveBuffList) -> {OwnBuffList, ChangeBuffList,RemoveBuffList};
add_buff1(UserID, [AddBuff|T], OwnBuffList, ChangeBuffList,RemoveBuffList) ->
	%% 1 检查是不是已经中了该buff了
	case lists:keyfind(AddBuff#ets_buff_template.buff_id, #ets_users_buffs.template_id, OwnBuffList) of
		false ->	%% 2b没中过，检查会不会中
			case add_buff2(UserID, AddBuff, OwnBuffList) of
				false -> %% 检查后不能添加
					add_buff1(UserID, T, OwnBuffList, ChangeBuffList,RemoveBuffList);
				{NewOwnBuffList,NewChangeBuffList,RemoveBuffList1} ->
					add_buff1(UserID, T, NewOwnBuffList, NewChangeBuffList,RemoveBuffList1++RemoveBuffList)
			end;
		OldAddBuff1 when OldAddBuff1#ets_users_buffs.is_exist =:= 0 -> %% 2a中过，已经过期了，有数据，检查会不会中
			case add_buff2(UserID, AddBuff, OwnBuffList) of
				false -> %% 检查后不能添加
					add_buff1(UserID, T, OwnBuffList, ChangeBuffList,RemoveBuffList);
				{NewOwnBuffList,NewChangeBuffList,RemoveBuffList1} ->
					add_buff1(UserID, T, NewOwnBuffList, NewChangeBuffList,RemoveBuffList1++RemoveBuffList)
			end;
		OldAddBuff2 ->	%% 3已经中过，检查覆盖情况
			{NewOwnBuffList,NewChangeBuffList,RemoveBuffList1} = add_buff3(AddBuff, OldAddBuff2, OwnBuffList, ChangeBuffList),
			add_buff1(UserID, T, NewOwnBuffList, NewChangeBuffList,RemoveBuffList1++RemoveBuffList)
	end.

%% 检查新增buff
add_buff2(UserID, AddBuff, OwnBuffList) ->
	Cant = AddBuff#ets_buff_template.cant_createbuffids,
	if length(Cant) > 0 ->
		   %% 检查是否不能出现
		   case add_buff2_a(Cant, OwnBuffList, true) of
			   true ->
				   %% 检查是否有替换
				   add_buff2_b(UserID, AddBuff, OwnBuffList);
			   _ ->
				   false	%% 此buff不能出现
		   end;
	   true ->
		   %% 检查是否有替换
		   add_buff2_b(UserID, AddBuff, OwnBuffList)
	end.


add_buff2_a([],_OwnBuffList,Check) -> Check;
add_buff2_a([{CantCreate}|T], OwnBuffList, Check) ->
	case lists:keyfind(CantCreate, #ets_users_buffs.template_id, OwnBuffList) of
		false ->
			add_buff2_a(T, OwnBuffList, Check);
		CantBuffInfo when CantBuffInfo#ets_users_buffs.is_exist =:= 0 ->
			add_buff2_a(T, OwnBuffList, Check);
		_ ->
			false
	end.

%% 检查是否有替换buff
add_buff2_b(UserID, AddBuff, OwnBuffList) ->
	Reap =AddBuff#ets_buff_template.replace_buffids,
	case length(Reap) > 0 of
		true ->
			{TmpAddList, TmpChangeList} = add_buff2_c(Reap, OwnBuffList, []);
		_ ->
			TmpAddList = OwnBuffList,
			TmpChangeList = []
	end,
	TemplateID = AddBuff#ets_buff_template.buff_id,		
	Time = misc_timer:now_milseconds(),
	
	case lists:keyfind(TemplateID, #ets_users_buffs.template_id, OwnBuffList) of
		false ->
			Other = #r_other_buff{is_new = 1, is_alter = 1};
		OldInfo ->
			Other = #r_other_buff{is_new = OldInfo#ets_users_buffs.other_data#r_other_buff.is_new, is_alter = 1}
	end,
	BuffInfo = [UserID, TemplateID, Time, Time, Time + AddBuff#ets_buff_template.active_totaltime, AddBuff#ets_buff_template.type, 
						0, 1, Other],
	AddBuffFinal = list_to_tuple([ets_users_buffs|BuffInfo]), 
	
	AddBuffFinal = #ets_users_buffs{
								   user_id = UserID,
								   template_id = TemplateID,
								   begin_date = Time,
								   valid_date = Time,
								   end_date = Time + AddBuff#ets_buff_template.active_totaltime,
								   type = AddBuff#ets_buff_template.type,
								   total_value = 0,
								   is_exist = 1,
								   other_data = Other
								   },
	add_buff_final(AddBuffFinal,TmpAddList,TmpChangeList).	%%写入

add_buff2_c([], OwnBuffList, ChangeBuffList) -> {OwnBuffList, ChangeBuffList};
add_buff2_c([{Replace}|T], OwnBuffList, ChangeBuffList) ->
	case lists:keyfind(Replace,#ets_users_buffs.template_id,OwnBuffList) of
		false ->
			add_buff2_c(T, OwnBuffList, ChangeBuffList);
		ReplaceInfo when ReplaceInfo#ets_users_buffs.is_exist =:= 1 ->
 			OtherData = ReplaceInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
			NewReplaceInfo = ReplaceInfo#ets_users_buffs{other_data = OtherData, is_exist = 0},
 			TmpChangeBuffList = [NewReplaceInfo|ChangeBuffList],
			TmpOwnBuffList = lists:keyreplace(Replace, #ets_users_buffs.template_id, OwnBuffList, NewReplaceInfo),
			add_buff2_c(T, TmpOwnBuffList, TmpChangeBuffList);
		_ ->
			add_buff2_c(T, OwnBuffList, ChangeBuffList)
	end.

add_buff3(AddBuff, OldBuff, OwnBuffList, ChangeBuffList) ->
	NewEnd = case AddBuff#ets_buff_template.merge_type of
				 ?BUFF_TIME_ADD ->
					 OldBuff#ets_users_buffs.end_date + AddBuff#ets_buff_template.active_totaltime;
				 ?BUFF_TIME_RELOAD ->
					 misc_timer:now_milseconds()+AddBuff#ets_buff_template.active_totaltime;
				 _ ->
					 OldBuff#ets_users_buffs.end_date
			 end,
	OtherData = OldBuff#ets_users_buffs.other_data#r_other_buff{is_alter = 1,
																need_notice = 1},
	NewBuffInfo = OldBuff#ets_users_buffs{end_date = NewEnd, other_data = OtherData},
	add_buff_final1(NewBuffInfo, OwnBuffList, ChangeBuffList).
	
add_buff_final(BuffInfo, OwnBuffList, ChangeBuffList) ->
	TmpOwnBuffList = lists:keydelete(BuffInfo#ets_users_buffs.template_id, #ets_users_buffs.template_id, OwnBuffList),
	FinalOwnBuffList = [BuffInfo|TmpOwnBuffList],
	FinalChangeBuffList = [BuffInfo|ChangeBuffList],
	{FinalOwnBuffList,FinalChangeBuffList,ChangeBuffList}.

add_buff_final1(BuffInfo, OwnBuffList, ChangeBuffList) ->
	TmpOwnBuffList = lists:keydelete(BuffInfo#ets_users_buffs.template_id, #ets_users_buffs.template_id, OwnBuffList),
	FinalOwnBuffList = [BuffInfo|TmpOwnBuffList],
	FinalChangeBuffList = [BuffInfo|ChangeBuffList],
	{FinalOwnBuffList,FinalChangeBuffList,[]}.


%% 添加buff进入buff列表，在这里判断覆盖等内容
%% 同一个编号进行合并
add_buff_to_buff_list(UserID, ChangeBuffList,BuffList) ->
	Now = misc_timer:now_milseconds(),
	add_buff_to_buff_list0(UserID, ChangeBuffList,BuffList,[],[],Now).
	
add_buff_to_buff_list0(_UserID, [],BuffList,NewBuffList,RemoveBuffList,_Now) -> {BuffList,NewBuffList,RemoveBuffList};
add_buff_to_buff_list0(UserID, [BuffInfo|T],BuffList,NewBuffList,RemoveBuffList,Now) ->
	case lists:keyfind(BuffInfo#ets_buff_template.buff_id, #ets_users_buffs.template_id, BuffList) of
		false ->
			case add_buff_to_buff_list1(BuffInfo,BuffList) of
				false -> %不能添加
					 NBL = BuffList,
					 NNBL = NewBuffList,
					 NRBL = RemoveBuffList;
				{NBuffList,NRemoveBL} ->
					TemplateID = BuffInfo#ets_buff_template.buff_id,					
					Other = #r_other_buff{ is_new = 1},
					TempNBI = [UserID, TemplateID, Now, Now, 
								   Now+BuffInfo#ets_buff_template.active_totaltime,  BuffInfo#ets_buff_template.type, 0, 1, Other],
					NBI = list_to_tuple([ets_users_buffs|TempNBI]),
					NBL = [NBI|NBuffList],
					NNBL = [NBI|NewBuffList],
					NRBL = NRemoveBL ++ RemoveBuffList
			end;
		OldBuffInfo -> 
			{NBL,NNBL} = add_buff_to_buff_list3(BuffInfo,OldBuffInfo,BuffList,NewBuffList,Now),
			NRBL = RemoveBuffList
	end,
	add_buff_to_buff_list0(UserID, T,NBL,NNBL,NRBL,Now).


	
	

%判断是否有排斥buff等,返回处理完的buff列表，未将buffinfo加入
add_buff_to_buff_list1(BuffInfo,BuffList) ->
	Cant =  BuffInfo#ets_buff_template.cant_createbuffids,
	case length(Cant) > 0 of
		true ->
			case add_buff_to_buff_list1_a(Cant,BuffList,true) of
				true ->
					%判断是否有替换
					add_buff_to_buff_list2(BuffInfo,BuffList);
				_ ->
				  	false %此buff不能出现
			end;
		_ ->
			%判断是否有替换
			add_buff_to_buff_list2(BuffInfo,BuffList)
	end.

% 返回false表示不能出现
add_buff_to_buff_list1_a([], _BuffList, Check) -> Check;
add_buff_to_buff_list1_a([H|T], BuffList, Check) ->
	case H of 
		{CantCreate} ->
			case lists:keymember(CantCreate,#ets_users_buffs.template_id,BuffList) of
				false ->
					add_buff_to_buff_list1_a(T,BuffList,Check);
				_ ->
					false
			end;
		_ ->
			add_buff_to_buff_list1_a(T,BuffList,Check)
	end.



% 判断是否有替换 
add_buff_to_buff_list2(BuffInfo,BuffList) ->
	Reap =  BuffInfo#ets_buff_template.replace_buffids,
	case length(Reap) > 0 of
		true ->
			add_buff_to_buff_list2_a(Reap,BuffList,[]);
		_ ->
			{BuffList,[]}
	end.

add_buff_to_buff_list2_a([], BuffList, RemoveBuffList) -> {BuffList,RemoveBuffList};
add_buff_to_buff_list2_a([H|T], BuffList, RemoveBuffList) ->
	case H of 
		{Replace} ->
			case lists:keyfind(Replace,#ets_users_buffs.template_id,BuffList) of
				false ->
					NBL = BuffList,
					NRBL = RemoveBuffList;
				ReplaceInfo ->%移掉

					NBL = lists:keydelete(Replace,#ets_users_buffs.template_id,BuffList),
					OtherData = ReplaceInfo#ets_users_buffs.other_data#r_other_buff{is_new = 0,is_alter = 1},
					NRBL = [ReplaceInfo#ets_users_buffs{other_data = OtherData, is_exist = 0}|RemoveBuffList]
			end,
			add_buff_to_buff_list2_a(T,NBL,NRBL);
		_ ->
			add_buff_to_buff_list2_a(T, BuffList, RemoveBuffList)
	end.

%加入 判断合并类型
add_buff_to_buff_list3(BuffInfo, OldBuffInfo, BuffList, NewBuffList,Now) ->
	case BuffInfo#ets_buff_template.merge_type of
		?BUFF_TIME_ADD ->
			if 
				OldBuffInfo#ets_users_buffs.is_exist =:= 1 ->
				   NewEnd = OldBuffInfo#ets_users_buffs.end_date + BuffInfo#ets_buff_template.active_totaltime,
			   	   NewBuffInfo = OldBuffInfo#ets_users_buffs{end_date = NewEnd};
			   true ->
				   NewEnd = Now+BuffInfo#ets_buff_template.active_totaltime,
				   NewBuffInfo = OldBuffInfo#ets_users_buffs{end_date = NewEnd, is_exist = 1,
															 begin_date = Now, valid_date = Now}
			end;
		?BUFF_TIME_RELOAD ->
			NewEnd = Now+BuffInfo#ets_buff_template.active_totaltime,
			NewBuffInfo = OldBuffInfo#ets_users_buffs{end_date = NewEnd, is_exist = 1};
		_ ->
			NewBuffInfo = OldBuffInfo
	end,
	{lists:keyreplace(OldBuffInfo#ets_users_buffs.begin_date, #ets_users_buffs.begin_date, BuffList,NewBuffInfo),[NewBuffInfo|NewBuffList]}.

remove_buff_effect([],_Type,Aer) -> Aer;
remove_buff_effect([H|T],Type,Aer) ->
	Effect = H#ets_users_buffs.other_data#r_other_buff.effect_list,
	case Type of
		?ELEMENT_PLAYER ->
			{NewAer} = cale_active_effect_remove_loop(Effect,Aer);	
		_ ->
			{NewAer} = cale_active_effect_remove_loop_monster(Effect,Aer)
	end,
	
	remove_buff_effect(T,Type,NewAer).

%定时处理buff信息
timer_buff_list([],Type,_Time,HaveL,RemoveL,Aer,NeedSaveEts) ->
	case Type of
		?ELEMENT_PLAYER ->
			NewRemoveList = Aer#ets_users.other_data#user_other.remove_buff_list ,
			%% 处理移除数据
			NewAer1 = remove_buff_effect(NewRemoveList,Type,Aer), 
			Other = NewAer1#ets_users.other_data#user_other{ buff_list = HaveL, remove_buff_list = []},
			NewAer = NewAer1#ets_users{other_data = Other};
		_ ->
			
			NewAer = Aer#r_mon_info{buff_list = HaveL}
	end,
	{RemoveL,NewAer,NeedSaveEts};

timer_buff_list([H|T],Type,Time,HaveL,RemoveL,Aer,NeedSaveEts) ->
	BuffID = H#ets_users_buffs.template_id,
	Begin = H#ets_users_buffs.begin_date,
	ValidDate = H#ets_users_buffs.valid_date,
	End = H#ets_users_buffs.end_date,
	Effect = H#ets_users_buffs.other_data#r_other_buff.effect_list,

	BuffInfo = get_buff_from_template(BuffID),
	if H#ets_users_buffs.is_exist =:= 1 ->
		case Time > End of
			true ->	%结束
				case Type of
					?ELEMENT_PLAYER ->
						{NewAer} = cale_active_effect_remove_loop(Effect,Aer);
					_ ->
						{NewAer} = cale_active_effect_remove_loop_monster(Effect,Aer)
				end,
				Other = H#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
				NH = H#ets_users_buffs{other_data = Other, is_exist = 0},
				NRemoveL = [NH|RemoveL],
				NHaveL = [NH|HaveL],
				NewNeedSaveEts = 1;
			_ ->
				case BuffInfo#ets_buff_template.active_timespan =:= BuffInfo#ets_buff_template.active_totaltime of
					true ->	%只起效一次
						case Begin =:= ValidDate of
							true ->
								case Type of
									?ELEMENT_PLAYER ->
										{NewAer,NewEffect} = cale_active_effect_loop(BuffInfo#ets_buff_template.skill_effect_list,Aer,Effect);
									_ ->
										{NewAer,NewEffect} = cale_active_effect_loop_monster(BuffInfo#ets_buff_template.skill_effect_list,Aer,Effect)
								end,
								LastValidDate = Time + BuffInfo#ets_buff_template.active_timespan,
								NewNeedSaveEts = 1,
								Other = H#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
								Other1 = Other#r_other_buff{effect_list = NewEffect},
								NewH = H#ets_users_buffs{
												 valid_date = LastValidDate,
												 other_data = Other1},
								NHaveL = [NewH|HaveL];
							_ ->
								NewAer = Aer,
								NewNeedSaveEts = NeedSaveEts,
								NHaveL = [H|HaveL]
						end,
						NRemoveL = RemoveL;
%% 						NRemoveL = RemoveL,
%% 						Other1 = Other#r_other_buff{effect_list = NewEffect},
%% 						NewH = H#ets_users_buffs{
%% 												 valid_date = LastValidDate,
%% 												 other_data = Other1},
%% 						?DEBUG("~w",[NewH]),
%% 						NHaveL = [NewH|HaveL];
					_ ->	%可起效多次
						case Time > ValidDate + BuffInfo#ets_buff_template.active_timespan of 
							true -> 
								case Type of
									?ELEMENT_PLAYER ->
										{NewAer,NewEffect} = cale_active_effect_loop(BuffInfo#ets_buff_template.skill_effect_list,Aer,Effect);
									_ ->
										{NewAer,NewEffect} = cale_active_effect_loop_monster(BuffInfo#ets_buff_template.skill_effect_list,Aer,Effect)
								end,
								LastValidDate = Time,
								NewNeedSaveEts = 1,
								Other = H#ets_users_buffs.other_data#r_other_buff{is_alter = 1};
							_ ->
								Other = H#ets_users_buffs.other_data,
								NewAer = Aer,
								NewEffect = Effect,
								LastValidDate = ValidDate,
								NewNeedSaveEts = NeedSaveEts
						end,
						NRemoveL = RemoveL,
						Other1 = Other#r_other_buff{effect_list = NewEffect},
						NewH = H#ets_users_buffs{
												 valid_date = LastValidDate,
												 other_data = Other1},
						NHaveL = [NewH|HaveL]
				end
		end;
	   true ->
		   NHaveL = [H|HaveL],
		   NewAer = Aer,
		   NRemoveL = RemoveL,
		   NewNeedSaveEts = NeedSaveEts
	end,
	timer_buff_list(T,Type,Time,NHaveL,NRemoveL,NewAer,NewNeedSaveEts).


%% 退出副本时副本BUFF移除
%% return : NewAer
remove_buff(Aer,Type) ->
	F = fun(Info,{List,Time}) ->
		BuffID = Info#ets_users_buffs.template_id,
		End = Info#ets_users_buffs.end_date,
		BuffInfo = get_buff_from_template(BuffID),
		if 
			Info#ets_users_buffs.is_exist =:= 1 
			  andalso End > Time
			  andalso BuffInfo#ets_buff_template.rem_buff_type band Type >= 1 ->
				NewBuff = Info#ets_users_buffs{ end_date = Time },
				{[ NewBuff|List ],Time};
			true ->
				{[ Info|List ],Time}
		end
	end,
	Time = misc_timer:now_milseconds(),
%% 	case Type of
%% 		1 ->
			{NewBuffList,_} = lists:foldl(F, {[],Time}, Aer#ets_users.other_data#user_other.buff_list),
			Other =  Aer#ets_users.other_data#user_other{ buff_list = NewBuffList },
			Aer#ets_users{other_data = Other}.
%% 		_ ->
%% 			Aer
%% 	end.

	




%组织buff更新协议包并发送
send_buff_update(Type,ID,ChangeBuffs,UpdateType,MapID,X,Y, Change_Info) ->
	{ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[ChangeBuffs,Type,ID,UpdateType,Change_Info]),
%% 	lib_send:send_to_local_scene(MapID,X,Y,BuffBin).
	mod_map_agent:send_to_area_scene(MapID,X,Y,BuffBin).



%%过滤不存在的BUFF
filter_exist_buff(TotalBuff) ->
	F = fun(Info, ExistBuff) ->
				if
					Info#ets_users_buffs.is_exist =:= 1 ->
						[Info|ExistBuff];
					true ->
						ExistBuff
				end
		end,
	lists:foldl(F, [], TotalBuff).
					  

%%血包添加血量，魔法包添加魔法
auto_add_hp_mp_buff(PlayerStatus) ->
    BloodInfo = is_have_buff(0, PlayerStatus#ets_users.other_data#user_other.blood_buff),
	MagicInfo = is_have_buff(0, PlayerStatus#ets_users.other_data#user_other.magic_buff),
	TempBloodBuff = lists:delete(BloodInfo, PlayerStatus#ets_users.other_data#user_other.blood_buff),
	TempMagicBuff = lists:delete(MagicInfo, PlayerStatus#ets_users.other_data#user_other.magic_buff),
	Now = misc_timer:now_milseconds(),
	if
		PlayerStatus#ets_users.current_hp < (PlayerStatus#ets_users.other_data#user_other.total_hp + PlayerStatus#ets_users.other_data#user_other.tmp_totalhp) 
		  andalso BloodInfo =/= [] ->
			{AddBlood, NewPlayerStatus1} = auto_add_hp_buff(PlayerStatus, BloodInfo, Now, TempBloodBuff);
		true ->
			AddBlood = 0,
			NewPlayerStatus1 = PlayerStatus
	end,
	if
		NewPlayerStatus1#ets_users.current_mp < (NewPlayerStatus1#ets_users.other_data#user_other.total_mp + NewPlayerStatus1#ets_users.other_data#user_other.tmp_totalmp) 
		  andalso MagicInfo =/=[] ->
			{AddMagic, NewPlayerStatus2} = auto_add_mp_buff(NewPlayerStatus1, MagicInfo, Now, TempMagicBuff);
		true ->
			AddMagic = 0,
			NewPlayerStatus2 = NewPlayerStatus1
	end,
	{AddBlood, AddMagic, NewPlayerStatus2}.
			   
%%血包加血
auto_add_hp_buff(PlayerStatus, BloodInfo, Now, TempBuff) ->
	CurrentHp = PlayerStatus#ets_users.current_hp,
	TotalHp = PlayerStatus#ets_users.other_data#user_other.total_hp + PlayerStatus#ets_users.other_data#user_other.tmp_totalhp,
	BuffLeftBlood = BloodInfo#ets_users_buffs.end_date,
	BuffTemplateInfo = get_buff_from_template(BloodInfo#ets_users_buffs.template_id),
	if
		Now - BloodInfo#ets_users_buffs.begin_date >= BuffTemplateInfo#ets_buff_template.active_timespan ->
			PlayerLeftBlood = TotalHp - CurrentHp,
			TemplateBlood = BuffTemplateInfo#ets_buff_template.active_percent,
			AddBlood = erlang:min(PlayerLeftBlood, erlang:min(TemplateBlood, BuffLeftBlood)),
			NewBuffInfo = check_hp_mp_buff(PlayerStatus#ets_users.other_data#user_other.pid_send, 
										   PlayerStatus#ets_users.id, BloodInfo, AddBlood, Now,
										   PlayerStatus#ets_users.other_data#user_other.buff_temp_info),
			NewOther = PlayerStatus#ets_users.other_data#user_other{blood_buff = [NewBuffInfo|TempBuff]},
			NewPlayerStatus = PlayerStatus#ets_users{
													 other_data = NewOther
													},
			{AddBlood, NewPlayerStatus};
	true ->
		{0, PlayerStatus}
	end.

%%魔法加魔
auto_add_mp_buff(PlayerStatus, MagicInfo, Now, TempBuff) ->
	CurrentMp = PlayerStatus#ets_users.current_mp,
	TotalMp = PlayerStatus#ets_users.other_data#user_other.total_mp + PlayerStatus#ets_users.other_data#user_other.tmp_totalmp,
	BuffLeftMaigc = MagicInfo#ets_users_buffs.end_date,
	BuffTemplateInfo = get_buff_from_template(MagicInfo#ets_users_buffs.template_id),
	if
		Now - MagicInfo#ets_users_buffs.begin_date >= BuffTemplateInfo#ets_buff_template.active_timespan ->
			PlayerLeftMagic = TotalMp - CurrentMp,
			TemplateBlood = BuffTemplateInfo#ets_buff_template.active_percent,
			AddMagic = erlang:min(PlayerLeftMagic, erlang:min(TemplateBlood, BuffLeftMaigc)),
			NewBuffInfo = check_hp_mp_buff(PlayerStatus#ets_users.other_data#user_other.pid_send, 
										   PlayerStatus#ets_users.id, MagicInfo, AddMagic, Now,
										   PlayerStatus#ets_users.other_data#user_other.buff_temp_info),
			NewOther = PlayerStatus#ets_users.other_data#user_other{magic_buff = [NewBuffInfo|TempBuff]},
			NewPlayerStatus = PlayerStatus#ets_users{other_data = NewOther},
			{AddMagic, NewPlayerStatus};
	true ->
		{0, PlayerStatus}
	end.

	
%%经验buff时间处理
timer_exp_buff_list(Pid_send, UserId, ExpBuff, ExpRate, NowTime, BuffChangeInfo) ->
	BuffInfo = is_have_buff(0, ExpBuff),
	NewExpBuff = lists:delete(BuffInfo, ExpBuff),
	if 
		BuffInfo =:= [] orelse BuffInfo#ets_users_buffs.is_exist =:= 0  
		  orelse BuffInfo#ets_users_buffs.valid_date =/= 0 ->
			{ExpBuff, ExpRate, 0};
		true ->
			BuffID = BuffInfo#ets_users_buffs.template_id,
			Other = BuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
			End = BuffInfo#ets_users_buffs.end_date,
			case NowTime > End of
				true ->	
 					BuffInfo1= BuffInfo#ets_users_buffs{is_exist = 0, other_data = Other},
					{ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[[BuffInfo1],?ELEMENT_PLAYER,UserId,0,BuffChangeInfo]),
					lib_send:send_to_sid(Pid_send, BuffBin),
 					{[BuffInfo1|NewExpBuff], ExpRate, 1};
				_ ->
					BuffTemplateInfo = get_buff_from_template(BuffID),
					NewExpRate = ExpRate * BuffTemplateInfo#ets_buff_template.active_percent / 100,
					{[BuffInfo|NewExpBuff], NewExpRate, 0}
			end
	end.

%% %%冻结Exp_buff
%% frozen_exp_buff(ExpBuff, NowTime) ->
%% 	BuffInfo = is_have_buff(0, ExpBuff),
%% 	NewExpBuff = lists:delete(BuffInfo, ExpBuff),
%% 	if
%% 		BuffInfo =:= [] orelse BuffInfo#ets_users_buffs.is_exist =:= 0 
%% 		  orelse BuffInfo#ets_users_buffs.valid_date =/= 0 ->
%% 			{ExpBuff,[]};
%% 		true ->
%% 			End = BuffInfo#ets_users_buffs.end_date,
%% 			LeftTime = End - NowTime,
%% 			Other = BuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
%% 			BuffInfo1 = BuffInfo#ets_users_buffs{other_data = Other, 
%% 												 end_date = NowTime + LeftTime, 
%% 												 valid_date = NowTime,
%% 												  begin_date = NowTime},
%% 			{[BuffInfo1|NewExpBuff],[BuffInfo1]}
%% 	end.
%% 
%% %%解冻Exp_buff
%% free_exp_buff(ExpBuff, ExpRate, NowTime) ->
%% 	BuffInfo = is_have_buff(0, ExpBuff),
%% 	NewExpBuff = lists:delete(BuffInfo, ExpBuff),
%% 	if
%% 		BuffInfo =:= [] orelse BuffInfo#ets_users_buffs.valid_date =:=0 
%% 		  orelse BuffInfo#ets_users_buffs.is_exist =:= 0  ->
%% 			{ExpRate, [BuffInfo|NewExpBuff], []};
%% 		true ->
%% 			BuffID = BuffInfo#ets_users_buffs.template_id,
%% 			End = BuffInfo#ets_users_buffs.end_date,
%% 			Begin = BuffInfo#ets_users_buffs.begin_date,
%% 			BuffTemplateInfo = get_buff_from_template(BuffID),
%% 			NewExpRate = ExpRate * BuffTemplateInfo#ets_buff_template.active_percent / 100,
%% 			Other = BuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
%% 			BuffInfo1 = BuffInfo#ets_users_buffs{other_data = Other, 
%% 												 end_date = NowTime + End - Begin, 
%% 												 valid_date = 0,
%% 												 begin_date = NowTime},
%% 			{NewExpRate, [BuffInfo1|NewExpBuff], [BuffInfo1]}
%% 	end.
		
%%添加Exp_buff
add_exp_buff(BuffInfo, TemplateID, ExpRate, UserID) ->
	OldBuffInfo = is_have_buff(0, BuffInfo),
	TempBuff1 = lists:delete(OldBuffInfo, BuffInfo),
	BuffTemplateInfo = get_buff_from_template(TemplateID),
	if
		OldBuffInfo =:= [] orelse OldBuffInfo#ets_users_buffs.template_id =/= TemplateID ->
			if
				OldBuffInfo =:= [] -> 
					RemoveBuff = OldBuffInfo,
					TempBuff = TempBuff1;								  
				true -> 
					RemoveBuff = [OldBuffInfo],
					OldOther = OldBuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
					NewOldBUffInfo = OldBuffInfo#ets_users_buffs{other_data = OldOther, is_exist = 0},
					TempBuff = [NewOldBUffInfo|TempBuff1]
			end,
			
			Begin = misc_timer:now_milseconds(),
			End = Begin + BuffTemplateInfo#ets_buff_template.active_totaltime,
			NewExpRate = ExpRate * BuffTemplateInfo#ets_buff_template.active_percent / 100,
			case lists:keyfind(TemplateID, #ets_users_buffs.template_id, TempBuff) of
				false ->
					TempBuff2 = TempBuff,
					Other = #r_other_buff{is_new = 1, is_alter = 1};
				OldInfo ->
					TempBuff2 = lists:keydelete(TemplateID, #ets_users_buffs.template_id, TempBuff),
					Other = #r_other_buff{is_new = OldInfo#ets_users_buffs.other_data#r_other_buff.is_new, is_alter = 1}
				end,
			BuffInfo1 = [UserID, TemplateID, Begin, 0, End, ?BUFFEXP, 0, 1, Other],
			NewBuff = list_to_tuple([ets_users_buffs|BuffInfo1]), 
			{[NewBuff|TempBuff2], [NewBuff|RemoveBuff],  NewExpRate};
		true ->
			End = OldBuffInfo#ets_users_buffs.end_date,
			Other = OldBuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
			NowTime = misc_timer:now_milseconds(),
			if 
				OldBuffInfo#ets_users_buffs.is_exist =:= 1 ->
					End = OldBuffInfo#ets_users_buffs.end_date,
					if
						BuffTemplateInfo#ets_buff_template.limit_totaltime =/= -1
						  andalso OldBuffInfo#ets_users_buffs.valid_date =/= 0 
						  andalso End - OldBuffInfo#ets_users_buffs.begin_date 
						  >= BuffTemplateInfo#ets_buff_template.limit_totaltime ->
							{BuffInfo, [], [], ExpRate};
						
						BuffTemplateInfo#ets_buff_template.limit_totaltime =/= -1
						  andalso OldBuffInfo#ets_users_buffs.valid_date =:= 0 
						  andalso  End - NowTime >=  BuffTemplateInfo#ets_buff_template.limit_totaltime ->
							{BuffInfo, [], [], ExpRate};
						
						true ->
							case OldBuffInfo#ets_users_buffs.valid_date of
								0 ->
									TempEnd = NowTime + BuffTemplateInfo#ets_buff_template.limit_totaltime;
								_ ->
									TempEnd = OldBuffInfo#ets_users_buffs.begin_date + BuffTemplateInfo#ets_buff_template.limit_totaltime
							end,
							NewEnd = erlang:min(End + BuffTemplateInfo#ets_buff_template.active_totaltime,TempEnd),
							NewBuffInfo = OldBuffInfo#ets_users_buffs{end_date = NewEnd,
																   other_data = Other},
							{[NewBuffInfo|TempBuff1], [NewBuffInfo], ExpRate}
					end; 
				true ->
					Begin = misc_timer:now_milseconds(),
					NewEnd = Begin + BuffTemplateInfo#ets_buff_template.active_totaltime,
					Other = BuffInfo#ets_users_buffs.other_data#r_other_buff{ is_alter = 1},
					NewBuffInfo = BuffInfo#ets_users_buffs{begin_date = Begin,
												  end_date = NewEnd,
												  is_exist = 1,
												  other_data = Other},
					NewExpRate = ExpRate * BuffTemplateInfo#ets_buff_template.active_percent / 100,
					{[NewBuffInfo|TempBuff1], [NewBuffInfo], NewExpRate}
			end
	end.
		
%%
%% Local Functions
%%
cale_active_effect_loop_attack(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_attack + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_attack = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_ATTACK, CalcV).

cale_active_effect_loop_target(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_hit_target + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_hit_target =  CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_HITTARGET, CalcV).
cale_active_effect_loop_power_hit(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_power_hit + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_power_hit =  CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_POWERHIT, CalcV).

cale_active_effect_loop_magic_hurt(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_magic_hurt + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_magic_hurt =  CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_MAGICHURT, CalcV).
cale_active_effect_loop_far_hurt(Aer,CalcV) ->
                    CalcT = Aer#ets_users.other_data#user_other.tmp_far_hurt + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_far_hurt =  CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_FARHURT, CalcV).
cale_active_effect_loop_mump_hurt(Aer,CalcV) ->
                    CalcT = Aer#ets_users.other_data#user_other.tmp_mump_hurt + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_mump_hurt = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_MUMPHURT, CalcV).
cale_active_effect_loop_hp(Aer,CalcV) ->
					if CalcV > 0 ->
                    	   CalcT = min(Aer#ets_users.current_hp + CalcV, Aer#ets_users.other_data#user_other.total_hp + Aer#ets_users.other_data#user_other.tmp_totalhp);
					   Aer#ets_users.current_hp =< 0 ->
						   CalcT = 0;
					   true ->
						   CalcT = max(Aer#ets_users.current_hp + CalcV, ?HP_BUFF_REDUCE_MAX_EFFECT)
					end,
					NewAer = Aer#ets_users{
						current_hp = CalcT				  
					},
					send_player_info(NewAer,0,CalcV,0),
					NewAer.
cale_active_effect_loop_mp(Aer,CalcV) ->
					if CalcV > 0 ->
						   CalcT = min(Aer#ets_users.current_mp + CalcV, Aer#ets_users.other_data#user_other.total_mp + + Aer#ets_users.other_data#user_other.tmp_totalmp);
					   true ->
						   CalcT = max(Aer#ets_users.current_mp + CalcV, ?MP_BUFF_REDUCE_MAX_EFFECT)
					end,
					Aer#ets_users{
					    current_mp = CalcT
					}.
cale_active_effect_loop_move_speed(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_move_speed + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{tmp_move_speed = CalcT},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					NewAer1 = cale_player_temp_info(NewAer, ?ATTR_MOVE_SPEED, CalcV),
					NewAer2 = lib_player:calc_speed(NewAer1, NewAer1#ets_users.is_horse),
					send_player_info(NewAer2,2,0,0),
					NewAer1.
cale_active_effect_loop_attack_speed(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_attack_speed +  CalcV,
					OtherData = Aer#ets_users.other_data#user_other{tmp_attack_speed = CalcT},
					NewAer =Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_ATTACK_SPEED, CalcV).
cale_active_effect_loop_defense(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_defense + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_defense =  CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_DEFENSE, CalcV).
cale_active_effect_loop_duck(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_duck + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_duck =  CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_DUCK, CalcV).
cale_active_effect_loop_keep_off(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_keep_off + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_keep_off =  CalcT
										},
					NewAer =Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_KEEPOFF, CalcV).
cale_active_effect_loop_deligency(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_deligency + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_deligency = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_DELIGENCY, CalcV).
cale_active_effect_loop_magic_defense(Aer,CalcV) ->
                    CalcT = Aer#ets_users.other_data#user_other.tmp_magic_defense + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_magic_defense = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_MAGICDEFENCE, CalcV).
cale_active_effect_loop_magic_avoid_in_hurt(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_magic_avoid_in_hurt + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_magic_avoid_in_hurt = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_MAGICAVOIDINHURT, CalcV).
cale_active_effect_loop_far_defense(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_far_defense + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_far_defense = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_FARDEFENSE, CalcV).
cale_active_effect_loop_far_avoid_in_hurt(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_far_avoid_in_hurt + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_far_avoid_in_hurt = CalcT
										},
					Aer#ets_users{
						other_data = OtherData				  
					}.
cale_active_effect_loop_mump_defense(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_mump_defense + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_mump_defense = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_MUMPDEFENSE, CalcV).
cale_active_effect_loop_mump_avoid_in_hurt(Aer,CalcV) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_mump_avoid_in_hurt + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_mump_avoid_in_hurt = CalcT
										},
					NewAer = Aer#ets_users{
						other_data = OtherData				  
					},
					cale_player_temp_info(NewAer, ?ATTR_MUMPAVOIDINHURT, CalcV).


cale_active_effect_loop_extent_total_hp(Aer, CalcV ) ->
					CalcT = Aer#ets_users.other_data#user_other.tmp_totalhp + CalcV,
					OtherData = Aer#ets_users.other_data#user_other{
														tmp_totalhp = trunc(CalcT)
										},
					CurrentHp = 
						case  Aer#ets_users.current_hp + CalcV > CalcT + Aer#ets_users.other_data#user_other.total_hp of
								  true ->
									  trunc(CalcT) + Aer#ets_users.other_data#user_other.total_hp;
								  _ ->
									  Aer#ets_users.current_hp %+ trunc(CalcV)
							  end,
					NewAer = Aer#ets_users{
						other_data = OtherData,
						current_hp = CurrentHp	  
					},
					NewAer.
	
cale_active_effect_loop_monster_attack_physics(Aer,CalcV) ->
					CalcT = Aer#r_mon_info.tmp_attack_physics + CalcV,
					Aer#r_mon_info{
                        tmp_attack_physics =  CalcT
                    }.
cale_active_effect_loop_monster_hit(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_hit + CalcV,
					Aer#r_mon_info{
						tmp_hit =  CalcT
					}.
cale_active_effect_loop_monster_critical(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_critical + CalcV	,
					Aer#r_mon_info{
						tmp_critical =  CalcT				  
					}.
cale_active_effect_loop_monster_attack_magic(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_attack_magic + CalcV	,
					Aer#r_mon_info{
						tmp_attack_magic =  CalcT				  
					}.
cale_active_effect_loop_monster_attack_range(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_attack_range + CalcV	,
					Aer#r_mon_info{
						tmp_attack_range = 	 CalcT			  
					}.
cale_active_effect_loop_monster_attack_vindictive(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_attack_vindictive + CalcV	,
					Aer#r_mon_info{
						tmp_attack_vindictive = CalcT 			  
					}.
cale_active_effect_loop_monster_hp(Aer,CalcV) ->
					if CalcV > 0 ->
						   CalcT = min(Aer#r_mon_info.hp + CalcV, Aer#r_mon_info.template#ets_monster_template.max_hp);
					   true ->
						   CalcT = max(Aer#r_mon_info.hp + CalcV, ?HP_BUFF_REDUCE_MAX_EFFECT)
					end,
					NewAer = Aer#r_mon_info{
						hp = CalcT			  
					},
					send_monster_info(NewAer,0,CalcV,0),
					NewAer.
cale_active_effect_loop_monster_mp(Aer,CalcV) ->
					CalcT = Aer#r_mon_info.mp,	%怪物目前无mp不处理
					Aer#r_mon_info{
					    mp =  CalcT
					}.
cale_active_effect_loop_monster_move_speed(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_move_speed + CalcV,
					Aer#r_mon_info{tmp_move_speed =  CalcT}.
cale_active_effect_loop_monster_attack_speed(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_attack_speed + CalcV,
					Aer#r_mon_info{tmp_attack_speed =  CalcT}.
cale_active_effect_loop_monster_defanse_physics(Aer,CalcV) ->
					CalcT = Aer#r_mon_info.tmp_defanse_physics + CalcV ,
					Aer#r_mon_info{
						tmp_defanse_physics =  CalcT					  
					}.
cale_active_effect_loop_monster_dodge(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_dodge + CalcV,
					 Aer#r_mon_info{
						tmp_dodge =  CalcT			  
					}.
cale_active_effect_loop_monster_block(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_block + CalcV,
					Aer#r_mon_info{
						tmp_block = CalcT				  
					}.
cale_active_effect_loop_monster_tough(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_tough + CalcV	,
					Aer#r_mon_info{
						tmp_tough = CalcT		  
					}.
cale_active_effect_loop_monster_defanse_magic(Aer,CalcV) ->
					CalcT = Aer#r_mon_info.tmp_defanse_magic + CalcV ,
					Aer#r_mon_info{
						tmp_defanse_magic = CalcT
					}.
cale_active_effect_loop_monster_reduce_magic(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_reduce_magic + CalcV,
					Aer#r_mon_info{
						tmp_reduce_magic = CalcT
					}.
cale_active_effect_loop_monster_defanse_range(Aer,CalcV) ->
					CalcT = Aer#r_mon_info.tmp_defanse_range + CalcV,
					Aer#r_mon_info{
						tmp_defanse_range = CalcT
					}.
cale_active_effect_loop_monster_reduce_range(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_reduce_range + CalcV ,
					Aer#r_mon_info{
						tmp_reduce_range = CalcT
					}.
cale_active_effect_loop_monster_defanse_vindictive(Aer,CalcV) ->
					CalcT =   Aer#r_mon_info.tmp_defanse_vindictive + CalcV,
					Aer#r_mon_info{
						tmp_defanse_vindictive = CalcT
					}.
cale_active_effect_loop_monster_reduce_vindictive(Aer,CalcV) ->
					CalcT =  Aer#r_mon_info.tmp_reduce_vindictive + CalcV ,
					Aer#r_mon_info{
						tmp_reduce_vindictive = CalcT  
					}.

%计算buff效果，到人或怪的temp中
cale_active_effect_loop([], Aer, Effect) ->
    {Aer,Effect};
cale_active_effect_loop([H | T], Aer, Effect) ->
	case H of 
		{K, V} -> %%加减法
			case K of
				?ATTR_ATTACK ->
					CalcV = V,
					NewAer = cale_active_effect_loop_attack(Aer,CalcV);
				?ATTR_HITTARGET ->
					CalcV =V,
					NewAer = cale_active_effect_loop_target(Aer,CalcV);
				?ATTR_POWERHIT ->
					CalcV =V,
					NewAer = cale_active_effect_loop_power_hit(Aer,CalcV);
				?ATTR_MAGICHURT ->
					CalcV =V,
					NewAer = cale_active_effect_loop_magic_hurt(Aer,CalcV);
				?ATTR_FARHURT -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_far_hurt(Aer,CalcV);
				?ATTR_MUMPHURT ->
					CalcV =V,
					NewAer = cale_active_effect_loop_mump_hurt(Aer,CalcV);
			
				?ATTR_HP ->
					CalcV =V,
					NewAer = cale_active_effect_loop_hp(Aer,CalcV);
				?ATTR_MP -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_mp(Aer,CalcV);
						
				?ATTR_MOVE_SPEED -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_move_speed(Aer,CalcV);
						
				?ATTR_ATTACK_SPEED -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_attack_speed(Aer,CalcV);
				
				?ATTR_DEFENSE ->
					CalcV =V,
					NewAer = cale_active_effect_loop_defense(Aer,CalcV);
				
				?ATTR_DUCK -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_duck(Aer,CalcV);
						
				?ATTR_KEEPOFF ->
					CalcV =V,
					NewAer = cale_active_effect_loop_keep_off(Aer,CalcV);
						
				?ATTR_DELIGENCY ->
					CalcV =V,
					NewAer = cale_active_effect_loop_deligency(Aer,CalcV);
				
				?ATTR_MAGICDEFENCE ->
					CalcV =V,
					NewAer = cale_active_effect_loop_magic_defense(Aer,CalcV);
			
				?ATTR_MAGICAVOIDINHURT ->
					CalcV =V,
					NewAer = cale_active_effect_loop_magic_avoid_in_hurt(Aer,CalcV);
				
				?ATTR_FARDEFENSE -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_far_defense(Aer,CalcV);
				
				?ATTR_FARAVOIDINHURT ->
					CalcV =V,
					NewAer = cale_active_effect_loop_far_avoid_in_hurt(Aer,CalcV);
				
				?ATTR_MUMPDEFENSE -> 
					CalcV =V,
					NewAer = cale_active_effect_loop_mump_defense(Aer,CalcV);
				
				?ATTR_MUMPAVOIDINHURT ->
					CalcV =V,
					NewAer = cale_active_effect_loop_mump_avoid_in_hurt(Aer,CalcV);
				?ATTR_EXTENT_TOTAL_HP ->
					CalcV = V,
					NewAer = cale_active_effect_loop_extent_total_hp(Aer, CalcV);
				_ ->
					?WARNING_MSG("lib_buff cale_active_effect_loop :~w",[K]),
					CalcV = V,
					NewAer = Aer	
			end;
		{K,V1,V2} -> %%乘除法
			case K of
				?ATTR_ATTACK -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.attack * V1 / V2),
					NewAer = cale_active_effect_loop_attack(Aer,CalcV);
				?ATTR_HITTARGET -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.hit_target * V1 / V2),
					NewAer = cale_active_effect_loop_target(Aer,CalcV);
				?ATTR_POWERHIT ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.power_hit * V1 / V2),
					NewAer = cale_active_effect_loop_power_hit(Aer,CalcV);
				?ATTR_MAGICHURT ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.magic_hurt * V1 / V2),
					NewAer = cale_active_effect_loop_magic_hurt(Aer,CalcV);
				?ATTR_FARHURT -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.far_hurt * V1 / V2),
                    NewAer = cale_active_effect_loop_far_hurt(Aer,CalcV);
				?ATTR_MUMPHURT ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.mump_hurt * V1 / V2),
                    NewAer = cale_active_effect_loop_mump_hurt(Aer,CalcV);
				?ATTR_HP -> 
					TotalHp = Aer#ets_users.other_data#user_other.total_hp + Aer#ets_users.other_data#user_other.tmp_totalhp,
					CalcV = trunc(TotalHp * V1 / V2),
                    NewAer = cale_active_effect_loop_hp(Aer,CalcV);
				?ATTR_MP -> 
					CalcV = trunc(Aer#ets_users.current_mp * V1 / V2),
                    NewAer = cale_active_effect_loop_mp(Aer,CalcV);
%% 				?ATTR_MOVE_SPEED -> 
%% 					CalcV = trunc(Aer#ets_users.other_data#user_other.speed * V1 / V2),
%% 					NewAer = cale_active_effect_loop_move_speed(Aer,CalcV);
				?ATTR_ATTACK_SPEED -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.attack_speed * V1 / V2),
					NewAer = cale_active_effect_loop_attack_speed(Aer,CalcV);
%% 					CalcV = V1,
%% 					NewAer = Aer;
				?ATTR_DEFENSE ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.defense * V1 / V2),
					NewAer = cale_active_effect_loop_defense(Aer,CalcV);
				?ATTR_DUCK ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.duck * V1 / V2),
					NewAer = cale_active_effect_loop_duck(Aer,CalcV);
				?ATTR_KEEPOFF ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.keep_off * V1 / V2),
					NewAer = cale_active_effect_loop_keep_off(Aer,CalcV);
				?ATTR_DELIGENCY -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.deligency * V1 / V2),
					NewAer = cale_active_effect_loop_deligency(Aer,CalcV);
				?ATTR_MAGICDEFENCE -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.magic_defense * V1 / V2),
                    NewAer = cale_active_effect_loop_magic_defense(Aer,CalcV);
				?ATTR_MAGICAVOIDINHURT ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.magic_avoid_in_hurt * V1 / V2),
					NewAer = cale_active_effect_loop_magic_avoid_in_hurt(Aer,CalcV);
				?ATTR_FARDEFENSE ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.far_defense * V1 / V2),
					NewAer = cale_active_effect_loop_far_defense(Aer,CalcV);
				?ATTR_FARAVOIDINHURT -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.far_avoid_in_hurt * V1 / V2),
					NewAer = cale_active_effect_loop_far_avoid_in_hurt(Aer,CalcV);
				?ATTR_MUMPDEFENSE -> 
					CalcV = trunc(Aer#ets_users.other_data#user_other.mump_defense * V1 / V2),
					NewAer = cale_active_effect_loop_mump_defense(Aer,CalcV);
				?ATTR_MUMPAVOIDINHURT ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.mump_avoid_in_hurt * V1 / V2),
					NewAer = cale_active_effect_loop_mump_avoid_in_hurt(Aer,CalcV);
				?ATTR_EXTENT_TOTAL_HP ->
					CalcV = trunc(Aer#ets_users.other_data#user_other.total_hp * V1 / V2),
					NewAer = cale_active_effect_loop_extent_total_hp(Aer, CalcV);
				_ ->
					?WARNING_MSG("lib_buff cale_active_effect_loop,~w",[K]),
					CalcV = V1,
					NewAer = Aer
			end
	end,
	EP = lists:keyfind(K,1,Effect),
	case EP of
		false ->
			NewEffect = [{K,CalcV}|Effect];
		{E1,E2} ->
			NewEffect = lists:keyreplace(K,1,Effect,{E1,E2+CalcV})
	end,
	cale_active_effect_loop(T, NewAer, NewEffect).

cale_active_effect_loop_monster([], Aer, Effect) -> {Aer,Effect};
cale_active_effect_loop_monster([H | T], Aer, Effect) ->
	case H of 
		{K,V} -> %%加减法
			case K of
				?ATTR_ATTACK ->
					CalcV = V,
					NewAer =  cale_active_effect_loop_monster_attack_physics(Aer,CalcV);
			
				?ATTR_HITTARGET ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_hit(Aer,CalcV);

				?ATTR_POWERHIT ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_critical(Aer,CalcV);

				?ATTR_MAGICHURT ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_attack_magic(Aer,CalcV);

				?ATTR_FARHURT -> 
                    CalcV = V,
					NewAer = cale_active_effect_loop_monster_attack_range(Aer,CalcV);

				?ATTR_MUMPHURT ->
                    CalcV = V,
					NewAer = cale_active_effect_loop_monster_attack_vindictive(Aer,CalcV);

				?ATTR_HP ->
                    CalcV =  V,
					NewAer = cale_active_effect_loop_monster_hp(Aer,CalcV);

				?ATTR_MP -> 
                    CalcV =  V,
					NewAer = cale_active_effect_loop_monster_mp(Aer,CalcV);

				?ATTR_MOVE_SPEED -> 
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_move_speed(Aer,CalcV);

				?ATTR_ATTACK_SPEED -> 
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_attack_speed(Aer,CalcV);

				?ATTR_DEFENSE ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_defanse_physics(Aer,CalcV);

				?ATTR_DUCK -> 
					CalcV = V,
					NewAer =cale_active_effect_loop_monster_dodge(Aer,CalcV);

				?ATTR_KEEPOFF ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_block(Aer,CalcV);

				?ATTR_DELIGENCY ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_tough(Aer,CalcV);

				?ATTR_MAGICDEFENCE ->
                    CalcV = V,
					NewAer = cale_active_effect_loop_monster_defanse_magic(Aer,CalcV);

				?ATTR_MAGICAVOIDINHURT ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_reduce_magic(Aer,CalcV);

				?ATTR_FARDEFENSE -> 
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_defanse_range(Aer,CalcV);

				?ATTR_FARAVOIDINHURT ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_reduce_range(Aer,CalcV);

				?ATTR_MUMPDEFENSE -> 
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_defanse_vindictive(Aer,CalcV);

				?ATTR_MUMPAVOIDINHURT ->
					CalcV = V,
					NewAer = cale_active_effect_loop_monster_reduce_vindictive(Aer,CalcV);
				_ ->
					NewAer = Aer,
					CalcV = V
			end;
		{K,V1,V2} -> %%乘除法
			case K of
				?ATTR_ATTACK -> 
					CalcV = Aer#r_mon_info.template#ets_monster_template.attack_physics * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_attack_physics(Aer,CalcV);
				?ATTR_HITTARGET -> 
					CalcV = Aer#r_mon_info.template#ets_monster_template.hit * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_hit(Aer,CalcV);
				?ATTR_POWERHIT -> 
					CalcV = Aer#r_mon_info.template#ets_monster_template.critical * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_critical(Aer,CalcV);
				?ATTR_MAGICHURT ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.attack_magic * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_attack_magic(Aer,CalcV);
				?ATTR_FARHURT -> 
                    CalcV = Aer#r_mon_info.template#ets_monster_template.attack_range * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_attack_range(Aer,CalcV);
				?ATTR_MUMPHURT ->
                    CalcV = Aer#r_mon_info.template#ets_monster_template.attack_vindictive * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_attack_vindictive(Aer,CalcV);
				?ATTR_HP -> 
                    CalcV = Aer#r_mon_info.hp * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_hp(Aer,CalcV);
				?ATTR_MP -> 
					CalcV = Aer#r_mon_info.mp * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_mp(Aer,CalcV);
				?ATTR_MOVE_SPEED -> 
					CalcV = Aer#r_mon_info.move_speed * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_move_speed(Aer,CalcV);
				?ATTR_ATTACK_SPEED -> 
					CalcV = Aer#r_mon_info.attack_speed * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_attack_speed(Aer,CalcV);
				?ATTR_DEFENSE ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.defanse_physics * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_defanse_physics(Aer,CalcV);
				?ATTR_DUCK ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.dodge * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_dodge(Aer,CalcV);
				?ATTR_KEEPOFF ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.block * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_block(Aer,CalcV);
				?ATTR_DELIGENCY -> 
					CalcV = Aer#r_mon_info.template#ets_monster_template.tough * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_tough(Aer,CalcV);
				?ATTR_MAGICDEFENCE -> 
                    CalcV = Aer#r_mon_info.template#ets_monster_template.defanse_magic * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_defanse_magic(Aer,CalcV);
				?ATTR_MAGICAVOIDINHURT ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.redece_magic * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_reduce_magic(Aer,CalcV);
				?ATTR_FARDEFENSE ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.defanse_range * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_defanse_range(Aer,CalcV);
				?ATTR_FARAVOIDINHURT -> 
					CalcV = Aer#r_mon_info.template#ets_monster_template.reduce_range * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_reduce_range(Aer,CalcV);
				?ATTR_MUMPDEFENSE -> 
					CalcV = Aer#r_mon_info.template#ets_monster_template.defanse_vindictive * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_defanse_vindictive(Aer,CalcV);
				?ATTR_MUMPAVOIDINHURT ->
					CalcV = Aer#r_mon_info.template#ets_monster_template.reduce_vindictive * V1 / V2,
					NewAer =  cale_active_effect_loop_monster_reduce_vindictive(Aer,CalcV);
			_ ->
					NewAer = Aer,
					CalcV = V1
			end
	end,
	EP = lists:keyfind(K,1,Effect),
	case EP of
		false ->
			NewEffect = [H|Effect];
		{E1,E2} ->
			NewEffect = lists:keyreplace(K,1,Effect,{E1,E2+CalcV})
	end,
	cale_active_effect_loop_monster(T, NewAer, NewEffect).




%取消buff效果，到人或怪的temp中
cale_active_effect_remove_loop([], Aer) -> {Aer};
cale_active_effect_remove_loop([{K, V} | T], Aer) ->
	case K of
				?ATTR_ATTACK ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_attack(Aer,CalcV);
				
		
				?ATTR_HITTARGET ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_target(Aer,CalcV);
				?ATTR_POWERHIT ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_power_hit(Aer,CalcV);
				?ATTR_MAGICHURT ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_magic_hurt(Aer,CalcV);
				?ATTR_FARHURT -> 
                    CalcV = - V,
					NewAer = cale_active_effect_loop_far_hurt(Aer,CalcV);
				?ATTR_MUMPHURT ->
                    CalcV = - V,
					NewAer = cale_active_effect_loop_mump_hurt(Aer,CalcV);
				?ATTR_HP ->
					NewAer = Aer;
				?ATTR_MP -> 
					NewAer = Aer;
				?ATTR_MOVE_SPEED -> 
					CalcV = - V,
					NewAer = cale_active_effect_loop_move_speed(Aer,CalcV);
				?ATTR_ATTACK_SPEED -> 
					CalcV = - V,
					NewAer = cale_active_effect_loop_attack_speed(Aer,CalcV);
				?ATTR_DEFENSE ->
					CalcV =  - V,
					NewAer = cale_active_effect_loop_defense(Aer,CalcV);
				?ATTR_DUCK -> 
					CalcV = - V,
					NewAer = cale_active_effect_loop_duck(Aer,CalcV);
				?ATTR_KEEPOFF ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_keep_off(Aer,CalcV);
				?ATTR_DELIGENCY ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_deligency(Aer,CalcV);
				?ATTR_MAGICDEFENCE ->
                    CalcV = - V,
					NewAer = cale_active_effect_loop_magic_defense(Aer,CalcV);
				?ATTR_MAGICAVOIDINHURT ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_magic_avoid_in_hurt(Aer,CalcV);
				?ATTR_FARDEFENSE -> 
					CalcV = - V,
					NewAer = cale_active_effect_loop_far_defense(Aer,CalcV);
				?ATTR_FARAVOIDINHURT ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_far_avoid_in_hurt(Aer,CalcV);
				?ATTR_MUMPDEFENSE -> 
					CalcV = - V,
					NewAer = cale_active_effect_loop_mump_defense(Aer,CalcV);
				?ATTR_MUMPAVOIDINHURT ->
					CalcV = - V,
					NewAer = cale_active_effect_loop_mump_avoid_in_hurt(Aer,CalcV);
		 		?ATTR_EXTENT_TOTAL_HP ->
					CalcV = -V,
					NewAer = cale_active_effect_loop_extent_total_hp(Aer, CalcV);
		
				_ ->
					NewAer = Aer
	end,
	cale_active_effect_remove_loop(T, NewAer).


cale_active_effect_remove_loop_monster([], Aer) -> {Aer};
cale_active_effect_remove_loop_monster([{K, V} | T], Aer) ->
			case K of
				?ATTR_ATTACK ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_attack_physics(Aer,CalcV);
				?ATTR_HITTARGET ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_hit(Aer,CalcV);
				?ATTR_POWERHIT ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_critical(Aer,CalcV);
				?ATTR_MAGICHURT ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_attack_magic(Aer,CalcV);
				?ATTR_FARHURT -> 
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_attack_range(Aer,CalcV);
				?ATTR_MUMPHURT ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_attack_vindictive(Aer,CalcV);
				?ATTR_HP ->
					NewAer = Aer;
				?ATTR_MP -> 
					NewAer = Aer;
				?ATTR_MOVE_SPEED -> 
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_move_speed(Aer,CalcV);
				?ATTR_ATTACK_SPEED -> 
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_attack_speed(Aer,CalcV);
				?ATTR_DEFENSE ->
					CalcV = - V ,
					NewAer =  cale_active_effect_loop_monster_defanse_physics(Aer,CalcV);
				?ATTR_DUCK -> 
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_dodge(Aer,CalcV);
				?ATTR_KEEPOFF ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_block(Aer,CalcV);
				?ATTR_DELIGENCY ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_tough(Aer,CalcV);
				?ATTR_MAGICDEFENCE ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_defanse_magic(Aer,CalcV);
				?ATTR_MAGICAVOIDINHURT ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_reduce_magic(Aer,CalcV);
				?ATTR_FARDEFENSE -> 
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_defanse_range(Aer,CalcV);
				?ATTR_FARAVOIDINHURT ->
					CalcV = - V ,
					NewAer =  cale_active_effect_loop_monster_reduce_range(Aer,CalcV);
				?ATTR_MUMPDEFENSE -> 
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_defanse_vindictive(Aer,CalcV);
				?ATTR_MUMPAVOIDINHURT ->
					CalcV = - V,
					NewAer =  cale_active_effect_loop_monster_reduce_vindictive(Aer,CalcV);
				_ ->
					NewAer = Aer
			end,
	cale_active_effect_remove_loop_monster(T, NewAer).

%%检查是否存在有效BUFF
is_have_buff(0, []) -> [];
is_have_buff(1, BuffInfo) -> BuffInfo;
is_have_buff(0, [H|T]) ->
	if
		H#ets_users_buffs.is_exist =:= 1 ->
			is_have_buff(1, H);
		true ->
			is_have_buff(0, T) 
	end.
			
%%检测血包使用
check_hp_mp_buff(Pid_Send, UserID, BuffInfo, ReduceValue, Now, ChangeInfo) ->
	BuffLeftValue = BuffInfo#ets_users_buffs.end_date,
	LeftValue = BuffLeftValue - ReduceValue,
	if
		LeftValue > 0 ->
			Other = BuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
			NewBuffInfo = BuffInfo#ets_users_buffs{end_date = LeftValue,
												   begin_date = Now,
												   other_data = Other},
			{ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[[NewBuffInfo],?ELEMENT_PLAYER,UserID,1,ChangeInfo]),
			lib_send:send_to_sid(Pid_Send, BuffBin),
			NewBuffInfo;
		true ->
			Other = BuffInfo#ets_users_buffs.other_data#r_other_buff{is_alter = 1},
			NewBuffInfo = BuffInfo#ets_users_buffs{is_exist = 0,
												   other_data = Other},
			{ok,BuffBin} = pt_20:write(?PP_BUFF_UPDATE,[[NewBuffInfo],?ELEMENT_PLAYER,UserID,0,ChangeInfo]),
			lib_send:send_to_sid(Pid_Send, BuffBin),
			NewBuffInfo
	end.


%%计算人物Buff动态属性变化
cale_player_temp_info(PlayerStauts, Type, Value) ->
	Temp_Info = PlayerStauts#ets_users.other_data#user_other.buff_temp_info,
	case lists:keymember(Type, 1, Temp_Info) of 
		true ->
			NewInfo = lists:keyreplace(Type, 1, Temp_Info, {Type, Value});
		_ ->
			NewInfo = [{Type, Value}|Temp_Info]
	end,
	Other = PlayerStauts#ets_users.other_data#user_other{buff_temp_info = NewInfo},
	NewPlayerStatus = PlayerStauts#ets_users{other_data = Other},
	NewPlayerStatus.

%% 广播角色BUFF产生后的属性变化 
send_player_info(PlayerStatus,Send,HP,MP) ->
	case Send of
		0 -> %% 广播自己发血魔变化
			{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[PlayerStatus#ets_users.id, 1, ?ELEMENT_PLAYER,HP,MP,
																 PlayerStatus#ets_users.current_hp, 
																 PlayerStatus#ets_users.current_mp]),
			mod_map_agent:send_to_area_scene(PlayerStatus#ets_users.current_map_id,
												 PlayerStatus#ets_users.pos_x,
												 PlayerStatus#ets_users.pos_y,
												 HPMPBin,
												 undefined);
		1 -> %% 给自己发属性更新包
			{ok, PlayerBin} = pt_20:write(?PP_UPDATE_USER_INFO, PlayerStatus),
 			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, PlayerBin);
		2 -> %% 给自己发属性更新包
			{ok, PlayerScenBin} = pt_12:write(?PP_PLAYER_STYLE_UPDATE, [PlayerStatus]),
			mod_map_agent:send_to_area_scene(
									PlayerStatus#ets_users.current_map_id,
									PlayerStatus#ets_users.pos_x,
									PlayerStatus#ets_users.pos_y,
									PlayerScenBin);
		
		_ ->
			skip
	end.

%% 广播怪物BUFF产生后的属性变化 
send_monster_info(Mon,Send,HP,MP) ->
	case Send of
		0 -> %% 广播自己发血魔变化
			{ok, HPMPBin} = pt_23:write(?PP_TARGET_UPDATE_BLOOD,[Mon#r_mon_info.id, 1, ?ELEMENT_MONSTER,HP,MP,
																 Mon#r_mon_info.hp, 
																 Mon#r_mon_info.mp]),
			mod_map_agent:send_to_area_scene(Mon#r_mon_info.map_id,
											 Mon#r_mon_info.pos_x,
											 Mon#r_mon_info.pos_y,
											 HPMPBin,
											 undefined);
		_ ->
			skip
	end.

%% 计算移除的bufflist,用于保存数据库
remove_buff_list([], List) -> List;
remove_buff_list(BuffList, List) ->
	[H|T] = BuffList,
	case lists:keymember(H#ets_users_buffs.template_id,#ets_users_buffs.template_id,List) of
		true ->
			remove_buff_list(T,List);
		_ ->
			remove_buff_list(T,[H|List])
	end.