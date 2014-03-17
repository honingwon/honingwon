package sszt.core.socketHandlers
{
	import flash.utils.Dictionary;
	
	import sszt.constData.CommonConfig;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.interfaces.socket.ISocketManager;
	import sszt.interfaces.socket.ISubCodeSocketHandler;
	/**
	 * 只针对模块
	 * @author Administrator
	 * 
	 */	
	public class SubCodeSocketHandlerManager
	{
		private var _subSocketList:Dictionary;
		private var _code:int;
//		private var _packageList:Vector.<IPackageIn>;
		private var _packageList:Array;
		/**
		 * 模块侦听添加完成
		 */		
		private var _handlerAddComplete:Boolean;
		
		public function SubCodeSocketHandlerManager(code:int)
		{
			_code = code;
			_subSocketList = new Dictionary();
//			_packageList = new Vector.<IPackageIn>();
			_packageList = [];
			_handlerAddComplete = false;
		}
		
		public function addSocketHandler(handler:ISubCodeSocketHandler):void
		{
			if(_code != handler.getCode())return;
			if(_subSocketList[handler.getSubCode()] == null || _subSocketList[handler.getSubCode()] == undefined)
			{
				_subSocketList[handler.getSubCode()] = handler;
			}
		}
		
		/**
		 * 所有handler添加完成
		 * 
		 */		
		public function handlerAddComplete():void
		{
			_handlerAddComplete = true;
//			var t:Vector.<IPackageIn> = _packageList.slice(0);
			var t:Array = _packageList.slice(0);
//			_packageList = new Vector.<IPackageIn>();
			_packageList = [];
			for each(var i:IPackageIn in t)
			{
				handlePackage(i);
			}
		}
		
		public function handlerRemoveComplete():void
		{
			_handlerAddComplete = false;
//			_packageList = new Vector.<IPackageIn>();
			_packageList = [];
		}
		
		/**
		 * 处理协议
		 * 如果找到handler，就直接执行，
		 * 如果找不到，就先按顺序存起，等_handlerAddComplete再执行
		 * 如:房间加载和游戏开始直接执行，游戏中的命令需要等_handlerAddComplete后再执行
		 * @param pkg
		 * 
		 */		
		public function handlePackage(pkg:IPackageIn):void
		{
			pkg.position = CommonConfig.PACKAGE_HEAD_SIZE;
			var code:int = pkg.readUnsignedInt();
			var handler:ISubCodeSocketHandler = _subSocketList[code] as ISubCodeSocketHandler;
			if(handler != null)
			{
				handler.configure(pkg);
				handler.handlePackage();
			}
			else
			{
				_packageList.push(pkg);
			}
		}
		
		public function removeSocketHandler(code:int,subCode:int):void
		{
			if(code != _code)return;
			if(_subSocketList[subCode] != null)
			{
				_subSocketList[subCode].dispose();
				delete _subSocketList[subCode];
			}
		}
		
		public function dispose():void
		{
			for each(var i:ISubCodeSocketHandler in _subSocketList)
			{
				i.dispose();
			}
			_subSocketList = null;
		}
	}
}
