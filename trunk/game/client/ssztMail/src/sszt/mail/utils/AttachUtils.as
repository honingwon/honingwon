package sszt.mail.utils
{
	import sszt.core.data.mail.MailItemInfo;

	public class AttachUtils
	{
		public static const attachs:Array = [0x0001,0x0002,0x0004,0x0008,0x0010];
//		public static const copper:uint = 0x0400;
//		public static const yuanBao:uint = 0x0800;
//		public static const bindCopper:uint = 0x1000;
		public static const money:uint = 0x0400;
					
		public function AttachUtils()
		{
			
		}
		
		public static function CanFetch(attachFetch:int,type:uint):Boolean
		{
			return (attachFetch & int(type)) == 0;
		}
		
		public static function hasAttachment(attachFetch:int,item:MailItemInfo):Boolean
		{
			return (AttachUtils.CanFetch(attachFetch,attachs[0])&&item.attachs[0]) ||
				(AttachUtils.CanFetch(attachFetch,attachs[1])&&item.attachs[1]) ||
				(AttachUtils.CanFetch(attachFetch,attachs[2])&&item.attachs[2]) ||
				(AttachUtils.CanFetch(attachFetch,attachs[3])&&item.attachs[3]) ||
				(AttachUtils.CanFetch(attachFetch,attachs[4])&&item.attachs[4]);
		}
		
		public static function hasMoney(item:MailItemInfo):Boolean
		{
			return CanFetch(item.attachFetch,money)&&(item.copper > 0 || item.yuanBao > 0 ||item.bindCopper > 0||item.bindYuanBao>0) ;
		}

	}
}