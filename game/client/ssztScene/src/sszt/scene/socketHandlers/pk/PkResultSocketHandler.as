package sszt.scene.socketHandlers.pk
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.scene.components.pk.PkResultView;
	
	public class PkResultSocketHandler extends BaseSocketHandler
	{
		public function PkResultSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.PK_RESULT;
		}
		
		override public function handlePackage():void
		{
			var type:int = _data.readInt();
			GlobalData.selfPlayer.pkState = type;
			PkResultView.getInstance().show(type);
			handComplete();
		}
	}
}