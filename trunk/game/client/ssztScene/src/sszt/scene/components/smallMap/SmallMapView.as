package sszt.scene.components.smallMap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.DirectType;
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.KeyType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.data.module.changeInfos.ToSettingData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SharedObjectManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.club.camp.ClubCampLeaveSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.gm.GMPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.GuideTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.FriendModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.events.StoreModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.components.gift.OnlineGiftPanel;
	import sszt.scene.data.SceneMapInfoUpdateEvent;
	import sszt.scene.data.roles.BaseSceneMonsterInfo;
	import sszt.scene.data.roles.NpcRoleInfo;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.events.SceneMediatorEvent;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.events.ScenePlayerListUpdateEvent;
	import sszt.scene.mediators.SmallMapMediator;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class SmallMapView extends Sprite
	{
		private var _bg:Bitmap;
		//private var _mapName:TextField;
		private var _mapName:MAssetLabel;
		private var _posText:TextField;
//		private var _btns:Vector.<MBitmapButton>;
//		private var _poses:Vector.<Point>;
//		private var _classes:Vector.<Class>;
//		private var _handlers:Vector.<Function>;
		private var _btns:Array;
		private var _poses:Array;
		private var _classes:Array;
		private var _handlers:Array;
		private var _labels:Array;
		private var _medaitor:SmallMapMediator;
		private var _mapContainer:Sprite;
		private var _mapContainer1:Sprite;
		
		private var _mask:Shape;
		
		private var _pathLayer:Shape;
		private var _mapMonsterLayer:Sprite;
		private var _mapNpcLayer:Sprite;
		private var _jumpPointLayer:Sprite;
		private var _arrow:MovieClip;
		private var _smallMap:Bitmap;
		private var _noVoice:Bitmap;
		private var _hasVoice:Boolean = true;
		private var _forbidVoice:Bitmap;
		private var _forbidHidePlayer:Bitmap;
		
		private var mapMaxX:Number;
		private var mapMaxY:Number;
		
		private var _topLinkLayer:MSprite;
		private var _topLinkArray:Array;
		
		private var _tlEffort:MAssetButton1;
		
		private var _activityEffect:BaseLoadEffect;
		private var _mysticEffect:BaseLoadEffect;
		
		private var _activeAmount:AmountFlashView;
		
		private var _leaveBtn:MAssetButton1;
		
		private var _mysticCd:CountDownView;
		
		public function SmallMapView(mediator:SmallMapMediator)
		{
			_medaitor = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			mouseEnabled = false;
			updateSizeHandler(null);
			
			_mapContainer1 = new Sprite();
			_mapContainer1.mouseChildren = _mapContainer1.mouseEnabled = true;
			addChild(_mapContainer1);
			_mapContainer1.x = -134;
			_mapContainer1.y = 32;
			
			_mapContainer = new Sprite();
			_mapContainer.mouseChildren = _mapContainer.mouseEnabled = true;
			_mapContainer1.addChild(_mapContainer);
			_mask = new Shape();
			addChild(_mask);
			_mask.graphics.beginFill(0xff0000,0.1);
			_mask.graphics.drawCircle(0,0,58);
			_mask.graphics.endFill();
			_mask.x = -76;
			_mask.y = 90;
			_mapContainer.mask = _mask;
			
			_smallMap = new Bitmap();
			_mapContainer.addChild(_smallMap);
			
			_pathLayer = new Shape();
		
			_mapMonsterLayer = new Sprite();		
			_mapNpcLayer = new Sprite();
			_jumpPointLayer = new Sprite();	
			
			_bg = new Bitmap(AssetUtil.getAsset("ssztui.scene.SmallMapBgAsset") as BitmapData);
			_bg.x = -180;
			_bg.y = 0;
			addChild(_bg);				
			
			/*
			_mapName = new TextField();
			_mapName.textColor = 0xFF9900;
			_mapName.mouseEnabled = _mapName.mouseWheelEnabled = false;
			_mapName.x = -158;
			_mapName.y = 8;
			addChild(_mapName);
			*/
			_mapName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,"center");
			_mapName.move(-81,5);			
			addChild(_mapName);
			
			var id:int = _medaitor.sceneInfo.getSceneId();
			if(MapTemplateList.list[id])
			{
				_mapName.setValue(MapTemplateList.list[id].name);
			}
			
			_posText = new TextField();
			_posText.textColor = 0xD8CBAB;
			_posText.mouseEnabled = _posText.mouseWheelEnabled = false;
			_posText.x = -94;
			_posText.y = 7;
			//addChild(_posText);
			
			_poses = [
				new Point(-154,17), 
				new Point(100,79),
				new Point(-161,59),
				new Point(-152,115),
				new Point(-98,149),
				new Point(-35,120),
				new Point(100,117),
				new Point(-27,45),
				new Point(-40,27),
				
				new Point(-163,88),
				new Point(-55,138),
				new Point(-27,94),
				
				new Point(-131,132),
				
				/* belowBtns
				new Point(-191,176),
				new Point(-146,176),
				new Point(-101,176),
				new Point(-56,176),
				*/
				
				// TopBtns
//				new Point(-242,9)
			];
			_classes = [
				"ssztui.scene.SmallMapActivityBtnAsset",
				"ssztui.scene.SmallMapWelfareBtnAsset",
				"ssztui.scene.SmallRankBtnAsset",
				"ssztui.scene.SmallMapFriendBtnAsset",
				"ssztui.scene.SmallMapMapBtnAsset",
				"ssztui.scene.SmallMapMailBtnAsset",
				"ssztui.scene.SmallSetBtnAsset",
				"ssztui.scene.SmallMapHidePlayerBtnAsset",
				"ssztui.scene.SmallMapVoiceBtnAsset",
				
				"ssztui.scene.SmallMarketBtnAsset",
				"ssztui.scene.SmallTeamBtnAsset",
				"ssztui.scene.SmallGJBtnAsset",
				
				"ssztui.scene.SmallMysteriousBtnAsset"
			];
			_handlers = [
				activityClickHandler,
				welfareClickHandler,
				rankClickHandler,
				friendClickHandler,
				mapClickHandler,
				mailClickHandler,
				setClickHandler,
				hidePlayerClickHandler,
				voiceClickHandler,
				
				consignClickHandler,
				teamClickHander,
				onhookClickHander,
				
				mysteriousClickHander
				
//				onlineAwardClickHandler
				//hidePlayerClickHandler
				//hidePlayerClickHandler
//				voiceClickHandler,activityClickHandler,taskClickHandler,rankClickHandler,mailClickHandler,mapClickHandler,,
//				mountClickHandler,consignClickHandler,fightClickHandler,userClickHandler,gmClickHandler,screenClickHandler,
			];
			
			_labels = [
				LanguageManager.getWord("ssztl.scene.smallMapTip1"),
				LanguageManager.getWord("ssztl.scene.smallMapTip2"),
				LanguageManager.getWord("ssztl.scene.smallMapTip3"),
				LanguageManager.getWord("ssztl.scene.smallMapTip4"),
				LanguageManager.getWord("ssztl.scene.smallMapTip5"),
				LanguageManager.getWord("ssztl.scene.smallMapTip6"),
				LanguageManager.getWord("ssztl.scene.smallMapTip7"),
				LanguageManager.getWord("ssztl.scene.smallMapTip8"),
				LanguageManager.getWord("ssztl.scene.smallMapTip9"),
				
				LanguageManager.getWord("ssztl.scene.smallMapTip10"),
				LanguageManager.getWord("ssztl.scene.smallMapTip11"),
				LanguageManager.getWord("ssztl.scene.startHangup"),
				LanguageManager.getWord("ssztl.store.refreshableShop"),
			];
			
			_btns = [];
			for(var i:int = 0; i < _classes.length; i++)
			{
				var btn:MAssetButton1 = new MAssetButton1(AssetUtil.getAsset(_classes[i]) as MovieClip);
				btn.move(_poses[i].x,_poses[i].y);
				addChild(btn);
				_btns.push(btn);
			}
			_forbidVoice = new Bitmap(AssetUtil.getAsset("ssztui.scene.FunForbidBgAsset") as BitmapData);
			_forbidVoice.x = -35;
			_forbidVoice.y = 31;
			_forbidHidePlayer = new Bitmap(AssetUtil.getAsset("ssztui.scene.FunForbidBgAsset") as BitmapData);
			_forbidHidePlayer.x = -22;
			_forbidHidePlayer.y = 50;
			addChild(_forbidVoice);
			addChild(_forbidHidePlayer);

			_forbidHidePlayer.visible = false;
			
			if(!SharedObjectManager.soundEnable.value && !SharedObjectManager.musicEnable.value)
				_hasVoice = false;
			else
				_hasVoice = true;
			
			if(!_hasVoice)
			{
				showNoVoice();
			}
			_forbidVoice.visible = !_hasVoice;
			
			setMap(null);
			setGuideTipHandler(null);
			
//			_topLinkArray = [];
//			_topLinkLayer = new MSprite();
//			_topLinkLayer.move(-180,6);
//			addChild(_topLinkLayer);
//			
//			_tlEffort = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnScoreAsset") as MovieClip);
//			addTopLink(_tlEffort);
//			AchievementView.getInstance().isShow = true;
			
			_activityEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.ACTIVITY_EFFECT));
			_activityEffect.move(_poses[0].x+21,_poses[0].y+21);
			_activityEffect.play();
			addChild(_activityEffect);
			_activityEffect.visible = false;
			
			_mysticEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.ACTIVITY_EFFECT));
			_mysticEffect.scaleX = _mysticEffect.scaleY = 0.7;
			_mysticEffect.move(_poses[12].x+26,_poses[12].y+26);
			_mysticEffect.play();
			addChild(_mysticEffect);
//			_mysticEffect.visible = false;
			_mysticCd = new CountDownView();
			updataRefreshTime(null)
			
			_leaveBtn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnExitAsset") as MovieClip);
			_leaveBtn.move(-325,180);
			addChild(_leaveBtn);
			_leaveBtn.visible = false;
			changeSceneHandlerSmall(null);
			
		}
		
		private function initEvent():void
		{
			for each(var i:MAssetButton1 in _btns)
			{
				i.addEventListener(MouseEvent.CLICK,btnClickHandler);
				i.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
				i.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			}
			_medaitor.sceneInfo.mapInfo.addEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE,mapSetNameHandler);
			_medaitor.sceneInfo.addEventListener(SceneInfoUpdateEvent.SETNAIL_COMPLETE,setMap);
			_medaitor.sceneInfo.addEventListener(SceneInfoUpdateEvent.RENDER,sceneRenderHandler);
			_medaitor.sceneInfo.playerList.addEventListener(ScenePlayerListUpdateEvent.SETSELF_COMPLETE,setSelf);
			_mapContainer.addEventListener(MouseEvent.CLICK,smallMapClickHandler);
			_medaitor.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER,updateMonster);
			_medaitor.sceneInfo.monsterList.addEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER,updateMonster);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,updateSizeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.VOICE_CHANGE,voiceChangeHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.UPDATE_ACTIVE_INFO, updateActiveInfoHandler);
			
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler); 
			
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicateSmall);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandlerSmall);
			
			ModuleEventDispatcher.addStoreEventListener(StoreModuleEvent.MYSTERY_REFRESH_UPDATE,updataRefreshTime);
			_mysticCd.addEventListener(Event.COMPLETE,cdComplete);
		}
		
		private function removeEvent():void
		{
			for each(var i:MBitmapButton in _btns)
			{
				i.removeEventListener(MouseEvent.CLICK,btnClickHandler);
				i.removeEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
				i.removeEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
			}
			_medaitor.sceneInfo.mapInfo.removeEventListener(SceneMapInfoUpdateEvent.SETDATA_COMPLETE,mapSetNameHandler);
			_medaitor.sceneInfo.removeEventListener(SceneInfoUpdateEvent.SETNAIL_COMPLETE,setMap);
			_medaitor.sceneInfo.removeEventListener(SceneInfoUpdateEvent.RENDER,sceneRenderHandler);
			_medaitor.sceneInfo.playerList.removeEventListener(ScenePlayerListUpdateEvent.SETSELF_COMPLETE,setSelf);
			_mapContainer.removeEventListener(MouseEvent.CLICK,smallMapClickHandler);
			_medaitor.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.ADD_MONSTER,updateMonster);
			_medaitor.sceneInfo.monsterList.removeEventListener(SceneMonsterListUpdateEvent.REMOVE_MONSTER,updateMonster);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,updateSizeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SET_GUIDETIP,setGuideTipHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.VOICE_CHANGE,voiceChangeHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.UPDATE_ACTIVE_INFO, updateActiveInfoHandler);
			
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler); 
			
			_leaveBtn.removeEventListener(MouseEvent.CLICK,quitDuplicateSmall);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneHandlerSmall);
			
			ModuleEventDispatcher.removeStoreEventListener(StoreModuleEvent.MYSTERY_REFRESH_UPDATE,updataRefreshTime);
			_mysticCd.removeEventListener(Event.COMPLETE,cdComplete);
		}
		private function updataRefreshTime(evt:StoreModuleEvent):void
		{
			var diff:Number = GlobalData.mysteryShopInfo.lastUpdate + 14400 - GlobalData.systemDate.getSystemDate().time/1000;
			_mysticCd.start(diff);
		}
		private function cdComplete(evt:Event):void
		{
			_mysticEffect.visible = true;
		}
		
		private function updateActiveInfoHandler(e:SceneModuleEvent):void
		{
			_activityEffect.visible = GlobalData.selfPlayer.activeRewardCanGet;
			var num:int = GlobalData.selfPlayer.activeNum;
			if(num > 0)
			{
				if(!_activeAmount)
				{
					_activeAmount = new AmountFlashView();
					_activeAmount.move(-166,21);
					addChild(_activeAmount);
				}
				_activeAmount.setValue(num.toString());
			}else{
				if(_activeAmount && _activeAmount.parent)
				{
					_activeAmount.parent.removeChild(_activeAmount);
					_activeAmount = null;
				}
			}
		}
		
		public function addTopLink(obj:DisplayObject):void
		{
			var am:int = _topLinkArray.length+1;
			
			obj.x = am*-55;
			obj.y = 0;
			_topLinkLayer.addChild(obj);
			_topLinkArray.push(obj);
		}
		
		private function keyDownHandler(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case KeyType.F9:
					_forbidHidePlayer.visible = !_forbidHidePlayer.visible;
					break;
			}
		}
		
		private function quitDuplicateSmall(evt:Event):void
		{
			if(GlobalData.currentMapId == 10000)
			{
				ClubCampLeaveSocketHandler.send();
				return;
			}
			var message:String;
			if(GlobalData.copyEnterCountList.isPKCopy()&& GlobalData.selfPlayer.pkState == 0) message = LanguageManager.getWord("ssztl.scene.isSureBeLoser");
			else message = LanguageManager.getWord("ssztl.scene.isSureLeaveCopy");
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
			function leaveAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{	
					CopyLeaveSocketHandler.send();
				}
			}
		}
		
		private function changeSceneHandlerSmall(e:SceneModuleEvent):void
		{
			if(GlobalData.currentMapId == 6200101 || GlobalData.currentMapId == 6200102 || GlobalData.currentMapId == 1000000 || GlobalData.currentMapId == 10000)
			{
				_leaveBtn.visible = true;
			}
			else
			{
				_leaveBtn.visible = false;
			}
		}

		private function welfareClickHandler():void
		{
			trace('福利')
		}
		private function friendClickHandler():void
		{
			ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_IMPANEL));
		}
		private function setClickHandler():void
		{
			SetModuleUtils.addSetting(new ToSettingData(1));
		}
		private function hidePlayerClickHandler():void
		{
			SharedObjectManager.setHidePlayerCharacter(!SharedObjectManager.hidePlayerCharacter.value);
			_forbidHidePlayer.visible = !_forbidHidePlayer.visible;
		}
		private function scoreClickHandler():void
		{
			
		}
		private function teamClickHander():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_GROUP_PANEL));
		}
		private function targetClickHander():void
		{
			
		}
		private function onhookClickHander():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_HANG_UP_PANEL));
		}
		private function mysteriousClickHander():void
		{
			SetModuleUtils.addStore(new ToStoreData(3));
			_mysticEffect.visible = false;
		}
		
		private function mapSetNameHandler(evt:SceneMapInfoUpdateEvent):void
		{
			var id:int = _medaitor.sceneInfo.getSceneId();
			if(MapTemplateList.list[id])
			{
				_mapName.setValue(MapTemplateList.list[id].name);
			}
		}
		
		private function voiceChangeHandler(evt:CommonModuleEvent):void
		{
			if(!SharedObjectManager.soundEnable.value && !SharedObjectManager.musicEnable.value)
			{
				showNoVoice();
				_hasVoice = false;
			}else
			{
				hideNoVoice();
				_hasVoice = true;
			}
			_forbidVoice.visible = !_hasVoice;
		}
		
		private function showNoVoice():void
		{
//			if(!_noVoice)
//			{
//				_noVoice = new Bitmap(AssetUtil.getAsset("ssztui.scene.SmallMapNoVoiceAsset") as BitmapData);
//				_noVoice.x = 2;
//				_noVoice.y = 3;
//			}
//			if(!_noVoice.parent)
//				addChild(_noVoice);
		}
		private function hideNoVoice():void
		{
//			if(_noVoice && _noVoice.parent)_noVoice.parent.removeChild(_noVoice);
		}
		
		private function updateSizeHandler(evt:CommonModuleEvent):void
		{
			move(CommonConfig.GAME_WIDTH,0);
		}
		
		private function setGuideTipHandler(e:CommonModuleEvent):void
		{
			if(GlobalData.guideTipInfo == null)return;
			var info:DeployItemInfo = GlobalData.guideTipInfo;
			if(info.param1 == GuideTipDeployType.SMALL_MAP)
			{
				GuideTip.getInstance().show(info.descript,info.param2,new Point(info.param3,info.param4),addChild);
			}
		}
		
		private function smallMapClickHandler(evt:MouseEvent):void
		{
			var x:Number = evt.localX * 10;
			var y:Number = evt.localY * 10;
			var point:Point = new Point(x,y);
			if(x>mapMaxX || y>mapMaxY) return;
			
			WalkChecker.doWalk(_medaitor.sceneInfo.getSceneId(),point);
		}
		
		private function setSelf(evt:ScenePlayerListUpdateEvent):void
		{
			_medaitor.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,selfRenderHandler);
			_medaitor.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.WALK_START,pathRenderHandler);
			_mapContainer.addChild(_pathLayer);
			if(_arrow && _arrow.parent)
			{
				_arrow.parent.removeChild(_arrow);
			}
//			_arrow = new BigmapArrowAsset();
			_arrow = AssetUtil.getAsset("ssztui.scene.BigmapArrowAsset",MovieClip) as MovieClip;
			_arrow.mouseEnabled = false;
			_mapContainer.addChild(_arrow);
			
			//====Aron.Modify
			//_posText.text ="["+ String(int(_medaitor.sceneInfo.playerList.self.sceneX )) + "," + String(int(_medaitor.sceneInfo.playerList.self.sceneY)) + "]";
			var id:int = _medaitor.sceneInfo.getSceneId();
			if(MapTemplateList.list[id])
			{
				_mapName.setValue(MapTemplateList.list[id].name + "("+ String(int(_medaitor.sceneInfo.playerList.self.sceneX )) + "," + String(int(_medaitor.sceneInfo.playerList.self.sceneY)) + ")");
			}
			//====The End Aron.Modify
			
			_medaitor.checkCarState();
		}
		
		private function getDir():int
		{
			var dir:int = 0;
			switch (GlobalData.selfScenePlayer.dir)
			{
				case DirectType.BOTTOM:
					dir = 90;
					break;
				case DirectType.TOP:
					dir = -90;
					break;
				case DirectType.LEFT:
					dir = 180;
					break;
				case DirectType.RIGHT:
					dir = 0;
					break;
				case DirectType.RIGHT_BOTTOM:
					dir = 45;
					break;
				case DirectType.RIGHT_TOP:
					dir = -45;
					break;
				case DirectType.LEFT_BOTTOM:
					dir = 135;
					break;
				case DirectType.LEFT_TOP:
					dir = -135;
					break;		
			}
			return dir;
		}
		
		private function pathRenderHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			var path:Array = evt.data.path;
			_pathLayer.graphics.clear();
			_pathLayer.graphics.lineStyle(1,0x00ff00);
			_pathLayer.graphics.moveTo(_medaitor.sceneInfo.playerList.self.sceneX / 10,_medaitor.sceneInfo.playerList.self.sceneY / 10);
			for(var i:int = 0;i<path.length;i++)
			{
				_pathLayer.graphics.lineTo(path[i].x /10,path[i].y / 10);
			}
		}
		
		private function selfRenderHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(!_medaitor.sceneInfo.playerList.self)return;
			_arrow.x = _medaitor.sceneInfo.playerList.self.sceneX / 10;
			_arrow.y = _medaitor.sceneInfo.playerList.self.sceneY / 10;
//			RotateUtils.setRotation(_arrow,new Point(3,6),getDir());
			_arrow.rotation = getDir();
			
			//====Aron.Modify
			//_posText.text ="["+ String(int(_medaitor.sceneInfo.playerList.self.sceneX )) + "," + String(int(_medaitor.sceneInfo.playerList.self.sceneY)) + "]"; 
			var id:int = _medaitor.sceneInfo.getSceneId();
			if(MapTemplateList.list[id])
			{
				_mapName.setValue(MapTemplateList.list[id].name + "("+ String(int(_medaitor.sceneInfo.playerList.self.sceneX )) + "," + String(int(_medaitor.sceneInfo.playerList.self.sceneY)) + ")");
			}
			//====The End Aron.Modify
		}
		
		private function setMap(evt:SceneInfoUpdateEvent):void
		{
			if(!_medaitor.sceneInfo.mapThumbnail)return;
//			_mapContainer.addChild(new Bitmap(_medaitor.sceneInfo.mapThumbnail));
			
			_pathLayer.graphics.clear();
			
			_smallMap.bitmapData = _medaitor.sceneInfo.mapThumbnail;
			_mapContainer.addChild(_mapMonsterLayer);
			_mapContainer.addChild(_mapNpcLayer);
			_mapContainer.addChild(_jumpPointLayer);
			drawMonster();
			drawNpc();
			drawJumpPoint();
			
//			var id:int = _medaitor.sceneInfo.getSceneId();
//			if(MapTemplateList.list[id])
//			{
//				_mapName.text = MapTemplateList.list[id].name;
//			}
//			
			mapMaxX = _medaitor.sceneInfo.mapThumbnail.width*10;
			mapMaxY = _medaitor.sceneInfo.mapThumbnail.height*10;
		}
		
		private function updateMonster(evt:SceneMonsterListUpdateEvent):void
		{
			drawMonster();
		}
		
		private function drawJumpPoint():void
		{
			clearJumpPoint();
			var list:Array = DoorTemplateList.sceneDoorList[_medaitor.sceneInfo.getSceneId()];
			if(list)
			{
				for(var i:int = 0;i<list.length;i++)
				{
					var tmp:Bitmap = new Bitmap(AssetUtil.getAsset("ssztui.scene.MapJumpPointAsset") as BitmapData);
					tmp.x = list[i].sceneX/10 -9;
					tmp.y = list[i].sceneY/10 -14;
					_jumpPointLayer.addChild(tmp);
				}
			}
		}
		
		private function clearJumpPoint():void
		{
			for(var i:int = _jumpPointLayer.numChildren - 1;i >= 0;i--)
			{
				_jumpPointLayer.removeChildAt(i);
			}
		}
		
		private function drawMonster():void
		{
			_mapMonsterLayer.graphics.clear();
			_mapMonsterLayer.graphics.beginFill(0xFF0000);
			for each(var k:BaseSceneMonsterInfo in _medaitor.sceneInfo.monsterList.getMonsters())
			{
				_mapMonsterLayer.graphics.drawCircle(k.sceneX /10,k.sceneY/10,2);
			}
			_mapMonsterLayer.graphics.endFill();
		}
		
		private function drawNpc():void
		{
			clearNpcPoint();
			for each(var p:NpcRoleInfo in _medaitor.sceneInfo.mapInfo.npcList)
			{
//				var icon:Bitmap = new Bitmap(new BigmapLittleHumanAsset());
				var icon:Bitmap = new Bitmap(AssetUtil.getAsset("ssztui.scene.BigmapLittleHumanAsset") as BitmapData);
				icon.x = p.sceneX/10;
				icon.y = p.sceneY/10 - 11;
				_mapNpcLayer.addChild(icon);
			}
		}
		
		private function clearNpcPoint():void
		{
			for(var i:int = _mapNpcLayer.numChildren - 1;i >= 0;i--)
			{
				_mapNpcLayer.removeChildAt(i);
			}
		}
			
		private function btnClickHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget as MAssetButton1);
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_handlers[index]();
		}
		
		private function btnOverHandler(evt:MouseEvent):void
		{
			var index:int = _btns.indexOf(evt.currentTarget as MAssetButton1);
			if(_labels[index])
				TipsUtil.getInstance().show(_labels[index],null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function btnOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function sceneRenderHandler(evt:SceneInfoUpdateEvent):void
		{
			if(_medaitor.sceneInfo.mapThumbnail == null)return;
			var viewPos:Point = _medaitor.sceneModule.sceneInit.getViewPortPos();
			_mapContainer.x = -viewPos.x / 10 ;
			_mapContainer.y = -viewPos.y / 10 ;
			if(_mapContainer.x < -(_medaitor.sceneInfo.mapThumbnail.width - 115))
				_mapContainer.x = -(_medaitor.sceneInfo.mapThumbnail.width - 115);
			if(_mapContainer.y < -(_medaitor.sceneInfo.mapThumbnail.height - 115))
				_mapContainer.y = -(_medaitor.sceneInfo.mapThumbnail.height - 115);
			if(_mapContainer.y > 0)
				_mapContainer.y = 0;
			if(_mapContainer.x > 0)
				_mapContainer.x = 0;
		}
		
		private function voiceClickHandler():void
		{
			if(_hasVoice)
			{
				SharedObjectManager.setMusicEnable(false);
				SharedObjectManager.setSoundEnable(false);
			}else
			{
				SharedObjectManager.setMusicEnable(true);
				SharedObjectManager.setSoundEnable(true);
			}
			_forbidVoice.visible = !_hasVoice;
			SharedObjectManager.musicEnable.update();
			SharedObjectManager.soundEnable.update();
			SharedObjectManager.save();
			SoundManager.instance.setMusicMute(!SharedObjectManager.musicEnable.value);
			SoundManager.instance.setSoundMute(!SharedObjectManager.soundEnable.value);		
		}
		
		private function activityClickHandler():void
		{
			SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.MAIN,0));
//			var t:TestPanel = new TestPanel();
//			GlobalAPI.layerManager.addPanel(t);
//			var tt:BitmapData = new BitmapData(700,400);
//			var t:Bitmap = new Bitmap(tt);
//			GlobalAPI.layerManager.getTipLayer().stage.addChild(t);
		}
		
		private function taskClickHandler():void
		{
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.SHOW_MAINPANEL));
		}
		
		private function fightClickHandler():void
		{
			if(_medaitor.sceneInfo.mapInfo.isShenmoDouScene())
			{
				_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOREWARDS);
				return;
			}
			if(_medaitor.sceneInfo.mapInfo.isClubPointWarScene())
			{
				_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCLUBPOINTSCORE);
				return;
			}
			if(_medaitor.sceneInfo.mapInfo.isCrystalWarScene())
			{
				_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWCRYSTALPOINTSCORE);
				return;
			}
			if(MapTemplateList.isPerWarMap())
			{
				_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWPERWAR_REWARDS);
				return;
			}
			_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOWAR,0);
		}
		
		private function shopClickHandler():void
		{
			SetModuleUtils.addStore(new ToStoreData(1));
		}
		
//		private function handupClickHandler():void
//		{
//			_medaitor.showHangup();
//		}
		
		private function rankClickHandler():void
		{
			SetModuleUtils.addRank();
		}
		
		private function mountClickHandler():void
		{
			_medaitor.mountAvoid();
		}
		
		private function mapClickHandler():void
		{
			_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWBIGMAP);
		}
		
		private function mailClickHandler():void
		{
			SetModuleUtils.addMail(new ToMailData(true));
		}
		
		private function settingClickHandler():void
		{
			SetModuleUtils.addSetting();
		}
		
		private function gmClickHandler():void
		{
			if(GlobalAPI.pathManager.getGMLinkPath() != "")
			{
				JSUtils.gotoPage(GlobalAPI.pathManager.getGMLinkPath());
			}else
			{
				if(GMPanel.getInstance() && GMPanel.getInstance().parent)
				{
					GMPanel.getInstance().dispose();
				}else
				{
					GMPanel.getInstance().show();
				}	
			}
		}
		
		private function userClickHandler():void
		{
			if(MapTemplateList.isAcrossBossMap())
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.crossServerBoss"));
				return;
			}
			SetModuleUtils.addPersonal(GlobalData.selfPlayer.userId);
//			MAlert.show("此功能尚未开放，敬请期待");
		}
		
		private function bbsClickHandler():void
		{
			JSUtils.gotoPage(GlobalAPI.pathManager.getBBSPath());
		}
		
		private function officeClickHandler():void
		{
			JSUtils.gotoPage(GlobalAPI.pathManager.getOfficalPath());
		}
		
		private function fillClickHandler():void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.functionNoOpen"));
		}
		
		/**
		 * 寄售店 
		 */
		private function consignClickHandler():void
		{
			SetModuleUtils.addConsign();
		}
		
		private function screenClickHandler():void
		{
			if(CommonConfig.isFull)
			{
				JSUtils.exitFullScene();
			}
			else
			{
				JSUtils.doFullScene();
			}
			CommonConfig.isFull = !CommonConfig.isFull;
//			MAlert.show("此功能尚未开放，敬请期待");
		}
		
		private function achieveClickHandler():void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.functionNoOpen"));
//			if(GlobalData.copyEnterCountList.isInCopy)
//			{
//				_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOWAR);
//			}
//			else
//			{
//				_medaitor.sceneModule.facade.sendNotification(SceneMediatorEvent.SCENE_MEDIATOR_SHOWSHENMOREWARDS);
//			}
		}
		
		private function copyClickHandler():void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_COPY_PANEL));
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			removeEvent();
			if(parent)parent.removeChild(this);
			_activityEffect = null;
		}
	}
}
