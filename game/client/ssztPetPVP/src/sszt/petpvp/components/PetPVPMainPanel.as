package sszt.petpvp.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.petpvp.PetPVPLogItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.PetPVPModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.petpvp.PetPVPModule;
	import sszt.petpvp.components.cell.PetCell;
	import sszt.petpvp.data.PetPVPInfo;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.petpvp.events.PetPVPUIEvent;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.petPVP.BgAsset;
	import ssztui.petPVP.IconTipAsset;
	import ssztui.petPVP.TagAsset1;
	import ssztui.petPVP.TagAsset2;
	import ssztui.petPVP.TagAsset3;
	import ssztui.petPVP.TitleAsset;
	
	public class PetPVPMainPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private const TIMES_MAX:int = 10;
		private var _startChallengingHandler:Function;
		private var _addTimesHandler:Function;
		private var _clearCDHandler:Function;
		private var _getDailyRewardHandler:Function;
		
		private var _btnHelpExplain:Sprite;
		private var _petCellList:Array;
		private var _logViewItemList:Array;		
		private var _itemCellList:Array;
		private var _myPetList:Array;
		private var _rankView:PetPVPRankView;
		private var _myPetsTile:MTile;
		private var _challengeListView:PetPVPChallengeListView;
		private var _btnChallenge:MCacheAssetBtn1;
		private var _myPetDetailView:PetPVPPetDetailView;
		private var _oppnentPetDetailView:PetPVPPetDetailView;
		private var _logView:MScrollPanel;
		private var _timesLabel:MAssetLabel;
		private var _countdownView:CountDownView;
		private var _btnAddTimes:MCacheAssetBtn2;
		private var _btnClearCD:MCacheAssetBtn2;
		private var _btnGetReward:MCacheAssetBtn1;
		
		private var _currPetCell:PetCell;
		private var _currentLogViewHeight:int;
		
		private var _times:int;
		private var _seconds:int;
		private const _awardList:Array = [292400,292401,292402,292403]; 
		
		public function PetPVPMainPanel(startChallengingHandler:Function,addTimesHandler:Function,clearCDHandler:Function,getDailyRewardHandler:Function)
		{
			_startChallengingHandler = startChallengingHandler;
			_addTimesHandler = addTimesHandler;
			_clearCDHandler = clearCDHandler;
			_getDailyRewardHandler = getDailyRewardHandler;
			
			_itemCellList = [];
			_petCellList = [];
			_logViewItemList = [];
			
			super(new MCacheTitle1('',new Bitmap(new TitleAsset())), true, -1);
			initEvent();
		}
		
		private function initEvent():void
		{
			var petCell:PetCell;
			for each(petCell in _petCellList)
			{
				petCell.addEventListener(MouseEvent.CLICK,petCellClickHandler);
			}
			
			//_btnChallenge.addEventListener(MouseEvent.CLICK,_startChallengingHandler);
			_btnAddTimes.addEventListener(MouseEvent.CLICK,_addTimesHandler);
			_btnClearCD.addEventListener(MouseEvent.CLICK,_clearCDHandler);
			_btnGetReward.addEventListener(MouseEvent.CLICK,_getDailyRewardHandler);
			_btnHelpExplain.addEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_btnHelpExplain.addEventListener(MouseEvent.MOUSE_OUT,helpTipOutHandler);
		}
		
		private function removeEvent():void
		{
			var petCell:PetCell;
			for each(petCell in _petCellList)
			{
				petCell.removeEventListener(MouseEvent.CLICK,petCellClickHandler);
			}
			
			//_btnChallenge.removeEventListener(MouseEvent.CLICK,_startChallengingHandler);
			_btnAddTimes.removeEventListener(MouseEvent.CLICK,_addTimesHandler);
			_btnClearCD.removeEventListener(MouseEvent.CLICK,_clearCDHandler);
			_btnGetReward.removeEventListener(MouseEvent.CLICK,_getDailyRewardHandler);
			_btnHelpExplain.removeEventListener(MouseEvent.MOUSE_OVER,helpTipOverHandler);
			_btnHelpExplain.removeEventListener(MouseEvent.MOUSE_OUT,helpTipOutHandler);
		}		
		
		private function helpTipOverHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.petpvp.awardTip1"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		
		private function helpTipOutHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		protected function petCellClickHandler(event:MouseEvent):void
		{
			var targetCell:PetCell = event.currentTarget as PetCell;
			switchToPet(targetCell);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(736, 400);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,149,390)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(9,1,147,387)),
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(157,2,571,390)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(161,6,563,382)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(163,8,559,378),new Bitmap(new BgAsset())),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,31,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,101,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,171,141,2)),
				new BackgroundInfo(BackgroundType.LINE_1,new Rectangle(12,241,141,2)),
				
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(12,6,141,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(12,242,141,26)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(280,9,340,26)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(44,12,80,15),new Bitmap(new TagAsset1())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(52,248,65,15),new Bitmap(new TagAsset2())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(409,15,65,15),new Bitmap(new TagAsset3())),
				
				//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,277,15,15),new Bitmap(new IconTipAsset())),
				//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(9,277,147,16),new MAssetLabel(LanguageManager.getWord("ssztl.petpvp.getAwardTip"),MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(563,250,50,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.coolDownTime")+"：",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,40,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,110,50,50),new Bitmap(CellCaches.getCellBigBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(21,180,50,50),new Bitmap(CellCaches.getCellBigBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,269,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(63,269,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(104,269,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,309,38,38),new Bitmap(CellCaches.getCellBg())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(67,327,15,15),new Bitmap(new IconTipAsset())),
			]); 
			addContent(_bg as DisplayObject);
			
			_rankView = new PetPVPRankView();
			_rankView.move(12,30)
			addContent(_rankView);
			
			_challengeListView = new PetPVPChallengeListView();
			_challengeListView.move(200,111)
			addContent(_challengeListView);
			
			_myPetDetailView = new PetPVPPetDetailView();
			_myPetDetailView.move(400,0);
//			addContent(_myPetDetailView);
			
			_oppnentPetDetailView = new PetPVPPetDetailView();
			_oppnentPetDetailView.move(500,0);
//			addContent(_oppnentPetDetailView);
			
			_logView = new MScrollPanel();
//			_logView.mouseEnabled = _logView.getContainer().mouseEnabled = false;
			_logView.move(177,285);
			_logView.setSize(536,90);
			_logView.horizontalScrollPolicy = "off";
			_logView.verticalScrollPolicy = "auto";
			_logView.update();
			addContent(_logView);
			_currentLogViewHeight = 0;
			
//			_btnChallenge = new MCacheAssetBtn1(0,3,'challenge');
//			_btnChallenge.move(200,365);
//			addContent(_btnChallenge);
			
			_timesLabel = new MAssetLabel('',MAssetLabel.LABEL_TYPE1,'left');
			_timesLabel.move(207,250);
			addContent(_timesLabel);
			
			_countdownView = new CountDownView();
			_countdownView.move(623,250);
			addContent(_countdownView);
			_countdownView.setLabelType(MAssetLabel.LABEL_TYPE6[0]);
			_countdownView.addEventListener(Event.COMPLETE,completePay);
			
			_btnAddTimes = new MCacheAssetBtn2(0);
			_btnAddTimes.move(328,248);
			addContent(_btnAddTimes);
			
			_btnClearCD = new MCacheAssetBtn2(1);
			_btnClearCD.move(680,248);
			addContent(_btnClearCD);
			
			var x:int = 22;
			var y:int = 269;
			var itemCell:BaseItemInfoCell;
			for(var i:int =0; i< 4; i++)
			{
				if(i==3)
				{
					x=22;
					y=309;
				}
				itemCell = new BaseItemInfoCell();
				itemCell.info = ItemTemplateList.getTemplate(_awardList[i]);
				itemCell.locked = true;
				addContent(itemCell);
				itemCell.move(x,y);
				x = x+9+itemCell.width;	
				_itemCellList.push(itemCell);
			}
			
			_btnGetReward = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.common.getAward'));
			_btnGetReward.move(47,351);
			addContent(_btnGetReward);	
			
			var txtHelp:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			txtHelp.htmlText = "<u>"+LanguageManager.getWord("ssztl.petpvp.awardTip")+"</u>";
			txtHelp.move(84,327);
			addContent(txtHelp);
			_btnHelpExplain = new Sprite();
			_btnHelpExplain.graphics.beginFill(0xffffff,0);
			_btnHelpExplain.graphics.drawRect(49,327,100,17);
			_btnHelpExplain.graphics.endFill();
			_btnHelpExplain.buttonMode = true;
			addContent(_btnHelpExplain);
			
			_myPetList = GlobalData.petList.getList();
			var petCount:int = _myPetList.length;
			_myPetsTile = new MTile(50,50,_myPetList.length);
			_myPetsTile.setSize(_myPetList.length*55,50);
			_myPetsTile.itemGapH = _myPetsTile.itemGapW = 5;
			_myPetsTile.horizontalScrollPolicy = _myPetsTile.verticalScrollPolicy = ScrollPolicy.OFF;
			_myPetsTile.move(442-(_myPetList.length*55)/2,43);
			addContent(_myPetsTile);
			
			var cell:PetCell;
			var petItemInfo:PetItemInfo;
			for(i = 0; i < petCount; i++)
			{
				cell = new PetCell();
				petItemInfo = _myPetList[i];
				cell.info = petItemInfo.template;
				cell._id = petItemInfo.id;
				_myPetsTile.appendItem(cell);
				_petCellList.push(cell);
			}
		}
		
		public function updateTimes(times:int,totalTimes:int,seconds:int):void
		{
			_times = times;
			_seconds = seconds;
//			if(_seconds > 0)
			_timesLabel.setHtmlValue(LanguageManager.getWord("ssztl.petpvp.fightNumber", times, totalTimes));// + '/' + TIMES_MAX);
			_countdownView.start(seconds);
		}
		
		public function switchToFirstPet():void
		{
			switchToPet(_petCellList[0]);
		}
		
		private function switchToPet(cell:PetCell):void
		{
			if(_currPetCell == cell) return;
			if(_currPetCell)
				_currPetCell.selected = false;
			_currPetCell = cell;
			_currPetCell.selected = true;
			dispatchEvent(new PetPVPUIEvent(PetPVPUIEvent.PET_CELL_CHANGE,cell._id));
		}
		
		public function updateMyPetCell(myPets:Array):void
		{
			var cell:PetCell;
			for(var i:int = 0; i < myPets.length; i++)
			{
				cell = _petCellList[i];
				cell._petPvpPetItemInfo = myPets[i];
			}
		}		
		
		private function completePay(e:Event):void
		{
			_countdownView.textField.setTextFormat(MAssetLabel.LABEL_TYPE7[0]);
		}
		
		public function getCountDownTime():int
		{
			return _countdownView.getTimeToInt();
		}
		
		public function updateRankView(rankInfo:Array):void
		{
			_rankView.updateView(rankInfo);
		}
		
		public function updateChallengeListView(challengeInfo:Array):void
		{
			_challengeListView.updateView(challengeInfo);
		}
		
		private function clearLogView():void
		{
			for(var i:int =0;i<_logViewItemList.length;i++)
			{
				(_logViewItemList[i] as RichTextField).dispose();
				//_logViewItemList[i] = null;
			}
			_currentLogViewHeight = 0;
		}
		
		public function updateAwardList(awardState:Boolean,awardList:Array):void
		{			
			_btnGetReward.enabled = !awardState;
			var itemCell:BaseItemInfoCell;
			if(awardState == true)
			{
				for each(var cell:BaseItemInfoCell in _itemCellList)
				{
					cell.locked = true;
					//itemCell.itemInfo.count = 0;
				}
				return;
			}
			else
			{
				for(var i:int =0; i< awardList.length;i++)
				{
					if(awardList[i] != 0)
					{
						itemCell = _itemCellList[_awardList.indexOf(awardList[i])];
						itemCell.locked = false;
					}
				}
			}
		}
		
		public function updateLogView(logInfo:Array):void
		{
			var logInfoItem:PetPVPLogItemInfo;
			var logViewItem:RichTextField;
			clearLogView();
			for(var i:int = 0; i < logInfo.length; i++)
			{
				logInfoItem = logInfo[i];
				logViewItem = RichTextUtil.getPetPVPRichText(logInfoItem);
				
				
				_logView.getContainer().addChild(logViewItem);
				_logViewItemList.push(logViewItem);
				logViewItem.y = _currentLogViewHeight;
				_currentLogViewHeight += logViewItem.height-6;
			}
			
			_logView.getContainer().height = _currentLogViewHeight;
			_logView.update();
		}
		
		public function updateMyPetDetailView(info:PetPVPPetItemInfo):void
		{
			_myPetDetailView.updateView(info);
		}
		
		public function updateOppnentPetDetailView(info:PetPVPPetItemInfo):void
		{
			_oppnentPetDetailView.updateView(info);
		}
		
		public function get challengeListView():PetPVPChallengeListView
		{
			return _challengeListView;
		}
		
		override public function dispose():void
		{
			if(_btnGetReward.enabled == true)
			{
				ModuleEventDispatcher.dispatchPetPVPEvent(new PetPVPModuleEvent(PetPVPModuleEvent.UPDATE_ICON_VIEW,true));
			}
			if(_btnGetReward.enabled == false && _countdownView.getTimeToInt() > 0)
			{
				ModuleEventDispatcher.dispatchPetPVPEvent(new PetPVPModuleEvent(PetPVPModuleEvent.UPDATE_ICON_VIEW,false));
			}
			if(_times > 0)
			{
				ModuleEventDispatcher.dispatchPetPVPEvent(new PetPVPModuleEvent(PetPVPModuleEvent.UPDATE_COUNT_DOWN,_countdownView.getTimeToInt()));
			}
			removeEvent();
			super.dispose();
			if(_rankView)
			{
				_rankView.dispose();
				_rankView = null;
			}
			if(_myPetsTile)
			{
				_myPetsTile.disposeItems();
				_myPetsTile.dispose();
				_myPetsTile = null;
			}
			if(_challengeListView)
			{
				_challengeListView.dispose();
				_challengeListView = null;
			}
			if(_btnChallenge)
			{
				_btnChallenge.dispose();
				_btnChallenge = null;
			}
			if(_myPetDetailView)
			{
				_myPetDetailView.dispose();
				_myPetDetailView = null;
			}
			if(_oppnentPetDetailView)
			{
				_oppnentPetDetailView.dispose();
				_oppnentPetDetailView = null;
			}
			if(_logView)
			{
				_logView.dispose();
				_logView = null;
			}
			_timesLabel = null;
			if(_countdownView)
			{
				_countdownView.removeEventListener(Event.COMPLETE,completePay);
				_countdownView.dispose();
				_countdownView = null;
			}
		}
	}
}