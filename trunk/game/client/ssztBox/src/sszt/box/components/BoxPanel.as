package sszt.box.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.box.components.views.IBoxView;
	import sszt.box.components.views.QiShiView;
	import sszt.box.data.BoxStoreInfo;
	import sszt.box.data.OpenBoxCostUtil;
	import sszt.box.events.GainInfoEvent;
	import sszt.box.events.ShenMoStoreEvent;
	import sszt.box.mediators.BoxMediator;
	import sszt.constData.CategoryType;
	import sszt.constData.SourceClearType;
	import sszt.core.caches.MoneyIconCaches;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.box.BoxType;
	import sszt.core.data.chat.ChatInfo;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToBoxData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.player.SelfPlayerInfoUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.box.OpenBoxSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.events.BoxMessageEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.box.BoxTitleAsset;
	import ssztui.box.TaobaoBtnAsset1;
	import ssztui.box.TaobaoBtnAsset2;
	import ssztui.box.TaobaoBtnAsset3;
	import ssztui.box.listTitleAsset1;
	import ssztui.box.listTitleAsset2;
	
	public class BoxPanel extends MPanel
	{
		private var _mediator:BoxMediator;
		
		private var _bgBtmp:Bitmap;
		private var _bg:IMovieWrapper;
		private var _bgCell:IMovieWrapper;
		private var _bg1:Bitmap;
		private var _bg2:Bitmap;
		
		private var _contentBtmp:Bitmap;
		
		/**
		 * 淘宝仓库 
		 */
		private var _storeBtn:MCacheAssetBtn1;
		/**
		 * 立即充值 
		 */		
		private var _chargeBtn:MCacheAssetBtn1;
		
		private var _labels:Array;
		private var _poses:Array;
		private var _btns:Array;
//		private var _classes:Array;
//		private var _panels:Array;
		private var _boxView:QiShiView;
		private var _curType:int = -1;
		
		private var _oneBtn:MAssetButton1;
		private var _tenBtn:MAssetButton1;
		private var _fiftyBtn:MAssetButton1;
		
		private var _leftYuanBaoField:TextField;
		private var _storeField:TextField;
		
		private var _gainItemMsgArea:MTextArea;

		private var _listView:MScrollPanel;
		private var _msgViewList:Array;
		
		private var _openEffect:BaseLoadEffect;
		private var _effectComplete:Boolean;
		private var _resultBack:Boolean;
		private var _tmpData:ToBoxData;
		private var _boxKeyIdList:Array;
		private var _bottomTile:MTile;
		
		
		public function BoxPanel(mediator:BoxMediator)
		{
			_mediator = mediator;
			_boxKeyIdList = [CategoryType.QISHI_KEY,CategoryType.ZHENSHI_KEY];
//			_msgViewList = [];
			super(new MCacheTitle1("",new Bitmap(new BoxTitleAsset())), true, -1, true, true);
			
			initEvents();
			
			if(_mediator.boxModule.toBoxData.tabIndex != 0)
			{
				setType(_mediator.boxModule.toBoxData.tabIndex);
			}
			else
			{
				setType(0);
			}
//			setType(BoxType.ZHENSHI);
			
			
			
//			_mediator.showOverView();
			/**
			 * 暂时屏蔽
			 */
//			(_btns[1] as MCacheTab1Btn).enabled = false;
//			(_btns[2] as MCacheTab1Btn).enabled = false;
			
//			_mediator.showOverView();
//			_mediator.showXunYuan();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(661,420);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(9,25,643,388)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,29,452,111)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,139,452,270)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(467,29,181,380)),
				new BackgroundInfo(BackgroundType.BORDER_13,new Rectangle(16,32,446,105)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(80,37,80,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(289,37,55,22)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(469,31,177,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(469,183,177,26)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(525,36,64,15),new Bitmap(new listTitleAsset1() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(525,187,63,15),new Bitmap(new listTitleAsset2() as BitmapData)),
			]);
			addContent(_bg as DisplayObject);
			
			_bg1 = new Bitmap();
			_bg1.x = 14;
			_bg1.y = 140;
			addContent(_bg1);
			_bg2 = new Bitmap();
			_bg2.x = 64;
			_bg2.y = 62;
			addContent(_bg2);
			
			_bgCell = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(88,152,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(134,152,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(180,152,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(258,152,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(304,152,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(350,152,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(42,197,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(396,197,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(42,248,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(396,248,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(88,293,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(134,293,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(180,293,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(258,293,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(304,293,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(350,293,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(73,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(115,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(157,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(199,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(241,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(283,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(325,91,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(367,91,38,38),new Bitmap(CellCaches.getCellBg())),
				
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(107,216,50,50),new Bitmap(CellCaches.getCellBigBg())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(325,216,50,50),new Bitmap(CellCaches.getCellBigBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(84,39,18,18),new Bitmap(MoneyIconCaches.yuanBaoAsset)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,40,65,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.leftYuanBao"),MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(229,40,65,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.taoBaoStore")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(165,68,160,16),new MAssetLabel(LanguageManager.getWord("ssztl.box.taoBaoTip1"),MAssetLabel.LABEL_TYPE_TITLE2)),
				]);
			addContent(_bgCell as DisplayObject);
			
			var contentField:TextField = new TextField();
			contentField.textColor = 0xCC8233;
			contentField.x = 29;
			contentField.y = 336;
			contentField.width = 453;
			contentField.height = 40;
			contentField.wordWrap = true;
			contentField.multiline = true;
			contentField.mouseEnabled = contentField.mouseWheelEnabled = false;
			contentField.text = LanguageManager.getWord("ssztl.box.taoBaoContent");
			//addContent(contentField);
			
			_oneBtn = new MAssetButton1(new TaobaoBtnAsset1() as MovieClip);
			_oneBtn.move(64,349);
			addContent(_oneBtn);
			
			_tenBtn = new MAssetButton1(new TaobaoBtnAsset2() as MovieClip);
			_tenBtn.move(193,349);
			addContent(_tenBtn);
			
			_fiftyBtn = new MAssetButton1(new TaobaoBtnAsset3() as MovieClip);
			_fiftyBtn.move(323,349);
			addContent(_fiftyBtn);
			
			_labels = [LanguageManager.getWord("ssztl.box.qiShi"),
				LanguageManager.getWord("ssztl.box.zhenShi") ];
			var posX:int = 15;
			_btns = [];
			for(var i:int=0; i<_labels.length; i++)
			{
				var btn:MCacheTabBtn1 = new MCacheTabBtn1(0,2,_labels[i]);
				btn.move(posX,0);
				addContent(btn);
				_btns.push(btn);
				posX += 69;
			}
			
			_boxView = new QiShiView();
			_boxView.move(0,0);
			addContent(_boxView);
			
			_storeBtn = new MCacheAssetBtn1(1,2,LanguageManager.getWord("ssztl.common.taoBaoStore"));
			_storeBtn.move(394,37);
			addContent(_storeBtn);
			
			_chargeBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.charge"));
			_chargeBtn.move(161,37);
			addContent(_chargeBtn);
			
			var tf:TextFormat = new TextFormat("SimSun",12,0xfffccc);
			_leftYuanBaoField = new TextField();
			_leftYuanBaoField.defaultTextFormat = tf;
			_leftYuanBaoField.width = 60;
			_leftYuanBaoField.height = 18;
			_leftYuanBaoField.x = 104;
			_leftYuanBaoField.y = 40;
			_leftYuanBaoField.selectable = false;
			_leftYuanBaoField.text = GlobalData.selfPlayer.userMoney.yuanBao.toString();
			addContent(_leftYuanBaoField);
			
			_storeField = new TextField();
			_storeField.defaultTextFormat = tf;
			_storeField.width = 60;
			_storeField.height = 18;
			_storeField.x = 294;
			_storeField.y = 40;
			_storeField.selectable = false;
			_storeField.text = _mediator.boxModule.shenmoStoreInfo.getItemsCount() + "/" + BoxStoreInfo.MAX_SIZE;
			addContent(_storeField);
			
			_gainItemMsgArea = new MTextArea();
			_gainItemMsgArea.x = 471;
			_gainItemMsgArea.y = 58;
			_gainItemMsgArea.width = 183;
			_gainItemMsgArea.height = 123;
			_gainItemMsgArea.textField.mouseEnabled = _gainItemMsgArea.textField.mouseWheelEnabled = false;
			_gainItemMsgArea.htmlText = getGainItemStr(_mediator.boxModule.shenmoStoreInfo.gainItemList);
			_gainItemMsgArea.verticalScrollPolicy = ScrollPolicy.AUTO;
			addContent(_gainItemMsgArea);
			
//			_bgBtmp = new Bitmap(new QiShiBgAsset());
//			_bgBtmp.x = 7;
//			_bgBtmp.y = 76;
//			addContent(_bgBtmp);
//			addContentAt(_bgBtmp,0);
			
			_listView = new MScrollPanel();
			_listView.mouseEnabled = _listView.getContainer().mouseEnabled = false;
			_listView.move(471,210);
			_listView.setSize(175,196);
			_listView.horizontalScrollPolicy = ScrollPolicy.OFF;
			_listView.verticalScrollPolicy = ScrollPolicy.AUTO;
			addContent(_listView);
			_listView.update();
			
			_bottomTile = new MTile(38,38,8);
			_bottomTile.itemGapH = 0;
			_bottomTile.itemGapW = 4;
			_bottomTile.setSize(428,38);
			_bottomTile.move(73,91);
			_bottomTile.verticalScrollPolicy = _bottomTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			addContent(_bottomTile);
			
			if(GlobalData.boxMsgInfo.flag)
			{
				initListView();
			}
			else
			{
				GlobalData.boxMsgInfo.addEventListener(BoxMessageEvent.BOX_MSG_LOADED,msgLoadedHandler);
			}
		}
		
		public function assetsCompleteHandler():void
		{
			_bg1.bitmapData = AssetUtil.getAsset("ssztui.box.BoxBgAsset",BitmapData) as BitmapData;
			_bg2.bitmapData = AssetUtil.getAsset("ssztui.box.ItemBgAsset",BitmapData) as BitmapData;
		}
		
		private function initListView():void
		{
			var msgList:Array = GlobalData.boxMsgInfo.msgList;
			var msgList1:Array = GlobalData.boxMsgInfo.msgList1;
			var richTextField:RichTextField;
			var len:int = msgList.length <= 20 ? msgList.length : 20;
			var currentHeight:int = 0;

			_msgViewList = [];
			for(var i:int=0;i<len;i++)
			{
				richTextField = RichTextUtil.getOpenBoxRichText(msgList[i],170);
				richTextField.y = currentHeight;
				_listView.getContainer().addChild(richTextField);
				currentHeight += richTextField.height;
				_msgViewList.push(richTextField);
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
//			_listView.verticalScrollPosition = _listView.maxVerticalScrollPosition;
			
			var cell:BaseCell;
			var info:ItemTemplateInfo ;
			var len1:int = msgList1.length > 8 ? 8 : msgList1.length;
			for(var j:int = 0 ; j < len1 ; ++j)
			{
				cell = new BoxTempCell2(null,msgList1[j].nickName);
				cell.info = ItemTemplateList.getTemplate(msgList1[j].id);
				_bottomTile.appendItem(cell);
			}
			
		}
		
		private function initEvents():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAIN_ITEM_UPDATE,gainItemShowHandler);
			
			GlobalData.selfPlayer.userMoney.addEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);
//			GlobalData.boxMsgInfo.addEventListener(BoxMessageEvent.BOX_MSG_LOADED,msgLoadedHandler);
			GlobalData.boxMsgInfo.addEventListener(BoxMessageEvent.BOX_MSG_ADD,msgAddHandler);
			GlobalData.boxMsgInfo.addEventListener(BoxMessageEvent.GAIN_ITEM_LIST_UPDATE,gainItemUpdateHandler);

			_storeBtn.addEventListener(MouseEvent.CLICK, onStoreClickHandler);
			_chargeBtn.addEventListener(MouseEvent.CLICK, onChargeHandler);
			
			for(var i:int=0; i<_btns.length; i++)
			{
				var btn:MCacheTabBtn1 = _btns[i] as MCacheTabBtn1;
				btn.addEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			_oneBtn.addEventListener(MouseEvent.CLICK,openBoxHandler);
			_tenBtn.addEventListener(MouseEvent.CLICK,openBoxHandler);
			_fiftyBtn.addEventListener(MouseEvent.CLICK,openBoxHandler);
			
			_mediator.boxModule.shenmoStoreInfo.addEventListener(ShenMoStoreEvent.ADD_ITEM,storeTotalChangeHandler);
			_mediator.boxModule.shenmoStoreInfo.addEventListener(ShenMoStoreEvent.REMOVE_ITEM,storeTotalChangeHandler);
		}
		
		private function removeEvents():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAIN_ITEM_UPDATE,gainItemShowHandler);
			
			GlobalData.selfPlayer.userMoney.removeEventListener(SelfPlayerInfoUpdateEvent.MONEYUPDATE,moneyUpdateHandler);	
//			GlobalData.boxMsgInfo.removeEventListener(BoxMessageEvent.BOX_MSG_LOADED,msgLoadedHandler);
			GlobalData.boxMsgInfo.removeEventListener(BoxMessageEvent.BOX_MSG_ADD,msgAddHandler);	
			GlobalData.boxMsgInfo.removeEventListener(BoxMessageEvent.GAIN_ITEM_LIST_UPDATE,gainItemUpdateHandler);

			_storeBtn.removeEventListener(MouseEvent.CLICK, onStoreClickHandler);
			_chargeBtn.removeEventListener(MouseEvent.CLICK, onChargeHandler);
			
			for(var i:int=0; i<_btns.length; i++)
			{
				var btn:MCacheTabBtn1 = _btns[i] as MCacheTabBtn1;
				btn.removeEventListener(MouseEvent.CLICK, btnClickHandler);
			}
			
			_oneBtn.removeEventListener(MouseEvent.CLICK,openBoxHandler);
			_tenBtn.removeEventListener(MouseEvent.CLICK,openBoxHandler);
			_fiftyBtn.removeEventListener(MouseEvent.CLICK,openBoxHandler);
			
			_mediator.boxModule.shenmoStoreInfo.removeEventListener(ShenMoStoreEvent.ADD_ITEM,storeTotalChangeHandler);
			_mediator.boxModule.shenmoStoreInfo.removeEventListener(ShenMoStoreEvent.REMOVE_ITEM,storeTotalChangeHandler);
		}
		
		//玩家元宝数量
		private function moneyUpdateHandler(evt:SelfPlayerInfoUpdateEvent):void
		{
			_leftYuanBaoField.text = GlobalData.selfPlayer.userMoney.yuanBao.toString();
		}
		
		private function msgLoadedHandler(evt:BoxMessageEvent):void
		{
			initListView();
			GlobalData.boxMsgInfo.removeEventListener(BoxMessageEvent.BOX_MSG_LOADED,msgLoadedHandler);
		}
		
		private function msgAddHandler(evt:BoxMessageEvent):void
		{
			if(_msgViewList == null)
			{
				return;
			}
			var richTextField:RichTextField = RichTextUtil.getOpenBoxRichText(evt.data as String,170);
			_listView.getContainer().addChild(richTextField);
			_msgViewList.unshift(richTextField);
			
			while(_msgViewList.length > 20)
			{
				richTextField = _msgViewList.pop();
				if(_listView.getContainer().contains(richTextField))
				{
					_listView.getContainer().removeChild(richTextField);
					richTextField.dispose();
				}
			}
			
			
			
			var currentHeight:int = 0;
			for(var i:int = 0; i < _msgViewList.length; i++)
			{
				_msgViewList[i].y = currentHeight;
				currentHeight += _msgViewList[i].height;
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
//			_listView.verticalScrollPosition = _listView.maxVerticalScrollPosition;
			
			
			_bottomTile.disposeItems();
			var msgList1:Array = GlobalData.boxMsgInfo.msgList1;
			var cell:BaseCell;
			var info:ItemTemplateInfo ;
			var len1:int = msgList1.length > 8 ? 8 : msgList1.length;
			for(var j:int = 0 ; j < len1 ; ++j)
			{
				cell = new BoxTempCell2(null,msgList1[j].nickName);
				cell.info = ItemTemplateList.getTemplate(msgList1[j].id);
				_bottomTile.appendItem(cell);
			}
		}
		
		//神魔仓库物品数量更新
		private function storeTotalChangeHandler(evt:ShenMoStoreEvent):void
		{
			_storeField.text = _mediator.boxModule.shenmoStoreInfo.getItemsCount() + "/" + BoxStoreInfo.MAX_SIZE;
		}
		
		private function gainItemShowHandler(evt:CommonModuleEvent):void
		{
			_tmpData = evt.data as ToBoxData;
			_resultBack = true;
			if(_effectComplete)
			{
				SetModuleUtils.addBox(5,-1,_tmpData.list);
				_tmpData = null;
			}
			
//			if(_openEffect)
//			{
//				_openEffect.stop();
//				if(_openEffect.parent)_openEffect.parent.removeChild(_openEffect);
//			}
		}
		
		
		
		private function gainItemUpdateHandler(evt:BoxMessageEvent):void
		{
			var itemList:Array = evt.data as Array;
			if(itemList.length>0)
			{
				_gainItemMsgArea.htmlText = getGainItemStr(itemList);
			}
		}
		
		private function getGainItemStr(list:Array):String
		{
			var item:ItemInfo;
			var detailStr:String = "";
			for(var i:int=0;i<list.length;i++)
			{
				item = list[i];
				detailStr += "<font color='#"+ CategoryType.getQualityColorString(item.template.quality) +
					"'>[" + item.template.name + "]" + "×" + item.count + "</font>\n";
			}
			return detailStr;
		}
		
		//打开神魔仓库
		private function  onStoreClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_mediator.showStore();
		}
		
		//充值
		private function onChargeHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			JSUtils.gotoFill();
		}
		
		private function btnClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.TAB_BTN);
			
			var index:int = _btns.indexOf(evt.currentTarget as MCacheTabBtn1);
			setType(index + 1);
		}
		
		//点击开箱子
		private function openBoxHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			
			var btn:MAssetButton1 = evt.currentTarget as MAssetButton1;
			if(_mediator.boxModule.shenmoStoreInfo.getItemsCount()>=240)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.box.taoBaoStoreFull"));
				return;
			}
			var times:int =0;
			switch(btn)
			{
				case _oneBtn:
					times = 1;
					break;
				case _tenBtn:
					times = 2;
					break;
				case _fiftyBtn:
					times = 3;
					break;
			}
			
			if(times == 1)
			{
				var count:int = GlobalData.bagInfo.getItemCountById(_boxKeyIdList[_curType-1]);
				if(GlobalData.selfPlayer.userMoney.yuanBao<OpenBoxCostUtil.getCost(3 * (_curType -1) + times) && count==0)
				{
					MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyHandler);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
					return;
				}
			}
			else
			{
				if(GlobalData.selfPlayer.userMoney.yuanBao<OpenBoxCostUtil.getCost(3 * (_curType -1) + times))
				{
					MAlert.show(LanguageManager.getWord("ssztl.common.isGoingCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,buyHandler);
					QuickTips.show(LanguageManager.getWord('ssztl.common.yuanBaoNotEnough'));
					return;
				}
			}
			OpenBoxSocketHandler.sendOpenBox(3 * (_curType -1) + times);
			_effectComplete = false;
			_resultBack = false;
			_tmpData = null;
			if(!_openEffect)
			{
				_openEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.BOX_EFFECT));
				_openEffect.move(230,240);
				
				_openEffect.addEventListener(Event.COMPLETE,effectCompleteHandler);
				_openEffect.play(SourceClearType.TIME,300000);
			}
			if(_openEffect.parent != this)
			{
				addContent(_openEffect);
			}
		}
		
		private function effectCompleteHandler(evt:Event):void
		{
			_effectComplete = true;
			if(_openEffect)
			{
				_openEffect.removeEventListener(Event.COMPLETE,effectCompleteHandler);
				_openEffect.dispose();
				_openEffect = null;
			}
			if(_resultBack && _tmpData)
			{
				SetModuleUtils.addBox(5,-1,_tmpData.list);
				_tmpData = null;
			}
		}
		
		public function buyHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoFill();
			}
		}
		
		public function EnHandler(evt:CloseEvent):void
		{
			
		}
		
		//切卡，更换显示物品
		public function setType(type:int):void
		{
			if(_curType == type)
				return;
			if(_curType >=-1)
			{
				if(_btns[_curType-1])
				{
					_btns[_curType-1].selected = false;
				}
			}
			_curType = type;
			_btns[_curType-1].selected = true;
			
			_boxView.initTile(_curType);
		}
		
		override public function dispose():void
		{
			if(_openEffect)
			{
				_openEffect.removeEventListener(Event.COMPLETE,effectCompleteHandler);
				_openEffect.dispose();
				_openEffect = null;
			}
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bgCell)
			{
				_bgCell.dispose();
				_bgCell = null;
			}
			if(_bg1 && _bg1.bitmapData)
			{
				_bg1.bitmapData.dispose();
				_bg1 = null;
			}
			if(_bg2 && _bg2.bitmapData)
			{
				_bg2.bitmapData.dispose();
				_bg2 = null;
			}
			_labels = null;
			for each(var btn:MCacheTabBtn1 in _btns)
			{
				btn.dispose();
				btn = null;
			}
			_btns = null;
			
			if(_boxView)
			{
				_boxView.dispose();
				_boxView = null;
			}
			if(_oneBtn)
			{
				_oneBtn.dispose();
				_oneBtn = null;
			}
			if(_tenBtn)
			{
				_tenBtn.dispose();
				_tenBtn = null;
			}
			if(_fiftyBtn)
			{
				_fiftyBtn.dispose();
				_fiftyBtn = null;
			}
			if(_gainItemMsgArea)
			{
				_gainItemMsgArea.dispose();
				_gainItemMsgArea = null;
			}
			if(_listView)
			{
				_listView.dispose();
				_listView = null;
			}
			if(_msgViewList)
			{
				for each(var msgView:RichTextField in _msgViewList)
				{
					msgView.dispose();
				}
				msgView = null;
				_msgViewList = null;
			}
			
			if(_bottomTile)
			{
				_bottomTile.dispose();
				_bottomTile = null;
			}
			
			_tmpData = null;
			_mediator = null;
			super.dispose();
		}
	}
}

























