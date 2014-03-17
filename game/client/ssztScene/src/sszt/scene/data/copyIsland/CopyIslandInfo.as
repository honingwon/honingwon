package sszt.scene.data.copyIsland
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.data.copyIsland.beforeEnter.CIBeforeInfo;
	
	public class CopyIslandInfo extends EventDispatcher
	{
		public var cIMainInfo:CIMaininfo;
		public var cIBeforeInfo:CIBeforeInfo;
		public var cIKingInfo:CIKingInfo;
		public function CopyIslandInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function initCIMaininfo():void
		{
			if(cIMainInfo == null)
			{
				cIMainInfo = new CIMaininfo();
			}
		}
				
		public function clearCIMaininfo():void
		{
			if(cIMainInfo)
			{
				cIMainInfo = null;
			}
		}
		
		public function initCIKingInfo():void
		{
			if(cIKingInfo == null)
			{
				cIKingInfo = new CIKingInfo();
			}
		}
		
		public function clearCIKingInfo():void
		{
			if(cIKingInfo)
			{
				cIKingInfo = null;
			}
		}
		
		
		public function initCIBeforeInfo():void
		{
			if(cIBeforeInfo == null)
			{
				cIBeforeInfo = new CIBeforeInfo();
			}
		}
		
		public function clearCIBeforeInfo():void
		{
			if(cIBeforeInfo)
			{
				cIBeforeInfo = null;
			}
		}
	}
}