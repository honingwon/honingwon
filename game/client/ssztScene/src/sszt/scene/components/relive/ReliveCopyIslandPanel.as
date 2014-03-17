package sszt.scene.components.relive
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.copyIsland.CIMaininfo;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.scene.socketHandlers.SkillReliveSocketHandler;
	import sszt.scene.socketHandlers.smIsland.CopyIslandReliveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.TitleTraceryAsset;
	import ssztui.ui.WinTitleHintAsset;
	
	public class ReliveCopyIslandPanel extends MPanel
	{
		private var _mediator:ReliveMediator;
		
		private var _bg:IMovieWrapper;
		
		private var _countryBtn:MCacheAsset3Btn;
//		private var _localBtn:MCacheAsset3Btn;
		private var _localFull:MCacheAsset3Btn;
//		private var _timer:Timer;
		private var _hanguping:Boolean;
		private var _sendTime:int;
		
		private var _reliveMalert:MAlert;
		
		public function ReliveCopyIslandPanel(mediator:ReliveMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,0,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(256,140);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(9,4,238,128)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(25,23,205,11),new Bitmap(new TitleTraceryAsset() as BitmapData)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(85,21,166,20),new MAssetLabel(LanguageManager.getWord("ssztl.scene.chooseReliveModle"),MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT))
			]);
			addContent(_bg as DisplayObject);
			
			_countryBtn = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.safeRelive"));
			_countryBtn.move(28,48);
			addContent(_countryBtn);
//			_localBtn = new MCacheAsset3Btn(3,"自动原地复活(倒计时15秒)");
//			_localBtn.move(32,83);
//			addContent(_localBtn);
//			_localBtn.enabled = false;
			_localFull = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.curPlaceRelive"));
			_localFull.move(28,78);
			addContent(_localFull);
			
//			_timer = new Timer(1000,15);
//			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
//			_timer.start();
			
			_hanguping = false;
			
			initEvent();
			
			checkHangup();
		}
		
		private function initEvent():void
		{
			_countryBtn.addEventListener(MouseEvent.CLICK,countryClickHandler);
			_localFull.addEventListener(MouseEvent.CLICK,localFullClickHandler);
			_mediator.sceneModule.sceneInfo.playerList.self.state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
			_mediator.sceneModule.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_UP,keyUpHandler1,false,2);
		}
		
		private function removeEvent():void
		{
			_countryBtn.removeEventListener(MouseEvent.CLICK,countryClickHandler);
			_localFull.removeEventListener(MouseEvent.CLICK,localFullClickHandler);
			if(_mediator.sceneModule.sceneInfo.playerList.self)
			{
				_mediator.sceneModule.sceneInfo.playerList.self.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				_mediator.sceneModule.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			}
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler1);
		}
		
		private function keyUpHandler1(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
		private function selfSceneRemoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(_mediator.sceneModule.sceneInfo.playerList.self)
			{
				_mediator.sceneModule.sceneInfo.playerList.self.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
				_mediator.sceneModule.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			}
		}
		
		private function checkHangup():void
		{
			//挂机中
			if(_mediator.sceneInfo.playerList.self.getIsHangup())
			{
				if(_mediator.sceneInfo.hangupData.autoRelive && GlobalData.selfPlayer.getVipType() == VipType.BESTVIP)
				{
					doYuanBaoRelive();
					_hanguping = true;
				}
			}
		}
		
		private function doYuanBaoRelive():void
		{
			if(getTimer() - _sendTime < 1000)return;
			if(GlobalData.bagInfo.getItemById(CategoryType.RELIVE_DRUG).length > 0)
			{
				_mediator.relive(3);
				_sendTime = getTimer();
				return;
			}
			if(GlobalData.selfPlayer.userMoney.yuanBao >= 10)
			{
				_mediator.relive(3);
				_sendTime = getTimer();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough2"));
			}
		}
		
		private function countryClickHandler(evt:MouseEvent):void
		{
			if(getTimer() - _sendTime < 1000)return;
			if(!_mediator.sceneModule.copyIslandInfo.cIMainInfo)return;
			CopyIslandReliveSocketHandler.send(CIMaininfo.COPY_ISLAND_ID,_mediator.sceneModule.copyIslandInfo.cIMainInfo.stage);
			_sendTime = getTimer();
			dispose();
		}
		
//		private function localClickHandler(evt:MouseEvent):void
//		{
//			if(getTimer() - _sendTime < 1000)return;
//			_mediator.relive(2);
//			_sendTime = getTimer();
//		}
		
		
		private function localFullClickHandler(evt:MouseEvent):void
		{
			doYuanBaoRelive();
		}
		
//		private function timerHandler(evt:TimerEvent):void
//		{
//			var n:int = 15 - _timer.currentCount;
//			if(n < 0)n = 0;
//			_localBtn.setLabel("自动原地复活(倒计时" + n + "秒)");
//		}
//		private function timerCompleteHandler(evt:TimerEvent):void
//		{
//			if(getTimer() - _sendTime < 1000)return;
//			_mediator.relive(4);
//			_sendTime = getTimer();
//			dispose();
//		}
		
		override public function doEscHandler():void{}
		
		private function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			if(!_mediator.sceneModule.sceneInfo.playerList.self.getIsDead())
			{
				if(_hanguping)
				{
					_mediator.sceneModule.sceneMediator.setHangup();
				}
				dispose();
			}
		}
		
		public function showAlert(serverId:int,nick:String):void
		{
			if(_reliveMalert)_reliveMalert.dispose();
			_reliveMalert = MAlert.show("[" + serverId + "]" + nick + LanguageManager.getWord("ssztl.scene.sureRelive"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
		}
		
		private function closeHandler(e:CloseEvent):void
		{
			if(e.detail == MAlert.OK)
			{
				SkillReliveSocketHandler.send();
			}
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			removeEvent();
//			if(_timer)
//			{
//				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
//				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
//				_timer.stop();
//				_timer = null;
//			}
			if(_countryBtn)
			{
				_countryBtn.dispose();
				_countryBtn = null;
			}
//			if(_localBtn)
//			{
//				_localBtn.dispose();
//				_localBtn = null;
//			}
			if(_localFull)
			{
				_localFull.dispose();
				_localFull = null;
			}
			if(_reliveMalert)
			{
				_reliveMalert.dispose();
				_reliveMalert = null;
			}
			super.dispose();
		}
	}
}