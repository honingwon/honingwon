package sszt.scene.data.crystalWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.data.crystalWar.mainInfo.CrystalWarMainInfo;
	import sszt.scene.data.crystalWar.scoreInfo.CrystalWarScoreInfo;
	
	public class CrystalWarInfo extends EventDispatcher
	{
		public var crystalWarMainInfo:CrystalWarMainInfo;
		public var crystalWarScoreInfo:CrystalWarScoreInfo;
		
		public function initialMainInfo():void
		{
			if(crystalWarMainInfo == null)
			{
				crystalWarMainInfo = new CrystalWarMainInfo();
			}
		}
		
		public function clearMainIno():void
		{
			if(crystalWarMainInfo)
			{
				crystalWarMainInfo = null;
			}
		}
		
		public function initialScoreInfo():void
		{
			if(crystalWarScoreInfo == null)
			{
				crystalWarScoreInfo = new CrystalWarScoreInfo();
			}
		}
		public function clearScoreInfo():void
		{
			if(crystalWarScoreInfo)
			{
				crystalWarScoreInfo = null;
			}
		}
	}
}