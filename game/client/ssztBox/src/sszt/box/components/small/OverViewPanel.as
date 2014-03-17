package sszt.box.components.small
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.box.components.GainPanel;
	import sszt.box.events.ShenMoStoreEvent;
	import sszt.box.mediators.BoxMediator;
	import sszt.constData.CategoryType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.RichTextUtil;
	import sszt.core.view.richTextField.RichTextField;
	import sszt.events.BoxMessageEvent;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MTextArea;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class OverViewPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _gainItemMsgArea:MTextArea;
//		private var _tile:MTile;	
		private var _msgViewList:Array = [];
		private var _listView:MScrollPanel;
		
		private var _mediator:BoxMediator;
		
		public function OverViewPanel(mediator:BoxMediator)
		{
			_mediator = mediator;
//			super(new MCacheTitle1("",new Bitmap(new OverViewTitleAsset())), true, -1, true, true);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(406,406);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,406,406)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,6,395,194)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(6,205,395,194)),
				
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(10,10,388,22)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(10,209,388,22))
			]);
			
			addContent(_bg as DisplayObject);
			
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(178,12,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.overView"),MAssetLabel.LABELTYPE3)));
			addContent(MBackgroundLabel.getDisplayObject(new Rectangle(178,211,52,16),new MAssetLabel(LanguageManager.getWord("ssztl.box.summarize"),MAssetLabel.LABELTYPE3)));
		
			_gainItemMsgArea = new MTextArea();
			_gainItemMsgArea.x = 13;
			_gainItemMsgArea.y = 33;
			_gainItemMsgArea.width = 388;
			_gainItemMsgArea.height = 163;
			_gainItemMsgArea.textField.mouseEnabled = _gainItemMsgArea.textField.mouseWheelEnabled = false;
			if(GlobalData.boxMsgInfo.gainItemList.length>0)
			{
				_gainItemMsgArea.htmlText = getGainItemStr(GlobalData.boxMsgInfo.gainItemList);
			}
			_gainItemMsgArea.verticalScrollPolicy = ScrollPolicy.ON;
			addContent(_gainItemMsgArea);
			
//			_tile = new MTile(255,36,1);
//			_tile.itemGapH = _tile.itemGapW = 0;
//			_tile.width = 385;
//			_tile.height = 164;
//			_tile.move(11,231);
//			_tile.verticalScrollPolicy = ScrollPolicy.ON;
//			_tile.horizontalScrollPolicy = ScrollPolicy.OFF;
//			addContent(_tile);
			
			_listView = new MScrollPanel();
			_listView.mouseEnabled = _listView.getContainer().mouseEnabled = false;
			_listView.move(11,231);
			_listView.setSize(385,164);
			_listView.horizontalScrollPolicy = "off";
			_listView.verticalScrollPolicy = "on";
			addContent(_listView);
			_listView.update();
			
			initTile();
		}
		
		private function initTile():void
		{
			_msgViewList = [];
			var msgList:Array = GlobalData.boxMsgInfo.msgList;
			var richTextField:RichTextField;
			var len:int = msgList.length <= 20 ? msgList.length : 20;
			var currentHeight:int = 0;
			for(var i:int=0;i<len;i++)
			{
				richTextField = RichTextUtil.getOpenBoxRichText(msgList[i],360);
				richTextField.y = currentHeight;
				_listView.getContainer().addChild(richTextField);
				currentHeight += richTextField.height;
//				_tile.appendItem(richTextField);
				_msgViewList.push(richTextField);
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
			_listView.verticalScrollPosition = _listView.maxVerticalScrollPosition;
			
//			while(_msgViewList.length > 20)
//			{
//				richTextField = _msgViewList.shift();
//				if(_tile.containItem(richTextField))
//				{
//					_tile.removeItem(richTextField);
//					richTextField.dispose();
//				}
//			}
		}
		
		private function initEvents():void
		{
			GlobalData.boxMsgInfo.addEventListener(BoxMessageEvent.BOX_MSG_ADD,msgAddHandler);
			GlobalData.boxMsgInfo.addEventListener(BoxMessageEvent.GAIN_ITEM_LIST_UPDATE,gainItemUpdateHandler);
		}
		
		private function removeEvents():void
		{
			GlobalData.boxMsgInfo.removeEventListener(BoxMessageEvent.BOX_MSG_ADD,msgAddHandler);
			GlobalData.boxMsgInfo.removeEventListener(BoxMessageEvent.GAIN_ITEM_LIST_UPDATE,gainItemUpdateHandler);
		}
		
		private function msgAddHandler(evt:BoxMessageEvent):void
		{
			
			var richTextField:RichTextField = RichTextUtil.getOpenBoxRichText(evt.data as String,360);
			_listView.getContainer().addChild(richTextField);
			_msgViewList.push(richTextField);
			
			while(_msgViewList.length > 20)
			{
				richTextField = _msgViewList.shift();
				if(_listView.getContainer().contains(richTextField))
				{
					_listView.getContainer().removeChild(richTextField);
					richTextField.dispose();
				}
			}
			
			var currentHeight:int = 0;
			for(var i:int = 0; i < _msgViewList.length; i++)
			{
				_msgViewList[i].y = currentHeight;
				currentHeight += _msgViewList[i].height;
			}
			_listView.getContainer().height = currentHeight;
			_listView.update();
			_listView.verticalScrollPosition = _listView.maxVerticalScrollPosition;
		}
		
		private function gainItemUpdateHandler(evt:BoxMessageEvent):void
		{
			var itemList:Array = evt.data as Array;
			if(itemList.length>0)
			{
				_gainItemMsgArea.htmlText = getGainItemStr(itemList);
			}
		}
		
		private function getGainItemStr(list:Array):String
		{
			var item:ItemInfo;
			var detailStr:String = "";
			for(var i:int=0;i<list.length;i++)
			{
				item = list[i];
				detailStr += "<font color='#"+ CategoryType.getQualityColorString(item.template.quality) +
					"'>【" + item.template.name + "】" + " * " + item.count + "<font>\n";
			}
			detailStr = detailStr.slice(0,detailStr.length - 1);
			return detailStr;
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_listView)
			{
				_listView.dispose();
				_listView = null;
			}
//			if(_tile)
//			{
//				_tile.dispose();
//				_tile = null;
//			}
			if(_msgViewList)
			{
				for each(var field:RichTextField in _msgViewList)
				{
					field.dispose();
				}
				field = null;
				_msgViewList = null;
			}
			
			super.dispose();
		}
	}
}