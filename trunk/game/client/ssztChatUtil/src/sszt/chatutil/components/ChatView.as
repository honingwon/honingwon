package sszt.chatutil.components
{
	import fl.controls.ScrollBar;
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import sszt.ui.container.MScrollPanel;
	
	import sszt.chatutil.data.ChatInfo;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.richTextField.RichTextField;
	
	public class ChatView extends MScrollPanel
	{
		private var _btnList:Array;
		private var _btnLabels:Array;
		private var _currentHeight:int;
		private var _list:Array;
		private var _itemList:Array;
		private var _showList:Array;
		private var _bg:Bitmap;
		private const GAP:int = 5;
		private var _chatInfo:ChatInfo;
		public function ChatView(chatInfo:ChatInfo)
		{
			_chatInfo = chatInfo;
			super();
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			_itemList = [];
			_showList = [];
			mouseEnabled = getContainer().mouseEnabled = false;
			width = 285;
			height = 210;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.ON;
			_bg = new Bitmap(new BitmapData(1,1,true,0x50000000));
			_bg.x = 0;
			_bg.y = 0;
			_bg.width = 265;
			_bg.height = 210;
			addChildAt(_bg,0);
			
			_list = [];
			_currentHeight = 0;
		}
		
		private function initEvents():void
		{
			_chatInfo.addEventListener(ChatInfoUpdateEvent.ADD_MESSAGE,addMessageHandler);
			_chatInfo.addEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
		}
		
		private function removeEvents():void
		{
			_chatInfo.removeEventListener(ChatInfoUpdateEvent.ADD_MESSAGE,addMessageHandler);
			_chatInfo.removeEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
		}
		
		override protected function setVerticalScrollBarPos():void
		{
			_verticalScrollBar.x = - ScrollBar.WIDTH - contentPadding;
			_verticalScrollBar.y = contentPadding;
		}
		
		private function addMessageHandler(evt:ChatInfoUpdateEvent):void
		{
			var removeInfo:ChatItemInfo = evt.data["remove"];
			var addInfo:ChatItemInfo = evt.data["add"];
			if(removeInfo)
			{
				removeItem(removeInfo);
			}
			if(addInfo)
			{
				addItem(addInfo);
			}
		}
		
		private function removeItem(info:ChatItemInfo):void
		{
			var field:ChatTextField = getItemFromTotalList(info,true);
			if(!field)return;
			var index:int = _showList.indexOf(field);
			if(index > -1)
			{
				_showList.splice(index,1);
			}
			if(field)
			{
				field.dispose();
				field = null;
			}
			invalidate("item");
		}
		private function addItem(info:ChatItemInfo):void
		{
			//新加的项，判断一下当前频道，如果是切频道，取视图时需要先判断是否已存在
			if(info.isRequoteByChannel(_chatInfo.currentChannel))
			{
				getAndCreateItem(info);
			}
			invalidate("item");
		}
		
		private function getAndCreateItem(info:ChatItemInfo):ChatTextField
		{
			var field:ChatTextField = getItemFromTotalList(info);
			if(!field)
			{
				field = new ChatTextField(info,RichTextUtil.getChatRichText(info));
				_itemList.push(field);
			}
			return field;
		}
		
		private function getItemFromTotalList(info:ChatItemInfo,shift:Boolean = false):ChatTextField
		{
			var field:ChatTextField;
			for(var i:int = 0; i < _itemList.length; i++)
			{
				if(_itemList[i] && _itemList[i].info == info)
				{
					if(shift)field = _itemList.splice(i,1)[0];
					else field = _itemList[i];
				}
			}
			return field;
		}
		
		private function channelChangeHandler(e:ChatInfoUpdateEvent):void
		{
			invalidate("item");
		}
		
		private function updateList():void
		{
			var p:Boolean = (verticalScrollPosition >= maxVerticalScrollPosition - 3) || maxVerticalScrollPosition < 2;
			//临时注释
			var channelList:Array = _chatInfo.getListByChannel(_chatInfo.currentChannel);
			var tmp:Array = [];
			var i:int = 0;
			for(i = 0; i < channelList.length; i++)
			{
				tmp.push(getAndCreateItem(channelList[i]));
			}
			//删除，添加
			for(i = _showList.length - 1; i >= 0; i--)
			{
				if(tmp.indexOf(_showList[i]) == -1)
				{
					var field:ChatTextField = _showList.splice(i,1)[0];
					if(field && field.field.parent)field.field.parent.removeChild(field.field);
				}
			}
			var tmpShow:Array = [];
			for(i = 0 ;i < tmp.length; i++)
			{
				
				var showIndex:int = _showList.indexOf(tmp[i]);
				if(showIndex == -1)
				{
					getContainer().addChild(tmp[i].field);
					tmpShow.push(tmp[i]);
				}
				else
					tmpShow.push(_showList[showIndex]);
			}
			_showList = tmpShow;
			var currentHeight:int = 0;
			for(i = 0; i < _showList.length; i++)
			{
				_showList[i].field.y = currentHeight;
				currentHeight += _showList[i].field.height + GAP;
			}
			getContainer().height = currentHeight;
			if(currentHeight > 0)
			{
				update();
			}
			
			if(p)
			{
				doEnd();
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid("item"))
			{
				invalidHash["item"] = null;
				invalidHash[InvalidationType.ALL] = false;
				updateList();
			}
			super.draw();
		}
		
		public function doEnd():void
		{
			verticalScrollPosition = maxVerticalScrollPosition;
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_list)
			{
				for(var i:int = 0; i < _list.length; i++)
				{
					_list[i].dispose();
				}
			}
			_list = null;
			super.dispose();
		}
	}
}