package sszt.core.caches
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import sszt.constData.AttackTargetResultType;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.tick.ITick;
	import sszt.ui.container.MSprite;

	public class NumberCache
	{
//		private static var _redNumberSource:Array = [];
//		
//		private static var _greenNumberSource:Array = [];
//		
//		private static var _yellowNumberSource:Array = [];
		
		private static var _criticalAsset:BitmapData;
		private static var _missAsset:BitmapData;
		private static var _blockAsset:BitmapData;
		private static var _hitDownAsset:BitmapData;
		private static var _deadAsset:BitmapData;
		
		public static function setup():void
		{
//			_redNumberSource = [AssetUtil.getAsset("mhsm.common.RedNumAsset0",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset1",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset2",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset3",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset4",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset5",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset6",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset7",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset8",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedNumAsset9",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedAddAsset",BitmapData),
//				AssetUtil.getAsset("mhsm.common.RedSubAsset",BitmapData)
//			];
//			_greenNumberSource = [
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset0",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset1",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset2",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset3",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset4",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset5",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset6",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset7",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset8",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenNumAsset9",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenAddAsset",BitmapData),
//				AssetUtil.getAsset("mhsm.common.GreenSubAsset",BitmapData)
//			]
//			_yellowNumberSource = [
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset0",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset1",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset2",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset3",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset4",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset5",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset6",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset7",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset8",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowNumAsset9",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowAddAsset",BitmapData),
//				AssetUtil.getAsset("mhsm.common.YellowSubAsset",BitmapData)
//			];
			_criticalAsset = AssetUtil.getAsset("ssztui.common.CriticalAsset",BitmapData) as BitmapData;
			_missAsset = AssetUtil.getAsset("ssztui.common.MissAsset",BitmapData) as BitmapData;
			_blockAsset = AssetUtil.getAsset("ssztui.common.BlockAsset",BitmapData) as BitmapData;
			_hitDownAsset = AssetUtil.getAsset("ssztui.common.HitDownAsset",BitmapData) as BitmapData;
			_deadAsset = AssetUtil.getAsset("ssztui.common.DeadAsset",BitmapData) as BitmapData;
		}
		
		public static function getNumber(value:int,_fightTextType:FightTextType):MSprite
		{
			var str:String = value < 0 ? "-" : "+";
			str = str + Math.abs(value).toString();
			var sp:MSprite = new MSprite();
			
			var bmp:Bitmap;
			if(_fightTextType == FightTextType.MissType)
			{
				bmp = new Bitmap(_missAsset);
				bmp.x = sp.width;
				sp.addChild(bmp);
			}
			else if(_fightTextType == FightTextType.BlockType)
			{
				bmp = new Bitmap(_blockAsset);
				bmp.x = sp.width;
				sp.addChild(bmp);
			}
			else if(_fightTextType == FightTextType.CritHurtNumber)
			{
				bmp = new Bitmap(_criticalAsset);
				bmp.x = sp.width;
				sp.addChild(bmp);
			}
			if(value == 0)
			{
				return sp;	
			}
			
			var fightText:FightText = new FightText(str, false, _fightTextType.textColor, _fightTextType.offsetX, 
				_fightTextType.offsetY, _fightTextType.textFont,_fightTextType.textSize);
			fightText.x = sp.width;
			fightText.y = int(sp.height - fightText.height>> 1);
			sp.addChild(fightText);
			
			return sp;		
		}
		
		
		
		
//		public static function getNumber2(type:int):BitmapData
//		{
//			if(type == AttackTargetResultType.CRITICAL)return _criticalAsset;
//			else if(type == AttackTargetResultType.MISS)return _missAsset;
//			else if(type == AttackTargetResultType.BLOCK)return _blockAsset;
//			else if(type == AttackTargetResultType.DEAD)return _deadAsset;
//			else if(type == AttackTargetResultType.HITDOWN)return _hitDownAsset;
//			return null;
//		}
		
//		public static function getNumber(value:int,type:int,color:String = ""):Sprite
//		{
//			var t:String = value.toString();
//			if(value > 0)t = "+" + t;
//			else if(value == 0)t = "";
//			var sp:Sprite = new Sprite();
//			var bmp:Bitmap;
//			if(type == AttackTargetResultType.CRITICAL && _criticalAsset)
//			{
//				bmp = new Bitmap(_criticalAsset);
//				bmp.x = sp.width;
//				sp.addChild(bmp);
//			}
//			else if(type == AttackTargetResultType.MISS && _missAsset)
//			{
//				bmp = new Bitmap(_missAsset);
//				bmp.x = sp.width;
//				sp.addChild(bmp);
//			}
//			else if(type == AttackTargetResultType.BLOCK && _blockAsset)
//			{
//				bmp = new Bitmap(_blockAsset);
//				bmp.x = sp.width;
//				sp.addChild(bmp);
//			}
//			else if(type == AttackTargetResultType.DEAD && _deadAsset)
//			{
//				bmp = new Bitmap(_deadAsset);
//				bmp.x = sp.width;
//				sp.addChild(bmp);
//			}
//			else if(type == AttackTargetResultType.HITDOWN && _hitDownAsset)
//			{
//				bmp = new Bitmap(_hitDownAsset);
//				bmp.x = sp.width;
//				sp.addChild(bmp);
//			}
//			else if(t == "")return sp;
//			var list:Array = getList(type,color);
//			if(list.length == 0)return sp;
//			for(var i:int = 0; i < t.length; i++)
//			{
//				bmp = new Bitmap(list[getIndex(t.charAt(i))]);
//				bmp.x = sp.width;
//				sp.addChild(bmp);
//			}
//			if(type == AttackTargetResultType.CRITICAL)
//			{
//				sp.scaleX = 1.3;
//				sp.scaleY = 1.3;
//			}
//			sp.mouseChildren = sp.mouseEnabled = false;
//			return sp;
//		}
		
//		private static function getIndex(str:String):int
//		{
//			switch(str)
//			{
//				case "0":return 0;
//				case "1":return 1;
//				case "2":return 2;
//				case "3":return 3;
//				case "4":return 4;
//				case "5":return 5;
//				case "6":return 6;
//				case "7":return 7;
//				case "8":return 8;
//				case "9":return 9;
//				case "+":return 10;
//				case "-":return 11;
//			}
//			return 0;
//		}
//		
//		private static function getList(type:int,color:String):Array
//		{
//			switch(type)
//			{
//				case AttackTargetResultType.HIT:
//					if(color == "yellow")return _yellowNumberSource;
//					else return _redNumberSource;
//				case AttackTargetResultType.CRITICAL:
//				case AttackTargetResultType.REDUCE:
//				case AttackTargetResultType.BLOCK:
//					return _redNumberSource;
//				case AttackTargetResultType.EXP:
//				case AttackTargetResultType.ADDMP:
//					return _yellowNumberSource;
//				case AttackTargetResultType.ADDBLOOD:
//					return _greenNumberSource;
//			}
//			return [];
//		}
	}
}