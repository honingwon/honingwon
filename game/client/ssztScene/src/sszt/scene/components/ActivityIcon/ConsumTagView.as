package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MAlert;
	
	/**
	 * 消费奖励
	 * @author chendong
	 * 
	 */	
	public class ConsumTagView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		private var _effect:BaseLoadEffect;
		
		/**
		 * 是否显示特效 
		 */
		private static var _isEffectShow:Boolean = true;
		
		/**
		 * 1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级 
		 */		
		private var groupId:int = 3;
		
		/**
		 * 0:登录已经点击按钮过, 1:登录已经未击按钮过
		 */
		private var _isLogin:int = 1;
		
		private var _stopTime:int = 0;
		
		private var _countDown:CountDownView;
		
		public function ConsumTagView()
		{
			super();
			_stopTime = getOpenServerTime();
			_index = 18;
			init();
			initEvent();
			initData();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new ConsumTagView() as IActivityView;
			}
			return instance;
		}
		private function init():void
		{
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(55,18);
			//			_countDown.move(0,55);
//			addChild(_countDown);
			
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnConsumAsset") as MovieClip);
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
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getConsum);
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getConsumTagAct);
			
			_countDown.addEventListener(Event.COMPLETE,completeOpenAct);
		}
		private function completeOpenAct(evt:Event):void
		{
			hide(true);
		}
		
		private function initData():void
		{
			if(_isEffectShow || _isLogin == 1)
			{
				_effect.visible = true;
			}
			else
			{
				_effect.visible = false;
			}
			
			var t:int =_stopTime - GlobalData.systemDate.getSystemDate().valueOf() /1000;
			if(t>0)
			{
				_countDown.start( t );
				if(_topIconState[_index] ==0)
				{
					show();
				}
			}
			else
			{
				_countDown.start( 0 );
			}
		}
		
		private function getConsum(evt:ModuleEvent):void
		{
			setisEffectShow();
		}
		
		private function getConsumTagAct(evt:ModuleEvent):void
		{
			_stopTime = getOpenServerTime();
			setisEffectShow();
		}
		
		private function setisEffectShow():void
		{
			var tempIsShow:Boolean = false;
			var opAct:Array = OpenActivityUtils.getActivityArray(groupId);
			var opActObj:OpenActivityTemplateListInfo;
			var i:int = 0;
			var state:int =0;
			for(i = 0; i<opAct.length; i++)
			{
				opActObj = opAct[i];
				state = OpenActivityUtils.getedActivity(opActObj.group_id,opActObj.id,opActObj.need_num);
				if(state == 1 || _isLogin == 1)
				{
					tempIsShow = true;
					break;
				}
			}
			_isEffectShow = tempIsShow;
			initData();
		}
		private function getOpenServerTime():int
		{
			var tempDic:Dictionary = GlobalData.openActivityInfo.activityDic;
			var tempOpenTime:int = 0;
			for each(var obj:Object in tempDic)
			{
				if(int(obj.groupId) == 3)
				{
					tempOpenTime = int(obj.openTime);  //获取开服活动最大开服时间
				}
			}
			return tempOpenTime;
		}
		private function onClick(e:MouseEvent):void
		{
			_isLogin = 0;
			initData();
			SetModuleUtils.addConsumTagView();
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.listLabel3"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getConsum);
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getConsumTagAct);
			_countDown.removeEventListener(Event.COMPLETE,completeOpenAct);
		}
		
		
		
		override public function dispose():void
		{
			super.dispose();
			if(_btn)
			{
				_btn.dispose();
				_btn = null;
			}
			if(_countDown)
			{
				_countDown.dispose();
				_countDown = null;
			}
			instance = null
			if(parent) parent.removeChild(this);
		}
		
	}
}