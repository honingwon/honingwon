package sszt.scene.components.jumpPoints
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.SourceClearType;
	import sszt.core.data.EffectType;
	import sszt.core.data.map.MapTemplateList;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.scene.DoorTemplateInfo;
	import sszt.core.data.scene.DoorTemplateList;
	import sszt.core.data.scene.MapElementInfo;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.scene.components.sceneObjs.BaseMapElement;
	import sszt.ui.label.MAssetLabel;
	
	public class JumpPoints extends BaseMapElement
	{
		private var _effect:BaseLoadEffect;
		private var _nameField:MAssetLabel;
		
		public function JumpPoints(info:DoorTemplateInfo)
		{
			super(info);
		}
		
		override protected function init():void
		{
			super.init();
			mouseEnabled = true;
			canSort = false;
			_effect = new BaseLoadEffect(MovieTemplateList.getMovie(EffectType.DOOR_EFFECT));
//			_effect.blendMode = BlendMode.ADD;
			_effect.play(SourceClearType.NEVER);
			addChild(_effect);
			
			x = getJumpTemplate().sceneX;
			y = getJumpTemplate().sceneY;
			
			_nameField = new MAssetLabel("",MAssetLabel.LABEL_TYPE1,TextFormatAlign.CENTER);
			_nameField.move(0,-100);
			_nameField.mouseEnabled = false;
			addChild(_nameField);
//			_nameField.text = String(getJumpTemplate().nextMapId);
			_nameField.text = MapTemplateList.list[getJumpTemplate().nextMapId].name;
		}
		
		public function getJumpTemplate():DoorTemplateInfo
		{
			return _info as DoorTemplateInfo;
		}
		
		override public function dispose():void
		{
			if(_effect)
			{
				_effect.dispose();
				_effect = null;
			}
			super.dispose();
		}
	}
}