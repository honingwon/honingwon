package sszt.chat.components.sec
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	
	import sszt.chat.events.ChatInnerEvent;
	import sszt.chat.mediators.ChatMediator;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.manager.LayerManager;
	import sszt.core.manager.SoundManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ChannelView extends MSprite
	{
		private var _mediator:ChatMediator;
		private var _bgasset:IMovieWrapper;
//		private var _list:Vector.<ChannelItem>;
		private var _list:Array;
		
		public function ChannelView(mediator:ChatMediator)
		{
			_mediator = mediator;
			super();
			initView();
		}
		
		private function initView():void
		{
			//			_list = new Vector.<ChannelItem>();
			_list = [];
			//			var list:Vector.<String> = ChannelType.getAllChannel();
			var list:Array = ChannelType.getAllChannel();
			
			_bgasset = BackgroundUtils.setBackground([new BackgroundInfo(BackgroundType.BORDER_4,new Rectangle(0,0,56,18*list.length+14))]);
			addChild(_bgasset as DisplayObject);

			for(var i:int = 0; i < list.length; i++)
			{
				var item:ChannelItem = new ChannelItem(list[i]);
				item.addEventListener(MouseEvent.CLICK,itemClickHandler);
				item.x = 3;
				item.y = 7+18*i;
				addChild(item);
				_list.push(item);
			}
		}
		
		private function itemClickHandler(e:MouseEvent):void
		{
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			var channel:int = _list.indexOf(e.currentTarget as ChannelItem) + 1;
			if(channel == ChannelType.PRIVATE)
				_mediator.showPrivatePanel();
//			GlobalData.chatInfo.currentChannel = channel;
			dispatchEvent(new ChatInnerEvent(ChatInnerEvent.CHANNEL_CHANGE,channel));
		}
		
		public function show():void
		{
			GlobalAPI.layerManager.getPopLayer().addChild(this);
			GlobalAPI.layerManager.getPopLayer().stage.addEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		private function hideHandler(e:MouseEvent):void
		{
			hide();
		}
		
		public function hide():void
		{
			if(this.parent)this.parent.removeChild(this);
			GlobalAPI.layerManager.getPopLayer().stage.removeEventListener(MouseEvent.CLICK,hideHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_bgasset)
			{
				_bgasset.dispose();
				_bgasset = null;
			}
			if(_list)
			{
				for(var i:int = 0; i < _list.length; i++)
				{
					_list[i].removeEventListener(MouseEvent.CLICK,itemClickHandler);
					_list[i].dispose();
				}
			}
			_list = null;
		}
	}
}