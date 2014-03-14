%%%--------------------------------------
%%% @Module  : table_to_record
%%% @Author  : ygzj
%%% @Created : 2010.10.27 
%%% @Description: 
%%%			生成文件： "../temp/common.php
%%%--------------------------------------
-module(item_to_code).

-include("common.hrl").

%%
%% Exported Functions
%%
-compile(export_all). 

-define(CONFIG_FILE, "../config/server.app").

-define(FILENAME, "../temp/config/common.php").

%%
%% API Functions
%%
start()->	
	try
		Res = case  get_mysql_config(?CONFIG_FILE) of
			[Host, Port, User, Password, DB, Encode] ->
				start_erlydb(Host, Port, User, Password, DB),
  		  		mysql:start_link(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode),
 		   		mysql:connect(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true),
	  			item_to_buy_info(),
				ok;
			_ -> mysql_config_fail
		end,
		io:format("Res:~w~n",[Res])
	catch
		_:Reason ->
		io:format("Reason:~w~n",[Reason]),
		error
	end,
  	halt(),
	ok.

get_mysql_config(Config_file)->
	try
		{ok,[{_,_, Conf}]} = file:consult(Config_file),
		{env, L} = lists:keyfind(env, 1, Conf),	
		{_, Mysql_config} = lists:keyfind(mysql_template_config, 1, L),
		{_, Host} = lists:keyfind(host, 1, Mysql_config),
		{_, Port} = lists:keyfind(port, 1, Mysql_config),
		{_, User} = lists:keyfind(user, 1, Mysql_config),
		{_, Password} = lists:keyfind(password, 1, Mysql_config),
		{_, DB} = lists:keyfind(db, 1, Mysql_config),
		{_, Encode} = lists:keyfind(encode, 1, Mysql_config),
		[Host, Port, User, Password, DB, Encode]		
	catch
		_:_ -> no_config
	end.

%%
%% Local Functions
%%
start_erlydb(IP, Port, User, Password, Db) ->
	erlydb:start(mysql, [{pool_id, erlydb_mysql},
						{hostname, IP},
						 {port, Port},
						 {username, User}, 
						 {password, Password}, 
						 {database, Db},
						 {encoding, utf8},
						 {pool_size, 10}]).


%% 物品格式化物品购买信息
item_to_buy_info()->
	Sql = lists:concat(["SELECT 	a.id, a.yuanbao,
	a.price, 
	b.template_id,
	b.name	 
	FROM 
	t_shop_template AS a, t_item_template AS b
	WHERE (a.shop_id = 1) AND a.category_id =7  AND  a.template_id = b.template_id;"]),
	
	Bakfile = re:replace(
		lists:flatten(lists:concat([?FILENAME , "_", time_format(now())])),
		"[ :]","_",[global,{return,list}]),
	
	file:rename(?FILENAME, Bakfile), 
	
	file:write_file(?FILENAME, "<?php\n"),
	file:write_file(?FILENAME, "//------------------------------------------------	\t\n",[append]),
	Bytes = list_to_binary(io_lib:format("// Created : ~s\t\n", [time_format(now())])),
	file:write_file(?FILENAME, Bytes,[append]),
	file:write_file(?FILENAME, "// Description: 根据商店表格式化成QQ购买信息\t\n",[append]),
	file:write_file(?FILENAME, "// Warning:  由程序自动生成，请不要随意修改！\t\n",[append]),	
	file:write_file(?FILENAME, "//------------------------------------------------	\t\n",[append]),
	file:write_file(?FILENAME, "	class common {\t\n",[append]),
	file:write_file(?FILENAME, "		private function __construct()\t\n",[append]),
	file:write_file(?FILENAME, "		{}\t\n",[append]),
	file:write_file(?FILENAME, "		private static $items  = array(  \t\n",[append]),
	try
		case db_mysqlutil:get_all(list_to_binary(Sql)) of 
			[] -> 	error1;
			B ->
				F = fun([ID,Yuanbao,Price,TemplateID,Name],Sum)->
							
						 S = 
							 if
								 Sum == length(B) ->
									 io_lib:format("											~p=>'{\"id\":~w ,\"name\":\"~s\",\"glod\":~w,\"price\":~w,\"url\":\"~w\"}' \t\n",
												  [ID,ID, Name, Yuanbao,Price,TemplateID]);
								 true -> 
									 io_lib:format("											~p=>'{\"id\":~w ,\"name\":\"~s\",\"glod\":~w,\"price\":~w,\"url\":\"~w\"}', \t\n",
												  [ID, ID,Name, Yuanbao,Price,TemplateID])
							 end,
						 {S, Sum+1}
					end,
				{DL,_} = lists:mapfoldl(F, 1, B),
				E = io_lib:format('~s', [lists:flatten(DL)]),
				file:write_file(?FILENAME,
										list_to_binary(io_lib:format("~s\t\n",[E])), 
										[append])								
				
		end
	catch
		_:_ -> fail
	end,
	
	

	file:write_file(?FILENAME, "										   );\t\n",[append]),
	file:write_file(?FILENAME, "		public static function getItemInfo($id)\t\n",[append]),
	file:write_file(?FILENAME, "		{\t\n",[append]),
	file:write_file(?FILENAME, "			return self::$items[$id];\t\n",[append]),
	file:write_file(?FILENAME, "		}\t\n",[append]),
	file:write_file(?FILENAME, "	}\t\n",[append]),
	file:write_file(?FILENAME, "?>\t\n",[append]),
	
	

	io:format("~n~n"),
	
	io:format("finished!~n~n"),	
	ok.
	

%% --------------------------------------------------
%% time format
one_to_two(One) -> io_lib:format("~2..0B", [One]).

%% @doc get the time's seconds for integer type
%% @spec get_seconds(Time) -> integer() 
get_seconds(Time)->
	{_MegaSecs, Secs, _MicroSecs} = Time, 
	Secs.
	
time_format(Now) -> 
	{{Y,M,D},{H,MM,S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", 
						one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).
date_format(Now) ->
	{{Y,M,D},{_H,_MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D)]).
date_hour_format(Now) ->
	{{Y,M,D},{H,_MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", one_to_two(H)]).
date_hour_minute_format(Now) ->
	{{Y,M,D},{H,MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([Y, "-", one_to_two(M), "-", one_to_two(D), " ", one_to_two(H) , "-", one_to_two(MM)]).
%% split by -
minute_second_format(Now) ->
	{{_Y,_M,_D},{H,MM,_S}} = calendar:now_to_local_time(Now),
	lists:concat([one_to_two(H) , "-", one_to_two(MM)]).

hour_minute_second_format(Now) ->
	{{_Y,_M,_D},{H,MM,S}} = calendar:now_to_local_time(Now),
	lists:concat([one_to_two(H) , ":", one_to_two(MM), ":", one_to_two(S)]).	