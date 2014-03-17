package sszt.scene.components.ActivityIcon
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.activity.ActiveStarTimeData;
	import sszt.core.data.activity.ActiveTemplateInfoList;
	import sszt.core.data.module.changeInfos.ToActivityData;
	import sszt.core.data.module.changeInfos.ToPvPData;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.countDownView.CountDownView;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.ActiveStartEvents;
	import sszt.events.ModuleEvent;
	import sszt.events.SceneModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.label.MAssetLabel;

	public class PVPView extends BaseIconView
	{
		private static var instance:IActivityView;
		
		private var _btn:MAssetButton1;
		private var _isShow:Boolean;
		
		/**
		 * 活动时间信息 20:00-20:30
		 */		
		private var _timeShow:MAssetLabel;
		/**
		 * 倒计时 
		 * 00:00:00 
		 */
		private var _countDown:CountDownView;
		private var _effect:BaseLoadEffect;
		
		/**
		 * 单挑活动id 
		 */		
		private var activeId:int = 12;
		
		private var _canUse:Boolean = false;
		
		/**
		 * pvp活动id 
		 */
		private var _pvpActiveId:int = 1001;
		
		/**
		 * 活动即将开启 倒计时 秒
		 */
		private var _actvieWillOpenTime:int = 1800;
		
		private var _activeData:ActiveStarTimeData;
		
		public function PVPView()
		{
			super();
//			_index = 4;
			init();
			initEvent();
//			initData();
		}
		public static function getInstance():IActivityView
		{
			if(instance == null)
			{
				instance = new PVPView() as IActivityView;
			}
			return instance;
		}
		
		override public function show(state:int=-1,arg2:Object =null,isDispatcher:Boolean = false):void
		{
			if(state >=1 && state <=3)
			{
//				if(!arg2)
//				{
//					_actvieWillOpenTime = 1800;
//				}
				if(arg2 != null)
				{
					_actvieWillOpenTime = int(arg2);
				}
				if(state == 1)
				{
					updateActiveStartTimeToOne();
				}
//				else if(state == 2)
//				{
//					updateActiveStartTimeToTow();
//				}
				else if(state==3) //隐藏效果
				{
					_effect.visible = false;
				}
				super.show(state,arg2,isDispatcher);
			}
		}
		
		
		private function init():void
		{
			_btn = new MAssetButton1(AssetUtil.getAsset("ssztui.scene.TopBtnFBAsset") as MovieClip);
			addChild(_btn);
			
			_countDown = new CountDownView();
			_countDown.setLabelType(new TextFormat("SimSun",12,0x00ff00,null,null,null,null,null,TextFormatAlign.CENTER));
			_countDown.textField.filters = [new GlowFilter(0x000000,1,2,2,6)]
			_countDown.setSize(55,18);
			_countDown.move(0,55);
			addChild(_countDown);
			_countDown.visible = false;
			
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
			ModuleEventDispatcher.addModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,updateActiveTime);
		}
		
		private function initData():void
		{
			setData();
		}
		
		private function completePVP(evt:Event):void
		{
			_effect.visible = true;
			_countDown.visible = false;
		}
		
		private function updateActiveTime(evt:ModuleEvent):void
		{
			setData();
		}
		
		private function setData():void
		{
			_activeData = GlobalData.activeStartInfo.activeTimeInfo[_pvpActiveId];
			_actvieWillOpenTime = _activeData.time;
			show(_activeData.state,_actvieWillOpenTime,true);
			
		}
		
		private function getSec(timeValue:Number):int
		{
			var mydate:Date = new Date();
			var hour:Number = mydate.getHours();
			var minute:Number = mydate.getMinutes();
			var second:Number = mydate.getSeconds();
			return second + minute*60 + hour*3600;
		}
		
		/**
		 * 活动即将开启
		 */		
		private function updateActiveStartTimeToTow():void
		{
			_canUse = false;
			_countDown.visible = true;
			_countDown.start(_actvieWillOpenTime);
		}
		
		/**
		 * 活动开启
		 */		
		private function updateActiveStartTimeToOne():void
		{
			_countDown.visible = true;
			_countDown.start(_actvieWillOpenTime);
			_canUse = true;
			_effect.visible = true;
		}
		
		private function onClick(e:MouseEvent):void
		{
			show(3);
			if(GlobalData.selfPlayer.level < 35)
			{
				SetModuleUtils.addActivity(new ToActivityData(2,0,21));
			}
			else
			{
				var pvpData:ToPvPData = new ToPvPData();
				pvpData.openPanel = 2;
				SetModuleUtils.addPVP1(pvpData);
			}
			
//			_activeData = GlobalData.activeStartInfo.activeTimeInfo[_pvpActiveId];
//			if(_canUse && GlobalData.pvpInfo.current_active_id != 0 && _activeData.state == 1)
//			{
//				if(GlobalData.selfPlayer.level >= 35)
//				{
//					var pvpData:ToPvPData = new ToPvPData();
//					pvpData.openPanel = 2;
//					SetModuleUtils.addPVP1(pvpData);
//				}
//				else
//				{
//					QuickTips.show(LanguageManager.getWord("ssztl.pvp.pvpName")+LanguageManager.getWord("ssztl.pvp.roleLevel"));
//				}
//			}
//			else
//			{
////				QuickTips.show(ActiveTemplateInfoList.getActiveTempalteInfo(activeId).activeName+ LanguageManager.getWord("ssztl.scene.startTime") +ActiveTemplateInfoList.getActiveTempalteInfo(activeId).activeTime);
//				QuickTips.show(LanguageManager.getWord("ssztl.pvp.pvpName")+LanguageManager.getWord("ssztl.pvp.openTime"));
//			}
		}
		private function overHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.pvp.pvpName"),null,new Rectangle(e.stageX,e.stageY,0,0));
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
			_countDown.removeEventListener(Event.COMPLETE,completePVP);
			ModuleEventDispatcher.removeModuleEventListener(ActiveStartEvents.ACTIVE_START_UPDATE,updateActiveTime);
			
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