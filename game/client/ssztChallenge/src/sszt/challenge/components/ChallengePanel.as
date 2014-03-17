package sszt.challenge.components
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.challenge.mediator.ChallengeMediator;
	import sszt.challenge.socketHandlers.ChallengeEnterSocketHandler;
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.challenge.ChallengeInfo;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.challenge.ChallengeTopInfoSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.AmountFlashView;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ChallengeEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.challenge.NumberAsset0;
	import ssztui.challenge.NumberAsset1;
	import ssztui.challenge.NumberAsset2;
	import ssztui.challenge.NumberAsset3;
	import ssztui.challenge.NumberAsset4;
	import ssztui.challenge.NumberAsset5;
	import ssztui.challenge.NumberAsset6;
	import ssztui.challenge.NumberAsset7;
	import ssztui.challenge.NumberAsset8;
	import ssztui.challenge.NumberAsset9;
	import ssztui.challenge.RewardBoxAsset;
	import ssztui.challenge.TabFloorAsset1;
	import ssztui.challenge.TabFloorAsset2;
	import ssztui.challenge.TabFloorAsset3;
	import ssztui.challenge.TabFloorAsset4;
	import ssztui.challenge.TabFloorAsset5;
	import ssztui.challenge.TabFloorAsset6;
	import ssztui.challenge.TabFloorAsset7;
	import ssztui.challenge.TagAsset2;
	import ssztui.challenge.TitleAsset;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class ChallengePanel extends MPanel
	{
		private var _mediator:ChallengeMediator;
		
		private var _bg:IMovieWrapper;
		private var _imgBg:Bitmap;
		private var _imgGate:Bitmap;
		/**
		 * 层按钮 
		 */
		private var _cengBtn:Array;
		/**
		 * 层按钮坐标位置 
		 */
		private var _cengBtnPostion:Array;
		/**
		 *当前层 
		 */
		private var _currentCeng:int = -1;
		/**
		 *当前关卡 
		 */
		private var _currentMark:int = -1;
		/**
		 * 当前关口是否打开 
		 */
		private var _currentMarkOpen:Boolean = false;
		private var _showTollGate:MSprite;
		/**
		 * 上页
		 */
//		private var _btnUp:MCacheAssetBtn1;
		
		/**
		 * 下页
		 */
//		private var _btnDown:MCacheAssetBtn1;
		/**
		 * 关卡 MTile 
		 */		
		private var _tile:MTile;
		private var _tileArray:Array;
		
		/**
		 * 挑战按钮 
		 */
		private var _challengeBtn:MCacheAssetBtn1;
		/**
		 *副本说明
		 */
		private var _duplicateNote:MAssetLabel;
		
		
		/**
		 * 每天前10次才有评价奖励(1/10) 今日有奖挑战次数：
		 */
		private var _rewardLable:MAssetLabel;
		/**
		 * 查看排行 
		 */
		private var _checkRankBtn:MCacheAssetBtn1;
		
		/**
		 * 成就奖励
		 */
		private var _targetBtn:MCacheAssetBtn1;
		private var _targetAmount:AmountFlashView;
		
		/**
		 * 霸主:波波(68级)
		 */
		private var _overlord:MAssetLabel;
		/**
		 * 通关时间:00:00:00
		 */
		private var _passTime:MAssetLabel;
		
		private var _overlordGiftText:MAssetLabel;
		
		/**
		 * 霸主礼包 
		 */
		private var _bazhuCell:Cell;
		private var _rewardBox:MAssetButton1;
		/**
		 * 注释:霸主信息每日0点清空 
		 */
		private var _notes:MAssetLabel;
		/**
		 * 掉落物品
		 */		
		private var _tile2:MTile;
		private var _tile2Array:Array;
		
		public static const PANEL_WIDTH:int = 588;
		public static const PANEL_HEIGHT:int = 470;
		
		private var _countdonwinfo:CountDownInfo;
		
		public function ChallengePanel(mediator:ChallengeMediator)
		{
			super(new MCacheTitle1("",new Bitmap(new TitleAsset())),true,-1,true,true);
			_mediator = mediator;
			initEvent();
			initData();
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(PANEL_WIDTH,PANEL_HEIGHT);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,PANEL_WIDTH-16,PANEL_HEIGHT-10)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,384,452)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(397,6,179,452)),
				new BackgroundInfo(BackgroundType.BAR_2,new Rectangle(398,252,177,26)),//286
				
//				new BackgroundInfo(BackgroundType.BORDER_14,new Rectangle(404,169,166,57)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(413,179,38,38),new Bitmap(CellCaches.getCellBg())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(455,257,62,15),new Bitmap(new TagAsset2())),
				
			]);
			addContent(_bg as DisplayObject);
			
			_imgBg = new Bitmap();
			_imgBg.x = 14;
			_imgBg.y = 8;
			addContent(_imgBg);
			
			_imgGate = new Bitmap();
			_imgGate.x = 399;
			_imgGate.y = 8;
			addContent(_imgGate);
			
			var tabClass:Array = [TabFloorAsset1,TabFloorAsset2,TabFloorAsset3,TabFloorAsset4,TabFloorAsset5,TabFloorAsset6,TabFloorAsset7];
			_cengBtn = [];
			
			for(var i:int = 0;i < ChallengeInfo.LAYER_NUM;i++)
			{
				var tab:MSelectButton = new MSelectButton(new tabClass[i]());
				tab.move(27+i*52,26);
				_cengBtn.push(tab);
				addContent(tab);	
			}
			
			_tileArray = [];
			_tile = new MTile(104,100,3);
			_tile.setSize(340,235);
			_tile.move(36,68);
			_tile.itemGapW = 11;
			_tile.itemGapH = 10;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPosition = 24;
			addContent(_tile);
			
			_showTollGate = new MSprite();
			addContent(_showTollGate);
			
//			_btnUp = new MCacheAssetBtn1(0,1,LanguageManager.getWord("上一页"));
//			_btnUp.move(0,0);
//			
//			_btnDown = new MCacheAssetBtn1(0,1,LanguageManager.getWord("下一页"));
//			_btnDown.move(0,0);
			
			_challengeBtn = new MCacheAssetBtn1(2,0,LanguageManager.getWord("ssztl.challenge.dare"));
			_challengeBtn.move(154,310);
			addContent(_challengeBtn);
			
			_checkRankBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.challenge.seeRank"));
			_checkRankBtn.move(414,213);
			addContent(_checkRankBtn);
			
			_targetBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.challenge.achAeward"));
			_targetBtn.move(487,213);
			addContent(_targetBtn);
			
//			程序员看这里：显示试炼可领的数量。
			setAchievementNum(0);
			
			_rewardLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE_YAHEI);
			_rewardLable.textColor = 0xffcc33;
			_rewardLable.move(204,350);
			addContent(_rewardLable);
			
			_duplicateNote = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
			_duplicateNote.setLabelType([new TextFormat("SimSun",12,0xae9b6f,false,null,null,null,null,null,null,null,null,6)]);
			_duplicateNote.wordWrap = true;
			_duplicateNote.setSize(360,76);
			_duplicateNote.move(28,375);
			addContent(_duplicateNote);
			_duplicateNote.setHtmlValue(LanguageManager.getWord("ssztl.challenge.achLabel",5));
			
			_overlord = new MAssetLabel("", MAssetLabel.LABEL_TYPE_YAHEI);
			_overlord.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),18,0xffff00,true)]);
			_overlord.move(486,165);
			addContent(_overlord);
			
			_passTime = new MAssetLabel("", MAssetLabel.LABEL_TYPE_YAHEI);
			_passTime.textColor = 0xee8d5f;
			_passTime.move(486,145);
			addContent(_passTime);
			
			_bazhuCell = new Cell();
			_bazhuCell.move(413,179);
//			addContent(_bazhuCell);
			
			_rewardBox = new MAssetButton1(new RewardBoxAsset() as MovieClip);
			_rewardBox.move(465,74);
			addContent(_rewardBox);
			
			_overlordGiftText = new MAssetLabel("",MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_overlordGiftText.move(460,188);
			addContent(_overlordGiftText);
			
			_notes = new MAssetLabel(LanguageManager.getWord("ssztl.challenge.overlordInfoTip"), MAssetLabel.LABEL_TYPE_TAG, TextFormatAlign.LEFT);
			_notes.move(408,234);
//			addContent(_notes);
			
			_tile2Array = [];
			_tile2 = new MTile(38,38,4);
			_tile2.setSize(158,158);
			_tile2.move(409,284);
			_tile2.itemGapW = _tile2.itemGapH = 2;
			_tile2.horizontalScrollPolicy = _tile2.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_tile2);
			
//			initMark();
		}
		
		private function initEvent():void
		{
			var i:int=0
			for(;i<ChallengeInfo.LAYER_NUM;i++)
			{
				_cengBtn[i].addEventListener(MouseEvent.CLICK,changeCeng);
			}
//			i = 0;
//			for(;i<ChallengeUtils.CENG_NUM;i++)
//			{
//				_tileArray[i].addEventListener(MouseEvent.CLICK,changeMark);
//			}
			
//			_btnUp.addEventListener(MouseEvent.CLICK,upClick);
//			_btnDown.addEventListener(MouseEvent.CLICK,downClick);
			_challengeBtn.addEventListener(MouseEvent.CLICK,challengeClick);
			_checkRankBtn.addEventListener(MouseEvent.CLICK,checkRankClick);
			_targetBtn.addEventListener(MouseEvent.CLICK,targetClick);
			
			_rewardBox.addEventListener(MouseEvent.MOUSE_OVER,rewardOverHandler);
			_rewardBox.addEventListener(MouseEvent.MOUSE_OUT,rewardOutHandler);
			
			ModuleEventDispatcher.addModuleEventListener(ChallengeEvent.CHALLENGE_BOSS_INFO,challengeBossInfo);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneChall);
			ModuleEventDispatcher.addModuleEventListener(ChallengeEvent.CHALLENGE_TOP_INFO,challengeTopInfo);
		}
		
		private function initData():void
		{
//			initMark();
		}
		private function setAchievementNum(num:int):void
		{
			if(num > 0)
			{
				if(!_targetAmount)
				{
					_targetAmount = new AmountFlashView();
					_targetAmount.move(544,206);
					addContent(_targetAmount);
				}
				_targetAmount.setValue(num.toString());
				
			}else{
				if(_targetAmount && _targetAmount.parent)
				{
					_targetAmount.parent.removeChild(_targetAmount);
					_targetAmount = null;
				}
			}
		}
		
		private function rewardOverHandler(evt:MouseEvent):void
		{
			if(_bazhuCell.info)TipsUtil.getInstance().show(_bazhuCell.itemInfo,null,new Rectangle(this.localToGlobal(new Point(_rewardBox.x,_rewardBox.y)).x,this.localToGlobal(new Point(_rewardBox.x,_rewardBox.y)).y,_rewardBox.width,_rewardBox.height));
		}
		
		private function rewardOutHandler(evt:MouseEvent):void
		{
			if(_bazhuCell.info)TipsUtil.getInstance().hide();
		}
		
		private function setCeng(index:int):void
		{
			if(_currentCeng == index)return;
			if(_currentCeng > -1)
			{
				_cengBtn[_currentCeng].selected = false;
			}
			_currentCeng = index;
			_cengBtn[_currentCeng].selected = true;
		}
		
		private function setMark(index:int):void
		{
			if(_currentMark == index)return;
			if(_currentMark > -1)
			{
				_tileArray[_currentMark].selected = false;
			}
			_currentMark = index;
			_tileArray[_currentMark].selected = true;
		}
		
		/**
		 * 点击选中试练层事件 
		 * @param evt
		 * 
		 */
		private function changeCeng(evt:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var index:int = _cengBtn.indexOf(evt.currentTarget);
			if(index == _currentCeng)
				return;
			if(!ChallengeUtils.preLayerOver(index))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.challenge.needPassLayer"));
				_cengBtn[index].selected = false;
				return;
			}
			else
			{
				setCurrentCengSelect(index);
			}
		}
		
		/**
		 * 点击选中关卡事件 
		 * @param evt
		 * 
		 */
		private function changeMark(evt:MouseEvent):void
		{
			var index:int = _tileArray.indexOf(evt.currentTarget);
			if(index == _currentMark)
				return;
			if((_currentCeng != 0 || index != 0  ) && !ChallengeUtils.getCurrMarkPreOpen(_currentCeng,index,false))
			{
				QuickTips.show(LanguageManager.getWord("ssztl.challenge.needPassMakr",index+_currentCeng*ChallengeInfo.MARK_LAYER_NUM));
				return;
			}
			setCurrentMarkSelect(index);
		}
		
		private function challengeBossInfo(evt:ModuleEvent):void
		{
			setCeng(ChallengeUtils.getCurrentLayer());
//			setCurrentCengSelect(ChallengeUtils.getCurrentCeng());
			initMark();
			setMark(ChallengeUtils.getCurrentLayerLastMark(_currentCeng))
			setCurrentCengAndMark();
			_rewardLable.setHtmlValue(LanguageManager.getWord("ssztl.challenge.rankLabel",10-GlobalData.challInfo.num));
		}
		
		private function changeSceneChall(evt:SceneModuleEvent):void
		{
			dispose();
		}
		
		private function challengeTopInfo(evt:ModuleEvent):void
		{
			var tempPaZhuName:String = String(evt.data.pazhuName);
			if(tempPaZhuName != "")
			{
				_overlord.text = tempPaZhuName;
			}
			else
			{
				_overlord.text = LanguageManager.getWord("ssztl.challenge.noPazhu");
			}
			
			_countdonwinfo = DateUtil.getCountDownByHour(0,int(evt.data.timeNum) * 1000);
			var timeStr:String = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			_passTime.setHtmlValue(LanguageManager.getWord("ssztl.rank.passTime")+"：<font color='#a8ff00'>" + timeStr + "</font>");
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		/**
		 * 设置当前层下关卡信息,如评星等级、是否开启、关卡名称
		 */
		private function setCurrentCengAndMark():void
		{
			
//			initMark();
			var i:int = 0;
			var markIndex:int = 0;
			for(;i<_tileArray.length; i++)
			{
				markIndex = _currentCeng*ChallengeInfo.MARK_LAYER_NUM + i;
				_tileArray[i].starLevel = ChallengeUtils.getCurrentMarkStar(_currentCeng,i);
				_tileArray[i].markName.setValue(LanguageManager.getWord("ssztl.challenge.currentMark",(markIndex + 1)));
				_tileArray[i].preMarkBoolean = ChallengeUtils.getCurrMarkPreOpen(_currentCeng,i); 
			}
			
			if(GlobalData.selfPlayer.level >= 40)
			{
				if(_currentCeng == 0) //第一层，第一个关默认开启
				{
					_tileArray[0].markHead.visible = true;
					_tileArray[0].lockMask.visible = false;
				}
			}
			
			setTollGate((getCurrentIndex()+1));
			getCurrentMarkOpen(); 
			bazhuItem();
			setDropItem();
			
			var challTemp:ChallengeTemplateListInfo = ChallengeUtils.getChallengeTemplateInfoBy(getCurrentIndex());
			ChallengeTopInfoSocketHandler.send(challTemp.challengeId);
			
			
		}
		
		/**
		 * 判断当前关口是否打开
		 */		
		private function getCurrentMarkOpen():void
		{
			var challItem:ChallengeItemView = _tileArray[_currentMark];
			if(challItem.starLevel > 0 || challItem.lockMask.visible == false)
			{
				_currentMarkOpen = true;
			}
			else
			{
				_currentMarkOpen = false;
			}
		}
		
		/**
		 *霸主礼包 
		 */
		private function bazhuItem():void
		{
			var challTemplateListInfo:ChallengeTemplateListInfo = ChallengeTemplateList.getChallByIndex(getCurrentIndex());
			var giftInt:int = challTemplateListInfo.gift;
			var itemInfo:ItemInfo;
			itemInfo = new ItemInfo();
			itemInfo.templateId = giftInt;
			_bazhuCell.itemInfo = itemInfo;
		}
		
		/**
		 * 设置掉落物品
		 */
		private function setDropItem():void
		{
			clearDropData();
			var challTemplateListInfo:ChallengeTemplateListInfo = ChallengeTemplateList.getChallByIndex(getCurrentIndex());
			var dropArray:Array = challTemplateListInfo.dropArray;
			
			var cell:Cell;
			var itemInfo:ItemInfo;
			var i:int = 0;
			for(;i<dropArray.length;i++)
			{
				cell = new Cell();
				itemInfo = new ItemInfo();
				itemInfo.templateId = int(dropArray[i]);
				cell.itemInfo = itemInfo;
				_tile2.appendItem(cell);
				_tile2Array.push(cell);
			}
		}
		
		/**
		 * 获得当前关卡模板序列号 
		 * @return 
		 * 
		 */
		private function getCurrentIndex():int
		{
			return (_currentCeng*ChallengeInfo.MARK_LAYER_NUM + _currentMark);
		}
		
		private function upClick(evt:MouseEvent):void
		{
			
		}
		
		private function downClick(evt:MouseEvent):void
		{
			
		}
		
		private function challengeClick(evt:MouseEvent):void
		{
			if(GlobalData.currentMapId >= 1001 && GlobalData.currentMapId <= 1999)
			{
				if(GlobalData.selfPlayer.level >= 40)
				{
					if(_currentMarkOpen)
					{
						var currIndex:int = _currentCeng*ChallengeInfo.MARK_LAYER_NUM + _currentMark;
						var challInfo:ChallengeTemplateListInfo = ChallengeTemplateList.getChallByIndex(currIndex);
						ChallengeEnterSocketHandler.send(challInfo.challengeId);
						dispose();
					}
					else
					{
						QuickTips.show(LanguageManager.getWord("ssztl.challenge.currentMarkOpen"));
					}
				}
				else
				{
					QuickTips.show(LanguageManager.getWord("ssztl.challenge.levelNoEnough"));
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.scene.leaveCurrentScene"));
			}
		}
		
		private function checkRankClick(evt:MouseEvent):void
		{
			SetModuleUtils.addRank();
		}
		
		private function targetClick(evt:MouseEvent):void
		{
			SetModuleUtils.addTarget(1,8);
		}
		
		/**
		 * 设置选择层
		 * @param currCeng 当前层
		 * 
		 */
		private function setCurrentCengSelect(currCeng:int=0):void
		{
			_cengBtn[_currentCeng].selected = false;
			_cengBtn[currCeng].selected = true;
			_currentCeng = currCeng;
			initMark();
			setCurrentMarkSelect(ChallengeUtils.getCurrentLayerLastMark(_currentCeng));
		}
		
		/**
		 * 设置当前关卡
		 * @param currMark 当前关卡
		 * 
		 */
		private function setCurrentMarkSelect(currMark:int=0):void
		{
			_tileArray[_currentMark].selected = false;
			_tileArray[currMark].selected = true;
			_currentMark = currMark;
			setCurrentCengAndMark();
		}
		
		private function initMark(currCeng:int=0):void
		{
			clearData();
			var markArray:Array = ChallengeUtils.getMarkArrayByCeng(_currentCeng);
			var challInfo:ChallengeTemplateListInfo;
			var challItem:ChallengeItemView;
			for(var i:int = 0;i < markArray.length;i++)
			{
				challInfo = markArray[i]
				challItem = new ChallengeItemView(challInfo);
				_tile.appendItem(challItem);
				_tileArray.push(challItem);
				_tileArray[i].addEventListener(MouseEvent.CLICK,changeMark);
			}
		}
		
		private function removeEvent():void
		{ 
			var i:int=0
			for(;i<ChallengeInfo.LAYER_NUM;i++){
				_cengBtn[i].removeEventListener(MouseEvent.CLICK,changeCeng);
			}
			i = 0;
			for(;i<ChallengeInfo.MARK_LAYER_NUM;i++)
			{
				_tileArray[i].removeEventListener(MouseEvent.CLICK,changeMark);
			}
			
//			_btnUp.removeEventListener(MouseEvent.CLICK,upClick);
//			_btnDown.removeEventListener(MouseEvent.CLICK,downClick);
			_challengeBtn.removeEventListener(MouseEvent.CLICK,challengeClick);
			_checkRankBtn.removeEventListener(MouseEvent.CLICK,checkRankClick);
			_targetBtn.removeEventListener(MouseEvent.CLICK,targetClick);
			
			_rewardBox.removeEventListener(MouseEvent.MOUSE_OVER,rewardOverHandler);
			_rewardBox.removeEventListener(MouseEvent.MOUSE_OUT,rewardOutHandler);
			
			ModuleEventDispatcher.removeModuleEventListener(ChallengeEvent.CHALLENGE_BOSS_INFO,challengeBossInfo);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.CHANGE_SCENE,changeSceneChall);
			ModuleEventDispatcher.removeModuleEventListener(ChallengeEvent.CHALLENGE_TOP_INFO,challengeTopInfo);
		}
		private function itemOverHandler(e:MouseEvent):void
		{
			var ob:ChallengeItemView = e.currentTarget as ChallengeItemView;
			setBrightness(ob,0.08);
		}
		private function itemOutHandler(e:MouseEvent):void
		{
			var ob:ChallengeItemView = e.currentTarget as ChallengeItemView;
			setBrightness(ob,0);
		}
		
		private function clearData():void
		{
			var i:int = 0;
			if (_tileArray)
			{
				while (i < _tileArray.length)
				{
					
					_tileArray[i].dispose();
					i++;
				}
				_tileArray = [];
			}
			if(_tile)
			{
				_tile.disposeItems();
			}
			clearDropData();
		}
		
		private function clearDropData():void
		{
			var i:int = 0;
			if (_tile2Array)
			{
				while (i < _tile2Array.length)
				{
					
					_tile2Array[i].dispose();
					i++;
				}
				_tile2Array = [];
			}
			if(_tile2)
			{
				_tile2.disposeItems();
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			clearData();
			_mediator = null;			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_imgBg && _imgBg.bitmapData)
			{
				_imgBg.bitmapData.dispose();
				_imgBg = null;
			}
			if(_imgGate && _imgGate.bitmapData)
			{
				_imgGate.bitmapData.dispose();
				_imgGate = null;
			}
			if(_showTollGate && _showTollGate.parent)
			{
				while(_showTollGate && _showTollGate.numChildren>0){
					_showTollGate.removeChildAt(0);
				}
				_showTollGate.parent.removeChild(_showTollGate);
				_showTollGate = null;
			}
			if(_targetAmount && _targetAmount.parent)
			{
				_targetAmount.parent.removeChild(_targetAmount);
				_targetAmount = null;
			}
			dispatchEvent(new Event(Event.CLOSE));
			super.dispose();
		}
		
		public function assetsCompleteHandler():void
		{
			_imgBg.bitmapData = AssetUtil.getAsset("ssztui.challenge.BgAsset",BitmapData) as BitmapData;
			_imgGate.bitmapData = AssetUtil.getAsset("ssztui.challenge.BgGateAsset",BitmapData) as BitmapData;
		}
		//value取值范围-1~1,对应Flash内容制作工具里的-100%-100%
		public static function setBrightness(obj:DisplayObject,value:Number):void {
			var colorTransformer:ColorTransform = obj.transform.colorTransform;
			var backup_filters:* = obj.filters;
			if (value >= 0) {
				colorTransformer.blueMultiplier = 1-value;
				colorTransformer.redMultiplier = 1-value;
				colorTransformer.greenMultiplier = 1-value;
				colorTransformer.redOffset = 255*value;
				colorTransformer.greenOffset = 255*value;
				colorTransformer.blueOffset = 255*value;
			}
			else {
				value=Math.abs(value)
				colorTransformer.blueMultiplier = 1-value;
				colorTransformer.redMultiplier = 1-value;
				colorTransformer.greenMultiplier = 1-value;
				colorTransformer.redOffset = 0;
				colorTransformer.greenOffset = 0;
				colorTransformer.blueOffset = 0;
			}
			obj.transform.colorTransform = colorTransformer;
			obj.filters = backup_filters;
		}
		/**
		 * 显示选择关卡数字
		 */
		private var _numberClass:Array = [NumberAsset0,NumberAsset1,NumberAsset2,NumberAsset3,NumberAsset4,NumberAsset5,NumberAsset6,NumberAsset7,NumberAsset8,NumberAsset9];
		private function setTollGate(n:int):void
		{
			while(_showTollGate && _showTollGate.numChildren>0){
				_showTollGate.removeChildAt(0);
			}
			var f:String = n.toString();
			for(var i:int=0; i<f.length; i++)
			{
				var mc:Bitmap = new Bitmap(new _numberClass[int(f.charAt(i))]() as BitmapData);
				mc.x = _showTollGate.width; 
				_showTollGate.addChild(mc);
			}
			_showTollGate.move(490-_showTollGate.width/2,35);
		}
	}
}