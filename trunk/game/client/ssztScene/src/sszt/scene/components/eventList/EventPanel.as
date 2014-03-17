package sszt.scene.components.eventList
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.events.EventListUpdateEvent;
	import sszt.scene.mediators.EventMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.splits.MCacheSplit3Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class EventPanel extends MPanel
	{
		private var _mediator:EventMediator;
		private var _bg:IMovieWrapper;
		private var _tile:MTile;
		
		public function EventPanel(mediator:EventMediator)
		{
			_mediator = mediator;
			super(new MCacheTitle1(LanguageManager.getWord("ssztl.common.event")),true,-1);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(300,185);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,3,284,177)),	
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(13,7,274,167)),
			]);
			addContent(_bg as DisplayObject);
			
			_tile = new MTile(248,18);
			_tile.itemGapH = 0;
			_tile.setSize(267,163);
			_tile.move(18,9);
			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.verticalScrollPolicy = ScrollPolicy.AUTO;
			_tile.verticalScrollBar.lineScrollSize = 18;
			addContent(_tile);
			
			initView();
			initEvent();
		}
		
		private function initView():void
		{
//			var list:Vector.<String> = _mediator.sceneInfo.eventList.getList();
			var list:Array = _mediator.sceneInfo.eventList.getList();
			for(var i:int =0;i<list.length;i++)
			{
				var eventLabel:TextField = new TextField();
				eventLabel.mouseEnabled = eventLabel.mouseWheelEnabled = false;
				eventLabel.textColor = 0xffffff;
				eventLabel.height = 20;
				eventLabel.width = 400;
				eventLabel.text = list[i];
				_tile.appendItem(eventLabel);
			}
		}
		
		private function initEvent():void
		{
			_mediator.sceneInfo.eventList.addEventListener(EventListUpdateEvent.ADDEVENT,addEventHandler);
		}
		
		private function removeEvent():void
		{
			_mediator.sceneInfo.eventList.removeEventListener(EventListUpdateEvent.ADDEVENT,addEventHandler);
		}
		
		private function addEventHandler(evt:EventListUpdateEvent):void
		{
			var mes:String = evt.data as String;
			var eventLabel:TextField = new TextField();
			eventLabel.textColor = 0xffffff;
			eventLabel.height = 20;
			eventLabel.width = 400;
			eventLabel.mouseEnabled = eventLabel.mouseWheelEnabled = false;
//			eventLabel.text = mes;
			_tile.appendItem(eventLabel);
			if(_tile.getItemCount() > 100)_tile.removeItemAt(0);
		}
		
		override public function dispose():void
		{
			removeEvent();
			if(_tile)
			{
				_tile.dispose();
				_tile = null;
			}
			super.dispose();
		}
	}
}