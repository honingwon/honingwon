package sszt.core.view.effects
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.pool.IPoolObj;

	public class QuealityMoveEffectPool3 extends BaseQuealityMoveEffectPool
	{
		
		
		public function QuealityMoveEffectPool3()
		{
			super();
		}
		
		override  public function reset(param:Object):void
		{
			if(_asset == null)
			{
				_asset =  AssetUtil.getAsset("ssztui.common.EquipEffectAsset3", MovieClip) as MovieClip;
			}
		}
		
		

	}
}