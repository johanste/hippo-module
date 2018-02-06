local core = import 'core/module.libsonnet';

core.Module {

    resources: {
        loadBalancer: core.Resource {
            type: 'Microsoft.Network/loadBalancers',
            name: $.name,
        },
    },

    outputs: {
        backendAddressPool: 'default'
    },
}