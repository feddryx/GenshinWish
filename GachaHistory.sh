am start -n com.miHoYo.GenshinImpact/com.miHoYo.GetMobileInfo.MainActivity
echo ''
logcat -m 1 -e "OnGetWebViewPageFinish.+https.+gacha.+/log" | grep -oE "https.+/log"
echo ''
am start -n $(dumpsys activity activities | grep -oE "bin.mt.+/l[^}]+") > /dev/null