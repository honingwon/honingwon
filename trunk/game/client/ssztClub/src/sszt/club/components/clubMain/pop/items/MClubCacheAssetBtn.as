/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-9-27 下午5:21:52 
 * 
 */ 
package sszt.club.components.clubMain.pop.items
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IBDMovieWrapperFactory;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.interfaces.moviewrapper.IRemanceParam;
	import sszt.ui.LabelCreator;
	import sszt.ui.UIManager;
	import sszt.ui.button.MAssetButton;
	
	import ssztui.club.ClubBtnAsset1;
	import ssztui.club.ClubLevelIconAsset;
	
	
	public class MClubCacheAssetBtn extends MAssetButton
	{
		private var _img:Bitmap;
		
		private static const _movies:Array = new Array(2);
		protected var _selectedTextFormat:TextFormat;
		protected var _unselectedTextFormat:TextFormat;
		protected var _selctedFilter:Array;
		protected var _unselectedFileter:Array;
		
		private static const _styles:Array = [
			[new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xF9A54A),new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xF9A54A),null,null]
			
		];
		
		public static const SELECTED_TEXTFORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xff0000);
		public static const UNSELECTED_TEXTFORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0x00FF00);
		
		private static const _classes:Array = [ClubBtnAsset1];
		private static const _sizes:Array = [new Point(72,94)];
		
		private static const _levelIconBitmapdata:BitmapData = new ClubLevelIconAsset();
		
		private var _levelIcon:Bitmap;
		private var _type:int;
		private var _levelText:TextField;
		private var _imgX:int;
		private var _imgY:int;
		
		
		public function MClubCacheAssetBtn(type:int,labelYOffset:int,isShowLevel:Boolean = false,level:int = 0,label:String = "")
		{
			_type = type;
			super(null,label,-1,-1,1,1,null,0,labelYOffset);
			_img = new Bitmap(); 
			addChild(_img);
			if(isShowLevel)
			{
				_levelIcon = new Bitmap( _levelIconBitmapdata);
				_levelIcon.x = 5;
				_levelIcon.y = 4;
				_levelText = LabelCreator.getLabel(level.toString(),new TextFormat(LanguageManager.getWord("ssztl.club.wordType"),12,0xffffff),null,false,TextFieldAutoSize.CENTER);
				_levelText.mouseEnabled = false;
				_levelText.x = 8;
				_levelText.y = 8;
				addChild(_levelIcon);
				addChild(_levelText);
			}
			
			selectedTextformat = _styles[_type][0];
			unselectedTextformat = _styles[_type][1];
			selectedFilter = _styles[_type][2];
			unselectedFilter = _styles[_type][3];
			
			_label.setTextFormat(unselectedTextformat);
			_label.filters = unselectedFilter;
		}
		
		
		override protected function createLabel(str:String):TextField
		{
			if(str == null)return null;
			var t:TextField = LabelCreator.getLabel(str,null,null,false,TextFieldAutoSize.CENTER);
			t.x = (_asset.width - t.width >> 1) ;
			t.y = _labelYOffset;
			_labelX = t.x;
			_labelY = t.y;
			return t;
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
		
		
		
		public function set selectedTextformat(value:TextFormat):void
		{
			_selectedTextFormat = value;
		}
		public function get selectedTextformat():TextFormat
		{
			if(_selectedTextFormat == null)return SELECTED_TEXTFORMAT;
			return _selectedTextFormat;
		}
		
		public function set unselectedTextformat(value:TextFormat):void
		{
			_unselectedTextFormat = value;
		}
		public function get unselectedTextformat():TextFormat
		{
			if(_unselectedTextFormat == null)return UNSELECTED_TEXTFORMAT;
			return _unselectedTextFormat;
		}
		
		public function set selectedFilter(value:Array):void
		{
			_selctedFilter = value;
		}
		public function get selectedFilter():Array
		{
			return _selctedFilter;
		}
		
		public function set unselectedFilter(value:Array):void
		{
			_unselectedFileter = value;
		}
		public function get unselectedFilter():Array
		{
			return _unselectedFileter;
		}
		
		
		
		override protected function overHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(2);
			_label.setTextFormat(selectedTextformat);
			_label.filters = selectedFilter;
		}
		
		override protected function outHandler(evt:MouseEvent):void
		{
			(_asset as IMovieWrapper).gotoAndStop(1);
			_label.setTextFormat(unselectedTextformat);
			_label.filters = unselectedFilter;
			
		}
		
		override protected function downHandler(evt:MouseEvent):void
		{
			if(_asset)
				_asset.x = _asset.y = 1;
			if(_label)
			{
				_label.x = _labelX + 1;
				_label.y = _labelY + 1;
			}
			if(_levelIcon)
			{
				_levelIcon.x = 5 + 1;
				_levelIcon.y = 4 + 1;
			}
			if(_levelText)
			{
				_levelText.x = 8 + 1;
				_levelText.y = 8 + 1;
			}
			if(_img)
			{
				_img.x = _imgX + 1 ;
				_img.y = _imgY + 1;
			}
			if(stage)stage.addEventListener(MouseEvent.MOUSE_UP,upHandler,false,0,true);
		}
		override protected function upHandler(evt:MouseEvent):void
		{
			if(_asset)
				_asset.x = _asset.y = 0;
			if(_label)
			{
				_label.x = _labelX;
				_label.y = _labelY;
			}
			
			if(_levelIcon)
			{
				_levelIcon.x = 5 ;
				_levelIcon.y = 4;
			}
			if(_levelText)
			{
				_levelText.x = 8 ;
				_levelText.y = 8 ;
			}
			if(_img)
			{
				_img.x = _imgX ;
				_img.y = _imgY;
			}
			
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP,upHandler);
		}
		
		
		public function setImg(bitmapdata:BitmapData,vx:int = 0,vy:int = 0):void
		{
			_img.bitmapData = bitmapdata;
			_img.x = vx;
			_img.y = vy;
			_imgX = vx;
			_imgY = vy;
		}
		
		
		public function setLevel(level:int):void
		{
			_levelText.text = level.toString();
		}
		
		
		override public function dispose():void
		{
			super.dispose();
			_levelText = null;
			if(_levelIcon)
			{
				_levelIcon = null;
			}
			if(_img && _img.bitmapData)
			{
				_img.bitmapData.dispose();
				_img = null;
			}
		}
		
		
	}
}