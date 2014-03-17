package sszt.common.vip.component.sec
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	
	import sszt.ui.label.MAssetLabel;
	
	import sszt.common.vip.data.VipPlayerInfo;
	import sszt.constData.CareerType;
	import sszt.core.manager.LanguageManager;
	
	public class VipItemView extends Sprite
	{
		private var _playerInfo:VipPlayerInfo;
		private var _typeLabel:MAssetLabel;
		private var _nameLabel:MAssetLabel;
		private var _levelLabel:MAssetLabel;
		private var _carrerLabel:MAssetLabel;
		private var _addLabel:MAssetLabel;
		private var _addSprite:Sprite;
		private var _nameSprite:Sprite;
		
		public function VipItemView(info:VipPlayerInfo)
		{
			_playerInfo = info;
			super();
			init();
		}
		
		private function init():void
		{
			_typeLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_typeLabel.move(20,6);
			addChild(_typeLabel);
			
			
			_nameLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.CENTER);
			_nameLabel.move(96,6);
			addChild(_nameLabel);
			_nameLabel.htmlText = "<u>[" + _playerInfo.serverId + "]" + _playerInfo.nick + "</u>";
			
			_nameSprite = new Sprite();
			_nameSprite.graphics.beginFill(0,0);
			_nameSprite.graphics.drawRect(96,6,_nameLabel.textWidth,_nameLabel.textHeight);
			_nameSprite.graphics.endFill();
			_nameSprite.buttonMode = true;
			addChild(_nameLabel);
			
			_levelLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_levelLabel.move(172,6);
			addChild(_levelLabel);
//			_levelLabel.setValue(_playerInfo.level + "级");
			_levelLabel.setValue(LanguageManager.getWord("ssztl.common.levelValue"));
			
			_carrerLabel = new MAssetLabel("",MAssetLabel.LABELTYPE1,TextFormatAlign.CENTER);
			_carrerLabel.move(215,6);
			addChild(_carrerLabel);
			_levelLabel.setValue(CareerType.getNameByCareer(_playerInfo.carrer));
			
			_addLabel = new MAssetLabel("",MAssetLabel.LABELTYPE16,TextFormatAlign.CENTER);
			_addLabel.move(271,6);
			addChild(_addLabel);
			_addLabel.setValue(LanguageManager.getWord("ssztl.common.addToFriend"));
			
			_addSprite = new Sprite();
			_addSprite.graphics.beginFill(0,0);
			_addSprite.graphics.drawRect(271,6,_addLabel.textWidth,_addLabel.textHeight);
			_addSprite.graphics.endFill();
			_addSprite.buttonMode = true;
			addChild(_nameLabel);
			
			initEvent();
		}
		
		private function initEvent():void
		{
			_nameSprite.addEventListener(MouseEvent.CLICK,nameClickHandler);
			_addSprite.addEventListener(MouseEvent.CLICK,addClickHandler);
		}
		
		private function removeEvent():void
		{
			_nameSprite.removeEventListener(MouseEvent.CLICK,nameClickHandler);
			_addSprite.removeEventListener(MouseEvent.CLICK,addClickHandler);
		}
		
		private function nameClickHandler(evt:MouseEvent):void
		{
			
		}
		
		private function addClickHandler(evt:MouseEvent):void
		{
			
		}
		
		public function dispose():void
		{
			removeEvent();
			_playerInfo = null;
			_typeLabel = null;
			_nameLabel = null;
			_levelLabel = null;
			_carrerLabel = null;
			_addLabel = null;
			_addSprite = null;
			_nameSprite = null;			
			if(parent) parent.removeChild(this);
		}
	}
}