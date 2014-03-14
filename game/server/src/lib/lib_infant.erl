%% Author: Administrator
%% Created: 2011-3-23
%% Description: TODO: Add description to lib_infant
-module(lib_infant).


-include("common.hrl").
-define(INFANT_ONE_HOUR, (1*3600)).						%%在线慢1小时
-define(INFANT_THREE, (3*3600)).     						%%在线满3小时
-define(INFANT_OFF_FIVE, (5*3600)).   						%%下线满5小时
-define(LEFT_FIVE_MINUTE_SEND, five_minute_left).			%%在线累积2小时55分送时间	
-define(Total_Online_time, nt).							%%在线累积时间
%%
%% Exported Functions
%%
-export([
		 check/4,
		 get_infant_user/2,
		 send_infant_user/1,
		 infant_post/3,
		 idnum_ver/1,
		 infant_post_local/3
		 ]).

%%
%% API Functions
%%
% 防沉迷，0未登记，1成年，2登记但未成年， 3满三个小时 , 4发送过下线协议
check(Pid, TempOnlineTime, InfantState, LastOnlineDate) ->
	InFant = config:get_infant_ctrl(),
	Now = misc_timer:now_seconds(),
	if
		Now - LastOnlineDate >= ?INFANT_OFF_FIVE -> 
			OnlineTime = 0;
		true ->
			OnlineTime = TempOnlineTime
	end,
	if 
		InFant =/= 0 andalso InfantState =/= 1 ->
			check1(Pid, OnlineTime,  LastOnlineDate, InfantState);
		true ->
			NewLastOnlineDate = Now,
			{ok, InfantState, NewLastOnlineDate, OnlineTime}
	end.

check1(Pid, OnlineTime,  LastOnlineDate, OldInfantState) ->	
	Left_five_send = get(?LEFT_FIVE_MINUTE_SEND),
	if
		OnlineTime >= ?INFANT_OFF_FIVE andalso(Left_five_send  =:= undefined orelse Left_five_send  =:= 3)->			
			{ok, Bin} = pt_26:write(?PP_INFANT_SEND_STATE, [4,OnlineTime]),
			lib_send:send_to_sid(Pid, Bin),
			put(?LEFT_FIVE_MINUTE_SEND, 4),
			InfantState = 4,
			NewLastOnlineDate = LastOnlineDate;
		OnlineTime >= ?INFANT_THREE andalso (Left_five_send  =:= undefined orelse Left_five_send  =:= 2)->
			{ok, Bin} = pt_26:write(?PP_INFANT_SEND_STATE, [3,OnlineTime]),
			lib_send:send_to_sid(Pid, Bin),
			put(?LEFT_FIVE_MINUTE_SEND, 3),
			InfantState = 3,
			NewLastOnlineDate = LastOnlineDate;
		OnlineTime >= ?INFANT_ONE_HOUR andalso Left_five_send  =:= undefined ->
			{ok, Bin} = pt_26:write(?PP_INFANT_SEND_STATE, [2,OnlineTime]),
			lib_send:send_to_sid(Pid, Bin),
			put(?LEFT_FIVE_MINUTE_SEND, 2),
			InfantState = OldInfantState,
			NewLastOnlineDate = LastOnlineDate;
		true ->
			InfantState = OldInfantState,
 			NewLastOnlineDate = misc_timer:now_seconds()
	end,
	LastTotalOnline = get(?Total_Online_time),	
	TempTotalTime = OnlineTime / (60 * 60),
	TotalTime = tool:floor(TempTotalTime),
    Notic = io_lib:format(?_LANG_INFANT_NOTIC_ONLINE_TIME, [TotalTime]),
	Notic1 = tool:to_binary(Notic),
	if
		LastTotalOnline =:= undefined ->
			put(?Total_Online_time, TotalTime),
			if 
				TotalTime > 0 andalso TotalTime < 3 ->
					lib_chat:chat_sysmsg_pid([Pid, ?ALTER, 0, ?ORANGE, Notic1]);
				true ->
					skip
			end;
		true ->
			if
				TotalTime > LastTotalOnline andalso TotalTime < 3 ->
					put(?Total_Online_time, TotalTime),
 					lib_chat:chat_sysmsg_pid([Pid, ?ALTER, 0, ?ORANGE, Notic1]);
				true ->
					skip
			end
	end,
	{ok, InfantState, NewLastOnlineDate, OnlineTime}.


%%获取防沉迷信息
get_infant_user(UserInfo, OldInfant) ->
	Now = misc_timer:now_seconds(),
	if
		Now - UserInfo#ets_users.last_online_date >= ?INFANT_OFF_FIVE -> 
			OnlineTime = 0;
		true ->
			OnlineTime = UserInfo#ets_users.online_time
	end,
	case OldInfant of
		-1 ->
			NewUserInfo = get_infant_user1(UserInfo);
	    _ ->
			NewUserInfo = get_infant_user2(UserInfo, OldInfant)			
	end,
%% 	case OldInfant of
%% 		1 ->
%% 			ok;
%% 		_ ->
%% 			{ok, Bin} = pt_26:write(?PP_INFANT_SEND_STATE, [2,0]),
%% 			lib_send:send_to_sid(NewUserInfo#ets_users.other_data#user_other.pid_send, Bin)
%% 	end,
	NewUserInfo1 = NewUserInfo#ets_users{online_time = OnlineTime},
	NewUserInfo1.

get_infant_user1(UserInfo) ->
	case lib_player:get_infant_by_username(UserInfo#ets_users.user_name, UserInfo#ets_users.site) of
 		{_InFanctName,InFanctId} ->
			TempInFanctID = tool:to_list(InFanctId),
			case check_adult(TempInFanctID) of 
				{true, TempRes} -> 
					Res = TempRes;
				_ -> 
					Res = -1
			end,										  
 			Other = UserInfo#ets_users.other_data#user_other{ infant_state = Res},
		    UserInfo#ets_users{other_data=Other};
		{} ->
			Other = UserInfo#ets_users.other_data#user_other{ infant_state = -1},
		    UserInfo#ets_users{other_data = Other}
	end.

get_infant_user2(UserInfo, OldInfant) ->
	case OldInfant of
				2 ->
					InfanctState = 0; %%未登记
				1 ->
					InfanctState = 1; %%成年，通过验证
				_ ->
					InfanctState = 2  %%未成年，通过验证
			end,
	Other = UserInfo#ets_users.other_data#user_other{ infant_state = InfanctState},
	UserInfo#ets_users{other_data=Other}.

send_infant_user(PlayerStatus) ->
	if PlayerStatus#ets_users.other_data#user_other.infant_state =:= 0
		 orelse PlayerStatus#ets_users.other_data#user_other.infant_state =:= -1 ->
		   NeedAdd = 0;
	   true ->
		   NeedAdd = 1     %%NeedAdd 1验证过 0还没验证
	end,
	if
		PlayerStatus#ets_users.other_data#user_other.infant_state =/= 4 ->
			{ok, InfantBin} = pt_26:write(?PP_INFANT_NOTICE, [NeedAdd, PlayerStatus#ets_users.online_time]),
			lib_send:send_to_sid(PlayerStatus#ets_users.other_data#user_other.pid_send, InfantBin);
		true ->
			skip
	end.

%% 添加防沉迷信息
infant_post(PlayerStatus, CardName, CardID) ->
	if
		PlayerStatus#ets_users.other_data#user_other.infant_state =:= -1 ->
			infant_post_local(PlayerStatus, CardName, CardID);
		true ->
			infant_post_far(PlayerStatus, CardName, CardID)
	end.
			
infant_post_local(PlayerStatus, CardName, CardID) ->
	case idnum_ver(CardID) of
		{true,  Res} ->
			Other = PlayerStatus#ets_users.other_data#user_other{ infant_state = Res},
			NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},
			db_agent_user:save_user_infant(PlayerStatus#ets_users.user_name,
										   PlayerStatus#ets_users.site,
								  		   CardName,
								   		   CardID,
										   misc_timer.now),
			{1, Res, NewPlayerStatus};
		{false, _} ->
			{0, 0 , PlayerStatus}
	end.

infant_post_far(PlayerStatus, CardName, CardID) ->
 	UserName = PlayerStatus#ets_users.user_name,
	Account = http_lib:url_decode(tool:to_list(UserName)),
	NewCardName = http_lib:url_decode(CardName),
	Key = config:get_infant_key(),
	Md5 = CardName ++  tool:to_list(UserName) ++ Key  ++ CardID,
    Sign = util:md5(Md5),
	Host = config:get_infant_post_site(),
	Address = Host ++ "?account=" ++ Account ++ "&truename=" ++ NewCardName ++ 
				  "&card=" ++ CardID ++ "&sign=" ++ Sign,

	Res = tool:to_integer(misc:get_http_content(Address)),
	if 
		Res =:= 1 orelse Res =:= 2 orelse Res =:= -4 ->
			Other = PlayerStatus#ets_users.other_data#user_other{ infant_state = Res},
			NewPlayerStatus = PlayerStatus#ets_users{other_data=Other},
			db_agent_user:save_user_infant(PlayerStatus#ets_users.user_name,
										   PlayerStatus#ets_users.site,
								  		   CardName,
								   		   CardID,
										   misc_timer.now),
			{1, Res, NewPlayerStatus};
		true ->
			{0, 0 , PlayerStatus}
	end.
	
%%防沉迷验证是否成年
check_adult(InfantID) ->
	InFant = config:get_infant_ctrl(),   %%1成年 2未成年
	if 
		InFant =/= 0 ->
			idnum_ver(InfantID);
		true ->
			{true, 1}
	end.


%%身份证验证
idnum_ver(Idnum) ->
	Idnum_len = string:len(Idnum),
	if Idnum_len =:= 18 -> idnum_ver18(Idnum);
		true -> idnum_ver15(Idnum)
	end.

idnum_ver15(Idnum) -> 
	Provinces ="11x22x35x44x53x12x23x36x45x54x13x31x37x46x61x14x32x41x50x62x15x33x42x51x63x21x34x43x52x64x65x71x81x82x91",
	Sub_Pro = string:sub_string(Idnum, 1, 2),
	Index = string:rstr(Provinces, Sub_Pro),
	 if
		 Index > 0 ->
		   {Bir_day,[]} = string:to_integer(string:sub_string(Idnum, 7, 12)),
		   {{Year, Month, Day}, {_Hour, _Min, _Sec}} = calendar:local_time(),
		   if ((Year rem 100 + 100) * 10000 + Month * 100 + Day - Bir_day) div 10000 >= 18 -> {true,1};
			  true -> {true,2}
		   end;
		 true -> {false, 3}
	end.

idnum_ver18(Idnum) ->
	Int_v1 = tool:to_integer(string:sub_string(Idnum, 1, 1)) * 7,
	Int_v2 = tool:to_integer(string:sub_string(Idnum, 2, 2)) * 9,
	Int_v3 = tool:to_integer(string:sub_string(Idnum, 3, 3)) * 10,
	Int_v4 = tool:to_integer(string:sub_string(Idnum, 4, 4)) * 5,
	Int_v5 = tool:to_integer(string:sub_string(Idnum, 5, 5)) * 8,
	Int_v6 = tool:to_integer(string:sub_string(Idnum, 6, 6)) * 4,
	Int_v7 = tool:to_integer(string:sub_string(Idnum, 7, 7)) * 2,
	Int_v8 = tool:to_integer(string:sub_string(Idnum, 8, 8)) * 1,
	Int_v9 = tool:to_integer(string:sub_string(Idnum, 9, 9)) * 6,
	Int_v10 = tool:to_integer(string:sub_string(Idnum, 10, 10)) * 3,
	Int_v11 = tool:to_integer(string:sub_string(Idnum, 11, 11)) * 7,
	Int_v12 = tool:to_integer(string:sub_string(Idnum, 12, 12)) * 9,
	Int_v13 = tool:to_integer(string:sub_string(Idnum, 13, 13)) * 10,
	Int_v14 = tool:to_integer(string:sub_string(Idnum, 14, 14)) * 5,
	Int_v15 = tool:to_integer(string:sub_string(Idnum, 15, 15)) * 8,
	Int_v16 = tool:to_integer(string:sub_string(Idnum, 16, 16)) * 4,
	Int_v17 = tool:to_integer(string:sub_string(Idnum, 17, 17)) * 2,

	case (Int_v1+ Int_v2+ Int_v3+ Int_v4+ Int_v5+ Int_v6+ Int_v7+ Int_v8+ Int_v9+ Int_v10+ Int_v11+ Int_v12+ Int_v13+ Int_v14+ Int_v15+ Int_v16+ Int_v17) rem 11 of
		0 -> Str_v18 = "1"; 
		1 -> Str_v18 = "0"; 
		2 -> Str_v18 = "X"; 
		3 -> Str_v18 = "9"; 
		4 -> Str_v18 = "8"; 
		5 -> Str_v18 = "7"; 
		6 -> Str_v18 = "6"; 
		7 -> Str_v18 = "5"; 
		8 -> Str_v18 = "4"; 
		9 -> Str_v18 = "3"; 
		10 -> Str_v18 = "2"
	end,
     
	Str_tmp = string:to_upper(string:sub_string(Idnum, 18, 18)),
	
	if Str_tmp =:= Str_v18  -> 
		   	{{Year, Month, Day}, {_Hour, _Min, _Sec}} = calendar:local_time(),
	   		Bir_day = tool:to_integer(string:sub_string(Idnum, 7, 14)),
	   		if (Year * 10000 + Month * 100 + Day - Bir_day) div 10000 >= 18 -> {true,1};
	   			true -> {true,2}
				end;
	   	true -> {false,3}
	end.


%%
%% Local Functions
%%

