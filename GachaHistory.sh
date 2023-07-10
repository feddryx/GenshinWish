am start -n com.miHoYo.GenshinImpact/com.miHoYo.GetMobileInfo.MainActivity
echo ''
url=$(sudo logcat -m 1 -e "OnGetWebViewPageFinish.+https.+gacha.+/log" | grep -oE "https.+/log")
termux-clipboard-set "$url"
termux-toast URL copied!
echo "URL: $url"
