//
// example of using existing modules to create a 
// composite module that creates multiple resources
// (some of which conditionally) and modifying resources
// from the 'base' resource module
//


local hippo = import 'core/module.libsonnet';
local compute = import 'compute/module.libsonnet';
local network = import 'network/module.libsonnet';

hippo.Module {
    name:: error "'name' is a required property",
    locations:: error "'locations' is a required property",
    imageReference:: error "'imageReference' is a required property",
    adminUserName:: error "'adminUserName' is a required property",

    resources: { 
        local vnet = network.VirtualNetwork {
            name: '%s-vnet' % [ $.name ],
        },

        virtualNetwork: vnet,

        backendSubnet: network.Subnet {
            name: 'backend',
            virtualNetwork: vnet.name,
            addressPrefix: '10.0.1.0/24,'
        },
        frontend: compute.VirtualMachineScaleSet {
            name: '%s-frontend' % [ $.name ],
            imageReference:: $.imageReference,
            subnet: vnet.outputs.subnet,
            adminUserName: $.adminUserName,
        },
        backend: compute.VirtualMachineScaleSet {
            name: '%s-backend' % [ $.name ],
            imageReference:: $.imageReference,
            subnet: vnet.outputs.subnet,
            adminUserName: $.adminUserName,
        },
    },
} {
    name: 'test',
    adminUserName: 'johanste',
    imageReference: {},
}
