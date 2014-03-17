package sszt.core.view.effects
{
	import flash.display.BlendMode;
	
	import sszt.constData.LayerType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.PkgRecord;
	import sszt.interfaces.loader.IDataFileInfo;

	public class BaseLoadEffectPool extends BaseEffectPool
	{
		public function BaseLoadEffectPool()
		{
			super();
		}
		
		override public function play(clearType:int = 1,clearTime:int = 2147483647,priority:int = 3):void
		{
//			PkgRecord.getFile(_info.picPath,int(_info.picPath),LayerType.EFFECT,0,getDataComplete);
			
			GlobalAPI.loaderAPI.getFanmFile(GlobalAPI.pathManager.getMoviePath(_info.picPath),getDataComplete,clearType,clearTime,priority);
//			getPngPackageFile(GlobalAPI.pathManager.getMoviePath(_info.picPath),int(_info.picPath),LayerType.EFFECT,0,getDataComplete,SourceClearType.CHANGE_SCENE);
		}
		
		protected function getDataComplete(data:Object):void
		{
			if(_info == null)return;
			super.reset([_info,data]);
			super.play();
		}
		
		/**
		 * [MovieTemplateInfo]
		 * @param param
		 * 
		 */		
		override public function reset(param:Object):void
		{
			_info = param[0];
			if(_info.addMode == 1)
			{
				blendMode = BlendMode.ADD;
			}
			else if(_info.addMode == 0 || _info.addMode == 2)
			{
				blendMode = BlendMode.NORMAL;
			}
			_currentFrame = 0;
			_currentIndex = -1;
		}
	}
}