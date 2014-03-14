<?php

/*

format 参数的可能值：
a - NUL-padded string
A - SPACE-padded string
h - Hex string, low nibble first
H - Hex string, high nibble first
c - signed char
C - unsigned char
s - signed short (always 16 bit, machine byte order)
S - unsigned short (always 16 bit, machine byte order)
n - unsigned short (always 16 bit, big endian byte order)
v - unsigned short (always 16 bit, little endian byte order)
i - signed integer (machine dependent size and byte order)
I - unsigned integer (machine dependent size and byte order)
l - signed long (always 32 bit, machine byte order)
L - unsigned long (always 32 bit, machine byte order)
N - unsigned long (always 32 bit, big endian byte order)
V - unsigned long (always 32 bit, little endian byte order)
f - float (machine dependent size and representation)
d - double (machine dependent size and representation)
x - NUL byte
X - Back up one byte
@ - NUL-fill to absolute position

*/

	class PackageIn
	{
		
		var $data;
		var $len;
		public function __construct(){ 
			$this->data  = new PHPPack();
			$this->len = 0;
		}
		

		public function writeInt($value)
		{
			$this->data->format .= "N";
			$this->data->params[] = $value;
			$this->len +=4;
		}
		
		public function writeUTF($value)
		{
 	 		$arr =  unpack("c*",$value);
   			$len = count($arr);
   			$this->writeShort($len);
			$this->data->format .= "c".$len;
		   	foreach ( $arr as $v ) {	   		
	   			$this->data->params[] = $v; 
		    }
    		$this->len += $len;
		}
		
		public function writeByte($value)
		{
			$this->data->format .= "C";
   			$this->data->params[] = $value;
   			$this->len += 1;
		}
		
		public function writeShort($value)
		{
			$this->data->format .= "n";
   			$this->data->params[] = $value;
   			$this->len += 2;
		}
		
		
		
		
	}
?>