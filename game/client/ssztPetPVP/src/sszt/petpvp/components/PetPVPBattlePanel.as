package sszt.petpvp.components
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import sszt.constData.ActionType;
	import sszt.constData.DirectType;
	import sszt.constData.SourceClearType;
	import sszt.core.data.GlobalAPI;
	import sszt.core.data.movies.MovieTemplateInfo;
	import sszt.core.data.movies.MovieTemplateList;
	import sszt.core.data.pet.PetTemplateInfo;
	import sszt.core.data.pet.PetTemplateList;
	import sszt.core.data.skill.SkillTemplateInfo;
	import sszt.core.data.skill.SkillTemplateList;
	import sszt.core.manager.LanguageManager;
	import sszt.core.view.effects.BaseLoadEffect;
	import sszt.interfaces.character.ICharacter;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import sszt.petpvp.components.cell.PetSkillCell;
	import sszt.petpvp.data.PetPVPChallengeResultInfo;
	import sszt.petpvp.data.PetPVPPetItemInfo;
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAssetBtn1;
	import sszt.ui.mcache.titles.MCacheTitle1;
	import sszt.ui.progress.ProgressBar1;
	
	import ssztui.petPVP.BgAsset;
	import ssztui.petPVP.BgAsset2;
	import ssztui.petPVP.HeartIconAsset;
	import ssztui.petPVP.IconTipAsset;
	import ssztui.petPVP.TagAsset1;
	import ssztui.petPVP.TagAsset2;
	import ssztui.petPVP.TagAsset3;
	import ssztui.petPVP.TitleAsset;
	
	public class PetPVPBattlePanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		
		private const TIMES_MAX:int = 10;
		private var _result:PetPVPChallengeResultInfo;
		private var _skillIndex:int;
		private var _myTimer:Timer;
		private var _myPetHP:int;
		private var _opponetPetHP:int;
		private var _roundFight:int;
		
		private var _myPetNick:MAssetLabel;
		private var _opponetPetNick:MAssetLabel;
		private var _myPetFight:MAssetLabel;
		private var _opponetPetFight:MAssetLabel;
		private var _myPetSkillCells:Array;
		private var _myPetLifes:Array;
		private var _opponetPetSkillCells:Array;
		private var _opponetPetLifes:Array;
		private var _btnSkip:MCacheAssetBtn1;
//		private var _progressBar:ProgressBar1;
//		private var _progressBar1:ProgressBar1;
		
		private var _myPetCharacterbox:Sprite;
		private var _myPetCharacter:ICharacter;
		private var _oppoentCharacterbox:Sprite;
		private var _opponetCharacter:ICharacter;
		
		public function PetPVPBattlePanel(result:PetPVPChallengeResultInfo)
		{
			_result = result;
			
			_myPetSkillCells = [];
			_myPetLifes = []
			_opponetPetSkillCells = [];
			_opponetPetLifes = [];
			super(new MCacheTitle1('',new Bitmap(new TitleAsset())), true, -1);
			initEvent();
			updateCharacter();
		}
		
		private function initEvent():void
		{
			_btnSkip.addEventListener(MouseEvent.CLICK,actionSkipHandler);
		}
		
		private function removeEvent():void
		{
			_btnSkip.removeEventListener(MouseEvent.CLICK,actionSkipHandler);
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(646, 350);
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_11,new Rectangle(7,2,632,341)),
				new BackgroundInfo(BackgroundType.BORDER_12,new Rectangle(11,6,624,333)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(13,8,620,329),new Bitmap(new BgAsset2())),
			]); 
			addContent(_bg as DisplayObject);			
			
			_myPetNick = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B,'right');
			_myPetNick.textColor = 0xfffccc;
			_myPetNick.move(270,20);
			addContent(_myPetNick);
			_myPetNick.setValue(_result.petNick);
			
			_opponetPetNick = new MAssetLabel("",MAssetLabel.LABEL_TYPE21B,'left');
			_opponetPetNick.textColor = 0xfffccc;
			_opponetPetNick.move(372,20);
			addContent(_opponetPetNick);
			_opponetPetNick.setValue(_result.opponetPetNick);
			
			_myPetFight = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,'right');
			_myPetFight.move(270,45);
			addContent(_myPetFight);
			_myPetFight.setValue(LanguageManager.getWord("ssztl.common.fightValueEx")+_result.petFight.toString());
			
			_opponetPetFight = new MAssetLabel("",MAssetLabel.LABEL_TYPE20,'left');
			_opponetPetFight.move(372,45);
			addContent(_opponetPetFight);
			_opponetPetFight.setValue(LanguageManager.getWord("ssztl.common.fightValueEx")+_result.opponetPetFight.toString());
			
			_btnSkip = new MCacheAssetBtn1(0,3,LanguageManager.getWord('ssztl.petpvp.actionSkip'));
			_btnSkip.move(552,304);
			addContent(_btnSkip);
			
			var skillCell:PetSkillCell;
			for(var i:int =0; i<_result.myPetSkills.length; i++)
			{
				skillCell = new PetSkillCell();
				skillCell.skillTemplateID = _result.myPetSkills[i];
				addContent(skillCell);
				skillCell.move(15+i%4*40,19+int(i/4)*40);
				x = x+2+skillCell.width;
				_myPetSkillCells.push(skillCell);
			}
			
			for(i =0; i< _result.oppoentPetSkills.length; i++)
			{
				skillCell = new PetSkillCell();
				skillCell.skillTemplateID = _result.oppoentPetSkills[i];
				addContent(skillCell);
				skillCell.move(589-i%4*40,19+int(i/4)*40);
				_myPetSkillCells.push(skillCell);
			}
			
//			var heartBar:Sprite = new Sprite();
//			for(i=0; i<10; i++)
//			{
//				var heartIcon:Bitmap = new Bitmap(new HeartIconAsset());
//				heartIcon.x = i*24;
//				heartBar.addChild(heartIcon);
//			}
//			_progressBar = new ProgressBar1(heartBar,0,0,heartBar.width,24,false,false);
//			_progressBar.move(15,69);
//			addChild(_progressBar);
//			
//			heartBar = new Sprite();
//			for(i=0; i<10; i++)
//			{
//				heartIcon = new Bitmap(new HeartIconAsset());
//				heartIcon.x = i*24;
//				heartBar.addChild(heartIcon);
//			}
//			_progressBar1 = new ProgressBar1(heartBar,0,0,heartBar.width,24,false,false);
//			_progressBar1.move(315,69);
//			_progressBar1.scaleX = -1;
//			addChild(_progressBar1);
			
			_myPetHP = 4 + _result.petFight / 4000;
			_opponetPetHP = 4 + _result.opponetPetFight / 4000;
			var size:Number = 24;
			if(_myPetHP>11)
				size = 264 / _myPetHP;
			else
				size = 24;
			for(i =0;i<_myPetHP;i++)//生命
			{
				var hi:Bitmap = new Bitmap(new HeartIconAsset());
				addContent(hi);
				hi.x =15+i*size;
				hi.y = 69;
				_myPetLifes.push(hi);
			}
			if(_opponetPetHP>11)
				size = 264 / _opponetPetHP;
			else
				size = 24;
			for(i =0;i<_opponetPetHP;i++)
			{
				hi = new Bitmap(new HeartIconAsset());
				addContent(hi);
				hi.x = 602-i*size;
				hi.y = 69;
				_opponetPetLifes.push(hi);
			}
			
			_roundFight = getRoundFight();
			
			_myPetCharacterbox = new Sprite();
			addContent(_myPetCharacterbox);			
			
			_oppoentCharacterbox = new Sprite();
			addContent(_oppoentCharacterbox);
		}
		
		protected function actionSkipHandler(e:MouseEvent):void
		{
			dispose();
		}
		
		private function updateCharacter():void
		{
			if(_myPetCharacter){_myPetCharacter.dispose();_myPetCharacter = null;}
			var tmp:PetTemplateInfo;
			tmp = PetTemplateList.getPet(_result.petReplaceID);
			_myPetCharacter = GlobalAPI.characterManager.createPetCharacter( tmp);
			if(_myPetCharacter==null)return;
			_myPetCharacter.setMouseEnabeld(false);
			_myPetCharacter.show(DirectType.RIGHT_TOP);
			_myPetCharacter.move(250,260);
			_myPetCharacterbox.addChild(_myPetCharacter as DisplayObject);
			
			if(_opponetCharacter){_opponetCharacter.dispose();_opponetCharacter = null;}
			tmp = PetTemplateList.getPet(_result.opponetPetReplaceID);
			_opponetCharacter = GlobalAPI.characterManager.createPetCharacter(tmp);
			if(_opponetCharacter==null)return;
			_opponetCharacter.setMouseEnabeld(false);
			_opponetCharacter.show(DirectType.LEFT_BOTTOM);
			_opponetCharacter.move(395,180);
			_oppoentCharacterbox.addChild(_opponetCharacter as DisplayObject);
			
			startAttack();
		}
		
		private function startAttack():void
		{
			_skillIndex = 0;
			var i:int=0;
			_myTimer= new Timer(1000, _roundFight*2);   
			_myTimer.addEventListener(TimerEvent.TIMER,playAttackMovie);
			_myTimer.start();
		}
		
		protected function playAttackMovie(e:TimerEvent):void
		{
			if(_skillIndex == _roundFight*2-1 ||_opponetPetHP==0||_myPetHP==0)
			{
				dispose();
				return;
			}
			var desHp:int = Math.max(Math.min(_myPetLifes.length/_roundFight,_opponetPetLifes.length),1);
			if(_skillIndex % 2 == _result.isWinning)
			{
				playOpponetPet();
				_myPetHP = _myPetHP-desHp;
				if(_skillIndex == _roundFight*2-2)
				{	_myPetHP=0;	}			
				setMyPetHP(_myPetHP);
//				_progressBar.setValue(10,10-int(_skillIndex/2)*2);
//				_progressBar.scaleX = -1;
//				(_myPetLifes[int(_skillIndex/2)] as Bitmap).visible = false;
			}
			else
			{
				playMyPet();
				_opponetPetHP = _opponetPetHP-desHp;
				if(_skillIndex == _roundFight*2-2)
				{	_opponetPetHP=0;}
				setOpponetPetHP(_opponetPetHP);
//				(_opponetPetLifes[int(_skillIndex/2)] as Bitmap).visible = false;
			}
			_skillIndex ++;
		}
		
		private function setMyPetHP(value:int):void
		{
			for(var i:int=_myPetLifes.length-1;i>=value;i--)
			{
				(_myPetLifes[i] as Bitmap).visible = false;
			}
		}
		private function setOpponetPetHP(value:int):void
		{
			for(var i:int=_opponetPetLifes.length-1;i>=value;i--)
			{
				(_opponetPetLifes[i] as Bitmap).visible = false;
			}
		}
		private function getRoundFight():int
		{
			var p:Number;
			if(_result.isWinning)				
			{				
				p =_result.petFight / _result.opponetPetFight;			
			}
			else
			{
				p =_result.opponetPetFight / _result.petFight;
			}
			if(p>1.5) return 1;
			if(p>1.4) return 2;
			if(p>1.3) return 4;
			if(p>1.2) return 6;
			if(p>1.1) return 7;
			return 8;
		}
		
		private function playMyPet():void
		{
			_myPetCharacter.doActionType(ActionType.ATTACK);
			var index:int = int(Math.random()*4) % _result.myPetSkills.length;
			var skill:SkillTemplateInfo = SkillTemplateList.getSkill(_result.myPetSkills[index]/100);
			if(skill)
			{
				var movieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(skill.getAttackEffect(_result.myPetSkills[index]%10 +1)[0]);
				if(movieInfo)
				{
					var behitEffect:BaseLoadEffect = new BaseLoadEffect(movieInfo);
					behitEffect.move(_opponetCharacter.x,_opponetCharacter.y);
					behitEffect.play(SourceClearType.TIME,300000,4);
					addContent(behitEffect);
				}
			}
		}
		
		private function playOpponetPet():void
		{
			_opponetCharacter.doActionType(ActionType.ATTACK);
			var index:int = int(Math.random()*4) % _result.oppoentPetSkills.length;
			var skill:SkillTemplateInfo = SkillTemplateList.getSkill(_result.oppoentPetSkills[index]/100);
			if(skill)
			{
				var movieInfo:MovieTemplateInfo = MovieTemplateList.getMovie(skill.getAttackEffect(_result.oppoentPetSkills[index]%10 +1)[0]);
				if(movieInfo)
				{
					var behitEffect:BaseLoadEffect = new BaseLoadEffect(movieInfo);
					behitEffect.move(_myPetCharacter.x,_myPetCharacter.y);
					behitEffect.play(SourceClearType.TIME,300000,4);
					addContent(behitEffect);
				}
			}
		}
		
		private function showResult():void
		{			
			if(_result.isWinning)
			{
				PetPVPSuccessPanel.getInstance().show(_result.copper,_result.exp,_result.itemTemplateId);
			}
			else
			{
				PetPVPFailurePanel.getInstance().show(_result.copper,_result.exp,_result.petId,_result.opponetPetId);
			}
		}
		
		override public function dispose():void
		{
			showResult();
			removeEvent();
			if(_myTimer)
			{
				_myTimer.stop();
				_myTimer.removeEventListener(TimerEvent.TIMER,playAttackMovie);				
			}
			super.dispose();
			if(_btnSkip)
			{
				_btnSkip.dispose();
			}	
			if(_myPetCharacter)
			{
				_myPetCharacter.dispose();
			}
			if(_opponetCharacter)
			{
				_opponetCharacter.dispose();
			}
		}
	}
}