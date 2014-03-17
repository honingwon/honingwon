package sszt.quiz.component
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.constData.CommonConfig;
	import sszt.constData.MapType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.quiz.QuizQuestion;
	import sszt.core.data.quiz.QuizQuestionResult;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.QuizModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.quiz.mediator.QuizMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.quiz.BtnNoAsset;
	import ssztui.quiz.BtnYesAsset;
	import ssztui.quiz.MovRightAsset;
	import ssztui.quiz.MovWrongAsset;
	import ssztui.quiz.TagTimeAsset;
	import ssztui.ui.BtnAssetClose;
	
	public class QuizPanel extends MSprite implements IPanel,ITick
	{
		public static const DEFAULT_WIDTH:int = 550; 
		public static const DEFAULT_HEIGHT:int = 105;
		
		private var _quizMediator:QuizMediator;
		
		private var _bg:IMovieWrapper;
		private var _btnClose:MAssetButton1;
		
		private var _txtProgress:MAssetLabel;
		private var _txtCountDown:MAssetLabel;
		private var _txtQuestionContent:MAssetLabel;
		private var _txtOptionA:MAssetLabel;
		private var _txtOptionB:MAssetLabel;
		
		private var _movResult:MovieClip;
		
		private var _BtnY:MSprite;
		private var _BtnN:MSprite;
		
		protected var _updateTime:int;
		
		public function QuizPanel(quizMediator:QuizMediator)
		{
			super();
			_quizMediator = quizMediator;
			
			initView();
			initEvent();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setSize1();
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_10, new Rectangle(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT)),
				new BackgroundInfo(BackgroundType.BORDER_3, new Rectangle(139, 9, 402, 85)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(255,60,78,25),new Bitmap(new BtnYesAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(347,60,78,25),new Bitmap(new BtnNoAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(32,15,71,17),new Bitmap(new TagTimeAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(89,47,20,15),new MAssetLabel("秒",MAssetLabel.LABEL_TYPE_TAG))
			]);
			addChild(_bg as DisplayObject);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-26,4);
			addChild(_btnClose);
			
			_txtCountDown = new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_txtCountDown.setLabelType([new TextFormat("Courier New",30,0x99ff00,true)]);
			_txtCountDown.move(65,35);
			addChild(_txtCountDown);
			_txtCountDown.setValue("20");
			
			_txtProgress = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			_txtProgress.move(29,76);
			addChild(_txtProgress);
			_txtProgress.text = LanguageManager.getWord("ssztl.quit.currentPro") + 1 + "/30";
			
			_txtQuestionContent = new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_txtQuestionContent.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtQuestionContent.wordWrap = true;
			_txtQuestionContent.setSize(360,33);
			_txtQuestionContent.move(160,19);
			addChild(_txtQuestionContent);
			_txtQuestionContent.setValue("一只小蜈蚣心情不好， 他爸爸问：你怎么了？  小蜈蚣摆动着他那100多条腿说：六一了我想买匡威鞋。");
			
			_txtOptionA = new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_txtOptionA.move(294,65);
			addChild(_txtOptionA);
			_txtOptionA.setValue("YES");
			
			_txtOptionB = new MAssetLabel('',MAssetLabel.LABEL_TYPE20);
			_txtOptionB.move(386,65);
			addChild(_txtOptionB);
			_txtOptionB.setValue("NO");
			
			this.x = Math.floor((CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2);
			this.y = -DEFAULT_HEIGHT;
			
			_BtnY = new MSprite();
			_BtnY.buttonMode = true;
			_BtnY.graphics.beginFill(0,0);
			_BtnY.graphics.drawRect(255,60,78,25);
			_BtnY.graphics.endFill();
			addChild(_BtnY);
			_BtnN = new MSprite();
			_BtnN.buttonMode = true;
			_BtnN.graphics.beginFill(0,0);
			_BtnN.graphics.drawRect(347,60,78,25);
			_BtnN.graphics.endFill();
			addChild(_BtnN);
		}
		
		private function initView():void
		{
			updateQuestionView();
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function initEvent():void
		{
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, setPanelPosition);
			
			ModuleEventDispatcher.addQuizEventListener(QuizModuleEvent.QUIZ_PUSH,quizPushHandler);
			ModuleEventDispatcher.addQuizEventListener(QuizModuleEvent.QUIZ_RESULT,quizResultHandler);
			ModuleEventDispatcher.addQuizEventListener(QuizModuleEvent.QUIZ_END,quizEndHandler);
			
			_btnClose.addEventListener(MouseEvent.CLICK, closePanel);
			_BtnY.addEventListener(MouseEvent.MOUSE_OVER,rightOverHandler);
			_BtnY.addEventListener(MouseEvent.MOUSE_OUT,rightOutHandler);
			_BtnY.addEventListener(MouseEvent.CLICK,showRight);
			_BtnN.addEventListener(MouseEvent.CLICK,showWrong);
			_BtnN.addEventListener(MouseEvent.MOUSE_OVER,wrongOverHandler);
			_BtnY.addEventListener(MouseEvent.MOUSE_OUT,rightOutHandler);
		}
		
		private function removeEvent():void
		{
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE, setPanelPosition);
			
			ModuleEventDispatcher.removeQuizEventListener(QuizModuleEvent.QUIZ_PUSH,quizPushHandler);
			ModuleEventDispatcher.removeQuizEventListener(QuizModuleEvent.QUIZ_RESULT,quizResultHandler);
			ModuleEventDispatcher.removeQuizEventListener(QuizModuleEvent.QUIZ_END,quizEndHandler);
			
			_btnClose.removeEventListener(MouseEvent.CLICK, closePanel);
			
			_BtnY.removeEventListener(MouseEvent.CLICK,showRight);
			_BtnN.removeEventListener(MouseEvent.CLICK,showWrong);
		}
		
		private function quizEndHandler(e:QuizModuleEvent):void
		{
			dispose();
		}
		
		private function rightOverHandler(e:MouseEvent):void
		{
			
		}
		
		private function rightOutHandler(e:MouseEvent):void
		{
			
		}
		
		private function wrongOverHandler(e:MouseEvent):void
		{
			
		}
		
		private function wrongOutHandler(e:MouseEvent):void
		{
			
		}
		
		private function quizResultHandler(e:QuizModuleEvent):void
		{
			var result:QuizQuestionResult = e.data as QuizQuestionResult;
			//index相同才显示
			var lastQuestion:QuizQuestion = GlobalData.quizInfo.lastQuestion;
			if(lastQuestion.index == result.index)
			{
				updateResultView(result.isOrNot);
			}
		}
		private function showRight(e:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:MapType.QUIZ,target:new Point(1140,740)}));
		}
		private function showWrong(e:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchSceneEvent(new SceneModuleEvent(SceneModuleEvent.WALKTOPOINT,{sceneId:MapType.QUIZ,target:new Point(1500,740)}));
		}
		private function updateResultView(result:Boolean):void
		{
			if(result)
			{
				_movResult = new MovRightAsset();
			}else
			{
				_movResult = new MovWrongAsset();
			}
			_movResult.x = DEFAULT_WIDTH >> 1;
			_movResult.y = Math.floor(CommonConfig.GAME_HEIGHT >> 1);
			addChild(_movResult);
			TweenLite.to(_movResult,1,{alpha:0,delay:3,ease:Cubic.easeOut,onComplete:onRemoveComplete});
		}
		private function onRemoveComplete():void
		{
			if(_movResult)
			{
				_movResult.parent.removeChild(_movResult);
				_movResult = null;
			}
		}
		private function quizPushHandler(e:QuizModuleEvent):void
		{
			updateQuestionView();
		}
		
		private function updateQuestionView():void
		{
			var lastQuestion:QuizQuestion = GlobalData.quizInfo.lastQuestion;
			if(!lastQuestion)return;
			
			clearView();
			_txtCountDown.setValue("20");
			_txtProgress.text = LanguageManager.getWord("ssztl.quit.currentPro") + lastQuestion.index + "/30";
			_txtQuestionContent.text = lastQuestion.index + '、' +lastQuestion.questionContent;
			_txtOptionA.text = lastQuestion.optionA;
			_txtOptionB.text = lastQuestion.optionB;
			
			_updateTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		private function clearView():void
		{
			_txtProgress.text = "";
			_txtQuestionContent.text = '';
			_txtOptionA.text = '';
			_txtOptionB.text = '';
		}
		
		private function closePanel(event:MouseEvent):void
		{
			MAlert.show(
				LanguageManager.getWord("ssztl.quiz.alert") ,
				LanguageManager.getWord("ssztl.common.alertTitle"),
				MAlert.OK | MAlert.CANCEL,null,closeHandler);
			
			function closeHandler(e:CloseEvent):void
			{
				if(e.detail == MAlert.OK)
				{
					dispose();
				}
			}
		}
		
		private function setPanelPosition(e:Event):void
		{
			this.x = Math.floor((CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2);
		}
		
		private function setSize1():void
		{
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, DEFAULT_WIDTH, DEFAULT_HEIGHT);
			graphics.endFill();
		}
		
		public function doEscHandler():void
		{
			closePanel(null);
		}
		
		override public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_movResult && _movResult.parent)
			{
				_movResult.parent.removeChild(_movResult);
				_movResult = null;
			}
			_txtProgress = null;
			_txtCountDown = null;
			_txtQuestionContent = null;
			_txtOptionA = null;
			_txtOptionB = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
		public function update(times:int,dt:Number = 0.04):void
		{
			if(getTimer() - _updateTime >= 1000)
			{
				var _time:Number = int(_txtCountDown.text);
				if(_time > 0)
				{
					_time -= Math.floor((getTimer() - _updateTime) / 1000);
				}else
				{
					GlobalAPI.tickManager.removeTick(this);
				}
				_txtCountDown.text = _time.toString();
				_updateTime = getTimer();
			}
			
			if(y >= 1)
			{
				y = 1;
//				GlobalAPI.tickManager.removeTick(this);
			}
			else
			{
				y += (1-y)/3.8;
			}
			
		}
	}
}