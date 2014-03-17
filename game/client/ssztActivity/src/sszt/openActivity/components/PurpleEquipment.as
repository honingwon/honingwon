package sszt.openActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.openActivity.OpenActivityGetAwardSocketHandler;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.components.item.PurpleItemView;
	import sszt.openActivity.mediator.OpenActivityMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.tabBtns.MCacheTabBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	import ssztui.openServer.PurpleEquipmentTitleAsset;
	
	/**
	 * 穿紫色装备奖励 
	 * @author chendong
	 * 
	 */	
	public class PurpleEquipment extends Sprite implements IPanel
	{
		private var _mediator:OpenActivityMediator;
		private var _actTime:MAssetLabel;
		private var _actCont:MAssetLabel;
		private var _type:int = 6; //1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级
		/**
		 * 倒计时 
		 * 天-时-分-秒
		 */
		private var _countDown:CountDownDayView;
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		/**
		 * 穿紫色装备送的礼包 
		 */		
		private var _bigCell:BigCell;
		/**
		 * 开服活动模板数据 
		 */		
		private var opActObj:OpenActivityTemplateListInfo;
		
		private var _lables:Array;
		
		private var _bg:IMovieWrapper;
		private var _txtTitle:MAssetLabel;
		
		public function PurpleEquipment(mediator:OpenActivityMediator,type:int=0)
		{
			super();
			_mediator = mediator;
//			_type = type;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(6,195,394,25),new MCacheCompartLine2()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(117,171,187,22),new Bitmap(new PurpleEquipmentTitleAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel(LanguageManager.getWord("ssztl.activity.listTitle6"),[OpenActivityPanel.titleStyle],TextFormatAlign.LEFT);
			_txtTitle.move(60,16);
			addChild(_txtTitle);
			
			_countDown = new CountDownDayView();
			_countDown.setLabelType(OpenActivityPanel.tfStyle);
			_countDown.textField.textColor = 0x6ae100;
			_countDown.setSize(120,18);
			_countDown.move(78,65);
			addChild(_countDown);
			_countDown.visible = false;
			
			_actTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actTime.setLabelType([OpenActivityPanel.tfStyle]);
			_actTime.move(78,65);
			addChild(_actTime);
			_actTime.visible = false;
			
			_actCont = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actCont.wordWrap = true;
			_actCont.setLabelType([OpenActivityPanel.tfStyle]);
			_actCont.setSize(320,65);
			_actCont.move(78,84);
			addChild(_actCont);
			
			_itemList = [];
			_itemTile = new MTile(394,62);
			_itemTile.setSize(413,186);
			_itemTile.move(6,199);
			_itemTile.itemGapH = 0;
			_itemTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_itemTile.verticalScrollPolicy = ScrollPolicy.AUTO;
//			_itemTile.verticalScrollBar.lineScrollSize = 62;
			addChild(_itemTile);
			
			_bigCell = new BigCell();
			_bigCell.move(0,0);
			addChild(_bigCell);
			
			_lables = [
				LanguageManager.getWord("ssztl.activity.numLable2"),LanguageManager.getWord("ssztl.activity.numLable4"),
				LanguageManager.getWord("ssztl.activity.numLable6"),LanguageManager.getWord("ssztl.activity.numLable9")];
			setTemplateListData();
		}
		
		public function initEvent():void
		{
			_countDown.addEventListener(Event.COMPLETE,completePruple);
			
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getPruple);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardPruple);
		}
		
		public function getAwardClickHandler(e:MouseEvent):void
		{
//			OpenActivityGetAwardSocketHandler.send(opActObj.id,opActObj.group_id);
		}
		
		private function completePruple(evt:Event):void
		{
			_countDown.visible = false;
			_actTime.visible = true;
			_actTime.setValue(LanguageManager.getWord("ssztl.activity.overTime"));
		}
		
		private function getPruple(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardPruple(evt:ModuleEvent):void
		{
			var opActObj:OpenActivityTemplateListInfo;
			var item:PurpleItemView
			for(var i:int; i<_itemList.length; i++)
			{
				item = _itemList[i] as PurpleItemView;
				opActObj = item.opActObj;
				if(opActObj.id == int(evt.data.id))
				{
					item.setType(2);
					break;
				}
			}
		}
		
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			clearData();
			var opActObj:OpenActivityTemplateListInfo;
			var item:PurpleItemView;
			opAct = OpenActivityUtils.getActivityArray(_type);
			for(var i:int = 0; i<_lables.length; i++)
			{
				opActObj = opAct[i];
				item = new PurpleItemView(opActObj);
				item.setType(OpenActivityUtils.getedActivity(opActObj.group_id,opActObj.id,opActObj.need_num));
				_itemTile.appendItem(item);
				_itemList.push(item); 
					
				item.setTag(_lables[i],i);
			}

			/*
			//赠送礼包
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = bigItem.templateId;
			_bigCell.itemInfo = itemInfo;
			
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
			var item:Cell;
			for(; i<itemArray.length; i++)
			{
				item = new Cell();
				itemInfo = new ItemInfo();
				itemInfo.templateId = itemArray[i];
				itemInfo.count = itemNumArray[i];
				item.itemInfo = itemInfo;
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
			*/
		}
		
		/**
		 * 设置紫装数量
		 */
		private function setPurleNum():int
		{
			var index:int = 0;
			var opTemplateArray:Array = OpenActivityUtils.getActivityArray(_type);
			var userObj:Object = GlobalData.openActivityInfo.activityDic[_type];
			var totalValue:int = int(userObj.totalValue);
			if(totalValue <= OpenActivityTemplateListInfo(opTemplateArray[0]).need_num)
			{
				index = 0;
			}
			else if(totalValue <= OpenActivityTemplateListInfo(opTemplateArray[1]).need_num && totalValue > OpenActivityTemplateListInfo(opTemplateArray[0]).need_num)
			{
				index = 1;
			}
			else if(totalValue <= OpenActivityTemplateListInfo(opTemplateArray[2]).need_num && totalValue > OpenActivityTemplateListInfo(opTemplateArray[1]).need_num)
			{
				index = 2;
			}
			else if(totalValue <= OpenActivityTemplateListInfo(opTemplateArray[3]).need_num && totalValue > OpenActivityTemplateListInfo(opTemplateArray[2]).need_num)
			{
				index = 3;
			}
			else
			{
				index = 3;
			}
			return index;
		}
		
		
		/**
		 * 获得获得奖励是否被领取 0:不可领 1:可领取 2:已领
		 */
		private function isGeted(argindex:int):int
		{
			var isType:int = 0;
			var opTemplateArray:Array = OpenActivityUtils.getActivityArray(_type);
			var userObj:OpenActivityTemplateListInfo;
			userObj = opTemplateArray[argindex];
			isType = OpenActivityUtils.getedActivity(userObj.group_id,userObj.id,userObj.need_num);
			return isType;
		}
		
		public function initData():void
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
				}
			}
			_countDown.visible = true;
			_countDown.start(Number(obj.openTime));
			_actCont.setHtmlValue(LanguageManager.getWord("ssztl.openActivityactCont.actCont"+_type));
			
			setTemplateListData();
		}
		
		public function clearData():void
		{
			var i:int = 0;
			if (_itemList)
			{
				while (i < _itemList.length)
				{
					
					_itemList[i].dispose();
					i++;
				}
				_itemList = [];
			}
			if(_itemTile)
			{
				_itemTile.clearItems();
			}
			_bigCell.dispose();
		}
		
		public function removeEvent():void
		{
			_countDown.removeEventListener(Event.COMPLETE,completePruple);
			
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getPruple);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardPruple);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		
		public function dispose():void
		{
			clearData();
			removeEvent();
			_actTime = null;
			_actCont = null;
			opAct = null;
			_itemTile = null;
			_itemList = null;
			_bigCell = null;
		}
	}
}