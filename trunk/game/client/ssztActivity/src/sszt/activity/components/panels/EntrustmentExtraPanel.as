package sszt.activity.components.panels
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.entrustment.EntrustmentInfoEvent;
	import sszt.core.data.entrustment.EntrustmentTemplateItem;
	import sszt.core.data.entrustment.EntrustmentTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.entrustment.StartEntrustingSocketHandler;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.activity.syTitleAsset;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	import ssztui.ui.SplitCompartLine2;
	
	public class EntrustmentExtraPanel extends MSprite implements IPanel
	{
		public static const DEFAULT_WIDTH:int = 282;
		public static const DEFAULT_HEIGHT:int = 400; 
		private var _bg:IMovieWrapper;
		private var _dragArea:Sprite;
		private var _btnClose:MAssetButton1;
		private var _helpTip:MSprite;
		
		private var _duplicateTemplateInfo:CopyTemplateItem;
		private var _currEntrustmentTemplateItem:EntrustmentTemplateItem;
		private var _timesMax:int;
		private var _times:int;
		private var _floorMax:int;
		private var _currFloor:int;
		private var _multiple:Number;
		private var _vipMultiple:Number = 0;
		private var _myFight:int;
		
		private var _duplicateNameLabel:MAssetLabel;
		private var _fightNeededLabel:MAssetLabel;
		private var _floorField:TextField;
		private var _timesField:TextField;
		private var _timeCostLabel:MAssetLabel;
		private var _copperCostLabel:MAssetLabel;
		private var _expRewardLabel:MAssetLabel;
		private var _checkbox:CheckBox;
		private var _extraExpRewardLabel:MAssetLabel;
		
		private var _btnStart:MCacheAssetBtn1;
		private var _upBtn:MBitmapButton;
		private var _downBtn:MBitmapButton;
		private var _upBtn2:MBitmapButton;
		private var _downBtn2:MBitmapButton;
		
		public function EntrustmentExtraPanel(duplicateTemplateInfo:CopyTemplateItem)
		{
			_duplicateTemplateInfo = duplicateTemplateInfo;
			
			var collection:Array = EntrustmentTemplateList.getTemplateCollection(_duplicateTemplateInfo.id);
			_floorMax = collection.length;
			
			_timesMax = _duplicateTemplateInfo.dayTimes - GlobalData.copyEnterCountList.getItemCount(_duplicateTemplateInfo.id)
			_times = _timesMax;
			_multiple = 1.0;
			
			var vip:int = GlobalData.selfPlayer.getVipType();
			switch(vip)
			{
				case VipType.VIP:
				case VipType.OneDay:
					_vipMultiple = 0.1;
					break;
				case VipType.BETTERVIP:
				case VipType.OneHour:
					_vipMultiple = 0.2;
					break;
				case VipType.BESTVIP:
					_vipMultiple = 0.3;
					break;
			}
						
			_myFight = GlobalData.selfPlayer.fight;
			for (_currFloor = 30; _currFloor > 1; _currFloor--)
			{				
				_currEntrustmentTemplateItem = EntrustmentTemplateList.getTemplate(_duplicateTemplateInfo.id,_currFloor);
				if(_currEntrustmentTemplateItem.fightNeeded < _myFight)
					break;
			}
			
			
			super();
			
			init();
			initEvent();
		}
		private function init():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.REELWIN,new Rectangle(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(23,31,236,340)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(120,4,42,20),new Bitmap(new syTitleAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,73,236,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(23,292,236,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,87,120,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,112,120,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,137,120,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,162,120,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,187,120,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,212,120,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(106,237,120,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,91,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustmentTag1"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,116,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustmentTag5"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,141,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustmentTag2"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,166,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustmentTag3"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,191,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.costCopper")+"：",MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,216,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustGetExp"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,241,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.role.extraAppend"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(45,266,80,16),new MAssetLabel(LanguageManager.getWord("ssztl.activity.entrustmentTag4"),MAssetLabel.LABEL_TYPE_TAG,"left")),
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,30);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-42,2);
			addChild(_btnClose);
			
			_duplicateNameLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_duplicateNameLabel.textColor = 0xffcc00;
			_duplicateNameLabel.move(141,46);
			addChild(_duplicateNameLabel);
			_duplicateNameLabel.setHtmlValue(_duplicateTemplateInfo.name);
			
			_fightNeededLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_fightNeededLabel.move(115,91);
			addChild(_fightNeededLabel);
			
			_floorField = new TextField();
			_floorField.defaultTextFormat = MAssetLabel.LABEL_TYPE20[0];
			_floorField.autoSize = TextFormatAlign.LEFT;
			_floorField.type = TextFieldType.INPUT;
			_floorField.width = 30;
			_floorField.height = 18;
			_floorField.text = _currFloor.toString();
			_floorField.x = 115;
			_floorField.y = 116;
			_floorField.textColor = 0xffffff;
			addChild(_floorField);
			
			_upBtn = new MBitmapButton(new SmallBtnAmountUpAsset());
			_upBtn.move(205,114);
			addChild(_upBtn);
			
			_downBtn = new MBitmapButton(new SmallBtnAmountDownAsset());
			_downBtn.move(205,123);
			addChild(_downBtn);
			
			_timesField = new TextField();
			_timesField.defaultTextFormat = MAssetLabel.LABEL_TYPE20[0];
			_timesField.autoSize = TextFormatAlign.LEFT;
			_timesField.type = TextFieldType.INPUT;
			_timesField.width = 30;
			_timesField.height = 18;
			_timesField.text = _times.toString();
			_timesField.x = 115;
			_timesField.y = 141;
			_timesField.textColor = 0xffffff;
			addChild(_timesField);
			
			_upBtn2 = new MBitmapButton(new SmallBtnAmountUpAsset());
			_upBtn2.move(205,139);
			addChild(_upBtn2);
			
			_downBtn2 = new MBitmapButton(new SmallBtnAmountDownAsset());
			_downBtn2.move(205,148);
			addChild(_downBtn2);
			
			_timeCostLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_timeCostLabel.move(115,166);
			addChild(_timeCostLabel);
			
			_copperCostLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE20,'left');
			_copperCostLabel.move(115,191);
			addChild(_copperCostLabel);
			
			_expRewardLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7,'left');
			_expRewardLabel.move(115,216);
			addChild(_expRewardLabel);
			
			_extraExpRewardLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE7,'left');
			_extraExpRewardLabel.move(115,241);
			addChild(_extraExpRewardLabel);
			
			_checkbox = new CheckBox();
			_checkbox.label = LanguageManager.getWord('ssztl.common.buy');
			_checkbox.move(115,274);
			addChild(_checkbox);
			
			_helpTip = new MSprite();
			_helpTip.graphics.beginFill(0,0);
			_helpTip.graphics.drawRect(115,294,72,17);
			_helpTip.graphics.endFill();
			addChild(_helpTip);
			
			_btnStart = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.start'));
			_btnStart.move(112,336);
			addChild(_btnStart);
			
			textFieldChangeHandler(null);
			setPanelPosition(null);
		}
		
		private function initEvent():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_upBtn.addEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.addEventListener(MouseEvent.CLICK,downClickHandler);
			_upBtn2.addEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn2.addEventListener(MouseEvent.CLICK,downClickHandler);
			_helpTip.addEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_helpTip.addEventListener(MouseEvent.MOUSE_OUT,tipOutHandler);
			
			
			_timesField.addEventListener(Event.CHANGE,textFieldChangeHandler);
			_floorField.addEventListener(Event.CHANGE,textFieldChangeHandler);
			_btnStart.addEventListener(MouseEvent.CLICK,btnStartClickHandler);
			_checkbox.addEventListener(Event.CHANGE,checkboxChangeHandler);
			
			GlobalData.entrustmentInfo.addEventListener(EntrustmentInfoEvent.IS_IN_ENTRUSTING,isInEntrustingHandler);
		}
		
		private function removeEvent():void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_upBtn.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_upBtn2.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_downBtn2.removeEventListener(MouseEvent.CLICK,downClickHandler);
			
			_timesField.removeEventListener(Event.CHANGE,textFieldChangeHandler);
			_floorField.removeEventListener(Event.CHANGE,textFieldChangeHandler);
			_btnStart.removeEventListener(MouseEvent.CLICK,btnStartClickHandler);
			_checkbox.removeEventListener(Event.CHANGE,checkboxChangeHandler);
			
			GlobalData.entrustmentInfo.removeEventListener(EntrustmentInfoEvent.IS_IN_ENTRUSTING,isInEntrustingHandler);
		}
		
		protected function isInEntrustingHandler(event:Event):void
		{
			if(GlobalData.entrustmentInfo.isInEntrusting)
				dispose();
		}
		
		protected function checkboxChangeHandler(event:Event):void
		{
			if(_checkbox.selected) _multiple = 1.5;
			else _multiple = 1;
			
			var totalMultiple:Number = _multiple+_vipMultiple;
			var add:Number = totalMultiple - 1;
			var addexp:int = int(_currEntrustmentTemplateItem.expReward * _times * add);
			var str:String = addexp + '[' + int(add*100) +'%]';
			_extraExpRewardLabel.setValue(str);
		}
		
		private function textFieldChangeHandler(e:Event):void
		{
			//加入次数，层数限制
			_times = int(_timesField.text);
			if(_times > _timesMax)
			{
				_times = _timesMax;
			}
			if(_times < 1)
			{
				_times = 1;
			}
			_timesField.text = _times.toString();
			
			_currFloor = int(_floorField.text);
			if(_currFloor > _floorMax)
			{
				_currFloor = _floorMax;
			}
			if(_currFloor < 1)
			{
				_currFloor = 1;
			}
			_floorField.text = _currFloor.toString();
			
			_currEntrustmentTemplateItem = EntrustmentTemplateList.getTemplate(_duplicateTemplateInfo.id,_currFloor);
			
			_fightNeededLabel.setValue(String(_currEntrustmentTemplateItem.fightNeeded));
			if(_currEntrustmentTemplateItem.fightNeeded > _myFight)
			{
				_fightNeededLabel.setLabelType(MAssetLabel.LABEL_TYPE6);
				_btnStart.enabled = false;
			}
			else
			{
				_fightNeededLabel.setLabelType(MAssetLabel.LABEL_TYPE1);
				_btnStart.enabled = true;
			}
			
			var second:int = _currEntrustmentTemplateItem.timeCost * _times;
			_timeCostLabel.setValue(DateUtil.getLeftTime(second));
			
			_copperCostLabel.setValue(String(_currEntrustmentTemplateItem.copperCost * _times));
			_expRewardLabel.setValue(int(_currEntrustmentTemplateItem.expReward * _times).toString());
			
			checkboxChangeHandler(null);
		}
		
		protected function btnStartClickHandler(event:MouseEvent):void
		{
			var itemId:int = 0;
			if(_checkbox.selected)
			{
				itemId = 206056;
			}
			StartEntrustingSocketHandler.send(_currEntrustmentTemplateItem.id,_times,itemId);
		}
		private function upClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(evt.currentTarget == _upBtn2)
			{
				_times++;
				if(_times > _timesMax)
				{
					_times = _timesMax;
				}
				_timesField.text = String(_times);
			}else
			{
				_currFloor++;
				if(_currFloor > _floorMax)
				{
					_currFloor = _floorMax;
				}
				_floorField.text = String(_currFloor);
			}
			
			textFieldChangeHandler(null);
		}
		
		private function helpTipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord('ssztl.pet.stairsRules'),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
			
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			if(evt.currentTarget == _downBtn2)
			{
				_times--;
				if(_times < 1)
				{
					_times = 1;
				}
				_timesField.text = String(_times);
			}else
			{
				_currFloor--;
				if(_currFloor < 1)
				{
					_currFloor = 1;
				}
				_floorField.text = String(_currFloor);
			}
			
			textFieldChangeHandler(null);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - this.width,parent.stage.stageHeight - this.height));
		}
		
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		
		public function doEscHandler():void
		{
			dispose();
		}
		
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		override public function dispose():void
		{
			super.dispose();
			
			_duplicateTemplateInfo = null;
			_currEntrustmentTemplateItem = null;
			_duplicateNameLabel = null;
			_fightNeededLabel = null;
			_floorField = null;
			_timesField = null;
			_timeCostLabel = null;
			_copperCostLabel = null;
			_expRewardLabel = null;
			if(_btnStart)
			{
				_btnStart.dispose();
				_btnStart = null;
			}
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}