package sszt.scene.socketHandlers.guildPVP
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.ui.mcache.cells.CellCaches;
	
	public class RewardCell extends BaseItemInfoCell
	{
		private var _countLabel:TextField;
		private var _ef:MovieClip;
		
		public function RewardCell()
		{
			super();
			var _bg:Bitmap = new Bitmap(CellCaches.getCellBg());
			addChild(_bg);
			
			_ef = MovieCaches.getCellBlinkAsset();
			_ef.mouseEnabled = false;
			_ef.mouseChildren = false;
			_ef.x = -19;
			_ef.y = -18;
			addChild(_ef);
			_ef.visible = false;
			
			_countLabel = new TextField();
			var t:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.RIGHT);
			_countLabel.defaultTextFormat = t;
			_countLabel.setTextFormat(t);
			_countLabel.x = 4;
			_countLabel.y = 22;
			_countLabel.width = 33;
			_countLabel.height = 14;
			_countLabel.mouseEnabled = _countLabel.mouseWheelEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
		}
		
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			
			if(itemInfo)
			{
				_countLabel.text = String(itemInfo.count>1?itemInfo.count:"");
			}
			else 
			{
				if(_countLabel && _countLabel.parent && _countLabel.parent.contains(_countLabel))
				{
					removeChild(_countLabel);
				}
			}
		}
		public function setEffect(value:Boolean):void
		{
			_ef.visible = value;
		}
		
		//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
			
			setChildIndex(_ef,numChildren-1);
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,32,32);
		}
		
//		override protected function showTipHandler(evt:MouseEvent):void
//		{
//			if(info)TipsUtil.getInstance().show(itemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
//		}
//		
//		override protected function hideTipHandler(evt:MouseEvent):void
//		{
//			if(info)TipsUtil.getInstance().hide();
//		}
		
		//		override public function dragDrop(data:IDragData):int
		//		{
		//			return 0;
		//		}
		override public function dispose():void
		{
			if(_ef && _ef.parent)
			{
				_ef.parent.removeChild(_ef);
				_ef = null;
			}
			super.dispose();
		}
	}
}