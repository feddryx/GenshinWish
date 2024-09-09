adbw() {
  echo "Attempting to connect to adb"
  
  # Check if adb is already connected to localhost
  if adb devices | grep -E '(:[0-9]{4,})\s+device'; then
    echo "Already connected to ADB on localhost."
    return 0
  else
    echo "Searching for the port..."
    
    # Find the open port using nmap
    local port=$(nmap -sT localhost -p30000-49999 | awk -F/ '/tcp open/{print $1; exit}')
    
    # If no open port is found, notify and return failure
    if [ -z "$port" ]; then
      echo "Failed to find an open port for adb connection."
      return 1
    fi
    
    # Connect adb using the found port
    adb connect localhost:$port
    
    # Check if the connection was successful
    if adb devices | grep -E 'localhost:[0-9]{4,}\s+device'; then
      return 0
    else
      echo "ERROR: Make sure the wireless debugging are still active."
      return 1
    fi
  fi
}

adbw
if [ $? -eq 0 ]; then
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
fi
