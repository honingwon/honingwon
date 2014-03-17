package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.armyInfo.ClubArmyItemInfo;
	import sszt.club.datas.armyInfo.ClubArmyMemberInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubArmyUpdateSocketHandler extends BaseSocketHandler
	{
		public function ClubArmyUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_ARMY_UPDATE;
		}
		
		override public function handlePackage():void
		{
			if(clubModule.clubInfo.clubArmyInfo)
			{
				var enounce:String = _data.readString();
				var len:int = _data.readInt();
//				var result:Vector.<ClubArmyItemInfo> = new Vector.<ClubArmyItemInfo>();
				var result:Array = [];
				for(var i:int = 0; i < len; i++)
				{
					var info:ClubArmyItemInfo = new ClubArmyItemInfo();
					info.armyId = _data.readNumber();
					info.isExist = _data.readBoolean();
					if(info.isExist)
					{
						info.armyName = _data.readString();
						info.level = _data.readInt();
						info.masterName = _data.readString();
						info.masterLevel = _data.readInt();
						info.masterCareer = _data.readInt();
						info.memberCount = _data.readInt();
						
//						var list:Vector.<ClubArmyMemberInfo> = new Vector.<ClubArmyMemberInfo>();
						var list:Array = [];
						for(var j:int = 0; j < info.memberCount; j++)
						{
							var memberInfo:ClubArmyMemberInfo = new ClubArmyMemberInfo();
							memberInfo.userId = _data.readNumber();
							memberInfo.name = _data.readString();
							memberInfo.armyDuty = _data.readByte();
							list.push(memberInfo);
						}
						info.memberList = list;
					}
					result.push(info);
				}
				clubModule.clubInfo.clubArmyInfo.update(result,enounce);
			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_ARMY_UPDATE);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}