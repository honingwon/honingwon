package sszt.core.data.skill
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;
	
	import sszt.core.manager.LanguageManager;

	public class SkillTemplateDescriptList
	{
		private static var _descriptList:Dictionary = new Dictionary();
		
		public static function setup(data:ByteArray):void
		{
			if(!data.readBoolean())
			{
				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
			}
			else
			{
				data.readUTF();
				var len:int = data.readInt();
				for(var i:int = 0; i < len; i++)
				{
					var descript:SkillTemplateDescriptInfo = new SkillTemplateDescriptInfo();
					descript.parseData(data);
					_descriptList[descript.id] = descript;
				}
			}
		}
		
		public static function getScript(id:int):SkillTemplateDescriptInfo
		{
			return _descriptList[id];
		}
	}
}
