package sszt.core.view
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.changeInfos.ToVipData;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	
	public class VipIcon extends Sprite
	{
		private var _asset:IMovieWrapper;
		
		public function VipIcon()
		{
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			buttonMode = true;
			_asset = GlobalAPI.movieManagerApi.getMovieWrapper(AssetUtil.getAsset("mhsm.common.MailAsset",MovieClip) as MovieClip,26,26,7);
			addChild(_asset as DisplayObject);
		}
		
		private function initEvent():void
		{
			this.addEventListener(MouseEvent.CLICK,clickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			this.removeEventListener(MouseEvent.CLICK,clickHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(CommonConfig.GAME_WIDTH - 99,CommonConfig.GAME_HEIGHT - 80);
		}
		
		private function clickHandler(evt:MouseEvent):void
		{
			_asset.stop();
			SetModuleUtils.addVip(new ToVipData(0));
			dispose();
		}
		
		public function show():void
		{
			sizeChangeHandler(null);
			var index:int = setTimeout(showHandler,3000);
			var tmp:VipIcon = this;
			function showHandler():void
			{
				if(index != 0)
				{
					clearTimeout(index);
				}
				GlobalAPI.layerManager.getPopLayer().addChild(tmp);
				_asset.play();
			}
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_asset)
			{
				_asset.dispose();
				_asset = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}