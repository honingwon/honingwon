package sszt.core.data.buff
{
	import flash.utils.ByteArray;
	
	import sszt.core.data.LayerInfo;

	public class BuffTemplateInfo extends LayerInfo
	{
		public var name:String;
		public var groupId:int;
		public var descript:String;
		/**
		 * 有效时间(ms)
		 * 血包时为总量
		 */		
		public var valieTime:int;
		/**
		 * 有效间隔
		 */		
		public var valieTimeSpan:int;
		/**
		 * 1普通buff,2血包buff,3经验buff
		 */		
		public var type:int;
		/**
		 * 叠加上限
		 */		
		public var limitTotalTime:int;
		/**
		 * 技能效果
		 * 效果列表，#分割 （效果1，值1)
		 */		
		public var skillEffectList:Array;
		
		public function BuffTemplateInfo()
		{
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			groupId = data.readInt();
			name = data.readUTF();
			picPath = data.readUTF();
			iconPath = picPath;
			descript = data.readUTF();
			valieTime = data.readInt();
			valieTimeSpan = data.readInt();
			type = data.readInt();
			limitTotalTime = data.readInt();
			skillEffectList = data.readUTF().split("|");
		}
		
		public function getIsTime():Boolean
		{
			return type != 1 && type != 2;
		}
	}
}