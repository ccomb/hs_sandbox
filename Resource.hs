module Resource where


data ResourceType =
    ResourceType
    { typeName :: String }


data ResourceGroup =
    ResourceGroup
    { groupName :: String
    , groupGroups :: [ResourceGroup] }


data Resource =
    Resource
    { resourceName :: String
    , resourceType :: ResourceType 
    , resourceGroups :: [ResourceGroup]}
