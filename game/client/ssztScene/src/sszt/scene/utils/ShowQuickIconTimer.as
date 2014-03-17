package sszt.scene.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.veins.AcupointType;
	import sszt.core.data.veins.VeinsInfo;
	import sszt.core.data.veins.VeinsTemplateInfo;
	import sszt.core.data.veins.VeinsTemplateList;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;

	public class ShowQuickIconTimer
	{
		private static var _showQuickIconTimer:ShowQuickIconTimer;
		private var _timer:Timer = new Timer(30000,0);
		private static const limitLv:uint = 30; //经脉等级学习限制
		/**
		 * 记时类型 
		 */
		private var _type:int; 
		
		public static function getInstance():ShowQuickIconTimer
		{
			if(!_showQuickIconTimer)
			{
				_showQuickIconTimer = new ShowQuickIconTimer();
			}
			return _showQuickIconTimer;
		}
		
		public function startTimer(type:int):void
		{
			_type = type;
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			switch(_type)
			{
				case 0:
					shwoQuickVeinsIcon();
					break;
			}
		}
		
		/**
		 * 打开穴位快速按钮
		 */
		private function shwoQuickVeinsIcon():void
		{
			var veins:VeinsInfo = GlobalData.veinsInfo.getVeinsByAcupointType(GlobalData.veinsInfo.getDefaultSelectAcupoint() + 1);
			if(!veins)
			{
				//如果下一个穴位不存在，则加进入
//				veins = new VeinsInfo();
//				veins.acupointType = GlobalData.veinsInfo.getDefaultSelectAcupoint() + 1;
//				veins.acupointLv = 0;
//				veins.genguLv = 0;
//				veins.luck = 0;
//				GlobalData.veinsInfo.addVeins(veins);
				return;
			}
			var nextXuewei:VeinsTemplateInfo = veins.getNextXueweiTemplate();
			var checkUpgrade:Boolean = true;
			if(veins.acupointLv >= VeinsTemplateList.getMaxLeve())
			{
				checkUpgrade = false;
			}
			if(GlobalData.selfPlayer.userMoney.allCopper >= nextXuewei.needCopper)
			{
				
			}
			else
			{
				checkUpgrade = false;
			}
			if(GlobalData.selfPlayer.lifeExperiences >= nextXuewei.needLifeExp)
			{
				
			}
			else
			{
				checkUpgrade = false;
			}
			var limitXuewei:int = veins.getLimitXuewei();
			var limitXueweiLv:int = nextXuewei.totalLevel;
			if (limitXuewei == AcupointType.YONGQUAN)
				limitXueweiLv --;
			if(GlobalData.veinsInfo.getAcupointLvByAcupointType(limitXuewei) < limitXueweiLv)
			{
				checkUpgrade = false;
			}
			if(GlobalData.selfPlayer.level < limitLv + nextXuewei.totalLevel)
			{
				checkUpgrade = false;
			}
			if(!veins.isUping && checkUpgrade)
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.VEINS_UPGRADE));
			}
		}
	}
}