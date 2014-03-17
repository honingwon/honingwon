package sszt.core.data.movies
{
	import flash.utils.ByteArray;

	public class MovieTemplateInfo
	{
		public var id:int;
		public var frames:Array;
		public var scaleX:int;
		public var scaleY:int;
		public var picPath:String;
		public var count:int;
		public var bound:int;
		public var time:int;
		public var addMode:int;
		public var isMove:Boolean;
		public var completeEffect:int;
		
		public function MovieTemplateInfo(id:int = 0,frames:Array = null,time:int = -1)
		{
			this.id = id;
			this.frames = frames;
			this.time = time;
		}
		
		public function parseData(data:ByteArray):void
		{
			id = data.readInt();
			frames = data.readUTF().split(",");
			scaleX = data.readInt();
			scaleY = data.readInt();
			picPath = String(data.readInt());
			count = data.readInt();
			bound = data.readInt();
			time = data.readInt();
			addMode = data.readInt();
			isMove = data.readBoolean();
			completeEffect = data.readInt();
		}
	}
}