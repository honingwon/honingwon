package sszt.petpvp.components.cell
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.constData.CategoryType;
	import sszt.constData.LayerType;
	import sszt.core.data.pet.PetItemInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.cell.BaseCell;
	import sszt.core.view.tips.TipsUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.mcache.cells.CellCaches;
	
	import ssztui.petPVP.FightAsset;
	
	public class PetCell extends BaseCell
	{
		protected var _petItemInfo:PetItemInfo;
		private var _bg:IMovieWrapper;
		private var _selectBg:Bitmap;
		public var _petPvpPetItemInfo:PetPVPPetItemInfo;
		public var _id:Number;
		private var _over:Bitmap;
		
		public function PetCell()
		{
			super();
			createBg();
			buttonMode = true;
		}
		
		
		
		protected function createBg():void
		{
			_bg = BackgroundUtils.setBackground([	
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(0,0,50,50),new Bitmap(CellCaches.getCellBigBg()))
			]);
			addChild(_bg as DisplayObject);
			_bg.visible = false;
			
//			_selectBg = new Bitmap(CellCaches.getCellSelectedBox() as BitmapData);
			_selectBg = new Bitmap(new FightAsset());
			addChild(_selectBg);
			_selectBg.visible = false;
			
		}
		
		public function get petItemInfo():PetItemInfo
		{
			return _petItemInfo;
		}
		
		public function set petItemInfo(value:PetItemInfo):void
		{
			if(_petItemInfo == value)return;
			_petItemInfo = value;
			if(_petItemInfo)
			{
				info = _petItemInfo.template;
				if(_bg)
				{
					_bg.visible = true;
				}
			}
			else
			{
				info = null;
				if(_bg)
				{
					_bg.visible = false;
				}
			}
		}
		override protected function initFigureBound():void
		{
			_figureBound = new Rectangle(3,3,44,44);
			
		}
		override protected function getLayerType():String
		{
			return LayerType.PET_AVATAR_BIG;
		}
		
		override protected function createPicComplete(value:BitmapData):void
		{
			super.createPicComplete(value);
			if(_selectBg) setChildIndex(_selectBg,numChildren-1);
			
		}
		public function set selected(value:Boolean):void
		{
			_selectBg.visible = value;
		}
		
//		override protected function getLayerType():String
//		{
//			return LayerType.PET_AVATAR;
//		}
		
		override protected function showTipHandler(e:MouseEvent):void
		{
			if(_petPvpPetItemInfo)
			{
				//TipsUtil.getInstance().show(_petItemInfo,null,new Rectangle(this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).x,this.localToGlobal(new Point(_figureBound.x,_figureBound.y)).y,_figureBound.width,_figureBound.height));	
				var tip:String = 
					"<font color='#" + CategoryType.getQualityColorString(_petPvpPetItemInfo.quality) + "'>" + _petPvpPetItemInfo.nick + "</font> " + 
					LanguageManager.getWord("ssztl.common.levelValue2",_petPvpPetItemInfo.level) + "\n" +
					LanguageManager.getWord("ssztl.scene.rank")  + "：" + _petPvpPetItemInfo.place + "\n" +
					LanguageManager.getWord("ssztl.sword.qualityLevel") + "：" + _petPvpPetItemInfo.stairs + "\n" +
					LanguageManager.getWord("ssztl.common.fightValue")  + "：" + _petPvpPetItemInfo.fight + "\n" +
					"<font color='#ff9900'>" + LanguageManager.getWord("ssztl.petpvp.winRate")  + "：" + int(_petPvpPetItemInfo.win/_petPvpPetItemInfo.total*100) + "%</font>"	;
				TipsUtil.getInstance().show(tip,null,new Rectangle(e.stageX,e.stageY,0,0));
			}
			
		}
		
		override protected function hideTipHandler(evt:MouseEvent):void
		{
			if(_petPvpPetItemInfo)
			{
				TipsUtil.getInstance().hide();
			}
		}
		
		override public function dispose():void
		{
			hideTipHandler(null);
			_petItemInfo = null;
			super.dispose();
		}
	}
}