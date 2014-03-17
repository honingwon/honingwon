package sszt.furnace.mediators
{
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.components.FurnacePanel;
	import sszt.furnace.events.FurnaceMediatorEvent;
	import sszt.furnace.socketHandlers.FurnaceComposeSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceEnchaseSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceEquipComposeSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceEquipSplitSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceFuseSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceOpenHoleSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceQuenchingSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceRebuildSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceRemoveSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceReplaceSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceStrengthSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceStrengthTransformSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceUpLevelSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceUpgradeSocketHandler;
	import sszt.furnace.socketHandlers.FurnaceWuHunUpgradeSocketHandler;
	
	public class FurnaceMediator extends Mediator
	{
		public static const NAME:String = "FurnaceMediator";
		
		public function FurnaceMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				FurnaceMediatorEvent.FURNACE_MEDIATOR_START,
				FurnaceMediatorEvent.FURNACE_MEDIATOR_DISPOSE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case FurnaceMediatorEvent.FURNACE_MEDIATOR_START:
					initView();
					break;
				case FurnaceMediatorEvent.FURNACE_MEDIATOR_DISPOSE:
					dispose();
					break;
			}
		}
		
		private function initView():void
		{
			if(furnaceModule.furnacePanel == null)
			{
				furnaceModule.furnacePanel = new FurnacePanel(this);
				furnaceModule.furnacePanel.addEventListener(Event.CLOSE,furnaceCloseHandler);
				GlobalAPI.layerManager.addPanel(furnaceModule.furnacePanel);
			}
		}
		
		private function furnaceCloseHandler(evt:Event):void
		{
			if(furnaceModule.furnacePanel)
			{
				furnaceModule.furnacePanel.removeEventListener(Event.CLOSE,furnaceCloseHandler);
				furnaceModule.furnacePanel = null;
//				if(furnaceModule)furnaceModule.dispose();
			}
		}
		
		public function sendStrength(argEquipPlace:int,argStonePlace:int,argProtectBagPlace:int,akey:int,isPetEquip:Boolean=false):void
		{
			var tmpPetId:Number = 0;
			if(isPetEquip)//如果装备在宠物身上
			{
				var pet:PetItemInfo =  GlobalData.petList.getFightPet();
				if(pet) tmpPetId = pet.id
			}
			FurnaceStrengthSocketHandler.sendStrength(argEquipPlace,argStonePlace,argProtectBagPlace,akey,tmpPetId);
		}
		
		public function sendRebuild(argEquipPlace:int,argStonePlace:int,lockList:Array, argLuckBagPlace:int,isPetEquip:Boolean=false):void
		{
			var tmpPetId:Number = 0;
			if(isPetEquip)//如果装备在宠物身上
			{
				var pet:PetItemInfo =  GlobalData.petList.getFightPet();
				if(pet) tmpPetId = pet.id
			}
			FurnaceRebuildSocketHandler.sendRebuild(tmpPetId,argEquipPlace,argStonePlace,lockList,argLuckBagPlace);
		}
		
		public function sendReplace(argEquipPlace:int,isPetEquip:Boolean=false):void
		{
			var tmpPetId:Number = 0;
			if(isPetEquip)//如果装备在宠物身上
			{
				var pet:PetItemInfo =  GlobalData.petList.getFightPet();
				if(pet) tmpPetId = pet.id
			}
			FurnaceReplaceSocketHandler.sendReplace(tmpPetId,argEquipPlace);
		}
		
		public function sendOpenHole(argEquipPlace:int,argStonePlace:int):void
		{
			FurnaceOpenHoleSocketHandler.addOpenHole(argEquipPlace,argStonePlace);
		}
		
		public function sendEnchase(equipPlace:int,stonePlace:int,enchasePlace:int):void
		{
			FurnaceEnchaseSocketHandler.sendEnchase(equipPlace,stonePlace,enchasePlace);
		}
		
		public function sendRemove(argEquipPlace:int,argRemoveBagPlace:int,argStonePlace:int):void
		{
			FurnaceRemoveSocketHandler.sendRemove(argEquipPlace,argRemoveBagPlace,argStonePlace);
		}
		
		public function sendEquipCompose(argBlueEquipPlace:int,argPurpleEquipPlace1:int,argPurpleEquipPlace2:int):void
		{
			FurnaceEquipComposeSocketHandler.sendEquipCompose(argBlueEquipPlace,argPurpleEquipPlace1,argPurpleEquipPlace2);
		}
		
//		public function sendCompose(argProtectBagPlace:int,argStonePlaceVector:Vector.<int>):void
//		{
//			FurnaceComposeSocketHandler.sendCompose(argProtectBagPlace,argStonePlaceVector);
//		}
		public function sendCompose(argStoneId:int, argComposeNum:int, argUseBind:Boolean):void
		{
			FurnaceComposeSocketHandler.sendCompose(argStoneId,argComposeNum,argUseBind);
		}
		
		public function sendQuenching(stonePlace:int, materialPlace:int,useYuanbao:Boolean,isBag:Boolean=true,itemPlace:int=0,holePlace:int=0):void
		{
			FurnaceQuenchingSocketHandler.send(stonePlace,materialPlace,useYuanbao);
		}
		
		public function sendEquipSplit(argEquipPlace:int):void
		{
			FurnaceEquipSplitSocketHandler.sendEquipSplit(argEquipPlace);
		}
		
		public function sendStrengthTransform(argEquipPlace1:int,argEquipPlace2:int,opType:int,isPetEquip:Boolean=false):void
		{
			if(isPetEquip)//如果装备在宠物身上
			{
				QuickTips.show('对不起，宠物身上的装备必须卸下之后才可以转移。');
				return;
			}
			FurnaceStrengthTransformSocketHandler.sendTransform(argEquipPlace1,argEquipPlace2,opType);
		}
		
		public function sendCuiLian(argEquipPlace:int):void
		{
			FurnaceWuHunUpgradeSocketHandler.send(argEquipPlace);
		}
		
		public function sendUpgrade(argEquipPlace1:int,isPetEquip:Boolean=false):void
		{
			var tmpPetId:Number = 0;
			if(isPetEquip)//如果装备在宠物身上
			{
				var pet:PetItemInfo =  GlobalData.petList.getFightPet();
				if(pet) tmpPetId = pet.id
			}
			
			FurnaceUpgradeSocketHandler.send(tmpPetId,argEquipPlace1);
		}
		public function sendFuse(argEquipPlace1:int,argEquipPlace2:int,itemID:int):void
		{
			FurnaceFuseSocketHandler.send(argEquipPlace1,argEquipPlace2,itemID);
		}
		//物品合成
//		public function sendItemCompose(argTemplateId:int,argType:int):void
//		{
//			FurnaceItemComposeSocketHandler.send(argTemplateId,argType);
//		}
		
		//装备升级协议
		public function sendUpLevel(argEquipPlace:int,isPetEquip:Boolean=false):void
		{
			var tmpPetId:Number = 0;
			if(isPetEquip)//如果装备在宠物身上
			{
				var pet:PetItemInfo =  GlobalData.petList.getFightPet();
				if(pet) tmpPetId = pet.id
			}
			FurnaceUpLevelSocketHandler.send(tmpPetId,argEquipPlace);
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return viewComponent as FurnaceModule;
		}
		
		public function dispose():void
		{
			viewComponent = null;
		}
	}
}