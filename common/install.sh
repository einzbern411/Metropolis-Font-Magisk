FONTDIR=$MODPATH/files
SYSFONT=$MODPATH/system/fonts
PRDFONT=$MODPATH/system/product/fonts
SYSETC=$MODPATH/system/etc
SYSXML=$SYSETC/fonts.xml
MODPROP=$MODPATH/module.prop

patch() {
	cp $ORIGDIR/system/etc/fonts.xml $SYSXML
	sed -i '/\"sans-serif\">/i \
	<family name="sans-serif">\
		<font weight="100" style="normal">Roboto-Thin.ttf</font>\
		<font weight="100" style="italic">Roboto-ThinItalic.ttf</font>\
		<font weight="300" style="normal">Roboto-Light.ttf</font>\
		<font weight="300" style="italic">Roboto-LightItalic.ttf</font>\
		<font weight="400" style="normal">Roboto-Regular.ttf</font>\
		<font weight="400" style="italic">Roboto-Italic.ttf</font>\
		<font weight="500" style="normal">Roboto-Medium.ttf</font>\
		<font weight="500" style="italic">Roboto-MediumItalic.ttf</font>\
		<font weight="900" style="normal">Roboto-Black.ttf</font>\
		<font weight="900" style="italic">Roboto-BlackItalic.ttf</font>\
		<font weight="700" style="normal">Roboto-Bold.ttf</font>\
		<font weight="700" style="italic">Roboto-BoldItalic.ttf</font>\
	</family>' $SYSXML
	sed -i ':a;N;$!ba; s/name=\"sans-serif\"//2' $SYSXML
}

headline() {
	cp $FONTDIR/Metropolis-Black.ttf $SYSFONT/Black.ttf;
	cp $FONTDIR/Metropolis-BlackItalic.ttf $SYSFONT/BlackItalic.ttf;
	cp $FONTDIR/Metropolis-Bold.ttf $SYSFONT/Bold.ttf;
	cp $FONTDIR/Metropolis-BoldItalic.ttf $SYSFONT/BoldItalic.ttf;
	cp $FONTDIR/Metropolis-Medium.ttf $SYSFONT/Medium.ttf;
	cp $FONTDIR/Metropolis-MediumItalic.ttf $SYSFONT/MediumItalic.ttf;
	sed -i '/\"sans-serif\">/,/family>/{s/Roboto-M/M/;s/Roboto-B/B/}' $SYSXML
	nsss
}

body() {
	cp $FONTDIR/Metropolis-Italic.ttf $SYSFONT/Italic.ttf;
	cp $FONTDIR/Metropolis-Light.ttf $SYSFONT/Light.ttf;
	cp $FONTDIR/Metropolis-LightItalic.ttf $SYSFONT/LightItalic.ttf;
	cp $FONTDIR/Metropolis-Regular.ttf $SYSFONT/Regular.ttf;
	cp $FONTDIR/Metropolis-Thin.ttf $SYSFONT/Thin.ttf
	cp $FONTDIR/Metropolis-ThinItalic.ttf $SYSFONT/ThinItalic.ttf;
	sed -i '/\"sans-serif\">/,/family>/{s/Roboto-T/T/;s/Roboto-L/L/;s/Roboto-R/R/;s/Roboto-I/I/}' $SYSXML
}

condensed() {
	cp $FONTDIR/Metropolis-Bold.ttf $SYSFONT/Condensed-Bold.ttf;
	cp $FONTDIR/Metropolis-BoldItalic.ttf $SYSFONT/Condensed-BoldItalic.ttf;
	cp $FONTDIR/Metropolis-Italic.ttf $SYSFONT/Condensed-Italic.ttf;
	cp $FONTDIR/Metropolis-Light.ttf $SYSFONT/Condensed-Light.ttf;
	cp $FONTDIR/Metropolis-LightItalic.ttf $SYSFONT/Condensed-LightItalic.ttf;
	cp $FONTDIR/Metropolis-Medium.ttf $SYSFONT/Condensed-Medium.ttf;
	cp $FONTDIR/Metropolis-MediumItalic.ttf $SYSFONT/Condensed-MediumItalic.ttf;
	cp $FONTDIR/Metropolis-Regular.ttf $SYSFONT/Condensed-Regular.ttf;
	sed -i 's/RobotoC/C/' $SYSXML
}

full() { headline; body; condensed; }

nsss() {
	if [ $API -ge 29 ] && i=$(grep NotoSerif $SYSXML) && i=$(grep SourceSansPro $SYSXML); then
		sed -i 's/NotoSerif-/NS-/' $SYSXML		
		cp $FONTDIR/Metropolis-BoldItalic.ttf $SYSFONT/NS-BoldItalic.ttf
		cp $FONTDIR/Metropolis-Bold.ttf $SYSFONT/NS-Bold.ttf		
		cp $FONTDIR/Metropolis-Italic.ttf $SYSFONT/NS-Italic.ttf
		cp $FONTDIR/Metropolis-Regular.ttf $SYSFONT/NS-Regular.ttf
		if [ $PART -eq 1 ]; then
			sed -i 's/SourceSansPro-SemiBold/SSP-Medium/;s/SourceSansPro-/SSP-/' $SYSXML			
			cp $FONTDIR/Metropolis-BoldItalic.ttf $SYSFONT/SSP-BoldItalic.ttf
			cp $FONTDIR/Metropolis-Bold.ttf $SYSFONT/SSP-Bold.ttf
			cp $FONTDIR/Metropolis-MediumItalic.ttf $SYSFONT/SSP-MediumItalic.ttf
			cp $FONTDIR/Metropolis-Medium.ttf $SYSFONT/SSP-Medium.ttf
			cp $FONTDIR/Metropolis-Italic.ttf $SYSFONT/SSP-Italic.ttf
			cp $FONTDIR/Metropolis-Regular.ttf $SYSFONT/SSP-Regular.ttf
		fi
	fi
}


bold() {
	sed -i '/\"sans-serif\">/,/family>/{/400/d;/>Light\./{N;h;d};/MediumItalic/G;/>Black\./{N;h;d};/BoldItalic/G}' $SYSXML
	sed -i '/\"sans-serif-condensed\">/,/family>/{/400/d;/-Light\./{N;h;d};/MediumItalic/G}' $SYSXML	
}

cleanup() {
	rm -rf $FONTDIR
	rmdir -p $SYSETC $PRDFONT
}

pixel() {
	if [ -f /product/fonts/GoogleSans-Regular.ttf ]; then
		DEST=$PRDFONT
	elif [ -f /system/fonts/GoogleSans-Regular.ttf ]; then
		DEST=$SYSFONT
	fi
	if [ ! -z $DEST ]; then
		cp $FONTDIR/Metropolis-Regular.ttf $DEST/GoogleSans-Regular.ttf
		cp $FONTDIR/Metropolis-Italic.ttf $DEST/GoogleSans-Italic.ttf
		cp $FONTDIR/Metropolis-Medium.ttf $DEST/GoogleSans-Medium.ttf
		cp $FONTDIR/Metropolis-MediumItalic.ttf $DEST/GoogleSans-MediumItalic.ttf
		cp $FONTDIR/Metropolis-Bold.ttf $DEST/GoogleSans-Bold.ttf
		cp $FONTDIR/Metropolis-BoldItalic.ttf $DEST/GoogleSans-BoldItalic.ttf
		if [ $BOLD ]; then
			cp $DEST/GoogleSans-Medium.ttf $DEST/GoogleSans-Regular.ttf
			cp $DEST/GoogleSans-MediumItalic.ttf $DEST/GoogleSans-Italic.ttf
		fi
		sed -ie 3's/$/+PXL&/' $MODPROP
		PXL=true
	fi
}

oxygen() {
	if [ -f /system/fonts/SlateForOnePlus-Regular.ttf ]; then
		cp $SYSFONT/Black.ttf $SYSFONT/SlateForOnePlus-Black.ttf
		cp $SYSFONT/Bold.ttf $SYSFONT/SlateForOnePlus-Bold.ttf
		cp $SYSFONT/Medium.ttf $SYSFONT/SlateForOnePlus-Medium.ttf
		cp $SYSFONT/Regular.ttf $SYSFONT/SlateForOnePlus-Regular.ttf
		cp $SYSFONT/Regular.ttf $SYSFONT/SlateForOnePlus-Book.ttf
		cp $SYSFONT/Light.ttf $SYSFONT/SlateForOnePlus-Light.ttf
		cp $SYSFONT/Thin.ttf $SYSFONT/SlateForOnePlus-Thin.ttf
		sed -ie 3's/$/+OOS&/' $MODPROP
		OOS=true
	fi
}

miui() {
	if i=$(grep miui $SYSXML); then
		sed -i '/\"miui\"/,/family>/{/700/,/>/s/MiLanProVF/Bold/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"miui-regular\"/,/family>/{/700/,/>/s/MiLanProVF/Medium/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"miui-bold\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro\"/,/family>/{/700/,/>/s/MiLanProVF/Bold/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"mipro-regular\"/,/family>/{/700/,/>/s/MiLanProVF/Medium/;/stylevalue=\"400\"/d}' $SYSXML
		sed -i '/\"mipro-medium\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-demibold\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-semibold\"/,/family>/{/400/,/>/s/MiLanProVF/Medium/;/700/,/>/s/MiLanProVF/Bold/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-bold\"/,/family>/{/400/,/>/s/MiLanProVF/Bold/;/700/,/>/s/MiLanProVF/Black/;/stylevalue/d}' $SYSXML
		sed -i '/\"mipro-heavy\"/,/family>/{/400/,/>/s/MiLanProVF/Black/;/stylevalue/d}' $SYSXML
		if [ $PART -eq 1 ]; then
			sed -i '/\"miui\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -i '/\"miui-thin\"/,/family>/{/400/,/>/s/MiLanProVF/Thin/;/700/,/>/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/\"miui-light\"/,/family>/{/400/,/>/s/MiLanProVF/Light/;/700/,/>/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/\"miui-regular\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -i '/\"mipro\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
			sed -i '/\"mipro-thin\"/,/family>/{/400/,/>/s/MiLanProVF/Thin/;/700/,/>/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-extralight\"/,/family>/{/400/,/>/s/MiLanProVF/Thin/;/700/,/>/s/MiLanProVF/Light/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-light\"/,/family>/{/400/,/>/s/MiLanProVF/Light/;/700/,/>/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-normal\"/,/family>/{/400/,/>/s/MiLanProVF/Light/;/700/,/>/s/MiLanProVF/Regular/;/stylevalue/d}' $SYSXML
			sed -i '/\"mipro-regular\"/,/family>/{/400/,/>/s/MiLanProVF/Regular/;/stylevalue=\"340\"/d}' $SYSXML
		fi	
		sed -ie 3's/$/+MIUI&/' $MODPROP
		MIUI=true
	fi
}

rom() {
	pixel
	if ! $PXL; then oxygen
		if ! $OOS; then miui
		fi
	fi
}

### SELECTIONS ###
PART=1
ui_print "   "
ui_print "- Which part of the system font do you want to install?"
ui_print "  Vol+ = Options; Vol- = Selection"
ui_print "   "
ui_print "  1. Full"
ui_print "  2. Headline"
ui_print "   "
ui_print "  Select:"
while true; do
	ui_print "  $PART"
	if $VKSEL; then
		PART=$((PART + 1))
	else 
		break
	fi
	if [ $PART -gt 2 ]; then
		PART=1
	fi
done
ui_print "   "
ui_print "  You choose: $PART"

BOLD=1	
ui_print "   "
ui_print "- Do you want to use BOLDER version over Regular version?"
ui_print "  Vol+ = Yes; Vol- = No"
ui_print "   "
if $VKSEL; then
	BOLD=true	
ui_print "  Selected: Yes"
else
ui_print "  Selected: No"	
fi

### INSTALLATION ###
ui_print "   "
ui_print "- Installing"
ui_print "  "
ui_print "  "

mkdir -p $SYSFONT $SYSETC $PRDFONT
patch

case $PART in
	1 ) full;;
	2 ) headline; sed -ie 3's/$/+HDLFNT&/' $MODPROP;;
esac

if $BOLD; then
	bold; sed -ie 3's/$/+BOLDER&/' $MODPROP
fi

PXL=false; OOS=false; MIUI=false
rom

### CLEAN UP ###
ui_print "- The installation is now completed."
ui_print "- Deleting temporary files and directories..."
cleanup


## CREDIT ##
ui_print "  "
ui_print "  "
ui_print "  "
ui_print " **************************************************************"
ui_print " **   Module Template based on Mr. Nông Thái Hoàng's work.   **"
ui_print " **************************************************************"
ui_print " **              MMT Extended by Zackptg5 @ XDA              **"
ui_print " **************************************************************"
ui_print " "                Metropolis fonts by einzbern
ui_print " "