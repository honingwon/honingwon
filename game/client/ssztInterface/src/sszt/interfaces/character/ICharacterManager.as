package sszt.interfaces.character
{
	import sszt.interfaces.loader.ILoaderApi;
	import sszt.interfaces.path.IPathManager;
	import sszt.interfaces.pool.IPoolObj;
	import sszt.interfaces.tick.ITickManager;

	public interface ICharacterManager
	{
		function setup(loaderApi:ILoaderApi,pathManager:IPathManager,tickManager:ITickManager):void;
		
		/**
		 * 创建形象
		 * @param info
		 * @return 
		 * 
		 */		
		function createShowCharacter(info:ICharacterInfo):ICharacter;
		function createSceneCharacter(info:ICharacterInfo):ICharacter;
		function createSceneMonsterCharacter(info:ICharacterInfo):ICharacter;
		function createSceneNpcCharacter(info:ICharacterInfo):ICharacter;
		function createSceneDropCharacter(info:ICharacterInfo):ICharacter;
		function createMountsChatacter(info:ICharacterInfo):ICharacter;
		function createMountsRunChatacter(info:ICharacterInfo):ICharacter;
		
		function createShowMountsOnlyCharacter(info:ICharacterInfo):ICharacter;
		function createShowMountsCharacter(info:ICharacterInfo):ICharacter;
		function createShowMountsRunCharacter(info:ICharacterInfo):ICharacter;
		
		function createShowCharacterWrapper(info:ICharacterInfo):ICharacterWrapper;
		function createPetCharacter(info:ICharacterInfo):ICharacter;
		function createShowPetCharacter(info:ICharacterInfo):ICharacter;
		
		function createSceneSitCharacter(info:ICharacterInfo):ICharacter;
		function createCollectCharacter(info:ICharacterInfo):ICharacter;
		function createCarCharacter(info:ICharacterInfo):ICharacter;
		function createSpaCharacter(info:ICharacterInfo):ICharacter;
		function createSwimCharacter(info:ICharacterInfo):ICharacter;
		
		
		function createCarCharacterPool(info:ICharacterInfo):ICharacter;
		function createCollectCharacterPool(info:ICharacterInfo):ICharacter;
		function createMountsCharacterPool(info:ICharacterInfo):ICharacter;
		function createSceneCharacterPool(info:ICharacterInfo):ICharacter;
		function createSceneMonsterCharacterPool(info:ICharacterInfo):ICharacter;
		function createNpcCharacterPool(info:ICharacterInfo):ICharacter;
		function createPetCharacterPool(info:ICharacterInfo):ICharacter;
		function createSceneSitCharacterPool(info:ICharacterInfo):ICharacter;
		function createShowCharacterPool(info:ICharacterInfo):ICharacter;
		function createShowMountsCharacterPool(info:ICharacterInfo):ICharacter;
		
	}
}