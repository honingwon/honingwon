package sszt.core.view.quickBuy
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	public class BuyPanel extends MPanel
	{
		private static var instance:BuyPanel;
		private var _bg:IMovieWrapper;
//		private var _itemList:Vector.<BuyItemView>;
		private var _itemList:Array;
		private var _itemTile:MTile;
		public function BuyPanel()
		{
			var title:Bitmap;
			if(GlobalData.domain.hasDefinition("ssztui.common.BuyTitleAsset"))
			{
				title = new Bitmap(new (GlobalData.domain.getDefinition("ssztui.common.BuyTitleAsset") as Class)());
			}
			super(new MCacheTitle1("",title),true,-1);
		}
		
		public static function getInstance():BuyPanel
		{
			if(instance == null)
			{
				instance = new BuyPanel();
			}
			return instance;
		}
		
		public function show(idList:Array,data:ToStoreData):void
		{
			clearData();
			init(idList,data.type);
			GlobalAPI.layerManager.addPanel(this);
		}
		
		public function init(idList:Array,type:int):void
		{
			var nlen:int = idList.length*88 + 30;
			setContentSize(266,nlen);
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(8,2,250,nlen-10)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(12,6,242,nlen-18)),
			]);
			addContent(_bg as DisplayObject);
			
			
			_itemTile = new MTile(230,87,1);
			_itemTile.move(18,12);
			_itemTile.itemGapH = 1;
			_itemTile.horizontalScrollPolicy = _itemTile.verticalScrollPolicy = ScrollPolicy.OFF;
			addContent(_itemTile);
			
			_itemList = [];
			for(var i:int = 0;i<idList.length;i++)
			{
				var item:BuyItemView = new BuyItemView(idList[i],type);
//				item.move(18,12+i*88);
//				addContent(item);
				_itemTile.appendItem(item);
				_itemList.push(item);
			}
			_itemTile.setSize(230,12+idList.length*88);
		}
		
		private function clearData():void
		{
			if(_itemTile)
			{
				_itemTile.disposeItems();
			}
			_itemList = [];
			_itemTile = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
		}
		
		override public function dispose():void
		{
			clearData();
			_itemTile = null;
			_itemList = null;
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