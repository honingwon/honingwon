package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	
	public class VeinsIconBtn extends BaseIconBtn
	{
		private var _veinsIconBtn:MBitmapButton;
		public function VeinsIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipVeins");
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_veinsIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconPointAsset") as BitmapData);
			addChild(_veinsIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			SetModuleUtils.addRole(GlobalData.selfPlayer.userId,1,true);
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.VEINS_ICON_REMOVE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_veinsIconBtn)
			{
				_veinsIconBtn.dispose();
				_veinsIconBtn = null;
			}
		}
	}
}