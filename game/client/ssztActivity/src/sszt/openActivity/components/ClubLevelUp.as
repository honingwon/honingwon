package sszt.openActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.panel.IPanel;
	import sszt.openActivity.components.item.ClubItemView;
	import sszt.openActivity.mediator.OpenActivityMediator;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	/**
	 * 帮会冲级奖励 
	 * @author chendong
	 * 
	 */	
	public class ClubLevelUp extends Sprite implements IPanel
	{
		private var _mediator:OpenActivityMediator;
		private var _actTime:MAssetLabel;
		private var _actCont:MAssetLabel;
		private var _type:int = -1; //2:"充值礼包"，3："消费礼包",4："冲级礼包"
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
		
		public function ClubLevelUp(mediator:OpenActivityMediator,type:int)
		{
			super();
			_mediator = mediator;
			_type = type;
			initView();
			initEvent();
//			initData();
		}
		
		public function initView():void
		{
			_actTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actTime.move(80,67);
			addChild(_actTime);
			_actTime.visible = false;
			
			_actCont = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actCont.wordWrap = true;
			_actCont.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,8)]);
			_actCont.setSize(296,65);
			_actCont.move(80,93);
			addChild(_actCont);
			
			_countDown = new CountDownDayView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(100,18);
			_countDown.move(80,67);
			addChild(_countDown);
			_countDown.visible = false;
			
			_itemList = [];
			_itemTile = new MTile(63,112,6);
			_itemTile.setSize(378,112);
			_itemTile.move(0,0);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			setTemplateListData();
			
		}
		
		public function initEvent():void
		{
			_countDown.addEventListener(Event.COMPLETE,completeClubLevelUp);
		}
		
		private function completeClubLevelUp(evt:Event):void
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
			opAct = OpenActivityUtils.getActivityArray(_type);
			var opActObj:OpenActivityTemplateListInfo;
			for(var i:int = 0; i<opAct.length; i++)
			{
				opActObj = opAct[i]
				var item:ClubItemView = new ClubItemView(opActObj);
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
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
			_countDown.removeEventListener(Event.COMPLETE,completeClubLevelUp);
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y
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