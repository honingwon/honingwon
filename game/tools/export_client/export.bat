echo off
php Export.php
set ROOT=.
erl -s mzlib compress -p sm.data sm.txt -s erlang halt
copy sm.txt E:\workplace\sszt2\client_res\game\sszt.txt

pause