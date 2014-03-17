package sszt.openActivity.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.JSUtils;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.openActivity.components.item.ChestItemView;
	import sszt.openActivity.mediator.OpenActivityMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.openServer.BtnPayAsset;
	import ssztui.openServer.ProgressIntervalAsset;
	import ssztui.openServer.TitleAsset3;
	
	/**
	 * 消费奖励 
	 * @author chendong
	 * 
	 */	
	public class ConsumTagView extends Sprite
	{
		private var _mediator:OpenActivityMediator;
		private var _bg:IMovieWrapper;
		
		private var _barInterval:Bitmap;
		private var _progress:ProgressBar2;
		private var _actCont:MAssetLabel;
		private var _myPayLabel:MAssetLabel;
		private var _myPayTxt:MAssetLabel;
//		private var _btnPay:MAssetButton1;
		
		private var _type:int = 3;//2:"充值礼包"，3："消费礼包",4："冲级礼包"
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _chestItemTile:MTile;
		private var _chestItemList:Array;
		
		/**
		 * 倒计时 
		 * 天-时-分-秒
		 */
		private var _countDown:CountDownDayView;
		
		public function ConsumTagView(mediator:OpenActivityMediator)
		{
			_mediator = mediator;
			initView();
			initEvent();
			initData();
		}
		private function initView():void
		{
			//402
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(60,14,140,32),new Bitmap(new TitleAsset3())),
				
			]);
			addChild(_bg as DisplayObject);
			
			_countDown = new CountDownDayView();
			_countDown.setLabelType(OpenActivityPanel.tfStyle);
			_countDown.textField.textColor = 0x6ae100;
			_countDown.setSize(200,18);
			_countDown.move(78,65);
			addChild(_countDown);
			_countDown.visible = false;
			
			_actCont = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_actCont.wordWrap = true;
			_actCont.setLabelType([OpenActivityPanel.tfStyle]);
			_actCont.setSize(296,65);
			_actCont.move(78,84);
			addChild(_actCont);
//			_actCont.setHtmlValue("只要每日充值达到一定的金额,都将会获得一份与充值金额对应的【充值礼包】。");			
			
			_myPayLabel = new MAssetLabel(LanguageManager.getWord("ssztl.activity.TagCurrentConsum"),MAssetLabel.LABEL_TYPE_YAHEI,TextFormatAlign.LEFT);
			_myPayLabel.setLabelType([OpenActivityPanel.tfStyle]);
			_myPayLabel.move(120,180);
			addChild(_myPayLabel);
			
			_myPayTxt = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_myPayTxt.setLabelType([new TextFormat("Tahoma",20,0xffcc00,true)]);
			_myPayTxt.move(220,177);
			addChild(_myPayTxt);
			
//			_btnPay = new MAssetButton1(new BtnPayAsset() as MovieClip);
//			_btnPay.move(260,172);
//			addChild(_btnPay);
			
			_progress = new ProgressBar2(_type,new Bitmap(),1,1,363,13,false,false);
			_progress.move(19,221);
			addChild(_progress);
			
//			_barInterval = new Bitmap(new ProgressIntervalAsset());
//			_barInterval.x = 67;
//			_barInterval.y = 221;
//			addChild(_barInterval);
			
			_chestItemList = [];
			_chestItemTile = new MTile(62,112,6);
			_chestItemTile.setSize(400,112);
			_chestItemTile.move(12,235);
			_chestItemTile.itemGapW = 0;
			_chestItemTile.horizontalScrollPolicy = _chestItemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addChild(_chestItemTile);
			
			setTemplateListData();
		}
		private function initEvent():void
		{
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getOpenServerDataCon);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getAwardDataCon);
//			_btnPay.addEventListener(MouseEvent.CLICK,toPayCon);
			_countDown.addEventListener(Event.COMPLETE,completeCon);
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
				_chestItemTile.appendItem(item);
				_chestItemList.push(item);
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
//			_actTime.setValue(LanguageManager.getWord("ssatl.openActivityactCont.time1"));
			_actCont.setHtmlValue(LanguageManager.getWord("ssztl.openActivityactCont.actCont2"));
			_myPayTxt.setValue(obj.totalValue);
			_progress.setValue(OpenActivityUtils.getCurrentMaxValue(_type,int(obj.totalValue)),int(obj.totalValue));
			
			setTemplateListData();
		}
		
		private function getOpenServerDataCon(evt:ModuleEvent):void
		{
			initData();
		}
		
		private function getAwardDataCon(evt:ModuleEvent):void
		{
			var opActObj:OpenActivityTemplateListInfo;
			var item:ChestItemView
			for(var i:int; i<_chestItemList.length; i++)
			{
				item = _chestItemList[i] as ChestItemView;
				opActObj = item.opActObj;
				if(opActObj.id == int(evt.data.id))
				{
					item.setType(2);
					break;
				}
			}
		}
		
		private function toPayCon(evt:MouseEvent):void
		{
			JSUtils.gotoFill();
		}
		
		private function completeCon(evt:Event):void
		{
			_countDown.visible = false;
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getOpenServerDataCon);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getAwardDataCon);
//			_btnPay.removeEventListener(MouseEvent.CLICK,toPayCon);
			_countDown.removeEventListener(Event.COMPLETE,completeCon);
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
			if (_chestItemList)
			{
				while (i < _chestItemList.length)
				{
					
					_chestItemList[i].dispose();
					i++;
				}
				_chestItemList = [];
			}
			if(_chestItemTile)
			{
				_chestItemTile.disposeItems();
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
			if(_progress)
			{
				_progress.dispose();
				_progress = null;
			}
			if(_barInterval && _barInterval.bitmapData)
			{
				_barInterval.bitmapData.dispose();
				_barInterval = null;
			}
//			_actTime = null;
			_actCont = null;
			_myPayTxt = null;
			_chestItemTile = null;
			_chestItemList = null;
		}
	}
}