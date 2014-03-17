package sszt.core.data.club
{
	import flash.utils.Dictionary;

	public class ClubShopInfo
	{
		private var _shopInfo:Dictionary = new Dictionary();

		

		public function get shopInfo():Dictionary
		{
			return _shopInfo;
		}

		public function set shopInfo(value:Dictionary):void
		{
			_shopInfo = value;
		}

	}
}