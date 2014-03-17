package sszt.firstRecharge.components
{
	import fl.controls.CheckBox;
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CommonConfig;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.deploys.types.GuideTipDeployType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.OpenActivityUtils;
	import sszt.core.manager.LanguageManager;
	import sszt.core.manager.SoundManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.JSUtils;
	import sszt.events.CommonModuleEvent;
	import sszt.firstRecharge.mediator.FirstRechargeMediator;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.tick.ITick;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.button.MBitmapButton;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar;
	
	import ssztui.openServer.BtnGetAsset;
	import ssztui.openServer.BtnPayAsset;
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	
	public class FirstRechargePanel extends MSprite implements IPanel
	{
		public static const DEFAULT_WIDTH:int = 760; //590;
		public static const DEFAULT_HEIGHT:int = 387; //367;
		
		private var _bg:Bitmap;
		private var _dragArea:Sprite;
		private var _btnClose:MAssetButton1;
		private var _mediator:FirstRechargeMediator;
		private var _tile:MTile;
		private var _cellList:Array;
		private var _cellPos:Array;
		
		/**
		 * 首冲 送的礼包 
		 */
		private var _bigCell:BigCell;
		
		/**
		 * 充值按钮 
		 */
		private var _btnRec:MAssetButton1;
		/**
		 * 领取按钮 
		 */
		private var _btnGet:MAssetButton1;
		
		private var _type:int = 1; //1:"首冲"
		/**
		 * 模板数据 
		 */
		private var opAct:Array;
		
		private var _ef:MovieClip;
		
		public function FirstRechargePanel(mediator:FirstRechargeMediator)
		{
			_mediator = mediator;
			initEvent();
			initData();
			
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setPanelPosition(null);
			
			_bg = new Bitmap();
			addChild(_bg);
			
			_dragArea = new Sprite();
			_dragArea.graphics.beginFill(0,0);
			_dragArea.graphics.drawRect(0,0,DEFAULT_WIDTH,DEFAULT_HEIGHT);
			_dragArea.graphics.endFill();
			addChild(_dragArea);
			
			_btnClose = new MAssetButton1(new BtnAssetClose());
			_btnClose.move(DEFAULT_WIDTH-40,36);
			addChild(_btnClose);
			
			_bigCell = new BigCell();
			_bigCell.move(514,247); //457,210;
			addChild(_bigCell);
			
			_ef = MovieCaches.getCellBlinkAsset();
			_ef.mouseEnabled = false;
			_ef.mouseChildren = false;
			_ef.x = 514-20;
			_ef.y = 247-20;
			_ef.scaleX = _ef.scaleY = 1.2;
			addChild(_ef);
			
			_cellList = [];
			_tile = new MTile(50,50,4);
			_tile.setSize(210,105);
			_tile.move(391,258);
			_tile.itemGapW = 2;
			_tile.itemGapH = 3;
			_tile.horizontalScrollPolicy = _tile.verticalScrollPolicy = ScrollPolicy.OFF;
//			addChild(_tile);
			
			_cellPos = [null,new Point(390,257),new Point(428,257),new Point(466,257),new Point(574,257),new Point(612,257),new Point(650,257)];
			
			_btnRec = new MAssetButton1(new BtnPayAsset() as MovieClip);
			_btnRec.move(477,318);
			addChild(_btnRec);
			
			_btnGet = new MAssetButton1(new BtnGetAsset() as MovieClip);
			_btnGet.move(477,318);
			addChild(_btnGet);
			_btnGet.visible = false;
			
			setTemplateListData();
		}
		
		/**
		 * 设置模板数据
		 */		
		private function setTemplateListData():void
		{
			opAct = OpenActivityUtils.getActivityArray(_type);
			var opActObj:OpenActivityTemplateListInfo = opAct[0];
			var bigItem:ItemTemplateInfo = ItemTemplateList.getTemplate(opActObj.item);
			
			//首冲 送的礼包 
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = bigItem.templateId;
//			_bigCell.itemInfo = itemInfo;
			
			var i:int = 0
			var itemArray:Array = []; //物品模板id数组
			var itemNumArray:Array = []; //物品数量数组
			var scriptArray:Array = bigItem.script.split("|"); 
			var scriptStr:String = "";
			var scriptStrArray:Array = [];
			for(;i<scriptArray.length;i++)
			{
				scriptStrArray = scriptArray[i].toString().split(",");
				if(scriptStrArray.length >= 6)
				{
					itemArray.push(scriptStrArray[2]);
					itemNumArray.push(scriptStrArray[3]);
				}
			}
			_bigCell.itemInfo = getItem(ItemTemplateList.getTemplate(itemArray[0]));
			i = 1; 
			for(; i<itemArray.length; i++)
			{
				bigItem = ItemTemplateList.getTemplate(itemArray[i]);
				var item:FirstRechargeItemView = new FirstRechargeItemView(bigItem,itemNumArray[i]);
				_tile.appendItem(item);
				_cellList.push(item);
				
				var item2:Cell = new Cell();
				item2.move(_cellPos[i].x,_cellPos[i].y);
				item2.setItemInfo(getItem(bigItem),itemNumArray[i]);
				addChild(item2);
			}
		}
		private function getItem(item:ItemTemplateInfo):ItemInfo
		{
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = item.templateId;
			return itemInfo;
		}
		private function initEvent():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_btnRec.addEventListener(MouseEvent.CLICK,toFirstRec);
		}
		private function removeEvent():void
		{
			_dragArea.addEventListener(MouseEvent.MOUSE_DOWN,dragDownHandler);
			_dragArea.addEventListener(MouseEvent.MOUSE_UP,dragUpHandler);
			_btnClose.addEventListener(MouseEvent.CLICK,closeClickHandler);
			
			_btnRec.removeEventListener(MouseEvent.CLICK,toFirstRec);
		}
		
		private function initData():void
		{
			
		}
		
		private function toFirstRec(evt:MouseEvent):void
		{
			JSUtils.gotoFill();
		}
		private function dragDownHandler(evt:MouseEvent):void
		{
			startDrag(false,new Rectangle(0,0,parent.stage.stageWidth - this.width,parent.stage.stageHeight - this.height));
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
		
		private function setPanelPosition(e:Event):void
		{
			move( Math.round(CommonConfig.GAME_WIDTH - DEFAULT_WIDTH >> 1), Math.round(CommonConfig.GAME_HEIGHT - DEFAULT_HEIGHT >> 1));
		}
		
		override public function dispose():void
		{
			if(_bg && _bg.bitmapData)
			{
				_bg.bitmapData.dispose();
				_bg = null;
			}
			if(_btnClose)
			{
				_btnClose.dispose();
				_btnClose = null;
			}
			if(_ef && _ef.parent)
			{
				_ef.parent.removeChild(_ef);
				_ef = null;
			}
			if(_btnRec)
			{
				_btnRec.dispose();
				_btnRec = null;
			}
			if(_btnGet)
			{
				_btnGet.dispose();
				_btnGet = null;
			}
			if(_bigCell)
			{
				_bigCell.dispose();
				_bigCell = null;
			}
			_cellList = null;
			_tile = null;
			_dragArea = null;
			super.dispose();
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function assetsCompleteHandler():void
		{
			_bg.bitmapData = AssetUtil.getAsset("ssztui.firstPay.bgAsset",BitmapData) as BitmapData;
		}
	}
}