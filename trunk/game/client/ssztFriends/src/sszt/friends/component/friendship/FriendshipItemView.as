package sszt.friends.component.friendship
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.core.data.friendship.FriendshipTemplateInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.friends.HeartIconAsset;
	
	/**
	 * 好友度各个等级 
	 * @author chendong
	 * 
	 */	
	public class FriendshipItemView extends Sprite implements IPanel
	{
		/**
		 * 好友度等级名称  点头之交
		 */
		private var _nameLable:MAssetLabel;
		
		/**
		 * 红心图片 
		 */
		private var _redStar:Bitmap
		
		/**
		 * 好友度等级值  0-999
		 */
		private var _valueLable:MAssetLabel;
		
		/**
		 * 属性奖励
		 */
		private var _attributeLable:MAssetLabel;
		
		private var _info:FriendshipTemplateInfo; 
		private var _tipBox:Sprite;
		
		public function FriendshipItemView(info:FriendshipTemplateInfo)
		{
			super();
			_info = info;
			initView();
			initEvent();
			initData();
		}
		
		public function clearData():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function initData():void
		{
			// TODO Auto Generated method stub
			_nameLable.setValue(_info.name);
			_valueLable.setValue(getNearValue(_info.level));
			_attributeLable.setHtmlValue("<a href=\'event:0\'><u>"+ LanguageManager.getWord("ssztl.friends.nearValue7") +"</u></a>");
		}
		
		private function getNearValue(nearLevel:int):String
		{
			var nearValue:String = LanguageManager.getWord("ssztl.friends.nearValue1");
			if(nearLevel == 1)
			{
				nearValue = LanguageManager.getWord("ssztl.friends.nearValue1");
			}
			if(nearLevel == 2)
			{
				nearValue = LanguageManager.getWord("ssztl.friends.nearValue2");
			}
			else if(nearLevel == 3)
			{
				nearValue = LanguageManager.getWord("ssztl.friends.nearValue3");
			}
			else if(nearLevel == 4)
			{
				nearValue = LanguageManager.getWord("ssztl.friends.nearValue4");
			}
			else if(nearLevel == 5)
			{
				nearValue = LanguageManager.getWord("ssztl.friends.nearValue5");
			}
			else if(nearLevel == 6)
			{
				nearValue = LanguageManager.getWord("ssztl.friends.nearValue6");
			}
			return nearValue;
		}
		
		public function initEvent():void
		{
			// TODO Auto Generated method stub
			_tipBox.addEventListener(MouseEvent.MOUSE_OVER,attributeLableOver);
			_tipBox.addEventListener(MouseEvent.MOUSE_OUT,attributeLableOut);
		}
		
		public function initView():void
		{
			// TODO Auto Generated method stub
			_nameLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE22, TextFormatAlign.LEFT);
			_nameLable.move(5,7);
			addChild(_nameLable);
			
			
			_redStar = new Bitmap(new HeartIconAsset());
			_redStar.width = _redStar.height = 16;
			_redStar.x = 70;
			_redStar.y = 6;
			addChild(_redStar);
			
			_valueLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
			_valueLable.move(90,7);
			addChild(_valueLable);
			
			_attributeLable = new MAssetLabel("", MAssetLabel.LABEL_TYPE7, TextFormatAlign.LEFT);
			_attributeLable.move(170,7);
			addChild(_attributeLable);
			
			_tipBox = new Sprite();
			_tipBox.graphics.beginFill(0,0);
			_tipBox.graphics.drawRect(168,6,55,17);
			_tipBox.graphics.endFill();
			addChild(_tipBox);
		}
		
		
		private function attributeLableOver(evt:MouseEvent):void
		{
			var tip:String = LanguageManager.getWord("ssztl.rank.strikeValue") + "：+"+ _info.awardValueArray[0];
			TipsUtil.getInstance().show(tip,null,new Rectangle(evt.stageX,evt.stageY,0,0));
		}
		
		private function attributeLableOut(evt:MouseEvent):void
		{
			TipsUtil.getInstance().hide();
		}
		
		public function move(x:Number, y:Number):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function removeEvent():void
		{
			// TODO Auto Generated method stub
			_tipBox.removeEventListener(MouseEvent.MOUSE_OVER,attributeLableOver);
			_tipBox.removeEventListener(MouseEvent.MOUSE_OUT,attributeLableOut);
		}
		
		public function dispose():void
		{
			// TODO Auto Generated method stub
			removeEvent();
			_nameLable = null;
			_redStar = null;
			_valueLable = null;
			_attributeLable = null;
			if(_tipBox && _tipBox.parent)
			{
				_tipBox.graphics.clear();
				_tipBox.parent.removeChild(_tipBox);
				_tipBox = null;
			}
			_info = null;
		}
	}
}