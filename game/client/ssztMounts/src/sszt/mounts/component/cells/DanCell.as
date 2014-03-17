/** 
 * @author 王鸿源
 * @E-mail: honingwon@gmail.com
 */ 
package sszt.mounts.component.cells
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.interfaces.character.ILayerInfo;
	import sszt.mounts.component.DanCellType;
	import sszt.ui.label.MAssetLabel;
	
	public class DanCell extends BaseItemInfoCell
	{
		private var _type:int;
		public static var danItemTemplateIdDict:Dictionary;
		public static var danItemTemplateInfoDict:Dictionary;
		private var _itemTemplateInfo:ItemTemplateInfo;
		private var _txtName:MAssetLabel;
		private var _txtAmount:MAssetLabel;
			
		public function DanCell(type:int)
		{
			_type = type;
			super();
			initView();
		}
		
		private function initView():void
		{
			// TODO Auto Generated method stub
			_txtName = new MAssetLabel('',MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			_txtName.move(42,10);
			addChild(_txtName);
			
			_txtAmount = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtAmount.move(42,10);
			addChild(_txtAmount);
			
			switch(_type)
			{
				case  DanCellType.QUALITY :
					_itemTemplateInfo = danItemTemplateInfoDict[DanCellType.QUALITY];
					break;
				case  DanCellType.EVOLUTION :
					_itemTemplateInfo = danItemTemplateInfoDict[DanCellType.EVOLUTION];
					break;
				case  DanCellType.INTELLIGENCE :
					_itemTemplateInfo = danItemTemplateInfoDict[DanCellType.INTELLIGENCE];
					break;
			}
			info = _itemTemplateInfo;
			_txtName.setValue(_itemTemplateInfo.name);
			_txtName.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(_itemTemplateInfo.templateId).quality);
			_txtAmount.x = _txtName.x + _txtName.textWidth + 3;
		}
		
		public static function initDict():void
		{
			if(!danItemTemplateIdDict)
			{
				danItemTemplateIdDict = new Dictionary();
				danItemTemplateIdDict[DanCellType.QUALITY] = CategoryType.MOUNTS_STAIRS_SYMBOL;
				danItemTemplateIdDict[DanCellType.EVOLUTION] = CategoryType.MOUNTS_GROW_SYMBOL;
				danItemTemplateIdDict[DanCellType.INTELLIGENCE] = CategoryType.MOUNTS_QUALITY_SYMBOL;
			}
			if(!danItemTemplateInfoDict)
			{
				danItemTemplateInfoDict = new Dictionary();
				danItemTemplateInfoDict[DanCellType.QUALITY] =  ItemTemplateList.getTemplate(danItemTemplateIdDict[DanCellType.QUALITY]);
				danItemTemplateInfoDict[DanCellType.EVOLUTION] =  ItemTemplateList.getTemplate(danItemTemplateIdDict[DanCellType.EVOLUTION]);
				danItemTemplateInfoDict[DanCellType.INTELLIGENCE] =  ItemTemplateList.getTemplate(danItemTemplateIdDict[DanCellType.INTELLIGENCE]);
			}
		}
		public function set amount(n:int):void
		{
			_txtAmount.textColor = n<1?0xff0000:0xfffccc;
			_txtAmount.x = _txtName.x + _txtName.textWidth + 3;
			_txtAmount.setValue("(" +n + "/1)");
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_itemTemplateInfo)
			{
				_itemTemplateInfo = null;
			}
			if(_txtName)
			{
				_txtName = null;
			}
			_txtAmount = null;
		}
	}
}