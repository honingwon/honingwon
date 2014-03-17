package sszt.club.socketHandlers
{
	import sszt.club.ClubModule;
	import sszt.club.datas.list.ClubListItemInfo;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.ClubLevelTemplate;
	import sszt.core.data.club.ClubLevelTemplateList;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class ClubQueryListSocketHandler extends BaseSocketHandler
	{
		public function ClubQueryListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_QUERYLIST;
		}
		
		override public function handlePackage():void
		{
			var total:int = _data.readInt();
			var len:int = _data.readInt();
//			var result:Vector.<ClubListItemInfo> = new Vector.<ClubListItemInfo>();
			var result:Array = [];
			for(var i:int = 0; i < len; i++)
			{
				var info:ClubListItemInfo = new ClubListItemInfo();
				info.id = _data.readNumber();
				info.name = _data.readString();
				info.level = _data.readByte();
				var temp:ClubLevelTemplate = ClubLevelTemplateList.getTemplate(info.level);
				info.totalMember = temp.total;
//				info.masterServerId = _data.readShort();
				info.masterId = _data.readNumber();
				info.masterName = _data.readString();
				info.masterType = _data.readByte();
				info.rich = _data.readInt();
//				info.activity = _data.readInt();
//				info.totalMember = _data.readShort();
				info.currentMember = _data.readShort();
				info.requestsNumber = _data.readShort();
				info.notice = _data.readString();
				info.furnaceLevel = _data.readByte();
				info.shopLevel = _data.readByte();
				
				result.push(info);
			}
			if(clubModule.clubInfo.clubListInfo)
			{
				clubModule.clubInfo.clubListInfo.total = total;
				clubModule.clubInfo.clubListInfo.setList(result);
			}
			
			handComplete();
		}
		
		private function get clubModule():ClubModule
		{
			return _handlerData as ClubModule;
		}
		/**
		 * 
		 * @param page
		 * @param pagesize
		 * @param name
		 * 
		 */		
		public static function send(page:int,pagesize:int = 11,clubName:String = "",masterName:String = ""):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_QUERYLIST);
			pkg.writeShort(page);
			pkg.writeByte(pagesize);
			pkg.writeString(clubName);
			pkg.writeString(masterName);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}