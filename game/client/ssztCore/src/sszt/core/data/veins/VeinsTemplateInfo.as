package sszt.core.data.veins
{
	import flash.utils.ByteArray;
	
	import sszt.core.manager.LanguageManager;
	
	public class VeinsTemplateInfo
	{
		public var templateId:int;
		public var name:String;
		public var totalLevel:int;
		public var acupointType:int;
		/**
		 * 需要铜币
		 */		
		public var needCopper:int;
		/**
		 * 需要历练
		 */		
		public var needLifeExp:int;
		/**
		 * 需要时间
		 */
		public var needTime:int;
		/**
		 * 需要根骨符
		 */
		public var needGenguAmulet:int;
		/**
		 *根骨升级成功率 
		 */
		public var successRate:int;
		/**
		 * 奖励属性类型
		 */		
		public var awardAttributeType:int;
		/**
		 * 穴位升级奖励
		 */		
		public var acupointAward:int;
		/**
		 * 穴位总奖励
		 */		
		public var acupointCountAward:int;
		/**
		 * 根骨升级奖励
		 */		
		public var genguAward:int;
		/**
		 * 根骨总奖励
		 */		
		public var genguCountAward:int;
		
		public function VeinsTemplateInfo()
		{
			
		}
		
		public function parseData(data:ByteArray):void
		{
			templateId = data.readInt();
			name = data.readUTF();
			totalLevel = data.readInt();         
			acupointType = data.readInt();       
			needCopper = data.readInt();         
			needLifeExp = data.readInt();        
			needTime = data.readInt();           
			needGenguAmulet = data.readInt();    
			successRate = data.readInt();	       
			awardAttributeType = data.readInt(); 
			acupointAward = data.readInt();      
			acupointCountAward = data.readInt(); 
			genguAward = data.readInt();         
			genguCountAward = data.readInt();
		}
	}
}