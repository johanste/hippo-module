[
    (import 'cli/vmss/module.jsonnet')
    {
        // Required parameters
        name: 'MyVirtualMachineScaleSet',
        imageReference: {
            publisher: 'Canonical',
            offer: 'UbuntuServer',
            sku: '16.04-LTS',
            version: 'latest'
        },
        adminUserName: 'johanste',
        osType: 'Linux',
         
        // Optional parameters
        instanceCount: 5, 
        sshPublicKeys: [ 'ssh: onekey', 'ssh: twokeys' ],
        subnet: '/yeah/i/know/what/im/doing',
        disableOverprovision: true,
        customData: 'helloWorld',
        licenseType: 'Windows_Server',
        upgradePolicy: 'Automatic',
        vmSku: 'Standard_DS1_V2',
        zones: [ '1', '3' ],
    }
]