package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class PetSkillUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetSkillUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_SKILL_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var id:Number = _data.readNumber();
			
			var len1:int = _data.readByte();
			var skill:PetSkillInfo;
			var pet:PetItemInfo = GlobalData.petList.getPetById(id);
			pet.clearSkill();//清空技能列表
			for(var j:int = 0;j<len1;j++)
			{
				skill = new PetSkillInfo;
				skill.templateId = _data.readInt();
				skill.level = _data.readByte();
				pet.updateSkill(skill);
			}
			
			pet.updateSkill(null,true);
			
			
			handComplete();
		}
	}
}