/**
 * @author lxb
 *  2012-9-12 修改
 */
package sszt.ui.mcache.btns
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import ssztui.ui.BtnAssetClose;
	

	public class MCacheCloseBtn extends MAssetButton
	{
		private static const movies:Array = new Array(1);
		


		public function MCacheCloseBtn()
		{

			super(null);
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = movies[0];
			if(f == null)
			{
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(BtnAssetClose,1,22,22,1,1,1);
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				movies[0] = f;
			}
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
			(_asset as IMovieWrapper).gotoAndStop(2);
		}
	}
}