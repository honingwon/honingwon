package sszt.interfaces.character
{
	import flash.events.IEventDispatcher;
	
	import sszt.interfaces.display.IDisplayObject;

	public interface ICharacter extends IDisplayObject
	{
		function get characterInfo():ICharacterInfo;
		function move(x:Number,y:Number):void;
		/**
		 * 开始加载人物，一般只调一次
		 * @param dir 
		 * @param clearLoader
		 * @param showLoading
		 * 
		 */		
		function show(dir:int = 8):void;
		/**
		 * 废弃 
		 * @param action
		 * 
		 */		
		function doAction(action:ICharacterActionInfo):void;
		function doActionType(actionType:int):void;
		function get currentAction():ICharacterActionInfo;
		function actionPlaying(action:ICharacterActionInfo):Boolean;
		function updateDir(dir:int):void;
		function get dir():int;
		function setFrame(index:int,index1:int=0,index2:int=0):void;
		function setFigureVisible(value:Boolean):void;
		
		function getIsAlpha(x:int,y:int):Boolean;
		function setMouseEnabeld(value:Boolean):void;
	}
}