package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import scene.events.BaseSceneObjectEvent;
	import scene.sceneObjs.BaseSceneObj;
	
	import sszt.core.action.ActionManager;
	import sszt.core.action.IAction;
	import sszt.core.caches.MovieCaches;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.MapElementType;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.data.scene.BaseRoleInfoUpdateEvent;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.core.data.scene.MoveType;
	import sszt.core.data.scene.PlayerStateUpdateEvent;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.paopao.PaopaoPanel;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.actions.characterActions.BaseCharacterAction;
	import sszt.scene.actions.characterActions.PlayerHpBarUpdateAction;
	import sszt.scene.data.SceneInfo;
	import sszt.scene.data.pools.BloodMoviePool;
	import sszt.scene.data.pools.ScenePoolManager;
	
	public class BaseRole extends BaseSceneObj
	{
		private static var _shadowAsset:BitmapData;
		public static function getShadowAsset():BitmapData
		{
			if(!_shadowAsset)
			{
				_shadowAsset = AssetUtil.getAsset("ssztui.scene.ShadowAsset") as BitmapData;
			}
			return _shadowAsset;
		}
		
		public static const OVER_EFFECT:GlowFilter = new GlowFilter(0xffffff,1,6,6,4);
		public static const NICK_FORMAT:TextFormat = new TextFormat(LanguageManager.getWord("ssztl.common.wordType"),12,0xFFFFFF,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,4);
		public static const NICK_FILTER:Array = [new GlowFilter(0x000000,1,2,2,10)]; //0x1D250E,1,4,4,4.5
		
//		private static var _bloodBarForData:BitmapData;
//		private static var _bloodBarBgData:BitmapData;
		
		protected var _character:ICharacter;
		protected var nick:TextField;
		protected var bloodBar:BloodBars2;
		protected var _actionManager:ActionManager;
		protected var _hpBarAction:PlayerHpBarUpdateAction;
		protected var _walkComplete:Function;
		private var _hideTime:int;
		private var _selectedEffect:BaseEffect;
		protected var _shadow:Bitmap;
		public var isMouseSelect:Boolean;
		protected var _paopao:PaopaoPanel;
		
		private var lastTweenTime:int = 0;
		private var vcFightText:Array;
		private const tweenTime:int = 100;
		private var _timeoutIndex:int =  -1;
		private var _roleAutoEffect:RoleAutoEffect;
		
		public function BaseRole(info:BaseRoleInfo)
		{
			super(info);
		}
		
		override protected function init():void
		{
			super.init();
			vcFightText = [];
			_shadow = new Bitmap(getShadowAsset());
			_shadow.x = -32;
			_shadow.y = -12;
			addChildAt(_shadow,0);
			
			nick = new TextField();
			nick.mouseWheelEnabled = false;
			nick.defaultTextFormat = NICK_FORMAT;
			nick.setTextFormat(NICK_FORMAT);
			nick.x = -75;
			nick.y = -150;
			nick.width = 120;
			nick.height = 100;
			nick.mouseEnabled = false;
			nick.width = 150;
			nick.filters = NICK_FILTER;
			addChild(nick);
			
			initCharacter();
			initWalkAction();
			
//			if(!_bloodBarForData)
//			{
//				_bloodBarForData = new BitmapData(4,6,false,0xff0000);
//			}
//			if(!_bloodBarBgData)
//			{
//				_bloodBarBgData = new BitmapData(54,8,false,0);
//			}
			
			initBloodBar();
			_actionManager = new ActionManager(_info.getName());
			GlobalAPI.tickManager.addTick(_actionManager);
			
			_hpBarAction = new PlayerHpBarUpdateAction(this);
			isMouseSelect = false;
			if(_info.dir != 0)
			{
				updateDir(_info.dir);
			}			
		}
		
		protected function showShadow():void
		{
			if(_shadow && _character && _character.parent == this)
			{
				if(_shadow.parent == this)
				{
					setChildIndex(_shadow,0);
				}
				else
					addChildAt(_shadow,0);
			}
		}
		protected function hideShadow():void
		{
			if(_shadow && _shadow.parent)_shadow.parent.removeChild(_shadow);
		}
		
		protected function initBloodBar():void
		{
//			bloodBar = BloodBars.getBloodBar(_bloodBarForData,_bloodBarBgData,getCurrentHP(),getTotalHP());
//			bloodBar.move(-20,-120);
			bloodBar = new BloodBars2();
			bloodBar.setLife(getCurrentHP(),getTotalHP());
			bloodBar.move(-30,-120);
		}
		
		protected function initCharacter():void
		{
		}
		
		protected function initWalkAction():void
		{
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_info.addEventListener(BaseSceneObjInfoUpdateEvent.WALK_START,walkStartHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.ADDACTION,addActionHandler);
//			_info.addEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,infoUpdateHandler);
			_info.addEventListener(BaseSceneObjInfoUpdateEvent.SELECTED_CHANGE,selectedChangeHandler);
			getBaseRoleInfo().state.addEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.DO_WALK_ACTION,doWalkActionHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.DIR_UPDATE,dirUpdateHandler);
			_info.addEventListener(BaseRoleInfoUpdateEvent.WALK_COMPLETE,walkCompleteHandler);
			_info.addEventListener(BaseSceneObjInfoUpdateEvent.MOVE,moveHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_info.removeEventListener(BaseSceneObjInfoUpdateEvent.WALK_START,walkStartHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.ADDACTION,addActionHandler);
//			_info.removeEventListener(BaseRoleInfoUpdateEvent.INFO_UPDATE,infoUpdateHandler);
			_info.removeEventListener(BaseSceneObjInfoUpdateEvent.SELECTED_CHANGE,selectedChangeHandler);
			getBaseRoleInfo().state.removeEventListener(PlayerStateUpdateEvent.STATE_CHANGE,playerStateUpdateHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.DO_WALK_ACTION,doWalkActionHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.DIR_UPDATE,dirUpdateHandler);
			_info.removeEventListener(BaseRoleInfoUpdateEvent.WALK_COMPLETE,walkCompleteHandler);
			_info.removeEventListener(BaseSceneObjInfoUpdateEvent.MOVE,moveHandler);
		}
		
		protected function walkStartHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			_info.setMoving();
		}
		
		override public function get dir():int
		{
			if(_character)return _character.dir;
			return 0;
		}
		
		protected function walkComplete():void
		{
			_info.setStand();
		}
		protected function walkCompleteHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			walkComplete();
		}
		
		protected function moveHandler(evt:BaseSceneObjInfoUpdateEvent):void
		{
			if(this.scene && _info)
			{
				var p:Point = new Point(_info.sceneX,_info.sceneY);
				this.scene.move(this,p);
				if((this.scene.mapData as SceneInfo).mapInfo.isAlpha(_info.sceneX,_info.sceneY))
				{
					if(this._character.alpha != 0.5)
						this._character.alpha = 0.5;
				}
				else
				{
					if(this._character.alpha != 1)
						this._character.alpha = 1;
				}
			}
		}
		
		public function get isMoving():Boolean
		{
			if(!_info)return false;
			return _info.moveType == MoveType.WALK;
		}
		
		
		override public function doMouseOver():void
		{
			if(_character)_character.filters = [OVER_EFFECT];
		}
		override public function doMouseOut():void
		{
			if(_character)_character.filters = null;
		}
		override public function doMouseClick():void
		{
			dispatchEvent(new BaseSceneObjectEvent(BaseSceneObjectEvent.SCENEOBJ_CLICK));
		}
		
		override public function isMouseOver():Boolean
		{
			if(_mouseAvoid)return false;
			if(_character)
			{
				return !_character.getIsAlpha((_character as DisplayObject).mouseX,(_character as DisplayObject).mouseY);
			}
			return false;
		}
		
		public function showHpBar():void
		{
			if(bloodBar.parent == null)
			{
				nick.y -= 10;
				bloodBar.y = nick.y + nick.textHeight + 8;
				addChild(bloodBar);
			}
		}
		public function hideHpBar():void
		{
			if(bloodBar && bloodBar.parent)
			{
				bloodBar.parent.removeChild(bloodBar);
				nick.y += 10;
			}
		}
		
		public function showPaopao(message:String):void
		{
			if(_paopao == null)
			{
				_paopao = new PaopaoPanel();
			}
			_paopao.show(message,this);
		}
		
		protected function playerStateUpdateHandler(e:PlayerStateUpdateEvent):void
		{
			if(getBaseRoleInfo().getIsFight())
			{
				_hpBarAction.configure();
				GlobalAPI.tickManager.addTick(_hpBarAction);
			}
			else
			{
				hideHpBar();
				GlobalAPI.tickManager.removeTick(_hpBarAction);
			}
			
			if(getBaseRoleInfo().getIsSlow())
			{
				if(getBaseRoleInfo().preSpeed == 0)
				{
					getBaseRoleInfo().preSpeed = getBaseRoleInfo().speed;
					getBaseRoleInfo().speed = 1;
				}
			}
			else
			{
				if(getBaseRoleInfo().preSpeed != 0)
				{
					getBaseRoleInfo().speed = getBaseRoleInfo().preSpeed;
					getBaseRoleInfo().preSpeed = 0;
				}
			}
		}
		/**
		 * 走路的时候会调用，避免出现漂移现象
		 * 
		 */		
		public function doWalkAction():void
		{
		}
		protected function doWalkActionHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			doWalkAction();
		}
		
		private function selectedChangeHandler(e:BaseSceneObjInfoUpdateEvent):void
		{
			setSelected(_info.selected);
		}
		
		private function setSelected(value:Boolean):void
		{
			if(value)
			{
				if(!_selectedEffect)
				{
					switch(_info.getObjType())
					{
						case MapElementType.MONSTER:
							_selectedEffect = MovieCaches.getSelectedEffect();
							break;
						case MapElementType.PLAYER:
							_selectedEffect = MovieCaches.getSelectedPlayerEffect();
							break;
					}
					
				}
				if(_selectedEffect)
				{
					_selectedEffect.move(0,0);
					addChildAt(_selectedEffect,0);
					_selectedEffect.play();
				}
			}
			else
			{
				if(_selectedEffect && _selectedEffect.parent)
				{
					_selectedEffect.stop();
					_selectedEffect.parent.removeChild(_selectedEffect);
				}
			}
		}
		
		public function getBaseRoleInfo():BaseRoleInfo
		{
			return _info as BaseRoleInfo;
		}
		
		public function get titleY():Number
		{
			return 0; 
		}
		
		private function addActionHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			var action:BaseCharacterAction = evt.data as BaseCharacterAction;
			action.setCharacter(this);
			_actionManager.addAction(action);
		}
		
		protected function addAction(action:IAction):void
		{
			_actionManager.addAction(action);
		}
		
		protected function removeAction(action:IAction):void
		{
			_actionManager.removeAction(action);
		}
		
//		public function updateLife():void
//		{
//			bloodBar.updateLife(getCurrentHP(),getTotalHP());
//		}
		
		protected function setLife():void
		{
			bloodBar.updateLife(getCurrentHP(),getTotalHP());
		}
		
		public function updateDir(dir:int):void
		{
			if(_character)_character.updateDir(dir);
		}
		protected function dirUpdateHandler(evt:BaseRoleInfoUpdateEvent):void
		{
			updateDir(int(evt.data));
		}
		
		public function getCharacter():ICharacter
		{
			return _character;
		}
		
		override public function move(x:Number,y:Number):void
		{
			
		}
		
		override public function getCanAttack():Boolean
		{
			return super.getCanAttack();
		}
				
		protected function getCurrentHP():int{return 0;}
		protected function getTotalHP():int{return 0;}
		
		
		protected function drawNick() : void
		{
		} 
		
		protected function drawFigure() : void
		{
		} 
		
		protected function getNickY() : int
		{
			return -180;
		} 
		
		protected function drawNickPosition() : void
		{
			nick.y = getNickY();
		}
		
		public function bloodMovie(param:Object):void
		{
			setLife();
			
			var value:int = param[0];
			var type:int = param[1];
			var isSelf:Boolean = param[2];
			
			var obj:Array = [this,value,type,isSelf];
			
			showHurtFlutter(obj);
			
		}
		
		
		private function showHurtFlutter(obj:Array) : void
		{
			var t:Number = getTimer();
			if (t - this.lastTweenTime > this.tweenTime)
			{
				this.lastTweenTime = t;
			}
			else
			{
				if (this.vcFightText.length <= 40)
				{
					this.vcFightText.push(obj);
				}
				return;
			}
			var blood:BloodMoviePool = ScenePoolManager.bloodMovieManager.getObj(obj) as BloodMoviePool;
			
			
//			blood.hurtFlutter();
			_timeoutIndex = setTimeout(___tweenNext, this.tweenTime + 10);
		}
		
		private function ___tweenNext() : void
		{
			if (vcFightText && this.vcFightText.length > 0)
			{
				showHurtFlutter(vcFightText.shift());
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			clearTimeout(_timeoutIndex);
			_timeoutIndex = -1;
			vcFightText = [];
			
			if(_hpBarAction)
			{
				_hpBarAction.dispose();
				_hpBarAction = null;
			}
			if(_actionManager)
			{
				GlobalAPI.tickManager.removeTick(_actionManager);
				_actionManager.dispose();
				_actionManager = null;
			}
			//静态不需要dispose
			if(_selectedEffect)
			{
				_selectedEffect.stop();
				_selectedEffect = null;
			}
			if(bloodBar)
			{
//				bloodBar.dispose();
//				BloodBars.collectBloodBar(bloodBar);
				if(bloodBar.parent && bloodBar.parent.contains(bloodBar))
				{
					bloodBar.parent.removeChild(bloodBar);
				}
				bloodBar = null;
			}
			if(_character)
			{
				_character.dispose();
				_character = null;
			}
			if(_paopao)
			{
				_paopao.dispose();
				_paopao = null;
			}
			_walkComplete = null;
		}
	}
}