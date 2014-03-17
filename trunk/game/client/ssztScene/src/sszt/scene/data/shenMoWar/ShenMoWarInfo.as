package sszt.scene.data.shenMoWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.data.shenMoWar.mainInfo.honoerInfo.ShenMoWarHonorInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarMenbersInfo;
	import sszt.scene.data.shenMoWar.menbersInfo.ShenMoWarResultInfo;
	import sszt.scene.data.shenMoWar.myWarInfo.ShenMoWarMyWarInfo;
	
	public class ShenMoWarInfo extends EventDispatcher
	{
		public var shenMoWarHonorInfo:ShenMoWarHonorInfo;
		public var shenMoWarMembersInfo:ShenMoWarMenbersInfo;
		public var shenMoWarMyWarInfo:ShenMoWarMyWarInfo;
		public var shenMoWarResult:ShenMoWarResultInfo;
		public var warSceneId:Number = -1;
		
		public function ShenMoWarInfo()
		{
		}
		
		/**荣誉信息**/
		public function initShenMoWarHonorInfo():void
		{
			if(!shenMoWarHonorInfo)
			{
				shenMoWarHonorInfo = new ShenMoWarHonorInfo();
			}
		}
		public function clearShenMoWarHonorInfo():void
		{
			if(shenMoWarHonorInfo)
			{
				shenMoWarHonorInfo = null;
			}
		}
		/**人员信息**/
		public function initShenMoWarMenbersInfo():void
		{
			if(shenMoWarMembersInfo == null)
			{
				shenMoWarMembersInfo = new ShenMoWarMenbersInfo();
			}
		}
		public function clearShenMoWarMenbersInfo():void
		{
			if(shenMoWarMembersInfo)
			{
				shenMoWarMembersInfo = null;
			}
		}
		/**我的战报**/
		public function initShenMoWarMyWarInfo():void
		{
			if(shenMoWarMyWarInfo == null)
			{
				shenMoWarMyWarInfo = new ShenMoWarMyWarInfo();
			}
		}
		public function clearShenMoWarMyWarInfo():void
		{
			if(shenMoWarMyWarInfo)
			{
				shenMoWarMyWarInfo = null;
			}
		}
		/**乱斗结果**/
		public function initShenMoWarResultInfo():void
		{
			if(shenMoWarResult == null)
			{
				shenMoWarResult = new ShenMoWarResultInfo();
			}
		}
		public function clearShenMoWarResultInfo():void
		{
			if(shenMoWarResult)
			{
				shenMoWarResult = null;
			}
		}
	}
}