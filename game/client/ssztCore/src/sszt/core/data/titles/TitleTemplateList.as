package sszt.core.data.titles
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.data.GlobalData;
	import sszt.core.manager.LanguageManager;
	
	public class TitleTemplateList
	{
		public static var titleTypes:Dictionary = new Dictionary();
		public static var titles:Dictionary = new Dictionary();
		public static var groupTitleNames:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
//			}
//			else
//			{
//				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var title:TitleTemplateInfo = new TitleTemplateInfo();
					title.parseData(data);
					if(titleTypes[title.type] == null)
					{
//						titleTypes[title.type] = new Vector.<TitleTemplateInfo>();
						titleTypes[title.type] = [];
						groupTitleNames[title.type] = NameType.getGroupName(title.type);
					}
					titleTypes[title.type].push(title);
					titles[title.id] = title;
				}
//			}
		}
		
		public static function testVirtualData():void
		{
			for(var i:int = 1;i < 5;i++)
			{
				var title:TitleTemplateInfo = new TitleTemplateInfo();
				title.id = i;
				title.name = LanguageManager.getWord("ssztl.common.rookie");
				title.type = i;
				title.descript = GlobalData.GAME_NAME + LanguageManager.getWord("ssztl.consign.titleSystem");
				title.quality = i;
				title.effects = "1,50|2,50";
				if(titleTypes[title.type] == null)
				{
//					titleTypes[title.type] = new Vector.<TitleTemplateInfo>();
					titleTypes[title.type] = [];
					groupTitleNames[title.type] = NameType.getGroupName(title.type);
				}
				titleTypes[title.type].push(title);
				titles[title.id] = title;
			}
		}
		
		public static function getTitle(id:int):TitleTemplateInfo
		{
			return titles[id];
		}
		
		public static function getGroupTitleName(type:int):String
		{
			return groupTitleNames[type];
		}
	}
}