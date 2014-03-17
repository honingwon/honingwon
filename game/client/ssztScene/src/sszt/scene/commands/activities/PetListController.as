package sszt.scene.commands.activities
{
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.manager.SharedObjectManager;
	import sszt.events.SceneModuleEvent;
	import sszt.interfaces.scene.IScene;
	import sszt.module.ModuleEventDispatcher;
	import sszt.scene.components.sceneObjs.BaseScenePet;
	import sszt.scene.components.sceneObjs.SelfScenePet;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.events.ScenePetListUpdateEvent;
	import sszt.scene.mediators.SceneMediator;

	public class PetListController
	{
		private var _mediator:SceneMediator;
		private var _scene:IScene;
//		private var _petList:Vector.<BaseScenePet>;
		private var _petList:Array;
		
		public function PetListController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
			initEvent();
		}
		
		private function init():void
		{
//			_petList = new Vector.<BaseScenePet>();
			_petList = [];
			var list:Dictionary = _mediator.sceneInfo.petList.getPets();
			for each(var i:BaseScenePetInfo in list)
			{
				addPet(i);
			}
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.petList.addEventListener(ScenePetListUpdateEvent.ADD_PET,addPetHandler);
			_mediator.sceneInfo.petList.addEventListener(ScenePetListUpdateEvent.REMOVE_PET,removePetHandler);
			ModuleEventDispatcher.addSceneEventListener(SceneModuleEvent.UPDATE_PLAYER_FIGURE,updatePlayerFigureHandler);
		}
		private function removeEvent():void
		{
			_mediator.sceneInfo.petList.removeEventListener(ScenePetListUpdateEvent.ADD_PET,addPetHandler);
			_mediator.sceneInfo.petList.removeEventListener(ScenePetListUpdateEvent.REMOVE_PET,removePetHandler);
			ModuleEventDispatcher.removeSceneEventListener(SceneModuleEvent.UPDATE_PLAYER_FIGURE,updatePlayerFigureHandler);
		}
		
		private function addPetHandler(evt:ScenePetListUpdateEvent):void
		{
			addPet(evt.data as BaseScenePetInfo);
		}
		private function removePetHandler(evt:ScenePetListUpdateEvent):void
		{
			var info:BaseScenePetInfo = evt.data as BaseScenePetInfo;
			var len:int = _petList.length;
			for (var i:int = 0; i < len ;i++)
			{
				if(_petList[i].getScenePetInfo() == info)
				{
					var pet:BaseScenePet = _petList.splice(i,1)[0];
					pet.dispose();
					break;
				}
			}
		}
		
		private function updatePlayerFigureHandler(evt:SceneModuleEvent):void
		{
			updatePlayerFigure();
		}
		public function updatePlayerFigure():void
		{
			for each(var i:BaseScenePet in _petList)
			{
				if(!(i is SelfScenePet))i.setFigureVisible(SharedObjectManager.hidePlayerCharacter.value != true);
				else i.setFigureVisible(true);
			}
		}
		
		private function addPet(info:BaseScenePetInfo):void
		{
			if(_mediator.sceneInfo.mapInfo.isSpaScene() || _mediator.sceneInfo.mapInfo.isShenmoDouScene() || MapTemplateList.isPerWarMap())
				return;
			var pet:BaseScenePet;
			if(info.owner == GlobalData.selfPlayer.userId)
			{
				pet = new SelfScenePet(info,_mediator);
			}
			else
			{
				pet = new BaseScenePet(info);
				pet.setFigureVisible(SharedObjectManager.hidePlayerCharacter.value != true);
			}
			_scene.addChild(pet);
			_petList.push(pet);
			if(GlobalData.petList.getFightPet() && GlobalData.petList.getFightPet().id == info.getObjId()) pet.startTalk();
		}
		
		public function getPetByOwner(owner:Number):BaseScenePet{
			var pet:BaseScenePet;
			for each (pet in this._petList) {
				if (pet.getScenePetInfo().owner == owner){
					return (pet);
				}
			}
			return null;
		}
		
		
		public function clear():void
		{
			for each(var i:BaseScenePet in _petList)
			{
				i.dispose();
			}
//			_petList = new Vector.<BaseScenePet>();
			_petList = [];
		}
		
		public function dispose():void
		{
			removeEvent();
		}
	}
}