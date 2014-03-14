set NODE=1
set COOKIE=sszt
set NODE_NAME=sszt_game%NODE%@127.0.0.1
set CONFIG_FILE=run_%NODE%

set SMP=auto
set ERL_PROCESSES=102400

cd ../config
werl +P %ERL_PROCESSES% -smp %SMP% -pa ../ebin -name %NODE_NAME% -setcookie %COOKIE% -boot start_sasl -config %CONFIG_FILE% -s main server_start
