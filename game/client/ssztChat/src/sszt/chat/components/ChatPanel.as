package sszt.chat.components
{
	import fl.controls.ScrollBar;
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import sszt.chat.mediators.ChatMediator;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalData;
	import sszt.core.data.chat.ChannelType;
	import sszt.core.data.chat.ChatInfo;
	import sszt.core.data.chat.ChatInfoUpdateEvent;
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.data.systemMessage.SystemMessageInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	
	import ssztui.chat.ChatBaseBgAsset;
	
	public class ChatPanel extends MScrollPanel
	{
		private var _mediator:ChatMediator;
		private var _list:Array;
		private var _currentHeight:int;
		private var _bg:Bitmap;
		private var _isBig:Boolean;
		
		private var _itemList:Array;
		private var _showList:Array;
		private var _sizeChange:Array = [150,250];
		
		private const GAP:int = -6;
		
		public function ChatPanel(mediator:ChatMediator)
		{
			_mediator = mediator;
			super();
			init();
			initEvent();
		}
		
		private function init():void
		{
			_itemList = [];
			_showList = [];
			
			mouseEnabled = getContainer().mouseEnabled = false;
			width = 291;
			height = _sizeChange[0];
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.AUTO;
			
			_bg = new Bitmap(new ChatBaseBgAsset() as BitmapData);
			_bg.x = -21;
			_bg.y = 70;
			addChildAt(_bg,0);
			
			_currentHeight = 0;
			gameSizeChangeHandler(null);
		}
		
		private function initEvent():void
		{
			GlobalData.chatInfo.addEventListener(ChatInfoUpdateEvent.ADD_MESSAGE,addMessageHandler);
			
			GlobalData.chatInfo.addEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function removeEvent():void
		{
			GlobalData.chatInfo.removeEventListener(ChatInfoUpdateEvent.ADD_MESSAGE,addMessageHandler);
			
			GlobalData.chatInfo.removeEventListener(ChatInfoUpdateEvent.CHANNEL_CHANGE,channelChangeHandler);
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,gameSizeChangeHandler);
		}
		
		private function gameSizeChangeHandler(evt:CommonModuleEvent):void
		{
			var _m:int = CommonConfig.GAME_WIDTH >1250?0:60;
			x = 22;
			if(_isBig)
			{
				y = CommonConfig.GAME_HEIGHT - (_sizeChange[1]+60) - _m;
				_bg.y = _sizeChange[1]-140;
			}
			else 
			{
				y = CommonConfig.GAME_HEIGHT - (_sizeChange[0]+60) - _m;
				_bg.y = _sizeChange[0]-140;;
			}
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			var list:Array = GlobalData.chatInfo.currentUpdateList;
			updateList(list);
			GlobalData.chatInfo.clearUpdateList();
		}
		
		private function channelChangeHandler(e:ChatInfoUpdateEvent):void
		{
			invalidate("item");
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
			if(info.isRequoteByChannel(GlobalData.chatInfo.currentChannel))
			{
				getAndCreateItem(info);
			}
			invalidate("item");
		}
		
		override protected function draw():void
		{
			if(isInvalid("item"))
			{
				invalidHash["item"] = null;
				invalidHash[InvalidationType.ALL] = false;
				updateList2();
			}
			super.draw();
		}
		
		private function updateList2():void
		{
			var p:Boolean = (verticalScrollPosition >= maxVerticalScrollPosition - 3) || maxVerticalScrollPosition < 2;
			//临时注释
			var channelList:Array = GlobalData.chatInfo.getListByChannel(GlobalData.chatInfo.currentChannel);
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
		
		public function doEnd():void
		{
			verticalScrollPosition = maxVerticalScrollPosition;
		}
		
		public function updatePanelVisible(value:Boolean):void
		{
			this.visible = value;
		}
		
		private function updateList(list:Array):void
		{
		}
		
		public function setPanelSize(value:Boolean):void
		{
			_isBig = value; //!_isBig;
			if(_isBig)
				height = _sizeChange[1]; //260;
			else
				height = _sizeChange[0]; //210;
			gameSizeChangeHandler(null);
			update();
			verticalScrollPosition = maxVerticalScrollPosition;
		}
		
		override protected function setVerticalScrollBarPos():void
		{
			_verticalScrollBar.x = - ScrollBar.WIDTH - contentPadding;
			_verticalScrollBar.y = contentPadding;
		}
		
		override public function dispose():void
		{
			super.dispose();
			removeEvent();
			if(_bg)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			_itemList = null;
			_showList = null;
			_mediator = null;
		}
	}
}