#!/bin/bash
# Replace with the UUID for the MDM profile that is deployed by your JSS
mdmuuid="00000000-0000-0000-A000-1A234B567890" 
mdm=$(/usr/bin/profiles -L | grep $mdmuuid)
jamf_binary=`/usr/bin/which jamf`

if [ "$mdm" ]; then
    echo "Removing existing MDM profile:"
    # This optional method below does not rely upon jamf binary
    # /usr/bin/profiles -R -p $mdmuuid -v
    $jamf_binary removeMdmProfile -verbose
    echo ""
fi

echo "Installing new MDM profile"
$jamf_binary mdm -verbose
status=$?

# You can replaced "Self Service" with another OS X app or service if you prefer
echo ""
if [ $status -ne 0 ]; then
    echo "There was an error installing the MDM profile: $status"
    /usr/bin/osascript -e 'Tell application "Self Service" to display dialog "There was an error obtaining a new MDM profile.\n\nPlease contact IT for assistance." with title "jamf error" with text buttons {"OK"} default button 1 with icon file "System:Library:CoreServices:CoreTypes.bundle:Contents:Resources:AlertCautionIcon.icns" giving up after 15'
    exit $status
fi

echo "Running Recon"
$jamf_binary recon
/usr/bin/osascript -e 'Tell application "Self Service" to display dialog "Profiles should now be pushed to your Mac.\n\nIf you do not see profiles populating after five minutes contact IT for assistance." with title "Success" with text buttons {"OK"} default button 1 with icon file "System:Library:PreferencePanes:Profiles.prefPane:Contents:Resources:Profiles.icns" giving up after 15'

exit 0