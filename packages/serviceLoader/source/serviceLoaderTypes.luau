--[=[
    @class serviceLoaderTypes
]=]

--[=[
    @type Service { [string]: unknown } & { ["ServiceName"]: string }
    @within serviceLoaderTypes
]=]
export type Service = { [string]: unknown } & { ["ServiceName"]: string }

return nil
