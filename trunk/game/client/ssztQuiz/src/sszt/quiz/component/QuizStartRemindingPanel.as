package sszt.quiz.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.MapType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
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
	
	import ssztui.quiz.ExpAewardAsset;
	import ssztui.ui.BtnAssetClose;
	
	public class QuizStartRemindingPanel extends MSprite implements IPanel,ITick
	{
		public static const DEFAULT_WIDTH:int = 325;
		public static const DEFAULT_HEIGHT:int = 225;
		
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _txtOpenTime:MAssetLabel;
		private var _btnClose:MCacheAssetBtn1;
		private var _btnTransportNow:MCacheAssetBtn1;
		private var _btnGo:MCacheAssetBtn1;
		
		private var _bannerImg:Bitmap;
		private var _picPath:String;
		private var _npc:NpcTemplateInfo;
		
		private var _count:int = 0; 
		private var _seconds:int = 60;
		
		public function QuizStartRemindingPanel()
		{
			super();
			
			_npc = NpcTemplateList.getNpc(102130);
			
			initEvent();
			GlobalAPI.tickManager.addTick(this);
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
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,151,253,16),new Bitmap(new ExpAewardAsset()))
			]);
			addChild(_bg as DisplayObject);
			
			_txtOpenTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtOpenTime.move(DEFAULT_WIDTH/2,130);
			addChild(_txtOpenTime);
			_txtOpenTime.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "12:00--12:10、18:00--18:10");
			
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
			
			_btnClose = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.close"));
			_btnClose.move(202,188);
			addChild(_btnClose);
			
			_bannerImg = new Bitmap();
			_bannerImg.x = 10;
			_bannerImg.y = 11;
			addChild(_bannerImg);
			
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(1);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bannerImg.bitmapData = data;
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_btnTransportNow.addEventListener(MouseEvent.CLICK,transClick);
			_btnGo.addEventListener(MouseEvent.CLICK,autoFindWayClick);
			
		}
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
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
				MAlert.show(LanguageManager.getWord("ssztl.pvp.userFeixie"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,trueUseFeixie);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveCurrentScene"));
			}
		}
		
		private function autoFindWayClick(evt:MouseEvent):void
		{
			if(MapTemplateList.getMapTemplate(GlobalData.currentMapId).type == 1)
			{
				var map:MapTemplateInfo = MapTemplateList.getMapTemplate(MapType.QUIZ);
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:_npc.sceneId, target:_npc.getAPoint()}));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveCurrentScene"));
			}
		}
		
		private function trueUseFeixie(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				var map:MapTemplateInfo = MapTemplateList.getMapTemplate(MapType.QUIZ);
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:_npc.sceneId, target:_npc.getAPoint()}));
			}
		}
		
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		
		public function update(time:int,dt:Number = 0.04):void
		{
			_count++;
			if(_count >= 25)
			{
				_seconds --;
				if(_seconds == 0)
				{
					dispose();
				}else
				{
					_btnClose.labelField.text = LanguageManager.getWord("ssztl.common.close1",_seconds);
				}				
				_count = 0;
			}
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
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
			_dragArea = null;
			_picPath = null;
			_txtOpenTime = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}