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
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActiveStartEvents;
	import sszt.events.ModuleEvent;
	import sszt.events.PetPVPModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	public class CityCraftView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _countDown:CountDownView;
		private var _btn:MAssetButton1;
		private var _effect:BaseLoadEffect;
		
		private var _activeId:int = 1013;
		private var _actvieWillOpenTime:int = 1800;
		private var _activeData:ActiveStarTimeData;
		private var _state:int = -1;
		public function CityCraftView()
		{
			super();
			init();
			initEvent();
		}
		
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new CityCraftView() as IActivityView;
			}
			return instance;
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
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnCityAsset1") as MovieClip);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			_effect.visible = true;			
		}		
		
		override protected function initEvent():void
		{
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.addModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,activeUpdateHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			ModuleEventDispatcher.removeModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,activeUpdateHandler);
		}
		
		override public function show(state:int = -1 ,arg2:Object=null,isDispatcher:Boolean=false):void
		{
			if(state != 1 && state != 2) return;
			_state = state;
			
			if(!arg2)
			{
				_actvieWillOpenTime = 1800;
			}
			
			if(state == 1)
			{
				updateActiveStartTimeToOne();
			}
			super.show(state,arg2,isDispatcher);
		}
		
		private function onClick(e:MouseEvent):void
		{
			_effect.visible = false;
			//断玩家等级是否达到
			if(GlobalData.selfPlayer.level < 35)
			{
				QuickTips.show("35级以后才可参加！");
//				SetModuleUtils.addActivity(new ToActivityData(2,0,29));
			}
			else
			{
				SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,9));
			}
		}		
		
		private function updateActiveStartTimeToOne():void
		{
			_countDown.visible = true;
			if(_actvieWillOpenTime >= 0) _countDown.start(_actvieWillOpenTime);
			_effect.visible = true;
		}
		
		private function activeUpdateHandler(evt:ModuleEvent):void
		{
			setData();
		}
		
		private function setData():void
		{
			_activeData = GlobalData.activeStartInfo.activeTimeInfo[_activeId];
			_actvieWillOpenTime = _activeData.time;
			show(_activeData.state,_actvieWillOpenTime,true);
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show('王城争霸战',null,new Rectangle(e.stageX,e.stageY,0,0));
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
			if(_effect)
			{
				_effect.dispose();
				_effect = null;
			}
			
			instance = null;
			if(parent) parent.removeChild(this);
		}
		
	}
}