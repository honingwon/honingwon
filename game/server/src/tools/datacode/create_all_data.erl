%% Author: Administrator
%% Created: 2011-3-18
%% Description: TODO: Add description to create_all_data
-module(create_all_data).
%%
%% Include files
%%
-include("common.hrl").

-define(CONFIG_FILE, "../config/server.app").

-define(DIR, "datafile/").

-define(DataTable, [{exp_data, "data_exp_template", ["t_exp_template"]},
					{shop_data, "data_shop_template", ["t_shop_template"]},		
 					{sit_award_data, "data_sit_award_template", ["t_sit_award_template"]},
 					{streng_rate_data, "data_streng_rate_template", ["t_streng_rate_template"]},
 					{streng_copper_data, "data_streng_copper_template", ["t_streng_copper_template"]},
					
					{skill_data, "data_skill_template", ["t_skill_template"]},
					{vip_data, "data_vip_template", ["t_vip_template"]},
					{active_bag_data, "data_active_bag_template", ["t_active_bag_template"]},
				    {active_everyday_data, "data_active_everyday_template", ["t_active_everyday_template"]},
				    {active_rewards_data, "data_active_rewards_template", ["t_active_rewards_template"]},
					{active_data, "data_active_template", ["t_active_template"]},	
				    {active_welfare_data, "data_active_welfare_template", ["t_active_welfare_template"]},
					{activity_data, "data_activity_template", ["t_activity_template"]},
					{buff_data, "data_buff_template", ["t_buff_template"]},
					{collect_data, "data_collect_template", ["t_collect_template"]},
				    {daily_award_data, "data_daily_award_template", ["t_daily_award_template"]},
				    {decompose_copper_data, "data_decompose_copper_template", ["t_decompose_copper_template"]},
					{door_data, "data_door_template", ["t_door_template"]},
				    {duplicate_item_data, "data_duplicate_item_template", ["t_duplicate_item_template"]},
				    {duplicate_mission_data, "data_duplicate_mission_template", ["t_duplicate_mission_template"]},
				    {duplicate_data, "data_duplicate_template", ["t_duplicate_template"]},
				    {enchase_data, "data_enchase_template", ["t_enchase_template"]},
					{formula_data, "data_formula_template", ["t_formula_template"]},	
				    {formula_table_data, "data_formula_table_template", ["t_formula_table_template"]},	
				    {guilds_data, "data_guilds_template", ["t_guilds_template"]},	
					{hole_data, "data_hole_template", ["t_hole_template"]},
				    {item_category_data, "data_item_category_template", ["t_item_category_template"]},
					{item_stone_data, "data_item_stone_template", ["t_item_stone_template"]},
					{item_data, "data_item_template", ["t_item_template"]},
					{map_data, "data_map_template", ["t_map_template"]},
				    {monster_drop_item_data, "data_monster_drop_item_template", ["t_monster_drop_item_template"]},
				    {monster_item_data, "data_monster_item_template", ["t_monster_item_template"]},
				    {monster_data, "data_monster_template", ["t_monster_template"]},
					{npc_data, "data_npc_template", ["t_npc_template"]},
				    {pets_attr_data, "data_pets_attr_template", ["t_pets_attr_template"]},
				    {pick_stone_data, "data_pick_stone_template", ["t_pick_stone_template"]},
				    {rebuild_prop_data, "data_rebuild_prop_template", ["t_rebuild_prop_template"]},
				    {streng_addsuccrate_data, "data_streng_addsuccrate_template", ["t_streng_addsuccrate_template"]},
					{task_data, "data_task_template", ["t_task_template"]},
					{task_award_data, "data_task_award_template", ["t_task_award_template"]},
					{task_state_data, "data_task_state_template", ["t_task_state_template"]},
					{title_data, "data_title_template", ["t_title_template"]},
					{user_attr_data, "data_user_attr_template", ["t_user_attr_template"]},						
 					{stone_compose_data, "data_stone_compose_template", ["t_stone_compose_template"]}]).

%%
%% Exported Functions
%%
-export([
		 start/0,
		 module_define/3
		]).

%%
%% API Functions
%%
start()->
	file:make_dir(?DIR),
	case  get_mysql_config(?CONFIG_FILE) of
		[Host, Port, User, Password, DB, Encode] ->
			start_erlydb(Host, Port, User, Password, DB),
    		mysql:start_link(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode),
    		mysql:connect(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true),
			create_template_all();
		_ ->
			mysql_config_fail
	end,
%%   	halt(),
	ok.


get_mysql_config(Config_file)->
	try
		{ok,[{_,_, Conf}]} = file:consult(Config_file),
		{env, L} = lists:keyfind(env, 1, Conf),	
		{_, Mysql_config} = lists:keyfind(mysql_config, 1, L),
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


start_erlydb(IP, Port, User, Password, Db) ->
	erlydb:start(mysql, [{pool_id, erlydb_mysql},
						{hostname, IP},
						 {port, Port},
						 {username, User}, 
						 {password, Password}, 
						 {database, Db},
						 {encoding, utf8},
						 {pool_size, 10}]).
	
create_template_all() ->
	?PRINT("create_all_data"),
	try 
		F = fun({Module, FileName, Table}) ->
					?PRINT("create_data_template working :~w ...~n",[Module]),
					create_data(Module, FileName, Table)
			end,
		lists:foreach(F, ?DataTable),
		?PRINT("finish all create data ~n")
	catch
		_:Reason ->
			?PRINT("create_data_template error :~w ...~n",[Reason]),
			?PRINT("get_stacktrace:~p",[erlang:get_stacktrace()]),
			error
	end.


create_data(Moudle, FileName, Table) ->
	case get_template_Mul_Table(Table) of
		error ->
			io:format("get_template_list is error:~s",[Table]);
		List ->	
			ListInfo =  Moudle:create(List),
			NewFileName = lists:concat([?DIR, FileName , ".erl"]),
			file:write_file(NewFileName, ListInfo),
			?PRINT("~w: data_template create success ...~n",[Moudle])
	end.


get_template_Mul_Table(Tables) ->
	F = fun(Table, Acc) ->
				if 
					Acc == error ->
						error;
					true ->
						Sql = lists:concat(["select * from  ", Table]),
						try 
							case  db_mysqlutil:get_all(Sql) of 
								{db_error, _} ->
									error;
								List when is_list(List) ->
									[List|Acc]
							end
						catch
							_:Reason ->
								io:format("create_data_all error :~w ...~n",[Reason]),
								error
						end
				end
		end,
	lists:foldl(F, [], Tables).


%% 生成模块的头部声明
module_define(Module, Function, Descript) ->
    io_lib:format(
    "%%%----------------------------------------------------------------------\n"
    "%%%\n"
    "%%% @author: 盛世遮天\n"
    "%%% @date: ~s\n"
    "%%% @doc: ~s (自动生成，请勿编辑!)\n"
    "%%%\n"
    "%%%----------------------------------------------------------------------\n"
    "-module(~s).\n"
    "\n"
    "%%\n"
    "%% Exported Functions \n"
	"%% \n"
	"-export([~s]).\n"
	"\n",
    [datetime_to_str(erlang:localtime()), Descript, Module, Function]).

	
%% Local Functions
%%

datetime_to_str({{Year, Month, Day}, {Hour, Minute, Second}}) ->
    lists:flatten(
        io_lib:format("~4..0B-~2..0B-~2..0B ~2..0B:~2..0B:~2..0B",
                    [Year, Month, Day, Hour, Minute, Second])).