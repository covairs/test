# Load required assemblies for WinForms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define the function to create the SMB share
function Create-SMBShare {
    param (
        [string]$ShareName,
        [string]$Path,
        [string]$DriveLetter
    )
    
    # Create a new PS drive for the chosen drive letter
    New-PSDrive -Name $DriveLetter -PSProvider FileSystem -Root $Path -Persist
    
    # Create the SMB share
    $share = Get-WmiObject -Class Win32_Share -Filter "Name='$ShareName'" -ErrorAction SilentlyContinue
    if ($share) {
        Write-Warning "The share '$ShareName' already exists."
    } else {
        $share = [WMIClass]"Win32_Share"
        $result = $share.Create($Path,$ShareName,0,0,"")
        if ($result.ReturnValue -ne 0) {
            Write-Error "Failed to create share '$ShareName': $($result.ErrorMessage)"
        } else {
            Write-Host "Successfully created share '$ShareName'."
        }
    }
}

# Create the GUI form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Create SMB Share"
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = "CenterScreen"

# Create the share name label
$shareNameLabel = New-Object System.Windows.Forms.Label
$shareNameLabel.Location = New-Object System.Drawing.Point(10,20)
$shareNameLabel.Size = New-Object System.Drawing.Size(80,20)
$shareNameLabel.Text = "Share Name:"
$form.Controls.Add($shareNameLabel)

# Create the share name textbox
$shareNameTextbox = New-Object System.Windows.Forms.TextBox
$shareNameTextbox.Location = New-Object System.Drawing.Point(100,20)
$shareNameTextbox.Size = New-Object System.Drawing.Size(180,20)
$form.Controls.Add($shareNameTextbox)

# Create the path label
$pathLabel = New-Object System.Windows.Forms.Label
$pathLabel.Location = New-Object System.Drawing.Point(10,50)
$pathLabel.Size = New-Object System.Drawing.Size(80,20)
$pathLabel.Text = "Path:"
$form.Controls.Add($pathLabel)

# Create the path textbox
$pathTextbox = New-Object System.Windows.Forms.TextBox
$pathTextbox.Location = New-Object System.Drawing.Point(100,50)
$pathTextbox.Size = New-Object System.Drawing.Size(180,20)
$form.Controls.Add($pathTextbox)

# Create the drive label
$driveLabel = New-Object System.Windows.Forms.Label
$driveLabel.Location = New-Object System.Drawing.Point(10,80)
$driveLabel.Size = New-Object System.Drawing.Size(80,20)
$driveLabel.Text = "Drive:"
$form.Controls.Add($driveLabel)

# Create the drive dropdown
$driveDropdown = New-Object System.Windows.Forms.ComboBox
$driveDropdown.Location = New-Object System.Drawing.Point(100,80)
$driveDropdown.Size = New-Object System.Drawing.Size(80,20)
$driveDropdown.Items.AddRange("D:","E:","F:","G:","H:","I:")
$driveDropdown.SelectedIndex = 0
$form.Controls.Add($driveDropdown)

# Create the create button
$createButton = New-Object System.Windows.Forms.Button
$createButton.Location = New-Object System.Drawing.Point(10,120)
$createButton.Size = New-Object System
