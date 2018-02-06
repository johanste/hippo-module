local core = import 'core/module.libsonnet';

core.Module {
    virtualNetwork:: error "'virtualNetwork' is a required property",
    addressPrefix: '10.0.0.0/16',
    serviceEndpoints: [],

    resources: {
        subnet: core.Resource {
            type: 'Microsoft.Network/virtualNetworks/subnets',
            name: '%s/%s' % [ $.virtualNetwork, $.name ],
            properties: {
                addressPrefix: $.addressPrefix,
                serviceEndpoints: [
                    {
                        service: se
                    }
                    for se in $.serviceEndpoints
                ], 
            },
        },
    },

    outputs: {
        backendAddressPool: 'default'
    },
}