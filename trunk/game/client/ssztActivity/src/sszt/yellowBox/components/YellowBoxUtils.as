package sszt.yellowBox.components
{
	import sszt.core.data.CountDownInfo;
	import sszt.core.data.GlobalData;
	import sszt.core.data.openActivity.OpenActivityTemplateList;
	import sszt.core.data.openActivity.OpenActivityTemplateListInfo;
	import sszt.core.data.openActivity.YellowBoxTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;

	/**
	 * 
	 * @author chendong
	 */	
	public class YellowBoxUtils
	{
		/**
		 * 当前领取黄钻类型 0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包 
		 */		
		public static var currentType:int = 2;
		
		/**
		 * 返回模板数据
		 * @param type 0.每日礼包,1.升级礼包2,新手礼包3.每日年费礼包4.升级黄钻礼包5.豪华礼包 
		 * @return 
		 * 
		 */		
		public static function getYellowBoxArray(type:int):Array
		{
			var opAct:Array = [];
			switch(type)
			{
				case 0:
					opAct = YellowBoxTemplateList.yellowBoxTypeOneArray;
					break;
				case 1:
					opAct = YellowBoxTemplateList.yellowBoxTypeTwoArray;
					break;
				case 2:
					opAct = YellowBoxTemplateList.yellowBoxTypeThreeArray;
					break;
				case 3:
					opAct = YellowBoxTemplateList.yellowBoxTypeFourArray;
					break;
				case 4:
					opAct = YellowBoxTemplateList.yellowBoxTypeFiveArray;
					break;
				case 5:
					opAct = YellowBoxTemplateList.yellowBoxTypeSixArray;
					break;
			}
			return opAct;
		}
		
		
	}
}