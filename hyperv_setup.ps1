New-VMSwitch -SwitchName “NATSwitch” -SwitchType Internal
New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceAlias “vEthernet (NATSwitch)”
New-NetNAT -Name “NATNetwork” -InternalIPInterfaceAddressPrefix 192.168.0.0/24
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/0" -ExternalPort 22 -Protocol TCP -InternalIPAddress "192.168.0.93" -InternalPort 22 -NatName NATNetwork
Add-NetNatStaticMapping -ExternalIPAddress "0.0.0.0/0" -ExternalPort 25565 -Protocol TCP -InternalIPAddress "192.168.0.93" -InternalPort 25565 -NatName NATNetwork
