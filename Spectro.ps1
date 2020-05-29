Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -assembly System.Windows.Forms

Function Get-AudioDir($dir=""){
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select Folder Containing Audio Files"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $dir

        if($foldername.ShowDialog() -eq "OK")
            {
            $folder += $foldername.SelectedPath
            }

    return $folder
}
function Create-Spectrograms(){
    #Checks for $null audio directory and throws error
  
    if($audioDir -eq $null){
        Go-Error
    }
    #Create a directory named 'Spectrograms' in the Audio Root directory
    
    $outDir = New-Item -Force -Path "$audioDir" -Name "Spectrograms" -ItemType "Directory"
    
## -- Create The Progress-Bar
$ObjForm = New-Object System.Windows.Forms.Form
$ObjForm.Text = "Generating Spectrograms ..."
$ObjForm.Height = 200
$ObjForm.Width = 500
#$ObjForm.BackColor = "White"

$ObjForm.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$ObjForm.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

## -- Create The Label
$ObjLabel = New-Object System.Windows.Forms.Label
$ObjLabel.Text = "Starting. Please wait ... "
$ObjLabel.Left = 5
$ObjLabel.Top = 10
$ObjLabel.Width = 500 - 20
$ObjLabel.Height = 20
#$ObjLabel.Font = "Tahoma"
## -- Add the label to the Form
$ObjForm.Controls.Add($ObjLabel)

$PB = New-Object System.Windows.Forms.ProgressBar
$PB.Name = "PowerShellProgressBar"
$PB.Value = 0
$PB.Style="Continuous"

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 500 - 40
$System_Drawing_Size.Height = 20
$PB.Size = $System_Drawing_Size
$PB.Left = 5
$PB.Top = 50
$ObjForm.Controls.Add($PB)

## -- Show the Progress-Bar and Start The PowerShell Script
$ObjForm.Show() | Out-Null
$ObjForm.Focus() | Out-NUll
$ObjLabel.Text = "Starting. Please wait ... "
$ObjForm.Refresh()

    #Create spectrograms of wav files using input settings in $audiodir/spectrograms
            $audioFiles = Get-ChildItem -Path $audioDir -Filter "*.wav"
            $i = 1
            ForEach ($audiofile in $audiofiles){
                $inFile = $audioFile.FullName
                $outFile = Join-Path -Path $outDir -ChildPath $audioFile.BaseName
                $fileName = Split-Path -Path $audiofile -Leaf
                    if($showtext -eq $true){
                    $printText = "-t $fileName"
                    }
                    else{
                    $printText = ""
                    }
                [int]$perComp = (100 / $audiofiles.count) * $i  
                $PB.Value = $perComp
		        $ObjLabel.Text = "Processing $fileName ($percomp% done)"
		        $ObjForm.Refresh()  
                $process = & sox $infile -n spectrogram $FFTwindow $zColor $zLimit $zQuant -x 1600 $bw $showHiColor $printFriend $printText -o $outfile".png"
                $process | Wait-Process
                $i++
                }
            $ObjForm.Close()
            Exit
}

function Go-Error(){
    $oReturn=[System.Windows.Forms.MessageBox]::Show("No Audio Directory Selected","Error",[System.Windows.Forms.MessageBoxButtons]::OK) 
switch ($oReturn){
    "OK" {
         Exit
        } 
    
}
    
}

#Create Dialog Box Object

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Spectrogram Options'
    $form.Size = New-Object System.Drawing.Size(450,400)
    $form.StartPosition = 'CenterScreen'

#Browse Button

    $browseButton = New-Object System.Windows.Forms.Button
    $browseButton.Location = New-Object System.Drawing.Point (10,330)
    $browseButton.Size = New-Object System.Drawing.Size (75,23)
    $browseButton.Text = 'Folder...'
    $browseButton.Add_Click({New-Variable -Name audioDir -Value $(Get-Audiodir) -Scope Script -Force})
    $form.Controls.Add($browseButton)
    
#OK Button

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,330)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)
      
#Cancel Button

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,330)
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
    #$bwCheckBox.Control.Add($bwCheckBox)
    $form.Controls.Add($bwCheckBox)

#Add Title Text to Image

    $addText = New-Object System.Windows.Forms.CheckBox
    $addText.Location = New-Object System.Drawing.Point(10,60)
    $addText.Size = New-Object System.Drawing.Size(260,20)
    $addText.Text = "Add filename to image"
    $addText.Checked = $false
    $addText.Tabindex = 0
    #$addText.Control.Add($addText)
    $form.Controls.Add($addText)

#high colour pallette option

    $hiColor = New-Object System.Windows.Forms.CheckBox
    $hiColor.Location = New-Object System.Drawing.Point(10,80)
    $hiColor.Size = New-Object System.Drawing.Size(260,20)
    $hiColor.Text = "High Colour Palette"
    $hiColor.Checked = $false
    $hiColor.Tabindex = 0
    #$hiColor.Control.Add($hiColor)
    $form.Controls.Add($hiColor)

#printer friendly option

    $printerFriendly = New-Object System.Windows.Forms.CheckBox
    $printerFriendly.Location = New-Object System.Drawing.Point(10,100)
    $printerFriendly.Size = New-Object System.Drawing.Size(260,20)
    $printerFriendly.Text = "Printer Friendly (Light Background)"
    $printerFriendly.Checked = $false
    $printerFriendly.Tabindex = 0
    #$printerFriendly.Control.Add($printerFriendly)
    $form.Controls.Add($printerFriendly)

#Choose window type Han, Hamming or Dolph
        $WindowTypeLabel = New-Object System.Windows.Forms.label
        $WindowTypeLabel.Location = New-Object System.Drawing.Point(10,130)
        $WindowTypeLabel.Size = New-Object System.Drawing.Size(130,15)
        #$WindowTypeLabel.BackColor = "Transparent"
        #$WindowTypeLabel.ForeColor = "black"
        $WindowTypeLabel.Text = "Select FFT Window"
        $form.Controls.Add($WindowTypeLabel)

    $windowType                     = New-Object system.Windows.Forms.ComboBox
    $windowType.text                = "FFT Window Type"
    $windowType.width               = 400
    $windowType.autosize            = $true

    # Add the items in the dropdown list
    @('Hamming (High Frequency Resolution, Low Dynamic Range)','Hann (Balanced)','Dolph (Low Frequency Resolution, High Dynamic Range)') | ForEach-Object {[void] $windowType.Items.Add($_)}

    # Select the default value
    $windowType.SelectedIndex       = 1
    $windowType.location            = New-Object System.Drawing.Point(10,150)
    #$windowType.Font                = 'Microsoft Sans Serif,10'
    #$windowType.Conrol.Add($windowType)
    $form.Controls.Add($windowType)

#set z axis colour range

        $colorRangeLabel = New-Object System.Windows.Forms.label
        $colorRangeLabel.Location = New-Object System.Drawing.Point(10,180)
        $colorRangeLabel.Size = New-Object System.Drawing.Size(350,15)
        #$colorRangeLabel.BackColor = "Transparent"
        #$colorRangeLabel.ForeColor = "black"
        $colorRangeLabel.Text = "Set Z axis colour range in dB (lower values increase contrast)"
        $form.Controls.Add($colorRangeLabel)

    $colorRange = New-Object System.Windows.Forms.NumericUpDown
    $colorRange.Location = New-Object System.Drawing.Point(10,200)
    $colorRange.Size = New-Object System.Drawing.Size(50,20)
    $colorRange.Maximum = 180
    $colorRange.Minimum = 20
    $colorRange.Value = 120
    $form.Controls.Add($colorRange)
   
#upper limit of z axis in dbfs
        $zLimitLabel = New-Object System.Windows.Forms.label
        $zLimitLabel.Location = New-Object System.Drawing.Point(10,230)
        $zLimitLabel.Size = New-Object System.Drawing.Size(400,20)
        #$zLimitLabel.BackColor = "Transparent"
        #$zLimitLabel.ForeColor = "black"
        $zLimitLabel.Text = "Set upper limit of Z axis in dBFS (negative numbers increase brightness)"
        $form.Controls.Add($zLimitLabel)

    $zLimitPicker = New-Object System.Windows.Forms.NumericUpDown
    $zLimitPicker.Location = New-Object System.Drawing.Point(10,250)
    $zLimitPicker.Size = New-Object System.Drawing.Size(50,20)
    $zLimitPicker.Maximum = 100
    $zLimitPicker.Minimum = -100
    $zLimitPicker.Value = 0
    $form.Controls.Add($zLimitPicker)

#z axis quantisation (number of colours)

        $zQuantLabel = New-Object System.Windows.Forms.label
        $zQuantLabel.Location = New-Object System.Drawing.Point(10,280)
        $zQuantLabel.Size = New-Object System.Drawing.Size(400,20)
        #$zQuantLabel.BackColor = "Transparent"
        #$zQuantLabel.ForeColor = "black"
        $zQuantLabel.Text = "Set Z axis quantisation (number of colours to render)"
        $form.Controls.Add($zQuantLabel)

    $zQuantPicker = New-Object System.Windows.Forms.NumericUpDown
    $zQuantPicker.Location = New-Object System.Drawing.Point(10,300)
    $zQuantPicker.Size = New-Object System.Drawing.Size(50,20)
    $zQuantPicker.Maximum = 249
    $zQuantPicker.Minimum = 4
    $zQuantPicker.Value = 249
    $form.Controls.Add($zQuantPicker)

#Display on top of othger windows

$form.Topmost = $true

#Show the Dialog Box

$result = $form.ShowDialog()

#Parse Results on 'OK'

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
       
    $bw = ""
    $showText = $false
    $showHiColor = ""
    $printFriend = ""
    $windowChoice = $windowType.SelectedIndex
    $zRange = $colorRange.Value
    $zLimitValue = $zLimitPicker.Value
    $zQuantValue = $zQuantPicker.Value

        if($bwCheckbox.Checked){
            $bw = "-m"
        }
        if($addText.Checked){
            $showText = $true
        }
        if($hiColor.Checked){
            $showHiColor = "-h"
        }
        if($printerFriendly.Checked){
            $printFriend = "-l"
        }
        if($windowChoice -eq 0) {
            $FFTwindow = "-wHamming"}
            elseif($windowChoice -eq 2) {
            $FFTwindow = "-wDolph"
            }
            else{
            $FFTwindow = "-wHann"
            }
        $zColor = "-z $zRange"
        $zLimit = "-Z $zLimitValue"
        $zQuant = "-q $zQuantValue"

           Create-Spectrograms
}


