package sszt.core.socketHandlers.skill
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	
	public class SkillBarInitSocketHandler extends BaseSocketHandler
	{
		public function SkillBarInitSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.SKILL_BAR_INIT;
		}
		
		override public function handlePackage():void
		{
			var len:int = _data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				GlobalData.skillShortCut.updateShortCut(_data.readShort(),_data.readByte(),_data.readInt());
//				GlobalData.skillShortCut.updateShortCut(_data.readShort(),0,_data.readInt());
			}
			
			handComplete();
		}
	}
}