package sszt.scene.components.relive
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.shenMoWar.ShenMoWarReliveSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.WinTitleHintAsset;
	
	public class ReliveShenMoPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _mediator:ReliveMediator;
		
		private var _reliveYuanBaoBtn:MCacheAsset3Btn;
		private var _reliveBtn1:MCacheAsset3Btn;
		private var _reliveBtn2:MCacheAsset3Btn;
		private var _reliveBtn3:MCacheAsset3Btn;
		private var _tipsLabel:MAssetLabel;
		private var _timer:Timer;
		private var _hadSend:Boolean;
		private var _sendTime:int;
		
		private var _reliveMalert:MAlert;
		
		public function ReliveShenMoPanel(argMediator:ReliveMediator)
		{
			_mediator = argMediator;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,0,false);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(228,188);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(9,4,220,177)),
			]);
			addContent(_bg as DisplayObject);
			
			_timer = new Timer(1000,15);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			_timer.start();
			
			_tipsLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.autoRelive15s"),MAssetLabel.LABELTYPE1);
			_tipsLabel.move(51,4);
			addContent(_tipsLabel);
			
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.yuanBaoRelive"),MAssetLabel.LABELTYPE1);
			label1.move(56,20);
			addContent(label1);
			
			_reliveYuanBaoBtn = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.curPlaceRelive"));
			_reliveYuanBaoBtn.move(23,52);
			addContent(_reliveYuanBaoBtn);
			if(_mediator.sceneInfo.mapInfo.isClubPointWarScene())
			{
				_reliveYuanBaoBtn.enabled = false;
			}
			
			_reliveBtn1 = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.relivePlace1"));
			_reliveBtn1.move(23,84);
			addContent(_reliveBtn1);
			
			_reliveBtn2 = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.relivePlace2"));
			_reliveBtn2.move(23,115);
			addContent(_reliveBtn2);
			
			_reliveBtn3 = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.relivePlace3"));
			_reliveBtn3.move(23,147);
			addContent(_reliveBtn3);
			
		}
		
		private function initEvents():void
		{
			_reliveYuanBaoBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_reliveBtn1.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_reliveBtn2.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_reliveBtn3.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_mediator.sceneInfo.playerList.self.state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,stateChangeHandler);
			_mediator.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_UP,keyUpHandler1,false,2);
		}
		
		private function removeEvents():void
		{
			_reliveYuanBaoBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_reliveBtn1.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_reliveBtn2.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_reliveBtn3.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			if(_mediator.sceneInfo.playerList.self)
			{
				_mediator.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
				_mediator.sceneInfo.playerList.self.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,stateChangeHandler);
			}
			GlobalAPI.keyboardApi.getKeyListener().removeEventListener(KeyboardEvent.KEY_UP,keyUpHandler1);
		}
		
		private function keyUpHandler1(evt:KeyboardEvent):void
		{
			evt.stopImmediatePropagation();
		}
		
		private function stateChangeHandler(e:PlayerStateUpdateEvent):void
		{
			if(!_mediator.sceneInfo.playerList.self.getIsDead())
			{
				dispose();
			}
		}
		
		private function selfSceneRemoveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(_mediator.sceneModule.sceneInfo.playerList.self)
			{
				_mediator.sceneInfo.playerList.self.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,stateChangeHandler);
				_mediator.sceneInfo.playerList.self.removeEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			}
		}
		
		override public function doEscHandler():void{}
		
//		public function showAlert(nick:String):void
//		{
//			if(_reliveMalert)_reliveMalert.dispose();
//			_reliveMalert = MAlert.show(nick + "玩家将您原地复活，确定复活吗？",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,this,closeHandler);
//		}
		
//		private function closeHandler(e:CloseEvent):void
//		{
//			if(e.detail == MAlert.OK)
//			{
//				ShenMoWarReliveSocketHandler.send((Math.floor((4-2+1)*Math.random()+2)));
//			}
//		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			var n:int = 15 - _timer.currentCount;
			if(n < 0)n = 0;
			_tipsLabel.text = LanguageManager.getWord("ssztl.scene.autoReliveLeftSeconds",n);
		}
		private function timerCompleteHandler(evt:TimerEvent):void
		{
			if(getTimer() - _sendTime < 1000)return;
			ShenMoWarReliveSocketHandler.send((Math.floor((4-2+1)*Math.random()+2)));
			_sendTime = getTimer();
		}
		
		private function yuanBaoBtnClickHandler():void
		{
			if(getTimer() - _sendTime < 1000)return;
			if(GlobalData.bagInfo.getItemById(CategoryType.RELIVE_DRUG).length > 0)
			{
				ShenMoWarReliveSocketHandler.send(1);
				_sendTime = getTimer();
				return;
			}
			if(GlobalData.selfPlayer.userMoney.yuanBao >= 10)
			{
//				if(_hadSend)return;
//				_hadSend = true;
				ShenMoWarReliveSocketHandler.send(1);
				_sendTime = getTimer();
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.yuanBaoNotEnough2"));
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			if(getTimer() - _sendTime < 1000)return;
			switch(e.currentTarget)
			{
				case _reliveYuanBaoBtn:
					yuanBaoBtnClickHandler();
					break;
				case _reliveBtn1:
					ShenMoWarReliveSocketHandler.send(2);
					break;
				case _reliveBtn2:
					ShenMoWarReliveSocketHandler.send(3);
					break;
				case _reliveBtn3:
					ShenMoWarReliveSocketHandler.send(4);
					break;
			}
			_sendTime = getTimer();
		}
			
		
		override public function dispose():void
		{
			super.dispose();
			removeEvents();
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
				_timer.stop();
				_timer = null;
			}
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
			
			if(_reliveYuanBaoBtn)
			{
				_reliveYuanBaoBtn.dispose();
				_reliveYuanBaoBtn = null;
			}
			if(_reliveBtn1)
			{
				_reliveBtn1.dispose();
				_reliveBtn1 = null;
			}
			if(_reliveBtn2)
			{
				_reliveBtn2.dispose();
				_reliveBtn2 = null;
			}
			if(_reliveBtn3)
			{
				_reliveBtn3.dispose();
				_reliveBtn3 = null;
			}
			_tipsLabel = null;
			if(_reliveMalert)
			{
				_reliveMalert.dispose();
				_reliveMalert = null;
			}
		}
	}
}