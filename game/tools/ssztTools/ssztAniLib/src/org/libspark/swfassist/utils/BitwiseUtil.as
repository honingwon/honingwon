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

package org.libspark.swfassist.utils
{
	public class BitwiseUtil
	{
		public static function getMinBits(a:uint, b:uint = 0, c:uint = 0, d:uint = 0):uint
		{
			var val:uint = a | b | c | d;
			var bits:uint = 1;
			
			do {
				val >>>= 1;
				++bits;
			}
			while (val != 0)
			
			return bits;
		}
		
		public static function getMinSBits(a:int, b:int = 0, c:int = 0, d:int = 0):uint
		{
			return getMinBits(Math.abs(a), Math.abs(b), Math.abs(c), Math.abs(d));
		}
		
		public static function getMinFBits(a:Number, b:Number = 0, c:Number = 0, d:Number = 0):uint
		{
			return getMinSBits(a * 65536, b * 65536, c * 65536, d * 65536);
		}
	}
}