package sszt.scene.components.sceneObjs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.GlobalData;
	import sszt.core.data.cityCraft.CityCraftEvent;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.npc.NpcTemplateInfo;
	import sszt.core.data.npc.NpcTemplateList;
	import sszt.core.data.player.FigurePlayerInfo;
	import sszt.core.data.scene.BaseRoleInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.core.view.effects.BaseEffect;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.character.ICharacter;
	import sszt.scene.data.roles.NpcRoleInfo;
	import sszt.ui.label.MAssetLabel;
	
	public class BaseSceneNpc extends BaseRole
	{
		private static var _sceneNpcGrayData:BitmapData;
		private static function getSceneNpcGrapData():BitmapData
		{
			if(!_sceneNpcGrayData)
			{
				_sceneNpcGrayData = AssetUtil.getAsset("mhsm.scene.SceneNpcTaskGrayAsset1") as BitmapData;
			}
			return _sceneNpcGrayData;
		}
		
		private var carrer:MAssetLabel;
		private var _taskAcceptEffect:BaseLoadEffect;
		private var _taskSubmitEffect:BaseLoadEffect;
		private var _taskNotSubmitEffect:BaseLoadEffect;
		
		public function BaseSceneNpc(info:BaseRoleInfo)
		{
			super(info);
		}
		
		override protected function init():void
		{
			super.init();
			
//			nick.move(0,-120);
//			nick.y = -140;
			nick.y = 0 - getNpcTempalte().picHeight;
			if(getNpcTempalte().templateId == 102137)
			{
				nick.htmlText = "<font color='#eddb60'>[城主]"+GlobalData.cityCraftInfo.cityMaster+"</font>";
				GlobalData.cityCraftInfo.addEventListener(CityCraftEvent.MASTER_UPDATE,cityMasterUpdateHandler);
			}
			else
			{
				nick.htmlText = "<font color='#eddb60'>"+getNpcTempalte().name+"</font>";
			}
			
			mouseChildren = mouseEnabled = tabChildren = tabEnabled = false;
			
			carrer = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.CENTER);
//			carrer.move(0,-155);
			carrer.move(0,-15 - getNpcTempalte().picHeight);
			addChild(carrer);
			if(getNpcTempalte().funcName != LanguageManager.getWord("ssztl.common.none"))
			{
				if(getNpcTempalte().templateId == 102137)
					carrer.htmlText ="<font color='#00ffff'>[王城帮会]" + GlobalData.cityCraftInfo.defenseGuild + "</font>";
				else
					carrer.htmlText ="<font color='#00ffff'>" + getNpcTempalte().funcName + "</font>";
			}
		}
		
		public function getNpcTempalte():NpcTemplateInfo
		{
			return getNpcRoleInfo().template;
		}
		
		public function getNpcRoleInfo():NpcRoleInfo
		{
			return _info as NpcRoleInfo;
		}
		override public function isMouseOver():Boolean
		{
//			if(_asset && stage && _asset.hitTestPoint(stage.mouseX,stage.mouseY))return true;
			if(_taskAcceptEffect && _taskAcceptEffect.stage && _taskAcceptEffect.hitTestPoint(stage.mouseX,stage.mouseY))return true;
			if(_taskSubmitEffect && _taskSubmitEffect.stage && _taskSubmitEffect.hitTestPoint(stage.mouseX,stage.mouseY))return true;
			if(_taskNotSubmitEffect && _taskNotSubmitEffect.stage && _taskNotSubmitEffect.hitTestPoint(stage.mouseX,stage.mouseY))return true;
			return super.isMouseOver();
		}
		
		override protected function initCharacter():void
		{
			_character = GlobalAPI.characterManager.createSceneNpcCharacter(getNpcTempalte());
			_character.addEventListener(Event.COMPLETE,characterLoadCompleteHandler);
			_character.show();
//			_character.move(-185,-230);
			addChild(_character as DisplayObject);
			
//			_asset = new SceneNpcTaskAsset();
//			_asset.x = 5;
//			_asset.y = -192;
//			addChild(_asset);
//			_asset.gotoAndStop(getNpcRoleInfo().taskState + 1);
			updateStateHandler(null);
		}
		private function cityMasterUpdateHandler(e:CityCraftEvent):void
		{
			nick.htmlText = "<font color='#eddb60'>[城主]"+GlobalData.cityCraftInfo.cityMaster+"</font>";
			carrer.htmlText ="<font color='#00ffff'>[王城帮会]" + GlobalData.cityCraftInfo.defenseGuild + "</font>";
		}
		private function characterLoadCompleteHandler(evt:Event):void
		{
			_character.removeEventListener(Event.COMPLETE,characterLoadCompleteHandler);
		}
		
		override protected function initEvent():void
		{
			super.initEvent();
			_info.addEventListener(NpcRoleInfo.UPDTAE_STATE,updateStateHandler);
		}
		
		override protected function removeEvent():void
		{
			super.removeEvent();
			_info.removeEventListener(NpcRoleInfo.UPDTAE_STATE,updateStateHandler);
			GlobalData.cityCraftInfo.removeEventListener(CityCraftEvent.MASTER_UPDATE,cityMasterUpdateHandler);
		}
		
		private function updateStateHandler(e:Event):void
		{
//			_asset.gotoAndStop(getNpcRoleInfo().taskState + 1);
			var state:int = getNpcRoleInfo().taskState;
			if(state == 0)
			{
				clearAllState();
			}
			else if(state == 1)
			{
				if(_taskAcceptEffect)
				{
					_taskAcceptEffect.dispose();
					_taskAcceptEffect = null;
				}
				if(_taskNotSubmitEffect && _taskNotSubmitEffect)
				{
					_taskNotSubmitEffect.parent.removeChild(_taskNotSubmitEffect);
					_taskNotSubmitEffect = null;
				}
				if(!_taskSubmitEffect)
				{
					_taskSubmitEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.HAS_TASK_SUBMIT));
					_taskSubmitEffect.play(SourceClearType.NEVER);
//					_taskSubmitEffect.move(-45,-240);
					_taskSubmitEffect.move(0,-20 - getNpcTempalte().picHeight);
					addChild(_taskSubmitEffect);
				}
			}
			else if(state == 2)
			{
				if(_taskNotSubmitEffect && _taskNotSubmitEffect)
				{
					_taskNotSubmitEffect.parent.removeChild(_taskNotSubmitEffect);
					_taskNotSubmitEffect = null;
				}
				if(_taskSubmitEffect)
				{
					_taskSubmitEffect.dispose();
					_taskSubmitEffect = null;
				}
				if(!_taskAcceptEffect)
				{
					_taskAcceptEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.HAS_TASK_ACCEPT));
					_taskAcceptEffect.play(SourceClearType.NEVER);
//					_taskAcceptEffect.move(-45,-240);
					_taskAcceptEffect.move(0,-20 - getNpcTempalte().picHeight);
					addChild(_taskAcceptEffect);
				}
			}
			else if(state == 3)
			{
				if(_taskAcceptEffect)
				{
					_taskAcceptEffect.dispose();
					_taskAcceptEffect = null;
				}
				if(_taskSubmitEffect)
				{
					_taskSubmitEffect.dispose();
					_taskSubmitEffect = null;
				}
				if(!_taskNotSubmitEffect)
				{
					_taskNotSubmitEffect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.HAS_TASK_NOT_SUBMIT));
					_taskNotSubmitEffect.play(SourceClearType.NEVER);
					_taskNotSubmitEffect.move(0,-20 - getNpcTempalte().picHeight);
					addChild(_taskNotSubmitEffect);
				}
			}
		}
		private function clearAllState():void
		{
			if(_taskAcceptEffect)
			{
				_taskAcceptEffect.dispose();
				_taskAcceptEffect = null;
			}
			if(_taskNotSubmitEffect)
			{
				_taskNotSubmitEffect.dispose();
				_taskNotSubmitEffect = null;
			}
			if(_taskSubmitEffect)
			{
				_taskSubmitEffect.dispose();
				_taskSubmitEffect = null;
			}
		}
		
		override public function dispose():void
		{
			clearAllState();
			if(_character)
				_character.removeEventListener(Event.COMPLETE,characterLoadCompleteHandler);
			super.dispose();
		}
	}
}