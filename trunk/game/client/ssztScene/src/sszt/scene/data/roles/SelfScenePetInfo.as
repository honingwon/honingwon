package sszt.scene.data.roles
{
	import flash.geom.Point;
	
	import sszt.constData.CommonConfig;
	import sszt.core.data.scene.BaseSceneObjInfoUpdateEvent;
	import sszt.scene.actions.CharacterWalkActionII;
	import sszt.scene.components.sceneObjs.BaseRole;
	import sszt.scene.mediators.SceneMediator;

	public class SelfScenePetInfo extends BaseScenePetInfo
	{
		public function SelfScenePetInfo(mediator:SceneMediator,walkAction:CharacterWalkActionII)
		{
			super(mediator,walkAction);
		}
	}
}