package sszt.core.view.tips
{
	import flash.text.TextFormat;
	
	import sszt.constData.CategoryType;
	import sszt.constData.PropertyType;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.PropertyInfo;
//	import sszt.core.data.pet.PetQualityTemplateList;
	import sszt.core.manager.LanguageManager;

	public class PetTemplateTip extends BaseDynamicTip
	{
		private var _info:ItemTemplateInfo;
		
		public function PetTemplateTip()
		{
			super();
		}
		
		public function setPetTemplate(info:ItemTemplateInfo):void
		{
			clear();
			_info = info;
			
			addStringToField(_info.name,getTextFormat(CategoryType.getQualityColor(_info.quality)));
//			addStringToField("等级：1",getTextFormat(0xffffff));
//			addStringToField("成长：" + _info.property2,getTextFormat(0xffffff));
//			addStringToField("资质：" + _info.property3 + "/" + PetQualityTemplateList.getTemplate(_info.quality).max,getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.level2")+"：1",getTextFormat(0xffffff));
			addStringToField(LanguageManager.getWord("ssztl.common.grow2")+"：" + _info.property2,getTextFormat(0xffffff));
//			addStringToField(LanguageManager.getWord("ssztl.common.petQuality")+"：" + _info.property3 + "/" + PetQualityTemplateList.getTemplate(_info.quality).max,getTextFormat(0xffffff));
			
			for each(var j:PropertyInfo in _info.regularPropertyList)
			{
				if(j.propertyValue > 0)
					addStringToField(PropertyType.getName(j.propertyId) + "：" + j.propertyValue,getTextFormat(0x41D913));
			}
		}
		
		protected function getTextFormat(color:uint):TextFormat
		{
			return new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,color,null,null,null,null,null,null,null,null,null,3);
		}
	}
}