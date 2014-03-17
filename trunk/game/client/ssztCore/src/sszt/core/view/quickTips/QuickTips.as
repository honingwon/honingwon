package sszt.core.view.quickTips
{
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	public class QuickTips extends Sprite implements ITick
	{
		private static var _quickTips:QuickTips;
		private var _flag:Boolean;
//		private var _fields:Vector.<TextField>;
		private var _fields:Array;
//		private var _containers:Vector.<Sprite>;
		private var _containers:Array;
//		private var _frameCounts:Vector.<int>;
		private var _frameCounts:Array;
		
		public function QuickTips()
		{
			super();
			initView();
		}
		
		public static function show(tips:String):void
		{
			if(_quickTips == null)
				_quickTips = new QuickTips();
			_quickTips.appendMessage(tips);
		}
		
		private function initView():void
		{
			_flag = false;
//			_containers = new Vector.<Sprite>();
			_containers = [];
//			_fields = new Vector.<TextField>();
			_fields = [];
//			_frameCounts = new Vector.<int>();
			_frameCounts = [];
			for(var i:int = 0; i < 3; i++)
			{
				var container:Sprite = new Sprite();
				container.alpha = 0;
				container.y = 90 + i * 30;
				addChild(container);
				_containers.push(container);
				
				var textfield:TextField = new TextField();
				var f:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xFFF100,true, null, null, null, null, TextFormatAlign.CENTER, null, null, null, 0);
				f.letterSpacing = 3;
				textfield.defaultTextFormat = f;
				textfield.filters = [new GlowFilter(0x000000,1,2,2,8)];
				textfield.width = 500;
				textfield.mouseEnabled = false;
				container.addChild(textfield);
				_fields.push(textfield);
				_frameCounts.push(0);
			}
			
//			this.x = (CommonConfig.GAME_WIDTH >> 1)  + 200;
//			this.y =(CommonConfig.GAME_HEIGHT >>1 ) + 40;
			sizeChangeHandler(null);
			this.mouseChildren = this.mouseEnabled = false;
			
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		private function sizeChangeHandler(e:CommonModuleEvent):void
		{
			this.x = (CommonConfig.GAME_WIDTH >> 1);
			this.y = (CommonConfig.GAME_HEIGHT >> 1);
		}
		
		private function appendMessage(mes:String):void
		{
			if(_fields[2].text != "")
			{
				_fields[0].text = _fields[1].text;
				_fields[1].text = _fields[2].text;
				_fields[2].text = mes;
			}
			else
			{
				for(var i:int = 0; i < _fields.length; i++)
				{
					if(_fields[i].text == "")
					{
						_fields[i].text = mes;
						break;
					}
				}
			}
			
			if(!_flag)
			{
				_flag = true;
				GlobalAPI.layerManager.getTipLayer().addChild(_quickTips);
				GlobalAPI.tickManager.addTick(_quickTips);
			}
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			var i:int;
			for(i = 0; i < _frameCounts.length; i++)
			{
				if(_fields[i].text != "")
				{
					if(_frameCounts[i] < 30)
					{
						_containers[i].alpha += 0.05;
						_containers[i].y -= 1;
					}
					else if(_frameCounts[i] < 80)
					{
						_containers[i].alpha = 1;
						_containers[i].y = 60 + i * 30;
					}
					else if(_frameCounts[i] < 110)
					{
						_containers[i].alpha -= 0.05;
						_containers[i].y -= 2;
					}
					else if(_frameCounts[i] >= 110)
					{
						_fields[i].text = "";
						_containers[i].alpha = 0;
						_containers[i].y = 90 + i * 30;
					}
					_frameCounts[i] += times;
				}
			}
			
			var p:Boolean = true;
			for(i = 0; i < _frameCounts.length; i++)
			{
				if(_fields[i].text != "" && _frameCounts[i] < 110)p = false;
			}
			if(p)
			{
				for(i = 0; i < _frameCounts.length; i++)
				{
					_fields[i].text = "";
					_frameCounts[i] = 0;
					_containers[i].alpha = 0;
					_containers[i].y = 90 + i * 30;
				}
				_flag = false;
				if(this.parent)this.parent.removeChild(this);
				GlobalAPI.tickManager.removeTick(this);
			}
		}
	}
}