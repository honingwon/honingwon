package sszt.scene.commands
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import sszt.scene.SceneModule;
	import sszt.scene.mediators.AcroSerMediator;
	import sszt.scene.mediators.BigBossWarMediator;
	import sszt.scene.mediators.BigMapMediator;
	import sszt.scene.mediators.BossWarMediator;
	import sszt.scene.mediators.CityCraftMediator;
	import sszt.scene.mediators.CopyGroupMediator;
	import sszt.scene.mediators.DoubleSitMediator;
	import sszt.scene.mediators.DuplicateLotteryMediator;
	import sszt.scene.mediators.ElementInfoMediator;
	import sszt.scene.mediators.EventMediator;
	import sszt.scene.mediators.GroupMediator;
	import sszt.scene.mediators.GuildPVPMediator;
	import sszt.scene.mediators.HangupMediator;
	import sszt.scene.mediators.LifeExpSitMediator;
	import sszt.scene.mediators.MedicinesCautionMediator;
	import sszt.scene.mediators.NearlyMediator;
	import sszt.scene.mediators.NewcomerGiftMediator;
	import sszt.scene.mediators.QuickIconMediator;
	import sszt.scene.mediators.ReliveMediator;
	import sszt.scene.mediators.SceneClubMediator;
	import sszt.scene.mediators.SceneMediator;
	import sszt.scene.mediators.SceneWarMediator;
	import sszt.scene.mediators.SkillBarMediator;
	import sszt.scene.mediators.SmallMapMediator;
	import sszt.scene.mediators.SpaMediator;
	import sszt.scene.mediators.TargetFinishMediator;
	import sszt.scene.mediators.TradeDirectMediator;
	import sszt.scene.mediators.TreasureMediator;
	
	public class SceneStartCommand extends SimpleCommand
	{
		public function SceneStartCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var module:SceneModule = notification.getBody() as SceneModule;
			facade.registerMediator(new SceneMediator(module));
			facade.registerMediator(new SmallMapMediator(module));
			facade.registerMediator(new ElementInfoMediator(module));
			facade.registerMediator(new SkillBarMediator(module));
			facade.registerMediator(new ReliveMediator(module));
			facade.registerMediator(new BigMapMediator(module));
			facade.registerMediator(new GroupMediator(module));
			facade.registerMediator(new NearlyMediator(module));
			facade.registerMediator(new EventMediator(module));
			facade.registerMediator(new HangupMediator(module));
			facade.registerMediator(new DoubleSitMediator(module));
			facade.registerMediator(new LifeExpSitMediator(module));
			facade.registerMediator(new NewcomerGiftMediator(module));
			facade.registerMediator(new TradeDirectMediator(module));
			facade.registerMediator(new CopyGroupMediator(module));
			facade.registerMediator(new QuickIconMediator(module));
			facade.registerMediator(new TargetFinishMediator(module));
			facade.registerMediator(new SceneWarMediator(module));
			facade.registerMediator(new SpaMediator(module));
			facade.registerMediator(new BossWarMediator(module));
			facade.registerMediator(new SceneClubMediator(module));
			facade.registerMediator(new AcroSerMediator(module));
			facade.registerMediator(new TreasureMediator(module));
			facade.registerMediator(new MedicinesCautionMediator(module));
			facade.registerMediator(new DuplicateLotteryMediator(module));
			facade.registerMediator(new BigBossWarMediator(module));
			facade.registerMediator(new GuildPVPMediator(module));
			facade.registerMediator(new CityCraftMediator(module));
		}
	}
}