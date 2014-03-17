package sszt.core.data.shenMoGuide
{
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.richTextField.RichTextFormatInfo;
	import sszt.core.manager.LanguageManager;

	public class GuideItemInfo
	{
		public var infoId:int;
		public var title:String;
		public var msg:String;
		public var deployList:Array;
		public var formatList:Array;
		public var titleFormatList:Array;
		
		private static var _pattern:RegExp = /\{[^\}]*\}/g;
		public function GuideItemInfo()
		{
			deployList = [];
			formatList = [];
			titleFormatList = [];
		}
		
		public function parseData(data:ByteArray):void
		{
			infoId = data.readInt();
			
			var formatInfo:RichTextFormatInfo;
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = -1;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xEDDB60);
			titleFormatList.push( formatInfo);
			title = parseStr(data.readUTF(),titleFormatList,[]);
			
			msg = title + "\n\n" + data.readUTF().replace(/{enter}/g,"\n");
			
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = -1;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,null,null,null,null,10);
			formatList.push(formatInfo);
			
			formatInfo = new RichTextFormatInfo();
			formatInfo.index = 0;
			formatInfo.length = title.length;
			formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),16,0xFFFF99);
			formatList.push(formatInfo);
			
			msg = parseStr(msg,formatList,deployList);
		}
		
		public function parseStr(argStr:String,argFormatList:Array,argDeployList:Array):String
		{
			var list:Array = argStr.match(_pattern);
			
			if(list != null && list.length > 0)  
			{
				for(var j:int = 0; j < list.length; j++)
				{
					var str:String = list[j] as String;
					var subStr:String = str.substr(1,str.length-2);
					var parms:Array = subStr.split("-");
					var deploy:DeployItemInfo;
					var formatInfo:RichTextFormatInfo;
					switch(parms[0])
					{
						case "#":
							formatInfo = new RichTextFormatInfo();
							formatInfo.index = argStr.indexOf(str);
							formatInfo.length = parms[1].length;
							formatInfo.textFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,parseInt("0x"+parms[2]));
							argFormatList.push(formatInfo);
							argStr = argStr.replace(str,parms[1]);
							break;
						case "$":
							deploy = new DeployItemInfo();
							deploy.descript = parms[1];
							deploy.type = parms[2];
							deploy.param1 = parms[3];
							deploy.param2 = parms[4];
							deploy.param3 = parms[5];
							deploy.param4 = argStr.indexOf(str);
							argStr = argStr.replace(str,deploy.descript);
							argDeployList.push(deploy);
							break;
						case "T":
							deploy = new DeployItemInfo();
							deploy.descript = parms[1];
							deploy.type = parms[2];
							deploy.param1 = parms[3];
							deploy.param2 = parms[4];
							deploy.param3 = parms[5];
							deploy.param4 = argStr.indexOf(str);
							argStr = argStr.replace(str,"    ");
							argDeployList.push(deploy);
							break;
					}
				}
			}
			return argStr;
		}
	}
}