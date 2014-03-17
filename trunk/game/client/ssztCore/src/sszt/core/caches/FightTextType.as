/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-21 上午11:25:20 
 * 
 */ 
package sszt.core.caches
{
	import sszt.core.manager.FontManager;
	import sszt.core.manager.LanguageManager;

	public class FightTextType extends Object
	{
		public var str:String;
		public var isScale:Boolean;
		public var textColor:uint;
		public var textFont:String;
		public var textSize:int;
		public var offsetX:int;
		public var offsetY:int;
		
		public static const _HurtNumber:String = "normalHurtNumber";
		public static const _AddNumber:String = "AddNumber";
		public static const _EffectType:String = "hurtType";
		public static const _SelfHurtNumber:String = "selfHurtNumber";
		public static const _CritHurtNumber:String = "critHurtNumber";
		public static const _MissType:String = "missType";
		public static const _BlockType:String = "blockType";
		
		
		public static const HurtNumber:FightTextType = new FightTextType(_HurtNumber, 0xFFFF00, FontManager.EmbedNumberName, 30);
		public static const AddNumber:FightTextType = new FightTextType(_AddNumber, 0x00FF00, FontManager.EmbedNumberName, 30);
		public static const SelfHurtNumber:FightTextType = new FightTextType(_HurtNumber, 0xFF2323, FontManager.EmbedNumberName, 30);
		public static const CritHurtNumber:FightTextType = new FightTextType(_CritHurtNumber, 0xFF2323, FontManager.EmbedNumberName, 35);
		public static const MissType:FightTextType = new FightTextType(_MissType);
		public static const BlockType:FightTextType = new FightTextType(_BlockType);
		
		
		public function FightTextType(str:String, color:uint = 0xFFD200, textFont:String = "", textSize:int = 35, offsetX:int = 0, offsetY:int = 0)
		{
			this.textFont = LanguageManager.getWord("ssztl.common.wordType");
			super();
			this.str = str;
			this.textColor = color;
			if (textFont){
				this.textFont = textFont;
			}
			this.textSize = textSize;
			this.offsetX = offsetX;
			this.offsetY = offsetY;
		}
		
		public function copyTo(ft:FightTextType) : void
		{
			ft.str = this.str;
			ft.isScale = this.isScale;
			ft.textColor = this.textColor;
			ft.textFont = this.textFont;
			ft.textSize = this.textSize;
			ft.offsetX = this.offsetX;
			ft.offsetY = this.offsetY;
		}
		
		
	}
}