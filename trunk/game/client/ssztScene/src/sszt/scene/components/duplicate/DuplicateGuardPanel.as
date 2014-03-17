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
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountUpView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.data.duplicate.DuplicateGuardInfo;
	import sszt.scene.events.SceneDuplicateGuardUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.CopyInfoSocketHandler;
	import sszt.scene.socketHandlers.CopyLeaveSocketHandler;
	import sszt.scene.socketHandlers.duplicate.CopyCanOpenNextMonsterSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.scene.FBAmountBgAsset;
	import ssztui.scene.FBBallBgAsset;
	import ssztui.scene.FBLeaveBtnAsset;
	import ssztui.scene.FBNextBtnAsset;
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.scene.FBTaskBtnAsset;
	import ssztui.scene.FBTimerShowAsset;
	
	public class DuplicateGuardPanel extends Sprite implements ITick
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		private var _leaveBtn:MCacheAssetBtn1;
//		private var _timerTrack:MovieClip;
//		private var _timeTrack:Sprite;
//		private var _timeBar:ProgressBar1;
		
		private var _openBtn:MCacheAssetBtn1;
		private var _useTimeView:CountUpView;
		
		private var _monsterTimesTxt:MAssetLabel;	//当前波数
		private var _expTxt:MAssetLabel;		//累计经验
		private var _bindCopperTxt:MAssetLabel;//累计铜币
		private var _comeTickTime:int;
		private var _tick:int;
		private var _comeTime:int;
		private var _taskBtn:MAssetButton1;
		
		public function DuplicateGuardPanel(argMediator:SceneMediator)
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
//			matr.createGradientBox(150,150,Math.PI/2,0,10);
//			_background.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x000000],[0.75,0],[0,255],matr,SpreadMethod.PAD);
//			_background.graphics.drawRect(0,0,208,150);
			_container.addChild(_background);
			
			var pl:int = 22;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,203),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,50,160,48),new Bitmap(new FBAmountBgAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,4,182,17),new MAssetLabel("",MAssetLabel.LABEL_TYPE20)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,31,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.currentMonsterNum"),MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,103,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.guardCopy.accumulateTime"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),	
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,121,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.guardCopy.accumulateExp") + "：",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,139,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.guardCopy.accumulateCopper") + "：",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT))
			]);
			_container.addChild(_bg as DisplayObject);
			
			_taskBtn = new MAssetButton1(new FBTaskBtnAsset() as MovieClip);
			_taskBtn.x = 206;
			_container.addChild(_taskBtn);
			
			_monsterTimesTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2);
			_monsterTimesTxt.setLabelType([new TextFormat("Verdana",42,0x33ffff,true,null,null,null,null,TextFormatAlign.CENTER)]);
			_monsterTimesTxt.move(pl+80,45);
			_container.addChild(_monsterTimesTxt);
			
			var total:MAssetLabel = new MAssetLabel("/50",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			total.setLabelType([new TextFormat("Verdana",14,0x33ffff,true)]);
			total.move(pl+132,73);
			_container.addChild(total);
			
			_useTimeView = new CountUpView();
			_useTimeView.setColor(0x00ff00);
			_useTimeView.move(pl+72,103);
			_container.addChild(_useTimeView);
			_useTimeView.start(99000);
			
			_expTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_expTxt.setHtmlValue("<b>0</b>");
			_expTxt.textColor = 0x00ff00;
			_expTxt.move(pl+72,121);
			_container.addChild(_expTxt);
			_bindCopperTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_bindCopperTxt.setHtmlValue("<b>0</b>");
			_bindCopperTxt.textColor = 0x00ff00;
			_bindCopperTxt.move(pl+72,139);
			_container.addChild(_bindCopperTxt);
			
			_leaveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_leaveBtn.x = 130;
			_leaveBtn.y = 168;
			_container.addChild(_leaveBtn);
//			_container.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(pl+163,4,153,17),new MAssetLabel(LanguageManager.getWord("ssztl.group.leaveTeamWord"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)));
			
			//Timer
//			_container.addChild(MBackgroundLabel.getDisplayObject(new Rectangle(22,-13,38,38),new Bitmap(new FBBallBgAsset() as BitmapData)));
//			_timerTrack = new FBTimerShowAsset();
//			_timerTrack.x = 53;
//			_timerTrack.y = 150;
//			_timerTrack.gotoAndStop(100);
//			_container.addChild(_timerTrack);
			
			_openBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.guardCopy.nextMonster"));
			_openBtn.move(53,168);
			_container.addChild(_openBtn);
			_openBtn.enabled = false;
			
			/*
			_timeTrack = new Sprite();
			_timeTrack.graphics.beginFill(0x080b05,1);
			_timeTrack.graphics.drawRect(14,47,35,4);
			_timeTrack.graphics.endFill();
			_container.addChild(_timeTrack);
			_timeTrack.visible = false;
			*/
			
			var bar:Sprite = new Sprite();
			bar.graphics.beginFill(0xf5ab3a,1);
			bar.graphics.drawRect(0,0,33,2);
			bar.graphics.endFill();
//			_timeBar = new ProgressBar1(bar,1,1,33,2,false,false);
//			_timeBar.move(15,48);
//			_timeBar.setValue(100,0);
//			_timeTrack.addChild(_timeBar);
		}
		private function initialEvents():void
		{
			duplicateGuardInfo.addEventListener(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_UPDATE_AWARD,updateAward);
			duplicateGuardInfo.addEventListener(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_UPDATE_MISSION,updateMission);
			duplicateGuardInfo.addEventListener(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_CAN_OPEN_NEXT_MONSTER,updateCanOpenNextMonster);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
			_openBtn.addEventListener(MouseEvent.CLICK, openNextMoster);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
		}
		private function removeEvents():void
		{
			duplicateGuardInfo.removeEventListener(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_UPDATE_AWARD,updateAward);
			duplicateGuardInfo.removeEventListener(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_UPDATE_MISSION,updateMission);
			duplicateGuardInfo.removeEventListener(SceneDuplicateGuardUpdateEvent.DUPLICATE_GUARD_CAN_OPEN_NEXT_MONSTER,updateCanOpenNextMonster);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			_leaveBtn.removeEventListener(MouseEvent.CLICK,quitDuplicate);
			_openBtn.removeEventListener(MouseEvent.CLICK, openNextMoster);
			
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
		public function update(times:int,dt:Number = 0.04):void
		{
			var nowTime:int = getTimer();
			if(nowTime - _tick > 1000)
			{
				_comeTime = _comeTickTime - (nowTime - _tick)/1000;
				_openBtn.label = LanguageManager.getWord("ssztl.guardCopy.nextMonster") + "(" + _comeTime + ")";
			}
			if(_comeTime <= 0)
			{
				_comeTime = 0;
				_tick = 0;
				_comeTickTime = 0;
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 230;
			y = 190;
		}
		private function updateCopyInfo(e:CommonModuleEvent):void
		{
			var data:IPackageIn = e.data as IPackageIn;
			data.readShort();
			var missionId:int = data.readShort();
			var startTime:int = GlobalData.systemDate.getSystemDate().getTime()/1000 - data.readNumber();
//			duplicateGuardInfo.leftTime = duplicateGuardInfo.leftTime - (time - startTime);
//			_countDownView.stop();
//			_countDownView.start(duplicateGuardInfo.leftTime);
			_useTimeView.setStartTime(startTime);  
			var num:int = data.readShort();
			for(var i:int = 0; i < num; i++)
			{
				var type:int = data.readInt();
				var value:int = data.readInt();
				if(type == 5)
					duplicateGuardInfo.exp = value;
				else if(type == 4)
					duplicateGuardInfo.bindCopper = value;
			}
			var nextTime:Number = data.readNumber();
			duplicateGuardInfo.missionNum = missionId;
//			var time:Number =	int(GlobalData.systemDate.getSystemDate().getTime() / 1000);
			duplicateGuardInfo.nextComeTime = nextTime;
			updateMission(null);
			updateCanOpenNextMonster(null);
			updateAward(null);
		}
		private function openNextMoster(evt:Event):void
		{
			CopyCanOpenNextMonsterSocketHandler.send();
			if(_comeTime > 0)
			{
				_comeTime = 0;
				_tick = 0;
				_comeTickTime = 0;
				GlobalAPI.tickManager.removeTick(this);
			}
			_openBtn.enabled = false;
//			_timerTrack.gotoAndStop(100);
//			_timerTrack.visible = false;
		}
		private function updateCanOpenNextMonster(e:SceneDuplicateGuardUpdateEvent):void
		{
			_openBtn.enabled = true;
		}
		
		private function updateAward(e:SceneDuplicateGuardUpdateEvent):void	
		{
			_expTxt.setHtmlValue("<b>"+duplicateGuardInfo.exp.toString()+"</b>");
			_bindCopperTxt.setHtmlValue("<b>"+duplicateGuardInfo.bindCopper.toString()+"</b>");
		}
		private function updateMission(e:SceneDuplicateGuardUpdateEvent):void	
		{
			if(_comeTime > 0)
			{
				_comeTime = 0;
				GlobalAPI.tickManager.removeTick(this);
			}
			_comeTickTime = duplicateGuardInfo.nextComeTime;
			_comeTime = _comeTickTime;
			_tick = getTimer();
			_openBtn.enabled = false;
			_openBtn.label = LanguageManager.getWord("ssztl.guardCopy.nextMonster") + "(" + _comeTickTime + ")";
			GlobalAPI.tickManager.addTick(this);
			_monsterTimesTxt.setValue(duplicateGuardInfo.missionNum.toString());
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
		public function get duplicateGuardInfo():DuplicateGuardInfo
		{
			return _mediator.duplicateGuardInfo;
		}
		public function dispose():void
		{
			removeEvents();
			GlobalAPI.tickManager.removeTick(this);
			duplicateGuardInfo.clearData();
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
			if(_openBtn)
			{
				_openBtn.dispose();
				_openBtn = null;
			}
			if(_useTimeView)
			{
				_useTimeView.dispose();
				_useTimeView = null;
			}
//			if(_timerTrack && _timerTrack.parent)
//			{
//				_timerTrack.parent.removeChild(_timerTrack);
//				_timerTrack = null;
//			}
			_background = null;
			_mediator = null;
			_container = null;			
			_monsterTimesTxt = null;
			_expTxt = null;
			_bindCopperTxt = null;
			
			if(parent)parent.removeChild(this);
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
	}
}