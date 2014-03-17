/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-9-3 下午7:45:06 
 * 
 */ 
package sszt.core.socketHandlers.club
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.interfaces.socket.IPackageOut;
		
		
	public class ClubGetNoticeSocketHandler extends BaseSocketHandler {
		
		public function ClubGetNoticeSocketHandler(handlerData:Object=null){
			super(handlerData);
		}
		public static function send():void{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.CLUB_GET_NOTICE);
			GlobalAPI.socketManager.send(pkg);
		}
		
		override public function getCode():int{
			return ProtocolType.CLUB_GET_NOTICE;
		}
		override public function handlePackage():void{
			var notice:String = _data.readString();
			GlobalData.clubMemberInfo.noticeUpdate(notice);
			handComplete();
		}
		
	}
}