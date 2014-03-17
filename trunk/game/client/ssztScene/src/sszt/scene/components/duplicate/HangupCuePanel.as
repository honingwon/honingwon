package sszt.scene.components.duplicate
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.mediators.SceneMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset3Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	public class HangupCuePanel extends Sprite
	{
		private var _bg:IMovieWrapper;
		private var _background:Shape;
		private var _mediator:SceneMediator;
		
		private var _tip:MAssetLabel;
		private var _leaveBtn:MCacheAssetBtn1;
		private var _timer:Timer;
		
		private var _keyboardEffect:BaseLoadEffect;
		
		public static const DEFAULT_WIDTH:int = 270;
		public static const DEFAULT_HEIGHT:int = 115;
		
		public function HangupCuePanel(argMediator:SceneMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
			initialEvents();	
		}
		private function initialView():void
		{
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT)),
				
			]);
			addChild(_bg as DisplayObject);
			
			_tip = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
			_tip.move(22,38);
			addChild(_tip);
			_tip.setHtmlValue(LanguageManager.getWord("ssztl.scene.enterCopyHint"));
				 
			_keyboardEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.HANGUP_KEYBOARD_EFFECT));
			_keyboardEffect.move(110,38);
			_keyboardEffect.play(SourceClearType.TIME,300000);
			addChild(_keyboardEffect);
			
			_leaveBtn =  new MCacheAssetBtn1(0,4, LanguageManager.getWord("ssztl.pengLai.hangUpBegin"));
			_leaveBtn.move(76,73);
			addChild(_leaveBtn);
			
			_timer = new Timer(1000,60);
			_timer.addEventListener(TimerEvent.TIMER,timerHandler);
			_timer.start();
		}
		
		private function timerHandler(evt:TimerEvent):void
		{
			var n:int = 5 - _timer.currentCount;			
			_leaveBtn.label = LanguageManager.getWord("ssztl.pengLai.hangUpBegin") +"("+ n + ")";
			if(n <= 0)
			{
				leaveBtnHandler(null);
			}
		}
		
		private function leaveBtnHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.HANGUP));
			dispose();
		}
		
		private function initialEvents():void
		{
			_leaveBtn.addEventListener(MouseEvent.CLICK, leaveBtnHandler);
		}
		private function removeEvents():void
		{
			_leaveBtn.removeEventListener(MouseEvent.CLICK, leaveBtnHandler);
		}
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT - 150));
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function show():void
		{
			
		}
		public function hide():void
		{
			
		}
		public function dispose():void
		{
			
			removeEvents();
			if(_timer)
			{
				_timer.removeEventListener(TimerEvent.TIMER,timerHandler);
				_timer.stop();
				_timer = null;
			}
			if(_leaveBtn)
			{
				_leaveBtn.dispose();
				_leaveBtn = null;
			}
			if(_keyboardEffect)
			{
				_keyboardEffect.dispose();
				_keyboardEffect = null;
			}
			_tip = null;
			_background = null;
			_mediator = null;
			if(parent)parent.removeChild(this);
		}
	}
}