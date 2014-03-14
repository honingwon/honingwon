%% Author: wangdahai
%% Created: 2012-12-6
%% Description: TODO: Add description to lib_top
-module(lib_top).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([
		 init_top_config/0,
		 init_line_off_top/0,
		 send_challenge_first_award/0,
		 first_statistic_top/0,
		 statistic_top/0,
		 statistic_top_test/0,
		 init_ets_duplicate_top/0,
		 %get_top_3_userId/1,
		 get_challenge_top/3,
		 update_duplicate_top/1,
		 save_duplicate_top/1,
		 update_seven_days_top/1,
		 get_level_top_10/0,
		 send_to_dup_top/2]).

-define(MAX_GUARD_DUPLICATE_TOP_NUM, 50).	%%守护副本防守

%% -define(TOP_INDIVIDUAL_BINARY, top_individual_binary). %% 个人排行榜数据包
%% -define(TOP_OTHER_BINARY, top_other_binary).%%其它排行榜数据包

-define(TOP_TIME_1, 1). 	%% 排行榜统计时间1 (00:01)
-define(TOP_TIME_2, 43201). %% 排行榜统计时间2（12）

-define(PGAE_NUMBER,10).
-define(TOP_NUMBER,30).
%%
%% API Functions
%%

init_top_config() ->
	F = fun(Info) ->
			Record = list_to_tuple([ets_top_config] ++ Info),
			ets:insert(?ETS_TOP_CONFIG, Record)
		end,
	case db_agent_top:get_top_config() of
		[] ->skip;
		List when is_list(List) ->
			lists:foreach(F, List);
		_ ->skip			
	end,	
	ok.

first_statistic_top() ->
	Now = misc_timer:now_seconds(),
	{Day,_} = util:get_midnight_seconds(Now),
	Time = Now - Day ,
	if
		Time =< ?TOP_TIME_1 ->
			erlang:send_after((?TOP_TIME_1 - Time) * 1000, self(), {statistic_top});
		Time =< ?TOP_TIME_2 ->
			erlang:send_after((?TOP_TIME_2 - Time) * 1000, self(), {statistic_top});
		true ->
			AfterTimte = (?ONE_DAY_SECONDS - Time + ?TOP_TIME_1) * 1000,
			erlang:send_after(AfterTimte, self(), {statistic_top})		
	end,
	ok.
statistic_top_test() ->
	F = fun(Info) ->
			db_agent_top:statistic_top(Info#ets_top_config.sql_update)
		end,
	db_agent_top:truncate_top_table(), %% 先清除数据表在统计。
	List = ets:tab2list(?ETS_TOP_CONFIG),
	lists:foreach(F, List),
	init_line_off_top(),
	update_top_title().

statistic_top() ->
	%?WARNING_MSG("statistic_top:~p",[misc_timer:now_seconds()]),
	erlang:send_after((?TOP_TIME_2 - ?TOP_TIME_1) * 1000, self(), {statistic_top}),
	F = fun(Info) ->
			db_agent_top:statistic_top(Info#ets_top_config.sql_update)
		end,
	db_agent_top:truncate_top_table(), %% 先清除数据表在统计。
	List = ets:tab2list(?ETS_TOP_CONFIG),
	lists:foreach(F, List),
	init_line_off_top(),
	lib_world_data:update_world_level(),
	update_top_title().


init_line_off_top() ->
	ets:delete_all_objects(?ETS_TOP_DATA),
	ets:delete_all_objects(?ETS_TOP_BINARY_DATA),
	IndBinary = init_top_individual(),
	OthBinary = init_top_other(),
	BinData = <<IndBinary/binary, OthBinary/binary>>,
	DataCompress = zlib:compress(BinData),
	ets:insert(?ETS_TOP_BINARY_DATA,{1,DataCompress}),
%% 	lib_world_data:update_world_level(),
	ok.

init_top_individual() ->
	F = fun(Info, {Bin,List,TopType}) ->
			Record = list_to_tuple([top_individual_info] ++ Info),
			NewBin = individual_pack_binary(Bin,Record),
			if
				TopType =:= 0 ->
					{NewBin,[Record],Record#top_individual_info.top_id};
				TopType =/= Record#top_individual_info.top_id ->
					ets:insert(?ETS_TOP_DATA, {TopType,List}),
					{NewBin,[Record],Record#top_individual_info.top_id};
				true ->
					{NewBin,[Record|List],TopType}
			end			
		end,
	case db_agent_top:get_top_individual() of
		[] -><<>>;
		List when is_list(List) ->
			{BinData,List1,TopType1} = lists:foldr(F, {<<>>,[],0}, List),
			ets:insert(?ETS_TOP_DATA, {TopType1,List1}),
			N = length(List),
			<<1:8,N:16,BinData/binary>>;
			%%ets:insert(?ETS_TOP_BINARY_DATA,{1,DataCompress});
		_-><<>>
	end.

individual_pack_binary(Bin,Info) ->
	NickName = pt:write_string(Info#top_individual_info.nick_name),
	GuildName = pt:write_string(Info#top_individual_info.guild_name),
				<<
				(Info#top_individual_info.top_id):16,
				(Info#top_individual_info.user_id):64,
				NickName/binary,
				(Info#top_individual_info.vip_level):16,
				(Info#top_individual_info.career):8,
				GuildName/binary,
				(Info#top_individual_info.value):32,
				Bin/binary>>.
other_pack_binary(Bin,Info) ->
	NickName = pt:write_string(Info#top_other_info.nick_name),
	ItemName = pt:write_string(Info#top_other_info.item_name),
				<<				
				(Info#top_other_info.top_id):16,
				(Info#top_other_info.user_id):64,
				NickName/binary,
				(Info#top_other_info.item_id):64,
				ItemName/binary,
				(Info#top_other_info.value):32,
				Bin/binary>>.

init_top_other() ->
	F = fun(Info, {Bin,List,TopType}) ->
			Record = list_to_tuple([top_other_info] ++ Info),
			NewBin = other_pack_binary(Bin,Record),
			if
				TopType =:= 0 ->
					{NewBin,[Record],Record#top_other_info.top_id};
				TopType =/= Record#top_other_info.top_id ->
					ets:insert(?ETS_TOP_DATA, {TopType,List}),
					{NewBin,[Record],Record#top_other_info.top_id};
				true ->
					{NewBin,[Record|List],TopType}
			end	
		end,
	case db_agent_top:get_top_other() of
		[] -><<>>;
		List when is_list(List) ->
		{BinData,List1,TopType1} = lists:foldr(F, {<<>>,[],0}, List),
		ets:insert(?ETS_TOP_DATA, {TopType1,List1}),
		N = length(List),
		<<2:8,N:16,BinData/binary>>;
		%%ets:insert(?ETS_TOP_BINARY_DATA,{2,DataCompress});
		_-><<>>
	end.

%%初始化副本排行榜ets表基础信息
init_ets_duplicate_top() ->
	DataList = init_duplicate_top_info(),
	F = fun(Info) ->
			Record = list_to_tuple([top_duplicate_List] ++ Info),
			TopList = case lists:keyfind(Record#top_duplicate_List.duplicate_id, 1, DataList) of
				false ->
					[];
				{_,List} ->
					List;
				_ ->
					[]
			end,
			TopCount = length(TopList),
			NewRecord = Record#top_duplicate_List{list = TopList, top_count = TopCount},
			ets:insert(?ETS_DUPLICATE_TOP, NewRecord)
		end,
	case db_agent_top:get_duplicate_top_list() of
		[] ->
			skip;
		List when is_list(List) ->
			lists:foreach(F, List);
        _ ->
			skip
	end,
	ok.
init_duplicate_top_info() ->
	F = fun(Info,{DataList,List,Id}) ->
			Record1 = list_to_tuple([top_duplicate_info] ++ Info),
			IdList = split_string_to_list(Record1#top_duplicate_info.user_name),
			Record = Record1#top_duplicate_info{user_id_list = IdList},
			if 
				Record#top_duplicate_info.duplicate_id =/= Id ->
					if
						List =/= [] ->
							{[{Id,List}|DataList],[Record],Record#top_duplicate_info.duplicate_id};
						true ->
							{DataList,[Record],Record#top_duplicate_info.duplicate_id}
					end;
				true ->
					{DataList,[Record|List],Id}
			end
		end,
	case db_agent_top:get_duplicate_top_info()of
		[] ->
			[];
		List when is_list(List) ->
			{DL,L,I} = lists:foldr(F, {[],[],0}, List),
			[{I,L}|DL];
		_ ->
			[]
	end.

update_seven_days_top(OpenDay) ->
	case OpenDay of
		0 ->
			send_seven_days_top("SELECT a.id, a.nick_name, a.level,0 FROM t_users AS a ORDER BY a.level DESC,a.exp DESC LIMIT 3;",1);
		1 ->
			send_seven_days_top("SELECT a.id, a.nick_name, a.fight,0 FROM t_users AS a  ORDER BY a.fight DESC LIMIT 3;",2);
		2 ->
			send_seven_days_top("SELECT a.id, a.nick_name, b.fight,0 FROM t_users a, t_users_mounts b WHERE a.id = b.user_id AND b.is_exit = 1 ORDER BY b.fight DESC LIMIT 3;",3);
		3 ->
			send_seven_days_top("SELECT a.id, a.nick_name, b.fight,0 FROM t_users a, t_users_pets b WHERE a.id = b.user_id AND b.is_exit = 1 ORDER BY b.fight DESC LIMIT 3;",4);
		4 ->
			send_seven_days_top("SELECT a.user_id, b.nick_name, SUM(a.gengu_levl) AS v,0 FROM t_users_veins a, t_users b WHERE  a.user_id = b.id GROUP BY a.user_id ORDER BY v DESC LIMIT 3; ",5);
		5 ->
			send_seven_days_top("SELECT b.user_id, a.nick_name, SUM(b.strengthen_level) AS v,0 FROM t_users a, t_users_items b WHERE b.bag_type = 1 AND b.place < 30 AND b.is_exist = 1 AND a.id = b.user_id GROUP BY a.id ORDER BY v DESC LIMIT 3;",6);
		6 ->
			send_seven_days_top("SELECT a.id, a.nick_name, a.money ,0 FROM t_users AS a  ORDER BY a.money DESC LIMIT 3;",7);
		7 ->
			send_seven_days_top("SELECT a.id, a.nick_name, a.money ,0 FROM t_users AS a  ORDER BY a.money DESC LIMIT 3;",8);
		_ ->
			skip
	end.

send_seven_days_top(Sql,OpenDay) ->
	F = fun(Info) ->
			 list_to_tuple([activity_seven_data] ++ Info)
		end,
	case db_agent_top:seven_day_top(Sql) of
		[] -> skip;
		List when is_list(List) ->
			NewList =  [F(X) || X <- List],
			mod_activity_seven:update_top_list({OpenDay,NewList});
        _ -> skip
	end.

update_duplicate_top(Record) ->
	case db_agent_top:duplicate_top_list_get(Record#top_duplicate_info.duplicate_id) of
		[] ->
			ok;
		TopList ->
			Result = case TopList#top_duplicate_List.duplicate_type of
				?DUPLICATE_TYPE_CHALLENGE ->
					update_duplicate_top_pass(TopList#top_duplicate_List.list, Record);
				?DUPLICATE_TYPE_PASS ->
					update_duplicate_top_pass(TopList#top_duplicate_List.list, Record);
				?DUPLICATE_TYPE_GUARD ->
					update_duplicate_top_guard(TopList#top_duplicate_List.list, Record, TopList#top_duplicate_List.top_count);
				_ ->
					false
			end,
			case Result of
						false ->
							ok;
						{add,List} ->
							NewTopList = TopList#top_duplicate_List{state = 1, top_count = TopList#top_duplicate_List.top_count + 1, list = List},
							ets:delete(?ETS_DUPLICATE_TOP,Record#top_duplicate_info.duplicate_id),
							ets:insert(?ETS_DUPLICATE_TOP, NewTopList);
						{update,List} ->
							NewTopList = TopList#top_duplicate_List{state = 1, list = List},
							ets:delete(?ETS_DUPLICATE_TOP,Record#top_duplicate_info.duplicate_id),
							ets:insert(?ETS_DUPLICATE_TOP, NewTopList)
			end
	end.

%%发送副本排行榜信息
send_to_dup_top(DuplicateId, Pid) ->
	case ets:lookup(?ETS_DUPLICATE_TOP, DuplicateId) of
		[] ->
			{ok, Bin} = pt_26:write(?PP_DUPLICATE_TOP_LIST,[DuplicateId, []]);
		[TopData] ->
			
			{ok, Bin} = pt_26:write(?PP_DUPLICATE_TOP_LIST,[DuplicateId, TopData#top_duplicate_List.list])
	end,
	lib_send:send_to_sid(Pid, Bin).

get_challenge_top(DuplicateId,Index, Pid) ->
	case ets:lookup(?ETS_DUPLICATE_TOP, DuplicateId) of
		[] ->
			{ok, Bin} = pt_26:write(?PP_CHALLENGE_TOP_INFO, ["", 0]),
			lib_send:send_to_sid(Pid, Bin);
		[TopData] ->
			case lists:keyfind(Index, #top_duplicate_info.pass_id, TopData#top_duplicate_List.list) of
				false ->
					{ok, Bin} = pt_26:write(?PP_CHALLENGE_TOP_INFO, ["", 0]),
					lib_send:send_to_sid(Pid, Bin);
				Tup ->
					{ok, Bin} = pt_26:write(?PP_CHALLENGE_TOP_INFO, [Tup#top_duplicate_info.user_name, Tup#top_duplicate_info.use_time]),
					lib_send:send_to_sid(Pid, Bin)
			end
	end.

update_top_title() ->
	update_top_title(1,41,3),
	update_top_title(5,44,3),
	update_top_title(17,47,1),
	update_top_title(34,48,1),
	update_top_title(35,49,1),
	update_top_title(30,50,1),
	update_top_title(31,51,1),
	update_top_title(25,52,1),
	update_top_title(26,53,1),
	update_top_title(27,54,1).

update_top_title(TopId,TitleId,Num) ->
	case ets:lookup(?ETS_TOP_DATA, TopId) of
		[] ->
			skip;
		[TopData] ->
			{_,TList} = TopData,
			update_top_title1(TList, Num, TitleId)
	end.

update_top_title1(_,0,_TitleId) -> skip;
update_top_title1([],_Num,_TitleId) -> skip;
update_top_title1([H|L],Num,TitleId) ->
	if is_record(H, top_individual_info) =:= true ->
			lib_player:add_title(H#top_individual_info.user_id,TitleId);
	   true ->
			lib_player:add_title(H#top_other_info.user_id,TitleId)
	end,
	update_top_title1(L, Num - 1, TitleId + 1).

get_level_top_10() ->
	case ets:lookup(?ETS_TOP_DATA, 5) of
		[] ->
			0;
		[TopData] ->
			{_,TList} = TopData,
			if	TList =:= [] ->
				0;
			true ->
				get_level_top_10(TList, 10, 0)
			end			
	end.
get_level_top_10(_,0,CountLevel) -> CountLevel div 10;
get_level_top_10([],Num,CountLevel) -> CountLevel div (10 - Num);
get_level_top_10([H|L],Num,CountLevel) ->
	get_level_top_10(L,Num - 1,CountLevel + H#top_individual_info.value).

update_seven_data()->
	Data1 =	update_seven_data(26, 2),
	Data2 = [update_seven_data(25, 3),Data1],
	Data3 = [update_seven_data(30, 4)|Data2],
	Data4 = [update_seven_data(1, 5)|Data3],
	Data5 = [update_seven_data(13, 6)|Data4],
	Data6 = [update_seven_data(5, 7)|Data5],
%%	?DEBUG("update_seven_data:~p",[Data6]).
 	mod_activity_seven:update_top_list(Data6).


update_seven_data(TopId, Type) ->
	case ets:lookup(?ETS_TOP_DATA, TopId) of
		[] ->
			{Type,[]};
		[TopData] ->
			{_,TList} = TopData,
			List = update_seven_data1(TList,0,[]),
			{Type,List}
	end.

update_seven_data1([],_,List) ->
	List;
update_seven_data1(_,3,List) ->
	List;
update_seven_data1([H|L],Top,List) ->
	Info = if is_record(H, top_individual_info) =:= true ->
		#activity_seven_data{
									user_id = H#top_individual_info.user_id,    %%用户编号
							 		nick_name = H#top_individual_info.nick_name, %%用户名称
									num = H#top_individual_info.value		 %%数量
									};
		true ->
		#activity_seven_data{
									user_id = H#top_other_info.user_id,    %%用户编号
							 		nick_name = H#top_other_info.nick_name, %%用户名称
									num = H#top_other_info.value		 %%数量
									}
	end,
	update_seven_data1(L,Top + 1,List++[Info]).

send_challenge_first_award() ->
	case ets:lookup(?ETS_DUPLICATE_TOP, ?CHALLENGE_DUPLICATE_ID) of
		[] ->
			ok;
		[TopData] ->
			ets:delete(?ETS_DUPLICATE_TOP, ?CHALLENGE_DUPLICATE_ID),
			NewData = TopData#top_duplicate_List{list = [],state = 0,top_count = 0},
			ets:insert(?ETS_DUPLICATE_TOP, NewData),
			db_agent_top:delete_duplicate_top(?CHALLENGE_DUPLICATE_ID),
			send_challenge_first_award1(TopData#top_duplicate_List.list)
	end.

send_challenge_first_award1(TopList) ->
	{MegaSecs, Secs, MicroSecs} = misc_timer:now(),	
	{{Y,Month,D},_} = calendar:now_to_local_time({MegaSecs, Secs - 60, MicroSecs}),
	send_challenge_first_award1(TopList,{Y,Month,D}).

send_challenge_first_award1([],_) ->
	ok;
send_challenge_first_award1([Info|L],{Y,Month,D}) ->
	Template_id = get_challenge_first_award_item(Info#top_duplicate_info.pass_id),
	case data_agent:item_template_get(Template_id) of
		Template when is_record(Template, ets_item_template) ->
			MailItem1 = item_util:create_new_item(Template, 1, 0, 0, 1, 0, ?BAG_TYPE_MAIL),
			MailItem = item_util:add_item_and_get_id(MailItem1),
			SList = string:tokens(tool:to_list(Info#top_duplicate_info.user_name), tool:to_list(",")),
			{Name,ID} = case SList of
				[[NickName],[X],_,_] ->
					{NickName,X};
				[NickName,X,_,_] ->
					{NickName,X};
				_ ->
					?WARNING_MSG("duplicate top error user id:~p",[SList]),
					{"","0"}
			end,
			{UserId,_} = string:to_integer(ID),
			if
				UserId > 0 ->
					Title = ?GET_TRAN(?_LANG_MAIL_CHALLENGE_AWARD_TITLE,[Info#top_duplicate_info.pass_id]),
					Content = ?GET_TRAN(?_LANG_MAIL_CHALLENGE_AWARD_CONTENT,[Y,Month,D,Info#top_duplicate_info.pass_id]),
					lib_mail:send_GM_items_to_mail([[MailItem], Name, UserId, Title, Content]);
				true ->
					ok				
			end;
		_ ->
			ok
	end,
	send_challenge_first_award1(L,{Y,Month,D}).



%% 保存副本排行榜
save_duplicate_top(Record) ->
	if
		Record#top_duplicate_List.state =:= 1 ->
			ets:delete(?ETS_DUPLICATE_TOP, Record#top_duplicate_List.duplicate_id),
			NewRecord = Record#top_duplicate_List{state = 0},
			ets:insert(?ETS_DUPLICATE_TOP, NewRecord),
			db_agent_top:delete_duplicate_top(Record#top_duplicate_List.duplicate_id),
			db_agent_top:insert_into_duplicate_top(Record#top_duplicate_List.list);			
		true ->
			ok
	end.

%%
%% Local Functions
%%
get_challenge_first_award_item(Top_Num) ->
	ChallengeTemplate = data_agent:get_challenge_duplicate_template(Top_Num),
	Item = ChallengeTemplate#ets_challenge_duplicate_template.gift,
	Item.
%% 	case (Top_Num-1) div 6 of
%% 		Temp when(Temp >= 0 andalso Temp < 6 ) ->
%% 			293000 + Temp;
%% 		_ ->
%% 			293000
%% 	end.

%% order_by_value([],HList,TopInfo) ->
%% 	lists:append(HList, [TopInfo]);
%% order_by_value([H|L],HList,TopInfo) ->
%% 	if H#top_info.value > TopInfo#top_info.value ->
%% 		lists:append(HList, [TopInfo|[H|L]]);
%% 	H#top_info.user_id =:= TopInfo#top_info.user_id -> %%发现自己已经在排行榜中了将原来的排名除去
%% 		order_by_value(L, HList, TopInfo);
%% 	true ->
%% 		order_by_value(L, lists:append(HList, [H]), TopInfo)
%% 	end.

update_duplicate_top_pass(List, Record) ->
	case lists:keyfind(Record#top_duplicate_info.pass_id, #top_duplicate_info.pass_id, List) of
		false ->
			{add,[Record|List]};
		Info ->
			if
				Info#top_duplicate_info.use_time =< Record#top_duplicate_info.use_time ->
					false;
				true ->
					NewList = lists:keyreplace(Record#top_duplicate_info.pass_id, #top_duplicate_info.pass_id, List, Record),
					{update, NewList}
			end
	end.

update_duplicate_top_guard(List, Record, TopCount) ->
	case List of
		[] ->
			{add,[Record]};
		[Info|_] ->
			update_duplicate_top_guard3(Info, List, Record, TopCount)
	end.

update_duplicate_top_guard3(Info, List, Record, TopCount) ->
	if
		TopCount >= ?MAX_GUARD_DUPLICATE_TOP_NUM andalso(
		Info#top_duplicate_info.pass_id > Record#top_duplicate_info.pass_id
		orelse (Info#top_duplicate_info.pass_id =:= Record#top_duplicate_info.pass_id
			andalso Info#top_duplicate_info.use_time =< Record#top_duplicate_info.use_time)) ->
			false;
		true ->
		case check_no_same_user(List, Record#top_duplicate_info.user_id_list) of
			{NewList} ->
				update_duplicate_top_guard2(NewList, Record, TopCount, false);
			{NewList,H} ->
				if
					H#top_duplicate_info.pass_id > Record#top_duplicate_info.pass_id
						orelse (H#top_duplicate_info.pass_id =:= Record#top_duplicate_info.pass_id
								andalso H#top_duplicate_info.use_time =< Record#top_duplicate_info.use_time) ->
						false;
					true ->
						update_duplicate_top_guard2(NewList, Record, TopCount - 1, true)
				end
		end
	end.

update_duplicate_top_guard2(List, Record, TopCount, Flag) ->
	case update_duplicate_top_guard1(Record,List) of
		NewList->
			if
				TopCount < ?MAX_GUARD_DUPLICATE_TOP_NUM ->
					if
						Flag =:= true ->
							{update,NewList};
						true ->
							{add,NewList}
					end;					
				true ->
					[_I|L] = NewList,
					{update,L}
			end
	end.

%% update_duplicate_top_guard1([], List, Record) ->
%% 	{List ++ [Record]};
%% update_duplicate_top_guard1([H|L], List, Record) ->
%% 	if
%% 		H#top_duplicate_info.pass_id < Record#top_duplicate_info.pass_id ->
%% 			update_duplicate_top_guard1(L, List ++ [H], Record);
%% 		H#top_duplicate_info.pass_id =:= Record#top_duplicate_info.pass_id
%% 			andalso  H#top_duplicate_info.use_time > Record#top_duplicate_info.use_time ->
%% 			update_duplicate_top_guard1(L, List ++ [H], Record);
%% 		List =/= [] ->
%% 			{List ++ [Record|L]};
%% 		true ->
%% 			false
%% 	end.

update_duplicate_top_guard1(Record, [H|T]) when H#top_duplicate_info.pass_id > Record#top_duplicate_info.pass_id 
											orelse(H#top_duplicate_info.pass_id =:= Record#top_duplicate_info.pass_id 
													andalso H#top_duplicate_info.use_time =< Record#top_duplicate_info.use_time) -> [Record|[H|T]];
update_duplicate_top_guard1(Record, [H|T]) -> [H|update_duplicate_top_guard1(Record, T)];
update_duplicate_top_guard1(Record, []) -> [Record].


check_no_same_user(List, RList) ->
	Num = length(RList),
	check_no_same_user3(List,[],{RList,Num}).

check_no_same_user3([],List,{_RList,_Num}) ->
	{List};
check_no_same_user3([H|L],List,{RList,Num}) ->
	N = length(H#top_duplicate_info.user_id_list),
	if
		N =/= Num ->
			check_no_same_user3(L,List ++ [H],{RList,Num});
		true ->
			case check_no_same_user2(RList,Num,H#top_duplicate_info.user_id_list) of
				true ->
					check_no_same_user3(L,List ++ [H],{RList,Num});
				false ->
					{List ++ L,H}
			end
	end.

check_no_same_user2([],_Num,_List) ->
	true;
check_no_same_user2([H|L],Num,List) ->
	case check_no_same_user1(List,H) of
		true ->
			true;
		false when Num =:= 1 ->
			false;
		_ ->
			check_no_same_user2(L,Num - 1,List)
	end.

check_no_same_user1([],_Id)->
	true;
check_no_same_user1([H|L],Id)->
	if
		H =:= Id ->
			false;
		true ->
			check_no_same_user1(L,Id)
	end.


split_string_to_list(SL) ->
	SList = string:tokens(tool:to_list(SL), "|"),
	F = fun(X,L) ->
			case string:tokens(X, ",") of
				[_,Id,_] ->
					{V,_} = string:to_integer(Id),
					[V|L];
				[_,Id,_,_] ->
					{V,_} = string:to_integer(Id),
					[V|L];
				_ ->
					L
			end
		end,
	lists:foldr(F,[],SList).












