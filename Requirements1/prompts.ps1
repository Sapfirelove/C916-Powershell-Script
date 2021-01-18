# Martha Schiebel #000923205


clear 

Do {
  #Allows the user to input keys for desired response
  $input = ( Read-Host "Using your keyboard, input numbers 1-4 to achieve desired results, press 5 to terminate the session.");

  switch ($input) {
    1 {
      #Lits files with the .log file extension and reirect results to a new file called "DailyLog.txt.
      Get-Date | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append 
      Get-ChildItem $PSScriptRoot -Filter *.log | Out-File -FilePath $PSScriptRoot\DailyLog.txt -Append; break
    }
    2 {
      # List the files within the Reqirments folder in ascendng alphabetical order, then direct to a new file called C916contents.txt
      Get-ChildItem -path $PSScriptRoot | Sort-Object [-ascending] | Format-Table -Property Mode, LastWriteTime, Length, Name -AutoSize | 
      Out-File -FilePath $PSScriptRoot\C916contents.txt; break
    }
    3 { 
      #Lists current CPU and physical memory usage, which will collect 4 samples with each samole being 5 secound intervals.
      Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 5 -MaxSamples 4 
    }
    4 {
      #Lists different running processes inside the system sorted by processor time in secounds greatest to least.
      Get-Process | Sort-Object cpu -descending | Out-GridView
    }
    5 {     
      # Terminates the session once the user presses 5.
      "SESSION HAS BEEN TERMINATED"; break 
    }
  }
  #When the 5 key is pressed then switch exits
}until ($input -eq 5)


{
  # An exception handling using a try-catch for System.OutofMemoryException
  catch [System.OutOfMemoryException] {
    Write-Host "A system out of memory exception has occured. (╯°Д°)╯︵/(.□ . \)"
  }
  
}