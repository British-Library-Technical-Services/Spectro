# Spectro v0.2

Batch Spectrogram script using Sox

Requires SoX to be installed and added to PATH variable in Windows.

Notes:

* Will create a directory called 'spectrograms' in the root audio folder you select using 'browse'
* Will generate spectrograms for *all* .wav files in the audio directory, in .png format to the spectrogram directory
* Previously generated spectrograms from the same audio files (with default filenames) will be overwritten
* Works on all .wav files
* Default image width is 1600px
* Process cannot be easily aborted once initiated, 'Generating spectrograms' and 'sox' processes must be closed in task manager
