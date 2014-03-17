package sszt.core.socketHandlers.pet
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.pet.petSkill.PetSkillInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.bag.PetItemPlaceUpdateSocketHandler;
	import sszt.core.utils.PackageUtil;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.interfaces.socket.IPackageOut;
	
	public class PetGetPetShowItemSocketHandler extends BaseSocketHandler
	{
		public function PetGetPetShowItemSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PET_GET_OTHER_PETS;
		}
		
		override public function handlePackage():void
		{
			var petId:Number = _data.readNumber();
			var isPetExist:Boolean =  _data.readBoolean();
			if(isPetExist)
			{
				var pet:PetItemInfo = new PetItemInfo();
				pet.id = petId;
				pet.templateId = _data.readInt();
				pet.styleId = _data.readInt();
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
				for(var j:int = 0; j<skillLen; j++)
				{
					skillItem = new PetSkillInfo();
					skillItem.templateId = _data.readInt();
					skillItem.level = _data.readByte();
					pet.updateSkill(skillItem);
				}
//				petId = _data.readNumber();
				var len:int = _data.readInt();
				var list:Array = [];
				var pickType:int = 0;
				for(var i:int = 0; i < len; i++)
				{					
					var itemInfo:ItemInfo = new ItemInfo();
					itemInfo.place = _data.readInt();
					itemInfo.isExist = true;
					PackageUtil.readItem(itemInfo,_data);				
					list.push(itemInfo);
				}
				
				GlobalData.petShowInfo.updateItems(list);
				GlobalData.petShowInfo.updatePetShowItemInfo(pet);
			}
			else
			{
				QuickTips.show(LanguageManager.getWord('ssztl.pet.isNotExist'));
			}
			handComplete();
		}
		
		public static function send(userId:Number, petId:Number):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.PET_GET_OTHER_PETS);
			pkg.writeNumber(userId);
			pkg.writeNumber(petId);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}