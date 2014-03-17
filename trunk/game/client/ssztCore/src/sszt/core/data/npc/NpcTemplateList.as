package sszt.core.data.npc
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.ui.container.MAlert;

	public class NpcTemplateList
	{
		private static var _templateList:Dictionary;
		public static var sceneNpcs:Dictionary;
		
		public static function setup(data:ByteArray):void
		{
//			if(data.readBoolean())
//			{
//				data.readUTF();
//			}
//			else
//			{
//				MAlert.show(data.readUTF());
//				return;
//			}
			_templateList = new Dictionary();
			sceneNpcs = new Dictionary();
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var npc:NpcTemplateInfo = new NpcTemplateInfo();
				npc.parseData(data);
				_templateList[npc.templateId] = npc;
//				if(sceneNpcs[npc.sceneId] == null)sceneNpcs[npc.sceneId] = new Vector.<NpcTemplateInfo>();
				if(sceneNpcs[npc.sceneId] == null)sceneNpcs[npc.sceneId] = [];
				sceneNpcs[npc.sceneId].push(npc);
			}
		}
		
		public static function getNpc(id:int):NpcTemplateInfo
		{
			return _templateList[id];
		}
		
		public static function getTemplates():Dictionary
		{
			return _templateList;
		}
	}
}