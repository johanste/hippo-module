local hippo = import "core/module.libsonnet";

hippo.Module {

    addressPrefix: '10.0.0.0/16',
    serviceEndpoints: [],

    resources: {
        virtualNetwork: hippo.Resource {
            type: "Microsoft.Network/virtualNetworks",
            name: $.name,

            properties: {
                subnets: [
                    {
                        id::
                            '/subscriptions/[insert subscription here]/providers/Microsoft.Network/virtualNetworks/%s/subnets/%s' %
                                [ $.name, 'default' ], 
                        name: 'default',
                        properties: {
                            addressPrefix: $.addressPrefix,
                            serviceEndpoints: $.serviceEndpoints
                        },   
                    }
                ],
            },
        }
    },

    outputs: {
        virtualNetwork: $.resources.virtualNetwork,
        subnet: $.resources.virtualNetwork.properties.subnets[0].id,
    }
}