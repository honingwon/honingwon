package sszt.core.socketHandlers.notice
{
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PlayerNoticeUtil;

	public class PlayerNoticeHandler extends BaseSocketHandler
	{
		public function PlayerNoticeHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function handlePackage():void
		{
			var serverId:int;
			var nickName:String;
			var tempId:int;
			var level:int;
			var monsterId:int;
			var itemId:Number;
			var useId:Number;
			var type:int = _data.readInt();
			switch(type)
			{
				case 1:
					break;
				case 2:
					break;
				case 3:
					serverId = _data.readShort();
					nickName = _data.readUTF();
					tempId = _data.readInt();
					PlayerNoticeUtil.openTaiChuBoxNotice(serverId,nickName,tempId);
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
				case 7:
					serverId = _data.readShort();
					PlayerNoticeUtil.petEggOpenNotice(serverId,_data.readUTF(),_data.readUTF());
					break;
				case 8:
					serverId = _data.readShort();
					PlayerNoticeUtil.useHalfYearVipCard(serverId,_data.readUTF());
					break;
				case 9:
					serverId = _data.readShort();
					nickName = _data.readUTF();
					level = _data.readInt();
					PlayerNoticeUtil.chiYueKuNotice(serverId,nickName,level);
					break;
				case 10:
					serverId = _data.readShort();
					nickName = _data.readUTF();
					monsterId = _data.readInt();
					tempId = _data.readInt();
					PlayerNoticeUtil.killMonster(serverId,nickName,monsterId,tempId);
					break;
				case 11:
					serverId = _data.readShort();
					nickName = _data.readUTF();
					itemId = _data.readNumber();
					tempId = _data.readInt();
					level = _data.readInt();
					useId = _data.readNumber();
					PlayerNoticeUtil.equipStrengthNotice(serverId,nickName,itemId,tempId,level,useId);
					break;
				case 12:
					serverId = _data.readShort();
					nickName = _data.readUTF();
					tempId = _data.readInt();
					PlayerNoticeUtil.compoundStoneNotice(serverId,nickName,tempId);
					break;
				case 13:
					break;
				 case 14:
					 break;
				case 15:
					PlayerNoticeUtil.bossRefreshNotice(_data.readInt());
					break;
				case 16:
					PlayerNoticeUtil.bossRefreshNotice(_data.readInt());
					break;
				case 17:
					nickName = _data.readUTF();
					useId = _data.readNumber();
					itemId = _data.readNumber();
					tempId = _data.readInt();
					PlayerNoticeUtil.equipShenYou(nickName,useId,itemId,tempId);
					break;
				case 18:
					nickName = _data.readUTF();
					PlayerNoticeUtil.openLovePacket(nickName);
					break;
				case 20:
					nickName = _data.readUTF();
					useId = _data.readNumber();
					itemId = _data.readNumber();
					tempId = _data.readInt();
					PlayerNoticeUtil.equipUpgradeNotice(nickName,useId,itemId,tempId);
					break;
				case 21:
					serverId = _data.readShort();
					useId = _data.readNumber();
					nickName = _data.readUTF();
					itemId = _data.readNumber();
					tempId = _data.readInt();
					var petName:String = _data.readUTF();
					var growValue:int = _data.readByte();
					PlayerNoticeUtil.petGrowUpNotice(serverId,nickName,useId,itemId,tempId,petName,growValue);
					break;
				case 22:
					serverId = _data.readShort();
					useId = _data.readNumber();
					nickName = _data.readUTF();
					itemId = _data.readNumber();
					tempId = _data.readInt();
					var petNick:String = _data.readUTF();
					var qualityValue:int = _data.readByte();			
					PlayerNoticeUtil.petQualityNotice(serverId,nickName,useId,itemId,tempId,petNick,qualityValue);
					break;
			}
		}
		
		override public function getCode():int
		{
			return ProtocolType.PLAYER_NOTICE;
		}
	}
}