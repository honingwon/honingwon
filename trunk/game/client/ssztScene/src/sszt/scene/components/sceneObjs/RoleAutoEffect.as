package sszt.scene.components.sceneObjs
{
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.SharedObjectInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.tick.ITick;
	
	public class RoleAutoEffect implements ITick
	{
		private var _qiangMale:Array =[];
		private var _qiangFemale:Array =[];
		private var _shanMale:Array =[];
		private var _shanFemale:Array =[];
		private var _biaoMale:Array =[];
		private var _biaoFemale:Array =[];
		private var _character:BaseScenePlayer;
		private var _count:int;
		private var _dx:Number;
		private var _dy:Number;
		private var _mountY:int=0;
		private var _currentX:Number;
		private var _currentY:Number;
		public function RoleAutoEffect(character:BaseScenePlayer)
		{
			_character = character;
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int,dt:Number = 0.04):void
		{
//			if(_character.getScenePlayerInfo().info.style[3]>0 &&_character.isSit() == false)
//			{	
//				var time:int = _character.getScenePlayerInfo().info.strengthLevel;
//				if(_character.getScenePlayerInfo().isMount)
//					_mountY = 0;
//				else
//					_mountY = 45;
//				updateChibang(time);
//				updateChibang(time);
//				updateChibang(time);
//			}
//			if(SharedObjectInfo.value == true)
				updateMount();
		}
		
		private function updateChibang(time:int):void
		{
//			var effect:SpritEffect; = new SpritEffect(50);
			var effect1:SpritEffect = new SpritEffect(time);
			var effect2:SpritEffect = new SpritEffect(time);
			var effect3:SpritEffect = new SpritEffect(time);
			var effect4:SpritEffect = new SpritEffect(time);
			switch(_character.dir)
			{
				case DirectType.BOTTOM:
					_dx = Math.random()*52;
					_dy = Math.random()*47;
					effect1.move(_character.sceneX-7-_dx,_character.sceneY-135-_dy+_mountY);
					effect2.move(_character.sceneX-45-_dx,_character.sceneY-177-_dy+_mountY);
					effect3.move(_character.sceneX+10+_dx,_character.sceneY-120-_dy+_mountY);
					effect4.move(_character.sceneX+53+_dx,_character.sceneY-153-_dy+_mountY);			
					break;
				case DirectType.TOP:
					_dx = Math.random()*90;
					_dy = Math.random()*70;
					effect1.move(_character.sceneX+10+_dx,_character.sceneY-100-_dy+_mountY);
					effect2.move(_character.sceneX+13+_dx,_character.sceneY-95-_dy+_mountY);
					effect3.move(_character.sceneX-10-_dx,_character.sceneY-100-_dy+_mountY);
					effect4.move(_character.sceneX-13-_dx,_character.sceneY-95-_dy+_mountY);	
					break;
				case DirectType.LEFT:
					_dx = Math.random()*25;
					_dy = Math.random()*60;
					effect1.move(_character.sceneX+22+_dx,_character.sceneY-108-_dy+_mountY);
					effect2.move(_character.sceneX+47+_dx,_character.sceneY-108-_dy+_mountY);
					_dx = Math.random()*16;
					_dy = Math.random()*60;
					effect3.move(_character.sceneX+3+_dx,_character.sceneY-180-_dy+_mountY);	
					break;
				case DirectType.RIGHT:
					_dx = Math.random()*25;
					_dy = Math.random()*60;
					effect1.move(_character.sceneX-22-_dx,_character.sceneY-108-_dy+_mountY);
					effect2.move(_character.sceneX-47-_dx,_character.sceneY-108-_dy+_mountY);
					_dx = Math.random()*16;
					_dy = Math.random()*60;
					effect3.move(_character.sceneX-3-_dx,_character.sceneY-180-_dy+_mountY);	
					break;
				case DirectType.RIGHT_BOTTOM:
					_dx = Math.random()*49;
					_dy = Math.random()*57;
					effect1.move(_character.sceneX-70-_dx,_character.sceneY-130-_dy+_mountY);
					_dx = Math.random()*36;
					_dy = Math.random()*56;
					effect2.move(_character.sceneX-37-_dx,_character.sceneY-117-_dy+_mountY);
					_dx = Math.random()*30;
					_dy = Math.random()*36;
					effect3.move(_character.sceneX+5+_dx,_character.sceneY-135-_dy+_mountY);
					effect4.move(_character.sceneX+35+_dx,_character.sceneY-178-_dy+_mountY);
					break;
				case DirectType.RIGHT_TOP:				
					_dx = Math.random()*27;
					_dy = Math.random()*65;
					effect1.move(_character.sceneX+21-_dx,_character.sceneY-83-_dy+_mountY);		
					_dx = Math.random()*38;
					_dy = Math.random()*78;
					effect2.move(_character.sceneX-17-_dx,_character.sceneY-112-_dy+_mountY);		
					_dx = Math.random()*43;
					_dy = Math.random()*70;
					effect3.move(_character.sceneX-44-_dx,_character.sceneY-135-_dy+_mountY);					
					break;
				case DirectType.LEFT_BOTTOM:
					_dx = Math.random()*49;
					_dy = Math.random()*57;
					effect1.move(_character.sceneX+70+_dx,_character.sceneY-130-_dy+_mountY);
					_dx = Math.random()*36;
					_dy = Math.random()*56;
					effect2.move(_character.sceneX+37+_dx,_character.sceneY-117-_dy+_mountY);
					_dx = Math.random()*30;
					_dy = Math.random()*36;
					effect3.move(_character.sceneX-5-_dx,_character.sceneY-135-_dy+_mountY);
					effect4.move(_character.sceneX-35-_dx,_character.sceneY-178-_dy+_mountY);
					break;
				case DirectType.LEFT_TOP:
					_dx = Math.random()*27;
					_dy = Math.random()*65;
					effect1.move(_character.sceneX-21+_dx,_character.sceneY-83-_dy+_mountY);		
					_dx = Math.random()*38;
					_dy = Math.random()*78;
					effect2.move(_character.sceneX+17+_dx,_character.sceneY-112-_dy+_mountY);		
					_dx = Math.random()*43;
					_dy = Math.random()*70;
					effect3.move(_character.sceneX+44+_dx,_character.sceneY-135-_dy+_mountY);
					break;	
			}	
			_character.scene.addEffect(effect1);
			_character.scene.addEffect(effect2);
			_character.scene.addEffect(effect3);
			_character.scene.addEffect(effect4);	
		}
		
		private function updateQiang():void
		{
			var time:int = Math.random()*50;
			var effect:SpritEffect = new SpritEffect(51-time);
			switch(_character.dir)
			{
				case DirectType.BOTTOM:
					_dx = time*73/50;
					effect.move(_character.sceneX-52+_dx,_character.sceneY-73-_dx*1.44);
					break;
				case DirectType.TOP:
					_dx = time*73/50;
					effect.move(_character.sceneX+46-_dx,_character.sceneY-68-_dx*1.15);
					break;
				case DirectType.LEFT:						
					_dy = time*132/50;
					effect.move(_character.sceneX+10+_dy*0.197,_character.sceneY-40-_dy);
					break;
				case DirectType.RIGHT:
					_dy = time*132/50;
					effect.move(_character.sceneX-10-_dy*0.197,_character.sceneY-40-_dy);
					break;
				case DirectType.RIGHT_BOTTOM:
					_dy = time/50*131;
					effect.move(_character.sceneX-44+_dy*0.282,_character.sceneY-52-_dy);
					break;
				case DirectType.RIGHT_TOP:
					_dy = time/50*118;
					effect.move(_character.sceneX+24-_dy*0.593,_character.sceneY-43-_dy);
					break;
				case DirectType.LEFT_BOTTOM:
					_dy = time/50*131;
					effect.move(_character.sceneX+44-_dy*0.282,_character.sceneY-52-_dy);
					break;
				case DirectType.LEFT_TOP:
					_dy = time/50*118;
					effect.move(_character.sceneX-24+_dy*0.593,_character.sceneY-43-_dy);
					break;	
			}			
			_character.scene.addEffect(effect);
		}
		
		private function updateMount():void
		{
			_count++;
			if(_count>10 && _character.getScenePlayerInfo().info.style[2] == 240005)//_character.getScenePlayerInfo().isMount
			{
				_count = 0;
				if(_currentX != _character.sceneX || _currentY != _character.sceneY)
				{
					_currentX = _character.sceneX;
					_currentY = _character.sceneY;
					var effect:BaseLoadEffect = new BaseLoadEffect(MovieTemplateList.getMovie(30014));
					effect.move(_currentX,_currentY);
					_character.scene.addEffect(effect);
					effect.play(SourceClearType.TIME,30,4);
//					effect = new BaseLoadEffect(MovieTemplateList.getMovie(114));
//					effect.move(_currentX+100,_currentY+100);
//					_character.scene.addEffect(effect);
//					effect.play(SourceClearType.TIME,30000,4);
//					effect = new BaseLoadEffect(MovieTemplateList.getMovie(115));
//					effect.move(_currentX-100,_currentY+100);
//					_character.scene.addEffect(effect);
//					effect.play(SourceClearType.TIME,30000,4);
//					effect = new BaseLoadEffect(MovieTemplateList.getMovie(116));
//					effect.move(_currentX-100,_currentY-100);
//					_character.scene.addEffect(effect);
//					effect.play(SourceClearType.TIME,30000,4);
//					effect = new BaseLoadEffect(MovieTemplateList.getMovie(117));
//					effect.move(_currentX+100,_currentY-100);
//					_character.scene.addEffect(effect);
//					effect.play(SourceClearType.TIME,30000,4);
				}
			}
		}
		
		public function dispose():void
		{
			GlobalAPI.tickManager.removeTick(this);
		}
	}
}