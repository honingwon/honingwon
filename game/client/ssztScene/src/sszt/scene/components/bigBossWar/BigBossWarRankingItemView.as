package sszt.scene.components.bigBossWar
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import sszt.scene.data.bigBossWar.BigBossWarRankingItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	public class BigBossWarRankingItemView extends MSprite
	{
		private var _placeLabel:MAssetLabel;
		private var _nickLabel:MAssetLabel;
		private var _damageLabel:MAssetLabel;
		private var _textFormatName:TextFormat;
		private var _textFormatName1:TextFormat;
		private var _textFormatDamage:TextFormat;
		private var _textFormatDamage1:TextFormat;
		
		public function BigBossWarRankingItemView()
		{
			super();
			_textFormatName = new TextFormat("SimSun",11,0xFFfccc);
			_textFormatName1 = new TextFormat("SimSun",11,0x33ff00);
			_textFormatDamage = new TextFormat("SimSun",12,0xFFfccc);
			_textFormatDamage1 = new TextFormat("SimSun",12,0x33ff00);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			
			_placeLabel = new MAssetLabel('-',MAssetLabel.LABEL_TYPE20);
			_placeLabel.move(13,3);
			addChild(_placeLabel);
			
			_nickLabel = new MAssetLabel('-',MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			_nickLabel.move(45,-2);
			addChild(_nickLabel);
			
			_damageLabel = new MAssetLabel('-',MAssetLabel.LABEL_TYPE20,TextFormatAlign.RIGHT);
			_damageLabel.move(185,8);
			addChild(_damageLabel);
		}
		
		public function updateView(info:BigBossWarRankingItemInfo,total:int,nick:String):void
		{
			_placeLabel.setValue(info.place.toString());
			var nickName:String = info.nick;
//			if(nickName.length > 4)
//			{	
//				nickName = info.nick.substr(0,4)+"...";
//			}
			_nickLabel.setValue(nickName);
			var damage:int = info.damage;//10000;
			if(total==0) total =1;
			var str:String = damage +"("+ (info.damage /total * 100).toFixed(2) +"%)";
			_damageLabel.setValue(str);
			if (nick == info.nick)
			{
				_damageLabel.setTextFormat(_textFormatName1);
				_nickLabel.setTextFormat(_textFormatName1);
				_placeLabel.setTextFormat(MAssetLabel.LABEL_TYPE7[0] as TextFormat);
			}
			else
			{
				_damageLabel.setTextFormat(_textFormatName);
				_nickLabel.setTextFormat(_textFormatName);
				_placeLabel.setTextFormat(MAssetLabel.LABEL_TYPE20[0] as TextFormat);				
			}
		}
		
		public function clearView():void
		{
			_placeLabel.setValue('');
			_nickLabel.setValue('');
			_damageLabel.setValue('');
		}
		
		override public function dispose():void
		{
			super.dispose();
			_placeLabel = null;
			_nickLabel = null;
			_nickLabel = null;
		}
	}
}