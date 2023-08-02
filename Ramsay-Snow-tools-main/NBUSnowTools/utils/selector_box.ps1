function selector_box {

	param(
		[Parameter(Mandatory = $false,ValueFromPipeline = $true)]
		[string]$Myinput,
		[string]$mypath = "c:\temp\",
		[string]$fname = "*.txt"
	)

	Add-Type -AssemblyName System.Windows.Forms
	Add-Type -AssemblyName System.Drawing
	#$img = [System.Drawing.Image]::Fromfile('H:\Documents\Windowspowershell\frm696x606.png')
	$img = [System.Drawing.Image]::Fromfile('\\vwrhc02\data\Templates\OS\RHCWallpaper.bmp')
	$form = New-Object System.Windows.Forms.Form
	$form.AutoScaleMode = 0
	$form.AutoScroll = 0
	$form.AutoSizeMode = "GrowAndShrink"
	$form.AutoSize = 0
	$form.BackColor = "Aquamarine"
	$form.BackgroundImage = $img
	$form.Text = 'Robs ticket selector box..'
	$form.Width = $img.size.Width;
	$form.Height = $img.size.Height;
	#$form.Size = New-Object System.Drawing.Size(693,604)
	$form.StartPosition = 'CenterScreen'

	$Font = New-Object System.Drawing.Font ("Times New Roman",12,[System.Drawing.FontStyle]::Italic)

	# Font styles are: Regular, Bold, Italic, Underline, Strikeout

	$form.Font = $Font
	$Icon = New-Object system.drawing.icon ("\\vwrhc02\Data\Templates\OS\RAMLOGO.ICO")

	$Form.Icon = $Icon


	$OKButton = New-Object System.Windows.Forms.Button
	$OKButton.location = New-Object System.Drawing.Point (75,300)
	$OKButton.size = New-Object System.Drawing.Size (75,23)
	$OKButton.Text = 'RIP IT!'
	$OKButton.BackColor = 'Green'
	$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
	$form.AcceptButton = $OKButton
	$form.Controls.Add($OKButton)

	$CancelButton = New-Object System.Windows.Forms.Button
	$CancelButton.location = New-Object System.Drawing.Point (150,300)
	$CancelButton.size = New-Object System.Drawing.Size (75,23)
	$CancelButton.Text = 'SHIT NO!'
	$CancelButton.BackColor = 'Brown'
	#$CancelButton.BackgroundImage = $Icon
	$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
	$form.CancelButton = $CancelButton
	$form.Controls.Add($CancelButton)

	$label = New-Object System.Windows.Forms.Label
	$label.location = New-Object System.Drawing.Point (10,20)
	$label.size = New-Object System.Drawing.Size (280,20)
	$label.Text = 'Please choose wisely..'
	$form.Controls.Add($label)

	$listBox = New-Object System.Windows.Forms.ListBox
	$listBox.location = New-Object System.Drawing.Point (10,40)
	#$listBox.Height = 200
	$listbox.AutoSize = 1
	#$listBox.Size = New-Object System.Drawing.Size(500,200)
	$listbox.ForeColor = "Blue"


	if ($Myinput -eq "NUM") {
		$imagelist = $global:tickets.number
	} elseif ($Myinput -eq "Multi") {
		$imagelist = $global:tickets | Select-Object @{ N = 'Number'; E = { $_.number } },@{ N = 'Short Description'; E = { $_.short_description } },@{ N = 'CMDB'; E = { $_.cmdb_ci.display_value } }
	}

	foreach ($bid in $imagelist) {
		[void]$ListBox.Items.Add($bid)
	}


	$form.Controls.Add($listBox)
	$form.Topmost = $true
	$result = $form.ShowDialog()

	if ($result -eq [System.Windows.Forms.DialogResult]::OK)
	{
		$x = $listBox.SelectedItem
		$x
	}
} #  Graphical Selection Tool. Single Selections.
