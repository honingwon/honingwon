package sszt.payTagView.components
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.events.ActivityEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.components.BigCell;
	import sszt.openActivity.components.CountDownDayView;
	import sszt.openActivity.components.ProgressBar2;
	import sszt.openActivity.components.item.ChestItemView;
	import sszt.payTagView.mediator.PayTagViewMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.activity.ActiveBarAsset;
	import ssztui.activity.ActiveTrackrAsset;
	import ssztui.openServer.BtnPayAsset;
	import ssztui.openServer.ItemOverAsset;
	import ssztui.openServer.PayTitleAsset;
	import ssztui.openServer.ProgressIntervalAsset;
	import ssztui.openServer.TitleAsset1;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	/**
	 * 累积充值  
	 * @author chendong
	 * 
	 */	
	public class PayTagViewPanel extends MPanel implements ITick
	{
		
		private var _mediator:PayTagViewMediator;
		private var _bg:IMovieWrapper;
		private var _bg2:IMovieWrapper;
		private var _bgMap:Bitmap;
		private var _barInterval:Bitmap;
		private var _progress:ProgressBar2;
		/**
		 * 活动时间
		 */		
//		private var _actTime:MAssetLabel;
		/**
		 * 活动内容
		 */		
		private var _actCont:MAssetLabel;
		/**
		 * 累计值
		 */		
		private var _myPayTxt:MAssetLabel;
		/**
		 * 操作按钮 
		 */		
		private var _btnPay:MAssetButton1;
		
		
		private var _type:int = 2;//2:"充值礼包"，3："消费礼包",4："冲级礼包"
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		private var _cellTile:MTile;
		
		private var _currentIndex:int = -1;
		private var _selectedBorder:Bitmap;
		private var _selectedTag:MAssetLabel;
		
		/**
		 * 倒计时 
		 * 天-时-分-秒
		 */
		private var _countDown:CountDownDayView;
		
		public function PayTagViewPanel(mediator:PayTagViewMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new PayTitleAsset())),true,-1,true,true);
			_mediator = mediator;
			initEvent();
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(598,377);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,582,367)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,574,359)),
			]);
			addContent(_bg as DisplayObject);
			
			_bgMap = new Bitmap();
			_bgMap.x = 14;
			_bgMap.y = 8;
			addContent(_bgMap);
			
			_bg2 = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(181,15,236,36),new Bitmap(new TitleAsset1())),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(66,157,466,20),new ActiveTrackrAsset()),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,67,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime")+"：",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,93,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityDescription")+"：",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
			addContent(_bg2 as DisplayObject);
			
//			_actTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
//			_actTime.move(128,65);
//			addContent(_actTime);
			
			_countDown = new CountDownDayView();
			_countDown.setLabelType(new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),12,0x00ff00));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(200,18);
			_countDown.move(116,62);
			addContent(_countDown);
			_countDown.visible = false;
			
			_actCont = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_actCont.wordWrap = true;
			_actCont.textColor = 0xf1c580;
//			_actCont.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),12,0xf1c580,null,null,null,null,null,null,null,null,null,4)]);
			_actCont.setSize(340,50);
			_actCont.move(52,62);
			addContent(_actCont);
			
			_myPayTxt = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_myPayTxt.move(299,114);
			addContent(_myPayTxt);
			
			_selectedTag = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_selectedTag.move(305,267);
			addContent(_selectedTag);
			
			_btnPay = new MAssetButton1(new BtnPayAsset() as MovieClip);
			_btnPay.move(437,65);
			addContent(_btnPay);
			
			_progress = new ProgressBar2(_type,new ActiveBarAsset() as MovieClip,1,1,462,15,false,false);
			_progress.move(68,159);
//			addContent(_progress);
			
			_barInterval = new Bitmap(new ProgressIntervalAsset());
			_barInterval.x = 144;
			_barInterval.y = 159;
//			addContent(_barInterval);
			
//			_neddNumList = [];
//			_needNumTile = new MTile(63,112,7);
//			_needNumTile.setSize(378,112);
//			_needNumTile.move(43,236);
//			_needNumTile.itemGapW = 0;
//			_needNumTile.horizontalScrollPolicy = _needNumTile.verticalScrollPolicy = ScrollPolicy.OFF;
//			addContent(_needNumTile);
			
			_itemList = [];
			_itemTile = new MTile(85,117,7);
			_itemTile.setSize(520,117);
			_itemTile.move(40,146);
			_itemTile.itemGapW = 2;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_itemTile);
			
			_cellTile = new MTile(50,50,7);
			_cellTile.setSize(364,50);
			_cellTile.move(40,291);
			_cellTile.itemGapW = 2;
			_cellTile.horizontalScrollPolicy = _cellTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_cellTile);
			
			_selectedBorder = new Bitmap(new ItemOverAsset());
			_selectedBorder.x = 34;
			_selectedBorder.y = _itemTile.y - 6;
			addContent(_selectedBorder);
			
			setTemplateListData();
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getOpenServerData);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardData);
			_btnPay.addEventListener(MouseEvent.CLICK,toPay);
			_countDown.addEventListener(Event.COMPLETE,completePay);
		}
		
		private function initData():void
		{
			var obj:Object = GlobalData.openActivityInfo.activityDic[_type];
			var opActObj:OpenActivityTemplateListInfo;
			var timeStr:String="";
			if(opAct[0])
			{
				opActObj = opAct[0];
				if(opActObj.time_type == 0)
				{
					timeStr = OpenActivityUtils.remainTimeString(Number(opActObj.end_time-opActObj.start_time));
				}
				else
				{
					timeStr = OpenActivityUtils.remainTimeString(Number(obj.openTime));
//					timeStr = OpenActivityUtils.getEndTime(Number(obj.openTime));
				}
			}
			_countDown.visible = true;
			_countDown.start(Number(obj.openTime));
//			_actTime.setValue(LanguageManager.getWord("ssztl.openActivityactCont.time1"));
			_actCont.setHtmlValue(
				LanguageManager.getWord("ssztl.activity.activityTime")+"：\n" + 
				LanguageManager.getWord("ssztl.scene.activityDescription")+"：" + LanguageManager.getWord("ssztl.openActivityactCont.actCont1")
			);
			_myPayTxt.setHtmlValue(LanguageManager.getWord("ssztl.activity.TagCurrentPay") + "<font size='14' color='#ff9900'>" + obj.totalValue + LanguageManager.getWord("ssztl.common.yuanBao") + "</font>");
			_progress.setValue(OpenActivityUtils.getCurrentMaxValue(_type,int(obj.totalValue)),int(obj.totalValue));
			
			setTemplateListData();
		}
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			clearData();
			opAct = OpenActivityUtils.getActivityArray(_type);
			var opActObj:OpenActivityTemplateListInfo;
			var tn:MAssetLabel;
			var i:int = 0;
			var item:ChestItemView;
			for(i = 0; i<opAct.length; i++)
			{
				opActObj = opAct[i];
				item = new ChestItemView(opActObj);
				item.setType(OpenActivityUtils.getedActivity(opActObj.group_id,opActObj.id,opActObj.need_num));
				_itemTile.appendItem(item);
				_itemList.push(item);
				item.addEventListener(MouseEvent.CLICK,itemClickHanlder);
			}
			setIindex(0);
		}
		private function itemClickHanlder(e:MouseEvent):void
		{
			var index:int = _itemList.indexOf(e.currentTarget);
			setIindex(index);
		}
		private function setIindex(id:int):void
		{
			_currentIndex = id;
			_selectedBorder.x = 34 + 87*_currentIndex;
			clearCell();
			
			//赠送礼包
			var _opActObj:OpenActivityTemplateListInfo = (_itemList[_currentIndex] as ChestItemView).opActObj;
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = _opActObj.item;
			
			var bigItem:ItemTemplateInfo = ItemTemplateList.getTemplate(_opActObj.item);
			//礼包里赠送的物品
			var i:int = 0
			var itemArray:Array = []; //物品模板id数组
			var itemNumArray:Array = []; //物品数量数组
			var scriptArray:Array = bigItem.script.split("|"); 
			var scriptStr:String = "";
			var scriptStrArray:Array = [];
			for(;i<scriptArray.length;i++)
			{
				scriptStrArray = scriptArray[i].toString().split(",");
				if(scriptStrArray.length >= 6)
				{
					itemArray.push(scriptStrArray[2]);
					itemNumArray.push(scriptStrArray[3]);
				}
			}
			i = 0; 
			var item:BigCell;
			for(; i<itemArray.length; i++)
			{
				item = new BigCell();
				itemInfo = new ItemInfo();
				itemInfo.templateId = itemArray[i];
				itemInfo.count = itemNumArray[i];
				item.itemInfo = itemInfo;
				_cellTile.appendItem(item);
			}
			_cellTile.columns = itemArray.length;
			_cellTile.width = itemArray.length*52;
			_cellTile.x = (598 - itemArray.length*52)/2;
			
			_selectedTag.setValue(_opActObj.need_num + LanguageManager.getWord("ssztl.common.yuanBao") + LanguageManager.getWord("ssztl.common.packs"));
		}
		private function getOpenServerData(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardData(evt:ModuleEvent):void
		{
			var opActObj:OpenActivityTemplateListInfo;
			var item:ChestItemView
			for(var i:int; i<_itemList.length; i++)
			{
				item = _itemList[i] as ChestItemView;
				opActObj = item.opActObj;
				if(opActObj.id == int(evt.data.id))
				{
					item.setType(2);
					break;
				}
			}
		}
		
		private function toPay(evt:MouseEvent):void
		{
			JSUtils.gotoFill();
		}
		
		private function completePay(evt:Event):void
		{
			_countDown.visible = false;
//			_actTime.visible = true;
//			_actTime.setValue(LanguageManager.getWord("ssztl.activity.overTime"));
			
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getOpenServerData);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardData);
			_btnPay.removeEventListener(MouseEvent.CLICK,toPay);
			_countDown.removeEventListener(Event.COMPLETE,completePay);
		}
		
		private function clearData():void
		{
			var i:int = 0;
			if (_itemList)
			{
				while (i < _itemList.length)
				{
					_itemList[i].removeEventListener(MouseEvent.CLICK,itemClickHanlder);
					_itemList[i].dispose();
					i++;
				}
				_itemList = [];
			}
			if(_itemTile)
			{
				_itemTile.disposeItems();
			}
		}
		private function clearCell():void
		{
			var ay:Array = _cellTile.getItems();
			for(var i:int=0; i<ay.length; i++)
			{
				ay[i].dispose();
			}
			_cellTile.disposeItems();
		}
		
		override public function dispose():void
		{
			clearData();
			clearCell();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_bg2)
			{
				_bg2.dispose();
				_bg2 = null;
			}
			if(_progress)
			{
				_progress.dispose();
				_progress = null;
			}
			if(_bgMap && _bgMap.bitmapData)
			{
				_bgMap.bitmapData.dispose();
				_bgMap = null;
			}
			if(_barInterval && _barInterval.bitmapData)
			{
				_barInterval.bitmapData.dispose();
				_barInterval = null;
			}
			if(_selectedBorder && _selectedBorder.bitmapData)
			{
				_selectedBorder.bitmapData.dispose();
				_selectedBorder = null;
			}
//			_actTime = null;
			_actCont = null;
			_myPayTxt = null;
			_itemTile = null;
			_itemList = null;
			_currentIndex = 0;
			_selectedTag = null;
			_cellTile = null;
			super.dispose();
		}
		
		public function assetsCompleteHandler():void
		{
			_bgMap.bitmapData = AssetUtil.getAsset("ssztui.firstPay.bgPayAsset",BitmapData) as BitmapData;
		}
	}
}