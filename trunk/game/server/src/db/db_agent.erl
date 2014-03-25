%%%-------------------------------------------------------------------
%%% Module  : db_agent

%%% Author  : 
%%% Description : 统一的数据库处理模块
%%%-------------------------------------------------------------------
-module(db_agent).

%%--------------------------------------------------------------------
%% Include files
%%--------------------------------------------------------------------
-include("common.hrl").

%%-define(Macro, value).
%%-record(state, {}).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([init_db/0,
		 create_role/1, 
		 mp_save_user_table/3, 
		 get_role_id_by_name/1, 
		 get_role_ids_by_condition/1,
		 get_role_id_by_userName/2,
		 get_info_by_user/1, 
		 get_info_by_id/1,
		 get_site_and_username_by_userid/1,
		 get_role_list/3,
		 update_current_physical/2,
		 get_nick_by_id/1,
		 get_auto_guest_id/0,
		 create_mysql_connect/1,
		 get_forbid_state/1,
		 get_id_by_username/1,
		 get_activity_by_uid/2,
		 get_activity_by_code/2,
		 get_activity_every_by_uid/1,
		 insert_activity_every_collect/3,
		 update_activity_collect/3,
		 get_activity_collect_award/1,
		 get_activity_res/2,
		 insert_map_player/2
		]).

%%############数据库初始化##############
%% 数据库连接初始化
init_db() ->
	if ?DB_MODULE =:= db_mysql ->
    		init_mysql();
		true ->
			init_mongo(),%%加载主数据库
			init_slave_mongo()  %%加载从数据库		   
	end,	
	ok.

%% mysql数据库连接初始化
init_mysql() ->
	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_config),
    mysql:start_link(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB,fun(_, _, _, _) -> ok end  , Encode), %% fun(_, _, _, _) -> ok end

	Count = 12,
	LTemp =
    case Count > 1 of
        true ->
            lists:duplicate(Count, dummy);
        _ ->
            [dummy]
    end,

    % 启动conn pool
    [begin
		   mysql:connect(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true)
    end || _ <- LTemp],
	
	
	misc:write_system_info({self(), mysql}, mysql, {Host, Port, User, DB, Encode}),
	ok.

create_mysql_connect(Count) ->
	[Host, Port, User, Password, DB, Encode] = config:get_mysql_config(mysql_config),
	LTemp =
    case Count > 1 of
        true ->
            lists:duplicate(Count, dummy);
        false ->
            [dummy]
    end,

    % 启动conn pool
    [begin
		   mysql:connect(mysql_dispatcher, ?DB_POOL, Host, Port, User, Password, DB, Encode, true)
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

%%====================================================================
%% External functions
%%====================================================================
create_role(User) ->
	ValueList = lists:nthtail(2, tuple_to_list(User#ets_users{other_data=''})),
	[id | FieldList] = record_info(fields, ets_users),
	Ret = ?DB_MODULE:insert(t_users, FieldList, ValueList),
	if ?DB_MODULE =:= db_mysql ->
		   Ret;
	   true ->
		   {mongo, Ret}
	end.


%%保存玩家基本信息
mp_save_user_table(UserId, FieldList, ValueList)->
	?DB_MODULE:update(t_users, FieldList, ValueList, "id", UserId).

%% 根据角色名称查找ID
get_role_id_by_name(NickName) ->	
	?DB_MODULE:select_one(t_users, "id", [{nick_name, NickName}], [], [1]).

get_role_ids_by_condition(Where_List) ->
	?DB_MODULE:select_all(t_users, "id,nick_name", Where_List).

%% 根据用户帐号与服务器id查询ID
get_role_id_by_userName(UserName, ServerId) ->
	?DB_MODULE:select_row(t_users, "id,nick_name", [{user_name, UserName},{server_id, ServerId}], [], [1]).

%% 根据id查询角色昵称
get_nick_by_id(Id) ->
	?DB_MODULE:select_one(t_users, "nick_name", [{id, Id}], [], [1]).

 %% 根据用户名查询角色ID
get_id_by_username(Id) ->
	?DB_MODULE:select_one(t_users, "user_name", [{id, Id}], [], [1]).

get_info_by_user(UserName) ->
	?DB_MODULE:select_row(t_users, "*", [{user_name, UserName}], [], [1]).	

%% 通过角色ID取得帐号信息
get_info_by_id(UserID) ->
	?DB_MODULE:select_row(t_users, "*", [{id, UserID}], [], [1]).	
	
%% 通过ID取得帐号和站点
get_site_and_username_by_userid(UserID) ->
	?DB_MODULE:select_row(t_users, "user_name, site", [{id, UserID}], [], [1]).	

%% 取得指定帐号名称的角色列表 
get_role_list(UserName, Server_id, Site) ->	
	Ret = ?DB_MODULE:select_all(t_users, "id, user_name, nick_name, sex, level, vip_id", 
								[{user_name, UserName},{server_id, Server_id},{site, Site}]),
	case Ret of 
		[] ->[];
		_ -> Ret
	end.

%% 取得数据库中游客的最大id，返回null或者结果
get_auto_guest_id() ->
	?DB_MODULE:select_one(t_users,"user_name",[{site,"guest"}],[{id,desc}],[1]).

%%获取是否禁号 1可以登录 0禁止登录
get_forbid_state(UserID) ->
	?DB_MODULE:select_row(t_users, "forbid, forbid_date", [{id, UserID}]).

%%根据用户ID和等级获取礼包
get_activity_by_uid(UId, Level) ->
	?DB_MODULE:select_row(t_user_code_activity, "id, activity_index", [{user_id, UId}, {level, "<=", Level}]).

%%根据激活码获取奖励
get_activity_by_code(Code, Activity_Index) ->
	?DB_MODULE:select_row(t_user_code_activity, "id", [
													   {code, Code}, {activity_index, Activity_Index},
													  {is_used, 1}]).

%%或许用户领取奖励情况
get_activity_every_by_uid(UserID) ->
	?DB_MODULE:select_row(t_user_code_activity, "id", [{user_id, UserID}]).

%%插入奖励领取记录
insert_activity_every_collect(UserID, Now, Activity_Index) ->
	?DB_MODULE:insert(t_user_code_activity, 
					  [user_id, activity_index, collect_date, is_used],
					  [UserID, Activity_Index, Now, 0]).

%%插入地图在线人数
insert_map_player(MapID, Amount) ->
	?DB_MODULE:insert(t_map_players, 
					  [map_id, amount, node, time],
					  [MapID, Amount, node(), misc_timer:now_seconds()]).

%%更新玩家领取信息
update_activity_collect(ID, Now, UserID) ->
	?DB_MODULE:update(t_user_code_activity,
					  [{is_used, 0},{collect_date, Now}, {user_id, UserID}],[{id, ID}]).

%%根据活动序列获取奖励
get_activity_collect_award(Activity_Index) ->
	?DB_MODULE:select_row(t_user_code_activity, "award_id, amount, is_bind", [{activity_index, Activity_Index}]).

%%活动奖励领取查询
get_activity_res(UID, Activity_Index) ->
	?DB_MODULE:select_row(t_user_code_activity, "id", [{user_id, UID}, {activity_index, Activity_Index}, {is_used, 0}]).

%%体力值的修改
update_current_physical(Id,CP) ->
	?DB_MODULE:update(t_users, [{current_physical,CP}],[{id,Id}]).
%%====================================================================
%% Local functions
%%====================================================================


