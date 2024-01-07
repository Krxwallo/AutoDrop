# AutoDrop

This is a very **experimental** tweak I am using in my setup for "receiving" AirDrop files on non-Apple devices. 
It consists of a relatively old jailbroken iPhone (I am currently using an iPhone 6S) that is connected to a 
personal hotspot I opened up on my other phone (can be any WiFi).

## Setup for serving AirDrop files via web server

1. Jailbreak your iPhone (e.g. [Chimera](https://chimera.coolstar.org/), depending on your iOS version and phone model)
2. Install and setup SSH server: [Tutorial](https://cydia.saurik.com/openssh.html) (recommended)
3. Install AutoDrop using `dpkg -r [autodrop-deb]` (replace `[autodrop-deb]` with a `.deb` file from the releases)
4. Respring: `killall SpringBoard`
5. Install a web server like `nginx`
6. Download the [mover.sh script](https://raw.githubusercontent.com/Krxwallo/airbox-mover/master/mover.sh)
7. Edit the paths in the script so that it works for you (you may need to do some testing to see where AirDrop files end up)
8. Run the script in the **destination** path, so e.g. `/var/www/html` (you should probably run it in a screen).

When the above is working you should be able to connect to the web server from any device on the 
same network by connecting to the IP address of the jailbroken iPhone. When you enable AirDrop on 
your phone and receive an AirDrop request, it should automatically get accepted and you should be
able to access the files via web server.

### Notes:

- (Automatically) receiving AirDrop files works while the **display is turned on** and the iPhone is **unlocked**.
- This method relies on the fact that AirDrop files are already fully transmitted in the background, before the
  user even chooses where to actually "save"/send the files (e.g. to iCloud or to another app). This also means it
  currently only works for documents with more than one saving option (e.g. `.pdf` files) or documents that are automatically saved to
  the Files app (e.g. `.goodnotes` files).
- Currently, this tweak just accepts **every** dialogue with an action saying "Accept" or "Annehmen", which means that 
  the language on your iPhone must be **German or English**, and also non-airdrop dialogues containing actions with that
  text will be accepted (XD).
- The PDF attachments from [GoodNotes](https://www.goodnotes.com/) files are automatically extracted by
  [airbox-mover](https://github.com/Krxwallo/airbox-mover). For more information, see the [gax README](https://github.com/Krxwallo/gax).
