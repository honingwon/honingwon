package sszt.scene.components.nearly
{
	import flash.display.Sprite;
	
	import sszt.scene.mediators.NearlyMediator;
	
	public class BaseNearlyTabView extends Sprite implements INearlyTabView
	{
		protected var _mediator:NearlyMediator;
		
		public function BaseNearlyTabView(mediator:NearlyMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		protected function init():void
		{
			
		}
		
		protected function initEvent():void
		{
			
		}
		
		protected function removeEvent():void
		{
			
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function dispose():void
		{

		}
	}
}