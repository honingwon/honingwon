package sszt.character.loaders
{
	import sszt.interfaces.character.ICharacterInfo;
	import sszt.interfaces.character.*;
	
	public class BaseCharacterLoader implements ICharacterLoader 
	{
		
		protected var _info:ICharacterInfo;
		protected var _callback:Function;
		
		public function BaseCharacterLoader(info:ICharacterInfo)
		{
			this._info = info;
			this.init();
		}
		protected function init():void
		{
		}
		public function load(callBack:Function=null):void
		{
			this._callback = callBack;
		}
		public function getContent():Array
		{
			return (null);
		}
		public function clearContent():void
		{
		}
		public function get info():ICharacterInfo
		{
			return (this._info);
		}
		protected function loadComplete():void
		{
			if (this._callback != null){
				this._callback(this);
			};
		}
		public function dispose():void
		{
			this._info = null;
			this._callback = null;
		}
		
	}
}