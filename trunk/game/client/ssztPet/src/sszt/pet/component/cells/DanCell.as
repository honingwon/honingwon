/** 
 * @author 王鸿源
 * @E-mail: honingwon@gmail.com
 */ 
package sszt.pet.component.cells
{
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.view.cell.BaseItemInfoCell;
	import sszt.ui.label.MAssetLabel;
	
	public class DanCell extends BaseItemInfoCell
	{
		private var _danInfo:ItemTemplateInfo;
		private var _txtName:MAssetLabel;
		private var _txtAmount:MAssetLabel;
		
		public function DanCell()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			_txtName = new MAssetLabel('',MAssetLabel.LABEL_TYPE9,TextFieldAutoSize.LEFT);
			_txtName.move(42,10);
			addChild(_txtName);
			_txtAmount = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_txtAmount.move(42,10);
			addChild(_txtAmount);
		}
		
		public function set danInfo(itemInfo:ItemTemplateInfo):void
		{
			_danInfo = itemInfo;
			info = itemInfo;
			_txtName.setValue(itemInfo.name);
			_txtName.textColor = CategoryType.getQualityColor(ItemTemplateList.getTemplate(itemInfo.templateId).quality);
			_txtAmount.x = _txtName.x + _txtName.textWidth + 3;
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
			if(_txtName)
			{
				_txtName = null;
			}
			_txtAmount = null;
		}
	}
}