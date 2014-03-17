package sszt.core.manager
{
	import flash.external.ExternalInterface;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.LayerType;
	import sszt.core.data.module.ModuleType;
	import sszt.interfaces.path.IPathManager;
	
	public class PathManager implements IPathManager
	{
		/**
		 * 注册登陆地址
		 */		
		private var _registerPath:String;
		private var _loginPath:String;
		/**
		 * 网站地址
		 */	
		private var _site:String;
		private var _clientPath:String;
		private var _webservicePath:String;
		/**
		 * 充值地址
		 */		
		private var _fillPath:String;
		/**
		 * 新手礼包激活码页面
		 */		
		private var _activityCodePath:String;
		/**
		 * 媒体礼包激活页面 
		 */
		private var _luckCodePath:String;
		/**
		 * 类型2媒体礼包激活页面 
		 */
		private var _luckCodePathTwo:String;
		/**
		 * GM链接地址
		 */
		private var _gmLinkPath:String;
		/**
		 * 防沉迷地址
		 */		
		private var _adlsPath:String;
		private var _officalPath:String;
		private var _selectServerPath:String;
		/**
		 * 论坛入口
		 */		
		private var _bbsPath:String;
		
		private var _statPath:String;
		
		private var _payYellowPath:String;
		private var _payYellowYeayPath:String;
		/**
		 * 排行地址
		 */		
		private var _rankPath:String;
		/**
		 * facebook查询地址
		 */		
		private var _facebookQueryPath:String;
		
		public function PathManager(config:XML)
		{
			_registerPath = String(config.config.REGISTER_PATH.@value);
			_site = String(config.config.SITE.@value);
			_clientPath = String(config.config.SITE_CLIENT.@value);
			_webservicePath = String(config.config.WEBSERVICE_PATH.@value);
			_fillPath = String(config.config.FILL_PATH.@value);
			_activityCodePath = String(config.config.ACTIVITYCODE.@value);
			_luckCodePath = String(config.config.LUCKCODE.@value);
			_luckCodePathTwo = String(config.config.LUCKCODE_TWO.@value);
			_adlsPath = String(config.config.ADLSPATH.@value);
			_officalPath = String(config.config.OFFICAL_PATH.@value);
			_selectServerPath = String(config.config.SELECTSERVER_PATH.@value);
			_bbsPath = String(config.config.BBS.@value);
			_loginPath = String(config.config.LOGIN_PATH.@value);
			_statPath = String(config.config.STAT_PATH.@value);
			_rankPath = String(config.config.RANK_PATH.@value);
			
			_payYellowPath = String(config.config.PAY_YELLOW_PATH.@value);
			_payYellowYeayPath = String(config.config.PAY_YELLOW_YEAR_PATH.@value);
			
			_gmLinkPath = String(config.config.GM_LINK.@value);
			_facebookQueryPath = String(config.config.FACEBOOKQUERY.@value);
		}
		
		public function getModulePath(moduleId:int):String
		{
//			var pre:String = _clientPath + "client/";
			var pre:String;
			if(CommonConfig.LANGUAGE == "" || CommonConfig.LANGUAGE == "cn")pre = _clientPath + "client/";
			else pre = _clientPath + CommonConfig.LANGUAGE + "_client/";
			switch(moduleId)
			{
				case ModuleType.SCENE:break;
				case ModuleType.NAVIGATION:
					return pre + "Cookieadministratorwww.163.com[10].txt";
				case ModuleType.NPCSTORE:
				case ModuleType.WAREHOUSE:
				case ModuleType.BAGSELL:
				case ModuleType.ONLINEREWARD:
//				case ModuleType.Exchange:
				case ModuleType.VIP:
					return pre + "Cookieadministratorwww.163.com[30].txt";
				case ModuleType.CHAT:
					return pre + "Cookieadministratorwww.163.com[11].txt";
				case ModuleType.TASK:
					return pre + "Cookieadministratorwww.163.com[12].txt";
				case ModuleType.BAG:
					return pre + "Cookieadministratorwww.163.com[13].txt";
				case ModuleType.STALL:
					return pre + "Cookieadministratorwww.163.com[14].txt";
				case ModuleType.DUPLICATESTORE:
				case ModuleType.Exchange:
				case ModuleType.STORE:
					return pre + "Cookieadministratorwww.163.com[15].txt";
				case ModuleType.ROLE:
					return pre + "Cookieadministratorwww.163.com[16].txt";
				case ModuleType.MAIL:
					return pre + "Cookieadministratorwww.163.com[17].txt";
				case ModuleType.CONSIGN:
					return pre + "Cookieadministratorwww.163.com[18].txt";
				case ModuleType.FRIENDS:
					return pre + "Cookieadministratorwww.163.com[19].txt";
				case ModuleType.SETTING:
					return pre + "Cookieadministratorwww.163.com[20].txt";
				case ModuleType.SKILL:
					return pre + "Cookieadministratorwww.163.com[21].txt";
				case ModuleType.FURNACE:
					return pre + "Cookieadministratorwww.163.com[22].txt";
				case ModuleType.CLUB:
					return pre + "Cookieadministratorwww.163.com[23].txt";
				case ModuleType.PET:
					return pre + "Cookieadministratorwww.163.com[24].txt";
				case ModuleType.ACTIVITY:
				case ModuleType.OPENACTIVITY:
				case ModuleType.FIRSTRECHARGE:
				case ModuleType.SEVENACTIVITY:
				case ModuleType.YELLOWBOX:
				case ModuleType.PAYTAGVIEW:
				case ModuleType.CONSUMTAGVIEW:
				case ModuleType.MID_AUTUMN_ACTIVITY:
				case ModuleType.MERGE_SERVER:
					return pre + "Cookieadministratorwww.163.com[25].txt";
				case ModuleType.RANK:
					return pre + "Cookieadministratorwww.163.com[26].txt";
				case ModuleType.BOX:
					return pre + "Cookieadministratorwww.163.com[27].txt";
				case ModuleType.PERSONAL:
					return pre + "Cookieadministratorwww.163.com[28].txt";
				case ModuleType.FIREBOX:
					return pre + "Cookieadministratorwww.163.com[29].txt";
				case ModuleType.MOUNTS:
					return pre + "Cookieadministratorwww.163.com[31].txt";
				case ModuleType.LOGINREWARD:
					return pre + "Cookieadministratorwww.163.com[33].txt";
				case ModuleType.SWORDSMAN:
					return pre + "Cookieadministratorwww.163.com[34].txt";
				case ModuleType.TARGET:
					return pre + "Cookieadministratorwww.163.com[35].txt";
				case ModuleType.PVP1:
					return pre + "Cookieadministratorwww.163.com[36].txt";
				case ModuleType.Challenge:
					return pre + "Cookieadministratorwww.163.com[37].txt";
				case ModuleType.QUIZ:
					return pre + "Cookieadministratorwww.163.com[38].txt";
				case ModuleType.MARRIAGE:
					return pre + "Cookieadministratorwww.163.com[39].txt";
				case ModuleType.PET_PVP:
					return pre + "Cookieadministratorwww.163.com[40].txt";
				case ModuleType.TEMPLATE:
					return pre + "Cookieadministrator@www.163.com[-1].txt";
			}
			return "";
		}

		public function getModulAssetsPath(moduleId:int):Array
		{
			var pre:String;
			if(CommonConfig.LANGUAGE == "" || CommonConfig.LANGUAGE == "cn")pre = _clientPath + "asset/";
			else pre = _clientPath + CommonConfig.LANGUAGE + "_asset/";
			
			switch(moduleId)
			{
				case ModuleType.BAG:
					return [pre + "bag_bg.swf"];
				case ModuleType.ROLE:
					return [pre + "role_bg.swf"];	
				case ModuleType.CLUB:
					return [pre + "club_bg.swf"];	
				case ModuleType.SKILL:
					return [pre + "skill_bg.swf"];	
				case ModuleType.CONSIGN:
					return [pre + "consign_bg.swf"];	
				case ModuleType.BOX:
					return [pre + "box_bg.swf"];	
				case ModuleType.FURNACE:
					return [pre + "furnace_bg.swf"];
				case ModuleType.FIREBOX:
					return [pre + "furnace_bg.swf"];
				case ModuleType.DUPLICATESTORE:
				case ModuleType.STORE:
					return [pre + "store_bg.swf"];
				case ModuleType.PET:
					return [pre + "pet_bg.swf"];
				case ModuleType.MOUNTS:
					return [pre + "pet_bg.swf"];
				case ModuleType.TARGET:
					return [pre + "target_bg.swf"];
				case ModuleType.PVP1:
					return [pre + "pvp_bg.swf"];
				case ModuleType.Challenge:
					return [pre + "challenge_bg.swf"];
//				case ModuleType.QUIZ:
//					return [pre + "quiz_bg.swf"];	
				case ModuleType.FIRSTRECHARGE:
					return [pre + "firstPay_bg.swf"];	
				case ModuleType.YELLOWBOX:
					return [pre + "yellowBox_bg.swf"];
				case ModuleType.PAYTAGVIEW:
					return [pre + "firstPay_bg.swf"];
				case ModuleType.CONSUMTAGVIEW:
					return [pre + "firstPay_bg.swf"];
				case ModuleType.SEVENACTIVITY:
					return [pre + "sevenActivity_bg.swf"];	
				case ModuleType.MARRIAGE:
					return [pre + "wedding_bg.swf"];	
				case ModuleType.MID_AUTUMN_ACTIVITY:
				case ModuleType.MERGE_SERVER:
					return [pre + "midAutmn_bg.swf"];
				case ModuleType.PET_PVP:
					return [pre + "petpvp_bg.swf"];
			}
			return [];
		}
		
		public function getModuleClassPath(moduleId:int):String
		{
			switch(moduleId)
			{
				case ModuleType.SCENE:
					return "sszt.scene.SceneModule";
				case ModuleType.NAVIGATION:
					return "sszt.navigation.NavigationModule";
				case ModuleType.BAG:
					return "sszt.bag.BagModule";
				case ModuleType.STALL:
					return "sszt.stall.StallModule";
				case ModuleType.STORE:
					return "sszt.store.StoreModule";
//				case ModuleType.ROLECHOISE:
//					return "sszt.roleChoise.RoleChoiseModule";
				case ModuleType.ROLE:
					return "sszt.role.RoleModule";
				case ModuleType.TASK:
					return "sszt.task.TaskModule";
				case ModuleType.NPCSTORE:
					return "sszt.common.npcStore.NPCStoreModule";
				case ModuleType.MAIL:
					return "sszt.mail.MailModule";
				case ModuleType.CONSIGN:
					return "sszt.consign.ConsignModule";
				case ModuleType.CHAT:
					return "sszt.chat.ChatModule";
				case ModuleType.FRIENDS:
					return "sszt.friends.FriendsModule";
				case ModuleType.SETTING:
					return "sszt.setting.SettingModule";
				case ModuleType.SKILL:
					return "sszt.skill.SkillModule";
				case ModuleType.FURNACE:
					return "sszt.furnace.FurnaceModule";
				case ModuleType.WAREHOUSE:
					return "sszt.common.wareHouse.WareHouseModule";
				case ModuleType.CLUB:
					return "sszt.club.ClubModule";
				case ModuleType.PET:
					return "sszt.pet.PetModule";
				case ModuleType.ACTIVITY:
					return "sszt.activity.ActivityModule";
				case ModuleType.OPENACTIVITY:
					return "sszt.openActivity.OpenActivityModule";
				case ModuleType.RANK:
					return "sszt.rank.RankModule";
				case ModuleType.VIP:
					return "sszt.common.vip.VipModule";
				case ModuleType.BOX:
					return "sszt.box.BoxModule";
				case ModuleType.PERSONAL:
					return "sszt.personal.PersonalModule";
				case ModuleType.FIREBOX:
					return "sszt.firebox.FireBoxModule";
				case ModuleType.MOUNTS:
					return "sszt.mounts.MountsModule";
				case ModuleType.DUPLICATESTORE:
					return "sszt.duplicateStore.DuplicateStoreModule";
//				case ModuleType.ENTHRAL:
//					return "sszt.common.enthral.EnthralModule";
				case ModuleType.BAGSELL:
					return "sszt.common.bagSell.BagSellModule";
				case ModuleType.ONLINEREWARD:
					return "sszt.common.onlineReward.OnlineRewardModule";
				case ModuleType.LOGINREWARD:
					return "sszt.welfare.WelfareModule";
				case ModuleType.SWORDSMAN:
					return "sszt.swordsman.SwordsmanModule";
				case ModuleType.TARGET:
					return "sszt.target.TargetModule";
				case ModuleType.PVP1:
					return "sszt.pvp.PVPModule";
				case ModuleType.Exchange:
					return "sszt.exStore.ExStoreModule";
				case ModuleType.Challenge:
					return "sszt.challenge.ChallengeModule";
				case ModuleType.QUIZ:
					return "sszt.quiz.QuizModule";
				case ModuleType.FIRSTRECHARGE:
					return "sszt.firstRecharge.FirstRechargeModule";
				case ModuleType.SEVENACTIVITY:
					return "sszt.sevenActivity.SevenActivityModule";
				case ModuleType.YELLOWBOX:
					return "sszt.yellowBox.YellowBoxModule";
				case ModuleType.PAYTAGVIEW:
					return "sszt.payTagView.PayTagViewModule";
					break;
				case ModuleType.CONSUMTAGVIEW:
					return "sszt.consumTagView.ConsumTagViewModule";
					break;
				case ModuleType.MARRIAGE:
					return "sszt.marriage.MarriageModule";
				case ModuleType.MID_AUTUMN_ACTIVITY:
					return "sszt.midAutumnActivity.MidAutumnActivityModule";
				case ModuleType.MERGE_SERVER:
					return "sszt.mergeServer.MergeServerModule";
				case ModuleType.PET_PVP:
					return "sszt.petpvp.PetPVPModule";
				case ModuleType.TEMPLATE:
					return "sszt.template.TemplateModule";
			}
			return "";
		}
		
		public function getFacebookQueryPath(id:String,serverId:int,nick:String):String
		{
			return _facebookQueryPath.split("{1}").join(id).split("{2}").join(String(serverId)).split("{3}").join(nick);
		}
		
		public function getFillPath():String
		{
			return _fillPath;
		}
		
		public function getActivityCode():String
		{
			return _activityCodePath;
		}
		
		public function getLuckCode():String
		{
			return _luckCodePath;
		}
		
		public function getLuckCodeTwo():String
		{
			return _luckCodePathTwo;
		}
		
		public function getItemPath(path:String,layerType:String,dir:int = 0,action:int = 0):String
		{
			if(layerType == LayerType.SCENE_PLAYER)
			{
				return _site + "img/items1/" + path + "/" + layerType + dir + "_" + action + ".swf";
			}
			return _site + "img/items1/" + path + "/" + layerType + ".swf";
		}
		
		public function getRankPath():String
		{
			return _rankPath;
		}
		
		public function getDisplayItemPath(path:String,layerType:String):String
		{
			if(layerType == LayerType.SCENE_ICON)
				return _site + "img/items/" + path + "/" + layerType + ".png";
			else if(layerType == LayerType.SCENE_DROP)
				return _site + "img/items/" + path + "/" + layerType + ".swf";
			return _site + "img/items/" + path + "/" + layerType + ".jpg"; 
//			return _site + "img/items1/" + path + "/" + layerType + ".swf";
		}
		
		public function getFunctionGuidePath(path:String):String
		{
			return _site + "img/guide/" + path + ".jpg";
		}
		
		public function getItemClassPath(path:String,layerType:String):String
		{
			return "sszt.item" + path + "_" + layerType;
		}
		public function getSceneItemsPath(path:String,layerType:String):String
		{
			return _site + "img/items/" + path + "/" + layerType + ".swf";
		}
		public function getSceneMonsterItemsPath(path:String):String
		{
			return _site + "img/sceneMonster/" + path + ".swf";
		}
		public function getSceneMonsterShowPath(path:String):String
		{
			return _site + "img/sceneMonster1/" + path + ".png";
		}
		public function getScenePetItemPath(path:String,layerType:String):String
		{
//			return _site + "img/items1/" + path + "/" + layerType + ".swf";
			return _site + "img/pet/" + path + ".swf";
		}
		
		public function getSceneNpcItemsPath(path:String):String
		{
			return _site + "img/sceneNpc/" + path + ".swf";
		}
		
		public function getSceneNpcAvatarPath(path:String):String
		{
			return _site + "img/sceneNpc/" + path + ".png";
		}
		
		public function getTargetPath(path:String):String
		{
			return _site + "img/targetIcon/" + path + ".jpg";
		}
		
		public function getChallengePath(path:String):String
		{
			return _site + "img/challenge/" + path + ".png";
		}
		
		public function getSceneCollectItemPath(path:String):String
		{
			return _site + "img/collects/" + path + ".swf";
		}
		
		public function getSceneCarItemPath(path:String):String
		{
			return _site + "img/car/" + path + ".swf";
		}
		
		public function getAssetPath(path:String):String
		{
			var pre:String;
			if(CommonConfig.LANGUAGE == "" || CommonConfig.LANGUAGE == "cn")pre = _clientPath + "asset/";
			else pre = _clientPath + CommonConfig.LANGUAGE + "_asset/";
			return pre + path;
		}
		
		public function getCommonSoundPath():String
		{
			return _site + "sound/sound.swf";
		}
		public function getSoundClassPath(path:String):String
		{
			return "mhsm.sound.S" + path;
		}
		public function getMusicPath(music:int):String
		{
			return _site + "music/" + music + ".mp3";
		}
		
		public function getWaitingPath(type:int):String
		{
			return _site + "img/waitingbg/waitingbg" + type + ".swf";
		}
		public function getWaitingClassPath(type:int):String
		{
			return "mhqy.Waitting" + type;
		}
		
		public function getConfigZipPath():String
		{
			var pre:String = "";
			if(CommonConfig.LANGUAGE != "" && CommonConfig.LANGUAGE != "cn")pre = CommonConfig.LANGUAGE + "_";
			return _webservicePath + pre + "sszt.txt?" + Math.random();
		}
		
		public function getServerListPath():String
		{
			return _webservicePath + "ServerList.ashx";
		}
		
		public function getWebServicePath(path:String):String
		{
			return _webservicePath + path;
		}
		
		public function getSceneSpaPath(sex:int):String
		{
			return _site + "img/spa1/" + sex + ".swf";
		}
		public function getSceneSwimPath(sex:int):String
		{
			return _site + "img/swim1/" + sex + ".swf";
		}
		
		public function getFacePath():String
		{
//			return _site + "img/face/1.swf";
			return _site + "img/face1/1.swf";
		}
		
		public function getLanagerPath(type:String):String
		{
			if(type == "")return "languageC.txt";
			return type + "_languageC.txt";
		}
		
		
		public function getMoviePath(path:String):String
		{
			return _site + "img/effects/" + path + ".swf";
//			return _site + "img/effects1/" + path + ".swf";
		}
		
		public function getSceneConfigPath(picPath:String):String
		{
			return _site + "img/map/" + picPath + "/client1.txt";
		}
		
		public function getScenePreMapPath(path:String):String
		{
//			return _site + "img/map/" + id + "/pre.swf";
			return _site + "img/map/" + path + "/pre.jpg";
		}
		public function getScenePreMapClassPath(id:int):String
		{
			return "sszt.map" + id + "_pre";
		}
		
		public function getSceneDetailMapPath(path:String,row:int,col:int):String
		{
//			return _site + "img/map/" + id + "/" + row + "_" + col + ".swf";
			return _site + "img/map/" + path + "/" + row + "_" + col + ".jpg";
		}
		public function getSceneDetailMapClassPath(id:int,row:int,col:int):String
		{
			return "sszt.map" + id + "_" + row + "_" + col;
		}
		
		public function getSceneDetailClassPath(id:int,x:int,y:int):String
		{
			return "bxgh.map" + id + "_" + x + "_" + y;
		}
		public function getStorePeriPath():String
		{
			return _site + "img/face1/storePeri.png";
		}
		public function getActivityBannerPath(id:int):String
		{
			//id = 0:单挑王 　1:京城捉贼 　2:惩恶扶伤　3:京城巡逻　4:答题
			return _site + "img/banner/"+id+".png";
		}
		public function getBannerPath(name:String):String
		{
			return _site + "img/banner/" + name;
		}
		public function getWorldBossPath(name:String):String
		{
			//id:图片  header_id:头像
			return _site + "img/worldBoss/"+name+".jpg";
		}
		public function getWebLoginPath():String
		{
			return _loginPath;
		}
		
		public function getLoginPath():String
		{
			return _loginPath;
		}
		
		public function getStatPath():String
		{
			return _statPath;
		}
		
		public function getOfficalPath():String
		{
			return _officalPath;
		}
		
		public function getSelectServerPath():String
		{
			return _selectServerPath;
		}
		
		public function getBBSPath():String
		{
			return _bbsPath;
		}
		
		public function getRegisterPath():String
		{
			return _registerPath;
		}
		
		public function getAdlsPath():String
		{
			return _adlsPath;
		}
		
		public function getGMLinkPath():String
		{
			return _gmLinkPath;
		}
		
		
		public function getPayYellowPath():String
		{
			return _payYellowPath;
		}
		
		public function getPayYellowYeayPath():String
		{
			return _payYellowYeayPath;
		}
	}
}