package sszt.scene.components.shenMoWar.members
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.mediators.SceneWarMediator;
	
	public class ShenMoWarMapTabPanel extends Sprite implements IShenMoRewardsInterface
	{
		private var _bg:IMovieWrapper;
		private var _mediator:SceneWarMediator;
		public function ShenMoWarMapTabPanel(argMediator:SceneWarMediator)
		{
			super();
			_mediator = argMediator;
			initialView();
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
																				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(0,0,625,356))
																			]);
			addChild(_bg as DisplayObject);
			
		}
		
		public function show():void
		{
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(argX:int, argY:int):void
		{
			x = argX;
			y = argY;
		}
		
		public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_mediator = null;
		}
	}
}