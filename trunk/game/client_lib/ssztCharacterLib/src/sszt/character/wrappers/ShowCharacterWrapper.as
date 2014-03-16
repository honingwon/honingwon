package sszt.character.wrappers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import sszt.character.ShowCharacter;
	import sszt.character.ShowMountsCharacter;
	import sszt.character.ShowMountsRunCharacter;
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.events.CharacterEvent;
	import sszt.interfaces.character.*;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.interfaces.character.ICharacterInfo;
	
	public class ShowCharacterWrapper implements ICharacterWrapper 
	{
		
		private var _info:ICharacterInfo;
		private var _character:ICharacter;
		private var _container:DisplayObjectContainer;
		private var _getMounts:Boolean;
		private var _mouseEnabled:Boolean;
		
		public function ShowCharacterWrapper(info:ICharacterInfo)
		{
			this._info = info;
			this._getMounts = this._info.getMounts();
			this._info.addEventListener(CharacterEvent.CHARACTER_UPDATE, this.characterUpdateHandler, false, 10);
		}
		private function characterUpdateHandler(evt:CharacterEvent):void
		{
			if (this._getMounts == this._info.getMounts()){
				return;
			}
			this._getMounts = this._info.getMounts();
			if (!(this._character)){
				return;
			}
			var dir:int = this._character.dir;
			var isAdd:Boolean = (this._character.parent == this._container);
			var cx:Number = this._character.x;
			var cy:Number = this._character.y;
			var layerIndex:int = -1;
			if (isAdd){
				layerIndex = this._character.parent.getChildIndex((this._character as DisplayObject));
			}
			this._character.dispose();
			if (this._getMounts){
				this._character = new ShowMountsRunCharacter(this._info);
			}
			else 
			{
				this._character = new ShowCharacter(this._info);
			}
			this._character.show(dir);
			if (isAdd)
			{
				this._container.addChildAt((this._character as DisplayObject), layerIndex);
			}
			this._character.move(cx, cy);
			this.updateEnable();
		}
		public function get characterInfo():ICharacterInfo
		{
			return (this._info);
		}
		public function move(x:Number, y:Number):void
		{
			if (this._character){
				this._character.move(x, y);
			}
		}
		public function show(dir:int=8, container:DisplayObjectContainer=null):void
		{
			if (!_character){
				if (_getMounts){
					_character = new ShowMountsRunCharacter(_info);
				} 
				else {
					_character = new ShowCharacter(_info);
				}
			}
			_character.show(dir);
			_container = container;
			_container.addChild((_character as DisplayObject));
			updateEnable();
			
		}
		public function setMouseEnabeld(value:Boolean):void
		{
			if (this._mouseEnabled == value)
			{
				return;
			}
			this._mouseEnabled = value;
			this.updateEnable();
		}
		private function updateEnable():void
		{
			if (this._character)
			{
				this._character.setMouseEnabeld(this._mouseEnabled);
			}
		}
		public function doAction(action:ICharacterActionInfo):void
		{
			if (this._character){
				this._character.doAction(action);
			}
		}
		
		public function doActionType(actionType:int):void
		{
			if (this._character){
				this._character.doActionType( actionType);
			}
		}
		
		public function get currentAction():ICharacterActionInfo
		{
			if (this._character){
				return (this._character.currentAction);
			}
			return (null);
		}
		public function actionPlaying(action:ICharacterActionInfo):Boolean
		{
			if (this._character){
				return (this._character.actionPlaying(action));
			}
			return (false);
		}
		public function updateDir(dir:int):void
		{
			if (this._character){
				this._character.updateDir(dir);
			}
		}
		public function get dir():int
		{
			if (this._character){
				return (this._character.dir);
			}
			return (DirectType.RIGHT);
		}
		public function dispose():void
		{
			if (this._character)
			{
				this._character.dispose();
				this._character = null;
			}
			this._info.removeEventListener(CharacterEvent.CHARACTER_UPDATE, this.characterUpdateHandler);
			this._info = null;
			this._container = null;
		}
		
	}
}
