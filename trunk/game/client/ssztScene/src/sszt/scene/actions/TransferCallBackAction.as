/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2013-1-15 下午2:11:15 
 * 
 */ 
package sszt.scene.actions
{
	import flash.geom.Point;
	
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.checks.WalkChecker;
	import sszt.scene.data.collects.CollectItemInfo;
	import sszt.scene.mediators.SceneMediator;

	public class TransferCallBackAction implements ITick
	{
		private var _tickCount:int;
		private var _mediator:SceneMediator;
		
		public function TransferCallBackAction(mediator:SceneMediator){
			this._mediator = mediator;
		}
		
		public function configure():void{
			this._tickCount = 0;
			GlobalAPI.tickManager.addTick(this);
		}
		
		public function update(times:int, dt:Number=0.04):void{
			var collectItem:CollectItemInfo;
			if (this._tickCount > 25){
				this.stop();
				return;
			}
			this._tickCount++;
			
			if (GlobalData.transferType == 1){
				WalkChecker.doWalkToNpc(GlobalData.transferTarget);
				this.stop();
			} 
			else {
				if (GlobalData.transferType == 2){
					WalkChecker.doWalkToHangup(GlobalData.transferTarget);
					this.stop();
				} else {
					if (GlobalData.transferType == 3){
						collectItem = this._mediator.sceneInfo.collectList.getNearlyItemByTemplateId(GlobalData.transferTarget, new Point(this._mediator.sceneInfo.playerList.self.sceneX, this._mediator.sceneInfo.playerList.self.sceneY));
						if (collectItem){
							WalkChecker.doWalkToCenterCollect(GlobalData.transferTarget);
							this.stop();
						}
					}
				}
			}
		}
		
		public function stop():void{
			GlobalAPI.tickManager.removeTick(this);
			GlobalData.transferType = 0;
			GlobalData.transferTarget = 0;
		}
		
		public function dispose():void{
			this.stop();
			this._mediator = null;
		}
	}
}