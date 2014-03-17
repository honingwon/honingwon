package sszt.core.view.effects
{
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.interfaces.loader.IDataFileInfo;
	
	public class BaseLoadEffect extends BaseEffect
	{
		public function BaseLoadEffect(info:MovieTemplateInfo)
		{
			super(info); 
		}
		
		override public function play(clearType:int = 1,clearTime:int = 2147483647,priority:int = 3):void
		{
			GlobalAPI.loaderAPI.getFanmFile(GlobalAPI.pathManager.getMoviePath(_info.picPath),getDataComplete,clearType,clearTime,priority);
		}
		
		protected function getDataComplete(data:Object):void
		{
			setData(data);
			super.play();
		}
		
		override public function dispose():void
		{
			GlobalAPI.loaderAPI.removeFanmAQuote(GlobalAPI.pathManager.getMoviePath(_info.picPath));
			super.dispose();
		}
	}
}