%%%--------------------------------------
%%% @Module  : lib_account
%%% @Author  : ygzj
%%% @Created : 2010.10.05
%%% @Description:用户账户处理
%%%--------------------------------------
-module(lib_account).


-include("common.hrl").
-define(INIT_BAG_CELL, 36).
-define(INITDEPOTMAXNUM, 36).

-define(INIT_YUAN_BAO, 0).		%% 元宝
-define(INIT_BIND_YUAN_BAO, 0).
-define(INIT_COPPER, 0).
-define(INIT_BIND_COPPER, 0). 

-export(
    [
	 is_valid/5,
	 check_account/3,
	 create_role/6,
	 get_role_list/3,
	 get_info_by_id/1,
	 get_info_by_user/1,
	 validate_name/1,
	 check_forbid/1,
	 is_vip/1
    ]
).

is_vip(List) ->
	F = fun([_UserID, _Username, _Nickname, _Sex, _Level, Vip_id], _) ->
				if Vip_id > 0 ->
					   true;
				   true ->
					   false
				end
		end,
	IsVip = lists:foldr(F, false , List),
	IsVip.


is_valid(UserName, Site, Server_id, Tick, Sign) ->
	try is_bad_pass(UserName, Site, Server_id, Tick, Sign) of
        true ->  
			{NewSite,LoginData} = is_valid1(Site,Tick),
			{true, NewSite,LoginData};
        _ -> 
			case config:get_strict_md5() of
				1 -> 
					false;
				_ -> 
					{NewSite,LoginData} = is_valid1(Site,Tick),
					{true, NewSite,LoginData}
			end
    catch
        ERROR:REASON ->
		?WARNING_MSG("is_valid:~w,~w",[ERROR,REASON]),
		false
    end.

is_valid1(Site,Tick) ->
	if
		Site =:=  [] ->
			NewSite = config:get_login_site();
		true -> 
			NewSite = Site
	end,
	Info = string:tokens(Tick, "|"),
	if
		length(Info) =:= 6 ->
			[Time,IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant] = Info;
		true ->
			[Time,IsYellowVip,IsYellowYearVip,YellowVipLevel,IsYellowHighvip,Infant] = [0,0,0,0,0,0]
	end,
	{NewSite,[list_to_integer(Time),list_to_integer(IsYellowVip),list_to_integer(IsYellowYearVip),list_to_integer(YellowVipLevel),list_to_integer(IsYellowHighvip),list_to_integer(Infant)]}.
	

%%通行证验证
is_bad_pass(UserName, Site, Server_id, Tick, Sign) ->	
	TickList = tool:to_list(Tick),
	AppTicket = config:get_ticket(),
	ServerId = tool:to_list(Server_id),
	Md5 = UserName ++ Site ++ ServerId ++ TickList ++ AppTicket  ,
    Hex = util:md5(Md5),
    Hex == Sign.

%% 检查账号是否存在
check_account(Site, UserName, UserID) ->
    case db_agent:get_site_and_username_by_userid(UserID) of
        [] ->
            false;
        [UserName1, Site1] ->
			case UserName1 =:= tool:to_binary(UserName) andalso Site1 =:= tool:to_binary(Site) of
                true ->
                    true;
                false ->
                    false
            end
    end.

check_forbid(UserID) ->
	case db_agent:get_forbid_state(UserID) of
        [0, ForBid_Date] ->
			Now = misc_timer:now_seconds(),
			if
				Now > ForBid_Date ->
					db_agent_user:delete_forbid_status_by_id(UserID),
					true;
				true ->
					false
            end;
		_ ->
			true
    end.

check_career(Career) ->
	case Career of
		?CAREER_YUEWANG ->
			{Career, lib_map:return_career_born(Career)};
		?CAREER_HUAJIAN ->
			{Career, lib_map:return_career_born(Career)};
		?CAREER_TANGMEN ->
			{Career, lib_map:return_career_born(Career)};
		_ ->
			{?CAREER_YUEWANG , lib_map:return_career_born(?CAREER_YUEWANG)}
	end.
			

create_role(Site, Sever_id, User_Name, Nick_Name, Sex, Career) ->	
 	{NewCareer, {Current_Map_ID, Pos_X, Pos_Y}} = check_career(Career),	   
%% 	LifeExperiences = 10000,
	New = misc_timer:now_seconds(),
	User = #ets_users{	
      id = 0,                            %% 用户id	
	  server_id = Sever_id,					%% 服务器编号
      user_name = User_Name,                         %% 用户名	
      nick_name = Nick_Name,                         %% 用户昵称	
      sex = Sex,                                %% 性别	
      exp = 0,                                %% 经验	
	  style_bin = ?STYLE_DEFAULT,			  %% 样式
      level = 1,                              %% 等级	
      current_map_id = Current_Map_ID,                     %% 当前地图	
      pos_x = Pos_X,                              %% 当前坐标X	
      pos_y = Pos_Y,                              %% 当前坐标y	
      state = 0,                              %% 玩家状态1在线，0不在线,	
      online_time = 0,                        %% 在线时间	
      club_id = 0,                            %% 公会id	
      ban_chat = 1,                           %% 是否禁言	 1可以发言 0禁止
      ban_chat_date = 0,                      %% 禁言时间	
      forbid = 1,                             %% 禁止登陆	
      forbid_date = 0,                        %% 禁止登陆时间	
      forbid_reason = "",                     %% 禁止原因	
      ip = "",                                %% 登陆IP	
      site = Site,                            %% 站点	
      is_exist = 1,                           %% 是否存在	
      camp = 0,                               %% 阵营	
      career = NewCareer,                        %% 职业	
      current_hp = 0,                         %% 当前hp	
      current_mp = 0,                         %% 当前mp	
%%       total_hp = 0,                           %% 总HP	
%%       total_mp = 0,                           %% 总mp	
      current_club_contribute = 0,            %% 当前公会捐献	
%%       attack = 0,                             %% 攻击	
%%       defense = 0,                            %% 防御	
%%       hit_target = 0,                         %% 命中率	
%%       duck = 0,                               %% 回避率	
%%       keep_off = 0,                           %% 格挡	
%%       power_hit = 0,                          %% 致命一击	
%%       deligency = 0,                          %% 坚韧	
%%       magic_hurt = 0,                         %% 魔法伤害	
%%       magic_defense = 0,                      %% 魔法防御	
%%       magic_avoid_in_hurt = 0,                %% 魔法免伤	
%%       far_hurt = 0,                           %% 远程伤害	
%%       far_defense = 0,                        %% 远程防御	
%%       far_avoid_in_hurt = 0,                  %% 远程免伤	
%%       mump_hurt = 0,                          %% 斗气伤害	
%%       mump_defense = 0,                       %% 斗气防御	
%%       mump_avoid_in_hurt = 0,                 %% 斗气免伤	
      god_repute = 0,                         %% 神界声望	
      ghost_repute = 0,                       %% 魔界声望	
      honor = 0,                              %% 荣誉	
      pk_value = 0,                           %% pk值	
      title = 0,                              %% 称号	
      current_exp = 0,                        %% 当前经验	
      total_club_contribute = 0,              %% 总公会捐献	
%%       hp_revert = 0,                          %% HP恢复	
%%       mp_revert = 0,                          %% mp恢复	
%%       except_rate = 0,                        %% 异常状态几率	
%%       defense_except_rate = 0,                %% 异常状态防御率	
      fit_equip_type = 0,                     %% 可装备盔甲类型	
      fit_weapon_type = 0,                    %% 可装武器类型	
      current_physical = 0,                   %% 当前体力	
%%       max_physical = 0,                       %% 最大体力	
      current_energy = 0,                     %% 当前精力	
%%       max_energy = 0,                         %% 最大精力	
      especial_status = 0,                    %% 特殊状态	
	  depot_max_number = ?INITDEPOTMAXNUM,    %% 仓库最大格子
      bag_max_count = ?INIT_BAG_CELL,         %% 背包最大格子	
      yuan_bao = ?INIT_YUAN_BAO,              %% 元宝	
	  bind_yuan_bao = ?INIT_BIND_YUAN_BAO, 		  %% 绑定元宝
      copper = ?INIT_COPPER,             %% 铜币	
      bind_copper = ?INIT_BIND_COPPER,                        %% 绑定铜币	
      client_config = 0,                      %% 客户端配置	
%%       attack_suppression = 0,                 %% 进攻压制	
%%       defense_suppression = 0,                %% 防御压制	
%%       abnormal_rate = 0,                      %% 异常状态几率	
%%       anti_abnormal_rate = 0,                 %% 抵抗异常状态几率	
      team_id = 0,                            %% 队伍ID	
      life_experiences = 0,                   %% 历练	
%%       total_life_experiences = 0,             %% 总历练	
      other_career_skill = 0,                  %% 其它职业技能	
	  register_date = New,	%%注册时间
	  last_online_date = New
    },
	%%Res: 1可以插入  else 插入出错
	case config:get_nick_insert_site() of
		[] ->
			Res = 1;
		Insert_Site ->
			Nick = http_lib:url_decode(tool:to_list(Nick_Name)),
			Address = Insert_Site ++ "?nick_name=" ++ Nick ++ "&site=" ++ Site ++ "&server_id=" ++ config:get_server_no(),
			Res = tool:to_integer(misc:get_http_content(Address))
	end,
	if
		Res =:= 1 ->
			case db_agent:create_role(User) of
				{mongo, _Id} ->
					false;
				1 ->
					Id = lib_player:get_role_id_by_name(Nick_Name),
					db_agent_admin:insert_register(Id, Nick_Name, User_Name, Sex, NewCareer, Site),
					{true, Id};
				_Other ->
					false
			end;
		true ->
			is_exist
	end.

%% 取得指定帐号的角色列表
get_role_list(UserName, Server_id, Site) ->
	db_agent:get_role_list(UserName, Server_id, Site).


%% 通过帐号名称取得帐号信息
get_info_by_id(UserId) ->
	db_agent:get_info_by_id(UserId).

get_info_by_user(UserName) ->
	db_agent:get_info_by_user(UserName).
			
%% 角色名合法性检测
validate_name(Name) ->
	validate_name(len, Name).

%% 角色名合法性检测:长度
validate_name(len, Name) ->
	case asn1rt:utf8_binary_to_list(list_to_binary(Name)) of
		{ok, CharList} ->
			Len = misc:string_width(CharList),   
			if
				Len < 4 ->
					{false, ?_LANG_ACCOUNT_CREATE_TOO_SHORT};
				Len > 14 ->
					{false, ?_LANG_ACCOUNT_CREATE_TOO_LONG};
				true ->
					case misc:name_ver(CharList) of
						true ->
                    		validate_name(existed, Name);
						_ ->
							{false, ?_LANG_ACCOUNT_CREATE_NOT_VALID}
					end
			end;
		{error, _Reason} ->
            %%非法字符
			{false, ?_LANG_ACCOUNT_CREATE_NOT_VALID}
	end; 

%%判断角色名是否已经存在
%%Name:角色名
validate_name(existed, Name) ->
	case lib_player:is_exists_name(Name) of
		true ->
			%角色名称已经被使用
			{false, ?_LANG_ACCOUNT_CREATE_IS_EXIST};    
		false ->
			validate_name(sen_words, Name)
	end;
	

%%是否包含敏感词
%%Name:角色名
validate_name(sen_words, Name) ->
    case lib_words_ver:words_ver(Name) of
        true ->
			true;  
        false ->
            %包含敏感词
            {false, ?_LANG_ACCOUNT_CREATE_NOT_VALID} 
    end;

validate_name(_, _Name) ->
    {false, 2}.



