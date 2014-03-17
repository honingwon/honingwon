package sszt.scene.components.tradeDirect
{
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CareerType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.events.CellEvent;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.scene.data.tradeDirect.TradeDirectInfo;
	import sszt.scene.data.tradeDirect.TradeDirectInfoUpdateEvent;
	import sszt.scene.mediators.TradeDirectMediator;
	import sszt.scene.socketHandlers.TradeCancelSocketHandler;
	import sszt.scene.socketHandlers.TradeItemAddSocketHandler;
	import sszt.scene.socketHandlers.TradeLockSocketHandler;
	import sszt.scene.socketHandlers.TradeSureSocketHandler;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton;
	import sszt.ui.button.MSelectButton;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.event.CloseEvent;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.btns.selectBtns.MCacheSelectBtn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BorderAsset9;
	import ssztui.ui.SplitCompartLine2;
	
	public class TradeDirectPanel extends MPanel
	{
		private var _mediator:TradeDirectMediator;
		private var _bg:IMovieWrapper;
		private var _selfTile:MTile;
//		private var _selfItems:Vector.<TradeDirectCell>;
		private var _selfItems:Array;
		private var _otherTile:MTile;
//		private var _otherItems:Vector.<TradeDirectCell>;
		private var _otherItems:Array;
		private var _serverId:int;
		/**
		 * 玩家id 
		 */
		private var _id:Number;
		private var _nick:String;
		private var _acceptBound:TradeDirectEmpty;
		/**
		 *交易 
		 */
		private var _tradeBtn:MCacheAssetBtn1;
		/**
		 *锁定 
		 */
		private var _lockBtn:MCacheAssetBtn1;
		/**
		 * 取消 
		 */
		private var _cancelBtn:MCacheAssetBtn1;
		/**
		 * 提示信息,如 “对方正在操作中。”
		 */
		private var _alertLabel:MAssetLabel;
		/**
		 * 自己铜币 
		 */
		private var _selfCopperField:TextField;
		/**
		 * 对方铜币 
		 */
		private var _otherCopperField:TextField;
		private var _confirmBtn:MCacheAssetBtn1;
//		private var _confirmBtn:MCacheSelectBtn(0,1,"帮会")
		private var _sendCancel:Boolean;
		/**
		 * 对方名称 
		 */		
		private var _nickTextField:MAssetLabel; 
		/**
		 *等级
		 */
//		private var _leveTextField:MAssetLabel;
//		private var _carrer:MAssetLabel;
		/**
		 *战斗力 
		 
		private var _fightTextField:MAssetLabel;*/
		/**
		 * "请留意对方信息,谨防受骗。"
		 */
		private var _promptField:MAssetLabel;
		
		private var _lockBorder1:DisplayObject;
		private var _lockBorder2:DisplayObject;
		
		public function TradeDirectPanel(mediator:TradeDirectMediator,id:Number,nick:String,serverId:int)
		{
			_mediator = mediator;
			_sendCancel = true;
			_id = id;
//			_serverId = serverId;
			_nick = nick;
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.TradeTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.TradeTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
			GlobalData.isInTrade = true;
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			setContentSize(386,272);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(9,3,368,262)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(16,10,175,216)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(195,10,175,216)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(18,12,171,22)),
				new BackgroundInfo(BackgroundType.BAR_1,new Rectangle(197,12,171,22)),
				
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(82,196,100,22)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(263,196,59,22)),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(17,59,173,25),new Bitmap(new SplitCompartLine2())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(196,59,173,25),new Bitmap(new SplitCompartLine2())),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,69,160,40),new Bitmap(CellCaches.getCellBgPanel4())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,109,160,40),new Bitmap(CellCaches.getCellBgPanel4())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,149,160,40),new Bitmap(CellCaches.getCellBgPanel4())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(204,69,160,40),new Bitmap(CellCaches.getCellBgPanel4())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(204,109,160,40),new Bitmap(CellCaches.getCellBgPanel4())),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(204,149,160,40),new Bitmap(CellCaches.getCellBgPanel4())),
			
				/**名称*/
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(17,11,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.name") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				/**等级*/
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(24,39,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.level") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
//				/**职业*/
//				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(92,39,40,17),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer") + "：",MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT)),
				
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(246,15,60,15),new MAssetLabel(LanguageManager.getWord('ssztl.scene.yourTradePanel'),MAssetLabel.LABEL_TYPE_TITLE2,"left")),
			]);
			addContent(_bg as DisplayObject);
			
			_nickTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.CENTER);
			_nickTextField.move(103,15);
			addContent(_nickTextField);
			
//			_leveTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
//			_leveTextField.move(62,39);
//			addContent(_leveTextField);
			
//			_carrer = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
//			_carrer.move(128,39);
//			addContent(_carrer);
			
//			_fightTextField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.LEFT);
//			_fightTextField.move(72,21);
//			addChild(_fightTextField);
			
			var label3:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.tradeCopper"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			label3.move(24,199);
			addContent(label3);
			
			var label4:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.tradeCopper"),MAssetLabel.LABEL_TYPE_TAG,TextFormatAlign.LEFT);
			label4.move(204,199);
			addContent(label4);
			
			_promptField = new MAssetLabel(LanguageManager.getWord("ssztl.trade.tradeDirectPrompt"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_promptField.textColor = 0xff0000;
			_promptField.move(204,39);
			addContent(_promptField);
			
			_acceptBound = new TradeDirectEmpty(_mediator);
			_acceptBound.move(204,69);
			addContent(_acceptBound);
			
			_selfTile = new MTile(38,38,4);
			_selfTile.setSize(158,118);
			_selfTile.move(204,69);
			addContent(_selfTile);
			
			_otherTile = new MTile(38,38,4);
			_otherTile.setSize(158,118);
			_otherTile.move(24,69);
			addContent(_otherTile);
			_selfTile.itemGapH = _selfTile.itemGapH = _otherTile.itemGapH = _otherTile.itemGapH = 2
			_selfTile.verticalScrollPolicy = _selfTile.horizontalScrollPolicy = _otherTile.verticalScrollPolicy = _otherTile.horizontalScrollPolicy = ScrollPolicy.OFF;
			
//			_selfItems = new Vector.<TradeDirectCell>();
//			_otherItems = new Vector.<TradeDirectCell>();
			_selfItems = [];
			_otherItems = [];
			
			_lockBtn =new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.lock"));
			_lockBtn.move(176,233);
			addContent(_lockBtn);
			
			_tradeBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.trade"));
			_tradeBtn.move(240,233);
			addContent(_tradeBtn);
			_tradeBtn.enabled = false;
			
			_cancelBtn = new MCacheAssetBtn1(0,2,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(304,233);
			addContent(_cancelBtn);
			
			_alertLabel = new MAssetLabel(LanguageManager.getWord("ssztl.scene.inOperation"),MAssetLabel.LABELTYPE3,TextFormatAlign.LEFT);
			_alertLabel.move(20,237);
			addContent(_alertLabel);
			
			_selfCopperField = new TextField();
			_selfCopperField.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_selfCopperField.x = 267;
			_selfCopperField.y = 199;
			_selfCopperField.width = 55;
			_selfCopperField.height = 16;
			_selfCopperField.type = TextFieldType.INPUT;
			addContent(_selfCopperField);
			
			_otherCopperField = new TextField();
			_otherCopperField.defaultTextFormat = new TextFormat("SimSun",12,0xfffccc);
			_otherCopperField.x = 85;
			_otherCopperField.y = 199;
			_otherCopperField.width = 95;
			_otherCopperField.height = 16;
			_otherCopperField.mouseEnabled = false;
			addContent(_otherCopperField);
			
			_selfCopperField.restrict = _otherCopperField.restrict = "0123456789";
			_selfCopperField.maxChars = _otherCopperField.maxChars = 9;
			
			_confirmBtn = new MCacheAssetBtn1(1,1,LanguageManager.getWord("ssztl.common.sure"));
			_confirmBtn.move(323,196);
			addContent(_confirmBtn);
			
			_lockBorder1 = MBackgroundLabel.getDisplayObject(new Rectangle(16,10,175,216),new BorderAsset9());
			_lockBorder2 = MBackgroundLabel.getDisplayObject(new Rectangle(195,10,175,216),new BorderAsset9());
			addContent(_lockBorder1);
			addContent(_lockBorder2);
			_lockBorder1.visible = _lockBorder2.visible = false;
				
			initData();
			initEvent();
		}
		
		private function initData():void
		{
			_nickTextField.text = _nick;
//			_carrer.text = CareerType.getNameByCareer(_mediator.sceneModule.sceneInfo.playerList.getPlayer(_id).info.career);
//			_leveTextField.text = _mediator.sceneModule.sceneInfo.playerList.getPlayer(_id).info.level +"";
		}
		
		private function initEvent():void
		{
			_acceptBound.addEventListener(CellEvent.CELL_MOVE,cellMoveHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.ADDSELFITEM,addSelfItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.ADDOTHERITEM,addOtherItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.REMOVESELFITEM,removeSelfItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.REMOVEOTHERITEM,removeOtherItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.SELFLOCK_UPDATE,selfLockHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.OTHERLOCK_UPDATE,otherLockHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.SELFSURE_UPDATE,selfSureHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.OTHERSURE_UPDATE,otherSureHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.DOCOMPLETE,doCompleteHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.DOCANCEL,otherDoCancelHandler);
			_mediator.sceneInfo.tradeDirectInfo.addEventListener(TradeDirectInfoUpdateEvent.OTHERCOPPER_CHANGE,otherCopperChangeHandler);
			_lockBtn.addEventListener(MouseEvent.CLICK,lockClickHandler);
			_tradeBtn.addEventListener(MouseEvent.CLICK,tradeClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,cancelClickHandler);
			_confirmBtn.addEventListener(MouseEvent.CLICK,confirmClickHandler);
		}
		
		private function removeEvent():void
		{
			_acceptBound.removeEventListener(CellEvent.CELL_MOVE,cellMoveHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.ADDSELFITEM,addSelfItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.ADDOTHERITEM,addOtherItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.REMOVESELFITEM,removeSelfItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.REMOVEOTHERITEM,removeOtherItemHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.SELFLOCK_UPDATE,selfLockHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.OTHERLOCK_UPDATE,otherLockHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.SELFSURE_UPDATE,selfSureHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.OTHERSURE_UPDATE,otherSureHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.DOCOMPLETE,doCompleteHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.DOCANCEL,otherDoCancelHandler);
			_mediator.sceneInfo.tradeDirectInfo.removeEventListener(TradeDirectInfoUpdateEvent.OTHERCOPPER_CHANGE,otherCopperChangeHandler);
			_lockBtn.removeEventListener(MouseEvent.CLICK,lockClickHandler);
			_tradeBtn.removeEventListener(MouseEvent.CLICK,tradeClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,cancelClickHandler);
			_confirmBtn.removeEventListener(MouseEvent.CLICK,confirmClickHandler);
		}
		
		private function cellMoveHandler(evt:CellEvent):void
		{
			var data:Object = evt.data;
			TradeItemAddSocketHandler.sendItemAdd(_id,data["place"]);
		}
		
		override public function doEscHandler():void{}
		
		private function addSelfItem(info:ItemInfo):void
		{
			var cell:TradeDirectCell = new TradeDirectCell();
			cell.itemInfo = info;
			_selfItems.push(cell);
			_selfTile.appendItem(cell);
			cell.addEventListener(MouseEvent.MOUSE_DOWN,cellMouseDownHandler);
		}
		private function addOtherItem(info:ItemInfo):void
		{
			var cell:TradeDirectCell = new TradeDirectCell();
			cell.itemInfo = info;
			_otherItems.push(cell);
			_otherTile.appendItem(cell);
		}
		private function removeSelfItem(id:Number):void
		{
			var cell:TradeDirectCell;
			for(var i:int = 0; i < _selfItems.length; i++)
			{
				if(_selfItems[i].itemInfo.itemId == id)
				{
					cell = _selfItems.splice(i,1)[0];
					break;
				}
			}
			if(cell)
			{
				cell.removeEventListener(MouseEvent.MOUSE_DOWN,cellMouseDownHandler);
				_selfTile.removeItem(cell);
			}
		}
		private function cellMouseDownHandler(evt:MouseEvent):void
		{
			if(!_mediator.sceneInfo.tradeDirectInfo.selfLock)
			{
				GlobalAPI.dragManager.startDrag(evt.currentTarget as IDragable);
			}
		}
		private function removeOtherItem(id:Number):void
		{
			var cell:TradeDirectCell;
			for(var i:int = 0; i < _otherItems.length; i++)
			{
				if(_otherItems[i].itemInfo.itemId == id)
				{
					cell = _otherItems.splice(i,1)[0];
					break;
				}
			}
			if(cell)
			{
				_otherTile.removeItem(cell);
			}
		}
		private function doCompleteHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			_sendCancel = false;
			dispose();
		}
		private function otherDoCancelHandler(evt:TradeDirectInfoUpdateEvent):void
		{
//			QuickTips.show("交易失败");
			QuickTips.show(LanguageManager.getWord("ssztl.scene.tradeFail"));
			dispose();
		}
		
		private function addSelfItemHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			addSelfItem(evt.data as ItemInfo);
		}
		private function addOtherItemHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			addOtherItem(evt.data as ItemInfo);
		}
		private function removeSelfItemHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			removeSelfItem(evt.data as Number);
		}
		private function removeOtherItemHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			removeOtherItem(evt.data as Number);
		}
		private function selfLockHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			_lockBtn.enabled = false;
			_selfCopperField.mouseEnabled = false;
			_selfCopperField.type = TextFieldType.DYNAMIC;
			if(_mediator.sceneInfo.tradeDirectInfo.otherLock)
			{
				_tradeBtn.enabled = true;
			}
			stage.focus = null;
		}
		private function otherLockHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			_lockBorder1.visible = true;
			_alertLabel.text = "对方已经锁定交易。";
			if(_mediator.sceneInfo.tradeDirectInfo.selfLock)
			{
				_tradeBtn.enabled = true;
			}
		}
		private function selfSureHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			_tradeBtn.enabled = false;
		}
		private function otherSureHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			
		}
		private function otherCopperChangeHandler(evt:TradeDirectInfoUpdateEvent):void
		{
			_otherCopperField.text = String(_mediator.sceneInfo.tradeDirectInfo.otherCopper);
		}
		
		private function lockClickHandler(evt:MouseEvent):void
		{
			if(confirmClickHandler(null))
			{
				_lockBorder2.visible = true;
				_mediator.selfLock();
				stage.focus = null;
				_confirmBtn.enabled = false;
			}
		}
		private function tradeClickHandler(evt:MouseEvent):void
		{
			_mediator.selfTrade();
		}
		private function cancelClickHandler(evt:MouseEvent):void
		{
			closeClickHandler(null);
		}
		override protected function closeClickHandler(evt:MouseEvent):void
		{
			MAlert.show("确定停止交易?",LanguageManager.getWord("ssztl.common.alertTitle"),MAlert.OK | MAlert.CANCEL,null,closeHandler);
			function closeHandler(evt:CloseEvent):void
			{
				if(evt.detail == MAlert.OK)
				{
					_mediator.selfCancel();
				}
			}
		}
		private function confirmClickHandler(evt:MouseEvent):Boolean
		{
			var value:int = int(_selfCopperField.text);
			if(value > GlobalData.selfPlayer.userMoney.copper)
			{
				QuickTips.show("铜币不足。");
				return false;
			}
			_mediator.selfSetCopper(int(_selfCopperField.text));
			return true;
		}
		
		override public function dispose():void
		{
			removeEvent();
			_mediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			var item:TradeDirectCell;
			for each(item in _selfItems)
			{
				item.dispose();
			}
			_selfItems = null;
			if(_selfTile)
			{
				_selfTile.dispose();
			}
			_selfTile = null;
			for each(item in _otherItems)
			{
				item.dispose();
			}
			_otherItems = null;
			if(_otherTile)
			{
				_otherTile.dispose();
			}
			_otherTile = null;
			if(_acceptBound)
			{
				_acceptBound.dispose();
				_acceptBound = null;
			}
			if(_tradeBtn)
			{
				_tradeBtn.dispose();
				_tradeBtn = null;
			}
			if(_lockBtn)
			{
				_lockBtn.dispose();
				_lockBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			if(_confirmBtn)
			{
				_confirmBtn.dispose();
				_confirmBtn = null;
			}
			super.dispose();
			if(_sendCancel)
				TradeCancelSocketHandler.send();
			GlobalData.isInTrade = false;
		}
	}
}