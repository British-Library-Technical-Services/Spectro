Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Get-AudioDir($audioDirectory="")

{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select Folder Containing Audio Files"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $audioDirectory

        if($foldername.ShowDialog() -eq "OK")
            {
            $folder += $foldername.SelectedPath
            }
    return $folder
}

<#Function Get-SoxDir($soxdir="")
{
   
        [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null
    
        $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
        $foldername.Description = "Select SoX Directory"
        #$foldername.rootfolder = ""
        $foldername.SelectedPath = "c:\program files (x86)\"
    
        if($foldername.ShowDialog() -eq "OK")
        {
            $folder += $foldername.SelectedPath
        }
        return $folder
}
#>
<# Function Get-MagickDir($magickdir="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null
    
    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select ImageMagick Directory"
    $foldername.rootfolder = ""
    $foldername.SelectedPath = "c:\program files (x86)\"

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }
    return $folder
}
#>

#Get directory containing audio files for processing

$audioDir = Get-AudioDir

# $magickdir = Get-MagickDir

#Create Dialog Box Object

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Spectrogram Options'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

#OK Button

$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(75,120)
$okButton.Size = New-Object System.Drawing.Size(75,23)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

#Cancel Button

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,120)
$cancelButton.Size = New-Object System.Drawing.Size(75,23)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

#Dialog Box Properties

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Select Spectrogram Options:'
$form.Controls.Add($label)

#Black and White Selection Box

$bwCheckBox = New-Object System.Windows.Forms.CheckBox
$bwCheckBox.Location = New-Object System.Drawing.Point(10,40)
$bwCheckBox.Size = New-Object System.Drawing.Size(260,20)
$bwCheckBox.Text = "Black and White"
$bwCheckBox.Checked = $false
$bwCheckBox.Tabindex = 0
$bwCheckBox.Control.Add($bwCheckBox)
$form.Controls.Add($bwCheckBox)

#Add Title Text to Image

$addText = New-Object System.Windows.Forms.CheckBox
$addText.Location = New-Object System.Drawing.Point(10,70)
$addText.Size = New-Object System.Drawing.Size(260,20)
$addText.Text = "Add filename to image"
$addText.Checked = $false
$addText.Tabindex = 0
$addText.Control.Add($addText)
$form.Controls.Add($addText)

#Display on top of othger windows

$form.Topmost = $true

#Show the Dialog Box

$result = $form.ShowDialog()

#Parse Results on 'OK'

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    $bw = ""
    $showText = ""
    if($bwCheckbox.Checked){
        $bw = "-m"
    }
    if($addText.Checked){
        $showtext = "-t $fileName"
    }
 
#Create a directory named 'Spectrograms' in the Audio Root directory

$outDir = New-Item -Force -Path "$audioDir" -Name "Spectrograms" -ItemType "Directory"

#Create spectrograms of wav files using input settings in $audiodir/spectrograms

    $audioFiles = Get-ChildItem -Path $audioDir -Filter "*.wav"
        ForEach ($audiofile in $audiofiles){
            $inFile = $audioFile.FullName
            $outFile = Join-Path -Path $outDir -ChildPath $audioFile.BaseName
            $fileName = Split-Path -Path $audiofile -Leaf
            & sox $infile -n spectrogram $bw $showText -o $outfile".png"
    }

}