(import 'cli/vmss/module.jsonnet')
{
    name: 'MyVirtualMachineScaleSet',
    imageReference: {
        publisher: 'Canonical',
        offer: 'UbuntuServer',
        sku: '16.04-LTS',
        version: 'latest'
    },
    adminUserName: 'johanste',
    capacity: 5,
    osType: 'Linux',
    sshPublicKeys: [ 'ssh: onekey', 'ssh: twokeys' ],
    subnet: '/yeah/i/know/what/im/doing',
}
