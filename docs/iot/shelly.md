# shelly iot devices

## connect to wifi

the old shelly devices can be connected to the wifi via AP. the process is
roughly the same for them

1. press some button for 5 sec to put the device into AP mode (10 sec usually do
   factory reset, so count the seconds)
2. connect to the shelly devices wifi AP (e.g. with phone)
3. open <http://192.168.33.1> to access the webui of the device
4. enter the credentials for the wifi network that you want the shelly device to
   join (use a static ip to avoid dhcp issues)

## add to shelly cloud account

- (if the device was not added to the account yet) to add to the shelly cloud
  app, you can type the assigned ip manually here:
  `"+" -> "Scan network" -> "Add by Ip"`.
- (otherwise) it should just appear in the app again, once the device is in the
  wifi and has "cloud" enabled

## openwrt setup

- shelly devices need 2.4GHz wifi and WPA2
- setup with the shelly cloud app requires network with working dhcp, dns and a
  very permissive router firewall, no device isolation (the approach is not
  worth the effort, just do it with the webui)

## device settings

- for the shelly cloud app to work, devices need their "cloud feature" enabled
- turn on "restrict login" where possible, otherwise anything in the local
  network can access the shelly devices' webui and api

## devices specifics

### shelly trv gen 1

- docs: <https://kb.shelly.cloud/knowledge-base/shelly-trv>
- AP mode: press reset button 5sec (underside, next to the usb-c port, requires
  a small metal pin to press, it might take a second for the display to show
  "AP")

### shelly plug s gen 1

- docs:<https://kb.shelly.cloud/knowledge-base/shelly-plug-s>
- AP mode: press on/off button 5sec (it will blink red once then you can stop
  pressing the button, during AP mode it won't blink blue if the blue LED was
  turned off in settings)

### shelly plus h&t

- docs: <https://kb.shelly.cloud/knowledge-base/shelly-plus-h-t>
- AP mode: press the reset button once, then the device will switch to setup
  mode (it will say "Set" on the screen), there it will say "AP" in the bottom
  right corner, or you need to press the reset button again for 5sec to turn on
  AP mode. when done, press the reset button again to leave setup mode.
- the device is unresponsive to changing settings outside of setup mode, so do
  all the settings at once
