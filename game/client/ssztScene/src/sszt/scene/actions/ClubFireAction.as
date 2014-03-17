package sszt.scene.actions
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import flash.ui.Mouse;
	
	import sszt.ui.container.MAlert;
	
	import sszt.constData.SourceClearType;
	import sszt.core.action.BaseAction;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.effects.BaseLoadEffect;
	
	import scene.scene.BaseMapScene;
	
	public class ClubFireAction extends BaseAction
	{
		private var _scene:BaseMapScene;
		private var _isClub:Boolean;
		private var _fireEffect:BaseLoadEffect;
		private var _hotArea:Sprite;
		
		public function ClubFireAction()
		{
			super(0);
		}
		
		public function setParent(container:BaseMapScene):void
		{
			_scene = container;
		}
		
		override public function configure(...parameters):void
		{
			_isClub = parameters[0];
			if(_isClub)
				GlobalAPI.tickManager.addTick(this);
			else GlobalAPI.tickManager.removeTick(this);
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			super.update(times,dt);
			var hours:int = GlobalData.systemDate.getSystemDate().hours;
			var minutes:int = GlobalData.systemDate.getSystemDate().minutes;
//			if(!_isClub || (_isClub && hours != 18))
			if(!_isClub || !(_isClub && ((hours == 19 && minutes > 30) || (hours == 20 && minutes < 30))))
			{
				clearFire();
			}
			else
			{
				createFire();
			}
		}
		
		private function clearFire():void
		{
			if(_fireEffect)
			{
				_fireEffect.dispose();
				_fireEffect = null;
			}
			if(_hotArea)
			{
				_hotArea.removeEventListener(MouseEvent.CLICK,hotAreaClickHandler);
				if(_hotArea.parent)_hotArea.parent.removeChild(_hotArea);
				_hotArea = null;
			}
		}
		private function createFire():void
		{
			if(!_fireEffect)
			{
				_fireEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.CLUB_FIRE));
				_fireEffect.play(SourceClearType.CHANGESCENE_AND_TIME,100000);
				_fireEffect.move(1430,630);
				_scene.addEffect(_fireEffect);
			}
			if(!_hotArea)
			{
				_hotArea = new Sprite();
				_hotArea.graphics.beginFill(0,0);
				_hotArea.graphics.drawRect(0,0,100,135);
				_hotArea.graphics.endFill();
				_hotArea.buttonMode = true;
				_hotArea.addEventListener(MouseEvent.CLICK,hotAreaClickHandler);
				_hotArea.x = 1490;
				_hotArea.y = 770;
				_scene.addControl(_hotArea);
			}
		}
		
		private function hotAreaClickHandler(evt:MouseEvent):void
		{
			MAlert.show(LanguageManager.getWord("ssztl.scene.clubFireDetail"),LanguageManager.getWord("ssztl.scene.clubFireHelp"),4,null,null,TextFormatAlign.LEFT);
		}
		
		public function clear():void
		{
			GlobalAPI.tickManager.removeTick(this);
			clearFire();
		}
		
		override public function dispose():void
		{
			clear();
			super.dispose();
		}
	}
}