package sszt.character
{
	import sszt.character.wrappers.ShowCharacterWrapper;
	import sszt.interfaces.character.*;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.ICharacterWrapper;
	import sszt.interfaces.loader.ILoaderApi;
	import sszt.interfaces.path.IPathManager;
	import sszt.interfaces.tick.ITickManager;
	
	public class CharacterManager implements ICharacterManager 
	{
		
		public static var loaderApi:ILoaderApi;
		public static var pathManager:IPathManager;
		public static var tickManager:ITickManager;
		
		public function setup(loaderApi:ILoaderApi, pathManager:IPathManager, tickManager:ITickManager):void
		{
			CharacterManager.loaderApi = loaderApi;
			CharacterManager.pathManager = pathManager;
			CharacterManager.tickManager = tickManager;
		}
		public function createShowCharacter(info:ICharacterInfo):ICharacter
		{
			return new ShowCharacter(info);
		}
		public function createSceneCharacter(info:ICharacterInfo):ICharacter
		{
			return new SceneCharacter(info);
		}
		public function createSceneMonsterCharacter(info:ICharacterInfo):ICharacter
		{
			return new SceneMonsterCharacter(info);
		}
		public function createSceneNpcCharacter(info:ICharacterInfo):ICharacter
		{
			return new NPCCharacter(info);
		}
		public function createSceneDropCharacter(info:ICharacterInfo):ICharacter
		{
			return new DropCharacter(info);
		}
		public function createMountsChatacter(info:ICharacterInfo):ICharacter
		{
			return new MountsCharacter(info);
		}
		public function createMountsRunChatacter(info:ICharacterInfo):ICharacter
		{
			return new MountsRunCharacter(info);
		}
		
		public function createShowMountsOnlyCharacter(info:ICharacterInfo):ICharacter
		{
			return new ShowMountsOnlyCharacter(info);
		}
		
		public function createShowMountsCharacter(info:ICharacterInfo):ICharacter
		{
			return new ShowMountsCharacter(info);
		}
		
		public function createShowMountsRunCharacter(info:ICharacterInfo):ICharacter
		{
			return new ShowMountsRunCharacter(info);
		}
		public function createShowCharacterWrapper(info:ICharacterInfo):ICharacterWrapper
		{
			return new ShowCharacterWrapper(info);
		}
		public function createPetCharacter(info:ICharacterInfo):ICharacter
		{
			return new PetCharacter(info);
		}
		public function createShowPetCharacter(info:ICharacterInfo):ICharacter
		{
			return new ShowPetCharacter(info);
		}
		public function createSceneSitCharacter(info:ICharacterInfo):ICharacter
		{
			return new SceneSitCharacter(info);
		}
		public function createCollectCharacter(info:ICharacterInfo):ICharacter
		{
			return new CollectCharacter(info);
		}
		public function createCarCharacter(info:ICharacterInfo):ICharacter
		{
			return new CarCharacter(info);
		}
		public function createSpaCharacter(info:ICharacterInfo):ICharacter
		{
			return new SpaCharacter(info);
		}
		public function createSwimCharacter(info:ICharacterInfo):ICharacter
		{
			return new SwimCharacter(info);
		}
		public function createCarCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createCollectCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createMountsCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createSceneCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createSceneMonsterCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createNpcCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createPetCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createSceneSitCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createShowCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		public function createShowMountsCharacterPool(info:ICharacterInfo):ICharacter
		{
			return null;
		}
		
	}
}