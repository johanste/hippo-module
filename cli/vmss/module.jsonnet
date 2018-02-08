//
// example of using existing modules to create a 
// composite module that creates multiple resources
// (some of which conditionally) and extends some of the 
// resources (load balancer) based on the VMSS configuration
//

local hippo = import 'core/module.libsonnet';
local compute = import 'compute/module.libsonnet';
local network = import 'network/module.libsonnet';

local utils = {
    effectiveAuthenticationMode(explicitSetting, osType)::
        if explicitSetting == null then
            if osType == 'Linux' then 'ssh' else 'rdp'
        else
            explicitSetting,

};

hippo.Module {
    loadBalancer:: null,    
    instanceCount:: 2,
    imageReference: error "'imageReference' is a required parameter",
    osType: error "'osType' is a required parameters",
    subnet: null, # TODO: need to exposed subnet id  
    loadBalancerBackendAddressPool: $.resources.loadBalancer.outputs.backendAddressPool,
    disableOverprovision:: false,
    customData:: null,
    licenseType:: null,
    singlePlacementGroup:: $.instanceCount <= 100,
    upgradePolicy:: null,
    vmSku: null,
    zones: [],
    authenticationType: if $.osType == 'Linux' then 'ssh' else 'rdp',

    resources +: {
        // Unless we are given an explicit subnet id, we will create an
        // appropriate VNET for the scale set
        [if $.subnet == null then 'virtualNetwork']:
            network.VirtualNetwork {
                name: '%s-vnet' % [ $.name ], 
        },

        // We put a load balancer in front of the VMSS
        // TODO: support no LB or AppGW
        loadBalancer: network.LoadBalancer {
            local instance = self,

            name: '%s-loadbalancer' % [ $.name ],

            resources +: {
                loadBalancer +: {
                    properties +: {
                        // If authentication type is SSH, we make sure that
                        // we create an appropriate inbound NAT pool so the 
                        // instances are reachable from the outside...
                        // TODO: Support RDP or no auth type
                        [if $.authenticationType == 'ssh' then 'inboundNatPool']: {
                            inboundNatPools +: [
                                {
                                    name: '%sLBNatPool' % [ $.name ],
                                    properties: {
                                        frontendIpConfiguration: {
                                            id: instance.outputs.frontendIpId('-xxx')
                                        },
                                        protocol: "tcp",
                                        
                                    },
                                },
                            ],
                        },
                    },
                },
            },
        },
        virtualMachineScaleSet: compute.VirtualMachineScaleSet {
            name: $.name,
            adminUserName: $.adminUserName,
            imageReference: $.imageReference,
            osType: $.osType,
            overprovision: ! $.disableOverprovision,
            customData: $.customData,
            capacity: $.instanceCount,
            subnet: if $.subnet != null then $.subnet else $.resources.virtualNetwork.outputs.subnet,
            licenseType: $.licenseType,
            singlePlacementGroup: $.singlePlacementGroup,
            [if $.upgradePolicy != null then 'upgradePolicy']: $.upgradePolicy,
            [if $.vmSku != null then 'vmSku']: $.vmSku,
            [if $.zones != [] then 'zones']: $.zones,
        }, 
    },
    outputs::: {
        virtualMachineScaleSet: $.resources.virtualMachineScaleSet.outputs.id(),
        loadBalancer: $.resources.loadBalancer,

    },
}


