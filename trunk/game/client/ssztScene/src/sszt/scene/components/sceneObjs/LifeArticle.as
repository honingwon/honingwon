/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-29 上午11:20:34 
 * 
 */ 
package sszt.scene.components.sceneObjs
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class LifeArticle extends Sprite {
		
		private var lifeUp:Bitmap;
		private var lifeDown:Bitmap;
		private var upMask:Sprite;
		private var downMask:Sprite;
		private var _lifeW:int;
		private var _lifeH:int;
		public var upTime:Number = 0.5;
		public var downTime:Number = 0.5;
		private var _lifeX:Number = 0;
		private var tween:TweenLite;
		private var tweenUp:TweenLite;
		private var tweenDown:TweenLite;
		private var _upSkin:String;
		private var _downSkin:String;
		
		public function LifeArticle(w:int, h:int, upSkin:Bitmap, downSkin:Bitmap){
			this.lifeW = w;
			this.lifeH = h;
			this.lifeDown = downSkin;
			this.addChild(this.lifeDown);
			this.downMask = new Sprite();
			this.addChild(this.downMask);
			this.setLife(this.lifeDown, this.downMask);
			
			this.lifeUp = upSkin;
			this.lifeUp.width = this.lifeW;
			this.lifeUp.height = this.lifeH;
			
			this.addChild(this.lifeUp);
			this.upMask = new Sprite();
			this.addChild(this.upMask);
			this.setLife(this.lifeUp, this.upMask);
			this.lifeValue = 0;
		}
		private function setLife(bm:Bitmap, mask:Sprite):void{
			this.setMask(mask);
			bm.mask = mask;
		}
		private function setMask(mask:Sprite):void{
			mask.graphics.clear();
			mask.graphics.beginFill(0);
			mask.graphics.drawRect(0, 0, this.lifeW, this.lifeH);
			mask.graphics.endFill();
		}
		public function get lifeH():int{
			return (this._lifeH);
		}
		public function set lifeH(value:int):void{
			this._lifeH = value;
			if (this.lifeUp){
				this.lifeUp.height = value;
				this.setMask(this.upMask);
			}
			if (this.lifeDown){
				this.lifeDown.height = value;
				this.setMask(this.downMask);
			}
		}
		public function get lifeW():int{
			return (this._lifeW);
		}
		public function set lifeW(value:int):void{
			this._lifeW = value;
			if (this.lifeUp){
				this.lifeUp.width = value;
				this.setMask(this.upMask);
			}
			if (this.lifeDown){
				this.lifeDown.width = value;
				this.setMask(this.downMask);
			}
		}
		
		public function get lifeX():Number{
			return (this._lifeX);
		}
		public function set lifeX(value:Number):void{
			var temp:Number;
			temp = (value - this.lifeW);
			temp = (((temp)>0) ? 0 : temp);
			if (temp > this._lifeX){
				this.lifeIncrease(temp);
			} else {
				this.lifeReduce(temp);
			}
			this._lifeX = temp;
		}
		private function lifeIncrease(value:Number):void{
			if (this.tweenUp){
				this.tweenUp.kill();
			}
			if (this.tweenDown){
				this.tweenDown.kill();
			}
			this.tweenUp = TweenLite.to(this.upMask, this.upTime, {x:value});
			this.tweenDown = TweenLite.to(this.downMask, this.downTime, {x:value});
		}
		private function lifeReduce(value:Number):void{
			if (this.tweenUp){
				this.tweenUp.complete();
			}
			if (this.tweenDown){
				this.tweenDown.kill();
			}
			this.upMask.x = value;
			this.tweenDown = TweenLite.to(this.downMask, this.downTime, {x:value});
//			function onStartFun():void {
//				upMask.x = value;
//			}
		}
		
		public function set lifeValue(value:Number):void{
			if (this.tweenUp){
				this.tweenUp.complete();
			}
			if (this.tweenDown){
				this.tweenDown.complete();
			}
			var temp:Number = (value - this.lifeW);
			temp = (((temp)>0) ? 0 : temp);
			this.upMask.x = temp;
			this.downMask.x = temp;
		}
		
	}
}
