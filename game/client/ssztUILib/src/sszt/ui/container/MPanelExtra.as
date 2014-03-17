package sszt.ui.container
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.CommonConfig;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	
	import ssztui.ui.BtnAssetClose2;
	
	public class MPanelExtra extends MSprite implements IPanel
	{
		public static const DEFAULT_WIDTH:int = 300;
		public static const DEFAULT_HEIGHT:int = 400;
		
		private var _background:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _btnClose:MAssetButton1;
		
		public function MPanelExtra()
		{
			super();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			graphics.endFill();
			
			_background = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_16, new Rectangle(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)),
			]);
			addChild(_background as DisplayObject);
			
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0, 0);
			_dragArea.graphics.drawRect(0, 0, DEFAULT_WIDTH, 30);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose2());
			_btnClose.move(DEFAULT_WIDTH - 25, -4);
			addChild(_btnClose);
		}
		
		private function initEvent():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_btnClose.addEventListener(MouseEvent.CLICK, closePanel);
		}
		
		private function removeEvent():void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK, closePanel);
		}
		
		override public function setSize(width:Number , height:Number ):void
		{
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			if(_background)
			{
				_background.dispose();
				_background = null;
			}
			_background = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_16, new Rectangle(0, 0, width, height)),
			]);
			addChildAt(_background as DisplayObject, 0);
			
			move( (CommonConfig.GAME_WIDTH - width)/2, (CommonConfig.GAME_HEIGHT - height)/2);
			
			_dragArea.graphics.clear();
			_dragArea.graphics.beginFill(0, 0);
			_dragArea.graphics.drawRect(0, 0, width, 30);
			_dragArea.graphics.endFill();
			
			_btnClose.move(width - 25, -4);
		}
		
		private function closePanel(event:MouseEvent):void
		{
			dispose();
		}
		
		public function doEscHandler():void
		{
			closePanel(null);
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
		
		override public function dispose():void
		{
			removeEvent();
			if(_background)
			{
				_background.dispose();
				_background = null;
			}
			if(_dragArea)
			{
				_dragArea = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}