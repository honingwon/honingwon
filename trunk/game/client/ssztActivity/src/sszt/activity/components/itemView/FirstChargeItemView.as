package sszt.activity.components.itemView
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.activity.GitfIconAsset;
	import sszt.activity.components.cell.AwardCell;
	import sszt.activity.components.cell.WelfFareCell;
	import sszt.activity.data.itemViewInfo.GiftItemInfo;
	import sszt.activity.events.ActivityInfoEvents;
	import sszt.activity.mediators.ActivityMediator;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.WelfareTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.task.TaskItemInfo;
	import sszt.core.data.task.TaskStateType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.task.TaskSubmitSocketHandler;
	import sszt.core.utils.JSUtils;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class FirstChargeItemView extends Sprite
	{
		private var _mediator:ActivityMediator;
		private var _giftInfo:GiftItemInfo;
		private var _descriptionLabel:TextField;
		private var _chargeBtn:MCacheAsset1Btn;
		private var _getBtn:MCacheAsset1Btn;
		private var _bg:IMovieWrapper;
		private var _gift:Bitmap;
		
		public function FirstChargeItemView(item:GiftItemInfo,argMediator:ActivityMediator)
		{
			super();
			_giftInfo = item;
			_mediator = argMediator;
			initialView();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,591,102)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(3,3,586,22))
			]);
			addChild(_bg as DisplayObject);
			
			if(_giftInfo.title == "")
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(265,6,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.FirstChargeGift"),MAssetLabel.LABELTYPE1)));
			}else
			{
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(265,6,52,16),new MAssetLabel(_giftInfo.title,MAssetLabel.LABELTYPE1)));
			}
			
			_gift = new Bitmap(new GitfIconAsset());
			_gift.x = 18;
			_gift.y = 36;
			addChild(_gift);
			
			_chargeBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.activity.clickToCharge"));
			_chargeBtn.move(495,31);
			addChild(_chargeBtn);
			
			_getBtn = new MCacheAsset1Btn(3,LanguageManager.getWord("ssztl.activity.getFirstChargeGift"));
			_getBtn.move(495,64);
			addChild(_getBtn);
			var task:TaskItemInfo = GlobalData.taskInfo.getTask(CategoryType.FIRST_CHARGE_TASK);
			if(task && task.isExist && task.isFinish)
			{
				_getBtn.labelField.text = LanguageManager.getWord("ssztl.activity.hasGotten");
				_getBtn.enabled = false;
			}
			
			initLinkView();		
			initialEvents();
		}
		
		private function initLinkView():void
		{
			var currentH:int = 33;
			var currentW:int = 96;		
			var str:String = _giftInfo.descript;
			var strArray:Array = str.split("#");
			var ids:Array = strArray[1].split(",");
			var counts:Array = strArray[2].split(",");
			
			_descriptionLabel = new TextField();
			_descriptionLabel.textColor = 0xffffff;
			_descriptionLabel.mouseEnabled = _descriptionLabel.mouseWheelEnabled = false;
			_descriptionLabel.x = currentW;
			_descriptionLabel.y = currentH;
			_descriptionLabel.width = 400;
			_descriptionLabel.height = 60;
			_descriptionLabel.wordWrap = true;
			_descriptionLabel.multiline = true;
			_descriptionLabel.text = strArray[0];
			addChild(_descriptionLabel);
			
			currentW = currentW + _descriptionLabel.textWidth;
			
			for(var i:int = 0;i<ids.length;i++)
			{
				var obg:LinkItemView = new LinkItemView(ids[i],counts[i]);
				addChild(obg);
				if(currentW + obg.getWidth() > 496)
				{
					currentW = 96;
					currentH = currentH + 20;
					obg.x = currentW;
					obg.y = currentH;
				}else
				{
					obg.x = currentW;
					obg.y = currentH;
				}
				currentW = currentW + obg.getWidth();
			}
		}
		
		private function initialEvents():void
		{
			_chargeBtn.addEventListener(MouseEvent.CLICK,chargeClickHandler);
			_getBtn.addEventListener(MouseEvent.CLICK,getBtnHandler);
		}
		
		private function removeEvents():void
		{
			_chargeBtn.removeEventListener(MouseEvent.CLICK,chargeClickHandler);
			_getBtn.removeEventListener(MouseEvent.CLICK,getBtnHandler);
		}
		
		private function chargeClickHandler(evt:MouseEvent):void
		{
			JSUtils.gotoFill();
		}
		
		private function getBtnHandler(e:MouseEvent):void
		{
			var task:TaskItemInfo = GlobalData.taskInfo.getTask(520001);
			if(!task) return;
			if(task.taskState != TaskStateType.FINISHNOTSUBMIT)
			{
				MAlert.show(LanguageManager.getWord("ssztl.activity.neverCharge"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,chargeAlertHandler);
				return;
			}
			TaskSubmitSocketHandler.sendSubmit(task.taskId);
			_getBtn.labelField.text = LanguageManager.getWord("ssztl.activity.hasGotten");
			_getBtn.enabled = false;
		}
		
		private function chargeAlertHandler(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.OK)
			{
				JSUtils.gotoFill();
			}
		}
		
		public function dispose():void
		{
			removeEvents();
			_mediator = null;
			_giftInfo = null;
			_descriptionLabel = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			} 
			if(_getBtn)
			{
				_getBtn.dispose();
				_getBtn = null;
			}
			if(_chargeBtn)
			{
				_chargeBtn.dispose();
				_chargeBtn = null;
			}
			_gift = null;
			if(parent) parent.removeChild(this);
		}
	}
}