{
    version:: "0.0.1",

    resources: {},
    outputs:: {},

    template():: {
        "$schema": "/bla/bla/bla",
        contentVersion: $.version,

        resources: [
            local resource = $.resources[resourcename];
            {
                name: resource.name,
            } + resource
            for resourcename in std.objectFields($.resources) if !std.objectHasAll($.resources[resourcename], 'template')
        ] + [
            local resource = $.resources[resourcename];
            resource.template() + { type: 'Microsoft.Resources/deployments' },
            for resourcename in std.objectFields($.resources) if std.objectHasAll($.resources[resourcename], 'template')            
        ],
    },
    justResources()::
        $.resources
}