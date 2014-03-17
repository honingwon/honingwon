package sszt.scene.components.pk
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	public class PkCountDownAction extends Sprite implements ITick
	{
		private static var _pic1:BitmapData;
		private static var _pic2:BitmapData;
		private static var _pic3:BitmapData;
		private var _count:int;
		private var display:Bitmap;
		private static var instance:PkCountDownAction; 
		private var _timeoutIndex:int = -1;
		
		public function PkCountDownAction()
		{
			super();
			init();
			mouseEnabled = mouseChildren = false;
		}
		
		private function init():void
		{
			display = new Bitmap();
			addChild(display);
		}
		
		public static function getInstance():PkCountDownAction
		{
			if(instance == null)
			{
				instance = new PkCountDownAction();
			}
			return instance;
		}
		
		public function show():void
		{
			if(!parent) GlobalAPI.layerManager.getPopLayer().addChild(this);
			display.bitmapData = null;
			_count = 0;
			this.x = CommonConfig.GAME_WIDTH/2 - 150;
			this.y = 150;
			var tmp:PkCountDownAction = this;
			_timeoutIndex = setTimeout(delayHandler,7000);
			function delayHandler():void
			{
				GlobalAPI.tickManager.addTick(tmp);
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
				if(_timeoutIndex != -1)
				{
					clearTimeout(_timeoutIndex);
				}
			}
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH/2 - 150;
			this.y = 150;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_count++;
			if(_count < 25)
			{
				if(_pic3)
				{
					display.bitmapData = _pic3;
				}
				else
				{
					_pic3 = AssetUtil.getAsset("mhsm.common.Number3Asset") as BitmapData;
				}
			}
			else if(_count < 50)
			{
				if(_pic2)
				{
					display.bitmapData = _pic2;
				}
				else
				{
					_pic2 = AssetUtil.getAsset("mhsm.common.Number2Asset") as BitmapData;
				}
			}
			else if(_count <75)
			{
				if(_pic1)
				{
					display.bitmapData = _pic1;
				}
				else
				{
					_pic1 = AssetUtil.getAsset("mhsm.common.Number1Asset") as BitmapData;
				}
			}
			else
			{
				dispose();	
			}
		}
		
		public function dispose():void
		{
			if(_timeoutIndex != -1)
			{
				clearTimeout(_timeoutIndex);
			}
			GlobalAPI.tickManager.removeTick(this);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			if(parent) parent.removeChild(this);
		}
	}
}