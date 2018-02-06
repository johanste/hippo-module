{
    name: error "'name' is a required property for resources!",
    type: error "'type' is a required property for resources",

    id():: 
        "[resourceId('%s', '%s')]" % [ $.type, $.name ],
}