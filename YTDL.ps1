# Gathers information
$link = Read-Host -Prompt 'i eat urls'
$artist = Read-Host -Prompt 'i eat artist names'
$song = Read-Host -Prompt 'i eat songs'
$Date = Get-Date

# Sets fixed variables
$codec = 'libmp3lame'
$ab = '128k'
$curDate = "" + $Date
$curDate = $curDate.replace("/","_")
$curDate = $curDate.replace(":","_")
$curDate = $curDate.replace(" ","_")
$outputPath = 'D:\PATH\Youtube-DL\PowershellComplete\' + $curDate

# Downloads from YouTube
Start-Process -FilePath 'D:\PATH\Youtube-DL\youtube-dl.exe' -ArgumentList ("$link -o $outputPath") -Wait

# Sets ffmpeg variables
$gottenFile = gci "D:\PATH\Youtube-DL\PowershellComplete\" | select -last 1
$fullab = $ab + " " + $outputPath + ".mp3"
$fullFileLocation = 'D:\PATH\Youtube-DL\PowershellComplete\' + $gottenFile


# Calls ffmpeg
Start-Process -FilePath 'D:\PATH\Youtube-DL\ffmpeg\bin\ffmpeg.exe' -ArgumentList ("-i $fullFileLocation -acodec $codec -ab $fullab") -Wait

# Sets variables to move file
$pathAfterFfmpeg = gci "D:\PATH\Youtube-DL\PowershellComplete\" | select -last 1
$fullPathAfterFfmpeg = 'D:\PATH\Youtube-DL\PowershellComplete\' + $pathAfterFfmpeg
$endingLocation = 'F:\Media\Music\' + $artist + '\YT\'

# Creates the media folder if it doesn't exist
If(!(test-path $endingLocation))
{
      New-Item -ItemType Directory -Force -Path $endingLocation
}

# Moves the item from the powershell folder to the music folder
Move-Item -Path $fullPathAfterFfmpeg -Destination $endingLocation

# Finds the file after it moves to the music folder
$pathAfterMove = gci $endingLocation | select -last 1
$fullPathAfterMove = 'F:\Media\Music\' + $artist + '\YT\' + $pathAfterMove

# Gives the file a new name
$newFileName = $artist + ' - ' + $song + '.mp3'
Rename-Item -Path $fullPathAfterMove -NewName $newFileName
