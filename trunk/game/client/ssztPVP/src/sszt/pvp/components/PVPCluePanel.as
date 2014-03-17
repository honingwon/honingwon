package sszt.pvp.components
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
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CommonModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
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
	
	import ssztui.pvp.HeralTagsAsset;
	import ssztui.ui.BtnAssetClose;

	/**
	 * 自动传送 寻路
	 * @author chendong
	 * 
	 */	
	public class PVPCluePanel extends MSprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _timeShow:MAssetLabel;
		private var _btnClose:MAssetButton1;
		private var _dragArea:Sprite;
		
		/**
		 * 立即传送 
		 */		
		private var _btnDeliver:MCacheAssetBtn1;
		/**
		 * 自动寻路 
		 */		
		private var _btnGo:MCacheAssetBtn1;
		
		private var _bannerImg:Bitmap;
		private var _picPath:String
		
		public static const DEFAULT_WIDTH:int = 325;
		public static const DEFAULT_HEIGHT:int = 225;
		
		public function PVPCluePanel()
		{
			init();
			initEvent();
		}
		protected function init():void
		{
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_1,new Rectangle(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(11,117,303,66)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(10,11,305,92),new Bitmap(new BannerAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,151,259,16),new Bitmap(new HeralTagsAsset()))
			]);
			addChild(_bg as DisplayObject);
			
			_timeShow = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_timeShow.move(DEFAULT_WIDTH/2,130);
			addChild(_timeShow);
			_timeShow.setValue(LanguageManager.getWord("ssztl.common.time")+"：" + "20:30-21:00");
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnDeliver = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.transferRightNow"));
			_btnDeliver.move(90,188);
			addChild(_btnDeliver);
			
			_btnGo = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.common.autoFindWay"));
			_btnGo.move(166,188);
			addChild(_btnGo);
			
			_bannerImg = new Bitmap();
			_bannerImg.x = 10;
			_bannerImg.y = 11;
			addChild(_bannerImg);
			
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(0);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-26,4);
			addChild(_btnClose);
		}
		public function assetsCompleteHandler():void
		{	
		}
		private function loadAvatarComplete(data:BitmapData):void
		{
			_bannerImg.bitmapData = data;
		}
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			
			_btnDeliver.addEventListener(MouseEvent.CLICK,transClick);
			_btnGo.addEventListener(MouseEvent.CLICK,autoFindWayClick);
			
		}
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			
			_btnDeliver.removeEventListener(MouseEvent.CLICK,transClick);
			_btnGo.removeEventListener(MouseEvent.CLICK,autoFindWayClick);
		}
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		
		private function transClick(evt:MouseEvent):void
		{
			if(GlobalData.currentMapId < 3000 && MapTemplateList.getMapTemplate(GlobalData.currentMapId).type == 1)
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
			if(GlobalData.currentMapId < 3000 && MapTemplateList.getMapTemplate(GlobalData.currentMapId).type == 1)
			{
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTONPC,102110));
				dispose();
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
				ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.USE_TRANSFER,{sceneId:1021,target:new Point(1304,2570),npcId:102110}));
				dispose();
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
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - this.width,parent.stage.stageHeight - this.height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		override public function dispose():void
		{
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
			_picPath = null;
			_timeShow = null;
			_btnDeliver = null;
			_btnGo = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}