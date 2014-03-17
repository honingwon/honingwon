package sszt.rank.components.itemView.pvp
{
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.rank.components.itemView.RankItemView;
	import sszt.rank.data.item.OtherRankItem;
	
	import ssztui.rank.RankIndex1Asset;
	import ssztui.rank.RankIndex2Asset;
	import ssztui.rank.RankIndex3Asset;
	
	public class PVPRankItemView extends RankItemView
	{
		private var _rankField:TextField;
		private var _roleField:TextField;
		private var _roleSprite:Sprite;
		private var _careerField:TextField;
		private var _clubField:TextField;
		private var _valueField:TextField;
		private var _rankItemInfo:OtherRankItem;
		private var _topThree:Bitmap;
		
		private var _colWidth:Array = [51,130,60,114,110];
		
		public function PVPRankItemView(info:OtherRankItem)
		{
			super();
			_rankItemInfo = info;
			initView();
			initEvents();
		}
		
		private function initView():void
		{
			var colX:Array = [];
			for(var i:int=0; i<_colWidth.length; i++)
			{
				colX.push(i>0?colX[i-1]+_colWidth[i]:_colWidth[0]+i*2);
			}
			
			var clickBg:Shape = new Shape();
			clickBg.graphics.beginFill(0,0);
			clickBg.graphics.drawRect(0,0,475,28);
			clickBg.graphics.endFill();
			addChild(clickBg);
			
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFCCC,null,null,null,null,null,TextFormatAlign.CENTER);
			
			_rankField = new TextField();
			_rankField.selectable = false;
			_rankField.x = 0;
			_rankField.y = 6;
			_rankField.width = _colWidth[0];
			_rankField.height = 18;
			_rankField.defaultTextFormat = format;
			addChild(_rankField);
			
			_topThree = new Bitmap();
			_topThree.x = Math.round((_colWidth[0]-40)/2);
			_topThree.y = 7;
			addChild(_topThree);
			
			if(_rankItemInfo.place > 3)
				_rankField.text = _rankItemInfo.place.toString();
			else if(_rankItemInfo.place >2 )
				_topThree.bitmapData = new RankIndex3Asset();
			else if(_rankItemInfo.place >1 )
				_topThree.bitmapData = new RankIndex2Asset();
			else if(_rankItemInfo.place >0 )
				_topThree.bitmapData = new RankIndex1Asset();
			
			_roleField = new TextField();
			_roleField.selectable = false;
			_roleField.x = colX[0]+2;
			_roleField.y = 6;
			_roleField.width = _colWidth[1];
			_roleField.height = 18;
			_roleField.defaultTextFormat = format;
			_roleField.autoSize = TextFieldAutoSize.CENTER;
//			_roleField.htmlText = "<u>"+_rankItemInfo.userName+"</u>";
			addChild(_roleField);
			
			
			_careerField = new TextField();
			_careerField.selectable = false;
			_careerField.x = colX[1]+2;
			_careerField.y = 6;
			_careerField.width = _colWidth[2];
			_careerField.height = 18;
			_careerField.defaultTextFormat = format;
			var careerWordId:String;
//			switch(_rankItemInfo.career)
//			{
//				case 1 : 
//					careerWordId = 'ssztl.common.yuewangzong';
//					_careerField.textColor = 0x539fff;
//					break;
//				case 3 : 
//					careerWordId = 'ssztl.common.tangmen';
//					_careerField.textColor = 0x56cc00;
//					break;
//				case 2 : 
//					careerWordId = 'ssztl.common.baihuagu';
//					_careerField.textColor = 0xff526b;
//					break;
//			}
			_careerField.text = LanguageManager.getWord(careerWordId);
			addChild(_careerField);
			
			_clubField = new TextField();
			_clubField.selectable = false;
			_clubField.x = colX[2]+2;
			_clubField.y = 6;
			_clubField.width = _colWidth[3];
			_clubField.height = 18;
			_clubField.defaultTextFormat = format;
//			if(!_rankItemInfo.guildName)
//			{
//				_clubField.text = LanguageManager.getWord("ssztl.common.none");
//			}
//			else
//			{
//				_clubField.text = _rankItemInfo.guildName;
//			}
			addChild(_clubField);
			
			_valueField = new TextField();
			_valueField.selectable = false;
			_valueField.x = colX[3]+2;
			_valueField.y = 6;
			_valueField.width = _colWidth[4];
			_valueField.height = 18;
			_valueField.defaultTextFormat = format;
			_valueField.textColor = 0xfaf53d;
			_valueField.text = _rankItemInfo.value.toString();
			addChild(_valueField);
			
			
			_roleSprite = new Sprite();
			_roleSprite.graphics.beginFill(0,0);
			_roleSprite.graphics.drawRect(0,0,_roleField.width,16);
			_roleSprite.graphics.endFill();
			_roleSprite.x = _roleField.x;
			_roleSprite.y = 5;
			_roleSprite.buttonMode = true;
			_roleSprite.tabEnabled = false;
			addChild(_roleSprite);
		}
		
		private function initEvents():void
		{
			_roleSprite.addEventListener(MouseEvent.CLICK,showTip);
		}
		
		private function removeEvents():void
		{
			_roleSprite.removeEventListener(MouseEvent.CLICK,showTip);
		}
		
		private function showTip(evt:MouseEvent):void
		{
//			ChatPlayerTip.getInstance().show(0,_rankItemInfo.userId,_rankItemInfo.userName,new Point(evt.stageX,evt.stageY));
		}
		
		override public function set select(value:Boolean):void
		{
			_select = value;
			if(_select)
			{
				addChildAt(SELECTED_BITMAP,0);
				ModuleEventDispatcher.dispatchCommonModuleEvent(new CommonModuleEvent(CommonModuleEvent.RANK_ITEM_CHANGE,_rankItemInfo));
			}
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_rankField && _rankField.parent)
			{
				_rankField.parent.removeChild(_rankField);
			}
			if(_roleField && _roleField.parent)
			{
				_roleField.parent.removeChild(_roleField);
			}
			if(_clubField && _clubField.parent)
			{
				_clubField.parent.removeChild(_clubField);
			}
			if(_valueField && _valueField.parent)
			{
				_valueField.parent.removeChild(_valueField);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			if(_topThree && _topThree.bitmapData)
			{
				_topThree.bitmapData.dispose();
				_topThree = null;
			}
			
			_rankField = null;
			_roleField = null;
			_careerField = null;
			_clubField= null;
			_valueField = null;
			
			_rankItemInfo = null;
			super.dispose();
		}
		
	}
}