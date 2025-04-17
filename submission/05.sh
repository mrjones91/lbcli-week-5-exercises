# Create a CSV script that would lock funds until one hundred and fifty blocks had passed
# publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277
publicKey=02e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb277
pubKeyHash=1e51fcdc14be9a148bb0aaec9197eb47c83776fb

# relHash=0x$(. ../tools/int2le.sh $relative | cut -d ' ' -f2)
# $relative OP_CHECKLOCKTIMEVERIFY

btcc 150 OP_CHECKSEQUENCEVERIFY OP_DROP OP_DUP OP_HASH160 $pubKeyHash OP_EQUALVERIFY OP_CHECKSIG

# 029600b27576a9141e51fcdc14be9a148bb0aaec9197eb47c83776fb88ac
# 
# 029600b27576a92102e3af28965693b9ce1228f9d468149b831d6a0540b25e8a9900f71372c11fb27788ac