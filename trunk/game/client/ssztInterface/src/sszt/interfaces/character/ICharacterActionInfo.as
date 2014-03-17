package sszt.interfaces.character
{
	public interface ICharacterActionInfo
	{
		/**
		 * 动作类型
		 * @return 
		 * 
		 */		
		function get actionType():int;
		/**
		 * 是否停在最后一帧频
		 * @return 
		 * 
		 */		
		function get stopAtEnd():Boolean;
		/**
		 * 帧
		 * @return 
		 * 
		 */		
//		function get frames():Vector.<int>;
		function get frames():Array;
		/**
		 * 方向类型
		 * @return 
		 * 
		 */		
		function get directType():int;
		/**
		 * 是否重复播放
		 * @return 
		 * 
		 */		
		function get repeat():Boolean;
		/**
		 * 是否替换相同
		 * @return 
		 * 
		 */		
		function get replaceSame():Boolean;
		/**
		 * 能否替换
		 * @param action
		 * @return 
		 * 
		 */		
		function canReplace(action:ICharacterActionInfo):Boolean;
	}
}