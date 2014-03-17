package sszt.mergeServer.components
{
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
	import sszt.core.data.module.changeInfos.ToStoreData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.utils.SetModuleUtils;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.activity.IconStarAsset;
	import ssztui.midAutmn.moonCakeIconAsset;
	
	public class ExchangeView extends Sprite
	{
		private var _bg:IMovieWrapper;
		
		private var _txtTitle:MAssetLabel;
		private var _txtTime:MAssetLabel;
		private var _txtDetail:MAssetLabel;
		private var _btnExchange:MCacheAssetBtn1;
		
		private var _colWidth:Array = [78,36,36,36,36,61,61,61]; 
		private var _tempData1:Array = [null,6,6,2,15,15,20,20];
		private var _tempData2:Array = [null,"蚕丝","神木","精铁","玄铁","99朵玫瑰","6格背包","6格仓库"];
		private var _table:MSprite;
		private var _txtTotal:MAssetLabel;
		
		private var _exchangePanel:ExchangePanel;
		
		public function ExchangeView()
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
				_table.graphics.lineTo(cx+_colWidth[i],66);
				_table.graphics.lineTo(cx,66);
				_table.graphics.lineTo(cx,0);
				
				var label:MAssetLabel = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
				label.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,21)]);
				label.move(cx,9);
				label.setSize(_colWidth[i],60);
				if(i==0)
				{
					label.textColor = 0xd9ad60;
					label.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.moonCakeCount") + "\n" + LanguageManager.getWord("ssztl.midAutumnActivity.moonCakeExchange"));
				}else
				{
					label.setHtmlValue(_tempData1[i] + "\n" + _tempData2[i]);
				}
				_table.addChild(label);
				
				cx += _colWidth[i];
			}
			_table.graphics.moveTo(0,33);
			_table.graphics.lineTo(cx,33);
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
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(99,260,18,18),new Bitmap(new moonCakeIconAsset())),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(18,261,60,15),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.moonCakeTotal"),MAssetLabel.LABEL_TYPE_TAG,"left")),
				
				new BackgroundInfo(BackgroundType.DISPLAY, new Rectangle(18,298,404,30),new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.exchangeDetail"),MAssetLabel.LABEL_TYPE_TAG,"left")),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTitle = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtTitle.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType3"),20,0xffcc00,true)]);
			_txtTitle.move(211,10);
			addChild(_txtTitle);
			_txtTitle.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acName2"));
			
			_txtTime = new MAssetLabel(LanguageManager.getWord("ssztl.midAutumnActivity.endTime"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtTime.move(79,42);
			addChild(_txtTime);
			
			_txtDetail = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtDetail.wordWrap = true;
			_txtDetail.setLabelType([new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtDetail.setSize(322,68);
			_txtDetail.move(79,86);
			addChild(_txtDetail);
			_txtDetail.setHtmlValue(LanguageManager.getWord("ssztl.midAutumnActivity.acDetail2"));
			
			_txtTotal = new MAssetLabel("0",MAssetLabel.LABEL_TYPE20,"left");
			_txtTotal.move(117,261);
			addChild(_txtTotal);
			
			_btnExchange = new MCacheAssetBtn1(0,3,LanguageManager.getWord("ssztl.scene.exchange"));
			_btnExchange.move(181,256);
			addChild(_btnExchange);
			
			_txtTotal.setHtmlValue( GlobalData.bagInfo.getItemCountByItemplateId(300000).toString());
		}
		
		private function bagInfoUpdateHandler(evt:BagInfoUpdateEvent):void
		{
			_txtTotal.setHtmlValue( GlobalData.bagInfo.getItemCountByItemplateId(300000).toString());
		}
		public function initEvent():void
		{
			_btnExchange.addEventListener(MouseEvent.CLICK,btnClickHandler);
			GlobalData.bagInfo.addEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
		}
		public function removeEvent():void
		{
			_btnExchange.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			GlobalData.bagInfo.removeEventListener(BagInfoUpdateEvent.ITEM_UPDATE,bagInfoUpdateHandler);
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
			_btnExchange = null;
			if(_table && _table.parent)
			{
				_table.parent.removeChild(_table);
				_table = null;
			}
		}
		
	}
}