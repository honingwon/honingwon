package sszt.welfare.component.view
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.itemDiscount.ItemDiscountSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.events.WelfareEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.welfare.component.WelfarePanel;
	import sszt.welfare.component.cell.DiscountCell;
	import sszt.welfare.mediator.WelfareMediator;
	
	import ssztui.ui.CellBigBgAsset;
	import ssztui.ui.YuanBaoAsset;
	import ssztui.welfare.BtnPayAsset;
	
	/**
	 * 抢购特区 
	 * @author chendong
	 * 
	 */	
	public class HotGoodView extends Sprite
	{
		private var _cheapItem1:DiscountCell;
		private var _cheapItem2:DiscountCell;
		private var _cheapItem3:DiscountCell;
		private var _chargeBtn:MAssetButton1;
		private var _yuanBao:MAssetLabel;
		
		private var _mediator:WelfareMediator;
		
		private var _shopType:int = 1;
		public function HotGoodView(mediator:WelfareMediator)
		{
			_mediator = mediator;
			initView();
			initEvent();
			ItemDiscountSocketHandler.sendDiscount();
		}
		
		private function initView():void
		{
			_cheapItem1 = new DiscountCell(_shopType);
			_cheapItem2 = new DiscountCell(_shopType);
			_cheapItem3 = new DiscountCell(_shopType);
			_cheapItem1.move(3,29);
			_cheapItem2.move(3,125);
			_cheapItem3.move(3,221);
			addChild(_cheapItem1);
			addChild(_cheapItem2);
			addChild(_cheapItem3);
			
			_yuanBao = new MAssetLabel(LanguageManager.getWord("ssztl.common.yuanBao") + "：　 "+String(GlobalData.selfPlayer.userMoney.yuanBao),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_yuanBao.textColor = 0xffc500;
			_yuanBao.move(11,332);
			addChild(_yuanBao);
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(45,332,18,18),new Bitmap(WelfarePanel.yuanBaoAsset)));
			
			_chargeBtn = new MAssetButton1(BtnPayAsset);
			_chargeBtn.move(101,325);
//			addChild(_chargeBtn);
			if(!GlobalData.canCharge)_chargeBtn.enabled = false;
			
		}
		
		private function initEvent():void
		{
//			addEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
			ModuleEventDispatcher.addModuleEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
			_chargeBtn.addEventListener(MouseEvent.CLICK,chargeClickHandler);
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
		}
		
		private function discountHandler(evt:WelfareEvent):void
		{
//			_cheapItem1.cheapItem = _mediator.welfareModule.cheapInfo.cheapItems[0];
//			_cheapItem2.cheapItem = _mediator.welfareModule.cheapInfo.cheapItems[1];
//			_cheapItem3.cheapItem = _mediator.welfareModule.cheapInfo.cheapItems[2];
			
			_cheapItem1.cheapItem = GlobalData.cheapInfo.cheapItems[0];
			_cheapItem2.cheapItem = GlobalData.cheapInfo.cheapItems[1];
			_cheapItem3.cheapItem = GlobalData.cheapInfo.cheapItems[2];
		}
		private function moneyUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_yuanBao.setValue(LanguageManager.getWord("ssztl.common.yuanBao2") + "：　 "+String(GlobalData.selfPlayer.userMoney.yuanBao));
		}		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		private function removeEvent():void
		{
			_chargeBtn.removeEventListener(MouseEvent.CLICK,chargeClickHandler);
			ModuleEventDispatcher.removeModuleEventListener(WelfareEvent.DISCOUNT_UPDATE,discountHandler);
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
		} 
		private function chargeClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			JSUtils.gotoFill();
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_cheapItem1)
			{
				_cheapItem1.dispose();
				_cheapItem1 = null;
			}
			if(_cheapItem2)
			{
				_cheapItem2.dispose();
				_cheapItem2 = null;
			}
			if(_cheapItem3)
			{
				_cheapItem3.dispose();
				_cheapItem3 = null;
			}
			_yuanBao = null;
			if(_chargeBtn)
			{
				_chargeBtn.dispose();
				_chargeBtn = null;
			}
		}
	}
}