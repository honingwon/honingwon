package sszt.openActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.panel.IPanel;
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.components.item.LevelGiftItemView;
	import sszt.openActivity.components.item.MakeVipItemView;
	import sszt.openActivity.mediator.OpenActivityMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit1Line;
	
	/**
	 * 角色冲级 
	 * @author chendong
	 * 
	 */	
	public class RoleLevelUp extends Sprite implements IPanel
	{
		private var _mediator:OpenActivityMediator;
		private var _actTime:MAssetLabel;
		private var _actCont:MAssetLabel;
		private var _type:int = 74; //1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级
		private var _typeArray:Array = [71,72,73,74];
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
		 * 领取奖励 
		 */
		private var _finishGetAwardBtn:MCacheAssetBtn1;
		/**
		 * 开服活动模板数据 
		 */		
		private var opActObj:OpenActivityTemplateListInfo;
		
		private var _bg:IMovieWrapper;
		private var _txtTitle:MAssetLabel;
		private var _myLevel:MAssetLabel;
		
		public function RoleLevelUp(mediator:OpenActivityMediator,type:int=0)
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
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(9,200,404,180)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,203,398,174)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(111,210,2,161),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(210,210,2,161),new MCacheSplit1Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(309,210,2,161),new MCacheSplit1Line()),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel(LanguageManager.getWord("ssztl.activity.listTitle7"),[OpenActivityPanel.titleStyle],TextFormatAlign.LEFT);
			_txtTitle.move(60,16);
			addChild(_txtTitle);
			
			_countDown = new CountDownDayView();
			_countDown.setLabelType(OpenActivityPanel.tfStyle);
			_countDown.textField.textColor = 0x6ae100;
			_countDown.setSize(120,18);
			_countDown.move(78,65);
			addChild(_countDown);
			_countDown.visible = false;
			
			_actTime = new MAssetLabel("",[OpenActivityPanel.tfStyle],TextFormatAlign.LEFT);
			_actTime.move(78,65);
			addChild(_actTime);
			_actTime.visible = false;
			
			_actCont = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actCont.wordWrap = true;
			_actCont.setLabelType([OpenActivityPanel.tfStyle]);
			_actCont.setSize(320,65);
			_actCont.move(78,84);
			addChild(_actCont);
			
			_myLevel = new MAssetLabel("",[OpenActivityPanel.tfStyle],TextFormatAlign.LEFT);
			_myLevel.move(18,176);
			addChild(_myLevel);
			_myLevel.setHtmlValue(LanguageManager.getWord("ssztl.activity.levelingLabel1") + "<font color='#ff6600'>"+ LanguageManager.getWord("ssztl.common.levelValue",GlobalData.selfPlayer.level)+"</font>");
			
			_itemList = [];
			_itemTile = new MTile(99,170,6);
			_itemTile.setSize(394,170);
			_itemTile.move(14,205);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			setTemplateListData();
		}
		
		public function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getRoleLevelUp);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardRoleLevelUp);
			_countDown.addEventListener(Event.COMPLETE,completeRoleLevelUp);
		}
		
		private function getRoleLevelUp(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardRoleLevelUp(evt:ModuleEvent):void
		{
			var opActObj:OpenActivityTemplateListInfo;
			var item:LevelGiftItemView
			for(var i:int; i<_itemList.length; i++)
			{
				item = _itemList[i] as LevelGiftItemView;
				opActObj = item.opActObj;
				if(opActObj.id == int(evt.data.id))
				{
					item.setType(2);
					break;
				}
			}
		}
		
		
		private function completeRoleLevelUp(evt:Event):void
		{
			_countDown.visible = false;
			_actTime.visible = true;
			_actTime.setValue(LanguageManager.getWord("ssztl.activity.overTime"));
		}
		
		
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			clearData();
			var opActObj:OpenActivityTemplateListInfo;
			var item:LevelGiftItemView
			for(var j:int=0;j<_typeArray.length;j++)
			{
				opAct = OpenActivityUtils.getActivityArray(_typeArray[j]);
				for(var i:int = 0; i<opAct.length; i++)
				{
					opActObj = opAct[i];
					item = new LevelGiftItemView(opActObj);
					item.setType(OpenActivityUtils.getedActivity(opActObj.group_id,opActObj.id,opActObj.need_num));
					_itemTile.appendItem(item);
					_itemList.push(item); 
				}
			}
		}
		
		public function initData():void
		{
			var obj:Object = GlobalData.openActivityInfo.activityDic[_type];
			var opActObj:OpenActivityTemplateListInfo;
			var timeStr:String="";
			if(opAct[opAct.length-1])
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
		}
		
		public function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getRoleLevelUp);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardRoleLevelUp);
			_countDown.removeEventListener(Event.COMPLETE,completeRoleLevelUp);
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