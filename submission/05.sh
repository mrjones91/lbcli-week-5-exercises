# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277
pubKeyHash=$(echo $publicKey | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -ripemd160 | cut -d ' ' -f2)

time=150

if [ -z $time ];
then
    echo "You must include an integer as an argument.";
    exit;
fi

if (( $time > "2147483647" )) || (( $time < "-2147483647" ));
then
    echo "Your number ($time) must be between -2147483647 and 2147483647";
    exit;
fi

if [ $time -lt 0 ];
then
    integer=$(echo $((-$time)));
    negative=1;
else
    integer=$time;
    negative=0;
fi

hex=$(printf '%08x\n' $integer | sed 's/^\(00\)*//');

hexfirst=$(echo $hex | cut -c1)
[[ 0x$hexfirst -gt 0x7 ]] && hex="00"$hex

lehex=$(echo $hex | tac -rs .. | echo "$(tr -d '\n')");

if [ "$negative" -eq "1" ];
then
   lehex=$(printf '%x\n' $((0x$lehex | 0x80)))
fi

size=$(echo -n $lehex | wc -c | awk '{print $time/2}');
hexcodeprefix=$(printf '%02x\n' $size);
# relHash=0x$(. ../tools/int2le.sh $time | cut -d ' ' -f2)
# $time OP_CHECKLOCKTIMEVERIFY

# btcc 150 OP_CHECKSEQUENCEVERIFY OP_DROP OP_DUP OP_HASH160 $pubKeyHash OP_EQUALVERIFY OP_CHECKSIG
echo $hexcodeprefix$lehex"b27576a914"$pubKeyHash"88ac"

# 029600b27576a9141e51fcdc14be9a148bb0aaec9197eb47c83776fb88ac
# 
# 029600b27576a92102e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb27788ac