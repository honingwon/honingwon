package sszt.club.components.clubMain.pop.sec.monster
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	import sszt.club.mediators.ClubMediator;
	import sszt.core.data.club.ClubMonsterTemplateInfo;
	import sszt.core.data.monster.MonsterTemplateList;
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	
	public class ClubMonsterItemView extends Sprite
	{
		private var _mediator:ClubMediator;
		private var _info:ClubMonsterTemplateInfo;
		private var _nameLabel:MAssetLabel;
		private var _select:Boolean;
		private var _selectedBg:Shape;
		
		public function ClubMonsterItemView(argInfo:ClubMonsterTemplateInfo,argMediator:ClubMediator)
		{
			super();
			_mediator = argMediator;
			_info = argInfo;
			initView();
		}
		
		private function initView():void
		{
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,120,40);
			graphics.endFill();
			
			_selectedBg = new Shape();
			_selectedBg.graphics.beginFill(0x7AC900,0.5);
			_selectedBg.graphics.drawRect(0,0,117,40);
			_selectedBg.graphics.endFill();
			addChild(_selectedBg);
			_selectedBg.visible = false;
			
			_nameLabel = new MAssetLabel(MonsterTemplateList.getMonster(_info.monsterId).name,MAssetLabel.LABELTYPE1);
			_nameLabel.move(15,15);
			addChild(_nameLabel);
		}
		
		public function get info():ClubMonsterTemplateInfo
		{
			return _info;
		}

		public function set info(value:ClubMonsterTemplateInfo):void
		{
			_info = value;
		}

		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			if(_select == value)return;
			_select = value;
			if(_select)_selectedBg.visible = true;
			else _selectedBg.visible = false;
		}

		public function dispse():void
		{
			_mediator = null;
			_info = null;
			_nameLabel = null;
			_selectedBg = null;
			if(parent)parent.removeChild(this);
		}
	}
}