package sszt.rank.util
{
	import sszt.core.data.GlobalData;
	import sszt.core.data.item.ItemInfo;
	import sszt.core.data.player.BasePlayerInfo;
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.data.player.TipPlayerInfo;
	import sszt.core.utils.PackageUtil;

	public class RankDataUtil
	{
		public function RankDataUtil()
		{
		}
		
		public static function readBasePlayer(player:BasePlayerInfo,data:XML):void
		{
			player.nick = data.@nick_name;
			player.sex = Boolean(parseInt(data.@sex_id));
			player.level = parseInt(data.@level);
		}
		
		public static function readTipPlayer(player:TipPlayerInfo,data:XML):void
		{
			readBasePlayer(player,data);
		}
		
		public static function readFigurePlayer(player:DetailPlayerInfo,data:XML):void
		{
			readTipPlayer(player,data);
			player.career = parseInt(data.@career_id);
			var styleStr:String = data.@style_bin;
			var styleArray:Array = styleStr.split(",");
			var cloth:int = parseInt(styleArray[0]);
			var weapon:int = parseInt(styleArray[1]);
			var mounts:int = parseInt(styleArray[2]);
			var wing:int = parseInt(styleArray[3]);
			var strengthLevel:int = parseInt(styleArray[4]);
			var mStrengthLevel:int = parseInt(styleArray[5]);
			var hideSuit:Boolean;
			var suit:int
			if(styleArray.length>5)
			{
				hideSuit = Boolean(parseInt(styleArray[5]));
				suit = parseInt(styleArray[6]);
				if(!hideSuit && suit != 0)
				{
					cloth = suit;
				}
			}
			player.updateStyle(cloth,weapon,mounts,wing,strengthLevel,mStrengthLevel,hideSuit,true);
		}
		
		public static function readDetailPlayer(player:DetailPlayerInfo,data:XML):void
		{
			readFigurePlayer(player,data);
			player.fight = parseInt(data.@fighting_effect); 
		}
		
		public static function readItem(itemInfo:ItemInfo,data:XML):void
		{
			itemInfo.isBind = Boolean(parseInt(data.@is_bind));
			itemInfo.strengthenLevel = parseInt(data.@strengthen_level);
			itemInfo.count = parseInt(data.@amount);
			itemInfo.place = parseInt(data.@place);
			itemInfo.state = parseInt(data.@state);
			itemInfo.durable = parseInt(data.@durable);
			itemInfo.enchase1 = parseInt(data.@enchase1);
			itemInfo.enchase2 = parseInt(data.@enchase2);
			itemInfo.enchase3 = parseInt(data.@enchase3);
			itemInfo.enchase4 = parseInt(data.@enchase4);
			itemInfo.enchase5 = parseInt(data.@enchase5);
			itemInfo.itemId = parseFloat(data.@id);
			itemInfo.templateId = parseInt(data.@template_id);
			itemInfo.freePropertyVector = PackageUtil.parseProperty(data.@data);
		}
	}
}