package sszt.rank.components.itemView.winner
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.DateUtil;
	import sszt.core.view.tips.TipsUtil;
	import sszt.rank.components.RankPanel;
	import sszt.rank.components.itemView.RankItemView;
	import sszt.rank.data.item.ShenMoIslandRankItem;
	
	public class ShenMoIslandRankItemView extends RankItemView
	{
		private var _floorField:TextField;
		private var _roleField:TextField;
		private var _passTimeField:TextField;
		private var _rankItemInfo:ShenMoIslandRankItem;
//		private var _selectShape:Shape;
		
		public function ShenMoIslandRankItemView(info:ShenMoIslandRankItem)
		{
			super();
			_rankItemInfo = info;
			initView();
			initEvents();
		}
		
		private function initView():void
		{		
			var format:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			
			_floorField = new TextField();
			_floorField.selectable = false;
			_floorField.x = 9;
			_floorField.y = 7;
			_floorField.width = 48;
			_floorField.height = 18;
			_floorField.defaultTextFormat = format;
			_floorField.text = LanguageManager.getWord("ssztl.rank.floorNum",_rankItemInfo.stage);
			addChild(_floorField);
			
			_roleField = new TextField();
			_roleField.selectable = false;
			_roleField.x = 62;
			_roleField.y = 7;
			_roleField.width = 261;
			_roleField.height = 18;
			_roleField.defaultTextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xffffff,null,null,null,null,null,TextFormatAlign.CENTER);
			_roleField.text = _rankItemInfo.playersStr;
			addChild(_roleField);
			
			_passTimeField = new TextField();
			_passTimeField.selectable = false;
			_passTimeField.x = 326;
			_passTimeField.y = 7;
			_passTimeField.width = 85;
			_passTimeField.height = 18;
			_passTimeField.defaultTextFormat = format;
			var hours:Number = DateUtil.millisecondsToHours(_rankItemInfo.passTime * 1000);
			var mins:Number = DateUtil.hoursToMinutes(hours % 1);
			var secs:Number = DateUtil.minutesToSeconds(mins % 1);
			var useTimeString:String = "";
			if(hours < 10)
				useTimeString += "0" + int(hours);
			else
				useTimeString += int(hours);
			if(mins < 10)
				useTimeString += ":0" + int(mins);
			else
				useTimeString += ":" + int(mins);
			if(secs < 10)
				useTimeString += ":0" + int(secs);
			else
				useTimeString += ":" + int(secs);
			_passTimeField.text = useTimeString;
			addChild(_passTimeField);
		}
		
		private function initEvents():void
		{
		}
		
		private function removeEvents():void
		{
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_floorField && _floorField.parent)
			{
				_floorField.parent.removeChild(_floorField);
			}
			if(_roleField && _roleField.parent)
			{
				_roleField.parent.removeChild(_roleField);
			}
			if(_passTimeField && _passTimeField.parent)
			{
				_passTimeField.parent.removeChild(_passTimeField);
			}
			if(parent)
			{
				parent.removeChild(this);
			}
			
			_floorField = null;
			_roleField = null;
			_passTimeField = null;
			
			_rankItemInfo = null;
			super.dispose();
		}

	}
}