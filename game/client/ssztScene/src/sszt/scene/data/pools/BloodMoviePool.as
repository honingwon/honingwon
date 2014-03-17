package sszt.scene.data.pools
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Sine;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	import sszt.constData.AttackTargetResultType;
	import sszt.core.caches.FightTextType;
	import sszt.core.caches.NumberCache;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.interfaces.pool.IPoolManager;
	import sszt.interfaces.pool.IPoolObj;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.ui.container.MSprite;
	
	public class BloodMoviePool extends Sprite implements IPoolObj
	{
		private var _value:int;
		private var _type:int;
		private var _color:String;
		private var _sceneX:Number;
		private var _sceneY:Number;
		private var _target:BaseRole;
//		private var _currentFrame:int;
//		private var _isComplete:Boolean;
		private var _manager:IPoolManager;
		private var _movie:Sprite;
		
		private var _isSelf:Boolean = false;
		private var _fightTextType:FightTextType;
		
		private static const xConst:Array = [18, 16, 14, -14, -16, -18];
		private static const yConst:Array = [20, 25, 30, 35];
		
		private static var lastA:int;
		private static var lastB:int;
		
		
		private var _image:MSprite; 
		public function BloodMoviePool()
		{
			mouseChildren = mouseEnabled = false;
		}
		
		public function setManager(manager:IPoolManager):void
		{
			_manager = manager;
		}
		
		public function reset(param:Object):void
		{
			_target = param[0];
			_value = param[1];
			_type = param[2];
			_isSelf = param[3];
			
			
			switch (_type){
				case AttackTargetResultType.CRITICAL:
					_image = NumberCache.getNumber(_value,FightTextType.CritHurtNumber);
					break;
				case AttackTargetResultType.ADDBLOOD:
				case AttackTargetResultType.ADDMP:
					_image = NumberCache.getNumber(_value,FightTextType.AddNumber);
					break;
				case AttackTargetResultType.HIT:
					_image = NumberCache.getNumber(_value,_isSelf?FightTextType.SelfHurtNumber:FightTextType.HurtNumber);
					break;
				case AttackTargetResultType.BLOCK:
					_image = NumberCache.getNumber(_value,FightTextType.BlockType);
					break;
				case AttackTargetResultType.MISS:
					_image = NumberCache.getNumber(_value,FightTextType.MissType);
					break;
				default:
					_image = NumberCache.getNumber(_value,FightTextType.HurtNumber);
			}
			_image.x = (-(_image.width) / 2);
			_image.y = ((_target.titleY - _image.height)+40);
			hurtFlutter(_image);
			
			
			
//			if(_type == AttackTargetResultType.CRITICAL)
//			{
//				_fightTextType = FightTextType.CritHurtNumber;
//			}
//			else if(_type == AttackTargetResultType.ADDBLOOD || _type == AttackTargetResultType.ADDMP)
//			{
//				_fightTextType = FightTextType.AddNumber;
//			}
//			else if(_type == AttackTargetResultType.HIT)
//			{
//				if(_isSelf)
//				{
//					_fightTextType = FightTextType.SelfHurtNumber;
//				}
//				else
//				{
//					_fightTextType = FightTextType.HurtNumber;
//				}
//			}
//			else if(_type == AttackTargetResultType.BLOCK)
//			{
//				_fightTextType = FightTextType.BlockType;
//			}
//			else if(_type == AttackTargetResultType.MISS)
//			{
//				_fightTextType = FightTextType.MissType;
//			}
//			else
//			{
//				_fightTextType = FightTextType.HurtNumber;
//			}
//			
//			if(_movie && _movie.parent)_movie.parent.removeChild(_movie);
//			_movie = NumberCache.getNumber(_value,_fightTextType);
//			if(_movie)
//			{
//				addChild(_movie);
//			}
//			this.alpha = 1;
		}
		
		public function infoFlutter(dis:DisplayObject):void{
			
			var _x:int = dis.x;
			var _width:int = dis.width;
			var startX:int = (_x - (((_width * 1.1) - _width) / 2));
			var midleX:int = (_x - (((_width * 1) - _width) / 2));
			var endX:int = (_x - (((_width * 0.9) - _width) / 2));
			var startY:int = dis.y;
			TweenLite.to(dis, 1, {
				y:(startY - 80),
				ease:Sine.easeOut,
				onComplete:function ():void{
					if ((dis is MSprite)){
						(dis as MSprite).dispose();
					}
					if (dis.parent){
						dis.parent.removeChild(dis);
					}
				}
			});
		}
		
		public function hurtFlutter(dis:DisplayObject):void{
			var maxX:int;
			const staTime:Number = 0.2;
			var timeLite:TimelineLite;
			var dis:DisplayObject = dis;
			var temp:int;
			var b:int = yConst[int((Math.random() * yConst.length))];
			if (b == lastB){
				temp = yConst[int((Math.random() * yConst.length))];
				b = temp;
				lastB = temp;
			} 
			else {
				lastB = b;
			}
			const c:int = -25;
			var a:int = xConst[int((Math.random() * xConst.length))];
			if (a == lastA){
				temp = xConst[int((Math.random() * xConst.length))];
				a = temp;
				lastA = temp;
			} else {
				lastA = a;
			}
			maxX = ((Math.sqrt(((b - c) / b)) * a) + a);
			var endTime:Number = (staTime * (maxX / a));
			var _x:int = ( + dis.x);
			dis.y = (( + dis.y) - 10);
			var _width:int = dis.width;
			var _height:int = dis.height;
			var startX:int = ( - ((_width * 1.5) / 2));
			var endX:int = ( - ((_width * 0.6) / 2));
			var startY:int = (dis.y + ((_height * 0.6) - (_height * 1.5)));
			dis.scaleX = (dis.scaleY = 0.6);
			dis.x = endX;
			dis.alpha = 0.8;
			if (!dis.parent){
				_target.addChild(dis);
			}
			timeLite = new TimelineLite();
			timeLite.append(new TweenMax(dis, 0.07, {
				x:startX,
				y:startY,
				ease:Linear.easeOut,
				scaleX:1.5,
				scaleY:1.5,
				alpha:1,
				colorMatrixFilter:{brightness:1.8}
			}), 0.04);
			timeLite.append(new TweenMax(dis, 0.08, {
				x:_x,
				scaleX:1,
				scaleY:1,
				ease:Linear.easeNone,
				colorMatrixFilter:{brightness:1.2}
			}), 0.05);
			timeLite.append(new TweenLite(dis, staTime, {
				x:(_x - a),
				ease:Linear.easeNone
			}));
			timeLite.append(new TweenLite(dis, staTime, {
				y:(startY - b),
				ease:Quad.easeOut,
				scaleX:(1 - ((1 - 0.8) * (a / maxX))),
				scaleY:(1 - ((1 - 0.8) * (a / maxX)))
			}), (0 - staTime));
			timeLite.append(new TweenLite(dis, endTime, {
				x:(_x - maxX),
				ease:Linear.easeNone
			}));
			timeLite.append(new TweenLite(dis, endTime, {
				y:(startY - c),
				ease:Quad.easeIn,
				alpha:0,
				scaleX:0.8,
				scaleY:0.8,
				onComplete:function ():void{
					timeLite.stop();
					timeLite = null;
					if ((dis is MSprite)){
						(dis as MSprite).dispose();
					}
					if (dis.parent){
						dis.parent.removeChild(dis);
					}
					collect();
				}
			}), (0 - endTime));
			timeLite.play();
		}
		
//		
//		public function hurtFlutter2(dis:DisplayObject):void{
//			var b:int;
//			const c:int = -45;
//			var a:int;
//			var timeLite:TimelineLite;
//			var dis:DisplayObject = dis;
//			b = yConst[int((Math.random() * yConst.length))];
//			a = xConst[int((Math.random() * xConst.length))];
//			var maxX:int = ((Math.sqrt(((b - c) / b)) * a) + a);
//			const staTime:Number = 0.35;
//			const endTime:Number = 0.55;
//			var _x:int = (_target.sceneX + dis.x);
//			var _y:int = (_target.sceneY + dis.y);
//			dis.y = ((_target.sceneY + dis.y) - 10);
//			var _width:int = dis.width;
//			var _height:int = dis.height;
//			var startX:int = (_target.sceneX - ((_width * 1.5) / 2));
//			var midleX:int = (_target.sceneX - ((_width * 1.2) / 2));
//			var endX:int = (_target.sceneX - ((_width * 0.6) / 2));
//			var hGrap:int;
//			var sGrap:int;
//			if (a < 0){
//				sGrap = (startX - _x);
//				hGrap = (startX - endX);
//			};
//			var startY:int = (dis.y + (((_height * 0.8) - (_height * 1.5)) / 2));
//			dis.scaleX = (dis.scaleY = 0.8);
//			dis.x = endX;
//			dis.alpha = 0.9;
//			if (!dis.parent){
//				_target.scene.addEffect(dis);
//			};
//			timeLite = new TimelineLite();
//			timeLite.append(new TweenLite(dis, 0.05, {
//				y:startY,
//				x:startX,
//				scaleX:1.5,
//				scaleY:1.5,
//				alpha:1.2,
//				ease:Sine.easeOut
//			}), 0.08);
//			timeLite.append(new TweenLite(dis, staTime, {
//				x:((startX - a) - (sGrap * 2)),
//				ease:Linear.easeNone
//			}), 0.1);
//			timeLite.append(new TweenLite(dis, staTime, {
//				y:(startY - b),
//				ease:Quad.easeOut,
//				scaleX:1,
//				scaleY:1
//			}), (0 - staTime));
//			timeLite.append(new TweenLite(dis, endTime, {
//				x:((startX - maxX) - (hGrap * 2)),
//				ease:Linear.easeNone
//			}));
//			timeLite.append(new TweenLite(dis, endTime, {
//				y:(startY - c),
//				ease:Quad.easeIn,
//				alpha:0.1,
//				scaleX:0.6,
//				scaleY:0.6,
//				onComplete:function ():void{
//					timeLite.stop();
//					timeLite = null;
//					if ((dis is MSprite)){
//						(dis as MSprite).dispose();
//					};
//					if (dis.parent){
//						dis.parent.removeChild(dis);
//					};
//				}
//			}), (0 - endTime));
//			timeLite.play();
//		}
//		
//		public function hurtFlutter1(dis:DisplayObject):void{
//			var b:int;
//			const c:int = -15;
//			var a:int;
//			var timeLite:TimelineLite;
//			var dis:DisplayObject = dis;
//			b = yConst[int((Math.random() * yConst.length))];
//			a = xConst[int((Math.random() * xConst.length))];
//			var maxX:int = ((Math.sqrt(((b - c) / b)) * a) + a);
//			const staTime:Number = 0.35;
//			const endTime:Number = 0.55;
//			var _x:int = (_target.sceneX + dis.x);
//			var _y:int = (_target.sceneY + dis.y);
//			dis.y = ((_target.sceneY + dis.y) - 10);
//			var _width:int = dis.width;
//			var _height:int = dis.height;
//			var startX:int = (_target.sceneX - ((_width * 1.5) / 2));
//			var midleX:int = (_target.sceneX - ((_width * 1.2) / 2));
//			var endX:int = (_target.sceneX - ((_width * 0.6) / 2));
//			var hGrap:int;
//			var sGrap:int;
//			if (a < 0){
//				sGrap = (startX - _x);
//				hGrap = (startX - endX);
//			};
//			var startY:int = (dis.y + (((_height * 0.8) - (_height * 1.5)) / 2));
//			dis.scaleX = (dis.scaleY = 0.8);
//			dis.x = endX;
//			dis.alpha = 0.9;
//			if (!dis.parent){
//				_target.scene.addEffect(dis);
//			};
//			timeLite = new TimelineLite();
//			timeLite.append(new TweenLite(dis, 0.06, {
//				y:startY,
//				x:startX,
//				scaleX:1.5,
//				scaleY:1.5,
//				alpha:1.3,
//				ease:Sine.easeOut
//			}), 0.06);
//			timeLite.append(new TweenLite(dis, 0.08, {
//				y:_y,
//				x:midleX,
//				scaleX:1.2,
//				scaleY:1.2,
//				ease:Sine.easeOut
//			}), 0.06);
//			timeLite.append(new TweenLite(dis, staTime, {
//				x:((startX - a) - (sGrap * 2)),
//				ease:Linear.easeNone
//			}), 0.06);
//			timeLite.append(new TweenLite(dis, staTime, {
//				y:(startY - b),
//				ease:Quad.easeOut,
//				scaleX:1,
//				scaleY:1
//			}), (0 - staTime));
//			timeLite.append(new TweenLite(dis, endTime, {
//				x:((startX - maxX) - (hGrap * 2)),
//				ease:Linear.easeNone
//			}));
//			timeLite.append(new TweenLite(dis, endTime, {
//				y:(startY - c),
//				ease:Quad.easeIn,
//				alpha:0.1,
//				scaleX:0.6,
//				scaleY:0.6,
//				onComplete:function ():void{
//					timeLite.stop();
//					timeLite = null;
//					if ((dis is MSprite)){
//						(dis as MSprite).dispose();
//					};
//					if (dis.parent){
//						dis.parent.removeChild(dis);
//					};
//				}
//			}), (0 - endTime));
//			timeLite.play();
//		}
		

		
		public function start():void
		{
			if (this._fightTextType == FightTextType.HurtNumber || this._fightTextType == FightTextType.AddNumber)
			{
				this.tweenHurtNumber();
			}
			else if (this._fightTextType == FightTextType.SelfHurtNumber)
			{
				this.tweenHurtNumber();
			}
			else if (this._fightTextType == FightTextType.CritHurtNumber)
			{
				this.tweenCritHurtNumber();
			}
			else if (this._fightTextType == FightTextType.MissType)
			{
				this.tweenMiss();
			}
			else if (this._fightTextType == FightTextType.BlockType)
			{
				this.tweenBlock();
			}
			else
			{
				this.tweenHurtNumber();
			}
		}
		
		
		private function tweenHurtNumber() : void
		{
			var timeLite:TimelineLite;
			var startY:Number = this.y;
			timeLite = new TimelineLite();
			timeLite.append(new TweenLite(this, 0.5, {y:startY - 85, ease:Back.easeOut, onComplete:function () : void
			{
				timeLite.stop();
				timeLite = null;
				collect();
			}
			}));
			timeLite.play();
		}
		
		private function tweenCritHurtNumber() : void
		{
			var timeLite:TimelineLite;
			var startX:Number = this.x;
			var startY:Number = this.y;
			timeLite = new TimelineLite();
			timeLite.append(new TweenLite(this, 0.1, {y:startY - 40}));
			timeLite.append(new TweenLite(this, 0.2, {y:startY - 50, x:startX - 45, scaleX:1.6, scaleY:1.6}));
			timeLite.append(new TweenLite(this, 0.2, {y:startY - 50, x:startX, scaleX:1, scaleY:1}));
			timeLite.append(new TweenLite(this, 0.6, {y:startY - 100, onComplete:function () : void
			{
				timeLite.stop();
				timeLite = null;
				collect();
			}
			}));
			timeLite.play();
		}
		
		private function tweenMiss() : void
		{
			var timeLite:TimelineLite;
			var startY:Number = this.y;
			timeLite = new TimelineLite();
			timeLite.append(new TweenLite(this, 0.3, {y:startY - 70}));
			timeLite.append(new TweenLite(this, 0.5, {y:startY - 90, alpha:0.5, onComplete:function () : void
			{
				timeLite.stop();
				timeLite = null;
				collect();
			}
			}));
			timeLite.play();
		}
		
		private function tweenBlock() : void
		{
			var timeLite:TimelineLite;
			var startY:Number = this.y;
			timeLite = new TimelineLite();
			timeLite.append(new TweenLite(this, 0.3, {y:startY - 70}));
			timeLite.append(new TweenLite(this, 0.5, {y:startY - 90, alpha:0.5, onComplete:function () : void
			{
				timeLite.stop();
				timeLite = null;
				collect();
			}
			}));
			timeLite.play();
		}
		
		
		public function collect():void
		{
			if(_manager)
			{
				_manager.removeObj(this);
			}
		}
		
		public function move(vx:Number,vy:Number):void
		{
			_sceneX = vx;
			_sceneY = vy;
			if(_movie)setPos();
		}
		
		private function setPos():void
		{
			if(_movie)
			{
				x = _sceneX -( _movie.width >> 1);
				y = _sceneY;
			}
		}
		
		public function poolDispose():void
		{
			dispose();
		}
		
		public function dispose():void
		{
			_value = 0;
			_target = null;
			_type = 0;
			_isSelf = false;
			if(_movie && _movie.parent)
				_movie.parent.removeChild(_movie);
			if(this.parent && this.parent.contains(this) )
				this.parent.removeChild(this);
		}
		
//		public function update(times:int, dt:Number=0.04):void
//		{
//			for(var i:int = 0; i < times; i++)
//			{
//				if(!_isComplete)
//				{
//					_currentFrame++;
//					if(_currentFrame < 10)
//					{
//						move(_sceneX,_sceneY - 5);
//					}
//					else if(_currentFrame < 20){}
//					else if(_currentFrame < 26)
//					{
//						move(_sceneX,_sceneY - 8);
//						alpha -= 0.2;
//					}
//					else if(_currentFrame >= 40)
//					{
//						_isComplete = true;
//						collect();
//					}
//				}
//			}
//		}
	}
}