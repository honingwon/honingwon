package sszt.scene.components.duplicate
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.challenge.ChallengeTemplateList;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.challenge.ChallengeTopInfoSocketHandler;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.countDownView.CountUpView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ChallengeEvent;
	import sszt.events.CommonModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.SceneMonsterList;
	import sszt.scene.data.duplicate.DuplicateChallInfo;
	import sszt.scene.events.SceneDuplicatePassUpdateEvent;
	import sszt.scene.events.SceneMonsterListUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyInfoSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.scene.FBLeaveBtnAsset;
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.scene.FBTaskBtnAsset;
	
	/**
	 * 试炼
	 * @author chendong
	 * 
	 */	
	public class DuplicateChallengePanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		private var _leaveBtn:MCacheAssetBtn1;
		
		private var _countDownView:CountDownView;
		private var _useTimeView:CountUpView;
		
		private var _passInfoView:MAssetLabel;	
		private var _dorpItemCells:Array;  //_lockCell:BaseItemInfoCell;
		private var _position:MAssetLabel;
		/**
		 * 霸主通关时间 
		 */		
		private var _overlordTime:MAssetLabel;
		/**
		 * 霸主名字 
		 */		
		private var _overlordName:MAssetLabel;
		private var _threeStarTime:MAssetLabel;
		private var _threeStarGift:MAssetLabel;
		private var _taskBtn:MAssetButton1;
		
		/**
		 * 该试炼副本总怪物数量 
		 */
		private var _totalMonsterNum:int;
		
		private var _countdonwinfo:CountDownInfo;
		
		public function DuplicateChallengePanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
			CopyInfoSocketHandler.send();
		}
		
		private function initialView():void
		{
			x = CommonConfig.GAME_WIDTH - 230;
			y = 190;
			mouseEnabled = false;
			
			_container = new Sprite();
			addChild(_container);
			_container.mouseEnabled = false;
			
			_background = new Shape();
			_background.graphics.beginFill(0x000000,0.5);
			_background.graphics.drawRect(0,0,208,10);
			_background.graphics.endFill();
//			var matr:Matrix = new Matrix();
//			matr.createGradientBox(260,280,Math.PI/2,0,10);
//			_background.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x000000],[0.70,0],[0,255],matr,SpreadMethod.PAD);
//			_background.graphics.drawRect(0,0,208,280);
			_container.addChild(_background);
			
			var pl:int = 22;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,300),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+3,4,182,17),new MAssetLabel(duplicateChallInfo.duplicateName ,MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,31,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.gateLeftMonster"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,85,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.gateLeftTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,103,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.gatePileTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,121,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.challenge.overLordTime"),MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,157,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyMissionDrop"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,229,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.challenge.threeStarTime"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,247,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.challenge.threeStarGift"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
			]);
			_container.addChild(_bg as DisplayObject);
			
			_taskBtn = new MAssetButton1(new FBTaskBtnAsset() as MovieClip);
			_taskBtn.x = 206;
			_container.addChild(_taskBtn);
			
			_position = new MAssetLabel(duplicateChallInfo.leftMonsterNum  +"/"+ duplicateChallInfo.missionInfo.monsterNum,MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_position.move(pl+96,31);
			_container.addChild(_position);
			
			_passInfoView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_passInfoView.move(pl+24,49);
			_passInfoView.htmlText = duplicateChallInfo.missionInfo.passInfo;
			_container.addChild(_passInfoView);
			
			
			//关卡剩余时间
			_countDownView = new CountDownView();
			_countDownView.setColor(0xffff00);
			_countDownView.move(pl+96,85);
			_container.addChild(_countDownView);
			
			//关卡累计时间
			_useTimeView = new CountUpView();
			_useTimeView.setColor(0x00ff00);
			_useTimeView.move(pl+96,103);
			_container.addChild(_useTimeView);
			_useTimeView.start(99000);

			//:霸主通关时间
			_overlordTime = new MAssetLabel("00:00:00",MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_overlordTime.move(pl+96,121);
			_container.addChild(_overlordTime);
			
			_overlordName = new MAssetLabel("名字",MAssetLabel.LABEL_TYPE24,TextFormatAlign.LEFT);
			_overlordName.move(pl+96,139);
			_container.addChild(_overlordName);
			
			_threeStarTime = new  MAssetLabel("00:00:00",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_threeStarTime.move(pl+96,229);
			_container.addChild(_threeStarTime);
			
			_threeStarGift = new  MAssetLabel("生命+10",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_threeStarGift.move(pl+96,247);
//			_container.addChild(_threeStarGift);
			
			_dorpItemCells = [];
			for(var i:int; i < 4 ; i++)
			{
				var cell:BaseItemInfoCell = new BaseItemInfoCell();
				var cellBg:Bitmap = new Bitmap(CellCaches.getCellBg());
				var x:int = pl+13 + i * 41;
				cellBg.x = x;
				cellBg.y = 180;
				cell.move(x, 180);
				_container.addChild(cellBg);
				_container.addChild(cell);
				_dorpItemCells.push(cell);
			}
			// 显示当前物品掉落信息
			var dorpItem:Array = duplicateChallInfo.missionInfo.dorpList;
			for(var n:int = 0; n < dorpItem.length; n++)
			{
				//				var item:ItemTemplateInfo  = ItemTemplateList.getTemplate(dorpItem[n]);
				var item:ItemInfo = new ItemInfo();
				item.templateId = int(dorpItem[n]);
				(_dorpItemCells[n] as BaseItemInfoCell).itemInfo = item;
			}
			
			_leaveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_leaveBtn.x = 90;
			_leaveBtn.y = 270;
			_container.addChild(_leaveBtn);
		}
		
		private function initialEvents():void
		{
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
			duplicateChallInfo.addEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_AWARD,updateAward);
			duplicateChallInfo.addEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_MONSTER,updateMonsterNum);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			
			ModuleEventDispatcher.addModuleEventListener(ChallengeEvent.CHALLENGE_TOP_INFO,challengeTopInfoDupChall);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function removeEvents():void
		{
			_leaveBtn.removeEventListener(MouseEvent.CLICK,quitDuplicate);
			duplicateChallInfo.removeEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_AWARD,updateAward);
			duplicateChallInfo.removeEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_MONSTER,updateMonsterNum);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			
			ModuleEventDispatcher.removeModuleEventListener(ChallengeEvent.CHALLENGE_TOP_INFO,challengeTopInfoDupChall);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function taskClickHandler(evt:MouseEvent):void
		{
			
		}
		private function taskOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.task"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function taskOutHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 230;
			y = 190;
		}
		private function updateCopyInfo(e:CommonModuleEvent):void
		{
			var data:IPackageIn = e.data as IPackageIn;
			var type:int = data.readShort();
			var missionId:int = data.readShort();
			var startTime:Number = data.readNumber();
			var time:Number =	int(GlobalData.systemDate.getSystemDate().getTime() / 1000);
			duplicateChallInfo.leftTime = duplicateChallInfo.leftTime - (time - startTime);
//			duplicateChallInfo.leftTime = (time - startTime);
			_countDownView.stop();
			_countDownView.start(duplicateChallInfo.leftTime);
//			_useTimeView.stop();
//			_useTimeView.start(1000);
			var num:int = data.readShort();
			for(var i:int = 0; i < num; i++)
			{
				data.readInt();
				data.readInt();
			}
			var killNum:int = data.readInt();
			if(killNum >=  duplicateChallInfo.missionInfo.monsterNum)
				updateAward(null);
			else
			{
				duplicateChallInfo.leftMonsterNum = duplicateChallInfo.missionInfo.monsterNum - killNum;
				updateMonsterNum(null);
			}
			
			var temp:ChallengeTemplateListInfo = ChallengeTemplateList.getChall(missionId);
			
			_countdonwinfo = DateUtil.getCountDownByHour(0,int(temp.threeTime) * 1000);
			var timeStr:String = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			_threeStarTime.text = timeStr;
			
			ChallengeTopInfoSocketHandler.send(missionId);
		}
		
		private function challengeTopInfoDupChall(evt:ModuleEvent):void
		{
			var tempPaZhuName:String = String(evt.data.pazhuName);
			if(tempPaZhuName != "")
			{
				_overlordName.text = tempPaZhuName;
			}
			else
			{
				_overlordName.text = LanguageManager.getWord("ssztl.challenge.noPazhu");
			}
			
			_countdonwinfo = DateUtil.getCountDownByHour(0,int(evt.data.timeNum) * 1000);
			var timeStr:String = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			_overlordTime.text = timeStr;
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		private function updateAward(e:SceneDuplicatePassUpdateEvent):void
		{
			duplicateChallInfo.passState = true;
		}
		private function updateMonsterNum(e:SceneDuplicatePassUpdateEvent):void
		{
			_position.htmlText = duplicateChallInfo.leftMonsterNum  +"/"+ duplicateChallInfo.missionInfo.monsterNum;
		}
		
		private function quitDuplicate(evt:Event):void
		{
			var message:String;
			if(GlobalData.copyEnterCountList.isPKCopy()&& GlobalData.selfPlayer.pkState == 0) message = LanguageManager.getWord("ssztl.scene.isSureBeLoser");
			else message = LanguageManager.getWord("ssztl.scene.isSureLeaveCopy");
			MAlert.show(message,LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK|MAlert.CANCEL,null,leaveAlertHandler);
			function leaveAlertHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{	
					_mediator.sceneInfo.playerList.self.setKillOne();
					CopyLeaveSocketHandler.send();
				}
			}
		}
		public function show():void
		{
			
		}
		public function hide():void
		{
			
		}
		public function get duplicateChallInfo():DuplicateChallInfo
		{
			return _mediator.duplicateChallInfo;
		}
		
		public function get monsterList():SceneMonsterList
		{
			return _mediator.monsterList;
		}
		
		public function dispose():void
		{
			removeEvents();
			duplicateChallInfo.clearData();
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
			if(_countDownView)
			{
				_countDownView.dispose();
				_countDownView = null;
			}
			if(_useTimeView)
			{
				_useTimeView.dispose();
				_useTimeView = null;
			}
			_background = null;
			_mediator = null;
			_container = null;	
			if(parent)parent.removeChild(this);
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
	}
}