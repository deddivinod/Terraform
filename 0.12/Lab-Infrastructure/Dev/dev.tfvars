
location = "West Europe"
tags =   {
    customer    = "Lab"
    environment = "Dev"
    IaCMethod  = "terraform"
    deployedby = "AzDevops"
  }

vmtags  = {
    customer    = "Lab"
    environment = "Dev"
    IaCMethod  = "terraform"
    deployedby = "AzDevops"
    shutDown   = "19:00"
  }


networkresourcegroupname = "RG_DevNetworkWE"

loganalyticsresourcgroupname = "RG_DevLAWE"

hubvnetname = "devhubVnet"
    
hubaddressspace = ["10.10.0.0/16"]     

azFireWallSubnetPreFix = "10.10.1.0/24"
 
subnet1Name = "ADDSSubnet"

subnet1AddressPrefix = "10.10.2.0/24"

subnet2Name = "devsubnet2"

subnet2AddressPrefix = "10.10.3.0/24"

BastionSubnetName = "AzureBastionSubnet"

BastionSubnetAddressPrefix = "10.10.5.0/24"

hubtospok1VnetPeerName = "devhubtospoke1peer"

hubtospok2VnetPeerName = "devhubtospoke2peer"

routeTableName = "devroutetable"

routeName = "devspoketohubroute"

gateWaySubnetPrefix = "10.10.4.0/24"

spoke1name = "devspoke1vnet"

spoke1addressspace = ["10.20.0.0/16"]
        
spoke1Subnet1Name = "devspoke1subnet1"

spoke1Subnet1AddressPrefix = "10.20.1.0/24"

spoke1ToHubVnetPeerName = "devspoke1toHubPeer"

spoke2name = "devspoke2vnet"
    
spoke2addressspace = ["10.30.0.0/16"]
    
spoke2Subnet1Name = "devspoke2Subnet1"

spoke2Subnet1AddressPrefix = "10.30.1.0/24"

spoke2ToHubVnetPeerName  = "devspoke2ToHubPeer"

laname = "devpmpVSEnt"

autoaccountname = "devautoaccount"

keyvaultresourcegroupname = "RG_DevKeyVaultWE"

keyvaultname = "DevVSEntKeyVaultWE"

tenantid = ""

devlocaladminpwd = ""

vpngwname = "devvpngw"

vpngwpipname = "devvpngwPIP"

localnetname = "localnetGWHome"

localgwaddress = ""

localaddressspace = [""]

vpnpsk  = ""

recoveryvaultrgname = "RG_DevRecoveryVaultWE"

recoveryvaultname = "DevRecoveryVaultVSEntPMP"

ubuntuprefix = "Ubuntu-"

studyvmsresourcegroupname = "RG_LinuxStudyVMs"

ubuntucount = 2

datadiskstorageaccounttype = "Standard_LRS"

datadisksize = 20

avsetname = "AVlinuxStudyVMs"

vmsize = "Standard_B2s"

vmpublisher = "Canonical"

vmoffer = "UbuntuServer"

vmsku = "18.04-LTS"

osmanageddisktype = ["Standard_LRS", "StandardSSD_LRS", "PremiumSSD_LRS"]

linuxusername = "azadmin"

linuxpassword = "Password1234!!"

centosvmpublisher = "OpenLogic"

centosvmoffer = "Centos"

centosvmsku  = "7.6"

centoscount = 1

centosprefix = "Centos"

windowsvmsresourcegroup = "RG-WindowsVMs"

winprefix = "Win"

winvmpublisher = "MicrosoftWindowsServer"
    
winvmoffer = "WindowsServer"

winvmsku = "2016-DataCenter"

wincount = 1

windowsusername = "azadmin"

seccenterscope = ""

seccenteremailaddress = ""
