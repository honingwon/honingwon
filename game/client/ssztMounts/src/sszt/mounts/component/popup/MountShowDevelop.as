package  sszt.mounts.component.popup
{
	import fl.controls.ComboBox;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import sszt.constData.DirectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.mounts.MountsItemInfo;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.mounts.component.MountsPanel;
	import sszt.mounts.data.MountsInfo;
	import sszt.mounts.mediator.MountsMediator;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.button.MAssetButton1;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.splits.MCacheCompartLine2;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import ssztui.pet.BtnPageAsset;
	import ssztui.pet.TitleShowDevelAsset;
	import ssztui.pet.TitleSkillAsset;
	
	public class MountShowDevelop extends MPanel
	{
		private var _showBg:Bitmap;
		private var _bg:IMovieWrapper;
		private var _mediator:MountsMediator;
		private var _character:ICharacter;
		private var _txtLab:MAssetLabel;
		private var _currentStep:int = 0;
		private var _cutBtn:MAssetButton1;
		private var _addBtn:MAssetButton1;
		private var _comboxQuality:ComboBox;
		private var _characterbox:Sprite;
		
		public function MountShowDevelop(mediator:MountsMediator)
		{
			super(new MCacheTitle1("", new Bitmap(new TitleShowDevelAsset())), true,-1);
			_mediator = mediator;
			updateCharacter(0);
		}
		override protected function configUI():void
		{
			
			super.configUI();
			setContentSize(341,330);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11, new Rectangle(8,2,325,320)),
				new BackgroundInfo(BackgroundType.BORDER_12, new Rectangle(14,6,317,312)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(14,219,317,25),new MCacheCompartLine2()),
			]);
			addContent(_bg as DisplayObject);
			
			_showBg = new Bitmap();
			_showBg.x = 16;
			_showBg.y = 8;
			addContent(_showBg);
			var bd:BitmapData = AssetUtil.getAsset('ssztui.pet.ShowDevelBgAsset',BitmapData) as BitmapData;
			_showBg.bitmapData =bd;
			
			_characterbox = new Sprite();
			addContent(_characterbox);
			
			_cutBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_cutBtn.move(22,87);
			addContent(_cutBtn);
			
			_addBtn = new MAssetButton1(new BtnPageAsset() as MovieClip);
			_addBtn.move(322,87);
			_addBtn.scaleX = -1;
			addContent(_addBtn);
			
			_txtLab = new MAssetLabel("",MAssetLabel.LABEL_TYPE_B14);
			_txtLab.move(170,180);
			addContent(_txtLab);
			
			var txtBgRulesIntro:MAssetLabel = new MAssetLabel("", MAssetLabel.LABEL_TYPE_TAG, TextFieldAutoSize.LEFT);
			txtBgRulesIntro.multiline = txtBgRulesIntro.wordWrap = true;
			txtBgRulesIntro.setSize(285,70);
			txtBgRulesIntro.move(30,236);
			txtBgRulesIntro.setHtmlValue(LanguageManager.getWord('ssztl.mounts.stairsRules1'));
			addContent(txtBgRulesIntro);
			
			_comboxQuality = new ComboBox();
			_comboxQuality.open();
			_comboxQuality.setStyle("textFormat",new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF));
			_comboxQuality.x = 166;
			_comboxQuality.y = 280;
			_comboxQuality.width = 60;
			_comboxQuality.height = 22;
			_comboxQuality.rowCount = 4;
//			addContent(_comboxQuality);
			_comboxQuality.dataProvider = new DataProvider([
				{label:LanguageManager.getWord("ssztl.mounts.mountOneStep"),value:0},
				{label:LanguageManager.getWord("ssztl.mounts.mountTwoStep"),value:1},
				{label:LanguageManager.getWord("ssztl.mounts.mountThrStep"),value:2},
				{label:LanguageManager.getWord("ssztl.mounts.mountForStep"),value:3},
				{label:LanguageManager.getWord("ssztl.mounts.mountFiveStep"),value:4},
			]);
			_comboxQuality.selectedIndex = 0;
			
			initEvents();
		}
		
//		//缩放位图
//		public static function scaleBitmapData(bmpData:BitmapData, scaleX:Number, scaleY:Number):BitmapData
//		{
//			var matrix:Matrix = new Matrix();
//			matrix.scale(scaleX, scaleY);
//			var bmpData_:BitmapData = new BitmapData(scaleX * bmpData.width, scaleY * bmpData.height, true, 0);
//			bmpData_.draw(bmpData, matrix);
//			return bmpData_;
//		}
		
		private function initEvents():void
		{
			_cutBtn.addEventListener(MouseEvent.CLICK,selectCutCharacter);
			_addBtn.addEventListener(MouseEvent.CLICK,selectAddCharacter);
			_comboxQuality.addEventListener(Event.CHANGE,selectCharacter);
		}
		
		private function removeEvents():void
		{
			_cutBtn.removeEventListener(MouseEvent.CLICK,selectCutCharacter);
			_addBtn.removeEventListener(MouseEvent.CLICK,selectAddCharacter);
			_comboxQuality.removeEventListener(Event.CHANGE,selectCharacter);
		}
		
		private function updateCharacter(i:int):void
		{
			if(_character){_character.dispose();_character = null;}
			var tmp:MountsItemInfo= _mediator.module.mountsInfo.currentMounts;
			var tmp1:MountsItemInfo = new MountsItemInfo();
			tmp1.id = tmp.id;
			tmp1.templateId = tmp.templateId;
			tmp1.stairs = i*15+1;
			_character = GlobalAPI.characterManager.createShowMountsOnlyCharacter( tmp1);
			if(_character==null)return;
			_currentStep = i;
			_character.setMouseEnabeld(false);
			_character.show(DirectType.LEFT_BOTTOM);
			_character.move(170,110);
			_characterbox.addChild(_character as DisplayObject);
			_txtLab.setValue(LanguageManager.getWord("ssztl.pet.petGrowStep",i*15));
			_currentStep==0?_cutBtn.enabled=false:_cutBtn.enabled=true;
			_currentStep==4?_addBtn.enabled=false:_addBtn.enabled=true;
			_comboxQuality.selectedIndex = _currentStep;
		}
		
		private function selectCutCharacter(e:MouseEvent):void
		{
			updateCharacter(_currentStep-1);
		}
		private function selectAddCharacter(e:MouseEvent):void
		{
			updateCharacter(_currentStep+1);
		}
		private function selectCharacter(e:Event):void
		{
			updateCharacter(_comboxQuality.selectedIndex);
		}
		
		override public function dispose():void
		{
			removeEvents();	
			super.dispose();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			_characterbox = null;
			if(_txtLab)
				_txtLab = null;
			if(_cutBtn)
				_cutBtn = null;
			if(_addBtn)
				_addBtn =null;
			if(_comboxQuality)
				_comboxQuality =null;
		}
		
	}
}