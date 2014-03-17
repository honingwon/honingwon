package sszt.scene.components.newBigMap.linkItems
{
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.display.SpreadMethod;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    
    import sszt.core.manager.LanguageManager;
    import sszt.core.view.assets.AssetSource;
    import sszt.core.view.tips.TipsUtil;
    import sszt.ui.button.MBitmapButton;
    import sszt.ui.container.MSprite;
    import sszt.ui.label.MAssetLabel;

    public class BaseLinkItemView extends MSprite
    {
        protected var _itemField:MAssetLabel;
        private var _transferBtn:MBitmapButton;
		private var _background:Shape;

        public function BaseLinkItemView()
        {
			super();
        }

        override protected function configUI() : void
        {
            super.configUI();
			buttonMode = true;
			_background = new Shape();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(146,146,0,0,0);
			_background.graphics.beginGradientFill(GradientType.LINEAR,[0x265d2b,0x265d2b],[1,0],[0,255],matr,SpreadMethod.PAD);
			_background.graphics.drawRect(0,0,146,23);
			addChild(_background);
			_background.alpha = 0.01;
			
            this._itemField = new MAssetLabel("", MAssetLabel.LABEL_TYPE20, TextFormatAlign.LEFT);
            this._itemField.move(24,4);
            this._itemField.width = 100;
            this._itemField.height = 20;
//            this._itemField.mouseEnabled = true;
            addChild(this._itemField);
            this._transferBtn = new MBitmapButton(AssetSource.getTransferShoes());
            this._transferBtn.move(4,2);
            addChild(this._transferBtn);
			
			this.initEvent();
        } 

        private function initEvent() : void
        {
            this.addEventListener(MouseEvent.CLICK, this.linkClickHandler);
            this._transferBtn.addEventListener(MouseEvent.CLICK, this.transferHandler);
            this._transferBtn.addEventListener(MouseEvent.ROLL_OVER, this.transferOverClickHandler);
            this._transferBtn.addEventListener(MouseEvent.ROLL_OUT, this.transferOutClickHandler);
			this.addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
        }

        private function removeEvent() : void
        {
            this.removeEventListener(MouseEvent.CLICK, this.linkClickHandler);
            this._transferBtn.removeEventListener(MouseEvent.CLICK, this.transferHandler);
            this._transferBtn.removeEventListener(MouseEvent.ROLL_OVER, this.transferOverClickHandler);
            this._transferBtn.removeEventListener(MouseEvent.ROLL_OUT, this.transferOutClickHandler);
			this.removeEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
			this.removeEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
        }

        protected function linkClickHandler(event:MouseEvent) : void
        {
			
        }

        protected function transferHandler(event:MouseEvent) : void
        {
			event.stopImmediatePropagation();
        }
		private function overHandler(e:MouseEvent):void
		{
			_background.alpha = 1;
		}
		private function outHandler(e:MouseEvent):void
		{
			_background.alpha = 0.01;
		}
        private function transferOverClickHandler(event:MouseEvent) : void
        {
            TipsUtil.getInstance().show(LanguageManager.getWord("ssztl.common.transferBtnTips"), null, new Rectangle(stage.mouseX, stage.mouseY));
        }

        private function transferOutClickHandler(event:MouseEvent) : void
        {
            TipsUtil.getInstance().hide();
        }

        override public function dispose() : void
        {
            this.removeEvent();
			if(_background.parent)_background.parent.removeChild(_background);
            super.dispose();
			
        }

    }
}
