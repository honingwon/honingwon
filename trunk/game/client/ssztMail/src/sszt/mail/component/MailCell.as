package sszt.mail.component
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.constData.DragActionType;
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.core.view.cell.CellType;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.interfaces.drag.IAcceptDrag;
	import sszt.interfaces.drag.IDragData;
	import sszt.interfaces.drag.IDragable;
	import sszt.interfaces.loader.IDisplayFileInfo;
	import sszt.ui.container.MAlert;
	
	public class MailCell extends BaseCell implements IAcceptDrag
	{
		public var _itemInfo:ItemInfo;
		private var _type:int;           //0读取邮件格子，1写邮件格子,2列表格子
		private var _place:int;
		private var _countLabel:TextField;
		
		public function MailCell(type:int,place:int)
		{
			_type = type;
			_place = place;
			_itemInfo = null;
			super();
			
			_countLabel = new TextField();
			_countLabel.defaultTextFormat = new TextFormat("SimSun",12,0xffffff);
			//_countLabel.textColor = 0xffffff;
			_countLabel.autoSize = TextFormatAlign.RIGHT;
			_countLabel.x = 4;
			_countLabel.y = 22;
			_countLabel.width = 33;
			_countLabel.height = 15;
			_countLabel.mouseEnabled = _countLabel.mouseWheelEnabled = false;
			_countLabel.filters = [new GlowFilter(0x000000,1,2,2,10)];
		}
		
		public function get place():int
		{
			return _place;
		}
		
		public function get itemInfo():ItemInfo
		{
			return _itemInfo
		}
		
		public function set itemInfo(item:ItemInfo):void
		{
			if(_itemInfo == item) return;
			_itemInfo = item;
			if(_itemInfo)
			{
				info = _itemInfo.template;
				if(CategoryType.isEquip(_itemInfo.template.categoryId))
				{
					if(_itemInfo.strengthenLevel > 0)
						_countLabel.text = "+" + String(_itemInfo.strengthenLevel);
					else
						_countLabel.text = "";
				}
				else
				{
					_countLabel.text = String(_itemInfo.count>1?_itemInfo.count:"");
				}
			}else
			{
				info = null;
				_countLabel.text = "";
			}
		}
		
//		override protected function createPicComplete(value:IDisplayFileInfo):void
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			addChild(_countLabel);
		}
		
		override public function getSourceData():Object
		{
			return _itemInfo;
		}
		
		override public function getSourceType():int
		{
			return CellType.MAILCELL;
		}
		
		override public function dragDrop(data:IDragData):int
		{
			var source:IDragable = data.dragSource;
			var action:int = DragActionType.UNDRAG;
			if(!source)return action;
			if(_type == 0 || _type == 2) return action;
			var bagItemInfo:ItemInfo = source.getSourceData() as ItemInfo;
			if(source == this){}
			else if(source.getSourceType() == CellType.BAGCELL)
			{
				if(!bagItemInfo.template.canTrade)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.itemCannotTrade"));
				}
				else if(bagItemInfo.isBind)
				{
					QuickTips.show(LanguageManager.getWord("ssztl.common.itemIsBind"));
				}else
				{
					itemInfo = bagItemInfo;
					action =DragActionType.DRAGIN;
					GlobalData.clientBagInfo.addToMail(bagItemInfo,_place);
				}				
			}else if(source.getSourceType() == CellType.MAILCELL)
			{
				itemInfo = bagItemInfo;
				action =DragActionType.DRAGIN;
				GlobalData.clientBagInfo.addToMail(bagItemInfo,_place);
			}
			return action;
		}
		
		override public function dragStop(data:IDragData):void
		{
			if(data.action == DragActionType.ONSELF || data.action == DragActionType.UNDRAG)
			{
				itemInfo = null;
				GlobalData.clientBagInfo.removeFromMail(_place);
			}else if(data.action == DragActionType.DRAGIN)
			{
				itemInfo = null;
			}
		}
		
		override protected function showTipHandler(evt:MouseEvent):void
		{
			if(itemInfo)TipsUtil.getInstance().show(itemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(itemInfo)TipsUtil.getInstance().hide();
		}
		
		override public function dispose():void
		{
			_itemInfo = null;
			super.dispose();
		}
	}
}