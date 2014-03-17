/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-13 上午11:02:55 
 * 
 */ 
package sszt.skill.components.items
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
	
	import ssztui.skill.SkillUpgradeBtnAsset;
	
	
	public class MSkillCacheAssetBtn extends MAssetButton
	{
		private static const _movies:Array = [new Array(1)];
		
		private static const _scale9Grids:Array = [
			new Rectangle(10,10,25,5)
		];
		private static const _xscales:Array = [[1]];
		private static const _labelYOffsets:Array = [1];
		
		private static const _styles:Array = [
			[new TextFormat("宋体",12,0xDAB956),[new GlowFilter(0x000000,1,3,3,8)]]
		];
		private static const _classes:Array = [SkillUpgradeBtnAsset];
		private static const _sizes:Array = [new Point(37,42)];
		
		private var _type:int;
		private var _xscaleType:int;
		
		
		/**
		 *  
		 * @param type
		 * @param xscaleType
		 * @param label
		 * 
		 */		
		public function MSkillCacheAssetBtn(type:int,xscaleType:int,label:String = "")
		{
			_type = type;
			_xscaleType = xscaleType;
			if(_xscaleType < 0)_xscaleType = 0;
			else if(_xscaleType > (_xscales[type].length - 1))_xscaleType = _xscales[_type].length - 1;
			super(null,label);
			labelField.defaultTextFormat = _styles[_type][0];
			labelField.setTextFormat(_styles[_type][0]);
			labelField.filters = _styles[_type][1];
			
		}
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = _movies[_type][_xscaleType];
			if(f == null)
			{
				var xscale:Number = _xscales[_type][_xscaleType];
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(_classes[_type],2,_sizes[_type].x,_sizes[_type].y,1,xscale,1);
				if(xscale != 1)param.scale9Grid = _scale9Grids[_type];
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				_movies[_type][_xscaleType] = f;
			}
			return f.getMovie() as DisplayObject;
		}
		
		override protected function createLabel(str:String):TextField
		{
			_labelYOffset = _labelYOffsets[_type];
			return super.createLabel(str);
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