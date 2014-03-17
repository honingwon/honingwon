/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-28 上午9:12:48 
 * 
 */ 
package sszt.club.components.clubMain.pop.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.LabelCreator;
	import sszt.ui.UIManager;
	import sszt.ui.button.MSelectButton;
	
	import ssztui.club.ClubBtnAsset2;
	
	public class MClubCacheSelectBtn extends MSelectButton
	{
		private var _img:Bitmap;
		private var _levelText:TextField;
		private var __labelYOffset:int;
		
		
		private static const _movies:Array = new Array(1);
		
		private static const _styles:Array = [
			[new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xF9A54A),new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xF9A54A),null,null]
			
		];
		private static const _classes:Array = [ClubBtnAsset2];
		private static const _sizes:Array = [new Point(106,151)];
		
		private var _type:int;
		
		
		public function MClubCacheSelectBtn(type:int, labelYOffset:int=2,level:String="1/1", label:String="")
		{
			__labelYOffset = labelYOffset;
			_type = type;
			super(null,label);
			selectedTextformat = _styles[_type][0];
			unselectedTextformat = _styles[_type][1];
			selectedFilter = _styles[_type][2];
			unselectedFilter = _styles[_type][3];
			
			_img = new Bitmap(); 
			addChild(_img);
			
			_levelText = LabelCreator.getLabel(level,new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xCEC59D),null,false,TextFieldAutoSize.CENTER);
			_levelText.mouseEnabled = false;
			_levelText.x = 0;
			_levelText.y = 122;
			_levelText.width = 106;
			addChild(_levelText);
		}
		
		
		override protected function createAsset():DisplayObject
		{
			var f:IBDMovieWrapperFactory = _movies[_type];
			if(f == null)
			{
				var param:IRemanceParam = UIManager.movieWrapperApi.getRemanceParam(_classes[_type],2,_sizes[_type].x,_sizes[_type].y,1,1,1);
				f = UIManager.movieWrapperApi.getBDMovieWrapperFactory(param);
				_movies[_type] = f;
			}
			return f.getMovie() as DisplayObject;
		}

		
		override public function updateStyle():void
		{
			if(_selected)
			{
				assetWrap.gotoAndStop(2);
				if(_label)
				{
					_label.setTextFormat(selectedTextformat);
					_label.filters = selectedFilter;
				}
			}
			else
			{
				assetWrap.gotoAndStop(1);
				if(_label)
				{
					_label.setTextFormat(unselectedTextformat);
					_label.filters = unselectedFilter;
				}
			}
		}
				
		
		override protected function createLabel(str:String):TextField
		{
			if(str == null)return null;
			var t:TextField = LabelCreator.getLabel(str,null,null,false,TextFieldAutoSize.CENTER);
			t.x = (_asset.width - t.width >> 1) ;
			t.y = __labelYOffset;
			_labelX = t.x;
			_labelY = t.y;
			return t;
		}
		
		
		
		public function setImg(bitmapdata:BitmapData,vx:int = 0,vy:int = 0):void
		{
			_img.bitmapData = bitmapdata;
			_img.x = vx;
			_img.y = vy;
		}
		
		
		public function setLevel(level:String):void
		{
			_levelText.text = "[" + level + "]";
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			_levelText = null;
			if(_img && _img.bitmapData)
			{
				_img.bitmapData.dispose();
				_img = null;
			}
		}
		
		
		
	}
}