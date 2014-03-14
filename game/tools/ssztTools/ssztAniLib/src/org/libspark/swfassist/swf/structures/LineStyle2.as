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

package org.libspark.swfassist.swf.structures
{
	public class LineStyle2 extends LineStyle
	{
		private var _startCapStyle:uint = CapStyleConstants.ROUND_CAP;
		private var _joinStyle:uint = JoinStyleConstants.ROUND_JOIN;
		private var _hasFill:Boolean = false;
		private var _noHorizontalScale:Boolean = false;
		private var _noVerticalScale:Boolean = false;
		private var _pixelHinting:Boolean = false;
		private var _noClose:Boolean = false;
		private var _endCapStyle:uint = CapStyleConstants.ROUND_CAP;
		private var _miterLimitFactor:Number = 1.0;
		private var _fillType:FillStyle = new FillStyle();
		
		public function get startCapStyle():uint
		{
			return _startCapStyle;
		}
		
		public function set startCapStyle(value:uint):void
		{
			_startCapStyle = value;
		}
		
		public function get joinStyle():uint
		{
			return _joinStyle;
		}
		
		public function set joinStyle(value:uint):void
		{
			_joinStyle = value;
		}
		
		public function get hasFill():Boolean
		{
			return _hasFill;
		}
		
		public function set hasFill(value:Boolean):void
		{
			_hasFill = value;
		}
		
		public function get noHorizontalScale():Boolean
		{
			return _noHorizontalScale;
		}
		
		public function set noHorizontalScale(value:Boolean):void
		{
			_noHorizontalScale = value;
		}
		
		public function get noVerticalScale():Boolean
		{
			return _noVerticalScale;
		}
		
		public function set noVerticalScale(value:Boolean):void
		{
			_noVerticalScale = value;
		}
		
		public function get pixelHinting():Boolean
		{
			return _pixelHinting;
		}
		
		public function set pixelHinting(value:Boolean):void
		{
			_pixelHinting = value;
		}
		
		public function get noClose():Boolean
		{
			return _noClose;
		}
		
		public function set noClose(value:Boolean):void
		{
			_noClose = value;
		}
		
		public function get endCapStyle():uint
		{
			return _endCapStyle;
		}
		
		public function set endCapStyle(value:uint):void
		{
			_endCapStyle = value;
		}
		
		public function get miterLimitFactor():uint
		{
			return _miterLimitFactor;
		}
		
		public function set miterLimitFactor(value:uint):void
		{
			_miterLimitFactor = value;
		}
		
		public function get fillType():FillStyle
		{
			return _fillType;
		}
		
		public function set fillType(value:FillStyle):void
		{
			_fillType = value;
		}
	}
}