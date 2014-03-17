package sszt.core.data.furnace
{
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.LanguageManager;

	public class FurnaceIntroInfo
	{
		public var index:int;
		public var title:String;
		public var content:String;
		public var deployList:Array = [];
		public var formatList:Array = [];
		
		private static var _pattern:RegExp = /\{[^\}]*\}/g;
		
		public function FurnaceIntroInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			var formatInfo:RichTextFormatInfo;
			
			index = data.readInt();
			title = parseString(data.readUTF());
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = title.length;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFDA5);
			formatList.unshift(formatInfo);
			
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = -1;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,null,null,null,null,5);
			formatList.unshift(formatInfo);
			
			content = parseString(title + "\n" + data.readUTF().replace(/{enter}/g,"\n"));
		}
		
		protected function parseString(msg:String):String
		{
			var formatInfo:RichTextFormatInfo;
			var deploy:DeployItemInfo;
			var list:Array = msg.match(_pattern);
			if(list && list.length >0)
			{
				for(var i:int=0;i<list.length;i++)
				{
					var str:String = list[i];
					var subStr:String = (list[i] as String).slice(1,str.length-1);
					var parms:Array = subStr.split("-");
					switch(parms[0])
					{
						case "#":
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = msg.indexOf(str);
							formatInfo.length = parms[1].length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,parseInt("0x"+parms[2]));
							formatList.push(formatInfo);
							msg = msg.replace(str,parms[1]);
							break;
						case "$":
							deploy = new DeployItemInfo();
							deploy.descript = parms[1];
							deploy.type = parms[2];
							deploy.param1 = parms[3];
							deploy.param2 = parms[4];
							deploy.param3 = parms[5];
							deploy.param4 = msg.indexOf(str);
							msg = msg.replace(str,deploy.descript);
							deployList.push(deploy);
							break;
					}
				}
			}
			return msg;
		}
	}
}