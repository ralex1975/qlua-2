#!/bin/bash
COUNTER=0
GAP_COUNTER=0
BGAP_COUNTER=0
SKIP_COUNTER=0
BSKIP_COUNTER=0
LAST_BID=0
LAST_ASK=0
LAST_BUY=0
INCOME=0

while read -r  col1 col2 col3 col4 
do
    let COUNTER=COUNTER+1
    case $col3 in
        ''|*[!0-9]*) continue ;;
        *)  ;;
    esac
    case $col4 in
        ''|*[!0-9]*) continue ;;
        *)  ;;
    esac
    if [ $col3 -ge $col4 ]
    then
	continue
    fi
    # ASK
    if [ $col4 -le $LAST_ASK ]
    then
	let dif=LAST_ASK-col4
	let GAP_COUNTER=GAP_COUNTER+dif	    
    else
	    let SKIP_COUNTER=SKIP_COUNTER+1
	    let dif=col4-LAST_ASK
	    let GAP_COUNTER=GAP_COUNTER-dif	    
	    if [ $SKIP_COUNTER -gt $1 ]
	    then
	            let SKIP_COUNTER=0

		    if  [ $GAP_COUNTER -ge $2 ]
		    then
			echo "ASK: " $COUNTER $col4 $GAP_COUNTER 
			if [ $LAST_BUY -eq 0 ]
			then
				let LAST_BUY=col4
			fi
		    fi
		    let GAP_COUNTER=0
	    fi
    fi
    # BID
    if [ $col3 -ge $LAST_BID ]
    then
	let dif=col3-LAST_BID
	let BGAP_COUNTER=BGAP_COUNTER+dif	    
    else
	    let BSKIP_COUNTER=BSKIP_COUNTER+1
	    let dif=LAST_BID-col3
	    let BGAP_COUNTER=BGAP_COUNTER-dif	    
	    if [ $BSKIP_COUNTER -gt $1 ]
	    then
	            let BSKIP_COUNTER=0

		    if  [ $BGAP_COUNTER -ge $3 ]
		    then
			echo "BID: " $COUNTER $col3 $BGAP_COUNTER 
			if [ $LAST_BUY -gt 0 ]
			then
			        let p=LAST_BUY+50
				if [ $col3 -gt $p ]
				then
			        	let INCOME=INCOME+col3-p
			        	let LAST_BUY=0
		            	        echo "IN: " $INCOME
			        fi
			fi
		    fi
		    let BGAP_COUNTER=0
	    fi
    fi
    LAST_BID=$col3
    LAST_ASK=$col4
  # printf "col1: %s col2: %s col3 %s col4 %s\n" "$col1" "$col2" "$col3" "$col4"

done

echo "IN: " $INCOME
