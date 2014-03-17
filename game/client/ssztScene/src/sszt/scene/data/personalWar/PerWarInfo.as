package sszt.scene.data.personalWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.data.personalWar.menber.PerWarMembersInfo;
	import sszt.scene.data.personalWar.menber.PerWarResultInfo;
	import sszt.scene.data.personalWar.myInfo.PerWarMyWarInfo;
	
	public class PerWarInfo extends EventDispatcher
	{
		public var perWarMainInfo:PerWarMainInfo;
		public var perWarMembersInfo:PerWarMembersInfo;
		public var perWarMyWarInfo:PerWarMyWarInfo;
		public var perWarResultInfo:PerWarResultInfo;
		public var warSceneId:Number = -1;
		
		public function PerWarInfo()
		{
			
		}
		
		/**进入战场信息**/
		public function initPerWarMainInfo():void
		{
			if(!perWarMainInfo)
			{
				perWarMainInfo = new PerWarMainInfo();
			}
		}
		public function clearPerWarMainInfo():void
		{
			if(perWarMainInfo)
			{
				perWarMainInfo = null;
			}
		}
		/**人员信息**/
		public function initPerWarMembersInfo():void
		{
			if(perWarMembersInfo == null)
			{
				perWarMembersInfo = new PerWarMembersInfo();
			}
		}
		public function clearPerWarMembersInfo():void
		{
			if(perWarMembersInfo)
			{
				perWarMembersInfo = null;
			}
		}
		/**我的战报**/
		public function initPerWarMyWarInfo():void
		{
			if(perWarMyWarInfo == null)
			{
				perWarMyWarInfo = new PerWarMyWarInfo();
			}
		}
		public function clearPerWarMyWarInfo():void
		{
			if(perWarMyWarInfo)
			{
				perWarMyWarInfo = null;
			}
		}
		/**乱斗结果**/
		public function initPerWarResultInfo():void
		{
			if(perWarResultInfo == null)
			{
				perWarResultInfo = new PerWarResultInfo();
			}
		}
		public function clearPerWarResultInfo():void
		{
			if(perWarResultInfo)
			{
				perWarResultInfo = null;
			}
		}
	}
}