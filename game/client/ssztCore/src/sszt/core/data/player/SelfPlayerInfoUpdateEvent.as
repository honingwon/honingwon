package sszt.core.data.player
{
	import flash.events.Event;
	
	public class SelfPlayerInfoUpdateEvent extends Event
	{
		public static const MONEYUPDATE:String = "moneyUpdata";
		
		public static const EQUIPUPDATE:String = "equipUpdate";
		
		public static const STALLNAMEUPDATE:String = "stallNameUpdate";
		
		public static const PROPERTYUPDATE:String = "propertyUpdate";
		
		public static const SELFEXPLOIT_UPDATE:String = "selfExploitUpdate";
		
		public static const SELFHONOR_UPDATE:String = "selfHonorUpdate";
		
		public static const EXPUPDATE:String = "expUpdate";
		
		public static const PHYSICAL_UPDATE:String = "physicalUpdate";
		
		public static const TASK_ACCEPT:String = "taskAccept";
		public static const TASK_SUBMIT:String = "taskSubmit";
		
		public static const UPDATE_HPMP:String = "updateHpMp";
		
		public static const UPDATE_YUANBAO_SCORE:String = "updateYuanBaoScore";
		
		public static const LIFEEXP_UPDATE:String = "lifeExpUpdate";
		
		public static const FREE_PROPERTY_UPDATE:String = "freePropertyUpdate";
		
		public static const TOTAL_LIFE_EXP_UPDATE:String = "totalLifeExpUpdate";
		
		public static const CAMP_TYPE_UPDATE:String = "campTypeUpdate";
		
		public var data:Object;
		
		public function SelfPlayerInfoUpdateEvent(type:String,obj:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = obj;
			super(type, bubbles, cancelable);
		}
	}
}