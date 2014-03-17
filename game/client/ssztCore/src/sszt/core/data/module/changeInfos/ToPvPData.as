package sszt.core.data.module.changeInfos
{
	public class ToPvPData
	{
		private var _openPanel:int=0; // 0:pvp主面板，1：pvp战斗结果面板，2：参加pvp面板
		private var _result:int = 0; // 0:平局，1：胜利，2：失败
		private var _count1:int = 0; //功勋
		private var _count2:int = 0; //奖励
		
		public function ToPvPData()
		{
		}

		public function get openPanel():int
		{
			return _openPanel;
		}

		public function set openPanel(value:int):void
		{
			_openPanel = value;
		}

		public function get count2():int
		{
			return _count2;
		}

		public function set count2(value:int):void
		{
			_count2 = value;
		}

		public function get count1():int
		{
			return _count1;
		}

		public function set count1(value:int):void
		{
			_count1 = value;
		}

		public function get result():int
		{
			return _result;
		}

		public function set result(value:int):void
		{
			_result = value;
		}

	}
}