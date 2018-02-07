local core = import 'core/module.libsonnet';

core.Module {

    parameters:: {},
    
    overprovision:: true,
    capacity:: 2,
    vmSku: 'Standard_D1_v2',
    upgradePolicy:: 'Manual',
    singlePlacementGroup:: true,
    storageAccountType:: null,
    imageReference:: error "'imageReference' is a required parameter",

    osType:: null,    
    adminUserName:: error "'adminUserName' is a required parameter",
    adminUserPassword:: null,

    subnet:: error "'subnet' is a required parameter",
    loadBalancerBackendAddressPool:: null,
    loadBalancerBackendInboundNatPool:: null,
    zones: [],
    customData:: null,
    licenseType:: null,
    sshPublicKeys: [],
    resources: {
        virtualMachineScaleSet: core.Resource {
            type: 'Microsoft.Compute/virtualMachineScaleSets',
            name: $.name,

            sku: {
                name: $.vmSku,
                capactiy: $.capacity,
            },
            [if $.zones != [] then 'zones']: $.zones,
            properties: {
                overprovision: $.overprovision,
                upgradePolicy: { mode: $.upgradePolicy },
                licenseType: $.licenseType,
                singlePlacementGroup: $.singlePlacementGroup,
                virtualMachineProfile: {
                    storageProfile: {
                        osDisk: {
                            createOption: "FromImage",
                            caching: "ReadWrite",
                            managedDisk: { storageAccountType: $.storageAccountType }
                        },
                        imageReference: $.imageReference
                    },
                    osProfile: {
                        computerNamePrefix: $.name,
                        adminUserName: $.adminUserName,
                        [if $.customData != null then 'customData']: std.base64($.customData),
                        [if $.osType == 'Linux' then 'linuxConfiguration']: {
                            disablePasswordAuthentication: $.adminUserPassword == null,
                            ssh: {
                                publicKeys: [
                                    {
                                        path: "/home/%s/.ssh/auhtorized_keys" % [ $.adminUserName ],
                                        keyData: key
                                    }
                                    for key in $.sshPublicKeys
                                ],
                            },
                        },
                        [if $.osType == 'Windows' then 'windowsConfiguration']: error "'windows configuration not yet supported",
                    },
                    networkProfile: {
                        networkInterfaceConfigurations: [
                            {
                                name: '%s-nic-default' % [ $.name ],
                                properties: {
                                    primary: true,
                                    ipConfigurations: [
                                        {
                                            name: '%s-default' % [ $.name ],
                                            properties: {
                                                subnet: {
                                                    id: $.subnet
                                                },
                                                [if $.loadBalancerBackendAddressPool != null then 'loadBalancerBackendAddressPool']: [
                                                    { id: $.loadBalancerBackendAddressPool },
                                                ],
                                                [if $.loadBalancerBackendInboundNatPool != null then 'loadBalancerBackendAddressPool']: [
                                                    { id: $.loadBalancerBackendInboundNatPool },
                                                ],
                                                
                                            },
                                        },
                                    ],
                                },
                            }
                        ],
                    },
                },
            },
        }
    },
    outputs: {
        id()::
            $.resources.virtualMachineScaleSet.id() 
    },
} 