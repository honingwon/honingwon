package sszt.rank.components.itemView.copy
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.rank.components.itemView.RankItemView;
	import sszt.rank.data.item.CopyRankItem;
	
	public class MultiClimbingTowerRankItemView extends RankItemView
	{
		private var _rankField:TextField;
		private var _roleField:TextField;
		private var _useTimeField:TextField;
		private var _roleSprite:Sprite;
		
		private var _copyItemInfo:CopyRankItem;
		private var _colWidth:Array = [60, 240, 175];
		
		public function MultiClimbingTowerRankItemView(info:CopyRankItem)
		{
			super();
			_copyItemInfo = info;
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
			
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			
			_rankField = new TextField();
			_rankField.selectable = false;
			_rankField.x = 0;
			_rankField.y = 6;
			_rankField.width = _colWidth[0];
			_rankField.height = 18;
			_rankField.defaultTextFormat = format;
			_rankField.text = _copyItemInfo.passId.toString();
			addChild(_rankField);
			
			_roleField = new TextField();
			_roleField.selectable = false;
			_roleField.x = colX[0]+2;
			_roleField.y = 6;
			_roleField.width = _colWidth[1];
			_roleField.height = 18;
			_roleField.defaultTextFormat = format;
			_roleField.autoSize = TextFieldAutoSize.CENTER;
			_roleField.htmlText = getUsesName();
			addChild(_roleField);
			
			_useTimeField = new TextField();
			_useTimeField.selectable = false;
			_useTimeField.x = colX[1]+2;
			_useTimeField.y = 6;
			_useTimeField.width = _colWidth[2];
			_useTimeField.height = 18;
			_useTimeField.defaultTextFormat = format;
			_useTimeField.autoSize = TextFieldAutoSize.CENTER;
			_useTimeField.text = _copyItemInfo.timeUsedStr;
			addChild(_useTimeField);
			
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
//			_roleSprite.addEventListener(MouseEvent.CLICK,showTip);
		}
		
		private function removeEvents():void
		{
//			_roleSprite.removeEventListener(MouseEvent.CLICK,showTip);
		}
		
		private function showTip(evt:MouseEvent):void
		{
//			ChatPlayerTip.getInstance().show(0,_copyItemInfo.users[0].id,_copyItemInfo.users[0].name,new Point(evt.stageX,evt.stageY));
		}
		
		private function getUsesName():String
		{
			var str:String = '';
			for each(var i:Object in _copyItemInfo.users)
			{
				str += i['name'] + ' ';
			}
			return str;
		}
		
		override public function dispose():void
		{
			if(_rankField && _rankField.parent)
			{
				_rankField.parent.removeChild(_rankField);
			}
			if(_roleField && _roleField.parent)
			{
				_roleField.parent.removeChild(_roleField);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			
			_rankField = null;
			_roleField = null;
			
			_copyItemInfo = null;
			super.dispose();
		}
	}
}