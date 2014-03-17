package sszt.mergeServer.components
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.ShopID;
	import sszt.core.data.GlobalData;
	import sszt.core.data.bag.BagInfoUpdateEvent;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mergeServer.components.item.Cell;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.IconStarAsset;
	import ssztui.midAutmn.moonCakeIconAsset;
	
	public class BossFlopView extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _txtTitle:MAssetLabel;
		private var _txtTime:MAssetLabel;
		private var _txtDetail:MAssetLabel;
		
		private var _colWidth:Array = [115,290]; 
		private var _table:MSprite;
		
		private var _tile1:MTile;
		private var _tile2:MTile;
		private var _bossId:Array = [300000,203016,203019,201001,201002,201027,201028,203012,204003,250001];
		private var _mononsterId:Array = [300000,203016,203019,201001,201027,203011];
		
		public function BossFlopView()
		{
			initView();
			initEvent();
		}
		public function initView():void
		{
			_table = new MSprite();
			_table.move(9,179);
			_table.graphics.lineStyle(1,0x4e2c0e);
			var cx:int = 0;
			for(var i:int =0; i<_colWidth.length; i++)
			{
				_table.graphics.moveTo(cx,0);
				_table.graphics.lineTo(cx+_colWidth[i],0);
				_table.graphics.lineTo(cx+_colWidth[i],150);
				_table.graphics.lineTo(cx,150);
				_table.graphics.lineTo(cx,0);
				
				var label:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
				label.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,62)]);
				label.move(cx,40);
				label.setSize(_colWidth[i],100);
				if(i==0)
				{
					label.textColor = 0xd9ad60;
					label.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.FlopTag2") + "\n" + LanguageManager.getWord("ssztl.midAutumnActivity.FlopTag1"));
				}else
				{
				}
				_table.addChild(label);
				
				cx += _colWidth[i];
			}
			_table.graphics.moveTo(0,94);
			_table.graphics.lineTo(cx,94);
			_table.graphics.endFill();
			addChild(_table)
			
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,42,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.activity.activityTime")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,64,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.rewardLevel")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(19,86,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.scene.activityDescription")+"：",MAssetLabel.LABEL_TYPE20,"left")),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(80,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(95,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(110,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(125,64,15,15),new Bitmap(new IconStarAsset())),
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(140,64,15,15),new Bitmap(new IconStarAsset())),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtTitle.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),20,0xffcc00,true)]);
			_txtTitle.move(211,10);
			addChild(_txtTitle);
			_txtTitle.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acName4"));
			
			_txtTime = new MAssetLabel("截止12月27日24:00",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTime.move(79,42);
			addChild(_txtTime);
			
			_txtDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDetail.wordWrap = true;
			_txtDetail.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtDetail.setSize(322,68);
			_txtDetail.move(79,86);
			addChild(_txtDetail);
			_txtDetail.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acDetail4"));
			
			_tile1 = new MTile(38,38,7);
			_tile1.setSize(275,80);
			_tile1.move(122,9);
			_tile1.itemGapW = _tile1.itemGapH = 1;
			_tile1.horizontalScrollPolicy = _tile1.verticalScrollPolicy = ScrollPolicy.OFF;
			_table.addChild(_tile1);
			
			_tile2 = new MTile(38,38,7);
			_tile2.setSize(275,38);
			_tile2.move(122,103);
			_tile2.itemGapW = 1;
			_tile2.horizontalScrollPolicy = _tile2.verticalScrollPolicy = ScrollPolicy.OFF;
			_table.addChild(_tile2);
			
			setData();
		}
		private function setData():void
		{
			var bigItem:ItemTemplateInfo;
			var cell:Cell;
			
			for(var i:int=0; i<_bossId.length; i++)
			{
				bigItem = ItemTemplateList.getTemplate(_bossId[i]);
				
				cell = new Cell();
				cell.itemInfo = getItem(bigItem);
				_tile1.appendItem(cell);
			}
			for(i=0; i<_mononsterId.length; i++)
			{
				bigItem = ItemTemplateList.getTemplate(_mononsterId[i]);
				
				cell = new Cell();
				cell.itemInfo = getItem(bigItem);
				_tile2.appendItem(cell);
			}
		}
		private function getItem(item:ItemTemplateInfo):ItemInfo
		{
			var itemInfo:ItemInfo = new ItemInfo();
			itemInfo.templateId = item.templateId;
			return itemInfo;
		}
		public function initEvent():void
		{
		}
		public function removeEvent():void
		{
		}
		private function btnClickHandler(e:MouseEvent):void
		{
			SetModuleUtils.addExStore(new ToStoreData(ShopID.MOONCAKE,3)); 
			//			if(!_exchangePanel)
			//			{
			//				_exchangePanel = new ExchangePanel();
			//				_exchangePanel.move(2,2);
			//				_exchangePanel.assetsCompleteHandler();
			//			}
			//			addChild(_exchangePanel);
		}
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		public function assetsCompleteHandler():void
		{
			//			if(_exchangePanel)
			//			{
			//				_exchangePanel.assetsCompleteHandler();
			//			}
		}
		
		public function show():void
		{
			
		}
		
		public function hide():void
		{
			this.parent.removeChild(this);
		}
		
		public function dispose():void
		{
			removeEvent();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_txtTitle = null;
			_txtTime = null;
			_txtDetail = null;
			if(_table && _table.parent)
			{
				_table.parent.removeChild(_table);
				_table = null;
			}
		}
		
	}
}