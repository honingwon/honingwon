package sszt.common.vip.component.sec
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.common.vip.component.cell.Vip3ItemCell;
	import sszt.constData.VipType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.vip.VipTemplateInfo;
	import sszt.core.data.vip.VipTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MScrollPanel;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.vip.BoxBgAsset;
	
	public class VipCard1 extends MSprite
	{
		private var _bg:IMovieWrapper;
		private var _txtPrivilege:MAssetLabel;
		private var _tile:MTile;
		private var _list:Array;
		private var _sp:MScrollPanel;
		private var _txtTag1:MAssetLabel;
		private var _txtTag2:MAssetLabel;
		private var _txtTag:MAssetLabel;
		
		public function VipCard1()
		{
			super();
			
			
			initView();
		}
		
		private function initView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(	BackgroundType.DISPLAY, new Rectangle(9,103,328,170), new BoxBgAsset() as MovieClip),
			]);
			addChild(_bg as DisplayObject);
			
			_txtTag = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_txtTag.setLabelType([new TextFormat("Microsoft Yahei Font",14,0xcc00ff,true)]);
			_txtTag.move(164,8);
			addChild(_txtTag); 
			_txtTag.setValue(LanguageManager.getWord("ssztl.basic.superVipPlayer"));
			
			_sp = new MScrollPanel();
			_sp.setSize(320,162);
			_sp.move(13,107);
			_sp.verticalScrollPolicy = ScrollPolicy.AUTO;
			addChild(_sp); 
				
//			_sp.getContainer().
//			getContainer().height += _bg.height;
			_txtTag2 = new MAssetLabel("", MAssetLabel.LABEL_TYPE20,'left');
			_txtTag2.move(5,4);
			_sp.getContainer().addChild(_txtTag2);
			_txtTag2.setHtmlValue(LanguageManager.getWord('ssztl.vip.otherGiftTitle'));
			_sp.getContainer().height += _txtTag2.height;
			
			_txtPrivilege = new MAssetLabel('', MAssetLabel.LABEL_TYPE20,'left');
			_txtPrivilege.setLabelType([new TextFormat("SimSun",12,0xfffccc,null,null,null,null,null,null,null,null,null,6)]);
			_txtPrivilege.move(5,22);
			_sp.getContainer().addChild(_txtPrivilege);
			_txtPrivilege.setHtmlValue(LanguageManager.getWord('ssztl.common.superVipDescript'));
			_sp.getContainer().height += _txtPrivilege.height+5;
			
			_sp.update(-1,_sp.getContainer().height);
			
			_txtTag1 = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TAG,'left');
			_txtTag1.move(14,38);
			addChild(_txtTag1);
			_txtTag1.setHtmlValue(LanguageManager.getWord('ssztl.vip.superTitle'));
			
			_tile = new MTile(38,38,8);			
			_tile.verticalScrollPolicy = _tile.horizontalScrollPolicy = ScrollPolicy.OFF;
			_tile.itemGapH = _tile.itemGapW = 1;
			
			_list = [];
			var vipTemplateInfo:VipTemplateInfo = VipTemplateList.getVipTemplateInfo(VipType.BESTVIP)
			var len:int = vipTemplateInfo.items.length;
			var items:Array = vipTemplateInfo.items;
			var itemsCount:Array = vipTemplateInfo.itemsCount;
			var vipItemCell:Vip3ItemCell;
			var itemInfo:ItemInfo;
			
			_tile.setSize(38*len+1*(len-1),38);
			_tile.move(Math.round((346-_tile.width)/2),60);
			
			for(var i:int = 0; i < len; i++)
			{
				vipItemCell = new Vip3ItemCell();
				itemInfo =new ItemInfo();
				itemInfo.templateId = items[i];
				itemInfo.count = itemsCount[i];
				vipItemCell.itemInfo = itemInfo;
				_tile.appendItem(vipItemCell);
				_list.push(vipItemCell);
				addChild(MBackgroundLabel.getDisplayObject(new Rectangle(_tile.x + 39*i,60,38, 38), new Bitmap(CellCaches.getCellBg())));
				
			}
			addChild(_tile);
			
		}
		
		public function hide():void
		{
			if(parent) parent.removeChild(this);
		}
		
		override public function dispose():void
		{
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_txtPrivilege)
			{
				_txtPrivilege = null;
			}
			if(_tile)
			{
				_tile.disposeItems();
				_tile.dispose();
				_tile = null;
			}
			if(_sp)
			{
				_sp.dispose();
				_sp = null;
			}
			_txtTag = null;
			_txtTag1 = null;
			_txtTag2 = null;
			_list = null;
		}
	}
}