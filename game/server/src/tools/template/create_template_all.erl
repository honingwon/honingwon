%% Author: Administrator
%% Created: 2011-3-18
%% Description: TODO: Add description to create_template_all
-module(create_template_all).

%%
%% Include files
%%
-include("common.hrl").

-define(CONFIG_FILE, "../config/server.app").

-define(DIR, "templatefile/").

%% 
%%   下面对应的是                 调用模块名称， 生成模板文件名称， 取数据生成模板的数据库表
%% 
-define(TEMPLATE, [
				    {filter_content_list,"FilterContentList",["t_filter_content"]},
				    {nick_template_list,"NickTemplateList",["t_nick_template"]},
					{door_template_list, "DoorTemplateList", ["t_door_template"]},
					{buff_template_list, "BuffTemplateList",["t_buff_template"]},
                    {item_template_list, "ItemTemplateList",["t_item_template"]},
                    {map_template_list, "MapTemplateList",["t_map_template"]},
					{monster_template_list,"MonsterTemplateList",["t_monster_template"]},
                    {movie_template_list, "MovieTemplateList",["t_movie_template"]},
                    {npc_template_list, "NPCTemplateList",["t_npc_template"]},
					{exp_template_list, "ExpTemplateList",["t_exp_template"]},
                    {shop_template_list, "ShopTemplateList",["t_shop_category_template","t_shop_template"]},
                    {skill_template_list,"SkillTemplateList",["t_skill_template"]},
 					{task_template_list,"TaskTemplateList",["t_task_award_template","t_task_state_template","t_task_template"]},
					{title_template_list, "TitleTemplateList",["t_title_template"]},
					{collect_template_list,"CollectTemplateList",["t_collect_template"]},
					{streng_template_list, "StrengTemplateList", ["t_streng_rate_template"]},
					{enchase_template_list, "EnchaseTemplateList", ["t_item_stone_template"]},
					{forge_template_list, "ForgeTemplateList", ["t_formula_name_template"]},
					{formula_template_list, "FormulaTemplateList", ["t_formula_table_template"]},
					{formula_data_template_list, "FormulaDataTemplateList", ["t_formula_template"]},					
					{stone_compose_template_list, "StoneComposeTemplateList", ["t_stone_compose_template"]},
					{hole_template_list, "HoleTemplateList", ["t_hole_template"]},
					{stone_enchase_template_list, "StoneEnchaseTemplateList", ["t_enchase_template"]},
					{streng_copper_template_list, "StrengCopperTemplateList", ["t_streng_copper_template"]},
					{decompose_copper_template_list, "DecomposeCopperTemplateList", ["t_decompose_copper_template"]},					
					{pick_stone_template_list, "PickStoneTemplateList", ["t_pick_stone_template"]},
					{streng_addsuccrate_template_list, "StrengAddsuccrateTemplateList", ["t_streng_addsuccrate_template"]},					
					{decompose_template_list, "DecomposeTemplateList", ["t_decompose_template"]},
					{duplicate_template_list, "DuplicateTemplateList", ["t_duplicate_template"]},
					
					
					{active_bag_template_list, "ActiveBagTemplateInfoList", ["t_active_bag_template"]},
					{active_everyday_template_list, "ActivityEverydayTemplateInfoList", ["t_active_everyday_template"]},
					{active_rewards_template_list, "ActiveRewardsTemplateInfoList", ["t_active_rewards_template"]},
					{active_template_list, "ActiveTemplateInfoList", ["t_active_template"]},
					{active_welfare_template_list, "WelfareTemplateInfoList", ["t_active_welfare_template"]},
					{activity_template_list, "ActivityTemplateInfoList", ["t_activity_template"]},
					{streng_parameters_template_list, "StrengParametersTemplateList", ["t_streng_modulus_template"]},
					{active_boss_template_list, "ActiveBossTemplateList", ["t_boss_activity_template"]},
					{active_task_template_list, "ActiveTaskTemplateList", ["t_task_activity_template"]},

					
					{vip_template_list, "VipTemplateList", ["t_vip_template"]},
					
				    {open_box_template_list, "OpenBoxTemplateList", ["t_open_box_template"]},
					{suit_num_template_list, "SuitNumTemplateList", ["t_suit_num_template"]},
					{suit_props_template_list, "SuitPropsTemplateList", ["t_suit_props_template"]}
				  
%%				  	{shop_discount_template_list, "ShopDiscountTemplateList", ["t_shop_discount_template"]}						  

					]).

%%
%% Exported Functions
%%
-export([
		 start/0,
		 write_string/1,
		 deploy_string/1,
		 create_template/3
		]).

%%
%% API Functions
%%


start()->
	file:make_dir(?DIR),
	io:format("create_template_all is starting...~n"),
	case  get_mysql_config(?CONFIG_FILE) of
		[Host, Port, User, Password, DB, Encode] ->
			start_erlydb(Host, Port, User, Password, DB),
    		mysql:start_link(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode),
    		mysql:connect(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true),
			create_template_all(),
			ok;
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
	try 
		F = fun({Module, FileName, Table}) ->
					io:format("create_template__all success :~w ...~n",[Module]),
					create_template(Module, FileName, Table)
			end,
		lists:foreach(F, ?TEMPLATE)
	catch
		_:Reason ->
			io:format("create_template_all error :~w ...~n",[Reason]),
			io:format("get_stacktrace:~p",[erlang:get_stacktrace()]),
			error
	end.


create_template(Module, FileName, Table) ->
	case get_template_Mul_Table(Table) of
		error ->
			io:format("get_template_list is error:~s",[Table]);
		List ->	
			{_Res, Msg, BinData} = case Module:create(List) of
				{ok, Bin} ->
				Message = lists:concat([Module , " is success."]),
				MsgBin = write_string(Message),
				{ok, Message, <<1:8, MsgBin/binary, Bin/binary>>};
			error ->
				Message = lists:concat([Module , " is fail"]),
				MsgBin = write_string(Message),
				{error, Message, <<0:8, MsgBin/binary>>}
			end,
			io:format("create_template: ~s ~n",[Msg]),
			NewFileName = lists:concat([?DIR, FileName , ".txt"]),
			file:write_file(NewFileName, BinData)
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
		%% 				List
				end
			catch
				_:Reason ->
					io:format("create_template_all error :~w ...~n",[Reason]),
					error
			end
	end
	end,
	lists:foldl(F, [], Tables).

	
%%将字符串转成二进制
write_string(Str) ->
	Bin = tool:to_binary(Str),
    Len = byte_size(Bin),	
	<<Len:16/signed, Bin/binary>>.


deploy_string(Str)->
	 Deploys 	= string:tokens(Str, "|"),
	 DeploysLen = length(Deploys),
		FDeploy =fun(O) ->
			  Values = string:tokens(tool:to_list(O), "$"),
			  ValLen = length(Values),
			  if 
				  ValLen > 0->
					  Type = tool:to_integer( lists:nth(1, Values));
				  
				  true ->
					 Type = 0
			   end,
			  
			  if 
				  ValLen > 1->
					  Descript= lists:nth(2, Values);
				  true ->
					  Descript = ""
			   end,
			  
              if 
				  ValLen > 2->
					  Param1 = tool:to_integer( lists:nth(3, Values));
				  true ->
					  Param1 = 0
			   end,
			  
                 if 
				  ValLen > 3->
					  Param2 = tool:to_integer( lists:nth(4, Values));
				  true ->
					  Param2 = 0
			    end,
			  
               if 
				  ValLen > 4->
					  Param3 = tool:to_integer( lists:nth(5, Values));
				  true ->
					  Param3 = 0
			    end,
			  
                if 
				  ValLen > 5->
					  Param4 = tool:to_integer( lists:nth(6, Values));
				  true ->
					  Param4 = 0
			    end,

			                <<Type:8,
					       (write_string(Descript))/binary,
                            Param1:32/signed,
                            Param2:32/signed,
                            Param3:32/signed,
                            Param4:32/signed>>
			end,
			
	      DeployInfosBin = tool:to_binary([FDeploy(Z)||Z <- Deploys]),
          <<DeploysLen:32/signed,DeployInfosBin/binary>>.
			

%%
%% Local Functions
%%
