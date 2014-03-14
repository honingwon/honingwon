{   
    application, server,
    [   
        {description, "This is game server."},   
        {vsn, "1.0a"},   
        {modules, [main]},   
        {registered, [server_sup]},   
        {applications, [kernel, stdlib, sasl]},   
        {mod, {server_app, []}},   
        {start_phases, []},  
  		{env, [   		
 			{mysql_config, 	  [
						{host, "127.0.0.1"},
						{password, "123456"},
						{user, "root"},
						{port, 3306},					
						{db, "sszt_game"},
						{encode, utf8}
				  		]},
			{mysql_template_config, [
						{host, "127.0.0.1"},
						{port, 3306},
						{user, "root"},
						{password, "123456"},
						{db, "sszt_template"},
						{encode, utf8}
				  		]},		
			{mysql_admin_config, [
						{host, "127.0.0.1"},
						{port, 3306},
						{user, "root"},
						{password, "123456"},
						{db, "sszt_admin"},
						{encode, utf8}
				  		]},
			{server_no, "1"},				%% 开服编号(合服情况下可多个，以英文逗号分隔)				 		
			{log_level, 5},				%% 日志输出级别类型
			{http_ips, ["192.168.3.25","192.168.3.23","127.0.0.1"]},				%% HTTP协议的允许客户端IPs
			{base_data_from_db, 1},		%% 基本数据实时读数据库？(1：是，使用ets; 0：否，来自生成的静态文件)
			{can_gmcmd, 1},				%% GM命令启用否 （1：开启; 0: 关闭）
			{strict_md5, 0},			%% 是否需要严格验证 （1：验证; 0: 不验证）
			{infant_ctrl, 0},			%% 防沉迷系统开关 （1：开启; 0: 关闭）
			{infant_post_site, "http://web.4399.com/api/reg/fcm_api.php"},  %%防沉迷提交站点
			{infant_key, "shjdysuwei32*&DSdooiew"},  %%防沉迷验证Key
			{login_site, "sszt"},     %%登录默认站点
			{service_wait_time,0},     %% 延时允许客户端连接时间 (单位：秒)	
			{nick_insert_site, ""},			%%注册帐号插入中心服务器
			{guild_insert_site, ""},		%%创建帮派插入中心服务器
			{test_host, 1},				%% 本机测试
			{test_ip, "192.168.3.25"},	%% 测试IP
			{test_port, 8010},			%% 测试端口
			{ticket,	"qq-zone-710-5000-cm3d"},		%%安全校验
			{service_start_time, {{2013, 8, 5}, {11, 0, 0}}},%%开服时间			
			{service_hf_time, {{2013, 10, 22}, {5, 0, 0}}},	%%服务器合服时间
			{login_server_id, [0,1]}%允许登录服务器id

			
			]
		}        
    ]   
}.  