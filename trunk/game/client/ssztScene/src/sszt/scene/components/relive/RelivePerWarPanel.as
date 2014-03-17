package sszt.scene.components.relive
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import sszt.constData.CategoryType;
	import sszt.constData.VipType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseRoleStateType;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.types.PlayerHangupType;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.scene.socketHandlers.SkillReliveSocketHandler;
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
	
	public class RelivePerWarPanel extends MPanel
	{
		private var _mediator:ReliveMediator;
		private var _bg:IMovieWrapper;
//		private var _localBtn:MCacheAsset3Btn;
		private var _localLabel:MAssetLabel;
		private var _timer:Timer;
		private var _hadSend:Boolean;
		private var _sendTime:int;
		
		public static const LABEL_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,null,null,null,null,null,null,TextFormatAlign.LEFT,null,null,null,6);
		
		public function RelivePerWarPanel(mediator:ReliveMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1("",new Bitmap(new WinTitleHintAsset())),true,0.5,false);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(234,77);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_3,new Rectangle(9,4,216,66)),
			]);
			addContent(_bg as DisplayObject);
			
//			_localBtn = new MCacheAsset3Btn(3,"原地复活(倒计时60秒)");
//			_localBtn = new MCacheAsset3Btn(3,LanguageManager.getWord("ssztl.scene.curPlaceRelive2"));
//			_localBtn.move(32,83);
//			addContent(_localBtn);
//			_localBtn.enabled = false;
			
			_localLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1);
			_localLabel.defaultTextFormat = LABEL_FORMAT;
			_localLabel.setTextFormat(LABEL_FORMAT);
			_localLabel.width = 136;
			_localLabel.wordWrap = true;
			_localLabel.multiline = true;
			_localLabel.htmlText = LanguageManager.getWord("ssztl.scene.huangGuDieTip",7);
			
			_localLabel.move(53,11);
			addContent(_localLabel);
			
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
//			_timer.addEventListener(TimerEvent.TIMER_COMPLETE,timerCompleteHandler);
			_timer.start();
			initEvent();
		}
		
		private function initEvent():void
		{
			_mediator.sceneModule.sceneInfo.playerList.self.state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
			_mediator.sceneModule.sceneInfo.playerList.self.addEventListener(BaseSceneObjInfoUpdateEvent.SCENEREMOVE,selfSceneRemoveHandler);
			GlobalAPI.keyboardApi.getKeyListener().addEventListener(KeyboardEvent.KEY_UP,keyUpHandler1,false,2);
		}
		
		private function removeEvent():void
		{
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
		
		private function timerHandler(evt:TimerEvent):void
		{
			if(getTimer() - _sendTime < 1000)return;
			var n:int = 7 - _timer.currentCount;
			if(n < 0)n = 0;
			_localLabel.htmlText = LanguageManager.getWord("ssztl.scene.huangGuDieTip",n);
			if(n == 0)
			{
				_mediator.relive(4);
				_sendTime = getTimer();
			}
		}
//		private function timerCompleteHandler(evt:TimerEvent):void
//		{
//			_mediator.relive(4);
//			dispose();
//		}
		
		override public function doEscHandler():void{}
		
		private function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			if(!_mediator.sceneModule.sceneInfo.playerList.self.getIsDead())
			{
				dispose();
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
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
				_timer = null;
			}
			_localLabel = null;
			super.dispose();
		}
	}
}