package sszt.club.components.clubMain.pop.store
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.club.socketHandlers.ClubStoreGetSocketHandler;
	import sszt.club.socketHandlers.ClubStorePutSocketHandler;
	import sszt.constData.DragActionType;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.interfaces.loader.ILoader;
	import sszt.ui.container.MAlert;
	
	public class ClubStoreCell extends BaseItemInfoCell implements IAcceptDrag
	{
		private var _selected:Boolean;
		private var _selectedBg:Shape;
		private var _count:TextField;
		private var _clickPoint:Point;
		private var _over:Bitmap;
		
		public function ClubStoreCell()
		{
			super();
			mouseEnabled = mouseChildren = false;
			this.initEvent();
			
			_over = new Bitmap(AssetUtil.getAsset("ssztui.scene.SkillBarCellOverAsset") as BitmapData);
			_over.visible = false;
			addChild(_over);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			this.addEventListener(MouseEvent.CLICK, clickHandler1);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			this.removeEventListener(MouseEvent.CLICK, clickHandler1);
		}
		
		private function clickHandler1(event:MouseEvent):void
		{
			_clickPoint = new Point(event.stageX, event.stageY);
			ClubStoreAppliedItemPopup.getInstance().show(this as IDragable, _clickPoint);
		}
		
		override public function set itemInfo(value:ItemInfo):void
		{
			super.itemInfo = value;
			if(value)
			{
				mouseEnabled = mouseChildren = true;
				if(_count == null)
				{
					_count = new TextField();
					_count.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.RIGHT);
					_count.filters = [new GlowFilter(0x000000,1,2,2,10)];
					_count.mouseEnabled = _count.mouseWheelEnabled = false;
					_count.maxChars = 2;
					_count.x = 4;
					_count.y = 22;
					_count.width = 33;
					_count.height = 15;
					addChild(_count);
				}
				_count.text = String(_iteminfo.count>1?_iteminfo.count:"");
			}
			else
			{
				if(_count)_count.text = "";
				mouseEnabled = mouseChildren = false;
			}
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			if(_count)setChildIndex(_count,numChildren - 1);
			setChildIndex(_over,numChildren-1);
		}
		
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,32,32);
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected == value)return;
			_selected = value;
			if(_selected)
			{
				_selectedBg = new Shape();
				_selectedBg.graphics.lineStyle(2,0xFFFFFF,1);
				_selectedBg.graphics.drawRoundRect(0,0,38,38,8,8);
				_selectedBg.graphics.endFill();
				addChildAt(_selectedBg,0);
				_selectedBg.visible = false;
			}
			else
			{
				if(_selectedBg && _selectedBg.parent)
				{
					_selectedBg.parent.removeChild(_selectedBg);
					_selectedBg = null;
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		public function set over(value:Boolean):void
		{
			_over.visible = value;
		}
		override public function dispose():void
		{
			super.dispose();
			this.removeEvent();
			
			if(_clickPoint)
			{
				_clickPoint = null;
			}
		}
	}
}