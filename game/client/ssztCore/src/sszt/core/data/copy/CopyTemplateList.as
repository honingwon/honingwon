package sszt.core.data.copy
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import sszt.core.manager.LanguageManager;
	import sszt.ui.container.MAlert;
	
	public class CopyTemplateList
	{
		/**
		 * 保卫襄阳
		 */		
		public static const BAOWEI:int = 3202101;
		/**
		 * 保卫雁门
		 */		
		public static const YANMEN:int = 3200301;
		
		/**
		 *  遮天阁
		 */		
		public static const ZHETIANGE:int = 42006;
		
		/**
		 * 恶人谷 
		 */		
		public static const ERRENGU:int = 42007;
		/**
		 * 狱魔会 
		 */		
		public static const YUMOHUI:int = 42009;
		/**
		 * 无限挑战
		 */		
		public static const WUXIANTIAOZHAN:int = 42010;
		
		
		
//		public static var list:Vector.<CopyTemplateItem> = new Vector.<CopyTemplateItem>();
//		public static var list:Array = [];
		public static var list:Dictionary = new Dictionary();
		public static function setup(data:ByteArray):void
		{
			var len:int = data.readInt();
			for(var i:int = 0; i < len; i++)
			{
				var item:CopyTemplateItem = new CopyTemplateItem();
				item.parseDate(data);
				list[item.id] = item;
			}
		}
		
		public function CopyTemplateList()
		{
			super();
		}
		
//		public static function parseData(data:ByteArray):void
//		{
//			if(!data.readBoolean())
//			{
//				MAlert.show(data.readUTF(),LanguageManager.getAlertTitle());
//			}
//			else
//			{
//				data.readUTF();
//				var len:int = data.readInt();
//				for(var i:int = 0;i<len;i++)
//				{
//					var item:CopyTemplateItem = new CopyTemplateItem();
//					item.parseDate(data);
//					list.push(item);
//				}
//			}
//		}
		
//		public static function getListByType(type:int):Vector.<CopyTemplateItem>
		public static function getListByType(type:int):Array
		{
//			var result:Vector.<CopyTemplateItem> = new Vector.<CopyTemplateItem>();
			var result:Array = [];
			if(type == 0)
			{
				for each(var i:CopyTemplateItem in list)
				{
					result.push(i);					
				}
			}
			else
			{
				for each(var j:CopyTemplateItem in list)
				{
					if(j.type == type)
					{
						result.push(j);
					}
				}
			}			
			return result;
		}

		/**
		 *通过npcId查找副本 
		 * @param id
		 * @return 
		 * 
		 */		
		public static function getCopyByNpc(id:int):CopyTemplateItem
		{
			for each(var i:CopyTemplateItem in list)
			{
				if(i.npcId == id)
					return i;
			}
			return null;
		}
		
		/**
		 * 通过id查找副本
		 */
		public static function getCopy(id:int):CopyTemplateItem
		{			
			return list[id];
		}
		
		public static function showTitle(id:int):Boolean
		{
			return true;
		}
		
		public static function isBaoWei(copyId:int) : Boolean
		{
			return copyId == BAOWEI;
		}
		
		public static function isYanMen(copyId:int):Boolean
		{
			return copyId == YANMEN;
		}		
		public static function isYuMoHui(copyId:int):Boolean
		{
			return int(copyId /100) == YUMOHUI;
		}
		
		public static function isZheTianGe(copyId:int):Boolean
		{
			return int(copyId /100) == ZHETIANGE;
		}
		
		public static function isErRenGu(copyId:int):Boolean
		{
			return int(copyId /100) == ERRENGU;
		}
		public static function isErWuXianTiaoZhan(copyId:int):Boolean
		{
			return int(copyId /100) == WUXIANTIAOZHAN;
		}
		
		public static function isTowerCopy(copyId:int) : Boolean
		{
			if (isBaoWei(copyId))
			{
				return true;
			}
			else if (isYanMen(copyId))
			{
				return true;
			}
			return false;
		}
		
		public static function isHangupToNextLayer(copyId:int) : Boolean
		{
			if (isZheTianGe(copyId) || isYuMoHui(copyId) || isErRenGu(copyId) || isErWuXianTiaoZhan(copyId)) 
			{
				return true;
			}
			return false;
		}
		
		public static function needClearOutBrost(copyId:int) : Boolean
		{
			if (isZheTianGe(copyId) || isYuMoHui(copyId) || isErRenGu(copyId))
			{
				return false;
			}
			return true;
		}
		
	}
}