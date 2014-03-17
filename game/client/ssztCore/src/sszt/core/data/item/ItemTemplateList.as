package sszt.core.data.item
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.constData.CategoryType;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.interfaces.socket.IPackageIn;
	import sszt.ui.container.MAlert;
	
	public class ItemTemplateList extends EventDispatcher
	{
		public static var _templateList:Dictionary = new Dictionary();
		public static var hasParse:Boolean = false;
		/**
		 * 根据协议解析data
		 * @param data
		 * 
		 */		
		public static function setup(data:ByteArray):void 
		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF());
//				return;
//			}
//			data.readUTF();
			var len:int = data.readInt();
			for( var i:int=0;i<len;i++)
			{
				var categoryId:int = data.readInt();
				var info:ItemTemplateInfo;
				
					info = new ItemTemplateInfo();
				
				info.loadData(categoryId,data);
				_templateList[info.templateId] = info;
			}			
			hasParse = true;
		}
		
		public static function getTemplate(id:int):ItemTemplateInfo
		{
			return _templateList[id];
		}		
		
		public static function getTemplateForFuse(level:int,quality:int,name:String,career:int,categoryId:int):ItemTemplateInfo
		{
			for each(var i:ItemTemplateInfo in _templateList)
			{
				if(i.needLevel == level && i.quality == quality  && i.needCareer == career && i.categoryId == categoryId && i.name.indexOf(name) != -1)
				{
					return i;
				}
			}
			return null;
		}
		
		public static function getTemplateSuitId(argSuitId:int,argCategoryId:int):ItemTemplateInfo
		{
			for each(var i:ItemTemplateInfo in _templateList)
			{
				if(i.suitId == argSuitId && i.categoryId == argCategoryId)
				{
					return i;
				}
			}
			return null;
		}
	}
}
