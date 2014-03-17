/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午7:46:25 
 * 
 */ 
package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.events.ClubModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;

	public class ClubSetNoticeSocketHandler extends BaseSocketHandler
	{
		
		public function ClubSetNoticeSocketHandler(handlerData:Object=null){
			super(handlerData);
		}
		public static function send(message:String):void{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_SET_NOTICE);
			pkg.writeString(message);
			GlobalAPI.socketManager.send(pkg);
		}
		
		override public function getCode():int{
			return ProtocolType.CLUB_SET_NOTICE;
		}
		override public function handlePackage():void{
			var notice:String = _data.readString();
			GlobalData.clubMemberInfo.noticeUpdate(notice);
//			ModuleEventDispatcher.dispatchClubEvent(new ClubModuleEvent(ClubModuleEvent.CLUB_UPDATE_NOTICE, notice));
			handComplete();
		}
		
	}
}