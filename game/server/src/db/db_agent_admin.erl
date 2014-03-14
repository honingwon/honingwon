%%%-------------------------------------------------------------------
%%% Module  : db_agent_admin
%%% Author  : 
%%% Description : 统一的数据库处理模块
%%%-------------------------------------------------------------------
-module(db_agent_admin).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").


-define(DIC_TASKS_LOG, dic_tasks_log). %% 任务日志字典
%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([init_db/0,
		 insert_online/7,
		 insert_complain_info/9,
		 insert_register/6,
		 admin_send_gif/1,
		 insert_login_in_out/6,
		 create_mysql_connect/1,
		 get_all_mapid/0,
		 insert_task_log/2,
		 insert_compose_log/2,
		 insert_strength_log/2,
		 insert_hole_log/4,
		 insert_enchase_log/2,
		 insert_rebuild_log/2,
		 insert_pk_log/1,
		 get_user_pay/2,
		 get_user_pay_by_server_id/3,
		 update_user_pay/1,
		 insert_consume_yuanbao_log/1,
		 insert_consume_copper_log/1,
		 insert_trade_log/1,
		 insert_item_log/2,
		 insert_magic_log/1,
		 get_pay_info/1,
		 get_mult_by_id/1,
		 get_all_multexp/0,
		 get_sys_msg/0,
		 del_sys_msg/1,
		 insert_sys_msg/7
		]).

%%############数据库初始化##############
%% 数据库连接初始化
init_db() ->
	if 
		?DB_MODULE =:= db_mysql ->
    		init_mysql_admin();
		true ->
			init_mongo(),%%加载主数据库
			init_slave_mongo()  %%加载从数据库		   
	end,	
	ok.

%% mysql数据库连接初始化
init_mysql_admin() ->
	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_admin_config),
    mysql:start_link(mysql_admin_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, fun(_, _, _, _) -> ok end, Encode), %%fun(_, _, _, _) -> ok end

	Count = 5,
	LTemp =
    case Count > 1 of
        true ->
            lists:duplicate(Count, dummy);
        _ ->
            [dummy]
    end,

    % 启动conn pool
    [begin
		   mysql:connect(mysql_admin_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true)
    end || _ <- LTemp],
	
	misc:write_system_info({self(), mysql_admin}, mysql_admin, {Host, Port, User, DB, Encode}),
	
%% 	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_admin_config),
%% 	mysql:start_link(mysql_admin_dispatcher, ?DB_POOL, Host, Port, User, Password, DB,  fun(_, _, _, _) -> ok end, Encode),
%% 	mysql:connect(mysql_admin_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true),
%%  	misc:write_system_info({self(), mysql_admin}, mysql_admin, {Host, Port, User, DB, Encode}),
	ok.

create_mysql_connect(Count) ->
	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_admin_config),
	LTemp =
    case Count > 1 of
        true ->
            lists:duplicate(Count, dummy);
        false ->
            [dummy]
    end,

    % 启动conn pool
    [begin
		   {ok, _ConnPid} = mysql:connect(mysql_admin_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true)
    end || _ <- LTemp],
	ok.


%% monogo数据库连接初始化
init_mongo() ->
	try
		[PoolId, Host, Port, DB, EmongoSize] = config:get_mongo_config(),
		emongo_sup:start_link(),
		emongo_app:initialize_pools([PoolId, Host, Port, DB, EmongoSize]),
		misc:write_system_info({self(),mongo}, mongo, {PoolId, Host, Port, DB, EmongoSize}),
		ok
	catch
		_:_ -> mongo_config_error
	end.

%% monogo数据库连接初始化
init_slave_mongo() ->
	try 
		[PoolId, Host, Port, DB, EmongoSize] = config:get_slave_mongo_config(),
		emongo_sup:start_link(),
		emongo_app:initialize_pools([PoolId, Host, Port, DB, EmongoSize]),
		misc:write_system_info({self(),mongo_slave}, mongo_slave, {PoolId, Host, Port, DB, EmongoSize}),
		ok
	catch
		_:_ -> init_mongo()%%没有配置从数据库就调用主数据库
	end.

%% %%====================================================================
%% %% External functions
%% %%====================================================================
%%添加在线人数记录
insert_online(TotalCount, LinuxNow, Y, Month, D, H, Minute) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_online, [online, log_time, year, month, day, hour, min],
					  [TotalCount, LinuxNow, Y, Month, D, H, Minute]).

%%添加注册记录
insert_register(Id, Nick_Name, User_Name, Sex, NewCareer, Site) ->
	LinuxNow = misc_timer:now_seconds(),
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_register, [role_id, role_name, account_name, create_time, role_sex, role_job, site],
					  [Id, Nick_Name, User_Name, LinuxNow, Sex, NewCareer, Site]).

%%添加玩家投诉，建议信息
insert_complain_info(IP, User_id, Account_name, Nick_name, Level, Mtime, Mtype, Mtitle, Content) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_all_complaint, 
					  [agent, server_id, ip, user_id, account_name, user_name, level, mtime, mtype, mtitle, content],
					  [1, config:get_server_no(), IP, User_id, Account_name, Nick_name, Level, Mtime, Mtype, Mtitle, Content]).

%%添加玩家登入登出数据
insert_login_in_out(UserID, Login_time, Total_pay, Login_IP, Career, Level) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_in_out, 
					  [role_id, login_time, logout_time, online_time, total_pay, last_login_ip, career, level],
					  [UserID, Login_time, misc_timer:now_seconds(), misc_timer:now_seconds() - Login_time,
					    Total_pay, Login_IP, Career, Level]).

%%添加玩家任务数据
insert_task_log(Info, Time) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_task, 
					  [task_id, task_type, status, utime, count],
					  [Info#task_log.task_id, Info#task_log.task_type, Info#task_log.task_state, Time, Info#task_log.count]).

%%添加玩家合成数据
insert_compose_log(Info, Time) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_compose, 
					  [stone_level, count, success_count, stone_count, compose_count, utime],
					  [Info#compose_log.compose_level, Info#compose_log.count, Info#compose_log.success_count, 
					   Info#compose_log.stone_count, Info#compose_log.compose_count,Time]).

%%添加玩家强化数据
insert_strength_log(Info, Time) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_strengthen, 
					  [user_id, level, is_success, luck_num, is_protect, utime, strengthen_level],
					  [Info#strength_log.user_id, Info#strength_log.level, Info#strength_log.is_success, 
					   Info#strength_log.luck_num, Info#strength_log.is_protect, Time, Info#strength_log.strength_level]).

insert_hole_log(UserID, Level, HoleNum, IsSuccess) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_hole, 
					  [user_id, level, is_success, hole_num, utime],
					  [UserID, Level, IsSuccess, HoleNum, misc_timer:now_seconds()]).

%%添加玩家镶嵌数据
insert_enchase_log(Info, Time) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_enchase, 
					  [user_id, type, hole_num, category_id, stone_id, level, utime],
					  [Info#enchase_log.user_id, Info#enchase_log.type, Info#enchase_log.hole_num, 
					   Info#enchase_log.category_id, Info#enchase_log.stone_id, Info#enchase_log.level, Time]).

%%添加玩家洗练数据
insert_rebuild_log(Info, Time) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_rebuild, 
					  [quality, attribute_num, count, one_star, two_star, three_star, four_star, five_star, utime],
					  [Info#rebuild_log.quality, Info#rebuild_log.attribute_num, Info#rebuild_log.count, 
					   Info#rebuild_log.one_star, Info#rebuild_log.two_star, Info#rebuild_log.three_star, 
					   Info#rebuild_log.four_star, Info#rebuild_log.five_star, Time]).

%%添加玩家PK数据
insert_pk_log(Info) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_pk, 
					  [killer_id, killer_level, killer_pk, dead_id, dead_level, utime, drops],
					  [Info#pk_log.killer_id, Info#pk_log.killer_level, Info#pk_log.killer_pk, 
					   Info#pk_log.dead_id, Info#pk_log.dead_level,
					   Info#pk_log.utime, Info#pk_log.drops]).

%%添加玩家元宝数据
insert_consume_yuanbao_log(Info) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_yuanbao, 
					  [user_id, yuanbao, bind_yuanbao, is_consume, type, utime, template_id, amount, level],
					  [Info#consume_yuanbao_log.user_id, Info#consume_yuanbao_log.yuanbao, Info#consume_yuanbao_log.bind_yuanbao, 
					   Info#consume_yuanbao_log.is_consume, Info#consume_yuanbao_log.type, Info#consume_yuanbao_log.utime,
					   Info#consume_yuanbao_log.template_id, Info#consume_yuanbao_log.amount, Info#consume_yuanbao_log.level]).
%%添加玩家铜币数据
insert_consume_copper_log(Info) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_copper, 
					  [user_id, copper, bind_copper, type, utime, template_id, amount, level],
					  [Info#consume_copper_log.user_id, Info#consume_copper_log.copper, Info#consume_copper_log.bind_copper, 
					   Info#consume_copper_log.type, Info#consume_copper_log.utime, Info#consume_copper_log.template_id,
					   Info#consume_copper_log.amount, Info#consume_copper_log.level]).	

%%添加直接交易数据
insert_trade_log(Info) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_trade, 
					  [first_trade_id, first_trade_copper, first_trade_items, second_trade_id, 
					   second_trade_copper, second_trade_items, trade_date],
					  [Info#trade_log.first_trade_id,Info#trade_log.first_trade_copper,	Info#trade_log.first_trade_items,
					   Info#trade_log.second_trade_id,Info#trade_log.second_trade_copper, Info#trade_log.second_trade_items,					
					   Info#trade_log.trade_date]).

%%添加物品日志
insert_item_log(Info, _Time) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_items, 
					  [user_id,item_id,template_id,type,amount,usenum,time,level],
					  [Info#item_log.user_id,Info#item_log.item_id, Info#item_log.template_id, Info#item_log.type,
						Info#item_log.amount,Info#item_log.usenum,Info#item_log.time,Info#item_log.level]).

%%添加魔法箱子日志
insert_magic_log(Info) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_log_magic, 
					  [user_id,count, type, template_id, amount, utime],
					  [Info#magic_log.user_id,Info#magic_log.count,Info#magic_log.type, Info#magic_log.template_id,
					    Info#magic_log.amount,Info#magic_log.utime]).
%%添加公告
insert_sys_msg(ID,MsgType, SendType, StartTime, EndTime, Interval, Content) ->
	?DB_MODULE:insert(mysql_admin_dispatcher, t_sys_msg, [id,msg_type, send_type, start_time, end_time, interval, content,edit_time],
					  [ID,MsgType, SendType, StartTime, EndTime, Interval, Content,misc_timer:now_seconds()]).




%%后台发送物品
admin_send_gif(Gif_id) ->
	Ret = ?DB_MODULE:select_row(mysql_admin_dispatcher, t_user_gift,
								"user_id, nick_name, content,copper, bind_copper, 
								 yuanbao, bind_yuanbao", [{apply_id, Gif_id}]),
	case Ret of 
		[] ->
			[];
		_ -> 
			[User_id, Nick_name, Content, Copper, Bind_Copper, YuanBao, Bind_YuanBao] = Ret,
			ItemInfo = ?DB_MODULE:select_all(mysql_admin_dispatcher, t_user_gift_item,
								"template_id, amount, strength_level, is_bind", [{gift_id, Gif_id}]),
		    F = fun(Info, ItemList) ->
						[Template_id, Amount, Strength_level, Is_Bind] = Info,
						Template = data_agent:item_template_get(Template_id),
						Item = item_util:create_new_item(Template, Amount, -100, tool:to_integer(User_id), Is_Bind, Strength_level),
						NewItem = item_util:add_item_and_get_id(Item),
						[NewItem|ItemList]
				end,
			ItemList = lists:foldl(F, [], ItemInfo),
			[binary_to_list(Nick_name), tool:to_integer(User_id), ItemList, binary_to_list(Content), Copper, Bind_Copper, YuanBao, Bind_YuanBao]		
	end.

%%获取所有地图ID
get_all_mapid() ->
	?DB_MODULE:select_all(t_map_template, "map_id", []).

get_user_pay(Site, UserName) ->
	?DB_MODULE:select_all(mysql_admin_dispatcher, t_user_pay_qq,
								"id, pay_itemid,pay_item_num,pay_gold,pay_coins", [{account_name, UserName},{site, Site},{is_pay, 0}]).

get_user_pay_by_server_id(Site, UserName, ServerId) ->
	?DB_MODULE:select_all(mysql_admin_dispatcher, t_user_pay_qq,
								"id, pay_itemid,pay_item_num,pay_gold,pay_coins", [{account_name, UserName},{site, Site},{providetype, ServerId},{is_pay, 0}]).

get_pay_info(UserId) ->
	?DB_MODULE:select_all(mysql_admin_dispatcher, t_user_pay_qq, "id", [{role_id, UserId}]).

get_mult_by_id(ID) ->
	?DB_MODULE:select_row(mysql_admin_dispatcher, t_multexp_rate,
						  "mult_rate, begin_date, end_date, begin_time, end_time", [{id, ID}]).

get_all_multexp() ->
	?DB_MODULE:select_all(mysql_admin_dispatcher, t_multexp_rate,
								"id, mult_rate, begin_date, end_date, begin_time, end_time", [{end_date, ">", misc_timer:now_seconds()},{is_stop, 0}]).
%% 获得公告
get_sys_msg() ->
	?DB_MODULE:select_all(mysql_admin_dispatcher, t_sys_msg,"*", [{send_type,2},{end_time,">",misc_timer:now_seconds()}]).

%% 删除公告
del_sys_msg(ID) ->
	?DB_MODULE:delete(mysql_admin_dispatcher, t_sys_msg, [{id,ID}]).

%%更新玩家充值信息
update_user_pay(Pay_id) ->
		?DB_MODULE:update(mysql_admin_dispatcher, t_user_pay_qq,
					  [{is_pay, 1}],[{id, Pay_id}]).
 
 
 



	










