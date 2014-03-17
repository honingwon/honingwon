package sszt.core.socketHandlers.mounts
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsGetMountShowItemSocketHandler extends BaseSocketHandler
	{
		public function MountsGetMountShowItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_GET_MOUNT_SHOW_ITEM_INFO;
		}
		
		override public function handlePackage():void
		{
			var mountId:Number = _data.readNumber();
			var isMountExist:Boolean =  _data.readBoolean();
			if(isMountExist)
			{
				var mountItemInfo:MountsItemInfo = new MountsItemInfo();
				mountItemInfo.id = mountId;
				mountItemInfo.templateId = _data.readInt();
				mountItemInfo.state = _data.readByte();
				mountItemInfo.diamond = _data.readByte();
				mountItemInfo.star = _data.readByte();
				mountItemInfo.nick = _data.readString();
				if(mountItemInfo.nick == "")
				{
					mountItemInfo.nick = ItemTemplateList.getTemplate(mountItemInfo.templateId).name;
				}
				
				mountItemInfo.stairs = _data.readByte();
				mountItemInfo.level = _data.readByte();
				mountItemInfo.exp = _data.readInt();
				mountItemInfo.speed = _data.readByte();
				mountItemInfo.grow = _data.readByte();
				mountItemInfo.quality = _data.readByte();
				
				mountItemInfo.refined = _data.readByte();
				//PackageUtil.parseMountsRefined(mountItemInfo,_data);
				PackageUtil.parseMountsProperty(mountItemInfo,_data);
				
				var len1:int = _data.readByte();
				var skill:SkillItemInfo;
				for(var j:int = 0;j<len1;j++)
				{
					skill = new SkillItemInfo();
					skill.templateId = _data.readInt();
					skill.level = _data.readByte();
					mountItemInfo.updateSkill(skill);
				}
				GlobalData.mountShowInfo.updateMountShowItemInfo(mountItemInfo);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord('ssztl.mounts.isNotExist'));
			}
			handComplete();
		}
		
		public static function send(userId:Number, mountId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.MOUNTS_GET_MOUNT_SHOW_ITEM_INFO);
			pkg.writeNumber(userId);
			pkg.writeNumber(mountId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}