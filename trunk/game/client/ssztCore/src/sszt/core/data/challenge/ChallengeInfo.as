package sszt.core.data.challenge
{
	public class ChallengeInfo
	{
		/**
		 * 试练总层数
		 */
		public static var LAYER_NUM:int = 7;
		/**
		 * 每层关口数 
		 */
		public static var MARK_LAYER_NUM:int = 6;
		
		private var _challInfo:Array;
		private var _num:int;
		private var _challTypeOneArray:Array = [];
		private var _challTypeTwoArray:Array = [];
		private var _challTypeThreeArray:Array = [];
		private var _challTypeFourArray:Array = [];
		private var _challTypeFiveArray:Array = [];
		private var _challTypeSixArray:Array = [];
		
		public function get challInfo():Array
		{
			return _challInfo;
		}

		public function set challInfo(value:Array):void
		{
			_challInfo = value;
			setSixArrayData();
		}

		public function get num():int
		{
			return _num;
		}

		public function set num(value:int):void
		{
			_num = value;
		}

		private function setSixArrayData():void
		{
			var k:int=0;
			var endIndex:int=0;
			for(var i:int=0;i<challInfo.length;i+=6)
			{
				endIndex = i+6;
				if(k==0)  //i=0
				{
					_challTypeOneArray = challInfo.slice(i,endIndex);
				}
				else if(k==1) //i=6
				{
					_challTypeTwoArray = challInfo.slice(i,endIndex);
				}
				else if(k==2) //i=12
				{
					_challTypeThreeArray = challInfo.slice(i,endIndex);
				}
				else if(k==3)//i=18
				{
					_challTypeFourArray = challInfo.slice(i,endIndex);
				}
				else if(k==4)//i=24
				{
					_challTypeFiveArray = challInfo.slice(i,endIndex);
				}
				else if(k==5) //i=30
				{
					_challTypeSixArray = challInfo.slice(i,endIndex);
				}
				++k;
			}
		}
		
		/**
		 * 根据层数返回该层的评星信息 
		 * @param layer 0-5层
		 * @return 
		 * 
		 */		
		public function getLayerStar(layer:int):Array
		{
			var tempArray:Array = [];
			switch(layer)
			{
				case 0:
					tempArray = _challTypeOneArray;
					break;
				case 1:
					tempArray = _challTypeTwoArray;
					break;
				case 2:
					tempArray = _challTypeThreeArray;
					break;
				case 3:
					tempArray = _challTypeFourArray;
					break;
				case 4:
					tempArray = _challTypeFiveArray;
					break;
				case 5:
					tempArray = _challTypeSixArray;
					break;
			}
			return tempArray;
		}
		
	}
}