Clear-Host

Disconnect-AzAccount | Out-Null; #Clear all sesions in Az to avoid unexpected behavior
Write-Output "CONNECTING..."
Write-Output " "

Connect-AzAccount | Out-Null;
$ctx = Get-AzContext;
if ( $null -eq $ctx ) {
    Write-Output " "
    Write-Output "The connection with Azure was not possible, check the problem and try running the script again..."
    Write-Output " "
    pause
    exit
}
else {
    Write-Output " "
    Write-Output "CONNECTION SUCCESSFUL!!!"
    Write-Output "******************************************************************"
    Write-Output "**********                                             **********-"
    Write-Output "**********       RESOURCE GROUPS IN AZURE ACCOUNT      **********-"
    Write-Output "**********                                             **********-"
    Write-Output "******************************************************************"
    Get-AzResourceGroup | Sort-Object ResourceGroupName | Format-Table ResourceGroupName, Location, ProvisioningState, Tags;
    Write-Output "******************************************************************"
}
$rgchoose = Read-Host "Write the name of the desired resource group and press ENTER: "

$resources = Get-AzResource -ResourceGroupName $rgchoose | Format-Table;
if ( $null -eq $resources ) {
    Write-Output " "
    Write-Output "There is a problem locating the resources in the specified resource group, check the name and try running the script again..."
    Write-Output " "
    pause
}
else {

}
$stay = 0
while ( $stay -eq 0 ) {
    Write-Output " "
    Write-Output "*****************************************************************"
    Write-Output "**********                                             **********"
    Write-Output "**********  RESOURCES IN THE SPECIFIED RESOURCE GROUP  **********"
    Write-Output "**********                                             **********"
    Write-Output "*****************************************************************"
    Write-Output $resources
    Write-Output "MENU"
    Write-Output "****"
    Write-Output "1. Check the properties of a specified resource"
    Write-Output "2. Add a tag to a resource"
    Write-Output "3. Check the properties by resource type"
    Write-Output "4. Exit"
    Write-Output "****"
    $rmopt = Read-Host "Choose the desired option and press ENTER"
    switch ($rmopt) {
        1 {
            Write-Output "************ Checking the properties of a specified resource **********"
            #Check prop
            $res = Read-Host "Write the resource name and press ENTER"
            $resprop = Get-AzResource -ExpandProperties -Name $res;
            Write-Output "This are some configuration properties of the resource"
            $resprop.properties | Format-Table
            pause
        }
        2 {
            Write-Output "************ Adding a tag to a resource **********"
            #tag to resource
            $resexist = Read-Host "Write the resource name that you want to tag and press ENTER"
            $restest = Get-AzResource -Name $resexist;
            if ( $null -eq $restest ) {
                Write-Output "The specified resource does not exist!, check the name and try again."
            }
            else {
                $tagname = Read-Host "Write the tag name and press ENTER"
                $tagvalue = Read-Host "Now, write the tag value and press ENTER"
                #New-AzTag -Name $tagname -Value $tagvalue
                $tag = @{Name = "$tagname"; Value = "$tagvalue" }
                Set-AzResource -ResourceId $restest.Id -Tag $tag -Force
                Get-AzResource -Name $resexist | Format-List
            }
            pause
        }
        3 {
            #prop by resource type
            Write-Output "************************************************"
            Write-Output "*** Checking the properties by resource type ***"
            Write-Output "************************************************"
            Write-Output "*** 1. Check Microsoft.Web/serverFarms"
            Write-Output "*** 2. Check Microsoft.Web/sites"
            Write-Output "*** 3. Check Microsoft.VSOnline"
            Write-Output "*** 4. Back"

            $rtopt = Read-Host "Choose the desired option and press ENTER"
            switch ($rtopt) {
                1 {
                    "******************** Checking Microsoft.Web/serverFarms **********************"
                    $buffer = Get-AzResource -ResourceType Microsoft.Web/serverFarms | Format-List
                    if ($null -eq $buffer) {
                        "ANY RESOURCE OF THIS TYPE WAS FOUND..."
                    }
                    Write-Output $buffer
                }
                2 {
                    "******************** Checking Microsoft.Web/sites **********************" 
                    $buffer = Get-AzResource -ResourceType Microsoft.Web/sites | Format-List
                    if ($null -eq $buffer) {
                        "ANY RESOURCE OF THIS TYPE WAS FOUND..."
                    }
                    Write-Output $buffer
                }
                3 {
                    "******************** Checking Microsoft.VSOnline **********************"
                    $buffer = Get-AzResource -ResourceType Microsoft.VSOnline | Format-List
                    if ($null -eq $buffer) {
                        "ANY RESOURCE OF THIS TYPE WAS FOUND..."
                    }
                    Write-Output $buffer
                }
                4 {
                    # Do Nothing
                }
                Default {
                    Write-Output "************ OPTION NOT FOUND!, TRY AGAIN ************"
                    Pause
                }
            }
            pause
        }
        4 {
            Write-Output "************ LOGGING OUT AZURE ACCOUNT ************"
            Disconnect-AzAccount
            $stay = 1 #byebye
            exit
        }
        Default {
            Write-Output "************ OPTION NOT FOUND!, TRY AGAIN ************"
            Pause
        }
    }
}