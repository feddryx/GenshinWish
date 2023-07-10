am start -n com.miHoYo.GenshinImpact/com.miHoYo.GetMobileInfo.MainActivity
echo ''
termux-clipboard-set $(logcat -m 1 -e "OnGetWebViewPageFinish.+https.+gacha.+/log" | grep -oE "https.+/log")
