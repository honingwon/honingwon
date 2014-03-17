package sszt.common.wareHouse.component
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.common.wareHouse.WareHouseController;
	import sszt.common.wareHouse.socket.WareHouseBankSocketHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class PopUpPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _maxBtn:MCacheAsset3Btn;
		private var _okBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _countInput:TextField;
		private var _controller:WareHouseController;
		/**
		 *0存款，1取款 
		 */		
		private var _type:int;
		
		public function PopUpPanel(type:int,control:WareHouseController)
		{
			_type = type;
			_controller = control;
			var label:String;
			if(_type == 0)
				label = LanguageManager.getWord("ssztl.common.saveMoney");

			else
				label = LanguageManager.getWord("ssztl.common.getMoney");
			super(new MCacheTitle1(label),true,-1);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(276,107);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,276,74)),
				new BackgroundInfo(BackgroundType.BAR_6,new Rectangle(66,27,97,22)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(30,30,28,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.count"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT))
			]);
			addContent(_bg as DisplayObject);
			
			_maxBtn = new MCacheAsset3Btn(1,LanguageManager.getWord("ssztl.common.maxCount"));
			_maxBtn.move(174,26);
			addContent(_maxBtn);
			
			_okBtn = new MCacheAsset1Btn(0,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(32,79);
			addContent(_okBtn);
			
//			_cancelBtn = new MCacheAsset1Btn(0,"取消");
			_cancelBtn = new MCacheAsset1Btn(0,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(175,78);
			addContent(_cancelBtn);
			
			_countInput = new TextField();
			_countInput.textColor = 0xFFFFFF;
			_countInput.type = "input";
			_countInput.restrict = "0123456789";
			_countInput.maxChars = 10;
			_countInput.x = 68;
			_countInput.y = 27;
			_countInput.width = 97;
			_countInput.height = 22;
			_countInput.text = "1";
			addContent(_countInput);
		}
		
		private function initEvent():void
		{
			_maxBtn.addEventListener(MouseEvent.CLICK,maxClickHandler);
			_okBtn.addEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function removeEvent():void
		{
			_maxBtn.removeEventListener(MouseEvent.CLICK,maxClickHandler);
			_okBtn.removeEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);	
		}
		
		private function maxClickHandler(evt:MouseEvent):void
		{
			if(_type == 0)
			{
				_countInput.text = String(GlobalData.selfPlayer.userMoney.copper);
			}else
			{
				_countInput.text = String(GlobalData.selfPlayer.userMoney.bankCopper);
			}
		}
		
		private function okClickHandler(evt:MouseEvent):void
		{
			if(_type == 0)
			{
				if(int(_countInput.text)>GlobalData.selfPlayer.userMoney.copper)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
					return;
				}
			}else
			{
				if(int(_countInput.text)>GlobalData.selfPlayer.userMoney.bankCopper)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.copperNotEnough"));
					return;
				}
			}
			WareHouseBankSocketHandler.sendBank(_type,int(_countInput.text));
			dispose();
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
			}
			if(_maxBtn)
			{
				_maxBtn.dispose();
				_maxBtn = null;
			}
			if(_okBtn)
			{
				_okBtn.dispose();
				_okBtn = null;
			}
			if(_maxBtn)
			{
				_maxBtn.dispose();
				_maxBtn = null;
			}
			_countInput = null;
			super.dispose();
		}
			
	}
}