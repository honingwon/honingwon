package sszt.challenge.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.challenge.ChallengeTemplateListInfo;
	import sszt.interfaces.panel.IPanel;
	import sszt.ui.container.MAlert;
	import sszt.ui.container.MSprite;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.challenge.IconBallBgAsset;
	import ssztui.challenge.IconBallSelectedAsset;
	import ssztui.challenge.IconLockAsset;
	import ssztui.challenge.IconStarAsset;
	import ssztui.challenge.ItemNameBgAsset;
	import ssztui.challenge.ItemPassMarkAsset;
	
	/**
	 * 关卡信息 
	 * @author chendong
	 * 
	 */	
	public class ChallengeItemView extends Sprite implements IPanel
	{
		/**
		 * 关卡背景图片
		 */		
		private var _bg:Bitmap;
		private var _bgName:Bitmap;
		private var _markHead:Bitmap;
		/**
		 * 图片路径 
		 */		
		private var _picPath:String;
		/**
		 * 关卡三星通关显示
		 */
		private var _markThreeStar:Bitmap;
		private var _markName:MAssetLabel;
		/**
		 * 存放星的容器
		 */
		private var _starVes:MSprite;
		/**
		 * 判断是否被选中 
		 */
		private var _selected:Boolean;
		
		/**
		 * 评星等级 
		 */
		private var _starLevel:int;
		
		private var _lockMask:Bitmap;
		
		private var SelectBorder:Bitmap;
		
		private var _preMarkBoolean:Boolean;
		
		private var _challInfo:ChallengeTemplateListInfo;
		
		public function ChallengeItemView(challInfo:ChallengeTemplateListInfo)
		{
			super();
			_challInfo = challInfo;
			initView();
			initEvent();
			initData();
		}
		
		public function initView():void
		{
			buttonMode = true;
			
			_bg = new Bitmap(new IconBallBgAsset());
			_bg.x = 5;
			_bg.y = 9;
			addChild(_bg);
			
			_lockMask = new Bitmap(new IconLockAsset());
			_lockMask.x = 14;
			_lockMask.y = 21;
			addChild(_lockMask);
			
			SelectBorder = new Bitmap(new IconBallSelectedAsset());
			SelectBorder.x = 0;
			SelectBorder.y = 5;
			SelectBorder.visible = false;
			addChild(SelectBorder);
			
			_markHead = new Bitmap();
			_markHead.x = _markHead.y = 0;
			addChild(_markHead);
			_markHead.visible = false;
			
			_bgName = new Bitmap(new ItemNameBgAsset());
			_bgName.x = 25;
			_bgName.y = 89;
			addChild(_bgName);
			
			_markThreeStar = new Bitmap(new ItemPassMarkAsset());
			_markThreeStar.x = 75;
			_markThreeStar.y = 10;
			_markThreeStar.visible = false;
			addChild(_markThreeStar);
			
			_markName = new MAssetLabel("",MAssetLabel.LABEL_TYPE20);
			_markName.move(52,91);
			addChild(_markName);
			
			_starVes = new MSprite();
			_starVes.move(52,72);
			addChild(_starVes);
			showThreeStar(2);
		}
		
		public function initEvent():void
		{
		}
		
		public function initData():void
		{
//			MAlert.show(_challInfo.headPic.toString());
			_picPath = GlobalAPI.pathManager.getChallengePath(_challInfo.headPic.toString());
			GlobalAPI.loaderAPI.getPicFile(_picPath, loadAvatarComplete,SourceClearType.NEVER);
		}
		
		private function loadAvatarComplete(data:BitmapData):void
		{
			_markHead.bitmapData = data;
		}
		
		/**
		 * 显示评星 
		 * @param value 评星等级 1，2，3
		 * 
		 */		
		private function showThreeStar(value:int):void
		{
			while(_starVes && _starVes.numChildren>0){
				_starVes.removeChildAt(0);
			}
			for(var i:int=0; i<value; i++)
			{
				var star:Bitmap = new Bitmap(new IconStarAsset());
				star.x = _starVes.width;
				_starVes.addChild(star);
			}
			_starVes.move((104-_starVes.width)/2,72);
		}
		
		private function clearStarList():void
		{
			while(_starVes && _starVes.numChildren>0){
				_starVes.removeChildAt(0);
			}
		}
		
		public function clearData():void
		{
		}
		
		public function removeEvent():void
		{
		}
		
		public function move(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			if(SelectBorder && SelectBorder.bitmapData)
			{
				SelectBorder.bitmapData.dispose();
				SelectBorder = null;
			}
			GlobalAPI.loaderAPI.removeAQuote(_picPath,loadAvatarComplete);
		}

		/**
		 * 是否被选中 
		 */
		public function get selected():Boolean
		{
			return _selected;
		}

		/**
		 * @private
		 */
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(value)
			{
				SelectBorder.visible = true;
			}else
			{
				SelectBorder.visible = false;
			}
		}

		/**
		 * 评星等级
		 */
		public function get starLevel():int
		{
			return _starLevel;
		}

		/**
		 * @private
		 */
		public function set starLevel(value:int):void
		{
			_starLevel = value;
			if(starLevel == 3)
			{
				_markHead.visible = true;
				_markThreeStar.visible = true;
			}
			else if(starLevel != 0)
			{
				_markHead.visible = true;
				lockMask.visible = false;
			}
			else if(starLevel == 0)
			{
				_markHead.visible = false;
				lockMask.visible = true;
			}
			clearStarList();
			showThreeStar(starLevel);
		}

		/**
		 * 关卡名称 第一关、第二关。。。
		 */
		public function get markName():MAssetLabel
		{
			return _markName;
		}

		/**
		 * @private
		 */
		public function set markName(value:MAssetLabel):void
		{
			_markName = value;
		}

		/**
		 * 锁
		 */
		public function get lockMask():Bitmap
		{
			return _lockMask;
		}

		/**
		 * @private
		 */
		public function set lockMask(value:Bitmap):void
		{
			_lockMask = value;
		}

		/**
		 * 前置关卡是否通过 
		 */
		public function get preMarkBoolean():Boolean
		{
			return _preMarkBoolean;
		}

		/**
		 * @private
		 */
		public function set preMarkBoolean(value:Boolean):void
		{
			_preMarkBoolean = value;
			if(preMarkBoolean)
			{
//				selected = true;
				_markHead.visible = true;
				lockMask.visible = false;
			}
		}

		/**
		 * 关卡人物头像 
		 */
		public function get markHead():Bitmap
		{
			return _markHead;
		}

		/**
		 * @private
		 */
		public function set markHead(value:Bitmap):void
		{
			_markHead = value;
		}

	}
}