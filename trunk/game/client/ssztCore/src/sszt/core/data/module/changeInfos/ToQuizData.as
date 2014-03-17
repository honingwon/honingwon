package sszt.core.data.module.changeInfos
{
	public class ToQuizData
	{
		/**
		 * 视图类型。
		 * 0，答题主界面。
		 * 1，答题开始提醒。
		 */
		public var viewType:int;
		
		public function ToQuizData(viewType:int)
		{
			this.viewType = viewType;
		}
	}
}