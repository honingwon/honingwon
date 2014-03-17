package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import sszt.core.data.module.changeInfos.ToMailData;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	
	public class MailIconBtn extends BaseIconBtn
	{
		private var _mailIconBtn:MBitmapButton;
		private var _tipSting:String;
		
		public function MailIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipMail");
		}
		
		override protected function initView():void
		{
			super.initView();
			_mailIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconMailAsset") as BitmapData);
			addChild(_mailIconBtn);
		}
		
		override protected  function btnClickHandler(e:MouseEvent):void
		{
			SetModuleUtils.addMail(new ToMailData(true,0,'',true));
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.MAIL_ICON_REMOVE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_mailIconBtn)
			{
				_mailIconBtn.dispose();
				_mailIconBtn = null;
			}
		}
	}
}