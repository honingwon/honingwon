package sszt.character.actions
{
	import sszt.character.LayerCharacter;
	import sszt.interfaces.character.ICharacterActionInfo;
	import sszt.character.CharacterManager;
	import sszt.constData.DirectType;
	import sszt.interfaces.tick.*;
	
	public class BaseActionController implements ITick 
	{
		
		private var _character:LayerCharacter;
		private var _defaultAction:ICharacterActionInfo;
		private var _defaultAction1:ICharacterActionInfo;
		private var _defaultAction2:ICharacterActionInfo;
		private var _currentAction:ICharacterActionInfo;
		private var _currentAction1:ICharacterActionInfo;
		private var _currentAction2:ICharacterActionInfo;
		private var _actionComplete:Boolean;
		private var _currentStep:int;
		private var _currentStep1:int;
		private var _currentStep2:int;
		private var _currentDir:int;
		private var _actionStepLen:int;
		private var _actionStepLen1:int;
		private var _actionStepLen2:int;
		
		public function BaseActionController(character:LayerCharacter,defaultAction:ICharacterActionInfo)
		{
			this._character = character;
			this._defaultAction = defaultAction;
//			this.doAction(defaultAction);
		}
		
		public function setDefaultAction(defaultAction:ICharacterActionInfo,defaultAction1:ICharacterActionInfo = null,defaultAction2:ICharacterActionInfo = null):void
		{
			this._defaultAction = defaultAction;
			this._defaultAction1 = defaultAction1;
			this._defaultAction2 = defaultAction2;
			this.doAction(this._defaultAction,this._defaultAction1,this._defaultAction2);
		}
		
		public function start():void
		{
			CharacterManager.tickManager.addTick(this);
		}
		public function stop():void
		{
			CharacterManager.tickManager.removeTick(this);
		}
		public function doAction(action:ICharacterActionInfo,action1:ICharacterActionInfo=null,action2:ICharacterActionInfo=null):void
		{
			if (action == null){
				return;
			}
			if( action1 != null)
			{
				if( this._currentAction != null && this._currentAction.frames.length == action.frames.length && !this._currentAction.canReplace(action) &&
					this._currentAction1 != null && this._currentAction1.frames.length == action1.frames.length  && !this._currentAction1.canReplace(action1))
				{
						return;
				}
			}
			else if (this._currentAction != null && this._currentAction.frames.length == action.frames.length && !this._currentAction.canReplace(action))
			{
				return;
			}
//			if (this._actionComplete )
//			{
				this._currentStep = 0;
//			}
			this._actionComplete = false;
			this._currentAction = action;
			this._currentAction1 = action1;
			this._currentAction2 = action2;
			this._actionStepLen = action.directType == DirectType.DIRECT_2 ? action.frames.length / 2 : (action.directType == DirectType.DIRECT_5 ? action.frames.length / 5 : action.frames.length);
			if(action1 != null)
			{
				this._actionStepLen1 = action1.directType == DirectType.DIRECT_2 ? action1.frames.length / 2 : (action1.directType == DirectType.DIRECT_5 ? action1.frames.length / 5 : action1.frames.length);
			}
			if(action2 != null)
			{
				this._actionStepLen2 = action2.directType == DirectType.DIRECT_2 ? action2.frames.length / 2 : (action2.directType == DirectType.DIRECT_5 ? action2.frames.length / 5 : action2.frames.length);
			}
		}
		public function setDir(dir:int):void
		{
			this._currentDir = dir;
		}
		public function getCurrentAction():ICharacterActionInfo
		{
			return this._currentAction;
		}
		public function getActionComplete(action:ICharacterActionInfo):Boolean
		{
			return this._actionComplete && this._currentAction == action;
		}
		public function update(times:int, dt:Number=0.04):void
		{
			if (this._currentAction == null){
				return;
			}
			if (this._currentStep >= this._actionStepLen)
			{
				if (!this._actionComplete){
					this._actionComplete = true;
					this._character.actionComplete(this._currentAction);
				}
				if (this._currentAction.repeat){
					this._currentStep = 0;
				} 
				else 
				{
					if (this._currentAction.stopAtEnd){
						this._currentStep = (this._actionStepLen - 1);
					} 
					else 
					{
						this.doAction(this._defaultAction,this._defaultAction1,this._defaultAction2);
						return;
					}
				}
			}
			
			var frame:int = 0;
			var frame1:int = 0;
			var frame2:int = 0;
			
			if (_currentStep1 >= _actionStepLen1)
			{
				_currentStep1 = 0;
			}
			if (_currentStep2 >= _actionStepLen2)
			{
				_currentStep2 = 0;
			}
			frame = _currentAction.frames[(getDirOffset() + _currentStep)];
			if (_currentAction1 != null){
				frame1 = _currentAction1.frames[(getDirOffset1() + _currentStep1)];
			}
			
			if (_currentAction2 != null){
				frame2 = _currentAction2.frames[(getDirOffset2() + _currentStep2)];
			}
			this._character.setFrame(frame,frame1,frame2);
			_currentStep = (_currentStep + times);
			_currentStep1 = (_currentStep1 + times);
			_currentStep2 = (_currentStep2 + times);
			
			
			
//			this._character.setFrame1(this._currentAction1.frames[(this.getDirOffset1() + this._currentStep1)]);
//			this._currentStep1 = (this._currentStep1 + times);
		}
		public function getDirOffset():int
		{
			if (this._currentAction.directType == DirectType.DIRECT_2)
			{
				switch (this._currentDir){
					case DirectType.TOP:
					case DirectType.RIGHT_TOP:
					case DirectType.RIGHT:
					case DirectType.LEFT_TOP:
					case DirectType.LEFT:
						return 0;
				}
				return this._actionStepLen;
			}
			if (this._currentAction.directType == DirectType.DIRECT_5)
			{
				switch (this._currentDir){
					case DirectType.TOP:
						return 0;
					case DirectType.LEFT_TOP:
					case DirectType.RIGHT_TOP:
						return this._actionStepLen;
					case DirectType.LEFT:
					case DirectType.RIGHT:
						return 2 * this._actionStepLen;
					case DirectType.LEFT_BOTTOM:
					case DirectType.RIGHT_BOTTOM:
						return 3 * this._actionStepLen;
					case DirectType.BOTTOM:
						return 4 * this._actionStepLen;
				}
			}
			return 0;
		}
		
		public function getDirOffset1():int
		{
			if (this._currentAction1.directType == DirectType.DIRECT_2)
			{
				switch (this._currentDir){
					case DirectType.TOP:
					case DirectType.RIGHT_TOP:
					case DirectType.RIGHT:
					case DirectType.LEFT_TOP:
					case DirectType.LEFT:
						return 0;
				}
				return this._actionStepLen1;
			}
			if (this._currentAction1.directType == DirectType.DIRECT_5)
			{
				switch (this._currentDir){
					case DirectType.TOP:
						return 0;
					case DirectType.LEFT_TOP:
					case DirectType.RIGHT_TOP:
						return this._actionStepLen1;
					case DirectType.LEFT:
					case DirectType.RIGHT:
						return 2 * this._actionStepLen1;
					case DirectType.LEFT_BOTTOM:
					case DirectType.RIGHT_BOTTOM:
						return 3 * this._actionStepLen1;
					case DirectType.BOTTOM:
						return 4 * this._actionStepLen1;
				}
			}
			return 0;
		}
		public function getDirOffset2():int
		{
			if (this._currentAction2.directType == DirectType.DIRECT_2)
			{
				switch (this._currentDir){
					case DirectType.TOP:
					case DirectType.RIGHT_TOP:
					case DirectType.RIGHT:
					case DirectType.LEFT_TOP:
					case DirectType.LEFT:
						return 0;
				}
				return this._actionStepLen2;
			}
			if (this._currentAction2.directType == DirectType.DIRECT_5)
			{
				switch (this._currentDir){
					case DirectType.TOP:
						return 0;
					case DirectType.LEFT_TOP:
					case DirectType.RIGHT_TOP:
						return this._actionStepLen2;
					case DirectType.LEFT:
					case DirectType.RIGHT:
						return 2 * this._actionStepLen2;
					case DirectType.LEFT_BOTTOM:
					case DirectType.RIGHT_BOTTOM:
						return 3 * this._actionStepLen2;
					case DirectType.BOTTOM:
						return 4 * this._actionStepLen2;
				}
			}
			return 0;
		}
		
		public function dispose():void
		{
			this.stop();
			this._character = null;
			this._defaultAction = null;
			this._defaultAction1 = null;
			this._defaultAction2 = null;
			this._currentAction = null;
			this._currentAction1 = null;
			this._currentAction2 = null;
		}
		
	}
}