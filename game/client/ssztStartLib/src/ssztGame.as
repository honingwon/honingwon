package
{
	import com.greensock.easing.Cubic;
	
	import fl.controls.CheckBox;
	import fl.managers.StyleManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.DecodeType;
	import sszt.constData.DirectType;
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.CellAssetCaches;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.caches.NumberCache;
	import sszt.core.caches.PlayerIconCaches;
	import sszt.core.caches.ToolTipCaches;
	import sszt.core.caches.VipIconCaches;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.LayerInfo;
	import sszt.core.data.SystemDateInfo;
	import sszt.core.data.activity.ActiveBagTemplateInfoList;
	import sszt.core.data.activity.ActiveRewardsTemplateInfoList;
	import sszt.core.data.activity.ActiveTemplateInfoList;
	import sszt.core.data.activity.ActivityPvpTemplateList;
	import sszt.core.data.activity.ActivityTaskTemplateInfoList;
	import sszt.core.data.activity.ActivityTemplateInfoList;
	import sszt.core.data.activity.BossTemplateInfoList;
	import sszt.core.data.activity.WelfareTemplateInfoList;
	import sszt.core.data.bossWar.BossWarTemplateList;
	import sszt.core.data.box.BoxTemplateList;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.characterActionInfos.SceneCharacterActions;
	import sszt.core.data.characterActionInfos.SceneMonsterActionInfos;
	import sszt.core.data.characterActionInfos.SceneMountsActionInfo;
	import sszt.core.data.club.ClubFurnaceTemplateList;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.data.club.ClubLotteryTemplateList;
	import sszt.core.data.club.ClubMonsterTemplateList;
	import sszt.core.data.club.ClubShopLevelTemplateList;
	import sszt.core.data.club.ClubSkillTemplateList;
	import sszt.core.data.club.camp.ClubCampCallTemplateList;
	import sszt.core.data.collect.CollectTemplateList;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.copy.duplicate.DuplicateMissionList;
	import sszt.core.data.dailyAward.DailyAwardTemplateList;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.entrustment.EntrustmentTemplateList;
	import sszt.core.data.equipStrength.EquipStrengthTemplateList;
	import sszt.core.data.expList.ExpList;
	import sszt.core.data.friendship.FriendshipTemplateList;
	import sszt.core.data.furnace.CuiLianTemplateList;
	import sszt.core.data.furnace.ForgeTemplateList;
	import sszt.core.data.furnace.FormulaDataTemplateList;
	import sszt.core.data.furnace.FormulaTemplateList;
	import sszt.core.data.furnace.FuseTemplateList;
	import sszt.core.data.furnace.FurnaceIntroList;
	import sszt.core.data.furnace.LuckComposeTemplateList;
	import sszt.core.data.furnace.PromotionItemTemplateList;
	import sszt.core.data.furnace.StrengParametersTemplateList;
	import sszt.core.data.furnace.StrengTemplateList;
	import sszt.core.data.furnace.StrengthenTemplateList;
	import sszt.core.data.furnace.parametersList.DecomposeCopperTemplateList;
	import sszt.core.data.furnace.parametersList.DecomposeTemplateList;
	import sszt.core.data.furnace.parametersList.HoleTemplateList;
	import sszt.core.data.furnace.parametersList.PickStoneTemplateList;
	import sszt.core.data.furnace.parametersList.RebuildTemplateList;
	import sszt.core.data.furnace.parametersList.StoneComposeTemplateList;
	import sszt.core.data.furnace.parametersList.StoneEnchaseTemplateList;
	import sszt.core.data.furnace.parametersList.StoneMatchTemplateList;
	import sszt.core.data.furnace.parametersList.StrengAddsuccrateTemplateList;
	import sszt.core.data.furnace.parametersList.StrengCopperTemplateList;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.item.OrangeItemTemplateList;
	import sszt.core.data.item.PlaceCategoryTemaplteList;
	import sszt.core.data.item.SuitNumberList;
	import sszt.core.data.item.SuitTemplateList;
	import sszt.core.data.levelUpDeploy.LevelUpDeployTemplateList;
	import sszt.core.data.loginReward.LoginRewardTemplateList;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.ModuleList;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.core.data.mounts.MountsDiamondTemplateList;
	import sszt.core.data.mounts.MountsGrowupTemplateList;
	import sszt.core.data.mounts.MountsQualificationTemplateList;
	import sszt.core.data.mounts.MountsRefinedTemplateList;
	import sszt.core.data.mounts.MountsStarTemplateList;
	import sszt.core.data.mounts.MountsUpgradeTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.SevenActivityTemplateList;
	import sszt.core.data.openActivity.YellowBoxTemplateList;
	import sszt.core.data.personal.template.PersonalCityTemplateList;
	import sszt.core.data.personal.template.PersonalProvinceTemplateList;
	import sszt.core.data.personal.template.PersonalStarTemplateList;
	import sszt.core.data.pet.PetDialogTemplateList;
	import sszt.core.data.pet.PetDiamondTemplateList;
	import sszt.core.data.pet.PetGrowupExpTemplateList;
	import sszt.core.data.pet.PetGrowupTemplateList;
	import sszt.core.data.pet.PetQualificationExpTemplateList;
	import sszt.core.data.pet.PetQualificationTemplateList;
	import sszt.core.data.pet.PetStarTemplateList;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.pet.PetUpgradeTemplateList;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.shenMoGuide.GuideInfoList;
	import sszt.core.data.shop.ShopTemplateList;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.data.socket.SocketInfo;
	import sszt.core.data.swordsman.SwordsmanTemplateList;
	import sszt.core.data.target.TargetTemplateList;
	import sszt.core.data.task.TaskTemplateList;
	import sszt.core.data.titles.TitleTemplateList;
	import sszt.core.data.veins.VeinsExtraTemplateList;
	import sszt.core.data.veins.VeinsTemplateList;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.DescriptManager;
	import sszt.core.manager.FaceManager;
	import sszt.core.manager.FontManager;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.LayerManager;
	import sszt.core.manager.PathManager;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.pool.CommonEffectPoolManager;
	import sszt.core.proxy.LoadLoginDataProxy;
	import sszt.core.proxy.LoadMovieProxy;
	import sszt.core.proxy.LoginSocketProxy;
	import sszt.core.socketHandlers.SetSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.CellDoubleClickHandler;
	import sszt.core.utils.MapSearch;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.utils.WordFilterUtils;
	import sszt.core.view.FriendIconList;
	import sszt.core.view.MailIcon;
	import sszt.core.view.WaitingLoadingPanel;
	import sszt.core.view.assets.AssetSource;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.paopao.PaopaoSoure;
	import sszt.core.view.timerEffect.TimerEffectSource;
	import sszt.events.CommonModuleEvent;
	import sszt.events.LoaderEvent;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.font.IFontManager;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.interfaces.loader.IZipArchive;
	import sszt.interfaces.loader.IZipFile;
	import sszt.interfaces.loader.IZipLoader;
	import sszt.module.ModuleEventDispatcher;
	import sszt.navigation.NavigationModule;
	import sszt.scene.SceneModule;
	import sszt.task.TaskModule;
	import sszt.ui.UIManager;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	
	public class ssztGame extends Sprite
	{	
		private var _config:XML;
		private var _commonConfig:XML;
		private var _useCache:Boolean;
		private var _sitePath:String;
		private var _requestPath:String;
		private var _addProgress:Function;
		private var _nick:String;
		private var _parentDispose:Function;
		private var _user:String;
		private var _pass:String;
		private var _sign:String;
		private var _site:String;
		private var  _serverid:int;
		private var _tick:String;
		
		private var _is_yellow_vip:int;
		private var _is_yellow_year_vip:int;
		private var _yellow_vip_level:int;
		private var _is_yellow_high_vip:int;
		
		private var _rolesData:ByteArray;
		
		private var _stage:Stage;
		
		public function ssztGame()
		{
			super();
			SceneModule;
			NavigationModule;
			TaskModule;
			Cubic;
			
		}
		
		/**
		 * 预启动，初始化数值和开始预加载
		 * @param param
		 * 
		 */		
		public function preSetup(param:Object):void
		{
			GlobalData.systemDate = new SystemDateInfo();
			_config = param["config"];
			_commonConfig = param["commonconfig"];
			_useCache = param["useCache"];
			_sitePath = param["sitePath"];
			_requestPath = param["requestPath"];
			_addProgress = param["addProgress"];
			_parentDispose = param["parentDispose"];
			_user = param["user"];
			_site = param["site"];
			_serverid = param["serverid"];
			_sign = param["sign"];
			_tick = param["tick"];
			_nick = param["nick"];
			_pass = param["pass"];
			_is_yellow_vip = param["isYellowVip"];
			_is_yellow_year_vip = param["isYellowYearVip"];
			_yellow_vip_level = param["yellowVipLevel"];
			_is_yellow_high_vip = param["isYellowHighVip"];
			
			
			GlobalData.tmpId = param["userId"];
			GlobalData.tmpUserName = _user;
			GlobalData.tmpSite = _site;
			GlobalData.tmpServerId= _serverid;
			GlobalData.tmpSign = _sign;
			GlobalData.tmpTick = _tick;
			GlobalData.tmpIsYellowVip = _is_yellow_vip;
			GlobalData.tmpIsYellowYearVip = _is_yellow_year_vip;
			GlobalData.tmpYellowVipLevel = _yellow_vip_level;
			GlobalData.tmpIsYellowHighVip = _is_yellow_high_vip;
			_stage =  param["stage"] as Stage;
			
			GlobalData.isFirstLogin = param["isFirstLogin"];
			GlobalData.isVisitor = String(param["guest"]) == "true";
			GlobalData.tmpCM = param["fcm"];
			GlobalData.tmpIp = param["gameIp"];
			GlobalData.tmpPort = param["gamePort"];
			
			GlobalData.tmpPf = param["pf"];
			GlobalData.tmpPfKey = param["pfKey"];
			GlobalData.tmpOpenKey = param["openKey"];
			GlobalData.tmpZoneId = param["zoneId"];
			GlobalData.tmpDomain = param["domain"];
			
			
			/**配置公共数据,加载config.xml,commonconfig.xml*/
			CommonConfig.initConfigData(_config,_commonConfig);
			
			GlobalData.domain = ApplicationDomain.currentDomain;
			/**过滤脏字*/
			WordFilterUtils.setup(param["filterWord"] as Array);
			/**资源路径*/
			var pathmanager:PathManager = new PathManager(_config);
			GlobalAPI.pathManager = pathmanager;
			GlobalAPI.decodeApi = param["decode"];
			/**层次管理*/
			var layermanager:LayerManager = new LayerManager(this);
			GlobalAPI.layerManager = layermanager;
			GlobalAPI.loaderAPI = param["loaderApi"];
			GlobalAPI.movieManagerApi = param["movieManager"];
			GlobalAPI.cacheManager = param["cache"];
			/**字体管理器*/
			var fontManager:FontManager = new FontManager();
			GlobalAPI.fontManager = fontManager;
			UIManager.setup(this,GlobalAPI.movieManagerApi);
			
			GlobalData.isShowSevenActivity = int(_config.config.IS_SHOWSEVENACTIVITY.@value);
			GlobalData.isShowMergeServer = int(_config.config.IS_SHOWMERGESERVER.@value);
			GlobalData.functionYellowEnabled = String(_config.config.FUNCTION_YELLOW_ENABLED.@value) == "true";
			GlobalData.functionFriendInviteEnabled = String(_config.config.FUNCTION_YELLOW_ENABLED.@value) == "true";
			GlobalData.fillPath2 = String(_config.config.FILL_PATH2.@value);
			GlobalData.QQ_GRUOP = String(_config.config.QQ_GROUP.@value);
			GlobalData.QQ_SERVER = String(_config.config.QQ_SERVER.@value);
			GlobalData.canUseAssist = String(_commonConfig.config.USE_ASSIST.@value) == "true";
			GlobalData.hasMediaPackage = String(_config.config.HAS_MEDIA_PACKAGE.@value) == "true";
			GlobalData.hasMediaPackageTwo = String(_config.config.HAS_MEDIA_PACKAGE_TWO.@value) == "true";
			GlobalData.fullScene = String(_commonConfig.config.FULLSCENE.@value) == "true";
			GlobalData.GCTIME = int(_commonConfig.config.GC_TIME.@value);
			GlobalData.PLAT = int(_config.config.PLAT.@value);
			GlobalData.GAME_NAME = String(_config.config.GAMENAME.@value);
			GlobalData.serverList = String(_config.config.SERVER_ID_LIST.@value).split(",");
			if(GlobalData.GAME_NAME == "")GlobalData.GAME_NAME = "盛世遮天";
			var str:String = String(_config.config.OPEN_SERVER_DATE.@value);
			var array:Array = str.split("-");
			GlobalData.openServerDate = new Date(int(array[0]),int(array[1]) - 1,int(array[2]),int(array[3]),int(array[4]),int(array[5]));
			FaceManager.setup();
			
			GlobalData.enthralType = int(_config.config.ENTHRAL_TYPE.@value);
			
			
			ModuleList.setup();
			
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			contextMenu = cm;
			var item:ContextMenuItem = new ContextMenuItem("清除缓存");
			cm.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,clearCacheHandler);
			
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getCommonSoundPath(),soundComplete,3);
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getAssetPath("sceneIcons.swf"),sceneIconComplete,3);
			
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getAssetPath("bloods.swf"),bloodsComplete,3);
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getAssetPath("playerIcons.swf"),playerIconComplete,3);
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getAssetPath("titles.swf"),titleAssetComplete,3);
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getAssetPath("PKAsset.swf"),pkassetComplete,3);
			GlobalAPI.loaderAPI.loadSwf(GlobalAPI.pathManager.getAssetPath("fontnumber.swf"),fontnumberComplete,3);
			
//			MAlert.show("使用缓存非常好，确定使用?","缓存",MAlert.YES|MAlert.NO,param.stage,closeHandler);
			if(!GlobalAPI.cacheManager.getCanCache() && CommonConfig.CACHELOCAL)
			{
				GlobalAPI.cacheManager.setCanCache(true);
				GlobalAPI.cacheManager.saveCacheList();
//				MAlert.show("使用缓存非常好，确定使用?","缓存",MAlert.YES|MAlert.NO,param.stage,closeHandler);
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.YES)
				{
					GlobalAPI.cacheManager.setCanCache(true);
					GlobalAPI.cacheManager.saveCacheList();
				}
			}
			
			_stage.addEventListener(Event.DEACTIVATE,deactiveteHandler);
			_stage.addEventListener(Event.ACTIVATE,activateHandler);
		}
		
		
		public function setUserId(param:Object):void
		{
			GlobalData.tmpId = param["userId"];
		}
		private function clearCacheHandler(evt:ContextMenuEvent):void
		{
			if(GlobalAPI.cacheManager)
			{
				GlobalAPI.cacheManager.clearCache();
			}
		}
		
		private function deactiveteHandler(evt:Event):void
		{
			CommonConfig.ISACTIVITY = false;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.DEACTIVATE));
		}
		private function activateHandler(evt:Event):void
		{
			CommonConfig.ISACTIVITY = true;
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.ACTIVATE));	
		}
		
		public function setup():void
		{
			var loaderlist:Array = [
				GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getAssetPath("logos.swf"),logoLoadComplete,3),
				GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getAssetPath("common.swf"),commonAssetComplete,3),				
				GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getAssetPath("sceneII.swf"),loadSceneIIComplete,3),
				GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getAssetPath("scene.swf"),navigationComplete,3),
				GlobalAPI.loaderAPI.createSwfLoader(GlobalAPI.pathManager.getAssetPath("task.swf"),taskComplete,3),
				GlobalAPI.loaderAPI.createRequestLoader(GlobalAPI.pathManager.getLanagerPath(CommonConfig.LANGUAGE),null,languageComplete,true,3),
				GlobalAPI.loaderAPI.createRequestLoader(GlobalAPI.pathManager.getConfigZipPath(),null,zipLoadComplete,true,3)
			];
			
			GlobalAPI.loaderAPI.createRequestLoader("descriptC.txt", null, descriptComplete, true, 3).loadSync();
			
			var queueloader:ILoader = GlobalAPI.loaderAPI.createQueueLoader(loaderlist,queueLoadComplete);
			queueloader.addEventListener(LoaderEvent.LOAD_ERROR,queueLoadErrorHandler);
			queueloader.loadSync();
			
			SharedObjectManager.setup();
			
			_stage.addEventListener(Event.RESIZE,stageResizeHandler);
			stageResizeHandler(null);
			
			
		}
		
		private function descriptComplete(loader:ILoader) : void
		{
			var data:ByteArray= loader.getData() as ByteArray;
			DescriptManager.setup(data.readUTFBytes(data.length));
			loader.dispose();
			setLoadingNext(null,1);
		}
		
		private function languageComplete(loader:ILoader):void
		{
			var data:ByteArray = loader.getData() as ByteArray;
			LanguageManager.setup(data.readUTFBytes(data.length));
			setLoadingNext(null,2);
			loader.dispose();
		}
		
		private function stageResizeHandler(evt:Event):void
		{
			CommonConfig.setGameSize(_stage.stageWidth,_stage.stageHeight);
		}
		
		private function soundComplete(loader:ILoader):void
		{
			_addProgress(1);
			loader.dispose();
		}
		private function titleAssetComplete(loader:ILoader):void
		{
			_addProgress(7);
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.TITLE_ASSET_COMPLETE));
			loader.dispose();
		}
		private function bloodsComplete(loader:ILoader):void
		{
			_addProgress(1);
			NumberCache.setup();
			loader.dispose();
		}
		private function playerIconComplete(loader:ILoader):void
		{
			PlayerIconCaches.setup();
			loader.dispose();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.PLAYERICON_ASSET_COMPLETE));
		}
		private function pkassetComplete(loader:ILoader):void
		{
			_addProgress(1);
			loader.dispose();
		}
		private function fontnumberComplete(loader:ILoader):void
		{
			GlobalAPI.fontManager.registerFont("font.FontNumber_number");
			loader.dispose();			
		}
			
		private function sceneIconComplete(loader:ILoader):void
		{
			_addProgress(6);
			loader.dispose();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SCENE_ASSET_COMPLETE));
		}
		private function commonAssetComplete(loader:ILoader):void
		{
			loader.dispose();
			VipIconCaches.setup();
			ToolTipCaches.setup();
			AssetSource.setup();
			BaseCell.setup();
			MoneyIconCaches.setup();
			CellAssetCaches.setup();
			setLoadingNext(null,5);
		}
		private function loadSceneIIComplete(loader:ILoader):void
		{
			loader.dispose();
			setLoadingNext(null,7);
		}
		private function navigationComplete(loader:ILoader):void
		{
			loader.dispose();
			setLoadingNext(null,10);
		}
//		private function chatComplete(loader:ILoader):void
//		{
//			loader.dispose();
//			setLoadingNext(null,1);
//		}
		private function taskComplete(loader:ILoader):void
		{
			loader.dispose();
			setLoadingNext(null,1);
		}
		
//		private function rolesLoadComplete(loader:ILoader):void
//		{
//			_rolesData = loader.getData() as ByteArray;
//			loader.dispose();
//			setLoadingNext(null);
//		}
		
		private function preLoadComplete(loader:ILoader):void
		{
			loader.dispose();
		}
		private function waitingLoadComplete(loader:ILoader):void
		{
			loader.dispose();
		}
		
		private function setLoadingNext(loader:ILoader,addPro:int = 1):void
		{
			if(loader)
			{
				loader.dispose();
			}
			_addProgress(addPro);
		}
		
//		private function waittingLoadComplete(loader:ILoader):void
//		{
//			var waiting:WaitingLoadingPanel = new WaitingLoadingPanel();
//			waiting.setup();
//			GlobalAPI.initWaitingApi(waiting);
//			GlobalAPI.setup(this);
//			GlobalAPI.loaderAPI.setTickManager(GlobalAPI.tickManager);
//			setLoadingNext(null);
//			CellDoubleClickHandler.setup();
//		}
		
		private function logoLoadComplete(loader:ILoader):void
		{
			var waiting:WaitingLoadingPanel = new WaitingLoadingPanel();
			waiting.setup();
			GlobalAPI.initWaitingApi(waiting);
			loader.dispose();
			GlobalAPI.setup(this);
			GlobalAPI.loaderAPI.setTickManager(GlobalAPI.tickManager);
			setLoadingNext(null,1);
			CellDoubleClickHandler.setup();
		}
		
		
		private function zipLoadComplete(loader:ILoader):void
		{
			var type:int;
			var fileLen:int;
			var file:ByteArray;
			setLoadingNext(null, 5);
			ParseData.start(this);
			var d:ByteArray = (loader.getData() as ByteArray);
			d.readByte(); //版本
			d.readByte();
			d.readByte();
			
			var len:int = d.readByte();
			var i:int;
			while (i < len) {
				type = d.readByte();
				fileLen = d.readUnsignedInt();
				file = new ByteArray();
				d.readBytes(file, 0, fileLen);
				file.position = 0;
				switch (type){
					case 1:
						break;
					case 2:
						break;
					case 5:
						DoorTemplateList.setup(file);
						break;
					case 6:
						BuffTemplateList.setup(file);
						break;
					case 7:
						ItemTemplateList.setup(file);
						break;
					case 8:
						MapTemplateList.parseData(file);
						break;
					case 9:
						MonsterTemplateList.setup(file);
						break;
					case 10:
						MovieTemplateList.setup(file);
						break;
					case 11:
						NpcTemplateList.setup(file);
						break;
					case 12:
						ExpList.parseData(file);
						break;
					case 13:
						ParseData.add(file, ShopTemplateList.parseData, 2);
						break;
					case 14:
						SkillTemplateList.parseData(file);
						break;
					case 15:
						TaskTemplateList.setup(file);
						break;
					case 17:
						CollectTemplateList.setup(file);
						break;
					case 18:
						CopyTemplateList.setup(file);
						break;
					case 19:
						VeinsTemplateList.parseData(file);
						break;
					case 20:
						ClubLevelTemplateList.parseData(file);
						break;
					case 21:
						ClubFurnaceTemplateList.parseData(file);
						break;
					case 22:
						ClubShopLevelTemplateList.parseData(file);
						break;
					case 23:
						StrengthenTemplateList.parseData(file);
						break;
					case 24:
						StoneMatchTemplateList.parseData(file);
						break;
					case 25:
						PickStoneTemplateList.parseData(file);
						break;
					case 26:
						PromotionItemTemplateList.parseData(file);
						break;
					case 27:
						OrangeItemTemplateList.parseData(file);
						break;
					case 28:
						BoxTemplateList.setup(file);
						break;
//					case 29:
//						SuitNumberList.parseData(file);
//						break;
//					case 29:
//						LuckComposeTemplateList.parseData(file);
//						break;
					case 30:
						ForgeTemplateList.parseData(file);
						break;
					case 31:
						FormulaTemplateList.parseData(file);
						break;
					case 32:
						FormulaDataTemplateList.parseData(file);
						break;
					case 33:
						SuitNumberList.parseData(file);
						break;
					case 34:
						MountsUpgradeTemplateList.parseData(file);
						break;
					case 35:
						MountsDiamondTemplateList.parseData(file);
						break;
					case 36:
						MountsStarTemplateList.parseData(file);
						break;
					case 37:
						MountsGrowupTemplateList.parseData(file);
						break;
					case 38:
						MountsQualificationTemplateList.parseData(file);
						break;
					case 39:
						PetTemplateList.setup(file);
						break;
					case 40:
						PetUpgradeTemplateList.parseData(file);
						break;
					case 41:
						PetDiamondTemplateList.parseData(file);
						break;
					case 42:
						PetStarTemplateList.parseData(file);
						break;
					case 43:
						PetGrowupTemplateList.parseData(file);
						break;
					case 44:
						PetQualificationTemplateList.parseData(file);
						break;
					case 45:
						PetGrowupExpTemplateList.parseData(file);
						break;
					case 46:
						PetQualificationExpTemplateList.parseData(file);
						break;
					case 47:
						VipTemplateList.parseData(file);
						break;
					case 48:
						DecomposeCopperTemplateList.parseData(file);
						break;
					case 49:
						StoneEnchaseTemplateList.parseData(file);
						break;
					case 50:
						StoneComposeTemplateList.parseData(file);
						break;
					case 51:
						DuplicateMissionList.setup(file);
						break;
					case 52:
						VeinsExtraTemplateList.parseData(file);
						break;
					case 53:
						ActiveTemplateInfoList.parseData(file);
						break;
					case 54:
						ActiveRewardsTemplateInfoList.parseData(file);
						break;
					case 55:
						ActivityTaskTemplateInfoList.parseData(file);
						break;
					case 56:
						EquipStrengthTemplateList.parseData(file);
						break;
					case 57:
						DailyAwardTemplateList.parseData(file);
						break;
					case 58:
						LoginRewardTemplateList.parseData(file);
						break;
					case 59:
						LoginRewardTemplateList.parseExpData(file);
						break;
					case 60:
						PlaceCategoryTemaplteList.parseData(file);
						break;
					case 61:
						SuitTemplateList.parseData(file);
						break;
					case 62:
						SwordsmanTemplateList.parseData(file);
						break;
					case 63:
						TargetTemplateList.parseData(file);
						break;
					case 64:
						TitleTemplateList.setup(file);
						break;
					case 65:
						ChallengeTemplateList.parseData(file);
						break;
					case 66:
						ActivityPvpTemplateList.parseData(file);
						break;
					case 67:
						BossTemplateInfoList.parseData(file);
						break;
					case 68:
						FriendshipTemplateList.parseData(file);
						break;
					case 69:
						ActivityTemplateInfoList.parseData(file);
						break;
					case 70:
						OpenActivityTemplateList.parseData(file);
						break;
					case 71:
						ClubCampCallTemplateList.setup(file);
						break;
					case 72:
						YellowBoxTemplateList.parseData(file);
						break;
					case 73:
						SevenActivityTemplateList.parseData(file);
						break;
					case 74:
						ClubLotteryTemplateList.parseData(file);
						break;
					case 75:
						EntrustmentTemplateList.parseData(file);
						break;
					case 76:
						MountsRefinedTemplateList.parseData(file);
						break;
					case 77:
						FuseTemplateList.parseData(file);
						break;
				}
				i++;
			}
//			FurnaceIntroList.setup();
			loader.dispose();
			file = null;
		}
		
		
		private function queueLoadErrorHandler(evt:LoaderEvent):void
		{
			if(evt.data == null)
			{
				MAlert.show("加载数据出错","提示");
			}
			else
			{
				MAlert.show((evt.data as String).slice(0,300));
			}
		}
		
		private function queueLoadComplete(loader:ILoader):void
		{
			GlobalData.friendIconList = new FriendIconList();
			GlobalData.mailIcon = new MailIcon();
			
			loader.dispose();
			
			GlobalData.timerEffectSource = new TimerEffectSource();
			GlobalData.paopaoSource = new PaopaoSoure();
			
			if(_parentDispose != null)
				_parentDispose();
			_parentDispose = null;
//			SetSocketHandler.addHandlers();
//			LoginProxy.login(GlobalPhaseParam.nick,GlobalPhaseParam.user,GlobalPhaseParam.pass,GlobalPhaseParam.site);
			
//			SetModuleUtils.setToScene(new ToSceneData(1));
			
			/**初始化系统中用到的包,即包处理方法*/
			SetSocketHandler.add();
			/**有效的事件管理*/
			DeployEventManager.initDeploy();
			
			CommonEffectPoolManager.setup();
			
			LoginSocketProxy.loginSocket(new SocketInfo(GlobalData.tmpIp,GlobalData.tmpPort));
			
			initModuleList();
			
			try
			{
				ExternalInterface.addCallback("doClose",doClose);
			}
			catch(e:Error){}
			CommonEffectPoolManager.setup();
			
		}
		
		private function doClose():void
		{
			GlobalAPI.socketManager.close();
		}
		
		private function clearParam():void
		{
			
		}
		
		private function initModuleList():void
		{
			SetModuleUtils.addNavigation();
			SetModuleUtils.addTask();
		}
	}
}
