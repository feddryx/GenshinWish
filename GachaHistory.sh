if adb devices | grep -q 'device'; then :
else
  echo "Connecting to adb..."
  local port=$(nmap -sT localhost -p30000-49999 | awk -F/ '/tcp open/{print $1; exit}')
  adb connect localhost:$port
fi

am start com.miHoYo.GenshinImpact/com.miHoYo.GetMobileInfo.MainActivity
adb logcat -e "https://gs.hoyoverse.com/" | while read -r line; do
  echo "$line"
  if [[ "$line" == *"MiHoYoWebview"* ]]; then
    echo "Detected 'MiHoYoWebview', stopping logcat..." &
    termux-toast "Detected 'MiHoYoWebview', stopping logcat..."
    pkill -f "adb logcat"
    break
  fi
done
am start --activity-clear-task com.termux/.app.TermuxActivity
