package sszt.core.queue
{
	import sszt.interfaces.tick.ITick;

	public class QueueManager implements ITick
	{
//		private var _queues:Vector.<IQueue>;
		private var _queues:Array;
		
		public function QueueManager()
		{
//			_queues = new Vector.<IQueue>();
			_queues = [];
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			if(_queues.length > 0)
			{
				var queue:IQueue = _queues[0];
				if(!queue.hadDoInit)
					queue.init();
				if(!queue.isFinished)
					queue.update(times,dt);
				if(queue.isFinished)
				{
					queue.managerClear();
					_queues.shift();
				}
			}
		}
		
		public function addQueue(queue:IQueue):void
		{
			if(_queues.indexOf(queue) != -1)return;
			_queues.push(queue);
		}
		
		public function addQueueIn(queue:IQueue,index:int):void
		{
			if(_queues.indexOf(queue) != -1)return;
			_queues.splice(index,0,queue);
		}
		
		public function getQueueIndex(queue:IQueue):int
		{
			return _queues.indexOf(queue);
		}
		
		public function addQueueInCurrentBack(queue:IQueue):void
		{
			_queues.splice(1,0,queue);
		}
		
		public function removeQueue(queue:IQueue):void
		{
			var n:int = _queues.indexOf(queue);
			_queues.splice(n,1);
		}
				
		public function dispose():void
		{
			for each(var i:IQueue in _queues)
			{
				i.dispose();
			}
			_queues = null;
		}
	}
}