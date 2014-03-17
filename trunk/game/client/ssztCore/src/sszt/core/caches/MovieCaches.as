package sszt.core.caches
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.loader.IDataFileInfo;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	/**
	 * 存储游戏中只出现单个的效果，如选中效果
	 * @author Administrator
	 * 
	 */	
	public class MovieCaches
	{
		private static var _arrowAsset:MovieClip;
		
		private static var _eqEfAsset1:IMovieWrapper;
		private static var _eqEfAsset2:IMovieWrapper;
		private static var _eqEfAsset3:IMovieWrapper;
		private static var _eqEfAsset4:IMovieWrapper;
		
		private static var _selectedEffect:BaseLoadEffect;
		private static var _selectedEffect1:BaseLoadEffect;
		
		public static function getSelectedEffect():BaseLoadEffect
		{
			if(_selectedEffect == null)
			{
				_selectedEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.SElECT_EFFECT));
			}
			return _selectedEffect;
		}
		
		public static function getSelectedPlayerEffect():BaseLoadEffect
		{
			if(_selectedEffect1 == null)
			{
				_selectedEffect1 = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.SElECT_EFFECT1));
			}
			return _selectedEffect1;
		}
		
		/**
		 * 新手引导箭头
		 * @return 
		 * 
		 */		
		public static function getArrowAsset() : MovieClip//IMovieWrapper
		{
			if (_arrowAsset == null)
			{
//				_arrowAsset = GlobalAPI.movieManagerApi.getMovieWrapper( AssetUtil.getAsset("ssztui.common.GuideTipAsset3", MovieClip) as MovieClip, 78, 60);
				_arrowAsset =  AssetUtil.getAsset("ssztui.common.GuideTipAsset3", MovieClip) as MovieClip;
			}
			return _arrowAsset;
		}
		
		/**
		 * 
		 * @进度条、穴位fire动画
		 * 
		 */		
		public static function getFireAsset() : MovieClip
		{
			return AssetUtil.getAsset("ssztui.common.EffectFireAsset", MovieClip) as MovieClip;
		}
		/**
		 * 
		 * @格子闪亮动画
		 * 
		 */		
		public static function getCellBlinkAsset() : MovieClip
		{
			return AssetUtil.getAsset("ssztui.common.CellLightAsset", MovieClip) as MovieClip;
		}
		
	}
}