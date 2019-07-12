$VM_SWITCH_NAME="NATSwitch"
$VM_SWITCH_TYPE="Internal"

$NET_IP_ADDRESS="192.168.0.1"
$NET_PREFIX_LENGTH="24"
$NET_INTERFACE_ALIAS="vEthernet (NATSwitch)"

$NET_NAT_NAME="NATNetwork"
$NET_INTERNAL_IP_INTERFACE_ADDRESS_PREFIX="192.168.0.0/24"

$NET_NAT_STATIC_MAPPING_EXTERNAL_IP_ADDRESS="0.0.0.0/0"
$NET_NAT_STATIC_MAPPING_INTERNAL_IP_ADDRESS="192.168.0.93"


function main()
{
    echo "Removing/Adding Switch ($VM_SWITCH_NAME)..."
    Remove-VMSwitch -Force -name $VM_SWITCH_NAME -confirm:$false
    New-VMSwitch -SwitchName $VM_SWITCH_NAME -SwitchType $VM_SWITCH_TYPE

    echo "Resetting/Setting IP Range Rules ($NET_INTERFACE_ALIAS)..."
    Remove-NetIPAddress -InterfaceAlias $NET_INTERFACE_ALIAS -confirm:$false
    New-NetIPAddress -IPAddress $NET_IP_ADDRESS -PrefixLength $NET_PREFIX_LENGTH -InterfaceAlias $NET_INTERFACE_ALIAS

    echo "Removing/Adding NAT Network ($NET_NAT_NAME)..."
    Remove-NetNat -Name $NET_NAT_NAME -confirm:$false
    New-NetNAT -Name $NET_NAT_NAME -InternalIPInterfaceAddressPrefix $NET_INTERNAL_IP_INTERFACE_ADDRESS_PREFIX

    Setup_PortForwarding -Port 22
    Setup_PortForwarding -Port 25565
    Setup_PortForwarding -Port 19132
    Setup_PortForwarding -Port 19133
}

function Setup_NetNatStaticMapping()
{
    param($ExternalIPAddress, $ExternalPort, $Protocol, $InternalIPAddress, $InternalPort, $NatName)
    
    $NetNatStaticMappingList = Get-NetNatStaticMapping 

    foreach($NetNatStaticMapping in $NetNatStaticMappingList)
    {
        Remove-NetNatStaticMapping -StaticMappingID $NetNatStaticMapping.StaticMappingID -confirm:$false
    }

    Add-NetNatStaticMapping -ExternalIPAddress $ExternalIPAddress -ExternalPort $ExternalPort -Protocol $Protocol -InternalIPAddress $InternalIPAddress -InternalPort $InternalPort -NatName $NatName
}

function Setup_PortForwarding()
{
    param($Port)

    echo "Removing/Adding Port Forwarding ($Port)..."
    Setup_NetNatStaticMapping -ExternalIPAddress $NET_NAT_STATIC_MAPPING_EXTERNAL_IP_ADDRESS -ExternalPort $Port -Protocol TCP -InternalIPAddress $NET_NAT_STATIC_MAPPING_INTERNAL_IP_ADDRESS -InternalPort $Port -NatName $NET_NAT_NAME
}

main
