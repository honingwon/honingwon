package sszt.scene.components.common
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	
	import sszt.constData.CommonConfig;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	
	public class TransportBtn extends MSprite
	{
		private var _transportBtn:MBitmapButton;
		private var _mediator:SceneMediator;
		
		public function TransportBtn(mediator:SceneMediator)
		{
			_mediator = mediator;
			super();
			initView();
			initEvent();
		}
		
		private function initView():void
		{
//			_transportBtn = new MBitmapButton(new TransportIconAsset());
			_transportBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.TransportIconAsset") as BitmapData);
			addChild(_transportBtn);
			
			gameSizeChangeHandler(null);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_transportBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
			_transportBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			this.x = CommonConfig.GAME_WIDTH/2 +56 + 50;
			this.y = CommonConfig.GAME_HEIGHT - 150;
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			_mediator.showTransportPanel();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_transportBtn)
			{
				_transportBtn.dispose();
				_transportBtn = null;
			}
			_mediator = null;
			super.dispose();
		}
	}
}