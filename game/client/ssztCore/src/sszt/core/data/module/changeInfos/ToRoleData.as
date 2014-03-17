package sszt.core.data.module.changeInfos
{
	public class ToRoleData
	{
		public var playerId:Number;
		public var selectIndex:int;//0人物穿戴装备，1穴位
		public var forciblyOpen:Boolean;
		public function ToRoleData(argPlayerId:Number,argIndex:int,forciblyOpen:Boolean)
		{
			playerId = argPlayerId;
			selectIndex = argIndex;
			this.forciblyOpen = forciblyOpen;
		}
	}
}