package sszt.core.data.role
{
	import flash.events.Event;
	
	public class RoleInfoEvents extends Event
	{
		public static const ROLEINFO_INITIAL:String = "roleInfoInitial";
		public static const ROLENAME_SETDATA:String = "roleName_setData";
		public static const VEINS_UPDATE:String = "veinsUpdate";
		
		public var data:Object;
		
		public function RoleInfoEvents(type:String, argData:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			data = argData;
		}
	}
}