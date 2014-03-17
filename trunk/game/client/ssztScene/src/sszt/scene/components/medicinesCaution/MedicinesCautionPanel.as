package sszt.scene.components.medicinesCaution
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.constData.ShopID;
	import sszt.core.data.module.changeInfos.ToNpcStoreData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.MedicinesCautionMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class MedicinesCautionPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:MedicinesCautionMediator;
		private var _medicinesType:int;
		
		private var _txtTip:MAssetLabel;
		private var _btnBuyPackage:MCacheAssetBtn1;
		private var _btnRemoteStore:MCacheAssetBtn1;
		
		public function MedicinesCautionPanel(mediator:MedicinesCautionMediator, medicinesType:int)
		{
			_mediator = mediator;
			_medicinesType = medicinesType;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(256,110);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(10,4,236,70)),
				]);
			addContent(_bg as DisplayObject);
			
			_txtTip = new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_txtTip.wordWrap = true;
			_txtTip.setSize(210,42);
			_txtTip.move(22,20);
			addContent(_txtTip);
			
			_btnBuyPackage = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.scene.medicinesBuyPackage'));
			_btnBuyPackage.move(57,77);
			addContent(_btnBuyPackage);
			
			_btnRemoteStore = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.bag.farDrug'));
			_btnRemoteStore.move(129,77);
			addContent(_btnRemoteStore);
			
			var tip:String;
			if(_medicinesType == 1)
			{
				tip = LanguageManager.getWord('ssztl.scene.medicinesCautionPanelTipHp');
			}
			else if(_medicinesType == 2)
			{
				tip = LanguageManager.getWord('ssztl.scene.medicinesCautionPanelTipMp');
			}
			_txtTip.setValue(tip);
			
//			if(GlobalData.selfPlayer.getVipType() <= VipType.NORMAL)
//			{
//				_btnRemoteStore.enabled = false;
//			}
		}
		
		private function initEvent():void
		{
			_btnBuyPackage.addEventListener(MouseEvent.CLICK, btnBuyPackageHandler);
			_btnRemoteStore.addEventListener(MouseEvent.CLICK, btnRemoteStoreHandler);
		}
		
		private function removeEvent():void
		{
			_btnBuyPackage.removeEventListener(MouseEvent.CLICK, btnBuyPackageHandler);
			_btnRemoteStore.removeEventListener(MouseEvent.CLICK, btnRemoteStoreHandler);
		}
		
		private function btnRemoteStoreHandler(event:MouseEvent):void
		{
//			if(GlobalData.selfPlayer.getVipType() > VipType.NORMAL)
//			{
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
				SetModuleUtils.addNPCStore(new ToNpcStoreData(ShopID.NPC_SHOP,1));
//			}
		}
		
		private function btnBuyPackageHandler(event:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(_medicinesType == 1)
			{
				BuyPanel.getInstance().show([206018,206020],new ToStoreData(ShopID.STORE));
			}
			else if(_medicinesType == 2)
			{
				BuyPanel.getInstance().show([206019,206021],new ToStoreData(ShopID.STORE));
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			_txtTip = null;
			if(_btnBuyPackage)
			{
				_btnBuyPackage.dispose();
				_btnBuyPackage= null;
			}
			if(_btnRemoteStore)
			{
				_btnRemoteStore.dispose();
				_btnRemoteStore= null;
			}
		}
	}
}