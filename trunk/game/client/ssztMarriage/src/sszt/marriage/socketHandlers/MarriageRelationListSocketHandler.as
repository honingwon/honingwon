package sszt.marriage.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.marriage.MarriageModule;
	import sszt.marriage.data.MarriageRelationItemInfo;
	
	public class MarriageRelationListSocketHandler extends BaseSocketHandler
	{
		public function MarriageRelationListSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MARRY_LIST;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var i:int
			var marriageRelation:MarriageRelationItemInfo;
			var list:Array = [];
			for(i = 0; i < len; i++)
			{
				marriageRelation = new MarriageRelationItemInfo();
				_data.readNumber();
				marriageRelation.userId = _data.readNumber();
				marriageRelation.type = _data.readShort();
				marriageRelation.career = _data.readShort();
				marriageRelation.sex = _data.readShort();
				marriageRelation.nick = _data.readUTF();
				list.push(marriageRelation);
			}
			module.marriageRelationList.update(list);
			
			handComplete();
		}
		
		public function get module():MarriageModule
		{
			return _handlerData as MarriageModule;
		}
		
		public static function send():void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MARRY_LIST);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}