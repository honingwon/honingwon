package sszt.midAutumnActivity.components
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
	import sszt.interfaces.panel.IPanel;
	import sszt.midAutumnActivity.components.item.BigCell;
	import sszt.midAutumnActivity.components.item.RecItemView;
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.components.OpenActivityPanel;
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
	
	import ssztui.activity.IconStarAsset;
	import ssztui.midAutmn.IntervalAsset;
	
	/**
	 * 单日充值 
	 * @author chendong
	 * 
	 */	
	public class Recharge extends Sprite implements IPanel
	{
		private var _bg:IMovieWrapper;
		private var _actTime:MAssetLabel;
		private var _actCont:MAssetLabel;
		private var _type:int = 81; //1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级
		private var _typeArray:Array = [81,82,83];
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _itemTile:MTile;
		private var _itemList:Array;
		
		private var _bigCell:BigCell;
		
		private var _txtTitle:MAssetLabel;
		private var _txtTime:MAssetLabel;
		private var _txtDetail:MAssetLabel;
		
		/**
		 * 领取奖励 
		 */
		private var _finishGetAwardBtn:MCacheAssetBtn1;
		/**
		 * 开服活动模板数据 
		 */		
		private var opActObj:OpenActivityTemplateListInfo;
		
		public function Recharge()
		{
			super();
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,42,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,64,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.rewardLevel")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,86,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityDescription")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(80,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(95,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(110,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(125,64,15,15),new Bitmap(new IconStarAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(143,180,1,133),new Bitmap(new IntervalAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(279,180,1,133),new Bitmap(new IntervalAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtTitle.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),20,0xffcc00,true)]);
			_txtTitle.move(211,10);
			addChild(_txtTitle);
			_txtTitle.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acName5"));
			
			_txtTime = new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.endTime"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTime.move(79,42);
			addChild(_txtTime);
			
			_txtDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDetail.wordWrap = true;
			_txtDetail.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtDetail.setSize(322,68);
			_txtDetail.move(79,86);
			addChild(_txtDetail);
			_txtDetail.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acDetail5"));
			
			_itemList = [];
			_itemTile = new MTile(135,155,3);
			_itemTile.setSize(407,155);
			_itemTile.move(8,174);
			_itemTile.itemGapW = 1;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_itemTile);
			
			setTemplateListData();
		}
		
		public function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getSingleRec);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardSingleRec);
		}
		
		private function getSingleRec(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardSingleRec(evt:ModuleEvent):void
		{
			var opActObj:OpenActivityTemplateListInfo;
			var item:RecItemView
			for(var i:int; i<_itemList.length; i++)
			{
				item = _itemList[i] as RecItemView;
				opActObj = item.opActObj;
				if(opActObj.id == int(evt.data.id))
				{
					item.setType(2);
					break;
				}
			}
		}
		
		public function assetsCompleteHandler():void
		{
		}
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			clearData();
			
			var opActObj:OpenActivityTemplateListInfo;
			var item:RecItemView
			for(var j:int=0;j<_typeArray.length;j++)
			{
				opAct = OpenActivityUtils.getActivityArray(_typeArray[j]);
				for(var i:int = 0; i<opAct.length; i++)
				{
					opActObj = opAct[i];
					item = new RecItemView(opActObj);
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
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getSingleRec);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardSingleRec);
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