# Spectro v0.0.2
> Batch create spectrograms from a folder containing .wav files

<img src="/screenshot.png" alt="Screenshot" width="300"/>

GUI interface allowing specification of SoX spectrogram options and batch generation of spectrograms for a specified audio folder.


## Installation

Windows:

Requires SoX to be installed and added to PATH variable in Windows. 
sox - SOund eXchange: http://sox.sourceforge.net/
Adding a program to PATH: https://www.howtogeek.com/118594/how-to-edit-your-system-path-for-easy-command-line-access/

## Usage example

```sh
PS C:\Windows\System32> & "C:\Path\To\Directory\spectro.ps1"
```

## Release History

* 0.0.2
    * ADDED: Additional user options
    * ADDED: Progress bar window
    * CHANGED: Fixed image width of 1600px
* 0.0.1
    * Work in progress

## Notes:

* Will create a directory called 'spectrograms' in the root audio folder you select using 'browse'
* Will generate spectrograms for *all* .wav files in the audio directory, in .png format to the spectrogram directory
* Previously generated spectrograms from the same audio files (with default filenames) will be overwritten
* Works on all .wav files
* Default image width is 1600px
* Process cannot be easily aborted once initiated, 'Generating spectrograms' and 'sox' processes must be closed in task manager
