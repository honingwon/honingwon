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

package org.libspark.swfassist.io
{
	import flash.utils.ByteArray;
	
	/**
	 * Based on "FLV and SWF File Format Specification Version9" Section.5 (p35-41)
	 */
	public interface DataInput
	{
		function get bytesAvaliable():uint;
		
		function get length():uint;
		
		function get position():uint;
		function set position(value:uint):void;
		
		function readS8():int;
		function readS16():int;
		function readS32():int;
		function readU8():uint;
		function readU16():uint;
		function readU32():uint;
		function readFixed():Number;
		function readFixed8():Number;
		function readFloat16():Number;
		function readFloat():Number;
		function readDouble():Number;
		function readEncodedU32():uint;
		function readBit():Boolean;
		function readSBits(numBits:uint):int;
		function readUBits(numBits:uint):uint;
		function readFBits(numBits:uint):Number;
		function resetBitCursor():void;
		function readUTF(length:uint = 0):String;
		function readString(length:uint = 0, charset:String = 'iso-8859-1'):String;
		function readBytes(dest:ByteArray, length:uint = 0):void;
		function uncompress(offset:uint = 0, length:uint = 0):void;
		function seek(position:int):void;
		function skip(offset:int):void;
	}
}