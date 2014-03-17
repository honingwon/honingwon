package sszt.club.datas.levelup
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import sszt.club.events.ClubManageInfoUpdateEvent;
	
	public class ClubLevelUpInfo extends EventDispatcher
	{
		public var level:int;
		public var needContribute:int;										//物资
		public var needLiveness:int;										//繁荣度
		public var needRich:int;											//资金
//		public var honorNum:int;										//荣誉成员增加数
//		public var formalNum:int;										//正式成员增加数
//		public var prepareNum:int;									//预备成员增加数
		public var clubContribute:int;
		public var clubLiveness:int;
		public var clubRich:int;
		
		public function ClubLevelUpInfo(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function update():void
		{
			dispatchEvent(new ClubManageInfoUpdateEvent(ClubManageInfoUpdateEvent.LEVELUP_INFO_UPDATE));
		}
	}
}