package sszt.marriage.event
{
	import flash.events.Event;
	
	public class MarriageMediatorEvent
	{
		public static const MARRIAGE_COMMAND_START:String = "marriageCommandStart";
		public static const MARRIAGE_COMMAND_END:String = "marriageCommandEnd";
		
		public static const MARRIAGE_START:String = "marriageStart";
		public static const MARRIAGE_DISPOSE:String = "marriageDispose";
		
		/**
		 * 打开求婚对象界面
		 * */
		public static const SHOW_MARRY_TARGET_PANEL:String = "showMarryTargetPanel";
		
		/**
		 * 打开结婚祝福界面
		 * */
		public static const SHOW_WEDDING_BLESSING_PANEL:String = "showWeddingBlessingPanel";
		
		/**
		 * 打开求婚拒绝伤心界面
		 * */
		public static const SHOW_MARRY_REFUSE_PANEL:String = "showMarryRefusePanel";
		
		/**
		 * 打开婚礼面板
		 * */
		public static const SHOW_WEDDING_PANEL:String = "showWeddingPanel";
		
		/**
		 * 打开婚礼请柬
		 * */
		public static const SHOW_WEDDING_INVITATION_CARD:String = "showWeddingInvitationCard";
		
		/**
		 * 婚礼取消（求婚成功但求婚者没钱办不起婚礼）
		 * */
		public static const SHOW_WEDDING_CANCEL_VIEW:String = "showWeddingCancelView";
		
		/**
		 * 婚姻管理
		 * */
		public static const SHOW_MARRIAGE_MANAGE_PANEL:String = "showMarriageManagePanel";
		
	}
}