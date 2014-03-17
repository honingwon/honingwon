package sszt.ui.container
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	
	import sszt.constData.CommonConfig;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.BtnAssetClose2;
	import ssztui.ui.NpcPanelBgAsset;
	import ssztui.ui.NpcPanelTitleAsset;
	
	public class MNPCPanel extends MSprite implements IPanel
	{
		public static const DEFAULT_WIDTH:int = 538; //455;
		public static const DEFAULT_HEIGHT:int = 200; //202;
		
		private var _npcId:int;
		private var _npcName:String;
		
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		
		private var _title:MAssetLabel;
		private var _btnClose:MAssetButton1;
		protected var _imageLayout:MSprite;
		
		public function MNPCPanel(npcName:String)
		{
			_npcName = npcName;
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setSize(0,0);
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_16, new Rectangle(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)),
//				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(152,11,274,26)),
//				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(7, 12, 211, 26), new Bitmap(new NpcPanelTitleAsset()))
			]);
			addChild(_bg as DisplayObject);
			_imageLayout = new MSprite();
			addChild(_imageLayout);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(5,164,152,33), new Bitmap(new NpcPanelTitleAsset())));
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(140,7,392,183), new Bitmap(new NpcPanelBgAsset())));
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0, 0);
			_dragArea.graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
//			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-26,7);
			addChild(_btnClose);
			
			_title = new MAssetLabel('', MAssetLabel.LABEL_TYPE20);
			_title.move(82,170);
			_title.htmlText = '<font size="14"><b>' + _npcName + '</b></font>';
			
			addChild(_title);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, setPanelPosition);
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_btnClose.addEventListener(MouseEvent.CLICK, closePanel);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, setPanelPosition);
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK, closePanel);
		}
		
		private function closePanel(event:MouseEvent):void
		{
			dispose();
		}
		
		private function dragDownHandler(event:MouseEvent):void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			this.startDrag();
			
		}
		
		private function dragUpHandler(event:MouseEvent):void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			this.stopDrag();
		}
		
		private function setPanelPosition(e:Event):void
		{
			move(Math.floor((CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2), Math.floor((CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2));
		}
		
		override public function setSize(w:Number,h:Number):void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			graphics.endFill();
		}
		
		public function doEscHandler():void
		{
			closePanel(null);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_dragArea)
			{
				_dragArea = null;
			}
			if(_title)
			{
				_title = null;	
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_imageLayout && _imageLayout.parent)
			{
				_imageLayout.parent.removeChild(_imageLayout);
				_imageLayout = null;
			}
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}