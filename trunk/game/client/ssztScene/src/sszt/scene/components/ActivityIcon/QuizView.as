package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActiveStartEvents;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	public class QuizView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		private var _effect:BaseLoadEffect;
		private var _countDown:CountDownView;
		
		private var _state:int = -1;
		/**
		 * 一战到底活动id 
		 */
		private var _pvpActiveId:int = 1004;
		
		/**
		 * 活动即将开启 倒计时 秒
		 */
		private var _actvieWillOpenTime:int = 600;
		
		private var _activeData:ActiveStarTimeData;
		
		/**
		 * 是否显示特效 
		 */
		private static var _isEffectShow:Boolean = true;
		
		public function QuizView()
		{
			super();
//			_index = 9;
			init();
			initEvent();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new QuizView() as IActivityView;
			}
			return instance;
		}
		/**
		 * @param state 值为2：活动 差30分钟开始 图标显示，倒计时显示。值为1：已经开始，30秒后推送题目, 图标继续显示，并显示特效
		 * */
		override public function show(state:int = 2 ,arg2:Object=null,isDispatcher:Boolean=false):void
		{
			if(state != 1 && state != 2) return;
			_state = state;
			
//			if(!arg2)
//			{
//				_actvieWillOpenTime = 600;
//			}
			if(arg2 != null)
			{
				_actvieWillOpenTime = int(arg2);
			}
			if(state == 1)
			{
//				_effect.visible = true;
				updateActiveStartTimeToOne();
			}
			
//			if(state == 2)
//			{
//				_countDown.visible = true;
//				_countDown.start(1800);
//				
//			}
			super.show(state,arg2,isDispatcher);
		}
		private function init():void
		{
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(55,18);
			_countDown.move(0,55);
			addChild(_countDown);
			_countDown.visible = false;
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnQuizAsset") as MovieClip);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = false;
			
			
			
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_countDown.addEventListener(Event.COMPLETE,completePVP);
			
			ModuleEventDispatcher.addModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,quiZActiveTime);
		}
		
		
		private function initData():void
		{
			if(_isEffectShow)
			{
				_effect.visible = true;
			}
			else
			{
				_effect.visible = false;
			}
		}
		
		private function completePVP(evt:Event):void
		{
			_effect.visible = true;
			_countDown.visible = false;
		}
		
		private function quiZActiveTime(evt:ModuleEvent):void
		{
			setData();
		}
		
		private function setData():void
		{
			_activeData = GlobalData.activeStartInfo.activeTimeInfo[_pvpActiveId];
			_actvieWillOpenTime = _activeData.time;
			show(_activeData.state,{state:1},true);
			
		}
		
		/**
		 * 活动开启
		 */		
		private function updateActiveStartTimeToOne():void
		{
			_countDown.visible = true;
			_countDown.start(_actvieWillOpenTime);
			_effect.visible = true;
		}
		
		private function onClick(e:MouseEvent):void
		{
			_isEffectShow = false;
			initData();
			//断玩家等级是否达到
			if(GlobalData.selfPlayer.level < 30)
			{
				SetModuleUtils.addActivity(new ToActivityData(2,0,22));
//				QuickTips.show(LanguageManager.getWord('ssztl.furnace.notEnoughLevel'));
			}
			else
			{
				SetModuleUtils.addQuiz(new ToQuizData(1));
//				if(_state == 1)
//				{
//					SetModuleUtils.addQuiz(new ToQuizData(1));
//				}
//				else if(_state == 2)
//				{
//					QuickTips.show(LanguageManager.getWord('ssztl.common.activityIsNotReady'));
//				}
			}
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.scene.quizTip"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		override protected function layout(e:SceneModuleEvent):void
		{
			if(e.data != instance)
			{
				setPosition();
			}
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.removeModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,quiZActiveTime);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			if(_btn)
			{
				_btn.dispose();
				_btn = null;
			}
			if(_effect)
			{
				_effect.dispose();
				_effect = null;
			}
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			instance = null;
			
			if(parent) parent.removeChild(this);
		}
		
	}
}