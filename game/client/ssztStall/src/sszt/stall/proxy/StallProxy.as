package sszt.stall.proxy
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.stall.StallFacade;
	import sszt.core.data.stall.StallInfo;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class StallProxy extends Proxy
	{
		public static const NAME:String = "stallProxy";
		public function StallProxy(data:Object=null)
		{
			super(NAME, data);
		}
		
		public function setStallData():void
		{
//			var path:String = "StallData";
//			var loader:IRequestLoader = GlobalAPI.loaderAPI.loadRequest(GlobalAPI.pathManager.getWebServicePath(path),
//				{id:GlobalData.selfPlayer.userId},loadComplete,false,3);
//			loader.loadSync();
		}
		
		//从服务器加载完成，准备初始化数据层
//		public function loadComplete(loader:IRequestLoader):void
//		{
//			stallInfo.InitialStallData(loader.xmlData);
//		}
	}
}