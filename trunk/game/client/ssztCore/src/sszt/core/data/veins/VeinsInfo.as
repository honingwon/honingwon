package sszt.core.data.veins
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;
	
	public class VeinsInfo extends EventDispatcher implements ITick
	{
		public var acupointType:int;
		private var _veinsTemplate:VeinsTemplateInfo;
		public var acupointLv:int;
		public var genguLv:int;
		public var luck:int;
		public var isUping:Boolean;	//是否在修炼中
		
		public function VeinsInfo()
		{
			isUping = false;
		}
		
		public function getTemplate():VeinsTemplateInfo
		{
			if(_veinsTemplate == null || _veinsTemplate.totalLevel != acupointLv )
			{
				_veinsTemplate = VeinsTemplateList.getVeins(acupointType, acupointLv);
			}
			return _veinsTemplate;
		}
		public function getNextXueweiTemplate():VeinsTemplateInfo
		{
			return VeinsTemplateList.getVeins(acupointType, acupointLv + 1);
		}
		public function getLimitXuewei():int
		{
			if(acupointType == AcupointType.BAIHUI)
				return AcupointType.YONGQUAN;
			else
				return acupointType - 1;
		}
		public function getNextGenguTemplate():VeinsTemplateInfo
		{
			return VeinsTemplateList.getVeins(acupointType, genguLv + 1);
		}
		
		public function canUpgradeAcupoint():Boolean
		{
			var nextVeinsTemplate:VeinsTemplateInfo = VeinsTemplateList.getVeins(acupointType, acupointLv);
			if (nextVeinsTemplate == null)
				return false;
			if(nextVeinsTemplate.needCopper > GlobalData.selfPlayer.userMoney.copper)
				return false;
			if(nextVeinsTemplate.needLifeExp > GlobalData.selfPlayer.lifeExperiences)
				return false;
			return true;
		}
		public function update(times:int,dt:Number = 0.04):void
		{
			
		}
//		public function dataUpdate():void
//		{
//			
//		}
	}
}