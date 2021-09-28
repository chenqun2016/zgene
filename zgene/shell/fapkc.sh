flutter build apk --dart-define=APP_CHANNEL=$1
if [ ! -d "../build/" ];then
    mkdir ../build/
fi
if [ ! -d "../build/myrelease/" ];then
    mkdir ../build/myrelease/
fi
address=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
echo "$address"
address=${address/%shell/build}
address=$address"/myrelease/"
echo "$address"

cd ../build/app/outputs/apk/release || exit
cp -R *.apk "$address"

