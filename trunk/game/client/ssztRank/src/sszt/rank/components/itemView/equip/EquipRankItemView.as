package sszt.rank.components.itemView.equip
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
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.ChatPlayerTip;
	import sszt.core.view.tips.TipsUtil;
	import sszt.events.CommonModuleEvent;
	import sszt.module.ModuleEventDispatcher;
	import sszt.rank.components.itemView.RankItemView;
	import sszt.rank.data.item.OtherRankItem;
	
	import ssztui.rank.RankIndex1Asset;
	import ssztui.rank.RankIndex2Asset;
	import ssztui.rank.RankIndex3Asset;
	
	public class EquipRankItemView extends RankItemView
	{
		private var _equipSprite:Sprite;
		private var _rankItemInfo:OtherRankItem;
		private var _topThree:Bitmap;
		
		private var _colWidth:Array = [51,130,174,110];
		
		private var _rankField:TextField;
		private var _equipNameField:TextField;
		private var _nickField:TextField;
		private var _valueField:TextField;
		
		private var _itemTemplateInfo:ItemTemplateInfo;
		
		public function EquipRankItemView(info:OtherRankItem)
		{
			super();
			_rankItemInfo = info;
			
			_itemTemplateInfo = ItemTemplateList.getTemplate(int(_rankItemInfo.itemName));
			
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
			
			_equipNameField = new TextField();
			_equipNameField.selectable = false;
			_equipNameField.x = colX[0]+2;
			_equipNameField.y = 6;
			_equipNameField.width = _colWidth[1];
			_equipNameField.height = 18;
			_equipNameField.defaultTextFormat = format;
			_equipNameField.autoSize = TextFieldAutoSize.CENTER;
			if(_itemTemplateInfo) _equipNameField.htmlText = "<u>"+_itemTemplateInfo.name+"</u>";
			addChild(_equipNameField);
			
			
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
			
			//			var r1:Rectangle = _equipNameField.getCharBoundaries(0);
			//			var r2:Rectangle = _equipNameField.getCharBoundaries(_equipNameField.text.length-1);
			
			_equipSprite = new Sprite();
			_equipSprite.graphics.beginFill(0,0);
			_equipSprite.graphics.drawRect(0,0,_equipNameField.width,16);
			_equipSprite.graphics.endFill();
			_equipSprite.x = _equipNameField.x;
			_equipSprite.y = 5;
			_equipSprite.buttonMode = true;
			_equipSprite.tabEnabled = false;
			addChild(_equipSprite);
		}
		
		private function initEvents():void
		{
			_equipSprite.addEventListener(MouseEvent.CLICK,showTip);
		}
		
		private function removeEvents():void
		{
			_equipSprite.removeEventListener(MouseEvent.CLICK,showTip);
		}
		
		private function showTip(e:MouseEvent):void
		{
			if(_itemTemplateInfo)
			{
				var deployInfo:DeployItemInfo = new DeployItemInfo();
				deployInfo.type = DeployEventType.ITEMTIP
				deployInfo.param1 = _rankItemInfo.userId;
				deployInfo.param2 = _rankItemInfo.itemId;
				deployInfo.param3 = _itemTemplateInfo.templateId;
				
				if(deployInfo.type == DeployEventType.ITEMTIP)
				{
					deployInfo.param4 = e.stageX * 100000 + e.stageY;
				}
				
				DeployEventManager.handle(deployInfo);
			}
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
			if(_equipNameField && _equipNameField.parent)
			{
				_equipNameField.parent.removeChild(_equipNameField);
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
			_equipNameField = null;
			_nickField = null;
			_valueField = null;
			
			_rankItemInfo = null;
			super.dispose();
		}
		
	}
}