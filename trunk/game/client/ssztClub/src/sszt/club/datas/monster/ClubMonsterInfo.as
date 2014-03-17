package sszt.club.datas.monster
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubMonsterUpdateEvent;
	
	public class ClubMonsterInfo extends EventDispatcher
	{
		public var monsterLevel:int;
		public var currentClubLevel:int;
		public var currentClubRich:int;
		
		public function ClubMonsterInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new ClubMonsterUpdateEvent(ClubMonsterUpdateEvent.CLUB_MONSTER_UPDATE));
		}
	}
}