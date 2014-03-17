package sszt.loader
{
	public class DataFileLoader extends BytesLoader 
	{
		
		public function DataFileLoader(path:String, callBack:Function=null, tryTime:int=1)
		{
			super(path, callBack, tryTime);
		}
	}
}
