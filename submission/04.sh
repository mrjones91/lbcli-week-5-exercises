# Create a CLTV script with a timestamp of 1495584032 and public key below:
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277
pubKeyHash=0x"$publicKey"
relative=1495584032


if [ -z $1 ];
then
    echo "You must include an integer as an argument.";
    exit;
fi

if (( $1 > "2147483647" )) || (( $1 < "-2147483647" ));
then
    echo "Your number ($1) must be between -2147483647 and 2147483647";
    exit;
fi

if [ $1 -lt 0 ];
then
    integer=$(echo $((-$1)));
    negative=1;
else
    integer=$1;
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

size=$(echo -n $lehex | wc -c | awk '{print $1/2}');
hexcodeprefix=$(printf '%02x\n' $size);

# relHash=0x$(. ../tools/int2le.sh $relative | cut -d ' ' -f2)
# $relative OP_CHECKLOCKTIMEVERIFY

$hexcodeprefix OP_CHECKLOCKTIMEVERIFY OP_DROP OP_DUP OP_HASH160 $pubKeyHash OP_EQUALVERIFY OP_CHECKSIG
# 0420cd2459b17576a9141e51fcdc14be9a148bb0aaec9197eb47c83776fb88ac
# 0420cd2459b17576a92102e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb27788ac
