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
	
	public interface DataOutput
	{
		function get length():uint;
		
		function get position():uint;
		function set position(value:uint):void;
		
		function writeS8(value:int):void;
		function writeS16(value:int):void;
		function writeS32(value:int):void;
		function writeU8(value:uint):void;
		function writeU16(value:uint):void;
		function writeU32(value:uint):void;
		function writeFixed(value:Number):void;
		function writeFixed8(value:Number):void;
		function writeFloat16(value:Number):void;
		function writeFloat(value:Number):void;
		function writeDouble(value:Number):void;
		function writeEncodedU32(value:uint):void;
		function writeBit(value:Boolean):void;
		function writeUBits(numBits:uint, value:uint):void;
		function writeSBits(numBits:uint, value:int):void;
		function writeFBits(numBits:uint, value:Number):void;
		function resetBitCursor():void;
		function writeUTF(value:String, isNullTerminated:Boolean = true):void;
		function writeString(value:String, charset:String = 'iso-8859-1', isNullTerminated:Boolean = true):void;
		function writeBytes(source:ByteArray):void;
		function compress(offset:uint = 0, length:uint = 0):void;
	}
}