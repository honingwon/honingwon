package sszt.openActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
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
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.components.item.LevelGiftItemView;
	import sszt.openActivity.mediator.OpenActivityMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.openServer.TitleAsset2;

	/**
	 * 冲级礼包 
	 * @author chendong
	 * 
	 */	
	public class LevelTagView extends Sprite
	{
		private var _mediator:OpenActivityMediator;
		private var _bg:IMovieWrapper;
		
		private var _actTime:MAssetLabel;
		private var _actCont:MAssetLabel;
		private var _type:int = -1;//1:首充2:开服充值,3:开服消费4,冲级5.单笔充值6.VIP 7.帮会等级8.紫装
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		/**
		 * 倒计时 
		 * 天-时-分-秒
		 */
		private var _countDown:CountDownDayView;
		
		public function LevelTagView(mediator:OpenActivityMediator,type:int)
		{
			_mediator = mediator;
			_type = type;
			initView();
			initEvent();
			initData();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(145,15,113,30),new Bitmap(new TitleAsset2())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,212,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(82,212,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(145,212,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(208,212,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(271,212,50,50), new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(334,212,50,50), new Bitmap(CellCaches.getCellBigBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,67,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime")+"：",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,93,50,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityDescription")+"：",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
			addChild(_bg as DisplayObject);
			
			_actTime = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actTime.move(80,67);
			addChild(_actTime);
			
			_countDown = new CountDownDayView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(200,18);
			_countDown.move(80,67);
//			addChild(_countDown);
			_countDown.visible = false;
			
			_actCont = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actCont.wordWrap = true;
			_actCont.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,8)]);
			_actCont.setSize(296,65);
			_actCont.move(80,93);
			addChild(_actCont);
//			_actCont.setHtmlValue("只要每日充值达到一定的金额,都将会获得一份与充值金额对应的【充值礼包】。");
			
			_itemList = [];
			_itemTile = new MTile(63,112,6);
			_itemTile.setSize(378,112);
			_itemTile.move(12,179);
			_itemTile.itemGapW = 0;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			setTemplateListData();
		}
		private function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getOpenServerDataLevel);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardDataLevel);
			_countDown.addEventListener(Event.COMPLETE,completeLevel);
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
				var item:LevelGiftItemView = new LevelGiftItemView(opActObj);
				item.setType(OpenActivityUtils.getedActivity(opActObj.group_id,opActObj.id,opActObj.need_num));
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
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
			_actTime.setValue(LanguageManager.getWord("ssztl.openActivityactCont.time2"));
			_actCont.setHtmlValue(LanguageManager.getWord("ssztl.openActivityactCont.actCont3"));
			
			setTemplateListData();
		}
		
		private function getOpenServerDataLevel(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardDataLevel(evt:ModuleEvent):void
		{
			var opActObj:OpenActivityTemplateListInfo;
			var item:LevelGiftItemView;
			for(var i:int; i<_itemList.length; i++)
			{
				item = _itemList[i] as LevelGiftItemView;
				opActObj = item.opActObj
				if(opActObj.id == int(evt.data.id))
				{
					item.setType(2);
					break;
				}
			}
		}
		
		private function completeLevel(evt:Event):void
		{
			_countDown.visible = false;
			_actTime.visible = true;
			_actTime.setValue(LanguageManager.getWord("ssztl.activity.overTime"));
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getOpenServerDataLevel);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardDataLevel);
			_countDown.removeEventListener(Event.COMPLETE,completeLevel);
		}
		
		public function show():void
		{
			
		}
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		public function move(x:int,y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		private function clearData():void
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
		
		public function dispose():void
		{
			clearData();
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_actTime = null;
			_actCont = null;
			opAct = null;
			_itemTile = null;
			_itemList = null;
		}
	}
}