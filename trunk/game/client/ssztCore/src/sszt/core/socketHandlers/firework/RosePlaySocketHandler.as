package sszt.core.socketHandlers.firework
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.ProtocolType;
	import sszt.core.socketHandlers.BaseSocketHandler;
	import sszt.core.socketHandlers.notice.PlayerNoticeHandler;
	import sszt.core.utils.PlayerNoticeUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.events.FriendModuleEvent;
	import sszt.interfaces.socket.IPackageOut;
	import sszt.module.ModuleEventDispatcher;
	
	public class RosePlaySocketHandler extends BaseSocketHandler
	{
		public function RosePlaySocketHandler(handlerData:Object=null)
		{
			super(handlerData);
		}
		
		override public function getCode():int
		{
			return ProtocolType.ROSE_PLAY;
		}
		
		override public function handlePackage():void
		{
			var roseType:int;
			var senderId:Number = _data.readNumber();
			var sender:String = _data.readString();
			var senderSex:Boolean = _data.readBoolean();
			var receiverId:Number = _data.readNumber();
			var receiver:String = _data.readString();
			var type:int = _data.readByte();
			var count:int = _data.readShort();
			
//			PlayerNoticeUtil.roseNotice(senderServerId, sender, receiverServerId, receiver, type, count);
			
			ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.GIVE_FLOWERS));
			
			roseType = type % 4;
			if (roseType > 1)
			{
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.ROSE_PLAY,  roseType-1));
			}
			//回赠
			if (receiverId == GlobalData.selfPlayer.userId  && type <4 ){
//				ReceiveRoseView.getInstance().show(senderId, senderServerId, sender, senderSex, type);
//				ReceiveRosePanel.getInstance().show(senderId,sender,type,count);
				ModuleEventDispatcher.dispatchFriendEvent(new FriendModuleEvent(FriendModuleEvent.SHOW_RECEIVE_FLOWERS_PANEL,{senderId:senderId,sender:sender,type:type,count:count}));
			}
			
//			var senderServerId:int = _data.readShort();
//			var sender:String = _data.readString();
//			var receiverServerId:int = _data.readShort();
//			var receiver:String = _data.readString();
//			PlayerNoticeUtil.roseNotice(sender,receiver);
//			
//			ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.ROSE_PLAY));
			
			handComplete();
		}
		
		/**
		 *  
		 * @param userId 对方id
		 * @param type 4中类型，1，9，99，999多
		 * @param amount 数量
		 * @param isAuto 是否自动购买并赠送
		 * @param nick 对方昵称
		 * 
		 */		
		public static function send(userId:Number, type:int, amount:int, isAuto:Boolean, nick:String):void
		{
			var pkg:IPackageOut = GlobalAPI.socketManager.getPackageOut(ProtocolType.ROSE_PLAY);
			pkg.writeNumber(userId);
			pkg.writeByte(type);
			pkg.writeShort(amount);
			pkg.writeBoolean(isAuto);
			pkg.writeUTF(nick);
			GlobalAPI.socketManager.send(pkg);
		}
	}
}