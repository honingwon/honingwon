package sszt.personal.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import sszt.ui.backgroundUtil.BackgroundInfo;
	import sszt.ui.backgroundUtil.BackgroundType;
	import sszt.ui.backgroundUtil.BackgroundUtils;
	import sszt.ui.container.MPanel;
	import sszt.ui.label.MAssetLabel;
	import sszt.ui.mcache.btns.MCacheAsset1Btn;
	import sszt.ui.mcache.titles.MCacheTitle1;
	
	import sszt.core.data.GlobalData;
	import sszt.core.data.personal.PersonalMyInfo;
	import sszt.core.manager.LanguageManager;
	import sszt.core.utils.AssetUtil;
	import sszt.interfaces.moviewrapper.IMovieWrapper;
	import mhsm.personal.HeadChooseAsset;
	import sszt.personal.mediators.PersonalMediator;
	
	public class PersonalChangeHeadPanel extends MPanel
	{
		private var _bg:IMovieWrapper;
		private var _defaultBtn:MCacheAsset1Btn;
		private var _changeBtn:MCacheAsset1Btn;
		private var _cancelBtn:MCacheAsset1Btn;
		private var _mediator:PersonalMediator;
		
		private var _cells:Array;
		private var _currendHeadIndex:int = -1;
		
		public function PersonalChangeHeadPanel(argMediator:PersonalMediator)
		{
			_mediator = argMediator;
			super(new MCacheTitle1("",new Bitmap(new HeadChooseAsset())),true,-1);
			initEvents();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			setContentSize(287,182);
			var t:BitmapData = AssetUtil.getAsset("mhsm.common.iconCellAsset",BitmapData) as BitmapData;
			
			_bg = BackgroundUtils.setBackground([
				new BackgroundInfo(BackgroundType.BORDER_2,new Rectangle(0,0,287,182)),
				new BackgroundInfo(BackgroundType.BORDER_6,new Rectangle(8,75,273,64)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(37,13,55,54),new Bitmap(t)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(116,13,55,54),new Bitmap(t)),
				new BackgroundInfo(BackgroundType.DISPLAY,new Rectangle(195,13,55,54),new Bitmap(t)),
			]);
			addContent(_bg as DisplayObject);
			
			_cells = [];
			var poses:Array = [new Point(43,19),new Point(122,19),new Point(201,19)];
			var tmpCell:PersonalHeadCell;
			for(var i:int = 0;i < poses.length;i++)
			{
				tmpCell = new PersonalHeadCell();
				tmpCell.updateHead(GlobalData.selfPlayer.sex,i);
				tmpCell.move(poses[i].x,poses[i].y);
				_cells.push(tmpCell);
				addContent(tmpCell);
			}
			
//			var label1:MAssetLabel = new MAssetLabel("提示：\n1.选择头像点击修改即可成功切换头像。\n2.点击默认按钮即可恢复门派默认头像。",MAssetLabel.LABELTYPE1);
			var label1:MAssetLabel = new MAssetLabel(LanguageManager.getWord("ssztl.personal.setHeadPrompt"),MAssetLabel.LABELTYPE1);
			label1.move(30,79);
			addContent(label1);
		
//			_defaultBtn = new MCacheAsset1Btn(1,"默认");
			_defaultBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.default"));
			_defaultBtn.move(21,147);
			addContent(_defaultBtn);
			
//			_changeBtn = new MCacheAsset1Btn(1,"修改");
			_changeBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.change"));
			_changeBtn.move(110,147);
			addContent(_changeBtn);
			
//			_cancelBtn = new MCacheAsset1Btn(1,"取消");
			_cancelBtn = new MCacheAsset1Btn(1,LanguageManager.getWord("ssztl.common.cannel"));
			_cancelBtn.move(198,147);
			addContent(_cancelBtn);
			//默认头像选项
			var argIndex:int = myInfo.headIndex;
			if(argIndex == -1)argIndex = 0;
			setCells(argIndex);
		}
		
		private function initEvents():void
		{
			_defaultBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_changeBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelBtn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			
			for(var i:int = 0;i < _cells.length;i++)
			{
				_cells[i].addEventListener(MouseEvent.CLICK,cellClickHandler);
			}
		}
		
		private function removeEvents():void
		{
			_defaultBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_changeBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			_cancelBtn.removeEventListener(MouseEvent.CLICK,btnClickHandler);
			
			for(var i:int = 0;i < _cells.length;i++)
			{
				_cells[i].removeEventListener(MouseEvent.CLICK,cellClickHandler);
			}
		}
		
		private function btnClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget)
			{
				case _defaultBtn:
					defaultBtnHandler();
					break;
				case _changeBtn:
					myInfo.updateHead(_currendHeadIndex);
					dispose();
				break;
				case _cancelBtn:
					dispose();
					break;
			}
		}
		
		private function defaultBtnHandler():void
		{
			var index:int;
			if(GlobalData.selfPlayer.career == 1)
			{
				index = 0;
			}
			else if(GlobalData.selfPlayer.career == 2)
			{
				index = 1;
			}
			else 
			{
				index = 2;
			}
			setCells(index);
		}
		
		private function cellClickHandler(e:MouseEvent):void
		{
			var index:int = _cells.indexOf(e.currentTarget as PersonalHeadCell);
			setCells(index);
		}
		
		private function setCells(argIndex:int):void
		{
			if(_currendHeadIndex == argIndex)return;
			if(_currendHeadIndex != -1)
			{
				_cells[_currendHeadIndex].selected = false;
			}
			_currendHeadIndex = argIndex;
			_cells[_currendHeadIndex].selected = true;
		}
		
		private function get myInfo():PersonalMyInfo
		{
			return _mediator.personalModule.personalInfoList[GlobalData.selfPlayer.userId].personaOtherMainInfo;
		}
		
		override public function dispose():void
		{
			removeEvents();
			if(_bg)
			{
				_bg.dispose();
				_bg = null;
			}
			if(_defaultBtn)
			{
				_defaultBtn.dispose();
				_defaultBtn = null;
			}
			if(_changeBtn)
			{
				_changeBtn.dispose();
				_changeBtn = null;
			}
			if(_cancelBtn)
			{
				_cancelBtn.dispose();
				_cancelBtn = null;
			}
			_mediator = null;
			for(var i:int = 0;i < _cells.length;i++)
			{
				_cells[i].dispose();
				_cells[i] = null;
			}
			_cells = null;
			super.dispose();
			if(parent)parent.removeChild(this);
		}
	}
}