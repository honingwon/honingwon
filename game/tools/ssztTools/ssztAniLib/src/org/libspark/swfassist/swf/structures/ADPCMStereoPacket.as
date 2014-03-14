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
	import flash.utils.ByteArray;
	
	public class ADPCMStereoPacket
	{
		private var _initialSampleLeft:uint = 0;
		private var _initialIndexLeft:uint = 0;
		private var _initialSampleRight:uint = 0;
		private var _initialIndexRight:uint = 0;
		private var _adpcmCodeData:ByteArray = new ByteArray();
		
		public function get initialSampleLeft():uint
		{
			return _initialSampleLeft;
		}
		
		public function set initialSampleLeft(value:uint):void
		{
			_initialSampleLeft = value;
		}
		
		public function get initialIndexLeft():uint
		{
			return _initialIndexLeft;
		}
		
		public function set initialIndexLeft(value:uint):void
		{
			_initialIndexLeft = value;
		}
		
		public function get initialSampleRight():uint
		{
			return _initialSampleRight;
		}
		
		public function set initialSampleRight(value:uint):void
		{
			_initialSampleRight = value;
		}
		
		public function get initialIndexRight():uint
		{
			return _initialIndexRight;
		}
		
		public function set initialIndexRight(value:uint):void
		{
			_initialIndexRight = value;
		}
		
		public function get adpcmCodeData():ByteArray
		{
			return _adpcmCodeData;
		}
		
		public function set adpcmCodeData(value:ByteArray):void
		{
			_adpcmCodeData = value;
		}
	}
}