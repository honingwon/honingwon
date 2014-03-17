package sszt.scene.actions
{
	import fl.events.DataChangeEvent;
	
	import flash.utils.getTimer;
	
	import sszt.constData.SourceClearType;
	import sszt.core.action.BaseAction;
	import sszt.core.data.EffectType;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.view.effects.BaseLoadEffect;
	
	import scene.scene.BaseMapScene;
	
	public class FireworkAction extends BaseAction
	{
		private var _fireTotalCount:int = 5;
		
		private var _scene:BaseMapScene;
		private var _fireList:Array;
		private var _fires:Array;
		
		public function FireworkAction()
		{
			super(0);
			_fireList = [];
			_fires = [EffectType.FIRE_1,EffectType.FIRE_2,EffectType.FIRE_3,EffectType.FIRE_4,EffectType.FIRE_5,
				EffectType.FIRE_6,EffectType.FIRE_7,EffectType.FIRE_8,EffectType.FIRE_9];
		}
		
		public function setParent(container:BaseMapScene):void
		{
			_scene = container;
		}
		
		override public function configure(...parameters):void
		{
			var x:Number = parameters[0];
			var y:Number = parameters[1];
			var type:int = parameters[2];
			//x,y,type,lastEffectTime,count,effects
			_fireList.push([x,y,type,getTimer(),_fireTotalCount,[]]);
			
		}
		
		override public function update(times:int, dt:Number=0.04):void
		{
			if(!_scene)return;
			for(var i:int = _fireList.length - 1; i >= 0; i--)
			{
				var data:Array = _fireList[i];
				if(data[4] <= 0 && getTimer() - data[3] > 3000)
				{
					var tmp:Array = _fireList.splice(i,1)[0][5];
					for(var j:int = 0; j < tmp.length; j++)
					{
						tmp[j].dispose();
					}
					tmp.length = 0;
					continue;
				}
				else
				{
					if(data[4] > 0 && (data[4] == _fireTotalCount || getTimer() - data[3] > 1000))
					{
						data[4]--;
						var effect:BaseLoadEffect = new BaseLoadEffect(MovieTemplateList.getMovie(_fires[int(_fires.length * Math.random())]));
						data[5].push(effect);
						effect.play(SourceClearType.TIME,30000);
						_scene.addEffect(effect);
						effect.move(int(data[0] - 60 + Math.random() * 120),int(data[1] - 150 - 60 + Math.random() * 120));
						data[3] = getTimer();
					}
				}
				
			}
		}
		
		public function clear():void
		{
			for(var i:int = _fireList.length - 1; i >= 0; i--)
			{
				var data:Array = _fireList[i];
				for(var j:int = 0; j < data[5].length; j++)
				{
					data[5][j].dispose();
				}
			}
			_fireList.length = 0;
		}
	}
}