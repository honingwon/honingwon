package sszt.friends.component
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextFormatAlign;
	
	import sszt.constData.CampType;
	import sszt.constData.CareerType;
	import sszt.core.data.im.ImPlayerInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.label.MAssetLabel;
	
	public class PlayerInfoView extends Sprite
	{
		private var nick:MAssetLabel;
		private var job:MAssetLabel;
		private var level:MAssetLabel;
		private var fightInfo:MAssetLabel;
		private var group:MAssetLabel;
		private var party:MAssetLabel;
		private var bg:IMovieWrapper;
		private var noLabel:MAssetLabel;
		
		public function PlayerInfoView()
		{
			super();
			initView();
		}
		
		private function initView():void
		{
			bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,14,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.name") + "：",MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(188,14,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.carrer2") + "：",MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,38,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.level") + "：",MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(188,38,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.score"),MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(22,61,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.camp") + "：",MAssetLabel.LABEL_TYPE_TAG)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(188,61,40,16),new MAssetLabel(LanguageManager.getWord("ssztl.common.club") + "：",MAssetLabel.LABEL_TYPE_TAG))
			]);
			addChild(bg as DisplayObject);
			
			nick = new MAssetLabel("",MAssetLabel.LABEL_TYPE22,TextFormatAlign.LEFT);
			nick.move(57,14);
			addChild(nick);
			
			job = new MAssetLabel("",MAssetLabel.LABEL_TYPE9,TextFormatAlign.LEFT);
			job.move(224,14);
			addChild(job);
			
			level = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			level.move(57,38);
			addChild(level);
			
			fightInfo = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			fightInfo.move(224,38);
			addChild(fightInfo);
			
			group = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			group.move(57,61);
			addChild(group);
			
			party = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			party.move(224,61);
			addChild(party);
			
			noLabel = new MAssetLabel(LanguageManager.getWord("ssztl.friends.notOnline"),MAssetLabel.LABEL_TYPE20,TextFormatAlign.LEFT);
			noLabel.move(78,33);
			addChild(noLabel);
			noLabel.visible = false;
		}
		
		public function showInfo(data:Object):void
		{
//			{id:id,nick:nick,sex:sex,level:level,camp:camp,career:career,clubName:clubName})
			if(data)
			{
				noLabel.visible = false;
				bg.visible = true;
				nick.visible = true;
				job.visible = true;
				level.visible = true;
				fightInfo.visible = true;
				group.visible = true;
				party.visible = true;
				nick.setValue(data.nick);
				job.setValue(CareerType.getNameByCareer(data.career));
				level.setValue(String(data.level));
				fightInfo.setValue(LanguageManager.getWord("ssztl.common.none"));
				group.setValue(CampType.getCampName(data.camp));
				if(data.clubName == "")
				{
					party.setValue(LanguageManager.getWord("ssztl.common.none"));
				}else
				{
					party.setValue(data.clubName);
				}
			}else
			{
				noLabel.visible = true;
				bg.visible = false;
				nick.visible = false;
				job.visible = false;
				level.visible = false;
				fightInfo.visible = false;
				group.visible = false;
				party.visible = false;
			}			
		}
		
		public function show():void
		{
			this.visible = true;
		}
		
		public function hide():void
		{
			this.visible = false;
		}
		
		public function move(x:Number,y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function dispose():void
		{
			nick = null;
			job = null;
			level = null;
			fightInfo = null;
			group = null;
			party = null;
			noLabel = null;
			if(bg)
			{
				bg.dispose();
				bg = null;
			}
			if(parent) parent.removeChild(this);
		}
	}
}