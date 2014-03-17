package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.club.ClubSkillItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class ClubSkillInitSocketHandler extends BaseSocketHandler
	{
		public function ClubSkillInitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.CLUB_SKILL_INIT;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readShort();
			var skill:ClubSkillItemInfo;
			var add:Boolean;
			if(len == 0) GlobalData.clubSkillList.clear();
			for(var i:int = 0;i<len;i++)
			{
				var id:int = _data.readInt();
				add = false;
				skill = GlobalData.clubSkillList.getSkill(id);
				if(!skill)
				{
					add = true;
					skill = new ClubSkillItemInfo();
				}
				skill.templateId = id;
				skill.level = _data.readByte();
				if(add) GlobalData.clubSkillList.addSkill(skill);
				else skill.update();
			}
			handComplete();
		}
	}
}