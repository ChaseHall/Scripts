#Screenshoter - simple script for making&uploding screenshots
#Requirements: ssh, xclip, scrot
#For automated upload it is required to have properly set up RSA key authentication in your system
#you can specify used key by adding -i option in scp command
#use on your own


fileName=".png"
FILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 7 | head -n 1)$fileName
dst="example.com" #your dst. server
dstPath="u"
dstAbs="/var/www/example.com/"
user="user"

###########
#CONFIG END
###########



#MAIN
scrot $FILENAME #Make screenshot and save it as $FILENAME
scp -P1001 -i ~/.ssh/id_rsa -C $FILENAME $user@$dst:$dstAbs$dstPath #send screenshot through SCP(with compression enabled for low-bandwith connection) 
echo "https://"example.com"/"$dstPath"/"$FILENAME | xclip -i -selection clipboard #copy screenshot link to your clipboard
rm $FILENAME #delete screenshot locally
