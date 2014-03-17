package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.module.ModuleType;
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	
	public class PetPVPIconBtn extends BaseIconBtn
	{
		private var _petPVPIconBtn:MBitmapButton;
		public function PetPVPIconBtn(argMediator:QuickIconMediator)
		{
			super(argMediator);
			_tipString = "有宠物挑战信息";
		}
		
		override protected function initView():void
		{
			super.initView();
			
			_petPVPIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconDeathAsset") as BitmapData);
			addChild(_petPVPIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			if(GlobalAPI.moduleManager.getModuleById(ModuleType.PET_PVP)==null)
				SetModuleUtils.addPetPVP();
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.PETPVP_ICON_REMOVE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_petPVPIconBtn)
			{
				_petPVPIconBtn.dispose();
				_petPVPIconBtn = null;
			}
		}
	}
}