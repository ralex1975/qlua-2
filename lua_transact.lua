
t = {

            ["CLASSCODE"]="TQBR",

            ["SECCODE"]="IRKT",

            ["ACTION"]="NEW_ORDER",

            ["ACCOUNT"]="L01-00000F00",

            ["CLIENT_CODE"]="346204",

            ["TYPE"]="L",

            ["OPERATION"]="B",

            ["QUANTITY"]="1",

            ["PRICE"]="14,15",

            ["TRANS_ID"]="1"

      }

res=sendTransaction(t)

message(res,1)