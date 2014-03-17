/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-13 上午11:02:55 
 * 
 */ 
package sszt.ui.mcache.btns
{
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import ssztui.ui.*;
	
	public class MCacheAssetBtn2 extends MAssetButton
	{
		private static const _movies:Array = new Array(8);
		
		
		private static const _classes:Array = [
			UpBtnAsset,			//0:Amount lower 
			DownBtnAsset,		//1:Amount Add 
			ModifyBtnAsset,
			PrePageBtnAsset,	//3: Page LeftArrow
			NextPageBtnAsset,	//4: Page RightArrow
			SmallBtnUpAsset,	//5: upArrow 
			UpBtnAsset2,
			AddBtnAsset,
			MiniAddBtnAsset,
			MiniLowBtnAsset,
			SmallBtnAddAsset,	// 10: tree unfold - add
			SmallBtnLowAsset,	// 11: tree reef - low
			SmallBtnDownAsset,	// 12: DownArrow
			SmallBtnMaxAsset	// 13: Amount Max
		];
		
		private var _type:int;
		private static const _sizes:Array = [
			new Point(18,18),
			new Point(18,18),
			new Point(18,18),
			new Point(18,18),
			new Point(18,18),
			new Point(19,18),
			new Point(18,18),
			new Point(16,16),
			new Point(16,10),
			new Point(16,10),
			new Point(18,18),
			new Point(18,18),
			new Point(19,18),
			new Point(18,18)
		];
		
		/**
		 *  
		 * @param type
		 * @param xscaleType
		 * @param label
		 * 
		 */		
		public function MCacheAssetBtn2(type:int)
		{
			_type = type;
			super(null);
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = _movies[_type];
			if(f == null)
			{
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(_classes[_type],2,_sizes[_type].x,_sizes[_type].y);
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				_movies[_type] = f;
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