package sszt.scene.utils
{
	import sszt.core.data.EffectType;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffect;

	public class ClickEffect
	{
		private static var _instance:BaseLoadEffect;
		
		public static function getInstance():BaseLoadEffect
		{
			if(!_instance)
			{
				_instance = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.CLICK_FLOOR));
			}
			return _instance;
		}
	}
}