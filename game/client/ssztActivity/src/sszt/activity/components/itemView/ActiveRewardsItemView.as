package sszt.activity.components.itemView
{
	import fl.controls.ScrollPolicy;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.activity.components.cell.AwardCell;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.activity.ActiveRewardsTemplateInfo;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MSprite;
	import sszt.ui.container.MTile;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import ssztui.activity.ActiveGiftIconAsset;
	import ssztui.activity.PngCanGetAsset;
	import ssztui.activity.PngGotAsset;
	
	public class ActiveRewardsItemView extends Sprite
	{
		private var _rewardsInfo:ActiveRewardsTemplateInfo;
		private var _bg:IMovieWrapper;
		private var _bgGot:Bitmap;
		private var _activeNumLabel:MAssetLabel;
		private var _itemsTile:MTile;
		private var _expLabel:MAssetLabel;
		private var _yuanbaoLabel:MAssetLabel;
		private var _got:Boolean;
		private var _icon:MSprite;
		private var _ef:MovieClip;
		
		public function ActiveRewardsItemView(argInfo:ActiveRewardsTemplateInfo)
		{
			super();
			_rewardsInfo = argInfo;
			initialView();
		}
		
		public function get rewardsInfo():ActiveRewardsTemplateInfo
		{
			return _rewardsInfo;
		}
		
		private function initialView():void
		{
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,17,38,38),new Bitmap(CellCaches.getCellBg())),
			]);
			addChild(_bg as DisplayObject);
			
			_icon = new MSprite(); 
			_icon.move(3,20);
			addChild(_icon);
			_icon.addChild(new Bitmap(new ActiveGiftIconAsset()));
			setIcon(false);
			_icon.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_icon.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
				
			_activeNumLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE20);
			_activeNumLabel.move(18,0);
			addChild(_activeNumLabel);
			_activeNumLabel.setHtmlValue(_rewardsInfo.needActive.toString());
			
			_expLabel = new MAssetLabel('+' + _rewardsInfo.exp.toString(), MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_expLabel.move(32,22);
//			addChild(_expLabel);
			
			_yuanbaoLabel = new MAssetLabel('+' + _rewardsInfo.bindYuanbao.toString(), MAssetLabel.LABEL_TYPE7,TextFormatAlign.LEFT);
			_yuanbaoLabel.move(140,22);
//			addChild(_yuanbaoLabel);
			
			_itemsTile = new MTile(38, 38, 2);
			_itemsTile.itemGapH = 0;
			_itemsTile.itemGapW = 4;
			_itemsTile.setSize(80, 38);
			_itemsTile.move(8, 41);
//			addChild(_itemsTile);
			_itemsTile.horizontalScrollPolicy = _itemsTile.verticalScrollPolicy = ScrollPolicy.OFF;
			
			var len:int = _rewardsInfo.items.length;
			var items:Array = _rewardsInfo.items;
			var itemsCount:Array = _rewardsInfo.itemsCount;
			var cell:AwardCell;
			var itemInfo:ItemInfo;
			for(var i:int = 0; i < len; i++)
			{
				cell = new AwardCell();
				itemInfo =new ItemInfo();
				itemInfo.templateId = items[i];
				itemInfo.count = itemsCount[i];
				cell.itemInfo = itemInfo;
				_itemsTile.appendItem(cell);
			}
			
			_bgGot = new Bitmap(new PngGotAsset(),"auto",true);
			_bgGot.scaleX = _bgGot.scaleY = 0.7;
			addChild(_bgGot);
			_bgGot.visible = false;
			_bgGot.x = 0;
			_bgGot.y = 33;
			
			move((_rewardsInfo.needActive/10)*40-18,0);
		}
		private function overHandler(e:MouseEvent):void
		{
			var str:String = LanguageManager.getWord("ssztl.activity.OpenObtain") + "\n";
			str += "<font color='#78eb1c'>";
			if(_rewardsInfo.exp != 0) 
			{
				str += LanguageManager.getWord("ssztl.swordsMan.expValue") + _rewardsInfo.exp.toString() + "\n";
			}
			if(_rewardsInfo.bindYuanbao != 0)
			{
				str += LanguageManager.getWord("ssztl.common.bindYuanBao2")+"+" + _rewardsInfo.bindYuanbao.toString() + "\n";
			}
			var items:Array = _rewardsInfo.items;
			var itemsCount:Array = _rewardsInfo.itemsCount;
			for(var i:int = 0; i <items.length; i++)
			{
				
				str += ItemTemplateList.getTemplate(items[i]).name + "×" + itemsCount[i] + "\n";
			}
			str += "</font>";
			TipsUtil.getInstance().show(str,null,new Rectangle(e.stageX,e.stageY,0,0));
		}
		private function outHandler(e:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function set canGet(value:Boolean):void
		{
			setIcon(value);
			if(value)
			{
				if(_ef == null)
				{
					_ef = MovieCaches.getCellBlinkAsset();
					_ef.mouseEnabled = _ef.mouseChildren = false;
					_ef.x = -18;
					_ef.y = 0;
					addChild(_ef);
					_ef.blendMode = BlendMode.ADD;
				}
			}else
			{
				if(_ef && _ef.parent)
				{
					_ef.parent.removeChild(_ef);
					_ef = null;
				}
			}
		}
		
		public function set got(value:Boolean):void
		{
			_bgGot.visible = _got = value;
			setIcon(!value);
		}
		
		public function get got():Boolean
		{
			return _got;
		}
		private function setIcon(value:Boolean):void
		{
			if(value)
				_icon.filters = [];
			else
				_icon.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			_icon.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			_icon.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
			 _rewardsInfo = null;
			 if(_itemsTile)
			 {
				 _itemsTile.disposeItems();
				 _itemsTile.dispose();
				 _itemsTile = null;
			 }
			 if(_bg)
			 {
				 _bg.dispose();
				 _bg = null;
			 }
			 _icon = null;
			 _activeNumLabel = null;
			 _expLabel = null;
			 _yuanbaoLabel = null;
		}
	}
}