package sszt.scene.data
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import sszt.core.data.GlobalAPI;
	
	public class SceneAttackList extends EventDispatcher
	{
//		public var attackList:Vector.<Number>;
		public var attackList:Array;
		
		public function SceneAttackList(target:IEventDispatcher=null)
		{
//			attackList = new Vector.<Number>();
			attackList = [];
			super(target);
		}
		
		public function addPlayer(id:Number):void
		{
			if(attackList.indexOf(id) == -1)
			{
				attackList.push(id);
			}
		}
		
		public function removePlayer(id:Number):void
		{
			if(attackList.indexOf(id) != -1)
			{
				attackList.splice(attackList.indexOf(id),1);
			}
		}
	}
}