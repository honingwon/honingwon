/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-3-7 上午9:58:35 
 * 
 */ 
package sszt.core.utils
{
	import flash.text.TextField;
	
	import ssztui.ui.TextFieldAsset;

	public class FontTextFieldCreator
	{
		public function FontTextFieldCreator()
		{
		}
		
		public static function getFontTextField():TextField{
			var result:TextField;
			var mc:TextFieldAsset = new TextFieldAsset();
			result = mc.aa;
			result.text = "";
			if (result.parent){
				result.parent.removeChild(result);
			}
			result.mouseEnabled = (result.selectable = false);
			return result;
		}
	}
}