package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActiveStartEvents;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	/**
	 * 惩恶扶伤
	 * @author Aron
	 * 
	 */	
	public class ActivityPunishView extends BaseIconView
	{
		protected static var instance:IActivityView;
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		private var _effect:BaseLoadEffect;
		private var _countDown:CountDownView;
		
		private var _state:int = -1;
		
		/**
		 * 是否显示特效 
		 */
		private static var _isEffectShow:Boolean = true;
		
		private var _activeData:ActiveStarTimeData;
		
		/**
		 *活动id 
		 */
		private var _pvpActiveId:int = 1003;
		
		/**
		 * 活动开启 倒计时 秒
		 */
		private var _actvieWillOpenTime:int = 600;
		
		public function ActivityPunishView()
		{
			super();
//			_index = 15;
			init();
			initEvent();
			initData();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new ActivityPunishView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(state:int=0,arg2:Object =null,isDispatcher:Boolean=false):void
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
				updateActiveStartTimeToOne();
			}
			
//			if(state == 2)
//			{
//				_countDown.visible = true;
//				_countDown.start(1800);
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
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnActiveCEAsset") as MovieClip);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = false;
			
			
		}
		override protected function initEvent():void
		{
			// TODO Auto Generated method stub
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_countDown.addEventListener(Event.COMPLETE,completePu);
			ModuleEventDispatcher.addModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,updateActivityPunishTime);
		}
		
		override protected function removeEvent():void
		{
			// TODO Auto Generated method stub
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			_countDown.removeEventListener(Event.COMPLETE,completePu);
			ModuleEventDispatcher.removeModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,updateActivityPunishTime);
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
		
		private function updateActivityPunishTime(evt:ModuleEvent):void
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
		
		private function completePu(evt:Event):void
		{
			_effect.visible = true;
			_countDown.visible = false;
		}
		
		private function onClick(e:MouseEvent):void
		{
			_isEffectShow = false;
			initData();
			SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,1));
		}
		
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.ActivityPunish"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
		

		
		
		
		override public function dispose():void
		{
			super.dispose();
			if(_btn)
			{
				_btn.dispose();
				_btn = null;
			}
			instance = null;
			
			if(parent) parent.removeChild(this);
		}
		
	}
}