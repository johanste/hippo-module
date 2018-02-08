local core = import 'core/module.libsonnet';

core.Module {
    
    backendAddressPools:: [ 'default' ],
    inboundNatPools:: [

    ],

    resources: {
        loadBalancer: core.Resource {
            type: 'Microsoft.Network/loadBalancers',
            name: $.name,

            properties: {
                backendAddressPools: [
                    { name: bep }
                    for bep in $.backendAddressPools
                ],
            },
        },
    },

    outputs: {
        frontendIpId(name)::
            $.resources.loadBalancer.name + name,

        backendAddressPool: $.resources.loadBalancer.properties.backendAddressPools[0].name,
    },
}