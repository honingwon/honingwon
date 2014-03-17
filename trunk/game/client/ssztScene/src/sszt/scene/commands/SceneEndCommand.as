package sszt.scene.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.scene.mediators.BigBossWarMediator;
	import sszt.scene.mediators.CityCraftMediator;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.scene.mediators.DoubleSitMediator;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.scene.mediators.EventMediator;
	import sszt.scene.mediators.GroupMediator;
	import sszt.scene.mediators.GuildPVPMediator;
	import sszt.scene.mediators.HangupMediator;
	import sszt.scene.mediators.NearlyMediator;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.mediators.SkillBarMediator;
	import sszt.scene.mediators.SmallMapMediator;
	import sszt.scene.mediators.TradeDirectMediator;
	
	public class SceneEndCommand extends SimpleCommand
	{
		public function SceneEndCommand()
		{
			super();
		} 
		
		override public function execute(notification:INotification):void
		{
			facade.removeMediator(SceneMediator.NAME);
			facade.removeMediator(SmallMapMediator.NAME);
			facade.removeMediator(ElementInfoMediator.NAME);
			facade.removeMediator(SkillBarMediator.NAME);
			facade.removeMediator(ReliveMediator.NAME);
			facade.removeMediator(GroupMediator.NAME);
			facade.removeMediator(NearlyMediator.NAME);
			facade.removeMediator(EventMediator.NAME);
			facade.removeMediator(HangupMediator.NAME);
			facade.removeMediator(DoubleSitMediator.NAME);
			facade.removeMediator(TradeDirectMediator.NAME);
			facade.removeMediator(CopyGroupMediator.NAME);
			facade.removeMediator(BigBossWarMediator.NAME);
			facade.removeMediator(GuildPVPMediator.NAME);
			facade.removeMediator(CityCraftMediator.NAME);
		}
	}
}