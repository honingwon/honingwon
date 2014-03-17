package sszt.core.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.club.camp.ClubCampEnterSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BtnAssetClose;
	
	public class ClubCampCollectionAttentionPanel extends MSprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _dragArea:MSprite;
		private var _btnClose:MAssetButton1;
		private static var instance:ClubCampCollectionAttentionPanel;
		
		private var _messageLabel:MAssetLabel;
		private var _goBtn:MCacheAssetBtn1;
		
		private var _bannerImg:Bitmap;
		private var _picPath:String
		
		public static const DEFAULT_WIDTH:int = 325;
		public static const DEFAULT_HEIGHT:int = 225;
		
		public function ClubCampCollectionAttentionPanel()
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
				
			]);
			addChild(_bg as DisplayObject);
			
			_bannerImg = new Bitmap();
			_bannerImg.x = 10;
			_bannerImg.y = 11;
			addChild(_bannerImg);
			
			_picPath = GlobalAPI.pathManager.getActivityBannerPath(4);
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
			
			_dragArea = new MSprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_messageLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_messageLabel.wordWrap = true;
			_messageLabel.setSize(280,50);
			_messageLabel.move(22,130);
			addChild(_messageLabel);
			
			_goBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.goRightNow'));
			_goBtn.move(128,188);
			addChild(_goBtn);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-26,4);
			addChild(_btnClose);
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
			
			_goBtn.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			
			_goBtn.removeEventListener(MouseEvent.CLICK,onClick);
		}	
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		protected function onClick(event:MouseEvent):void
		{
			ClubCampEnterSocketHandler.send();
			hide();
		}
		
		public static function getInstance():ClubCampCollectionAttentionPanel
		{
			if(instance == null)
			{
				instance = new ClubCampCollectionAttentionPanel();
			}
			return instance;
		}
		
		public function show(message:String):void
		{
			_messageLabel.setHtmlValue(message);
			if(!parent)
			{
				GlobalAPI.layerManager.addPanel(this);
			}
		}
		
		public function hide():void
		{
			dispose();
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
			super.dispose();
			removeEvent();
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
			if(_bannerImg && _bannerImg.bitmapData)
			{
//				_bannerImg.bitmapData.dispose();
				_bannerImg = null;
			}
			_picPath = null;
			_dragArea = null;
			if(_goBtn)
			{
				_goBtn.dispose();
				_goBtn = null;
			}
			instance = null;
		}
	}
}