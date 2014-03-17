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
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.duplicate.DuplicateMissionList;
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
	import sszt.scene.data.duplicate.DuplicatePassInfo;
	import sszt.scene.events.SceneDuplicatePassUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyInfoSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBLeaveBtnAsset;
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.scene.FBTaskBtnAsset;
	import ssztui.scene.FBTeamTipAsset;
	
	public class DuplicatePassPanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		private var _leaveBtn:MCacheAssetBtn1;
		private var _resetBtn:MCacheAssetBtn1;
		
		private var _countDownView:CountDownView;
		private var _useTimeView:CountUpView;
		
		private var _passInfoView:MAssetLabel;	
		private var _monsterNumView:MAssetLabel;
		private var _passAward:MAssetLabel;
		private var _passedView:MAssetLabel;
		private var _dorpItemCells:Array;  //_lockCell:BaseItemInfoCell;
		private var _position:MAssetLabel;
		
		private var _taskBtn:MAssetButton1;
		private var _overlordLabel:MAssetLabel;
		private var _overlord:MAssetLabel;
		private var _teamTip:MSprite;
		
		private var _countdonwinfo:CountDownInfo;
		
		public function DuplicatePassPanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
			_countDownView.start(duplicatePassInfo.leftTime);
//			_useTimeView.start(0);
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
//			matr.createGradientBox(260,260,Math.PI/2,0,10);
//			_background.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x000000],[0.70,0],[0,255],matr,SpreadMethod.PAD);
//			_background.graphics.drawRect(0,0,208,260);
			_container.addChild(_background);
			
			var pl:int = 22;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,335),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+3,4,182,17),new MAssetLabel(duplicatePassInfo.duplicateName ,MAssetLabel.LABEL_TYPE20)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,31,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyPosition"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,49,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.scene.overGateCondition"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,67,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.gateLeftMonster"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,85,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.gateLeftTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),	
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,103,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.gatePileTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),	
				//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,121,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.challenge.overLordTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,234,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyMissionDrop"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT))
				
			]);
			_container.addChild(_bg as DisplayObject);
			_taskBtn = new MAssetButton1(new FBTaskBtnAsset() as MovieClip);
			_taskBtn.x = 206;
			_container.addChild(_taskBtn);
			
			var count:int = DuplicateMissionList.getDuplicateMissionCount(duplicatePassInfo.mapId);
			_position = new MAssetLabel(LanguageManager.getWord("ssztl.rank.floorNum",duplicatePassInfo.mapId%100 + "/" + count),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_position.move(pl+48,31);
			_container.addChild(_position);
			
			_passAward = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_passAward.setLabelType([new TextFormat("SimSun",12,0xFFFCCC,null,null,null,null,null,null,null,null,null,6)]);
			_passAward.move(pl+12,141);
			_passAward.htmlText = 
				LanguageManager.getWord("ssztl.copy.missionRewardWord",duplicatePassInfo.missionInfo.awardExp,duplicatePassInfo.missionInfo.totalExp,
				duplicatePassInfo.missionInfo.awardLilian, duplicatePassInfo.missionInfo.totalLilian);
			_container.addChild(_passAward);
			
			_teamTip = new MSprite();
			_teamTip.move(pl+177,143);
//			_container.addChild(_teamTip);
			_teamTip.addChild(new Bitmap(new FBTeamTipAsset()));
			
			_passInfoView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_passInfoView.move(pl+72,49);
			_passInfoView.htmlText = duplicatePassInfo.missionInfo.passInfo;
			_container.addChild(_passInfoView);
			
			_monsterNumView = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_monsterNumView.setLabelType([new TextFormat("SimSun",12,0x00ff00,true)]);
			_monsterNumView.move(pl+96,67);
			_monsterNumView.htmlText = duplicatePassInfo.leftMonsterNum  +"/"+ duplicatePassInfo.missionInfo.monsterNum;
			_container.addChild(_monsterNumView);
			
			_passedView = new MAssetLabel(LanguageManager.getWord("ssztl.copy.finishMission"),MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_passedView.move(pl+96,67);
			_container.addChild(_passedView);
			if(duplicatePassInfo.missionInfo.monsterNum > 0)
			{
				_passedView.visible = false;
				_monsterNumView.visible = true;
			}
			else
			{
				_passedView.visible = true;
				_monsterNumView.visible = false;
			}
			
			_countDownView = new CountDownView();
			_countDownView.setColor(0x00ff00);
			_countDownView.move(pl+96,85);
			_container.addChild(_countDownView);
			
			_useTimeView = new CountUpView();
			_useTimeView.setColor(0x00ff00);
			_useTimeView.move(pl+96,103);
			_container.addChild(_useTimeView);
			_useTimeView.start(99000);
			
			//new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,121,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.challenge.overLordTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
			
			_overlordLabel = new MAssetLabel(LanguageManager.getWord("ssztl.challenge.overLordTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			_overlordLabel.move(pl+12,121);
			_container.addChild(_overlordLabel);
			_overlord = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_overlord.move(pl+96,121);
			_container.addChild(_overlord);
			_overlord.setHtmlValue("00:00:00"+"<font color='#ffcc00'>[霸主名]</font>");
			
			_dorpItemCells = [];
			for(var i:int; i < 4 ; i++)
			{
				var cell:BaseItemInfoCell = new BaseItemInfoCell();
				var cellBg:Bitmap = new Bitmap(CellCaches.getCellBg());
				var x:int = pl+13 + i * 41;
				cellBg.x = x;
				cellBg.y = 254;
				cell.move(x, 254);
				_container.addChild(cellBg);
				_container.addChild(cell);
				_dorpItemCells.push(cell);
			}
			// 显示当前物品掉落信息
			var dorpItem:Array = duplicatePassInfo.missionInfo.dorpList;
			for(var n:int = 0; n < dorpItem.length; n++)
			{
				//				var item:ItemTemplateInfo  = ItemTemplateList.getTemplate(dorpItem[n]);
				var item:ItemInfo = new ItemInfo();
				item.templateId = int(dorpItem[n]);
				(_dorpItemCells[n] as BaseItemInfoCell).itemInfo = item;
			}
			
			_resetBtn = new MCacheAssetBtn1(1,3,LanguageManager.getWord("ssztl.scene.copyReset"));
			_resetBtn.move(pl+55,248);
//			_container.addChild(_resetBtn);
			
			_leaveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_leaveBtn.x = 90;
			_leaveBtn.y = 300;
			_container.addChild(_leaveBtn);
		}
		
		private function initialEvents():void
		{
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
			duplicatePassInfo.addEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_AWARD,updateAward);
			duplicatePassInfo.addEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_MONSTER,updateMonsterNum);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			
			ModuleEventDispatcher.addModuleEventListener(ChallengeEvent.CHALLENGE_TOP_INFO,challengeTopInfoDupPass);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
			_teamTip.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_teamTip.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function removeEvents():void
		{
			_leaveBtn.removeEventListener(MouseEvent.CLICK,quitDuplicate);
			duplicatePassInfo.removeEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_AWARD,updateAward);
			duplicatePassInfo.removeEventListener(SceneDuplicatePassUpdateEvent.DUPLICATE_PASS_UPDATE_MONSTER,updateMonsterNum);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			
			ModuleEventDispatcher.removeModuleEventListener(ChallengeEvent.CHALLENGE_TOP_INFO,challengeTopInfoDupPass);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
			_teamTip.addEventListener(MouseEvent.MOUSE_OVER,tipOverHandler);
			_teamTip.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function taskClickHandler(evt:MouseEvent):void
		{
			
		}
		private function taskOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.task"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function tipOverHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.passTeamTip"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
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
			duplicatePassInfo.leftTime = duplicatePassInfo.leftTime - (time - startTime);
			_countDownView.stop();
			_countDownView.start(duplicatePassInfo.leftTime);
			_useTimeView.setStartTime(time - startTime);
			var num:int = data.readShort();
			for(var i:int = 0; i < num; i++)
			{
				data.readInt();
				data.readInt();
			}
			var killNum:int = data.readInt();
			if(killNum >=  duplicatePassInfo.missionInfo.monsterNum)
				updateAward(null);
			else
			{
				duplicatePassInfo.leftMonsterNum = duplicatePassInfo.missionInfo.monsterNum - killNum;
				updateMonsterNum(null);
			}
			var duplicateId:int = data.readInt();
			ChallengeTopInfoSocketHandler.send(missionId,duplicateId);
		}
		
		private function challengeTopInfoDupPass(evt:ModuleEvent):void
		{
			_countdonwinfo = DateUtil.getCountDownByHour(0,int(evt.data.timeNum) * 1000);
			var timeStr:String = getIntToString(_countdonwinfo.hours) + ":" + getIntToString(_countdonwinfo.minutes) + ":" + getIntToString(_countdonwinfo.seconds);
			var tempPaZhuName:String = String(evt.data.pazhuName);
			if(tempPaZhuName != "")
			{
				_overlord.setHtmlValue(timeStr+"<font color='#ffcc00'>["+ tempPaZhuName +"]</font>");
			}
			else
			{
				_overlordLabel.visible = false;
				_overlord.visible = false;
				//_overlord.setHtmlValue(timeStr+"<font color='#ffcc00'>["+ LanguageManager.getWord("ssztl.challenge.noPazhu") +"]</font>");
			}
		}
		
		protected function getIntToString(value:int):String
		{
			if(value > 9)return String(value);
			return "0" + value;
		}
		
		private function updateAward(e:SceneDuplicatePassUpdateEvent):void
		{
			duplicatePassInfo.passState = true;
			_passedView.visible = true;
			_monsterNumView.visible = false;
			_passAward.htmlText = LanguageManager.getWord("ssztl.copy.missionRewardWord",
				duplicatePassInfo.missionInfo.awardExp,duplicatePassInfo.missionInfo.totalExp + duplicatePassInfo.missionInfo.awardExp,
				duplicatePassInfo.missionInfo.awardLilian, duplicatePassInfo.missionInfo.totalLilian + duplicatePassInfo.missionInfo.awardLilian);
		}
		private function updateMonsterNum(e:SceneDuplicatePassUpdateEvent):void
		{
			_monsterNumView.htmlText = duplicatePassInfo.leftMonsterNum  +"/"+ duplicatePassInfo.missionInfo.monsterNum;
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
		public function get duplicatePassInfo():DuplicatePassInfo
		{
			return _mediator.duplicatePassInfo;
		}
		public function dispose():void
		{
			removeEvents();
			duplicatePassInfo.clearData();
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