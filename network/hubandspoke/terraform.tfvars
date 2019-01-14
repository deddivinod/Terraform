
resourceGroupName = "RG_HubandSpoke"

location = "West Europe"

hubvnetname = "hubVnet"
    

hubaddressspace = ["10.10.0.0/16"]
     

azFireWallSubnetPreFix = "10.10.1.0/24"
 
 subnet1Name = "subnet1"

subnet1AddressPrefix = "10.10.2.0/24"

 subnet2Name = "subnet2"

 subnet2AddressPrefix = "10.10.3.0/24"

 hubtospok1VnetPeerName = "hubtospoke1peer"

hubtospok2VnetPeerName = "hubtospoke2peer"

    routeTableName = "routetable"

     routeName = "spoketohubroute"

    gateWaySubnetPrefix = "10.10.4.0/24"

    spoke1name = "spoke1vnet"

spoke1addressspace = ["10.20.0.0/16"]
    
    
    spoke1Subnet1Name = "spoke1subnet1"

    spoke1Subnet1AddressPrefix = "10.20.1.0/24"

    spoke1ToHubVnetPeerName = "spoke1toHubPeer"

    spoke2name = "spoke2vnet"
    
    spoke2addressspace = ["10.30.0.0/16"]
    
    spoke2Subnet1Name = "spoke2Subnet1"

    spoke2Subnet1AddressPrefix = "10.30.1.0/24"

  spoke2ToHubVnetPeerName  = "spoke2ToHubPeer"