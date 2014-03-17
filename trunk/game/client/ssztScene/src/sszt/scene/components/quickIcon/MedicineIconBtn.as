package sszt.scene.components.quickIcon
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import sszt.core.data.quickIcon.QuickIconInfoEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MSprite;
	
	public class MedicineIconBtn extends BaseIconBtn
	{
		private var _medicineIconBtn:MBitmapButton;
		private var _data:Object;
		
		public function MedicineIconBtn(argMediator:QuickIconMediator,data:Object)
		{
			super(argMediator);
			_data = data;
			_tipString = LanguageManager.getWord("ssztl.scene.quickTipMedicine");
		}
		
		override protected function initView():void
		{
			super.initView();
			_medicineIconBtn = new MBitmapButton(AssetUtil.getAsset("ssztui.scene.QuickIconDrugAsset") as BitmapData);
			addChild(_medicineIconBtn);
		}
		
		override protected function btnClickHandler(e:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.SHOW_MEDICINES_CAUTION_PANEL,_data));
			dispatchEvent(new QuickIconInfoEvent(QuickIconInfoEvent.MEDICINE_ICON_REMOVE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_medicineIconBtn)
			{
				_medicineIconBtn.dispose();
				_medicineIconBtn = null;
			}
		}
	}
}