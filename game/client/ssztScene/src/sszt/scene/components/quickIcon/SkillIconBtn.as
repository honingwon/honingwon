package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToSkillData;
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
	
	public class SkillIconBtn extends BaseIconBtn
	{
		private var _skillIconBtn:MBitmapButton;
		public function SkillIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipSkill");
		}
		
		override protected function initView():void
		{
			super.initView();
			_skillIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconSkillAsset") as BitmapData);
			addChild(_skillIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			SetModuleUtils.addSkill(new ToSkillData(-1,true));
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.SKILL_ICON_REMOVE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_skillIconBtn)
			{
				_skillIconBtn.dispose();
				_skillIconBtn = null;
			}
		}
	}
}