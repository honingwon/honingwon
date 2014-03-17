/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-11-21 上午11:16:07 
 * 
 */ 
package sszt.core.manager
{
	import flash.text.Font;
	
	import sszt.core.data.GlobalAPI;
	import sszt.interfaces.font.IFontManager;

	public class FontManager implements IFontManager
	{
		public static const EmbedNumberName:String = "number";
//		public static const EmbedSkillName:String = "skillName";
//		public static const EmbedTitleName:String = "title";
//		public static const EmbedBaseName:String = "base";
		
		public function FontManager()
		{
		}
		
		public function registerFont(className:String):void
		{
			var cl:Class =  GlobalAPI.loaderAPI.getClassByPath(className) as Class;
			if (cl != null)
			{
				Font.registerFont(cl);
				traceFonts();
			}
		}
		
		private function traceFonts():void 
		{
			var fonts:Array = Font.enumerateFonts();
			var i:int = -1;
			var n:int = fonts.length;
			while ( ++ i < n ) {
				var font:Font = fonts[ i ];
				trace( font.fontName );
			}
		}
	}
}