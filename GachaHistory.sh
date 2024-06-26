if adb devices | grep -E '(:[0-9]{4,})\s+device'; then :
else
  echo "Connecting to adb..."
  local port=$(nmap -sT localhost -p30000-49999 | awk -F/ '/tcp open/{print $1; exit}')
  adb connect localhost:$port
fi

am start com.miHoYo.GenshinImpact/com.miHoYo.GetMobileInfo.MainActivity
adb logcat -e "https://gs.hoyoverse.com/" | while read -r line; do
  if [[ "$line" == *"MiHoYoWebview"* ]]; then
    echo "Detected 'MiHoYoWebview', stopping logcat..." &
    termux-toast "Detected 'MiHoYoWebview', stopping logcat..."
    pkill -f "adb logcat"
    url=$(echo "$line" | grep -oP 'url:\K[^,]*')
    echo "URL founded: $url"
    termux-clipboard-set $url &
    termux-toast "URL copied!"
    break
  fi
done
