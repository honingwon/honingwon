package sszt.core.view.tips
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.backgroundUtil.BackgroundType;
	
	import ssztui.ui.BorderAsset4;
	import ssztui.ui.BorderAssetTip1;
	
	public class BaseTip extends Sprite implements ITick
	{
		protected var _bg:BorderAssetTip1;
		protected var _qbg:Bitmap;
		protected var _text:TextField;
		private var _disposeTime:int;
		
		protected const LEADING:int = 6;
		protected const OFFSET:int = 6;
		
		public function BaseTip()
		{
			super();
			init();
		}
		
		protected function init():void
		{
			mouseChildren = mouseEnabled = false;
			_bg = new BorderAssetTip1();
			addChild(_bg);
			_qbg = new Bitmap();
			addChild(_qbg);
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
//			_text.filters = [new GlowFilter(0x000000,1,2,2,4.5)];
			_text.wordWrap = _text.multiline = true;
			_text.mouseEnabled = _text.mouseWheelEnabled = _text.selectable = false;
			_text.width = 180;
			_text.x = 6;
			_text.y = OFFSET;
			addChild(_text);
		}
		
		protected function clear():void
		{
			if(_text && _text.parent)_text.parent.removeChild(_text);
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,null,null,null,null,3);
//			_text.filters = [new GlowFilter(0x000000,1,2,2,4.5)];
			_text.wordWrap = _text.multiline = true;
			_text.mouseEnabled = _text.mouseWheelEnabled = _text.selectable = false;
			_text.width = 180;
			_text.x = 6;
			_text.y = OFFSET;
			addChildAt(_text,1);
		}
		
		/*public function setqbg(q:int):void
		{			
			if(_qbg && _qbg.bitmapData)
			{
				_qbg.bitmapData.dispose();
			}
			if(q == 1)
			{
				_qbg.bitmapData = 				
			}			
		}*/
		public function setTips(mes:String):void
		{
			_text.width = 330;
			_text.defaultTextFormat  = new TextFormat("Tahoma",12,0xFFFCCC,null,null,null,null,null,null,null,null,null,3);
			_text.htmlText = mes;
			_text.width = _text.textWidth + 6;
		}
		
		public function show():void
		{
			GlobalAPI.tickManager.removeTick(this);
			
			_text.height = _text.textHeight + 4;
			_bg.width = _text.width + OFFSET * 2;
			_bg.height = _text.height +  _text.y * 2;
			
			this.visible = true;
			if(parent == null)
				GlobalAPI.layerManager.getTipLayer().addChild(this);
		}
		
		public function hide():void
		{
			this.visible = false;
			_disposeTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - _disposeTime >= 3000)
			{
				dispose();
			}
		}
		
		override public function get width():Number
		{
			return _bg.width;
		}
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			if(parent)parent.removeChild(this);
		}
	}
}