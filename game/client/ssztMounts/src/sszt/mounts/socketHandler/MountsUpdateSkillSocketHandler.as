package sszt.mounts.socketHandler
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
	
	public class MountsUpdateSkillSocketHandler extends BaseSocketHandler
	{
		public function MountsUpdateSkillSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.MOUNTS_SKILL_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			
			var len1:int = _data.readByte();
			var skill:SkillItemInfo;
			var mounts:MountsItemInfo = GlobalData.mountsList.getMountsById(id);
			mounts.skillList = [];
			for(var j:int = 0;j<len1;j++)
			{
				skill = new SkillItemInfo;
				skill.templateId = _data.readInt();
				skill.level = _data.readByte();
				mounts.updateSkill(skill);
			}
			
			mounts.updateSkill(null,true);
			
			
			handComplete();
		}
		
	}
}