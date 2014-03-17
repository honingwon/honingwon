package sszt.rank.data.item
{
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.utils.PackageUtil;

	public class EquipRankItem
	{
		public var serverId:int;
		public var place:int;
		public var roleId:Number;
		public var roleName:String;
		public var itemId:Number;
//		public var itemTemplateId:int;
//		public var itemTemplate:ItemTemplateInfo;
		public var careerName:String;
		public var score:int;
		
		public var itemInfo:ItemInfo;
		
		public function EquipRankItem()
		{
		}
		
		public function readData(xml:XML):void
		{
			itemInfo = new ItemInfo();
			
			serverId = parseInt(xml.@server_id);
			place = parseInt(xml.@rank);
			roleId = parseInt(xml.@user_id);
			roleName = xml.@nick_name;
			careerName = xml.@career;
			score = parseInt(xml.@score);
			
			itemInfo.isBind = Boolean(parseInt(xml.@is_bind));
			itemInfo.strengthenLevel = parseInt(xml.@strengthen_level);
			itemInfo.count = parseInt(xml.@amount);
			itemInfo.place = parseInt(xml.@place);
			itemInfo.state = parseInt(xml.@state);
			itemInfo.durable = parseInt(xml.@durable);
			itemInfo.enchase1 = parseInt(xml.@enchase1);
			itemInfo.enchase2 = parseInt(xml.@enchase2);
			itemInfo.enchase3 = parseInt(xml.@enchase3);
			itemInfo.enchase4 = parseInt(xml.@enchase4);
			itemInfo.enchase5 = parseInt(xml.@enchase5);
			itemInfo.itemId = parseFloat(xml.@id);
			itemInfo.templateId = parseInt(xml.@template_id);
			itemInfo.freePropertyVector = PackageUtil.parseProperty(xml.@data);
		}
	}
}