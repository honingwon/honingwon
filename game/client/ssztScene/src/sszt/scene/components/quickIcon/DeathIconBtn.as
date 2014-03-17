package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quickIcon.iconInfo.ClubIconInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTimerAlert;
	import sszt.ui.event.CloseEvent;
	
	public class DeathIconBtn extends BaseIconBtn
	{
		private var _clubIconBtn:MBitmapButton;
		
		public function DeathIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipDeath");
		}
		
		override protected function initView():void
		{
			super.initView();
			_clubIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconDeathAsset") as BitmapData);
			addChild(_clubIconBtn);
		}
		
		override protected  function btnClickHandler(e:MouseEvent):void
		{
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_clubIconBtn)
			{
				_clubIconBtn.dispose();
				_clubIconBtn = null;
			}
		}
	}
}