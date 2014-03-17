package sszt.role.components
{
	import fl.controls.ComboBox;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.label.MBackgroundLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.btns.MCacheAsset2Btn;
	import sszt.ui.mcache.cells.CellCaches;
	import sszt.ui.mcache.splits.MCacheSplit2Line;
	
	import sszt.core.data.player.DetailPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.role.mediator.RoleMediator;
	
	public class CharacterClothesPanel extends Sprite implements IRolePanelView
	{
		private var _roleMediator:RoleMediator;
		private var _bg:IMovieWrapper;
		
		private var _combox:ComboBox;
		private var _readBtn:MCacheAsset2Btn;
		private var _changeBtn:MCacheAsset2Btn;
		private var _nenameBtn:MCacheAsset2Btn;
		private var _saveBtn:MCacheAsset2Btn;
		private var _allUnloadBtn:MCacheAsset2Btn;
		
		
		public function CharacterClothesPanel(roleMediator:RoleMediator)
		{
			super();
			_roleMediator = roleMediator;
			initialView();
		}
		
		private function initialView():void
		{
			x = 247;
			y = 44;
			_bg = BackgroundUtils.setBackground([
									new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,241,252)),
									new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(15,22,48,49)),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(20,27,38,38),new Bitmap(CellCaches.getCellBg())),
									new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(6,86,229,156)),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,137,215,2),new MCacheSplit2Line()),
									new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,188,215,2),new MCacheSplit2Line()),
							]);
			addChild(_bg as DisplayObject);
			
			addChild(MBackgroundLabel.getDisplayObject(new Rectangle(77,28,88,17),new MAssetLabel(LanguageManager.getWord("ssztl.role.inputEquipProject"),MAssetLabel.LABELTYPE14)));
			
			_combox = new ComboBox();
			_combox.move(79,48);
			_combox.width = 155;
			_combox.height = 22;
			addChild(_combox);
			
			_readBtn = new MCacheAsset2Btn(0,LanguageManager.getWord("ssztl.role.read"),2);
			_readBtn.move(17,93);
			addChild(_readBtn);
			_changeBtn = new MCacheAsset2Btn(0,LanguageManager.getWord("ssztl.role.changeCloth"),2);
			_changeBtn.move(125,93);
			addChild(_changeBtn);
			_nenameBtn = new MCacheAsset2Btn(0,LanguageManager.getWord("ssztl.role.nename"),2);
			_nenameBtn.move(17,144);
			addChild(_nenameBtn);
			_saveBtn = new MCacheAsset2Btn(0,LanguageManager.getWord("ssztl.common.save"),2);
			_saveBtn.move(125,144);
			addChild(_saveBtn);
			_allUnloadBtn = new MCacheAsset2Btn(0,LanguageManager.getWord("ssztl.role.allOff"),2);
			_allUnloadBtn.move(17,195);
			addChild(_allUnloadBtn);
		}
		
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
		}
		public function show():void
		{
		}
		
		public function assetsCompleteHandler():void
		{
		}
		
		public function dispose():void
		{
			hide();
			_roleMediator = null;
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			_combox = null;
			if(_readBtn)
			{
				_readBtn.dispose();
				_readBtn = null;
			}
			if(_changeBtn)
			{
				_changeBtn.dispose();
				_changeBtn = null;
			}
			if(_nenameBtn)
			{
				_nenameBtn.dispose();
				_nenameBtn = null;
			}
			if(_saveBtn)
			{
				_saveBtn.dispose();
				_saveBtn = null;
			}
			if(_allUnloadBtn)
			{
				_allUnloadBtn.dispose();
				_allUnloadBtn = null;
			}
		}
	}
}