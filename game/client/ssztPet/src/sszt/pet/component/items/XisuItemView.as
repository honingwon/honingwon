package sszt.pet.component.items
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.ui.label.MAssetLabel;
	
	import ssztui.pet.xisuiBtnAsset1;
	import ssztui.pet.xisuiBtnAsset2;
	import ssztui.pet.xisuiBtnAsset3;

	public class XisuItemView extends Sprite
	{
		private var _id:int;
		private var _ef:BaseLoadEffect;
		private var _sortBtn:MovieClip;
		private var _txtName:MAssetLabel;
		
		private var _selected:Boolean;
		private var _current:Boolean;
		
		public function XisuItemView(id:int)
		{
			_id = id;
			init();
		}
		private function init():void
		{
			buttonMode = true;
			
			var efArray:Array = [EffectType.PET_XISU_BTN_1,EffectType.PET_XISU_BTN_2,EffectType.PET_XISU_BTN_3];
			var classArray:Array = [xisuiBtnAsset1,xisuiBtnAsset2,xisuiBtnAsset3];
			var nameArray:Array = ["ssztl.pet.farAttack","ssztl.pet.outerAttack","ssztl.pet.innerAttack"];
			
			_ef = new BaseLoadEffect(MovieTemplateList.getMovie(efArray[_id])); 
			_ef.play(SourceClearType.TIME,300000);
			_ef.visible = false;
			addChild(_ef);
			
			_sortBtn = new classArray[_id];
			addChild(_sortBtn);
			
			_txtName = new MAssetLabel("",MAssetLabel.LABEL_TYPE_YAHEI);
			_txtName.move(30,65);
			addChild(_txtName);
			_txtName.setHtmlValue(LanguageManager.getWord(nameArray[_id]));
		}
		public function set currentType(value:Boolean):void
		{
			_current = value;
			_ef.visible = value;
			if(value)
			{
				_txtName.textColor = 0xff6600;
				_sortBtn.gotoAndStop(3);
			}else
			{
				_txtName.textColor = 0xfffccc;
				_sortBtn.gotoAndStop(1);
			}
		}
		public function get currentType():Boolean
		{
			return _current;
		}
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if(value)
			{
				if(!_current) _sortBtn.gotoAndStop(2);
			}else
			{
				if(!_current) _sortBtn.gotoAndStop(1);
			}
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		public function move(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			
		}
	}
}