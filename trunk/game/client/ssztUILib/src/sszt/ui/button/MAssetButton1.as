/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-20 上午11:40:51 
 * 
 */ 
package sszt.ui.button
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.LabelCreator;

	public class MAssetButton1 extends MAssetButton
	{
		public function MAssetButton1(source:Object,label:String = "")
		{
			super(source,label);
		}
		
		override protected function overHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(2);
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(1);
		}
		override protected function downHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(3);
		}
		
		override protected function upHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(2);
		}
		override protected function createLabel(str:String):TextField
		{
			var tf:TextFormat = new TextFormat("Tahoma",12,0xfffccc);
			if(str == null)return null;
			var t:TextField = LabelCreator.getLabel(str,tf,null,false,TextFieldAutoSize.CENTER);
			t.x = (_asset.width - t.textWidth >> 1)-1;
			t.y = _asset.height - t.textHeight >> 1;
			_labelX = t.x;
			_labelY = t.y;
			return t;
		}
	}
}