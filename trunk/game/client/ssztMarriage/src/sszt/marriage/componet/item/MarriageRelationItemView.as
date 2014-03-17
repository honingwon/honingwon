package sszt.marriage.componet.item
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	
	import sszt.constData.CareerType;
	import sszt.constData.MarryRelationType;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.marriage.data.MarriageRelationItemInfo;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	
	import ssztui.marriage.HeadBallBgAsset;
	import ssztui.marriage.IconFootingAsset1;
	import ssztui.marriage.IconFootingAsset2;
	import ssztui.marriage.IconFootingAsset3;
	
	public class MarriageRelationItemView extends MSprite
	{
		private var _data:MarriageRelationItemInfo;
		private var _headAsset:Array;
		private var _highlight:Boolean;
		
		private var _nickLabel:MAssetLabel;
		private var _avatar:Bitmap;
		
		private var _divorceBtn:MCacheAssetBtn1;
		private var _upgradeBtn:MCacheAssetBtn1;
		
		private var _divorceHandler:Function;
		private var _upgradeHandler:Function;
		
		private var _footing:Bitmap;
		private var _headBg:Bitmap;
		
		public function MarriageRelationItemView(data:MarriageRelationItemInfo)
		{
			_headAsset = [];
			_headAsset.push(AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset1") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset2") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset3") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset4") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset5") as BitmapData,
				AssetUtil.getAsset("ssztui.scene.PlayerHeadAsset6") as BitmapData);
			
			_data = data;
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_headBg = new Bitmap(new HeadBallBgAsset());
			_headBg.x = 21;
			_headBg.y = 15;
			addChild(_headBg);
			
			_avatar = new Bitmap(_headAsset[CareerType.getHeadByCareerSex(_data.career,Boolean(_data.sex))]);
			_avatar.x = 28;
			_avatar.y = 7;
			addChild(_avatar);
			
			_nickLabel = new MAssetLabel(_data.nick,MAssetLabel.LABEL_TYPE20,'left');
			_nickLabel.move(129,50);
			addChild(_nickLabel);
			
			_footing = new Bitmap();
			_footing.x = 15;
			_footing.y = 77;
			addChild(_footing);
			
			switch(_data.type)
			{
				case MarryRelationType.HUSBAND:
				{
					_footing.bitmapData = new IconFootingAsset1() as BitmapData;
//					marryRelationStr = 'HUSBAND';
					break;
				}
				case MarryRelationType.WIFE:
				{
					_footing.bitmapData = new IconFootingAsset2() as BitmapData;
//					marryRelationStr = 'WIFE';
					break;
				}
				case MarryRelationType.CONCUBINE:
				{
					_footing.bitmapData = new IconFootingAsset3() as BitmapData;
//					marryRelationStr = 'CONCUBINE';
					break;
				}
			}
			
		}
		
		/**
		 * 更新其他成员可操作按钮状态
		 * */
		public function updateBtnState(myMarryRelationType:int,divorceHandler:Function,upgradeHandler:Function):void
		{
			_divorceHandler = divorceHandler;
			_upgradeHandler = upgradeHandler;
			if(myMarryRelationType == MarryRelationType.HUSBAND)//其他成员为妻子或妾
			{
				_divorceBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marry.divorce'));
				_divorceBtn.move(241,45);
				addChild(_divorceBtn);
				
				if(_data.type == MarryRelationType.CONCUBINE)//如果是妻子只能离婚，小妾还可以升级
				{
					_upgradeBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marry.upgradeFooting'));
					_upgradeBtn.move(241,31);
					_divorceBtn.move(241,59);
					addChild(_upgradeBtn);
				}
			}
			else//其他成员有一是丈夫有一是妻妾
			{
				if(_data.type == MarryRelationType.HUSBAND)//如果是妻妾，无操作，如果是丈夫，那么离婚
				{
					_divorceBtn = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.marry.divorce'));
					_divorceBtn.move(241,45);
					addChild(_divorceBtn);
				}
			}
			initEvent();
		}
		
		private function initEvent():void
		{
			if(_divorceBtn) _divorceBtn.addEventListener(MouseEvent.CLICK,divorceBtnClickHandler);
			if(_upgradeBtn) _upgradeBtn.addEventListener(MouseEvent.CLICK,upgradeBtnBtnClickHandler);
		}
		
		private function removeEvent():void
		{
			if(_divorceBtn) _divorceBtn.removeEventListener(MouseEvent.CLICK,divorceBtnClickHandler);
			if(_upgradeBtn) _upgradeBtn.removeEventListener(MouseEvent.CLICK,upgradeBtnBtnClickHandler);
		}
		
		protected function upgradeBtnBtnClickHandler(event:MouseEvent):void
		{
			_upgradeHandler(_data.userId);
		}
		
		protected function divorceBtnClickHandler(event:MouseEvent):void
		{
			_divorceHandler(_data.userId);
		}
		
		public function set highlight(value:Boolean):void
		{
			if(_highlight == value) return;
			_highlight = value;
			if(_highlight)
			{
//				graphics.beginFill(0xff0000,0.5);
//				graphics.drawRect(0,0,100,400);
//				graphics.endFill();
				_nickLabel.textColor = 0xffcc00;
			}
			else
			{
				_nickLabel.textColor = 0xfffcc;
				graphics.clear();
			}
		}
		
		override public function dispose():void
		{
			removeEvent();
			super.dispose();
			if(_headBg && _headBg.bitmapData)
			{
				_headBg.bitmapData.dispose();
				_headBg = null;
			}
			if(_footing && _footing.bitmapData)
			{
				_footing.bitmapData.dispose();
				_footing = null;
			}
			_data = null;
			_headAsset = null;
			_nickLabel = null;
			_avatar = null;
		}
	}
}