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

	public class BaseQuealityMoveEffectPool extends Sprite  implements IEffect, IPoolObj
	{
		protected var _poolManager:IPoolManager;
		
		protected var _asset:MovieClip;
		
		public function BaseQuealityMoveEffectPool()
		{
			super();
			this.mouseChildren = this.mouseEnabled =false;
		}
		
		/**
		 * [MovieTemplateInfo]
		 * @param param
		 * 
		 */		
		public function reset(param:Object):void
		{
		}
		
		public function setManager(manager:IPoolManager):void
		{
			_poolManager = manager;
		}

		
		public function collect():void
		{
			if(_poolManager)
			{
				_poolManager.removeObj(this);
			}
		}
		
		public function dispose():void
		{
			_poolManager = null;
			stop();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function poolDispose():void
		{
			dispose();
		}
		
		public function play(clearType:int=1,clearTime:int = 2147483647,priority:int = 3):void
		{
			_asset.play();
			addChild(_asset as DisplayObject)
		}
		
		public function stop():void
		{
			if(_asset && _asset.parent)
				_asset.parent.removeChild(_asset as DisplayObject);
		}
		
		public function move(x:Number, y:Number):void
		{
			
		}
		
		public function update(times:int, dt:Number=0.04):void
		{
			
		}
		

	}
}