#Create a resource group.
New-AzureRmResourceGroup -Name VNetRG1 -Location 'UK South'


#Set the subnets for each VNet
$Vnet1sn = New-AzureRmVirtualNetworkSubnetConfig -Name 'Subnet1-VNet1' -AddressPrefix '10.0.0.0/24'
$vnet2sn = New-AzureRmVirtualNetworkSubnetConfig -Name 'Subnet1-VNet2' -AddressPrefix '10.1.0.0/24'


#Create the two virtual networks with the subnets

New-AzureRmVirtualNetwork -ResourceGroupName VNetRG1 -Name 'MyVNet1' -AddressPrefix '10.0.0.0/16' -Location 'UK South' -Subnet $Vnet1sn
New-AzureRmVirtualNetwork -ResourceGroupName VNetRG1 -Name 'MyVNet2' -AddressPrefix '10.1.0.0/16' -Location 'UK South' -Subnet $Vnet2sn

#Peer MyVNet1 to MyVNet2

$vNet1=Get-AzureRmVirtualNetwork -Name MyVNet1 -ResourceGroupName VNetRG1

Add-AzureRmVirtualNetworkPeering `
  -Name 'MyVNet1-MyVNet2-Peering' `
  -VirtualNetwork $vNet1 `
  -RemoteVirtualNetworkId "/subscriptions/e9323b12-8e1e-4dde-9d38-fbdd05cd7eafD/resourceGroups/VNetRG1/providers/Microsoft.Network/virtualNetworks/MyVNet2"


#Peer MyVNet2 to MyVNet1

$vNet2=Get-AzureRmVirtualNetwork -Name MyVNet2 -ResourceGroupName VNetRG1

Add-AzureRmVirtualNetworkPeering -Name 'MyVNet1-MyVNet2-Peering' `
  -VirtualNetwork $vNet2 `
  -RemoteVirtualNetworkId "/subscriptions/ENTER YOUR SUBSCRIPTION ID/resourceGroups/VNetRG1/providers/Microsoft.Network/virtualNetworks/MyVNet1"


#View the peering state of myVnetA.

Get-AzureRmVirtualNetworkPeering -ResourceGroupName VNetRG1 -VirtualNetworkName myVnet1 | Format-Table VirtualNetworkName, PeeringState
Get-AzureRmVirtualNetworkPeering -ResourceGroupName VNetRG1 -VirtualNetworkName myVnet2 | Format-Table VirtualNetworkName, PeeringState

