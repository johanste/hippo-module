local hippo = import "core/module.libsonnet";

hippo.Module {

    resources: {
        virtualNetwork: hippo.Resource {
            type: "Microsoft.Network/virtualNetworks",
            name: $.name,

            properties: {
                subnets: [
                    {
                        name: 'default'   
                    }
                ],
            },
        }
    },

    outputs: {


        virtualNetwork: $.resources.virtualNetwork,
        subnet: $.resources.virtualNetwork.properties.subnets[0],
    }
}