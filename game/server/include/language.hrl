%%%----------------------------------------------------------------------
%%% File    : language.hrl
%%% Author  : 
%%% Created : 2011-03-15
%%% Description: 语言宏定义

-define(_LANG_CAMP_NAME_LIST, ["北宋","东辽","西夏","抢夺者","抵御者","进攻阵营","防守阵营"]).
-define(_LANG_KNIGHT_NAME_LIST, ["偏将军","左将军","右将军","大将军","统帅","霸王"]).
-define(_LANG_KILL_NAME_LIST, ["大杀特杀","杀人如麻","无人阻挡","变态杀戮","神一般的杀戮","超越神的杀戮"]).

-define(_LANG_TEST1, <<"item name is ~p, count is ~p">>).

%%-----------------------GM信息 -------------------------------------
-define(_LANG_GM_INFO_MAIL_TITLE,					"盛世遮天--GM").


%%-----------------------系统消息-----------------------------
-define(_LANG_SYSTEM_SHUTDOWN,					   	<<"系统关闭.">>).
-define(_LANG_PACKET_FAST,							<<"您的帐号异常,请重新登陆.">>).
-define(_LANG_OPERATE_ERROR,						<<"操作错误.">>).
-define(_LANG_ERROR_ITEM_NONE, 						<<"物品不存在">>).


%% ----------------------  登陆系统  --------------------------------
-define(_LANG_ACCOUNT_LOGIN_FAIL,				   <<"登陆失败,请重新登陆.">>).		
-define(_LANG_ACCOUNT_CREATE_SUCCESS,              <<"成功">>).
-define(_LANG_ACCOUNT_CREATE_FAIL,                 <<"失败">>).

-define(_LANG_ACCOUNT_PLAYER_FULL,					<<"服务器人数已满，请稍后再试。">>).	
-define(_LANG_DUPLICATED_LOGIN,						<<"您的帐号在别处登录，被迫下线！">>).
-define(_LANG_ACCOUNT_CREATE_IS_EXIST,				<<"此角色名称已存在，请重新起名。">>).		
-define(_LANG_ACCOUNT_CREATE_NOT_VALID,				<<"不能使用非法字符作为角色名称。">>).	
-define(_LANG_ACCOUNT_CREATE_TOO_LONG,				<<"角色名称不能多于14个字符（7个汉字）。">>).	
-define(_LANG_ACCOUNT_CREATE_TOO_SHORT,			    <<"角色名称不能少于4个字符（2个汉字）。">>).



%% ----------------------  好友系统  -------------------------------------
-define(_LANG_FRIEND_ONLINE,                        <<"~s ~s 上线了">>).
-define(_LANG_FRIEND_OFFLINE,                       <<"~s ~s 下线了">>).
-define(_LANG_FRIEND_FRIEND,                        <<"好友">>).
-define(_LANG_FRIEND_ENEMY,                        <<"仇人">>).
-define(_LANG_FRIEND_ADD_FULL,    				<<"好友人数已满">>).
-define(_LANG_FRIEND_BLACK_ADD_FULL,    			<<"黑名单人数已满">>).
-define(_LANG_FRIEND_NOT_ONLINE,          			<<"玩家不在线，不能添加">>).
-define(_LANG_FRIEND_ROLE_NOT_EXIST,      			<<"不存在此角色名称">>).
-define(_LANG_FRIEND_ADD_SUCCESS,         			<<"添加好友成功">>).
-define(_LANG_FRIEND_ADD_REFUSE,          			<<"对方拒绝您添加好友的请求">>).
-define(_LANG_FRIEND_REQUEST_SELF,                  <<"不能添加自己">>).
-define(_LANG_FRIEND_FRIEND_ADD_NOT_SAME_LINE,      <<"玩家不同线">>).
-define(_LANG_FRIEND_BLACK_ALREADY,            		<<"已经在你的黑名单中">>).
-define(_LANG_FRIEND_FAIL,                    		<<"操作失败">>).
-define(_LANG_FRIEND_GROUP_DEFAULT,                 <<"默认分组不能删除">>).
-define(_LANG_FRIEND_GROUP_NOT_EXIST,               <<"分组不存在">>).
-define(_LANG_FRIEND_GROUP_NUM_LIMIT,               <<"分组数量已满">>).
-define(_LANG_FRIEND_FRIEND_ROLE_NULL,              <<"请输入玩家昵称">>).
%% -define(_LANG_FRIEND_GROUP_ALREADY_EXIST,           <<"分组已存在">>).
-define(_LANG_FRIEND_ERROR_FRIEND_EXISTS,			<<"好友已存在">>).	
-define(_LANG_FRIEND_ERROR_BLACK_EXISTS,			<<"黑名单已存在">>).					
-define(_LANG_FRIEND_ERROR_ENEMY_EXISTS,			<<"仇人已存在">>).



-define(_LANG_FRIEND_ERROR_FRIEND_NOT_EXISTS,<<"好友不存在">>).
-define(_LANG_FRIEND_ERROR_BLACK_NOT_EXISTS,<<"黑名单不存在">>).	
-define(_LANG_FRIEND_ERROR_ENEMY_NOT_EXISTS,<<"仇人不存在">>).	

-define(_LANG_FRIEND_ROSE_NULL,<<"指定的玫瑰花不足,请先购买">>).
-define(_LANG_FRIEND_ROSE_NOT_EXISTS,<<"该玩家不是你的好友,不能赠送玫瑰">>).


%% ----------------------  任务系统  --------------------------------
-define(_LANG_TASK_ADD_NOT_EXIST,					<<"任务不存在.">>).
-define(_LANG_TASK_ADD_NOT_NPC,						<<"NPC不存在.">>).
-define(_LANG_TASK_ADD_FAR_NPC,						<<"不在NPC附近.">>).
-define(_LANG_TASK_ADD_BEGIN_DATE,					<<"任务时间未到.">>).
-define(_LANG_TASK_ADD_END_DATE,					<<"任务时间已过.">>).
-define(_LANG_TASK_ADD_MIN_LEVEL,					<<"等级过低.">>).
-define(_LANG_TASK_ADD_MAX_LEVEL,					<<"等级过高.">>).
-define(_LANG_TASK_ADD_PRE_TASK,					<<"前置任务未完成.">>).
-define(_LANG_TASK_ADD_HAS_ACCEPT,					<<"任务已经存在.">>).					

-define(_LANG_TASK_ADD_NOT_REPEAT,					<<"任务不能重复.">>).	
-define(_LANG_TASK_ADD_DAY_REPEAT,					<<"时间间隔未到.">>).	

-define(_LANG_TASK_ADD_NOT_SEX,						<<"性别不符合.">>).	
-define(_LANG_TASK_ADD_NOT_CORP,					<<"阵营不符合.">>).	
-define(_LANG_TASK_ADD_NOT_CAREER,					<<"职业不符合.">>).	

%%运镖
-define(_LANG_TASK_CARGO_OUT_TIMES,					<<"每天只能参加五次运镖.">>).
-define(_LANG_TASK_CARGO_ON_TASK,					<<"您已在押送镖车中.">>).
-define(_LANG_TASK_CARGO_COPPER_NOT_ENOUGH,			<<"刷新镖车失败，您的铜币不足!">>).
-define(_LANG_TASK_CARGO_NO_TOKEN,					<<"背包中没有相应的押镖令.">>).
-define(_LANG_TASK_CARGO_NO_BILL,					<<"背包没有银票，加货失败.">>).
-define(_LANG_TASK_CARGO_MAX_AWARD,					<<"镖车已为最高奖励，不能加货.">>).
-define(_LANG_TASK_CARGO_COLOR_WHITE,				<<"白">>).
-define(_LANG_TASK_CARGO_COLOR_GREEN,				<<"绿">>).
-define(_LANG_TASK_CARGO_COLOR_BLUE,				<<"蓝">>).
-define(_LANG_TASK_CARGO_COLOR_PURPLE,				<<"紫">>).
-define(_LANG_TASK_CARGO_COLOR_ORANGE,				<<"橙">>).
-define(_LANG_TASK_CARGO_ATTACK,					<<"危险！~s玩家的镖车被攻击，兄弟们请立即支援，立即传送。">>).
-define(_LANG_TASK_CARGO_GRABED,					<<"{S-65280-~s}凶狠手辣,手刃神兽护送者{S-65280-~s},夺取神兽,必将被万夫所指!">>).
-define(_LANG_TASK_CARGO_ROB_LIMIT,					<<"每日只有前~p次掠夺镖车能获得奖励。">>).
-define(_LANG_TASK_CARGO_LOSS,						<<"镖车被劫">>).
-define(_LANG_TASK_CARGO_ROB_SUCCESS,				<<"劫镖成功">>).
%%神魔令
-define(_LANG_TASK_SHENMO_NOT_ENOUGH,				<<"背包没有神魔令，接取任务失败.">>).
-define(_LANG_TASK_SHENMO_REFRESH_EXIST,			<<"背包没有玲珑石，不能刷新.">>).
-define(_LANG_TASK_SHENMO_REFRESH_SUCCESS,			<<"刷新成功，任务更改品质为~s色.">>).
-define(_LANG_TASK_SHENMO_MAX_TIMES,				<<"每日最高只可领取~p次神魔令任务.">>).
%% ----------------------  组队系统  --------------------------------
-define(_LANG_TEAM_NAME,							"的队伍").
-define(_LANG_TEAM_VITITE_SELF,						<<"不能邀请自己.">>).
-define(_LANG_TEAM_VITITE_NOT_EXIST,				<<"玩家不存在.">>).
-define(_LANG_TEAM_VITITE_OFFLINE,					<<"玩家不在线.">>).
-define(_LANG_TEAM_VITITE_NOT_LEADER,				<<"你不是队长.">>).
-define(_LANG_TEAM_VITITE_IN_TEAM,					<<"玩家已在本队中.">>).
-define(_LANG_TEAM_VITITE_IN_OTHERTEAM,				<<"玩家在其他队伍中.">>).
-define(_LANG_TEAM_VITITE_SUCCESS,					<<"邀请入队请求已发送,请等待对方回应.">>).		
-define(_LANG_TEAM_VITITE_MAX_MEMBER,				<<"队伍人数已满.">>).
-define(_LANG_TEAM_JOIN_REQUEST,					<<"入队请求已发出，等待队长回应.">>).
-define(_LANG_TEAM_VITITE_DISAGREE,					<<"~s玩家拒绝了您的队伍邀请">>).
-define(_LANG_TEAM_JOIN_TEXT,						"~s玩家成功进入本队伍").
-define(_LANG_TEAM_JOIN_SELFTEXT,					<<"你加入了队伍">>).
-define(_LANG_TEAM_LEAVE_TEXT,						<<"~s玩家已经退出队伍">>).
-define(_LANG_TEAM_LEAVE_SELFTEXT,					<<"你离开了队伍">>).
-define(_LANG_TEAM_KICK_SELFTEXT,					<<"你被移出队伍">>).
-define(_LANG_TEAM_DISBAND_TEXT,					<<"您的队伍已解散">>).
-define(_LANG_TEAM_LEADER_CHANGE,					"现在是队长").
-define(_LANG_TEAM_LEADER_CHANGE_SELF,				<<"你现在是队长">>).
-define(_LANG_TEAM_SETTING_CHANGE,					<<"修改队伍设置">>).
-define(_LANG_TEAM_CREATE,							<<"您已成功创建队伍">>).


-define(_LANG_TEAM_READY_DUPLICATE,					<<"队伍已有其他副本存在，不能再创建新副本.">>).	
-define(_LANG_TEAM_NOT_LEADER_DUPLICATE,			<<"你不是队长.">>).
-define(_LANG_TEAM_TEAMMATE_READY_DUPLICATE,        <<"您有队员已在副本中，不能申请进入副本">>).
-define(_LANG_TEAM_NOT_CREATE_DUPLICATE,            <<"只有队长才能申请进入副本">>).	
-define(_LANG_TEAM_NOT_JOIN,                        <<"此队伍已在副本中，不能加入">>).
-define(_LANG_LEVEL_NOT_TRUE,                       <<"你的等级没有满足进入条件").
-define(_LANG_ONLY_SINGLE_ENTER,                    <<"退出队伍后才能进入单人场景">>).
-define(_LANG_NOT_ALLOW_OPERATE,                    <<"特殊场景内不允许此行为">>).

%% ----------------------  防沉迷系统  --------------------------------
-define(_LANG_INFANT_VAILD,							<<"防沉迷开始,请填写身份验证">>).
-define(_LANG_INFANT_NOTIC_ONLINE_TIME,				<<"您累积在线已满~w小时。">>).
-define(_LANG_FIVE_MINUTE_LEFT, 					<<"您的账户防沉迷剩余时间将在5分钟后进入防沉迷状态，系统将自动将您离线休息一段时间。">>).

%% ----------------------  战斗相关系统  -------------------------------- 
-define(_LANG_RELIVE_HEALTH,                         <<"花费10银两，你原地健康复活了">>).
-define(_LANG_RELIVE_HEALTH2,          				 <<"消耗复活药x1，您原地健康复活了">>).
-define(_LANG_YUANBAO_NOT_ENOUGH,                    <<"银两不足，不能原地健康复活">>).


%% ----------------------  宠物系统  --------------------------------
-define(_LANG_PET_LIST_NUM_LIMIT,                    <<"对不起，您的宠物栏已满，无法装备宠物">>).
-define(_LANG_PET_ALREADY_FIGHTTING,                 <<"宠物已出战">>).
-define(_LANG_PET_CALL_BACK_FIRST,                   <<"请先召回宠物">>).
-define(_LNAG_PET_ONLY_ONE_FIGHT,                    <<"只能有一个宠物出战">>).
-define(_LANG_PET_NOT_EXIST,                         <<"宠物不存在">>).

%%-----------------------系统公告广播--------------------
-define(_LANG_NOTICE_DUPLICATE_MONEY, <<"{N~s}击杀了{D~s}获得了大量铜币.">>).
-define(_LANG_NOTICE_DUPLICATE_PASS_TEAM, <<"{N~s}的队伍勇闯{D~s},通过了[第~p层]关卡,真乃英雄出少年,长江后浪推前浪啊!">>).
-define(_LANG_NOTICE_DUPLICATE_PASS, <<"{N~s}勇闯{D~s}[第~p层],真乃英雄出少年,长江后浪推前浪啊!">>).
-define(_LANG_NOTICE_DUPLICATE_GUARD,				<<"{N~s}的队伍抵抗了{D~s-~p}外族敌人,真乃民族之真英雄！">>).							
-define(_LANG_NOTICE_COMPOSE,						<<"{N~s}历经千辛万苦终于合成出了一颗{G~p-~p-~p}，可喜可贺！">>).
-define(_LANG_NOTICE_UPGRADE,						<<"{N~s}成功把{E~p-~p-~p-~p}，江湖中又诞生了一把神兵利器！">>).
-define(_LANG_NOTICE_UPLEVEL,						<<"{N~s}成功把{B~p-~p-~p-~p}，江湖中又诞生了一把神兵利器！">>).
-define(_LANG_NOTICE_STRENG,						<<"{N~s}成功把{A~p-~p-~p-~p}，江湖中又诞生了一把神兵利器！">>).
-define(_LANG_STONE_QUENCH, 						<<"恭喜{N~s}洪福齐天，成功淬炼出了{G~p-~p-~p}">>).
-define(_LANG_NOTICE_DUPLICATE_BOSS_KILL, <<"玩家{N~s}击杀了{N~s},获得了大量财宝!">>).
-define(_LANG_NOTICE_DUPLICATE_BOSS_BORN, <<"{N~s}得知众多手下被江湖人士击败,怒不可遏,出现在{N~s}">>).
-define(_LANG_NOTICE_TIME_BOSS_BORN, <<"{N~s}说:温度正好,湿度适宜,去{N~s}活动活动筋骨!">>). 

-define(_LANG_NOTICE_KILL_BOSS,						<<"{N~s}武艺冠群,绝杀世界BOSS{N~s},获得了大量珍宝,武林中真乃高手辈出啊！">>).
-define(_LANG_NOTICE_RELIVE_BOSS,					<<"世界BOSS{N~s}出现在{N~s},赶紧找小伙伴们一同挑战BOSS,获取丰厚的奖励吧!">>).

-define(_LANG_NOTICE_ROLE_PLAY,						<<"情花灿烂，情谊无限.{N~s}向意中人{N~s}献上~p束1朵玫瑰！">>).
-define(_LANG_NOTICE_ROLE_PLAY1,						<<"情花灿烂，情谊无限.{N~s}向意中人{N~s}献上~p束9朵玫瑰！">>).
-define(_LANG_NOTICE_ROLE_PLAY2,						<<"情花灿烂，情谊无限.{N~s}向意中人{N~s}献上~p束99朵玫瑰！">>).
-define(_LANG_NOTICE_ROLE_PLAY3,						<<"情花灿烂，情谊无限.{N~s}向意中人{N~s}献上~p束999朵玫瑰！">>).
-define(_LANG_NOTICE_ROLE_PLAY4,						<<"菊花灿烂，基情无限.{N~s}向意中人{N~s}献上~p束~s朵玫瑰！">>).
-define(_LANG_NOTICE_ROLE_PLAY5,						<<"百合灿烂，花开无限.{N~s}向意中人{N~s}献上~p束~s朵玫瑰！">>).
-define(_LANG_NOTICE_ROLE_PLAY6,						<<"情花灿烂，情谊无限.{N~s}向意中人{N~s}献上~p束~s朵玫瑰！">>).

%%----------------------- 聊天系统-----------------------------------
-define(_LANG_CHAT_GUILD_TIME,"帮会聊天间隔还剩余").
-define(_LANG_CHAT_TEAM_TIME,"队伍聊天间隔还剩余").
-define(_LANG_CHAT_TIME_UNIT,"秒").
-define(_LANG_CHAT_WORLD_TIME,"世界聊天间隔还剩余").
-define(_LANG_CHAT_TEAM_MSG,"您没有所在队伍").
-define(_LANG_CHAT_GUILD_MSG,"您没有所在帮会").
-define(_LANG_CHAT_USER_MSG,"用户不在线").
-define(_LANG_CHAT_NOT_PRIVATE,"不能对自己私聊").
-define(_LANG_CHAT_NOT_LABA,"你没有喇叭了，快去买吧！").
-define(_LANG_CHAT_WORLD_LEVEL,"世界聊天需要达到15级。").
-define(_LANG_CHAT_CP,"世界聊天需要消耗1点体力，您的体力不足。").
-define(_LANG_CHAT_BAN, <<"您被禁止发言了！">>).
-define(_LANG_FORBID_LOGIN, <<"您的账号不能正常登陆，请联系游戏客服。">>).

%% -define(_LANG_CHAT_FINISH_DARTS, "押运镖车成功， 获得~p经验、~p铜币奖励。").
%% -define(_LANG_CHAT_ACCEPT_DARTS, "接取~s色镖车，请开始护送镖车。").

%% -define(_LANG_CHAT_ACCEPT_PURPLE_CAR, "恭喜[~s]玩家接取{S-10040013-橙色镖车}将会获得大量奖励。").

-define(_LANG_CHAT_SUBMIT_PURPLE_CAR, "{N~s}顺利将{S-16750848-梦魇}护送至终点,获得神兽驯养师约定的丰厚奖励！").

-define(_LANG_CHAT_RESOURCE_WAR, "远征沙场——活动结束\n在激烈的战争中.第一阵营和第一猛将新鲜出炉.\n 第一阵营:{N~s}\n 第一猛将:{N~s}\n 国家兴亡匹夫有责,远征沙场需要你的力量.加入远征大军,立不朽功名!").
-define(_LANG_CHAT_RESOURCE_KILL, "[~s]猛将{N~s}终结了[~s][~s]{N~s},额外奖励~p积分").
-define(_LANG_CHAT_RESOURCE_KILLING, "[~s]猛将{N~s}击杀了[~s]{N~s},已经[~s]了").
-define(_LANG_CHAT_RESOURCE_KILL_BOSS,"[~s]猛将{N~s}击杀了{N~s},获得~p积分").

-define(_LANG_CHAT_PVP_FIRST, "天下第一活动结束\n在激烈的杀戮中，{N~s}一人力战全服勇夺天下第一，拥有了强力BUFF，获得了丰厚奖励!").
-define(_LANG_CHAT_PVP_FIRST1,  "本次天下第一活动厮杀实在是太残酷了，最后竟然没有人能夺得天下第一!").
-define(_LANG_CHAT_PVP_FIRST_QUIT, "天下第一{N~s}离开了战场,天下第一重新刷新在地图中央!").
-define(_LANG_CHAT_PVP_FIRST_KILL,"{N~s}获得了天下第一，众位快击杀{N~s}抢夺天下第一!").
-define(_LANG_CHAT_ACTIVE_MONSTER_OPEN, "滥杀无辜的{N~s}重现江湖，请众侠速去擒服!").
-define(_LANG_CHAT_ACTIVE_MONSTER_WIN, "在{N~s}的带领下，众侠客齐心协力，成功将{N~s}擒服!").
-define(_LANG_CHAT_ACTIVE_MONSTER_FAIL, "虽然众侠客拼尽全力，但{N~s}仍全身而退!").
-define(_LANG_CHAT_ACTIVE_MONSTER_GET_COPPER, "活动结束，获得铜币[~p]").

-define(_LANG_CHAT_ACTIVE_GUILD_FIGHT_OPEN, "王帮、霸会现身在纷争之地,各帮主请带领帮众前去与其他帮会在前辈的见证下,一争荣誉!").
-define(_LANG_CHAT_ACTIVE_GUILD_FIGHT_RESULT, "不负前辈的期望,这次乱斗中{N~s}获得了第一名,真可谓是江湖第一帮!").
-define(_LANG_CHAT_ACTIVE_GUILD_FIGHT_RESULT1, "两位前辈站了半天,愣是没等到一个帮会出现,于是他们发誓再也不开这个帮会乱斗活动了!").
-define(_LANG_CHAT_ACTIVE_GUILD_FIGHT_KILL, "帮会{N~s}的帮众们已累计击败{D~p}名他帮成员,快联合起来阻止他们!").
-define(_LANG_CHAT_FLAG_GET, "{N~s}帮会夺取了旗帜").

-define(_LANG_CHAT_ACTIVE_KING_FIGHT_OPEN, "王城战开启!请进攻帮会{N~s}和防守帮会{N~s}立即前去支援!").
-define(_LANG_CHAT_ACTIVE_KING_FIGHT_OPEN_FAILD, "由于没有帮会竞拍王城攻打权，本次王城活动关闭！").
-define(_LANG_CHAT_ACTIVE_KING_FIGHT_RESULT1, "{N~s}帮会在众人齐心协力下,{N~s}了王城,获得帮会财富30000点并将拥有王城接下来24小时的管理权以及福利特权.").
-define(_LANG_CHAT_ACTIVE_KING_FIGHT_RESULT2, "NPC联盟:哈哈哈哈!你们这些可笑的玩家,竟试图攻占王城?真是自寻死路!!!").
-define(_LANG_CHAT_ACTIVE_KING_FIGHT_AUCTION, "恭喜{N~s}帮会获得了攻打权！").

%%----------------------- 邮件系统-----------------------------------
-define(_LANG_MAIL_LESS_COPPER,"铜币不足").
-define(_LANG_MAIL_COLLENT_TITLE,"背包已满，采集获得").
-define(_LANG_MAIL_MARRY_GIFT_SENDER,"婚礼司仪小助手").
-define(_LANG_MAIL_MARRY_GIFT_TITLE,"好友随礼，请查收").
-define(_LANG_MAIL_MARRY_GIFT_CONTENT,"[~p]位好友参加婚礼，\n随礼银两~p\n随礼铜币~p").
-define(_LANG_MAIL_MARRY_CHANGE1_TITLE, "任命妻子").
-define(_LANG_MAIL_MARRY_CHANGE2_TITLE, "任命小妾").
-define(_LANG_MAIL_MARRY_CHANGE1_CONTENT, "您的夫君[~s]将您册封为 妻子").
-define(_LANG_MAIL_MARRY_CHANGE2_CONTENT, "您的夫君[~s]将您册封为 小妾").
-define(_LANG_MAIL_DIVORCE_TITLE,"强制离婚").
-define(_LANG_MAIL_DIVORCE_CONTENT,"[~s]已与您强制解除婚姻关系.").
-define(_LANG_MAIL_ADD_TITLE,"背包已满，系统发送").
-define(_LANG_MAIL_FULL_BAG_ITEM_TITLE, "背包已满，清理背包，领取物品").
-define(_LANG_MAIL_FULL_BAG_ITEM_CONTENT, "您的背包已满,您获得的物品系统会以邮件发送给您。请清理背包后点击【收取附件】获得物品").
-define(_LANG_MAIL_CHALLENGE_AWARD_TITLE, "试炼BOSS[第~p关]霸主礼包发放").
-define(_LANG_MAIL_CHALLENGE_AWARD_CONTENT, "恭喜您荣获[~p年~p月~p日]试练BOSS[第~p关][霸主]，系统特此奖励以下霸主礼包，请点击【收取附件】领取礼包").
-define(_LANG_MAIL_PET_BATTLE_TOP_AWARD_TITLE, "宠物斗坛[第~p名]礼包发放").
-define(_LANG_MAIL_PET_BATTLE_TOP_AWARD_CONTENT, "恭喜您的宠物[~s]荣获[~p年~p月~p日]宠物斗坛[第~p名]，系统特此奖励以下礼包，请点击【收取附件】领取礼包").
-define(_LANG_MAIL_RESOURCE_WAR_AWARD_TITLE, "远征沙场活动奖励").
-define(_LANG_MAIL_RESOURCE_WAR_AWARD_TOP_CONTENT, "恭喜您在远征沙场活动中荣获[第~p名]，系统特此奖励以下排名礼包").
-define(_LANG_MAIL_RESOURCE_WAR_AWARD_CAMP_CONTENT1, "恭喜您所在阵营荣获远征沙场活动[第一阵营]，系统特此奖励以下阵营礼包").
-define(_LANG_MAIL_RESOURCE_WAR_AWARD_CAMP_CONTENT2, "恭喜您所在阵营荣获远征沙场活动[第二阵营]，系统特此奖励以下阵营礼包").
-define(_LANG_MAIL_RESOURCE_WAR_AWARD_CAMP_CONTENT3, "恭喜您所在阵营荣获远征沙场活动[第三阵营]，系统特此奖励以下阵营礼包").

-define(_LANG_MAIL_PVP_FIRST_AWARD_TITLE, "天下第一活动奖励").
-define(_LANG_MAIL_PVP_FIRST_AWARD_FIRST, "恭喜您获得天下第一，系统特此奖励天下第一礼包!").
-define(_LANG_MAIL_PVP_FIRST_AWARD_NORMAL, "感谢您参与本次天下第一活动，系统特此奖励参与礼包!").

-define(_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE1, "魔头现世活动豪侠大礼").
-define(_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE2, "魔头现世活动精英奖励").
-define(_LANG_MAIL_ACTIVE_MONSTER_AWARD_TITLE3, "魔头现世活动参与礼包").
-define(_LANG_MAIL_ACTIVE_MONSTER_AWARD_CONTENT, "大侠此役辛苦了,活动奖赏在此").

-define(_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE1, "帮会乱斗第一帮会奖励").
-define(_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE2, "帮会乱斗第二帮会奖励").
-define(_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE3, "帮会乱斗第三帮会奖励").
-define(_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_TITLE4, "帮会乱斗参与帮会奖励").
-define(_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT1, "你和盟友们证明了帮会的强大,请收下这份奖赏").
-define(_LANG_MAIL_ACTIVE_GUILD_FIGHT_AWARD_CONTENT2, "能在乱战中坚持下来实属不易,请收下这份奖赏").

-define(_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_TITLE1, "王城战胜利奖励").
-define(_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_TITLE2, "王城战参与奖励").
-define(_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_CONTENT1, " 在各大同盟的齐心协力之下,我方赢得了王城战,请收下奖励").
-define(_LANG_MAIL_ACTIVE_KING_FIGHT_AWARD_CONTENT2, "不要灰心,待时机成熟之时,我们将会重新攻夺王城!").

%%------------------------打坐修炼系统----------------------------------
-define(_LANGUAGE_SIT_ALREADY, "已经在打坐状态中。").
-define(_LANGUAGE_SIT_ON_PK, "战斗状态中，不能进行打坐修炼。").
-define(_LANGUAGE_SIT_START, "您进入【单人打坐】状态，每隔20秒获得xx点经验和xx点历练值，增加xx点所修炼的神通熟练度。").
-define(_LANGUAGE_SIT_CANCLE, "您的打坐状态已经取消。").
-define(_LANGUAGE_SIT_XW_CANCLE, "您的修为状态已经取消。").

%%------------------------寄售系统----------------------------------
-define(_LANGUAGE_SALE_TITLE, "寄售系统邮件").

-define(_LANGUAGE_SALE_ITEM_ONSALE_TIMEOUT, "超过寄售时间，没人购买, 物品【~s】x~p退还给您。").
-define(_LANGUAGE_SALE_YB_ONSALE_TIMEOUT, "超过寄售时间，没人购买, 银两x~p退还给您。").
-define(_LANGUAGE_SALE_COPPER_ONSALE_TIMEOUT, "超过寄售时间，没人购买, 铜币x~p退还给您。").

-define(_LANGUAGE_SALE_ITEM_ONSALE_DELETE, "您撤消了寄售，物品【~s】退还给您。").
-define(_LANGUAGE_SALE_YB_ONSALE_DELETE, "您撤消了寄售，银两x~p退还给您。").
-define(_LANGUAGE_SALE_COPPER_ONSALE_DELETE, "您撤消了寄售，铜币x~p退还给您。").

-define(_LANGUAGE_SALE_ITEM_BUY_SUCCESS, "您成功购买了【~s】x~p, 花费~p铜币。").
-define(_LANGUAGE_SALE_ITEM_BUY_SUCCESS1, "您成功购买了【~s】x~p, 花费~p银两。").
-define(_LANGUAGE_SALE_YB_BUY_SUCCESS, "您成功购买了银两x~p, 花费~p铜币。").
-define(_LANGUAGE_SALE_COPPER_BUY_SUCCESS, "您成功购买了铜币x~p, 花费~p银两。").


-define(_LANGUAGE_SALE_ITEM_ONSALE_SUCCESS_COPPER, "您成功寄售了【~s】x~p, 获得~p铜币。").
-define(_LANGUAGE_SALE_ITEM_ONSALE_SUCCESS_YUANBAO, "您成功寄售了【~s】x~p, 获得~p银两。").
-define(_LANGUAGE_SALE_YB_ONSALE_SUCCESS, "您成功寄售了银两x~p, 获得~p铜币。").
-define(_LANGUAGE_SALE_COPPER_ONSALE_SUCCESS, "您成功寄售了铜币x~p, 获得~p银两。").

-define(_LANGUAGE_SALE_COPPER, "铜币").
-define(_LANGUAGE_SALE_YUAN_BAO, "银两").

-define(_LANGUAGE_SALE_MSG_ITEM_NOT_EXIST, "物品不存在").
-define(_LANGUAGE_SALE_MSG_NOT_ENOUGH_COPPER, "铜币不足").
-define(_LANGUAGE_SALE_MSG_ERROR_ITEM_DATA, "物品数据错误").
-define(_LANGUAGE_SALE_MSG_BIND_ITEM, "绑定物品不能寄售").
-define(_LANGUAGE_SALE_MSG_ERROR_ITEM_TEMPLATE, "物品模板错误").
-define(_LANGUAGE_SALE_MSG_ITEM_ON_SALE, "物品已在寄售中").
-define(_LANGUAGE_SALE_MSG_SALE_NOT_EXIST, "寄售不存在").
-define(_LANGUAGE_SALE_MSG_BAG_FULL, "背包满").
-define(_LANGUAGE_SALE_MSG_UNKOWN_SALE_TYPE, "未知寄售类型").
-define(_LANGUAGE_SALE_MSG_ERROR_PRICE_TYPE, "价格类型 错误").
-define(_LANGUAGE_SALE_MSG_NOT_ENOUGH_YUAN_BAO, "银两不足").
-define(_LANGUAGE_SALE_MSG_DB_ADD_FAIL, "数据库添加寄售记录失败").
-define(_LANGUAGE_SALE_MSG_NOT_MATCH_SALER, "不是添加寄售的玩家").
-define(_LANGUAGE_SALE_MSG_FAIL_CANCEL_SALE_BEACAUSE_BAG_FULL, "撤消寄售失败，背包满").
-define(_LANGUAGE_SALE_MSG_FAIL_YOU_ARE_SALER, "购买寄售失败，不能购买自己的寄售").
-define(_LANGUAGE_SALE_MSG_ERROR_PARAM, "寄售失败，参数错误").
%% -------------------------交易系统 --------------------------------------
-define(_LANGUAGE_TRADE_FAIL_PK, "战斗状态不能交易").
-define(_LANGUAGE_TRADE_FAIL_DEAH, "死亡状态不能交易").
-define(_LANGUAGE_TRADE_FAIL_SIT, "打坐状态不能交易").
-define(_LANGUAGE_TRADE_FAIL_SELF, "不能和自己交易").
-define(_LANGUAGE_TRADE_FAIL_OFFLINE, "对方不在线或没有此玩家").
-define(_LANGUAGE_TRADE_FAIL_BUSY, "对方正在忙").
-define(_LANGUAGE_TRADE_FAIL_TRADE, "已经在交易状态中").
-define(_LANGUAGE_TRADE_FAIL_UNKOWN_VALUE, "参数错误").
-define(_LANGUAGE_TRADE_REQUEST_SUCCESS, "发出请求成功，请等待对方回应").
-define(_LANGUAGE_TRADE_REQUEST_REFUSE, "【~s】拒绝了您的交易请求").
-define(_LANGUAGE_TRADE_REQUEST_ACCEPT, "【~s】同意了您的交易请求").

-define(_LANG_ALREADY_STALL, "您已经在摆摊中").
-define(_LANG_STALL_LOCAL_ERROR, "当前位置不能摆摊").


%%帮会商店

-define(_LANG_GUILD_SHOP_BAG_ERROR, <<"背包空间不足，不能购买">>).
-define(_LANG_GUILD_SHOP_ITEM_NOT_EXIST, <<"物品不存在">>).
-define(_LANG_GUILD_SHOP_GUILD_NOT_EXIST,<<"您没有所在帮会">>).
-define(_LANG_GUILD_SHOP_FEATS_NOT,<<"您的贡献不足">>).
-define(_LANG_GUILD_SHOP_TIMES_OUT,<<"该物品今天购买次数已满">>).

%% -------------------------帮会--------------------------------------

-define(_LANG_GUILDS_ITEMS_GET,                     "~s 取出了 ~s").
-define(_LANG_GUILDS_ITEMS_PUT,                     "~s 放入了 ~s").

-define(_LANG_GUILDS_LEVEL_UP_LOG,					"帮会升到 ~p 级").
-define(_LANG_GUILDS_FURNACE_LEVEL_UP_LOG,			"帮会神炉升到 ~p 级").
-define(_LANG_GUILDS_SHOP_LEVEL_UP_LOG,				"帮会商店升到 ~p 级").
-define(_LANG_GUILDS_MEMBER_JOB_CHANGE,				"~s 被任命为 ~s").
-define(_LANG_GUILDS_VICE_PERSIDENT,				"副帮主").
-define(_LANG_GUILDS_HONORARY,						"长老成员").
-define(_LANG_GUILDS_COMMON,						"正式成员").

-define(_LANG_GUILDS_CREATE_GUILD_SUCCESS,			"创建帮会成功").
-define(_LANG_GUILDS_CREATE_GUILD_FAILED,			"创建帮会失败").

-define(_LANG_GUILD_ERROR_NAME_NOT_VALID,			"帮会名不合法").	
-define(_LANG_GUILD_ERROR_NAME_ALREADY_HAVE,		"帮会名重复").
-define(_LANG_GUILD_ERROR_CREATE_TOO_SHORT,		"输入内容太短").
-define(_LANG_GUILD_ERROR_CREATE_TOO_LONG,		"输入内容太长").

-define(_LANG_GUILD_ERROR_NOT_ENOUGH_LEVEL,		"级别不足").	
-define(_LANG_GUILD_ERROR_INVITE_NOT_ENOUGH_LEVEL,		"对方未达到要求等级，不能入帮").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_CASH,		"资金不足").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_MONEY,		"帮会财富不足").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_NEED,		"帮会贡献不足").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_GUILD_LEVEL,		"帮会等级不足").

-define(_LANG_GUILD_ERROR_TARGET_ALREADY_HAVE_GUILD,				"玩家已有帮会").
-define(_LANG_GUILD_ERROR_ALREADY_HAVE_GUILD,				"您已有帮会").
-define(_LANG_GUILD_ERROR_ALREADY_HAVE_GUILD1,				"对方已有帮会").
-define(_LANG_GUILD_ERROR_LEAVE_TIME_NOT_ENOUGH,			"您距上次退出帮会未满24小时").
-define(_LANG_GUILD_ERROR_TARGET_LEAVE_TIME_NOT_ENOUGH,		"对象距上次退出帮会未满3小时").
-define(_LANG_GUILD_ERROR_NOT_ENOUGH_RIGHT,		"帮会权限不足").	
-define(_LANG_GUILD_ERROR_NOT_GUILD,		"没有该帮会").
-define(_LANG_GUILD_ERROR_NOT_SAME_GUILD,		"非同一帮会").
-define(_LANG_GUILD_ERROR_NOT_CORP,		"没有该军团").
-define(_LANG_GUILD_ERROR_NOT_SAME_CORP,		"非同一军团").
-define(_LANG_GUILD_ERROR_LEADER_NOT_ALLOW,		"本操作不允许会长或军团长执行").
-define(_LANG_GUILD_ERROR_NOT_EXISTS_PLAYER,		"此人不存在").
-define(_LANG_GUILD_ERROR_TRYIN_NULL,		"申请列表为空").

-define(_LANG_GUILD_ERROR_DB_CAUSE,		"数据库错误").

-define(_LANG_GUILD_ERROR_FULL_MEMBER,		"帮会人员已满").
-define(_LANG_GUILD_ERROR_REQUEST_FULL_MEMBER,		"帮会申请列表已满").
-define(_LANG_GUILD_ERROR_FULL_VICE_MASTER_MEMBER,		"副帮主人员已满,请升级帮会").
-define(_LANG_GUILD_ERROR_FULL_HONORARY_MEMBER,		"长老人员已满,请升级帮会").

-define(_LANG_GUILD_ERROR_CORP_FULL_MEMBER,		"军团人员已满").
-define(_LANG_GUILD_ERROR_CORP_NUMBER_MAX,		"军团数量已满").

-define(_LANG_GUILD_ERROR_SETTING_MAX_NUMBER,		"已到最大值").
-define(_LANG_GUILD_ERROR_SETTING_MAX_LEVEL,		"已升到最高级").
-define(_LANG_GUILD_ERROR_LEVEL,		"帮会等级不存在").

-define(_LANG_GUILD_ERROR_ALREADY_TRYIN,		"已经申请过加入此帮会").
-define(_LANG_GUILD_ERROR_NEVER_TRYIN,		"此用户没有申请加入本帮会").

-define(_LANG_GUILD_ERROR_NOT_ONLINE,		"对象不在线").
-define(_LANG_GUILD_ERROR_WAREHOUSE_MAX,		"仓库已满").	
-define(_LANG_GUILD_ERROR_WAREHOUSE_USER_NO_ITEM,		"你没有此物品").
-define(_LANG_GUILD_ERROR_WAREHOUSE_ITEM_BIND,		"不能放入绑定物品").
-define(_LANG_GUILD_ERROR_WAREHOUSE_NULL,		"仓库没有物品").
-define(_LANG_GUILD_ERROR_WAREHOUSE_NOT_ITEM,		"仓库没有此物品").
-define(_LANG_GUILD_ERROR_BAG_MAX,		"背包已满").

-define(_LANG_GUILD_ERROR_MAX_MAILS,	"当日邮件发送限制已到").

-define(_LANG_GUILD_ERROR,		"").

-define(_LANG_GUILD_REQUEST_SUCCESS,	"招收成员成功").
-define(_LANG_GUILD_REQUEST_TARGET_SUCCESS,		"恭喜您，成功加入 ~s 帮会").

-define(_LANG_GUILD_CONTRIBUTION_YUANBAO, "{N~s}为帮会捐献{D银两~p两},增加帮会财富~p").
-define(_LANG_GUILD_CONTRIBUTION_COPPER, "{N~s}为帮会捐献{D铜钱~p},增加帮会财富~p").

-define(_LANG_GUILD_WELCOME_PLAYER_NEW,"受到了来自{N~s}的~s,增加{D~p~s}").
-define(_LANG_GUILD_WELCOME_PLAYER_OLD,"对{N~s}进行了~s,增加{D~p~s}").

-define(_LANG_GUILD_PLAYER_IN, "恭喜 ~s 玩家加入本帮会").
-define(_LANG_GUILD_PLAYER_CORP_IN, "恭喜 ~s 玩家加入军团 ~s ").

-define(_LANG_GUILD_PLAYER_CONTRIBUTION," ~s成员进行帮会贡献，增加~s帮会财富、~s个人贡献。").
-define(_LANG_GUILD_PLAYER_CONTRIBUTION_MONEY,"~s成员进行帮会贡献，增加~s帮会财富、~s个人贡献。").

-define(_LANG_GUILD_PLAYER_CONTRIBUTION1," ~s成员进行帮会贡献，增加~s帮会财富").
-define(_LANG_GUILD_PLAYER_CONTRIBUTION_MONEY1,"~s成员进行帮会贡献，增加~s帮会财富").

-define(_LANG_GUILD_PLAYER_INVITE,"邀请信息发送成功").

-define(_LANG_GUILD_CORP_PLAYER_KICKOUT,"您被移出军团").
-define(_LANG_GUILD_PLAYER_KICKOUT,"您被踢出帮会").
-define(_LANG_GUILD_PLAYER_KICKOUT_TO_ALL,"成员 ~s 被踢出帮会").

-define(_LANG_GUILD_PLAYER_LEAVE,"您退出了帮会").
-define(_LANG_GUILD_PLAYER_LEAVE_TO_ALL,"成员 ~s 退出帮会").

-define(_LANG_GUILD_DISMISS, "帮会已解散").
-define(_LANG_GUILD_LEVELUP, "本帮会已升级").
-define(_LANG_GUILD_LEVELUP1, "本帮会商城已升级").
-define(_LANG_GUILD_LEVELUP2, "本帮会演武堂已升级").
-define(_LANG_GUILD_CONTROL_SUCCESS, "操作成功").

-define(_LANG_GUILD_TRANSPORT_ALREADY_START, "本日已启动过帮会运镖").
-define(_LANG_GUILD_TRANSPORT_SUCCESS, "已开启帮会运镖，在有效时间内完成运镖可获得1.5倍经验与铜币奖励。").
-define(_LANG_GUILD_TEANSPORT_TO_WORLD, "~s帮会开启帮会运镖，大家从速前往！").
-define(_LANG_GUILD_TEANSPORT_CONTRIBUTION, "帮会物资不足，无法开启！").
-define(_LANG_GUILD_TEANSPORT_ACTIVITY, "帮会繁荣不足，无法开启！").

-define(_LANG_GUILD_CREATE_TO_WORLD, "恭喜 ~s 帮会成立，诚邀各位加盟。").

-define(_LANG_GUILD_ERROR_NOT_BATTLE_TIME,		"每天10时至18时才能对帮会宣战。").	
-define(_LANG_GUILD_ERROR_NOT_BATTLE_LEVEL,		"帮会需达到2级才能使用宣战功能。").	
-define(_LANG_GUILD_ERROR_TARGET_NOT_BATTLE_LEVEL,		"对方帮会未达到2级，不能宣战。").	
-define(_LANG_GUILD_ERROR_TARGET_ALREADY_DECLEAR,		"已对该帮会宣战，不能重复操作。").	
-define(_LANG_GUILD_ERROR_TARGET_ALREADY_WAR,		"已是敌对状态帮会，不需宣战。").	
-define(_LANG_GUILD_WAR, "~s 帮会已成为敌对帮会，击杀敌对帮会成员不会导致红名值。").

-define(_LANG_GUILD_ERROR_NO_DECLEAR_ITEM, "宣战令不足。").
-define(_LANG_GUILD_ERROR_NO_STOP_ITEM, "停战令不足。").
-define(_LANG_GUILD_ERROR_NO_CONTRIBUTION_ITEM, "物质不足。").
-define(_LANG_GUILD_ERROR_NO_CREATE_CARD_ITEM, "建卡令不足。").

-define(_LANG_GUILD_ERROR_WEAL_ALREADY_GET, "当日已领取过福利。").
-define(_LANG_GUILD_ERROR_NO_FEATS, "您的贡献不足。").
-define(_LANG_GUILD_ERROR_TIMERS_FEATS, "当日贡献使用次数已满。").

-define(_LANG_GUILD_ERROR_ITEM_REQUEST_NONE, "申請列表不存在。").
-define(_LANG_GUILD_ERROR_ITEM_REQUEST_HAS, "你已经申请过此物品。").
-define(_LANGUAGE_GUILD_MAIL_TITLE, "批准物品").
-define(_LANGUAGE_GUILD_MAIL_CONTENT_FAIL, "“~s”拒绝了您的申请物品请求。").
-define(_LANGUAGE_GUILD_MAIL_CONTENT_SUCCESS, "“~s”批准了您的申请物品请求，请查收附加物品。").

-define(_LANGUAGE_GUILD_MAIL_USER_MANAGE_TITLE, "公会成员管理").
-define(_LANGUAGE_GUILD_MAIL_CONTENT_KICK_OUT, "“~s” 把你踢出了公会。").

-define(_LANGUAGE_GUILD_SUMMON_COLLECT,"【~s】帮会开启了帮会采集【~s】,【~s】的帮会成员速回帮会营地采集宝贝,采集宝贝可获得丰厚的奖励哦!").
-define(_LANGUAGE_GUILD_SUMMON_MONSTER,"【~s】帮会召唤了帮会BOSS【~s】,【~s】的帮会成员速回帮会营地剿灭BOSS,剿灭BOSS可获得丰厚的奖励哦!").
-define(_LANGUAGE_GUILD_SUMMON_COLLECT1,"帮会营地开启了帮会采集【~s】已出现在{N帮会营地各处},帮会成员速回帮会营地采集宝贝,采集宝贝可获得丰厚的奖励哦!").
-define(_LANGUAGE_GUILD_SUMMON_MONSTER1,"帮会营地召唤了帮会BOSS【~s】已出现在{N帮会营地中间},帮会成员速回帮会营地剿灭BOSS,剿灭BOSS可获得丰厚的奖励哦!").

%%========================技能
-define(_LANG_SKILL_ERROR_LEVEL,"角色等级不足。").
-define(_LANG_SKILL_GUILD_ERROR_LEVEL,"演武堂等级不足。").
-define(_LANG_SKILL_NONE,"技能不存在。").
-define(_LANG_SKILL_LIFE_EXP_LESS,"历练不足。").
-define(_LANG_SKILL_PRE_NONE,"前置技能没达到。").
-define(_LANG_SKILL_GUILD_STUDY_NONE,"没有帮会不能学习帮会技能。").

%% ========================宠物斗坛
-define(_LANG_PET_BATTLE_SAME_PLAYER,<<"这是你自己的宠物，无法挑战">>).
-define(_LANG_PET_BATTLE_LESS_TOP,<<"该宠物的排名只有~p,别再欺负它了！">>).
-define(_LANG_PET_BATTLE_WINNING_STOP,<<"该宠物的连胜已被终结，无法挑战">>).
-define(_LANG_PET_BATTLE_WRONG_PET,<<"宠物信息出错，请刷新！">>).
-define(_LANG_PET_BATTLE_LESS_TIMES,<<"今日挑战次数已用完，需增加挑战次数！">>).
-define(_LANG_PET_BATTLE_NO_CD,<<"不需要重置挑战时间！">>).
-define(_LANG_PET_BATTLE_IN_CD,<<"挑战时间冷却中！">>).
-define(_LANG_PET_BATTLE_AWARD,<<"暂无奖励可领！">>).
-define(_LANG_PET_BATTLE_MAX_TIMES,<<"每天最多增加5次！">>).

%% ========================宠物
-define(_LANG_PET_ERROR_NONE,<<"该宠物不存在。">>).
-define(_LANG_PET_ERROR_UP,<<"宠物列表已经达到上限。">>).
-define(_LANG_PET_ERROR_FIGHT_NONE,<<"没有出战宠物,不能进行喂养。">>).
-define(_LANG_PET_ERROR_FIGHT_NONE1,<<"没有出战宠物,不能学习技能。">>).
-define(_LANG_PET_ERROR_FIGHT_NONE2,<<"出战宠物,不能放生。">>).
-define(_LANG_PET_ERROR_FIGHT_NONE3,<<"只有一个宠物不能放生。">>).
-define(_LANG_PET_ERROR_FIGHT_NONE4,<<"出战宠物,不能融合。">>).
-define(_LANG_PET_ERROR_FIGHT_NONE5,<<"被融合宠物不能穿戴装备！">>).
-define(_LANG_PET_ERROR_SKILL_NONE,<<"没有学习该技能,不能封印该技能。">>).
-define(_LANG_PET_ERROR_IS_THIS_STATE,<<"该宠物状态已经处于该状态。">>).
-define(_LANG_PET_ERROR_QUALIFICATION_UP,<<"该宠物的资质已达到上限,进阶会提升资质的上限。">>).
-define(_LANG_PET_ERROR_GROW_UP_UP,<<"该宠物的成长已达到上限,进阶会提升成长的上限。">>).
-define(_LANG_PET_ERROR_HAS_STUDY,<<"该技能等级已经学习,请学习更高技能。">>).
-define(_LANG_PET_ERROR_STUDY_LOW,<<"先学习低级技能才能学该技能。">>).
-define(_LANG_PET_ERROR_TYPE_HAS_STUDY,<<"此类型技能书已经学习。">>).
-define(_LANG_PET_ERROR_SKILL_CELL_FULL,<<"出战宠物的技能格已满。">>).
-define(_LANG_PET_ERROR_STAIRS_ITEM_NONE,<<"没有宠物进价丹。">>).
-define(_LANG_PET_ERROR_GROW_ITEM_NONE,<<"没有宠物成长提升符。">>).
-define(_LANG_PET_ERROR_QUALIFICATION_NONE,<<"没有宠物资质提升符。">>).
-define(_LANG_PET_ERROR_SEAL_NONE,<<"没有宠物技能封印符。">>).
-define(_LANG_PET_ERROR_MAX_STAIRS,<<"该宠物品阶达到上限。">>).

-define(_LANG_PET_ERROR_ITEM_TYPE_NONE, <<"不是宠物技能">>).
-define(_LANG_PET_ERROR_ENERGY_NONE, <<"宠物的饥饿度为0不能出战">>).
-define(_LANG_PET_ERROR_TYPE_NONE, <<"宠物洗髓不能同一类型">>).
-define(_LANG_PET_ERROR_TYPE_NONE1, <<"宠物洗髓类型不正确">>).
-define(_LANG_PET_MSG_NOT_ENOUGH_YUAN_BAO, <<"银两不足">>).
-define(_LANG_PET_ENERGY_FULL, <<"宠物饥饿度已满">>).
-define(_LANG_PET_ENERGY_ITEM_NONE, <<"宠物口粮不存在">>).

-define(_LANG_PET_CREATE_NOT_VALID,	<<"不能使用非法字符作为宠物名称。">>).	
-define(_LANG_PET_CREATE_TOO_LONG,	<<"宠物名称不能多于14个字符（7个汉字）。">>).	
-define(_LANG_PET_CREATE_TOO_SHORT,	<<"宠物名称不能少于4个字符（2个汉字）。">>).

%% ========================坐骑
-define(_LANG_MOUNTS_ERROR_NONE,<<"该坐骑不存在。">>).
-define(_LANG_MOUNTS_ERROR_UP,<<"坐骑列表已经达到上限。">>).
-define(_LANG_MOUNTS_ERROR_FIGHT_NONE,<<"没有出战坐骑,不能进行喂养。">>).
-define(_LANG_MOUNTS_ERROR_FIGHT_NONE1,<<"没有出战坐骑,不能学习技能。">>).
-define(_LANG_MOUNTS_ERROR_FIGHT_NONE2,<<"出战坐骑,不能放生。">>).
-define(_LANG_MOUNTS_ERROR_FIGHT_NONE3,<<"只有一个坐骑不能放生。">>).
-define(_LANG_MOUNTS_ERROR_FIGHT_NONE4,<<"出战坐骑,不能融合。">>).
-define(_LANG_MOUNTS_ERROR_SKILL_NONE,<<"没有学习该技能,不能封印该技能。">>).
-define(_LANG_MOUNTS_ERROR_IS_THIS_STATE,<<"该坐骑状态已经处于该状态。">>).
-define(_LANG_MOUNTS_ERROR_QUALIFICATION_UP,<<"该坐骑的资质已达到上限,进阶会提升资质的上限。">>).
-define(_LANG_MOUNTS_ERROR_GROW_UP_UP,<<"该坐骑的成长已达到上限,进阶会提升成长的上限。">>).
-define(_LANG_MOUNTS_ERROR_HAS_STUDY,<<"该技能等级已经学习,请学习更高技能。">>).
-define(_LANG_MOUNTS_ERROR_STUDY_LOW,<<"先学习低级技能才能学该技能。">>).
-define(_LANG_MOUNTS_ERROR_TYPE_HAS_STUDY,<<"此类型技能书已经学习。">>).
-define(_LANG_MOUNTS_ERROR_SKILL_CELL_FULL,<<"出战坐骑的技能格已满。">>).
-define(_LANG_MOUNTS_ERROR_STAIRS_ITEM_NONE,<<"没有坐骑进价丹。">>).
-define(_LANG_MOUNTS_ERROR_GROW_ITEM_NONE,<<"没有坐骑成长提升符。">>).
-define(_LANG_MOUNTS_ERROR_QUALIFICATION_NONE,<<"没有坐骑资质提升符。">>).
-define(_LANG_MOUNTS_ERROR_SEAL_NONE,<<"没有坐骑技能封印符。">>).
-define(_LANG_MOUNTS_ERROR_MAX_STAIRS,<<"该坐骑品阶达到上限。">>).
-define(_LANG_MOUNTS_ERROR_MAX_REFINED, <<"洗炼等级已达上限,请继续提升坐骑等级">>).
-define(_LANG_MOUNTS_ERROR_NO_COPPER, <<"铜币不够">>).
-define(_LANG_MOUNTS_ERROR_NO_YUANBAO, <<"元宝不够">>).
-define(_LANG_MOUNTS_FAIL_REFINED, <<"洗练失败">>).
-define(_LANG_MOUNTS_UP_REFINED, <<"洗炼等级提升！">>).


%% ====================== 黄钻
-define(_LANG_YELLOW_AWARD_ITEM_ERROR, <<"背包空间不足，不能领取">>).
-define(_LANG_YELLOW_AWARD_DAY_ERROR,<<"今日礼包已领取,请明天再来领取">>).
-define(_LANG_YELLOW_AWARD_ERROR,<<"您还未成为QQ黄钻贵族玩家">>).
-define(_LANG_YELLOW_AWARD_NEW_PLAYER_ERROR,<<"黄钻新手礼包已领取">>).

-define(_LANG_YELLOW_ERROR,<<"礼包不能领取">>).

-define(_LANG_YELLOW_AWARD_LEVEL_ERROR,<<"还未达到等级,礼包不能领取">>).


-define(_LANG_VIP_BAG_FULL,<<"背包空间不足，不能使用vip卡。">>).


%%========================每日奖励

-define(_LANG_DAILY_AWARD_COPPER, " ~s 铜币，").
-define(_LANG_DAILY_AWARD_BIND_COPPER, " ~s 绑定铜币，").
-define(_LANG_DAILY_AWARD_YUANBAO, " ~s 银两，").
-define(_LANG_DAILY_AWARD_BIND_YUANBAO, " ~s 绑定银两，").
-define(_LANG_DAILY_AWARD, "恭喜您，获得 ~s~s~s~s~s 奖励").
-define(_LANG_DAILY_AWARD_ITEM_ERROR, "背包空间不足，不能领取").
-define(_LANG_DAILY_AWARD_TIME_ERROR, "需要等待 ~s 秒才能领取奖励").


-define(_LANG_EXCHANGE_SUC, <<"兑换成功!">>).



%%------------------------活动奖励系统----------------------------------
-define(_LANG_ACTIVITY_COLLECT_FAIL, "条件不符合，领取失败。").
-define(_LANG_ACTIVITY_HAS_GET, "已领取，领取失败。").
-define(_LANG_ACTIVITY_HAS_EXPIRED, "活动已过期，领取失败。").
-define(_LANG_ACTIVITY_ERROR, "活动异常，领取失败。").

-define(_LANG_ACTIVITY_COLLECT_FAIL1, "等级未达到40级。").
-define(_LANG_ACTIVITY_COLLECT_FAIL2, "角色战斗力未达到12000。").
-define(_LANG_ACTIVITY_COLLECT_FAIL3, "没有参战坐骑。").
-define(_LANG_ACTIVITY_COLLECT_FAIL4, "坐骑战斗力未达到600。").
-define(_LANG_ACTIVITY_COLLECT_FAIL5, "没有参战宠物。").
-define(_LANG_ACTIVITY_COLLECT_FAIL6, "宠物战斗力未达到9000。").
-define(_LANG_ACTIVITY_COLLECT_FAIL7, "气海未达到15级。").
-define(_LANG_ACTIVITY_COLLECT_FAIL8, "武器未达到完美+5").
-define(_LANG_ACTIVITY_COLLECT_FAIL9, "消费未达到50Q点").

%%------------------------PK打死----------------------

-define(_LANG_PK_DEAD, "您已经被 ~s 玩家击杀").
-define(_LANG_PK_KILL, "你击杀了~s，pk值增加~p").

%% -----------------------天下第一-------------
-define(_LANG_FIRST_ENTER_AGAIN, "中途退出活动,需要等待30秒才可再次进入活动").
-define(_LANG_FIRST_NOT_TIME, "离开活动后7分钟才能再次进入").
-define(_LANG_FIRST_ENTER_ERROR, "进入天下第一活动地图错误，请重新刷新").
-define(_LANG_FIRST_PLAYER_FULL, "天下第一活动人数已满").
-define(_LANG_FIRST_LEVEL_ERROR, "等级小于40级").
-define(_LANG_FIRST_NOT_OPEN, "天下第一活动未开启").


%% ------------------------战场-------------
-define(_LANG_WAR_ENTER_AGAIN, "中途退出活动,需要等待2分钟才可再次进入活动").

-define(_LANG_WAR_NOT_TIME, "离开战场后7分钟才能再次进入。").
-define(_LANG_WAR_ENTER_ERROR, "进入战场错误，请重新刷新。").
-define(_LANG_WAR_PLAYER_FULL, "战场人数已满。").
-define(_LANG_WAR_LEVEL_ERROR, "等级不符合。").
-define(_LANG_WAR_NOT_OPEN, "自由战场未开启。").

%% ------------------------公会乱斗-------------
-define(_LANG_GUILD_FIGHT_NOT_OPEN, "帮会战活动未开启").
-define(_LANG_GUILD_FIGHT_NO_GUILD, "未加入公会不能参与帮会战").

%% ----------------------- 王城战 ------------------------
-define(_LANG_KING_WAR_NOT_OPEN, "王城战未开启").
-define(_LANG_KING_WAR_FIRST, "首次攻城不能加入防守方").
-define(_LANG_KING_WAR_NO_MONEY, "帮会财富不足").
-define(_LANG_KING_WAR_ACTIVE_NOT_OPEN, "竞拍活动未开启").
-define(_LANG_KING_WAR_IS_CITY_MASTER, "已经是王城帮会了").
-define(_LANG_KING_WAR_FIRST_AUCTION, "已经是竞拍第一名了").
-define(_LANG_KING_WAR_NO_PRESIDENT, "帮主和副帮主才能竞拍").
-define(_LANG_KING_WAR_MAX_GUARD_NUM, "守卫数量已满！").
-define(_LANG_KING_WAR_NOT_KING_GUILD, "您还不是王城帮会！").
-define(_LANG_KING_WAR_IN_DUPLICATE, "正在副本中，请先出副本参与攻城战").


%%-----------------------优惠商品-------------------
-define(_LANG_SHOP_LIMIT, "本次优惠活动，该商品每人只限购买~p件！").

-define(_LANG_SMSHOP_ITEM_NONE, <<"物品已被购买。">>).

-define(_LANG_SMSHOP_ITEM_NONE1, <<"商店里不存在该物品。">>).
-define(_LANG_SMSHOP_ITEM_NONE2, <<"模板表不存在该物品。">>).
-define(_LANG_SMSHOP_ITEM_PAY_TYPE_ERROR, <<"物品支付类型错误。">>).

%%-----------------------系统公告广播--------------------
%%-----------------------结婚提示--------------------
-define(_LANG_MARRY_GIFT_1,"{N~s}来贺，赠文银{D~p}两").
-define(_LANG_MARRY_GIFT_2,"{N~s}来贺，赠铜钱{D~p}文").
-define(_LANG_MARRY_START,"新郎{N~s}新娘{N~s}开始拜堂").
-define(_LANG_MARRY_START1,"一拜天地").
-define(_LANG_MARRY_START2,"二拜高堂").
-define(_LANG_MARRY_START3,"夫妻对拜").
-define(_LANG_MARRY_START4,"送入洞房").
-define(_LANG_MARRY_START5,"{N~s}与{N~s}完成拜堂仪式，现场刷出大量[婚礼宝箱]!").

%%-----------------------系统异常提示--------------------
-define(_LANG_ER_WRONG_VALUE,"非法操作！").
-define(_LANG_ER_NOT_ENOUGH_POWER, "对不起，您没有足够的权限，操作失败！").		
-define(_LANG_ER_NOT_EXSIT_DATA,"系统繁忙，请您联系我们客服可即时解决！谢谢！").	%%配置数据不存在
-define(_LANG_ER_NOT_ON_LINE, "对不起，该玩家不在线！").
-define(_LANG_ER_NOT_ENOUGH_YUANBAO, "对不起，您的银两不足~p，操作失败！").
-define(_LANG_ER_NOT_ENOUGH_COPPER, "对不起，您的铜币不足~p，操作失败！").
-define(_LANG_ER_NOT_ENOUGH_LEVEL, "对不起，您的等级不足~p级，操作失败！").
-define(_LANG_ER_NOT_NEAR_NPC, "对不起，您需要在[~s]旁才能进行此操作！").
-define(_LANG_ER_NOT_WORLD_MAP, "副本地图请使用退出按钮！").

-define(_LANG_ER_NOT_ENOUGH_AMITY, "对不起，该好友的好友度不足，操作失败！").
-define(_LANG_ER_FRIEND_NOT_ENOUGH_LEVEL, "对不起，该好友的等级不足~p级，操作失败！").
-define(_LANG_ER_IS_PROPOSING, "对不起，您已发起求婚，请静候佳音！").
-define(_LANG_ER_IS_MARRYED, "对不起，您已嫁人不可再婚！").
-define(_LANG_ER_IS_MARRY, "对不起，已婚人员不能被二次求婚！").
-define(_LANG_ER_IS_PROPOSED, "对不起，有人抢先求婚了，请几分钟后再试试！").
-define(_LANG_ER_NO_PROPOSE, "对不起，您没有被求婚或已超时，操作失败！").
-define(_LANG_ER_MARRY_LIMIT, "对不起，对方条件不足，操作失败！").
-define(_LANG_ER_NOT_EXSIT_MARRY, "对不起，该婚礼不存在！").
-define(_LANG_ER_MARRY_IS_FINISH, "对不起，该婚礼已结束！").
-define(_LANG_ER_NO_FREE_CANDY, "对不起，免费发送喜糖次数已用完！").

%%-----------------------副本神游提示--------------------
-define(_LANG_SHENYOU_NO_DUPLICATE,"没有该副本").
-define(_LANG_SHENYOU_CAN_NOT,"该副本不能神游").
-define(_LANG_SHENYOU_LESS_TIME,"上次神游未结束，请再等~p秒").
-define(_LANG_SHENYOU_LESS_LEVEL,"您的低于~p级").
-define(_LANG_SHENYOU_LESS_TIMES,"副本次数不足").
-define(_LANG_SHENYOU_LESS_FIGHT,"您的战斗力低于~p").
-define(_LANG_SHENYOU_LESS_EXP_PILL,"您的经验丹不够").
-define(_LANG_SHENYOU_LESS_COPPER,"铜币不足~p").
-define(_LANG_SHENYOU_LESS_YUANBAO,"银两不足~p两").
-define(_LANG_SHENYOU_TIME_OVER,"您的副本神游时间已到").
-define(_LANG_SHENYOU_NOT_ACTIVE,"没有进行中的神游").

%%-------------银行投资----------
-define(_LANG_BANK_ERROR_EXISTS,"对不起，此类型已经购买，不能重复购买！").
-define(_LANG_BANK_ERROR_BUY_LIMIT,"对不起，最高只可以购买~p银两！").
-define(_LANG_BANK_ERROR_UNEXIST,"对不起，您还没有购买该类型产品！").
-define(_LANG_BANK_ERROR_AWARD_IS_RECEIVED,"对不起，您今天已经领取过该奖励！").

