Disconnect-AzAccount | Out-Null; #Clear all sesions in Az to avoid unexpected behavior
Write-Output "                      __ _ _____   _ _ __ ___ 
                     / _`  |_  / | | | '__/ _ \
                    | (_| |/ /| |_| | | |  __/
                     \__,_/___|\__,_|_|  \___|"
Write-Output ""
Write-Output "------------------------------------------------------------------"
Write-Output "--------------Powershell script for azure management--------------"
Write-Output "------------------------------------------------------------------"
Write-Output "----------                                             -----------"
Write-Output "----------   PRESS ENTER TO START A SESSION IN AZURE   -----------"
Write-Output "----------                                             -----------"
Write-Output "------------------------------------------------------------------"
Write-Output "------------------------------------------------------------------"
pause
Write-Output " "
Write-Output " "
Write-Output "CONNECTING..."
Write-Output " "
Connect-AzAccount | Out-Null;
$ctx = Get-AzContext;
if ( $null -eq $ctx ){
    Write-Output " "
    Write-Output "The connection with Azure was not possible, check the problem and try running the script again..."
    Write-Output " "
    pause
    exit
}
else {
    Write-Output " "
    Write-Output "CONNECTION SUCCESSFUL!!!"
    Write-Output "------------------------------------------------------------------"
    Write-Output "----------                                             -----------"
    Write-Output "----------       RESOURCE GROUPS IN AZURE ACCOUNT      -----------"
    Write-Output "----------                                             -----------"
    Write-Output "------------------------------------------------------------------"
    Get-AzResourceGroup | Sort-Object ResourceGroupName | Format-Table ResourceGroupName,Location,ProvisioningState,Tags;
    Write-Output "------------------------------------------------------------------"
}
$rgchoose = Read-Host "Write the name of the desired resource group and press ENTER: "
#Write-Output "------------------------------------------------------------------"
$resources = Get-AzResource -ResourceGroupName $rgchoose | Format-Table;
if ( $null -eq $resources ){
    Write-Output " "
    Write-Output "There is a problem locating the resources in the specified resource group, check the name and try running the script again..."
    Write-Output " "
    pause
}
else {

}
$stay = 0
while ( $stay -eq 0 ) {
    Clear-Host
    Write-Output " "
    Write-Output "------------------------------------------------------------------"
    Write-Output "----------                                             -----------"
    Write-Output "----------  RESOURCES IN THE SPECIFIED RESOURCE GROUP  -----------"
    Write-Output "----------                                             -----------"
    Write-Output "------------------------------------------------------------------"
    Write-Output $resources
    Write-Output "------------------------------------------------------------------"
    Write-Output "------------------- Resource management options ------------------"
    Write-Output "------------------------------------------------------------------"
    Write-Output "-------- 1. Check the properties of a specified resource ---------"
    Write-Output "-------- 2. Add a tag to a resource ------------------------------"
    Write-Output "-------- 3. Check the properties by resource type ----------------"
    Write-Output "-------- 4. Exit -------------------------------------------------"
    Write-Output "------------------------------------------------------------------"
    $rmopt = Read-Host "Choose the desired option and press ENTER:"
        if ( 1 -eq $rmopt )
        {
        Write-Output "------------Checking the properties of a specified resource-----------"
        #Check prop
        $res = Read-Host "Write the resource name and press ENTER:"
        $resprop = Get-AzResource -ExpandProperties -Name $res;
        Write-Output "This are some configuration properties of the resource:"
        $resprop.properties | Format-Table
        pause
        }
        elseif ( 2 -eq $rmopt )
        {
        Write-Output "------------Adding a tag to a resource-----------"
        #tag to resource
        $resexist = Read-Host "Write the resource name that you want to tag and press ENTER:"
        $restest = Get-AzResource -Name $resexist;
        if ( $null -eq $restest ){
            Write-Output "The specified resource does not exist!, check the name and try again."
        }
        else{
            $tagname = Read-Host "Write the tag name and press ENTER:"
            $tagvalue = Read-Host "Now, write the tag value and press ENTER:"
            #New-AzTag -Name $tagname -Value $tagvalue
            $tag = @{Name="$tagname";Value="$tagvalue"}
            Set-AzResource -ResourceId $restest.Id -Tag $tag -Force
            Get-AzResource -Name $resexist | Format-List
        }
        pause
        }
        elseif ( 3 -eq $rmopt )
        {
        #prop by resource type
        Write-Output "------------------------------------------------------------------"
        Write-Output "------------ Checking the properties by resource type ------------"
        Write-Output "------------------------------------------------------------------"
        Write-Output "-------- 1. Check Microsoft.Web/serverFarms ----------------------"
        Write-Output "-------- 2. Check Microsoft.Web/sites ----------------------------"
        Write-Output "-------- 3. Check Microsoft.VSOnline -----------------------------"
        Write-Output "-------- 4. Back -------------------------------------------------"
        Write-Output "------------------------------------------------------------------"
        $rtopt = Read-Host "Choose the desired option and press ENTER:"
        if ( 1 -eq $rtopt ){
            "-------------------- Checking Microsoft.Web/serverFarms ----------------------"
            $buffer=Get-AzResource -ResourceType Microsoft.Web/serverFarms | Format-List
            if($null -eq $buffer){
                "ANY RESOURCE OF THIS TYPE WAS FOUND..."
            }
            Write-Output $buffer
        }
        elseif ( 2 -eq $rtopt ){
            "-------------------- Checking Microsoft.Web/sites ----------------------" 
            $buffer=Get-AzResource -ResourceType Microsoft.Web/sites | Format-List
            if($null -eq $buffer){
                "ANY RESOURCE OF THIS TYPE WAS FOUND..."
            }
            Write-Output $buffer
        }
        elseif ( 3 -eq $rtopt ){
            "-------------------- Checking Microsoft.VSOnline ----------------------"
            $buffer=Get-AzResource -ResourceType Microsoft.VSOnline | Format-List
            if($null -eq $buffer){
                "ANY RESOURCE OF THIS TYPE WAS FOUND..."
            }
            Write-Output $buffer
        }
        elseif ( 4 -eq $rtopt ){
            #nothing... go back
        }
        else {
            Write-Output "------------ OPTION NOT FOUND!, RETURNING TO MAIN MENU... -----------"
        }
        pause
        }
        elseif ( 4 -eq $rmopt )
        {
        Write-Output "------------  LOGGING OUT AZURE ACCOUNT  -----------"
        Disconnect-AzAccount
        $stay = 1 #byebye
        exit
        }
        else {
            Write-Output "------------ OPTION NOT FOUND!, TRY AGAIN -----------"
            Pause
        }
}