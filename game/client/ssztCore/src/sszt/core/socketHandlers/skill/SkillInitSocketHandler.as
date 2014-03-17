package sszt.core.socketHandlers.skill
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.skill.SkillItemInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	public class SkillInitSocketHandler extends BaseSocketHandler
	{
		public function SkillInitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SKILL_INIT;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var id:int = _data.readInt();
				if(_data.readBoolean())
				{
					var item:SkillItemInfo = GlobalData.skillInfo.getSkillById(id);
					var add:Boolean = false;
					if(item == null)
					{
						item = new SkillItemInfo();
						item.templateId = id;
						add = true;
					}
					var lastUserTime:Number = _data.readNumber();
					item.level = _data.readShort();
					item.lastUseTime = lastUserTime;
					if(add)
					{
						GlobalData.skillInfo.addSkill(item);
					}
					else
					{
						item.dataUpdate();
					}
				}
				else
				{
					GlobalData.skillInfo.removeSkill(id);
				}
			}
			
			GlobalData.guildSkillUpTimes = _data.readByte();
			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GUILD_SKILL_UPGRADE_TIMERS));
			
			if(!GlobalData.skillInfo.hasInit)
			{
				GlobalData.skillInfo.hasInit = true;
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.SKILL_REFRESH));
			}
			
			handComplete();
		}
	}
}