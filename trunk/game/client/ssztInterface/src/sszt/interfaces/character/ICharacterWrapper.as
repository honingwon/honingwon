package sszt.interfaces.character
{
	import flash.display.DisplayObjectContainer;
	
	import sszt.interfaces.display.IDisplayObject;
	import sszt.interfaces.dispose.IDispose;
	
	public interface ICharacterWrapper extends IDispose
	{
		function get characterInfo():ICharacterInfo;
		function move(x:Number,y:Number):void;
		/**
		 * 开始加载人物，一般只调一次
		 * @param dir 
		 * @param container
		 * 
		 */		
		function show(dir:int = 1,container:DisplayObjectContainer = null):void;
		function doAction(action:ICharacterActionInfo):void;
		function doActionType(actionType:int):void;
		function get currentAction():ICharacterActionInfo;
		function actionPlaying(action:ICharacterActionInfo):Boolean;
		function updateDir(dir:int):void;
		function get dir():int;
		
		function setMouseEnabeld(value:Boolean):void;
	}
}