package sszt.scene.components.copyMoney
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
	import flash.events.TextEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.copy.CopyTemplateItem;
	import sszt.core.data.copy.CopyTemplateList;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.TaskModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.copyMoney.ComboAddPanel;
	import sszt.scene.components.sceneObjs.SelfScenePlayer;
	import sszt.scene.data.duplicate.DuplicateMoneyInfo;
	import sszt.scene.events.SceneDuplicateMoneyUpdateEvent;
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
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.scene.FBLeaveBtnAsset;
	import ssztui.scene.FBSideBgTitleAsset;
	import ssztui.scene.FBTaskBtnAsset;
	
	public class MoneyDuplicatePanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		private var _container:Sprite;
		
		private var _countDownView:CountDownView;
		private var _pickUpDownView:PickUpDownView;
		
		private var _tf:TextFormat = new TextFormat("SimSun",12,0xfffccc);

//		private var _bindCopper:int;
//		private var _bindYuanbao:int;
//		private var _killNum:int;
//		private var _killBoss:int;		
		private var _maxBatterNum:int;
		private var _comboAdd:int;
		
		private var _viewComboAdd:MAssetLabel;
		private var _tipWord:MAssetLabel;
		private var _needBatter:MAssetLabel;
		private var _leftTimeTxt:MAssetLabel;
		private var _pickTimeTxt:MAssetLabel;
		private var _copperTxt:MAssetLabel;
		private var _bindCopperTxt:MAssetLabel;
		private var _bindYuanBaoTxt:MAssetLabel;
		private var _killMonsterTxt:MAssetLabel;
		private var _killBossTxt:MAssetLabel;
		private var _maxComboTxt:MAssetLabel;
		private var _addComboTxt:MAssetLabel;
		private var _leaveBtn:MCacheAssetBtn1;
		
		private var _luckDraw:LuckyDrawPanel;
		
		private var _taskBtn:MAssetButton1;
		
		public function MoneyDuplicatePanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();
			_countDownView.start(duplicateMonyeInfo.leftTime);
			CopyInfoSocketHandler.send();
			_pickUpDownView.start(0);
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
//			matr.createGradientBox(230,230,Math.PI/2,0,30);
//			_background.graphics.beginGradientFill(GradientType.LINEAR,[0x000000,0x000000],[0.75,0],[0,255],matr,SpreadMethod.PAD);
//			_background.graphics.drawRect(0,0,208,230);
			_container.addChild(_background);
			
			var pl:int = 22;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl,0,208,270),_background),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,206,24),new Bitmap(new FBSideBgTitleAsset() as BitmapData)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,92,200,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,152,200,2),new MCacheSplit2Line()),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(16,194,200,2),new MCacheSplit2Line()),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,4,182,17),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.titleName"),MAssetLabel.LABEL_TYPE20)),
				//old:目标！击杀更多BOSS，获得更多的绑定铜币！
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,31,112,17),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.tagert"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT)),
				//Tags
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,73,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.scene.copyLeftTime"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(44,109,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.pickTongBiTime"),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,97,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.bindYuanBao"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,115,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.bindCopper"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+122,115,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.common.copperLabel"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,133,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.killMonsterWord"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+122,133,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.killBossWord"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(pl+12,157,85,14),new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.MaxBatter"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT)),
			]);
			_container.addChild(_bg as DisplayObject);
			
			_taskBtn = new MAssetButton1(new FBTaskBtnAsset() as MovieClip);
			_taskBtn.x = 206;
			_container.addChild(_taskBtn);
			
			_viewComboAdd = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_viewComboAdd.textColor = 0x2fb7cf;
			_viewComboAdd.htmlText = "<a href=\'event:0\'><u>[" + LanguageManager.getWord("ssztl.moneycopy.BatterAdd") + "]</u></a>";
			_viewComboAdd.move(pl+12,49);
			_viewComboAdd.mouseEnabled = true;
			_container.addChild(_viewComboAdd);
			
			_tipWord = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_tipWord.textColor = 0xffff99;
			_tipWord.move(pl+12,199);
			_tipWord.setSize(190,34);
//			_tipWord.wordWrap = true;
//			_tipWord.multiline = true;
			_tipWord.htmlText = LanguageManager.getWord("ssztl.moneycopy.tipsWord");
			_container.addChild(_tipWord);
			
			//数据项
			_needBatter = new MAssetLabel(LanguageManager.getWord("ssztl.moneycopy.NeedBatter",_comboAward[0].num, _comboAward[0].value),MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_needBatter.textColor = 0xff33ff;
			_needBatter.move(pl+12,175);
			_container.addChild(_needBatter);
			
//			_leftTimeTxt = new MAssetLabel("00:20:15",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
//			_leftTimeTxt.textColor = 0x00ff00;
//			_leftTimeTxt.move(128,91);
//			_container.addChild(_leftTimeTxt);
			
			_countDownView = new CountDownView();
			_countDownView.setColor(0x00ff00);
			_countDownView.move(pl+96,73);
			_container.addChild(_countDownView);
			
//			_pickTimeTxt = new MAssetLabel("00:20:15",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
//			_pickTimeTxt.textColor = 0x00ff00;
//			_pickTimeTxt.move(128,109);
//			_container.addChild(_pickTimeTxt);
			_pickUpDownView = new PickUpDownView();
			_pickUpDownView.move(230-CommonConfig.GAME_WIDTH/2,-100);
			addChild(_pickUpDownView);
			_pickUpDownView.visible = false;
			
			_bindCopperTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_bindCopperTxt.textColor = 0xffff00;
			_bindCopperTxt.move(pl+72,115);			
			_container.addChild(_bindCopperTxt);
			
			_copperTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_copperTxt.textColor = 0xffff00;
			_copperTxt.move(pl+157,115);
			_container.addChild(_copperTxt);
			
			_bindYuanBaoTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_bindYuanBaoTxt.textColor = 0xffff00;
			_bindYuanBaoTxt.move(pl+72,97);
			
			_container.addChild(_bindYuanBaoTxt);
			_killMonsterTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_killMonsterTxt.textColor = 0xffff00;
			_killMonsterTxt.move(pl+72,133);
			_container.addChild(_killMonsterTxt);
			_killBossTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_killBossTxt.textColor = 0xffff00;
			_killBossTxt.move(pl+181,133);
			_container.addChild(_killBossTxt);			
			_maxComboTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_maxComboTxt.textColor = 0xffff00;
			_maxComboTxt.move(pl+72,157);
			_container.addChild(_maxComboTxt);
			_addComboTxt = new MAssetLabel("0",MAssetLabel.LABEL_TYPE_TAG2,TextFormatAlign.LEFT);
			_addComboTxt.textColor = 0xffff00;
			_addComboTxt.move(pl+181,157);
			_container.addChild(_addComboTxt);
			
			_leaveBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.quitCopy"));
			_leaveBtn.x = 90;
			_leaveBtn.y = 235;
			_container.addChild(_leaveBtn);
			
			_luckDraw = new LuckyDrawPanel();
			_luckDraw.x = -450;
			_luckDraw.visible = false;
			addChild(_luckDraw);
		}
		private function initialEvents():void
		{
			_viewComboAdd.addEventListener(MouseEvent.MOUSE_OVER,linkOverHandler);
			_viewComboAdd.addEventListener(MouseEvent.MOUSE_OUT,linkOurHandler);
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO, updateCombo);
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_KILL_BOSS, updateKillBoss);
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_PICKUP_MONEY, updateMoney);
			duplicateMonyeInfo.addEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_RAND_MONEY_STOP, stopLuckDraw);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
//			_countDownView.addEventListener(Event.COMPLETE,countUpCompleteHandler);
			_pickUpDownView.addEventListener(Event.COMPLETE,countUpCompleteHandler);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
			
//			SelfScenePlayer(GlobalData.selfScenePlayer).getBaseRoleInfo().state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerMoneyDupHandler);
		}
		private function removeEvents():void
		{
			_viewComboAdd.removeEventListener(MouseEvent.MOUSE_OVER,linkOverHandler);
			_viewComboAdd.removeEventListener(MouseEvent.MOUSE_OUT,linkOurHandler);
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_COMBO, updateCombo);
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_KILL_BOSS, updateKillBoss);
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_UPDATE_PICKUP_MONEY, updateMoney);
			duplicateMonyeInfo.removeEventListener(SceneDuplicateMoneyUpdateEvent.DUPLICATE_MONEY_RAND_MONEY_STOP, stopLuckDraw);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, gameSizeChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.UPDATE_COPY_INFO,updateCopyInfo);
			_leaveBtn.addEventListener(MouseEvent.CLICK,quitDuplicate);
			_pickUpDownView.addEventListener(Event.COMPLETE,countUpCompleteHandler);
			
			_taskBtn.addEventListener(MouseEvent.CLICK,taskClickHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OVER,taskOverHandler);
			_taskBtn.addEventListener(MouseEvent.MOUSE_OUT,taskOutHandler);
			
//			SelfScenePlayer(GlobalData.selfScenePlayer).getBaseRoleInfo().state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerMoneyDupHandler);
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
		
		private function playerMoneyDupHandler(e:PlayerStateUpdateEvent):void
		{
			
		}
		
		public function show():void
		{
			
		}
		public function hide():void
		{
			
		}
		public function showLuckDraw():void
		{
			_luckDraw.visible = true;			
		}
		public function stopLuckDraw(e:SceneDuplicateMoneyUpdateEvent):void
		{
			var num:int = int(e.data);
			_luckDraw.startLottery(num);
		}
		private function linkOverHandler(evt:MouseEvent):void
		{
//			var _info:ComboAddPanel = new ComboAddPanel(_mediator);
//			GlobalAPI.layerManager.getPopLayer().addChild(_info);
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.killAdditionValue"),null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function linkOurHandler(evt:MouseEvent):void
		{
//			var _info:ComboAddPanel = new ComboAddPanel(_mediator);
//			GlobalAPI.layerManager.getPopLayer().addChild(_info);
			TipsUtil.getInstance().hide();
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
		private function gameSizeChangeHandler(e:CommonModuleEvent):void
		{
			x = CommonConfig.GAME_WIDTH - 230;
			y = 190;
			_pickUpDownView.move(230-CommonConfig.GAME_WIDTH/2,-100);
		}
		private function updateCopyInfo(e:CommonModuleEvent):void
		{
			var data:IPackageIn = e.data as IPackageIn;
			data.readShort();
			var missionId:int = data.readShort();
			var startTime:Number = data.readNumber();
			var time:Number =	int(GlobalData.systemDate.getSystemDate().getTime() / 1000);
			
			var num:int = data.readShort();
			for(var i:int = 0; i < num; i++)
			{
				var type:int = data.readInt();
				if(type == 2)
					duplicateMonyeInfo.bindYuanbao = data.readInt();
				else if(type == 4)
					duplicateMonyeInfo.bindCopper = data.readInt();					
			}
			var killNumber:int = data.readInt();
			var state:int = data.readShort();
			var maxBattleNum:int = data.readInt();
			var battleNum:int = data.readInt();
			var battleTime:Number = data.readNumber();
			var buplicateId:int = data.readInt();
			var copy:CopyTemplateItem = CopyTemplateList.getCopy(buplicateId);
			duplicateMonyeInfo.leftTime = copy.countTime - (time - startTime);
			_countDownView.stop();
			_countDownView.start(duplicateMonyeInfo.leftTime);
			
			duplicateMonyeInfo.maxBatterNum = maxBattleNum;
			duplicateMonyeInfo.killNum = killNumber;
			duplicateMonyeInfo.batterTickTime = battleTime;
			duplicateMonyeInfo.cutterBatterNum = battleNum;
			if(state == 1)
			{
				duplicateMonyeInfo.state = 0;
				duplicateMonyeInfo.killBoss = missionId - 1;
			}
			else if(state == 2)
			{
				duplicateMonyeInfo.state = 1;
				duplicateMonyeInfo.killBoss = missionId;
			}
			updateCombo(null);
			_killBossTxt.setValue(duplicateMonyeInfo.killBoss.toString());
			_bindYuanBaoTxt.setValue(duplicateMonyeInfo.bindYuanbao.toString());
			
		}
		private function updateCombo(e:SceneDuplicateMoneyUpdateEvent):void
		{
			if(duplicateMonyeInfo.maxBatterNum > 0)
			{
				if(_maxBatterNum < duplicateMonyeInfo.maxBatterNum)
				{
					_maxBatterNum = duplicateMonyeInfo.maxBatterNum;
					_maxComboTxt.setValue(_maxBatterNum.toString());
					updateComboAdd();
				}
				_bindCopperTxt.setValue(duplicateMonyeInfo.bindCopper.toString());
				_killMonsterTxt.setValue(duplicateMonyeInfo.killNum.toString());
			}
		}
		private static var _comboAward:Array = [{num:100,value:40},{num:200,value:60},{num:300,value:80},{num:400,value:100},{num:500,value:120},{num:500,value:120}];
		private function updateComboAdd():void
		{
			var temp:int = _maxBatterNum/100;
			if(_comboAdd >= 5 || _comboAdd >= temp)
				return;
			
			_comboAdd = temp;
			_needBatter.setValue(LanguageManager.getWord("ssztl.moneycopy.NeedBatter",_comboAward[_comboAdd].num, _comboAward[_comboAdd].value));
			_addComboTxt.setValue(_comboAward[_comboAdd - 1].value + "%");
			
		}
		private function updateKillBoss(e:SceneDuplicateMoneyUpdateEvent):void
		{
			_killBossTxt.setValue(duplicateMonyeInfo.killBoss.toString());
			_pickUpDownView.start(duplicateMonyeInfo.pickUpTime);
			_pickUpDownView.visible = true;
			showLuckDraw();
		}
		private function countUpCompleteHandler(e:Event):void
		{
			_pickUpDownView.visible = false;
		}
		private function updateMoney(e:SceneDuplicateMoneyUpdateEvent):void
		{
			_bindCopperTxt.setValue(duplicateMonyeInfo.bindCopper.toString());
			_bindYuanBaoTxt.setValue(duplicateMonyeInfo.bindYuanbao.toString());
		}
		
		public function get duplicateMonyeInfo():DuplicateMoneyInfo
		{
			return _mediator.duplicateMonyeInfo;
		}
		
		public function dispose():void
		{
			removeEvents();
			duplicateMonyeInfo.clearData();
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
			if(_pickUpDownView)
			{
				_pickUpDownView.dispose();
				_pickUpDownView = null;
			}
			if(_luckDraw)
			{
				_luckDraw.dispose();
				_luckDraw = null;
			}
			_copperTxt = null;
			//缺少背景图片析构
			_background = null;
			_container = null;
			if(parent)parent.removeChild(this);
			ModuleEventDispatcher.dispatchTaskEvent(new TaskModuleEvent(TaskModuleEvent.TASK_SHOW_FOLLOW_COMPLETE));//显示任务栏
		}
	}
}