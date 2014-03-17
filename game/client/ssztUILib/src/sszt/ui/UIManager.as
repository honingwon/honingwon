package sszt.ui
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.ComboBox;
	import fl.controls.List;
	import fl.controls.RadioButton;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.controls.listClasses.CellRenderer;
	import fl.core.UIComponent;
	import fl.managers.StyleManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	
	import mhqy.ui.DragonBorder;
	import mhqy.ui.FlowerBorder;
	import mhqy.ui.ProgressBarBlue;
	import mhqy.ui.ProgressBarRed;
	
	import mhsm.ui.AddBtnAsset;
	import mhsm.ui.Btn2BgAsset;
	import mhsm.ui.CloseBtn1Asset;
	import mhsm.ui.DownBtnAsset;
	import mhsm.ui.HidePlayerBtn;
	import mhsm.ui.LeftBtnAsset;
	import mhsm.ui.ReduceBtnAsset;
	import mhsm.ui.SelectBgAsset;
	import mhsm.ui.UpBtnAsset;
	
	import sszt.interfaces.moviewrapper.IMovieManager;
	import sszt.ui.container.MAlert;
	
	import ssztui.ui.BarAsset7;
	import ssztui.ui.BindCopperAsset;
	import ssztui.ui.BindYuanBaoAsset;
	import ssztui.ui.BorderAssetTip1;
	import ssztui.ui.BtnStairOverAsset;
	import ssztui.ui.BtnStairSelectedAsset;
	import ssztui.ui.BtnStairUpAsset;
	import ssztui.ui.CellSelectedAsset;
	import ssztui.ui.CopperAsset;
	import ssztui.ui.LockAsset;
	import ssztui.ui.MenuIconOKAsset;
	import ssztui.ui.MenuIconOffAsset;
	import ssztui.ui.NpcPanelItemOverAsset;
	import ssztui.ui.PlayCollectBarAsset;
	import ssztui.ui.PlayCollectTrackAsset;
	import ssztui.ui.ProgressBar3Asset;
	import ssztui.ui.ProgressBarExpAsset;
	import ssztui.ui.ProgressBarGpAsset;
	import ssztui.ui.ProgressBarGreen;
	import ssztui.ui.ProgressBarHpAsset;
	import ssztui.ui.ProgressBarMpAsset;
	import ssztui.ui.ProgressTrack2Asset;
	import ssztui.ui.ProgressTrack3Asset;
	import ssztui.ui.ProgressTrackAsset;
	import ssztui.ui.SmallBtnAmountDownAsset;
	import ssztui.ui.SmallBtnAmountUpAsset;
	import ssztui.ui.SmallBtnCloseAsset;
	import ssztui.ui.StoreItemBgAsset;
	import ssztui.ui.TextFieldAsset;
	import ssztui.ui.TitleTraceryAsset;
	import ssztui.ui.TreeIconAddAsset;
	import ssztui.ui.TreeIconLowAsset;
	import ssztui.ui.YuanBaoAsset;
	
	public class UIManager
	{
		private var alertupSkil:Alert_upSkin;
		private var textarea:TextArea;
		private var textareaupskin:TextArea_upSkin;
		private var textareadisableskin:TextArea_disabledSkin;
		
		private var comboboxupskin:ComboBox_upSkin;
		private var comboboxoverskin:ComboBox_overSkin;
		private var comboboxdownskin:ComboBox_downSkin;
		private var comboboxdisableskin:ComboBox_disabledSkin;
		
		private var listSkin:List_skin;
		
		private var panelcloseupskin:Panel_CloseBtn_upSkin;
		private var panelclosedownskin:Panel_CloseBtn_downSkin;
		private var panelcloseoverskin:Panel_CloseBtn_overSkin;
		private var panelupskin:Panel_upSkin;
		
		private var radiobuttonupicon:RadioButton_upIcon;
		private var radiobuttonovericon:RadioButton_overIcon;
		private var radiobuttondownicon:RadioButton_downIcon;
		private var radiobuttondisableicon:RadioButton_disabledIcon;
		private var radiobuttonselectupicon:RadioButton_selectedUpIcon;
		private var radiobuttonselectovericon:RadioButton_selectedOverIcon;
		private var radiobuttonselectdownicon:RadioButton_selectedDownIcon;
		private var radiobuttonselectdisableicon:RadioButton_selectedDisabledIcon;
		
		private var scrollarrowdowndisabledskin:ScrollArrowDown_disabledSkin;
		private var scrollarrowdowndownskin:ScrollArrowDown_downSkin;
		private var scrollarrowdownoverskin:ScrollArrowDown_overSkin;
		private var scrollarrowdownupskin:ScrollArrowDown_upSkin;
		private var scrollarrowupdisabledskin:ScrollArrowUp_disabledSkin;
		private var scrollarrowupdownskin:ScrollArrowUp_downSkin;
		private var scrollarrowupoverskin:ScrollArrowUp_overSkin;
		private var scrollarrowupupskin:ScrollArrowUp_upSkin;
		private var scrollbarthumbicon:ScrollBar_thumbIcon;
		private var scrollthumbdownskin:ScrollThumb_downSkin;
		private var scrollthumboverskin:ScrollThumb_overSkin;
		private var scrollthumbupskin:ScrollThumb_upSkin;
		private var scrolltrackskin:ScrollTrack_skin;
		
		private var scrollpaneDisabledSkin:ScrollPane_disabledSkin;
		private var scrollpaneupskin:ScrollPane_upSkin;
		
		
		private var focusrectskin:focusRectSkin;
		
		private var slidertrackskin:SliderTrack_skin;
		private var sliderthumbupskin:SliderThumb_upSkin;
		private var sliderthumboverskin:SliderThumb_overSkin;
		private var sliderthumbdownskin:SliderThumb_downSkin;
		private var sliderthumbdisabledskin:SliderThumb_disabledSkin;
		private var slidertickskin:SliderTick_skin;
		private var slidertrackdisabledskin:SliderTrack_disabledSkin;
		
		
		private var textinputdisabledskin:TextInput_disabledSkin;
		private var textinputupskin:TextInput_upSkin;
		
		private var cellrendererdisabledskin:CellRenderer_disabledSkin;
		private var cellrendererdownskin:CellRenderer_downSkin;
		private var cellrendereroverskin:CellRenderer_overSkin;
		private var cellrendererselecteddisabledskin:CellRenderer_selectedDisabledSkin;
		private var cellrendererselecteddownskin:CellRenderer_selectedDownSkin;
		private var cellrendererselectedoverskin:CellRenderer_selectedOverSkin;
		private var cellrendererselectedupskin:CellRenderer_selectedUpSkin;
		private var cellrendererupskin:CellRenderer_upSkin;
		
		private var checkboxdisabledicon:CheckBox_disabledIcon;
		private var checkboxdownicon:CheckBox_downIcon;
		private var checkboxovericon:CheckBox_overIcon;
		private var checkboxSelectedDisabledIcon:CheckBox_selectedDisabledIcon;
		private var checkboxSelectedDownIcon:CheckBox_selectedDownIcon;
		private var checkboxSelectedOverIcon:CheckBox_selectedOverIcon;
		private var checkboxSelectedUpIcon:CheckBox_selectedUpIcon;
		private var checkboxUpicon:CheckBox_upIcon;
		
		private var copperAsset:CopperAsset;
		private var bindCopperAsset:BindCopperAsset;
		private var yuanBaoAsset:YuanBaoAsset;
		private var bindYuanBaoAsset:BindYuanBaoAsset;
		
		private var dragonBorder:DragonBorder;
		private var flowerBorder:FlowerBorder
		
		private var progressBarBlue:ProgressBarBlue;
		private var progressBarRed:ProgressBarRed;
		
		private var barasset7:BarAsset7;
		private var borderAssetTip1:BorderAssetTip1;
		private var progressBarGreen:ProgressBarGreen;
		private var progressBarMpAsset:ProgressBarMpAsset;
		private var progressBarHpAsset:ProgressBarHpAsset;
		private var progressBarGpAsset:ProgressBarGpAsset;
		private var progressBarExpAsset:ProgressBarExpAsset;
		private var progressBar3Asset:ProgressBar3Asset;
		private var progressTrackAsset:ProgressTrackAsset;
		private var progressTrack2Asset:ProgressTrack2Asset;
		private var progressTrack3Asset:ProgressTrack3Asset;
		private var playCollectTrackAsset:PlayCollectTrackAsset;
		private var playCollectBarAsset:PlayCollectBarAsset;
		
		private var amountBtnUp:SmallBtnAmountUpAsset;
		private var amountBtnDown:SmallBtnAmountDownAsset;
		
		private var leftBtnAsset:LeftBtnAsset;
//		private var sliderBgAsset:SliderBgAsset;
		private var upBtnBg:UpBtnAsset;
		private var downBtnBg:DownBtnAsset;
		private var selectBg:SelectBgAsset;
		
		private var addBtnAsset:AddBtnAsset;
		private var btn2BgAsset:Btn2BgAsset;
		private var hidePlayerAsset:HidePlayerBtn;
		
		private var reduceBtnAsset:ReduceBtnAsset;
		private var closeBtn1Asset:CloseBtn1Asset;
		private var smallBtnCloseAsset:SmallBtnCloseAsset;
		
		private var treeIconAddAsset:TreeIconAddAsset;
		private var treeIconLowAsset:TreeIconLowAsset;
		
		private var menuIconOKAsset:MenuIconOKAsset;
		private var menuIconOffAsset:MenuIconOffAsset;
		
		private var malert:MAlert;
		
		private var titleTraceryAsset:TitleTraceryAsset;
		
		private var npcPanelItemOverAsset:NpcPanelItemOverAsset;
		
		public static var PARENT:DisplayObjectContainer;
		public static var movieWrapperApi:IMovieManager;
		
		private var btnStairUpAsset:BtnStairUpAsset;
		private var btnStairOverAsset:BtnStairOverAsset;
		private var btnStairSelectedAsset:BtnStairSelectedAsset;
		
		private var lockAsset:LockAsset
		
		private var storeItemBgAsset:StoreItemBgAsset;
		
		public static function setup(uiparent:DisplayObjectContainer,movieManager:IMovieManager):void
		{
			PARENT = uiparent;
			movieWrapperApi = movieManager;
			
			Button;
			AddBtnAsset;
			ReduceBtnAsset;
			SelectBgAsset;
			TextFieldAsset;
			
			new RadioButton();
			new CheckBox();
			new ComboBox();
			new TextInput();
			new List();
			new UIComponent();
			new CellRenderer();
			
			StyleManager.setComponentStyle(UIComponent,"textFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(CheckBox,"textFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(RadioButton,"textFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(RadioButton,"disabledTextFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(ComboBox,"textFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(ComboBox,"disabledTextFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(TextInput,"textFormat",new TextFormat("SimSun",12,0xffffff));
			StyleManager.setComponentStyle(List,"textFormat",new TextFormat("SimSun",12,0xFFFFFF));
			StyleManager.setComponentStyle(CellRenderer,"textFormat",new TextFormat("SimSun",12,0xFFFFFF));
//			new CheckBox();
//			new Button();
		}
	}
}