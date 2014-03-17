package sszt.core.view.enthral
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;
	
	import sszt.ui.UIManager;
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.utils.JSUtils;
	import sszt.interfaces.tick.ITick;
	
	public class EAlert extends MAlert implements ITick
	{
		private var _disposeTime:Number = 0;
		
		public function EAlert(message:String="", title:String="", flags:uint=4, parent:DisplayObjectContainer=null, closeHandler:Function=null, textAlign:String="center", width:Number=-1, closeAble:Boolean=true)
		{
			super(message, title, flags, parent, closeHandler, textAlign, width, closeAble);
			_disposeTime = getTimer();
			GlobalAPI.tickManager.addTick(this);
		}
		
		override public function doEscHandler():void
		{
			
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
			var tmp:Number = getTimer();
			if(tmp - _disposeTime >= 60000)
			{
				JSUtils.gotoPage(GlobalAPI.pathManager.getOfficalPath(),true);
				dispose();
				GlobalAPI.tickManager.removeTick(this);
			}
		}
		
		public static function show(message:String = "",title:String = "",flags:uint = 4,parent:DisplayObjectContainer = null,closeHandler:Function = null,textAlign:String = "center",width:Number = -1,closeAble:Boolean = true):EAlert
		{
			var alert:EAlert = new EAlert(message,title,flags,parent,closeHandler,textAlign,width,closeAble);
			if(parent)parent.addChild(alert);
			else UIManager.PARENT.addChild(alert);
			alert.listenKey();
			return alert;
		}
	}
}