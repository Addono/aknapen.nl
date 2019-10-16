+++
title = "The Mycroft Experiment"
description = "Experimenting with an open-source personal assistant"
tags = [
	"Raspberry Pi",
	"Home Automation",
	"Privacy",
	"Open Source",
]
date = "2019-10-15"
categories = [
    "Deployment",
    "Home Automation",
]
highlight = "true"

+++
## The Mycroft Experiment


### Is it broken?
Let's start by making a sample recording.
```bash
arecord -D plughw:1 -d 5 test.wav
```

And check if we managed to record something.
```bash
# Playback the file, make sure that you know that audio is working
aplay -Dhw:0,0 test.wav

# Another option is to check the file size, if it's the # same size over multiple runs, then you're out of luck.
ll test.wav
```

### The fix
It's generally smart to make sure that we are running the latest kernel version, so let's start trying to upgrade that.
```bash
sudo apt-get update && sudo apt-get upgrade

sudo reboot now
```

For me upgrading the kernel did not fix my issues with getting the PS3 Eye to work. However, with the following command I was able to record audio, as uses a different device.
```bash
arecord -c 1 -r 16000 -f S16_LE -D plughw:1,0 -d 5 test.wav
```

To update the default recording device, first all detected devices.
```bash
pactl list sources short
```

Then, find the index of the device you want to use and update the source:
```bash
# In my case the index was 1
pactl set-default-source 1
```

Now reboot again and try running the microphone test to see if Mycroft picked it up.
```bash
mycroft-mic-test
```
