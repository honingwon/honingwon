package sszt.chat.components
{
	import sszt.core.data.chat.ChatItemInfo;
	import sszt.core.view.richTextField.RichTextField;

	public class ChatTextField
	{
		public var field:RichTextField;
		public var info:ChatItemInfo;
		
		public function ChatTextField(info:ChatItemInfo,field:RichTextField)
		{
			this.field = field;
			this.info = info;
		}
		
		public function dispose():void
		{
			if(field)
			{
				field.dispose();
				field = null;
			}
			info = null;
		}
	}
}