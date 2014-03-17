package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.activity.ActiveTemplateInfoList;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.data.module.changeInfos.ToQuizData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActiveStartEvents;
	import sszt.events.ActivityEvent;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;

	/**
	 * 开服活动 
	 * @author chendong
	 * 
	 */	
	public class OpenActivityView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		/**
		 * 倒计时 
		 * 天-时-分-秒
		 */
		private var _countDown:CountDownView;
		private var _effect:BaseLoadEffect;
		
		
		/**
		 * 是否显示特效 
		 */
		private static var _isEffectShow:Boolean = true;
		
		/**
		 * 是否开启按钮 
		 */
		private static var _isShow:Boolean = true;
		
		/**
		 * 开户活动groupid数组
		 * 1:首充2:开服充值,3:开服消费4.单笔充值5.VIP6.紫装7.一定时间内升级  
		 */
		private static var _groupIdArray:Array = [41,42,43,44,51,52,53,6,71,72,73,74];
		
		/**
		 * 0:登录已经点击按钮过, 1:登录已经未击按钮过
		 */
		private var _isLogin:int = 1;
		
		/**
		 * 最大开服时间 
		 */
		private var _maxOpenTime:int = 0;
		
		public function OpenActivityView()
		{
			super();
//			_index = 10;
			init();
			
			_maxOpenTime = getOpenServerTime();
			_isEffectShow = getCanGet();
			
//			if( _maxOpenTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000  < 0) 
//			{
//				dispose();
//			}
//			else
//			{
				initData();
				initEvent();
//			}
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new OpenActivityView() as IActivityView;
			}
			return instance;
		}
		
//		override public function show(arg1:int=0, arg2:Object=null, isDispatcher:Boolean=false):void
//		{
//			// TODO Auto Generated method stub
////			if(arg1 == 1)
////			{
////				return; //arg1 =1 只是为了创建实例注册事件，改变静态变量_isEffectShow值
////			}
//			super.show(arg1, arg2, isDispatcher);
//		}
		
		public function hideEffect():void
		{
			_effect.visible = false;
		}
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnOpenServiceAsset") as MovieClip);
			addChild(_btn);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(55,18);
//			_countDown.move(0,55);
//			addChild(_countDown);
			
			
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
			
			_countDown.addEventListener(Event.COMPLETE,completeOpenAct);
			
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,dataUpdateHandler);
//			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getEffectShow);
			
			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,dataUpdateHandler);
//			ModuleEventDispatcher.addModuleEventListener(ActivityEvent.GET_AWARD,getOpenActIsShow);
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
			var t:int = _maxOpenTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000  < 0  ? 0:_maxOpenTime  - GlobalData.systemDate.getSystemDate().valueOf() /1000 ;
			
			_countDown.start( t );
			
		}
		
		private function onClick(e:MouseEvent):void
		{
			_isLogin = 0;
			initData();
			SetModuleUtils.addOpenActivity();
		}
		
		private function completeOpenAct(evt:Event):void
		{
			hide(true);
		}
		
		
		
		private function dataUpdateHandler(evt:ModuleEvent):void
		{
			_maxOpenTime = getOpenServerTime();
			_isEffectShow = getCanGet();
			initData();
			if(_topIconState[_index] ==0 && _maxOpenTime>0)
				this.show(0,null,true);
		}	
		
		
		private function getCanGet():Boolean
		{
			var tempIsShow:Boolean = false;
			var opAct:Array;
			var opActObj:OpenActivityTemplateListInfo;
			var state:int =0;
			for(var j:int = 0;j<_groupIdArray.length;j++)
			{
				opAct = OpenActivityUtils.getActivityArray(_groupIdArray[j])
				for(var i:int = 0; i<opAct.length; i++)
				{
					opActObj = opAct[i];
					state = OpenActivityUtils.getedActivity(opActObj.group_id,opActObj.id,opActObj.need_num);
					if(state == 1)
					{
						tempIsShow = true;
						break;
					}
				}
			}
			return tempIsShow;
		}
		
		
		private function getOpenServerTime():int
		{
			var tempDic:Dictionary = GlobalData.openActivityInfo.activityDic;
			var sysData:int = GlobalData.systemDate.getSystemDate().valueOf()*0.001;
			var tempIsShow:Boolean = false;
			var tempOpenTime:int = 0;
			for each(var obj:Object in tempDic)
			{
				if(int(obj.groupId) != 1 && int(obj.groupId) != 2 && int(obj.groupId) != 3 && int(obj.groupId) != 81 && int(obj.groupId) != 82 && int(obj.groupId) != 83 && int(obj.openTime) > sysData)
				{
					tempIsShow = true;
					if(int(obj.openTime) > tempOpenTime)
					{
						tempOpenTime = int(obj.openTime);  //获取开服活动最大开服时间
					}
				}
			}
			return tempOpenTime;
		}
		
		
		override protected function layout(e:SceneModuleEvent):void
		{
			if(e.data != instance)
			{
				setPosition();
			}
		}
		
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.activity.openActivity"),null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		override protected function removeEvent():void
		{
			// TODO Auto Generated method stub
			super.removeEvent();
			
			_btn.removeEventListener(MouseEvent.CLICK,onClick);
			_btn.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_btn.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			
			_countDown.removeEventListener(Event.COMPLETE,completeOpenAct);
			
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,dataUpdateHandler);
//			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_OPEN_SERVER_DATA,getEffectShow);
			
			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,dataUpdateHandler);
//			ModuleEventDispatcher.removeModuleEventListener(ActivityEvent.GET_AWARD,getOpenActIsShow);
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
			
			instance = null;
			if(parent) parent.removeChild(this);
		}
		
	}
}