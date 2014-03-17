package sszt.stall.compoments
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.sendToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset4Btn;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.stall.StallDealItemInfo;
	import sszt.core.data.stall.StallDealPanelEvents;
	import sszt.core.data.stall.StallGoodsPanelEvents;
	import sszt.core.data.stall.StallInfo;
	import sszt.core.data.stall.StallMessageItemInfo;
	import sszt.core.utils.SetModuleUtils;
	import sszt.stall.compoments.itemView.DealContentItemView;
	import sszt.stall.compoments.itemView.MessageContentItemView;
	import sszt.stall.mediator.StallMediator;
	import sszt.stall.socketHandlers.StallOKSocketHandler;
	import sszt.stall.socketHandlers.StallPauseSocketHandler;
	
	public class DealPanel extends Sprite
	{
		public var _stallDealMediator:StallMediator;
		
		private var _clearTextfieldBtn:MCacheAsset4Btn;
		private var _clearGoodsBtn:MCacheAsset1Btn;
		private var _okStallBtn:MCacheAsset1Btn;
		private var _cancelStallBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _stallTextName:TextField;
		private var _dealContentPanel:MScrollPanel;
		private var _currentContentHeight:int;
		
		public function DealPanel(stallDealMediator:StallMediator)
		{
			_stallDealMediator = stallDealMediator;
			initialView();
			initalEvents();
		}
		
		 public function initialView():void
		 {
//			_dealTextfield = new TextField();
//			_dealTextfield.x = 15;
//			_dealTextfield.y = 59;
//			_dealTextfield.text = "测试";
//			_dealTextfield.height = 208;
//			_dealTextfield.width = 49;
//			addChild(_dealTextfield);
			
			_stallTextName = new TextField();
			_stallTextName.type = "input";
			_stallTextName.textColor = 0xFFFFFF;
			_stallTextName.text = GlobalData.selfPlayer.nick+"的小店";
			_stallTextName.x = 67;
			_stallTextName.y = 333;
			_stallTextName.width = 171;
			_stallTextName.height = 22;
			addChild(_stallTextName);
			
			_clearTextfieldBtn = new MCacheAsset4Btn(0,"清空");
			_clearTextfieldBtn.labelField.setTextFormat(new TextFormat("宋体",12,0xFAC951));
			_clearTextfieldBtn.move(207,31);
			addChild(_clearTextfieldBtn);
			
			_dealContentPanel = new MScrollPanel();
			_dealContentPanel.horizontalScrollPolicy = ScrollPolicy.OFF;
			_dealContentPanel.setSize(233,268);
			_dealContentPanel.move(12,55);
			addChild(_dealContentPanel);
			_currentContentHeight = 0;
			
			_clearGoodsBtn = new MCacheAsset1Btn(0,"清空物品");
			_clearGoodsBtn.move(5,366);
			addChild(_clearGoodsBtn);
			
			_okStallBtn = new MCacheAsset1Btn(0,"确定摆摊");
			if(GlobalData.selfPlayer.stallName != "")
			{
				_okStallBtn.visible =false;
			}
			else
			{
				_okStallBtn.visible =true;
			}
			_okStallBtn.move(101,366);
			addChild(_okStallBtn);
			
			_cancelStallBtn = new MCacheAsset1Btn(0,"暂停摆摊");
			if(GlobalData.selfPlayer.stallName != "")
			{
				_cancelStallBtn.visible =true;
			}
			else
			{
				_cancelStallBtn.visible =false;
			}
			_cancelStallBtn.move(101,366);
			addChild(_cancelStallBtn);
			
			_cancelBtn = new MCacheAsset1Btn(0,"取消");
			_cancelBtn.move(176,366);
			addChild(_cancelBtn);
		}
		
		
		public function initalEvents():void
		{
			GlobalData.stallInfo.addEventListener(StallDealPanelEvents.STALL_CONTENT_UPDATE,updateStallContent);
			GlobalData.stallInfo.addEventListener(StallDealPanelEvents.STALL_NAME_UPDATE,updateStallName);
			GlobalData.stallInfo.addEventListener(StallDealPanelEvents.STALL_CLEAR_CONTENT,clearContentHandler);
			
			_clearTextfieldBtn.addEventListener(MouseEvent.CLICK,clearTextfield);
			_clearGoodsBtn.addEventListener(MouseEvent.CLICK,clearGoods);
			_okStallBtn.addEventListener(MouseEvent.CLICK,okStallClickHandler);
			_cancelStallBtn.addEventListener(MouseEvent.CLICK,pauseStallClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		public function removeEvents():void
		{
			GlobalData.stallInfo.removeEventListener(StallDealPanelEvents.STALL_CONTENT_UPDATE,updateStallContent);
			GlobalData.stallInfo.removeEventListener(StallDealPanelEvents.STALL_NAME_UPDATE,updateStallName);
			GlobalData.stallInfo.removeEventListener(StallDealPanelEvents.STALL_CLEAR_CONTENT,clearContentHandler);
			
			_clearTextfieldBtn.removeEventListener(MouseEvent.CLICK,clearTextfield);
			_clearGoodsBtn.removeEventListener(MouseEvent.CLICK,clearGoods);
			_okStallBtn.removeEventListener(MouseEvent.CLICK,okStallClickHandler);
			_cancelStallBtn.removeEventListener(MouseEvent.CLICK,pauseStallClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		//更新交易信息
		public function updateStallContent(e:StallDealPanelEvents):void
		{
//			_dealTextfield.text = GlobalData.stallInfo.stallContent;
			var tmpData:Object = e.data;
			var tmpItemView:DisplayObject;
			if(tmpData is StallMessageItemInfo)
			{
				tmpItemView = new MessageContentItemView(tmpData as StallMessageItemInfo,_dealContentPanel.width - 5);
			}
			else if(tmpData is StallDealItemInfo)
			{
				tmpItemView = new DealContentItemView(tmpData as StallDealItemInfo,_dealContentPanel.width - 5);
			}
			_dealContentPanel.getContainer().addChild(tmpItemView);
			tmpItemView.x = 0;
			tmpItemView.y = _dealContentPanel.getContainer().height;
			_dealContentPanel.getContainer().height += tmpItemView.height;
			_dealContentPanel.update();
		}
		
		public function setData():void
		{
			var tmpItemView:DisplayObject;
			for each(var i:StallMessageItemInfo in GlobalData.stallInfo.messageItemVector)
			{
				tmpItemView = new MessageContentItemView(i,_dealContentPanel.width - 5);
				_dealContentPanel.getContainer().addChild(tmpItemView);
				tmpItemView.x = 0;
				tmpItemView.y = _dealContentPanel.getContainer().height;
				_dealContentPanel.getContainer().height += tmpItemView.height;
				_dealContentPanel.update();
			}
			for each(var j:StallDealItemInfo in GlobalData.stallInfo.dealItemVector)
			{
				tmpItemView = new DealContentItemView(j,_dealContentPanel.width - 5);
				_dealContentPanel.getContainer().addChild(tmpItemView);
				tmpItemView.x = 0;
				tmpItemView.y = _dealContentPanel.getContainer().height;
				_dealContentPanel.getContainer().height += tmpItemView.height;
				_dealContentPanel.update();
			}
		}
		
		//更新摆摊名字
		public function updateStallName(e:StallDealPanelEvents):void
		{
			_stallTextName.text = GlobalData.stallInfo.stallName;
		}
		
		
//		public function loadCompleteHandler(e:StallGoodsPanelEvents):void
//		{
//			_dealTextfield.text = GlobalData.stallInfo.stallContent;
//			_stallTextName.text = GlobalData.stallInfo.stallName;
//		}
		
		public function okStallClickHandler(e:MouseEvent):void
		{
			var saleCount:int = GlobalData.clientBagInfo.stallBegSaleVector.length;
			var buyCount:int = GlobalData.stallInfo.begBuyInfoVector.length;
			if(saleCount == 0&& buyCount == 0)
			{
				MAlert.show("请选择你要出售或者收购的物品","提示");
			}
			else
			{
				_stallDealMediator.sendStallStart(_stallTextName.text.toString());				
			}
		}
		
		public function pauseStallClickHandler(e:MouseEvent):void
		{
			_stallDealMediator.sendStallPause();
		}
		
		public function cancelClickHandler(e:MouseEvent):void
		{
			_stallDealMediator.stallModule.stallPanel.dispose();
		}
		
		public function clearGoods(e:MouseEvent):void
		{
			if(GlobalData.selfPlayer.stallName == "")
			{
				var saleCount:int = GlobalData.clientBagInfo.stallBegSaleVector.length;
				var buyCount:int = GlobalData.stallInfo.begBuyInfoVector.length;
				if(saleCount == 0&& buyCount == 0){}
				else
				{
					GlobalData.stallInfo.clearAllVector();
				}
			}
			else
			{
				MAlert.show("清空物品，请先取消摆摊!","警告");
			}
		}
		
		public function clearTextfield(e:MouseEvent):void
		{
			GlobalData.stallInfo.clearContentVector();
		}
		
		private function clearContentHandler(e:StallDealPanelEvents):void
		{
			for(var i:int = _dealContentPanel.getContainer().numChildren - 1;i >= 0;i--)
			{
				_dealContentPanel.getContainer().removeChildAt(i);
			}
			_dealContentPanel.getContainer().height = 0;
			_dealContentPanel.update();
		}
		
		
		
		public function stallSuccess():void
		{
			addChild(new MAlert("摆摊成功","提示"));
			GlobalData.selfPlayer.updateStallName(_stallTextName.text);
			GlobalData.clientBagInfo.unLockItemInfoFromStallBegSaleVector();
			_okStallBtn.visible = false;
			_cancelStallBtn.visible = true;			
			
		}
		
		public function pasueStallSuccess():void
		{
			addChild(new MAlert("暂停摆摊成功","提示"));
			GlobalData.selfPlayer.updateStallName("");
			GlobalData.clientBagInfo.lockItemInfoToStallBegSaleVector();
			_okStallBtn.visible = true;
			_cancelStallBtn.visible = false;	
		}
			
		public function cancelStallHandler(e:MouseEvent):void
		{
			
		}
		 public function dispose():void
		{
			 removeEvents();
			 _stallDealMediator = null;
			  if(_clearTextfieldBtn)
			  {
				  _clearTextfieldBtn.dispose();
				  _clearTextfieldBtn = null;
			  }
			  if(_clearGoodsBtn)
			  {
				  _clearGoodsBtn.dispose();  
				  _clearGoodsBtn = null;
			  }
			  if(_okStallBtn)
			  {
				  _okStallBtn.dispose();
				  _okStallBtn = null;
			  }
			  if(_cancelStallBtn)
			  {
				  _cancelStallBtn.dispose();
				  _cancelStallBtn = null;
			  }
			  if(_cancelBtn)
			  {
				  _cancelBtn.dispose();
				  _cancelBtn = null;
			  }
			  _stallTextName = null;
			  if(_dealContentPanel)
			  {
				  _dealContentPanel.dispose();
				  _dealContentPanel = null;
			  }
			  if(parent)parent.removeChild(this);
		}
	}
}