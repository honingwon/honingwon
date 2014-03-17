package sszt.core.data.activity
{
	import flash.utils.Dictionary;

	public class ActiveStartInfo
	{
		private var _activeTimeInfo:Dictionary;
		
		public function ActiveStartInfo()
		{
			_activeTimeInfo = new Dictionary();
		}
		

		public function get activeTimeInfo():Dictionary
		{
			return _activeTimeInfo;
		}

		public function set activeTimeInfo(value:Dictionary):void
		{
			_activeTimeInfo = value;
		}

	}
}