package sszt.scene.components.gift
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	public class GetGitAnimation extends Sprite implements ITick
	{
		private static var instance:GetGitAnimation;
		private var _pic:MAssetButton1;
		private var X1:Number = CommonConfig.GAME_WIDTH - 220;
		private var X2:Number = CommonConfig.GAME_WIDTH -355;
		private var Y1:Number = 140;
		private var Y2:Number = CommonConfig.GAME_HEIGHT - 85;
		private var detalX:Number = (X1-X2)/50;
		private var detalY:Number = (Y2-Y1)/50;
		private var count:int;
		
		public function GetGitAnimation()
		{
			super();
		}
		
		public static function getInstance():GetGitAnimation
		{
			if(instance == null)
			{
				instance = new GetGitAnimation();
			}
			return instance;
		}
		
		public function show():void
		{
			var btnAsset:MovieClip = AssetUtil.getAsset("ssztui.scene.TopBtnAwardAsset") as MovieClip;
			if(btnAsset)
			{
				_pic = new MAssetButton1(btnAsset);
				addChild(_pic);
			}
			else
			{
				ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			}
			
			this.x = X1;
			this.y = Y1;
			
			count = 0;
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function sceneAssetCompleteHandler(evt:CommonModuleEvent):void
		{
			var btnAsset:MovieClip = AssetUtil.getAsset("ssztui.scene.TopBtnAwardAsset") as MovieClip;
			_pic = new MAssetButton1(btnAsset);
			addChild(_pic);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			this.x = X1 - detalX * count;
			this.y = Y1 + detalY * count;
			count++;
			if(count >= 50) dispose();
		}
		
		public function dispose():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.SCENE_ASSET_COMPLETE,sceneAssetCompleteHandler);
			_pic = null;
			instance = null;
			GlobalAPI.tickManager.removeTick(this);
			if(parent) parent.removeChild(this);
		}
	}
}