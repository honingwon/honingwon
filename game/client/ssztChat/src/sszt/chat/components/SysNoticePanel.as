package sszt.chat.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	import ssztui.chat.BgNoticeAsset;
	
	public class SysNoticePanel implements ITick
	{
		private static var _pattern:RegExp = /\{[^\}]*\}/g;
		//单条消息连续播放的次数
		private static var PLAYS:int = 1;
		//文字移动速度，值越大，移动速度越快，默认2，实际速度大约为1秒50px。
		private static var SPEED:int = 2;
		
		//记录单条消息已经连续播放的次数
		private var _playsCounter:int = 0;
		//消息队列，先进先出
		private var _messageQueue:Array = [];
		
		private var _container:DisplayObjectContainer;
		
		private var _field:TextField;
		
		private var _bg:Bitmap;
		private var _mask:Bitmap;
		
		public function SysNoticePanel(container:DisplayObjectContainer)
		{
			_container = container;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			_bg = new Bitmap(new BgNoticeAsset());
			_bg.width = 595;
			_bg.height = 33;
			
			_field = new TextField();
			_field.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),14,0xffde9b,true);
			_field.mouseEnabled = _field.mouseWheelEnabled = false;
			_field.cacheAsBitmap = true;
			_field.wordWrap = false;
			_field.x = CommonConfig.GAME_WIDTH - (CommonConfig.GAME_WIDTH - _bg.width) / 2;
			_field.y = 72;
			
			_mask = new Bitmap(new BitmapData(1,1,false,0x55000000));
			_mask.width = 595;//CommonConfig.GAME_WIDTH - 450;
			_mask.height = 33;
			_field.mask = _mask;
			
			_bg.x = _mask.x = CommonConfig.GAME_WIDTH / 2 - _bg.width / 2;
			_bg.y = _mask.y = 65;
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			_bg.width = 595;//CommonConfig.GAME_WIDTH - 450;
			
			_mask.width = 595;//CommonConfig.GAME_WIDTH - 450;
			_bg.x = _mask.x = CommonConfig.GAME_WIDTH / 2 - _mask.width / 2;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{ 
			if(_messageQueue.length > 0)
			{
				if(_playsCounter < PLAYS)
				{
					
					if(_field.x > _bg.x -_field.width - 20)
					{
						_field.x -= SPEED;
					}
					else//当文字刚好看不到之后再移动20px
					{
						_field.x = CommonConfig.GAME_WIDTH - (CommonConfig.GAME_WIDTH - _bg.width) / 2;
						_playsCounter++;
					}
				}
				else//单个消息播放完毕
				{
					_playsCounter = 0;
					_messageQueue.shift();
					if(_messageQueue.length > 0)
					{
						while(_messageQueue.length > 10)
						{
							_messageQueue.shift();
						}
						_field.text = _messageQueue[0];
						_field.width = _field.textWidth + 10;
					}
					else//无待播放消息
					{
						_field.x = CommonConfig.GAME_WIDTH - (CommonConfig.GAME_WIDTH - _bg.width) / 2;
						_field.text = "";
					}
				}
			}
			else//当所有的消息按照指定的次数播放完毕之后
			{
				clearView();
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public function appendMessage(mes:String):void
		{
			var list:Array = mes.match(_pattern);
			if(list != null && list.length > 0)
			{
				for(var i:int = 0; i < list.length; i++)
				{
					var parms:Array = String(list[i]).slice(2,String(list[i]).length-1).split("-");
					mes = mes.replace(list[i],parms[0].split("$$")[0]);
				}
			}
			_messageQueue.push(mes);
			
			addView();
			
			if(_field.text == '')
			{
				_field.text = mes;
				_field.width = _field.textWidth + 10;
			}
			
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function addView():void
		{
			if(_container)
			{
				if(_bg.parent != _container)_container.addChild(_bg);
				if(_field.parent != _container)_container.addChild(_field);
				if(_mask)_container.addChild(_mask);
			}
		}
		
		private function clearView():void
		{
			if(_bg.parent)_bg.parent.removeChild(_bg);
			if(_field.parent)_field.parent.removeChild(_field);
			if(_mask.parent)_mask.parent.removeChild(_mask);
		}
		
		public function dispose():void
		{
			clearView();
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			_field = null;
			_mask = null;
		}
	}
}