package sszt.interfaces.character
{
	public interface ILayerInfo
	{
		/**
		 * 返回模板ID
		 * @return 
		 * 
		 */		
		function get templateId():int;
		/**
		 * 返回图片地址
		 * @return 
		 * 
		 */		
		function get picPath():String;
		/**
		 * 返回图标地址
		 * @return 
		 * 
		 */		
		function get iconPath():String;
		/**
		 * 资源侦数
		 * @return 
		 * 
		 */		
		function getTotalFrames(type:String):int;
//		function getAssetWidth(type:String):int;
//		function getAssetHeight(type:String):int;
	}
}