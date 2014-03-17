package sszt.core.queue
{
	import sszt.interfaces.socket.IPackageIn;

	public interface IQueueInfo
	{
		function get pkg():IPackageIn;
		function get handleData():*;
		function dispose():void;
	}
}