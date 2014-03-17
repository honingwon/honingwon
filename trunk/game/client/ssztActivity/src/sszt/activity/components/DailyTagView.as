package sszt.activity.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.activity.mediators.ActivityMediator;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	
	import ssztui.activity.RowBgAsset;

	/**
	 * ‘每日活动’面板下‘日常’选项卡
	 */
	public class DailyTagView extends Sprite implements IActivityTabPanel
	{
		private var _mediator:ActivityMediator;		
		private var _bg:IMovieWrapper;
		
		private var _activityView:ActivityTabPanel;
		private var _taskView:TaskTabPanel;
		
		public function DailyTagView(argMediator:ActivityMediator)
		{
			super();
			_mediator = argMediator;
			
			initView();
			
			initEvent();
		}
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(3,3,299,380)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(304,3,299,380)),
			]);
			addChild(_bg as DisplayObject);
			
			_activityView = new ActivityTabPanel(_mediator);
			_activityView.move(6,6);
			addChild(_activityView);
			
			_taskView = new TaskTabPanel(_mediator);
			_taskView.move(307,6);
			addChild(_taskView);
		}
		private function initEvent():void
		{
			
		}
		private function removeEvent():void
		{
			
		}
		public function show():void
		{
//			if(_currentItem)
//			{
//				_currentItem.selected = false;
//				_currentItem.selected = true;
//			}
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		
		public function move(argX:int,argY:int):void
		{
			x = argX;
			y = argY;
		}
		public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_activityView)
			{
				_activityView.dispose();
				_activityView = null;
			}
			if(_taskView)
			{
				_taskView.dispose();
				_taskView = null;
			}
		}
	}
}