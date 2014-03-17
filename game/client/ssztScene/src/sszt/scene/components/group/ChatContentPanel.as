package sszt.scene.components.group
{
	import fl.controls.ScrollPolicy;
	
	import sszt.ui.container.MScrollPanel;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.scene.components.group.groupSec.ChatItemView;
	import sszt.scene.mediators.GroupMediator;
	
	public class ChatContentPanel extends MScrollPanel
	{
		private var _mediator:GroupMediator;
		private var _currentHeight:int = 0;
//		private var _list:Vector.<ChatItemView>;
		private var _list:Array;
		private static const ITEM_GAP:int = 3;
			
		public function ChatContentPanel(mediator:GroupMediator)
		{
			_mediator = mediator;
			super();
			init();
		}
		
		private function init():void
		{
			verticalScrollPolicy = ScrollPolicy.ON;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			setSize(312,206);

//			_list = new Vector.<ChatItemView>();
			_list = [];
			
			initData();
			initEvent();
		}
		
		private function initEvent():void
		{
			GlobalData.chatInfo.addEventListener(ChatInfoUpdateEvent.ADD_GROUP_CHATINFO,updateView);
		}
		
		private function removeEvent():void
		{
			GlobalData.chatInfo.removeEventListener(ChatInfoUpdateEvent.ADD_GROUP_CHATINFO,updateView);
		}
			
		private function initData():void
		{
//			var list:Vector.<ChatItemInfo> = GlobalData.chatInfo.grouplist;
			var list:Array = GlobalData.chatInfo.grouplist;
			for(var i:int =0;i<list.length;i++)
			{
				var itemView:ChatItemView = new ChatItemView(list[i]);
				itemView.y = getContainer().height;
				getContainer().addChild(itemView);
				_currentHeight = _currentHeight + itemView.getHeight()+ITEM_GAP;
				getContainer().height = _currentHeight;
				_list.push(itemView);
				update();
			}
			
			verticalScrollPosition = maxVerticalScrollPosition;
		}
		
		private function updateView(evt:ChatInfoUpdateEvent):void
		{
			var info:ChatItemInfo = evt.data as ChatItemInfo;
			var itemView:ChatItemView = new ChatItemView(info);
			itemView.y = getContainer().height;
			getContainer().addChild(itemView);
			_currentHeight = _currentHeight + itemView.getHeight()+ITEM_GAP;
			getContainer().height = _currentHeight;
			update();
			_list.push(itemView);
			
			verticalScrollPosition = maxVerticalScrollPosition;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_list)
			{
				for(var i:int =0;i<_list.length;i++)
				{
					_list[i].dispose();
				}
				_list = null;
			}
			super.dispose();
		}
	}
}