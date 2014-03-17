package sszt.task.components.sec.TaskEntrust
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.TaskTrustFinishSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.task.components.sec.items.EntrustFinishItem;
	import sszt.task.events.TaskInnerEvent;
	
	public class EntrustFinishPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _finishBtn:MCacheAsset1Btn;
		private var _tile:MTile;
		private var _list:Array;
		private var _moneyField:TextField,_needField:TextField;
		private var _need:int;
		
		public function EntrustFinishPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("sszt.task.EntrustFinishTitleAsset"))
			{
//				title = new Bitmap(new (GlobalData.domain.getDefinition("sszt.task.EntrustFinishTitleAsset") as Class)());
				title = new Bitmap(AssetUtil.getAsset("mhsm.task.EntrustFinishTitleAsset") as BitmapData);
			}
			super(new MCacheTitle1("",title),true,-1);
			initView();
			initEvent();
		}
		
		private function initView():void
		{
			setContentSize(279,322);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,279,322)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,5,270,214)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(5,222,270,94)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,31,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,57,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,83,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,109,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,135,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,161,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,187,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(8,213,243,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(12,259,256,2),new MCacheSplit2Line())
			]);
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(13,233,80,18),new MAssetLabel(LanguageManager.getWord("ssztl.task.uintPrice"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(85,233,80,18),new MAssetLabel(LanguageManager.getWord("ssztl.task.oneYuanBao"),MAssetLabel.LABELTYPE1,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(143,233,80,18),new MAssetLabel(LanguageManager.getWord("ssztl.task.totalNeedYuanBao"),MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(13,283,80,18),new MAssetLabel(LanguageManager.getWord("ssztl.sszt.common.leftYuanBao") ,MAssetLabel.LABELTYPE2,TextFormatAlign.LEFT)));
			
			_moneyField = new TextField();
			_moneyField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_moneyField.width = 90;
			_moneyField.x = 76;
			_moneyField.y = 282;
			_moneyField.mouseEnabled = _moneyField.mouseWheelEnabled = false;
			addContent(_moneyField);
			_moneyField.text = String(GlobalData.selfPlayer.userMoney.yuanBao);
			
			_needField = new TextField();
			_needField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF);
			_needField.width = 90;
			_needField.x = 210;
			_needField.y = 233;
			_needField.mouseEnabled = _needField.mouseWheelEnabled = false;
			addContent(_needField);
			
			_finishBtn = new MCacheAsset1Btn(2,LanguageManager.getWord("ssztl.task.finishRightNow"));
			_finishBtn.move(190,278);
			addContent(_finishBtn);
			
			_list = [];
			_tile = new MTile(240,20);
			_tile.setSize(258,202);
			_tile.move(12,12);
			_tile.itemGapH = 6;
			_tile.verticalScrollBar.lineScrollSize = 26;
			_tile.horizontalScrollPolicy = "off";
			addContent(_tile);
			
			createList();
		} 
		
		private function initEvent():void
		{
			_finishBtn.addEventListener(MouseEvent.CLICK,finishBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			_finishBtn.removeEventListener(MouseEvent.CLICK,finishBtnClickHandler);
		}
		
		private function finishBtnClickHandler(e:MouseEvent):void
		{
			if(GlobalData.selfPlayer.userMoney.yuanBao < _need)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.task.yuanBaoNotEnough"));
				return;
			}
			var list:Array = [];
			for each(var item:EntrustFinishItem in _list)
			{
				if(item.selected)list.push(item.taskId);
			}
			TaskTrustFinishSocketHandler.send(list);
			dispose();
		}
		
		private function createList():void
		{
			var list:Array = GlobalData.taskInfo.getEntrustingTask();
			for each(var task:TaskItemInfo in list)
			{
				var item:EntrustFinishItem = new EntrustFinishItem(task);
				item.addEventListener(TaskInnerEvent.TASK_ENTRUSTFINISH_UPDATE,entrustFinishUpdateHandler);
				_tile.appendItem(item);
				_list.push(item);
			}
			entrustFinishUpdateHandler(null);
		}
		
		private function entrustFinishUpdateHandler(e:TaskInnerEvent):void
		{
			_need = 0;
			for each(var item:EntrustFinishItem in _list)
			{
				if(item.selected)
				{
					_need += item.price;
				}
			}
			_needField.text = String(_need);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_finishBtn)
			{
				_finishBtn.dispose();
				_finishBtn = null;
			}
			for each(var item:EntrustFinishItem in _list)
			{
				item.removeEventListener(TaskInnerEvent.TASK_ENTRUSTFINISH_UPDATE,entrustFinishUpdateHandler);
				item.dispose();
				item = null;
			}
			_list = null;
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			super.dispose();
		}
	}
}