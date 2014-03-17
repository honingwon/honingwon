package sszt.furnace.socketHandlers
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.ProtocolType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.view.quickTips.QuickTips;
	import sszt.furnace.FurnaceModule;
	import sszt.furnace.events.FuranceEvent;
	import sszt.interfaces.socket.IPackageOut;
	
	public class FurnaceQuenchingSocketHandler extends BaseSocketHandler
	{
		public function FurnaceQuenchingSocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.QUENCHING;
		}
		
		public function get furnaceModule():FurnaceModule
		{
			return _handlerData as FurnaceModule;
		}
		
		override public function handlePackage():void
		{
			//2是完美淬炼 1是普通淬炼 0是失败
			var result:int = _data.readByte();
			if(result == 1 || result == 2)
			{
				furnaceModule.furnaceInfo.dispatchEvent(new FuranceEvent(FuranceEvent.QUENCHING_SUCCESS,result));
				var word:String;
				if(result == 1)
				{
					word = 'ssztl.furnace.quenchingSuccess';
				}
				else if(result == 2)
				{
					word = 'ssztl.furnace.quenchingSuccess2';
				}
				QuickTips.show(LanguageManager.getWord(word));
			}
			else
			{
				QuickTips.show(LanguageManager.getWord("ssztl.furnace.quenchingFail"));
			}
			//请空中间面板
			furnaceModule.furnaceInfo.clearMiddlePanel();
			handComplete();
		}
		
		public static function send(stonePlace:int, materialPlace:int,useYuanbao:Boolean,isBag:Boolean=true,itemPlace:int=0,holePlace:int=0):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.QUENCHING);
			pkg.writeInt(stonePlace);
			pkg.writeInt(materialPlace);
			pkg.writeBoolean(useYuanbao);
			pkg.writeBoolean(isBag);
			pkg.writeInt(itemPlace);
			pkg.writeInt(holePlace);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}