package sszt.core.socketHandlers.mounts
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	
	public class MountsListUpdateSocketHandler extends BaseSocketHandler
	{
		public function MountsListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_LIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var add:Boolean;
			var len:int = _data.readByte();
			for(var i:int = 0; i < len; i++)
			{
				add = false;
				var id:Number = _data.readNumber();
				var mounts:MountsItemInfo = GlobalData.mountsList.getMountsById(id);
				if(_data.readBoolean())
				{
					//添加
					if(mounts == null)
					{
						add = true;
						mounts = new MountsItemInfo();
					}	
					mounts.id = id;
					mounts.templateId = _data.readInt();
					mounts.state = _data.readByte();
					mounts.diamond = _data.readByte();
					mounts.star = _data.readByte();
					mounts.nick = _data.readString();
					if(mounts.nick == "")
					{
						mounts.nick = ItemTemplateList.getTemplate(mounts.templateId).name;
					}
					
					mounts.stairs = _data.readByte();
					mounts.level = _data.readByte();
					mounts.exp = _data.readInt();
					mounts.speed = _data.readByte();
					mounts.grow = _data.readByte();
					mounts.quality = _data.readByte();
					PackageUtil.parseMountsRefined(mounts,_data);
					PackageUtil.parseMountsProperty(mounts,_data);
					
					var len1:int = _data.readByte();
					var skill:SkillItemInfo;
					mounts.clearSkill();
					for(var j:int = 0;j<len1;j++)
					{
						skill = new SkillItemInfo;
						skill.templateId = _data.readInt();
						skill.level = _data.readByte();
						mounts.updateSkill(skill);
					}
					mounts.updateSkill(null,true);
					
					if(add) GlobalData.mountsList.addMounts(mounts);
					else mounts.update();
				}
				else
				{
					//删除
					GlobalData.mountsList.removeMounts(id);
				}
				
				if(GlobalData.mountsList.mountsCount == 1 && mounts.state == 0 && GlobalData.selfPlayer.level <= 20 )
				{
					MountsStateChangeSocketHandler.send(mounts.id, 1);
				}
			}
			
			handComplete();
		}
	}
}