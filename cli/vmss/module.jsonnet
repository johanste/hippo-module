//
// example of using existing modules to create a 
// composite module that creates multiple resources
// (some of which conditionally)
//

local hippo = import 'core/module.libsonnet';
local compute = import 'compute/module.libsonnet';
local network = import 'network/module.libsonnet';

hippo.Module {
    loadBalancer:: null,    
    instanceCount:: 2,
    imageReference: error "'imageReference' is a required parameter",
    subnet: null, # TODO: need to exposed subnet id  
    loadBalancerBackendAddressPool: $.resources.loadBalancer.outputs.backendAddressPool,
   
    resources +: {
        [if $.subnet == null then 'virtualNetwork']:
            network.VirtualNetwork {
                name: '%s-vnet' % [ $.name ], 
        },
        loadBalancer: network.LoadBalancer {
            name: '%s-loadbalancer' % [ $.name ],
        },
        virtualMachineScaleSet: compute.VirtualMachineScaleSet {
            name: $.name,
            adminUserName: $.adminUserName,
            imageReference: $.imageReference,
            osType: $.osType,
            subnet: if $.subnet != null then $.subnet else $.resources.virtualNetwork.outputs.subnet.name,
        }, 
    },
    outputs::: {
        virtualMachineScaleSet: $.resources.virtualMachineScaleSet.outputs.id(),
        loadBalancer: $.resources.loadBalancer,

    },
}


