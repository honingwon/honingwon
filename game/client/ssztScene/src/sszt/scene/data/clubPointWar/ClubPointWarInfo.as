package sszt.scene.data.clubPointWar
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.scene.data.clubPointWar.mainInfo.ClubPointWarMainInfo;
	import sszt.scene.data.clubPointWar.scoreInfo.ClubPointWarScoreInfo;
	
	public class ClubPointWarInfo extends EventDispatcher
	{
		public var clubPointWarMainInfo:ClubPointWarMainInfo;
		public var clubPointWarScoreInfo:ClubPointWarScoreInfo;
		
		public function initialMainInfo():void
		{
			if(clubPointWarMainInfo == null)
			{
				clubPointWarMainInfo = new ClubPointWarMainInfo();
			}
		}
		
		public function clearMainIno():void
		{
			if(clubPointWarMainInfo)
			{
				clubPointWarMainInfo = null;
			}
		}
		
		public function initialScoreInfo():void
		{
			if(clubPointWarScoreInfo == null)
			{
				clubPointWarScoreInfo = new ClubPointWarScoreInfo();
			}
		}
		public function clearScoreInfo():void
		{
			if(clubPointWarScoreInfo)
			{
				clubPointWarScoreInfo = null;
			}
		}
	}
}