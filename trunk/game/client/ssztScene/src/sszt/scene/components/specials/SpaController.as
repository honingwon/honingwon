package sszt.scene.components.specials
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.scene.IScene;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.socketHandlers.spa.SpaPondSocketHandler;

	public class SpaController
	{
		private var _scene:IScene;
		private var _mediator:SceneMediator;
		
//		private var _btns:Array;
		private var _effects:Array;
		
		public function SpaController(scene:IScene,mediator:SceneMediator)
		{
			_scene = scene;
			_mediator = mediator;
			init();
		}
		
		private function init():void
		{
//			_btns = [];
//			var pos:Array = [new Point(2000,4140),new Point(800,200),new Point(600,600),new Point(1200,600)];
//			for(var i:int = 0; i < pos.length; i++)
//			{
//				var btn:Sprite = new Sprite();
//				btn.graphics.beginFill(0x000000,0.5);
//				btn.graphics.drawRect(0,0,100,100);
//				btn.graphics.endFill();
//				btn.x = pos[i].x;
//				btn.y = pos[i].y;
//				_scene.addControl(btn);
//				btn.buttonMode = true;
//				btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
//				_btns.push(btn);
//			}
			_effects = [];
			var pos1:Array = [new Point(1187,1524),new Point(1367,939),new Point(1086,1218),new Point(1566,1067),
							new Point(331,2876),new Point(1207,2787),new Point(791,3551),
							new Point(4355,1722),new Point(4948,1776),new Point(4409,2115),new Point(4921,2077),
							new Point(2910,3533),new Point(2355,3764),new Point(3013,4028),new Point(3724,4028)];
			var pos2:Array = [];
			var i:int = 0;
			var effect:BaseLoadEffect;
			for(i; i < pos1.length; i++)
			{
				effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.WAVE_EFFECT));
				effect.play(SourceClearType.TIME,300000);
				_scene.addEffect(effect);
				effect.move(pos1[i].x,pos1[i].y);
//				effect.width = 714;
//				effect.height = 408;
				effect.scaleX = 2;
				effect.scaleY = 1.5;
				_effects.push(effect);
			}
			for(i = 0; i < pos2.length; i++)
			{
				effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.WATER_EFFECT));
				effect.play(SourceClearType.NEVER);
				_scene.addEffect(effect);
				effect.move(pos1[i].x,pos1[i].y);
				_effects.push(effect);
			}
		}
		
		public function dispose():void
		{
			for each(var i:BaseLoadEffect in _effects)
			{
				i.dispose();
			}
			_effects = null;
			_scene = null;
			_mediator = null;
		}
	}
}