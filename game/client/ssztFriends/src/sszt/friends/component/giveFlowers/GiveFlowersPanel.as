package sszt.friends.component.giveFlowers
{
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.CommonConfig;
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.socketHandlers.firework.RosePlaySocketHandler;
	import sszt.core.view.quickBuy.BuyPanel;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.FriendModuleEvent;
	import sszt.events.ModuleEvent;
	import sszt.friends.mediator.FriendsMediator;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.MCacheAssetBtn2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.friends.FindTitleAsset;
	import ssztui.friends.FlowerBgAsset;
	import ssztui.friends.FunBtnAsset;
	import ssztui.ui.BtnAssetClose2;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class GiveFlowersPanel extends MSprite implements IPanel
	{
		private var _mediator:FriendsMediator;
		private var _bg:IMovieWrapper;
		private var _dragArea:MSprite;
		private var _btnClose:MAssetButton1;
		/**
		 * 好友列表 
		 */		
		private var _comboxFriends:ComboBox;
		/**
		 *选择赠送鲜花的的数量 
		 */		
		private var _comboxFlowers:ComboBox;
		
		private var _count:int = 1;
		private var _countValue:TextField;
		private var _up:MCacheAssetBtn2;
		private var _down:MCacheAssetBtn2;
		
		/**
		 * "自动购买并赠送" 
		 */		
		private var _buyFlowersCheckBox:CheckBox;
		/**
		 * 赠送鲜花 “立即行动” 
		 */
		private var _giveFlowersbtn:MAssetButton1;
		private var _giveFlowersLabel:MAssetLabel;
		
		private var _player:ImPlayerInfo;
		
		private var friendArray:Array = [];
		private var flowersArray:Array = [
//			{label:LanguageManager.getWord("ssztl.common.selectRoses"),value:-1},
			{label:"1"+LanguageManager.getWord("ssztl.common.rosesUnit"),value:0},
			{label:"9"+LanguageManager.getWord("ssztl.common.rosesUnit"),value:1},
			{label:"99"+LanguageManager.getWord("ssztl.common.rosesUnit"),value:2},
			{label:"999"+LanguageManager.getWord("ssztl.common.rosesUnit"),value:3}
		];
		
		public static const DEFAULT_WIDTH:int = 327;
		public static const DEFAULT_HEIGHT:int = 280;
		
		
		private var roseIdArray:Array = [CategoryType.ROSE_1_ID,CategoryType.ROSE_2_ID,CategoryType.ROSE_3_ID,CategoryType.ROSE_4_ID];
		
		
		/**
		 * 当前鲜花类型 背包中最大的数量 
		 */
		private var _currentTypeMax:int = 1;
		
		public function GiveFlowersPanel(mediator:FriendsMediator,player:ImPlayerInfo)
		{
			_mediator = mediator;
			_player = player;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			setPanelPosition(null);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(0,0,327,280),new Bitmap(new FlowerBgAsset())),
				new BackgroundInfo(BackgroundType.BORDER_6, new Rectangle(183,120,73,22))
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
			
			_comboxFriends = new ComboBox();
			_comboxFriends.open();
			_comboxFriends.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC));
			_comboxFriends.move(110,88);
			_comboxFriends.setSize(114,22);
			addChild(_comboxFriends);
//			_comboxFriends.dataProvider = new DataProvider([{label:LanguageManager.getWord("ssztl.common.allQulity"),value:99},
//				{label:LanguageManager.getWord("ssztl.common.whiteQulity2"),value:0},
//				{label:LanguageManager.getWord("ssztl.common.greenQulity2"),value:1},
//				{label:LanguageManager.getWord("ssztl.common.blueQulity2"),value:2},
//				{label:LanguageManager.getWord("ssztl.common.purpleQulity2"),value:3},
//				{label:LanguageManager.getWord("ssztl.common.orangeQulity2"),value:4}]);
//			_comboxFriends.selectedIndex = 0;
			
			_comboxFlowers = new ComboBox();
			_comboxFlowers.open();
			_comboxFlowers.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xff9900));
			_comboxFlowers.move(69,120);
			_comboxFlowers.setSize(113,22);
			_comboxFlowers.rowCount = 6;
			addChild(_comboxFlowers);
			
			_down = new MCacheAssetBtn2(1);
			_down.move(185,122);
			addChild(_down);
			
			_up = new MCacheAssetBtn2(0);
			_up.move(236,122);
			addChild(_up);
			
			
			
			_countValue = new TextField();
			_countValue.defaultTextFormat = new TextFormat("Tahoma",12,0xfffccc);
			_countValue.type = TextFieldType.INPUT;
			_countValue.autoSize = TextFormatAlign.CENTER;
			_countValue.maxChars = 3;
			_countValue.restrict ="0123456789";
			_countValue.width = 33;
			_countValue.height = 16;
			_countValue.text = "1";
			_countValue.x = 215;
			_countValue.y = 122;
			addChild(_countValue);
			
			_buyFlowersCheckBox = new CheckBox();
			_buyFlowersCheckBox.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffe673));
			_buyFlowersCheckBox.label = LanguageManager.getWord("ssztl.common.autoBuyGive");
			_buyFlowersCheckBox.setSize(124,20);
			_buyFlowersCheckBox.move(107,154);
//			_buyFlowersCheckBox.selected = true;
			addChild(_buyFlowersCheckBox);
			
			_giveFlowersbtn = new MAssetButton1(new FunBtnAsset() as MovieClip);
			_giveFlowersbtn.move(125, 186);
			addChild(_giveFlowersbtn);
			_giveFlowersLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_giveFlowersLabel.move(125+37,193);
			addChild(_giveFlowersLabel);
			_giveFlowersLabel.setValue(LanguageManager.getWord("ssztl.common.takeActionRightNow"));
			
		}
		
		public function initEvent():void
		{
			_up.addEventListener(MouseEvent.CLICK,upClickHandler);
			_down.addEventListener(MouseEvent.CLICK,downClickHandler);
			_countValue.addEventListener(Event.CHANGE,changeHandler);
			_giveFlowersbtn.addEventListener(MouseEvent.CLICK,giveFlowersClick);
			_comboxFlowers.addEventListener(Event.CHANGE,comboxChange);
			
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);	
			
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.BUY_FLOWERS,buyFlowers);
			ModuleEventDispatcher.addFriendEventListener(FriendModuleEvent.GIVE_FLOWERS,buyFlowers);
		}
		
		public function initData():void
		{
			
			var groups:Array = GlobalData.imPlayList.getSelfGroup();
			var friendArray:Array = [];
			var imPlayer:ImPlayerInfo;
			var obj:Object;
			var i:int = 1;
			var j:int = 0;
			var selectIndex:int = 0
			for each(imPlayer in groups[0])
			{
				obj = {};
				obj.label = imPlayer.info.nick;
				obj.userId = imPlayer.info.userId;
				if(_player && imPlayer.info.userId == _player.info.userId)
				{
					selectIndex = j;
				}
				friendArray.push(obj);
				j++;
			}
			for(;i<groups.length;i++)
			{
				for each(imPlayer in groups[i])
				{
					obj.label = imPlayer.info.nick;
					obj.userId = imPlayer.info.userId;
					if(_player && imPlayer.info.userId == _player.info.userId)
					{
						selectIndex = j+i;
					}
					friendArray.push(obj);
				}
			}
			_comboxFriends.dataProvider = new DataProvider(friendArray);
			_comboxFriends.selectedIndex = selectIndex;
			setFlowerArrayData();
			_comboxFlowers.dataProvider = new DataProvider(flowersArray);
			_comboxFlowers.selectedIndex = 0;
			setMaxValue(_comboxFlowers.selectedItem);
		}
		
		/**
		 * 设置各个类型鲜花的数量
		 */		
		private function setFlowerArrayData():void
		{
			var obj:Object;
			var list:Array;
			var countInt:int;
			for(var i:int=0; i<flowersArray.length;i++)
			{
				obj = flowersArray[i];
				if(String(obj.label).indexOf("(") > -1)
				{
					obj.label = String(obj.label).substring(0,String(obj.label).indexOf("("));
				}
//				list = GlobalData.bagInfo.getItemById(roseIdArray[i]);
				countInt = GlobalData.bagInfo.getItemCountById(roseIdArray[i]);
//				obj.label += "("+ list.length +")";
				obj.label += "("+ countInt +")";
			}
		}
		
		/**
		 * 根据鲜花类型获得鲜花数量
		 * @param type 鲜花类型 4中类型，1，9，99，999多
		 * @return 
		 */		
		private function getFlowersByType(type:int):int
		{
			var intNum:int = 0;
//			var list:Array;
//			list = GlobalData.bagInfo.getItemById(roseIdArray[type]);
			var countInt:int;
			countInt = GlobalData.bagInfo.getItemCountById(roseIdArray[type]);
			return countInt;
		}
		
		private function upClickHandler(evt:MouseEvent):void
		{
			if(_count>= 999) return;
			SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			_count = _count +1;
			_countValue.text = String(_count);
		}
		
		private function downClickHandler(evt:MouseEvent):void
		{
			if(_count <= 1)
			{
				_count = 1;
			}else
			{
				_count = _count - 1;
				SoundManager.instance.playSound(SoundManager.COMMON_BTN);
			}
			_countValue.text = String(_count);
		}
		
		private function changeHandler(evt:Event):void
		{
			_count = int(_countValue.text);
		}
		
		private function giveFlowersClick(evt:MouseEvent):void
		{
			var isAuto:Boolean = false;
			var type:int = int(_comboxFlowers.selectedItem.value); //送花的类型 0，1，2，3
			var imPlayer:ImPlayerInfo;
			var obj:Object =_comboxFriends.selectedItem; 
			imPlayer =  GlobalData.imPlayList.getFriend(int(obj.userId));
			if(type != -1)
			{
				isAuto = _buyFlowersCheckBox.selected;
				if(!isAuto)
				{
					if(haveCurrFlowers(type))
					{
						RosePlaySocketHandler.send(imPlayer.info.userId,type,_count,isAuto,imPlayer.info.nick);
					}
					else
					{
//						QuickTips.show(LanguageManager.getWord("ssztl.common.noTypeRoss"));
						MAlert.show(LanguageManager.getWord("ssztl.common.buyOrNotRoss"),LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.YES|MAlert.NO,null,getBuyRose);
					}
				}
				else
				{
					RosePlaySocketHandler.send(imPlayer.info.userId,type,_count,isAuto,imPlayer.info.nick);
				}
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.common.selectRoseNumber"));
			}
//			dispose();
		}
		
		private function getBuyRose(evt:CloseEvent):void
		{
			if(evt.detail == MAlert.YES)
			{
				BuyPanel.getInstance().show(roseIdArray,new ToStoreData(ShopID.STORE));
			}
		}
		
		private function comboxChange(evt:Event):void
		{
			var obj:Object = ComboBox(evt.currentTarget).selectedItem;
			setMaxValue(obj);
		}
		
		private function buyFlowers(evt:FriendModuleEvent):void
		{
			var currentIndex:int = _comboxFlowers.selectedIndex;
			setFlowerArrayData();
//			_comboxFlowers.dataProvider = null;
			_comboxFlowers.dataProvider = new DataProvider(flowersArray);
			_comboxFlowers.selectedIndex = currentIndex;
			setMaxValue(_comboxFlowers.selectedItem);
		}
		
		private function setMaxValue(argObj:Object):void
		{
			_currentTypeMax =  getFlowersByType(int(argObj.value));
			if(_currentTypeMax <= 0)
			{
				_currentTypeMax = 1;
			}
			_count = _currentTypeMax;
			_countValue.text = _currentTypeMax.toString();
		}
		
		
		private function haveCurrFlowers(type:int):Boolean
		{
			var haveBoolean:Boolean = false;
//			var list:Array;
//			list = GlobalData.bagInfo.getItemById(roseIdArray[type]);
			var countInt:int;
			countInt = GlobalData.bagInfo.getItemCountById(roseIdArray[type]);
			if(countInt >= _count)
			{
				haveBoolean = true;
			}
			return haveBoolean;
		}
		
		public function clearData():void
		{
		}
		
		public function removeEvent():void
		{
			_up.removeEventListener(MouseEvent.CLICK,upClickHandler);
			_down.removeEventListener(MouseEvent.CLICK,downClickHandler);
			_countValue.removeEventListener(Event.CHANGE,changeHandler);
			_giveFlowersbtn.removeEventListener(MouseEvent.CLICK,giveFlowersClick);
			_comboxFlowers.removeEventListener(Event.CHANGE,comboxChange);
			
			_dragArea.removeEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.removeEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.removeEventListener(MouseEvent.CLICK,closeClickHandler);	
			
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.BUY_FLOWERS,buyFlowers);
			ModuleEventDispatcher.removeFriendEventListener(FriendModuleEvent.GIVE_FLOWERS,buyFlowers);
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
			// TODO Auto Generated method stub
			removeEvent();
			dispatchEvent(new Event(Event.CLOSE));
			
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_dragArea)
			{
				_dragArea.dispose();
				_dragArea = null;
			}
			 _comboxFriends = null;
			_comboxFlowers = null;
			
			_countValue = null;
			_up = null;
			_down = null;
			_giveFlowersLabel = null;
			_buyFlowersCheckBox = null;
			_giveFlowersbtn = null;
			super.dispose();
		}
		
		
	}
}