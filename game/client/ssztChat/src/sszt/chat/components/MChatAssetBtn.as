/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-18 下午2:18:32 
 * 
 * 适用于只创建一次的
 * 
 */ 
package sszt.chat.components
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import ssztui.chat.*;

	public class MChatAssetBtn extends MAssetButton
	{
		private static const _classes:Array = [SetSizeBtnAsset,ChannelBtnAsset,SendBtnAsset,SetBtnAsset];
		private static const _sizes:Array = [new Point(22,22),new Point(35,29),new Point(37,29),new Point(22,22)];
		private var _type:int;
		public function MChatAssetBtn(type:int,label:String="")
		{
			_type = type;
			super(null,label,-1,-1,-1,-1,null,6,3);
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory;
			var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(_classes[_type],2,_sizes[_type].x,_sizes[_type].y);
			f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
			return f.getMovie() as DisplayObject;
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
			(_asset as IMovieWrapper).gotoAndStop(1);
		}
		
	}
}