/** 
 * @author lxb 
 * @E-mail: liaoxb1231@163.com 
 * @version 1.0.0 
 * 创建时间：2012-12-28 下午4:56:19 
 * 
 */ 
package sszt.scene.actions.characterActions
{
	import sszt.scene.data.fight.AttackActionInfo;

	public class PetWaitAttackAction extends CharacterWaitAttackAction
	{
		public function PetWaitAttackAction(info:AttackActionInfo)
		{
			super(info);
		}
		
		override protected function doWaiting():void
		{
		}
	}
}