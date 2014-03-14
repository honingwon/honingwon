/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the swfassist.
 *
 * The Initial Developer of the Original Code is
 * the BeInteractive!.
 * Portions created by the Initial Developer are Copyright (C) 2008
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * ***** END LICENSE BLOCK ***** */

package org.libspark.swfassist.swf.tags
{
	import flash.utils.ByteArray;
	
	public dynamic class DefineBitsLossless extends AbstractTag
	{
		public function DefineBitsLossless(code:uint = 0)
		{
			super(code != 0 ? code : TagCodeConstants.TAG_DEFINE_BITS_LOSSLESS);
		}
		
		private var _characterId:uint = 0;
		private var _bitmapFormat:uint = BitmapFormatConstants.COLORMAPPED8;
		private var _bitmapWidth:uint = 0;
		private var _bitmapHeight:uint = 0;
		private var _colorTable:Array = [];
		private var _data:ByteArray = new ByteArray();
		
		public function get characterId():uint
		{
			return _characterId;
		}
		
		public function set characterId(value:uint):void
		{
			_characterId = value;
		}
		
		public function get bitmapFormat():uint
		{
			return _bitmapFormat;
		}
		
		public function set bitmapFormat(value:uint):void
		{
			_bitmapFormat = value;
		}
		
		public function get bitmapWidth():uint
		{
			return _bitmapWidth;
		}
		
		public function set bitmapWidth(value:uint):void
		{
			_bitmapWidth = value;
		}
		
		public function get bitmapHeight():uint
		{
			return _bitmapHeight;
		}
		
		public function set bitmapHeight(value:uint):void
		{
			_bitmapHeight = value;
		}
		
		public function get colorTable():Array
		{
			return _colorTable;
		}
		
		public function set colorTable(value:Array):void
		{
			_colorTable = value;
		}
		
		public function get data():ByteArray
		{
			return _data;
		}
		
		public function set data(value:ByteArray):void
		{
			_data = value;
		}
		
		public override function visit(visitor:TagVisitor):void
		{
			visitor.visitDefineBitsLossless(this);
		}
	}
}