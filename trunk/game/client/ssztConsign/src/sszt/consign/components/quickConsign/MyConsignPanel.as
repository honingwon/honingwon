package sszt.consign.components.quickConsign
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.consign.components.itemView.MyItemView;
	import sszt.consign.components.itemView.SearchItemView;
	import sszt.consign.data.ConsignInfo;
	import sszt.consign.data.Item.MyItemInfo;
	import sszt.consign.data.Item.SearchItemInfo;
	import sszt.consign.events.ConsignEvent;
	import sszt.consign.mediator.ConsignMediator;
	import sszt.consign.socketHandlers.ConsignDeleteConsignHandler;
	import sszt.consign.socketHandlers.ConsignQuerySelfHandler;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CellEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.page.PageEvent;
	import sszt.ui.page.PageView;
	
	import ssztui.consign.IconHelpTipAsset;
	import ssztui.ui.SplitRowLine1Asset;
	

	public class MyConsignPanel extends Sprite implements IConsignPanelView
	{
		private var _mediator:ConsignMediator;
		private var _mTile:MTile;
		private var _pageView:PageView;
//		private var _resultItemViewList:Vector.<MyItemView> = new Vector.<MyItemView>();
		private var _resultItemViewList:Array = [];
		private var _currentItemView:MyItemView = null;
		private var _bg:IMovieWrapper;
		private var _tip:Sprite;
		
		public function MyConsignPanel(argMediator:ConsignMediator)
		{
			_mediator = argMediator;
			initialView();
		}
		
		private function initialView():void
		{
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(0,0,231,274)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,7,217,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,65,217,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,123,217,56)),
				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(7,181,217,56)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,16,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,74,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,132,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,190,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(198,241,24,24),new Bitmap(new IconHelpTipAsset())),
			]);
			
			addChild(_bg as DisplayObject);
			
//			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(10,217,229,40),new MAssetLabel(LanguageManager.getWord("ssztl.consign.reStorePrompt"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
			
			_tip = new Sprite();
			_tip.graphics.beginFill(0,0);
			_tip.graphics.drawRect(198,241,24,24);
			_tip.graphics.endFill();
			addChild(_tip);
			
			_mTile = new MTile(217,56,1);
			_mTile.itemGapH = _mTile.itemGapW = 2;
			_mTile.move(7,7);
			_mTile.setSize(217,230);
			addChild(_mTile);
			
			_pageView = new PageView(4,false,95);
			_pageView.move(68,242);
			addChild(_pageView);
			
			addEvents();
			queryByPage();
		}
		
		private function addEvents():void
		{
			_pageView.addEventListener(PageEvent.PAGE_CHANGE,queryMyConsign);
			consignInfo.addEventListener(ConsignEvent.MYCONSIGN_PAGE_UPDATE,pageUpdateHandler);
			consignInfo.addEventListener(ConsignEvent.MYLIST_UPDATE,searchListUpdate);
			
			_tip.addEventListener(MouseEvent.MOUSE_OVER,helpOverHandler);
			_tip.addEventListener(MouseEvent.MOUSE_OUT,helpOutHandler);
		}
		
		private function removeEvents():void
		{
			_pageView.removeEventListener(PageEvent.PAGE_CHANGE,queryMyConsign);
			consignInfo.removeEventListener(ConsignEvent.MYCONSIGN_PAGE_UPDATE,pageUpdateHandler);
			consignInfo.removeEventListener(ConsignEvent.MYLIST_UPDATE,searchListUpdate);
			
			_tip.removeEventListener(MouseEvent.MOUSE_OVER,helpOverHandler);
			_tip.removeEventListener(MouseEvent.MOUSE_OUT,helpOutHandler);
		}
		
		private function helpOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.consign.reStorePrompt"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function helpOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		//更新页码
		private function pageUpdateHandler(e:ConsignEvent):void
		{
			_pageView.totalRecord = consignInfo.myConsignTotalRecords;
			_pageView.setPage(consignInfo.myConsignCurPage,false);
		}
		
		//更新搜索
		private function searchListUpdate(e:ConsignEvent):void
		{
			var listId:Number = e.data as Number;
			var myItemInfo:MyItemInfo = consignInfo.getMyItemInfoFromMyList(listId);
			/**删除**/
			if(!myItemInfo)
			{
				for each(var i:MyItemView in _resultItemViewList)
				{
					if(i.myItemInfo.listId == listId)
					{
						_currentItemView = null;
						_resultItemViewList.splice(_resultItemViewList.indexOf(i),1);
						i.removeEventListener(MouseEvent.CLICK, itemViewSelectHandler);
						_mTile.removeItem(i);
						i.dispose();
						i = null;
						break;
					}
				}
			}/**插入**/
			else
			{
				var myItemView:MyItemView = new MyItemView();
				myItemView.addEventListener(MouseEvent.CLICK,itemViewSelectHandler);
				myItemView.myItemInfo = myItemInfo;
				_resultItemViewList.push(myItemView);
				_mTile.appendItem(myItemView);
			}
		}
		
		
		public function itemViewSelectHandler(e:MouseEvent):void
		{
			if(_currentItemView == null)
			{
				_currentItemView = e.currentTarget as MyItemView;
				_currentItemView.select = true;
			}
			else
			{
				_currentItemView.select = false;
				_currentItemView = e.currentTarget as MyItemView;
				_currentItemView.select = true;
			}
			//取回寄售物品
			if(e.target == _currentItemView.cancelBtn || e.target == _currentItemView.reTakeBtn)
			{
				cancelConsignHandler(e);
			}
			//继续寄售
			else if(e.target == _currentItemView.continueBtn)
			{
				var priceType:int = _currentItemView.myItemInfo.priceType;
				var consignPrice:int = _currentItemView.myItemInfo.consignPrice;
				var consignTime:int = _currentItemView.myItemInfo.consignTime;
				var base:int;
//				switch(_currentItemView.myItemInfo.priceType)
//				{
//					case 2:;                          //铜币
//					case 3:;
//				}
				
				switch(priceType)
				{
					case 2 : base = Math.ceil(consignPrice/20); break;
					case 3 : base = (consignPrice * 15);
				}
				switch(consignTime)
				{
					case 8 : base *= 1; break;
					case 24 : base *= 2; break;
					case 48 : base *= 3; break;
				}
				
				if(base > GlobalData.selfPlayer.userMoney.copper)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.consign.reConsignFail"));
				}
				else
				{
					_mediator.sendContinueConsign( _currentItemView.myItemInfo.listId);
				}
				
//				var myItemInfo:MyItemInfo = _currentItemView.myItemInfo;
				
			}
		}
		//取回寄售
		private function cancelConsignHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ConsignDeleteConsignHandler.sendDelete(_currentItemView.myItemInfo.listId, _pageView.currentPage);
		}
		//再售
		private function continueConsignHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.sendContinueConsign(_currentItemView.myItemInfo.listId);
		}	
		
		public function queryMyConsign(e:PageEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ConsignQuerySelfHandler.sendQuery(_pageView.currentPage);
		}
		
		public function queryByPage():void
		{
			ConsignQuerySelfHandler.sendQuery(_pageView.currentPage);
		}
		
		private function get consignInfo():ConsignInfo
		{
			return _mediator.module.consignInfo;
		}
		
		
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		

		public function show():void
		{
			queryByPage();
		}

		
		public function move(argX:int, argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_mTile)
			{
				_mTile.dispose();
				_mTile = null;
			}
			if(_pageView)
			{
				_pageView.dispose();
				_pageView = null;
			}
			if(_resultItemViewList)
			{
				for each(var itemView:MyItemView in _resultItemViewList)
				{
					itemView.dispose();
					itemView = null;
				}
				_resultItemViewList = null;
			}
			if(_tip && _tip.parent)
			{
				_tip.parent.removeChild(_tip);
				_tip = null;
			}
			
			if(parent)
			{
				parent.removeChild(this);
			}
			
			_currentItemView = null;
			_mediator = null;
			
		}
		
	}
}