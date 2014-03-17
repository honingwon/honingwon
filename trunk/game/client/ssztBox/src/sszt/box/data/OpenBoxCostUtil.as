package sszt.box.data
{
	import sszt.core.manager.LanguageManager;

	public class OpenBoxCostUtil
	{
		public function OpenBoxCostUtil()
		{
		}
		
		public static function getCost(type:int):int
		{
			var cost:int;
			switch(type)
			{
				case 1:
					cost = 5;
					break;
				case 2:
					cost = 45;
					break;
				case 3:
					cost = 225;
					break;
				case 4:
					cost = 10;
					break;
				case 5:
					cost = 95;
					break;
				case 6:
					cost = 450;
					break;
				case 7:
					cost = 20;
					break;
				case 8:
					cost = 190;
					break;
				case 9:
					cost = 900;
					break;
			}
			return cost;
		}
		
		public static function getCostItemName(type:int):String
		{
			var name:String;
			switch(type)
			{
				case 1:
					name = LanguageManager.getWord("ssztl.common.qiShiReel");
					break;
				case 4:
					name = LanguageManager.getWord("ssztl.common.shenShiReel");
					break;
				case 7:
					name = LanguageManager.getWord("ssztl.common.xianShiReel");
					break;
				default:
					name = "";	
			}
			return name;
		}
	}
}