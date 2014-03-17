package sszt.activity.components.panels
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bigBossWar.BigBossWarEnterSocketHandler;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.core.socketHandlers.guildPVP.GuildPVPEnterSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.ActiveStartEvents;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.RewardTxtAsset10;
	import ssztui.activity.RewardTxtAsset5;
	import ssztui.activity.RewardTxtAsset6;
	import ssztui.activity.RewardTxtAsset7;
	import ssztui.activity.RewardTxtAsset8;
	import ssztui.activity.RewardTxtAsset9;
	import ssztui.ui.BtnAssetClose;
	
	public class ActivityStartRemainingPanel extends MSprite implements IPanel
	{
		public static const DEFAULT_WIDTH:int = 325;
		public static const DEFAULT_HEIGHT:int = 225;
		
		private var _type:int;
		
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _txtOpenTime:MAssetLabel;
		private var _rewardImg:Bitmap;
		
		private var _btnClose:MCacheAssetBtn1;
		private var _btnTransportNow:MCacheAssetBtn1;
		private var _btnGo:MCacheAssetBtn1;
		
		private var _bannerImg:Bitmap;
		private var _picPath:String;
		
		private var _activityId:int;
		private var _sceneId:int;
		private var _targetPoint:Point;
		private var _isToNpc:Boolean;
		private var _npcId:int;
		private var _isToMap:Boolean;
		
		private var _count:int = 0; 
		private var _seconds:int = 60;
		
		public function ActivityStartRemainingPanel(type:int)
		{
			_type = type;
			super();
			
			var map:MapTemplateInfo;
			var npc:NpcTemplateInfo;
			switch(_type)
			{
				case 0 ://1002
				{
					map = MapTemplateList.getMapTemplate(1021);
					_sceneId = map.mapId;
					_targetPoint = map.defalutPoint;
					_isToMap = true;
					break;
				}
				case 1 ://1003
				{
					 map = MapTemplateList.getMapTemplate(1025);
					_sceneId = map.mapId;
					_targetPoint = map.defalutPoint;
					_isToMap = true;
					break;
				}
				case 2 ://1005
				{
					break;
				}
				case 3 ://1006
				{
					npc = NpcTemplateList.getNpc(102106);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102106;
					_activityId = 1006;
					break;
				}
				case 4 ://1008
				{
					npc = NpcTemplateList.getNpc(102133);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102133;
					_activityId = 1008;
					break;
				}
				case 5://1007
				{
					npc = NpcTemplateList.getNpc(102109);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102109;
					_activityId = 1007;
					break;
				}
				case 6 ://1009
				{
					npc = NpcTemplateList.getNpc(102133);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102133;
					_activityId = 1009;
					break;
				}
				case 7 ://1011
				{
					_activityId = 1011;
					break;
				}
				case 8 ://1012 帮会乱斗
				{
					npc = NpcTemplateList.getNpc(102133);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102133;
					_activityId = 1012;				
					break;
				}
				case 9:
				{
					npc = NpcTemplateList.getNpc(102133);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102133;
					_activityId = 1013;				
					break;
				}
				case 10:
				{
					npc = NpcTemplateList.getNpc(102136);
					_sceneId = npc.sceneId;
					_targetPoint = npc.getAPoint();
					_isToNpc = true;
					_npcId = 102136;				
					break;
				}
			}
			
			initEvent();
//			GlobalAPI.tickManager.addTick(this);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_1,new Rectangle(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(11,117,303,66)),
				//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,11,305,92),new Bitmap(new BannerAsset())),
				//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,148,259,16),new Bitmap(new HeralTagsAsset()))
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(105,151,116,16),new Bitmap(new ExpAewardAsset()))
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnTransportNow = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.transferRightNow"));
			_btnTransportNow.move(52,188);
			addChild(_btnTransportNow);
			
			_btnGo = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.autoFindWay"));
			_btnGo.move(127,188);
			addChild(_btnGo);
			if(_type == 7)
			{
				_btnGo.enabled = false;
			}
			
			_btnClose = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.close"));
			_btnClose.move(202,188);
			addChild(_btnClose);
			
			_bannerImg = new Bitmap();
			_bannerImg.x = 10;
			_bannerImg.y = 11;
			addChild(_bannerImg);
			
			_txtOpenTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtOpenTime.move(DEFAULT_WIDTH/2,130);
			addChild(_txtOpenTime);
			
			_rewardImg = new Bitmap();
			_rewardImg.x = 24;
			_rewardImg.y = 151;
			addChild(_rewardImg);
			
			var path:int;
			switch(_type)
			{
				case 0 :
				{
					path = 6;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "13:00-13:30");
					_rewardImg.bitmapData = new RewardTxtAsset6() as BitmapData;
					break;
				}
				case 1 :
				{
					path = 7;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "14:45,21:30");
					_rewardImg.bitmapData = new RewardTxtAsset7() as BitmapData;
					break;
				}
				case 2 :
				{
					path = 8;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "");
					break;
				}
				case 3 :
				{
					path = 5;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "19:00-19:20 ");
					_rewardImg.bitmapData = new RewardTxtAsset5() as BitmapData;
					break;
				}
				case 4 :
				{
					path = 10;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "16:00-16:20、21:00-21:20");
					_rewardImg.bitmapData = new RewardTxtAsset8() as BitmapData;
					break;
				}
				case 5 :
				{
					path = 9;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "15:00-16:00 ");
//					_rewardImg.bitmapData = new RewardTxtAsset8() as BitmapData;
					break;
				}
				case 6 :
				{
					path = 11;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "20:00-20:15");
					_rewardImg.bitmapData = new RewardTxtAsset8() as BitmapData;
					break;
				}
				case 7 :
				{
					path = 12;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "14:00-14:30、22:00-22:30");
					_rewardImg.bitmapData = new RewardTxtAsset9() as BitmapData;
					break;
				}
				case 8 :
				{
					path = 13;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "19:30-20:00");
					_rewardImg.bitmapData = new RewardTxtAsset10() as BitmapData;
					break;
				}
				case 9:
				{
					path = 15;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "21:30-22:00");
					_rewardImg.bitmapData = new RewardTxtAsset10() as BitmapData;
					break;
				}
				case 10:
				{
					path = 14;
					_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "全天");
					_rewardImg.bitmapData = new RewardTxtAsset10() as BitmapData;
					break;
				}
			}
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(path);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bannerImg.bitmapData = data;
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			ModuleEventDispatcher.addModuleEventListener(ActiveStartEvents.ACTIVE_FINISH,activeFinish);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_btnTransportNow.addEventListener(MouseEvent.CLICK,transClick);
			_btnGo.addEventListener(MouseEvent.CLICK,autoFindWayClick);
			
		}
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			ModuleEventDispatcher.removeModuleEventListener(ActiveStartEvents.ACTIVE_FINISH,activeFinish);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_btnTransportNow.removeEventListener(MouseEvent.CLICK,transClick);
			_btnGo.removeEventListener(MouseEvent.CLICK,autoFindWayClick);
		}
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - this.width,parent.stage.stageHeight - this.height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function transClick(evt:MouseEvent):void
		{
			if(MapTemplateList.getMapTemplate(GlobalData.currentMapId).type == 1)
			{	
				if(_activityId == 1011)				
					MAlert.show(LanguageManager.getWord("ssztl.scene.isSureEnterScene"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,trueUseFeixie);
				else 
					MAlert.show(LanguageManager.getWord("ssztl.pvp.userFeixie"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,trueUseFeixie);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveCurrentScene"));
			}
			dispose();
		}
		
		private function autoFindWayClick(evt:MouseEvent):void
		{
			if(MapTemplateList.getMapTemplate(GlobalData.currentMapId).type == 1)
			{
				if(_isToMap)
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:_sceneId, target:_targetPoint}));
				}
				if(_isToNpc)
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC,_npcId));
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveCurrentScene"));
			}
			dispose();
		}
		
		private function trueUseFeixie(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				if(_activityId == 1006)
				{
					ClubCampEnterSocketHandler.send();
				}
				if(_activityId == 1011)
				{
					BigBossWarEnterSocketHandler.send();
				}
//				if(_activityId == 1012)
//				{
//					GuildPVPEnterSocketHandler.send();
//				}
				else
				{
					ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:_sceneId, target:_targetPoint}));
				}
			}
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
//		public function update(time:int,dt:Number = 0.04):void
//		{
//			_count++;
//			if(_count >= 25)
//			{
//				_seconds --;
//				if(_seconds == 0)
//				{
//					dispose();
//				}else
//				{
//					_btnClose.labelField.text = LanguageManager.getWord("ssztl.common.close1",_seconds);
//				}				
//				_count = 0;
//			}
//		}
		
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		public function activeFinish(e:ActiveStartEvents):void
		{
			if (_activityId == e.data)
			{
				dispose();
			}
		}		
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		
		public function get type():int
		{
			return _type;
		}
		
		override public function dispose():void
		{
//			GlobalAPI.tickManager.removeTick(this);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_btnTransportNow)
			{
				_btnTransportNow.dispose();
				_btnTransportNow = null;
			}
			if(_btnGo)
			{
				_btnGo.dispose();
				_btnGo = null;
			}
			if(_rewardImg && _rewardImg.bitmapData)
			{
				_rewardImg.bitmapData.dispose();
				_rewardImg = null;
			}
			_dragArea = null;
			_picPath = null;
			_txtOpenTime = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}