package sszt.core.data.mail
{
	import sszt.core.manager.LanguageManager;

	public class MailType
	{
		public static const DEFAULT:int = 0;                   //缺省
		public static const SYSTEM:int = 5;
		public static const PRIVATE:int = 1;                   //普通私人邮件
		public static const AUCTIONSUCCESS:int = 2;           //拍卖成功邮件
		public static const AUCTIONFAIL:int = 3;              //拍卖失败邮件
		public static const Mail_Type_Guild_Broad:int = 11;  //公会邮件广播
		public static const BUYITEM:int = 4;                 //买物品邮件
		public static const Mail_Type_OpenBox:int = 6;       //箱子物品
		public static const SHOP_AUCTION_SUCCESS:int = 7;    //拍卖成功
		public static const SHOP_AUCTION_FAIL:int = 8;       //拍卖失败
		public static const MAIL_TYPE_ONSALE_DELETE:int = 9;  //物品寄售撤消
		public static const ADMIN:int = 51;                 //后台邮件
		public static const NOTICE:int = 52;                //公告邮件
		
		public function MailType()
		{
			
		}
		
		public static function getNameByType(value:int):String
		{
			var result:String = "";
			switch (value)
			{
				case DEFAULT:
					result = LanguageManager.getWord("ssztl.common.systemMail");
					break;
				case PRIVATE:
					result = LanguageManager.getWord("ssztl.common.privateMail");
					break;
				case AUCTIONSUCCESS:
					result = LanguageManager.getWord("ssztl.common.consignSuccess");
					break;
				case AUCTIONFAIL:
					result = LanguageManager.getWord("ssztl.common.consignFail");
					break;
				case BUYITEM:
					result = LanguageManager.getWord("ssztl.common.buyShortItem");
					break;
				case Mail_Type_OpenBox:
					result = LanguageManager.getWord("ssztl.common.boxItem");
					break;
				case SYSTEM:
					result = LanguageManager.getWord("ssztl.common.systemMail");
					break;
				case Mail_Type_Guild_Broad:
					result = LanguageManager.getWord("ssztl.common.clubMail");
					break;
				case ADMIN:
					result = LanguageManager.getWord("ssztl.common.backgroudMail");
					break;
				case NOTICE:
					result = LanguageManager.getWord("ssztl.common.noticeMail");
					break;
				case SHOP_AUCTION_SUCCESS:
					result = LanguageManager.getWord("ssztl.common.publicSellSuccess");
					break;
				case SHOP_AUCTION_FAIL:
					result = LanguageManager.getWord("ssztl.common.publicSellFail");
					break;
				case MAIL_TYPE_ONSALE_DELETE:
					result = LanguageManager.getWord("ssztl.common.onsaleDelete");
					break;
			}
			return result;
		}
	}
}