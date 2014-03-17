package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.scene.mediators.QuickIconMediator;
	
	public class WarIconBtn extends MSprite
	{
		private var _warIconBtn:MBitmapButton;
		private var _quickIconMediator:QuickIconMediator;
		public function WarIconBtn(argMediator:QuickIconMediator)
		{
			super();
			_quickIconMediator = argMediator;
			initialView();
			initialEvents();
		}
		
		private function initialView():void
		{
			_warIconBtn = new MBitmapButton(AssetUtil.getAsset("mhsm.scene.WarIconAsset") as BitmapData);
			addChild(_warIconBtn);
		}
		
		private function initialEvents():void
		{
			_warIconBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function removeEvents():void
		{
			_warIconBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			SetModuleUtils.addClub(5);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_warIconBtn)
			{
				_warIconBtn.dispose();
				_warIconBtn = null;
			}
		}
	}
}