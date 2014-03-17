package sszt.personal.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.core.data.personal.PersonalMyInfo;
	
	public class PersonalPartInfo extends EventDispatcher
	{
		public var personalPartLuckyInfo:PersonalPartLuckyInfo;
		public var personaOtherMainInfo:PersonalMyInfo;
		public function PersonalPartInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function initPersonalPartLuckyInfo():void
		{
			if(personalPartLuckyInfo == null)
			{
				personalPartLuckyInfo = new PersonalPartLuckyInfo();
			}
		}
		
		public function clearPersonalPartLuckyInfo():void
		{
			if(personalPartLuckyInfo)
			{
				personalPartLuckyInfo = null;
			}
		}
		
		public function initOtherMainInfo():void
		{
			if(personaOtherMainInfo == null)
			{
				personaOtherMainInfo = new PersonalMyInfo();
			}
		}
		
		public function clearOtherMainInfo():void
		{
			if(personaOtherMainInfo)
			{
				personaOtherMainInfo = null;
			}
		}
	}
}