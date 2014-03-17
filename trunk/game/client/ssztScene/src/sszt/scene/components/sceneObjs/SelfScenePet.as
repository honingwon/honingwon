package sszt.scene.components.sceneObjs 
{
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.interfaces.tick.ITick;
	import sszt.scene.actions.SelfPetAttackAction;
	import sszt.scene.data.roles.BaseScenePetInfo;
	import sszt.scene.data.roles.BaseScenePlayerInfo;
	import sszt.scene.data.roles.SelfScenePetInfo;
	import sszt.scene.events.SceneInfoUpdateEvent;
	import sszt.scene.mediators.SceneMediator;
	
	public class SelfScenePet extends BaseScenePet {
		
		private var _list:Array;
		private var _lastTime:Number;
		private var _quality:int;
		private var _selfPetAttackAction:SelfPetAttackAction;
		private var _mediator:SceneMediator;
		private var _ownerInfo:BaseScenePlayerInfo;
		private var _fightState:Boolean;
		
		public function SelfScenePet(info:BaseScenePetInfo, mediator:SceneMediator){
			this._mediator = mediator;
			this._ownerInfo = this._mediator.sceneInfo.playerList.getPlayer(info.owner);
			super(info);
		}
		
		override protected function configUI():void{
			super.configUI();
			this._selfPetAttackAction = new SelfPetAttackAction(this, this._mediator);
		}
		
		override public function hidePet():void{
			this.visible = true;
			if (_character){
				_character.alpha = 0.5;
			}
		}
		
		override public function showPet():void{
			this.visible = true;
			if (_character){
				_character.alpha = 1;
			}
		}
		
		override protected function initEvent():void{
			super.initEvent();
			if (this._ownerInfo)
			{
				this._ownerInfo.state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE, this.ownerStateChangeHandler);
			}
			this._mediator.sceneInfo.addEventListener(SceneInfoUpdateEvent.SELECT_CHANGE, this.selectChangeHandler);
		}
		
		override protected function removeEvent():void{
			super.removeEvent();
			if (this._ownerInfo)
			{
				this._ownerInfo.state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE, this.ownerStateChangeHandler);
			}
			this._mediator.sceneInfo.removeEventListener(SceneInfoUpdateEvent.SELECT_CHANGE, this.selectChangeHandler);
		}
		
		private function ownerStateChangeHandler(evt:PlayerStateUpdateEvent):void{
			this.checkAttack();
		}
		
		private function selectChangeHandler(evt:SceneInfoUpdateEvent):void{
			this.checkAttack();
		}
		
		private function checkAttack():void{
			var tmpFightState:Boolean;
			if (this._ownerInfo){
				tmpFightState = this._ownerInfo.state.getFight();
				this._fightState = tmpFightState;
				if (this._fightState && this._mediator.sceneInfo.getCurrentSelect())
				{
					this.startAttack();
				} 
				else {
					this.stopAttack();
				}
			}
		}
		
		private function startAttack():void{
			this._selfPetAttackAction.configure();
			
		}
		
		private function stopAttack():void{
			this._selfPetAttackAction.stop();
		}
		
		public function get selfScenePetInfo():SelfScenePetInfo{
			return _info as SelfScenePetInfo;
		}
		override public function dispose():void{
			super.dispose();
			if (this._selfPetAttackAction){
				this._selfPetAttackAction.dispose();
				this._selfPetAttackAction = null;
			}
			this._list = null;
			this._mediator = null;
			this._ownerInfo = null;
		}
		
	}
}