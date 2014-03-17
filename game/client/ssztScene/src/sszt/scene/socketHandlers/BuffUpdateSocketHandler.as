package sszt.scene.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.MapElementType;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.buff.BuffItemInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.scene.SceneModule;
	
	public class BuffUpdateSocketHandler extends BaseSocketHandler
	{
		public function BuffUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.BUFF_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var player:BaseRoleInfo = sceneModule.sceneInfo.getRoleInfo(_data.readByte(),_data.readNumber());
			if(player)
			{
				var len:int = _data.readShort();
				for(var i:int = 0; i < len; i++)
				{
					var buffId:int = _data.readInt();
					if(_data.readBoolean())
					{
						var buff:BuffItemInfo = player.getBuff(buffId);
						var buffAdd:Boolean = false;
						if(buff == null)
						{
							buff = new BuffItemInfo();
							buff.templateId = buffId;
							buffAdd = true;
						}
						if(buff.getTemplate().getIsTime())
						{
							buff.endTime = _data.readDate64();
						}
						else 
						{
							buff.remain = _data.readNumber();
						}
						buff.setPause(_data.readBoolean());
						buff.pauseTime = _data.readDate64();
						buff.totalValue = _data.readInt();
						if(buffAdd)
						{
							player.addBuff(buff);
////							sceneModule.sceneInfo.playerList.self.addBuff(buff);
						}
						else
						{
							player.updateBuff(buff);
						}
					}
					else
					{
						player.removeBuff(buffId);
//						sceneModule.sceneInfo.playerList.self.removeBuff(buffId);
					}
					
				}
				if(player.getObjId() == GlobalData.selfPlayer.userId)
				{
					GlobalData.selfPlayer.setFreePropertys(PackageUtil.parseProperty(_data.readString()));
				}
			}
			
			handComplete();
		}
		
		public function get sceneModule():SceneModule
		{
			return _handlerData as SceneModule;
		}
	}
}