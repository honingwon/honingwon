<?php
class CardNetwork
{
static public function makeRequest($url, $params)
{
	$query_string = self::makeQueryString($params);	
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, "$url?$query_string");
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 0);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array('Expect:'));
	$ret = curl_exec($ch);
	$err = curl_error($ch);
	if (false === $ret || !empty($err))
	    {
		    $errno = curl_errno($ch);
		    $info = curl_getinfo($ch);
		    curl_close($ch);

	        return array(
	        	'result' => false,
	        	'errno' => $errno,
	            'msg' => $err,
	        	'info' => $info,
	        );
	    }	    
       	curl_close($ch);
        	return array(
        		'result' => true,
            	'msg' => $ret,
        	);

}
	static private function makeQueryString($params)
	{
		if (is_string($params))
			return $params;
			
		$query_string = array();
	    foreach ($params as $key => $value)
	    {   
	        array_push($query_string, rawurlencode($key) . '=' . rawurlencode($value));
	    }   
	    $query_string = join('&', $query_string);
	    return $query_string;
	}
}
