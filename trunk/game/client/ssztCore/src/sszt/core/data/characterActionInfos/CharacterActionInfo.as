package sszt.core.data.characterActionInfos
{
	import sszt.interfaces.character.ICharacterActionInfo;
	
	public class CharacterActionInfo implements ICharacterActionInfo
	{
		private var _actionType:int;
		private var _stopAtEnd:Boolean;
//		private var _frames:Vector.<int>;
		private var _frames:Array;
		private var _directType:int;
		private var _repeat:Boolean;
		private var _replaceSame:Boolean;
		
//		public function CharacterActionInfo(actionType:int,frames:Vector.<int>,dirType:int,stopAtEnd:Boolean,repeat:Boolean,replaceSame:Boolean)
		public function CharacterActionInfo(actionType:int,frames:Array,dirType:int,stopAtEnd:Boolean,repeat:Boolean,replaceSame:Boolean)
		{
			_actionType = actionType;
			_stopAtEnd = stopAtEnd;
			_frames = frames;
			_directType = dirType;
			_repeat = repeat;
			_replaceSame = replaceSame;
		}
		
		public function get actionType():int
		{
			return _actionType;
		}
		
		public function get stopAtEnd():Boolean
		{
			return _stopAtEnd;
		}
		
//		public function get frames():Vector.<int>
		public function get frames():Array
		{
			return _frames;
		}
		
		public function get directType():int
		{
			return _directType;
		}
		
		public function get repeat():Boolean
		{
			return _repeat;
		}
		
		public function get replaceSame():Boolean
		{
			return _replaceSame;
		}
		
		public function canReplace(action:ICharacterActionInfo):Boolean
		{
			return (action.actionType != actionType) || replaceSame;
		}
	}
}