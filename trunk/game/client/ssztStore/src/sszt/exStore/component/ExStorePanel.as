package sszt.exStore.component
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.events.CommonModuleEvent;
	import sszt.exStore.component.secs.CanSiPanel;
	import sszt.exStore.component.secs.ExploitPanel;
	import sszt.exStore.component.secs.IExStorePanel;
	import sszt.exStore.component.secs.MoonCakePanel;
	import sszt.exStore.component.secs.ShenMuPanel;
	import sszt.exStore.mediator.ExStoreMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;

	
	public class ExStorePanel extends MPanel 
	{
		private var _mediator:ExStoreMediator;
		private var _shopType:int;
		private var _goodType:int = 0;
		private var _currentPage:int = 0;
		private var _tabPanels:Array;
//		private var _pageView:PageView;
		
		private var _bg:IMovieWrapper;
		private var _assetsComplete:Boolean;
		private var _labels:Array;
		private var _btns:Array;
		private var _classes:Array;
		private var _panels:Array;
		private var _currentIndex:int = -1;
		private var _index:int = 0;
		/**
		 * t_shop_template模板表shopid值 
		 */		
		private var _shopIdArray:Array = [ShopID.SM,ShopID.CS,ShopID.GX,ShopID.PET_EQUIP,ShopID.MOONCAKE];
		/**
		 * 当前拥有999功勋(神木、蚕丝) 
		 */
		private var _moneyLable:MAssetLabel;
		
		public function ExStorePanel(mediator:ExStoreMediator,data:ToStoreData)
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.ExchangeShopAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.ExchangeShopAsset") as Class)());
			}
			super(new MCacheTitle1("",title), true, -1,true,false,GlobalAPI.layerManager.getTopPanelRec());
			
			_assetsComplete = false;
			_mediator = mediator;
			_shopType = data.type;
//			_goodType = data.tabIndex;
			
//			GetDuplicateShopSaleNumSocketHandler.sendDiscount(_shopType);
			initialTab(data.tabIndex);
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(397,466);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,25,381,433)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(12,29,373,394)),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(82,428,105,22)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(24,431,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.common.currentOwn"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT))
			]);
			addContent(_bg as DisplayObject);
			
			_moneyLable = new MAssetLabel(String(GlobalData.selfPlayer.userMoney.yuanBao),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_moneyLable.textColor = 0x00ccff;
			_moneyLable.move(88,431);
			addContent(_moneyLable);
		}
		
		private function initialTab(selectIndex:int):void
		{
			var endTime:int = (OpenActivityTemplateList.activityTypeRecArray1[0] as OpenActivityTemplateListInfo).end_time;
			var t:int = endTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000  < 0  ? 0:endTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000 ;
			if(t<=0)
			{
				_labels = [LanguageManager.getWord("ssztl.common.storeShenMu"),
					LanguageManager.getWord("ssztl.common.storeCansi"),
					LanguageManager.getWord("ssztl.common.pvpExploit"),
					'宠物'
				];		
			}
			else
			{
				_labels = [LanguageManager.getWord("ssztl.common.storeShenMu"),
					LanguageManager.getWord("ssztl.common.storeCansi"),
					LanguageManager.getWord("ssztl.common.pvpExploit"),
					'宠物',
					LanguageManager.getWord("ssztl.common.guoqing")
				];		
			}
			
			_btns = [];
			
			for(var i:int = 0; i < _labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(15+i*69,0);
				addContent(btn);
				_btns.push(btn);
				btn.addEventListener(MouseEvent.CLICK,btnSelectedHandler);
			}
			
			_classes = [ShenMuPanel,CanSiPanel,ExploitPanel,ExploitPanel,MoonCakePanel];
			if(selectIndex >= _classes.length || selectIndex < 0)
				selectIndex = 0;
			_panels = new Array();
			setIndex(selectIndex);
		}
		
		public function setIndex(index:int):void
		{
			showShopType();
			if(_currentIndex == index)return;
			if(_currentIndex > -1)
			{
				if(_panels[_currentIndex])
				{
					_panels[_currentIndex].hide();
				}
				_btns[_currentIndex].selected = false;
			}
			_currentIndex = index;
			_btns[_currentIndex].selected = true;
			if(_panels[_currentIndex] == null)
			{
				_panels[_currentIndex] = new _classes[_currentIndex](_shopType,_mediator);
				_panels[_currentIndex].move(12,29);
				if(_assetsComplete)
				{
					(_panels[_currentIndex] as IExStorePanel).assetsCompleteHandler();
				}
			}
			addContent(_panels[_currentIndex] as DisplayObject);
			_panels[_currentIndex].show();
		}
		
		public function setShopType(shopType:int):void
		{
			_shopType = shopType;
		}
		
		public function assetsCompleteHandler():void
		{
			_assetsComplete = true;
			for(var i:int = 0; i < _tabPanels.length; i++)
			{
				if(_tabPanels[i] != null)
					(_tabPanels[i] as IExStorePanel).assetsCompleteHandler();
			}
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_EXPLOIT,updateExStoreExploit);
		}
		
		private function removeEvent():void
		{
			for(var i:int =0;i<_btns.length;i++)
			{
				_btns[i].removeEventListener(MouseEvent.CLICK,btnSelectedHandler);
			}
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,sizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_EXPLOIT,updateExStoreExploit);
		}
		
		
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - width,parent.stage.stageHeight - height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		
		private function sizeChangeHandler(evt:CommonModuleEvent):void
		{
			move(Math.round((CommonConfig.GAME_WIDTH - 466)/2),Math.round((CommonConfig.GAME_HEIGHT - 460)/2));
		}
		
		private function btnSelectedHandler(e:MouseEvent):void
		{
			var index:int = _btns.indexOf(e.currentTarget as MCacheTabBtn1);
			_shopType = _shopIdArray[index]
			setIndex(index);
		}
		
		private function updateExStoreExploit(evt:CommonModuleEvent):void
		{
			showShopType();
		}
		
		
		public function showShopType():void
		{
			switch(_shopType)
			{
				case 4:		//神木碎片
					_moneyLable.setHtmlValue(LanguageManager.getWord("ssztl.role.exchangeLable1") + "×" + GlobalData.bagInfo.getItemCountByItemplateId(203019).toString());
					break;
				case 5:		//蚕丝碎片
					_moneyLable.setHtmlValue(LanguageManager.getWord("ssztl.role.exchangeLable2") + "×" +  GlobalData.bagInfo.getItemCountByItemplateId(203016).toString());
					break;
				case 8:		
				case 6:		//功勋
					_moneyLable.setHtmlValue("<font color='#ff9900'>" + GlobalData.pvpInfo.exploit + LanguageManager.getWord("ssztl.role.exchangeLable3") + "</font>");
					break;
				case 7:		//月饼
					_moneyLable.setHtmlValue(LanguageManager.getWord("ssztl.common.moonCake") + "×" +  GlobalData.bagInfo.getItemCountByItemplateId(300000).toString());
					break;
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_btns)
			{
				for(var i:int =0;i<_btns.length;i++)
				{
					_btns[i].dispose();
					_btns[i] = null;
				}
				_btns = null;
			}
			if(_tabPanels)
			{
				for(var j:int=0;j<_tabPanels.length;j++)
				{
					if(_tabPanels[j])
					{
						_tabPanels[j].dispose();
						_tabPanels[j] = null;
					}
				}
				_tabPanels = null;
			}
			_classes = null;
			_mediator = null;
			dispatchEvent(new Event(Event.CLOSE));
			super.dispose();
		}
	}
}