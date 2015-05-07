# Reset MDM

## What were we trying to solve?

There have been cases where a Mac user would go to join one of the managed wireless networks and be prompted for a password, or use the VPN and receive an error message without prompt for authentication. In these cases, the values for the network password and/or the VPN shared secret were removed from the user's keychain (though the keychain entries were still there).

Previously in OS X 10.9 we had a workflow to remove the culprit configuration profile using System Preferences and run a recon (either via Terminal or a policy we have in Self Service) to trigger a re-push of the profile by the JSS.

As of OS X 10.10, profiles deployed by an MDM cannot be removed from a system without removing the MDM profile (which would then remove all profiles from the managed Mac).

## What does it do?

The 'Reset MDM' script removes the existing MDM profile on a client, then immediately re-installs a new MDM profile and runs a recon which will result in all configuration profiles being reinstalled on the client within a few minutes (if not immediately). As a part of this process, there are success and failure dialog prompts that will appear to inform the user of the policy's progress.

## How to deploy this script in a policy

Upload the script to your JSS and create a policy. Replace the 'mdmuuid' variable with the UUID of your JSS's MDM profile. You can find this UUID with the following command on a managed Mac:

```
~$ sudo profiles -Pv
profiles: verbose mode ON
_computerlevel[1] attribute: name: MDM Profile
_computerlevel[1] attribute: configurationDescription: MDM Profile for mobile device management
_computerlevel[1] attribute: installationDate: 2015-03-27 00:31:46 +0000
_computerlevel[1] attribute: organization: JAMF Software
_computerlevel[1] attribute: profileIdentifier: <<<UUID-IS-FOUND-HERE>>>
_computerlevel[1] attribute: profileUUID: <<<UUID-IS-FOUND-HERE>>>
```

It is important to note that the script in its current form does no checking to ensure the user is connected to the network over ethernet or on a wireless network that is not managed by configuration profiles. In JAMF Software's Self Service, we force users to read the policy description and note they should be connected to ethernet or the guest wireless network before running.

An icon you might use for this policy can be found in the /images directory.

![Screenshot](/images/ReloadProfiles.png)

## License

```
JAMF Software Standard License

Copyright (c) 2015, JAMF Software, LLC. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of
      conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.
    * Neither the name of the JAMF Software, LLC nor the names of its contributors may be
      used to endorse or promote products derived from this software without specific prior
      written permission.

THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```