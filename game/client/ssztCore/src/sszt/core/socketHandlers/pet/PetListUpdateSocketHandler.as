package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	
	/**
	 * 更新宠物列表。
	 * 1、用户登录时接收, 数据为全部宠物列表，存入客户端备用。
	 * 2、添加宠物时，数据为所添加的宠物的信息。
	 * 3、删除宠物时，数据为所删除的宠物的信息。4、更新已经存在于客户端的宠物，何时会触发？
	 */
	public class PetListUpdateSocketHandler extends BaseSocketHandler
	{
		public function PetListUpdateSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_LIST_UPDATE;
		}
		
		override public function handlePackage():void
		{
			var add:Boolean;
			var len:int = _data.readByte();
			for(var i:int = 0; i < len; i++)
			{
				var id:Number = _data.readNumber();
				var pet:PetItemInfo = GlobalData.petList.getPetById(id);
				if(_data.readBoolean())
				{
					//如果宠物没有添加到客户端数据列表
					if(pet == null)
					{
						add = true;
						pet = new PetItemInfo();
					}	
					pet.id = id;
					pet.templateId = _data.readInt();
					pet.updateStyle( _data.readInt());
					pet.color = _data.readByte();
					pet.type = _data.readByte();
					pet.energy = _data.readByte();
					pet.state = _data.readByte();
					pet.diamond =  _data.readByte();
					pet.star = _data.readByte();
					pet.nick = _data.readString();
					if(pet.nick == "")
					{
						pet.nick = PetTemplateList.getPet(pet.templateId).name;
					}
					pet.stairs = _data.readByte();
					pet.level = _data.readByte();
					pet.exp = _data.readInt();
					pet.grow = _data.readByte();
					pet.growExp =_data.readInt();
					pet.quality = _data.readByte();
					pet.qualityExp =_data.readInt();
					PackageUtil.parsePetProperty(pet,_data);
					//读取技能
					var skillLen:int = _data.readByte();
					var skillItem:PetSkillInfo;
					pet.clearSkill();
					for(var j:int = 0; j<skillLen; j++)
					{
						skillItem = new PetSkillInfo();
						skillItem.templateId = _data.readInt();
						skillItem.level = _data.readByte();
						pet.updateSkill(skillItem);
					}
					if(add)
					{
						GlobalData.petList.addPet(pet);//第一种情况下分发【添加宠物】事件无意义，因为无PetPanel。
					}
					else
					{
						pet.update();
						pet.updateGrowExp();
						pet.updateQualityExp();
						pet.upgrade();
					}
					pet.updateSkill(null,true);//如果是第1 、2种socket接收情况，那么此时pet：PetItemInfo无监听器。第三种情况，此行不执行。第四种情况，才可能会有意义。
				}
				else
				{
					//删除已经不存在的宠物
					GlobalData.petList.removePet(id);
				}
			}
			if(GlobalData.petList.petCount == 1 && pet.state == 0 && GlobalData.selfPlayer.level <= 35 )
			{
				PetStateChangeSocketHandler.send(pet.id, 1);
			}			
			//如果只有一只野猪宠物，且玩家等级小于40则提醒商城有卖宠物
			if(GlobalData.petList.petCount == 1 && GlobalData.selfPlayer.level <= 40 &&GlobalData.petList.getFightPet().templateId == 260001)
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.GET_FIRST_PET));
			}
			handComplete();
		}
	}
}