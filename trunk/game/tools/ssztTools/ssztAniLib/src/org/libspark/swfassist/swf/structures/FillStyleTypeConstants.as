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
	public class FillStyleTypeConstants
	{
		public static const SOLID_FILL:uint                    = 0x00;
		public static const LINEAR_GRADIENT_FILL:uint          = 0x10;
		public static const RADIAL_GRADIENT_FILL:uint          = 0x12;
		public static const FOCAL_RADIAL_GRADIENT_FILL:uint    = 0x13;
		public static const REPEATING_BITMAP_FILL:uint         = 0x40;
		public static const CLIPPED_BITMAP_FILL:uint           = 0x41;
		public static const NON_SMOOTHED_REPEATING_BITMAP:uint = 0x42;
		public static const NON_SMOOTHED_CLIPPED_BITMAP:uint   = 0x43;
	}
}