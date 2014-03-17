package sszt.rank.components.itemView.pet
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
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.deploys.DeployEventManager;
	import sszt.core.data.deploys.DeployEventType;
	import sszt.core.data.deploys.DeployItemInfo;
	import sszt.core.data.item.ItemTemplateInfo;
	import sszt.core.data.item.ItemTemplateList;
	import sszt.core.data.module.changeInfos.ToPetData;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.SetModuleUtils;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.rank.components.itemView.RankItemView;
	import sszt.rank.data.item.OtherRankItem;
	
	import ssztui.rank.RankIndex1Asset;
	import ssztui.rank.RankIndex2Asset;
	import ssztui.rank.RankIndex3Asset;
	
	public class PetFightRankItemView extends RankItemView
	{
		private var _equipSprite:Sprite;
		private var _rankItemInfo:OtherRankItem;
		private var _topThree:Bitmap;
		
		private var _colWidth:Array = [51,130,174,110];
		
		private var _rankField:TextField;
		private var _petNameField:TextField;
		private var _nickField:TextField;
		private var _valueField:TextField;
		
		public function PetFightRankItemView(info:OtherRankItem)
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
			
			_petNameField = new TextField();
			_petNameField.selectable = false;
			_petNameField.x = colX[0]+2;
			_petNameField.y = 6;
			_petNameField.width = _colWidth[1];
			_petNameField.height = 18;
			_petNameField.defaultTextFormat = format;
			_petNameField.autoSize = TextFieldAutoSize.CENTER;
			_petNameField.htmlText = "<u>"+_rankItemInfo.itemName+"</u>";
			addChild(_petNameField);
			
			
			_nickField = new TextField();
			_nickField.selectable = false;
			_nickField.x = colX[1]+2;
			_nickField.y = 6;
			_nickField.width = _colWidth[2];
			_nickField.height = 18;
			_nickField.defaultTextFormat = format;
			_nickField.text = _rankItemInfo.nick;
			addChild(_nickField);
			
			
			_valueField = new TextField();
			_valueField.selectable = false;
			_valueField.x = colX[2]+2;
			_valueField.y = 6;
			_valueField.width = _colWidth[4];
			_valueField.height = 18;
			_valueField.defaultTextFormat = format;
			_valueField.textColor = 0xfaf53d;
			_valueField.text = _rankItemInfo.value.toString();
			addChild(_valueField);
			
			//			var r1:Rectangle = _petNameField.getCharBoundaries(0);
			//			var r2:Rectangle = _petNameField.getCharBoundaries(_petNameField.text.length-1);
			
			_equipSprite = new Sprite();
			_equipSprite.graphics.beginFill(0,0);
			_equipSprite.graphics.drawRect(0,0,_petNameField.width,16);
			_equipSprite.graphics.endFill();
			_equipSprite.x = _petNameField.x;
			_equipSprite.y = 5;
			_equipSprite.buttonMode = true;
			_equipSprite.tabEnabled = false;
			addChild(_equipSprite);
		}
		
		private function initEvents():void
		{
			_equipSprite.addEventListener(MouseEvent.CLICK,showPanel);
		}
		
		private function removeEvents():void
		{
			_equipSprite.removeEventListener(MouseEvent.CLICK,showPanel);
		}
		
		private function showPanel(e:MouseEvent):void
		{
			SetModuleUtils.addPet(
				new ToPetData(0, 2, _rankItemInfo.itemId, _rankItemInfo.userId)
			);
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
			if(_petNameField && _petNameField.parent)
			{
				_petNameField.parent.removeChild(_petNameField);
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
			_petNameField = null;
			_nickField = null;
			_valueField = null;
			
			_rankItemInfo = null;
			super.dispose();
		}
		
	}
}