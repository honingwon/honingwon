package sszt.core.view.betterEquip 
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import sszt.constData.CommonBagType;
	import sszt.constData.CommonConfig;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.bag.ItemMoveSocketHandler;
	import sszt.core.utils.AssetUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.interfaces.layer.IPanel;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.module.ModuleEventDispatcher;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MPanel3;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.ui.BtnAssetClose;
	import ssztui.ui.SplitCompartLine2;
	
	public class BetterEquipPanel extends MPanel
	{
		
		private static var _instance:BetterEquipPanel;
		
		private var _bg:IMovieWrapper;
		private var _btn:MCacheAssetBtn1;
		private var _tile:MTile;
		private var _list:Array;
		private var _infoList:Array;
		private var _timeoutIndex:int = -1;
		
		public static const DEFAULT_WIDTH:int = 235;
		public static const DEFAULT_HEIGHT:int = 270;
		
		public function BetterEquipPanel()
		{
			var imageBtmp:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.GetEquipTitleImgAsset"))
				imageBtmp = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.GetEquipTitleImgAsset") as Class)());
			super(new MCacheTitle1("",imageBtmp),true,-1,true,false);
			
		}
		public static function getInstance():BetterEquipPanel{
			if (_instance == null){
				_instance = new (BetterEquipPanel)();
			};
			return (_instance);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(DEFAULT_WIDTH,DEFAULT_HEIGHT);
			setPanelPosition(null);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(10,4,DEFAULT_WIDTH-20,210)),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(10, 213, DEFAULT_WIDTH-20, 25), new MCacheCompartLine2()),
				
			]);
			addContent(_bg as DisplayObject);
			
			this._list = [];
			this._tile = new MTile(192,51);
			this._tile.setSize(209, 204);
			this._tile.move(14, 8);
			addContent(this._tile);
			this._tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			this._tile.verticalScrollPolicy = ScrollPolicy.ON;
			this._tile.verticalLineScrollSize = 51;
			this._tile.itemGapH = 0;
			
			this._btn = new MCacheAssetBtn1(2,0, LanguageManager.getWord("ssztl.common.equipAllLabel"));
			this._btn.move(68,225);
			addContent(this._btn);
			
			this.initEvent();
		}
		public function show(info:Array):void{
			this._infoList = info;
			if (!(parent)){
				GlobalAPI.layerManager.addPanel(this);
				this.initData();
			};
		}
		private function initData():void{
			var i:ItemInfo;
			var itemView:BetterItemView;
			var item:BetterItemView;
			if (((this._list) && ((this._list.length > 0)))){
				for each (itemView in this._list) {
					itemView.removeEventListener(Event.CLOSE, this.itemCloseHandler);
					this._tile.removeItem(itemView);
					itemView.dispose();
				};
			};
			this._list = [];
			for each (i in this._infoList) {
				item = new BetterItemView(i);
				item.addEventListener(Event.CLOSE, this.itemCloseHandler);
				this._tile.appendItem(item);
				this._list.push(item);
			};
		}
		private function itemCloseHandler(evt:Event):void{
			var itemView:BetterItemView = (evt.currentTarget as BetterItemView);
			itemView.removeEventListener(Event.CLOSE, this.itemCloseHandler);
			this._tile.removeItem(itemView);
			var index:int = this._list.indexOf(itemView);
			this._list.splice(index, 1);
			itemView.dispose();
			if (this._list.length == 0){
				this.dispose();
			};
		}
		private function initEvent():void{
			this._btn.addEventListener(MouseEvent.CLICK, this.clickHandler);
			ModuleEventDispatcher.addCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		private function removeEvent():void{
			this._btn.removeEventListener(MouseEvent.CLICK, this.clickHandler);
			
			ModuleEventDispatcher.removeCommonModuleEventListener(CommonModuleEvent.GAME_SIZE_CHANGE,setPanelPosition);
		}
		private function clickHandler(evt:MouseEvent):void{
			var i:BetterItemView;
			var closeHandler:Function;
			var evt:MouseEvent = evt;
			closeHandler = function ():void{
				if (_timeoutIndex != -1){
					clearTimeout(_timeoutIndex);
				};
				dispose();
			};
//			if (GlobalData.securityType == SecurityType.LOCKED){
//				SecurityUnlockPanel.show();
//				return;
//			};
//			if (GlobalData.selfPlayer.isShapeShifting){
//				QuickTips.show(LanguageManager.getWord("mhsm.common.shapeShiftCannotEquip"));
//				return;
//			};
			for each (i in this._list) {
				if (((i) && (i.itemInfo))){
					ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG, i.itemInfo.place, CommonBagType.BAG, 29, 1);
				};
			};
			this.visible = false;
			if (this._timeoutIndex != -1){
				clearTimeout(this._timeoutIndex);
			};
			this._timeoutIndex = setTimeout(closeHandler, 800);
		}
		
		private function setPanelPosition(e:Event):void
		{
			this.move(CommonConfig.GAME_WIDTH / 2 + 275, CommonConfig.GAME_HEIGHT / 2 - 200);
		}
		
		override protected function closeClickHandler(evt:MouseEvent):void
		{
			this.autoEquipBlue();
			super.dispose();
		}
		
		private function autoEquipBlue():void
		{
			var closeHandler:Function;
			var i:BetterItemView;
			closeHandler = function ():void{
				if (_timeoutIndex != -1){
					clearTimeout(_timeoutIndex);
				};
				dispose();
			};
//			if (!(GlobalData.selfPlayer.isShapeShifting)){
				for each (i in this._list) {
					if (((((i) && (i.itemInfo))) && ((i.itemInfo.template.quality == 2)))){
						ItemMoveSocketHandler.sendItemMove(CommonBagType.BAG, i.itemInfo.place, CommonBagType.BAG, 29, 1);
					};
				};
//			};
			this.visible = false;
			if (this._timeoutIndex != -1){
				clearTimeout(this._timeoutIndex);
			};
			this._timeoutIndex = setTimeout(closeHandler, 800);
		}
		
		override public function dispose():void{
			var i:int;
			this.removeEvent();
			_instance = null;
			if (this._btn){
				this._btn.dispose();
				this._btn = null;
			};
			if (this._tile){
				this._tile.dispose();
				this._tile = null;
			};
			this._infoList = null;
			if (this._list){
				i = 0;
				while (i < this._list.length) {
					this._list[i].removeEventListener(Event.CLOSE, this.itemCloseHandler);
					this._list[i].dispose();
					i++;
				};
				this._list = null;
			};
			super.dispose();
		}
		
	}
}
