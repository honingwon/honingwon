package sszt.marriage.componet.item
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.marriage.IconHeartAsset;

	public class CloseView extends MSprite
	{
		private var _friendship:int;
		private var _icon:Bitmap;
		private var _txtFriendship:MAssetLabel;
		
		public function CloseView()
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,60,22);
			graphics.endFill();
			
			_icon = new Bitmap(new IconHeartAsset());
			addChild(_icon);
			
			_txtFriendship = new MAssetLabel('0',MAssetLabel.LABEL_TYPE20,'left');
			_txtFriendship.move(25,3);
			addChild(_txtFriendship);
			
			initEvents();
			value = -1;
		}
		private function initEvents():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function removeEvents():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT,outHandler);
		}
		private function overHandler(evt:MouseEvent):void
		{
			var tip:String = 
				LanguageManager.getWord("ssztl.friends.near")+"："+ _friendship + "\n" +
				LanguageManager.getWord("ssztl.friends.nearLevel")+"：" + getNearLevel(_friendship);
			
			TipsUtil.getInstance().show(tip,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		private function outHandler(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		public function set value(value:int):void
		{
			_friendship = value;
			_txtFriendship.setValue(_friendship.toString());
			if(_friendship > -1)
				this.visible = true;
			else
				this.visible = false;
		}
		public function get value():int
		{
			return _friendship;
		}
		private function getNearLevel(nearValue:int):String
		{
			var nearLevel:String = LanguageManager.getWord("ssztl.friends.nearLevel1");
			if(nearValue >= 0 && nearValue < 1000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel1");
			}
			if(nearValue >= 1000 && nearValue < 3000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel2");
			}
			else if(nearValue >= 3000 && nearValue < 7000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel3");
			}
			else if(nearValue >= 7000 && nearValue < 15000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel4");
			}
			else if(nearValue >= 15000 && nearValue < 31000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel5");
			}
			else if(nearValue >= 31000)
			{
				nearLevel = LanguageManager.getWord("ssztl.friends.nearLevel6");
			}
			return nearLevel;
		}
		override public function dispose():void
		{
			removeEvents();
			if(_icon && _icon.bitmapData)
			{
				_icon.bitmapData.dispose();
				_icon = null;
			}
			_txtFriendship = null;
		}
	}
}