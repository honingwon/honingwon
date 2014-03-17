package sszt.core.data
{
	import sszt.constData.LayerType;
	import sszt.interfaces.character.ILayerInfo;
	
	public class LayerInfo implements ILayerInfo
	{
		private var _templateId:int=0;
		/**
		 * 图片地址
		 */		
		private var _picPath:String;
		/**
		 * 图标地址
		 */		
		private var _iconPath:String = "";
		/**
		 * 种类ID
		 */		
		private var _categoryId:int;
		
		public function get templateId():int
		{
			return _templateId;
		}
		public function set templateId(value:int):void
		{
			_templateId = value;
		}
		
		public function get picPath():String
		{
			return String(_picPath);
		}
		public function set picPath(value:String):void
		{
			_picPath = value;
		}
		
		public function getTotalFrames(type:String):int
		{
			switch(type)
			{
				case LayerType.SCENE_PLAYER:return 80;
			}
			return 0;
		}
		
		public function get iconPath():String
		{
			return _iconPath;
		}
		public function set iconPath(value:String):void
		{
			_iconPath = value;
		}
	}
}