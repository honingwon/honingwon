package sszt.scene.components.pk
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
//	import sszt.common.PKFailAsset;
//	import sszt.common.PKSameAsset;
//	import sszt.common.PKWinAsset;
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	
	public class PkResultView extends Sprite implements ITick
	{
		private var _pic:Bitmap;
		private var _count:int;
		private static var instance:PkResultView;
		
		
		public function PkResultView()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_pic = new Bitmap();
			addChild(_pic);
		}
		
		public static function getInstance():PkResultView
		{
			if(instance == null)
			{
				instance = new PkResultView();
			}
			return instance;
		}
		
		public function show(type:int):void
		{
			if(type == 1)
			{
				_pic.bitmapData = AssetUtil.getAsset("mhsm.common.PKWinAsset") as BitmapData;
			}
			else if(type == 2)
			{
				_pic.bitmapData = AssetUtil.getAsset("mhsm.common.PKFailAsset") as BitmapData;
			}
			else
			{
				_pic.bitmapData = AssetUtil.getAsset("mhsm.common.PKSameAsset") as BitmapData;
			}
			_count = 0;
			if(!parent) GlobalAPI.layerManager.getPopLayer().addChild(this);
			this.x = CommonConfig.GAME_WIDTH/2 - 150;
			this.y = 150;
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH/2 - 150;
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			_count++;
			if(_count < 25)
			{
				_pic.alpha = _count / 25;
			}else if(_count < 50)
			{
				_pic.alpha = 1;
			}else if(_count < 75)
			{
				_pic.alpha = 1 - (_count - 50)/25;
			}else
			{
				dispose();
			}
		}
		
		private function dispose():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			GlobalAPI.tickManager.removeTick(this);
			_pic = null;
			instance = null;
			if(parent) parent.removeChild(this);
		}
	}
}