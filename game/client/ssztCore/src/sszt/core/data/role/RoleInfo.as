package sszt.core.data.role
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.data.titles.TitleTemplateInfo;
	import sszt.core.data.veins.VeinsList;
	
	/**
	 * 其他玩家的角色信息，自己的角色信息不在此处保存
	 * */
	public class RoleInfo extends EventDispatcher
	{
		public static const EQUIP_SIZE:int = 30;
		/**其他玩家人物信息数据**/
		private var _playerInfo:DetailPlayerInfo;
		/**其他玩家身上装备,自己装备放在自己背包**/
		//		private var _equipList:Vector.<ItemInfo>;
		private var _equipList:Array;
		/**称号列表数据**/
		private var _titleTemplateInfo:TitleTemplateInfo;
		
		public var _nameCurrentId:int;
		
		public var veins:VeinsList = new VeinsList();
		
		public function RoleInfo()
		{
		}
		public function get playerInfo():DetailPlayerInfo
		{
			return _playerInfo;
		}
		
		public function set playerInfo(value:DetailPlayerInfo):void
		{
			_playerInfo = value;
			dispatchEvent(new RoleInfoEvents(RoleInfoEvents.ROLEINFO_INITIAL));
		}
		
		public function get titleTemplateInfo():TitleTemplateInfo
		{
			return _titleTemplateInfo;
		}
		
		public function set titleTemplateInfo(value:TitleTemplateInfo):void
		{
			_titleTemplateInfo = value;
			dispatchEvent(new RoleInfoEvents(RoleInfoEvents.ROLENAME_SETDATA));
		}
		
		public function get equipList():Array
		{
			return _equipList;
		}
		
		public function set equipList(value:Array):void
		{
			_equipList = value;
		}
		
		public function getItem(place:int):ItemInfo
		{
			for each(var i:ItemInfo in _equipList)
			{
				if(i && i.place == place)
				{
					return i;
				}
			}
			return null;
		}
		
		public function updateVeins():void
		{
			dispatchEvent(new RoleInfoEvents(RoleInfoEvents.VEINS_UPDATE));
		}
	}
}