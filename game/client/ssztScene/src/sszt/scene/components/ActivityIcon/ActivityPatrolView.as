package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.moduleViewType.ActivityModuleViewType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
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
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	
	/**
	 * 京城巡逻
	 * @author Aron
	 * 
	 */	
	public class ActivityPatrolView extends BaseIconView
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
		
		public function ActivityPatrolView()
		{
			super();
//			_index = 14;
			init();
			initEvent();
			initData();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new ActivityPatrolView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(state:int=0,arg2:Object=null,isDispatcher:Boolean=false):void
		{
			if(state != 1 && state != 2) return;
			_state = state;
//			if(arg2 != null)
//			{
//				_actvieWillOpenTime = int(arg2);
//			}
			if(state == 1)
			{
				_effect.visible = true;
			}
			if(state == 2)
			{
				_countDown.visible = true;
				if(arg2 != null)
					_countDown.start(int(arg2));
			}
			
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
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnActiveXLAsset") as MovieClip);
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
			addChild(_btn);
			
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.TOPNAV_EFFECT));
			_effect.move(27,26);
			_effect.play();
			addChild(_effect);
			
			
		}
		override protected function initEvent():void
		{
			// TODO Auto Generated method stub
			super.initEvent();
			_btn.addEventListener(MouseEvent.CLICK,onClick);
			_btn.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		
		
		private function initData():void
		{
			if(_isEffectShow && (!GlobalData.yellowBoxInfo.isReceNewPack || GlobalData.yellowBoxInfo.receDayPack <=0 || !GlobalData.yellowBoxInfo.levelUpPack))
			{
				_effect.visible = true;
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			//断玩家等级是否达到
			if(GlobalData.selfPlayer.level < 20)
			{
				SetModuleUtils.addActivity(new ToActivityData(2,0,24));
			}
			else
			{
				SetModuleUtils.addActivity(new ToActivityData(ActivityModuleViewType.ACTIVITY_START_REMAINING,0,2));
			}
//			if(_effect.visible)
//			{
//				_effect.visible = false;
//			}
		}
		
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.ActivityPatrol"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			// TODO Auto Generated method stub
			super.removeEvent();
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
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