package sszt.core.view.patchUse
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mhsm.ui.DownBtnAsset;
	import mhsm.ui.UpBtnAsset;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.buff.BuffTemplateInfo;
	import sszt.core.data.buff.BuffTemplateList;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.common.ItemBatchUseSocketHandler;
	import sszt.core.socketHandlers.common.ItemUseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class BatchUsePanel extends MPanel
	{
		private static var instance:BatchUsePanel;
		private var _itemInfo:ItemInfo;
		
		private var _inputLabel:TextField;
		private var _upBtn:MCacheAssetBtn2;
		private var _downBtn:MCacheAssetBtn2;
		private var _okBtn:MCacheAssetBtn1;
		private var _cancelBtn:MCacheAssetBtn1;
		private var _bg:IMovieWrapper;
		private static const TF:TextFormat = new TextFormat("Tahoma",12,0xFFD700,null,null,null,null,null,TextFormatAlign.CENTER);
		
		public function BatchUsePanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.BatchUseAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.BatchUseAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(270,112);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(11,7,248,64)),
				new BackgroundInfo(BackgroundType.BORDER_7,new Rectangle(109,27,94,24))
			]);
			addContent(_bg as DisplayObject);
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(66,30,60,16),new MAssetLabel(LanguageManager.getWord("ssztl.bag.number")+"：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)));
			
			_inputLabel = new TextField();
			_inputLabel.defaultTextFormat = TF;
			_inputLabel.type = TextFieldType.INPUT; 
			_inputLabel.height =16;
			_inputLabel.width = 54;		
			_inputLabel.x = 130;
			_inputLabel.y = 30;
			_inputLabel.text = "1";
			_inputLabel.restrict = "0123456789";
			_inputLabel.maxChars =2;
			addContent(_inputLabel);
			
			_downBtn = new MCacheAssetBtn2(1);
			addContent(_downBtn);
			_downBtn.move(112,30);
			_upBtn = new MCacheAssetBtn2(0);
			addContent(_upBtn);
			_upBtn.move(184,30);
			
			_okBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.sure"));
			_okBtn.move(72,76);
			addContent(_okBtn);
			_cancelBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(138,76);
			addContent(_cancelBtn);
		}
		
		private function initEvent():void
		{
			_upBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downClickHandler);
			_okBtn.addEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function removeEvent():void
		{
			_upBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_okBtn.removeEventListener(MouseEvent.CLICK,okClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(value == _itemInfo.count) return;
			_inputLabel.text = String(value + 1);
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(value == 1) return;
			_inputLabel.text = String(value - 1);
		}
		
		private function okClickHandler(evt:MouseEvent):void
		{
			if(value > _itemInfo.count)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.inputNumError"));
				return;
			}
			if(_itemInfo.template.needLevel >GlobalData.selfPlayer.level)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.levelNotEnough"));
				return ;
			}
			if(_itemInfo.template.categoryId == CategoryType.LIFEEXPERIENCEMEDICINE && GlobalData.selfPlayer.PKValue >=11)
			{
				QuickTips.show(LanguageManager.getWord("ssztl.core.redNameState"));
				return;
			}
			if(_itemInfo.template.categoryId == CategoryType.BUFF)
			{
				var buff:BuffTemplateInfo = BuffTemplateList.getBuff(_itemInfo.template.property5);
				var buffItem:BuffItemInfo = GlobalData.selfScenePlayerInfo.getBuffByType(buff.type);
				if(buffItem)
				{
					var upToLimit:Boolean = false;
					if(buffItem.getTemplate().limitTotalTime > -1)
					{
						if(!buffItem.getTemplate().getIsTime())
						{
							upToLimit = buffItem.remain + buff.valieTime >= buffItem.getTemplate().limitTotalTime;
						}
						else
						{
							var start:Number;
							if(buffItem.isPause)
							{
								start = buffItem.pauseTime.getTime();
							}
							else start = GlobalData.systemDate.getSystemDate().getTime();
							upToLimit = (buffItem.endTime.getTime() - start + buff.valieTime) >= buffItem.getTemplate().limitTotalTime;
						}
					}
					if(upToLimit)
					{
						MAlert.show(LanguageManager.getWord("ssztl.common.bufferAchieveMax"),buff.name);
						return;
					}
					if(buffItem.templateId != buff.templateId)
					{
						MAlert.show(LanguageManager.getWord("ssztl.core.bufferWillReplaced",buff.name,buffItem.getTemplate().name),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
						return;
					}
				}
			}
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					doUse();
				}
			}
			function doUse():void
			{
				ItemBatchUseSocketHandler.send(_itemInfo.place,value);
				hide();
			}
			doUse();
			hide();
		}
		
		private function cancelClickHandler(evt:MouseEvent):void
		{
			hide();
		}
		
		public function get value():int
		{
			return int(_inputLabel.text);
		}
		
		public static function getInstance():BatchUsePanel
		{
			if(instance == null)
			{
				instance = new BatchUsePanel();
			}
			return instance;
		}
		
		public function hide():void
		{
			removeEvent();
			if(parent) parent.removeChild(this);
		}
		
		public function show(item:ItemInfo):void
		{
			_itemInfo = item;
			if(!parent) GlobalAPI.layerManager.addPanel(this);
			initEvent();
			_inputLabel.text = String(_itemInfo.count);
		}
		
		override public function dispose():void
		{
			hide();
		}
	}
}