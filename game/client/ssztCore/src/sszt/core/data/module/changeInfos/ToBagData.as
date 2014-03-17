package sszt.core.data.module.changeInfos
{
	import flash.geom.Rectangle;

	public class ToBagData
	{
		public var moveX:int;
		public var moveY:int;
		public var rect:Rectangle;
		
		public function ToBagData(argMoveX:int,argMoveY:int,argRect:Rectangle)
		{
			moveX = argMoveX;
			moveY = argMoveY;
			rect = argRect;
		}
	}
}