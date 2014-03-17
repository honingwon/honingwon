package sszt.friends.component.receiveRose
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.firework.RosePlaySocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.friends.FlowerBgAsset;
	import ssztui.friends.FunBtnAsset;
	import ssztui.ui.BtnAssetClose2;
	
	/**
	 * 鲜花回赠面板 
	 * @author chendong
	 * 
	 */	
	public class ReceiveRosePanel extends  MSprite implements IPanel
	{
		
		private static var instance:ReceiveRosePanel;
		private var _bg:IMovieWrapper;
		private var _dragArea:MSprite;
		private var _btnClose:MAssetButton1;
		
		/**
		 * XXX被你的魅力所倾倒，送上X朵玫瑰花！此刻无比幸福的您想要怎么感谢他（她）呢？
		 */
		private var _description:MAssetLabel;
		
		/**
		 * 聊天 
		 */
		private var _talkTo:MAssetButton1;
		private var _talkLabel:MAssetLabel;
		/**
		 * 回赠
		 */
		private var _sendFlowersTo:MAssetButton1;
		private var _sendFlowersLabel:MAssetLabel;
		
		private var _senderId:Number = 0;
		private var _sender:String = "";  //赠送着nick
		private var _type:int = 0;
		private var _count:int = 0;
		
		public static const DEFAULT_WIDTH:int = 327;
		public static const DEFAULT_HEIGHT:int = 280;
		
		private var roseIdArray:Array = [CategoryType.ROSE_1_ID,CategoryType.ROSE_2_ID,CategoryType.ROSE_3_ID,CategoryType.ROSE_4_ID];
		
		public function ReceiveRosePanel(senderId:int, sender:String, type:int,count:int)
		{
			_senderId = senderId;
			_sender = sender;
			_type = type;
			_count = count;
			initView();
			initEvent();
			initData();
		}
		
		private function initView():void
		{
			setPanelPosition(null);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,0,327,280),new Bitmap(new FlowerBgAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_dragArea = new MSprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose2());
			_btnClose.move(253,28);
			addChild(_btnClose);
			
			_description = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_description.setLabelType([new TextFormat("Tahoma",12,0xfffccc,null,null,null,null,null,null,null,null,null,8)]);
			_description.move(DEFAULT_WIDTH/2,96);
			addChild(_description);
			
			_talkTo = new MAssetButton1(new FunBtnAsset() as MovieClip);
			_talkTo.move(163-77, 160);
			addChild(_talkTo);
			_talkLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_talkLabel.move(163-38,167);
			addChild(_talkLabel);
			_talkLabel.setHtmlValue(LanguageManager.getWord("ssztl.common.chatModule"));
			
			_sendFlowersTo = new MAssetButton1(new FunBtnAsset() as MovieClip);
			_sendFlowersTo.move(164, 160);
			addChild(_sendFlowersTo);
			_talkLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_talkLabel.move(201,167);
			addChild(_talkLabel);
			_talkLabel.setHtmlValue(LanguageManager.getWord("ssztl.friends.giveBack"));
		}
		
		private function initEvent():void
		{
			_talkTo.addEventListener(MouseEvent.CLICK,talkClick);
			_sendFlowersTo.addEventListener(MouseEvent.CLICK,sendClick);
			
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);	
		}
		private function removeEvent():void
		{
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);	
		}
		private function talkClick(evt:MouseEvent):void
		{
			ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_CHATPANEL,{serverId:0,id:_senderId,nick:_sender,flag:1}));
			dispose(); 
		}
		
		private function sendClick(evt:MouseEvent):void
		{
//			if(haveCurrFlowers(_type))
//			{
				ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_GIVE_FLOWERS_PANEL,{id:_senderId,nick:_sender}));
//				RosePlaySocketHandler.send(_senderId,(_type+4),_count,false,_sender);
				dispose();
//			}
//			else
//			{
//				QuickTips.show(LanguageManager.getWord("ssztl.common.noTypeRoss"));
//			}
		}
		
		private function haveCurrFlowers(type:int):Boolean
		{
			var haveBoolean:Boolean = false;
			var list:Array;
			list = GlobalData.bagInfo.getItemById(roseIdArray[type]);
			if(list.length >= _count)
			{
				haveBoolean = true;
			}
			return haveBoolean;
		}
		
		private function initData():void
		{
//			_description.setHtmlValue(_sender+"被你的魅力所倾倒，送上"+ getRoseNum()  +"朵玫瑰花！此刻无比幸福的您想要怎么感谢他（她）呢？");
			_description.setHtmlValue(LanguageManager.getWord("ssztl.common.receiveRoseDes","<font color='#ffcc00'>"+_sender+"</font>","<font color='#00ff00'><b>"+getRoseNum()+"</b></font>"));
		}
		
		private function getRoseNum():String
		{
			var returStr:String = _count.toString();
			switch(_type)
			{
				case 0:
					returStr += "";
					break;
				case 1:
					returStr += LanguageManager.getWord("ssztl.friends.roseNum1");
					break;
				case 2:
					returStr += LanguageManager.getWord("ssztl.friends.roseNum2");;
					break;
				case 3:
					returStr += LanguageManager.getWord("ssztl.friends.roseNum3");;
					break;
			}
			return returStr;
		}
		private function setPanelPosition(e:Event):void
		{
			move( (CommonConfig.GAME_WIDTH - DEFAULT_WIDTH)/2, (CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT)/2);
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - DEFAULT_WIDTH,parent.stage.stageHeight - DEFAULT_HEIGHT));
		}
		private function dragUpHandler(evt:MouseEvent):void
		{
			stopDrag();
		}
		private function closeClickHandler(evt:MouseEvent):void
		{
			dispose();
		}
		public function doEscHandler():void
		{
			dispose();
		}
		override public function dispose():void
		{
			removeEvent();
			_talkTo.removeEventListener(MouseEvent.CLICK,talkClick);
			_sendFlowersTo.removeEventListener(MouseEvent.CLICK,sendClick);
			dispatchEvent(new Event(Event.CLOSE));
			
			if(parent) parent.removeChild(this);
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			instance = null;
			super.dispose();
		}
	}
}