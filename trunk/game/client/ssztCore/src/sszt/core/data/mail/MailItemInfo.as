package sszt.core.data.mail
{
	import flash.events.EventDispatcher;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.utils.DateUtil;
	import sszt.core.utils.PackageUtil;
	import sszt.interfaces.socket.IPackageIn;

	public class MailItemInfo extends EventDispatcher
	{
		public var mailId:Number;
		public var senderServerId:int;
		public var senderId:Number;
		public var senderName:String;
		public var receiverId:Number;
		public var receiverName:String;
		public var title:String;
		public var context:String;
		public var sendDate:Date;
		public var isRead:Boolean;
		public var readDate:Date;
		public var copper:int;
		public var bindCopper:int;
		public var yuanBao:int;
		public var bindYuanBao:int;
		public var attachs:Array = new Array(5);
		public var attachFetch:int;
		public var remark:String;
		public var type:int;
		public var validDate:int;
		public var attachments:Array;
		public var leftDay:int;
		
		public function MailItemInfo(data:IPackageIn)
		{
			mailId = data.readNumber();
//			senderServerId = data.readShort();
			senderId = data.readNumber();
			senderName = data.readString();
			receiverId = data.readNumber();
			receiverName = data.readString();
			title = data.readString();
			context = data.readString();
			sendDate = data.readDate();
			isRead = data.readBoolean();
			readDate = data.readDate();
			copper = data.readInt();
			bindCopper = data.readInt();
			yuanBao = data.readInt();
			bindYuanBao = data.readInt();
			attachs[0] = data.readNumber();
			attachs[1] = data.readNumber();
			attachs[2]= data.readNumber();
			attachs[3] = data.readNumber();
			attachs[4]= data.readNumber();
			attachFetch = data.readInt();
			remark = data.readString();
			type = data.readInt();
			validDate = data.readInt();
			var len:int = data.readInt();
			attachments = new Array(4);
			for(var i:int = 0;i<len;i++)
			{
				var item:ItemInfo = new ItemInfo();
				PackageUtil.readItem(item,data);
				attachments[i] = item;
			}
			leftDay = validDate/24 - DateUtil.deltaDay(sendDate,GlobalData.systemDate.getSystemDate());
		}
		
		public function setFetch(fetch:int):void
		{
			attachFetch = fetch;
			dispatchEvent(new MailEvent(MailEvent.MAIL_ATTACH_RECEIVE,mailId));
		}
	}
}