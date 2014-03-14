%% Author: wangdahai
%% Created: 2013-9-4
%% Description: TODO: Add description to lib_marry_duplicate
-module(lib_marry_duplicate).

%%
%% Include files
%%
-include("common.hrl").
%%
%% Exported Functions
%%
-export([create_marry_duplicate/1,enter_marry_duplicate/7,enter_marry_map/8,login_in_duplicate/4,give_gift_enter/6,off_line/2,
		 send_invitation_card/2,see_gift_list/2,see_gift_list/1,send_candy/2,check_free_candy/2,check_quit_hall/2,quit_hall/2,
		 start_marry/1,start_marry/3,start_marry_timing/1,marry_words/2,send_marry_box/1,shut_down/1,award_exp/1,get_length/0,
		 get_marry_hall_info/1,get_marry_hall_info/2,send_gift_by_mail/1,quit_hall_mod/2]).

-record(marry_state,{	user_id = 0,		
						marry_type = 0,				
						map_only_id = 0,
						duplicate_id = 0,
						start_time = 0,
						map_id = 0,
						map_pid,											
						groom_name = "",		%%新郎名字
						bride_name = "",		%%新娘名字
						bride_id = 0,			%%新娘id
						award_exp = 0,			%%奖励经验	
						free_candy = 0,			%%免费召唤喜糖1，3
						gift_list = [],			%%礼单
						user_list = [],			%%玩家列表
						status = 0				%%0创建,1开启2已拜堂,3结束						
						}).
-record(marry_gift,{	user_id = 0,
						nick_name = "",
						yuan_bao = 0,
						copper = 0,
						state = 1
						}).
-define(MARRY_MAP_ID_1, 10100001).				%结婚地图普通id
-define(MARRY_MAP_ID_2, 10100002).				%结婚地图豪华id
-define(MARRY_MAP_AWARD_EXP_1, 1000).
-define(MARRY_MAP_AWARD_EXP_2, 3000).
-define(MARRY_MAP_POS, {1881,1401}).			%地图坐标
-define(MARRY_GROOM_POS, {961,1041}).			
-define(MARRY_BRIDE_POS, {1161,961}).
-define(MARRY_GROOM_RETURN_POS, {1392,1157}).
-define(MARRY_BRIDE_RETURN_POS, {1322,1189}).

-define(MARRY_AUTO_START_TIME, 1200000).		%自动拜堂时间20分钟
-define(MARRY_AWARD_EXP_TIME, 60000).			%奖励经验时间间隔

-define(MARRY_BOX_ID, 1000205).		%采集箱子编号
-define(MARRY_CANDY_TYP_LIST,[{1000201,0},{1000201,5},{1000202,10},{1000203,30},{1000204,100}]).%喜糖采集物价格
-define(MARRY_CANDY_POS_LIST,[{537,814},{550,573},{498,1459},{95,891},{1646,500},{528,258},{2137,889},{1080,391},{138,1061},{329,649},
{1141,662},{2105,853},{1534,1258},{574,1370},{1416,407},{2013,1106},{1779,544},{207,655},{174,622},{1747,771},
{1777,1335},{1229,292},{1429,849},{1732,1425},{1144,735},{1929,1332},{455,1337},{1541,980},{932,1607},{858,698},
{1691,849},{332,685},{1201,326},{1550,1056},{1203,810},{574,1094},{768,1207},{507,1085},{607,376},{461,1213},
{1786,943},{1355,1413},{2232,880},{2165,653},{950,376},{1458,446},{570,1497},{2101,931},{574,1119},{1286,810},
{1458,1373},{1498,998},{1183,777},{1750,580},{650,1055},{1479,1222},{1270,377},{1777,1129},{631,519},{1540,780},
{1220,1538},{135,850},{2295,889},{532,1214},{1780,1422},{1343,847},{247,819},{1897,1180},{1777,492},{983,1613},
{1095,777},{2025,741},{1101,655},{1303,853},{1310,1397},{725,486},{1407,737},{2064,882},{1426,892},{1508,889},
{488,588},{1534,834},{1459,1052},{286,725},{1958,777},{814,659},{1362,376},{1367,407},{1506,1092},{1097,1292},
{249,1179},{1892,653},{2301,817},{1098,349},{846,1619},{1582,1098},{2259,837},{1349,250},{1137,1301},{1249,1294},
{1131,331},{1103,1622},{1505,1143},{1895,571},{1492,777},{2182,931},{2170,694},{261,932},{1458,410},{453,880},
{905,403},{1779,1292},{1150,814},{1497,404},{1613,1376},{1007,243},{1192,361},{1126,644},{1228,368},{1328,407},
{819,1223},{1274,1368},{1900,977},{568,257},{2020,804},{301,1250},{576,501},{1276,332},{1300,1140},{1620,879},
{1808,1168},{140,779},{664,531},{934,1326},{785,1182},{1976,1374},{1641,526},{1691,1295},{1538,1173},{1297,376},
{459,928},{1294,298},{608,1168},{879,1294},{1317,274},{1804,579},{505,1052},{1234,329},{1774,450},{1889,611},
{1897,1407},{1295,740},{1059,691},{1897,1255},{1395,1282},{900,1582},{1497,1252},{1064,1580},{189,600},{1168,294},
{1176,649},{541,1313},{1456,1434},{1171,1531},{1537,876},{498,261},{1820,979},{1492,1049},{170,744},{819,691},
{2016,980},{923,711},{414,1370},{665,1255},{1946,692},{1271,1319},{2059,1044},{926,1635},{1311,1335},{1867,807},
{205,811},{1983,694},{1658,1326},{537,1253},{1252,286},{855,1331},{1901,1014},{977,383},{732,1219},{1819,1131},
{850,426},{497,849},{176,971},{1332,1373},{2259,774},{859,1250},{617,1495},{1022,371},{1938,1374},{1823,1461},
{297,1183},{206,1052},{532,1420},{2213,683},{2259,889},{1816,1292},{1949,843},{1026,1611},{1543,1123},{1213,738},
{841,497},{1091,1249},{1850,1211},{2089,894},{529,616},{1426,813},{1576,920},{179,1092},{1158,1413},{2295,773},
{1580,849},{1134,1583},{2170,873},{1261,1529},{2019,688},{1214,1580},{897,1620},{1177,398},{1407,1335},{1137,701},
{2055,1077},{1738,810},{946,410},{1146,611},{865,768},{1177,810},{1195,1267},{1038,192},{535,1008},{2132,695},
{1776,985},{2326,774},{1786,1368},{2185,628},{1338,1106},{2303,855},{216,774},{1852,1171},{352,1046},{658,577},
{134,1016},{1213,255},{325,1258},{895,729},{1373,735},{1497,1167},{1097,691},{1256,692},{2025,843},{329,891},
{1776,616},{759,494},{1605,537},{817,98},{1297,1540},{1405,1235},{1446,1256},{580,1295},{380,601},{105,1055},
{1416,444},{1289,420},{2226,641},{800,1611},{1946,814},{253,852},{949,1291},{373,814},{1104,1577},{1474,888},
{104,934},{174,931},{1413,1420},{131,692},{1459,814},{461,1014},{1811,447},{1992,891},{1179,1568},{453,1377},
{2013,652},{574,453},{1934,649},{1134,405},{1137,1376},{900,1662},{1689,535},{1820,889},{891,1335},{1583,1383},
{1659,844},{971,420},{583,1059},{368,774},{1197,1326},{659,1488},{1723,501},{164,1056},{1337,734},{1770,1080},
{1622,1338},{625,1292},{540,1183},{1367,1328},{737,538},{613,1122},{1070,1613},{1049,44},{725,1173},{250,1208},
{332,756},{223,1174},{298,1225},{1665,1302},{2091,698},{1694,816},{1785,423},{1494,652},{2220,925},{831,456},
{2200,841},{167,1008},{492,1014},{173,823},{1968,644},{685,1188},{622,1083},{213,1132},{850,138},{1450,370},
{571,1456},{98,977},{1503,971},{1107,380},{285,767},{1643,1077},{605,1010},{731,1535},{208,979},{1601,1050},
{383,701},{1601,483},{1735,1295},{1041,1253},{1697,568},{241,688},{613,1328},{1507,488},{1297,1492},{577,1013},
{1392,1458},{2053,713},{182,862},{67,923},{1304,682},{1737,1340},{1503,446},{1119,741},{1973,977},{164,578},
{1820,1208},{1861,1006},{343,1292},{1217,410},{895,700},{244,650},{856,722},{695,1555},{335,1214},{1080,308},
{1334,1297},{610,582},{1731,468},{959,1252},{1901,1365},{1141,373},{1250,819},{1010,408},{1010,816},{373,862},
{1973,1132},{295,822},{1261,734},{1008,185},{1558,495},{1810,610},{1453,1288},{788,1497},{1856,1305},{1620,977},
{380,1337},{1319,349},{300,847},{434,620},{486,1416},{295,323},{1241,1362},{1820,1335},{1431,1461},{341,1183},
{2255,740},{1385,891},{1228,688},{710,1253},{1107,292},{456,1416},{344,847},{1768,1177},{2340,838},{1544,926},
{137,725},{373,656},{1646,1047},{1334,1491},{241,1097},{210,1098},{1747,1126},{1179,734},{660,483},{691,1456},
{132,895},{1334,1137},{700,522},{652,1174},{1558,808},{2220,774},{952,1655},{826,1537},{1983,850},{1249,403},
{968,700},{1092,819},{607,547},{658,1289},{1589,979},{491,1373},{694,1495},{1473,853},{1025,1292},{1161,323},
{829,1579},{186,679},{650,450},{1591,813},{373,1208},{1144,782},{1705,1379},{1243,1252},{1013,52},{1056,341},
{1495,688},{1658,973},{176,904},{2029,1006},{871,452},{1350,317},{1310,656},{623,1464},{340,719},{2216,731},
{1498,816},{764,1535},{935,726},{1416,1183},{1182,617},{1044,295},{1973,1174},{1868,973},{1683,1073},{1922,603},
{774,661},{447,659},{1504,928},{103,1016},{973,813},{1741,1386},{1537,1216},{1405,374},{988,1250},{1682,498},
{1700,1341},{289,653},{1616,1003},{1028,231},{1141,1340},{756,1571},{1822,935},{1097,731},{1817,1383},{1620,832},
{376,1295},{1362,1485},{617,1052},{534,1374},{1483,1408},{2143,929},{1861,934},{611,1370},{258,879},{1453,759},
{1041,416},{810,1253},{1379,847},{328,798},{1900,813},{534,1444},{1295,720},{58,849},{697,1535},{610,480},{1568,879},
{1780,1031},{294,888},{1850,574},{482,1214},{1934,977},{1132,1261},{213,898},{974,1301},{1307,1174},{413,1340},
{214,850},{182,710},{1559,453},{135,970},{1392,1368},{817,1376},{723,1452},{1455,1328},{247,783},{728,1570},
{1562,1028},{1846,620},{589,406},{213,941},{618,436},{1897,944},{288,688},{1013,691},{91,856},{1376,1137},{213,1017},
{144,822},{1179,1368},{903,774},{977,1649},{1819,1008},{1523,1413},{2007,1174},{1658,1373},{1303,1455},{798,458},
{404,646},{732,1495},{485,973},{252,1135},{1329,1258},{62,889},{1452,697},{1062,1295},{655,1011},{1285,1279},
{1182,692},{1589,947},{1729,1070},{571,1176},{1008,313},{364,892},{1373,1171},{1929,1214},{1749,543},{926,449},
{616,977},{540,1091},{1023,326},{1786,898},{413,1286},{659,1453},{719,465},{479,613},{1826,1255},{1852,1410},
{798,1535},{1344,1449},{1864,1367},{1891,1214},{1267,1486},{182,782},{940,811},{405,1056},{135,931},{1544,1379},
{2022,885},{902,1258},{1050,811},{449,573},{553,1062},{792,1571},{1340,700},{1823,1404},{298,925},{380,738},
{1016,268},{225,735},{292,1146},{386,1255},{610,1252},{868,1585},{567,1404},{1858,1253},{1862,1334},{459,1061}]).

%%
%% API Functions
%%
get_length() ->
	?DEBUG("get_length:~p",[length(?MARRY_CANDY_POS_LIST)]).

create_marry_duplicate([UserId,Type]) ->
	ProcessName = misc:create_process_name(mod_marry_dup, [UserId]),
	misc:register(global, ProcessName, self()),
	{MapId,FreeNum,AwardExp} = 
	case Type of
		1 -> {?MARRY_MAP_ID_1,1,?MARRY_MAP_AWARD_EXP_1};
		_ -> {?MARRY_MAP_ID_2,3,?MARRY_MAP_AWARD_EXP_2}
	end,
	
	State = #marry_state{
				   user_id = UserId,
				   marry_type = Type,
				   duplicate_id = 0,
				   award_exp = AwardExp,
				   free_candy = FreeNum,
				   map_id = MapId,		   
				   gift_list = []
				   },

	misc:write_monitor_pid(self(),?MODULE, {State}),
    {ok, State}.

enter_marry_duplicate(UserId1,Pid1,NickName1,UserId2,Pid2,NickName2,State) ->
	if State#marry_state.map_only_id =:= 0 ->
			{Map_pid,Map_Only_Id} = create_marry_map(State#marry_state.map_id),
			UserList = [{UserId1,Pid1},{UserId2,Pid2}],			
			NewState = State#marry_state{map_only_id = Map_Only_Id, map_pid = Map_pid,
										 groom_name = NickName1, bride_name = NickName2,
										 user_list = UserList,bride_id = UserId2,
										 start_time = misc_timer:now_seconds(), status = 1};
		true ->
			NewState = State
	end,
	{X,Y} = ?MARRY_MAP_POS,
%% 	{ok, Bin} = pt_29:write(?PP_MARRY_HALL_INFO, [NewState#marry_state.user_id,NewState#marry_state.bride_id,
%% 													NewState#marry_state.start_time,NewState#marry_state.status,NewState#marry_state.free_candy]),
	gen_server:cast(Pid1, {enter_marry_map, NewState#marry_state.map_pid, self(),
							 NewState#marry_state.map_only_id, NewState#marry_state.duplicate_id,
							 NewState#marry_state.map_id,X,Y}),
	gen_server:cast(Pid2, {enter_marry_map, NewState#marry_state.map_pid, self(),
							 NewState#marry_state.map_only_id, NewState#marry_state.duplicate_id,
							 NewState#marry_state.map_id,X,Y}),
	erlang:send_after(?MARRY_AWARD_EXP_TIME, self() , {award_exp}),
	erlang:send_after(?MARRY_AUTO_START_TIME, self() , {start_marry}),
	NewState.

%%用户被调用进入结婚地图
enter_marry_map(Map_Pid,Marry_Pid,Map_Only_Id,_DuplicateId,Map_Id,X,Y,PlayerStatus) ->
	mod_map:leave_scene(PlayerStatus#ets_users.id, 
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id, 
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
								PlayerStatus#ets_users.pos_x, 
								PlayerStatus#ets_users.pos_y,
								PlayerStatus#ets_users.other_data#user_other.pid,
								PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),

					Other = PlayerStatus#ets_users.other_data#user_other{
																 pid_map = Map_Pid,
																 walk_path_bin=undefined,
																 pid_dungeon=Marry_Pid,
																 map_template_id = Map_Id,
																 duplicate_id=0},
					{OldMapId,OldX,OldY} = case lib_map:is_copy_scene(PlayerStatus#ets_users.current_map_id) of
						true ->
							{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y};
						_ ->
							{PlayerStatus#ets_users.current_map_id,PlayerStatus#ets_users.pos_x,PlayerStatus#ets_users.pos_y}
					end,
					NewStatus = PlayerStatus#ets_users{current_map_id=Map_Only_Id,
											   pos_x=X,
											   pos_y=Y,
											   old_map_id = OldMapId,
											   old_pos_x = OldX,
											   old_pos_y = OldY,
											   is_horse = 0,
											   other_data=Other},

					NewStatus1 = lib_player:calc_speed(NewStatus, PlayerStatus#ets_users.is_horse),

					{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [Map_Id, NewStatus1#ets_users.pos_x, NewStatus1#ets_users.pos_y]),
					lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, EnterData),	
			
					%{ok, ReturnData} = pt_12:write(?PP_ENTER_DUPLICATE, DuplicateId),
					%lib_send:send_to_sid(NewStatus1#ets_users.other_data#user_other.pid_send, ReturnData),	
					
					{ok, PlayerData} = pt_12:write(?PP_MAP_USER_ADD,[NewStatus1]),
					mod_map_agent:send_to_area_scene(NewStatus1#ets_users.current_map_id,
									  				NewStatus1#ets_users.pos_x,
									  				NewStatus1#ets_users.pos_y,
									  				PlayerData,
									  				undefined),
					NewStatus1.

login_in_duplicate(UserId, UserPid, _PidSend, State) ->
	if State#marry_state.status =:= 0 ->
			[State,{false}];
	   true ->
			case lists:keyfind(UserId, 1, State#marry_state.user_list) of
				false -> [State,{false}];
				_ ->
					NewList = lists:keydelete(UserId, 1, State#marry_state.user_list),
					NewState = State#marry_state{user_list = [{UserId, UserPid}|NewList]},
%%  					{ok, Bin} = pt_29:write(?PP_MARRY_HALL_INFO, [State#marry_state.user_id,State#marry_state.bride_id,
%%  													State#marry_state.start_time,State#marry_state.status,State#marry_state.free_candy]),
%%  					lib_send:send_to_sid(PidSend, Bin),
					[NewState,{State#marry_state.map_pid,State#marry_state.map_only_id, State#marry_state.duplicate_id, State#marry_state.map_id}]
			end	
	end.

give_gift_enter(UserId, UserPid, NickName, Yanbao, Copper, State) ->
	case lists:keyfind(UserId, 1, State#marry_state.user_list) of
		false ->
			NewUserList = State#marry_state.user_list;
		_ ->
			NewUserList = lists:keydelete(UserId, 1, State#marry_state.user_list)
	end,
	{X,Y} = ?MARRY_MAP_POS,
%% 	{ok, Bin} = pt_29:write(?PP_MARRY_HALL_INFO, [State#marry_state.user_id,State#marry_state.bride_id,
%% 													State#marry_state.start_time,State#marry_state.status,State#marry_state.free_candy]),
	gen_server:cast(UserPid, {enter_marry_map, State#marry_state.map_pid, self(),
							 State#marry_state.map_only_id, State#marry_state.duplicate_id,
							 State#marry_state.map_id,X,Y}),
	Msg = 
	if	Yanbao > 0 -> ?GET_TRAN(?_LANG_MARRY_GIFT_1, [NickName,Yanbao]);
		Copper > 0 -> ?GET_TRAN(?_LANG_MARRY_GIFT_2, [NickName,Copper])
	end,
	{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,Msg]),
	mod_map_agent:send_to_scene(State#marry_state.map_only_id, BinData),

	GiftInfo = #marry_gift{copper = Copper, user_id = UserId, nick_name = NickName, yuan_bao = Yanbao},
	NewGiftList = [GiftInfo|State#marry_state.gift_list],
	State#marry_state{user_list = [{UserId, UserPid}|NewUserList], gift_list = NewGiftList}.

%% 发送请帖
send_invitation_card(Lists, State) ->
	{ok, Bin} = pt_29:write(?PP_SEND_INVITATION_CARD, [State#marry_state.groom_name,
											 State#marry_state.bride_name,State#marry_state.marry_type,State#marry_state.user_id]),
	%?DEBUG("send_invitation_card:~p",[{State#marry_state.groom_name,State#marry_state.bride_name,State#marry_state.marry_type,State#marry_state.user_id}]),
	F = fun(Id) ->
			case lib_player:get_online_info(Id) of
				[] -> skip;
				FriendInfo ->
					lib_send:send_to_sid(FriendInfo#ets_users.other_data#user_other.pid_send, Bin)
			end
		end,
	lists:foreach(F, Lists).

%% 查看礼单
see_gift_list(Status) ->
	if	Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_1 orelse 
				Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_2 ->
			%?DEBUG("see_gift_list:~p",[Status#ets_users.other_data#user_other.pid_dungeon]),
			gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon,  {see_gift_list, Status#ets_users.other_data#user_other.pid_send});
		true ->
			%?DEBUG("see_gift_list:~p",[Status#ets_users.other_data#user_other.map_template_id]),
			skip
	end.

see_gift_list(Pid,State) ->
	N = length(State#marry_state.gift_list),
	%?DEBUG("see_gift_list:~p",[State#marry_state.gift_list]),
	Bin = write_gift_list(State#marry_state.gift_list,<<>>),
	ListBin = <<N:16,Bin/binary>>,
	{ok,B} = pt_29:write(?PP_SEE_GIFT_LIST, [ListBin]),
	lib_send:send_to_sid(Pid, B).
%% 发送喜糖(被mod_player调用)
send_candy(Type,Status) ->	
	Res =
	if	Status#ets_users.other_data#user_other.map_template_id =/= ?MARRY_MAP_ID_1 andalso 
				Status#ets_users.other_data#user_other.map_template_id =/= ?MARRY_MAP_ID_2 ->
			{error,?_LANG_ER_WRONG_VALUE};
		Type < 1 orelse Type > length(?MARRY_CANDY_TYP_LIST) ->
			{error,?_LANG_ER_WRONG_VALUE};
		Type =:= 1 ->
			gen_server:call(Status#ets_users.other_data#user_other.pid_dungeon, {check_free_candy, Status#ets_users.id});		
		true ->
			{_, NeedYuanbao1} = lists:nth(Type, ?MARRY_CANDY_TYP_LIST),
			if	NeedYuanbao1 > Status#ets_users.yuan_bao ->
					ErrStr = ?GET_TRAN(?_LANG_ER_NOT_ENOUGH_YUANBAO,[NeedYuanbao1]),
					{error,ErrStr};
				true ->
					{ok,0,0}
			end
	end,
	case Res of
		{ok, Id1, Id2} ->
			{CollectId, NeedYuanbao} = lists:nth(Type, ?MARRY_CANDY_TYP_LIST),
			PosList = get_candy_pos_list(10,[]),
			gen_server:cast(Status#ets_users.other_data#user_other.pid_map,{create_collect_pos, CollectId, PosList}),
			NewStatus = lib_player:reduce_cash_and_send(Status, NeedYuanbao, 0, 0, 0,{?CONSUME_YUANBAO_SEND_CANDY,Type,1}),
			{ok, Id1, Id2, NewStatus};
		_ ->
			Res
	end.

check_free_candy(UserId, State) ->
	if	UserId =/= State#marry_state.user_id andalso UserId =/= State#marry_state.bride_id ->
			{error, ?_LANG_ER_NOT_ENOUGH_POWER};
		State#marry_state.free_candy < 1 ->
			{error, ?_LANG_ER_NO_FREE_CANDY};
		true ->
			NewState = State#marry_state{free_candy = State#marry_state.free_candy - 1},
			{ok,NewState#marry_state.user_id,NewState#marry_state.bride_id, NewState}
	end.

get_marry_hall_info(Status) ->
	if	Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_1 orelse 
				Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_2 ->
			gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {get_hall_info, Status#ets_users.other_data#user_other.pid_send});
		true ->
			skip
	end.

get_marry_hall_info(State, SendPid) ->
	{ok, Bin} = pt_29:write(?PP_MARRY_HALL_INFO, [State#marry_state.user_id,State#marry_state.bride_id,
													State#marry_state.start_time,State#marry_state.status,State#marry_state.free_candy,
													State#marry_state.groom_name,State#marry_state.bride_name]),
	lib_send:send_to_sid(SendPid, Bin).

check_quit_hall(NickName, State) ->
	if	(NickName =:= State#marry_state.bride_name andalso State#marry_state.status < 3) 
				orelse (NickName =:= State#marry_state.groom_name andalso State#marry_state.status < 3) ->
			false;
		true ->
			true			
	end.

quit_hall(Status, Flag) ->
	if	Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_1 orelse 
				Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_2 ->
			case gen_server:call(Status#ets_users.other_data#user_other.pid_dungeon, {check_quit_hall, Status#ets_users.nick_name}) of
				true ->										
					NewStatus = quit_hall1(Status),
					if	Flag =:= marry_finsh ->
							{ok,Bin} = pt_29:write(?PP_MARRY_FINISH, [1]),
							lib_send:send_to_sid(Status#ets_users.other_data#user_other.pid_send, Bin),
							skip;
						true ->						
							gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {quit_hall, Status#ets_users.id})
					end,
					NewStatus;
				false ->
					Status
			end;
		true ->
			Status
	end.

quit_hall_mod(Id, State) ->
%% 	if	State#marry_state.status =:= 3 ->
%% 			State;
%% 		true ->
			NewList = lists:keydelete(Id, 1, State#marry_state.user_list),
			State#marry_state{user_list = NewList}.
%% 	end.

start_marry(Status) ->
	if	Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_1 orelse 
				Status#ets_users.other_data#user_other.map_template_id =:= ?MARRY_MAP_ID_2 ->
			gen_server:cast(Status#ets_users.other_data#user_other.pid_dungeon, {start_marry,
													 Status#ets_users.id, Status#ets_users.other_data#user_other.pid});
		true ->
			skip
	end.

start_marry(UserId,Pid,State) ->
	if	UserId =/= State#marry_state.user_id andalso UserId =/= State#marry_state.bride_id->
			skip;
		State#marry_state.status =/= 1 ->
			skip;
		true ->
			Tid = if UserId =:= State#marry_state.user_id -> State#marry_state.bride_id; true -> State#marry_state.user_id end,
			case lib_player:get_player_pid(Tid) of
				[] ->
					skip;
				BridePid ->
					{GX, GY} = ?MARRY_GROOM_POS,
					gen_server:cast(Pid, {current_map_fly, GX, GY}),
					{BX, BY} = ?MARRY_BRIDE_POS,
					gen_server:cast(BridePid, {current_map_fly, BX, BY}),
					NewState = State#marry_state{status = 2, start_time = misc_timer:now_seconds()},
					{ok, Bin} = pt_29:write(?PP_MARRY_HALL_INFO, [NewState#marry_state.user_id,NewState#marry_state.bride_id,
													NewState#marry_state.start_time,NewState#marry_state.status,NewState#marry_state.free_candy,
													NewState#marry_state.groom_name,NewState#marry_state.bride_name]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, Bin),
					NewState
			end
	end.
%% 时间到了强制开始拜堂
start_marry_timing(State) ->
	if	State#marry_state.status =:= 1 ->
			start_marry_timing1(State);
		true ->
			skip
	end.
%% %结婚说词自动播放
marry_words(State, T) ->
	if	State#marry_state.status =:= 2 andalso T < 7 ->
			erlang:send_after(3000, self(), {marry_words, T + 1}),
			%?DEBUG("marry_words:~p",[T]),
			case T of
				1 ->
					%%播放鲜花
					{ok,Bin1} = pt_14:write(?PP_ROSE_PLAY, [1,"",0,0,"",7,1]),
					lib_send:send_to_all(Bin1),
					Msg = ?GET_TRAN(?_LANG_MARRY_START,[State#marry_state.groom_name, State#marry_state.bride_name]),					
					%lib_chat:chat_sysmsg_roll([Msg]),
					{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,Msg]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, BinData),
					{ok, Bin} = pt_29:write(?PP_START_MARRY, [1]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, Bin);
				2 ->
					{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,?_LANG_MARRY_START1]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, BinData);
				3 ->
					{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,?_LANG_MARRY_START2]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, BinData);
				4 ->
					{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,?_LANG_MARRY_START3]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, BinData);
				5 ->					
					after_marry_fly(State),
					{ok,BinData} = pt_16:write(?PP_SYS_MESS,[?ROLL,?None,?ORANGE,?_LANG_MARRY_START4]),
					mod_map_agent:send_to_scene(State#marry_state.map_only_id, BinData),
					Msg = ?GET_TRAN(?_LANG_MARRY_START5,[State#marry_state.groom_name, State#marry_state.bride_name]),
					lib_chat:chat_sysmsg_roll([Msg]);				
				6 ->
					gen_server:cast(self(), {send_marry_box})
			end;
		true ->
			skip
	end.

send_marry_box(State) ->
	PosList = get_candy_pos_list(50,[]),
	gen_server:cast(State#marry_state.map_pid,{create_collect_pos, ?MARRY_BOX_ID , PosList}).

shut_down(State) ->
	if	State#marry_state.status =:= 2 ->
			%{ok,Bin} = pt_29:write(?PP_MARRY_FINISH, [1]),
			%mod_map_agent:send_to_scene(State#marry_state.map_only_id, Bin),
			send_gift_by_mail(State),%发送礼金到新郎邮箱
			erlang:send_after(1, self() , {shut_down}),
			State#marry_state{status = 3};
		State#marry_state.status =:= 3 ->
			if	State#marry_state.user_list =:= [] ->
					lib_pvp_duplicate:clear_duplicate_and_map(State#marry_state.map_pid),
					stop;
				true ->
					kick_out(State#marry_state.user_list, []),
					erlang:send_after(10, self() , {shut_down}),
					State#marry_state{user_list = []}
			end;			
		true ->
			State
	end.
award_exp(State) ->
	if	State#marry_state.status =/= 3 ->
			erlang:send_after(60000, self() , {award_exp}),
			F = fun(Info) ->
					{_,Pid} = Info,
					gen_server:cast(Pid, {guild_weal, State#marry_state.award_exp})%利用已有的帮会福利来增加exp
				end,
			lists:foreach(F, State#marry_state.user_list);
		true ->
			skip
	end.

kick_out([], List) -> List;
kick_out([H|T], List) ->
	{_, Pid} = H,
	case misc:is_process_alive(Pid) of
		true ->
			gen_server:cast(Pid, {quit_hall, marry_finsh}),
			kick_out(T, [H|List]);
		false ->
			kick_out(T, List)
	end.

off_line(Id, State) ->
	NewList = lists:keydelete(Id, 1, State#marry_state.user_list),
	State#marry_state{user_list = NewList}.

send_gift_by_mail(State) ->
	{Yuanbao,Copper} = add_gift(State#marry_state.gift_list,{0,0}),
	N = length(State#marry_state.gift_list),
	Str = ?GET_TRAN(?_LANG_MAIL_MARRY_GIFT_CONTENT,[N,Yuanbao,Copper]),
	lib_mail:send_sys_mail(?_LANG_MAIL_MARRY_GIFT_SENDER, 0, State#marry_state.groom_name,
									 State#marry_state.user_id, [], ?Mail_Type_GM, ?_LANG_MAIL_MARRY_GIFT_TITLE, Str, Copper, 0, Yuanbao, 0).
add_gift([],{Yuanbao,Copper}) -> {Yuanbao,Copper};
add_gift([H|L],{Yuanbao,Copper}) ->
	add_gift(L,{H#marry_gift.yuan_bao + Yuanbao, + H#marry_gift.copper + Copper}).

	

%%
%% Local Functions
%%
create_marry_map(MapId) ->
	UniqueId = mod_increase:get_duplicate_auto_id(),
	Id = lib_map:create_copy_id(MapId, UniqueId),
	ProcessName = misc:create_process_name(duplicate_p, [Id, 0]),
	misc:register(global, ProcessName, self()),
	{Map_pid, _} = mod_map:get_scene_pid(Id, undefined, undefined),
	gen_server:cast(Map_pid, {'set_dup_pid', self()}),
	{Map_pid,Id}.

quit_hall1(PlayerStatus) ->
	mod_map:leave_scene(PlayerStatus#ets_users.id,
								PlayerStatus#ets_users.other_data#user_other.pet_id,
								PlayerStatus#ets_users.current_map_id,
								PlayerStatus#ets_users.other_data#user_other.pid_map, 
						        PlayerStatus#ets_users.pos_x,
						        PlayerStatus#ets_users.pos_y,
						        PlayerStatus#ets_users.other_data#user_other.pid,
						        PlayerStatus#ets_users.other_data#user_other.pid_locked_monster),
			{OldMapId,OldX,OldY} = case PlayerStatus#ets_users.old_map_id of
						0 ->
							?MAIN_CITY;
						_ ->
							{PlayerStatus#ets_users.old_map_id,PlayerStatus#ets_users.old_pos_x,PlayerStatus#ets_users.old_pos_y}
			end,
			Other = PlayerStatus#ets_users.other_data#user_other{walk_path_bin=undefined,
																 pid_map = undefined,
														 		pid_dungeon=undefined,
														 		map_template_id = OldMapId,
														 		duplicate_id = 0,
														 		war_state = 0},
			
			NewStatus = PlayerStatus#ets_users{current_map_id=OldMapId,
											   pos_x=OldX,
									           pos_y=OldY,
									           other_data=Other},			
			%?DEBUG("map info:~p",[{NewStatus#ets_users.current_map_id, NewStatus#ets_users.pos_x, NewStatus#ets_users.pos_y}]),
			{ok, EnterData} = pt_12:write(?PP_MAP_ENTER, [NewStatus#ets_users.current_map_id, NewStatus#ets_users.pos_x, NewStatus#ets_users.pos_y]),
	        lib_send:send_to_sid(NewStatus#ets_users.other_data#user_other.pid_send, EnterData),
			
	        NewStatus.
%%拜堂结束后飞到指定点
after_marry_fly(State) ->
	case lib_player:get_player_pid(State#marry_state.user_id) of
		[] -> skip;
		Pid ->
			{GX, GY} = ?MARRY_GROOM_RETURN_POS,
			gen_server:cast(Pid, {current_map_fly, GX, GY})
	end,
	case lib_player:get_player_pid(State#marry_state.bride_id) of
		[] -> skip;
		Pid1 ->
			{BX, BY} = ?MARRY_BRIDE_RETURN_POS,
			gen_server:cast(Pid1, {current_map_fly, BX, BY})
	end.

start_marry_timing1(State) ->
	case lib_player:get_player_pid(State#marry_state.user_id) of
		[] ->
			skip;
		GroomPid ->
			{GX, GY} = ?MARRY_GROOM_POS,
			gen_server:cast(GroomPid, {current_map_fly, GX, GY})
	end,
	case lib_player:get_player_pid(State#marry_state.bride_id) of
		[] ->
			skip;
		BridePid ->
			{BX, BY} = ?MARRY_BRIDE_POS,
			gen_server:cast(BridePid, {current_map_fly, BX, BY})
	end,
	NewState = State#marry_state{status = 2, start_time = misc_timer:now_seconds()},
	{ok, Bin} = pt_29:write(?PP_MARRY_HALL_INFO, [NewState#marry_state.user_id,NewState#marry_state.bride_id,
													NewState#marry_state.start_time,NewState#marry_state.status,NewState#marry_state.free_candy,
													NewState#marry_state.groom_name,NewState#marry_state.bride_name]),
	mod_map_agent:send_to_scene(NewState#marry_state.map_only_id, Bin).

get_candy_pos_list(0,List) -> List;
get_candy_pos_list(N,List) ->
	Pos = util:rand(1, 622),
	P = lists:nth(Pos, ?MARRY_CANDY_POS_LIST),
	get_candy_pos_list(N - 1,[P|List]).
	

write_gift_list([],Bin) -> Bin;
write_gift_list([H|T],Bin) ->
	Name = pt:write_string(H#marry_gift.nick_name),
	Data = <<Name/binary,
			(H#marry_gift.copper):32,
			(H#marry_gift.yuan_bao):32,
			(H#marry_gift.state):8>>,
	write_gift_list(T,<<Bin/binary,Data/binary>>).